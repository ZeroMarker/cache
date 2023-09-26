////UDHCCON.PatEnroll.js

function BodyLoadHandler(){
	InitDoc();
	
	var myobj=document.getElementById("btnPatTypeAdd");
	if (myobj){
		myobj.onclick=btnPatTypeAdd_OnClick;
	}

	var myobj=document.getElementById("btnPatTypeDel");
	if (myobj){
		myobj.onclick=btnPatTypeDel_OnClick;
	}

	var myobj=document.getElementById("btnCardTypeAdd");
	if (myobj){
		myobj.onclick=btnCardTypeAdd_OnClick;
	}
	
	var myobj=document.getElementById("btnCardTypeDel");
	if (myobj){
		myobj.onclick=btnCardTypeDel_OnClick;
	}
	
	var myobj=document.getElementById("btnSave");
	if (myobj){
		myobj.onclick=Save_Click;
	}
	
	///var myvalue=DHCWebD_GetObjValueXMLTransA("WaitForPatTypeList");
	///alert(myvalue);
	
	/// Last Load Data
	/// Load Default Config
	/// Load Configer
	var myObjectType=DHCWebD_GetObjValue("ObjectType");
	var myObjectReference=DHCWebD_GetObjValue("ObjectReference");
	///LoadDataByObjectType(myObjectType,myObjectReference);
	
	document.onkeydown = DHCWeb_EStopSpaceKey;
}

function LoadDataByObjectType(ObjectType, ObjectReference)
{
	var encmeth=DHCWebD_GetObjValue("ReadDataEncrypt");
	if (encmeth!=""){
		///",IP,U,L,G,H,S"
		var rtnvalue=(cspRunServerMethod(encmeth,ObjectType, ObjectReference));
		///alert(rtnvalue);
		if (rtnvalue!=""){
			///alert(rtnvalue);
			DHCDOM_SetDOCItemValueByXML(rtnvalue);
		}
		if (rtnvalue!=""){
			///DHCDOM_SetDOCListItemValueByXML(rtnvalue,"","")
			///DHCDOM_SetDOCListItemValueByXML(rtnvalue,"","")
		}
	}
	
}

function IP_OnKeyPress()
{
	
}

function btnPatTypeAdd_OnClick()
{
	DHCWeb_TransListData("WaitForPatTypeList","PatTypeList");
	SetListObjectSelect("PatTypeList");
}

function btnPatTypeDel_OnClick()
{
	DHCWeb_TransListData("PatTypeList","WaitForPatTypeList");
}

function btnCardTypeAdd_OnClick()
{
	DHCWeb_TransListData("WaitForCardTypeList","CardTypeList");
	SetListObjectSelect("CardTypeList");
}

function SetListObjectSelect(ListName)
{
	var myobj=document.getElementById(ListName);
	if (myobj){
		var myCount=myobj.options.length;
		
		for (var myIdx=0; myIdx<myCount; myIdx++){
			myobj.options[myIdx].selected=true;
		}
	}
}

function btnCardTypeDel_OnClick()
{
	DHCWeb_TransListData("CardTypeList","WaitForCardTypeList");
}

function GetConfiXmlData()
{
}

////Init Value
function InitDoc(){
	
	var obj=document.getElementById("CardRefFlag");
	if (obj) {
		obj.size=1;
		obj.multiple=false;
	}
	
	var obj=document.getElementById("PatMasFlag");
	if (obj) {
		obj.size=1;
		obj.multiple=false;
	}
	
	var obj=document.getElementById("AccManageFLag");
	if (obj) {
		obj.size=1;
		obj.multiple=false;
	}
	
	var obj=document.getElementById("DefaultCardTypeDR");
	if (obj) {
		obj.size=1;
		obj.multiple=false;
	}
	
	var obj=document.getElementById("DefaultIDEquipDR");
	if (obj) {
		obj.size=1;
		obj.multiple=false;
	}
	
	var obj=document.getElementById("DefaultPatTypeDR");
	if (obj) {
		obj.size=1;
		obj.multiple=false;
	}
	SetListObjectSelect("CardTypeList");
	SetListObjectSelect("PatTypeList");
	
	var myObjectType=DHCWebD_GetObjValue("ObjectType");
	var myObjectReference=DHCWebD_GetObjValue("ObjectReference");
	LoadDataByObjectType(myObjectType,myObjectReference);
	
}


function Add_Click(){
	DHCWeb_TransListData("NSelArcItmCat","SelItemCat");
}

function Delete_Click(){
	DHCWeb_TransListData("SelItemCat","NSelArcItmCat");
}

function Save_Click(){
	SetListObjectSelect("CardTypeList");
	SetListObjectSelect("PatTypeList");
	
	var mystr=BuildStr();
	var myExpStr="";
	var myObjectType=DHCWebD_GetObjValue("ObjectType");
	var myObjectReference=DHCWebD_GetObjValue("ObjectReference");
	///myObjectType="U";
	///myObjectReference="12";
	var encmeth=DHCWebD_GetObjValue("SaveDataEncrypt");
	if (encmeth!=""){
		///",IP,U,L,G,H,S"
		var rtnvalue=(cspRunServerMethod(encmeth,myObjectType, myObjectReference, mystr));
		var myary=rtnvalue.split("^");
		if (myary[0]=="0"){
			alert(t["SaveOK"]);
		}else{
			alert(t["SaveFail"]);
		}
	}
}

function BuildStr(){
	var myparseinfo = DHCWebD_GetObjValue("InitPatEnrollEntity");
	///var myxml=DHCDOM_GetEntityClassInfoToXML(myparseinfo)
	var myxml=DHCDOM_GetEntityClassInfoToXMLA(myparseinfo);
	return myxml;
}

function SetDefaultCountry(value)
{
	var myary=value.split("^");
	DHCWebD_SetObjValueB("DefaultCountryDR",myary[1]);
}

function SetDefaultNation(value)
{
	var myary=value.split("^");
	DHCWebD_SetObjValueB("DefaultNationDR",myary[1]);
}

function SetDefaultProvince(value)
{
	var myary=value.split("^");
	DHCWebD_SetObjValueB("DefaultProvinceDR",myary[1]);
}

function SetDefaultCity(value)
{
	var myary=value.split("^");
	DHCWebD_SetObjValueB("DefaultCityDR",myary[1]);
}


function BodyUnLoadHandler(){
	
}

document.body.onload = BodyLoadHandler;
document.body.onunload=BodyUnLoadHandler;

