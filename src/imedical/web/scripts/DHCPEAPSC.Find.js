function BodyLoadHandler(){
	//var obj=GetObj("BFind");
   //if (obj) obj.onclick=BFind_click;
    var obj=GetObj("RegNo");
    if (obj) obj.onkeydown=RegNo_keydown;
    
    obj=document.getElementById("CardNo");
	if (obj) {
		obj.onchange=CardNo_Change;
		obj.onkeydown=CardNo_keydown;
	 }
	
	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}
	//initialReadCardButton();
	document.onkeydown=SetShortKey;
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
/*
function BFind_click()
{
	var RegNo=GetOneData("RegNo");
	var Name=GetOneData("Name");
	var Status=GetOneData("Status");
	var BeginDate=GetOneData("BeginDate");
	var EndDate=GetOneData("EndDate");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEAdvancePayment.Find"
			+"&RegNo="+RegNo
			+"&Name="+Name
			+"&Status="+Status
			+"&BeginDate="+BeginDate
			+"&EndDate="+EndDate;
	location.href=lnk; 
    return false;
}
*/
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
function SetShortKey()
{
	if (event.ctrlKey)
	{
		if (event.keyCode==80)
		{
			alert("CTRL+P")
		}
	}
}
document.body.onload = BodyLoadHandler;