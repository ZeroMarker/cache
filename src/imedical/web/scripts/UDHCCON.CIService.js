////UDHCCON.CIService.js

function BodyLoadHandler(){
	IntDoc();
}

function BodyUnLoadHandler(){
	
}

function IntDoc(){
	var myobj=document.getElementById("CISActiveFlag");
	if (myobj){
		myobj.multiple=false;
		myobj.size=1;
	}

	var myobj=document.getElementById("btnAdd");
	if (myobj){
		myobj.disabled=false;
		myobj.onclick=Update_OnClick;
	}
	
	DHCWeb_DisBtnA("btnUpdate");
	DHCWeb_DisBtnA("btnDelete");
	
}


function Update_OnClick(){
	///
	var myValue=DHCWebD_GetObjValue("InitCIServiceEncrypt");
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
		DHCWebD_SetObjValueXMLTrans("CISActiveFlag","");
		DHCWebD_SetObjValueA("CISCode","");
		DHCWebD_SetObjValueA("CISDesc","");
		DHCWebD_SetObjValueA("CIRowID","");
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
		
		var myobj=document.getElementById("TCISCodez"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("CISCode",myvalue);
		
		var myobj=document.getElementById("TCISDescz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("CISDesc",myvalue);
		
		var myobj=document.getElementById("TCIRowIDz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("CIRowID",myvalue);
		
		var myobj=document.getElementById("TCISActiveFlagz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueXMLTrans("CISActiveFlag",myvalue);
		
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
	
	////UDHCCON_CIServiceTypeList
	var mylnk="";
	var myCIRowID=DHCWebD_GetObjValue("CIRowID");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCCON.CIServiceTypeList&CIRowID="+myCIRowID;
	var chargeframe=parent.frames['UDHCCON_CIServiceTypeList'];
	if (chargeframe){
		chargeframe.location.href=lnk;
	}
	///SelectedRow = selectrow;
	
}


document.body.onload = BodyLoadHandler;
document.body.onunload=BodyUnLoadHandler;


