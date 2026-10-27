{*
    Blend Redesign chrome (S5) — Iris baseline shell: single left rail
    (brand, search, menu, footer with utility actions + account menu).
    The menu DATA is the stock blend-new tree: every Menu-* anchor id,
    in_array(...,$admin_perms) gate and $menuticketstatuses / $addon_modules
    loop are preserved 1:1 — only the visual grouping changed. The
    $showUpdateAvailable / cron indicator is the one exception: the menu-tree
    dot no longer renders on the Setup group with a Configuration child link,
    it lives on Utilities instead. The rail-footer .rail-update-btn is the
    blend-parity element (blend/nav.tpl:430) and still reads the same flag.
*}

{if empty($irisProLogoLightUrl)}{assign var="irisProLogoLightUrl" value="templates/$template/images/logo.svg"}{/if}
{if empty($irisProLogoDarkUrl)}{assign var="irisProLogoDarkUrl" value="templates/$template/images/logo-dark.svg"}{/if}
<aside class="nav-rail" id="adminNavRail" data-test="admin-nav">
    <div class="rail-brand-row">
        <a href="index.php" class="rail-brand" title="{$_ADMINLANG.home.title}">
            <img src="{$irisProLogoLightUrl|escape:'html'}" data-iris-logo-light="{$irisProLogoLightUrl|escape:'html'}" data-iris-logo-dark="{$irisProLogoDarkUrl|escape:'html'}" alt="WHMCS">
        </a>

        {if in_array("Add New Client", $admin_perms) || in_array("Add New Order", $admin_perms) || in_array("Create Invoice", $admin_perms) || in_array("Manage Quotes", $admin_perms) || in_array("Open New Ticket", $admin_perms)}
            <div class="rail-header-item has-dropdown" data-dropdown>
                <a href="#" onclick="return false;" class="rail-icon-btn" data-dropdown-btn aria-haspopup="true" aria-expanded="false" title="{$_ADMINLANG.addNew.title}">
                    <i class="far fa-plus" aria-hidden="true"></i>
                </a>
                <ul class="rail-dropdown" data-dropdown-menu>
                    {if in_array("Add New Client", $admin_perms)}
                        <li>
                            <a href="clientsadd.php">{$_ADMINLANG.addNew.client}</a>
                        </li>
                    {/if}
                    {if in_array("Add New Order", $admin_perms)}
                        <li>
                            <a href="ordersadd.php">{$_ADMINLANG.addNew.order}</a>
                        </li>
                    {/if}
                    {if in_array("Create Invoice", $admin_perms)}
                        <li>
                            <a href="{routePath('admin-billing-invoice-new')}" class="open-modal"
                               data-modal-title="{lang key='addNew.invoice'}"
                               {if !empty($anyGatewaysActivated)}data-btn-submit-id="btnCreateInvoice"
                               data-btn-submit-label="{lang key='invoices.create'}" {/if}>
                                {lang key='addNew.invoice'}
                            </a>
                        </li>
                    {/if}
                    {if in_array("Manage Quotes", $admin_perms)}
                        <li>
                            <a href="quotes.php?action=manage">{$_ADMINLANG.addNew.quote}</a>
                        </li>
                    {/if}
                    {if in_array("Open New Ticket", $admin_perms)}
                        <li>
                            <a href="supporttickets.php?action=open">{$_ADMINLANG.addNew.ticket}</a>
                        </li>
                    {/if}
                </ul>
            </div>
        {/if}
    </div>

    <div class="rail-search" data-test="admin-search">
        <div class="intellisearch" id="intelliSearchForm">
            <form method="post" action="{routePath('admin-search-intellisearch')}">
                <input type="hidden" id="intelliSearchHideInactive" name="hide_inactive" value="1">
                <i class="fas fa-search loader" aria-hidden="true"></i>
                <input type="text" name="searchterm" id="inputIntelliSearchValue" class="rail-search-input"
                       placeholder="{$_ADMINLANG.searchPlaceholder}" autocomplete="off"
                       aria-label="{$_ADMINLANG.global.search}">
                <button class="rail-search-close" type="button" id="btnIntelliSearchClose" aria-label="{$_ADMINLANG.global.close}">
                    <i class="far fa-xmark" aria-hidden="true"></i>
                </button>
                <input type="hidden" id="intelliSearchExpand" name="more" value="">
            </form>
            <button class="rail-search-adv" type="button" id="btnRailAdvSearchOpen"
                    data-toggle="modal" data-target="#modalRailAdvSearch"
                    title="{$_ADMINLANG.global.advancedsearch}"
                    aria-label="{$_ADMINLANG.global.advancedsearch}">
                <i class="far fa-sliders-h" aria-hidden="true"></i>
            </button>
        </div>
    </div>

    <nav class="rail-menu">
        <ul class="rail-root">
            {* ---- dashboard item (Figma "Insights" slot) + ex-sidebar shortcuts ---- *}
            {assign var="canGenerateInvoices" value=in_array("Main Homepage", $admin_perms) && in_array("Generate Due Invoices", $admin_perms)}
            {assign var="canCaptureCreditCards" value=in_array("Main Homepage", $admin_perms) && in_array("Attempts CC Captures", $admin_perms)}
            {assign var="hasDashboardActions" value=in_array("WHOIS Lookups", $admin_perms) || $canGenerateInvoices || $canCaptureCreditCards}
            <li class="rail-item{if $hasDashboardActions} rail-subgroup{/if}" {if $hasDashboardActions} data-nav-sub{/if} data-test="admin-nav-dashboard">
                <div class="rail-subrow">
                    <a href="index.php" class="rail-link rail-leaf" id="Menu-Home-Dashboard">
                        <i class="far fa-gauge-high" aria-hidden="true"></i>
                        <span class="rail-label">{$_ADMINLANG.global.hometitle}</span>
                    </a>
                    {if $hasDashboardActions}
                        <button type="button" class="rail-subtoggle" data-nav-subtoggle aria-expanded="false" aria-label="{$_ADMINLANG.global.hometitle}">
                            <i class="fas fa-chevron-down" aria-hidden="true"></i>
                        </button>
                    {/if}
                </div>
                {if $hasDashboardActions}
                    <ul class="rail-subchildren">
                        {if in_array("WHOIS Lookups", $admin_perms)}
                            {* Shortcut — Utilities > WHOIS Lookups owns the active pill. *}
                            <li>
                                <a id="Menu-Home-WHOIS_Lookups" href="whois.php" class="rail-link rail-child" data-nav-noactive>
                                    {$_ADMINLANG.utilities.whois}
                                </a>
                            </li>
                        {/if}
                        {if $canGenerateInvoices}
                            <li>
                                <a id="Menu-Home-Generate_Due_Invoices" href="#" class="rail-link rail-child"
                                   data-toggle="modal" data-target="#modalRailGenerateInvoices">
                                    {$_ADMINLANG.invoices.geninvoices}
                                </a>
                            </li>
                        {/if}
                        {if $canCaptureCreditCards}
                            <li>
                                <a id="Menu-Home-Attempt_CC_Captures" href="#" class="rail-link rail-child"
                                   data-toggle="modal" data-target="#modalRailCreditCardCapture">
                                    {$_ADMINLANG.invoices.attemptcccaptures}
                                </a>
                            </li>
                        {/if}
                    </ul>
                {/if}
            </li>

            {* ---- CORE section (label needs a lang key — divider only for now) ---- *}
            <li class="rail-divider" role="separator" aria-hidden="true"></li>

            {* ================= CLIENTS ================= *}
            <li class="rail-group{if $sidebar eq 'clients'} open{/if}" data-nav-group="clients" data-test="admin-nav-clients">
                <a id="Menu-Clients" href="#" onclick="return false;" class="rail-link rail-group-toggle" data-nav-toggle aria-expanded="{if $sidebar eq 'clients'}true{else}false{/if}">
                    <i class="far fa-user-group" aria-hidden="true"></i>
                    <span class="rail-label">{$_ADMINLANG.clients.title}</span>
                    <i class="fas fa-chevron-down rail-caret" aria-hidden="true"></i>
                </a>
                <ul class="rail-children">
                    {if in_array("List Clients",$admin_perms)}
                        <li>
                            <a id="Menu-Clients-View_Search_Clients" href="clients.php" class="rail-link rail-child">
                                {$_ADMINLANG.clients.viewsearch}
                            </a>
                        </li>
                    {/if}
                    {if in_array("List Users", $admin_perms)}
                        <li>
                            <a id="Menu-Clients-View_Search_Users" href="{routePath('admin-user-list')}" class="rail-link rail-child">
                                {lang key='user.manageUsers'}
                            </a>
                        </li>
                    {/if}
                    {if in_array("Add New Client",$admin_perms)}
                        <li>
                            <a id="Menu-Clients-Add_New_Client" href="clientsadd.php" class="rail-link rail-child">
                                {$_ADMINLANG.clients.addnew}
                            </a>
                        </li>
                    {/if}
                    {if in_array("List Services",$admin_perms)}
                        <li class="rail-subgroup" data-nav-sub>
                            <div class="rail-subrow">
                                <a id="Menu-Clients-Products_Services" href="{routePath('admin-services-index')}" class="rail-link rail-child">
                                    {$_ADMINLANG.services.title}
                                </a>
                                <button type="button" class="rail-subtoggle" data-nav-subtoggle aria-expanded="false" aria-label="{$_ADMINLANG.services.title}">
                                    <i class="fas fa-chevron-down" aria-hidden="true"></i>
                                </button>
                            </div>
                            <ul class="rail-subchildren">
                                <li>
                                    <a id="Menu-Clients-Products_Services-Shared_Hosting" href="{routePath('admin-services-shared')}" class="rail-link rail-child rail-grandchild">
                                        {$_ADMINLANG.services.listhosting}
                                    </a>
                                </li>
                                <li>
                                    <a id="Menu-Clients-Products_Services-Reseller_Accounts" href="{routePath('admin-services-reseller')}" class="rail-link rail-child rail-grandchild">
                                        {$_ADMINLANG.services.listreseller}
                                    </a>
                                </li>
                                <li>
                                    <a id="Menu-Clients-Products_Services-VPS_Servers" href="{routePath('admin-services-server')}" class="rail-link rail-child rail-grandchild">
                                        {$_ADMINLANG.services.listservers}
                                    </a>
                                </li>
                                <li>
                                    <a id="Menu-Clients-Products_Services-Other_Services" href="{routePath('admin-services-other')}" class="rail-link rail-child rail-grandchild">
                                        {$_ADMINLANG.services.listother}
                                    </a>
                                </li>
                            </ul>
                        </li>
                    {/if}
                    {if in_array("List Addons",$admin_perms)}
                        <li>
                            <a id="Menu-Clients-Service_Addons" href="{routePath('admin-addons-index')}" class="rail-link rail-child">
                                {$_ADMINLANG.services.listaddons}
                            </a>
                        </li>
                    {/if}
                    {if in_array("List Domains",$admin_perms)}
                        <li>
                            <a id="Menu-Clients-Domain_Registration" href="{routePath('admin-domains-index')}" class="rail-link rail-child">
                                {$_ADMINLANG.services.listdomains}
                            </a>
                        </li>
                    {/if}
                    {if in_array("View Cancellation Requests",$admin_perms)}
                        <li>
                            <a id="Menu-Clients-Cancelation_Requests" href="cancelrequests.php" class="rail-link rail-child">
                                {$_ADMINLANG.clients.cancelrequests}
                            </a>
                        </li>
                    {/if}
                    {if in_array("Manage Affiliates",$admin_perms)}
                        <li>
                            <a id="Menu-Clients-Manage_Affiliates" href="affiliates.php" class="rail-link rail-child">
                                {$_ADMINLANG.affiliates.manage}
                            </a>
                        </li>
                    {/if}
                </ul>
            </li>

            {* ================= ORDERS ================= *}
            <li class="rail-group{if $sidebar eq 'orders'} open{/if}" data-nav-group="orders" data-test="admin-nav-orders">
                <a id="Menu-Orders" href="#" onclick="return false;" class="rail-link rail-group-toggle" data-nav-toggle aria-expanded="{if $sidebar eq 'orders'}true{else}false{/if}">
                    <i class="far fa-cart-shopping" aria-hidden="true"></i>
                    <span class="rail-label">{$_ADMINLANG.orders.title}</span>
                    <i class="fas fa-chevron-down rail-caret" aria-hidden="true"></i>
                </a>
                <ul class="rail-children">
                    {if in_array("View Orders",$admin_perms)}
                        <li>
                            <a id="Menu-Orders-List_All_Orders" href="orders.php" class="rail-link rail-child">
                                {$_ADMINLANG.orders.listall}
                            </a>
                        </li>
                        <li>
                            <a id="Menu-Orders-Pending_Orders" href="orders.php?status=Pending" class="rail-link rail-child">
                                {$_ADMINLANG.orders.listpending}
                            </a>
                        </li>
                        <li>
                            <a id="Menu-Orders-Active_Orders" href="orders.php?status=Active" class="rail-link rail-child">
                                {$_ADMINLANG.orders.listactive}
                            </a>
                        </li>
                        <li>
                            <a id="Menu-Orders-Fraud_Orders" href="orders.php?status=Fraud" class="rail-link rail-child">
                                {$_ADMINLANG.orders.listfraud}
                            </a>
                        </li>
                        <li>
                            <a id="Menu-Orders-Cancelled_Orders" href="orders.php?status=Cancelled" class="rail-link rail-child">
                                {$_ADMINLANG.orders.listcancelled}
                            </a>
                        </li>
                    {/if}
                    {if in_array("Add New Order",$admin_perms)}
                        <li>
                            <a id="Menu-Orders-Add_New_Order" href="ordersadd.php" class="rail-link rail-child">
                                {$_ADMINLANG.orders.addnew}
                            </a>
                        </li>
                    {/if}
                </ul>
            </li>

            {* ================= BILLING ================= *}
            <li class="rail-group{if $sidebar eq 'billing'} open{/if}" data-nav-group="billing" data-test="admin-nav-billing">
                <a id="Menu-Billing" href="#" onclick="return false;" class="rail-link rail-group-toggle" data-nav-toggle aria-expanded="{if $sidebar eq 'billing'}true{else}false{/if}">
                    <i class="far fa-file-invoice-dollar" aria-hidden="true"></i>
                    <span class="rail-label">{$_ADMINLANG.billing.title}</span>
                    <i class="fas fa-chevron-down rail-caret" aria-hidden="true"></i>
                </a>
                <ul class="rail-children">
                    {if in_array("List Transactions",$admin_perms)}
                        <li>
                            <a id="Menu-Billing-Transactions_List" href="transactions.php" class="rail-link rail-child">
                                {$_ADMINLANG.billing.transactionslist}
                            </a>
                        </li>
                    {/if}
                    {if in_array('List Credit and Debit Notes', $admin_perms)}
                        <li>
                            <a id="Menu-Billing-Credit_Debit_Notes" href="{routePath('admin-billing-billingnotes-index')}" class="rail-link rail-child">
                                {$_ADMINLANG.billingnotes.title}
                            </a>
                        </li>
                    {/if}
                    {if in_array("List Invoices",$admin_perms)}
                        <li class="rail-subgroup" data-nav-sub>
                            <div class="rail-subrow">
                                <a id="Menu-Billing-Invoices" href="invoices.php" class="rail-link rail-child">
                                    {$_ADMINLANG.invoices.title}
                                </a>
                                <button type="button" class="rail-subtoggle" data-nav-subtoggle aria-expanded="false" aria-label="{$_ADMINLANG.invoices.title}">
                                    <i class="fas fa-chevron-down" aria-hidden="true"></i>
                                </button>
                            </div>
                            <ul class="rail-subchildren">
                                <li><a id="Menu-Billing-Invoices-Paid" href="invoices.php?status=Paid" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.status.paid}</a></li>
                                <li><a id="Menu-Billing-Invoices-Draft" href="invoices.php?status=Draft" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.status.draft}</a></li>
                                <li><a id="Menu-Billing-Invoices-Unpaid" href="invoices.php?status=Unpaid" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.status.unpaid}</a></li>
                                <li><a id="Menu-Billing-Invoices-Overdue" href="invoices.php?status=Overdue" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.status.overdue}</a></li>
                                <li><a id="Menu-Billing-Invoices-Cancelled" href="invoices.php?status=Cancelled" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.status.cancelled}</a></li>
                                <li><a id="Menu-Billing-Invoices-Refunded" href="invoices.php?status=Refunded" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.status.refunded}</a></li>
                                <li><a id="Menu-Billing-Invoices-Collections" href="invoices.php?status=Collections" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.status.collections}</a></li>
                                <li><a id="Menu-Billing-Invoices-Payment_Pending" href="invoices.php?status=Payment%20Pending" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.status.paymentpending}</a></li>
                            </ul>
                        </li>
                    {/if}
                    {if in_array("View Billable Items",$admin_perms)}
                        <li class="rail-subgroup" data-nav-sub>
                            <div class="rail-subrow">
                                <a id="Menu-Billing-Billable_Items" href="billableitems.php" class="rail-link rail-child">
                                    {$_ADMINLANG.billableitems.title}
                                </a>
                                <button type="button" class="rail-subtoggle" data-nav-subtoggle aria-expanded="false" aria-label="{$_ADMINLANG.billableitems.title}">
                                    <i class="fas fa-chevron-down" aria-hidden="true"></i>
                                </button>
                            </div>
                            <ul class="rail-subchildren">
                                <li><a id="Menu-Billing-Billable_Items-Uninvoiced_Items" href="billableitems.php?status=Uninvoiced" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.billableitems.uninvoiced}</a></li>
                                <li><a id="Menu-Billing-Billable_Items-Recurring_Items" href="billableitems.php?status=Recurring" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.billableitems.recurring}</a></li>
                                {if in_array("Manage Billable Items",$admin_perms)}
                                    <li><a id="Menu-Billing-Billable_Items-Add_New" href="billableitems.php?action=manage" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.billableitems.addnew}</a></li>
                                {/if}
                            </ul>
                        </li>
                    {/if}
                    {if in_array("Manage Quotes",$admin_perms)}
                        <li class="rail-subgroup" data-nav-sub>
                            <div class="rail-subrow">
                                <a id="Menu-Billing-Quotes" href="quotes.php" class="rail-link rail-child">
                                    {$_ADMINLANG.quotes.title}
                                </a>
                                <button type="button" class="rail-subtoggle" data-nav-subtoggle aria-expanded="false" aria-label="{$_ADMINLANG.quotes.title}">
                                    <i class="fas fa-chevron-down" aria-hidden="true"></i>
                                </button>
                            </div>
                            <ul class="rail-subchildren">
                                <li><a id="Menu-Billing-Quotes-Valid" href="quotes.php?validity=Valid" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.status.valid}</a></li>
                                <li><a id="Menu-Billing-Quotes-Expired" href="quotes.php?validity=Expired" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.status.expired}</a></li>
                                <li><a id="Menu-Billing-Quotes-Create_New_Quote" href="quotes.php?action=manage" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.quotes.createnew}</a></li>
                            </ul>
                        </li>
                    {/if}
                    {if in_array("Offline Credit Card Processing",$admin_perms)}
                        <li>
                            <a id="Menu-Billing-Offline_CC_Processing" href="offlineccprocessing.php" class="rail-link rail-child">
                                {$_ADMINLANG.billing.offlinecc}
                            </a>
                        </li>
                    {/if}
                    {if in_array("List Disputes",$admin_perms)}
                        <li>
                            <a id="Menu-Billing-Disputes" href="{routePath('admin-billing-disputes-index')}" class="rail-link rail-child">
                                {$_ADMINLANG.disputes.title}
                            </a>
                        </li>
                    {/if}
                    {if in_array("View Gateway Log",$admin_perms)}
                        <li>
                            <a id="Menu-Billing-Gateway_Log" href="gatewaylog.php" class="rail-link rail-child">
                                {$_ADMINLANG.billing.gatewaylog}
                            </a>
                        </li>
                    {/if}
                </ul>
            </li>

            {* ================= SUPPORT ================= *}
            <li class="rail-group{if $sidebar eq 'support'} open{/if}" data-nav-group="support" data-test="admin-nav-support">
                <a id="Menu-Support" href="#" onclick="return false;" class="rail-link rail-group-toggle" data-nav-toggle aria-expanded="{if $sidebar eq 'support'}true{else}false{/if}">
                    <i class="far fa-headset" aria-hidden="true"></i>
                    <span class="rail-label">{$_ADMINLANG.support.title}</span>
                    <i class="fas fa-chevron-down rail-caret" aria-hidden="true"></i>
                </a>
                <ul class="rail-children">
                    {if in_array("Support Center Overview",$admin_perms)}
                        <li>
                            <a id="Menu-Support-Support_Overview" href="supportcenter.php" class="rail-link rail-child">
                                {$_ADMINLANG.support.supportoverview}
                            </a>
                        </li>
                    {/if}
                    {if in_array("List Support Tickets",$admin_perms)}
                        <li class="rail-subgroup" data-nav-sub>
                            <div class="rail-subrow">
                                <a id="Menu-Support-Support_Tickets" href="supporttickets.php" class="rail-link rail-child">
                                    {$_ADMINLANG.support.supporttickets}
                                </a>
                                <button type="button" class="rail-subtoggle" data-nav-subtoggle aria-expanded="false" aria-label="{$_ADMINLANG.support.supporttickets}">
                                    <i class="fas fa-chevron-down" aria-hidden="true"></i>
                                </button>
                            </div>
                            <ul class="rail-subchildren">
                                <li><a id="Menu-Support-Support_Tickets-Flagged_Tickets" href="supporttickets.php?view=flagged" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.support.flagged}</a></li>
                                <li><a id="Menu-Support-Support_Tickets-All_Active_Tickets" href="supporttickets.php?view=active" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.support.allactive}</a></li>
                                {foreach $menuticketstatuses as $status}
                                    <li><a id="Menu-Support-Support_Tickets-{$status|replace:' ':'_'}" href="supporttickets.php?view={$status}" class="rail-link rail-child rail-grandchild">{$status}</a></li>
                                {/foreach}
                            </ul>
                        </li>
                    {/if}
                    {if in_array("Open New Ticket",$admin_perms)}
                        <li>
                            <a id="Menu-Support-Open_New_Ticket" href="supporttickets.php?action=open" class="rail-link rail-child">
                                {$_ADMINLANG.support.opennewticket}
                            </a>
                        </li>
                    {/if}
                    {if in_array("Manage Predefined Replies",$admin_perms)}
                        <li>
                            <a id="Menu-Support-Predefined_Replies" href="supportticketpredefinedreplies.php" class="rail-link rail-child">
                                {$_ADMINLANG.support.predefreplies}
                            </a>
                        </li>
                    {/if}
                    {if in_array("Manage Announcements",$admin_perms)}
                        <li>
                            <a id="Menu-Support-Announcements" href="supportannouncements.php" class="rail-link rail-child">
                                {$_ADMINLANG.support.announcements}
                            </a>
                        </li>
                    {/if}
                    {if in_array("Manage Downloads",$admin_perms)}
                        <li>
                            <a id="Menu-Support-Downloads" href="supportdownloads.php" class="rail-link rail-child">
                                {$_ADMINLANG.support.downloads}
                            </a>
                        </li>
                    {/if}
                    {if in_array("Manage Knowledgebase",$admin_perms)}
                        <li>
                            <a id="Menu-Support-Knowledgebase" href="supportkb.php" class="rail-link rail-child">
                                {$_ADMINLANG.support.knowledgebase}
                            </a>
                        </li>
                    {/if}
                    {if in_array("Manage Network Issues",$admin_perms)}
                        <li class="rail-subgroup" data-nav-sub>
                            <div class="rail-subrow">
                                <a id="Menu-Support-Network_Issues" href="networkissues.php" class="rail-link rail-child" data-nav-noactive>
                                    {$_ADMINLANG.networkissues.title}
                                </a>
                                <button type="button" class="rail-subtoggle" data-nav-subtoggle aria-expanded="false" aria-label="{$_ADMINLANG.networkissues.title}">
                                    <i class="fas fa-chevron-down" aria-hidden="true"></i>
                                </button>
                            </div>
                            <ul class="rail-subchildren">
                                <li><a id="Menu-Support-Network_Issues-Open" href="networkissues.php" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.networkissues.open}</a></li>
                                <li><a id="Menu-Support-Network_Issues-Scheduled" href="networkissues.php?view=scheduled" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.networkissues.scheduled}</a></li>
                                <li><a id="Menu-Support-Network_Issues-Resolved" href="networkissues.php?view=resolved" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.networkissues.resolved}</a></li>
                                <li><a id="Menu-Support-Network_Issues-Create_New" href="networkissues.php?action=manage" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.networkissues.addnew}</a></li>
                            </ul>
                        </li>
                    {/if}
                </ul>
            </li>

            {* ================= REPORTS ================= *}
            {if in_array("View Reports",$admin_perms)}
                <li class="rail-group{if $sidebar eq 'reports'} open{/if}" data-nav-group="reports" data-test="admin-nav-reports">
                    <a id="Menu-Reports" href="#" onclick="return false;" class="rail-link rail-group-toggle" data-nav-toggle aria-expanded="{if $sidebar eq 'reports'}true{else}false{/if}">
                        <i class="far fa-chart-pie" aria-hidden="true"></i>
                        <span class="rail-label">{$_ADMINLANG.reports.title}</span>
                        <i class="fas fa-chevron-down rail-caret" aria-hidden="true"></i>
                    </a>
                    <ul class="rail-children">
                        <li><a id="Menu-Reports-Home" href="reports.php" class="rail-link rail-child">{$_ADMINLANG.reports.title}</a></li>
                        <li><a id="Menu-Reports-Daily_Performance" href="reports.php?report=daily_performance" class="rail-link rail-child">Daily Performance</a></li>
                        <li><a id="Menu-Reports-Income_Forecast" href="reports.php?report=income_forecast" class="rail-link rail-child">Income Forecast</a></li>
                        <li><a id="Menu-Reports-Annual_Income_Report" href="reports.php?report=annual_income_report" class="rail-link rail-child">Annual Income Report</a></li>
                        <li><a id="Menu-Reports-New_Customers" href="reports.php?report=new_customers" class="rail-link rail-child">New Customers</a></li>
                        <li><a id="Menu-Reports-Ticket_Feedback_Scores" href="reports.php?report=ticket_feedback_scores" class="rail-link rail-child">Ticket Feedback Scores</a></li>
                        <li><a id="Menu-Reports-Batch_Invoice_PDF_Export" href="reports.php?report=pdf_batch" class="rail-link rail-child">Batch Invoice PDF Export</a></li>
                        <li><a id="Menu-Reports-More..." href="reports.php" class="rail-link rail-child">More...</a></li>
                    </ul>
                </li>
            {/if}

            {* ================= UTILITIES ================= *}
            <li class="rail-group{if $sidebar eq 'utilities'} open{/if}" data-nav-group="utilities" data-test="admin-nav-utilities">
                <a id="Menu-Utilities" href="#" onclick="return false;" class="rail-link rail-group-toggle" data-nav-toggle aria-expanded="{if $sidebar eq 'utilities'}true{else}false{/if}">
                    <i class="far fa-screwdriver-wrench" aria-hidden="true"></i>
                    <span class="rail-label">{$_ADMINLANG.utilities.title}</span>
                    {if $showUpdateAvailable || (!$isNewInstallation && ($isCronError || $isCronWarning))}
                        <span class="rail-dot {if !$isNewInstallation && $isCronError}dot-danger{else}dot-warning{/if}" aria-hidden="true"></span>
                    {/if}
                    <i class="fas fa-chevron-down rail-caret" aria-hidden="true"></i>
                </a>
                <ul class="rail-children">
                    {if in_array("Update WHMCS",$admin_perms)}
                        <li>
                            <a id="Menu-Utilities-Update" href="update.php" class="rail-link rail-child">
                                {$_ADMINLANG.update.title}
                                {if $showUpdateAvailable}
                                    <span class="rail-dot dot-warning" aria-hidden="true"></span>
                                {/if}
                            </a>
                        </li>
                    {/if}
                    {if in_array("WHMCSConnect",$admin_perms)}
                        <li>
                            <a id="Menu-Utilities-WHMCS_Connect" href="whmcsconnect.php" class="rail-link rail-child">{$_ADMINLANG.whmcsConnect.whmcsConnectName}</a>
                        </li>
                    {/if}
                    {if in_array("Automation Status", $admin_perms)}
                        <li>
                            <a id="Menu-Utilities-System-Automation_Status" href="automationstatus.php" class="rail-link rail-child">
                                {$_ADMINLANG.utilities.automationStatus}
                                {if !$isNewInstallation && ($isCronError || $isCronWarning)}
                                    <span class="rail-dot {if $isCronError}dot-danger{else}dot-warning{/if}" aria-hidden="true"></span>
                                {/if}
                            </a>
                            {* Blend also exposes this action as a standalone top-bar icon with this id
                               (nav.tpl "right-nav"). Iris folds that into the link above, but the id is
                               addon-facing, so a hidden anchor keeps it resolvable for third-party code
                               that still targets it directly. *}
                            <a id="Menu-Automation-Status" href="automationstatus.php" class="hidden" aria-hidden="true" tabindex="-1"></a>
                        </li>
                    {/if}
                    {if in_array("View Module Queue", $admin_perms)}
                        <li>
                            <a id="Menu-Utilities-Module_Queue" href="modulequeue.php" class="rail-link rail-child">{$_ADMINLANG.utilities.moduleQueue}</a>
                        </li>
                    {/if}
                    {if in_array('Apps and Integrations', $admin_perms)}
                        <li>
                            <a id="Menu-Utilities-Sitejet_Builder" href="{routePath('admin-utilities-sitejet-builder-index')}" class="rail-link rail-child u-position-relative">
                                {$_ADMINLANG.utilities.sitejetBuilder.title}
                                <span class="label label-success sitejet-badge-new sitejet-success">
                                    {$_ADMINLANG.global.new}
                                </span>
                            </a>
                        </li>
                    {/if}
                    {if in_array("Configure Domain Pricing",$admin_perms)}
                        <li>
                            <a id="Menu-Utilities-Tld_Sync" href="{routePath('admin-utilities-tools-tld-import-step-one')}" class="rail-link rail-child">{$_ADMINLANG.utilities.tldImport}</a>
                        </li>
                    {/if}
                    {if in_array("Mass Mail",$admin_perms)}
                        <li>
                            <a id="Menu-Utilities-Email_Campaigns" href="{routePath('admin-utilities-tools-email-campaigns')}" class="rail-link rail-child">{lang key='utilities.emailCampaigns.title'}</a>
                        </li>
                    {/if}
                    {if in_array("Email Marketer",$admin_perms)}
                        <li>
                            <a id="Menu-Utilities-Email_Marketer" href="utilitiesemailmarketer.php" class="rail-link rail-child">{$_ADMINLANG.utilities.emailmarketer}</a>
                        </li>
                    {/if}
                    {if in_array("Link Tracking",$admin_perms)}
                        <li>
                            <a id="Menu-Utilities-Link_Tracking" href="utilitieslinktracking.php" class="rail-link rail-child">{$_ADMINLANG.utilities.linktracking}</a>
                        </li>
                    {/if}
                    {if in_array("Calendar",$admin_perms)}
                        <li>
                            <a id="Menu-Utilities-Calendar" href="calendar.php" class="rail-link rail-child">{$_ADMINLANG.utilities.calendar}</a>
                        </li>
                    {/if}
                    {if in_array("To-Do List",$admin_perms)}
                        <li>
                            <a id="Menu-Utilities-To-Do_List" href="todolist.php" class="rail-link rail-child">{$_ADMINLANG.utilities.todolist}</a>
                        </li>
                    {/if}
                    {if in_array("WHOIS Lookups",$admin_perms)}
                        <li>
                            <a id="Menu-Utilities-WHOIS_Lookups" href="whois.php" class="rail-link rail-child">{$_ADMINLANG.utilities.whois}</a>
                        </li>
                    {/if}
                    {if in_array("Domain Resolver Checker",$admin_perms)}
                        <li>
                            <a id="Menu-Utilities-Domain_Resolver" href="utilitiesresolvercheck.php" class="rail-link rail-child">{$_ADMINLANG.utilities.domainresolver}</a>
                        </li>
                    {/if}
                    {if in_array("View Integration Code",$admin_perms)}
                        <li>
                            <a id="Menu-Utilities-Integration_Code" href="systemintegrationcode.php" class="rail-link rail-child">{$_ADMINLANG.utilities.integrationcode}</a>
                        </li>
                    {/if}
                    {if in_array("Automation Status", $admin_perms) || in_array("Database Status", $admin_perms) || in_array("System Cleanup Operations", $admin_perms) || in_array("View PHP Info", $admin_perms)}
                        <li class="rail-subgroup" data-nav-sub>
                            <div class="rail-subrow">
                                <a id="Menu-Utilities-System" href="#" onclick="return false;" class="rail-link rail-child" data-nav-subtoggle>
                                    {$_ADMINLANG.utilities.system}
                                </a>
                                <button type="button" class="rail-subtoggle" data-nav-subtoggle aria-expanded="false" aria-label="{$_ADMINLANG.utilities.system}">
                                    <i class="fas fa-chevron-down" aria-hidden="true"></i>
                                </button>
                            </div>
                            <ul class="rail-subchildren">
                                {if in_array("Database Status",$admin_perms)}
                                    <li><a id="Menu-Utilities-System-Database_Status" href="systemdatabase.php" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.utilities.dbstatus}</a></li>
                                {/if}
                                {if in_array("System Cleanup Operations",$admin_perms)}
                                    <li><a id="Menu-Utilities-System-System_Cleanup" href="systemcleanup.php" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.utilities.syscleanup}</a></li>
                                {/if}
                                {if in_array("View PHP Info",$admin_perms)}
                                    <li><a id="Menu-Utilities-System-PHP_Info" href="systemphpinfo.php" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.utilities.phpinfo}</a></li>
                                {/if}
                                {if in_array("View PHP Info",$admin_perms)}
                                    <li><a id="Menu-Utilities-System-PhpCompat" href="{routePath('admin-utilities-system-phpcompat')}" class="rail-link rail-child rail-grandchild">{$_ADMINLANG.utilities.phpcompat}</a></li>
                                {/if}
                            </ul>
                        </li>
                    {/if}
                </ul>
            </li>

            {* ================= ADDONS section ================= *}
            <li class="rail-group rail-section{if $sidebar eq 'addonmodules'} open{/if}" data-nav-group="addons" data-test="admin-nav-addons">
                <a id="Menu-Addons" href="#" onclick="return false;" class="rail-section-toggle" data-nav-toggle aria-expanded="{if $sidebar eq 'addonmodules'}true{else}false{/if}">
                    <span class="rail-section-label">{$_ADMINLANG.utilities.addonmodules}</span>
                    <i class="fas fa-chevron-down rail-caret" aria-hidden="true"></i>
                </a>
                <ul class="rail-children">
                    {foreach from=$addon_modules key=module item=displayname}
                        <li>
                            <a id="Menu-Addons-{$displayname}" href="addonmodules.php?module={$module}" class="rail-link rail-child">{$displayname}</a>
                        </li>
                        {foreachelse}
                        <li>
                            <a id="Menu-Addons-AppsAndIntegrations" href="{routePath('admin-apps-index')}" class="rail-link rail-child">{$_ADMINLANG.setup.appsAndIntegrations}</a>
                        </li>
                        <li>
                            <a id="Menu-Addons-Marketplace-Link" class="rail-link rail-child autoLinked" href="https://marketplace.whmcs.com">Visit WHMCS Marketplace</a>
                        </li>
                    {/foreach}
                </ul>
            </li>
        </ul>

        {* ---- pinned bottom group ---- *}
        <ul class="rail-root rail-pinned">
            <li class="rail-item" data-test="admin-nav-marketplace">
                <a href="{routePath('admin-apps-index')}" class="rail-link rail-leaf">
                    <i class="far fa-store" aria-hidden="true"></i>
                    <span class="rail-label">{$_ADMINLANG.setup.appsAndIntegrations}</span>
                </a>
            </li>
            <li class="rail-group{if $sidebar eq 'config' || $sidebar eq 'logs'} open{/if}" data-nav-group="settings" data-test="admin-nav-settings">
                <a id="Menu-Setup" href="#" onclick="return false;" class="rail-link rail-group-toggle" data-nav-toggle aria-expanded="{if $sidebar eq 'config' || $sidebar eq 'logs'}true{else}false{/if}">
                    <i class="far fa-wrench" aria-hidden="true"></i>
                    <span class="rail-label">{$_ADMINLANG.setup.config}</span>
                    <i class="fas fa-chevron-down rail-caret" aria-hidden="true"></i>
                </a>
                <ul class="rail-children">
                    {if $hasSetupMenuAccess}
                        <li>
                            <a id="Menu-Config-Setup" href="{routePath('admin-setup-index')}" class="rail-link rail-child">{$_ADMINLANG.setup.title}</a>
                        </li>
                    {/if}
                    <li>
                        <a id="Menu-Config-Apps-Integrations" href="{routePath('admin-apps-index')}" class="rail-link rail-child">{$_ADMINLANG.setup.appsAndIntegrations}</a>
                    </li>
                    {if in_array("Configure Administrators",$admin_perms)}
                        <li>
                            <a id="Menu-Config-Admins" href="configadmins.php" class="rail-link rail-child">{$_ADMINLANG.config.manageAdmins}</a>
                        </li>
                    {/if}
                    {if in_array("Health and Updates", $admin_perms)}
                        <li>
                            <a id="Menu-Config-HealthStatus" href="systemhealthandupdates.php" class="rail-link rail-child">{$_ADMINLANG.healthCheck.menuTitle}</a>
                        </li>
                    {/if}
                    {if in_array("Configure General Settings",$admin_perms)}
                        <li>
                            <a id="Menu-Config-SetupWizard" href="{routePath('admin-getting-started-index')}" class="rail-link rail-child">{$_ADMINLANG.help.setupWizard}</a>
                        </li>
                    {/if}
                    {if in_array("View Activity Log",$admin_perms) || in_array("View Admin Log",$admin_perms) || in_array("View Module Debug Log",$admin_perms) || in_array("View Email Message Log",$admin_perms) || in_array("View Ticket Mail Import Log",$admin_perms) || in_array("View WHOIS Lookup Log",$admin_perms)}
                        <li class="rail-subgroup" data-nav-sub>
                            <div class="rail-subrow">
                                <a id="Menu-Config-SysLogs" href="#" onclick="return false;" class="rail-link rail-child" data-nav-subtoggle>{$_ADMINLANG.config.sysLogs}</a>
                                <button type="button" class="rail-subtoggle" data-nav-subtoggle aria-expanded="false" aria-label="{$_ADMINLANG.config.sysLogs}">
                                    <i class="fas fa-chevron-down" aria-hidden="true"></i>
                                </button>
                            </div>
                            <ul class="rail-subchildren">
                                {if in_array("View Activity Log",$admin_perms)}
                                    <li>
                                        <a id="Menu-Config-SysLogs-Activity_Log" href="systemactivitylog.php" class="rail-link rail-child rail-grandchild">
                                            {$_ADMINLANG.utilities.activitylog}
                                        </a>
                                    </li>
                                {/if}
                                {if in_array("View Admin Log",$admin_perms)}
                                    <li>
                                        <a id="Menu-Config-SysLogs-Admin_Log" href="systemadminlog.php" class="rail-link rail-child rail-grandchild">
                                            {$_ADMINLANG.utilities.adminlog}
                                        </a>
                                    </li>
                                {/if}
                                {if in_array("View Module Debug Log",$admin_perms)}
                                    <li>
                                        <a id="Menu-Config-SysLogs-Module_Log" href="{routePath('admin-logs-module-log')}" class="rail-link rail-child rail-grandchild">
                                            {$_ADMINLANG.utilities.modulelog}
                                        </a>
                                    </li>
                                {/if}
                                {if in_array("View Email Message Log",$admin_perms)}
                                    <li>
                                        <a id="Menu-Config-SysLogs-Email_Message_Log" href="systememaillog.php" class="rail-link rail-child rail-grandchild">
                                            {$_ADMINLANG.utilities.emaillog}
                                        </a>
                                    </li>
                                {/if}
                                {if in_array("View Ticket Mail Import Log",$admin_perms)}
                                    <li>
                                        <a id="Menu-Config-SysLogs-Ticket_Mail_Import_Log" href="{routePath('admin-logs-mail-import-log')}" class="rail-link rail-child rail-grandchild">
                                            {$_ADMINLANG.utilities.ticketmaillog}
                                        </a>
                                    </li>
                                {/if}
                                {if in_array("View WHOIS Lookup Log",$admin_perms)}
                                    <li>
                                        <a id="Menu-Config-SysLogs-WHOIS_Lookup_Log" href="systemwhoislog.php" class="rail-link rail-child rail-grandchild">
                                            {$_ADMINLANG.utilities.whoislog}
                                        </a>
                                    </li>
                                {/if}
                            </ul>
                        </li>
                    {/if}
                </ul>
            </li>
            <li class="rail-group" data-nav-group="help" data-test="admin-nav-help">
                <a id="Menu-Help" href="#" onclick="return false;" class="rail-link rail-group-toggle" data-nav-toggle aria-expanded="false">
                    <i class="far fa-circle-question" aria-hidden="true"></i>
                    <span class="rail-label">{$_ADMINLANG.help.title}</span>
                    <i class="fas fa-chevron-down rail-caret" aria-hidden="true"></i>
                </a>
                <ul class="rail-children">
                    <li><a href="https://docs.whmcs.com/{$helplink}" target="_blank" class="rail-link rail-child">{$_ADMINLANG.help.docs}</a></li>
                    <li><a href="systemsupportrequest.php" class="rail-link rail-child">{$_ADMINLANG.help.techSupport}</a></li>
                    <li><a id="Menu-Help-Community_Forums" href="https://whmcs.community/?utm_source=InApp&utm_medium=Help_Menu" target="_blank" class="rail-link rail-child">{$_ADMINLANG.help.forums}</a></li>
                    {if in_array("View What's New",$admin_perms)}
                        <li><a href="javascript:openFeatureHighlights()" class="rail-link rail-child">{$_ADMINLANG.whatsNew.menuTitle}</a></li>
                    {/if}
                    {if in_array("Main Homepage",$admin_perms)}
                        <li><a href="{routePath('admin-help-license')}" class="rail-link rail-child">{$_ADMINLANG.help.licenseinfo}</a></li>
                    {/if}
                </ul>
            </li>
        </ul>
    </nav>

    {* ---- sidebar footer: account menu (opens upward) + utility actions ---- *}
    <div class="rail-footer">
        <div class="rail-footer-item has-dropdown rail-account" data-dropdown data-test="admin-account">
            {assign var="authenticatedAdmin" value=\WHMCS\User\Admin::getAuthenticatedUser()}
            {assign var="gravatarHash" value=""}
            {if (!empty($authenticatedAdmin->email))}
                {assign var="gravatarHash" value=md5($authenticatedAdmin->email)}
            {/if}
            <a id="Menu-Account" href="#" onclick="return false;" class="rail-account-btn" data-dropdown-btn
               aria-haspopup="true" aria-expanded="false">
                <img src="https://www.gravatar.com/avatar/{$gravatarHash}?s=72&d=mp" class="profile-icon"
                     alt="{if !empty($authenticatedAdmin->fullName)}{$authenticatedAdmin->fullName}{else}{$_ADMINLANG.account}{/if}"/>
            </a>
            <ul class="rail-dropdown rail-account-menu" data-dropdown-menu>
                <li class="rail-account-header">
                    <img src="https://www.gravatar.com/avatar/{$gravatarHash}?s=72&d=mp" alt="" aria-hidden="true"/>
                    <span class="rail-account-id">
                        <span class="rail-account-name">{if !empty($authenticatedAdmin->fullName)}{$authenticatedAdmin->fullName}{else}{$_ADMINLANG.account}{/if}</span>
                        {if !empty($authenticatedAdmin->email)}<span class="rail-account-email">{$authenticatedAdmin->email}</span>{/if}
                    </span>
                </li>
                <li class="rail-dropdown-divider" role="separator"></li>
                <li><a href="myaccount.php">{$_ADMINLANG.global.myaccount}</a></li>
                <li><a href="#" data-toggle="modal" data-target="#modalMyNotes">{$_ADMINLANG.global.mynotes}</a></li>
                <li class="rail-dropdown-divider" role="separator"></li>
                <li><a href="../">{$_ADMINLANG.global.clientarea}</a></li>
                <li class="rail-account-logout"><a id="Menu-Account-Logout" href="logout.php">{$_ADMINLANG.global.logout}</a></li>
            </ul>
        </div>

        <div class="rail-footer-actions">
        {if $showUpdateAvailable}
            <a href="update.php" class="rail-icon-btn rail-update-btn" title="{$_ADMINLANG.license.updateavailable}">
                <i class="far fa-download" aria-hidden="true"></i>
                <span>{$_ADMINLANG.global.updateAvailabile}</span>
            </a>
        {/if}

        <button type="button" class="rail-icon-btn iris-appearance-toggle" data-iris-appearance
                aria-label="Appearance: Light. Switch to Dark" title="Appearance: Light. Switch to Dark">
            <svg data-iris-appearance-icon viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" focusable="false">
                <path d="M20.5 13A8.5 8.5 0 0 1 11 3.5 8.5 8.5 0 1 0 20.5 13Z" />
            </svg>
        </button>
        <div class="rail-footer-item has-dropdown staff-dropdown" data-dropdown>
            <a id="Menu-Staff" href="#" onclick="return false;" class="rail-icon-btn rail-staff-btn" data-dropdown-btn
               aria-haspopup="true" aria-expanded="false"
               title="({$admins_online_list|default:[]|@count}) {$_ADMINLANG.global.staffonline}">
                <i class="far fa-users" aria-hidden="true"></i>
                <span class="rail-staff-count">({$admins_online_list|default:[]|@count})</span>
            </a>
            <ul class="rail-dropdown rail-dropdown-staff" data-dropdown-menu>
                <li class="staff-dropdown-wrapper">
                    <div class="staff-header">
                        <span class="staff-title">{$_ADMINLANG.support.staff}</span>
                        {if in_array("Configure Administrators",$admin_perms)}
                            <a href="configadmins.php" class="staff-manage-btn">{$_ADMINLANG.setup.staff}</a>
                        {/if}
                    </div>

                    <div class="staff-content">
                        {if !empty($admins_online_list)}
                            <div class="staff-section-title">{$_ADMINLANG.global.online}</div>
                            {foreach $admins_online_list as $adminKey => $adminData}
                                <div class="staff-member-accordion">
                                    <div class="staff-member"
                                         onclick="toggleStaffAccordion(event, this)"
                                         role="button"
                                         tabindex="0"
                                         aria-expanded="false"
                                         aria-controls="staff-details-{$adminData.admin.id}"
                                         aria-label="{$adminData.admin.fullName}"
                                         onkeydown="if(event.key==='Enter'||event.key===' ') toggleStaffAccordion(event, this)">
                                        <div class="staff-member-left">
                                            <div class="staff-icon-wrap">
                                                <i class="far fa-circle-user" aria-hidden="true"></i>
                                                <span class="status-badge online" aria-label="{$_ADMINLANG.global.online}"></span>
                                            </div>
                                            <span class="staff-name">{$adminData.admin.fullName}</span>
                                        </div>
                                        <div class="staff-member-right">
                                            <i class="far fa-plus staff-plus-icon" aria-hidden="true"></i>
                                        </div>
                                    </div>
                                    <div class="staff-accordion-details"
                                         id="staff-details-{$adminData.admin.id}"
                                         role="region"
                                         aria-labelledby="staff-member-{$adminData.admin.id}">
                                        <div class="staff-status-info">
                                            <div class="staff-status-text">{$_ADMINLANG.global.online}</div>
                                            <div class="staff-time-text">{$adminData.last_visit_formatted}</div>
                                        </div>
                                        {if in_array("Configure Administrators",$admin_perms)}
                                            <a href="configadmins.php?action=manage&id={$adminData.admin.id}" class="staff-manage-link">{$_ADMINLANG.global.manageMember}</a>
                                        {/if}
                                    </div>
                                </div>
                            {/foreach}
                        {/if}

                        {if !empty($admins_offline_list)}
                            <div class="staff-section-title">{$_ADMINLANG.global.lastActive}</div>
                            {foreach $admins_offline_list as $adminKey => $adminData}
                                <div class="staff-member-accordion">
                                    <div class="staff-member"
                                         onclick="toggleStaffAccordion(event, this)"
                                         role="button"
                                         tabindex="0"
                                         aria-expanded="false"
                                         aria-controls="staff-details-{$adminData.admin.id}"
                                         aria-label="{$adminData.admin.fullName}"
                                         onkeydown="if(event.key==='Enter'||event.key===' ') toggleStaffAccordion(event, this)">
                                        <div class="staff-member-left">
                                            <div class="staff-icon-wrap">
                                                <i class="far fa-circle-user" aria-hidden="true"></i>
                                                <span class="status-badge offline" aria-label="{$_ADMINLANG.global.lastActive}"></span>
                                            </div>
                                            <span class="staff-name">{$adminData.admin.fullName}</span>
                                        </div>
                                        <div class="staff-member-right">
                                            <i class="far fa-plus staff-plus-icon" aria-hidden="true"></i>
                                        </div>
                                    </div>
                                    <div class="staff-accordion-details"
                                         id="staff-details-{$adminData.admin.id}"
                                         role="region"
                                         aria-labelledby="staff-member-{$adminData.admin.id}">
                                        <div class="staff-status-info">
                                            <div class="staff-status-text">{$_ADMINLANG.global.lastActive}</div>
                                            <div class="staff-time-text">{$adminData.last_visit_formatted}</div>
                                        </div>
                                        {if in_array("Configure Administrators",$admin_perms)}
                                            <a href="configadmins.php?action=manage&id={$adminData.admin.id}" class="staff-manage-link">{$_ADMINLANG.global.manageMember}</a>
                                        {/if}
                                    </div>
                                </div>
                            {/foreach}
                        {/if}
                    </div>
                </li>
            </ul>
        </div>

        </div>
    </div>
</aside>

{* ---- mobile header (below lg): brand + drawer trigger ---- *}
<div class="mobile-header">
    <a href="index.php" class="rail-brand" title="{$_ADMINLANG.home.title}">
        <img src="{$irisProLogoLightUrl|escape:'html'}" data-iris-logo-light="{$irisProLogoLightUrl|escape:'html'}" data-iris-logo-dark="{$irisProLogoDarkUrl|escape:'html'}" alt="WHMCS">
    </a>
    <button type="button" class="mobile-rail-toggle" id="railToggle" aria-controls="adminNavRail" aria-expanded="false" aria-label="{$_ADMINLANG.home.title}">
        <i class="far fa-bars" aria-hidden="true"></i>
    </button>
</div>

<script>
function toggleStaffAccordion(event, element) {
    if (event) {
        event.preventDefault();
        event.stopPropagation();
    }

    const accordion = element.closest('.staff-member-accordion');
    if (!accordion) return;

    const details = accordion.querySelector('.staff-accordion-details');
    const icon = accordion.querySelector('.staff-plus-icon');

    if (!details || !icon) return;

    const isOpen = element.getAttribute('aria-expanded') === 'true';

    // Close all other accordions
    document.querySelectorAll('.staff-member[aria-expanded="true"]').forEach(member => {
        member.setAttribute('aria-expanded', 'false');
        const memberAccordion = member.closest('.staff-member-accordion');
        const memberDetails = memberAccordion.querySelector('.staff-accordion-details');
        const memberIcon = memberAccordion.querySelector('.staff-plus-icon');

        memberDetails.style.display = 'none';
        memberIcon.className = 'far fa-plus staff-plus-icon';
    });

    // Toggle current accordion
    if (!isOpen) {
        element.setAttribute('aria-expanded', 'true');
        details.style.display = 'block';
        icon.className = 'far fa-minus staff-plus-icon';
    } else {
        element.setAttribute('aria-expanded', 'false');
        details.style.display = 'none';
        icon.className = 'far fa-plus staff-plus-icon';
    }
}
</script>
