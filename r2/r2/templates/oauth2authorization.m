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
   import datetime
   from r2.models import OAuth2AccessToken
   from r2.lib.template_helpers import static, make_url_protocol_relative, _wsf, format_html, add_sr
%>
<%namespace file="clientinfobar.m" import="app_link" />
<%namespace file="prefapps.m" import="scope_details" />
<%
   if thing.client.icon_url:
     icon = make_url_protocol_relative(thing.client.icon_url)
   else:
     icon = static("defaultapp.png")
   app_name = format_html(
       "<!-- SC_OFF --> <b>%s</b> <!-- SC_ON -->", thing.client.name)
%>
<div class="content oauth2-authorize">
  <div class="icon">
    &nbsp;
    <img src="${icon}" alt="${thing.client.name} icon" />
    &nbsp;
  </div>
  <h1>
    <%
      username_link = format_html(
        '<a href="%(user_url)s">%(username)s</a>',
        username=c.user.name,
        user_url=add_sr("/user/%s" % c.user.name, sr_path=False),
      )
    %>
    ${_wsf(
      "Hey %(username)s! %(app)s would like to connect with your Account.",
      app=unsafe(app_link(thing.client)),
      username=username_link,
    )}
  </h1>
  <div class="access">
    <div class="access-permissions">
        <h2>${_wsf("Allow %(app)s to:", app=app_name)}</h2>
        ${scope_details(thing.scope, expiration=thing.expiration)}
    </div>
    <p class="notice">
        ${_wsf("%(app)s will not be able to access your Password.", app=app_name)}
    </p>
    <form method="post" action="/api/v1/authorize" class="pretty-form">
      <input type="hidden" name="client_id" value="${thing.client._id}" />
      <input type="hidden" name="redirect_uri" value="${thing.redirect_uri}" />
      <input type="hidden" name="scope" value="${str(thing.scope)}" />
      <input type="hidden" name="state" value="${thing.state}" />
      <input type="hidden" name="response_type" value="${thing.response_type}" />
      <input type="hidden" name="duration" value="${thing.duration}" />
      <input type="hidden" name="uh" value="${c.modhash}"/>
      <div>
        <input type="submit" class="fancybutton newbutton allow" name="authorize"
               value="${_("Allow")}" />
        <input type="submit" class="fancybutton newbutton decline red"
               value="${_("Decline")}" />
      </div>
    </form>
  </div>
</div>

