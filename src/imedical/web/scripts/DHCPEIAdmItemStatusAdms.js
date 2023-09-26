 ///	 DHCPEIAdmItemStatusAdms.js
///	前台工作站
///	2006/05/24  斑马888-TT
///	-----------------------
///	modified by SongDeBo 2006/5/25
///	Description: add function "CancelArrived"
//document.write("<object ID='PrintBar' CLASSID='CLSID:9B1A595C-CF71-41CD-BB9C-02A205DB7DFC' CODEBASE='../addins/client/BarCode.CAB#version=1,0,0,111'>");
//document.write("</object>");
var myCombAry=new Array();
//document.write("<object ID='ClsIDCode' WIDTH=0 HEIGHT=0 CLASSID='CLSID:299F3F4E-EEAA-4E8C-937A-C709111AECDC' CODEBASE='../addins/client/ReadPersonInfo.CAB#version=1,0,0,8' VIEWASTEXT>");
//document.write("</object>");

var gPEIAdmId="", gIAdmId="", gIAdmStatus="";
var TFORM="DHCPEIAdmItemStatusAdms";
var SelectedRow=0

function BodyLoadHandler(){
	var obj;
	//alert('s');
	obj=document.getElementById("BDietSelect");
	if (obj) { obj.onclick=BDietSelect_click;}
	
	obj=document.getElementById("Clear");
	if (obj) { obj.onclick=Clear_click; }
	
	obj=document.getElementById("BUpdateBarInfo");
	if (obj) { obj.onclick=UpdateBarInfo_Click; }
	
	obj=document.getElementById("BCancelBarInfo");
	if (obj) { obj.onclick=CancelBarInfo_Click; }
	
	obj=document.getElementById("SelectALL");
	if (obj) { obj.onclick=SelectALL_Click; }	
	
	obj=document.getElementById("txtGroupName");
	if (obj) { obj.onchange=GroupName_Change; }
	
	obj=document.getElementById("txtItemName");
	if (obj) { obj.onchange=ItemName_Change; }
	
	obj=document.getElementById("TFORM");
	if (obj && ""!=obj.value) { TFORM=obj.value; }
	
	obj=document.getElementById("txtAdmNo");
	if (obj) { obj.onkeydown=Reg_No_keydown; }
	obj=document.getElementById("txtPatName");
	if (obj) { obj.onkeydown=Reg_No_keydown; }
	
	//zhouli
	obj=document.getElementById("Save");
	if (obj) { obj.onclick=Save_Click; }
	
	obj=document.getElementById("BPrint");
	if (obj) { obj.onclick=BPrint_Click; }
	
	obj=document.getElementById("CardNo");
	if (obj) {
		obj.onchange=CardNo_Change;
		//obj.onkeydown=CardNo_KeyDown;
		obj.onkeydown= CardNo_keydown;
	}

	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}

	//读身份证
	var obj=document.getElementById("ReadRegInfo");
    if (obj){obj.onclick=ReadRegInfo_OnClick;}
	 //查询
	var obj=document.getElementById("btnQuery");
    //if (obj){obj.onclick=btnQuery_click;}

	//alert('BodyLoadHandler 1');
	// 打印 打印单
	//DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrint");
	//alert('BodyLoadHandler 2');
	ShowCurRecord(1);
	obj=document.getElementById('TSeclectz1');
	if (obj) obj.checked=true;
	//alert('BodyLoadHandler 3');
	websys_setfocus("txtAdmNo");
	SetSort("tDHCPEIAdmItemStatusAdms","TSort")
	//ColorTblColumn();
	initialReadCardButton()
}

function ReadRegInfo_OnClick()
  {
	 
   	var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
	var rtn=tkMakeServerCall("DHCDoc.Interface.Inside.Service","GetIECreat")
	var myHCTypeDR=rtn.split("^")[0];
	var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);
    var myary=myInfo.split("^");
 
     if (myary[0]=="0")
     { 
     
      SetPatInfoByXML(myary[1]); 
      //var mySexobj=document.getElementById("Sex");
	  //var myBirobj=document.getElementById("Birth");
	  var myNameobj=document.getElementById("Name");
	  var myPatNameobj=document.getElementById('txtPatName');
	  if ((myNameobj)&&(myPatNameobj)){
			myPatNameobj.value=myNameobj.value; 
			//alert(myPatNameobj.value)
			
		} 
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
	var obj=document.getElementById("txtAdmNo");
	if (obj){
		obj.value=RegNo;
		btnQuery_click();
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
			//alert(nodes(i).text)
			myCombAry[myItemName].setComboValue(myItemValue);
            
		}else{

			DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
		}
	}
	
	delete(xmlDoc);
}
/*
function btnQuery_click()
{
   var obj;
   var iRegNo="",iName="",itxtGroupId="",iDepart="",iCheckedFlag ="",itxtItemId="",iBeginDate="",iEndDate="";
	obj=document.getElementById("txtAdmNo");
	if (obj){ 
		iRegNo=obj.value;
		if (iRegNo.length<8 && iRegNo.length>0) { iRegNo=RegNoMask(iRegNo); }
	}
	obj=document.getElementById("txtPatName");
	if (obj){ 
		iName=obj.value;
	}
	
	obj=document.getElementById("txtGroupId");
	if (obj){ 
    	itxtGroupId=obj.value;
	}
	
	obj=document.getElementById("BeginDate");
	if (obj){ 
    	iBeginDate=obj.value;
	
	}
	obj=document.getElementById("EndDate");
	if (obj){ 
    	iEndDate=obj.value;
	
	}

	obj=document.getElementById("txtItemId");
	if (obj){ 
    	itxtItemId=obj.value;
	
	}
	obj=document.getElementById("CheckedFlag");
	if (obj){ 
    	iCheckedFlag=obj.value;
	
	}
	obj=document.getElementById("Depart");
	if (obj){ 
    	iDepart=obj.value;
	
	}

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIAdmItemStatusAdms"
			+"&txtPatName="+trim(iName)
			+"&txtGroupId="+itxtGroupId
			+"&BeginDate="+iBeginDate
			+"&txtAdmNo="+iRegNo
			+"&txtItemId="+itxtItemId
			+"&EndDate ="+iEndDate 
			+"&CheckedFlag"+iCheckedFlag
			+"&Depart="+iDepart
					
	;
	location.href=lnk;	
}
*/

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
function BPrint_Click()
{
	var obj;
	var Data=GetSelectId("TAdmId^");
	
	var Datas=Data.split(";");
	var obj=document.getElementById("GetSpecItemInfo");
	if (obj) var encmeth=obj.value;
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){
		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			var iIAdmId=FData[2];
			PrintAllApp(iIAdmId,"PAADM");  //DHCPEPrintCommon.js
		} 
	}
	
	websys_setfocus("txtAdmNo");
	
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
	CardNoChangeApp("txtAdmNo","CardNo","btnQuery_click()","Clear_click()","0");
}
function ReadCard_Click()
{
	ReadCardApp("txtAdmNo","btnQuery_click()","CardNo");
	
}

function GroupName_Change()
{
	var obj=document.getElementById("txtGroupId");
	if (obj) { obj.value=""; }
}
function ItemName_Change()
{
	var obj=document.getElementById("txtItemId");
	if (obj) { obj.value=""; }
}
function Reg_No_keydown(e)
{
	var Key=websys_getKey(e);
	if ((13==Key)) {
		btnQuery_click();
	}
}
//清屏
function Clear_click(){
	
	/*
	var Data=GetSelectId("TAdmId^TAdmStatus^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");

	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){
		
		FData=Datas[iLLoop].split("^");
		alert(FData);
		if (""!=FData) {
			iIAdmId=FData[2];
			
		}
	}
	
	return;
	*/
	var obj;
	obj=document.getElementById('txtAdmNo');
	if (obj) { obj.value=""; }
	
	obj=document.getElementById('txtGroupName');
	if (obj) { obj.value=""; }
	
	obj=document.getElementById('txtGroupId');
	if (obj) { obj.value=""; }
	
	obj=document.getElementById('txtPatName');
	if (obj) { obj.value=""; }
	
	obj=document.getElementById('BeginDate');
	if (obj) { obj.value=""; }
	
	obj=document.getElementById('CardNo');
	if (obj) { obj.value=""; }
	
	obj=document.getElementById('txtItemName');
	if (obj) { obj.value=""; }
	
	obj=document.getElementById('txtItemId');
	if (obj) { obj.value=""; }
	
	
	
}
function UpdateBarInfo_Click()
{
	var Strings=GetBarInfoStrings("OneStr");
	if (Strings=="") return;
	var encmethobj=document.getElementById("UpdateBarInfo");
	if (encmethobj) var encmeth=encmethobj.value;
	var ReturnStr=cspRunServerMethod(encmeth,Strings,"N");
	
}

 //zl 2008-03-25
function Save_Click()
{ 
	var Strings=GetNotPrintInfo();
	if (Strings=="") return;
	
	var encmethobj=document.getElementById("SaveInfo");
		
	if (encmethobj) var encmeth=encmethobj.value;
	var ReturnStr=cspRunServerMethod(encmeth,Strings);

	if (ReturnStr==0)  
    
	{    
		var obj=document.getElementById("btnQuery")
    		if (obj) obj.click();
		 
	}
	else
	{
		alert(t["Err"]);
	}
}





function CancelBarInfo_Click()
{
	var Strings=GetBarInfoStrings("OneStr");
	
	if (Strings=="") return;
	var encmethobj=document.getElementById("UpdateBarInfo");
	if (encmethobj) var encmeth=encmethobj.value;
	var ReturnStr=cspRunServerMethod(encmeth,Strings,"Y");
}
function GetBarInfoStrings(Type)
{
	var Strings=""
	var CurRow=0;
	TObj=parent.frames["DHCPEIAdmItemStatusDetail"];
	var DObj=parent.frames["DHCPEIAdmItemStatusDetail"].document;
	var tbl=DObj.getElementById('tDHCPEIAdmItemStatusDetail');	//取表格元素?名称
	if (Type!="")
	{
		CurRow=TObj.SelectedRow;
		if (CurRow==0) return "";
	}
	var row=tbl.rows.length;
	row=row-1;
	for (var j=1;j<row+1;j++) {
		var sLable=DObj.getElementById('TPlacerNoz'+j);
		var sTD=sLable.parentElement;
		var strCell=Trim(sLable.value);
		if (CurRow!=j&&CurRow!=0) continue;
		if (strCell!=""){
			var OEID="";
			var obj=DObj.getElementById('TIdz'+j);
			if (obj) OEID=Trim(obj.value);
			if (OEID!=""){
				if (Strings==""){
					Strings=OEID+";"+strCell;
				}
				else{
					Strings=Strings+"^"+OEID+";"+strCell;
				}
			}
		}
	}
	return Strings;
}

//zhouli
function GetNotPrintInfo()
{   var  isPrint=""
	var Strings=""
	var CurRow=0;
	TObj=parent.frames["DHCPEIAdmItemStatusDetail"];
	var DObj=parent.frames["DHCPEIAdmItemStatusDetail"].document;
	var tbl=DObj.getElementById('tDHCPEIAdmItemStatusDetail');	//取表格元素?名称

	var row=tbl.rows.length;
	row=row-1;

	for (var j=1;j<row+1;j++) {
		var sPrint=DObj.getElementById('TNotPrintz'+j);
		if (sPrint)
		
		{
		if (true==sPrint.checked){var isPrint="Y";}
		else{var isPrint="N"; }	
		
		var sTD=isPrint.parentElement;
	
     	var strCell=isPrint
     	
     	
	}  
		if (CurRow!=j&&CurRow!=0) continue;
		
		if (strCell!=""){
			
			var OEID="";
			var obj=DObj.getElementById('TIdz'+j);
				
			if (obj) OEID=Trim(obj.value);
			if (OEID!=""){
				if (Strings==""){
					Strings=OEID+";"+strCell;
				}
				else{
					Strings=Strings+"^"+OEID+";"+strCell;
				}
			}
		}
	}
	
	return Strings;
}

//去除字符串两端的空格
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
function AfterGroupSelected(value){
	//ROWSPEC = "GBI_Desc:%String, GBI_Code:%String, GBI_RowId:%String"	
	if (""==value){return false}
	var aiList=value.split("^");
	SetCtlValueByID("txtGroupId",aiList[0],true);
	SetCtlValueByID("txtGroupName",aiList[1],true);
	/*var aiList=value.split("^");
	SetCtlValueByID("txtGroupId",aiList[2],true);
	SetCtlValueByID("txtGroupName",aiList[0],true);*/
}
function AfterItemSelected(value){
	if (""==value){return false}
	
	var aiList=value.split("^");
	SetCtlValueByID("txtItemId",aiList[1],true);
	SetCtlValueByID("txtItemName",aiList[0],true);
	
}
// ******************************************************************************
// ******************************************************************************
// ************************        前台功能          *****************************
//更新到达日期
function UpdateArriveDate()
{
	var Data=GetSelectId("TPEIAdmId^");
	if (""==Data) {
		return ;
	}
	var Datas=Data.split(";");
	var ArriveDate="";
	var ArriveDateObj=document.getElementById("UpdateArriveDate");
	if (ArriveDateObj) ArriveDate=ArriveDateObj.value;
	//获取信息
	var Ins=document.getElementById("GetUpdateArrived");
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	if (encmeth=="")
	{
		alert("没有设置更新方法")
		return;
	}
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){
		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			var iIAdmId=FData[2]
			var Return=cspRunServerMethod(encmeth,iIAdmId,ArriveDate);
			if (Return!="0") break;
		}
	}
	alert(Return)
}

//补打检验条码
function BarCodePrintBD() 
{   
  
	var Data=GetSelectId("TAdmId^");
	if (""==Data) {
		return ;
	}
	var Datas=Data.split(";");
	var targetFrame=GetCtlValueById("txtTargetFrame");
	var obj;
	var OneSpecNo=parent.frames["DHCPEIAdmItemStatusDetail"].GetOneOrdItem();
	var Info=OneSpecNo.split("^");
	var iOEOriId=Info[1];
	//var iOEOriId="";
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){

		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			var iIAdmId=FData[2]
			
			var InString=iIAdmId+"^"+iOEOriId;
			//获取信息
			var Ins=document.getElementById("PatOrdItemInfo");
			if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
			var flag=cspRunServerMethod(encmeth,"BarPrint","",InString,"Y","Y");
		}
	}



}
//个人信息打印
function PersonInfoCodePrint()
{
	var Data=GetSelectId("TAdmId^");
	if (""==Data) {
	return ;
	}
	// 打印信息
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCPEPersonInfo");
	var Datas=Data.split(";");
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){
		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			var iIAdmId=FData[2]
			var InString=iIAdmId;
			//获取信息
			OnePersonInfoCodePrint(InString)
		}
	}
}


function PrintOneBarCode()
{
	var targetFrame=GetCtlValueById("txtTargetFrame");
	var obj;
	var OneSpecNo=parent.frames["DHCPEIAdmItemStatusDetail"].GetOneSpecNo();
	var Info=OneSpecNo.split("^");
	var IAdmId=Info[0];
	var SpecNo=Info[1];
	if (SpecNo=="") {alert("请选择一个标本号");return;}
	if (IAdmId=="") return;
	if (!confirm("确实打印标本号为"+SpecNo+"的条码吗")) return;
	var InString=IAdmId+"^"
	var Ins=document.getElementById("PatOrdItemInfo");
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,"","",InString);
	
	if (value=="NoPayed")
	{
		alert(t["NoPayed"])
		return false;
	}
	PrintBarApp(value,SpecNo)
	return;
	
	var Ords=value.split(";");
	
	var iLLoop=1;
	for (var iLLoop=1;iLLoop<Ords.length;iLLoop++) 
	{

		var OrdItems=Ords[iLLoop].split("^");
		var OneSpecNo=OrdItems[6];
		if (OneSpecNo!=SpecNo) continue;
		
		var Bar; 
		Bar= new ActiveXObject("PrintBar.PrnBar");
		Bar.PrintName="tm";//打印机名称
        Bar.SetPrint()
        // 登记号
		Bar.RegNo=OrdItems[0]; 	
		// 姓名
		Bar.PatName=OrdItems[1];
		// 年龄
		Bar.Age=OrdItems[2];
		// 性别
		Bar.Sex=OrdItems[3];
		//alert("Bar.Sex:"+Bar.Sex);
		// 部门
		Bar.PatLoc=OrdItems[4];	
		// 标本号
		Bar.SpecNo=OrdItems[6];	
		//标本名称
		Bar.SpecName=OrdItems[7].split("\\!")[0];
		// 项目名称
		var OrdNameArray=Ords[iLLoop].split("\\!");
		Bar.OrdName=OrdNameArray[1];
		Bar.RecLoc=OrdNameArray[2];
        Bar.BedCode="";
        Bar.PrintZebraBar();
	}
}
///站点等候查询
function StationWaitList() {	

	DAlert("test");	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+TFORM
			;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=400,height=300,left=100,top=100';
	window.open(lnk,"_blank",nwin)
}

///就餐 Create by MLH
function Diet() {

	var Data=GetSelectId("TPEIAdmId^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){

		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			var iIAdmId=FData[2];
			var encmeth=GetCtlValueById('DietBox',1);        
    		var flag=cspRunServerMethod(encmeth,iIAdmId)///////////
    		if (flag!='0') {
				alert(FData[2]+" "+t['ErrFailed']+"  error="+flag);
				return false
			}

		}
	}

    var obj=document.getElementById("btnQuery")
    if (obj) obj.click();

}

///取消取达
function IAdmAlterStatus(){
	var Data=GetSelectId("TPEIAdmId^TAdmStatus^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){

		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			iIAdmId=FData[2];
			IAdmStatus=FData[3];
			var newStatus=""
			//if (IAdmStatus=="ARRIVED") {newStatus="REGISTERED"}
			//if (IAdmStatus=="REGISTERED") {newStatus="ARRIVED"}
			if (IAdmStatus=="ARRIVED") {newStatus="CANCELARRIVED"}
			if (IAdmStatus=="CANCELARRIVED") {newStatus="ARRIVED"}
			if (newStatus==""){
				//alert(t['ErrNotStatus']+IAdmStatus);
				alert("选择客人的状态应是到达,否则不能取消到达");
				return false;
			}
	
			DAlert(gPEIAdmId);
			var encmeth=GetCtlValueById('AlterStatusBox',1);        
			var flag=cspRunServerMethod(encmeth,iIAdmId,newStatus)///////////
			if (flag!='0') {
				alert(FData[2]+" "+t['ErrFailed']+"  error="+flag);
				return false
			}
		}
	}

    var obj=document.getElementById("btnQuery")
    if (obj) obj.click();
}


// 给完成的预约设表示?颜色
function ColorTblColumn(){
	var tbl=document.getElementById('t'+TFORM);	//取表格元素?名称
	var row=tbl.rows.length;
	row=row-1;
	for (var j=1;j<row+1;j++) {
		var sLable=document.getElementById('TCompletedz'+j);
		var sTD=sLable.parentElement;
		var strCell=sLable.innerText;
		strCell=strCell.replace(" ","")
		if (strCell=='') {
			sTD.className="DentalSel";
		}
		else{
			sTD.className="Govement";
		}
	}
}

// ********************************************************************
function GetSelectId(FiledName) 
{   var tbl=document.getElementById('t'+TFORM);	//取表格元素?名称
	var row=tbl.rows.length;
	var vals="";
	var val=""
	var FNames=FiledName.split('^');
    if (row==2)
    {
	    obj=document.getElementById('TSeclect'+'z1');
	    obj.checked=true;
    }
	for (var iLLoop=1;iLLoop<row;iLLoop++) {
		obj=document.getElementById('TSeclect'+'z'+iLLoop);
		if (obj && obj.checked) {
			
			obj=document.getElementById('TPatNAME'+'z'+iLLoop);
			if (obj) { val=iLLoop+'^'+obj.innerText+'^'; }
			
			for (var iFLoop=0;iFLoop<FNames.length-1;iFLoop++){			
				obj=document.getElementById(FNames[iFLoop]+'z'+iLLoop);
				if (obj) {if (obj.type!='checkbox') val=val+obj.value+'^'; 
				if (obj.type=='checkbox') val=val+obj.checked+"^"}
				
			}
			
			vals=vals+val+";";
		}
	}
	if (""==vals) { alert("未选择受检人,操作中止!"); }
	/*if (vals!="")
	{
		var Flag=""
		if (FiledName.split("^")[0]=="TPEIAdmId") Flag="PEADM"
		var obj=document.getElementById("printSortClass");
		if (obj)
		{
			var encmeth=obj.value;
			vals=cspRunServerMethod(encmeth,vals,Flag)
			
		}
	}*/
	return vals;
}
function BDietSelect_click()
{
	var Src=window.event.srcElement;
	
	var tbl=document.getElementById('t'+TFORM);	//取表格元素?名称
	var row=tbl.rows.length;
	
	for (var iLLoop=1;iLLoop<=row;iLLoop++) {
		obj=document.getElementById('TDeitFlag'+'z'+iLLoop);
		if (obj) { obj.checked=!obj.checked; }
	}
}
function SelectALL_Click() 
{
	var Src=window.event.srcElement;
	
	var tbl=document.getElementById('t'+TFORM);	//取表格元素?名称
	var row=tbl.rows.length;
	
	for (var iLLoop=1;iLLoop<=row;iLLoop++) {
		obj=document.getElementById('TSeclect'+'z'+iLLoop);
		idobj=document.getElementById('TAdmNo'+'z'+iLLoop);
		if (idobj.innerText==" ") continue;
		if (obj) { obj.checked=Src.checked; }
	}
	
}
///选择 显示其项目
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEIAdmItemStatusAdms');	//取表格元素名称
	if (eSrc.id.split("TAdmDate").length>1) return false;
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

    ///此处之前较为固定?除了修改document.getElementById('tINSUPatTypeC
    
    if (!selectrow) return;
	//ChangeCheckStatus("TSeclect");
	ShowCurRecord(selectrow)
}	
function ShowCurRecord(CurRecord) {
	var SelRowObj
	var obj	
	var selectrow=CurRecord;
	var equipmentId;
	
	var admId="";
	gIAdmId="";
	gPEIAdmId="";
	gIAdmStatus="";	
	
	SelCellObj=document.getElementById('TAdmIdz'+selectrow);
	//admId=SelCellObj.innerText;	
	if (SelCellObj) {
		admId=SelCellObj.value;	
		gIAdmId=SelCellObj.value;	
	}
	
	SelCellObj=document.getElementById('TPEIAdmIdz'+selectrow);
	if (SelCellObj) {
		gPEIAdmId=SelCellObj.value;
	}
	SelCellObj=document.getElementById('TAdmStatusz'+selectrow);
	if (SelCellObj) {
		gIAdmStatus=SelCellObj.value;	
	}
	
	targetFrame=GetCtlValueById("txtTargetFrame");
	targetComponet=GetCtlValueById("txtTargetComponent");
	paramName=GetCtlValueById("txtParamName");
	if (paramName=="")  paramName="AdmId";
	if (targetComponet=="")  targetComponet="DHCPEIAdmItemStatusDetail";
	if (targetFrame=="")  targetFrame="DHCPEIAdmItemStatusDetail";
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+targetComponet+"&" +paramName+"="+admId ;
    parent.frames[targetFrame].location.href=lnk;
	
}
function SetSort(TableName,ItemName)
{
	var objtbl=document.getElementById(TableName);	
	
	if (objtbl) { var rows=objtbl.rows.length; }
	for (var j=1;j<rows;j++)
	{
		var obj=document.getElementById(ItemName+"z"+j);
		if (obj) obj.innerText=j;	
	}
}

//打印心电图信息
function PrintElectrocardiogram() {

	obj=document.getElementById("prnpath")
	        if (obj && ""!=obj.value) {
	        var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintElectrocardiogram.xls';
        	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");

	var Data=GetSelectId("TAdmId^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");

	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){
	
		FData=Datas[iLLoop].split("^");
			
		if (""!=FData) {
				
			var Instring=FData[2]+"^"+FData[1];
			var Ins=document.getElementById('GetBox');
			if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
			var value=cspRunServerMethod(encmeth,Instring);
		
		     if (value=="") return;
		     var Ords=value.split("^");
		   
        xlsheet.cells(1,2).Value=Ords[1]; //姓名
		xlsheet.cells(2,2).Value=Ords[2]; 
		xlsheet.cells(3,2).Value=Ords[3]; //医嘱名称
		
		xlsheet.Range(xlsheet.Cells(1,2), xlsheet.Cells(3,2)).Font.Name = "黑体" 
	    //xlsheet.Range(xlsheet.Cells(1,1), xlsheet.Cells(3,1)).Font.Name = "黑体" 
	  xlsheet.printout   ///(1,1,1,false,"tj");
	   

	xlBook.Close (savechanges=false);
	
	xlApp=null;
	
	xlsheet=null;
		
  // xlApp.Visible = true;
  // xlApp.UserControl = true;
 
}

		  	
	}
	
			
	
}
//打印心电图信息
function PrintElectrocardiogramFX(IADM) {


	
	var Ins=document.getElementById('ECGExistFlagBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var ExistFlag=cspRunServerMethod(encmeth,IADM);
       if (ExistFlag=="") return;
       var OrdItems=ExistFlag.split("^");
       
        var Bar; 
		Bar= new ActiveXObject("PrintBar.PrnBar");
		Bar.PrintName="tm";//打印机名称
        Bar.SetPrint()
		// 登记号
		Bar.RegNo=OrdItems[0]; 	
		// 姓名
		Bar.PatName=OrdItems[1];
		// 年龄
		Bar.Age=OrdItems[2];
		// 性别
		Bar.Sex=OrdItems[3];
		// 部门
		Bar.PatLoc="";	
		// 标本号
		Bar.SpecNo=OrdItems[0];	
		//标本名称
		Bar.SpecName="心电图";
		
		// 项目名称
		Bar.OrdName=OrdItems[4]
		Bar.RecLoc="";
        Bar.BedCode="";   
		Bar.PrintZebraBar();
 
}
//谢绝检查 Added by zhouyong
/*
function Refuse(){
	var OEORIRowId=parent.frames["DHCPEIAdmItemStatusDetail"].GetId();
	if(OEORIRowId=="")return;
	var encmeth="";
	var obj=document.getElementById("RefuseBox");
	if(obj)encmeth=obj.value;
	var obj=document.getElementById("RefuseReason");
	if (obj){
		OEORIRowId=OEORIRowId+"^"+obj.value;
	}
	var RefuseCode=cspRunServerMethod(encmeth,OEORIRowId);
	if (RefuseCode=='0') {alert(t['OrderItemRefused']);}
	else if(RefuseCode=="-1")
	{
		alert(t['OrderItemExecuted']);
	}
	else
	{alert(t['RefuseErr']);}
	parent.frames["DHCPEIAdmItemStatusDetail"].location.reload();
}
*/
function Refuse(){
	var OEORIRowIdStr=parent.frames["DHCPEIAdmItemStatusDetail"].GetId();
	if(OEORIRowIdStr==""){
		alert("请先选择医嘱")
		return false;
	}
	var encmeth="";
	var obj=document.getElementById("RefuseBox");
	if(obj)encmeth=obj.value;
	var RefuseCodeStr="";
	var Arr=OEORIRowIdStr.split("^");
	var Length=Arr.length;
	for (var i=0;i<Length;i++)
	{ 
		var OEORIRowId=Arr[i];
		var obj=document.getElementById("RefuseReason");
		if (obj){
			OEORIRowId=OEORIRowId+"^"+obj.value;
		}
	
	var RefuseCode=cspRunServerMethod(encmeth,OEORIRowId);
	
	if(RefuseCodeStr==""){var RefuseCodeStr=RefuseCode;}
	else{var RefuseCodeStr=RefuseCodeStr+"^"+RefuseCode;}
	
	}
	
	var RefuseArr=RefuseCodeStr.split("^");
	var RefuseLength=RefuseArr.length;
	var j=0
	for (var ii=0;ii<RefuseLength;ii++)
	{ 
		if(RefuseArr[ii]=="0") {j++;} 
	
	}
	if(ii==j){var flag="0";}
	if(RefuseCodeStr.indexOf("-1")>=0){var flag="-1";}
	if (flag=='0') {alert(t['OrderItemRefused']);}
	else if(flag=="-1")
	{
	alert("已执行项目不能再进行操作");
		
	}else{alert(t['RefuseErr']);}

	parent.frames["DHCPEIAdmItemStatusDetail"].location.reload();
	
}

//院外检验清单导出
function PrintLabItemList()
{  
	var Data=GetSelectId("TAdmId^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++)
	{
		FData=Datas[iLLoop].split("^");
			
		if (""!=FData) {
				
			var Instring=FData[2]+"^"+FData[3];
			var Ins=document.getElementById('GetPatLisItem');
			if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
			var value=cspRunServerMethod(encmeth,'','',Instring);
		 
	        obj=document.getElementById("prnpath");
	        if (obj && ""!=obj.value) {
		    var prnpath=obj.value;
		    var Templatefilepath=prnpath+'DHCPELisItemExport.xls';
	
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称

        var Row=2
        var PatInfo=value.split("!")[0]
    
        var RegNo=PatInfo.split("^")[0]
        var Name=PatInfo.split("^")[1]
        var SexDesc=PatInfo.split("^")[3]
        var Age=PatInfo.split("^")[2]
       
            	xlsheet.cells(Row,2).Value=RegNo;
            	xlsheet.cells(Row,4).Value=Name
            	xlsheet.cells(Row,6).Value=SexDesc
            	xlsheet.cells(Row,8).Value=Age
            
	            Row=Row+1;
	            Row=Row+1;
	            var LisStr=value.split("!")[1];
	            var LisItem=LisStr.split(";")
	         
	            for (var i=0;i<LisItem.length;i++)
	            { 
		            var Item=LisItem[i].split("^")
		       
		       
	            xlsheet.cells(Row,1).Value=Item[0];
	            xlsheet.cells(Row,5).Value=Item[1];
	            xlsheet.cells(Row,7).Value=Item[2];
	            Row=Row+1
	           
	            }
	  xlsheet.printout;
      xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet=null
		     
		}
		
	
	}
	
}
///打印病人信息的条码
function PrintPatInfo()
{
	
	var Data=GetSelectId("TAdmId^");
	if (""==Data) {
		return ;
	}
	var Datas=Data.split(";");
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintReportCoverInfo.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	var Str=xlsheet.cells(2,1).Value;
	var Length=Datas.length;
	var Num=1
	var obj=document.getElementById("txtPatName");
	if ((obj)&&(obj.value!="")) Num=+obj.value;
	var obj=document.getElementById("GetPatInfoClass");
	if (obj) var encmeth=obj.value;
	var RowLength=0
	for (i=0;i<Length-1;i++)
	{
		var IADM=Datas[i].split("^")[2];
		if (IADM=="") continue;
		
		var PatInfo=cspRunServerMethod(encmeth,IADM);
		var PatInfo=PatInfo.split("^");
		var PatName=PatInfo[4];
		var Sex=PatInfo[3];
		var Age=PatInfo[7];
		var SortNo=PatInfo[12];
		var hospStr=Str;
		if (SortNo!="") var hospStr=SortNo+"  "+Str;
		for (j=0;j<Num;j++)
		{
			var Rows=2*RowLength;
			var patStr=PatName+"  "+Sex+"  "+Age+"岁"
			xlsheet.cells(Rows+1,1).Value=patStr;
			xlsheet.cells(Rows+2,1).Value=hospStr;
			RowLength=RowLength+1
		}
		
	}
	//xlsheet.saveas("d:\\aa.xls")
	xlsheet.printout
	
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
	
}
//获取检查信息 2008-06-30
/*
function GetRisInfo()
{
	var LocID=session['LOGON.CTLOCID']    
	var Data=GetSelectId("TAdmId^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");
    for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++)
    {
		FData=Datas[iLLoop].split("^");
		if (""!=FData)
		{
		    var Instring=FData[2]+"^"+""+"^"+""+"^"+""+"^"+""
			var Ins=document.getElementById('GetRisItemInfo');
			if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }

			   var InfoString=cspRunServerMethod(encmeth,Instring,"Y");  //前台打印
		      	var Patstr=InfoString.split("&")[1]
                var InfoStr=InfoString.split("&")[0]
	             var String=InfoStr.split(";");
	          
		    	for (var i=0;i<String.length;i++)
		    	{
			    	var str=String[i].split("^");
                	var ItemDesc=str[0]
                	var Regno=str[1]
               	 	var SexDesc=str[2]
                	var Age=str[3]
                	var Name=str[4]
                	var GroupFlag=str[5]
                	var InfoStr=ItemDesc+"^"+Regno+"^"+SexDesc+"^"+Age+"^"+Name+"^"+GroupFlag
		  
		            PrintRisInfo(InfoStr)
		 
		    	}
		
			}
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
    var GroupFlag=Info[5]
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
	//xlsheet.cells(1,1).Value=Name+" "+SexDesc+" "+Age+" 医务部体检"; 

	xlsheet.cells(2,1).Value=ItemDesc ;
	xlsheet.cells(1,1).Value=Name+" "+SexDesc+" "+Age+" "+GroupFlag ; 
	xlsheet.cells(3,1).Value="*"+Regno+"*";
    //xlsheet.printout(1,1,1,false,"tiaoma")
   
    xlApp.Visible = true;
    // xlApp.UserControl = true;	
   //xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
}
*/
function GetRisInfo()

{    
   var Char_2=String.fromCharCode(2);
   DHCP_GetXMLConfig("InvPrintEncrypt","PERisInfoPrint");
    var OEItemID=""
    var LocID=session['LOGON.CTLOCID']    
	var Data=GetSelectId("TAdmId^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");

	
	var OneRisInfo=parent.frames["DHCPEIAdmItemStatusDetail"].GetOneRisInfo();
	if (OneRisInfo!=""){
	var Info=OneRisInfo.split("^");
	var ItmMastDR=Info[1];
	var ItmMastDesc=Info[2];
	var status=Info[3]
	var OEItemID=Info[4]
	var Ins=document.getElementById("GetOneRisItemInfo");
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var StationID=cspRunServerMethod(encmeth,ItmMastDR);
	var Info=StationID.split(";")
	var STID=Info[0]
    var LabID=Info[1]
    var str=Info[2]
    if (status=="停止") {alert("该医嘱已停");return;}
	var flag=false;
    var StringStr=str.split("^");
    for (var i=0;i<StringStr.length;i++)
    {  
    	var RisID=StringStr[i];
		if (RisID!=STID)continue;
        flag=true;
    }
    if(flag==false){alert("请选择一条检查医嘱");return;}
	if (!confirm("确实打印"+ItmMastDesc+"医嘱的标签吗")) return;
	}
    for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++)
    {
		FData=Datas[iLLoop].split("^");
		if (""!=FData)
		{
		    var Instring=FData[2]+"^"+""+"^"+""+"^"+""+"^"+OEItemID
			var Ins=document.getElementById('GetRisItemInfo');
			if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
			var InfoString=cspRunServerMethod(encmeth,Instring,"Y","N");  //前台打印  补打
	       var vals=InfoString.split("%");
           var InfoStr=vals[0]
           var PatInfo=vals[1]
           var TxtInfo=""
	       var ItemStr=InfoStr.split(";"); 
	       if (ItemStr=="")
	       {alert("没有检查医嘱")
	          return;}
       for (var i=0;i<ItemStr.length;i++)
         
		   {   
		    var ItemDesc=ItemStr[i]
			TxtInfo=PatInfo+"^"+"ItemDesc"+Char_2+ItemDesc; 
			var myobj=document.getElementById("ClsBillPrint");
	        DHCP_PrintFun(myobj,TxtInfo,"");

		     }
	

}

   }
    }
   //补打检查标签 
 function GetRisInfoBD()

{    
   var Char_2=String.fromCharCode(2);
   DHCP_GetXMLConfig("InvPrintEncrypt","PERisInfoPrint");
    var OEItemID=""
    var LocID=session['LOGON.CTLOCID']    
	var Data=GetSelectId("TAdmId^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");
	var OneRisInfo=parent.frames["DHCPEIAdmItemStatusDetail"].GetOneRisInfo();
	if (OneRisInfo!=""){
	var Info=OneRisInfo.split("^");
	var ItmMastDR=Info[1];
	var ItmMastDesc=Info[2];
	var status=Info[3]
	var OEItemID=Info[4]
	var Ins=document.getElementById("GetOneRisItemInfo");
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var StationID=cspRunServerMethod(encmeth,ItmMastDR);
	var Info=StationID.split(";")
	var STID=Info[0]
    var LabID=Info[1]
    var str=Info[2]
    if (status=="停止") {alert("该医嘱已停");return;}
	var flag=false;
    var StringStr=str.split("^");
    for (var i=0;i<StringStr.length;i++)
    {  
    	var RisID=StringStr[i];
		if (RisID!=STID)continue;
        flag=true;
    }
    if(flag==false){alert("请选择一条检查医嘱");return;}
	if (!confirm("确实打印"+ItmMastDesc+"医嘱的标签吗")) return;
	}
    for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++)
    {
		FData=Datas[iLLoop].split("^");
		if (""!=FData)
		{
		    var Instring=FData[2]+"^"+""+"^"+""+"^"+""+"^"+OEItemID
			var Ins=document.getElementById('GetRisItemInfo');
			if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
			var InfoString=cspRunServerMethod(encmeth,Instring,"Y","Y");  //前台打印
	        var vals=InfoString.split("%");
            var InfoStr=vals[0]
            var PatInfo=vals[1]
            var TxtInfo=""
	        var ItemStr=InfoStr.split(";"); 
	       if (ItemStr=="")
	       {alert("没有检查医嘱")
	          return;}
       for (var i=0;i<ItemStr.length;i++)
         
		   {   
		    var ItemDesc=ItemStr[i]
			TxtInfo=PatInfo+"^"+"ItemDesc"+Char_2+ItemDesc; 
			var myobj=document.getElementById("ClsBillPrint");
	        DHCP_PrintFun(myobj,TxtInfo,"");

		     }
		   

}

   }
    }
 //打印单个标签
 /*
function PrintOneRisInfo()
{   var LocID=session['LOGON.CTLOCID']
	var targetFrame=GetCtlValueById("txtTargetFrame");
	var obj;   
	var OneRisInfo=parent.frames["DHCPEIAdmItemStatusDetail"].GetOneRisInfo();
	var Info=OneRisInfo.split("^");
	var IAdmId=Info[0];
	var ItmMastDR=Info[1];
	var ItmMastDesc=Info[2];
	var status=Info[3]
	var OEItemID=Info[4]
	if (ItmMastDR=="") {alert("请选择一个检查医嘱");return;}
	var Ins=document.getElementById("GetOneRisItemInfo");
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var StationID=cspRunServerMethod(encmeth,ItmMastDR);
	var Info=StationID.split(";")
	var STID=Info[0]
    var LabID=Info[1]
    var str=Info[2]
    if (status=="停止") {alert("该医嘱已停");return;}
	var flag=false;
    //var STIDlastIndex=str.lastIndexOf(STID);
    var StringStr=str.split("^");
    for (var i=0;i<StringStr.length;i++)
    {  
    	var RisID=StringStr[i];
		if (RisID!=STID)continue;
        flag=true;
    }
    if(flag==false){alert("请选择一条检查医嘱");return;}
    if (IAdmId=="") return;
	if (!confirm("确实打印"+ItmMastDesc+"医嘱的标签吗")) return;
	var InString=IAdmId+"^"+""+"^"+""+"^"+""+"^"+OEItemID
	var Ins=document.getElementById("GetRisItemInfo");
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,InString);
	var Info=value.split("^")       
    var ItemDesc=Info[0]
    var Regno=Info[1]
    var SexDesc=Info[2]
    var Age=Info[3]
    var Name=Info[4]
    

	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) 
	{
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintRisItemInfo.xls';
	}else
	{
		alert("无效模板路径");
		return;
	}

	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1") 
    xlsheet.cells(3,1).Value=ItemDesc ;
    if (LocID=="165"){xlsheet.cells(2,1).Value="医务部查体"+"  "+Regno; }
	if (LocID=="579") {xlsheet.cells(2,1).Value="医保查体"+"  "+Regno;} 
	xlsheet.cells(1,1).Value=Name+"  "+SexDesc+"  "+Age ;
    if (LocID=="165") {xlsheet.printout(1,1,1,false,"tiaoma");}
    if (LocID=="579") {xlsheet.printout;}
   //xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
}
*/
function PrintOneRisInfo()
 
{   var Char_2=String.fromCharCode(2);
   DHCP_GetXMLConfig("InvPrintEncrypt","PERisInfoPrint");
    var LocID=session['LOGON.CTLOCID']
	var targetFrame=GetCtlValueById("txtTargetFrame");
	var obj;   

	var OneRisInfo=parent.frames["DHCPEIAdmItemStatusDetail"].GetOneRisInfo();
	var Info=OneRisInfo.split("^");
	var IAdmId=Info[0];
	var ItmMastDR=Info[1];
	var ItmMastDesc=Info[2];
	var status=Info[3]
	var OEItemID=Info[4]
	if (ItmMastDR=="") {alert("请选择一个检查医嘱");return;}
	var Ins=document.getElementById("GetOneRisItemInfo");
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var StationID=cspRunServerMethod(encmeth,ItmMastDR);
	var Info=StationID.split(";")
	var STID=Info[0]
    var LabID=Info[1]
    var str=Info[2]
    if (status=="停止") {alert("该医嘱已停");return;}
	var flag=false;
    //var STIDlastIndex=str.lastIndexOf(STID);
    var StringStr=str.split("^");
    for (var i=0;i<StringStr.length;i++)
    {  
    	var RisID=StringStr[i];
		if (RisID!=STID)continue;
        flag=true;
    }
    if(flag==false){alert("请选择一条检查医嘱");return;}
    if (IAdmId=="") return;
	if (!confirm("确实打印"+ItmMastDesc+"医嘱的标签吗")) return;
	var InString=IAdmId+"^"+""+"^"+""+"^"+""+"^"+OEItemID
	var Ins=document.getElementById("GetRisItemInfo");
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var InfoString=cspRunServerMethod(encmeth,InString,"Y");
	var vals=InfoString.split("%");
    var InfoStr=vals[0]
    var PatInfo=vals[1]
    var TxtInfo=""
	 var ItemStr=InfoStr.split(";");  	
     for (var i=0;i<ItemStr.length;i++)
         
		   {   
		    var ItemDesc=ItemStr[i]
			TxtInfo=PatInfo+"^"+"ItemDesc"+Char_2+ItemDesc; 
			var myobj=document.getElementById("ClsBillPrint");
	        DHCP_PrintFun(myobj,TxtInfo,"");

		     }
		      var myobj=document.getElementById("ClsBillPrint");
		     DHCP_PrintFun(myobj,PatInfo,"");

}
function printBaseInfo(Name,SexDesc)
{   
    var LocID=session['LOGON.CTLOCID']
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) 
	{
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintRisItemInfo.xls';
	}else
	{
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
function PatItemPrintA4() {
	
	DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrintA4");
	var Page="A4"

	var Data=GetSelectId("TAdmId^TDeitFlag^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");

	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){
	
		FData=Datas[iLLoop].split("^");
			
		if (""!=FData) {
				
		var Instring=FData[2]+"^"+FData[3]+"^"+""+"^"+Page;
			
			
			var Ins=document.getElementById('GetOEOrdItemBox');
			
			
			if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
			
			var value=cspRunServerMethod(encmeth,'','',Instring);
			
			Print(value);
		
		     
		}
		
	
	}	
}

function AllBarCodePrint() 
{   
	var Data=GetSelectId("TAdmId^");
	if (""==Data) {
		return ;
	}
	var AsCharged=document.getElementById("PatOrdItemInfo")
	var Datas=Data.split(";");
	var targetFrame=GetCtlValueById("txtTargetFrame");
	var obj;
	var OneSpecNo=parent.frames["DHCPEIAdmItemStatusDetail"].GetOneOrdItem();
	var Info=OneSpecNo.split("^");
	var iOEOriId=Info[1];
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){

		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			var iIAdmId=FData[2]
			
			var InString=iIAdmId+"^"+iOEOriId; //获取信息
			var Ins=document.getElementById("PatOrdItemInfo");
			if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
			var flag=cspRunServerMethod(encmeth,"BarPrint","",InString,"Y","N");
			continue
			BarPrint(flag)
			//AllRisPrint(iIAdmId);
			//打印病人基本信息条码
			//DHCP_GetXMLConfig("InvPrintEncrypt","DHCPEPersonInfo");
			//OnePersonInfoCodePrint(iIAdmId);
		}
	}
}

function AllRisPrint(iIAdmId)
{    
            var Char_2=String.fromCharCode(2);
            DHCP_GetXMLConfig("InvPrintEncrypt","PERisInfoPrint");
            var LocID=session['LOGON.CTLOCID'] 
			var Ins=document.getElementById('GetRisItemInfo');
			if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
			var InfoString=cspRunServerMethod(encmeth,iIAdmId,"Y","N");  //前台打印
	        var vals=InfoString.split("%");
            var InfoStr=vals[0]
            var PatInfo=vals[1]
            var TxtInfo=""
	        var ItemStr=InfoStr.split(";");  
	        /*
	        if (ItemStr=="")
	      {	
	       var myobj=document.getElementById("ClsBillPrint");
	       DHCP_PrintFun(myobj,PatInfo,"");
		   return;}*/
          for (var i=0;i<ItemStr.length;i++)
		   {   
		    var ItemDesc=ItemStr[i]
			TxtInfo=PatInfo+"^"+"ItemDesc"+Char_2+ItemDesc; 
			var myobj=document.getElementById("ClsBillPrint");
	        DHCP_PrintFun(myobj,TxtInfo,"");
             }
             /*
		var myobj=document.getElementById("ClsBillPrint");
	    DHCP_PrintFun(myobj,PatInfo,"");*/
}
function SendXaryInfo()
{
	var Data=GetSelectId("TAdmId^");
	if (""==Data) {
		return ;
	}
	var Datas=Data.split(";");
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){

		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			var info=tkMakeServerCall("web.DHCPE.CRM.RisGateway","ReSendInfo",FData[2],"ARRIVED");
		}
	}
	alert("已经重新发送,请查看");
}

//医嘱执行
function PEOrderExe()
{
	var obj;
	var Data=GetSelectId("TPEIAdmId^TDeitFlag^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");
	var OrdItemID="",Instring="",prnpath="",encmeth=""
	var OneSpecNo=parent.frames["DHCPEIAdmItemStatusDetail"].GetOneOrdItem();
	var Info=OneSpecNo.split("^");
	OrdItemID=Info[1];
	obj=document.getElementById("prnpath");
	prnpath=obj.value;
	var Ins=document.getElementById("GetOrdExcInfoClass");
	if (Ins) encmeth=Ins.value;
	if (encmeth=="") return;
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){
		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			var IADM=FData[2];
			var InfoStr=cspRunServerMethod(encmeth,IADM,OrdItemID);	
		
			 var obj=document.getElementById("btnQuery")
    			if (obj) obj.click();
		}
		
	}
}
//取消医嘱执行
function PECancelOrderExc()
{
	var obj;
	var Data=GetSelectId("TPEIAdmId^TDeitFlag^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");
	var OrdItemID="",Instring="",prnpath="",encmeth=""
	var OneSpecNo=parent.frames["DHCPEIAdmItemStatusDetail"].GetOneOrdItem();
	var Info=OneSpecNo.split("^");
	OrdItemID=Info[1];
	obj=document.getElementById("prnpath");
	prnpath=obj.value;
	var Ins=document.getElementById("CancelOrdExcInfoClass");
	if (Ins) encmeth=Ins.value;
	if (encmeth=="") return;
	if (OrdItemID==""){alert("是否取消全部材料医嘱?")}
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){
		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			var IADM=FData[2];
			var InfoStr=cspRunServerMethod(encmeth,IADM,OrdItemID);
			var obj=document.getElementById("btnQuery")
    			if (obj) obj.click();		
		}
		
	}
}
document.body.onload = BodyLoadHandler;