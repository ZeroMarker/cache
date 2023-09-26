
//log 61362 tedT 
function BodyUnloadHandler() {

	var par_win=window.opener;
	var rowid=document.getElementById("GRPRowIDz1");
	if(rowid && par_win) par_win.GroupNumberLink(1);
	if(!rowid && par_win) par_win.GroupNumberLink(0);
}

window.onunload=BodyUnloadHandler;