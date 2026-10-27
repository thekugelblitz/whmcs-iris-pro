<?php

use WHMCS\User\Admin;

if (!defined('WHMCS')) {
    exit('This file cannot be accessed directly');
}

function irispro_config()
{
    return [
        'name' => 'Iris Pro Preferences',
        'description' => 'Manages Iris Pro logo uploads.',
        'version' => '1.0.0',
        'author' => 'Dhruv J — HostingSpell.com',
        'fields' => [],
    ];
}

function irispro_activate()
{
    return ['status' => 'success', 'description' => 'Iris Pro logo settings are ready.'];
}

function irispro_deactivate()
{
    return ['status' => 'success', 'description' => 'Iris Pro logo settings are disabled.'];
}

function irispro_output($vars)
{
    $message = '';
    if (($_SERVER['REQUEST_METHOD'] ?? '') === 'POST' && ($_POST['irispro_action'] ?? '') === 'upload_logo') {
        $message = irispro_upload_logo();
    }

    $token = function_exists('generate_token') ? generate_token('plain') : '';
    echo '<div class="wrap"><h2>Iris Pro Preferences</h2>';
    if ($message !== '') {
        echo '<div class="alert ' . (strpos($message, 'successfully') !== false ? 'alert-success' : 'alert-danger') . '">' . htmlspecialchars($message, ENT_QUOTES, 'UTF-8') . '</div>';
    }
    echo '<p>Each administrator can choose Light or Dark mode from the navigation rail. This page manages the shared theme logos.</p>';
    echo '<div class="panel panel-default"><div class="panel-heading"><strong>Theme logos</strong></div><div class="panel-body">';
    echo '<p>Upload transparent PNG logos for light and dark mode. The built-in WHMCS wordmark is 211 × 48 pixels and renders at 24 pixels tall in desktop and mobile navigation; use a 2× PNG at 422 × 96 pixels for crisp high-density screens. Maximum upload size: 2 MB.</p>';
    foreach (['light' => 'Light mode logo (logo-light.png)', 'dark' => 'Dark mode logo (logo-dark.png)'] as $variant => $label) {
        echo '<form method="post" enctype="multipart/form-data" action="' . htmlspecialchars($vars['modulelink'], ENT_QUOTES, 'UTF-8') . '" style="margin:0 0 20px">';
        echo '<input type="hidden" name="token" value="' . htmlspecialchars($token, ENT_QUOTES, 'UTF-8') . '">';
        echo '<input type="hidden" name="irispro_action" value="upload_logo"><input type="hidden" name="variant" value="' . $variant . '">';
        echo '<label for="irispro-logo-' . $variant . '">' . htmlspecialchars($label, ENT_QUOTES, 'UTF-8') . '</label> ';
        echo '<input id="irispro-logo-' . $variant . '" type="file" name="logo" accept=".png,image/png" required> ';
        echo '<button type="submit" class="btn btn-primary">Upload PNG</button></form>';
    }
    echo '<p class="text-muted">Current files are replaced only after a successful validation. The built-in Iris logos are used when no custom file is present.</p>';
    echo '</div></div></div>';
}

function irispro_upload_logo()
{
    $admin = Admin::getAuthenticatedUser();
    if (!$admin || !$admin->hasPermission('Configure General Settings')) {
        return 'You need Configure General Settings permission to upload theme logos.';
    }
    if (!function_exists('check_token') || check_token('WHMCS.admin.default') === false) {
        return 'The security token is invalid. Refresh the page and try again.';
    }
    $variant = $_POST['variant'] ?? '';
    if (!in_array($variant, ['light', 'dark'], true)) {
        return 'Invalid logo variant.';
    }
    if (!isset($_FILES['logo']) || !is_array($_FILES['logo'])) {
        return 'Select a PNG file to upload.';
    }
    $upload = $_FILES['logo'];
    if (!isset($upload['name'], $upload['tmp_name']) || !is_string($upload['name']) || !is_string($upload['tmp_name']) ||
        strtolower(pathinfo($upload['name'], PATHINFO_EXTENSION)) !== 'png') {
        return 'Only files with a PNG filename extension are accepted.';
    }
    if (($upload['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK || !is_uploaded_file($upload['tmp_name'])) {
        return 'The upload did not complete. Select a PNG file smaller than 2 MB and try again.';
    }
    $actualSize = filesize($upload['tmp_name']);
    if ($actualSize === false || $actualSize < 1 || $actualSize > 2 * 1024 * 1024) {
        return 'PNG files must be no larger than 2 MB.';
    }
    if (!class_exists('finfo') || !function_exists('imagecreatefrompng') || !function_exists('imagepng')) {
        return 'Secure PNG processing requires PHP Fileinfo and GD extensions.';
    }
    $finfo = new finfo(FILEINFO_MIME_TYPE);
    if ($finfo->file($upload['tmp_name']) !== 'image/png') {
        return 'Only valid PNG image files are accepted.';
    }
    $imageInfo = @getimagesize($upload['tmp_name']);
    $ratio = $imageInfo && $imageInfo[1] > 0 ? $imageInfo[0] / $imageInfo[1] : 0;
    if (!$imageInfo || $imageInfo[2] !== IMAGETYPE_PNG || $imageInfo[0] < 1 || $imageInfo[1] < 1 || $imageInfo[0] > 422 || $imageInfo[1] > 96 || $ratio < 3.0 || $ratio > 6.0) {
        return 'Use a valid horizontal PNG up to 422 × 96 pixels with a 3:1 to 6:1 aspect ratio, matching the navigation wordmark.';
    }

    // Add-on modules live in the WHMCS root; upload the logo into the admin
    // directory that is currently running addonmodules.php.
    $adminRoot = realpath(dirname($_SERVER['SCRIPT_FILENAME'] ?? ''));
    if (!$adminRoot) {
        return 'The WHMCS admin directory could not be resolved.';
    }
    $templatesDirPath = $adminRoot . DIRECTORY_SEPARATOR . 'templates';
    $themeDirPath = $templatesDirPath . DIRECTORY_SEPARATOR . 'Iris Pro';
    $imagesPath = $themeDirPath . DIRECTORY_SEPARATOR . 'images';
    $imagesDir = realpath($imagesPath);
    if (is_link($templatesDirPath) || is_link($themeDirPath) || is_link($imagesPath) || !$imagesDir || $imagesDir !== $imagesPath || !is_dir($imagesDir) || !is_writable($imagesDir)) {
        return 'The Iris Pro images directory is unavailable or not writable by PHP.';
    }

    $target = $imagesDir . DIRECTORY_SEPARATOR . 'logo-' . $variant . '.png';
    if (is_link($target)) {
        return 'The destination logo path is not a regular file.';
    }
    $image = @imagecreatefrompng($upload['tmp_name']);
    if (!$image) {
        return 'The uploaded PNG could not be decoded.';
    }
    imagealphablending($image, false);
    imagesavealpha($image, true);
    $temporary = tempnam($imagesDir, '.irispro-logo-');
    if ($temporary === false || realpath(dirname($temporary)) !== $imagesDir) {
        imagedestroy($image);
        if ($temporary !== false) {
            @unlink($temporary);
        }
        return 'A secure temporary image could not be created.';
    }
    $written = @imagepng($image, $temporary, 6);
    imagedestroy($image);
    if (!$written || !is_file($temporary) || filesize($temporary) > 2 * 1024 * 1024) {
        @unlink($temporary);
        return 'The processed PNG exceeded the 2 MB limit or could not be written.';
    }
    if (!@rename($temporary, $target)) {
        @unlink($temporary);
        return 'The processed PNG could not be installed. Check folder permissions.';
    }
    @chmod($target, 0644);
    return 'The ' . $variant . ' mode logo was uploaded successfully.';
}
