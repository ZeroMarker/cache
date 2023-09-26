////udhcOPRefund.Request.js

var GUser,groupid;
var AllExecute;
var RebillFlag; 
var PartRefFlag;
var PrtXMLName;
var m_Version="";
var ReceipNO;

////DHCOPRefund.Request.js
////
function BodyLoadHandler()
{
   ///var obj=document.getElementById("ReceipNO");
   ///if (obj) obj.onkeydown=ReceipNO_KeyDown;
   groupid=session['LOGON.GROUPID'];
    var obj=document.getElementById("PatientID");
   if (obj) obj.onkeydown=PatientID_KeyDown;

   obj=document.getElementById("BVerify");
   DHCWeb_DisBtn(obj);
   obj=document.getElementById("RefClear");
   if (obj) obj.onclick=RefundClear_Click;
   
   obj=document.getElementById("EpisodeID");
   if (obj){
   	 	if (obj.value!=""){
   		Method=document.getElementById("GetRegister").value;
   		ret=cspRunServerMethod(Method,obj.value)
   		document.getElementById("PatientID").value=ret;
   		}
   	}
   obj=document.getElementById("BtnQuery");
   if (obj){
	   obj.onclick=INVQuery_Click;
   }
	var obj=document.getElementById("ReadCardQuery");
   	if (obj){
	   	obj.onclick=ReadCardQuery_OnClick;
   	}
   ReceipNO=dhtmlXComboFromStr("ReceipNO","");
   ReceipNO.enableFilteringMode(true);
   ReceipNO.selectHandle=ReceipNO_KeyDown;
   ReadINVInfo();
   document.onkeydown = DHCWeb_EStopSpaceKey;
   
   IntDoc();
   GUser=session['LOGON.USERID'];
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

function PatientID_KeyDown(){
 var obj=document.getElementById("PatientID"); 
 var key=websys_getKey(e);
 if (key==13) {	
 	var nameobj=document.getElementById("PatientName");
 	if (nameobj) nameobj.value="";
 	var Sumobj=document.getElementById("Sum");
 	if (Sumobj) Sumobj.value="";
 	var RefundSumobj=document.getElementById("RefundSum");
 	if (RefundSumobj) RefundSumobj.value="0";
 	
	var sexobj=document.getElementById("PatientSex");
	if (sexobj) sexobj.value="";
	ReceipNO.DOMelem_input.value="";
	ReceipNO.clearAll();
	/*
	var plen=obj.value.length
    var i
    var lszero=""
    if (plen==0){return ;}
 	if (plen>8){alert(t["PatNoLengthErr"]);return;}
	 for (i=1;i<=8-plen;i++)
  	  {
	 	 lszero=lszero+"0"  
      }
    
	 var lspmino=lszero+obj.value;
	 obj.value=lspmino 
	*/
	var lspmino=obj.value;
	var getinvobj=document.getElementById("GetInvPrt");
	if (getinvobj) {var encmeth=getinvobj.value} else {var encmeth=''};

	var myrtn=cspRunServerMethod(encmeth,lspmino);
	
	if (myrtn!="")
	{
		var tmparr=myrtn.split("!");
		
		if (nameobj) nameobj.value=tmparr[1];
		
		var Arr=DHCC_StrToArray(tmparr[0]);
		
		ReceipNO.addOption(Arr);
  } 
	}
}

function QueryInv()	{
	var mygLocDR=session['LOGON.GROUPID'];
	var myULoadLocDR=session['LOGON.CTLOCID'];
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk+="&FramName=udhcOPRefund_Request";
	lnk+="&AuditFlag=ALL&sFlag=PRT&INVStatus=N";
	lnk+="&gLocDR="+mygLocDR+"&ULoadLocDR="+myULoadLocDR;
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPINV_Query","scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function ReadCardQueryINV(PAPMNo){
	var mygLocDR=session['LOGON.GROUPID'];
	var myULoadLocDR=session['LOGON.CTLOCID'];
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk+="&FramName=udhcOPRefund_Request&PatientNO="+PAPMNo;
	lnk+="&AuditFlag=ALL&sFlag=PRT&INVStatus=N";
	lnk+="&gLocDR="+mygLocDR+"&ULoadLocDR="+myULoadLocDR;
	var NewWin=open(lnk,"udhcOPINV_Query","scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
	
}

function ReadCardQuery_OnClick(){
	var myrtn=DHCACC_GetAccInfo();
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
			ReadCardQueryINV(myary[5]);
			///alert(t["-201"]);
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
	var mywin=parent.frames["udhcOPRefund_RequestOrder"].window;
	
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
	
	if ((myAudFlag=="2")&&(myAuditInfo=="")){
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
	
	
	var verifyobj=document.getElementById("getVerify");
	if (verifyobj) {var encmeth=verifyobj.value} else {var encmeth=''};
	
	var myLocDR=session["LOGON.CTLOCID"];
	
	var myrtn=cspRunServerMethod(encmeth,ReceipRowid,GUser, myAuditInfo, myOEORDStr, myRefReason, myLocDR);
	if (myrtn=="0") {
		DHCWeb_DisBtnA("BVerify");
		////Print Audit OEOrdItem
		//var myINVStr="0^"+ReceipRowid;
		//BillPrintNew(myINVStr);
		
		alert(t["10"]);
		RefundClear_Click();
	}      /////
	else{
		alert(t["11"]);
	}		/////
	
}

function ReceipNO_KeyDown()
{  
	   var No=ReceipNO.getSelectedText();
	   var ReceipIDobj=document.getElementById("getReceipID");	
	   if (ReceipIDobj) {var encmeth=ReceipIDobj.value} else {var encmeth=''};
	   if (cspRunServerMethod(encmeth,'SetReceipID','',No)=='-1') 
		{
			alert(t["12"])	/////
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
			   
			   var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.RequestOrder&ReceipRowid="+ReceipID+"&GUser="+GUser+"&groupid="+groupid;  //
			   ////lnk+="&";
			   parent.frames['udhcOPRefund_RequestOrder'].location.href=lnk;
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
		GUser=session['LOGON.USERID'];
		parent.frames['udhcOPRefund_RequestOrder'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.RequestOrder&ReceipRowid="+ReceipID+"&GUser="+GUser+"&groupid="+groupid;  //
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
	////dsfsdfsdafsdfdsfdsgadsudhcOPRefund_RequestOrder
	var listdoc=parent.frames["udhcOPRefund_RequestOrder"].document;
	
	var StopOrderstr="",ToBillOrderstr=""
	AllExecute=1
	RebillFlag=0		////
	PartRefFlag=0
	
	var objtbl=listdoc.getElementById('tudhcOPRefund_RequestOrder');
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
	///alert(value)
	var Split_Value=value.split("^");
	var Sumobj=document.getElementById("Sum");
	var sexobj=document.getElementById("PatientSex");
	var nameobj=document.getElementById("PatientName");
	var noobj=document.getElementById("PatientID");
	var veryobj=document.getElementById("BVerify");
	var myAudObj=document.getElementById("AuditFlag");
	
	
	noobj.value=Split_Value[0];
	nameobj.value=Split_Value[1];
	sexobj.value=Split_Value[2];
	Sumobj.value=Split_Value[3];
	myAudObj.value=Split_Value[11];
	if (veryobj) {
	   		veryobj.disabled=false;
	   		veryobj.onclick=BVerify_Click;
   		}
	//alert(Split_Value[8]);
	//if be Audited  not to Audit
	/*
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
	*/
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
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.RequestOrder&ReceipRowid="+ReceipID+"&GUser="+GUser+"&groupid="+groupid;  //
	var AdmCharge=parent.frames['udhcOPRefund_RequestOrder'];
	AdmCharge.location.href=lnk;
}

function IntRefMain()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund_Request";
	var AdmCharge=parent.frames['udhcOPRefund_Request'];
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



document.body.onload = BodyLoadHandler;