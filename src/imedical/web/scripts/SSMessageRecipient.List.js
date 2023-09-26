// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function bodyLoadHandler() {
	if (top==self) websys_reSizeT();
	var obj=document.getElementById("ShowRead")
	if (obj) obj.onclick=showReadHandler;
}
function showReadHandler() {
	var DateFrom="";var DateTo="";var ShowRead="";var UserCode="";var DateCreatedFrom="";var DateCreatedTo="";
	if (document.getElementById("DateFrom")) DateFrom=document.getElementById("DateFrom").value;
	if (document.getElementById("DateTo")) DateTo=document.getElementById("DateTo").value;
	if (document.getElementById("DateCreatedFrom")) DateCreatedFrom=document.getElementById("DateCreatedFrom").value;
	if (document.getElementById("DateCreatedTo")) DateCreatedTo=document.getElementById("DateCreatedTo").value;
	if (document.getElementById("ShowRead")) ShowRead=document.getElementById("ShowRead").checked
	if (document.getElementById("User")) UserCode=document.getElementById("User").value;
	var win=window.open('websys.default.csp?WEBSYS.TCOMPONENT=SSMessageRecipient.List&User='+UserCode+"&DateFrom="+DateFrom+"&DateTo="+DateTo+"&ShowRead="+ShowRead+"&DateCreatedFrom="+DateCreatedFrom+"&DateCreatedTo="+DateCreatedTo,window.name,'')
	//if (document.getElementById("ShowRead").checked) {
	//	var win=window.open('websys.default.csp?WEBSYS.TCOMPONENT=SSMessageRecipient.List&UserID='+session['LOGON.USERID']+"&DateFrom="+DateFrom+"&DateTo="+DateTo+"&ShowRead="+ShowRead,window.name,'')
	//} else {
	//	var win=window.open('websys.default.csp?WEBSYS.TCOMPONENT=SSMessageRecipient.List&UserID='+session['LOGON.USERID']+"&DateFrom="+DateFrom+"&DateTo="+DateTo,window.name,'')
	//}
	//alert(document.getElementById("ShowRead").checked);
	//var win=window.open('websys.default.csp?WEBSYS.TCOMPONENT=SSMessageRecipient.List&UserID='+session['LOGON.USERID']+"&DateFrom="+DateFrom+"&DateTo="+DateTo,window.name,'')

}
window.document.body.onload=bodyLoadHandler;