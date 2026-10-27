# Iris Pro — WHMCS Admin Theme with Dark Mode

Iris Pro is a WHMCS administrator theme with a light interface, an AMOLED-inspired dark mode, a navigation theme switch, and optional custom logos. It is based on the WHMCS Iris admin theme and is currently made for and compatible with **WHMCS 9.1.x**.

## Author and publisher

**Published by Dhruval Joshi from [HostingSpell LLP (hostingspell.com)](https://hostingspell.com).** Iris Pro is a contribution to the WHMCS hosting community by Dhruval Joshi and HostingSpell LLP.

## Features

- Light and dark modes, with black page backgrounds and charcoal panels in dark mode.
- A theme switch in the desktop sidebar and mobile navigation. The choice is stored in a one-year browser cookie and shared by administrators using that browser profile.
- Early application of the cookie preference on refresh. The supplied hook also lets WHMCS render the initial dark canvas from the cookie; no theme preference database or network save is required.
- Dark styling for common admin components and ticket editors, including same-origin rich text editor frames.
- Separate light and dark PNG logos, with the built-in WHMCS logo as a fallback.

## Installation

The `admin` directory in this repository is an **example**. Your actual WHMCS admin directory may have any configured name, such as `admin` or a custom name. The WHMCS root is the directory containing `configuration.php`.

1. Back up the installation. Copy `admin/templates/Iris Pro/` from this repository to `<your-admin-directory>/templates/Iris Pro/` on the server. Keep the original Iris theme installed.
2. Copy `admin/templates/Iris Pro/integrations/includes/hooks/irispro_preferences.php` to `<WHMCS-root>/includes/hooks/irispro_preferences.php`. This hook supplies the early cookie hint and detects custom logos.
3. For the optional logo upload page, copy `admin/templates/Iris Pro/integrations/modules/addons/irispro/` to `<WHMCS-root>/modules/addons/irispro/`. In WHMCS **System Settings > Addon Modules**, activate **Iris Pro Preferences** and grant access only to trusted administrators. The **Configure General Settings** permission is also required to upload logos.
4. In **My Account**, select **Iris Pro** as the administrator template. Clear the WHMCS template cache and refresh the browser.
5. Use the appearance button in the navigation footer to select Light or Dark. Select Dark once after upgrading from an earlier preference system. Clearing cookies resets the browser's choice; the selection does not follow an account to another browser or device.

The integration files remain under the theme folder in this repository to keep the repository layout simple; WHMCS discovers them at the root paths in steps 2 and 3. The original admin folder name and URL need not be `admin`.

## Custom WHMCS admin logos

Open **Addons > Iris Pro Preferences** to upload a PNG for either appearance. Light mode uses `<your-admin-directory>/templates/Iris Pro/images/logo-light.png`; Dark mode uses `logo-dark.png` in the same folder. The original SVG is used for any variant without an uploaded logo. Both desktop and mobile navigation use the selected variant.

The WHMCS wordmark's SVG is 211 × 48 pixels and is displayed at 24 pixels high. A transparent **422 × 96 pixel** PNG provides a matching 2× canvas. Keep the artwork proportional and add transparent padding if needed. PNG files must be at most **2 MB**, no larger than **422 × 96 pixels**, and have a canvas aspect ratio between **3:1 and 6:1**.

The uploader checks administrator permission and the WHMCS security token, validates the upload, MIME type, PNG format and dimensions, and uses PHP GD to decode and re-encode the image. It writes only the fixed logo filenames and rejects symlinked theme paths. PHP Fileinfo and GD must be enabled, and the admin PHP process needs write access to the theme's `images/` directory. You may alternatively place appropriately sized PNG files there using your hosting file manager.

## Compatibility and security

Iris Pro is designed for **WHMCS 9.1.x**. Compatibility with other WHMCS versions has not been established. It is an admin theme, not a client-area theme. Test it with your WHMCS release and extensions before production use; third-party CSS, charts and cross-origin frames may need their own styling.

The supplied Iris vendor bundle includes **jQuery 1.12.4**, which is affected by published jQuery security advisories, including [CVE-2020-11022](https://github.com/jquery/jquery/security/advisories/GHSA-gxr4-xjj5-5px2). Compatibility with WHMCS and its extensions must be verified before replacing that bundled library. The custom logo uploader is validated as described above, but the bundled upstream code and installed extensions have not received a complete security audit.

The theme includes upstream WHMCS/Iris template files and bundled assets. Those files remain subject to their respective licenses and are not relicensed by Iris Pro. Obtain the necessary WHMCS permission before redistributing the complete modified theme. Font license notices remain with the fonts.

WHMCS and Iris are trademarks of their respective owners.
