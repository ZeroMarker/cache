// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 





function BodyUnloadHandler(e) {
	if (self == top) {
		var win=window.opener;
		if (win) {
			//win.location.reload();
			var path="websys.default.csp?WEBSYS.TCOMPONENT=PAAdmMedFit.List";
			//var path="PAAdmMedFit.List.csp?a=a";
			//var obj=document.getElementById("PARREF");
			//if (obj) path+="&PARREF="+obj.value;
			var obj=document.getElementById("MFParRef");
			if (obj) path+="&EpisodeID="+obj.value;
			var obj=win.document.getElementById("TWKFL");
			if (obj) path+="&TWKFL="+obj.value;
			var obj=win.document.getElementById("TWKFLI");
			if (obj) path+="&TWKFLI="+(obj.value-1);

			win.location = path;
		}
	}
	
}

document.body.onunload=BodyUnloadHandler;

//document.body.onunload=BodyUnloadHandler;
var obj=document.getElementById("update1");
if ((obj)&&(self==top)&&(window.opener)) {
	//sets the workflow back one step to display a refreshed list
	var objparent=window.opener.document.getElementById("TWKFL");
	var objthis=document.getElementById("TWKFL");
	if ((objthis)&&(objthis.value=="")&&(objparent)) objthis.value=objparent.value;
	var objparent=window.opener.document.getElementById("TWKFLI");
	var objthis=document.getElementById("TWKFLI");
	if ((objthis)&&(objthis.value=="")&&(objparent)) objthis.value=objparent.value-1;
	var frm = document.forms["fPATempAddress_Edit"];
	if (frm) frm.target=window.opener.name;
}


