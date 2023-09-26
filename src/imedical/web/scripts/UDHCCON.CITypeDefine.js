////UDHCCON.CITypeDefine.js

function BodyLoadHandler(){
	IntDoc();
}

function BodyUnLoadHandler(){
	
}

function IntDoc(){
	var myobj=document.getElementById("CTDActiveFlag");
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
	DHCWeb_DisBtnA("BtnDelete");
	DHCWeb_DisBtnA("btnRecOrdRule");
	DHCWeb_DisBtnA("btnItmMastRule");
	
}


function Update_OnClick(){
	///update for DHC_OPGroupSettings  and DHC_OPGSPayMode
	
	var myGSRowID=DHCWebD_GetObjValue("GSRowID");
	var myValue=DHCWebD_GetObjValue("InitCITypeDefineEncrypt");
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

function btnRecOrdRule_OnClick()
{
	var mylnk="";
	var myCIRowID=DHCWebD_GetObjValue("CTDRowID");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCCON.CITypeDefineRule&CTDRowID="+myCIRowID;
	var chargeframe=parent.frames['UDHCCON_CITypeDefineRule'];
	if (chargeframe){
		chargeframe.location.href=lnk;
	}
}

function btnItmMastRule_OnClick()
{
	var mylnk="";
	var myCIRowID=DHCWebD_GetObjValue("CTDRowID");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCCON.CITypeDefineRule&CTDRowID="+myCIRowID;
	var chargeframe=parent.frames['UDHCCON_CITypeDefineRule'];
	if (chargeframe){
		chargeframe.location.href=lnk;
	}
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
		DHCWebD_SetObjValueA("CTDCode","");
		DHCWebD_SetObjValueA("CTDDesc","");
		DHCWebD_SetObjValueXMLTrans("CTDActiveFlag","");
		DHCWebD_SetObjValueA("CTDDateFrom","");
		DHCWebD_SetObjValueA("CTDDateTo","");
		DHCWebD_SetObjValueA("CTDRowID","");
		DHCWebD_SetObjValueA("CTDInstruction","");
		
		//// Enable Add
		var myobj=document.getElementById("btnAdd");
		if (myobj){
			myobj.disabled=false;
			myobj.onclick=Update_OnClick;
		}
		DHCWeb_DisBtnA("btnUpdate");
		DHCWeb_DisBtnA("BtnDelete");
		DHCWeb_DisBtnA("btnRecOrdRule");
		DHCWeb_DisBtnA("btnItmMastRule");
	}
	else
	{
		
		var myobj=document.getElementById("TCTDCodez"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("CTDCode",myvalue);
		
		var myobj=document.getElementById("TCTDDescz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("CTDDesc",myvalue);
		
		var myobj=document.getElementById("TCTDActiveFlagz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueXMLTrans("CTDActiveFlag",myvalue);
		
		var myobj=document.getElementById("TCTDDateFromz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("CTDDateFrom",myvalue);

		var myobj=document.getElementById("TCTDDateToz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("CTDDateTo",myvalue);

		var myobj=document.getElementById("TCTDRowIDz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("CTDRowID",myvalue);
		
		///
		var myobj=document.getElementById("TCTDInstructionz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("CTDInstruction",myvalue);
			
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
		
		var myobj=document.getElementById("btnRecOrdRule");
		if (myobj){
			myobj.disabled=false;
			myobj.onclick=btnRecOrdRule_OnClick;
		}
		
		var myobj=document.getElementById("btnItmMastRule");
		if (myobj){
			myobj.disabled=false;
			myobj.onclick=btnItmMastRule_OnClick;
		}
		
		
		
		DHCWeb_DisBtnA("btnAdd");
	}
	btnRecOrdRule_OnClick();
	///SelectedRow = selectrow;
	
}

document.body.onload = BodyLoadHandler;
document.body.onunload=BodyUnLoadHandler;


