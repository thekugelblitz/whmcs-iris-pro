<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="{$charset}">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="referrer" content="same-origin">

    <title>WHMCS - {$pagetitle}</title>

    {* Set the saved palette before the browser can paint the document. This
       inline bootstrap must remain ahead of every external script and style. *}
    <script>
        (function () {
            var saved = null;
            try { saved = window.localStorage.getItem('whmcs.iris-pro.appearance'); } catch (error) {}
            var dark = saved === 'dark' || (saved !== 'light' && window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches);
            if (dark) {
                document.documentElement.setAttribute('data-iris-appearance', 'dark');
                document.documentElement.style.colorScheme = 'dark';
                document.documentElement.style.backgroundColor = '#000000';
            }
        }());
    </script>

    {\WHMCS\View\Asset::fontCssInclude('open-sans-family.css')}
    <link href="templates/{$template}/css/all.min.css?v={$versionHash}" rel="stylesheet" />
    <link href="templates/{$template}/css/theme.min.css?v={$versionHash}" rel="stylesheet" />
    <link href="templates/{$template}/css/appearance-legacy.css?v={$versionHash}&amp;iris=3" rel="stylesheet" />
    <link href="templates/{$template}/css/appearance.css?v={$versionHash}&amp;iris=3" rel="stylesheet" />
    <script src="templates/{$template}/js/appearance.js?v={$versionHash}&amp;iris=3"></script>
    <link href="{$WEB_ROOT}/assets/fonts/css/fontawesome.min.css" rel="stylesheet" />
    <link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-solid.min.css" rel="stylesheet" />
    <link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-regular.min.css" rel="stylesheet" />
    <link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-light.min.css" rel="stylesheet" />
    <link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-brands.min.css" rel="stylesheet" />
    <link href="{$WEB_ROOT}/assets/fonts/css/fontawesome-duotone.min.css" rel="stylesheet" />
    <script type="text/javascript" src="templates/{$template}/js/vendor.min.js?v={$versionHash}"></script>
    <script type="text/javascript" src="templates/{$template}/js/scripts.min.js?v={$versionHash}"></script>
    <script>
        var datepickerformat = "{$datepickerformat}",
            csrfToken="{$csrfToken}",
            adminBaseRoutePath = "{\WHMCS\Admin\AdminServiceProvider::getAdminRouteBase()}",
            whmcsBaseUrl = "{\WHMCS\Utility\Environment\WebHelper::getBaseUrl()}";

        // Localized strings consumed by jssrc/redesign-a11y.js (additive
        // accessible-name enhancer for shipped/legacy markup). All values come
        // from the admin language file — no hardcoded prose in the JS layer.
        var redesignA11yLang = {ldelim}
            close: "{$_ADMINLANG.global.close|escape:'javascript'}",
            dismiss: "{$_ADMINLANG.global.dismiss|escape:'javascript'}",
            checkAll: "{$_ADMINLANG.global.checkall|escape:'javascript'}",
            search: "{$_ADMINLANG.global.search|escape:'javascript'}",
            slide: "{$_ADMINLANG.redesign.carouselSlide|escape:'javascript'}",
            fullscreen: "{$_ADMINLANG.redesign.fullscreen|escape:'javascript'}",
            moreTabs: "{$_ADMINLANG.redesign.moreTabs|escape:'javascript'}",
            sortBy: "{$_ADMINLANG.redesign.sortBy|escape:'javascript'}",
            viewDetails: "{$_ADMINLANG.gettingStartedWizard.label.viewDetails|escape:'javascript'}"
        {rdelim};

        {if $jquerycode}
            $(document).ready(function(){ldelim}
                {$jquerycode}
            {rdelim});
        {/if}
        {if $jscode}
            {$jscode}
        {/if}
    </script>

    {$headoutput}

</head>
{assign var="showSidebar" value=$sidebar eq "support" && !empty($inticket)}
{assign var="irisPageSlug" value=$smarty.server.PHP_SELF|regex_replace:'#^.*/#':''|regex_replace:'#\.php$#':''|regex_replace:'#[^A-Za-z0-9_-]#':''}
<body class="iris{if $irisPageSlug} page-{$irisPageSlug}{/if}{if !$showSidebar} no-sidebar{/if}{if !empty($globalAdminWarningMsg)} has-warning-banner{/if}" data-phone-cc-input="{if !empty($phoneNumberInputStyle)}{$phoneNumberInputStyle}{/if}">
<div id="overlay"></div>
    {$headeroutput}

    <div class="navigation">
        {include file="$template/nav.tpl"}
    </div>

    {if $showSidebar}
        <div class="sidebar{if $minsidebar} minimized{/if}" id="sidebar" data-test="admin-sidebar">
            <a href="#" class="sidebar-collapse-expand" id="sidebarCollapseExpand">
                <span>{$_ADMINLANG.support.ticketinfo}</span>
                <i class="fa fa-chevron-down"></i>
            </a>
            <div class="sidebar-collapse">
                {include file="$template/sidebar.tpl"}
            </div>
        </div>
        <a href="#" class="sidebar-opener{if $minsidebar} minimized{/if}" id="sidebarOpener">
            {$_ADMINLANG.openSidebar}
        </a>
    {/if}

    <div class="{$contentAreaClasses}" id="contentarea">
        <div class="alert global-admin-warning">
            <i class="far fa-circle-info" aria-hidden="true"></i>
                {$globalAdminWarningMsg}
        </div>
        <div style="float:left;width:100%;">
            {if !$isCustomHeader}
                {if $sidebar eq 'logs'}
                    {* Blend shows the server time in the logs sidebar; iris has no sidebar here *}
                    <div class="page-title-row">
                        <h1>{$pagetitle}</h1>
                        <div class="page-title-meta" data-test="admin-logs-server-time">
                            <i class="far fa-clock" aria-hidden="true"></i>
                            {$_ADMINLANG.system.currentTime}:
                            <span class="page-title-meta-value">{$dateTimeNowFormatted}</span>
                        </div>
                    </div>
                {else}
                    <h1{if $pagetitle == $_ADMINLANG.global.hometitle} class="pull-left"{/if}>{$pagetitle}</h1>
                {/if}
            {/if}
