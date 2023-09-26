var SelectedRow=0
var TPEADMID=""
function BodyLoadHandler()
{	
	var obj;
	obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_click;
	obj=document.getElementById("BSend");
	if (obj){obj.onclick=BSend_click;}
	obj=document.getElementById("CardNo");
	if (obj) {
		obj.onchange=CardNo_Change;
		//obj.onkeydown=CardNo_KeyDown;
		obj.onkeydown=CardNo_keydown;
	}
	
	obj=document.getElementById("RegNo");
	if (obj) {
		obj.onkeydown=RegNo_keydown;
	}

	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}
	obj=document.getElementById("GroupDesc");
	if (obj) { obj.onchange=GroupDesc_Change; }
	//initialReadCardButton()
}

function GroupDesc_Change()
{
	var obj=document.getElementById("GroupID");
	if (obj) { obj.value=""; }
	var obj=document.getElementById("GroupDesc");
	if (obj) { obj.value=""; }

}
function AfterGroupSelected(value){
	if (""==value){return false}
	var aiList=value.split("^");
	SetCtlValueByID("GroupID",aiList[0],true);
	SetCtlValueByID("GroupDesc",aiList[1],true);
	
}
function CardNo_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
		CardNo_Change();
	}
}
function RegNo_keydown(e)
{
	var Key=websys_getKey(e);
	if ((13==Key)) {
		BFind_click();
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

function BSend_click()
{	
	if (TPEADMID=="")
	{
		alert(t["NoSelect"]);
		return false;	
	}
	Update("0");
	return false;
}
function Update(Type)
{
	var obj=document.getElementById("UpdateClass");
	var encmeth="";
	if (obj) encmeth=obj.value;
	if (encmeth=="") return false;
	var GiftName="";
	var obj=document.getElementById("GiftName");
	if (obj) GiftName=obj.value;
	if (GiftName=="")
	{
		alert("赠品不能为空");
		return false;
	}
	var ReturnStr=cspRunServerMethod(encmeth,TPEADMID,Type,GiftName);
	if (ReturnStr=="Success")
	{
		BFind_click();
		return true;
	}
	if (ReturnStr=="HadGift")
	{
		if (!confirm(t[ReturnStr])) return;
		Update("1")
		return true;
	}
	alert(t[ReturnStr]);
	return false;
}
function BFind_click()
{
	var obj="";
	var BeginDate="",EndDate="",GroupID="",RegNo="",GiftFlag="0",GiftName="";
	obj=document.getElementById("BeginDate");
	if (obj) BeginDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	obj=document.getElementById("GroupID");
	if (obj) GroupID=obj.value;
	obj=document.getElementById("RegNo");
	//if (obj) RegNo=obj.value;
	if (obj){ 
		RegNo=obj.value;
		if (RegNo.length<8 && RegNo.length>0) { RegNo=RegNoMask(RegNo); }
	}

	obj=document.getElementById("GiftFlag");
	if (obj&&obj.checked) GiftFlag="1";
	obj=document.getElementById("GiftName");
	if (obj) GiftName=obj.value;
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEGiftManager"            //+targeURL
    +"&BeginDate="+BeginDate
    +"&EndDate="+EndDate
    +"&GroupID="+GroupID
    +"&RegNo="+RegNo
    +"&GiftFlag="+GiftFlag
	+"&GiftName="+GiftName		;
	location.href=lnk;
}

function SelectRowHandler(){  
	var eSrc=window.event.srcElement;
	
	var objtbl=document.getElementById('tDHCPEDietManager');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	
	if (selectrow!=SelectedRow)
	{
		SelectedRow=selectrow;
		var obj;
		obj=document.getElementById("TPEADMz"+SelectedRow);
		if (obj) TPEADMID=obj.value;
	}
	else
	{
		SelectedRow=0
		TPEADMID="";
	}
	
}
document.body.onload = BodyLoadHandler;