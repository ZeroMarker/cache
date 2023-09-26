////UDHCOPINSPMRef.js

function BodyLoadHandler() {
	var obj=document.getElementById("Add");
	if (obj){
		obj.onclick=Add_OnClick;
	}
	var obj=document.getElementById("Edit");
	if (obj){
		obj.onclick=Edit_OnClick;
	}
	DHCWeb_DisBtnA("Edit");
	DHCWeb_DisBtnA("BDelete")
	var obj=document.getElementById("tUDHCOPINSPMRef");
	if (obj){
		//obj.ondblclick=UDHCOPINSPMRef_OnDBClick;
	}
	
	var obj=document.getElementById("INSType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		if(obj.options.length>0){
			obj.options.selectedIndex=0;
		}
	}
	var obj=document.getElementById("PMDesc");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		if(obj.options.length>0){
			obj.options.selectedIndex=0;
		}
	}
	
}

function IntDoc(){
	
}

function SelectRowHandler(){
	var tabOPList=document.getElementById('tUDHCOPINSPMRef');
	var selectrow=DHCWeb_GetRowIdx(window);
	if (selectrow<0){
		return;
	}
	var obj=document.getElementById("TINSTypez"+selectrow);
	var myTCode=DHCWebD_GetCellValue(obj);

	var obj=document.getElementById("TPMDescz"+selectrow);
	var myTDesc=DHCWebD_GetCellValue(obj);

	var obj=document.getElementById("TRowIDz"+selectrow);
	var myTRowID=DHCWebD_GetCellValue(obj);

	var obj=document.getElementById("TINSTypeRowIDz"+selectrow);
	var myTINSTypeRowID=DHCWebD_GetCellValue(obj);

	var obj=document.getElementById("TPMRowIDz"+selectrow);
	var myTPMRowID=DHCWebD_GetCellValue(obj);
	
	///(ObjName,DefValue,SplitVal,DefIdx)
	DHCWeb_SetListDefaultValue("INSType",myTINSTypeRowID, "^",0);
	DHCWeb_SetListDefaultValue("PMDesc",myTPMRowID, "^",0);
	DHCWebD_SetObjValueB("RowID",myTRowID);
	
	DHCWeb_DisBtnA("Add");
	var obj=document.getElementById("Edit");
	if (obj){
		DHCWeb_AvailabilityBtnA(obj,Edit_OnClick)
		//obj.disabled=false;
		//obj.onclick=Edit_OnClick;
	}
	
	var obj=document.getElementById("BDelete");
	if (obj){
		DHCWeb_AvailabilityBtnA(obj,Del_OnClick)
		//obj.disabled=false;
		//obj.onclick=Del_OnClick;
	}
	
}

function Del_OnClick(){
	var encmeth=DHCWebD_GetObjValue("DelEncrypt");
	if (encmeth!=""){
		var myRowID=DHCWebD_GetObjValue("RowID");
		if (myRowID==""){
			return;
		}
		var myrtn=cspRunServerMethod(encmeth,myRowID)
		var myary=myrtn.split("^");
		if (myary[0]=="0"){
			alert(t["SaveOK"]);
			ReLoadH();
		}else{
			alert(t["SaveErr"]);
		}
		
	}
}

function Add_OnClick(){
	var mystr=BuildStr();
	if (mystr==""){
		return;
	}
	var myINSType=DHCWeb_GetListBoxValue("INSType");
	var myPMRowID=DHCWeb_GetListBoxValue("PMDesc");
	
	var encmeth=DHCWebD_GetObjValue("AddEncrypt");
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth, myINSType, myPMRowID, mystr)
		var myary=myrtn.split("^");
		if (myary[0]=="0"){
			alert(t["SaveOK"]);
			ReLoadH();
		}else{
			alert(t[myary[0]]);
		}
	}
	
}

function ReLoadH(){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCOPINSPMRef";
	location.href=lnk;
	
}

function Edit_OnClick(){
	var mystr=BuildStr();
	if (mystr==""){
		return;
	}
	
	var encmeth=DHCWebD_GetObjValue("EditEcrypt");
	if (encmeth!=""){
		var myRowID=DHCWebD_GetObjValue("RowID");
		if (myRowID==""){
			return;
		}
		var myrtn=cspRunServerMethod(encmeth,myRowID, mystr)
		var myary=myrtn.split("^");
		if (myary[0]=="0"){
			alert(t["SaveOK"]);
			ReLoadH();
		}else{
			alert(t["SaveErr"]);
		}
		
	}
	
}

function BuildStr(){
	var mystr="";
	var myary=new Array();
	
	myary[0]=DHCWebD_GetObjValue("RowID");
	
	myary[1]=DHCWeb_GetListBoxValue("INSType");
	myary[2]=DHCWeb_GetListBoxValue("PMDesc");
	
	if (myary[2]!=""){
		mystr=myary.join("^");
	}
	
	return mystr;
	
}

document.body.onload = BodyLoadHandler;

