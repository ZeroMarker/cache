var CurRow=0
//var vRoomRecordID="";
var vRoomInfo="";
var vStatus="";
var vDetailStatus="";

function BodyIni()
{
	var obj;
	SetRoomInfo();
	CreateRoomRecordList();
	obj=document.getElementById("RegNo");
	if (obj) obj.onchange=RegNo_onchange;
	obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_Click;
	obj=document.getElementById("BSARef");
	if (obj) obj.onclick=BSARef_Click;
	obj=document.getElementById("BRef");
	if (obj) obj.onclick=BRef_Click;
	obj=document.getElementById("BSRRef");
	if (obj) obj.onclick=BSRRef_Click;
	obj=document.getElementById("BRRef");
	if (obj) obj.onclick=BRRef_Click;
	obj=document.getElementById("BShowSoftKey");
	if (obj) obj.onclick=ShowSoftKey_click;
	obj=document.getElementById("BWaitList");
	if (obj) {obj.onclick=BWaitList_Click;}
	obj=document.getElementById("BComplete");
	if (obj) {obj.onclick=BComplete_Click;}
	obj=document.getElementById("BActiveRoom");
	if (obj) {obj.onclick=BActiveRoom_Click;}
	obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	obj=document.getElementById("SpecNo");
	if (obj) obj.onkeydown=SpecNo_Keydown;
	SetSort("tDHCPESaveCollectSpec","TRowid",1);
	Init();
	obj.select();
	websys_setfocus("SpecNo");
	SetRoomID();
	
}

function BPrint_Click()
{ 
    var obj;
	var SpecNo="",PAADM="", PrintFlag="";
	obj=document.getElementById("SpecNo");
	if (obj) SpecNo=obj.value;
	obj=document.getElementById("IsCurDate");
	if (obj) encmeth=obj.value;
	if (encmeth=="") return false;
	var Value=cspRunServerMethod(encmeth,SpecNo);
	var Arr=Value.split("^");
	var PAADM=Arr[2];
	obj=document.getElementById("PrintBarCode");
	if(obj&&obj.checked){var PrintBarFlag=1;}
	if(PrintBarFlag==1){

		if (SpecNo!=""){
			PrintAllApp(SpecNo,"Spec","N")
		}
		else if(PAADM!="")
		{
			PrintAllApp(PAADM,"PAADM","N")
		}
	}	
	
}


function SetSort(TableName,ElementName,RowsOfPages)
{    
	var obj=document.getElementById(TableName);	
	if (obj) { var rows=obj.rows.length; }
	for (var j=1;j<rows;j++)
	{
		var obj=document.getElementById(ElementName+"z"+j)
		if (obj) obj.innerText=j;
	}
	
}
//全选取消
function BSARef_Click()
{
	var ObjArr=document.getElementsByName("TSelect");
	var ArrLength=ObjArr.length;
	for (var i=0;i<ArrLength;i++)
	{
		var IDInfo=ObjArr[i].id;
		var ID=IDInfo.split("^")[0];
		var obj=document.getElementById(ID);
		var Info=obj.value;
		if (Info=="取消") ObjArr[i].checked=!ObjArr[i].checked;
	}
}
//全取消
function BRef_Click()
{
	var ObjArr=document.getElementsByName("TSelect");
	var ArrLength=ObjArr.length;
	for (var i=0;i<ArrLength;i++)
	{
		if (ObjArr[i].checked)
		{
			var IDInfo=ObjArr[i].id;
			var ID=IDInfo.split("^")[0];
			var obj=document.getElementById(ID);
			var Info=obj.value;
			if (Info=="取消"){
				RefuseApp(ID);
			}
		}
	}
	window.location.reload();
}
//全选启用
function BSRRef_Click()
{
	var ObjArr=document.getElementsByName("TSelect");
	var ArrLength=ObjArr.length;
	for (var i=0;i<ArrLength;i++)
	{
		var IDInfo=ObjArr[i].id;
		var ID=IDInfo.split("^")[0];
		var obj=document.getElementById(ID);
		var Info=obj.value;
		if (Info=="启用") ObjArr[i].checked=!ObjArr[i].checked;
	}
}
//全启用
function BRRef_Click()
{
	var ObjArr=document.getElementsByName("TSelect");
	var ArrLength=ObjArr.length;
	for (var i=0;i<ArrLength;i++)
	{
		if (ObjArr[i].checked)
		{
			var IDInfo=ObjArr[i].id;
			var ID=IDInfo.split("^")[0];
			var obj=document.getElementById(ID);
			var Info=obj.value;
			if (Info=="启用"){
				RefuseApp(ID);
			}
		}
	}
	window.location.reload();
}
function BActiveRoom_Click()
{
	var eSrc=window.event.srcElement;
	var ActiveFlag="Y";
	if (eSrc.innerText=="关闭诊室"){
		ActiveFlag="N";
	}
	var ID=GetValue("RoomID");
	var encmeth=GetValue("ActiveRoomClass");
	var rtn=cspRunServerMethod(encmeth,ID,ActiveFlag);
	var Arr=rtn.split("^");
	if (Arr[0]=="-1"){
		alert(Arr[1]);
	}
	window.location.reload();
}
function SetRoomID()
{
	/*
	var Info=GetComputeInfo("");  //计算机名称  DHCPECommon.js
	var encmeth=GetValue("GetRoomIDClass");
	var RoomID=cspRunServerMethod(encmeth,Info);
	
	var RoomID=cspRunServerMethod(encmeth,Info);
	var Arr=RoomID.split("$")
	var Flag=Arr[1];
	if (Flag=="N"){
		var obj=GetObj("BActiveRoom");
		if (obj) obj.innerText="激活诊室";
	}*/
	var RoomID=GetValue("RoomID");;
	//SetValue("RoomID",RoomID);
	if (RoomID==""){
		var obj=GetObj("BWaitList");
		if (obj) obj.style.display='none';
		var obj=GetObj("BComplete");
		if (obj) obj.style.display='none';
		var obj=GetObj("BActiveRoom");
		if (obj) obj.style.display='none';
		var TotalLnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail";
		var Info="<a href="+TotalLnk+" target='_blank' >检查信息</a>"
	}else{
		var encmeth=GetValue("GetCheckInfoClass");
		var UserID=session['LOGON.USERID'];
		var CheckInfo=cspRunServerMethod(encmeth,RoomID,UserID);
		var Arr=CheckInfo.split("$");
		var NumInfo=Arr[0];
		var HadCheckStr=Arr[1];
		var NoCheckStr=Arr[2];
		var NumArr=NumInfo.split("^");
		var TotalPerson=NumArr[0];
		var HadCheckNum=NumArr[1];
		var NoCheckNum=NumArr[2];
		var NoCheckLnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail&AdmStr="+RoomID+NoCheckStr;
		var HadCheckLnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail&AdmStr="+RoomID+HadCheckStr;
		var TotalLnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail&StationID="+RoomID;
		var Info="<a href="+TotalLnk+" target='_blank' >共<font color=red size=6>"+TotalPerson+"</font>人</a>,<a href="+HadCheckLnk+" target='_blank' >已检<font color=red size=6>"+HadCheckNum+"</font>人</a>,<a href="+NoCheckLnk+" target='_blank' >未检<font size=6>"+NoCheckNum+"</font>人</a>"
	}
	var obj=document.getElementById("cCheckInfo");
	if (obj) obj.innerHTML=Info;
	
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

//等待列表
function BWaitList_Click()
{
	var RoomID=GetValue("RoomID");
	if (RoomID==""){
		alert("电脑没有设置对应的诊室");
		return false;
	}
	
	if (vRoomRecordID!=""){
		if (!confirm("当前体检者,还没有完成,是否开始下一个?")){
			return false;
		}
	}
	vRoomRecordID="";
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPERoomRecordDetail&RoomID="+RoomID+"&WaitInfo="+vRoomInfo;
	var PWidth=window.screen.width
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,titlebar=yes,'
			+'height='+400+',width='+720+',left='+260+',top=0'
			;

	var ALertWin=window.open(lnk,"AlertWin",nwin)
	return false;
}


function ShowSoftKey_click()
{
	var shell = new ActiveXObject("wscript.shell");

    	shell.run("osk.exe");
	return false;
}
function RegNo_onchange()
{
	/*
	if (vRoomRecordID!="")
	{
		if (!confirm("当前体检者,还没有完成,是否开始下一个?")){
			return false;
		}
	}
	vRoomRecordID="";
	*/
	var CurRegNo="";
	obj=document.getElementById("RegNo");
	if (obj) CurRegNo=obj.value;
	if (CurRegNo=="") return false;
	var Status=tkMakeServerCall("web.DHCPE.PreIADM","GetStatusByRegNo",CurRegNo);
	if(Status=="REGISTERED"){
	var url="dhcpecustomconfirmbox.csp?Type=Arrived";   
  	var  iWidth=300; //模态窗口宽度
  	var  iHeight=130;//模态窗口高度
  	var  iTop=(window.screen.height-iHeight)/2;
  	var  iLeft=(window.screen.width-iWidth)/2;
  	var dialog=window.showModalDialog(url, CurRegNo, "dialogwidth:300px;dialogheight:130px;center:1"); 
 	if(dialog){
		if(dialog!=1){
			return false;
		}
  		}
  	else{
    		return false;
  		}
	}
	Find();
}
function SpecNo_Keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) 
	{
		/*
		if (vRoomRecordID!="")
		{
			if (!confirm("当前体检者,还没有完成,是否开始下一个?")){
				return false;
			}
		}
		vRoomRecordID="";
		*/
		
			
		BSave_Click();
		
		
		
	}
	
}
function BSave_Click()
{
	var obj;
	vStatus="";
	vDetailStatus="";
	obj=document.getElementById("SpecNo");
	var SpecNo="",encmeth="",ReturnValue="";
	if (obj) SpecNo=obj.value;
	if (SpecNo=="") return false;
	
	obj=document.getElementById("IsCurDate");
	if (obj) encmeth=obj.value;
	if (encmeth=="") return false;
	Value=cspRunServerMethod(encmeth,SpecNo);
	var Arr=Value.split("^");
	var RegNoFlag=Arr[3];
	if (RegNoFlag=="1"){
		var Status=tkMakeServerCall("web.DHCPE.PreIADM","GetStatusByRegNo",SpecNo);
		if(Status=="REGISTERED"){
			var url="dhcpecustomconfirmbox.csp?Type=Arrived";   
			var  iWidth=300; //模态窗口宽度
			var  iHeight=130;//模态窗口高度
			var  iTop=(window.screen.height-iHeight)/2;
			var  iLeft=(window.screen.width-iWidth)/2;
			var dialog=window.showModalDialog(url, SpecNo, "dialogwidth:300px;dialogheight:130px;center:1");
			if(dialog!=1){
				return false;
			}
			var PIADM=tkMakeServerCall("web.DHCPE.PreIADM","GetPIADMByRegNo",SpecNo);
			if(PIADM==""){return false}
			var ArriveFlag=tkMakeServerCall("web.DHCPE.DHCPEIAdm","UpdateIADMInfo",PIADM,"3");
			if(ArriveFlag!="0"){alert("到达失败")}
	  	}
		obj=document.getElementById("SpecNo");
		if (obj) obj.value="";
		obj=document.getElementById("RegNo");
		if (obj) obj.value=SpecNo;
		obj=document.getElementById("PAADM");
		if (obj) obj.value=Arr[2];
	}else{
		obj=document.getElementById("RegNo");
		if (obj) obj.value="";
		var PAADM=Arr[2];
		var Status=tkMakeServerCall("web.DHCPE.PreIADM","GetStatusByPAADM",PAADM);
		var AdmArr=Status.split("^");
		if(AdmArr[0]=="REGISTERED"){
			var url="dhcpecustomconfirmbox.csp?Type=Arrived";   
			var  iWidth=300; //模态窗口宽度
			var  iHeight=130;//模态窗口高度
			var  iTop=(window.screen.height-iHeight)/2;
			var  iLeft=(window.screen.width-iWidth)/2;
			var dialog=window.showModalDialog(url, AdmArr[2], "dialogwidth:300px;dialogheight:130px;center:1");
			if(dialog!=1){
				return false;
			}
			var PIADM=AdmArr[1];
			if(PIADM==""){return false}
			var ArriveFlag=tkMakeServerCall("web.DHCPE.DHCPEIAdm","UpdateIADMInfo",PIADM,"3");
			if(ArriveFlag!="0"){alert("到达失败")}
	  	}
	}
	if (Arr[0]=="0"){
		alert(Arr[1]);
		return false;	
	}
	else if (Arr[0]=="1"){
		if (!(confirm("该标本体检者不是当天到达,是否继续标本核对?"))) {  return false; }
	}
	//alert(Value)
	var RoomID=GetValue("RoomID");
	if (RoomID!=""){
	
		var CurRoomID=Value.split("^")[1];
		vStatus=Value.split("^")[4];
		vDetailStatus=Value.split("^")[5];
		if ((CurRoomID!=vRoomRecordID)&&(vRoomRecordID!="")) //
		{
			if (!confirm("到达者和叫号者不是同一个人,是否继续?")) return false;
			
		}else if(vRoomRecordID==""){
			if (!confirm("没有叫号,是否继续?")) return false;
		}	
	}
	//parent.vRoomRecordID="";
	vRoomRecordID=CurRoomID;
	if (vStatus=="N"){  //判断是不是同一个人
		if (vDetailStatus!="E"){  //不是正检状态的，设置正检，下屏
			var encmeth=GetValue("ArriveCurRoomClass");
			var UserID=session['LOGON.USERID'];
			var ret=cspRunServerMethod(encmeth,vRoomRecordID,UserID,RoomID);
		}
	}
	
	/*
	obj=document.getElementById("SaveClass");
	if (obj) encmeth=obj.value;
	if (encmeth=="") return false;
	ReturnValue=cspRunServerMethod(encmeth,SpecNo);
	if (ReturnValue!="0")
	{
		alert(ReturnValue);
		//return false;
	}*/
	Find()
}
function Find()
{
	var obj;
	var RegNo="",SpecNo="",PAADM="";
	obj=document.getElementById("PAADM");
	if (obj) PAADM=obj.value;
	obj=document.getElementById("SpecNo");
	if (obj) SpecNo=obj.value;
	obj=document.getElementById("RegNo");
	if (obj) RegNo=obj.value;
	if ((vRoomRecordID=="")&&(SpecNo=="")&&(PAADM=="")){
		alert("当前就诊者和标本号不能都为空");
		return false;
	}
	var RoomID=GetValue("RoomID");
	if (RoomID==""){
	vRoomRecordID="";
	//PAADM="";
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPESaveCollectSpec&SpecNo="+SpecNo+"&RoomRecordID="+vRoomRecordID+"&RoomID="+RoomID+"&PAADM="+PAADM+"&RegNo="+RegNo;		
	/*try{
		if (SpecNo!=""){
			PrintAllApp(SpecNo,"Spec","N")
		}
		else if(PAADM!="")
		{
			PrintAllApp(PAADM,"PAADM","N")
		}
	}catch(e){}
	*/
	location.href=lnk;
}
function Init()
{
	var obj;
	var SpecNo="",RegNo="",encmeth;
	obj=document.getElementById("SpecNo");
	if (obj) SpecNo=obj.value;
	obj=document.getElementById("RegNo");
	if (obj) RegNo=obj.value;
	if ((SpecNo=="")&&(RegNo=="")) return false;
	obj=document.getElementById("GetInfoClass");
	if (obj) encmeth=obj.value;
	if (encmeth=="") return false;
	var Str=cspRunServerMethod(encmeth,RegNo,SpecNo);
	Str=Str.split("^");
	obj=document.getElementById("Name");
	if (obj) obj.value=Str[0];
	obj=document.getElementById("Sex");
	if (obj) obj.value=Str[1];
	obj=document.getElementById("CardID");
	if (obj) obj.value=Str[2];
	obj=document.getElementById("RegNo");
	if (obj) obj.value=Str[3];
	
	var tbl=document.getElementById('tDHCPESaveCollectSpec');
	var row=tbl.rows.length;
	
	for (var j=1;j<row;j++) {
		var sLable=document.getElementById('TDatez'+j);
		var strCell=sLable.innerText;
		strCell=strCell.replace(" ","")
		if(strCell=="")
		{
			tbl.rows[j].style.background="#FF0000"
		}
	}
	
	ColorTblColumn();
	return true;
}

function ColorTblColumn(){
	var tbl=document.getElementById('tDHCPESaveCollectSpec'); //取表格元素?名称
	var row=tbl.rows.length;
	row=row-1;
	for (var j=1;j<row+1;j++) {
		
	var objArcim=document.getElementById('TItemNamez'+j).parentElement;
	var objPlacerCode=document.getElementById('TPlacerColorz'+j);
	var placerCode="";
	
	if (objPlacerCode) {placerCode=objPlacerCode.value;}
	objArcim.bgColor=placerCode;
	/*
	switch (placerCode) 
	{
	   case "A":objArcim.className="Purple";break;//"Black"; break;
	   case "C":objArcim.className="Gray";break;
	   case "R":objArcim.className="Red";break;//objArcimDesc.style.color="Red";break;
	   case "P":objArcim.className="Fuchsia";break;
	   case "Y":objArcim.className="Yellow";break;//"#ffff80";objArcimDesc.style.FONTWEIGHT="bold";break;//"Yellow";break;
	   case "G":objArcim.className="Green";break;
	   case "H":objArcim.className="Black";break;
	   case "B":objArcim.className="Blue";break;
	   case "W":objArcim.className="White";break;
	   //case "O":objArcim.className="Maroon";break;
	   case "O":objArcim.className="Brown";break;
	   case "Q":objArcim.className="Orange";break;
	   default: //"Exec"
	   //RowObj.className="Exec";//AH "Needless";
	}
		*/
	
	}
}

//去除字符串两端的空格
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
/*
function BComplete_Click()
{
	var RecordID=vRoomRecordID;
	var RoomID=GetValue("RoomID");
	var encmeth=GetValue("CompleteClass");
	
	var PAADM=GetValue("TAdmIdz1");
	if (PAADM==""){
		alert("没有就诊患者");
		return false;
	}
	var ret=cspRunServerMethod(encmeth,RecordID,PAADM,RoomID);
	var Arr=ret.split("^");
	vRoomRecordID="";
	//if (Arr[0]!="0")
	var obj=document.getElementById("CheckInfo");
	if (obj) obj.value=Arr[1]; 
	//alert(Arr[1]);
	vRoomInfo=Arr[1];
	BWaitList_Click();
}
*/
function RefuseItem()
{
	var eSrc=window.event.srcElement;
	var ID=eSrc.id;
	var encmeth=GetValue("RefuseClass");
	cspRunServerMethod(encmeth,ID);
	window.location.reload();
}
function RefuseApp(ID)
{
	var encmeth=GetValue("RefuseClass");
	cspRunServerMethod(encmeth,ID);
}
document.body.onload = BodyIni;