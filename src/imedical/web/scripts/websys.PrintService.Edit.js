// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentLoadHandler() {
	var objUpdate=document.getElementById("update1");
	var objGroupVal=document.getElementById("PrinterGroup");
	var objGroupList=document.getElementById("PrinterGroupList");

	if(objGroupVal && objGroupVal.value!=""){
		var ary=objGroupVal.value.split(",");
		for(var i=0; i<ary.length; i++){
			var printerGroup=ary[i];
			for(var j=0; j<objGroupList.length; j++){
				if(printerGroup==objGroupList.options[j].value){
					objGroupList.options[j].selected="true";
				}
			}
		}
	}

	if(objUpdate) objUpdate.onclick=SelectedGroupsHandler;
}

function SelectedGroupsHandler(){
	var selPrinterGroups="";
	var objGroupVal=document.getElementById("PrinterGroup");
	var objGroupList=document.getElementById("PrinterGroupList");
	if (objGroupList){
		for(var i=0; i<objGroupList.length; i++){
			if(objGroupList.options[i].selected==true){
				if(selPrinterGroups==""){
					selPrinterGroups=objGroupList.options[i].value;
				}
				else{
					selPrinterGroups=selPrinterGroups+","+objGroupList.options[i].value;
				}
			}
		}
  }
	if(objGroupVal) objGroupVal.value=selPrinterGroups;

	return update1_click();
}
document.body.onload = DocumentLoadHandler;

