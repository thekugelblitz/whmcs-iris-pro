{* Ticket Info panel — all that is left of the legacy sidebar. Included by
   header.tpl on the ticket view only. *}
<div class="sidebar-header">
    <i class="fas fa-comment-alt-check"></i>
    {$_ADMINLANG.support.ticketinfo}
</div>
<div class="content-padded">
    <span class="sub-header">{$_ADMINLANG.fields.owner}</span>
    <div class="bottom-margin-5">
        {if $userid}
            <a href="clientssummary.php?userid={$userid}"{if $clientgroupcolour} style="background-color:{$clientgroupcolour}"{/if}
               target="_blank">
                {$clientname}
            </a>
            {if $contactid}
                (
                <a href="clientscontacts.php?userid={$userid}&contactid={$contactid}"{if $clientgroupcolour} style="background-color:{$clientgroupcolour}"{/if}
                   target="_blank">{$contactname}</a>
                )
            {/if}
        {else}
            <a href="{$SCRIPT_NAME}?email={$email|urlencode}">{$name}</a>
            <br/>
            <div class="truncate" title="{$email}">{$email}</div>
        {/if}
    </div>

    <span class="sub-header">
        {$_ADMINLANG.fields.requestor}
    </span>
    <div class="bottom-margin-5">
        <div class="identity-line">
            {$requestor.name}
            <span class="label requestor-type-{$requestor.type_normalised}">
                {if $requestor.type_normalised eq 'operator'}
                    {lang key='support.requestor.operator'}
                {elseif $requestor.type_normalised eq 'owner'}
                    {lang key='support.requestor.owner'}
                {elseif $requestor.type_normalised eq 'authorizeduser'}
                    {lang key='support.requestor.authorizeduser'}
                {elseif $requestor.type_normalised eq 'registereduser'}
                    {lang key='support.requestor.registereduser'}
                {elseif $requestor.type_normalised eq 'subaccount'}
                    {lang key='support.requestor.subaccount'}
                {elseif $requestor.type_normalised eq 'guest'}
                    {lang key='support.requestor.guest'}
                {/if}
            </span>
        </div>
        {if $requestor.email}
            <div class="small truncate" title="{$requestor.email}">{$requestor.email}</div>
        {/if}
    </div>

    <span class="sub-header">{$_ADMINLANG.support.department}</span>
    <div class="bottom-margin-5">
        <input type="hidden" id="currentdeptid" value="{$deptid}"/>
        <select id="deptid" data-update-type="deptid" class="form-control sidebar-ticket-ajax" aria-label="{$_ADMINLANG.support.department}">
            {foreach from=$departments item=department}
                <option value="{$department.id}"{if $department.id eq $deptid} selected{/if}>{$department.name}</option>
            {/foreach}
        </select>
    </div>
    <span class="sub-header">
        {$_ADMINLANG.support.assignedto}
        <a href="#" onclick="$('#flagto').val({$adminid});$('#flagto').trigger('change');return false"
           class="pull-right">{$_ADMINLANG.support.me}</a>
    </span>
    <div class="bottom-margin-5">
        <input type="hidden" id="currentflagto" value="{$flag}"/>
        <select id="flagto" data-update-type="flagto" class="form-control select-assignto sidebar-ticket-ajax" aria-label="{$_ADMINLANG.support.assignedto}">
            <option value="0">{$_ADMINLANG.global.none}</option>
            {foreach from=$staff item=staffmember}
                <option value="{$staffmember.id}"{if $staffmember.id eq $flag} selected{/if}>{$staffmember.name}</option>
            {/foreach}
        </select>
    </div>
    <span class="sub-header">{$_ADMINLANG.support.priority}</span>
    <div class="bottom-margin-5">
        <input type="hidden" id="currentpriority" value="{$priority}"/>
        <select id="priority" data-update-type="priority" class="form-control sidebar-ticket-ajax" aria-label="{$_ADMINLANG.support.priority}">
            <option value="High"{if $priority eq "High"} selected{/if}>{$_ADMINLANG.status.high}</option>
            <option value="Medium"{if $priority eq "Medium"} selected{/if}>{$_ADMINLANG.status.medium}</option>
            <option value="Low"{if $priority eq "Low"} selected{/if}>{$_ADMINLANG.status.low}</option>
        </select>
    </div>
    <span class="sub-header">{$_ADMINLANG.support.tags}</span>
    <input id="ticketTags" value="{$tags|implode:','}" class="selectize-tags"
           placeholder="{lang key='support.addTag'}"/>
</div>

{* No heading: the admin language pack has no key for a shared one, so the
   group break is a hairline. *}
<div class="content-padded sidebar-people">
    <span class="sub-header">{$_ADMINLANG.support.staffparticipants}</span>
    <div class="bottom-margin-5">
        {foreach from=$staffinvolved item=staffname}
            {$staffname}
            <br/>
            {foreachelse}
            No Replies Yet
        {/foreach}
    </div>

    <span class="sub-header">{$_ADMINLANG.support.ticketWatchers}</span>
    <div class="bottom-margin-5">
        {* role="list" because WebKit drops list semantics under list-style:none *}
        <ol id="ticketWatchers" role="list">
            {foreach $ticketWatchers as $k => $ticketWatcher}
                <li id="ticket-watcher-{$k}">{$ticketWatcher}</li>
            {/foreach}
            <li id="ticket-watcher-0"{if $ticketWatchers} class="hidden"{/if}>{$_ADMINLANG.global.none}</li>
        </ol>
    </div>

    <span class="sub-header">{$_ADMINLANG.support.ccrecipients}</span>
    <div class="bottom-margin-5">
        {if count($ticketCc) > 0}
            <ol role="list">
                {foreach $ticketCc as $k => $cc}
                    <li>{$cc}</li>
                {/foreach}
            </ol>
        {else}
            {lang key="global.none"}
        {/if}
    </div>
</div>

{foreach $sidebaroutput as $output}
    <div>
        {$output}
    </div>
{/foreach}

<div class="sidebar-actions">
    <div class="watch-ticket">
        {if $watchingTicket}
            <button class="btn btn-danger btn-block btn-xs" id="watch-ticket" type="button"
                    data-admin-full-name="{$adminFullName}" data-admin-id="{$adminid}"
                    data-ticket-id="{$ticketid}" data-type="unwatch">
                {lang key="support.unwatchTicket"}
            </button>
        {else}
            <button class="btn btn-info btn-block btn-xs" id="watch-ticket" type="button"
                    data-admin-full-name="{$adminFullName}" data-admin-id="{$adminid}"
                    data-ticket-id="{$ticketid}" data-type="watch">
                {lang key="support.watchTicket"}
            </button>
        {/if}
    </div>

    <div class="pin-ticket">
        {if $pinnedTicket}
            <button class="btn btn-danger btn-block btn-xs" id="pin-ticket" type="button"
                    data-admin-full-name="{$adminFullName}" data-admin-id="{$adminid}"
                    data-ticket-id="{$ticketid}" data-type="unpin">
                {lang key="support.unpinTicket"}
            </button>
        {else}
            <button class="btn btn-info btn-block btn-xs" id="pin-ticket" type="button"
                    data-admin-full-name="{$adminFullName}" data-admin-id="{$adminid}"
                    data-ticket-id="{$ticketid}" data-type="pin">
                {lang key="support.pinTicket"}
            </button>
        {/if}
    </div>

    <a href="#" class="btn-min-sidebar" id="sidebarClose">
        &laquo; Minimise Sidebar
    </a>
</div>
