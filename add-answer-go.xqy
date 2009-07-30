(:
 : Copyright (c) 2004 Mark Logic Corporation
 :
 : Licensed under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 : http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :
 : The use of the Apache License does not indicate that this project is
 : affiliated with the Apache Software Foundation.
 :)
xquery version "1.0-ml";
import module namespace xfl = "http://www.marklogic.com/xfaqtor-lib" at "xfaqtor-lib.xqy";
import module namespace xfd = "http://www.marklogic.com/xfaqtor-display" at "xfaqtor-display.xqy";

xdmp:set-response-content-type("text/html"),

<html xml:space="preserve">
<!-- @Template href="/default.tmpl" -->
<head>
<link rel="stylesheet" type="text/css" href="style.css" />
<!-- @BeginEditable id="title" -->
<title>XFAQtor</title>
<!-- @EndEditable -->
</head>
<!-- @BeginEditable id="bodytagstart" -->
<body class="help">
<!-- @EndEditable -->

<!-- @BeginEditable id="body" -->


<h1 class="title">Provide an answer.</h1>

{
  let $questid := xdmp:get-request-field("questid")
  let $text := xdmp:get-request-field("text")

  let $cancel := xdmp:get-request-field("cancel")
  return

  (: Do some input data checking :)
  if ($cancel) then
    xdmp:redirect-response("default.xqy")
  else if ($questid = "") then
    <span>
      <div class="error">The 'questid' parameter is missing</div>
      { xfd:print-go-home() }
    </span>
  else if (not($questid castable as xs:integer)) then
    <span>
      <div class="error">The 'questid' parameter must be an integer</div>
      { xfd:print-go-home() }
    </span>
  else if (normalize-space($text) = "") then
    <span>
      <div class="error">No answer text provided</div>
      { xfd:print-go-home() }
    </span>
  else
  
  let $question := xfl:get-question(xs:integer($questid))
  return
  
  if (empty($question)) then
    <span>
      <div class="error">Question id '{ $questid }' unknown</div>
      { xfd:print-go-home() }
    </span>
  else
  
  let $add := xfl:add-answer($question, $text)
  return

  <span>
    <div class="action-explain">
      Your answer has been recorded.  After administrator review it will be 
      posted on the live site.
    </div>
    { xfd:print-go-home() }
  </span>
}

<!-- @EndEditable -->
</body>
</html>
