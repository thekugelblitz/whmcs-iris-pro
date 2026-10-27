<script>
    function reloadTablePayMethods() {
        WHMCS.http.jqClient.post(
            '{routePath('admin-client-paymethods-html-rows', $client.id)}',
            {
                token: csrfToken
            },
            function(data) {
                jQuery('#tablePayMethods').html(data.body);
            },
            'json'
    );
    }
</script>
<div class="clientssummarybox">
    <div class="title">Pay Methods</div>
    <table id="tablePayMethods" class="clientssummarystats" cellspacing="0" cellpadding="2">
        {$payMethodRows}
    </table>
    <ul class="cs-actions">
        {if $addNewCardUrl}
            <li id="liAddCcPayMethod">
                <a id="btnAddCcPayMethod"
                   href="{$addNewCardUrl}"
                   data-modal-title="Add Pay Method - Credit Card"
                   data-btn-submit-id="btnSave"
                   data-btn-submit-label="Save"
                   onclick="return false;"
                   class="open-modal">
                    <i class="far fa-plus fa-fw" aria-hidden="true"></i>
                    Add Credit Card
                </a>
            </li>
        {/if}
        {if $addNewBankAccountUrl}
            <li id="liAddBankAccountPayMethod">
                <a id="btnAddBankAccountPayMethod"
                   href="{$addNewBankAccountUrl}"
                   data-modal-title="Add Pay Method - Bank Account"
                   data-btn-submit-id="btnSave"
                   data-btn-submit-label="Save"
                   onclick="return false;"
                   class="open-modal">
                    <i class="far fa-plus fa-fw" aria-hidden="true"></i>
                    Add Bank Account
                </a>
            </li>
        {/if}
        {if !$addNewCardUrl && !$addNewBankAccountUrl}
            <li>
                <a id="btnNoGateways"
                   role="button"
                   data-toggle="tooltip"
                   data-container="body"
                   data-placement="right auto"
                   data-trigger="hover"
                   class="disabled"
                   title="You must activate at least one merchant gateway before you can add a credit card. For local card storage without a payment gateway, use the Offline Credit Card gateway."
                >
                    <i class="far fa-plus fa-fw" aria-hidden="true"></i>
                    Add Credit Card
                </a>
            </li>
        {/if}
    </ul>
</div>
