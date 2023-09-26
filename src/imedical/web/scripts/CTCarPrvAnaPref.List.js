// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var tbl=document.getElementById("tCTCarPrvAnaPref_List");

function DocumentLoadHandler() {
	var obj=document.getElementById("DeleteAll")
	if (obj) obj.onclick=DeleteAllClickHandler;
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("Deletez"+i)
		if (obj) obj.onclick=DeleteClickHandler
	}
}

function DeleteAllClickHandler(e) {
	var idstring="";
	for (var i=1;i<tbl.rows.length;i++) {
		var objID=document.getElementById("OpPrefIDz"+i)
		if ((objID)&&(objID.value!="")) idstring=idstring+objID.value+"^";
	}
	document.getElementById("idstring").value=idstring
	return DeleteAll_click();
}

function DeleteClickHandler(e) {
	if (!confirm(t["deleteitem"])) return false;
}

document.body.onload=DocumentLoadHandler;