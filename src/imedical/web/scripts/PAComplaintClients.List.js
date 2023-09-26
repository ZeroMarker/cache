// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function CloseWindow(e) {
	window.close();
	var win=window.opener;
	if (win) {
		win.treload('websys.csp');
	}
}

//when continuing in workflow, "New" button needs to popup in new window and spawn off to 
//a different patient find workflow
function PAComplaintClients_List_NewClickHandler(evt) {
	var obj=document.getElementById('New');
	arrlnk=obj.href.split("?")
	var lnk = arrlnk[0] + "?dorefresh=1&";
	if (urlNEW) lnk += urlNEW + "&";
	if (arrlnk[1]) lnk += arrlnk[1];
	websys_createWindow(lnk,'PACOMPLAINTCLIENT','top=10,left=50,width=500,height=500,resizable=yes,status=yes,scrollbars=yes');
	return false;
}

if (self==top) {
	var objUpdate=document.getElementById('update1');
	//if (objUpdate) objUpdate.onclick=CloseWindow;
} else {
	var obj=document.getElementById('New');
	if (obj) obj.onclick=PAComplaintClients_List_NewClickHandler;
}