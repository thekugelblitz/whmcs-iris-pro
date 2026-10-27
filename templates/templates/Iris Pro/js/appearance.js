/* Iris Pro appearance. Deliberately independent of jQuery and WHMCS bundles. */
(function () {
    'use strict';
    var key = 'whmcs.iris-pro.appearance';
    var modes = ['light', 'dark'];
    var names = { light: 'Light', dark: 'Dark' };
    var icons = {
        light: '<path d="M20.5 13A8.5 8.5 0 0 1 11 3.5 8.5 8.5 0 1 0 20.5 13Z"/>',
        dark: '<circle cx="12" cy="12" r="4"/><path d="M12 2v2m0 16v2M2 12h2m16 0h2M5 5l1.5 1.5m11 11L19 19M5 19l1.5-1.5m11-11L19 5"/>'
    };
    var preference = null;
    var system = window.matchMedia ? window.matchMedia('(prefers-color-scheme: dark)') : null;
    function valid(value) { return modes.indexOf(value) !== -1; }
    function read() {
        try { var value = window.localStorage.getItem(key); return valid(value) ? value : null; }
        catch (error) { return null; }
    }
    function current() { return preference || (system && system.matches ? 'dark' : 'light'); }
    var editorSelector = '.mce-edit-area iframe, .tox-edit-area iframe';
    function themeEditor(frame) {
        // Only editing canvases, never customer email previews or external frames.
        if (!frame.matches(editorSelector)) { return; }
        try {
            var doc = frame.contentDocument;
            if (!doc || !doc.head) { return; }
            var style = doc.getElementById('irisEditorAppearance');
            if (current() === 'light') { if (style) { style.remove(); } return; }
            if (!style) {
                style = doc.createElement('style');
                style.id = 'irisEditorAppearance';
                doc.head.appendChild(style);
            }
            var colors = window.getComputedStyle(document.documentElement);
            style.textContent = '@media screen{html{color-scheme:dark}body{background-color:' + colors.getPropertyValue('--input-bg') +
                '!important;color:' + colors.getPropertyValue('--input-text') + '!important;caret-color:' +
                colors.getPropertyValue('--input-text') + '}a{color:' + colors.getPropertyValue('--link') + '}}';
        } catch (error) { /* Cross-origin editor frames cannot be styled. */ }
    }
    function apply() {
        var mode = current();
        document.documentElement.setAttribute('data-iris-appearance', mode);
        // Native form controls and scrollbars follow the selected palette too.
        document.documentElement.style.colorScheme = mode === 'light' ? 'light' : 'dark';
        document.querySelectorAll('[data-iris-appearance]').forEach(function (button) {
            if (button === document.documentElement) { return; }
            var next = modes[(modes.indexOf(mode) + 1) % modes.length];
            var label = 'Appearance: ' + names[mode] + '. Switch to ' + names[next];
            button.setAttribute('aria-label', label);
            button.setAttribute('title', label);
            var icon = button.querySelector('[data-iris-appearance-icon]');
            if (icon) { icon.innerHTML = icons[mode]; }
        });
        var status = document.getElementById('irisAppearanceStatus');
        if (status) { status.textContent = names[mode] + ' appearance selected'; }
        document.querySelectorAll(editorSelector).forEach(themeEditor);
        document.dispatchEvent(new CustomEvent('iris:appearancechange', { detail: { mode: mode } }));
    }
    preference = read();
    apply();
    document.addEventListener('DOMContentLoaded', function () {
        var status = document.createElement('span');
        status.id = 'irisAppearanceStatus';
        status.className = 'sr-only';
        status.setAttribute('role', 'status');
        status.setAttribute('aria-live', 'polite');
        document.body.appendChild(status);
        apply();
        document.addEventListener('load', function (event) {
            if (event.target.tagName === 'IFRAME') { themeEditor(event.target); }
        }, true);
        new MutationObserver(function (changes) {
            changes.forEach(function (change) {
                change.addedNodes.forEach(function (node) {
                    if (node.nodeType !== 1) { return; }
                    if (node.tagName === 'IFRAME') { themeEditor(node); }
                    node.querySelectorAll(editorSelector).forEach(themeEditor);
                });
            });
        }).observe(document.body, { childList: true, subtree: true });
    });
    document.addEventListener('click', function (event) {
        var button = event.target.closest('[data-iris-appearance]');
        if (!button || button === document.documentElement) { return; }
        preference = modes[(modes.indexOf(current()) + 1) % modes.length];
        try { window.localStorage.setItem(key, preference); } catch (error) { /* In-memory selection still works. */ }
        apply();
    });
    window.addEventListener('storage', function (event) {
        if (event.key === key || event.key === null) { preference = read(); apply(); }
    });
    function systemChanged() { if (!preference) { apply(); } }
    if (system) {
        if (system.addEventListener) { system.addEventListener('change', systemChanged); }
        else if (system.addListener) { system.addListener(systemChanged); }
    }
}());
