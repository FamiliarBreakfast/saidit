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
  from r2.lib.template_helpers import _wsf, static
%>

<%namespace file="utils.m" import="_md, buffered_timestamp"/>

<%inherit file="interstitial.m"/>

<%def name="interstitial_image_attrs()">
  src="${static('interstitial-image-banned.png')}"
  alt="${_('banned')}"
</%def>

<%def name="interstitial_title()">
  ${_("This community has been banned")}
</%def>

<%def name="interstitial_message()">
  %if thing.message:
    ${parent.interstitial_message()}
  %else:
    ${_md("This community has been banned for violating the [SubSimGPT2Interactive rules](/s/Headquarter/comments/46/terms_and_content_policy/).")}
  %endif

  %if thing.ban_time:
    <div class="note">
      ${_wsf("Banned %(time_ago)s.", time_ago=unsafe(buffered_timestamp(thing.ban_time, include_tense=True)))}
    </div>
  %endif
</%def>
