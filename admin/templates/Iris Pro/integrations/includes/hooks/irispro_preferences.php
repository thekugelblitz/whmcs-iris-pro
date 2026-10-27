<?php

if (!defined('WHMCS')) {
    exit('This file cannot be accessed directly');
}

add_hook('AdminAreaPage', 1, function ($vars) {
    // Hooks live at the WHMCS root; theme assets belong to the admin folder.
    $adminRoot = realpath(dirname($_SERVER['SCRIPT_FILENAME'] ?? ''));
    if (!$adminRoot) {
        $adminRoot = dirname(__DIR__, 2);
    }
    $themeFolder = 'Iris Pro';
    $imagesFolder = $adminRoot . DIRECTORY_SEPARATOR . 'templates' . DIRECTORY_SEPARATOR . $themeFolder . DIRECTORY_SEPARATOR . 'images';
    $lightLogo = $imagesFolder . DIRECTORY_SEPARATOR . 'logo-light.png';
    $darkLogo = $imagesFolder . DIRECTORY_SEPARATOR . 'logo-dark.png';

    return [
        'irisProCookieDark' => isset($_COOKIE['irispro_appearance_v2']) && $_COOKIE['irispro_appearance_v2'] === 'dark',
        'irisProLogoLightUrl' => is_file($lightLogo) && !is_link($lightLogo) ? 'templates/' . rawurlencode($themeFolder) . '/images/logo-light.png?v=' . (int) filemtime($lightLogo) : 'templates/' . rawurlencode($themeFolder) . '/images/logo.svg',
        'irisProLogoDarkUrl' => is_file($darkLogo) && !is_link($darkLogo) ? 'templates/' . rawurlencode($themeFolder) . '/images/logo-dark.png?v=' . (int) filemtime($darkLogo) : 'templates/' . rawurlencode($themeFolder) . '/images/logo-dark.svg',
    ];
});
