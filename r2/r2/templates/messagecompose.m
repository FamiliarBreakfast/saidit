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

<%namespace file="utils.m" import="error_field, submit_form"/>
<%namespace name="utils" file="utils.m"/>

<%!
   import simplejson
   from r2.lib import js
   from r2.lib.pages import UserText
   from r2.lib.template_helpers import static
%>

${unsafe(js.use("messagecompose"))}

<h1>${_("send a private message")}</h1>

<%utils:submit_form onsubmit="return post_form(this, 'compose', null, null, true)",
                    method="post", _id = "compose-message",
                    action="/message/compose">

${to_field()}
${subject_field()}
${message_field()}
%if thing.admin_check:
  ${clippy_field()}
%endif
${captcha_field()}
<input type="hidden" name="source" value="compose">

<button id="send" name="send" type="submit">${_("send")}</button>
<span class="status"></span>

</%utils:submit_form>


<%def name="to_field()">
  <div class="spacer">
    %if thing.restrict_recipient:
      <%utils:round_field title="${_('to')}">
        <input type="text" class="access-required" name="to" value="${g.admin_message_acct}"
               data-event-action="changerecipient" readonly />
      </%utils:round_field>
    %else:
      <%utils:round_field title="${_('to')}",
          description="${_('(username, or /' + g.brander_community_abbr + '/name for that subreddit\'s moderators)')}">
        <input type="text" name="to" value="${thing.to or ''}"
               onchange="${'admincheck(this)' if thing.admin_check else ''}"/>
        ${error_field("NO_USER", "to")}
        ${error_field("USER_DOESNT_EXIST", "to")}
        ${error_field("SUBREDDIT_NOEXIST", "to")}
        ${error_field("USER_BLOCKED", "to")}
        ${error_field("USER_BLOCKED_MESSAGE", "to")}
        ${error_field("USER_MUTED", "to")}
        ${error_field("MUTED_FROM_SUBREDDIT", "to")}
      </%utils:round_field>
    %endif
  </div>
</%def>

<%def name="subject_field()">
  <div class="spacer">
    <%utils:round_field title="${_('subject')}">
      ## Hidden by default so that the form is reasonable for users with no JS.
      <select class="rule_subject" style="display:none">
        <option value="" selected disabled class="blank"></option>
        <option value="" class="other">Other</option>
      </select>

      <input type="text" name="subject" value="${thing.subject or ''}"/>
      ${error_field("NO_SUBJECT", "subject", "span")}
      ${error_field("TOO_LONG", "subject", "span")}
    </%utils:round_field>
  </div>
</%def>

<%def name="message_field()">
  <div class="spacer">
    <%utils:round_field title="${_('message')}">
      ${UserText(None, text=thing.message, have_form = False, creating = True)}
    </%utils:round_field>
  </div>
</%def>

<%def name="clippy_field()">
  <script type="text/javascript">
  function admincheck(elem) {
    var admins = ${unsafe(simplejson.dumps(thing.admins))};

    if ($.inArray(elem.value, admins) >= 0) {
      $(".admin-to").text(elem.value);
      $(".clippy").show();
    } else {
      $(".clippy").hide();
    }
  }
  </script>

  <div class="clippy" ${"style='display:none'" if thing.to not in thing.admins else ""}>
     <div class="clippy-bubble">
       <p class="clippy-headline">You're messaging an Admin!</p><br>
       <p>
         Before you click "send", please make sure that
         &#32;
         <span class="admin-to">${thing.to}</span>
         &#32;
         is the right person for the job.
       </p><p> </p><br>

       <p>If your inqury relates to a specific sub, please messeage the mods of that sub rather than an Admin.</p>

     </div>
    <br class="clear"/>
  </div>
</%def>

<%def name="captcha_field()">
  <div class="spacer">
    ${thing.captcha}
  </div>
</%def>
