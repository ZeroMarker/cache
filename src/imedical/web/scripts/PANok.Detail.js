
//log61054 TedT
var tbl="";

function BodyLoadHandler(){
	tbl=document.getElementById("tPANok_Detail");
	
	var obj=document.getElementById("unselectAll");
	if(obj) obj.onclick=SelectHandler;
	
	obj=document.getElementById("selectAll");
	if(obj) {
		obj.onclick=SelectHandler;
		obj.click();
	}
	
	obj=document.getElementById("update");
	if(obj) obj.onclick=UpdateClickHandler;
	
}

function SelectHandler() {
	var check=true;
	if(this.id=="unselectAll") check=false;

	for (var i=1;i<tbl.rows.length;i++) {
		var select=document.getElementById("selectz"+i);
		select.checked=check;
	}
	return false;
}

function UpdateClickHandler() {
	
	var selected="";
	for (var i=1;i<tbl.rows.length;i++) {
		var select=document.getElementById("selectz"+i);
		if(select.checked) {
			var code=document.getElementById("codez"+i);
			if(code) selected+=code.value+"^";
			if(code.value=="PAPERName") createAlias(); 
			if(code.value=="PAPERStNameLine1") savePrevAddr();
		}
	}
	var obj=document.getElementById("selected");
	if(obj) obj.value=selected;
	
	update_click();
}

function createAlias() {
	var noali=document.getElementById("noAlias");
	var NokDetails=document.getElementById("NokDetails");
	var arr=null;
	if(NokDetails) arr=NokDetails.value.split("*");
	
	if (arr && (arr[0] != "") && (noali && noali.value!="Y")) {
		if (confirm(t['ALIAS'])) {
			var patArr=arr[0].split("^");
			var fullArr=arr[1].split("^");
			var defArr=arr[2].split("^");
			for (var i=0; i<patArr.length && patArr[i]!="";i++) {
				var save=tkMakeServerCall("web.PAPersonSurnameAlias","setAliasFromName","","",patArr[i],defArr[i],"","",fullArr[i]);
			}
		}
	}
}

function savePrevAddr() {
	var prevAddr=document.getElementById("prevAddr");
	var NokDetails=document.getElementById("NokDetails");
	var arr=null;
	if(NokDetails) arr=NokDetails.value.split("*");
	var PatientId=document.getElementById("PatientID");
	if(PatientId) PatientId=PatientId.value;
	
	if (arr && (arr[0] != "") && (prevAddr && prevAddr.value=="Y")) {
		if (confirm(t['SAVEADDR'])) {
			var save=tkMakeServerCall("web.PANok","SavePrevAddr",PatientId,arr[0],arr[3]);
		}
	}
}

document.body.onload = BodyLoadHandler;
