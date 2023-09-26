////UDHCCON.Preferences.js

//// Default Config
//// 

function BodyLoadHandler(){
	/*var obj=document.getElementById("btnSave");
	if (obj){
		obj.onclick=Add_Click;
	}*/
	
	var obj=document.getElementById("btnDelete");
	if (obj){
		obj.onclick=Delete_Click;
	}
	
	var obj=document.getElementById("IPFlag");
	if (obj){
		obj.onclick=IPFlag_OnClick;
	}
	
	var obj=document.getElementById("UserFlag");
	if (obj){
		obj.onclick=UserFlag_OnClick;
	}
	
	var obj=document.getElementById("GroupFlag");
	if (obj){
		obj.onclick = GroupFlag_OnClick;
	}
	
	var obj=document.getElementById("CTLocFlag");
	if (obj){
		obj.onclick = CTLocFlag_OnClick;
	}
	
	var obj=document.getElementById("CTHospitalFlag");
	if (obj){
		obj.onclick = CTHospitalFlag_OnClick;
	}
	
	InitDoc();
	document.onkeydown = DHCWeb_EStopSpaceKey;
	
	var obj=document.getElementById("CanNoCread");
	if (obj){
		obj.onclick = SaveCardSet;
	}
	var obj=document.getElementById("AllowAgeNoCreadCard");
	if (obj){
		obj.onkeyup = AllowAgeNoCreadCard;
	}
}

function AllowAgeNoCreadCard(e)
{
	var key=websys_getKey(e);
	if (key==13){
		var AllowAgeNoCreadCard=""
		var obj=document.getElementById("AllowAgeNoCreadCard");
		if (obj){AllowAgeNoCreadCard=obj.value}
		var Return=tkMakeServerCall("web.DHCDocConfig","SetDHCDocCardConfig","AllowAgeNoCreadCard",AllowAgeNoCreadCard);
		alert("OK")
	}
}

//保存建卡全局配置
function SaveCardSet()
{
	var CanNoCread="0"
	var obj=document.getElementById("CanNoCread");
	if ((obj)&&(obj.checked)){
		CanNoCread="1"
	}
	var Return=tkMakeServerCall("web.DHCDocConfig","SetDHCDocCardConfig","NOCREAD",CanNoCread);
	alert("OK")
	
}
function IPFlag_OnClick()
{
	SetDocumentValue("IPFlag","IP");
}

function UserFlag_OnClick()
{
	SetDocumentValue("UserFlag","UserList");
}

function GroupFlag_OnClick()
{
	SetDocumentValue("GroupFlag","GroupList");
}

function CTLocFlag_OnClick()
{
	SetDocumentValue("CTLocFlag","CTLocList");
	
}

function CTHospitalFlag_OnClick()
{
	SetDocumentValue("CTHospitalFlag","CTHospitalList");
}

function SetDocumentValue(FlagItemName,ItemName){
	DisableAll();
	ClearAll();
	
	DHCWebD_SetObjValueB(FlagItemName,true);
	var myobj=document.getElementById(ItemName);
	if (myobj){
		myobj.readOnly=false;
	}
	websys_setfocus(ItemName);
}


function ClearAll()
{
	DHCWebD_SetObjValueB("IPFlag",false);
	DHCWebD_SetObjValueB("IP","");
	DHCWebD_SetObjValueB("UserFlag",false);
	DHCWebD_SetObjValueB("UserList","");
	DHCWebD_SetObjValueB("GroupFlag",false);
	DHCWebD_SetObjValueB("GroupList","");
	DHCWebD_SetObjValueB("CTLocFlag",false);
	DHCWebD_SetObjValueB("CTLocList","");
	DHCWebD_SetObjValueB("CTHospitalFlag", false);
	DHCWebD_SetObjValueB("CTHospitalList","");
	DHCWebD_SetObjValueB("SITEFlag",false);
	DHCWebD_SetObjValueB("SITEList","");
	DHCWebD_SetObjValueB("UserListRowID","");
	DHCWebD_SetObjValueB("GroupListRowID","");
	DHCWebD_SetObjValueB("CTLocListRowID","");
	//DHCWeb_DisBtnA("btnDelete");
	
}

function DisableAll()
{
	var myobj=document.getElementById("IPFlag");
	if (myobj){
		///myobj.readOnly=true;
	}
	var myobj=document.getElementById("IP");
	if (myobj){
		myobj.readOnly=true;
	}
	var myobj=document.getElementById("UserFlag");
	if (myobj){
		///myobj.readOnly=true;
	}
	var myobj=document.getElementById("UserList");
	if (myobj){
		myobj.readOnly=true;
	}
	var myobj=document.getElementById("GroupFlag");
	if (myobj){
		///myobj.readOnly=true;
	}
	var myobj=document.getElementById("GroupList");
	if (myobj){
		///myobj.readOnly=true;
	}
	var myobj=document.getElementById("CTLocFlag");
	if (myobj){
		///myobj.readOnly=true;
	}
	var myobj=document.getElementById("CTLocList");
	if (myobj){
		//myobj.readOnly=true;
	}
	var myobj=document.getElementById("CTHospitalFlag");
	if (myobj){
		///myobj.readOnly=true;
	}
	var myobj=document.getElementById("CTHospitalList");
	if (myobj){
		//myobj.readOnly=true;
	}
	var myobj=document.getElementById("SITEFlag");
	if (myobj){
		///myobj.readOnly=true;
	}
	var myobj=document.getElementById("SITEList");
	if (myobj){
		myobj.readOnly=true;
	}
	
	//DHCWeb_DisBtnA("btnDelete");
	
}

function InitDoc(){
	
	DisableAll();
	ClearAll();
	
	DHCWebD_SetObjValueB("UserFlag",true);
	var myobj=document.getElementById("UserList");
	if (myobj){
		myobj.readOnly=false;
	}
	ReloadConfigDoc("U","")
}

function ItemFlag_OnClick(){
	var myRecFlag=DHCWebD_GetObjValue("ItemFlag");
	if (myRecFlag){
		var obj=document.getElementById("NSelArcItmCat");
		if (obj){
			obj.disabled=false;
		}
		var obj=document.getElementById("SelItemCat");
		if (obj){
			obj.disabled=false;
		}
		var obj=document.getElementById("AICAdd");
		if (obj){
			obj.disabled=false;
			obj.onclick=Add_Click;
		}
		var obj=document.getElementById("AICDel");
		if (obj){
			obj.disabled=false;
			obj.onclick=Delete_Click;
		}
		
	}else{
		DHCWeb_DisBtnA("NSelArcItmCat");
		DHCWeb_DisBtnA("SelItemCat");
		DHCWeb_DisBtnA("AICAdd");
		DHCWeb_DisBtnA("AICDel");
	}
}

function Add_Click(){
	DHCWeb_TransListData("NSelArcItmCat","SelItemCat");
}

function Delete_Click(){
try{
	var ObjectType=parent.frames["UDHCCONXMLData"].document.getElementById("ObjectType").value;
	var ObjectReference=parent.frames["UDHCCONXMLData"].document.getElementById("ObjectReference").value;
	var Return=tkMakeServerCall("web.DHCBL.Configure.PatEnroll","DHCDeleteData",ObjectType,ObjectReference);
	if (Return>=0){
		alert("Ok")
	}
	else{alert("Fail")}
	}catch(e){alert(e)}

}

function BodyUnLoadHandler(){
	
}

function SetUserData(value)
{
	///alert(value);
	///
	var myary=value.split("^");
	DHCWebD_SetObjValueB("UserListRowID",myary[4]);
	ReloadConfigDoc("U",myary[4])
	Add_Click()
}

function SetGroupData(value)
{
	///
	var myary=value.split("^");
	DHCWebD_SetObjValueB("GroupListRowID",myary[1]);
	ReloadConfigDoc("G",myary[1])
	Add_Click()
	
}

function SetCTLocData(value)
{
	////,IP,U,L,G,H,S
	var myary=value.split("^");
	
	DHCWebD_SetObjValueB("CTLocListRowID",myary[0]);
	DHCWebD_SetObjValueB("CTLocList",myary[1]);
	ReloadConfigDoc("L",myary[2])
	Add_Click()
}

function SetCTHospitalList(value)
{
	var myary=value.split("^");
	
	DHCWebD_SetObjValueB("CTHospitalListRowID",myary[1]);
	ReloadConfigDoc("H",myary[1])
	Add_Click()
	
}

function ReloadConfigDoc(ObjectType, ObjectReference)
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCCON.PatEnroll&ObjectType="+ ObjectType+"&ObjectReference="+ObjectReference;
	parent.frames["UDHCCONXMLData"].location.href=lnk;
}

document.body.onload = BodyLoadHandler;
document.body.onunload=BodyUnLoadHandler;

