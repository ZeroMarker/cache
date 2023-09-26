////DHCOPGCF.GroupPrintTask.js


function BodyLoadHandler(){
	IntDoc();
}

function BodyUnLoadHandler(){
	
}

function IntDoc(){

	var myobj=document.getElementById("PrintMode");
	if (myobj){
		myobj.size=1;
		myobj.multiple=false;
	}
	
	var myobj=document.getElementById("btnAdd");
	if (myobj){
		myobj.disabled=false;
		myobj.onclick=Update_OnClick;
	}
	
	DHCWeb_DisBtnA("btnUpdate");
	DHCWeb_DisBtnA("BtnDelete");
	
}


function Update_OnClick(){
	///update for DHC_OPGroupSettings  and DHC_OPGSPayMode
	
	var myGSRowID=DHCWebD_GetObjValue("GSRowID");
	var myValue=DHCWebD_GetObjValue("InitGSPrintTaskEncrypt");
	var myGSPTInfo=DHCDOM_GetEntityClassInfoToXML(myValue);
	
	////return;
	var encmeth=DHCWebD_GetObjValue("SaveDataEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,myGSRowID,myGSPTInfo);
		var myary=rtn.split("^");
		if (myary[0]=="0"){
			alert(t["SaveOK"]);
			///alert(location.href);
			location.href = location.href;
		}else{
			alert(t["SaveErr"]);
		}
		
	}
	
}

function BtnDelete_OnClick()
{
	
}

function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCApptSchedule_List');
	var tables = document.getElementsByTagName("table");
	if (!objtbl) objtbl = tables[2];
	if (!objtbl) return ;
	var rows=objtbl.rows.length;

	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
  	
	if (rowObj.className != "clsRowSelected")
	{
		DHCWebD_SetObjValueA("XmlTemplateName","");
		DHCWebD_SetObjValueA("ClassName","");
		DHCWebD_SetObjValueA("MethodName","");
		DHCWebD_SetObjValueA("GSPTRowID","");
		///PrintMode
		
		////
		DHCWebD_SetObjValueA("HardEquipDR","");
		DHCWebD_SetObjValueA("HardEquipDRDesc","");
		//// Enable Add
		var myobj=document.getElementById("btnAdd");
		if (myobj){
			myobj.disabled=false;
			myobj.onclick=Update_OnClick;
		}
		DHCWeb_DisBtnA("btnUpdate");
		DHCWeb_DisBtnA("BtnDelete");
	}
	else
	{
		
		var myobj=document.getElementById("TXmlTemplateNamez"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("XmlTemplateName",myvalue);
		
		var myobj=document.getElementById("TClassNamez"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("ClassName",myvalue);
		
		var myobj=document.getElementById("TMethodNamez"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("MethodName",myvalue);
		
		var myobj=document.getElementById("TPTRowIDz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("GSPTRowID",myvalue);
		
		var myobj=document.getElementById("TPrintModez"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueXMLTrans("PrintMode",myvalue);

		var myobj=document.getElementById("THardEquipDRz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("HardEquipDR",myvalue);
		
		var myobj=document.getElementById("THardEquipDRDescz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("HardEquipDRDesc",myvalue);
		
		/// Enable Update
		var myobj=document.getElementById("btnUpdate");
		if (myobj){
			myobj.disabled=false;
			myobj.onclick=Update_OnClick;
		}
		
		/// Enable Delete
		var myobj=document.getElementById("BtnDelete");
		if (myobj){
			myobj.disabled=false;
			myobj.onclick=BtnDelete_OnClick;
		}
		
		DHCWeb_DisBtnA("btnAdd");
	}
	
	///SelectedRow = selectrow;
	
}

function SetHardEquipDRInfo(value)
{
	var myary=value.split("^");
	DHCWebD_SetObjValueA("HardEquipDR",myary[2]);
	///DHCWebD_SetObjValueA("GSPTRowID",myary);
	
}

document.body.onload = BodyLoadHandler;
document.body.onunload=BodyUnLoadHandler;

