/// udhcOPAliRefundYCCL.js

var GUser;
var AllExecute;
var ExeFlag;
var RebillFlag;
var PartRefFlag;
var m_AbortPop=0;
var m_RefundPop=0;
var PrtXMLName;
var myCPPFlag="";
var m_YBConFlag="0";     //default not Connection YB

function BodyLoadHandler()
{
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

	IntDoc();

   	var obj=document.getElementById("ReceipNO");
   	if (obj) obj.onkeydown=ReceipNO_KeyDown;
   	
   	var obj=document.getElementById("PRTReceipID");
   	if (obj) obj.onkeydown=ReceipID_KeyDown;
   	
   	var obj=document.getElementById("Abort");
   	if(obj){DHCWeb_DisBtn(obj);}
   	obj=document.getElementById("Refund");
   	if(obj){DHCWeb_DisBtn(obj);}
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
	var obj=document.getElementById("ReadPos");
   	if (obj){
	   	obj.onclick=ReadPosQuery_OnClick;
   	}	
	ReadINVInfo();
	DHCWeb_setfocus("ReceipNO");
	document.onkeydown = DHCWeb_EStopSpaceKey;
	
	var encmeth=DHCWebD_GetObjValue("ReadOPBaseEncrypt");
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth);
		var myary=myrtn.split("^");
		m_YBConFlag=myary[12];
	}
	
	if (m_YBConFlag=="1"){
	    DHCWebOPYB_InitForm();
	}
   	obj=document.getElementById("ReTrade");
   	if (obj){
	   	obj.onclick=ReTrade_Click;
   	}
   	var obj=document.getElementById("RePrintAcert");
   	if (obj){
	   	obj.onclick=RePrintAcert_OnClick;
   	}
}

function IntDoc()
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
    ////特殊
	
}

function INVQuery_Click(){
	///   DHCOPINV.Query
	QueryInv();
	
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
function ReadPosQuery_OnClick(){
	var myrtn=DHCACC_GetAccInfobyPos();
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
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";  //YCCL
	lnk+="&FramName=udhcOPRefundYCCL&PatientNO="+PAPMNo;
	lnk+="&AuditFlag=A&sFlag=PRT&INVStatus=N";
	lnk+="&gLocDR="+mygLocDR+"&ULoadLocDR="+myULoadLocDR;
	var NewWin=open(lnk,"udhcOPINVYCCL_Query","status=yes,scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
	
}
/*
function QueryInv()	{
	var mygLocDR=session['LOGON.GROUPID'];
	var myULoadLocDR=session['LOGON.CTLOCID'];
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";   //YCCL
	lnk+="&FramName=udhcOPRefundYCCL";
	lnk+="&AuditFlag=A&sFlag=PRT&INVStatus=N";	
	lnk+="&gLocDR="+mygLocDR+"&ULoadLocDR="+myULoadLocDR;
	var NewWin=open(lnk,"udhcOPINVYCCL_Query","scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}
*/
function QueryInv()	{
	var mygLocDR=session['LOGON.GROUPID'];
	var myULoadLocDR=session['LOGON.CTLOCID'];
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk+="&FramName=udhcOPRefundYCCL";
	lnk+="&AuditFlag=A&sFlag=PRT&INVStatus=S&INVFlag=S";	
	lnk+="&gLocDR="+mygLocDR+"&ULoadLocDR="+myULoadLocDR;
	var NewWin=open(lnk,"udhcOPINVYCCL_Query","scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function RefundClear_Click()
{
	//
	IntRefMain();
	//AddIDToOrder("");
	parent.frames['udhcOPAliRefundyccl_Order'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPAliRefundyccl.Order&ReceipRowid=";
}

function BVerify_Click()
{
	var IDobj=document.getElementById("ReceipID");
	var ReceipRowid=IDobj.value;
	GUser=session['LOGON.USERID'];
	var verifyobj=document.getElementById("getVerify");
	if (verifyobj) {var encmeth=verifyobj.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,ReceipRowid,GUser)=='0') 
		{alert(t['04']);}
	else {alert(t['05']);}
}

function ReceipNO_KeyDown(e)
{  
	var key = websys_getKey(e);
	var obj = websys_getSrcElement(e);
	if ((obj)&&(obj.value!="")&&(key==13)) 
	{
	   	var No=obj.value;
	   	var encmeth = DHCWebD_GetObjValue("getReceipID");
		var rtn = cspRunServerMethod(encmeth, 'SetReceipID', '', No);
		var ReceipID = DHCWebD_GetObjValue("ReceipID");
	  	if (ReceipID == "") {
			DHCWeb_DisBtnA("ReTrade");
			alert(t['06']);
			websys_setfocus('ReceipNO');
			return websys_cancel();
		}else {
			var reTradeObj = websys_$("ReTrade");
			DHCWeb_AvailabilityBtnA(reTradeObj, ReTrade_Click);
		   	var IDobj=document.getElementById("ReceipID");
		   	var rptinfoobj=document.getElementById("getReceiptinfo");
		   	if (rptinfoobj) {var encmeth=rptinfoobj.value;} else {var encmeth='';}
	    	if (cspRunServerMethod(encmeth,'SetReceipInfo','',IDobj.value)=='0') {
				var ReceipID=IDobj.value.split("^")[0];
				parent.frames['udhcOPAliRefundyccl_Order'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPAliRefundyccl.Order&ReceipRowid="+ReceipID;
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
	var rtn=cspRunServerMethod(encmeth,'SetReceipInfo','',IDobj.value);
	if (rtn=='0')
	{
		var ReceipID=IDobj.value;
		parent.frames['udhcOPRefundyccl_Order'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefundyccl.Order&ReceipRowid="+ReceipID;
	}
}

function Abort_Click()
{
   	var aobj=document.getElementById("Abort");
   	if (aobj){
   		DHCWeb_DisBtn(aobj);
   	}
    //lgl+
   	/*var invnoobj=document.getElementById("ReceipNO");
   	if (invnoobj.value!=""){
	   	alert(t['ColPTip']);
	   	return;
   	}  */	
	var rtn=RefundSaveInfo("A");
   	
   	var aobj=document.getElementById("Abort");
	if ((rtn==false)&&(aobj)){
   		//DHCWeb_DisBtn(aobj);
		aobj.disabled=false;
		aobj.onclick=Abort_Click;
	}
}


function Refund_Click()
{
   	var robj=document.getElementById("Refund");
   	if (robj){
   		DHCWeb_DisBtn(robj);
   	}
	   	 //lgl+
   	/*	var invnoobj=document.getElementById("ReceipNO");
   	   	if (invnoobj.value!=""){
	   	alert(t['ColPTip']);
	   	return;
   	    }*/
	var rtn=RefundSaveInfo("S");
	
   	var robj=document.getElementById("Refund");
	if ((rtn==false)&&(robj)){
		robj.disabled=false;
		robj.onclick=Refund_Click;
	}
}


function getOrderstr(){
	////dfadsfd
	////zhaocz
	////
	////
	////
	////
	/////dfasdfsd
	var listdoc=parent.frames["udhcOPRefundyccl_Order"].document;
	
	var StopOrderstr="",ToBillOrderstr=""
	AllExecute=1
	RebillFlag=0		////
	PartRefFlag=0
	ExeFlag=0			///
	
	var objtbl=listdoc.getElementById('tudhcOPRefundyccl_Order');
	var Rows=objtbl.rows.length;
	
	for (var j=1; j<Rows; j++)
	{
		////DHCWebD_GetCellValue(obj)
		var excobj=listdoc.getElementById('TExcuteflagz'+j);
		var sExcute=DHCWebD_GetCellValue(excobj);    ////	listdoc.getElementById('TExcuteflagz'+j).innerText;
		if (sExcute==0){AllExecute=0}	//
		/*
		var TSelect=listdoc.getElementById("Tselectz"+j);
		var selflag=DHCWebD_GetCellValue(TSelect);
		if (TSelect.disabled==true){
			///ExeFlag=1;		////
			ExeFlag=0;		////
		} */
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
		/*
		if (TSelect.checked==true)
		{
			if (StopOrderstr==""){StopOrderstr=sOrderRowid;}
			else
			{StopOrderstr=StopOrderstr+'^'+sOrderRowid;}
		}  */
	}
	
	return StopOrderstr;
}


function ReTrade_Click(){
	var ReceipRowid=DHCWebD_GetObjValue("ReceipID");
	var encmeth=DHCWebD_GetObjValue('getRefundRcpt');
	var rtnvalue=cspRunServerMethod(encmeth,ReceipRowid);
	var myary=rtnvalue.split(String.fromCharCode(2))
	var rtn=myary[0].split("^");
	var abortrowid="";
	var normalrowid="";
	if(rtn[0]=="-1"){abortrowid=rtn[1];}
	if(rtn[0]=="-2"){abortrowid=rtn[2];normalrowid=rtn[1];}
	if(rtn[0]=="-3"){abortrowid=rtn[2];normalrowid=rtn[1];}
	//alert(myary[0])
	if(rtn[0]=="0"){
		alert(rtn[1]);
		return;
	}else {
		//add tangtao 2011-11-06   软POS
		var mystr=DHCWeb_GetListBoxValue("RefundPayMode");
		var myary1=mystr.split("^");
		var myPayModeDR=myary1[0];
		var myPayModeCode=myary1[1];
		//alert(mystr)
		if(myPayModeCode=="ALIPAY")
		{
			var Guser=session['LOGON.USERID'];
    		var ExpStr=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^^^"+session['LOGON.USERID']+"^补交易退费";
			var retn=tkMakeServerCall("DHCAliPay.ChargeInterface.AliPayLogic","AliPay","OP",normalrowid,abortrowid,"","D",ExpStr)
			if(retn=="0")
			{
				alert("补交易成功！");
				//BillPrintNew("^"+rtn[1]);
				//alert("打印票据成功!")
			}
			else
			{
				alert("Pos补交易失败,请联系信息部!");	
				return;
			}
		}else if (myPayModeCode=="WECHATPAY"){
			var Guser=session['LOGON.USERID'];
    		var ExpStr=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^^^"+session['LOGON.USERID']+"^补交易退费";
			var retn=tkMakeServerCall("DHCWeChatPay.ChargeInterface.WeChatPayLogic","WeChatPay","OP",normalrowid,abortrowid,"","D",ExpStr)
			if(retn=="0")
			{
				alert("补交易成功！");
				//BillPrintNew("^"+rtn[1]);
				//alert("打印票据成功!")
			}
			else
			{
				alert("Pos补交易失败,请联系信息部!");	
				return;
			}
			
		}else{
			alert("获取配置失败,该支付方式没有银医卡或者软POS支付配置,不能补交易")
		}
	}
}

function BillPrintNew(INVstr){
	if (PrtXMLName==""){
		return;
	}
	///alert(INVstr);
	///var myary=INVstr.split(String.fromCharCode(2));
	var INVtmp=INVstr.split("^");
	DHCP_GetXMLConfig("InvPrintEncrypt",PrtXMLName);		///INVPrtFlag
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
	///alert(TxtInfo+":::::"+ListInfo);
	////alert(TxtInfo);
	var myobj=document.getElementById("ClsBillPrint");
	var myInsType=DHCWebD_GetObjValue("InsType");
	if ((myInsType==44)||(myInsType==46)){   //lgl 干保
	   TxtInfo=TxtInfo+"^SBJflag"+String.fromCharCode(2)+"省保健发票"
	}
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
}


function CheckRefund(RefundFlag){
	var mySOrder=getOrderstr();
	
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
		alert(t["BackINVTip"]+":发票号:"+myReceipNO);
	}
	
	return true;
}

function CheckRefundOld(){
	var mySOrder=getOrderstr();
	/*
	if (PartRefFlag==1){
		return true;
	}
	*/
	if (mySOrder==""){
		alert(t['03']);
		return false;
	}
	return true;
}


function SetReceipID(value)
{
	try {
		var myAry = value.split('^');
		var ReceipID = myAry[0];
		var sFlag = myAry[1];
		if (sFlag == 'PRT') {
			DHCWebD_SetObjValueB("ReceipID", ReceipID);
		}
	} catch(e) {
	}
}

function SetReceipInfo(value)
{
	var Split_Value=value.split("^");
	var Sumobj=document.getElementById("Sum");
	var sexobj=document.getElementById("PatientSex");
	var nameobj=document.getElementById("PatientName");
	var noobj=document.getElementById("PatientID");
	var cobj=document.getElementById("Abort");
	var robj=document.getElementById("Refund");
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
	var obj=document.getElementById("InsType");
	if (obj){
		////lgl+
		obj.value=Split_Value[17];
	}	
	if(cobj){DHCWeb_DisBtn(cobj);}
	if(robj){DHCWeb_DisBtn(robj);}
	var defaultpaymode=Split_Value[9]
	//if(Split_Value[9]=="13"){defaultpaymode="31"}  //zhho银医卡默认pos退
	////alert(Split_Value[9]);
	if (Split_Value[9]!=""){
		var obj=document.getElementById("RefundPayMode");
		var myLen=obj.options.length;
		for (var i=0;i<myLen;i++){
			var mystr=obj.options[i].value;
			var myary=mystr.split("^");
			if (myary[0]==defaultpaymode){
				obj.selectedIndex=i;
				break;
			}
		}
		obj.disabled=true
	}
	/*
	if (((Split_Value[8]!="Y")&&!((Split_Value[6]==GUser)&&(Split_Value[7]=="")))||(Split_Value[14]=="Y"))
	{
		alert(t['10']);     ////
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}
	*/
	///alert(Split_Value[10]);
	var myColPFlag=Split_Value[10];
	if (myColPFlag=="1"){
		alert(t["ColPTip"]);
		websys_setfocus('ReceipNO');
		return websys_cancel();		
	}
	//alert(Split_Value[4])
	if ((Split_Value[4]!="A")&&(Split_Value[4]!="S"))
	{
		alert("此收据没有退费信息");   ////
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}
	if (Split_Value[5]=="1")
	{
		//alert(t['12']);   ////
		//websys_setfocus('ReceipNO');
		//return websys_cancel();
	}
	
}

function AddIDToOrder(ReceipID) {
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefundyccl.Order&ReceipRowid="+ReceipID;
	var AdmCharge=parent.frames['udhcOPRefundyccl_Order'];
	AdmCharge.location.href=lnk;
}

function IntRefMain()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPAliRefundYCCL";
	window.location.href=lnk;
	
}

function Abort_ClickOld()
{ 
   
   var Orderstr=getOrderstr();
   if (AllExecute==1)
   {
	   alert("");  ////
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
		{alert("");}  /////
	}
}


function Refund_ClickOld()
{
	/////RefundSaveInfo
	var Orderstr=getOrderstr();
   	
	var IDobj=document.getElementById("ReceipID");
	var ReceipRowid=IDobj.value;
	var GUser=session['LOGON.USERID'];
	var refundobj=document.getElementById("getRefundRcpt");
	if (refundobj) {var encmeth=refundobj.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'','',ReceipRowid,GUser)=='-1') 
		{alert(t['02']);
		 return;
		}
   	else
   	{
	   var chaorderobj=document.getElementById("getUpdateOrder");
	   if (chaorderobj) {var encmeth=chaorderobj.value} else {var encmeth=''};
	   if (cspRunServerMethod(encmeth,Orderstr,GUser)=='0') 
	   {alert("");}     ///
 	}
}

function RePrintAcert()
{
	var IDobj=document.getElementById("ReceipID");
}

function RePrintAcert_OnClick()
{
	var UserName=session['LOGON.USERNAME'];
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillFindBankTrade";
	lnk+="&FramName=udhcOPRefundYCCL";
	lnk+="&UserName="+UserName
	var NewWin=open(lnk,"DHCOPBillFindBankTrade","scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}
function ReceipID_KeyDown(e)
{
	var key = websys_getKey(e);
	var obj = websys_getSrcElement(e);
	if ((obj)&&(obj.value!="")&&(key==13)) 
	{
		   	var IDobj=document.getElementById("ReceipID");
		   	IDobj.value=document.getElementById("PRTReceipID").value
		   	alert(IDobj.value)
		   	var rptinfoobj=document.getElementById("getReceiptinfo");
		   	if (rptinfoobj) {var encmeth=rptinfoobj.value} else {var encmeth=''};
	    	if (cspRunServerMethod(encmeth,'SetReceipInfo','',IDobj.value)=='0') 
		   	{
				//AddIDToOrder(IDobj.value)
				var ReceipID=IDobj.value.split("^")[0];
				//alert(ReceipID)
				parent.frames['udhcOPAliRefundyccl_Order'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPAliRefundyccl.Order&ReceipRowid="+ReceipID;
		   	}
		
	}
	}
document.body.onload = BodyLoadHandler;