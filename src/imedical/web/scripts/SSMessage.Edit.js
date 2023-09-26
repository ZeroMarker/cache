// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler() {
	var IdValue = document.getElementById("ID").value;
	var obj=document.getElementById("SelectAll")
	if (obj) {
		obj.onclick=SelectAllHandler;
		var objCF=document.getElementById("AllowSendToAll")
		if (objCF) {if (objCF.value!="Y") obj.disabled=true;}
	}
	if (tsc['SelectAll']) websys_sckeys[tsc['SelectAll']]=SelectAllHandler;

	var obj=document.getElementById("deleteUser")
	if (obj) obj.onclick=deleteUserHandler;
	if (tsc['deleteUser']) websys_sckeys[tsc['deleteUser']]=deleteUserHandler;
	if(obj && IdValue>0){
		obj.hidden = true;
		obj.onclick = function(){return false;};
	}
	var obj=document.getElementById("update1")
	if (obj) obj.onclick=updateHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=updateHandler;
	if(obj && IdValue>0){
		obj.hidden = true;
		obj.onclick = function(){return false;};
	}
	if (IdValue>0){
		var mm = document.getElementById("MESSMessage");
		mm.disabled = true;
		var mr = document.getElementById("MessageRecipients");
		mr.disabled = true;
		var  sg = document.getElementById("SelectGroup");
		sg.disabled = true;
		var  sl = document.getElementById("SelectLocation");
		sl.disabled = true;
		var  su = document.getElementById("SelectUser");
		su.disabled = true;
	}
}

function LookUpUser(val) {
	var obj=document.getElementById("MessageRecipients")
	if (obj) TransferToList(obj,val);
	document.getElementById("SelectUser").value=""
}
function LookUpGroup(val) {
	var ary=val.split("^")
	//gets list of UserIDs and names that eventually get sent to callAddItemToList
	var job=websys_createWindow('ssuser.find.csp?GroupID='+ary[1], 'TRAK_hidden', '')
	var obj=document.getElementById("SelectGroup");
	if (obj) obj.value="";
}
function SelectAllHandler() {
	var obj=document.getElementById("SelectAll");
	if (obj&&obj.checked==true) {
		var job=websys_createWindow('ssuser.find.csp?All=1', 'TRAK_hidden','')
	}
}
function LookUpLocation(val) {
	var ary=val.split("^")
	//gets list of UserIDs and names that eventually get sent to callAddItemToList
	var job=websys_createWindow('ssuser.find.csp?LocID='+ary[1], 'TRAK_hidden','')
	var obj=document.getElementById("SelectLocation");
	if (obj) obj.value="";
}	

/* ab - no longer used
function receiveUsers(val,txt) {
	var obj=document.getElementById("MessageRecipients")
	if (obj) {callAddItemToList(obj,txt,val);obj.value=""}
}
*/

function deleteUserHandler() {
	var obj=document.getElementById("MessageRecipients")
	if (obj) ClearSelectedList(obj)
	return false;
}
function updateHandler() {
	var obj=document.getElementById("MessageRecipients");
	if (obj) {
		var ary=returnValues(obj);
		document.getElementById("MessageRecipientIDs").value=ary.join("^");
		//alert(document.getElementById("MessageRecipientIDs").value);
	}
	//return false;
	return update1_click();
}
window.document.body.onload=BodyLoadHandler;