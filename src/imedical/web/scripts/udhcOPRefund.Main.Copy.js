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
var MagCardNo="";  //28位
var InsuCardType=""; //判断是否是医保卡,调医保读卡返回值得到 调用医保实时接口

function BodyLoadHandler()
{
	ValidateDocumentData();
	//增加读医保卡的按钮
	var myobj = document.getElementById("ReadInsuCard");
	if (myobj){
		myobj.onclick = ReadInsuCard_click;
	}
	var obj=document.getElementById("RCardNo");
	if (obj){
			obj.onkeydown=RCardNo_KeyDown;
	}
	var myobj=document.getElementById("CardTypeDefine");
	if (myobj){
		myobj.onchange=CardTypeDefine_OnChange;
	}
	CardTypeDefine_OnChange();
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
		//alert(m_AbortPop+"^"+m_RefundPop);
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
	lnk+="&FramName=udhcOPRefund_main_Copy&PatientNO="+PAPMNo;
	lnk+="&AuditFlag=ALL&sFlag=PRT&INVStatus=N";
	lnk+="&gLocDR="+mygLocDR+"&ULoadLocDR="+myULoadLocDR;
	var NewWin=open(lnk,"udhcOPINV_Query","scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
	
}

function QueryInv()	{
	var mygLocDR=session['LOGON.GROUPID'];
	var myULoadLocDR=session['LOGON.CTLOCID'];
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk+="&FramName=udhcOPRefund_main_Copy";
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
		   	
		   	var rptinfoobj=document.getElementById("getReceiptinfo");
		   	if (rptinfoobj) {var encmeth=rptinfoobj.value} else {var encmeth=''};
	    	if (cspRunServerMethod(encmeth,'SetReceipInfo','',IDobj.value)=='0') 
		   	{
				//AddIDToOrder(IDobj.value)
				var ReceipID=IDobj.value;
				parent.frames['udhcOPRefund_Order_Copy'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.Order.Copy&ReceipRowid="+ReceipID;
		   		
		   		var flag = InvprtIsRegister(ReceipID) ;判断是否是挂号发票
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
		parent.frames['udhcOPRefund_Order_Copy'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.Order.Copy&ReceipRowid="+ReceipID;
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
   		//DHCWeb_DisBtn(aobj);
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
   		//DHCWeb_DisBtn(robj);
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
	var listdoc=parent.frames["udhcOPRefund_Order_Copy"].document;
	
	var StopOrderstr="",ToBillOrderstr=""
	AllExecute=1
	RebillFlag=0		////
	PartRefFlag=0
	ExeFlag=0			///
	
	var objtbl=listdoc.getElementById('tudhcOPRefund_Order_Copy');
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
	var rtn=CheckRefund(RefundFlag);
	if (rtn==false){
		return rtn;
	}
   ///yyx 2009-09-16
	///取选中的新的费别,并且根据费别取admsource判断是否需要调用医保接口
	var InsList=document.getElementById("InsTypeList");
	var InsIndex=InsList.selectedIndex;
	//NewInsType=InsList.options[InsIndex].value;
    NewInsType=document.getElementById("CurrentInsType").value;
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
			//var myExpStr=RebillFlag+"^";
			var myExpStr=RebillFlag+"^"+document.getElementById("PatINSUCardNO").value; //Lid 20100224 获取医保卡号
			
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
	/////alert("DDDD"+ReceipRowid+":::"+myUser+":::"+RefundFlag+":::"+StopOrdStr+":::"+patPay+":::"+gloc+"::::"+RebillFlag);
	/////return;
	var IPAdmRowID=DHCWebD_GetObjValue("IPAdm")
	myExpStr=IPAdmRowID+"^"
	if (IPAdmRowID=="") 
	{  alert("请选择住院就诊.") 
	   return 
	}
	if (StopOrdStr=="")
	{
		alert("请选择要复制的医嘱.")
		return
	}
	var rtnvalue=cspRunServerMethod(encmeth,ReceipRowid,myUser,RefundFlag,StopOrdStr,patPay,gloc,RebillFlag, myUserLocID, myPayModeDR,NewInsType,myExpStr);
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
		if (((m_YBConFlag=="1")&&(myINSDivDR!="")&&(myPRTRowID!=""))||((m_YBConFlag=="1")&&(AdmSource!=0)&&(myPRTRowID!=""))){
			var myYBHand="";
			var myCPPFlag="";
			var myExpStr="S^"+session['LOGON.GROUPID']+"^";
			DHCWebOPYB_DataUpdate(myYBHand, myCPPFlag, myPRTRowID, myExpStr);
		}
		///
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
		//
		///if (myary[1]=="0"){
		////BillPrintNew(myary[0]);
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


function InvPrintNewOLD(TxtInfo,ListInfo)
{
	////
	////DHCP_PrintFun(encmeth,PObj,inpara,inlist)
	///alert(TxtInfo+":::::"+ListInfo);
	////alert(TxtInfo);
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
}

function InvPrintNew(TxtInfo,ListInfo)
{
	 ///Lid 2010-02-25 明细分发票打印 
    var chr2=String.fromCharCode(2);
    var guser=session['LOGON.USERID'];
    var group=session['LOGON.GROUPID'];
    var invRowid=TxtInfo.split("^")[0].split(chr2)[1]; //主发票Rowid
 
    var listAry=ListInfo.split("!");
    var listNum=listAry.length;
    var myobj=document.getElementById("ClsBillPrint");
    for(i=0;i<listNum;i++){
	    switch(i){
			case 0:
	             DHCP_PrintFun(myobj,TxtInfo,listAry[i]);	    
			     break;
			default:
			     //走发票号
			     var rtn=tkMakeServerCall("web.UDHCOPINVPrtData24","UpdateInvoice",guser,group,invRowid)
	             var sucessFlag=rtn.split("^")[0]
	             //打印明细
	             if(sucessFlag==0){
		            //附票发票头信息 
		            var patName=TxtInfo.split("^")[1];     //病人姓名
		            var regNO=TxtInfo.split("^")[2];       //登记号 
		            var date=TxtInfo.split("^")[3];        //收费日期
		            var userCode=TxtInfo.split("^")[4];    //收款员Code
		            var patInsType=TxtInfo.split("^")[7];  //病人类型
		            var invNO=TxtInfo.split("^")[9].split(chr2)[1];       //主发票号
		            var currInvNO=rtn.split("^")[1];   //当前发票号
		            var invSubTxtInfo=patName+"^"+regNO+"^"+date+"^"+userCode+"^"+patInsType+"^"+"mainInvNO"+chr2+"主发票号:"+invNO+"^"+"InvNo"+chr2+currInvNO
		             
		            DHCP_PrintFun(myobj,invSubTxtInfo,listAry[i]); 
		         }else{
			     	alert("发票号码更新失败"); 
			     	return;   
			     }
	              
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
	//s ret=PapmiNo_"^"_PapmiName_"^"_PaSex_"^"_PRTPatPay_"^"_flag_"^"_Refundflag_"^"_PRTUsr_"^"_DHCINVPRTRDR_"^"_Verifyflag
	//s ret=ret_"^"_myINVPayMDR_"^"_myColPFlag_"^"_myConAppFlag_"^"_myMixOE
	//s ret=ret_"^"_myINSDivDR
	//s ret=ret_"^"_mySpecLFalg_"^"_myYBPaySum
	//s ret=ret_"^"_myOPRoundSum
	//s ret=ret_"^"_myINSTypeDR
	//s ret=ret_"^"_myAccFlag_"^"_PrtPapmiDR_"^"_prtDate_"^"_panAddress
	//登记号_"^"_病人姓名_"^"_病人性别_"^"_自付金额_"^"_发票状态_"^"_红冲标志_"^"_收款人_"^"_收款员结算表指针_"^"_审批标志
	//_"^"_结算时的支付方式_"^"_集中打印标志(卡消费用)_"^"_审批级别_"^"_混合医嘱标志_"^"_医保指针
	//_"^"_特殊标志(不用)_"^"_医保支付金额_"^"_分币找零金额_"^"_费别_"^"_有效账户标志(卡消费用)_"^"_病人信息表DR(pa_patmas)
	//_"^"_收费日期_"^"_病人地址	
	
	//alert(value);
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
	document.getElementById("IPAdm").value=""
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
		//以哪种种支付方结算默认以那种支付方式退费
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
	//alert("发票未审核!");
	//	websys_setfocus('ReceipNO');
	//	return websys_cancel();
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
	{
		if (m_AbortPop=="1"){
			cobj.disabled=false;
			cobj.onclick=Abort_Click;
		}else{
			alert(t["NoAbortPop"]);
		}
	}
   	else
   	{
	   	if (m_RefundPop=="1"){
			robj.disabled=false;
			robj.onclick=Refund_Click;
	   	}else{
		   	alert(t["NoRefundPop"]);
	   	}
   	}
   	//AddPrescTypeToList(PatDr);
}

function AddIDToOrder(ReceipID) {
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.Order.Copy&ReceipRowid="+ReceipID;
	var AdmCharge=parent.frames['udhcOPRefund_Order_Copy'];
	AdmCharge.location.href=lnk;
}

function IntRefMain()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund_main_Copy";
	var AdmCharge=parent.frames['udhcOPRefund_main_Copy'];
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

///////////////////////////////////////////////////
///读医保卡程序
function ReadInsuCard_click(){
	ReadInsuCardInfo("")
	var CardNo=document.getElementById("RCardNo").value;
	//if (CardTypeRowId!="") CardNo=FormatCardNo();
	//医保卡类型
	if ((InsuCardType=='1')||(InsuCardType=='0')){
	}else{
		 SetCardNOLength();
	}
	if (CardNo=="") return;	
	var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeRowID,CardNo,"","PatInfo");
	//alert(myrtn)
	var myary=myrtn.split("^");
	var rtn=myary[0];
	AccAmount=myary[3];
	switch (rtn){
	     case "0":
			///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			var obj=document.getElementById("PatientID");
			obj.value=myary[5];
			var obj=document.getElementById("CardNo");
			DHCWebD_SetObjValueB("CardNo",myary[1]);
			DHCWebD_SetObjValueB("RCardNo",myary[1]);
			DHCWebD_SetObjValueB("AccRowID",myary[7]);
			var myAccRowID=DHCWebD_GetObjValue("AccRowID");
			if (myAccRowID!=""){
				var obj=document.getElementById("AccAddDeposit");
				if (obj){
					obj.disabled=false;
					obj.onclick=AccAddDeposit;
				}
			}
			
		ReadCardQueryINV(myary[5]);
			break;
		case "-200":
			alert(t["-200"]);
			break;
		case "-201":
			ReadCardQueryINV(myary[5]);
			break;
		default:
			///alert("");
	}
}
///卡号回车事件
function RCardNo_KeyDown(){
	var key = websys_getKey(e);
	if ((key==13)){
		//Lid 20100224
		//如果是28位也要调用医保读卡程序,卡号赋值10位卡号,全局变量保存28位卡号
		var objCardNo=document.getElementById('RCardNo');
		if (objCardNo.value.length=='28'){
			document.getElementById('PatINSUCardNO').value=objCardNo; 
			MagCardNo=objCardNo.value;      //保留28位卡号
			ReadInsuCardInfo(objCardNo.value);
		}else{
			InsuCardType="";
		}
		
		if ((InsuCardType=='1')||(InsuCardType=='0')){
		}else{
			///Set Card No Length;
		    SetCardNOLength();
		}
		
		var myCardNo=DHCWebD_GetObjValue("RCardNo");
		var mySecurityNo="";
		
		///var myrtn=DHCACC_GetAccInfo();
		var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeRowID, myCardNo, mySecurityNo,"PatInfo")
		var myary=myrtn.split("^");
		//alert(myary);
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
}
///刷医保卡程序
function ReadInsuCardInfo(MCardNo){
	//调用医保js函数接口以为卡号为医保给 入28位出真正的卡号,给界面赋值
	var InfoStr="";
	var flag="";
	var MedicareNumber="";
	var PatName="";
	var CardTypeRowId='2';
   InfoStr=ReadINSUCard(MCardNo);
   var InfoStrarr=InfoStr.split("|");
   if (InfoStrarr[0]){
  	flag=InfoStrarr[0];
  	InsuCardType=InfoStrarr[1];    //0,1可以核对卡位数   在最后核对的时候check  全局变量
  	MedicareNumber=InfoStrarr[2];
  	MedicareNumber=Trim(MedicareNumber);
  	PatName=InfoStrarr[3];
  	
  	if (flag=='0'){
  		/*//置医保卡类型
  		if (InsuCardType=='1'){
  			//芯片卡
  			m_SelectCardTypeDR="1";
  			alert(111+"%%%"+document.getElementById('CardTypeDefine').value)
  		}else if (InsuCardType=='0'){
  			//磁卡
  			m_SelectCardTypeDR="3";
  			alert(222+"%%%"+document.getElementById('CardTypeDefine').value)
  		}*/
  		//没解决,ind一直是-1,code,rowid都不行,cardtyperowid实际没使用
  		//SetComboValue(combo_CardType,CardTypeRowId);
  		document.getElementById("RCardNo").value=MedicareNumber;
  	}else{
  		alert("读卡失败,请检查卡");
  		return;
  	}
  }
}
function SetCardNOLength(){
	var obj=document.getElementById('RCardNo');
		if (obj.value!='') {
			if ((obj.value.length<m_CardNoLength)&&(m_CardNoLength!=0)) {
				for (var i=(m_CardNoLength-obj.value.length-1); i>=0; i--) {
					obj.value="0"+obj.value
				}
			}
			var myCardobj=document.getElementById('CardNo');
			if (myCardobj){
				myCardobj.value=obj.value;
			}
		}
}
function Trim(str)
{
	return str.replace(/[\t\n\r ]/g, "");
}
function CardTypeDefine_OnChange()
{
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR=="")
	{
		return;
	}
	///Read Card Mode
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("RCardNo");
		if (myobj)
		{
			myobj.readOnly = false;
		}
		///DHCWeb_DisBtnA("ReadPCSC");
	}
	else
	{
		var ReloadFlag=document.getElementById("ReloadFlag");
		var vReloadFlag=ReloadFlag.value;
		if ((vReloadFlag!="3")&&(vReloadFlag!="2")){
			var myobj=document.getElementById("RCardNo");
			if (myobj)
			{
				myobj.readOnly = true;
			}
			var obj=document.getElementById("ReadPCSC");
			if (obj){
				obj.disabled=false;
				obj.onclick=ReadHFMagCard_Click;
			}
		}
	}
	
	//Set Focus
	if (myary[16]=="Handle"){
		DHCWeb_setfocus("RCardNo");
	}else{
		DHCWeb_setfocus("ReadPCSC");
	}
	
	m_CardNoLength=myary[17];
}
function ValidateDocumentData()
{
	var myobj=document.getElementById("CardTypeDefine");
	if (myobj){
		myobj.size=1;
		myobj.multiple=false;
	}
		
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
}
document.body.onload = BodyLoadHandler;