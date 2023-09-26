/// DHCPEPreIADM.Find.js
var myItemNameAry=new Array();
var myCombAry=new Array();
document.write("<object ID='ClsIDCode' WIDTH=0 HEIGHT=0 CLASSID='CLSID:299F3F4E-EEAA-4E8C-937A-C709111AECDC' CODEBASE='../addins/client/ReadPersonInfo.CAB#version=1,0,0,8' VIEWASTEXT>");
document.write("</object>");


var TFORM="tDHCPEPreIADM_Find";
var CurrentSel=0;
var ReportWin;
function BodyLoadHandler() {
 	//alert('s')
	var obj;
	obj=document.getElementById(TFORM);
	if (obj) { obj.ondblclick=PreIADM_click; }

	obj=document.getElementById("BFind");
	if (obj){ obj.onclick=BFind_click; }
	
    obj=document.getElementById("BUpdateDepart");
	if (obj){ obj.onclick=BUpdateDepart_click; }
	
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
	
	obj=document.getElementById("RegNo");
	if (obj){ obj.onkeydown=RegNo_KeyDown;
		obj.onblur=RegNo_onblur;
	}
	
	obj=document.getElementById("Name");
	if (obj){ obj.onkeydown=RegNo_KeyDown;}
	
	// 预约
	obj=document.getElementById("Status_PREREG");
	if (obj){ obj.onclick=Status_PREREG_click; }
	
	
	// 不需审核
	obj=document.getElementById("Status_NOCHECKED");
	if (obj){ obj.onclick=Status_PREREG_NoALL; }
	
	// 需审核
	obj=document.getElementById("Status_UNCHECKED");
	if (obj){ obj.onclick=Status_PREREG_NoALL; }
	
	// 已审核
	obj=document.getElementById("Status_CHECKED");
	if (obj){ obj.onclick=Status_PREREG_NoALL; }
	
	// 修改预约信息
	obj=document.getElementById("Update");
	if (obj){
		obj.onclick=Update_click;
		obj.disabled=true;
		obj.style.color = "gray";
	}
	obj=document.getElementById("BAudit");
	if (obj){
		obj.onclick=BAudit_click;
	
	}
	// 放弃预约
	obj=document.getElementById("CancelADM");
	if (obj){
		obj.onclick=CancelADM_click;
		obj.disabled=true;
		obj.style.color = "gray";
	}

	// 放弃预约
	obj=document.getElementById("BPreOver");
	if (obj){
		obj.onclick=CancelADM_click;
		obj.disabled=true;
		obj.style.color = "gray";
	}
	//修改项目
	//BModifyTest
	obj=document.getElementById("BModifyTest");
	if (obj){ 
	     //BModifyTest_click
		//BModifyTest_click
		obj.onclick=BModifyTest_click
		obj.disabled=true;
		obj.style.color = "gray";
	}
	
	obj=document.getElementById("CardNo");
	if (obj) {
		obj.onchange=CardNo_Change;
		obj.onkeydown=CardNo_keydown;
	}


	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}

	
	obj=document.getElementById("GroupDesc")
	if (obj) { obj.onchange=GroupDesc_Change; }
	
	obj=document.getElementById("TeamDesc");
	if (obj) { obj.onchange=TeamDesc_Change; }

    ///addStrat20131015 打印
    obj=document.getElementById("BPrint")
    if (obj) {
           obj.onclick=BPrint_click;  
     }
    ///指引单打印预览
    obj=document.getElementById("BPrintView")
    if (obj) {
	       obj.onclick=PatItemPrintXH;  
	 }
	///补打收费条码
	obj=document.getElementById("PrintPayAagin")
	if (obj) {
		   obj.onclick=PrintPayAagin_Click;
	}
	///发送申请单
	obj=document.getElementById("BSendRequest")
	if (obj) obj.onclick=SendRequest_click;
    ///addEnd20131015 打印
    ///全选
	obj=document.getElementById("BSelect")
	if (obj) obj.onclick=BSelect_change;
    ///报告预览
	obj=document.getElementById("BPreviewReport")
	if (obj) obj.onclick=PreviewAllReport;
	
	///addEnd20131015 打印
    
	// 打印 打印单
	//DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrint");
	iniForm();
	
	//var obj=document.getElementById("TSeclectz1");
	//if (obj) obj.click();
	
	//卡类型初始化
	initialReadCardButton()
	
   	Muilt_LookUp('GroupDesc'+'^'+'TeamDesc');
   	websys_setfocus("RegNo");
	
   	//读身份证
   	var myobj=document.getElementById("ReadRegInfo");
    if (myobj)
	{
		myobj.onclick=ReadRegInfo_OnClick;
		myobj.onkeydown=Doc_OnKeyDown;
	}
	var obj=document.getElementById("HpNo");
	if (obj){ obj.onkeydown=HpNo_KeyDown;
		obj.onblur=HpNo_onblur;
	}
	
	var obj=document.getElementById("BUpdateVIPLevel");
	if (obj){ obj.onclick=BUpdateVIPLevel_click; } 
	
	InitRowObj();
	
   //document.getElementById("Status_PREREG").checked=true;
   //document.getElementById("Status_REGISTERED").checked=true;  //add
   //document.getElementById("Status_ARRIVED").checked=true;
}

function InitRowObj(){
	
	var objtbl=document.getElementById('tDHCPEPreIADM_Find');
	if(objtbl){
		
		var rows=objtbl.rows.length;
		var lastrowindex=rows - 1;
		for (var i=1;i<=lastrowindex;i++){
			
			var Obj=document.getElementById("TMarkz"+i);
			if (Obj){
			      Obj.onblur=MarkBlurHandler; //事件在用户离开输入框时执行
			}

		}
   }
}

function MarkBlurHandler(e){
	
	var obj=websys_getSrcElement(e);
	var Row=GetEventRow(e);
	var Mark=obj.value;
	var Obj=document.getElementById("PIADM_RowIdz"+Row);
	if(Obj){var PIADM=Obj.value;}
	var rtn=tkMakeServerCall("web.DHCPE.PreIADM","UpDateMark",PIADM,Mark)
	
}


function GetEventRow(e)
{
	var obj=websys_getSrcElement(e);
	var Id=obj.id;
	var arrId=Id.split("z");
	var Row=arrId[arrId.length-1];
	return Row;
}


function BUpdateVIPLevel_click()
{
	
	var iTAdmId="",iVIP="";
	var TAdmIdStr=GetSelectId() ;
	var TAdmIds=TAdmIdStr.split(";")
	var obj=document.getElementById("VIPLevel");
    if (obj){ iVIP=obj.value; }
    if(iVIP==""){alert("请选择VIP等级后再更新");return false;}
	for(var PSort=0;PSort<TAdmIds.length;PSort++)
	{
		var iTAdmId=TAdmIds[PSort]; //paadm
		if (iTAdmId=="") { 
	    	alert("您没有选择客户,或者没有登记");
			websys_setfocus("RegNo");
	   		return false;    
		}
	   if(iTAdmId!=""){
         var flag=tkMakeServerCall("web.DHCPE.PreItemListEx","ChangeVipLevel",iTAdmId,iVIP);
        //if(flag==0){location.reload();}
     }
	
	}
	location.reload();
	
}
function Doc_OnKeyDown()
   { 
	  
	   if (event.keyCode==115)
       {
		ReadRegInfo_OnClick();
       }
   }
function ReadRegInfo_OnClick()
  {
	 
	//var myInfo=ClsIDCode.ReadPersonInfo();
   	
	var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
	var rtn=tkMakeServerCall("DHCDoc.Interface.Inside.Service","GetIECreat")
	var myHCTypeDR=rtn.split("^")[0];
	var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);
    var myary=myInfo.split("^");

     if (myary[0]=="0")
     { 
     
      SetPatInfoByXML(myary[1]); 
      var mySexobj=document.getElementById("Sex");
	  var myBirobj=document.getElementById("Birth");
	  var mycredobj=document.getElementById("CredNo");
	  var myidobj=document.getElementById('IDCard');
		if ((mycredobj)&&(myidobj)){
			myidobj.value=mycredobj.value;
		} 
     }
   
     
	 var RegNo=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetRegNoByIDCard",mycredobj.value);
	 if (RegNo==""){
		return false;
	}
	var obj=document.getElementById("RegNo");
	if (obj){
		obj.value=RegNo;
		BFind_click();
	}
     
   }

function SetPatInfoByXML(XMLStr)
{
	
	XMLStr ="<?xml version='1.0' encoding='gb2312'?>"+XMLStr
	
	var xmlDoc=DHCDOM_CreateXMLDOM();
	xmlDoc.async = false;
	xmlDoc.loadXML(XMLStr);
	if(xmlDoc.parseError.errorCode != 0) 
	{ 
		alert(xmlDoc.parseError.reason); 
		return; 
	}

	var nodes = xmlDoc.documentElement.childNodes;
	
	for(var i=0; i<nodes.length; i++) 
	{
		
		var myItemName=nodes(i).nodeName;
		
		var myItemValue= nodes(i).text;
		if (myCombAry[myItemName]){
			myCombAry[myItemName].setComboValue(myItemValue);

		}else{
			DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
		}
	}
	delete(xmlDoc);
}

function HpNo_KeyDown(e){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		obj=document.getElementById("HpNo");
		if(obj) var HpNo=obj.value
		var RegNo=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetRegNoByHpNo",HpNo);
	 	if (RegNo==""){
		return false;
		}
		var obj=document.getElementById("RegNo");
		if (obj){
		obj.value=RegNo;
		}
		BFind_click();
	}
}
function HpNo_onblur()
{
	var Src=window.event.srcElement;
	Src.value=Src.value;
	//Src.selection.empty();
}

function BUpdateDepart_click()
{
	var iRowId=""
	//alert(CurrentSel)
	if (CurrentSel==0) return;
	obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }
	if (iRowId=="") return;
	var obj,encmeth="",DepartName="";
	obj=document.getElementById("DepartClass");
	if (obj) encmeth=obj.value;
	obj=document.getElementById("DepartName");
	if (obj) DepartName=obj.value;
	var Info=cspRunServerMethod(encmeth,iRowId,DepartName);
	alert("设置完成");
}
function BSelect_change()
{
	var Src=window.event.srcElement;
	var objtbl=document.getElementById("tDHCPEPreIADM_Find");	
	if (objtbl) { var rows=objtbl.rows.length; }
	for (var i=1;i<rows;i++)
	{
		var obj=document.getElementById("TSeclectz"+i);
		if (obj) obj.checked=Src.checked;
		obj=document.getElementById("BModifyTest");
		if (obj){ 
	    	obj.disabled=!Src.checked;
		}
	}
}

function PreviewAllReport()
{
	var iReportName="",iEpisodeID="";
	obj=document.getElementById("ReportNameBox");
	if (obj) { iReportName=obj.value; }
	var TAdmIdStr=GetSelectId() ;
	var TAdmIds=TAdmIdStr.split(";")
	for(var PSort=0;PSort<TAdmIds.length;PSort++)
	{
		var iTAdmId=TAdmIds[PSort];
		//alert(iTAdmId) paadm
		if (iTAdmId=="") { 
	    	alert("您没有选择客户,或者没有登记");
			websys_setfocus("RegNo");
	   		return false;    
		}
	
		var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no'
			+',left=0'
			+',top=0'
			+',width='+window.screen.availWidth
			+',height='+(window.screen.availHeight-40)
			;
		var lnk=iReportName+"?PatientID="+iTAdmId;
		if (ReportWin) ReportWin.close();
		ReportWin=window.open(lnk,"ReportWin",nwin)
	}
}
function RegNo_onblur()
{
	var Src=window.event.srcElement;
	Src.value=Src.value;
	//Src.selection.empty();
}
function SendRequest_click()
{
	var iRowId=""
	//alert(CurrentSel)
	if (CurrentSel==0) return;
	
	obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }
	//alert(iRowId)
	if (iRowId=="") return;
	var obj,encmeth="";
	obj=document.getElementById("GetPAADMID");
	if (obj) encmeth=obj.value;
	var Info=cspRunServerMethod(encmeth,iRowId);
	//alert(Info)
	if (Info=="") return false;
	var Arr=Info.split("^");
	var PAADM=Arr[0];
	var PatID=Arr[1];
	var MRAdm=Arr[2];
	var url="diagnosentry.csp?EpisodeID="+PAADM+"&PatientID="+PatID+"&mradm="+MRAdm;
  	var ret=window.showModalDialog(url, "", "dialogwidth:1000px;dialogheight:600px;center:1"); 
	var url="dhcrisappbill.csp?EpisodeID="+PAADM+"&PatientID="+PatID;
	var wwidth=1250;
	var wheight=650;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(url,"_blank",nwin)
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
	
	 var obj=document.getElementById("CardNo"); 
	if (obj){ var myCardNo=obj.value;}
	DHCACC_DisabledCardType("CardTypeDefine",myCardNo);
	combo_CardTypeKeydownHandler(); 
	CardNoChangeApp("RegNo","CardNo","BFind_click()","Clear_click()","0");
	var obj=document.getElementById("CardNo"); 
	if (obj){ obj.value=myCardNo;}

}


function ReadCard_Click()
{
	ReadCardApp("RegNo","BFind_click()","CardNo");
	
}

function BAudit_click()
{
	var iRowId=""
	if (CurrentSel==0) return;
	obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }
	if (iRowId=="") return;
	var Ins=document.getElementById('AuditClass');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,iRowId)
	if (flag==0)
	{
		alert("更新成功")
	}
}
function iniForm(){
	var obj;
	obj=document.getElementById("Status");
	if (obj) { SetStatus(obj.value); }
	var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisFBWay");
	if(flag!="B"){
		obj=document.getElementById("PrintPisRequest");
		if(obj){ obj.style.display="none";}
		obj=document.getElementById("cPrintPisRequest");
		if(obj){ obj.style.display="none";}
		}

	ShowCurRecord(0);
	document.onkeydown=Doc_keyDown;
}
function Doc_keyDown()
{
	var Key=websys_getKey(e);
	if ((117==Key)){
		BPrint_click();
	}
}
function RegNo_KeyDown(e){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		BFind_click();
	}
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}
function   getURL(url)
{
	var   xmlhttp   =   new   ActiveXObject("Microsoft.XMLHTTP");
	xmlhttp.open("GET",url,false);
	xmlhttp.send();
	if   (xmlhttp.readyState==4)
	{
		if(xmlhttp.Status!=200){
			alert("不存在");
			return true;
		}
	}
	alert("存在")
	return   false;
} 
function BFind_click() {
	
	var obj;
	var iRegNo="";
	var iName="";
	var iPEDate="";
	var iPETime="";
	var iStatus="";
	var iPEEndDate=""
	var iGroupID=""
	var iTeamID=""
	var iDepartName=""
	var iVIP="";
	var iSex="";
	var iCardNo="";
	var iRoomPlace="";
	/*obj=document.getElementById("TFORM");
	if (obj){ var tForm=obj.value; }
	else { return false; }*/
	obj=document.getElementById("CardNo");
	if (obj) iCardNo=obj.value;

	obj=document.getElementById("RegNo");
	if (obj){ 
		iRegNo=obj.value;
		if (iRegNo.length<8 && iRegNo.length>0) { iRegNo=RegNoMask(iRegNo); }
	}

	obj=document.getElementById("Name");
	if (obj){ 
		iName=obj.value; 
		iName=trim(iName);
	}

	obj=document.getElementById("PEStDate");
	if (obj){ iPEDate=obj.value; }

	obj=document.getElementById("PETime");
	if (obj){ iPETime=obj.value; }	
	
	obj=document.getElementById("VIPLevel");
	if (obj){ iVIP=obj.value; }
	
	

	iStatus=GetStatus();
	iChargedStatus=GetChargedStatus();
	iCheckedStatus=GetCheckedStatus();
	if (""!=iCheckedStatus) { iStatus=iStatus+"^PREREG"; }
	
	obj=document.getElementById("EndDate");
	if (obj) iPEEndDate=obj.value;
	obj=document.getElementById("GroupID");
	if (obj) iGroupID=obj.value;
	obj=document.getElementById("TeamID");
	if (obj) iTeamID=obj.value;
	obj=document.getElementById("DepartName");
	if (obj){ iDepartName=obj.value; }
	
	obj=document.getElementById("ReCheck");
	if (obj){var ReCheck=obj.value; }
	
	obj=document.getElementById("Sex");
	if (obj){ iSex=obj.value; }
	
	obj=document.getElementById("RoomPlace");
	if (obj){ iRoomPlace=obj.value; }
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+tForm
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreIADM.Find"
			+"&RegNo="+iRegNo
			+"&Name="+iName
			+"&PEStDate="+iPEDate
			+"&PETime="+iPETime
			+"&Status="+iStatus
			+"&ChargedStatus="+iChargedStatus
			+"&CheckedStatus="+iCheckedStatus
			+"&EndDate="+iPEEndDate
			+"&GroupID="+iGroupID
			+"&TeamID="+iTeamID
			+"&DepartName="+iDepartName
			+"&VIPLevel="+iVIP+"^"+iRoomPlace
			+"&ReCheck="+ReCheck
			+"&RFind=1"
			+"&SexDR="+iSex
			+"&CardNo="+iCardNo
	;
	location.href=lnk;
}
function SelectGruop(value)
{
	if (value=="") return;
	var ValueArr=value.split("^");
	var obj=document.getElementById("GroupDesc");
	if (obj) obj.value=ValueArr[0];
	var obj=document.getElementById("GroupID");
	if (obj) obj.value=ValueArr[1];
}
function SelectTeam(value)
{
	if (value=="") return;
	var ValueArr=value.split("^");
	var obj=document.getElementById("TeamDesc");
	if (obj) obj.value=ValueArr[0];
	var obj=document.getElementById("TeamID");
	if (obj) obj.value=ValueArr[1];
}
function GroupDesc_Change()
{
	var obj=document.getElementById("GroupID");
	if (obj) obj.value="";
	var obj=document.getElementById("TeamID");
	if (obj) obj.value="";
	var obj=document.getElementById("TeamDesc");
	if (obj) obj.value="";
}
function TeamDesc_Change()
{
	var obj=document.getElementById("TeamID");
	if (obj) obj.value="";
}


function Update_click() {

	var obj;
	
	obj=document.getElementById("Update");
	if (obj && obj.disabled){ return false; }
	
	var iRowId="";
	
	obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }
		
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreIADM.Edit"
			+"&ID="+iRowId
	var lnk="dhcpepreiadm.main.csp?ID="+iRowId		
			
	//var PreOrAdd="PRE"
	//var lnk="dhcpepreitemlist.main.csp"+"?AdmType=PERSON"
	//		+"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd
	//;
	var wwidth=1250;
	var wheight=650;
	
	
	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;

}

function CancelADM_click() {
	var Src=window.event.srcElement;
	//var Src=document.getElementById("CancelADM");
	if (Src.disabled) { return false; }
	Src.disabled=true;
	var obj;
	var iRowId="",iStatus="PREREG",iUpdateUserDR="";
	var Instring="";
	var Type=Src.innerHTML.substr(Src.innerHTML.length-4,4)
	if (Type=="预约完成") iStatus="PREREGED"
	if (Type=="放弃预约") iStatus="CANCELPREREG"
	obj=document.getElementById("RowId");
	if (obj && ""!=obj.value) { iRowId=obj.value; }
	
	iUpdateUserDR==session['LOGON.USERID'];
	
	Instring=iRowId+"^"+iStatus+"^"+iUpdateUserDR;
	
	var Ins=document.getElementById('CancelADMBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	if ("NoItem"==flag)
	{
		alert(t[flag]);
		return;
	}else if (('Err 01'==flag)||('100'==flag)) {
		alert(t['Err 01']);
		return;
	}else if ('Err 02'==flag) {
		alert(t['Err 02']);
		return;
	}else if ('Err 03'==flag) {
		alert(t['Err 03']);
		return;
	}else if ('Err 04'==flag) {
		alert(t['Err 04']);
		return;
	}	
	else if ('0'==flag) {
		//alert("Update Success!");
		location.reload();
	}
	
	Src.disabled=false;
	
}
function GetAddItemPerson()
{
	var objtbl=document.getElementById("tDHCPEPreIADM_Find");	
	if (objtbl) { var rows=objtbl.rows.length; }
	var GFlag=0,IFlag=0,IDs="",OneID="",obj,VIPLevel="",LevelNum=1;
	var Total=0
	for (var i=1;i<rows;i++)
	{
		obj=document.getElementById("TSeclectz"+i);
		if (obj&&obj.checked){
			Total=Total+1;
			if (Total>10) break
			obj=document.getElementById("PIADM_RowIdz"+i);
			if (obj) OneID=obj.value;
			if (IDs==""){
				IDs=OneID;
			}else{
				IDs=IDs+"^"+OneID;
			}
			/*
			obj=document.getElementById("TGNamez"+i);
			if (obj){
				if ((obj.innerText!="")&&(obj.innerText!=" ")){
					GFlag=1;
				}else{
					IFlag=1;
				}
			}
			*/
			obj=document.getElementById("PIADM_PGADM_DRz"+i);

			if (obj){
				if (obj.value!=""){
					GFlag=1;
				}else{
					IFlag=1;
				}
			}

			
			obj=document.getElementById("TVIPLevelz"+i);
			if (obj){
				var CurVIPLevel=obj.innerText;
				if (VIPLevel==""){
					VIPLevel=CurVIPLevel;
				}else{
					if (VIPLevel!=CurVIPLevel) LevelNum=LevelNum+1;
				}
			}
		}
	}
	if (LevelNum>1){
		alert("选择人员不能包含不同的VIP等级");
		return "$";
	}
	if ((IFlag+GFlag)==2){
		alert("选择人员不能同时包含团体和个人");
		return "$";
	}
	return IDs+"$"+GFlag+"$"+CurVIPLevel;
}
/// 调用项目预约页面
//function ModifyTest_click() {
 function BModifyTest_click() {
	
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) { return false;}
	var IDsInfo=GetAddItemPerson();
	var Arr=IDsInfo.split("$");
	
	var iRowId=Arr[0];
	if(iRowId.split("^").length>1){
		alert("修改预约项目,只能选中一人");
		return false;
	}

	var GFlag=Arr[1];
	var VIPLevel=Arr[2];
	
	if (VIPLevel=="职业病"){
		var VipFlag="dhcpeoccupationaldiseaseinfo.csp"
	}else {
		var VipFlag=""
	}
	
	if (iRowId=="") return false;
	var PreOrAdd="PRE";
	if (GFlag=="1"){
		var obj=document.getElementById("AddType");
		if (obj&&obj.checked)
		{
			PreOrAdd="PRE";
		}else{
			PreOrAdd="ADD";
		}
		var AddType="自费";
		if (PreOrAdd=="PRE") AddType="公费"
		if (!confirm("确实要给选中的人员"+AddType+"加项吗")) return false;
	}
	/*	
	var obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; }
	if (""==iRowId) { return false;}
	
	var PreOrAdd="PRE"
	///如果是团体中的个人当作额外加项
	var obj=document.getElementById("TGNamez"+CurrentSel);
	if (obj)
	{
		if ((obj.innerText!="")&&(obj.innerText!=" ")) PreOrAdd="ADD"
	}
	*/
	var lnk="dhcpepreitemlist.main.csp"+"?AdmType=PERSON"
			+"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd+"&VipFlag="+VipFlag
			;
	
	//alert("   600")	
	//var wwidth=1000;
	//var wheight=600;
	
	
	var wwidth=1250;
	var wheight=650;
	
	
	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}
function SetStatus(Status) {
	var obj;
	var values=Status.split(":");
	var value=values[0];
	// REGISTERED 到达
	obj=document.getElementById("Status_ARRIVED");
	if (obj) {
		if (value.indexOf("^ARRIVED^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
	// REGISTERED 登记
	obj=document.getElementById("Status_REGISTERED");
	if (obj) {
		if (value.indexOf("^REGISTERED^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}

	// CANCELPREREG 取消预约
	obj=document.getElementById("Status_CANCELPREREG");
	if (obj) {
		if (value.indexOf("^CANCELPREREG^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
	// CANCELArrive 取消到达
	obj=document.getElementById("Status_CANCELArrive");
	if (obj) {
		if (value.indexOf("CANCELARRIVED^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
	//CANCELPE  取消体检
	obj=document.getElementById("Status_CANCELPE");
	if (obj) {
		if (value.indexOf("CANCELPE^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
	// PREREG 预约
	obj=document.getElementById("Status_PREREG");
	if (obj && ""==values[2]) {
		if (value.indexOf("^PREREG^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
	// PREREGED 完成预约
	obj=document.getElementById("Status_PREREGED");
	if (obj && ""==values[2]) {
		if (value.indexOf("^PREREGED^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	var value=values[2];
	if (""==value) { return ;}
	// UNCHECKED 未审核
	obj=document.getElementById("Status_UNCHECKED");
	if (obj) {
		if (value.indexOf("^UNCHECKED^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
		
	// CHECKED 已审核
	obj=document.getElementById("Status_CHECKED");
	if (obj) {
		if (value.indexOf("^CHECKED^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
	// NOCHECKED 不需审核
	obj=document.getElementById("Status_NOCHECKED");
	if (obj) {
		if (value.indexOf("^NOCHECKED^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
		
}

function GetChargedStatus()
{
	var iStatus="";
	return iStatus;
}
// 获取 审核状态
function GetCheckedStatus()
{
	var obj;
	var iStatus="";
	obj=document.getElementById("Status_PREREG");
	if (obj && obj.checked){ return ""; }
		
	// UNCHECKED 未审核
	obj=document.getElementById("Status_UNCHECKED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"UNCHECKED"; }
		
	// CHECKED 已审核
	obj=document.getElementById("Status_CHECKED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"CHECKED"; }
	
	// NOCHECKED 不需审核
	obj=document.getElementById("Status_NOCHECKED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"NOCHECKED"; }
	
	return iStatus;
}

function GetStatus() {
	var obj;
	var iStatus="";

	// PREREG 预约
	obj=document.getElementById("Status_PREREG");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"PREREG"; }
	// PREREGED 完成预约
	obj=document.getElementById("Status_PREREGED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"PREREGED"; }
	// REGISTERED 登记
	obj=document.getElementById("Status_REGISTERED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"REGISTERED"; }
	
	// REGISTERED 到达
	obj=document.getElementById("Status_ARRIVED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"ARRIVED"; }

	// CANCELPREREG 取消预约
	obj=document.getElementById("Status_CANCELPREREG");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"CANCELPREREG"; }
	
	// CANCELArrive 取消到达
	obj=document.getElementById("Status_CANCELArrive");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"CANCELARRIVED"; }
	//CANCELPE  取消体检
	obj=document.getElementById("Status_CANCELPE");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"CANCELPE"; }
	iStatus=iStatus+"^"
	return iStatus;
}

function Status_PREREG_click() {
	obj=document.getElementById("Status_PREREG");
	if (obj && obj.checked){
		// UNCHECKED 未审核
		obj=document.getElementById("Status_UNCHECKED");
		if (obj){  obj.checked=false; }
		
		// CHECKED 已审核
		obj=document.getElementById("Status_CHECKED");
		if (obj){  obj.checked=false; }
		
		// NOCHECKED 不需审核
		obj=document.getElementById("Status_NOCHECKED");
		if (obj){  obj.checked=false; }
	}
}
	
function Status_PREREG_NoALL() {
	var src=window.event.srcElement;
	if (src && src.checked){
		obj=document.getElementById("Status_PREREG");
		if (obj){  obj.checked=false; }
	}
}

function Clear_click() {


}

		
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	if (eSrc.id.split("PIADM_ChargedStatus_Desc").length>1) return false;
	if (eSrc.id.split("PrintBarCode").length>1) return false;
	if (eSrc.id.split("PEDateBegin").length>1) return false;
	if (eSrc.parentElement.id.split("PIADM_ItemList").length>1) return false;
	//alert(eSrc.childNodes[0].type)
	var tForm="";
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	var objtbl=document.getElementById("tDHCPEPreIADM_Find");	
	if (objtbl) { var rows=objtbl.rows.length; }
	/*
	for (var i=1;i<rows;i++)
	{
		var obj=document.getElementById("TSeclectz"+i);
		if (obj) obj.checked=false;
	}
	*/
	if(-1==eSrc.id.indexOf("TSeclect"))
	{ //如果单击一行?改变前面的选择框?方法在DHCPE.Toolets.Common.JS
		ChangeCheckStatus("TSeclect");
	}

	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	/*
	if (selectrow==CurrentSel)
	{	    
	
	    Clear_click();
	    CurrentSel=0;
	    return;
	}
	*/
	if (CurrentSel==selectrow)
	{
		CurrentSel=0;
	}
	else
	{
		CurrentSel=selectrow;
	}

	ShowCurRecord(CurrentSel);

}

function PreIADM_click() {
	var eSrc=window.event.srcElement;
	
	var obj=document.getElementById(TFORM);
	if (obj){ var tForm=obj.value; }
	
	var objtbl=document.getElementById(tForm);	
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	/*
	if (selectrow==CurrentSel)
	{
	    CurrentSel=0;
	    return;
	}
	*/
	CurrentSel=selectrow;
 	ShowCurRecord(CurrentSel);
}

function ShowCurRecord(CurrentSel) {

	//站点编码 显示	    
	var SelRowObj;
	var obj;
	var iRowId="";
	var iTAdmId=""
	if (CurrentSel==0)
	{
		obj=document.getElementById("RowId");
		if (obj) obj.value=iRowId
		obj=document.getElementById("Update");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("CancelADM");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("BModifyTest");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("TAdmId");
		if (obj) obj.value=iTAdmId;
		return false;
	}
	SelRowObj=document.getElementById('PIADM_RowId'+'z'+CurrentSel);
	obj=document.getElementById("RowId");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	//addstart20131016
	SelRowObj=document.getElementById('TAdmIdPIDM'+'z'+CurrentSel);
	obj=document.getElementById("TAdmId");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	var obj=document.getElementById("TSeclectz"+CurrentSel);
	if (obj) obj.checked=true;
	SelRowObj=document.getElementById('PIADM_Status'+'z'+CurrentSel);
	if (SelRowObj) var Status=SelRowObj.value;
	if (Status=="PREREG")
	{
		obj=document.getElementById("CancelADM");
		if (obj){obj.disabled=false;
		obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>放弃预约";
		obj.style.color = "blue";
		}
		obj=document.getElementById("Update");
		if (obj) {obj.disabled=false;
		obj.style.color = "blue";}
		obj=document.getElementById("BModifyTest");
		if (obj) {obj.disabled=false;
		obj.style.color = "blue";}
		obj=document.getElementById("BPreOver");
		if (obj) {obj.disabled=false;
		obj.style.color = "blue";}
	}
	if (Status=="PREREGED")
	{
		obj=document.getElementById("CancelADM");
		if (obj){obj.disabled=false;
		obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>取消完成";
		obj.style.color = "blue";
		}
		obj=document.getElementById("Update");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("BModifyTest");
		if (obj) {obj.disabled=false;
		obj.style.color = "blue";}
		obj=document.getElementById("BPreOver");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
	}
	if (Status=="ARRIVED")
	{
		obj=document.getElementById("CancelADM");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("Update");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("BModifyTest");
		if (obj) {obj.disabled=false;
		obj.style.color = "blue";}
		obj=document.getElementById("BPreOver");
		if (obj){ obj.disabled=true;
		obj.style.color = "gray";}
		
	}
	if (Status=="CANCELPREREG")
	{
		obj=document.getElementById("CancelADM");
		if (obj){obj.disabled=false;
		obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>预约";
		obj.style.color = "blue";}
		obj=document.getElementById("Update");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("BModifyTest");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("BPreOver");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
	}
	if (Status=="CANCELARRIVED")
	{
		obj=document.getElementById("CancelADM");
		if (obj){obj.disabled=true;
		obj.style.color = "gray";}
		//obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>预约"}
		obj=document.getElementById("Update");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("BModifyTest");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("BPreOver");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
	}
		if (Status=="REGISTERED")
	{
		obj=document.getElementById("CancelADM");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("Update");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("BModifyTest");
		if (obj) {obj.disabled=false;
		obj.style.color = "blue";}
		obj=document.getElementById("BPreOver");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
	}
}
// 菜单 查询预约项目
function PreIADMItemList() {

	var iRowId="";

	var obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; }
	if (""==iRowId) { return false;}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreItemList.List"
			+"&AdmType=PERSON"
			+"&AdmId="+iRowId
			;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes';
	window.open(lnk,"_blank",nwin)	

	return true;
}
function UpdatePreAudit()
{
	var Type="I";
	var obj;
	var obj=document.getElementById("RowId");
	if (obj) { ID=obj.value; }
	if (""==ID) { return false;}
	//obj=document.getElementById("PIADM_RowId");
	//if (obj){ var ID=obj.value;}
	//else{return false;}
	if (ID=="") return false;
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreAudit.Edit"
	//		+"&CRMADM="+ID+"&ADMType="+Type+"&GIADM=";
	var lnk="dhcpepreaudit.csp?CRMADM="+ID+"&ADMType="+Type+"&GIADM="+"&RowID=";
	var wwidth=800;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}
function ModifyDelayDate()
{
	var Type="Pre";
	var obj;
	var obj=document.getElementById("RowId");
	if (obj) { ID=obj.value; }
	if (""==ID) { return false;}
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreModifyDelayDate"
			+"&ID="+ID+"&Type="+Type;
	
	var wwidth=350;
	var wheight=150;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}


function PatItemPrintA4()  
{

	//DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrintA4");
	var Page="A4"
	obj=document.getElementById("RowId");  
	if (obj){ CRMId=obj.value; }
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	var Instring=CRMId+"^"+DietFlag+"^CRM"+"^"+Page;

    var Ins=document.getElementById('GetOEOrdItemBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,'','',Instring);

	 Print(value,Page);
}
		
	

function CancelPE()
{
	if (!confirm(t["02"])) return;
	CancelPECommon('PIADM_RowIdz',"I",CurrentSel,0);
	location.reload();
}
function UnCancelPE()
{
	var PIADM="",Status="";
	var SelRowObj=document.getElementById('PIADM_RowId'+'z'+CurrentSel);
	if(SelRowObj){var PIADM=SelRowObj.value;}
	if(PIADM==""){
		alert("未选择待撤销体检的人员");
		return false;
	}
	var SelRowObj=document.getElementById('PIADM_Status_Desc'+'z'+CurrentSel);
	if(SelRowObj){var Status=SelRowObj.innerText;}
	if(Status!="取消体检"){
		alert("不是取消体检状态,不能撤销取消体检");
		return false;
	}

	if (!confirm("确定要撤销取消体检吗")) return;
	CancelPECommon('PIADM_RowIdz',"I",CurrentSel,1);
	location.reload();
}
function CancelPECommon(ElementName,Type,CurRow,DoType)
{
	var obj=document.getElementById(ElementName+CurRow,DoType);
	if (obj)
	{
		var Id=obj.value;
	}
	else
	{
		return false;
	}
	
	var obj=document.getElementById("CancelPEClass");
	if (obj)
	{
		var encmeth=obj.value;
	}
	else
	{
		return false;
	}
	var Ret=cspRunServerMethod(encmeth,Id,Type,DoType);
	Ret=Ret.split("^");
	alert(Ret[1]);
}
function UpdateAsCharged()
{
	var Type="I";
	var obj,AsType="",AsRemark="",ID="";
	if (CurrentSel==0) return;
	obj=document.getElementById("TGNamez"+CurrentSel);
	var Group=""
	if (obj) Group=obj.innerText;
	if ((Group!="")&&(Group!=" "))
	{
		alert("团体中的客户,请在团体中操作");
		return;
	}
	obj=document.getElementById("RowId");  
	if (obj){ ID=obj.value; }
	if (ID=="") {
		alert("请先选择待操作的人员");
		return false;
	}
	obj=document.getElementById("AsType");
	if (obj) AsType=obj.value;
	obj=document.getElementById("AsRemark");
	if (obj) AsRemark=obj.value;
	ID=ID+"^"+AsType+"^"+AsRemark;
	obj=document.getElementById("UpdateAsCharged");
	if (obj) var encmeth=obj.value;
	var Return=cspRunServerMethod(encmeth,ID,Type)
	if (Return==""){alert("Status Err");}
	else if (Return=="SQLErr"){alert("Update Err");}
	else{
		var obj=document.getElementById("PIADM_AsChargedz"+CurrentSel);
		if (obj) obj.checked=!obj.checked;
		//alert("Update Success!");
		alert("更新成功!");
	}
}
//打印检查项目信息 2008-06-30
//create by  zhouli
function PrintRisRequest()
{
	var obj=document.getElementById("RowId");  
	if (obj){ PreIADMDR=obj.value; }
	PrintRisRequestApp(PreIADMDR,"","PreIADM");
	return false;
}
function GetRisInfo()
{  
	if (CurrentSel==0) return;
   	var LocID=session['LOGON.CTLOCID']
	var obj=document.getElementById("RowId");  
	if (obj){ PreIADMDR=obj.value; }
	var Ins=document.getElementById('GetRisItemInfo');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,PreIADMDR);
	var String=value.split(";");
	alert(String)
  
		for (var i=0;i<String.length;i++)
		{
			var str=String[i].split("^");
            var ItemDesc=str[0]
            var Regno=str[1]
            var SexDesc=str[2]
            var Age=str[3]
            var Name=str[4]
            var InfoStr=ItemDesc+"^"+Regno+"^"+SexDesc+"^"+Age+"^"+Name
            PrintRisInfo(InfoStr);
	        //if (LocID=="165")  PrintRisInfo(InfoStr);
	    }
			
	}

		
function PrintRisInfo(InfoStr)   
{   
   var LocID=session['LOGON.CTLOCID']
	var Info=InfoStr.split("^")       
    var ItemDesc=Info[0]
    var Regno=Info[1]
    var SexDesc=Info[2]
    var Age=Info[3]
    var Name=Info[4]
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) 
	{
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintRisItemInfoNew.xls';
	}else
	{
		alert("无效模板路径");
		return;
	}
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Templatefilepath);
    xlsheet = xlBook.WorkSheets("Sheet1") 
    xlsheet.cells(2,1).Value=ItemDesc ;
    //if (LocID=="165"){xlsheet.cells(1,1).Value=Name+"  "+SexDesc+"  医务部体检"; }
	//if (LocID=="579"){xlsheet.cells(2,1).Value="医保查体"+"  "+Regno;} 
	xlsheet.cells(1,1).Value=Name+"  "+SexDesc+"  医务部体检";
	//xlsheet.cells(2,1).Value="医保查体"+"  "+Regno;
	xlsheet.cells(3,1).Value="*"+Regno+"*";
    //if (LocID=="165") {xlsheet.printout(1,1,1,false,"tiaoma");}
    //if (LocID=="579") {xlsheet.printout;}
    xlsheet.printout(1,1,1,false,"tiaoma");
    xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
	}
function PrintRisInfoOld(InfoStr)   
{   
   var LocID=session['LOGON.CTLOCID']
    
    var Info=InfoStr.split("^")       
    var ItemDesc=Info[0]
    var Regno=Info[1]
    var SexDesc=Info[2]
    var Age=Info[3]
    var Name=Info[4]
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintRisItemInfo.xls';
	}else{
		alert("无效模板路径");
		return;
	}

	xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Templatefilepath);
    xlsheet = xlBook.WorkSheets("Sheet1") 
	
    xlsheet.cells(3,1).Value=ItemDesc ;
    if (LocID=="165"){xlsheet.cells(2,1).Value="医务查体"+"  "+Regno; }
	if (LocID=="579") {xlsheet.cells(2,1).Value="医保查体"+"  "+Regno;} 
    xlsheet.cells(1,1).Value=Name+"  "+SexDesc+"  "+Age ;
    if (LocID=="165") {xlsheet.printout(1,1,1,false,"tiaoma");}
    if (LocID=="579") {xlsheet.printout;}
    //xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
	}

function printBaseInfo(Name,SexDesc)
{   var LocID=session['LOGON.CTLOCID']
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintRisItemInfo.xls';
	}else{
		alert("无效模板路径");
		return;
	}

	xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Templatefilepath);
    xlsheet = xlBook.WorkSheets("Sheet1") 
	xlsheet.cells(2,1).Value=Name+"   "+SexDesc;
    xlsheet.Rows(2).Font.Size=16;
    if (LocID=="165") {xlsheet.printout(1,1,1,false,"tiaoma");}
    if (LocID=="579") {xlsheet.printout;}
    //xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
}
function PECashier()
{
	var obj=document.getElementById('PIADM_RowId'+'z'+CurrentSel);
	if (!obj) return;
	var PADM=obj.value;
	var obj=document.getElementById('PIADM_PIBI_DR_RegNo'+'z'+CurrentSel);
	if (obj) var RegNo=obj.innerText;
	var sURL="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEAdvancePayment"
				+"&RegNo="+RegNo+"&PADM="+PADM+"&Type=R";
	window.showModalDialog(sURL,"","dialogWidth=600px;dialogHeight=450px");
}
//预约到达日期
function AppointArrivedDate()

{
	
	var obj;
	var obj=document.getElementById("RowId");  
	if (obj) { var ID=obj.value; }
	if (""==ID) { return false;}
	var Type="I"
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEAppointArrivedDate"
			+"&ID="+ID+"&Type="+Type
	
	var wwidth=350;
	var wheight=200;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
	}
	
function PrintCashierNotes()

{
	
	var obj;
	var obj=document.getElementById("RowId");
	if (obj) { var ID=obj.value; }
	if (""==ID) { 
	alert(t["NoRecord"])
	return false;}
	var obj=document.getElementById('PIADM_PIBI_DR_Name'+'z'+CurrentSel);
	if (obj) var Name=obj.innerText;
	var Type="I"
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPrintCashierNotes"
			+"&ID="+ID+"&Name="+Name+"&Type="+Type
	var wwidth=350;
	var wheight=200;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
	}
function CancelCashierNotes()    
{     	
        var obj=""
        obj=document.getElementById('RowId');
		if(obj){
			var PIADM=obj.value
			if (PIADM=="")
			{alert(t["NoRecord"])
			  return;}
			
			}
		
         var Ins=document.getElementById('Cancel');
		 if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
		 var Flag=cspRunServerMethod(encmeth,"I",PIADM,"");
         if (Flag==""){alert(t["CancelSuccess"])}
         if (Flag=="NoCashier"){alert(t["NoCashier"])} 
	
	
	}
 function PrintIOEFeeDetail()   
   {   
   	var obj=document.getElementById("RowId");  
	if (obj){ PreIADMDR=obj.value; }

	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) 
	{
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEGOEFeeDetailPrint.xls';
	}else
	{
		alert("无效模板路径");
		return;
	}

	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("明细")     //Excel下标的名称

   var Ins=document.getElementById('GetIOEFeeDetail');
    if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
  
	var Returnvalue=cspRunServerMethod(encmeth,PreIADMDR);

	if (Returnvalue==""){
		alert("无已交费的个人明细!")
		return;}

	var String=Returnvalue.split("#");
	var PatName=String[0]
	var ARCIMStr=String[1]
	var ARCIM=ARCIMStr.split("$");
	xlsheet.cells(2,1).Value=PatName+""+"体检项目费用明细";
	for(i=0;i<(ARCIM.length);i++)
	{  
	var ARCIMDesc=ARCIM[i].split("^")[0]
	var ARCIMNum=ARCIM[i].split("^")[1]
	var ARCIMAmount=ARCIM[i].split("^")[2]
 
       xlsheet.Range(xlsheet.Cells(3+i,1),xlsheet.Cells(3+i,3)).mergecells=true; //合并单元格
	xlsheet.Range(xlsheet.Cells(3+i,4),xlsheet.Cells(3+i,5)).mergecells=true; //合并单元格
	xlsheet.Range(xlsheet.Cells(3+i,6),xlsheet.Cells(3+i,7)).mergecells=true; //合并单元格
	//xlsheet.Range(xlsheet.Cells(3+i,4),xlsheet.Cells(3+i,5)).HorizontalAlignment =-4108;//居中
       xlsheet.Range(xlsheet.Cells(3+i,1),xlsheet.Cells(3+i,7)).Borders.LineStyle=1;
	 xlsheet.cells(3+i,1).Value=ARCIMDesc
        xlsheet.cells(3+i,4).Value=ARCIMNum
        xlsheet.cells(3+i,6).Value=ARCIMAmount
	 }
 		xlsheet.SaveAs("d:\\"+PatName+"体检项目费用明细.xls");
		//xlBook.Close (savechanges=false);
		//xlApp=null;
		//xlsheet=null;
	   xlApp.Visible = true;
	   xlApp.UserControl = true;
	}
function PrintReportRJ()
{
	var obj=document.getElementById("RowId");  
	if (obj){ PreIADMDR=obj.value; }
	PrintReportRJApp(PreIADMDR,"PreIADM");
}

function PrintTarItemDetail()
{
	var obj=document.getElementById("RowId");  
	if (obj){ PreIADMDR=obj.value; }
	PrintTarItemDetailApp(PreIADMDR,"CRM");
}

///addStart20131015 打印选择框
function BPrint_click()
{
	var obj;
	var iTAdmId="";
	var iOEOriId="";
	var PrintFlag=1;
	var TAdmIdStr=GetSelectId() ;
	var TAdmIds=TAdmIdStr.split(";")
	for(var PSort=0;PSort<TAdmIds.length;PSort++)
	{
		var iTAdmId=TAdmIds[PSort];
		if (iTAdmId=="") { 
	    	alert("您没有选择客户,或者没有登记");
			websys_setfocus("RegNo");
	   		return false;    
		}
		PrintAllApp(iTAdmId,"PAADM");	
	}

	websys_setfocus("RegNo");
}

function CancelArrived()
{
	var obj=document.getElementById("TAdmId");
	if (obj) { iTAdmId=obj.value; }
	if (""==iTAdmId) { 
	    alert("您没有选择客户,或者没有登记")
	    return false;    
	}
	var ret=tkMakeServerCall("web.DHCPE.PreIADMEx","CancelArrived",iTAdmId);
	alert(ret)
	
}
function ReplaceCancelPE()
{
	if (!confirm('确实要对选中人员取消体检吗')) return false;
	var obj=document.getElementById("TAdmId");
	if (obj) { iTAdmId=obj.value; }
	if (""==iTAdmId) { 
	    alert("您没有选择客户,或者没有登记")
	    return false;    
	}
	var UserID=session['LOGON.USERID'];
	var ret=tkMakeServerCall("web.DHCPE.CancelPE","UpdateCancelPEStatus",iTAdmId,UserID);
	alert(ret)
	
}
///addEnd20131015 打印选择框
//指引单打印预览
function PatItemPrintXH()
{
	var viewmark=2;
	var obj=document.getElementById("TAdmId");
	if (obj) { iTAdmId=obj.value; }
	if (""==iTAdmId) { 
	    alert("您没有选择客户,或者没有登记")
	    return false;    
	}
	var PrintFlag=1;
	var PrintView=1;
	var Instring=iTAdmId+"^"+PrintFlag+"^PAADM"+"Y";	
	var Ins=document.getElementById('GetOEOrdItemBox');	
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,'','',Instring);
	if (value=="NoPayed"){
		alert("存在未付费项目，不能预览");
		return false;
	}


	Print(value,PrintFlag,viewmark);	//DHCPEIAdmItemStatusAdms.PatItemPrint
	
}
///补打收费条码
function PrintPayAagin_Click()
{
	var obj;
	var RegNo="";
    var Name="";
    var Sex="";
    var Age="";
    var PIAdmId="";
	var NewHPNo="";
	//if (CurrentSel==0) return;
	/*
	if (CurrentSel!=0){
	obj=document.getElementById("PIADM_PIBI_DR_RegNoz"+CurrentSel);
	if (obj) RegNo=obj.innerText;
	obj=document.getElementById("PIADM_PIBI_DR_Namez"+CurrentSel);
	if (obj) Name=obj.innerText;
	obj=document.getElementById("PIADMPIBI_DR_SEXz"+CurrentSel);
	if (obj) Sex=obj.innerText;
	obj=document.getElementById("TAgez"+CurrentSel);
	if (obj) Age=obj.innerText;
	var Info=RegNo+"^"+Name+"^"+""+"^"+""+"^"+Sex+String.fromCharCode(1)+"^"+Age;
	PrintBarRis(Info);
	}
	*/
	var tbl=document.getElementById(TFORM);	//取表格元素?名称
	var row=tbl.rows.length;
	for (var iLLoop=1;iLLoop<row;iLLoop++) {
		obj=document.getElementById('TSeclect'+'z'+iLLoop);
		if (obj && obj.checked) {
		obj=document.getElementById("PIADM_PIBI_DR_RegNoz"+iLLoop);
		if (obj) RegNo=obj.innerText;
		obj=document.getElementById("TNewHPNoz"+iLLoop);
		if (obj) NewHPNo=obj.innerText;
		obj=document.getElementById("PIADM_PIBI_DR_Namez"+iLLoop);
		if (obj) Name=obj.innerText;
		obj=document.getElementById("PIADMPIBI_DR_SEXz"+iLLoop);
		if (obj) Sex=obj.innerText;
		obj=document.getElementById("TAgez"+iLLoop);
		if (obj) Age=obj.innerText;
		obj=document.getElementById("PIADM_RowIdz"+iLLoop);
		if (obj) PIAdmId=obj.value;
		var Amount=tkMakeServerCall("web.DHCPE.HandlerPreOrds","IGetAmount4Person",PIAdmId); 
		//var Amount=tkMakeServerCall("web.DHCPE.PrintNewDirect","GetPayedAmt",PIAdmId); 
		var FactAmount=Amount.split('^')[1]+'元';
		var Info=RegNo+"^"+Name+"  "+FactAmount+"^"+"^"+"^"+"^"+Sex+String.fromCharCode(1)+"^"+Age+"^"+RegNo+"^"+NewHPNo;
		PrintBarRis(Info);	
		}
	}
}
function GetSelectId() 
{   
	
	var tbl=document.getElementById(TFORM);	//取表格元素?名称
	var row=tbl.rows.length;
	var vals="";
	var val="";
	for (var iLLoop=1;iLLoop<row;iLLoop++) {
		obj=document.getElementById('TSeclect'+'z'+iLLoop);
		if (obj && obj.checked) {
			//alert(iLLoop)
			
			
			obj=document.getElementById('TAdmIdPIDM'+'z'+iLLoop);
			if (obj) { val=obj.value; }
			if (val==" ") continue;
			if (vals=="") {vals=val;}
			else {vals=vals+";"+val;}
		}
	}
	//if (""==vals) { alert("未选择受检人,操作中止!"); }
	return vals;
}
function PrintBchao()
{
	var iTAdmId="";
	var TAdmIdStr=GetSelectId() ;
	var TAdmIds=TAdmIdStr.split(";")
	for(var PSort=0;PSort<TAdmIds.length;PSort++)
	{
		var iTAdmId=TAdmIds[PSort]; //paadm
		if (iTAdmId=="") { 
	    	alert("您没有选择客户,或者没有登记");
			websys_setfocus("RegNo");
	   		return false;    
		}
		PrintBChaoReport(iTAdmId,"")
	
	}
}
///到达/取消取达
function IAdmAlterStatus(){
	
	var Data=GetSelectId1();

	if (""==Data) { return ; }
	var Datas=Data.split(";");
	for (var iLLoop=0;iLLoop<=Datas.length-1;iLLoop++){
		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			var paadm=FData[0];
			var iIAdmId=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetIAdmIdByPaadm",paadm);
			var IAdmStatus=FData[1];
			var newStatus=""
			if (IAdmStatus=="ARRIVED") {newStatus="CANCELARRIVED"}
			if (IAdmStatus=="REGISTERED") {newStatus="ARRIVED"}
			//if (IAdmStatus=="CANCELARRIVED") {newStatus="ARRIVED"}
			if (newStatus==""){
				alert("选择客人的状态应是到达或登记!");
				return false;
			}
			var flag=tkMakeServerCall("web.DHCPE.DHCPEIAdm","ArrivedUpdate",iIAdmId,newStatus);
			if (flag!='0') {
				alert(FData[1]+" "+"操作失败"+flag);
				return false;
			}
		}
	}

    alert("完成操作");
    location.reload(0);
}

function GetSelectId1() 
{ 
	
	var tbl=document.getElementById(TFORM); //取表格元素?名称
	var row=tbl.rows.length;
	var vals="";
	var val="";
	var Status="";
	for (var iLLoop=1;iLLoop<row;iLLoop++) {
		obj=document.getElementById('TSeclect'+'z'+iLLoop);
		if (obj && obj.checked) {
			obj=document.getElementById('TAdmIdPIDM'+'z'+iLLoop);//paadm
			if (obj) { val=obj.value; }
			obj=document.getElementById('PIADM_Status'+'z'+iLLoop);
			if (obj) { Status=obj.value; }
			if (val==" ") continue;
			if (vals=="") {vals=val+"^"+Status;}
			else {vals=vals+";"+val+"^"+Status;}
		}
	}
	return vals;
}

document.body.onload = BodyLoadHandler;