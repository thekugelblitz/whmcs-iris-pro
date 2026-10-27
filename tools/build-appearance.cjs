/* Regenerate the scoped compatibility layer after an upstream Iris update.
 * Uses the browser CSS parser, including media rules and selector lists. */
const fs = require('node:fs');
const path = require('node:path');
const { chromium } = require('playwright');
const root = path.resolve(__dirname, '..');
const theme = path.join(root, 'templates/templates/Iris Pro');

async function build() {
    const browser = await chromium.launch({ headless: true, ...(process.env.BROWSER_CHANNEL ? { channel: process.env.BROWSER_CHANNEL } : {}) });
    try {
        const page = await browser.newPage();
        const source = fs.readFileSync(path.join(theme, 'css/theme.min.css'), 'utf8');
        const result = await page.evaluate(source => {
            const sheet = new CSSStyleSheet();
            sheet.replaceSync(source);
            const groups = {
                surface: ['fff', 'ffffff'],
                'surface-inset': ['eff2f9', 'efefef', 'f9f9f9', 'f8f9fa', 'fafbfc', 'f0f0f0', 'f3f9ff'],
                'surface-hover': ['e6e6e6', 'f1f3f5', 'e9ecef'],
                border: ['ebebeb', 'ddd', 'ccc', 'e2e7e9', 'dee2e6', 'e0e0e0', 'eef1f4', 'ced4da', 'e5e7eb', 'e1e5e9', 'adadad'],
                text: ['000', '333', '163753', '495057'],
                'text-muted': ['666', '777', '888', '999', '6c757d', '9ca3af', 'd3d3d3', '6e6e6e'],
                'primary-subtle': ['f3f7ff', 'dce9ff', 'e3f2fd', 'cbe7fb'],
                primary: ['005eff', '0048c4', '2196f3', '99bfff', '90caf9', '667eea'],
                'info-text': ['369', '1565c0', '1976d2', '0353a4'],
                'success-subtle': ['d4edda', 'c3e6cb', 'f0fff0'],
                'success-deep': ['155724', '28a745', '10b981', '556b00'],
                'danger-subtle': ['f8d7da', 'f5c6cb'],
                'danger-deep': ['dc3545'],
                'warning-subtle': ['ff9', 'ffc', 'fff3cd', 'ffeaa7'],
                'warning-deep': ['8a6d3b', '856404', 'c2410c']
            };
            const map = {};
            for (const [token, colors] of Object.entries(groups)) {
                for (let color of colors) {
                    if (color.length === 3) color = color.split('').map(c => c + c).join('');
                    map[color] = token;
                }
            }
            const prefix = ':root[data-iris-appearance="dark"]';
            let count = 0;
            const unknown = new Set();
            function visit(rules) {
                let output = '';
                for (const rule of rules) {
                    if (rule.type === CSSRule.MEDIA_RULE) {
                        const children = visit(rule.cssRules);
                        if (children) output += '@media ' + rule.conditionText + ' {\n' + children + '}\n';
                        continue;
                    }
                    if (rule.type !== CSSRule.STYLE_RULE || rule.selectorText.includes(':root')) continue;
                    const declarations = [];
                    const background = rule.style.background || rule.style.backgroundColor || '';
                    const coloredFill = /gradient/.test(background) && !/227, 242, 253|212, 237, 218|248, 215, 218|255, 243, 205|248, 249, 250|240, 255, 240/.test(background)
                        || /26, 77, 128|0, 94, 255/.test(background);
                    for (const property of rule.style) {
                        if (!/^(color|background(?:-color|-image)?|border(?:-(?:top|right|bottom|left))?(?:-color)?|fill|stroke)$/.test(property)) continue;
                        const original = rule.style.getPropertyValue(property);
                        const value = original.replace(/#[\da-f]{3,8}\b|rgba?\([^)]*\)/gi, literal => {
                            let hex;
                            if (literal[0] === '#') {
                                hex = literal.slice(1).toLowerCase();
                                if (hex.length === 3) hex = hex.split('').map(c => c + c).join('');
                            } else {
                                const parts = literal.match(/[\d.]+/g).map(Number);
                                if (parts.length !== 3) return literal; // Preserve translucency; targeted fixes live in appearance.css.
                                hex = parts.map(x => x.toString(16).padStart(2, '0')).join('');
                            }
                            let token = map[hex];
                            if (!token) { unknown.add(hex); return literal; }
                            if (property === 'color' && hex === 'ffffff') {
                                if (coloredFill || /introVideo|btnAiSuggestion|generateAiSuggestion|btn-ai-suggestions-manage/.test(rule.selectorText) && !/regenerate|active/.test(rule.selectorText)) return literal;
                                token = /schedule-actions|scheduled-actions-primary/.test(rule.selectorText) ? 'on-primary' : 'text';
                            } else if (property === 'color' && token === 'primary') token = 'link';
                            else if (/border/.test(property) && ['e3f2fd', 'dce9ff', '90caf9', '99bfff'].includes(hex)) token = 'border-subtle';
                            else if (/border/.test(property) && token === 'surface') token = 'border';
                            return 'var(--' + token + ')';
                        });
                        if (value !== original) declarations.push('    ' + property + ': ' + value + (rule.style.getPropertyPriority(property) ? ' !important' : '') + ';');
                    }
                    if (declarations.length) {
                        // :is() safely groups selectors with commas inside :has() or attributes.
                        output += prefix + ' :is(' + rule.selectorText + ') {\n' + declarations.join('\n') + '\n}\n';
                        count++;
                    }
                }
                return output;
            }
            return { css: visit(sheet.cssRules), count, retainedColors: [...unknown].sort() };
        }, source);
        fs.writeFileSync(path.join(theme, 'css/appearance-legacy.css'),
            '/* Generated by tools/build-appearance.cjs from the shipped theme.min.css.\n' +
            ' * Scope: known literal UI colors. Original light styles are untouched. */\n@media screen {\n' + result.css + '}\n');
        const logo = fs.readFileSync(path.join(theme, 'images/logo.svg'), 'utf8');
        fs.writeFileSync(path.join(theme, 'images/logo-dark.svg'), logo.replace(/fill="(?:black|#090C2A)"/g, 'fill="#e5eaf1"'));
        console.log(JSON.stringify({ generatedRules: result.count, retainedDecorativeColors: result.retainedColors }, null, 2));
    } finally { await browser.close(); }
}
build().catch(error => { console.error(error); process.exitCode = 1; });
