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
   from r2.lib.filters import websafe
   from r2.lib.strings import Score
   from r2.lib.template_helpers import format_number, format_percent, html_datetime
 %>


<%namespace file="printablebuttons.m" import="state_button" />
<%namespace file="printable.m" import="thing_css_class" />



<div class="linkinfo">
  <div class="date">
    <span>
      ${_("this post was submitted on")}
      &#32;
    </span>
    <time datetime="${html_datetime(thing.a._date)}">
      ${thing.a._date.strftime(thing.datefmt)}
    </time>
  </div>

  <div class="score">
    ${unsafe(Score.PERSON_LABEL % dict(num = format_number(thing.a.score),
                                       persons = websafe(ungettext("point", "points",
                                                                   thing.a.score))))}
    &#32;(${_("%(percent)s interesting | %(percent2)s fun") % dict(percent=format_percent(thing.a.upvote_ratio), percent2=format_percent(1-thing.a.upvote_ratio))})
  </div>

%if getattr(thing.a, "shortlink", None):
  <div class="shortlink">
    shortlink:
    &#32;
    <input type="text" value="https://${thing.a.shortlink}" readonly="readonly" id="shortlink-text" />
  </div>
%endif

  ${self.info_table()}
</div>

<%def name="info_table()">
</%def>

