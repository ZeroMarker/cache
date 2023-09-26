////UDHCCON.CIServiceTypeList.js

function BodyLoadHandler(){
	IntDoc();
}

function BodyUnLoadHandler(){
	
}

function IntDoc(){
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
	
	var myValue=DHCWebD_GetObjValue("InitCIServiceTypeListEncrypt");
	var myGSPTInfo=DHCDOM_GetEntityClassInfoToXML(myValue);
	
	////return;
	var encmeth=DHCWebD_GetObjValue("SaveDataEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,myGSPTInfo);
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
		DHCWebD_SetObjValueA("STPLRowID","");
		DHCWebD_SetObjValueA("STPLTypeDefineDR","");
		DHCWebD_SetObjValueA("TypeDefine","");
		DHCWebD_SetObjValueA("STPLDateFrom","");
		DHCWebD_SetObjValueA("STPLDateTo","");
		
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
		
		var myobj=document.getElementById("TSTPLRowIDz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("STPLRowID",myvalue);
		
		var myobj=document.getElementById("TSTPLTypeDefineDRz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("STPLTypeDefineDR",myvalue);
		
		var myobj=document.getElementById("TTypeDefinez"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("TypeDefine",myvalue);
		
		var myobj=document.getElementById("TSTPLDateFromz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("STPLDateFrom",myvalue);

		var myobj=document.getElementById("TSTPLDateToz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("STPLDateTo",myvalue);
		
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

function SetTypeDefine(value)
{
	var myary=value.split("^");
	
	DHCWebD_SetObjValueA("STPLTypeDefineDR",myary[1]);
	
}


document.body.onload = BodyLoadHandler;
document.body.onunload=BodyUnLoadHandler;


