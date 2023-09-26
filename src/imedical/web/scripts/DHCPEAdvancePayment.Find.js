function BodyLoadHandler(){
	var obj=GetObj("BFind");
    if (obj) obj.onclick=BFind_click;
    var obj=GetObj("RegNo");
    if (obj) obj.onkeydown=RegNo_keydown;
    
    obj=document.getElementById("CardNo");
	if (obj) {
		obj.onchange=CardNo_Change;
		obj.onkeydown=CardNo_keydown;
	}
	
	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}
	initialReadCardButton()
	ElementEnble()
}

function CardNo_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
		CardNo_Change();
	}
}

function CardNo_Change()
{
	CardNoChangeApp("RegNo","CardNo","BFind_click()","Clear_click()","0");
}
function ReadCard_Click()
{
	ReadCardApp("RegNo","BFind_click()","CardNo");
	
}
function BFind_click()
{
	
	var Type=GetOneData("Type");
	if(Type!="C"){
	var RegNo=GetOneData("RegNo");
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	if (RegNo.length<RegNoLength&&RegNo.length>0) {RegNo=RegNoMask(RegNo);}
	}else{
		var RegNo=GetOneData("RegNo");
	}

	var Name=GetOneData("Name");
	var Status=GetOneData("Status");
	var BeginDate=GetOneData("BeginDate");
	var EndDate=GetOneData("EndDate");
	var Type=GetOneData("Type");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEAdvancePayment.Find"
			+"&RegNo="+RegNo
			+"&Name="+Name
			+"&Status="+Status
			+"&BeginDate="+BeginDate
			+"&EndDate="+EndDate
			+"&Type="+Type;
	location.href=lnk; 
    return false;
}
function GetObj(ObjID)
{
	var obj=document.getElementById(ObjID);
	return obj;
}
function AL(String)
{
	alert(String)
}


function GetOneData(ElementName)
{
	var DataStr="";
	var obj=GetObj(ElementName);
	if (obj) DataStr=obj.value;
	return DataStr;
}

function RegNo_keydown(e)
{
	var key=websys_getKey(e);
	if ( 13==key) {
		BFind_click();
	}
}
function ElementEnble()
{
	var Type=GetOneData("Type");
	if (Type!="R")
	{
		var obj=GetObj("BRefund");
		//if (obj) obj.style.display="none";
		var obj=GetObj("cTitle");
		if (obj)
		{
			if (Type=="I") obj.innerText="贵宾卡管理";
			if (Type=="O") obj.innerText="折扣卡管理";
			if (Type=="C") obj.innerText="代金卡管理";
		}
		var obj=GetObj("cTTitle");
		if (obj)
		{
			if (Type=="I") obj.innerText="贵宾卡列表";
			if (Type=="O") obj.innerText="折扣卡列表";
			if (Type=="C") obj.innerText="代金卡列表";
		}

		if (Type=="C")
		{
			var obj=GetObj("cRegNo");
			if (obj) obj.innerText="代金卡号";
			var obj=GetObj("cCardNo");
			if (obj) obj.style.display="none";
			var obj=GetObj("CardNo");
			if (obj) obj.style.display="none";
			var obj=GetObj("BReadCard");
			if (obj) obj.style.display="none";
		}
		//var obj=GetObj("PayModeDR");
		//if (obj) obj.disabled=true;
	}
}
document.body.onload = BodyLoadHandler;