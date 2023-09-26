////udhcOPInv.SingleQuery.js


var GUser
var AllExecute
var RebillFlag
var PartRefFlag
var ExeFlag				///

var PrtXMLName="";

var m_YBConFlag="0";     ////default not Connection YB

var m_AbortPop=0;

var MyPrtAry=new Array();
var MyAryIdx=0

////DHCOPRefund.Auditing.js
////
function BodyLoadHandler()
{
   var obj=document.getElementById("ReceipNO");
   if (obj) obj.onkeydown=ReceipNO_KeyDown;
   obj=document.getElementById("PrintDetails");
   if (obj){
	   obj.onclick=PrintDetails_Click;
   }
   obj=document.getElementById("RefClear");
   if (obj) obj.onclick=RefundClear_Click;
   obj=document.getElementById("BtnQuery");
   if (obj){
	   obj.onclick=INVQuery_Click;
   }
	
	var obj=document.getElementById("bReadCardQuery");
	if (obj){
		obj.onclick=ReadCardQuery_OnClick;
	}
	
	var obj=document.getElementById("BINVPrint");
	if (obj){
		obj.onclick=BINVPrint_OnClick;
	}
	var myDHCVersion=DHCWebD_GetObjValue("DHCVersion");
	switch(myDHCVersion){
		case "0":
			DHCP_GetXMLConfig("InvPrintEncrypt","PrtINVList");		///INVPrtFlag
			PrtXMLName="PrtINVList"
	   default:
	   		IntPRTDoc();
   }
	
	var encmeth=DHCWebD_GetObjValue("ReadOPBaseEncrypt");
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth);
		var myary=myrtn.split("^");
		m_YBConFlag=myary[12];
		
		DHCWebD_SetObjValueA("RoundNum", myary[13]);
	}
	
	if (m_YBConFlag=="1"){
	    DHCWebOPYB_InitForm();
	}
   
  obj=document.getElementById("BPrint");
   if (obj)
   {
	   obj.onclick=BPrint_Click;
   }
   
   DHCWeb_DisBtnA("bINVParkPrint");
   
   document.onkeydown = document_OnKeyDown;
	
	var obj=document.getElementById("RefundPayMode");
   	if (obj){
	   obj.size=1;
	   obj.multiple=false;
	}
	
	DHCWebD_ClearAllListA("RefundPayMode");
	var encmeth=DHCWebD_GetObjValue("PayModeEncrypt");
	var mygLoc=session['LOGON.GROUPID'];
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","RefundPayMode");
	}
   
   ReadINVInfo();
   
}

function document_OnKeyDown()
{
	var e=window.event;
	///alert(e.keyCode);
	parent.window.FrameShutCutKeyFrame(e);
	DHCWeb_EStopSpaceKey();
	
}


function IntPRTDoc()
{
	///Load Base Config
	var mygLoc=session['LOGON.GROUPID'];
	var encmeth=DHCWebD_GetObjValue("GSCFEncrypt");
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth,mygLoc);
	}
	var myary=myrtn.split("^");
	if (myary[0]==0){
		///_"^"_GSRowID_"^"_FootFlag_"^"_RecLocFlag_"^"_PrtINVFlag
		///foot Flag
		m_AbortPop=myary[7];
		m_RefundPop=myary[8];
		////alert(m_AbortPop+"^"+m_RefundPop);
		////Get PrtXMLName
		var myPrtXMLName=myary[10];
	}
	
	PrtXMLName=myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt",myPrtXMLName);		///INVPrtFlag
    ////Ãÿ ‚
	
}

function BINVPrint_OnClick(){
	////
	
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
			alert(t["-201"]);
			///var obj=document.getElementById("PatientID");
			///obj.value=myary[5];
			///ReadPatInfo();
			break;
		default:
			///alert("");
	}
}

function ReadCardQueryINV(PAPMNo){
	var mygLocDR=session['LOGON.GROUPID'];
	var myULoadLocDR=session['LOGON.CTLOCID'];
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk+="&FramName=udhcOPInv.SingleQuery&PatientNO="+PAPMNo;
	lnk+="&AuditFlag=&sFlag=PRT&INVStatus=N";
	lnk+="&gLocDR="+mygLocDR+"&ULoadLocDR="+myULoadLocDR;
	var NewWin=open(lnk,"udhcOPINV_Query","scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
	
}


function INVQuery_Click(){
	///   DHCOPINV.Query
	///QueryInv();
	ReadCardQueryINV("");
}

function QueryInv()	{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk+="&FramName=udhcOPInv.SingleQuery";
	////alert(lnk);
	var NewWin=open(lnk,"udhcOPINV_Query","scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}


function RefundClear_Click()
{
	//
	IntRefMain();
	AddIDToOrder("");
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
			   //
			   var ReceipID=IDobj.value;
			   ///parent.frames['udhcOPRefund_Order'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.Order&ReceipRowid="+ReceipID;
			   parent.frames['udhcOPRefund_Order'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPInv.SingleOrder&ReceipRowid="+ReceipID;
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
		parent.frames['udhcOPRefund_Order'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPInv.SingleOrder&ReceipRowid="+ReceipID;
	}
}

function PrintDetails_Click(){
	var myReceiptID=DHCWebD_GetObjValue("ReceipID");
	if (myReceiptID==""){
		return;
	}
	
	mystr="0^"+myReceiptID;
	///alert(mystr);
	BillPrintNew(mystr);
}

function BillPrintNew(INVstr){
	if (PrtXMLName==""){
		return;
	}
	var INVtmp=INVstr.split("^");
	for (var invi=1;invi<INVtmp.length;invi++)
	{
		if (INVtmp[invi]!=""){
			var beforeprint=document.getElementById('getSendtoPrintinfo');
			if (beforeprint) {var encmeth=beforeprint.value} else {var encmeth=''};
			
			var payobj=document.getElementById("PayMode");
			if (payobj){
				var PayMode=payobj.value;
			}
			var PayMode=""
			var Guser=session['LOGON.USERID'];
			//GetInvoicePrtDetail(JSFunName As %String,InvRowID, UseID , PayMode
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew",PrtXMLName, INVtmp[invi],Guser,PayMode,"");
		}
	}
}


function InvPrintNew(TxtInfo,ListInfo)
{
	////
	////DHCP_PrintFun(encmeth,PObj,inpara,inlist)
	/////alert(TxtInfo+":::::"+ListInfo);
	var beforeprint=document.getElementById('TestPrint');
	if (beforeprint) {var encmeth=beforeprint.value} else {var encmeth=''};
	var myobj=document.getElementById("ClsBillPrint");
	TxtInfo+="^RePrint"+String.fromCharCode(2) +"(÷ÿ¥Ú)";
	////alert(TxtInfo);
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
}

function SetReceipID(value)
{
	var IDobj=document.getElementById("ReceipID");
	IDobj.value=value
}

function SetReceipInfo(value)
{
	var Split_Value=value.split("^");
	var Sumobj=document.getElementById("Sum");
	var sexobj=document.getElementById("PatientSex");
	var nameobj=document.getElementById("PatientName");
	var noobj=document.getElementById("PatientID");
	//var cobj=document.getElementById("Abort");
	//var robj=document.getElementById("Refund");
	ExeFlag=0;
	GUser=session['LOGON.USERID'];
	noobj.value=Split_Value[0];
	nameobj.value=Split_Value[1];
	sexobj.value=Split_Value[2];
	Sumobj.value=Split_Value[3];
	var obj=document.getElementById("INSDivDR");
	if (obj){
		////YB INSRowID
		obj.value=Split_Value[13];
	}
	
	var obj=document.getElementById("CurrentInsType");
	if (obj){
		obj.value=Split_Value[17];
	}
	
	//alert(Split_Value[8]);
	if (Split_Value[8]=="Y")
	{
		///alert(t["04"]);		////
		///websys_setfocus('ReceipNO');
		///return websys_cancel();
		
	}else{
	}
   	
   	DHCWeb_DisBtnA("bINVParkPrint");
	
	if (Split_Value[9]!=""){
		var obj=document.getElementById("RefundPayMode");
		var myLen=obj.options.length;
		for (var i=0;i<myLen;i++){
			var mystr=obj.options[i].value;
			var myary=mystr.split("^");
			if (myary[0]==Split_Value[9]){
				obj.selectedIndex=i;
				break;
			}
		}
	}
	
	
	if ((Split_Value[4]=="A")||(Split_Value[4]=="S"))
	{
		//DHCWeb_DisBtn(veryobj);
		alert(t["11"]);
		////alert(t["05"]);    ///
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}
	if (Split_Value[5]=="1")
	{
		///DHCWeb_DisBtn(veryobj);
		alert(t["06"]);     ////
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}
	
	if (((Split_Value[8]!="Y")&&!((Split_Value[6]==GUser)&&(Split_Value[7]=="")))||(Split_Value[14]=="Y"))
	{
		alert(t['10']);     ////
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}
	///alert(value);
	
	if ((Split_Value[6]==GUser)&&(Split_Value[7]==""))
	{
		if (m_AbortPop=="1"){
			var myobj=document.getElementById("bINVParkPrint");
			if (myobj){
				myobj.disabled=false;
				myobj.onclick=Abort_Click;
			}
		}else{
			alert(t["NoAbortPop"]);
		}
	}
	
}

function INVParkPrint()
{
   	var aobj=document.getElementById("bINVParkPrint");
	if ((aobj)&&(aobj.disabled==false)){
   		//DHCWeb_DisBtn(aobj);
		Abort_Click();
	}
	
}

function Abort_Click()
{
   	var aobj=document.getElementById("bINVParkPrint");
   	if (aobj){
   		DHCWeb_DisBtn(aobj);
   	}
   	
	var rtn=RefundSaveInfo("A");
   	
   	var aobj=document.getElementById("bINVParkPrint");
	if ((rtn==false)&&(aobj)){
   		//DHCWeb_DisBtn(aobj);
		aobj.disabled=false;
		aobj.onclick=Abort_Click;
	}
}


function RefundSaveInfo(RefundFlag){
	////
	var rtn=CheckRefund(RefundFlag);
	if (rtn==false){
		return rtn;
	}
	
	RebillFlag=1;
	
	////Connection YB for Park Fair
	var myINSDivDR=DHCWebD_GetObjValue("INSDivDR");
	if (myINSDivDR!=""){
		////YB  INV  
		if (m_YBConFlag=="0"){
			alert(t["YBINVTip"]);
			return;
		}else{
			////YB  Park Interface
			var myYBHand="";
			var myCPPFlag="";
			var myINSDivDR=myINSDivDR;
			var myExpStr=RebillFlag+"^";
			var rtn=DHCWebOPYB_ParkINVFYB(myYBHand, myCPPFlag, myINSDivDR, myExpStr)
			if (rtn!="0"){
				alert(t["YBParkErrTip"]);
				return;
			}
		}
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
	///if ((invodj)&&(refundobj)){
		var invsum=DHCWebD_GetObjValue("Sum");
		if (isNaN(invsum)){invsum=0;}
		
		var refundsum=DHCWebD_GetObjValue("RefundSum");
		if (isNaN(refundsum)){refundsum=0;}
		patPay=invsum-refundsum;
		patPay=patPay.toFixed(2);
	///}
	
	////INVPRTRowid,rUser,sFlag,StopOrdStr,NInvPay,gloc
	var refundobj=document.getElementById("getRefundRcpt");
	if (refundobj) {var encmeth=refundobj.value} else {var encmeth=''};
	var myUserLocID=session['LOGON.CTLOCID'];
	var mystr=DHCWeb_GetListBoxValue("RefundPayMode");
	var myary=mystr.split("^");
	var myPayModeDR=myary[0];
	/////alert("DDDD"+ReceipRowid+":::"+myUser+":::"+RefundFlag+":::"+StopOrdStr+":::"+patPay+":::"+gloc+"::::"+RebillFlag);
	/////return;
	
	var rtnvalue=cspRunServerMethod(encmeth,ReceipRowid,myUser,RefundFlag,StopOrdStr,patPay,gloc,RebillFlag, myUserLocID, myPayModeDR);
	var myary=rtnvalue.split(String.fromCharCode(2))
	var rtn=myary[0].split("^");
	if (rtn[0]=='0')
	{
		////Add YB InterFace   &&(myPRTRowID!="")
		var myPRTRowID="";
		if (rtn.length>1){
			myPRTRowID=rtn[1];
		}
		
		var myINSDivDR=DHCWebD_GetObjValue("INSDivDR");
		if (((m_YBConFlag=="1")&&(myINSDivDR!=""))){
			var myYBHand="";
			var myCPPFlag="";
			var myExpStr=RebillFlag+"^";
			DHCWebOPYB_ParkINVFYBConfirm(myYBHand, myCPPFlag, myINSDivDR, myExpStr);
		}
		
		var myINSDivDR=DHCWebD_GetObjValue("INSDivDR");
		if ((m_YBConFlag=="1")&&(myINSDivDR!="")&&(myPRTRowID!="")){
			var myYBHand="";
			var myCPPFlag="";
			var myExpStr="S^"+session['LOGON.GROUPID']+"^";
			DHCWebOPYB_DataUpdate(myYBHand, myCPPFlag, myPRTRowID, myExpStr);
		}
		///
		var myRCalFlag=1;
		if (((m_YBConFlag=="1")&&(myINSDivDR!=""))||(myRCalFlag==1)){
			var myEncrypt=DHCWebD_GetObjValue("ReadRefSumEncrypt");
			if (myEncrypt!=""){
				var myExpstr="";
				var myRefSum=cspRunServerMethod(myEncrypt,ReceipRowid, myExpstr);
				var obj=document.getElementById("FactRefSum");
				if (obj){
					obj.value=myRefSum;
				}
			}
		}
		
		if (((m_YBConFlag=="1")&&(myINSDivDR!=""))||(myRCalFlag==1)){
			var myExpStr=RebillFlag+"^";
			////DHCWebOPYB_ParkINVFYBConfirm(myYBHand, myCPPFlag, myINSDivDR, myExpStr);
		}
		
		//
		///if (myary[1]=="0"){
		///BillPrintNew(myary[0]);
		BillPrintTaskListNew(myary[0]);
		///}
		alert(t['07']);		/////
		return true;
	}else{
		switch(rtn[0]){
			case 101:
				alert(t['08']);   ////
			default:
				alert(t['09']+rtn[0]);	  /////
		}
		return false;	
	}
}

function BillPrintTaskListNew(INVstr){
	var myOldXmlName=PrtXMLName;
	
	var myTaskList=DHCWebD_GetObjValue("ReadPrtList");
	var myary=myTaskList.split(String.fromCharCode(1));
	
	if (myary[0]=="Y"){
		BillPrintTaskList(myary[1], INVstr)
		PrtXMLName = myOldXmlName;
		DHCP_GetXMLConfig("InvPrintEncrypt",PrtXMLName);		///INVPrtFlag
	}else{
		BillPrintNew(INVstr);
	}
	
	PrtXMLName = myOldXmlName;
}

function BillPrintTaskList(PrtTaskStr, INVstr){
	var myTListAry=PrtTaskStr.split(String.fromCharCode(2));
	for (var i=0;i<myTListAry.length;i++){
		if (myTListAry[i]!=""){
			var myStrAry=myTListAry[i].split("^");
			////myXmlName_"^"_myClassName_"^"_myMethodName
			var myPrtXMLName=myStrAry[0];
			PrtXMLName=myPrtXMLName;
			var myClassName=myStrAry[1];
			var myMethodName=myStrAry[2];
			if ((myStrAry[3]=="")||(myStrAry[3]=="XML")){
				if (myPrtXMLName!=""){
					DHCP_GetXMLConfig("InvPrintEncrypt",myPrtXMLName);		///INVPrtFlag
					CommBillPrintNew(INVstr, myClassName, myMethodName);
				}
			}
		}
	}
}

function CommBillPrintNew(INVstr,ClassName, MethodName){
	
	var INVtmp=INVstr.split("^");
	///
	///INVstr
	///for (var invi=1;invi<INVtmp.length;invi++)
	///{
		///if (INVtmp[invi]!=""){
			var beforeprint=document.getElementById('ReadCommOPDataEncrypt');
			if (beforeprint) {var encmeth=beforeprint.value} else {var encmeth=''};
			
			var PayMode=DHCWebD_GetObjValue("PayMode");
			var Guser=session['LOGON.USERID'];
			var sUserCode=session['LOGON.USERCODE'];
			var myExpStr="";
			var myPreDep=DHCWebD_GetObjValue("Actualmoney");
			var myCharge=DHCWebD_GetObjValue("Change");
			var myCurGroupDR=session['LOGON.GROUPID'];
			
			var myExpStr=myPreDep+"^"+myCharge+"^"+myCurGroupDR;
			//GetInvoicePrtDetail(JSFunName As %String,InvRowID, UseID , PayMode
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew",ClassName, MethodName, PrtXMLName,INVstr, sUserCode, PayMode, myExpStr);
		///}
	///}
}

function CommBillPrintNewSigle(INVstr,ClassName, MethodName){
	
	var INVtmp=INVstr.split("^");
	///
	///INVstr
	for (var invi=1;invi<INVtmp.length;invi++)
	{
		if (INVtmp[invi]!=""){
			var beforeprint=document.getElementById('ReadCommOPDataEncrypt');
			if (beforeprint) {var encmeth=beforeprint.value} else {var encmeth=''};
			
			var PayMode=DHCWebD_GetObjValue("PayMode");
			var Guser=session['LOGON.USERID'];
			var sUserCode=session['LOGON.USERCODE'];
			var myExpStr="";
			var myPreDep=DHCWebD_GetObjValue("Actualmoney");
			var myCharge=DHCWebD_GetObjValue("Change");
			var myCurGroupDR=session['LOGON.GROUPID'];
			
			var myExpStr=myPreDep+"^"+myCharge+"^"+myCurGroupDR;
			//GetInvoicePrtDetail(JSFunName As %String,InvRowID, UseID , PayMode
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew",ClassName, MethodName, PrtXMLName,INVtmp[invi], sUserCode, PayMode, myExpStr);
		}
	}
}


function CheckRefund(RefundFlag){
	var mySOrder=getOrderstr();
	
	var myrtn=window.confirm(t["BackConfirmINVTip"]);
	if (!myrtn){
		return myrtn;
	}
	
	if (mySOrder==""){
		////sdafdsfds
		///
		///
		///(RefundFlag=="A")&&   
		if ((ExeFlag==0)&&(RefundFlag=="A")){
			return true;
		}
		alert(t['03']);		/////
		return false;
	}
	
	var myReceipNO=DHCWebD_GetObjValue("ReceipNO");
	if (myReceipNO!=""){
		///alert(t["BackINVTip"]);
	}
	
	return true;
}

function getOrderstr(){
	return "";
}

function AddIDToOrder(ReceipID) {
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPInv.SingleOrder&ReceipRowid="+ReceipID;
	var AdmCharge=parent.frames['udhcOPRefund_Order'];
	AdmCharge.location.href=lnk;
}

function IntRefMain()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPInv.SingleQuery";
	var AdmCharge=parent.frames['udhcOPInv.SingleQuery'];
	AdmCharge.location.href=lnk;
	
}

//////Add By YYB

function BPrint_Click()
{ 
	for (var idx=0;idx<=MyAryIdx;idx=idx+1)
	{
		MyPrtAry[idx]="";
	}
	
	MyAryIdx=0;

	PrintClickGetVal();
	
	PrintClickHandlerINVRep();
	
}

function PrintClickGetVal()
{
	var myPrtId=DHCWebD_GetObjValue("ReceipID");
	if (myPrtId=="")
	{
		return;
	}

	var beforeprint=document.getElementById('GetPrtFeeDetail');
	if (beforeprint) {var encmeth=beforeprint.value} else {var encmeth=''};
	
	var Printinfo=cspRunServerMethod(encmeth,"WrtExcle",myPrtId);
}

function WrtExcle(val)
{
	var ary=val.split("^")
		
	 MyPrtAry[MyAryIdx]=val;
	 MyAryIdx=MyAryIdx+1
}

function PrintClickHandlerINVRep()
{ 	
	try {
		var GetPrescPath=document.getElementById("GetRepPath"); 
		if (GetPrescPath) {var encmeth=GetPrescPath.value ;} else {var encmeth=''};
		if (encmeth!="") 
		{
			var TemplatePath=cspRunServerMethod(encmeth);
			
		}
	       
        var myencmeth="";
        
        var xlApp,xlsheet,xlBook;
       
	    var Template=TemplatePath+"DHCOPInvFRep_NBInvPrt.xls";
		
	    var obj=document.getElementById("PatientName"); 
	    if (obj) {var pname=obj.value;} 
	    var obj=document.getElementById("PatientID"); 
	    if (obj) {var patno=obj.value;} 

	    var obj=document.getElementById("ReceipNO"); 
	    if (obj) {var prtno=obj.value;} 
		
		var obj=document.getElementById("CurDate");
		if (obj)
		{
			var PDate=obj.value;
		
		}
		
	    xlApp = new ActiveXObject("Excel.Application");
	    
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    

	    xlsheet.cells(2,3)=pname.toString(); 
	    xlsheet.cells(2,5)=patno.toString();
		xlsheet.cells(2,7)=prtno.toString();
		
		var xlsrow=3; 
		var xlsCurcol=0;
		//alert("MyAryIdx"+MyAryIdx)
		//idx_"^"_ItemDesc_"^"_ItmUPrice_"^"_ItmQty_"^"_UDesc_"^"_ItmTotalAmount
		for (var Row=0;Row<MyAryIdx;Row++)
		{
			xlsrow=xlsrow+1;
			var ary=MyPrtAry[Row].split("^");
			
			xlsheet.cells(xlsrow,xlsCurcol+1)=ary[0]; 				//idx
			xlsheet.cells(xlsrow,xlsCurcol+2)=ary[1];				//ItemDesc
			xlsheet.cells(xlsrow,xlsCurcol+4)=ary[2];				//ItemDesc
			xlsheet.cells(xlsrow,xlsCurcol+5)=ary[3];				//ItmUPrice
			xlsheet.cells(xlsrow,xlsCurcol+6)=ary[4];				//ItmQty
			xlsheet.cells(xlsrow,xlsCurcol+7)=ary[5]; 				//UDesc 
			xlsheet.cells(xlsrow,xlsCurcol+8)=ary[6];				//ItmTotalAmount
		}
	    
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,xlsCurcol+1)=t["fu"];
		xlsheet.cells(xlsrow,xlsCurcol+3)=t["zbr"]+" "+session['LOGON.USERNAME'];
		xlsheet.cells(xlsrow,xlsCurcol+5)=t["bt"]+" "+PDate;

	    xlsheet.printout;

	    xlBook.Close (savechanges=false);
	    
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	    ///window.setInterval("Cleanup();",1);
  	
	} catch(e) {
		alert(e.message);
	}
	
}


//////

document.body.onload = BodyLoadHandler;