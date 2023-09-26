///udhcOPRefund.main.js

var GUser
var AllExecute
var ExeFlag				///
var RebillFlag
var PartRefFlag;
var m_AbortPop=0;
var m_RefundPop=0;
var PrtXMLName;

var m_YBConFlag="0";     ////default not Connection YB
var m_SelectCardTypeRowID="";
var PUsr=""
var PUsrN=""
var InvFlag=""
var ToBillOrderstr=""
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
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","RefundPayMode",mygLoc,"","");
	}
	
	IntDoc();
	
   	var obj=document.getElementById("ReceipNO");
   	if (obj) obj.onkeydown=ReceipNO_KeyDown;
   	var obj=document.getElementById("Abort");
   	DHCWeb_DisBtn(obj);
   	obj=document.getElementById("Refund");
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
	DHCWeb_setfocus("ReceipNO");
	document.onkeydown = document_OnKeyDown;
	
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
	///modify 2011-06-10 增加发票补打功能
	obj=document.getElementById("RePrt");
   	if (obj){
	   	obj.onclick=RePrt_Click;
   	}
    	
	obj=document.getElementById("ReNumber");
   	if (obj){
	   	obj.onclick=ReNumber_Click;
   	}	
   	//补调用医保接口
   	obj=document.getElementById("BtpPrtInvInsu");
   	if (obj){
	   	obj.onclick=PrtInvInsuUpdate;
   	}   
	
}

function document_OnKeyDown()
{
	var e=window.event;
	///alert(e.keyCode);
	parent.window.FrameShutCutKeyFrame(e);
	DHCWeb_EStopSpaceKey();
	
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
	///var myrtn=DHCACC_GetAccInfo();
	
	var myCardTypeValue=combo_CardType.getSelectedValue();
	var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeRowID,myCardTypeValue);
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

function ReadCardQueryINV(PAPMNo){
	var mygLocDR=session['LOGON.GROUPID'];
	var myULoadLocDR=session['LOGON.CTLOCID'];
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk+="&FramName=udhcOPRefund_main&PatientNO="+PAPMNo;
	lnk+="&AuditFlag=ALL&sFlag=PRT&INVStatus=N";
	lnk+="&gLocDR="+mygLocDR+"&ULoadLocDR="+myULoadLocDR;
	var NewWin=open(lnk,"udhcOPINV_Query","scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
	
}

function QueryInv()	{
	var mygLocDR=session['LOGON.GROUPID'];
	var myULoadLocDR=session['LOGON.CTLOCID'];
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk+="&FramName=udhcOPRefund_main";
	lnk+="&AuditFlag=ALL&sFlag=PRT&INVStatus=N";	
	lnk+="&gLocDR="+mygLocDR+"&ULoadLocDR="+myULoadLocDR;
	var NewWin=open(lnk,"udhcOPINV_Query","scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}


function RefundClear_Click()
{
	//
	IntRefMain();
	AddIDToOrder("");
}

function BVerify_Click()
{
	var IDobj=document.getElementById("ReceipID");
	var ReceipRowid=IDobj.value;
	GUser=session['LOGON.USERID'];
	var verifyobj=document.getElementById("getVerify");
	if (verifyobj) {var encmeth=verifyobj.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,ReceipRowid,GUser)=='0') 
		{alert(t['04']);}     ////
	else {alert(t['05'])}    /////
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
		    ///yyx 2010-09-02
		   	///多种支付方式加载		   
		   	GetPayModeList(IDobj.value)
		   	var rptinfoobj=document.getElementById("getReceiptinfo");
		   	if (rptinfoobj) {var encmeth=rptinfoobj.value} else {var encmeth=''};
	    	if (cspRunServerMethod(encmeth,'SetReceipInfo','',IDobj.value)=='0') 
		   	{
				//AddIDToOrder(IDobj.value)
				var ReceipID=IDobj.value;
				parent.frames['udhcOPRefund_Order'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.Order&ReceipRowid="+ReceipID;
		   		var flag = InvprtIsRegister(ReceipID) ;
				if(flag){
					alert(t['invprtIsRegister']) ;
					var aobj=document.getElementById("Abort");
   					if (aobj){
   						DHCWeb_DisBtn(aobj);
   					}
   					var reobj=document.getElementById("Refund")
   					if (reobj){
	   					DHCWeb_DisBtn(reobj);
	   				}
				}
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
		parent.frames['udhcOPRefund_Order'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.Order&ReceipRowid="+ReceipID;
	}
}

function OPINVRefund_OnClick()
{
   	var aobj=document.getElementById("Abort");
	if (!aobj.disabled){
		Abort_Click();
	}else{
		var robj=document.getElementById("Refund");
		if (!robj.disabled){
			Refund_Click();
		}
	}
	
}

function Abort_Click()
{
   	var aobj=document.getElementById("Abort");
   	if (aobj){
   		DHCWeb_DisBtn(aobj);
   	}
   	
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
	var listdoc=parent.frames["udhcOPRefund_Order"].document;
	
	var StopOrderstr="",ToBillOrderstr=""
	AllExecute=1
	RebillFlag=0		////
	PartRefFlag=0
	ExeFlag=0			///
	
	var objtbl=listdoc.getElementById('tudhcOPRefund_Order');
	var Rows=objtbl.rows.length;
	
	for (var j=1; j<Rows; j++)
	{
		////DHCWebD_GetCellValue(obj)
		var excobj=listdoc.getElementById('TExcuteflagz'+j);
		var sExcute=DHCWebD_GetCellValue(excobj);    ////	listdoc.getElementById('TExcuteflagz'+j).innerText;
		if (sExcute==0){AllExecute=0}	//
		var TSelect=listdoc.getElementById("Tselectz"+j);
		var selflag=DHCWebD_GetCellValue(TSelect);
		if (TSelect.disabled==true){
			///ExeFlag=1;		////
			ExeFlag=0;		////
		}
		var ordobj=listdoc.getElementById('TOrderRowidz'+j);
		var sOrderRowid=DHCWebD_GetCellValue(ordobj);
		
		var qtyObj=listdoc.getElementById('TOrderQtyz'+j);
		var ordqty=DHCWebD_GetCellValue(qtyObj);		
		
		var refqtyObj=listdoc.getElementById('TReturnQtyz'+j);
		var refordqty=DHCWebD_GetCellValue(refqtyObj);
		//执行数量 yyx 2010-07-19
		var ExecQtyObj=listdoc.getElementById('TOEORDExecQtyz'+j);
		var ExecQty=DHCWebD_GetCellValue(ExecQtyObj);
		 
		if (!isNaN(refordqty)&&(PartRefFlag==0)){
			if (refordqty>0){
				PartRefFlag=1;
			}
		}
		
		//
		if (selflag==false) {RebillFlag=1;}
		///
		if ((selflag==true)&&(sExcute=="1")&&(ordqty!=refordqty)) {RebillFlag=1;}
		 
		//只有一条部分执行的医嘱退费再收费
		if (ExecQty=="") {ExecQty=0}
		if ((selflag==true)&&(ExecQty!="0")&&(ordqty!=ExecQty)) {RebillFlag=1;}
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
	var rtn=CheckRefund(RefundFlag);
	if (rtn==false){
		return rtn;
	}
   ///yyx 2009-09-16
	///取选中的新的费别,并且根据费别取admsource判断是否需要调用医保接口
	var InsList=document.getElementById("InsTypeList");
	var InsIndex=InsList.selectedIndex;
	NewInsType=InsList.options[InsIndex].value;
    var AdmSourceobj=document.getElementById("GetAdmSource");
	if (AdmSourceobj) {var encmeth=AdmSourceobj.value} else {var encmeth=''};
    var AdmSource=cspRunServerMethod(encmeth,NewInsType)
   
	var CurInsType=DHCWebD_GetObjValue("CurrentInsType");
	if ((CurInsType!=NewInsType)&(NewInsType!=""))
	{
		var myrtn=window.confirm("重新收费的收费类别发生变化,是否确认退费?");
	    if (!myrtn){
	       return myrtn;
	    }
	}	
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
			var StrikeFlag=RebillFlag
			var GroupDR=session['LOGON.GROUPID'];
			var InsuNo=""
			var CardType=""
			var YLLB=""
			var DicCode=""
			var DYLB=""
			var LeftAmt=""
			var MoneyType=""	//卡类型
			var LeftAmtStr=LeftAmt+"!"+LeftAmt+"^"+MoneyType			
			var myExpStr=StrikeFlag+"^"+GroupDR+"^"+InsuNo+"^"+CardType+"^"+YLLB+"^"+DicCode+"^"+DYLB+"^"+LeftAmtStr
			var rtn=DHCWebOPYB_ParkINVFYB(myYBHand,myUser, myINSDivDR,AdmSource,NewInsType,myExpStr, myCPPFlag)
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
	var myUserLocID=session['LOGON.CTLOCID'];
	var mystr=DHCWeb_GetListBoxValue("RefundPayMode");
	var myary=mystr.split("^");
	var myPayModeDR=myary[0];
	var myPayModeCode=myary[2];
	/////alert("DDDD"+ReceipRowid+":::"+myUser+":::"+RefundFlag+":::"+StopOrdStr+":::"+patPay+":::"+gloc+"::::"+RebillFlag);
	/////return;
	//Lid 2010-07-05 更新多种支付方式,对于卡消费在界面上控制?在此不做控制
    var PayMentFlag=document.getElementById("PayMentFlag").checked
    if (PayMentFlag==true) { MulityPayModeFlag="Y"}
    else { MulityPayModeFlag="N"}
	var myExpStr=MulityPayModeFlag+"^"
	var rtnvalue=cspRunServerMethod(encmeth,ReceipRowid,myUser,RefundFlag,StopOrdStr,patPay,gloc,RebillFlag, myUserLocID, myPayModeDR,NewInsType,myExpStr);
  
	var myary=rtnvalue.split(String.fromCharCode(2))
	var rtn=myary[0].split("^");
	if (rtn[0]=='0')
	{
		////Add YB InterFace   &&(myPRTRowID!="")
		var myPRTRowID="";
		var StrikeRowID="" ;
		var RefundInvFlag="N";
		if (rtn.length>1){
			myPRTRowID=rtn[1];
			StrikeRowID=rtn[2];
			RefundInvFlag=rtn[3]
		}
		
		var myINSDivDR=DHCWebD_GetObjValue("INSDivDR");
		if (((m_YBConFlag=="1")&&(myINSDivDR!=""))){
			var myYBHand="";
			var myCPPFlag="";
			var myExpStr=RebillFlag+"^";
			DHCWebOPYB_ParkINVFYBConfirm(myYBHand, myCPPFlag, myINSDivDR, myExpStr);
		}
		
		var myINSDivDR=DHCWebD_GetObjValue("INSDivDR");
		if (((m_YBConFlag=="1")&&(myINSDivDR!="")&&(myPRTRowID!=""))||((m_YBConFlag=="1")&&(AdmSource!=0)&&(myPRTRowID!=""))){
				var myYBHand="";
				var myCPPFlag="";
				var StrikeFlag="S"
				var GroupDR=session['LOGON.GROUPID'];
				var InsuNo=""
				var CardType=""
				var YLLB=""
				var DicCode=""
				var DYLB=""
				var MoneyType=""	//卡类型
				var LeftAmtStr=LeftAmt+"!"+LeftAmt+"^"+MoneyType	
				var myExpStr=StrikeFlag+"^"+GroupDR+"^"+InsuNo+"^"+CardType+"^"+YLLB+"^"+DicCode+"^"+DYLB+"^"+LeftAmtStr
				DHCWebOPYB_DataUpdate(myYBHand, myUser,myPRTRowID,AdmSource,NewInsType, myExpStr, myCPPFlag);
		}
	    
		if ((PayMentFlag==true)&(StopOrdStr!="")&(RebillFlag==1))
		
		{  var rtn=UpdatePayment(myPRTRowID);  //入参:发票Rowid串
	       if(!rtn){
		      alert("更新门诊收费多种支付方式失败,请到门诊收费界面重新结算.")
			  return;    
		    }
		}
		//银医卡接口
		if(myPayModeCode=="CARDCPP"){
			var BMCRtn=BankCardRefund(ReceipRowid,StrikeRowID,myPRTRowID);	
		}
		var myRCalFlag=1;
		var myINSDivDR=DHCWebD_GetObjValue("INSDivDR");
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
		var RETFLAGobj=document.getElementById("getUpdateRETFLAG");
			if (RETFLAGobj!=null)
			{
				var encmeth=RETFLAGobj.value;
				var mytmprtn=cspRunServerMethod(encmeth,myary[0]);
				
				}
		if (RefundInvFlag=="Y")
		{   
			BillPrintTaskListNew(StrikeRowID);
		}
		
		BillPrintTaskListNew(myPRTRowID);
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


function BillPrintNew(INVstr){
	if (PrtXMLName==""){
		return;
	}
	///alert(INVstr);
	///var myary=INVstr.split(String.fromCharCode(2));
	var INVtmp=INVstr.split("^");
	
	for (var invi=0;invi<INVtmp.length;invi++)
	{   
		if (INVtmp[invi]!=""){
			
			////alert(INVtmp[invi]);
			var beforeprint=document.getElementById('getSendtoPrintinfo');
			if (beforeprint) {var encmeth=beforeprint.value} else {var encmeth=''};
			var PayMode="";   ////
			var payobj=document.getElementById("RefundPayMode");
			if (payobj){
				//var PayMode=payobj.value;
				var PayMode=DHCWebD_GetObjValue("RefundPayMode");
			}
			
			var Guser=session['LOGON.USERID'];
			var sUserCode=session["LOGON.USERCODE"];
			//GetInvoicePrtDetail(JSFunName As %String,InvRowID, UseID , PayMode
			//JSFunName, PrtXMLName, InvRowID, UseID, PayMode, ExpStr
			var myCurGroupDR=session['LOGON.GROUPID'];
			
			var myExpStr="^^"+myCurGroupDR;
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew", PrtXMLName, INVtmp[invi],sUserCode,PayMode, myExpStr);
		}
	}
}


function InvPrintNew(TxtInfo,ListInfo)
{
	////
	////DHCP_PrintFun(encmeth,PObj,inpara,inlist)
	///alert(TxtInfo+":::::"+ListInfo);

	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
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
		if ((ExeFlag==0)&&(RefundFlag=="S")){  
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

function CheckRefundOld(){
	////
	////
	////
	var mySOrder=getOrderstr();
	///
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
	PUsr=Split_Value[6]
       
	var PatDr=Split_Value[19]  //yyx 2009-11-02
	var obj=document.getElementById("INSDivDR");
	if (obj){
		////YB INSRowID
		obj.value=Split_Value[13];
	}
	
	var obj=document.getElementById("CurrentInsType");
	if (obj){
		obj.value=Split_Value[17];
	}
	
	DHCWeb_DisBtn(cobj);
	DHCWeb_DisBtn(robj);
	////alert(Split_Value[9]);
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
	if ((Split_Value[18]!="")&&(Split_Value[18]!="N"))
	{
		alert(t['-201']);   ////
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}

	if (((Split_Value[8]!="Y")&&!((Split_Value[6]==GUser)&&(Split_Value[7]=="")))||(Split_Value[14]=="Y"))
	{
		alert(t['10']);     ////
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}
	
	///alert(Split_Value[10]);
	var myColPFlag=Split_Value[10];
	if (myColPFlag=="1"){
		alert(t["ColPTip"]);
		websys_setfocus('ReceipNO');
		return websys_cancel();		
	}
	
	if (Split_Value[4]=="A")
	{
		alert(t['11']);   ////
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}
	if (Split_Value[5]=="1")
	{
		alert(t['12']);   ////
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}
	
	if ((Split_Value[6]==GUser)&&(Split_Value[7]==""))
	{       InvFlag="A"
		if (m_AbortPop=="1"){
			cobj.disabled=false;
			cobj.onclick=Abort_Click;
		}else{
			alert(t["NoAbortPop"]);
		}
	}
   	else
   	{       InvFlag="S"
	   	if (m_RefundPop=="1"){
			robj.disabled=false;
			robj.onclick=Refund_Click;
	   	}else{
		   	alert(t["NoRefundPop"]);
	   	}
   	}
   	AddPrescTypeToList(PatDr);
}

function AddIDToOrder(ReceipID) {
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.Order&ReceipRowid="+ReceipID;
	var AdmCharge=parent.frames['udhcOPRefund_Order'];
	AdmCharge.location.href=lnk;
}

function IntRefMain()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund_main";
	var AdmCharge=parent.frames['udhcOPRefund_main'];
	AdmCharge.location.href=lnk;
	
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
		 return}
   	else
   	{
	   var chaorderobj=document.getElementById("getUpdateOrder");
	   if (chaorderobj) {var encmeth=chaorderobj.value} else {var encmeth=''};
	   if (cspRunServerMethod(encmeth,Orderstr,GUser)=='0') 
	   {alert("");}     ///
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
///Creator:yyx
///CreateDate:2009-09-16
///Function:  显示病人的费别
function AddPrescTypeToList(PatDr)	{
	//PrescType_$C(2)_PrescType_$C(2)_....
	//PrescTypeName_"^"_PrescTypeIns
	//PrescType:
	//PrescType[0]		PrescTypeName
	//PrescType[1]		PrescTypeIns
	//PrescType[2]		PatInsType
	var CurInsType=DHCWebD_GetObjValue("CurrentInsType");
	var GetPatPresc=document.getElementById('GetPatPresc');
	if (GetPatPresc) {var encmeth=GetPatPresc.value} else {var encmeth=''};
	var myExpStr="";
	var PrescTypeStr=cspRunServerMethod(encmeth,PatDr, myExpStr);
	var PrescType=PrescTypeStr.split("\002");
	var InsTypeList=document.getElementById('InsTypeList');
	InsTypeList.size=1;
	InsTypeList.multiple=false;
	if (PrescType.length==0) {return "";}
	var DefaultIndex=0;
	for (i=0;i<PrescType.length;i++)	{
		PrescList=PrescType[i].split("^");
		var ListText=PrescList[0];
	 	var ListValue=PrescList[1]
	 	var PatInsType=PrescList[2]
		InsTypeList.options[i]=new Option(ListText,ListValue);
		
		if (CurInsType==ListValue) {DefaultIndex=i;}
	}
	InsTypeList.options[DefaultIndex].selected=true;
}
//
function InvprtIsRegister(invprtRowid){

	var obj=document.getElementById("getPrtFairType");
	if(obj){  var encmeth=obj.value ; } else { var encmeth='' }
	if (encmeth!=""){
		var fairType = cspRunServerMethod(encmeth,invprtRowid) ;
		if(fairType=="R") {
			return true;
		}
		return false ;
	} 	

}

///// ************************************************************
///Creator:yyx
///CreateDate:2010-09-01
///Function  :加载支付方式
function GetPayModeList(PrtRowID)
{   
    var PayModeListObj=document.getElementById('PayModeList');
	PayModeListObj.options.length=0
    var obj=document.getElementById("GetPayModeList");
	if(obj){ 
	 var encmeth=obj.value ; } else { var encmeth='' }
	if (encmeth!=""){
		
		var PayModeInfo = cspRunServerMethod(encmeth,PrtRowID) ;
		PayModeInfo=PayModeInfo.split("&")
		if (PayModeInfo[0]>1)
		{   document.getElementById('PayMentFlag').checked=true   }
		else
		{   document.getElementById('PayMentFlag').checked=false  }
		for (i=1;i<PayModeInfo.length;i++)
		{  
			option=document.createElement("option");
		    option.value=PayModeInfo[i];
		    option.text=PayModeInfo[i];
		    PayModeListObj.add(option);
		}
	}
}
///// ************************************************************

///Lid 2010-07-05 更新多种支付方式?如果更新失败?则程序回滚
function UpdatePayment(PrtRowidStr){
	var paymentFlagObj=document.getElementById("PayMentFlag"); //多种支付方式标志
	var myrtn=true
	if(paymentFlagObj&&(paymentFlagObj.checked)){
	    var patNO=DHCWebD_GetObjValue("PatientID"); //病人登记号
        var expstr="N^"+session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+patNO;
	  //更新过多种支付方式
	  var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillPayment&PrtRowidStr='+PrtRowidStr; 
      var DlgReturnValue=window.showModalDialog(str,"",'dialogWidth:700px;dialogHeight:450px;resizable:yes');   //HTML样式的模态对话框
	  switch(DlgReturnValue)
	  {
		  case -1:
		      myrtn=true;  //不使用多种支付方式
		      break;
		  case -2:
		  	  myrtn=false;
		  	  var err=DeleteHISData(PrtRowidStr,expstr)
		  	  if(rtn==="HisCancelSuccess"){
			 	    myrtn=false;  //撤销结算
			 	    //alert("取消结算成功");    
			  }else if(rtn==="HisCancelFail"){
				    myrtn=true;	  //His撤销失败时?按默认支付方式结算出票
				    alert("His撤销失败,按默认支付方式结算!");
		      }
		  	  break;
		  default:
			 var rtn=UpDatePaymode(PrtRowidStr,DlgReturnValue,expstr);	
	  		 if(rtn==="0"){
		  		myrtn=true;	 
		     }else if(rtn==="HisCancelSuccess"){
			 	myrtn=false;  //撤销结算    
			 }else if(rtn==="HisCancelFail"){
				myrtn=true;	  //His撤销失败时?按默认支付方式结算出票
				alert("His撤销失败,按默认支付方式结算!");
		     }
	  }
	}
	return myrtn		
}
///Lid 2010-07-06 更新多种支付方式
function UpDatePaymode(prtRowidStr,payMInfo,expstr){
	var rtn=tkMakeServerCall("web.DHCOPBillManyPaymentLogic","UpdateInvPayM",prtRowidStr,payMInfo,expstr)
    //alert(rtn);
    var myrtn=rtn;
    if(rtn!=="0"){
	     //多种支付方式更新失败,分三种情况:
	     //   1.自费病人?His撤销结算?
	     //   2.医保病人?如果医保有撤销函数?则医保?His都撤销结算?
	     //   3.医保病人?如果医保没有撤销函数?则His不能撤销结算,只能按默认支付方式结算?或者补结算?
	     return DeleteHISData(prtRowidStr,expstr);
	}
	return rtn
}
///Lid 2010-07-06 回滚His数据
function DeleteHISData(prtRowidStr,expstr){
	var err=DHCWebOPYB_DeleteHISData(prtRowidStr,expstr)
	if(err==="0"){
		 myrtn="HisCancelSuccess"; //His撤销成功    
	 }else{
		 myrtn="HisCancelFail" //His撤销失败	 
	 }
	 return myrtn;
}

function RePrt_Click()
{
  var RepPrintFlag
  RepPrintFlag=window.confirm("是否确认原号重打发票?")
  if (!RepPrintFlag)
 {   return
 } 
  var ReceipRowid
   var recobj=document.getElementById("ReceipID");
   if (recobj){
      ReceipRowid=recobj.value;
  }  
  if ((ReceipRowid=="")||(ReceipRowid==" ")){
     alert("请选择要补打的发票");
     return;
  }
  
  BillPrintNew("^"+ReceipRowid);  	
}
function ReNumber_Click(){
        var RepPrintFlag
        RepPrintFlag=window.confirm("是否确认作废原发票重打发票?")
        if (!RepPrintFlag)
        {   return
        } 
	var StopOrdStr=getOrderstr();
       
	if (StopOrdStr!=""){alert("有停止医嘱不能新号重打!");return;}       
	var myUser=session['LOGON.USERID'];
      
	if (PUsr!=myUser){alert("请联系操作员:"+PUsrN+","+"新号重打!");return;}  
	//if (ExeSel=="1"){alert("有执行的医嘱,不能新号重打!");return;}       ///update  2010.10.11  zhl   sp
	var recobj=document.getElementById("ReceipID");
	if (recobj){
		var ReceipRowid=recobj.value;
	}
	
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
	var InsList=document.getElementById("InsTypeList");
	var InsIndex=InsList.selectedIndex;
	NewInsType=InsList.options[InsIndex].value;
	var refundobj=document.getElementById("getRefundRcpt");	//udhcOPRefBroker
	if (refundobj) {var encmeth=refundobj.value} else {var encmeth=''};
	var myUserLocID=session['LOGON.CTLOCID'];
	var mystr=DHCWeb_GetListBoxValue("RefundPayMode");
	var myary=mystr.split("^");
	var myPayModeDR=myary[0];
	var PayMentFlag=document.getElementById("PayMentFlag").checked
    if (PayMentFlag==true) { MulityPayModeFlag="Y"}
    else { MulityPayModeFlag="N"}
	var myExpStr=MulityPayModeFlag+"^"
      
	///var rtnvalue=cspRunServerMethod(encmeth,ReceipRowid,myUser,InvFlag,StopOrdStr,patPay,gloc,RebillFlag, myUserLocID, myPayModeDR);
	//alert("1"+"^"+ReceipRowid+"2^"+myUser+"3^"+InvFlag+"4^"+StopOrdStr+"5^"+patPay+"6^"+gloc+"7^"+RebillFlag+"8^"+myUserLocID+"9^"+myPayModeDR+"10^"+NewInsType+"11^"+myExpStr)
       var rtnvalue=cspRunServerMethod(encmeth,ReceipRowid,myUser,InvFlag,StopOrdStr,patPay,gloc,RebillFlag, myUserLocID, myPayModeDR,NewInsType,myExpStr);
	
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
        if (myINSDivDR!=""){
            var UpRepInvPayM=document.getElementById("UpRepInvPayM");
			if (UpRepInvPayM!=null)
			{
				var encmeth=UpRepInvPayM.value;
				var mytmprtn=cspRunServerMethod(encmeth,ReceipRowid,myary[0]);
				
				}
            }
		
		var RETFLAGobj=document.getElementById("getUpdateRETFLAG");
			if (RETFLAGobj!=null)
			{
				var encmeth=RETFLAGobj.value;
				var mytmprtn=cspRunServerMethod(encmeth,myary[0]);
				
				}	
		
		BillPrintNew("^"+myPRTRowID);
		alert("新号重打成功");		/////
		return true;
	}else{
		switch(rtn[0]){
			case 101:
				alert("过号失败101");   ////
			default:
				alert("过号失败"+rtn[0]);	  /////
		}
		return false;	
	}
	
	
	}

///Function:补调用医保接口
function PrtInvInsuUpdate()
{   
	var myINSDivDR=DHCWebD_GetObjValue("INSDivDR");
    var IDobj=document.getElementById("ReceipID");
	var ReceipRowid=IDobj.value;
	if (InvFlag!="A")
	{
		alert("收费员已结算或不是本人收据,不允许调用医保接口.")
		return
	}
	if (myINSDivDR!="")
	{
		alert("此发票已经是医保结算,不允许调用医保接口.")
		return
	}
	
	var InsList=document.getElementById("InsTypeList");
	var InsIndex=InsList.selectedIndex;
	NewInsType=InsList.options[InsIndex].value;
    var AdmSourceobj=document.getElementById("GetAdmSource");
	if (AdmSourceobj) {var encmeth=AdmSourceobj.value} else {var encmeth=''};
    var AdmSource=cspRunServerMethod(encmeth,NewInsType)
    
	var CurInsType=DHCWebD_GetObjValue("CurrentInsType");
	
	if ((CurInsType!=NewInsType)&(NewInsType!=""))
	{   
		var myrtn=window.confirm("重新收费的收费类别发生变化,是否确认退费?");
	    if (!myrtn){
	       return myrtn;
	    }
	}	

	//alert("m_YBConFlag="+m_YBConFlag+"myINSDivDR="+myINSDivDR+"AdmSource="+AdmSource+"ReceipRowid="+ReceipRowid)
	if (((m_YBConFlag=="1")&&(myINSDivDR=="")&&(AdmSource!=0)&&(ReceipRowid!=""))){
			var myYBHand="";
			var myCPPFlag="";
			var myExpStr="S^"+session['LOGON.GROUPID']+"^"+"^"+"";
			var myUser=session['LOGON.USERID']
			//var myExpStr="S^"+session['LOGON.GROUPID']+"^"+"^"+"";
			//DHCWebOPYB_DataUpdate(myYBHand, myUser,ReceipRowid,AdmSource,NewInsType, myExpStr, myCPPFlag);
			DHCWebOPYB_DataUpdate(myYBHand, myUser,ReceipRowid,AdmSource,NewInsType, myExpStr, myCPPFlag);
		}
		
	    
}
document.body.onload = BodyLoadHandler;
