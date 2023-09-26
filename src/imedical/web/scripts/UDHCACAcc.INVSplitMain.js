/////UDHCACAcc.INVSplitMain.js

var m_YBConFlag="0";     ////default not Connection YB
var ExeFlag=1;

var m_AbortFlag=0;
var m_RefundFlag=0;
var m_RebillFlag=0
var m_RefRowIDStr=new Array();
var PrtXMLName="";

function BodyLoadHandler()
{
	var obj=document.getElementById("ReceipNO");
	if (obj){
		obj.onkeypress=ReceipNO_OnKeyPress;
	}
	
	var obj=document.getElementById("Abort");
	DHCWeb_DisBtnA("Abort");
	
	var obj=document.getElementById("Refund");
	DHCWeb_DisBtnA("Refund");
	
	DHCWeb_DisBtnA("bSplit");
	
	DHCWeb_DisBtnA("RePrint");
	var obj=document.getElementById("Clear");
	if (obj){
		obj.onclick=Clear_OnClick;
	}
	
	IntDocument();
	DHCWeb_setfocus("ReceipNO");
	
	IntDoc();
	document.onkeydown = DHCWeb_EStopSpaceKey;
	
	var myReloadFlag=DHCWebD_GetObjValue("ReloadFlag");
	if (myReloadFlag=="1"){
		///Load Receipt Info Direct
		event.keyCode=13;
		ReceipNO_OnKeyPress();
		event.keyCode=0;
	}
}

function IntDoc()
{
	
	var mygLoc=session['LOGON.GROUPID'];
	///Load Base Config
	var encmeth=DHCWebD_GetObjValue("GSCFEncrypt");
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth,mygLoc);
	}
	var myary=myrtn.split("^");
	if (myary[0]==0){
		///_"^"_GSRowID_"^"_FootFlag_"^"_RecLocFlag_"^"_PrtINVFlag
		///foot Flag
		////Check Invoice PrtFlag
		mPrtINVFlag=myary[4];
		
		////Get ColPrtXMLName
		var myPrtXMLName=myary[11];
	}
	PrtXMLName=myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt",myPrtXMLName);		///INVPrtFlag
	
	var encmeth=DHCWebD_GetObjValue("ReadOPBaseEncrypt");
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth);
	}
	var myary=myrtn.split("^");
	m_YBConFlag=myary[9];
	
	if (m_YBConFlag=="1"){
		iniInsuForm();
	}
}


function Abort_OnClick()
{
	RefundSaveInfo("A");
}

function Refund_OnClick()
{
	RefundSaveInfo("S");
}

function bSplit_OnClick(){
	AccPayINVSplit();
}

function RePrint_OnClick(){
	
	DHCWeb_DisBtnA("RePrint");
	DHCWeb_DisBtnA("RePrint");
	var myAPIRowID=DHCWebD_GetObjValue("OldAccPayINVRowID");
	if (myAPIRowID!=""){
		BillPrintNew(myAPIRowID);
	}
	var obj=document.getElementById("RePrint");
	if (obj){
		obj.disabled=false;
		obj.onclick=RePrint_OnClick;
	}
}

function Clear_OnClick()
{
	SetACRefundMain();
	///SetACRefOEOrder("");
	SetACRefPayList("");
	////SetACRefOrder("");
}

function ReceipNO_OnKeyPress()
{
	var key=event.keyCode;
	var obj = websys_getSrcElement(e);
	var myReceipNO=DHCWebD_GetObjValue("ReceipNO");
	if ((myReceipNO!="")&&(key==13)) 
	{
		var myUser=session['LOGON.USERID'];
		var encmeth=DHCWebD_GetObjValue("ReadINVByNoEncrypt");
		var myrtn=cspRunServerMethod(encmeth,myReceipNO,myUser)
		var rtn=myrtn.split("^")[0];
		if (rtn!="0")
		{
			alert(t['06']);
			websys_setfocus('ReceipNO');
			return websys_cancel();
		}
		else
		{//
			WrtRefundMain(myrtn);
			var myAPIRowID=DHCWebD_GetObjValue("OldAccPayINVRowID");
			/////Read INVPRT Pay List
			SetACRefPayList(myAPIRowID);
			///SetACRefOEOrder(myAPIRowID);
		}
	}
}

function SetACRefundMain()
{
	var lnk="";
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCACAcc.INVSplitMain";
	RefundMain=parent.frames["UDHCACAcc_INVSplitMain"];
	RefundMain.location.href=lnk;
}

function SetACRefPayList(APIRowID)
{
	var lnk="";
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCACAcc.INVSplitPayList&APIRowID=" + APIRowID;
	var PayList=parent.frames["UDHCACAcc_INVSplitPayList"];
	PayList.location.href=lnk;
}

function SetACRefOEOrder(APIRowID){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCACRefund.OEOrder&APIRowID=" + APIRowID;
	var ACOEList=parent.frames["UDHCACAcc_INVSplitPayList"];
	ACOEList.location.href=lnk;
}

function SetACRefOrder(ReceipRowid)
{
	///ReceipRowid
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.Order&ReceipRowid=" + ReceipRowid;
	var PayOrdList=parent.frames["udhcOPRefund_Order"];
	PayOrdList.location.href=lnk;
}

function IntDocument()
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
	
}

function WrtRefundMain(AccINVInfo)
{
	/// Write Info For Main Form
	
	var myary=AccINVInfo.split("^");
	
	DHCWebD_SetObjValueB("ReceipNO",myary[1]);
	DHCWebD_SetObjValueB("PatientID",myary[2]);
	DHCWebD_SetObjValueB("PatientName",myary[3]);
	DHCWebD_SetObjValueB("PatientSex",myary[4]);
	DHCWebD_SetObjValueB("INVSum",myary[5]);
	var myBtnFlag=myary[6];
	if(myBtnFlag==""){
		myBtnFlag="S";
	}
	///DHCWebD_SetObjValueB("",);
	DHCWebD_SetObjValueB("AccNo",myary[7]);
	DHCWebD_SetObjValueB("AccLeft",myary[8]);
	DHCWebD_SetObjValueB("AccRowID",myary[9]);
	DHCWebD_SetObjValueB("AccStatus",myary[10]);
	var obj=document.getElementById("RefundPayMode");
	if (obj){
		var mylen=obj.options.length;
		for (var i=0;i<mylen;i++){
			var myval=obj.options[i].value;
			var mypayary=myval.split("^");
			///alert(myval);
			if (myary[11]==mypayary[0]){
				obj.options.selectedIndex=i;
				break;
			}
		}
	}
	///DHCWebD_SetObjValueB("RefundPayMode",);			////
	
	DHCWebD_SetObjValueB("YBPaySum",myary[12]);
	DHCWebD_SetObjValueB("AccStatDesc",myary[13]);
	DHCWebD_SetObjValueB("OldAccPayINVRowID",myary[14]);
	DHCWebD_SetObjValueB("PatSelfPay",myary[16]);
	DHCWebD_SetObjValueB("INSDivDR",myary[17]);
	
	DHCWeb_DisBtnA("Abort");
	DHCWeb_DisBtnA("Refund");
	if (myary[15]!="N"){
		DHCWeb_DisBtnA("Abort");
		DHCWeb_DisBtnA("Refund");
		alert(t[myary[15]+"01"]);
		return;
	}
	
	switch(myBtnFlag){
		case "S":
			var obj=document.getElementById("Refund");
			if (obj){
				obj.disabled=false;
				obj.onclick=Refund_OnClick;
			}
			DHCWebD_SetObjValueB("RefundFlag","S");
			ExeFlag=1;
			break;
		case "P":
			var obj=document.getElementById("Abort");
			if (obj){
				obj.disabled=false;
				obj.onclick=Abort_OnClick;
			}
			DHCWebD_SetObjValueB("RefundFlag","A");
			ExeFlag=0;
			break;
		default:
			DHCWeb_DisBtnA("Abort");
			DHCWeb_DisBtnA("Refund");
			ExeFlag=1;
			break;
	}
	var obj=document.getElementById("bSplit");
	if (obj){
		obj.disabled=false;
		obj.onclick=bSplit_OnClick;
	}
	var obj=document.getElementById("RePrint");
	if (obj){
		obj.disabled=false;
		obj.onclick=RePrint_OnClick;
	}
	
}

function EnBtn(myBtnFlag){
	////alert(myBtnFlag);
	switch(myBtnFlag){
		case "S":
			var obj=document.getElementById("Refund");
			if (obj){
				obj.disabled=false;
				obj.onclick=Refund_OnClick;
			}
			break;
		case "A":
			var obj=document.getElementById("Abort");
			if (obj){
				obj.disabled=false;
				obj.onclick=Abort_OnClick;
			}
			break;
		default:
			DHCWeb_DisBtnA("Abort");
			DHCWeb_DisBtnA("Refund");
			break;
	}
}

function RefundSaveInfo(RefundFlag){
	////
	DHCWeb_DisBtnA("Abort");
	DHCWeb_DisBtnA("Refund");
	
	var rtn=CheckRefund(RefundFlag);
	if (rtn==false){
		alert(t["CheckTip"]);
		EnBtn(RefundFlag);
		return rtn;
	}
	
	////return;
	
	var rtn=CardYBPark()
	if (rtn==false){
		return rtn;
	}
	
	var PrtStr=getOrderstr();
	
	////alert(PrtStr);
	////(APIRowID, PRTOrdStr, rUser, sFlag, gloc, ULoadLocDR, RPayModeDR, RefPaySum, ExpStr)
	
	var myAPIRowID=DHCWebD_GetObjValue("OldAccPayINVRowID");
	////PrtStr
	var myUser=session['LOGON.USERID'];
	///RefundFlag
	var gloc=session['LOGON.GROUPID'];
	var myUserLocID=session['LOGON.CTLOCID'];
	var mystr=DHCWeb_GetListBoxValue("RefundPayMode");
	var myary=mystr.split("^");
	var myPayModeDR=myary[0];
	var myRefPaySum=DHCWebD_GetObjValue("RefundSum");
	var myExpStr=""
	
	var encmeth=DHCWebD_GetObjValue("SaveParkDataEncrypt")
	////INVPRTRowid,rUser,sFlag,StopOrdStr,NInvPay,gloc
	if (encmeth!=""){
		var rtnvalue=cspRunServerMethod(encmeth,myAPIRowID,PrtStr,myUser, RefundFlag, gloc, myUserLocID, myPayModeDR, myRefPaySum,m_RebillFlag, myExpStr);
		var myary=rtnvalue.split(String.fromCharCode(2))
		var rtn=myary[0].split("^");
		////alert(rtn);
		if (rtn[0]=='0')
		{
			/////Set CID  for  YB
			DHCWebD_SetObjValueB("CID",myary[2]);
			
			var mystr=YBInsDiv();
			
			BillPrintNew(myary[1]);
			
			var myRefPaySum=DHCWebD_GetObjValue("RefundSum");
			
			alert(mystr+ t['ParkOK']+myRefPaySum+t["ParkYMB"]);		/////alert  return Money
			return true;
		}else{
			alert(rtnvalue);
			switch(rtn[0]){
				case 109:
					alert(t['08']);   ////
				default:
					alert(t['09']);	  /////
			}
			return false;
		}
	}
}

function BillPrintNew(INVstr){
	if (PrtXMLName==""){
		return;
	}
	
	///var myary=INVstr.split(String.fromCharCode(2));
	var INVtmp=INVstr.split("^");
	for (var invi=0;invi<INVtmp.length;invi++)
	{
		if (INVtmp[invi]!=""){
			var beforeprint=document.getElementById('ReadINVDataEncrypt');
			if (beforeprint) {var encmeth=beforeprint.value} else {var encmeth=''};
			
			var PayMode=DHCWebD_GetObjValue("PayMode");
			var Guser=session['LOGON.USERID'];
			var sUserCode=session["LOGON.USERCODE"];
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew", PrtXMLName, INVtmp[invi],sUserCode,PayMode, "");
		}
	}
}

function InvPrintNew(TxtInfo,ListInfo)
{
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
}

function CardYBPark(){
	var myINSDivDR=DHCWebD_GetObjValue("INSDivDR");
	
	if (myINSDivDR==""){
		////Not YB
		return true;
	}
	if ((myINSDivDR!="")&&(m_YBConFlag=="0")){
		alert(t["ReqYBTip"]);			////Require YB Connection
		return false;
	}
	
	var myrtn=QueryYBsysStrik(myINSDivDR);
	
	if (myrtn=="0"){
		return true;
	}else{
		alert(t["YBParErr"]);
		return false;
	}
	
}

function QueryYBsysStrik(myINSDivDR){
	if (insuINSUFlag!="Y"){                  //
		alert("No YB Client!");
		return "-1";
	}
	if (insuDLLFlag!="Y"){                   //
		alert("No Intial");
		return "-1";
	}
	if (insudHandle<=0){                     //
	    alert("dHandle="+insudHandle);
	    return "-1";
	}
	var OutString=""
	OutString=insuDHCINSUBLL.InsuDivideStrik(insudHandle,myINSDivDR);
	
	return OutString;
}

function YBInsDiv(){
	////YB   Decompose
	var myCID=DHCWebD_GetObjValue("CID");
	if (myCID==""){
		return "";
	}
	var myrtn=QueryYBsys(myCID);
	if (myrtn!="0"){
		alert(t["YBParErr"]+myrtn);
		return t["YBParErr"]+myrtn+", ";
	}
	
	var encmeth=DHCWebD_GetObjValue("SaveYBDataEncrypt");
	if (encmeth!=""){
		alert(myCID);
		var myrtn=cspRunServerMethod(encmeth,myCID,"");
		alert(myrtn);
		var myvalue=myrtn.split("^");
		if (myvalue[0]!="0"){
			alert(t["YBPMErr"]+myrtn);
			return t["YBPMErr"]+myrtn+", ";
		}else{
			var myRefundSum=DHCWebD_GetObjValue("RefundSum");
			if (isNaN(myRefundSum)){myRefundSum=0;}
			
			var myYBPay=myvalue[1];
			if (isNaN(myYBPay)){myYBPay=0;}
			
			myRefundSum=parseFloat(myRefundSum)+parseFloat(myYBPay);
			myRefundSum=myRefundSum.toFixed(2);
			DHCWebD_SetObjValueB("RefundSum",myRefundSum);
		}
	}
	
	return "";
}

function QueryYBsys(myCID){
	if (insuINSUFlag!="Y"){                  //
		alert("No YB Client!");
		return "-1";
	}
	if (insuDLLFlag!="Y"){                   //
		alert("No Intial");
		return "-1";
	}
	if (insudHandle<=0){                     //
	    alert("dHandle="+insudHandle);
	    return "-1";
	}
	var OutString=""
	OutString=insuDHCINSUBLL.InsuDivide(insudHandle,myCID);
	
	return OutString;
}


function CheckRefund(RefundFlag){

	var listdoc=parent.frames["UDHCACRefund_OEOrder"].document;
	
	var StopOrderstr="",ToBillOrderstr="";
	
	var objtbl=listdoc.getElementById("tUDHCACRefund_OEOrder");
	var Rows=objtbl.rows.length;
	
	var rtn=false;
	
	for (var j=1; j<Rows; j++)
	{
		////DHCWebD_GetCellValue(obj)
		var excobj=listdoc.getElementById('TExcuteflagz'+j);
		var sExcute=DHCWebD_GetCellValue(excobj);    ////	listdoc.getElementById('TExcuteflagz'+j).innerText;
		if (sExcute==0){AllExecute=0}	//
		var TSelect=listdoc.getElementById("Tselectz"+j);
		var selflag=DHCWebD_GetCellValue(TSelect);
		if (TSelect.checked==true){
			rtn=true;
		}
		
	}
	if (ExeFlag==0){
		rtn=true;
	}
	
	return rtn;
}

function getOrderstr(){
	var listdoc=parent.frames["UDHCACRefund_OEOrder"].document;
	
	var StopOrderstr="",ToBillOrderstr=""
	AllExecute=1
	RebillFlag=0		////
	PartRefFlag=0
	ExeFlag=0			///
	
	m_RefRowIDStr=new Array();
	var myOrdRowIDStr=new Array();
	var myRebillAry=new Array();
	var myRtnPatSum=new Array();
	
	var objtbl=listdoc.getElementById("tUDHCACRefund_OEOrder");
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
			ExeFlag=0;		////
		}		
		var ordobj=listdoc.getElementById('TOrderRowidz'+j);
		var sOrderRowid=DHCWebD_GetCellValue(ordobj);

		var qtyObj=listdoc.getElementById('TOrderQtyz'+j);
		var ordqty=DHCWebD_GetCellValue(qtyObj);		
		
		var myobj=listdoc.getElementById('PRTRowIDz'+j);
		var myprtRowID=DHCWebD_GetCellValue(myobj);
		
		var refqtyObj=listdoc.getElementById('TReturnQtyz'+j);
		var refordqty=DHCWebD_GetCellValue(refqtyObj);
		if (!isNaN(refordqty)&&(PartRefFlag==0)){
			if (refordqty>0){
				PartRefFlag=1;
			}
		}
		
		if (ToBillOrderstr==""){
			ToBillOrderstr=sOrderRowid;
		}
		else{
			ToBillOrderstr=ToBillOrderstr+'^'+sOrderRowid;
		}

		var findflag=false;
		var mylen=m_RefRowIDStr.length;
		for (var myIdx=0;myIdx<mylen;myIdx++){
			if (myprtRowID==m_RefRowIDStr[myIdx]){
				findflag=true;
				break;
			}
		}
		if (!findflag){
			myIdx=mylen;
			myOrdRowIDStr[myIdx]=new Array();
		}
		
		m_RefRowIDStr[myIdx]=myprtRowID;
		if (selflag==false) {
			myRebillAry[myIdx]=1;
			m_RebillFlag=1;
		}
		if ((selflag==true)&&(sExcute=="1")&&(ordqty!=refordqty)) {
			myRebillAry[myIdx]=1;
			m_RebillFlag=1;
		}
		
		var TSelect=listdoc.getElementById("Tselectz"+j);
		if (TSelect.checked==true)
		{
			var myCurlen=myOrdRowIDStr[myIdx].length;
			myOrdRowIDStr[myIdx][myCurlen]=sOrderRowid;
			var obj=listdoc.getElementById('RefSumz'+j);
			var myRefsum=DHCWebD_GetCellValue(obj);
			
			if (isNaN(myRtnPatSum[myIdx])){
				myRtnPatSum[myIdx]=parseFloat(myRefsum);
			}else{
				myRtnPatSum[myIdx]=myRtnPatSum[myIdx]+parseFloat(myRefsum);
			}
			
			if (StopOrderstr==""){StopOrderstr=sOrderRowid;}
			else
			{StopOrderstr=StopOrderstr+"^"+sOrderRowid;}
		}
	}
	
	var mylen=m_RefRowIDStr.length;
	var myary=new Array();
	var mystr="";
	
	for (var i=0;i<mylen;i++){
		if ((isNaN(myRebillAry[i]))||(myRebillAry[i]=="")){
			myRebillAry[i]=0;
		}
		if ((isNaN(myRtnPatSum[i]))||(myRtnPatSum[i]=="")){
			myRtnPatSum[i]=0;
		}
		myRtnPatSum[i]=myRtnPatSum[i].toFixed(2);
		mystr+=myOrdRowIDStr[i].join("^");
		myary[i]=m_RefRowIDStr[i]+ String.fromCharCode(3) + myOrdRowIDStr[i].join("^");
		myary[i]+=String.fromCharCode(3) + myRebillAry[i] ;
		myary[i]+=String.fromCharCode(3) + myRtnPatSum[i];
	}
	
	var myInfo=myary.join(String.fromCharCode(2));
	
	////alert(myInfo);
	return (myInfo);
}

/////***************************************************************************
/////***************************************************************************
////Add Split Invoice

function AccPayINVSplit(){
	//
	DHCWeb_DisBtnA("bSplit");
	
	///Check INV
	var myRefundFlag=DHCWebD_GetObjValue("RefundFlag");
	
	var rtn=CardYBPark()
	if (rtn==false){
		alert(t["YBNotConTip"]);
		return rtn;
	}
	
	///(APIRowID, UserDR, sFlag, PRTRowIDStr, ExpStr)
	var myAPIRowID=DHCWebD_GetObjValue("OldAccPayINVRowID");
	var myUDR=session["LOGON.USERID"];
	var myRefundFlag=DHCWebD_GetObjValue("RefundFlag");
	var mywin=parent.frames["UDHCACAcc_INVSplitPayList"].window;
	var myPRTStr=mywin.BuildSpiltPRTStr();
	
	var myExpStr="";
	var myEncrypt=DHCWebD_GetObjValue("SplitINVEncrypt");
	
	if(myEncrypt!=""){
		var myrtn=cspRunServerMethod(myEncrypt, myAPIRowID, myUDR, myRefundFlag, myPRTStr, myExpStr);
		
		var myary=myrtn.split(String.fromCharCode(2));
		if (myary[0]=="0"){
			DHCWeb_DisBtnA("RePrint");
			BillPrintNew(myary[1]);
			var myINVAry=myary[1].split("^");
			var myINVCount=myINVAry.length-1;
			alert(t["SplitINVOK"]+" " +myINVCount+ " "+t["INVCountTip"]);
		}else{
			alert(t["SplitINVErr"]+" "+myary[0]);
		}
	}
	
}

/////***************************************************************************
/////***************************************************************************



document.body.onload=BodyLoadHandler;
