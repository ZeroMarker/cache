document.body.onload = BodyLoadHandler;
var CurRegNo="";
var DoType="";
var PerRegNo="";
var vRoomInfo="";
function BodyLoadHandler()
{
	var obj;
	obj=GetObj("NoTSInfo");
	if (obj) obj.onchange=NoTSInfo_onclick;
	obj=GetObj("BFind");
	if (obj) obj.onclick=BFind_onclick;
	obj=GetObj("BSaveTel");
	if (obj) obj.onclick=BSaveTel_onclick;
	DoType=GetValue("Type");
	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;} 
	obj=document.getElementById("BWaitList");
	if (obj) {
		obj.onclick=BWaitList_Click;
		if (DoType!="") obj.style.display="none";
	}
	obj=document.getElementById("BComplete");
	if (obj) {
		obj.onclick=BComplete_Click;
		if (DoType!="")obj.style.display="none";
	}
	var PAADM=GetValue("PAADM");
	if (PAADM!=""){
		setTimeout("ShowOneInfo()",1000)
		
	}
	obj=GetObj("RegNo");
	if (obj){
		obj.onkeydown=RegNo_onkeydown;
		obj.onfocus=RegNo_onfocus;
		//obj.onchange=RegNo_onchange;
	}
	obj=GetObj("Name");
	if (obj) obj.onkeydown=Name_onkeydown;
	obj=GetObj("IDCard");
	if (obj) obj.onkeydown=IDCard_onkeydown;
	
	obj=document.getElementById("CardNo");
	if (obj) {obj.onchange=CardNo_Change;
	obj.onkeydown=CardNo_KeyDown;}
	
	var obj=GetObj("Record");
	if (obj){
		obj.multiple=false;   //多选属性
		//obj.size=1;  //多选属性为false时下拉列表框
		obj.ondblclick=ShowAllResult;
		obj.onchange=Record_onchange;
		websys_setfocus("RegNo");
	}
	var MainDoctor=GetValue("MainDoctor");
	parent.vMainDoctor=MainDoctor;
	SetRoomID();
	//initialReadCardButton();
}
function ShowAllResult()
{
	var obj=GetObj("Record");
	var PAADM=obj.options[obj.selectedIndex].value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewDiagnosis"
			+"&EpisodeID="+PAADM
			+"&ChartID="
			+"&OnlyRead=Y";
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes';
	window.open(lnk,"_blank",nwin)	

	return true;
}

function NoTSInfo_onclick()
{
	var TSInfo="0";
	var obj=GetObj("NoTSInfo");
	if (obj&&obj.checked) TSInfo="1";
	var encmeth=GetValue("TSInfoClass");
	var ret=cspRunServerMethod(encmeth,TSInfo);
}
function RegNo_onfocus()
{
	var obj=GetObj("RegNo");
	if (obj) obj.select();
   if(obj.style.imeMode ==  "disabled")
	{                       
	 }
	else
	{                      
		obj.style.imeMode   =   "disabled";    
	}      


	
}
function SetRoomID()
{
	var Info=GetComputeInfo("");  //计算机名称  DHCPECommon.js
	var encmeth=GetValue("GetRoomIDClass");
	var RoomID=cspRunServerMethod(encmeth,Info);
	SetValue("RoomID",RoomID);
	SetCheckInfo();
}
function SetCheckInfo()
{
	var RoomID=GetValue("RoomID");
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];
	var LocID=session['LOGON.CTLOCID'];
	if (RoomID==""){
		/**/
		var encmeth=GetValue("CheckNumInfo")
		var Info=cspRunServerMethod(encmeth);
		var obj=document.getElementById("cCheckNum");
		if (obj) obj.innerHTML=Info;
		
		var obj=GetObj("BWaitList");
		if (obj) obj.style.display='none';
		var obj=GetObj("BComplete");
		if (obj) obj.style.display='none';
		var TotalLnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail";
		var Info="<a href="+TotalLnk+" target='_blank' >检查信息</a>"
		
	}else{
		var encmeth=GetValue("GetCheckInfoClass");
		var CheckInfo=cspRunServerMethod(encmeth,RoomID,UserID);
		var Arr=CheckInfo.split("$");
		var NumInfo=Arr[0];
		var HadCheckStr=Arr[1];
		var NoCheckStr=Arr[2];
		var RefuseCheckStr=Arr[3];
		var NumArr=NumInfo.split("^");
		var TotalPerson=NumArr[0];
		var HadCheckNum=NumArr[1];
		var NoCheckNum=NumArr[2];
		var RefuseCheckNum=NumArr[3];
		var NoCheckLnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail&AdmStr="+RoomID+NoCheckStr;
		var HadCheckLnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail&AdmStr="+RoomID+HadCheckStr;
		var RefuseCheckLnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail&AdmStr="+RoomID+RefuseCheckStr;
		var TotalLnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail&StationID="+RoomID;
		//var Info="<a href="+TotalLnk+" target='_blank' >共<font color=red size=6>"+TotalPerson+"</font>人</a><br><a href="+HadCheckLnk+" target='_blank' >已检<font color=red size=6>"+HadCheckNum+"</font>人</a><br><a href="+NoCheckLnk+" target='_blank' >未检<font size=6>"+NoCheckNum+"</font>人</a>"
		var Info="<a href="+HadCheckLnk+" target='_blank' >已检<font color=red size=6>"+HadCheckNum+"</font>人</a>;<a href="+NoCheckLnk+" target='_blank' >未检<font size=6>"+NoCheckNum+"</font>人</a><br><a href="+RefuseCheckLnk+" target='_blank' >放弃<font size=6>"+RefuseCheckNum+"</font>人</a>"
	}
	var ResumeDefaultLnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEChartAssignDetail&UserID="+UserID+"&LocID="+LocID+"&GroupID="+GroupID+"&OpenType=Self"
	var Info=Info+";<a href="+ResumeDefaultLnk+" target='_blank' >默认科室</a>"
	var obj=document.getElementById("cCheckInfo");
	if (obj) obj.innerHTML=Info;
}
function CardNo_Change()
{
	CardNoChangeApp("RegNo","CardNo","BFind_onclick()","Clear_click()","0");
}
///读卡 add by rxb 20130121
function ReadCard_Click()
{
	ReadCardApp("RegNo","BFind_onclick()","CardNo");
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
	if (parent.vRoomRecordID!=""){
		if (!confirm("当前体检者,还没有完成,是否开始下一个?")){
			return false;
		}
		parent.vRoomRecordID="";
	}
	
	var RoomID=GetValue("RoomID");
	if (RoomID==""){
		alert("电脑没有设置对应的诊室");
		return false;
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPERoomRecordDetail&RoomID="+RoomID+"&WaitInfo="+vRoomInfo;
	var PWidth=window.screen.width
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,titlebar=yes,resizable=no,'
			+'height='+400+',width='+720+',left='+260+',top=0'
			;
	//var nwin="fullscreen=1"
	var ALertWin=window.open(lnk,"AlertWin",nwin);
	//ALertWin.resizeTo('701','305');
	return false;
}
//完成检查
function BComplete_Click()
{
	//SaveResult();
	BComplete();
	SetValue("RegNo","");
	return false;
}
function BComplete()
{
	SetCheckInfo();
	var RecordID=parent.vRoomRecordID;
	var PAADM=parent.vPAADM;
		
	
	var RoomID=GetValue("RoomID");
	if (RoomID=="") return false;
	var encmeth=GetValue("CompleteClass");
	if (PAADM==""){
		alert("没有就诊患者");
		return false;
	}
	var ret=cspRunServerMethod(encmeth,RecordID,PAADM,RoomID);
	var Arr=ret.split("^");
	parent.vRoomRecordID=""
	
	//if (Arr[0]!=""){
		//alert(Arr[1]);
		vRoomInfo=Arr[1];
	//}else{
		//需要诊室排队的都已经检查完成
	//}
	BWaitList_Click();
}
function RegNo_onkeydown(e)
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		BFind_onclick(e);
	}
}
function RegNo_onchange(e)
{
	BFind_onclick(e);
}
function Name_onkeydown(e)
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		var Name=GetValue("Name");
		if (Name=="") return false;
		var Info=tkMakeServerCall("web.DHCPE.DocPatientFind","GetPersonCountByName",Name);
		var InfoArr=Info.split("^");
		var Count=InfoArr[0];
		if (Count==0) return false;
		
		if (Count==1){
			SetValue("RegNo",InfoArr[1]);
			BFind_onclick();
			return false;
		}
		if (Count>1){
			var method="web.DHCPE.DocPatientFind:GetRegNoByName";
			var jsfunction="GetRegNoAfter"
			var url='websys.lookup.csp';
			url += "?ID=";
			url += "&CONTEXT=K"+method;
			url += "&TLUJSF="+jsfunction;	
			url += "&P1="+ websys_escape(Name);
			websys_lu(url,1,'');
			return websys_cancel();
		}
	}
}
function GetRegNoAfter(value)
{
	if (value=="") return false;
	var InfoArr=value.split("^");
	SetValue("RegNo",InfoArr[0]);
	BFind_onclick();
	return false;
}
function IDCard_onkeydown(e)
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		BFind_onclick(e);
	}
}
function BFind_onclick()
{
	//var eSrc=window.event.s rcElement;
	//parent.vRoomRecordID="";
	var RegNo="",Name="",IDCard="";
	//var CurID=eSrc.id
	RegNo=GetValue("RegNo");
	if (RegNo==""){
		alert("请输入登记号");
		return false;
	}
	if (PerRegNo==RegNo) return false;
	//SetCheckInfo();
	parent.vPAADM="";
	CurRegNo="";
	
	CurRegNo=RegNo;
	var StartDate=GetValue("StartDate");
	var EndDate=GetValue("EndDate");
	var obj=GetObj("HadCheck");
	var HadCheck=0;
	if (obj&&obj.checked) HadCheck=1;
	if (CurRegNo==""){
		alert("请选择人员");
		return false;
	}
	
	//var PatName=tkMakeServerCall("web.DHCPE.TempTools","GetPatNameByRegNo",CurRegNo); 
	//if (!(confirm("是否对"+PatName+"进行到达操作?"))) {  return false; }
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
	var encmeth=GetValue("GetInfo");
	var Info=cspRunServerMethod(encmeth,CurRegNo,StartDate,EndDate,HadCheck);
	if (Info.split("^")[0]=="-1")
	{
		alert(Info.split("^")[1]);
		return false;
	}
	var RecordInfo=Info.split(String.fromCharCode(1))[1];
	var BaseInfo=Info.split(String.fromCharCode(1))[0];
	var BaseArr=BaseInfo.split("^");
	SetValue("RegNo",BaseArr[0]);
	SetValue("Name",BaseArr[1]);
	SetValue("IDCard",BaseArr[2]);
	SetValue("Dob",BaseArr[3]);
	SetValue("Tel",BaseArr[4]);
	SetValue("Age",BaseArr[5]);
	SetValue("Sex",BaseArr[7]);
	SetValue("position",BaseArr[6]); //add by lxl 20121123
	var RecordArr=RecordInfo.split(String.fromCharCode(2));
	var obj=GetObj("Record");
	RemoveList(obj);
	var length=RecordArr.length;
	for (var j=0; j<length; j++)
	{
		AddListItem(obj,RecordArr[j].split("^")[0],RecordArr[j].split("^")[1]);
	}
	obj.options[0].selected=true;
	//取当前PAADM的排队记录，以及队列状态
	var encmeth=GetValue("ArriveByPAADMCls");
	if (encmeth!=""){
		var PAADM=obj.options[obj.selectedIndex].value;
		var RoomID=GetValue("RoomID");
		//alert("RoomID"+RoomID)
		var objct
		objct=tkMakeServerCall("web.DHCPE.RoomManager","IsHadCT",RoomID,PAADM);
		if (objct=="1") {alert("该人有CT")}
		if (DoType!="RecordDetail"){
			if (RoomID!=""){
				var ret=tkMakeServerCall("web.DHCPE.RoomManager","CanCheck",RoomID,PAADM);
				if (ret=="1"){
					alert("存在必须先检查的项目,请先去做相关检查")
					return false;
				}
				if (ret=="-1"){
					alert("该诊室已经放弃,不允许操作")
					return false;
				}
				var ret=cspRunServerMethod(encmeth,RoomID,PAADM);
				var Arr=ret.split("^");
				var ret=Arr[0];
				if (ret==""){  //不在当前诊室
					var TypeFlag=Arr[1];
					if  (TypeFlag=="2"){
						if (!confirm("体检者未排队到本诊室,是否查体?")) return false;
					}else if (TypeFlag=="1"){
						if (!confirm("已完成本科室检查,是否需要修改?")) return false;
					}
					parent.vRoomRecordID="";
					parent.frames["result"].vRoomRecordID="";
				}else{ //在当前诊室
					var Record=Arr[0];
					var Status=Arr[1];
					var DetailStatus=Arr[2];
					if (Status=="N"){  //判断是不是同一个人
						if (DetailStatus==""){ //还没有叫号
							if (!confirm("到达者和叫号者不是同一个人,是否继续?")) return false;
						}
						if (DetailStatus!="E"){  //不是正检状态的，设置正检，下屏
							var encmeth=GetValue("ArriveCurRoomClass");
							var UserID=session['LOGON.USERID'];
							var ret=cspRunServerMethod(encmeth,Record,UserID,RoomID);
						}
					}
					parent.vRoomRecordID=Record;
					parent.frames["result"].vRoomRecordID=Record;
				}
				/*
				if ((ret!=parent.vRoomRecordID)) //&&(parent.vRoomRecordID!="")
				{
					if (!confirm("到达者和叫号者不是同一个人,是否继续?")) return false;
					parent.vRoomRecordID="";
					parent.frames("result").vRoomRecordID="";	
				}else if (ret=="")
				{
					if (!confirm("没有叫号,是否继续?")) return false;
				}
				if (ret!=""){
					parent.vRoomRecordID=ret;
					parent.frames("result").vRoomRecordID=ret;
				}
				*/
			}
		}
	}
	PerRegNo=RegNo;
	
	Record_onchange();
	
	
}
function RemoveList(obj)
{
	for (var i=(obj.length-1); i>=0; i--) {
			obj.options[i]=null;
	}
}
function AddListItem(obj,value,display)
{
	obj.options[obj.options.length] = new Option(display,value);
}
function Record_onchange()
{
	var obj=GetObj("Record");
	ShowOneInfoApp(obj.options[obj.selectedIndex].value);
}
function ShowOneInfo()
{
	var PAADM=GetValue("PAADM");
	ShowOneInfoApp(PAADM);
	var RecordInfo=GetValue("RecordInfo")
	var RecordArr=RecordInfo.split(String.fromCharCode(2));
	var obj=GetObj("Record");
	//RemoveList(obj);
	var length=RecordArr.length;
	for (var j=0; j<length; j++)
	{
		AddListItem(obj,RecordArr[j].split("^")[0],RecordArr[j].split("^")[1]);
		if (RecordArr[j].split("^")[0]==PAADM) obj.options[j].selected=true;
	}
	
}
function ShowOneInfoApp(PAADM)
{
	
	if (DoType=="RecordDetail"){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEAdmRecordList&AdmId=" +PAADM;
    	//parent.frames("result").location.href=lnk;
    	parent.frames["result"].location.href=lnk;
		return false;
	}
	
	parent.vPAADM=PAADM;
	var encmeth=GetValue("GetOrdInfo");
	var MainDoctor=GetValue("MainDoctor");
	var OrderInfo=cspRunServerMethod(encmeth,PAADM,MainDoctor);
	var Position=OrderInfo.split(String.fromCharCode(2))[1];
	SetValue("position",Position);
	var OrderInfo=OrderInfo.split(String.fromCharCode(2))[0];
	parent.vOrdInfo=OrderInfo.split(String.fromCharCode(1));
	var obj=parent.Ext.getCmp('Tree');
	obj.root.reload();
	obj.expandAll();
	var ID=parent.vOrdInfo[0];
	parent.ShowPage(ID)
	
}
function BSaveTel_onclick()
{
	var obj,Tel="",encmeth="",RegNo="";
	obj=document.getElementById("RegNo");
	if (obj) RegNo=obj.value;
	obj=document.getElementById("Tel");
	if (obj) Tel=obj.value;
	if (Tel==""){
		alert(t["NoTel"]);
		return false;
	}
	obj=document.getElementById("SaveTelClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,RegNo,Tel);
	alert(ret)
}
function SaveResult()
{
	if (parent.frames("result")){
		var UObj=parent.frames("result").document.getElementsByTagName('button');
		var ButtonLength=UObj.length;
		for (var i=0;i<ButtonLength;i++)
		{
			var ButtonID=UObj[i].name;
			
			if (ButtonID.split("Update").length>1) UObj[i].click();
			if (ButtonID=="BSave") UObj[i].click();
		}
		var UObj=parent.frames("result").document.getElementsByTagName('A');
		var ButtonLength=UObj.length;
		for (var i=0;i<ButtonLength;i++)
		{
			var ButtonID=UObj[i].id;
			
			if (ButtonID.split("Update").length>1) UObj[i].click();
			if (ButtonID=="BSave") UObj[i].click();
		}
	}
}
function ShowHadCheck(e){
	var ArcimID=e.id;
	var Type="HadCheck"
	ShowCheckInfo(ArcimID,Type);
}
function ShowNoCheck(e){
	var ArcimID=e.id;
	var Type="NoCheck"
	ShowCheckInfo(ArcimID,Type);
}
function ShowRefuseCheck(e){
	var ArcimID=e.id;
	var Type="RefuseCheck"
	ShowCheckInfo(ArcimID,Type);
}
function ShowCheckInfo(ArcimID,Type){
	var wwidth=600;
	var wheight=450;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var url="dhcpeshowcheckinfo.csp?Type="+Type+"&ArcimID="+ArcimID;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(url,"ShowCheckInfo",nwin)	
}