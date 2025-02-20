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
   from r2.config import feature
   from r2.lib.template_helpers import add_sr
   from r2.lib.template_helpers import static
   from r2.lib.strings import strings
   from r2.lib.utils import UrlParser
   import random
 %>
<%namespace file="captcha.m" import="captchagen"/>
<%namespace file="utils.m" import="error_field, img_link, form_group, text_with_links"/>

## default content 
%if c.user_is_loggedin:
  <p class="error">${_("You are logged in. Go use the site!")}</p>
%else:
  %if thing.is_popup:
    <h3 id="cover-msg" class="modal-title">
      ${_('You need to login to do that.')}
    </h3>
  %endif
  <div id="login">
    ${login_panel(login_form, 
                  user_reg = thing.user_reg, user_login = thing.user_login, 
                  dest=thing.dest,
                  registration_info=thing.registration_info)}
  </div>
%endif

<%def name="login_form(register=False, user='', dest='', compact=False, autofocus=True)">
  %if not compact:
    <%
      op = "reg" if register else "login"
      base = g.https_endpoint
      tabindex = 2 if register else 3
    %>
    <form id="${'register' if register else 'login'}-form" method="post" 
          action="${add_sr(base + '/post/' + op)}"
          class="form-v2">
      <input type="hidden" name="op" value="${op}">
      %if dest:
        <input type="hidden" name="dest" value="${dest}">
      %endif
      <%call expr="form_group(
                    'user',
                    'USERNAME_TOO_SHORT',
                    'USERNAME_INVALID_CHARACTERS',
                    'USERNAME_TAKEN',
                    show_errors=register)">
        <label for="user_${op}" class="screenreader-only">${_('username')}:</label>
        <input value="${user}" name="user" id="user_${op}" class="c-form-control"
               type="text" maxlength="20" tabindex="${tabindex}"
               %if register:
                placeholder="${_('choose a username')}"
                data-validate-url="/api/check_username.json"
                data-validate-min="3"
                autocomplete="off"
               %else:
                placeholder="${_('username')}"
                ## %if autofocus:
                ##   autofocus
                ## %endif
               %endif
               >
      </%call>
      <%call expr="form_group('passwd', 'BAD_PASSWORD', 'WRONG_PASSWORD', 'INCORRECT_USERNAME_OR_PASSWORD', show_errors=True)">
        <label for="passwd_${op}" class="screenreader-only">${_('password')}:</label>
        <input id="passwd_${op}" class="c-form-control" name="passwd" type="password"
               tabindex="${tabindex}" placeholder="${_('password')}"
               ${"data-validate-url='/api/check_password.json'" if register else ''}>
      </%call>
      %if register:
        <%call expr="form_group('passwd2', 'BAD_PASSWORD_MATCH', show_errors=register)">
          <label for="passwd2_${op}" class="screenreader-only">${_('verify password')}:</label>
          <input name="passwd2" id="passwd2_${op}" class="c-form-control"
                 type="password" tabindex="${tabindex}"
                 placeholder="${_('verify password')}">
        </%call>
        <%call expr="form_group('email', 'BAD_EMAIL', show_errors=register)">
          <label for="email_${op}" class="screenreader-only">
            ${_('email')}: &nbsp;<i>(${_('optional')})
          </i></label>
          <input value="" name="email" id="email_${op}" class="c-form-control"
                 type="text" tabindex="${tabindex}"
                 placeholder="${_('email (optional)')}"
                 data-validate-url="/api/check_email.json"
                 data-validate-on="change blur">
        </%call>
      %endif
      %if register and not g.disable_captcha:
        ${thing.captcha}
      %endif
      <div class="c-checkbox">
        <input type="checkbox" name="rem" id="rem_${op}" tabindex="${tabindex}">
        <label for="rem_${op}">
          ${_('remember me')}
        </label>
        %if not register:
          <a href="/password" class="c-pull-right">${_('reset password')}</a>
        %endif
      </div>
      %if register and not g.disable_newsletter:
      <div class="c-checkbox">
        <input type="checkbox" name="newsletter_subscribe" id="newsletter_subscribe" tabindex="${tabindex}"
          data-validate-url="/api/check_email.json"
          data-validate-on="change blur"
          data-validate-with="email"
        >
        <label for="newsletter_subscribe">
          ${_('get the best of %s emailed to you once a week.') % g.brander_site}&#32;
          <a href="/newsletter" target="_blank">${_('learn more')}</a>
        </label>
      </div>
      %endif
      <div class="c-clearfix c-submit-group">
        <span class="c-form-throbber"></span>
        <button type="submit" class="c-btn c-btn-primary c-pull-right" tabindex="${tabindex}">
          ${register and _("sign up") or _("log in")}
        </button>
      </div>
      <div>
        <div class="c-alert c-alert-danger"></div>
        %if register:
          ${error_field("RATELIMIT", "ratelimit")}
          ${error_field("RATELIMIT", "vdelay")}
        %endif
      </div>
    </form>
  %else:
    <%
      op = "reg" if register else "login"
      base = g.https_endpoint
      tabindex = 2 if register else 3
    %>
    <form id="login_${op}" method="post" 
          action="${add_sr(base + '/post/' + op)}"
          class="user-form ${'register-form' if register else 'login-form'}">
      <input type="hidden" name="op" value="${op}" />
      %if dest:
        <input type="hidden" name="dest" value="${dest}" />
      %endif
      <div>
        <ul>
          <li class="name-entry">
            <label for="user_${op}">${_('username')}:</label>
            <input value="${user}" name="user" id="user_${op}" 
                   type="text" maxlength="20" tabindex="${tabindex}" autofocus />
            %if register:
              <span class="throbber"></span>
              <span class="notice-taken">${_('try another')}</span>
              <span class="notice-available">${_('available!')}</span>
              ${error_field("BAD_USERNAME", "user", kind="span")}
              ${error_field("USERNAME_TAKEN", "user", kind="span")}
              ${error_field("USERNAME_TAKEN_DEL", "user", kind="span")}
            %endif
          </li>
        %if register:
          <li>
            <label for="email_${op}">
              ${_('account recovery email')}: &nbsp;<i>(${_('optional')})
            </i></label>
            <input value="" name="email" id="email_${op}" 
                   type="email" maxlength="50" tabindex="${tabindex}"/>
            <label for="email_${op}" class="note">${_('we only send email at your request')}</label>
            %if register:
              ${error_field("BAD_EMAILS", "email", kind="span")}
            %endif
          </li>
        %endif
          <li>
            <label for="passwd_${op}">${_('password')}:</label>
            <input id="passwd_${op}" name="passwd" type="password" 
                   tabindex="${tabindex}"/>
            %if register:
              ${error_field("BAD_PASSWORD", "passwd", kind="span")}
            %else:
              ${error_field("WRONG_PASSWORD", "passwd", kind="span")}
              ${error_field("INCORRECT_USERNAME_OR_PASSWORD", "passwd", kind="span")}
            %endif
          </li>
        %if register:
          <li>
            <label for="passwd2_${op}">${_('verify password')}:</label>
            <input name="passwd2" id="passwd2_${op}" 
                   type="password" tabindex="${tabindex}"/>
            ${error_field("BAD_PASSWORD_MATCH", "passwd2", kind="span")}
          </li>
          <li>
            %if not g.disable_captcha:
            <% iden = hasattr(thing, "captcha") and thing.captcha.iden or '' %>
            ${captchagen(iden, tabulate=True, label=False, size=30, tabindex=tabindex)}
            %endif
          </li>
        %endif
        <li>
          <input type="checkbox" name="rem" id="rem_${op}" tabindex="${tabindex}" />
          <label for="rem_${op}" class="remember">
            ${_('remember me')}
          </label>
        </li>
        %if not register:
        <li>
          <a class="recover-password" href="/password">
            ${_("recover password")}
          </a>
        </li>
        %endif
      </ul>
        <p class="submit">
          <button type="submit" class="button" tabindex="${tabindex}">
            ${register and _("sign up") or _("log in")}
          </button>
          <span class="throbber"></span>
          <span class="status"></span>
          %if register:
            ${error_field("RATELIMIT", "ratelimit")}
            ${error_field("RATELIMIT", "vdelay")}
          %endif
        </p>
      </div>
    </form>
  %endif
</%def>


<%def name="login_panel(lf, user_reg = '', user_login = '', dest='', registration_info=None)">
  <% autofocus = (not thing.is_popup) %>
  <div class="split-panel">
    <div class="split-panel-section split-panel-divider">
      <h4 class="modal-title">${_("create a new account")}</h4>
      %if not feature.is_enabled('registration_disabled'):
        ${lf(register=True, user=user_reg, dest=dest, autofocus=autofocus)}
      %else:
        ${_(g.registration_disabled_message)}
      %endif
    </div>
    <div class="split-panel-section">
      <h4 class="modal-title">${_("log in")}</h4>
      %if not feature.is_enabled('login_disabled'):
        ${lf(user = user_login, dest = dest, autofocus=autofocus)}
      %else:
        ${_(g.login_disabled_message)}
      %endif
    </div>
  </div>
  <p class="login-disclaimer">
    ${text_with_links(
      _("By signing up, you agree to our %(policy)s."),
        policy=dict(link_text=_("Terms and Content Policy"), path="/s/Headquarter/comments/46/terms_and_content_policy/"),
        ## _("By signing up, you agree to our %(terms)s and that you have read our %(privacy_policy)s and %(content_policy)s."), 
        ## terms=dict(link_text=_("Terms"), path="/help/useragreement/"),
        ## privacy_policy=dict(link_text=_("Privacy Policy"), path="/help/privacypolicy/"),
        ## content_policy=dict(link_text=_("Content Policy"), path="/help/contentpolicy/"),
    )}
  </p>
</%def>

