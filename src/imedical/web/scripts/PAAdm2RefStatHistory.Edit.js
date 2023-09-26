// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//site=QH
function CustomDocumentLoadHandler(){
	var obj = document.getElementById('delete1')
	if (obj) obj.onclick=DeleteClickHandler;

	//DocumentLoadHandler();
}

function DeleteClickHandler() {
	var DateExist=""
	var obj = document.getElementById('DateExistsForAdmDate')
	if (obj) DateExist=obj.value	

	if (DateExist!="1") {
		alert(t['CantDelete']+" "+t['DateEqualAdm'])
		return false;
	}
	
	return delete1_click();
}

document.body.onload = CustomDocumentLoadHandler;
