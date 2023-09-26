////udhcOPRefund.Auditing.js

var GUser;
var AllExecute;
var RebillFlag;
var PartRefFlag;
var PrtXMLName;
var m_Version="";

var m_SelectCardTypeRowID="";

////DHCOPRefund.Auditing.js
////
function BodyLoadHandler()
{
   var obj=document.getElementById("ReceipNO");
   if (obj) obj.onkeydown=ReceipNO_KeyDown;
   obj=document.getElementById("BVerify");
   DHCWeb_DisBtn(obj);
   obj=document.getElementById("RefClear");
   if (obj) obj.onclick=RefundClear_Click;
   obj=document.getElementById("BtnQuery");
   if (obj){
	   obj.onclick=INVQuery_Click;
   }
	var obj=document.getElementById("ReadCardQuery");
   	if (obj){
	   	obj.onclick=ReadCardQuery_OnClick;
   	}

   ReadINVInfo();
   document.onkeydown = DHCWeb_EStopSpaceKey;
   
   IntDoc();
	
	var obj=document.getElementById('CardTypeDefine');
	if (obj) {
	          ReadCardType();
	          obj.setAttribute("isDefualt","true");
	          combo_CardType=dhtmlXComboFromSelect("CardTypeDefine");
	          }
	
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle=combo_CardTypeKeydownHandler;
	}
	
	combo_CardTypeKeydownHandler();
   
}

function IntDoc(){
	m_Version=DHCWebD_GetObjValue("DHCVersion");
	var myPrtXMLName="";
	switch(m_Version){
		case "1":
			PrtXMLName="AHSLOPAudit";
			myPrtXMLName=PrtXMLName;
			break;
		default:
			
			break;
	}
	if (PrtXMLName!=""){
		DHCP_GetXMLConfig("InvPrintEncrypt",myPrtXMLName);		///INVPrtFlag
		
	}

}

function INVQuery_Click(){
	///   DHCOPINV.Query
	QueryInv();
	
}

function QueryInv()	{
	var mygLocDR=session['LOGON.GROUPID'];
	var myULoadLocDR=session['LOGON.CTLOCID'];
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk+="&FramName=udhcOPRefund_Auditing";
	lnk+="&AuditFlag=C&sFlag=PRT&INVStatus=N";
	lnk+="&gLocDR="+mygLocDR+"&ULoadLocDR="+myULoadLocDR;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPINV_Query","scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function ReadCardQueryINV(PAPMNo){
	var mygLocDR=session['LOGON.GROUPID'];
	var myULoadLocDR=session['LOGON.CTLOCID'];
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk+="&FramName=udhcOPRefund_Auditing&PatientNO="+PAPMNo;
	lnk+="&AuditFlag=C&sFlag=PRT&INVStatus=N";
	lnk+="&gLocDR="+mygLocDR+"&ULoadLocDR="+myULoadLocDR;
	var NewWin=open(lnk,"udhcOPINV_Query","scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
	
}

function ReadCardQuery_OnClick(){
	///var myrtn=DHCACC_GetAccInfo();
	var myCardTypeValue=combo_CardType.getSelectedValue();
	var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeRowID,myCardTypeValue);
	///alert(myrtn)
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0":
			///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			///var obj=document.getElementById("PatientID");
			///obj.value=myary[5];
			ReadCardQueryINV(myary[5]);
			///ReadPatInfo();
			break;
		case "-200":
			alert(t["-200"]);
			break;
		case "-201":
			alert(t["-201"]);
			///var obj=document.getElementById("PatientID");
			///obj.value=myary[5];
			///ReadPatInfo();
			break;
		default:
			///alert("");
	}
}


function RefundClear_Click()
{
	//
	IntRefMain();
	AddIDToOrder("");
}

function BVerify_Click()
{
	var mywin=parent.frames["udhcOPRefund_AuditOrder"].window;
	
	var myAuditInfo=mywin.GetAuditInfo();
	var myOEORDStr="";
	var myOEAry=new Array();
	var myAudAry=myAuditInfo.split(String.fromCharCode(2));
	for (var i=0;i<myAudAry.length;i++){
		var myary=myAudAry[i].split("^");
		myOEAry[i]=myary[3];
	}
	myOEORDStr=myOEAry.join("^");
	
	var myAudFlag=DHCWebD_GetObjValue("AuditFlag");
	
	if (((myAudFlag=="4")||(myAudFlag=="3")||(myAudFlag=="2"))&&(myAuditInfo=="")){
		alert(t["SelOETip"]);
		return;
	}
	
	///return;
	var myRefReason=DHCWebD_GetObjValue("RefundReason");
	if (myRefReason==""){
		alert(t["AddReaTip"]);
		return;
	}
	
	var IDobj=document.getElementById("ReceipID");
	var ReceipRowid=IDobj.value;
	GUser=session['LOGON.USERID'];
	
	var verifyobj=document.getElementById("getVerify");
	if (verifyobj) {var encmeth=verifyobj.value} else {var encmeth=''};
	
	var myLocDR=session["LOGON.CTLOCID"];
	
	var myrtn=cspRunServerMethod(encmeth,ReceipRowid,GUser, myAuditInfo, myOEORDStr, myRefReason, myLocDR);
	if (myrtn=="0") {
		DHCWeb_DisBtnA("BVerify");
		////Print Audit OEOrdItem
		var myINVStr="0^"+ReceipRowid;
		BillPrintNew(myINVStr);
		
		alert(t["10"]);
	}      /////
	else{
		alert(t["11"]);
	}		/////
	
}

function ReceipNO_KeyDown(e)
{  
	var key = websys_getKey(e);
	var obj = websys_getSrcElement(e);
	if ((obj)&&(obj.value!="")&&(key==13)) 
	{ 
	   var No=obj.value;
	   var ReceipIDobj=document.getElementById("getReceipID");	
	   if (ReceipIDobj) {var encmeth=ReceipIDobj.value} else {var encmeth=''};
	   	var mytmprtn=cspRunServerMethod(encmeth,'SetReceipID','',No)
	   
	   if (mytmprtn=='-1') 
		{
			alert(t["12"])	/////
			websys_setfocus('ReceipNO');
			return websys_cancel();
		}else if (mytmprtn=='-2'){
			alert(t["15"])	/////
			websys_setfocus('ReceipNO');
			return websys_cancel();
			}
		else
		{//
		   var IDobj=document.getElementById("ReceipID");
		   
		   var rptinfoobj=document.getElementById("getReceiptinfo");
		   if (rptinfoobj) {var encmeth=rptinfoobj.value} else {var encmeth=''};
	      if (cspRunServerMethod(encmeth,'SetReceipInfo','',IDobj.value)=='0') 
		   {
			   //AddIDToOrder(IDobj.value)
			   var ReceipID=IDobj.value;
			   var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.AuditOrder&ReceipRowid="+ReceipID;
			   ////lnk+="&";
			   parent.frames['udhcOPRefund_AuditOrder'].location.href=lnk;
		   }
		}
	}
}

function ReadINVInfo(){
	////read INV Infomation
	var IDobj=document.getElementById("ReceipID");
	var INVRID=IDobj.value;
	if (INVRID==""){
		return;
	}
	var rptinfoobj=document.getElementById("getReceiptinfo");
	if (rptinfoobj) {var encmeth=rptinfoobj.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetReceipInfo','',IDobj.value)=='0') 
	{
		var ReceipID=IDobj.value;
		parent.frames['udhcOPRefund_AuditOrder'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.AuditOrder&ReceipRowid="+ReceipID;
	}
}


function Abort_Click()
{
	RefundSaveInfo("A");
}


function Refund_Click()
{
	RefundSaveInfo("S");
}


function getOrderstr(){
	////zhaocz
	////
	////
	////
	////
	////dsfsdfsdafsdfdsfdsgadsudhcOPRefund_AuditOrder
	var listdoc=parent.frames["udhcOPRefund_AuditOrder"].document;
	
	var StopOrderstr="",ToBillOrderstr=""
	AllExecute=1
	RebillFlag=0		////
	PartRefFlag=0
	
	var objtbl=listdoc.getElementById('tudhcOPRefund_AuditOrder');
	var Rows=objtbl.rows.length;
	
	for (var j=1; j<Rows; j++)
	{
		////DHCWebD_GetCellValue(obj)
		var excobj=listdoc.getElementById('TExcuteflagz'+j);
		var sExcute=DHCWebD_GetCellValue(excobj);    ////	listdoc.getElementById('TExcuteflagz'+j).innerText;
		if (sExcute==0){AllExecute=0}	//
		var TSelect=listdoc.getElementById("Tselectz"+j);
		var selflag=DHCWebD_GetCellValue(TSelect);
		var ordobj=listdoc.getElementById('TOrderRowidz'+j);
		var sOrderRowid=DHCWebD_GetCellValue(ordobj);
		
		var qtyObj=listdoc.getElementById('TOrderQtyz'+j);
		var ordqty=DHCWebD_GetCellValue(qtyObj);		
		
		var refqtyObj=listdoc.getElementById('TReturnQtyz'+j);
		var refordqty=DHCWebD_GetCellValue(refqtyObj);
		if (!isNaN(refordqty)&&(PartRefFlag==0)){
			if (refordqty>0){
				PartRefFlag=1;
			}
		}
		
		//
		if (selflag==false) {RebillFlag=1;}
		///
		if ((selflag==true)&&(sExcute=="1")&&(ordqty!=refordqty)) {RebillFlag=1;}
		
		if (ToBillOrderstr==""){
			ToBillOrderstr=sOrderRowid;
		}
		else{
			ToBillOrderstr=ToBillOrderstr+'^'+sOrderRowid;
		}
		
		if (TSelect.checked==true)
		{
			if (StopOrderstr==""){StopOrderstr=sOrderRowid;}
			else
			{StopOrderstr=StopOrderstr+'^'+sOrderRowid;}
		}
	}
	
	////(StopOrderstr+"!"+ToBillOrderstr)
	return (StopOrderstr)
}


function RefundSaveInfo(RefundFlag){
	////
	var rtn=CheckRefund();
	if (rtn==false){
		return ;
	}
	
	var StopOrdStr=getOrderstr();
	
	var recobj=document.getElementById("ReceipID");
	if (recobj){
		var ReceipRowid=recobj.value;
	}
	var myUser=session['LOGON.USERID'];
	var gloc=session['LOGON.GROUPID'];
	var invodj=document.getElementById("Sum");
	var refundobj=document.getElementById("RefundSum");
	var patPay=0
	if ((invodj)&&(refundobj)){
		var invsum=invodj.value;
		if (isNaN(invsum)){invsum=0;}
		var refundsum=refundobj.value;
		if (isNaN(refundsum)){refundsum=0;}
		patPay=invsum-refundsum;
		patPay=patPay.toFixed(2);
	}
		
	////INVPRTRowid,rUser,sFlag,StopOrdStr,NInvPay,gloc
	var refundobj=document.getElementById("getRefundRcpt");
	if (refundobj) {var encmeth=refundobj.value} else {var encmeth=''};
	
	/////alert("DDDD"+ReceipRowid+":::"+myUser+":::"+RefundFlag+":::"+StopOrdStr+":::"+patPay+":::"+gloc+"::::"+RebillFlag);
	/////return;
	
	var rtnvalue=cspRunServerMethod(encmeth,ReceipRowid,myUser,RefundFlag,StopOrdStr,patPay,gloc,RebillFlag);
	var rtn=rtnvalue.split("^");
	////alert(rtnvalue);
	if (rtn[0]=='0') 
	{
		//
		BillPrintNew(rtnvalue);
		alert(t["13"]);   ////
		return true;
	}else{
		alert(t["14"]);		////
		return false;	
	}
}

function BillPrintNew(INVstr){
	if (PrtXMLName==""){
		return;
	}
	///alert(INVstr);
	///var myary=INVstr.split(String.fromCharCode(2));
	var INVtmp=INVstr.split("^");
	for (var invi=1;invi<INVtmp.length;invi++)
	{
		if (INVtmp[invi]!=""){
			////alert(INVtmp[invi]);
			var beforeprint=document.getElementById('getSendtoPrintinfo');
			if (beforeprint) {var encmeth=beforeprint.value} else {var encmeth=''};
			
			var payobj=document.getElementById("PayMode");
			if (payobj){
				var PayMode=payobj.value;
			}
			var PayMode="";   ////
			var Guser=session['LOGON.USERID'];
			var sUserCode=session["LOGON.USERCODE"];
			//GetInvoicePrtDetail(JSFunName As %String,InvRowID, UseID , PayMode
			//JSFunName, PrtXMLName, InvRowID, UseID, PayMode, ExpStr
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew", PrtXMLName, INVtmp[invi],sUserCode,PayMode, "");
		}
	}
}


function InvPrintNew(TxtInfo,ListInfo)
{
	////
	////DHCP_PrintFun(encmeth,PObj,inpara,inlist)
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
}


function CheckRefund(){
	var mySOrder=getOrderstr();
	///if (PartRefFlag==1){
		////return true;
	////}
	if (mySOrder==""){
		alert(t['03']);		/////
		return false;
	}
	return true;
}

function SetReceipID(value)
{
	var IDobj=document.getElementById("ReceipID");
	IDobj.value=value
}

function SetReceipInfo(value)
{
	///PapmiNo_"^"_PapmiName_"^"_PaSex_"^"_PRTPatPay_"^"_flag_"^"_Refundflag_"^"_PRTUsr_"^"_DHCINVPRTRDR_"^"_Verifyflag
	///"^"_myINVPayMDR_"^"_myColPFlag_"^"_myConAppFlag
	
	var Split_Value=value.split("^");
	var Sumobj=document.getElementById("Sum");
	var sexobj=document.getElementById("PatientSex");
	var nameobj=document.getElementById("PatientName");
	var noobj=document.getElementById("PatientID");
	var veryobj=document.getElementById("BVerify");
	var myAudObj=document.getElementById("AuditFlag");
	
	GUser=session['LOGON.USERID'];
	noobj.value=Split_Value[0];
	nameobj.value=Split_Value[1];
	sexobj.value=Split_Value[2];
	Sumobj.value=Split_Value[3];
	myAudObj.value=Split_Value[11];
	
	
	//alert(Split_Value[8]);
	//if be Audited  not to Audit
	if (Split_Value[18]!=""&&Split_Value[18]!="N")
	{
		DHCWeb_DisBtn(veryobj);
		alert(t["-201"]);    ///
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}
	
	if ((Split_Value[8]=="Y")&&(Split_Value[12]!="M"))
	{
		DHCWeb_DisBtn(veryobj);
		alert(t["04"]);		////
		websys_setfocus('ReceipNO');
		return websys_cancel();
		
	}else{
   		if (veryobj) {
	   		veryobj.disabled=false;
	   		veryobj.onclick=BVerify_Click;
   		}
	}
	
	if (Split_Value[4]=="A")
	{
		DHCWeb_DisBtn(veryobj);
		alert(t["05"]);    ///
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}
	if (Split_Value[5]=="1")
	{
		DHCWeb_DisBtn(veryobj);
		alert(t["06"]);     ////
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}
}

function AddIDToOrder(ReceipID) {
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.AuditOrder&ReceipRowid="+ReceipID;
	var AdmCharge=parent.frames['udhcOPRefund_AuditOrder'];
	AdmCharge.location.href=lnk;
}

function IntRefMain()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund_Auditing";
	var AdmCharge=parent.frames['udhcOPRefund_Auditing'];
	AdmCharge.location.href=lnk;
	
}

function Abort_ClickOld()
{ 
   
   var Orderstr=getOrderstr();
   if (AllExecute==1)
   {
	   alert(t["07"]);     ////
   		return;
   }
	var IDobj=document.getElementById("ReceipID");
	var ReceipRowid=IDobj.value;
	GUser=session['LOGON.USERID'];
	
	
	var abortobj=document.getElementById("getCancelRcpt");
	if (abortobj) {var encmeth=abortobj.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,ReceipRowid,GUser)=='-1') 
		{alert(t['01']);
		 return}
	else
	{
		var chaorderobj=document.getElementById("getUpdateOrder");
	   if (chaorderobj) {var encmeth=chaorderobj.value} else {var encmeth=''};
	   if (cspRunServerMethod(encmeth,Orderstr,GUser)=='0') 
		{alert(t["08"]);}     /////
	}
}


function Refund_ClickOld()
{
	/////RefundSaveInfo
	var Orderstr=getOrderstr();
   	alert("Refund_ClickOld");
	var IDobj=document.getElementById("ReceipID");
	var ReceipRowid=IDobj.value;
	var GUser=session['LOGON.USERID'];
	var refundobj=document.getElementById("getRefundRcpt");
	if (refundobj) {var encmeth=refundobj.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'','',ReceipRowid,GUser)=='-1') 
		{alert(t['02']);
		 return}
   	else
   	{
	   var chaorderobj=document.getElementById("getUpdateOrder");
	   if (chaorderobj) {var encmeth=chaorderobj.value} else {var encmeth=''};
	   if (cspRunServerMethod(encmeth,Orderstr,GUser)=='0') 
	   {alert(t["09"]);}    /////
	}
}

///// ******************************************************************
function ReadCardType(){
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
}

function combo_CardTypeKeydownHandler(){
	//var myoptval=combo_CardType.getActualValue();
	var myoptval=combo_CardType.getSelectedValue();
	
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	m_SelectCardTypeRowID=myCardTypeDR
	
	if (myCardTypeDR=="")	{	return;	}
	m_CCMRowID=myary[14];
	///Read Card Mode
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj){myobj.readOnly = false;}
		DHCWeb_DisBtnA("ReadCard");
	}	else{
		//m_CCMRowID=GetCardEqRowId();
		
		var myobj=document.getElementById("CardNo");
		if (myobj){myobj.readOnly = true;}
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=ReadHFMagCard_Click;
		}
	}
	
}

///// ************************************************************



document.body.onload = BodyLoadHandler;