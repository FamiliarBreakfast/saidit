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
   from r2.lib.strings import strings
   import datetime
%>
<%namespace file="utils.m" import="text_with_links"/>

<div class="footer-parent">
  <div by-zero class="footer rounded" style="display: block;">
      %for toolbar in thing.nav:
      <div class="col">
        ${toolbar}
      </div>
      %endfor
  </div>
  ## %if g.domain != "reddit.com":
  ##  <!-- http://code.reddit.com/LICENSE see Exhibit B -->
  ##  <a href="https://www.reddit.com/code/" style="text-align:center;display:block">
  ##    <img src="https://s3.amazonaws.com/sp.reddit.com/powered_by_reddit.png"
  ##         alt="Powered by reddit."
  ##         style="width:140px; height:47px; margin-bottom: 5px"/>
  ##  </a>
  ## %endif
  <p class="bottommenu">
    ## ${text_with_links(
    ##        _("Use of this site constitutes acceptance of our "
    ##          "%(user_agreement)s and %(privacy_policy)s"),
    ##        user_agreement=dict(
    ##            link_text=_("User Agreement {Genitive}"),
    ##            path="/help/useragreement",
    ##        ),
    ##        privacy_policy=dict(
    ##            link_text=_("Privacy Policy (updated)"),
    ##            path="/help/privacypolicy",
    ##            _class="updated",
    ##        ),
    ## )}.
    ## &copy; 
    ${_("%(year)d") % \
    dict(year=datetime.datetime.now().timetuple()[0])}
<br />
<br />
  </p>
  ## <p class="bottommenu">REDDIT and the ALIEN Logo are registered trademarks of reddit inc.</p>
</div>

