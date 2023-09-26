////UDHCCON.CITypeDefineRule.js

function BodyLoadHandler(){
	IntDoc();
}

function BodyUnLoadHandler(){
	
}

function IntDoc(){
	var myobj=document.getElementById("TORActiveFlag");
	if (myobj){
		myobj.multiple=false;
		myobj.size=1;
	}

	var myobj=document.getElementById("TORActiveFlag");
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
	
}


function Update_OnClick(){
	///update for DHC_OPGroupSettings  and DHC_OPGSPayMode
	
	var myGSRowID=DHCWebD_GetObjValue("GSRowID");
	var myValue=DHCWebD_GetObjValue("InitCITypeDefineRuleEncrypt");
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
		DHCWebD_SetObjValueA("TORRecLocDesc","");
		DHCWebD_SetObjValueA("TORRecLocDR","");
		DHCWebD_SetObjValueXMLTrans("TORActiveFlag","");
		DHCWebD_SetObjValueA("TORCTHospitalDR","");
		
		DHCWebD_SetObjValueA("TORCTHospitalDesc","");
		DHCWebD_SetObjValueA("TORDateFrom","");
		DHCWebD_SetObjValueA("TORDateTo","");
		DHCWebD_SetObjValueA("TORTimeFrom","");
		DHCWebD_SetObjValueA("TORTimeTo","");
		DHCWebD_SetObjValueA("TORRowID","");
		
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
		
		var myobj=document.getElementById("TTORRecLocDescz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("TORRecLocDesc",myvalue);
		
		var myobj=document.getElementById("TTORRecLocDRz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("TORRecLocDR",myvalue);
		
		var myobj=document.getElementById("TTORActiveFlagz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueXMLTrans("TORActiveFlag",myvalue);
		
		var myobj=document.getElementById("TTORCTHospitalDRz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("TORCTHospitalDR",myvalue);

		var myobj=document.getElementById("TTORCTHospitalDescz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("TORCTHospitalDesc",myvalue);

		var myobj=document.getElementById("TTORDateFromz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("TORDateFrom",myvalue);

		var myobj=document.getElementById("TTORDateToz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("TORDateTo",myvalue);

		var myobj=document.getElementById("TTORTimeFromz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("TORTimeFrom",myvalue);

		var myobj=document.getElementById("TTORTimeToz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("TORTimeTo",myvalue);
		
		var myobj=document.getElementById("TTORRowIDz"+selectrow);
		var myvalue=DHCWebD_GetCellValue(myobj);
		DHCWebD_SetObjValueA("TORRowID",myvalue);
		
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

function SetRecLocInfo(value)
{
	var myary=value.split("^");
	DHCWebD_SetObjValueA("TORRecLocDR",myary[1]);
	
}

function SetHospitalInfo(value)
{
	var myary=value.split("^");
	DHCWebD_SetObjValueA("TORCTHospitalDR",myary[1]);
}


document.body.onload = BodyLoadHandler;
document.body.onunload=BodyUnLoadHandler;


