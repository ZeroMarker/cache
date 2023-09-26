var SelectedRow=0
var TPEADMID=""
var vRoomRecordID=""
function BodyLoadHandler()
{	
	var obj;
	obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_click;
	
	//发饭
	obj=document.getElementById("BSend");
	if (obj){obj.onclick=BSend_click;}
	
	//取消发饭
	obj=document.getElementById("BCancelDiet");
	if (obj){obj.onclick=BCancelDiet_click;}

	obj=document.getElementById("CardNo");
	if (obj) {obj.onchange=CardNo_Change;
	obj.onkeydown=CardNo_KeyDown;}
	
	//added by xy 20151023
	obj=document.getElementById("RegNo");
	if (obj){ obj.onkeydown=RegNo_KeyDown;}	

	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}
	obj=document.getElementById("GroupDesc");
	if (obj) { obj.onchange=GroupDesc_Change; }
	obj=document.getElementById("BWaitList");
	if (obj) {obj.onclick=BWaitList_Click;}
	obj=document.getElementById("BComplete");
	if (obj) {obj.onclick=BComplete_Click;}
	SetRoomID();
	SetColor();
	//initialReadCardButton()
}

function BCancelDiet_click()
{
	CancelDiet("0");
	return false;
}
function CancelDiet(Type)
{
	if (TPEADMID=="")
	{
		alert(t["NoSelect"]);
		return false; 
	}
	
	var obj=document.getElementById("TCountz"+SelectedRow);
	if(obj){var TCount=obj.innerText;} 
	var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","CancelDiet",TPEADMID,Type,TCount);

	
if (ReturnStr=="NCancelDiet")
	{ 
		alert("不能取消发饭")
		location.reload();
		return true;
	}
if (ReturnStr=="Success")
	{ 
		alert("取消发饭成功")
		location.reload();
		return true;
	}
	if (ReturnStr=="CancelDiet")
	{
		if (!confirm("是否确定取消发饭")) return;
		CancelDiet("1");
		return true;
	}
	
	return false;
}


//added by xy 20151023
function RegNo_KeyDown(e){
	var Key=websys_getKey(e);
	if ((13==Key)) {
		BFind_click();
        BSend_click();
	}
}

function SetRoomID()
{
	var Info=GetComputeInfo("");  //计算机名称  DHCPECommon.js
	var encmeth=GetValue("GetRoomIDClass");
	var RoomID=cspRunServerMethod(encmeth,Info);
	var Arr=RoomID.split("$")
	var Flag=Arr[1];
	/*
	if (Flag=="N"){
		var obj=GetObj("BActiveRoom");
		if (obj) obj.innerText="激活诊室";
	}*/
	var RoomID=Arr[0];
	SetValue("RoomID",RoomID);
	var encmeth=GetValue("GetCheckInfoClass");
	var UserID=session['LOGON.USERID'];
	var CheckInfo=cspRunServerMethod(encmeth,RoomID,UserID);
	var Arr=CheckInfo.split("$");
	var NumInfo=Arr[0];
	var NumArr=NumInfo.split("^");
	var PersonInfo=Arr[1];
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail&AdmStr="+PersonInfo
	var Info="共<font color=red size=6>"+NumArr[0]+"</font>人,已检<font color=red size=6>"+NumArr[1]+"</font>人,<a href="+lnk+" target='_blank' >未检<font size=6>"+NumArr[2]+"</font>人</a>"
	var obj=document.getElementById("cCheckInfo");
	//if (obj) obj.innerHTML=Info;
	
}
function SetColor()
{
	var objtbl=document.getElementById('tDHCPEDietManager');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
}
function SetVip()
{
	var eSrc=window.event.srcElement;
	alert(eSrc.id)
	alert(eSrc.value)
}
//等待列表
function BWaitList_Click()
{
	if (vRoomRecordID!=""){
		if (!confirm("当前体检者,还没有完成,是否开始下一个?")){
			return false;
		}
	}
	vRoomRecordID="";
	var RoomID=GetValue("RoomID");
	if (RoomID==""){
		alert("电脑没有设置对应的诊室");
		return false;
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPERoomRecordDetail&RoomID="+RoomID;
	var PWidth=window.screen.width
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,titlebar=yes,'
			+'height='+400+',width='+720+',left='+260+',top=0'
			;

	var ALertWin=window.open(lnk,"AlertWin",nwin)
	return false;
}
function BComplete_Click()
{
	var RecordID=vRoomRecordID;
	var RoomID=GetValue("RoomID");
	var encmeth=GetValue("CompleteClass");
	
	var PAADM=GetValue("TPAADMz"+SelectedRow);
	if (PAADM==""){
		alert("没有就诊患者");
		return false;
	}
	var ret=cspRunServerMethod(encmeth,RecordID,PAADM,RoomID);
	var Arr=ret.split("^");
	vRoomRecordID="";
	//if (Arr[0]!="0") 
	var obj=document.getElementById("cCheckInfo");
	if (obj) obj.innerText=Arr[1];
	alert(Arr[1]);
	BWaitList_Click();
}

function GroupDesc_Change()
{
	var obj=document.getElementById("GroupID");
	if (obj) { obj.value=""; }
}
function AfterGroupSelected(value){
	if (""==value){return false}
	var aiList=value.split("^");
	SetCtlValueByID("GroupID",aiList[0],true);
	SetCtlValueByID("GroupDesc",aiList[1],true);
	
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
	/*
	if (TPEADMID=="")
	{
		alert(t["NoSelect"]);
		return false;	
	}
	*/

	Update("0");
	return false;
}

/*
function Update(Type)
{
	var obj=document.getElementById("UpdateClass");
	var encmeth="";
	if (obj) encmeth=obj.value;
	if (encmeth=="") return false;
	var ReturnStr=cspRunServerMethod(encmeth,TPEADMID,Type);
	if (ReturnStr=="Success")
	{
		location.reload();
		return true;
	}
	if (ReturnStr=="HadDiet")
	{
		if (!confirm(t[ReturnStr])) return;
		Update("1")
		return true;
	}
	alert(t[ReturnStr]);
	return false;
}

*/

function Update(Type)  
{
	var iRegNo="",TPEADMID="",obj;
	obj=document.getElementById("RegNo");
	if(obj){
		var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
		iRegNo=obj.value;
		if (iRegNo.length<RegNoLength && iRegNo.length>0) { iRegNo=RegNoMask(iRegNo);}
	}
	
	var obj=document.getElementById("TPEADMz"+SelectedRow);
	if (obj) TPEADMID=obj.value;

	if(iRegNo==""){
		var TPEADMID=TPEADMID;
	}else{
		TPEADMID=iRegNo+"^";
	}
	
	if (TPEADMID=="")
	{
		alert(t["NoSelect"]);
		return false; 
	}
if(ReturnStr=="NCanntDiet")
	{
		alert("没有就餐权限");
		return true;
	}
	var obj=document.getElementById("UpdateClass");
	var encmeth="";
	if (obj) encmeth=obj.value;
	if (encmeth=="") return false;
	
	var ReturnStr=cspRunServerMethod(encmeth,TPEADMID,Type);
	if(ReturnStr=="NoPerson")
	{
		alert("没有选择就餐人员");
		return true;
	}
	if (ReturnStr=="Success")
	{ 
		alert("就餐成功")
		location.reload();
		return true;
	}
	if (ReturnStr=="HadDiet")
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
	var BeginDate="",EndDate="",GroupID="",RegNo="",DietFlag="";
	var iVIPID="";
	obj=document.getElementById("BeginDate");
	if (obj) BeginDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	obj=document.getElementById("GroupID");
	if (obj) GroupID=obj.value;
	obj=document.getElementById("RegNo");
	if (obj) RegNo=obj.value;
	if (RegNo.length<8 && RegNo.length>0) { RegNo=RegNoMask(RegNo); } //added by xy 20151023
	obj=document.getElementById("DietFlag");
	if (obj&&obj.checked) DietFlag="Y";
	obj=document.getElementById("VIPLevel");
	if (obj) iVIPID=obj.value;
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEDietManager"            //+targeURL
    +"&BeginDate="+BeginDate
    +"&EndDate="+EndDate
    +"&GroupID="+GroupID
    +"&RegNo="+RegNo
    +"&DietFlag="+DietFlag
    +"&VIPLevel="+iVIPID
	;
		//alert(lnk)
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
function GetObj(ElementName)
{
	return document.getElementById(ElementName)
}
function GetValue(ElementName)
{
	var obj=GetObj(ElementName)
	if (obj){
		return obj.value;
	}else{
		return "";
	}
}
function SetValue(ElementName,value)
{
	var obj=GetObj(ElementName)
	if (obj){
		obj.value=value;
	}
}

document.body.onload = BodyLoadHandler;