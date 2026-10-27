/* Browser integration checks against the shipped Iris CSS/JS and navigation.
 * No WHMCS installation or customer data is needed for this component fixture. */
const fs = require('node:fs');
const path = require('node:path');
const http = require('node:http');
const assert = require('node:assert/strict');
const { chromium } = require('playwright');
const root = path.resolve(__dirname, '..');
const theme = '/templates/templates/Iris Pro';
const out = path.join(root, 'verification');
const key = 'whmcs.iris-pro.appearance';
const samples = `
<h1>Iris appearance verification</h1>
<p data-contrast>Client management, billing and support</p>
<p class="text-muted" data-contrast>Secondary text and supporting information</p>
<div class="ticket-view"><label for="replymessage">Ticket reply editor</label><textarea id="replymessage" class="form-control" aria-label="Add reply" rows="7" data-contrast>**Hello Alex,**

Your service is available again.

Best regards,
Technical Support</textarea></div>
<div class="row"><div class="col-sm-6">
<div class="panel panel-default"><div class="panel-heading" data-contrast>Client details</div><div class="panel-body">
<label for="name" data-contrast>Client name</label><input id="name" class="form-control" value="Alex Morgan" data-contrast>
<label for="status" data-contrast>Status</label><select id="status" class="form-control" data-contrast><option>Active</option></select>
<textarea class="form-control" aria-label="Notes" data-contrast>Internal notes</textarea>
<input class="form-control" aria-label="Disabled field" value="Read only" disabled>
<div class="help-block" data-contrast>Changes are saved securely.</div>
<button class="btn btn-primary" data-contrast>Save changes</button> <button class="btn btn-default" data-contrast>Cancel</button> <button class="btn btn-danger" data-contrast>Delete</button>
</div></div></div><div class="col-sm-6">
<div class="alert alert-success" data-contrast>Payment received</div>
<div class="alert alert-warning" data-contrast>Renewal due soon</div>
<div class="alert alert-danger" data-contrast>Payment failed</div>
<div class="alert alert-info" data-contrast>Account update available</div>
<p><span class="text-success" data-contrast>Active</span> · <span class="text-warning" data-contrast>Pending</span> · <span class="text-danger" data-contrast>Overdue</span></p>
</div></div>
<div class="tablebg"><table class="datatable" width="100%"><thead><tr><th data-contrast>Invoice</th><th data-contrast>Client</th><th data-contrast>Status</th><th data-contrast>Total</th></tr></thead><tbody>
<tr><td data-contrast>#1001</td><td><a href="#" data-contrast>Alex Morgan</a></td><td><span class="status-pill status-paid" data-contrast>Paid</span></td><td data-contrast>$49.00</td></tr>
<tr><td data-contrast>#1002</td><td data-contrast>Sam Taylor</td><td><span class="status-pill status-pending" data-contrast>Pending</span></td><td data-contrast>$89.00</td></tr></tbody></table></div>
<ul class="nav nav-tabs"><li class="active"><a href="#" data-contrast>Overview</a></li><li><a href="#" data-contrast>Activity</a></li></ul>
<div class="whmcs-phpinfo"><table><tbody><tr><td class="e" data-contrast>PHP setting</td><td class="v" data-contrast>Enabled</td></tr></tbody></table></div>
<div id="ticketReplyAiSuggestions" style="display:block"><div class="ai-form-section"><label data-contrast>Ticket reply</label><input class="form-control" value="Draft response" data-contrast></div>
<div class="ai-suggestion-preview" style="display:block" data-contrast>Your service has been renewed.</div><div class="ai-pii-warning" data-contrast>Review personal information before sending.</div></div>
<div class="reply-thread"><div class="reply-thread-header"><h5 data-contrast>Reply thread</h5></div><div class="reply-message"><div class="reply-content" data-contrast>Thank you for contacting support.</div></div></div>
<div class="panel-scheduled-actions-management" style="display:block"><h3 class="panel-title" data-contrast>Scheduled actions</h3><button class="btn btn-scheduled-actions-primary" data-contrast>Schedule</button></div>
<table class="form"><tbody><tr><td class="fieldlabel" data-contrast>Legacy form</td><td class="fieldarea" data-contrast>Account configuration</td></tr></tbody></table>
<div class="mce-edit-area"><iframe title="Rich text editor" srcdoc="<body><p>Editable content</p></body>"></iframe></div>
<div class="modal" id="fixtureModal" tabindex="-1"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><h4 class="modal-title">Confirmation</h4></div><div class="modal-body">Review this action</div><div class="modal-footer"><button class="btn btn-primary">Confirm</button></div></div></div></div>
<div class="footerbar"><span data-contrast>WHMCS · Iris</span></div>`;

function fixture(baseline) {
    let nav = fs.readFileSync(path.join(root, theme, 'nav.tpl'), 'utf8');
    nav = nav.replace(/\{\*[\s\S]*?\*\}/g, '')
        .replace(/\{\$[^}]+\}/g, value => {
            if (value.includes('admins_online_list')) return '1';
            const label = value.replace(/^.*\./, '').replace(/[^a-zA-Z]/g, '');
            return label.charAt(0).toUpperCase() + label.slice(1);
        })
        .replace(/\{(?:\/?(?:if|else|elseif|foreach|assign)|lang|routePath)[^}]*\}/g, '')
        .replace(/src="https:\/\/www.gravatar.com[^\"]*"/g, 'src="data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'36\' height=\'36\'%3E%3Ccircle cx=\'18\' cy=\'18\' r=\'18\' fill=\'%23566c95\'/%3E%3C/svg%3E"')
        .replace(/templates\/\w+\/images/g, theme + '/images');
    return `<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
${baseline ? '' : `<script src="${theme}/js/appearance.js"></script>`}
<link rel="stylesheet" href="${theme}/css/all.min.css"><link rel="stylesheet" href="${theme}/css/theme.min.css">
${baseline ? '' : `<link rel="stylesheet" href="${theme}/css/appearance-legacy.css"><link rel="stylesheet" href="${theme}/css/appearance.css">`}
<script src="${theme}/js/vendor.min.js"></script><script src="${theme}/js/scripts.min.js"></script>
<script>var datepickerformat='dd/mm/yyyy',csrfToken='fixture',adminBaseRoutePath='',whmcsBaseUrl='';</script>
</head><body class="iris no-sidebar"><div id="overlay"></div><div class="navigation">${nav}</div><div class="contentarea" id="contentarea">${samples}</div><script>jQuery(function(){jQuery('#replymessage').markdown({autofocus:false});});</script></body></html>`;
}

async function verify() {
    fs.mkdirSync(out, { recursive: true });
    const server = http.createServer((req, res) => {
        const url = new URL(req.url, 'http://127.0.0.1');
        if (url.pathname === '/fixture') { res.setHeader('Content-Type', 'text/html'); return res.end(fixture(url.searchParams.has('baseline'))); }
        const file = path.resolve(root, '.' + decodeURIComponent(url.pathname));
        if (!file.startsWith(root + path.sep) || !fs.existsSync(file) || fs.statSync(file).isDirectory()) { res.statusCode = 404; return res.end(); }
        const types = { '.css': 'text/css', '.js': 'text/javascript', '.svg': 'image/svg+xml', '.woff2': 'font/woff2', '.ttf': 'font/ttf' };
        res.setHeader('Content-Type', types[path.extname(file)] || 'application/octet-stream');
        fs.createReadStream(file).pipe(res);
    });
    await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
    const url = `http://127.0.0.1:${server.address().port}/fixture`;
    const browser = await chromium.launch({ headless: true, ...(process.env.BROWSER_CHANNEL ? { channel: process.env.BROWSER_CHANNEL } : {}) });
    const report = { modes: [], checks: [] };
    try {
        const context = await browser.newContext({ viewport: { width: 1440, height: 1080 }, colorScheme: 'light', reducedMotion: 'reduce' });
        const page = await context.newPage();
        const errors = [];
        page.on('pageerror', error => errors.push(error.message));
        await page.goto(url);
        await page.waitForLoadState('networkidle');
        async function setMode(mode) {
            await page.evaluate(({ key, mode }) => { localStorage.setItem(key, mode); window.dispatchEvent(new StorageEvent('storage', { key })); }, { key, mode });
            await page.waitForTimeout(200); // Let shipped button color transitions settle.
        }
        async function snapshot() {
            return page.locator('[data-contrast]').evaluateAll(nodes => nodes.map(node => {
                const s = getComputedStyle(node);
                return { color: s.color, background: s.backgroundColor, border: s.borderColor };
            }));
        }
        const light = await snapshot();
        const baseline = await context.newPage();
        await baseline.goto(url + '?baseline');
        const original = await baseline.locator('[data-contrast]').evaluateAll(nodes => nodes.map(node => {
            const s = getComputedStyle(node); return { color: s.color, background: s.backgroundColor, border: s.borderColor };
        }));
        assert.deepEqual(light, original, 'Light mode preserves the original component palette');
        await baseline.close();
        report.checks.push('Light-mode computed colors match the original Iris styles');

        for (const mode of ['light', 'dark']) {
            await setMode(mode);
            const result = await page.evaluate(() => {
                function rgb(value) { return (value.match(/[\d.]+/g) || []).map(Number).slice(0, 3); }
                function luminance(values) { return values.map(x => { x /= 255; return x <= .04045 ? x / 12.92 : ((x + .055) / 1.055) ** 2.4; }).reduce((sum, x, i) => sum + x * [.2126, .7152, .0722][i], 0); }
                const failures = [];
                let min = 100;
                for (const node of document.querySelectorAll('[data-contrast]')) {
                    if (!node.getClientRects().length) continue;
                    let background = 'rgb(255,255,255)';
                    for (let parent = node; parent; parent = parent.parentElement) {
                        const color = getComputedStyle(parent).backgroundColor;
                        if (color !== 'rgba(0, 0, 0, 0)' && color !== 'transparent') { background = color; break; }
                    }
                    const foreground = getComputedStyle(node).color;
                    const values = [luminance(rgb(foreground)), luminance(rgb(background))].sort((a, b) => b - a);
                    const ratio = (values[0] + .05) / (values[1] + .05);
                    min = Math.min(min, ratio);
                    if (ratio < 4.5) failures.push({ text: node.textContent.trim().slice(0, 55) || node.value, foreground, background, ratio });
                }
                return { failures, minimumContrast: +min.toFixed(2), body: getComputedStyle(document.body).backgroundColor, content: getComputedStyle(document.getElementById('contentarea')).backgroundColor, rail: getComputedStyle(document.querySelector('.nav-rail')).backgroundColor, input: getComputedStyle(document.getElementById('name')).backgroundColor };
            });
            // Light mode is vendor-owned and its pre-existing contrast is reported, not changed.
            if (mode !== 'light') assert.deepEqual(result.failures, [], `${mode} text must reach 4.5:1 contrast`);
            if (mode === 'dark') for (const surface of ['body', 'content', 'rail']) assert.equal(result[surface], 'rgb(0, 0, 0)', surface + ' must be true black');
            if (mode === 'dark') {
                assert.equal(result.input, 'rgb(34, 34, 34)', 'Controls are charcoal rather than black');
                for (const selector of ['#name', '#status', '.md-editor']) {
                    const border = await page.locator(selector).first().evaluate(node => getComputedStyle(node).borderTopColor);
                    assert(['rgb(48, 48, 48)', 'rgb(59, 59, 59)'].includes(border), selector + ' uses a quiet neutral outline: ' + border);
                }
            }
            report.modes.push({ mode, ...result });
            await page.screenshot({ path: path.join(out, mode + '-desktop.png'), fullPage: true });
        }
        await page.reload();
        assert.equal(await page.locator('html').getAttribute('data-iris-appearance'), 'dark');
        const button = page.locator('button[data-iris-appearance]');
        await button.focus();
        await page.keyboard.press('Enter');
        assert.equal(await page.locator('html').getAttribute('data-iris-appearance'), 'light');
        await page.keyboard.press('Space');
        assert.equal(await page.locator('html').getAttribute('data-iris-appearance'), 'dark');
        report.checks.push('Saved preference survives reload; native Enter and Space cycle modes');
        const editor = page.locator('.md-editor').first();
        const editorColors = () => page.locator('#replymessage').evaluate(node => {
            const style = getComputedStyle(node); return { background: style.backgroundColor, color: style.color, border: style.borderColor };
        });
        assert.equal((await editorColors()).background, 'rgb(34, 34, 34)', 'Actual Bootstrap Markdown typing area must be charcoal');
        await page.locator('#replymessage').fill('Ticket draft must survive appearance changes.');
        await page.evaluate(() => jQuery('#replymessage').data('markdown').showPreview());
        assert.equal(await editor.locator('.md-preview').evaluate(node => getComputedStyle(node).backgroundColor), 'rgb(34, 34, 34)');
        await page.evaluate(() => jQuery('#replymessage').data('markdown').hidePreview());
        await page.evaluate(() => jQuery('#replymessage').data('markdown').setFullscreen(true));
        assert.equal((await editorColors()).background, 'rgb(34, 34, 34)', 'Fullscreen editor overrides the vendor white !important background');
        await page.screenshot({ path: path.join(out, 'dark-editor-fullscreen.png') });
        await page.evaluate(() => jQuery('#replymessage').data('markdown').setFullscreen(false));
        await setMode('light');
        assert.equal((await editorColors()).background, 'rgb(255, 255, 255)');
        await setMode('dark');
        assert.equal(await page.locator('#replymessage').inputValue(), 'Ticket draft must survive appearance changes.');
        report.checks.push('Real Bootstrap Markdown typing, preview and fullscreen stay charcoal; drafts survive switching back to Light');
        await page.evaluate(() => {
            const note = document.createElement('textarea');
            note.id = 'replynote'; note.value = 'Dynamically opened internal note';
            document.getElementById('contentarea').appendChild(note);
            jQuery(note).markdown({autofocus:false});
        });
        assert.equal(await page.locator('#replynote').evaluate(node => getComputedStyle(node).backgroundColor), 'rgb(34, 34, 34)');
        report.checks.push('Dynamically initialized note editors inherit the active Dark palette');
        assert.equal(await page.frameLocator('.mce-edit-area iframe').locator('body').evaluate(node => getComputedStyle(node).backgroundColor), 'rgb(34, 34, 34)');
        await setMode('light');
        assert.equal(await page.frameLocator('.mce-edit-area iframe').locator('#irisEditorAppearance').count(), 0);
        report.checks.push('Rich-text editing canvas follows dark mode and restores its original light styles');
        await setMode('dark');
        const second = await context.newPage();
        await second.goto(url);
        await second.evaluate(key => localStorage.setItem(key, 'light'), key);
        await page.waitForFunction(() => document.documentElement.getAttribute('data-iris-appearance') === 'light');
        await second.close();
        report.checks.push('Changes synchronize across browser tabs');

        for (const width of [320, 390, 768, 1023]) {
            await setMode('dark');
            await page.setViewportSize({ width, height: 844 });
            await page.locator('#railToggle').click();
            await button.waitFor({ state: 'visible' });
            await page.waitForTimeout(250); // The stock drawer slides into position.
            const bounds = await button.boundingBox();
            assert(bounds.x >= 0 && bounds.x + bounds.width <= width && bounds.y >= 0 && bounds.y + bounds.height <= 844, `Switch visible inside ${width}px mobile drawer`);
            assert(bounds.width >= 44 && bounds.height >= 44, 'Mobile control has a 44px touch target');
            const staff = await page.locator('#Menu-Staff').boundingBox();
            assert(bounds.x < staff.x, 'Appearance switch is immediately before the staff action');
            if (width === 390) await page.screenshot({ path: path.join(out, 'dark-mobile.png') });
            await button.click();
            await page.locator('#overlay').click({ position: { x: width - 5, y: 20 } });
        }
        report.checks.push('320/390/768/1023px mobile drawers keep the switch beside Staff with a 44px touch target');
        await page.setViewportSize({ width: 844, height: 360 });
        await page.locator('#railToggle').click();
        await page.waitForTimeout(250);
        const landscapeBounds = await button.boundingBox();
        assert(landscapeBounds.y >= 0 && landscapeBounds.y + landscapeBounds.height <= 360, 'Switch fits a short landscape drawer');
        await page.locator('#overlay').click({ position: { x: 839, y: 20 } });
        await setMode('dark');
        await page.emulateMedia({ media: 'print' });
        assert.equal(await page.locator('#contentarea').evaluate(node => getComputedStyle(node).backgroundColor), 'rgb(255, 255, 255)');
        assert.equal(await page.locator('html').evaluate(node => getComputedStyle(node).colorScheme), 'light');
        await page.emulateMedia({ media: 'screen' });
        report.checks.push('Print uses a light paper surface');

        const system = await browser.newContext({ colorScheme: 'dark' });
        const systemPage = await system.newPage();
        await systemPage.goto(url);
        assert.equal(await systemPage.locator('html').getAttribute('data-iris-appearance'), 'dark');
        await systemPage.emulateMedia({ colorScheme: 'light' });
        await systemPage.waitForFunction(() => document.documentElement.getAttribute('data-iris-appearance') === 'light');
        await system.close();
        const blocked = await browser.newContext({ colorScheme: 'dark' });
        await blocked.addInitScript(() => { Object.defineProperty(window, 'localStorage', { get() { throw new DOMException('Storage blocked', 'SecurityError'); } }); });
        const blockedPage = await blocked.newPage();
        await blockedPage.goto(url);
        await blockedPage.locator('button[data-iris-appearance]').click();
        assert.equal(await blockedPage.locator('html').getAttribute('data-iris-appearance'), 'light');
        await blocked.close();
        report.checks.push('System appearance is followed until a selection is saved; blocked storage still permits switching');
        assert.deepEqual(errors, [], 'No browser JavaScript errors');
        fs.writeFileSync(path.join(out, 'results.json'), JSON.stringify(report, null, 2) + '\n');
        console.log(JSON.stringify(report, null, 2));
    } finally {
        await browser.close();
        await new Promise(resolve => server.close(resolve));
    }
}
verify().catch(error => { console.error(error); process.exitCode = 1; });
