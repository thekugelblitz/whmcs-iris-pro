<form method="post" action="{routePath('admin-notes-save')}" id="frmMyNotes">
    <input type="hidden" name="action" value="savenotes" />
    <input type="hidden" name="token" value="{$csrfToken}" />
    <div class="modal fade modal-my-notes" id="modalMyNotes">
        <div class="modal-dialog">
            <div class="modal-content panel-primary">
                <div class="modal-header panel-heading">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">{$_ADMINLANG.global.mynotes}</h4>
                </div>
                <div class="modal-body">
                    <textarea id="mynotesbox" name="notes" rows="12" class="form-control">{$admin_notes}</textarea>
                </div>
                <div class="modal-footer panel-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">{$_ADMINLANG.global.cancel}</button>
                    <button type="submit" class="btn btn-primary" id="btnMyNotesSave">{$_ADMINLANG.global.savechanges}</button>
                </div>
            </div>
        </div>
    </div>
</form>

{if $clientLimitNotification}
    <div class="client-limit-notification client-limit-notification-form panel panel-{$clientLimitNotification.class}" id="clientLimitNotification">
        <div class="panel-heading">
            <button type="button" class="close" id="btnClientLimitNotificationDismiss"><span aria-hidden="true">&times;</span></button>
            <h3 class="panel-title">
                <i class="fas {$clientLimitNotification.icon}"></i>
                <span>{$clientLimitNotification.title}</span>
                <small>({$clientLimitNotification.numberOfActiveClients} / {$clientLimitNotification.clientLimit})</small>
            </h3>
        </div>
        <div class="panel-body">
            <p>{$clientLimitNotification.body}</p>
            <form method="post" action="{$clientLimitNotification.upgradeUrl}" target="_blank" data-fetch-url="{routePath('admin-help-license-upgrade-data')}">
                <input type="hidden" name="token" value="{$csrfToken}">
                <input type="hidden" name="getupgradedata" value="1">
                <input type="hidden" name="license_key" value="" class="input-license-key">
                <input type="hidden" name="member_data" value="" class="input-member-data">
                <div class="links">
                    <a href="#" id="btnClientLimitNotificationDontShowAgain" class="btn btn-xs btn-link pull-right">Don't show this again</a>
                    <button type="submit" class="btn btn-xs btn-{$clientLimitNotification.class}{if $clientLimitNotification.autoUpgradeEnabled} hidden{/if}" id="btnClientLimitNotificationUpgrade">Upgrade Now</button>
                    {if $clientLimitNotification.learnMoreUrl}
                        <a href="{$clientLimitNotification.learnMoreUrl}" class="btn btn-xs {if $clientLimitNotification.autoUpgradeEnabled}btn-{$clientLimitNotification.class}{else}btn-link{/if}" target="_blank">Learn more &raquo;</a>
                    {/if}
                </div>
            </form>
        </div>
    </div>
{/if}

<div class="modal whmcs-modal fade" id="modalAjax" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content panel panel-primary">
            <div class="modal-header panel-heading" id="modalAjaxHeader">
                <button id="modalAjaxCloseSmall" type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">&times;</span>
                    <span class="sr-only">{$_ADMINLANG.global.close}</span>
                </button>
                <h4 class="modal-title" id="modalAjaxTitle"></h4>
            </div>
            <div class="modal-body panel-body" id="modalAjaxBody">
                {$_ADMINLANG.global.loading}
            </div>
            <div class="modal-footer panel-footer" id="modalAjaxFooter">
                <div id="modalFooterLeft"></div>
                <div class="pull-left loader" id="modalAjaxLoader">
                    <i class="fas fa-circle-notch fa-spin"></i>
                    {$_ADMINLANG.global.loading}
                </div>
                <button id="modalAjaxClose" type="button" class="btn btn-default" data-dismiss="modal">
                    {$_ADMINLANG.global.close}
                </button>
                <button type="button" class="btn btn-primary modal-submit" id="modalAjaxSubmit">
                    {$_ADMINLANG.global.submit}
                </button>
            </div>
        </div>
    </div>
</div>

{if in_array("Main Homepage", $admin_perms) && in_array("Generate Due Invoices", $admin_perms)}
    <div class="modal fade" id="modalRailGenerateInvoices" tabindex="-1" role="dialog" aria-labelledby="RailGenerateInvoicesLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content panel panel-primary">
                <div class="modal-header panel-heading">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                        <span class="sr-only">{$_ADMINLANG.global.close}</span>
                    </button>
                    <h4 class="modal-title" id="RailGenerateInvoicesLabel">{$_ADMINLANG.invoices.geninvoices}</h4>
                </div>
                <div class="modal-body panel-body">
                    {$_ADMINLANG.invoices.geninvoicessendemails}
                </div>
                <div class="modal-footer panel-footer">
                    <a class="btn btn-primary" id="btnRailGenerateInvoicesYes"
                       href="index.php?generateinvoices=true&amp;token={$csrfToken}">
                        {$_ADMINLANG.global.yes}
                    </a>
                    <a class="btn btn-default" id="btnRailGenerateInvoicesNo"
                       href="index.php?generateinvoices=true&amp;noemails=true&amp;token={$csrfToken}">
                        {$_ADMINLANG.global.no}
                    </a>
                </div>
            </div>
        </div>
    </div>
{/if}

{if in_array("Main Homepage", $admin_perms) && in_array("Attempts CC Captures", $admin_perms)}
    <div class="modal fade" id="modalRailCreditCardCapture" tabindex="-1" role="dialog" aria-labelledby="RailCreditCardCaptureLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content panel panel-primary">
                <div class="modal-header panel-heading">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                        <span class="sr-only">{$_ADMINLANG.global.close}</span>
                    </button>
                    <h4 class="modal-title" id="RailCreditCardCaptureLabel">{$_ADMINLANG.invoices.attemptcccaptures}</h4>
                </div>
                <div class="modal-body panel-body">
                    {$_ADMINLANG.invoices.attemptcccapturessure}
                </div>
                <div class="modal-footer panel-footer">
                    <a class="btn btn-primary" id="btnRailCreditCardCaptureYes"
                       href="index.php?attemptccpayments=true&amp;token={$csrfToken}">
                        {$_ADMINLANG.global.yes}
                    </a>
                    <button type="button" class="btn btn-default" id="btnRailCreditCardCaptureNo" data-dismiss="modal">
                        {$_ADMINLANG.global.no}
                    </button>
                </div>
            </div>
        </div>
    </div>
{/if}

<div class="modal fade modal-adv-search" id="modalRailAdvSearch" tabindex="-1" role="dialog"
     aria-labelledby="RailAdvSearchLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content panel panel-primary">
            <form method="get" action="search.php">
                <div class="modal-header panel-heading">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span>
                        <span class="sr-only">{$_ADMINLANG.global.close}</span>
                    </button>
                    <h4 class="modal-title" id="RailAdvSearchLabel">{$_ADMINLANG.global.advancedsearch}</h4>
                </div>
                <div class="modal-body panel-body">
                    <div class="adv-search-scope">
                        <div class="adv-search-field">
                            <label for="searchtype">{$_ADMINLANG.redesign.searchType}</label>
                            <select name="type" id="searchtype" onchange="populate(this)" class="form-control">
                                <option value="clients">Clients</option>
                                <option value="orders">Orders</option>
                                <option value="services">Services</option>
                                <option value="domains">Domains</option>
                                <option value="invoices">Invoices</option>
                                <option value="tickets">Tickets</option>
                            </select>
                        </div>
                        <div class="adv-search-field">
                            <label for="searchfield">{$_ADMINLANG.redesign.searchField}</label>
                            <select name="field" id="searchfield" class="form-control">
                                <option>Client ID</option>
                                <option selected="selected">Client Name</option>
                                <option>Company Name</option>
                                <option>Email Address</option>
                                <option>Address 1</option>
                                <option>Address 2</option>
                                <option>City</option>
                                <option>State</option>
                                <option>Postcode</option>
                                <option>Country</option>
                                <option>Phone Number</option>
                                <option>CC Last Four</option>
                            </select>
                        </div>
                    </div>
                    <div class="adv-search-field">
                        <label for="inputRailAdvSearchTerm">{$_ADMINLANG.global.search}</label>
                        <input type="text" name="q" id="inputRailAdvSearchTerm" class="form-control"
                               autocomplete="off">
                    </div>
                </div>
                <div class="modal-footer panel-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        {$_ADMINLANG.global.cancel}
                    </button>
                    <button type="submit" class="btn btn-primary" id="btnRailAdvSearchSubmit">
                        {$_ADMINLANG.global.search}
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
