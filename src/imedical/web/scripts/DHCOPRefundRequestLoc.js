////DHCOPRefundRequestLoc.js
//add 2008-08-13 at feifang
var Guser
function BodyLoadHandler() {
	Guser=session['LOGON.USERID']
	var obj=document.getElementById("Add");
	if (obj){
		obj.onclick=Add_OnClick;
	}
	var obj=document.getElementById("Cancel");
	if (obj){
		obj.onclick=ReLoadH;
	}
	var obj=document.getElementById("Edit");
	if (obj){
		obj.onclick=Edit_OnClick;
	}
	DHCWeb_DisBtnA("Edit");
	DHCWeb_DisBtnA("BDelete")
	var obj=document.getElementById("tDHCOPRefundRequestLoc");
	if (obj){
		//obj.ondblclick=DHCOPRefundRequestLoc_OnDBClick;
	}
	var obj=document.getElementById("GroupDesc");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		//alert(obj.options.length)
		if(obj.options.length>0){
			obj.options.selectedIndex=0;
		}
	}
	var obj=document.getElementById("LocDesc");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		if(obj.options.length>0){
			obj.options.selectedIndex=0;
		}
	}	
}
function IntDoc()
{	
}
function SelectRowHandler(){
	var tabOPList=document.getElementById('tDHCOPRefundRequestLoc');
	var selectrow=DHCWeb_GetRowIdx(window);
	if (selectrow<0){
		return;
	}
	var obj=document.getElementById("TGroupDescz"+selectrow);
	var myTCode=DHCWebD_GetCellValue(obj);
	var obj=document.getElementById("TLocDescz"+selectrow);
	var myTDesc=DHCWebD_GetCellValue(obj);
	var obj=document.getElementById("TRowIDz"+selectrow);
	var myTRowID=DHCWebD_GetCellValue(obj);
	var obj=document.getElementById("TGroupRowIDz"+selectrow);
	var myTGroupRowID=DHCWebD_GetCellValue(obj);
	var obj=document.getElementById("TLocRowIDz"+selectrow);
	var myTLocRowID=DHCWebD_GetCellValue(obj);
	//(ObjName,DefValue,SplitVal,DefIdx)
	DHCWeb_SetListDefaultValue("GroupDesc",myTGroupRowID, "^",0);
	DHCWeb_SetListDefaultValue("LocDesc",myTLocRowID, "^",0);
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
			alert(t["DelOK"]);
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
	var myGroupDesc=DHCWeb_GetListBoxValue("GroupDesc");
	var myLocDesc=DHCWeb_GetListBoxValue("LocDesc");
	
	var encmeth=DHCWebD_GetObjValue("AddEncrypt");
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth, myGroupDesc, myLocDesc, mystr)
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
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPRefundRequestLoc";
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
	myary[1]=DHCWeb_GetListBoxValue("GroupDesc");
	myary[2]=DHCWeb_GetListBoxValue("LocDesc");
	myary[3]=Guser
	if (myary[3]!=""){
		mystr=myary.join("^");
	}
	return mystr;
}

document.body.onload = BodyLoadHandler;

