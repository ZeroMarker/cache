// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
function BodyLoadHandler(){
	//KB log 59353 
	var objDelete = document.getElementById("delete1");
	if (objDelete) objDelete.onclick=DeleteClickHandler;
 }

function ANAGNAgentLookUpHandler(str) {
	var lu=str.split("^");
	var obj=document.getElementById("ANAGNAgentDesc");
	if (obj) obj.value=lu[1];
}

function DeleteClickHandler()
{
	//KB log 59353 We check value of the hidden field "CanDelete" to determine if this record can be 
	// deleted
	var objCanDelete = document.getElementById("CanDelete");
	if ((objCanDelete)&&(objCanDelete.value=="1")) {delete1_click();}
  else {
	  	alert(t['CANNOTDELETE']);
	  	return false;
  }
}

document.body.onload=BodyLoadHandler;
