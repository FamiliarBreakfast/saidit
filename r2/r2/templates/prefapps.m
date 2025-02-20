## The contents of this file are subject to the Common Public Attribution
## License Version 1.0. (the "License"); you may not use this file except in
## compliance with the License. You may obtain a copy of the License at
## http://code.reddit.com/LICENSE. The License is based on the Mozilla Public
## License Version 1.1, but Sections 14 and 15 have been added to cover use of
## software over a computer network and provide for limited attribution for the
## Original Developer. In addition, Exhibit A has been modified to be
## consistent with Exhibit B.
##
## Software distributed under the License is distributed on an "AS IS" basis,
## WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
## the specific language governing rights and limitations under the License.
##
## The Original Code is reddit.
##
## The Original Developer is the Initial Developer.  The Initial Developer of
## the Original Code is reddit Inc.
##
## All portions of the code written by reddit are Copyright (c) 2006-2015
## reddit Inc. All Rights Reserved.
###############################################################################

<%!
  from r2.lib.filters import jssafe
  from r2.lib.template_helpers import static, make_url_protocol_relative
  from r2.lib.utils import timeuntil
%>

<%namespace name="utils" file="utils.m" />
<%namespace file="utils.m" import="_md"/>
<%namespace file="utils.m" import="error_field, plain_link" />
<%namespace file="printablebuttons.m" import="ajax_ynbutton, ynbutton" />

<%def name="icon(app)">
  <div class="app-icon">
    &nbsp;
    <img src="${make_url_protocol_relative(app.icon_url) or static('defaultapp.png')}">
    &nbsp;
  </div>
</%def>

<%def name="developers(app)">
  <% devs = app._developers %>
  %if devs:
    <div class="app-developers">
      Developers:&#32;
      %for i, dev in enumerate(sorted(devs, key=lambda d: d.name)):
        %if i:
          %if i == len(devs) - 1:
            &#32;and&#32;
          %else:
            ,&#32;
          %endif
        %endif
        ${plain_link(dev.name, "/u/" + dev.name)}
      %endfor
    </div>
  %endif
</%def>

<%def name="app_type_selector(selection='web')">
${utils.radio_type('app_type', "web", _("web app"),
                   _("A web based application"),
                   selection == "web")}
${utils.radio_type('app_type', "installed", _("installed app"),
                   _("An app intended for installation, such as on a mobile phone"),
                   selection == "installed")}
${utils.radio_type('app_type', "script", _("script"),
                   _("Script for personal use. Will only have access to the developers accounts"),
                   selection == "script")}
</%def>

<%def name="editable_developer(app, dev)">
  <li id="app-dev-${app._id}-${dev._id}">
    ${dev.name}&#32;
    %if c.user == dev:
      <span class="gray">${_("(that's you!)")}</span>&#32;
    %endif
    ${ajax_ynbutton(_("remove"), "removedeveloper",
                    hidden_data=dict(client_id=app._id, name=dev.name))}
  </li>
</%def>

<%def name="developed_app(app, collapsed=True)">
  <li id="developed-app-${app._id}"
      class="developed-app rounded ${'collapsed' if collapsed else ''}">
    ${icon(app)}
    <a class="edit-app-button ${'' if collapsed else 'collapsed'}"
       href="javascript:void(0)">
       ${_("edit")}
    </a>
    <div class="app-details">
      <h2>
      %if app.about_url:
        <a href="${app.about_url}">${app.name}</a>
      %else:
        ${app.name}
      %endif
      </h2>
      <h3>
        %if app.app_type == 'web':
          ${_("web app")}
        %elif app.app_type == 'installed':
          ${_("installed app")}
        %elif app.app_type == 'script':
          ${_("personal use script")}
        %endif
      </h3>
      <h3>${app._id}</h3>
    </div>
    <div class="app-description">${app.description}</div>
    %if collapsed:
      ${developers(app)}
    %endif
    <div class="edit-app ${'collapsed' if collapsed else ''}">
      <a class="edit-app-icon-button" href="javascript:void(0)">
        change icon
      </a>
      <%utils:ajax_upload target="/api/setappicon"
                          form_id="app-icon-upload-${app._id}">
        <input type="hidden" name="client_id" value="${app._id}" />
        ${error_field('TOO_LONG', 'file')}
        ${error_field('BAD_IMAGE', 'file')}
      </%utils:ajax_upload>
      <div class="edit-app-form">
        <form method="post" action="/api/updateapp" class="pretty-form"
         id="update-app-${app._id}"
         onsubmit="${"return post_form(this, 'updateapp', function(x) {return '%s'})" % jssafe(_("updating..."))}">
          <input type="hidden" name="uh" value="${c.modhash}" />
          <input type="hidden" name="client_id" value="${app._id}" />
          <input type="hidden" name="app_type" value="${app.app_type}" />
          <table class="preftable">
            %if app.is_confidential():
              <tr>
                <th>${_("secret")}</th>
                <td class="prefright">${app.secret}</td>
              </tr>
            %endif
            <tr>
              <th>${_("name")}</th>
              <td class="prefright">
                <input class="text" name="name" value="${app.name}">
                ${error_field("NO_TEXT", "name")}
              </td>
            </tr>
            <tr>
              <th>${_("description")}</th>
              <td class="prefright">
                <textarea name="description">${app.description}</textarea>
              </td>
            </tr>
            <tr>
              <th>${_("about url")}</th>
              <td class="prefright">
                <input class="text" name="about_url" value="${app.about_url}">
                ${error_field("BAD_URL", "about_url")}
              </td>
            </tr>
            <tr>
              <th>${_("redirect uri")}</th>
              <td class="prefright">
                <input class="text" name="redirect_uri"
                 value="${app.redirect_uri if app.redirect_uri else ''}">
                ${error_field("NO_URL", "redirect_uri")}
                ${error_field("BAD_URL", "redirect_uri")}
                ${error_field("INVALID_SCHEME", "redirect_uri")}
              </td>
            </tr>
          </table>
          <button type="submit">${_('update app')}</button>
          <span class="status"></span>
        </form>
      </div>
      <div class="edit-app-form pretty-form">
        <table class="preftable">
          <tr>
            <th>${_("developers")}</th>
            <td class="prefright">
              <ul>
                %for dev in sorted(app._developers, key=lambda d: d.name):
                  ${editable_developer(app, dev)}
                %endfor
              </ul>
              <br>
              <form method="post" action="/api/adddeveloper"
               class="pretty-form" id="app-developer-${app._id}"
               onsubmit="${"return post_form(this, 'adddeveloper', function(x) {return '%s'})" % jssafe(_("adding..."))}">
                <input type="hidden" name="uh" value="${c.modhash}" />
                <input type="hidden" name="client_id" value="${app._id}" />
                ${_('add developer')}: <input class="text" name="name">
                <br>
                ${error_field('TOO_MANY_DEVELOPERS', '')}
                ${error_field('OAUTH2_INVALID_CLIENT', 'client_id')}
                ${error_field('DEVELOPER_ALREADY_ADDED', 'name')}
                ${error_field('USER_DOESNT_EXIST', 'name')}
                ${error_field('NO_USER', 'name')}
                ${error_field('DEVELOPER_FIRST_PARTY_APP', 'name')}
                ${error_field('DEVELOPER_PRIVILEGED_ACCOUNT', 'name')}
                <span class="status"></span>
              </form>
            </td>
          </tr>
        </table>
      </div>
      <div class="delete-app-button">
        ${ynbutton(_("delete app"),
                   "deleted",
                   "deleteapp",
                   callback="r.apps.deleted",
                   hidden_data=dict(client_id=app._id))}
      </div>
    </div>
  </li>
</%def>

<%def name="sr_list(srs)">
  %for i, name in enumerate(sorted(srs)):
    %if i:
      ,&#32;
    %endif
    <a href="/${g.brander_community_abbr}/${name}">/${g.brander_community_abbr}/${name}</a>
  %endfor
</%def>

<%def name="scope_details(scope, compact=False, expiration=None)">
  <div class="app-permissions">
    <ul>
      %if scope.subreddit_only:
        %if compact:
	  ${_("Only in:")}&#32;
	  ${sr_list(scope.subreddits)}
	  <br>
	%else:
          <li>
            ${_("Only in the subreddits:")}&#32;
            ${sr_list(scope.subreddits)}.
          </li>
	%endif
      %endif
      %for name, scope_info in scope.details():
        <li>
          %if compact:
            ${scope_info['name']}
            <span class="app-scope">${scope_info['description']}</span>
          %else:
            ${scope_info['description']}
          %endif
        </li>
      %endfor
      %if not compact:
        <li>
          %if expiration:
            ${_("Expires in:")}&#32;
            ${timeuntil(expiration)}
          %else:
            ${_("Maintain this access indefinitely"
                " (or until manually revoked).")}
          %endif
        </li>
      %endif
    </ul>
    %if compact and expiration:
      <div class="app-permissions-details">
        ${_("Expires in:")}&#32;
        ${timeuntil(expiration)}
        <br>
      </div>
    %endif
  </div>
</%def>

<%def name="authorized_app(app_data)">
  <div id="authorized-app-${app_data['client']._id}" class="authorized-app rounded">
    ${icon(app_data['client'])}
    <div class="app-details">
      <h2>
      %if app_data['client'].about_url:
        <a href="${app_data['client'].about_url}">${app_data['client'].name}</a>
      %else:
        ${app_data['client'].name}
      %endif
      </h2>
      ## `sorted` should put global permissions first (keyed off `None`)
      %for sr in sorted(app_data['scopes']):
        ${scope_details(app_data['scopes'][sr], compact=True)}<br>
      %endfor
    </div>
    <div class="app-description">${app_data['client'].description}</div>
    ${developers(app_data['client'])}
    ${ynbutton(_("revoke access"),
               _("revoked"),
               "revokeapp",
               callback="r.apps.revoked",
               hidden_data=dict(client_id=app_data['client']._id),
               _class="revoke-app-button",
               access_required=False)}
  </div>
</%def>

%if thing.my_apps:
  <h1>${_("authorized applications")}</h1>

  %for app_data in thing.my_apps.values():
    ${authorized_app(app_data)}
  %endfor
%endif

<div id="developed-apps">
  <h1 style="${'' if thing.developed_apps else 'display:none'}">
    ${_("developed applications")}
  </h1>
  <ul>
    %for app in thing.developed_apps:
      ${developed_app(app)}
    %endfor
  </ul>
</div>

<div class="edit-app-form">
  <button id="create-app-button" class="submit-img">
    %if thing.developed_apps:
      ${_('create another app...')}
    %else:
      ${_('are you a developer? create an app...')}
    %endif
  </button>
  <form method="post" action="/api/updateapp" class="pretty-form" id="create-app"
   onsubmit="${"return post_form(this, 'updateapp', function(x) {return '%s'})" % jssafe(_("creating..."))}">
    <h1>${_("create application")}</h1>
    <p>${_md("Please [read the API usage guidelines](https://github.com/reddit-archive/reddit/wiki/API) before creating your application. After creating, you will be required to register for production API use. Please message /u/wezerl to let us know about your app if it reaches the production and release phase.")}
    <input type="hidden" name="uh" value="${c.modhash}" />
    <table class="content preftable">
      <tr>
        <th>${_("name")}</th>
        <td class="prefright">
          <input class="text" name="name">
          ${error_field("NO_TEXT", "name")}
        </td>
      </tr>
      ${app_type_selector()}
      <tr>
        <th>${_("description")}</th>
        <td class="prefright">
          <textarea name="description"></textarea>
        </td>
      </tr>
      <tr>
        <th>${_("about url")}</th>
        <td class="prefright">
          <input class="text" name="about_url">
          ${error_field("BAD_URL", "about_url")}
        </td>
      </tr>
      <tr>
        <th>${_("redirect uri")}</th>
        <td class="prefright">
          <input class="text" name="redirect_uri">
          ${error_field("NO_URL", "redirect_uri")}
          ${error_field("BAD_URL", "redirect_uri")}
          ${error_field("INVALID_SCHEME", "redirect_uri")}
        </td>
      </tr>
    </table>
    <button type="submit">${_('create app')}</button>
    <span class="status"></span>
  </form>
</div>
