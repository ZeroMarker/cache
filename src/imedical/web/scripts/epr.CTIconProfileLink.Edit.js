// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler() {
	var obj=document.getElementById('LinkComponent');
	if (obj) obj.onchange=LnkCompChangeHandler;
} 
function LnkCompChangeHandler() {
	var obj=document.getElementById('LinkUrl');
	if (obj) obj.value="websys.default.csp";
}
document.body.onload=BodyLoadHandler;
