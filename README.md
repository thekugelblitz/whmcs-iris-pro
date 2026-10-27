# WHMCS Iris Pro

A separate WHMCS admin theme based on Iris, with the original Light palette and a refined black-and-charcoal Dark palette. Install it alongside the original `iris` theme so administrators can switch back without overwriting the vendor theme.

## Appearance

- **Light** preserves Iris's original colors.
- **Dark** uses a `#000000` main canvas, `#161616` panels and `#222222` controls, editors and raised surfaces. Muted gray borders provide separation; focused controls retain an accent ring.
- The sun/moon button sits immediately before Staff in the navigation footer, including the mobile drawer. It toggles between Light and Dark and supports keyboard activation, tooltips and screen-reader announcements.
- System appearance is followed on the first visit. An explicit choice is stored under `whmcs.iris-pro.appearance`, survives reloads and synchronizes across tabs. This preference is separate from the original Iris customization. With browser storage blocked, switching still works for the current page.

The palette covers shared forms, tables, billing components, status messages, navigation, search, dropdowns, dialogs, date pickers, editor controls and chart labels. Legacy ticket AI and scheduled-action styles have a compatibility layer. Media and customer HTML previews retain their original colors.

The ticket editor's bundled Bootstrap Markdown stylesheet sets white backgrounds with `!important`. Iris Pro explicitly pairs dark backgrounds with readable text for typing, preview, fullscreen and focus states. Same-origin TinyMCE editing canvases are also themed, without changing draft content.

## Install alongside Iris

1. Copy the **entire** `templates/templates/Iris Pro` folder into `<your WHMCS admin directory>/templates/Iris Pro`. Preserve its capitalization and space. The normal `iris` directory stays in place.
2. Select **Iris Pro** as the administrator's template in WHMCS administrator settings. Admin template selection is per administrator; use the original **iris** entry to roll back.
3. Clear the compiled template cache through WHMCS's system cleanup tools and refresh any CDN/browser cache.
4. Use the appearance button next to Staff to select Light or Dark.

This repository contains an admin theme, not the WHMCS application or a client-area storefront. The duplicated `templates/templates` path reflects the supplied archive layout; it is not an instruction to create an extra nesting level on the server. Copy the inner **Iris Pro** folder into the actual admin `templates` directory. Run `powershell -File tools/package-theme.ps1` to generate a deployment archive under `dist/`; extract it inside the admin **templates** directory so its `Iris Pro` folder lands correctly. Generated archives are excluded from Git.

Keep the original Iris installation available. Iris Pro retains upstream WHMCS copyright and license notices. The upstream code and bundled assets remain subject to their existing licenses; this customization does not relicense them.

## Development

The upstream minified bundles are unchanged. The custom appearance implementation lives in:

- `js/appearance.js`: early preference restoration, two-mode switching, accessibility, tab synchronization and editing-frame appearance.
- `css/appearance.css`: palette, surfaces, control states and targeted editor/component fixes.
- `css/appearance-legacy.css`: generated overrides for known literal colors in the shipped theme.
- `images/logo-dark.svg`: legible wordmark with the original green brand mark.
- `header.tpl` and `nav.tpl`: asset loading and the navigation button.

Install the test dependency, then build and verify:

```powershell
npm ci --prefix tools
$env:BROWSER_CHANNEL = 'msedge'
node tools/build-appearance.cjs
node tools/verify-appearance.cjs
```

For bundled Chromium, install it with `npx --prefix tools playwright install chromium` and omit `BROWSER_CHANNEL`. The browser parser regenerates legacy rules from `theme.min.css`; review the explicit mapping when upgrading the upstream Iris theme. Increment the `iris=2` revision in `header.tpl` whenever the custom assets change.

## Verification

`verification/results.json` records the latest component integration run. Screenshots in `verification/` show a synthetic QA fixture using the actual Iris CSS/JS and Bootstrap Markdown plugin; they are not screenshots of a live WHMCS account. The fixture uses placeholders for Smarty output and no customer data.

Checks cover original-Light color parity; Dark text contrast; true-black page, rail and content; charcoal controls; the real ticket editor's typing, preview and fullscreen states; draft preservation; rich-text frame restoration; keyboard activation; saved preferences; cross-tab updates; blocked storage; system preference changes; mobile controls at 320/390/768/1023px and a short landscape viewport; and print appearance. Sampled Dark text exceeds the WCAG AA 4.5:1 requirement. This is component verification, not a complete accessibility audit or certification of every server-rendered WHMCS page.

Before production rollout, smoke-test your installed WHMCS version with its actual permissions and enabled modules: dashboard widgets, client/service/domain forms, invoices and transactions, orders, ticket replies and dialogs, reports/charts, configuration, search and Ajax dialogs. Those server-rendered workflows are not available in this asset-only checkout.

Third-party modules may supply their own styles or canvas-drawn charts. Cross-origin iframes cannot inherit the admin theme. Customer HTML previews intentionally preserve authored colors. Independently generated popup or login documents that do not include Iris Pro's header require the appearance assets in their own document header; shared login and client-area templates are outside this theme.
