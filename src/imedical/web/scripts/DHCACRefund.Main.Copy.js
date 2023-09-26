/////UDHCACRefund.Main.Copy.js

var m_YBConFlag="0";     ////default not Connection YB
var ExeFlag=0;

var m_AbortFlag=0;
var m_RefundFlag=0;
var m_RebillFlag=0
var m_RefRowIDStr=new Array();
var m_InsType="";
var PatientID
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
	document.onkeydown=Doc_OnKeyDown;
	//PatientID=document.getElementById("PatientID").value
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
		//iniInsuForm();
	}
}
function OPINVRefund_OnClick()
{
   	var aobj=document.getElementById("Abort");
	if (!aobj.disabled){
		Abort_OnClick();
	}else{
		var robj=document.getElementById("Refund");
		if (!robj.disabled){
			Refund_OnClick();
		}
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

function Clear_OnClick()
{
	SetACRefundMain();
	SetACRefOEOrder("");
	////SetACRefPayList("");
	////SetACRefOrder("");
}

function ReceipNO_OnKeyPress()
{
	var key=event.keyCode;
	var obj = websys_getSrcElement(e);
	var myReceipNO=DHCWebD_GetObjValue("ReceipNO");
	if ((myReceipNO!="")&&(key==13)) 
	{
		var flag=JudgeAccInvNo(myReceipNO)
		if(flag=="0"){return;}
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
            //href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCACRefund.OEOrder.Copy&APIRowID="+myAPIRowID;
		   	//window.open(href,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=700,left=0,top=0')
		    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCACRefund.OEOrder.Copy&APIRowID="+myAPIRowID;
	        var ACOEList=parent.frames["UDHCACRefund_OEOrder_Copy"];
	        ACOEList.location.href=lnk;
		}
	    var CateFeeStr=tkMakeServerCall("web.UDHCJFBaseCommon","GetCateFee",myReceipNO)
	    var obj=document.getElementById("CateFee");
	    if (obj){
		    var CateFee=CateFeeStr.split("&")
		    var CateFeelen=CateFee.length;
		    for(i=0;i<CateFeelen;i++){
                obj.options[i] = new Option(CateFee[i],i);	 
		    }   
        }
	}
}

function SetACRefundMain()
{
	var lnk="";
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCACRefund.Main.Copy";
	//RefundMain=parent.frames["UDHCACRefund_Main"];
	this.location.href=lnk;
}

function SetACRefPayList(APIRowID)
{
	var lnk="";
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCACRefund.PayList&APIRowID=" + APIRowID;
	var PayList=parent.frames["UDHCACRefund_PayList"];
	PayList.location.href=lnk;
}

function SetACRefOEOrder(APIRowID){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCACRefund.OEOrder.Copy&APIRowID=" + APIRowID;
	var ACOEList=parent.frames["UDHCACRefund_OEOrder_Copy"];
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
	DHCWebD_SetObjValueB("RefundSum",myary[16]);
	DHCWebD_SetObjValueB("INSDivDR",myary[17]);
	
	if (myary.length>24)
	{
		m_InsType=myary[24];
		}
	
	DHCWeb_DisBtnA("Abort");
	DHCWeb_DisBtnA("Refund");
	if (myary[15]!="N"){
		DHCWeb_DisBtnA("Abort");
		DHCWeb_DisBtnA("Refund");
		alert(t[myary[15]+"01"]);
		return;
	}
	
	var myVer=DHCWebD_GetObjValue("DHCVersion");
	
	///Check Account Status
	if(myary[10]=="F"){
		///foot 
		DHCWeb_DisBtnA("Abort");
		DHCWeb_DisBtnA("Refund");
		alert(t["AccFootTip"]);
		return;	
	}
	
	switch(myBtnFlag){
		case "S":
			var obj=document.getElementById("Refund");
			if (obj){
				obj.disabled=false;
				obj.onclick=Refund_OnClick;
			}
			if(myVer=="0"){
				ExeFlag=0;
			}else{
				ExeFlag=0;
			}
			break;
		case "P":
			var obj=document.getElementById("Abort");
			if (obj){
				obj.disabled=false;
				obj.onclick=Abort_OnClick;
			}
			ExeFlag=0;
			break;
		default:
			DHCWeb_DisBtnA("Abort");
			DHCWeb_DisBtnA("Refund");
			ExeFlag=1;
			break;
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
	
	//var rtn=CheckRefund(RefundFlag);
	//if (rtn==false){
	//	alert(t["CheckTip"]);
	//	EnBtn(RefundFlag);
	//	return rtn;
	//}
	
	////return;
	
	//var rtn=CardYBPark()
	//if (rtn==false){
	//	return rtn;
	//}

	var PrtStr=getOrderstr();

    var IPAdmRowID=DHCWebD_GetObjValue("IPAdm")
	if (IPAdmRowID=="") 
	{  alert("请选择住院就诊.") 
	   return 
	}
	
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
	var myExpStr=IPAdmRowID+"^^^^^";
	
	var encmeth=DHCWebD_GetObjValue("SaveParkDataEncrypt")
	////INVPRTRowid,rUser,sFlag,StopOrdStr,NInvPay,gloc
	if (encmeth!=""){
		//alert(myAPIRowID+","+PrtStr+","+myUser+","+RefundFlag+","+gloc+","+myUserLocID+","+myPayModeDR+","+myRefPaySum+","+m_RebillFlag+","+myExpStr)
		var rtnvalue=cspRunServerMethod(encmeth,myAPIRowID,PrtStr,myUser, RefundFlag, gloc, myUserLocID, myPayModeDR, myRefPaySum,m_RebillFlag, myExpStr);
		var myary=rtnvalue.split(String.fromCharCode(2))
		var rtn=myary[0].split("^");
		////alert(rtn);
		if (rtn[0]=='0')
		{
			/////Set CID  for  YB
			//DHCWebD_SetObjValueB("CID",myary[2]);
			//var mystr=YBInsDiv();
			//BillPrintNew(myary[1]);
			var myRefPaySum=DHCWebD_GetObjValue("RefundSum");
			alert(mystr+ t['ParkOK']+myRefPaySum+t["ParkYMB"]);		/////alert  return Money
			Clear_OnClick()
			return true;
		}else{
			//alert(rtnvalue);
			switch(rtn[0]){
				case 109:
					alert(t['08']);   ////
				default:
					alert(t['09']);	  /////
			}
			return false;
		}
	}
	//var obj=document.getElementById("IPAdm");
	//if(obj){
	//	obj.value=null
	//}
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
			//add 2011-04-19 tangtao 青医附院打印两种格式发票
			var datanum=tkMakeServerCall("web.UDHCOPINVPrtData12","JudgePBDetailsByAccInvRowid",INVtmp[invi])
			var datanum=eval(datanum)
			if(datanum==0){
				alert("发票不存在,不能打印当前发票!")
				continue;
			}else if((datanum>0)&&(datanum<=10)){
				PrtXMLName1="INVPrtFlagCPP2011"
			}else{
				PrtXMLName1=PrtXMLName
			}
			DHCP_GetXMLConfig("InvPrintEncrypt",PrtXMLName1);     //重新获取xml信息
			var beforeprint=document.getElementById('ReadINVDataEncrypt');
			if (beforeprint) {var encmeth=beforeprint.value} else {var encmeth=''};
			
			var PayMode=DHCWebD_GetObjValue("PayMode");
			var Guser=session['LOGON.USERID'];
			var sUserCode=session["LOGON.USERCODE"];
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew", PrtXMLName1, INVtmp[invi],sUserCode,PayMode, "");
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
	/*
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
	*/
	var OutString="";
	var insudHandle="0";
	var myUser=session['LOGON.USERID'];
	var ExpStr="";
	var InsuType=m_InsType;
	var CPPFlag="Y";
	//alert("myINSDivDR:"+myINSDivDR+"---InsuType:"+InsuType)
	var AdmSource=tkMakeServerCall("web.UDHCAccPrtPayFoot","GetAdmSourceByInsType",InsuType)
	if(AdmSource==-1){
		alert("费别"+InsuType+"AdmSource为空!不能进行医保结算!")
		return;
	}else{
	     OutString=InsuOPDivideStrike(insudHandle,myUser,myINSDivDR,AdmSource,InsuType,ExpStr,CPPFlag);
	     return OutString;
	}
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
		///alert(myCID);
		var myrtn=cspRunServerMethod(encmeth,myCID,"");
		///alert(myrtn);
		var myvalue=myrtn.split("^");
		if (myvalue[0]!="0"){
			alert(t["YBPMErr"]+myrtn);
			return t["YBPMErr"]+myrtn+", ";
		}else{
			var myRefundSum=DHCWebD_GetObjValue("RefundSum");
			if (isNaN(myRefundSum)){myRefundSum=0;}
			
			var myYBPay=myvalue[1];
			if (isNaN(myYBPay)){myYBPay=0;}
			
			//myRefundSum=parseFloat(myRefundSum)+parseFloat(myYBPay);
			myRefundSum=parseFloat(myRefundSum)-parseFloat(myYBPay);
			myRefundSum=myRefundSum.toFixed(2);
			DHCWebD_SetObjValueB("RefundSum",myRefundSum);
		}
	}
	
	return "";
}

function QueryYBsys(myCID){
	/*
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
	*/
	
	var OutString="";
	var insudHandle="0";
	var myUser=session['LOGON.USERID'];
	var ExpStr="";
	var InsuType=m_InsType;
	var CPPFlag="Y";
	//alert("myINSDivDR:"+myINSDivDR+"---InsuType:"+InsuType)
	
	OutString=InsuDivide(insudHandle,myCID,myUser,ExpStr,InsuType,CPPFlag);
	
	//var OutString=""
	//OutString=insuDHCINSUBLL.InsuDivide(insudHandle,myCID);
	
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
	var listdoc=parent.frames["UDHCACRefund_OEOrder_Copy"].document;
	
	var StopOrderstr="",ToBillOrderstr=""
	AllExecute=1
	RebillFlag=0		////
	PartRefFlag=1
	ExeFlag=1			///
	m_RefRowIDStr=new Array();
	var myOrdRowIDStr=new Array();
	var myRebillAry=new Array();
	var myRtnPatSum=new Array();
	
	var objtbl=listdoc.getElementById("tUDHCACRefund_OEOrder_Copy");
	var Rows=objtbl.rows.length;
	
	for (var j=1; j<Rows; j++)
	{
		//DHCWebD_GetCellValue(obj)
		//var excobj=listdoc.getElementById('TExcuteflagz'+j);
		//var sExcute=DHCWebD_GetCellValue(excobj);    ////	listdoc.getElementById('TExcuteflagz'+j).innerText;
		//if (sExcute==0){AllExecute=0}	//
		var sExcute=1
		var TSelect=listdoc.getElementById("Tselectz"+j);
		var selflag=DHCWebD_GetCellValue(TSelect);
		//if (TSelect.disabled==true){
			//ExeFlag=0;		////
		//}		
		var ordobj=listdoc.getElementById('TOrderRowidz'+j);
		var sOrderRowid=DHCWebD_GetCellValue(ordobj);

		var qtyObj=listdoc.getElementById('TOrderQtyz'+j);
		var ordqty=DHCWebD_GetCellValue(qtyObj);		
		
		var myobj=listdoc.getElementById('PRTRowIDz'+j);
		var myprtRowID=DHCWebD_GetCellValue(myobj);

		//var refqtyObj=listdoc.getElementById('TReturnQtyz'+j);     //急诊转住院不考虑退药数量
		var refqtyObj=listdoc.getElementById('TOrderQtyz'+j);
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
			//var obj=listdoc.getElementById('RefSumz'+j);
			var obj=listdoc.getElementById('TOrderSumz'+j);    //急诊转住院全退，不考虑是否执行、是否审核
	
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
	return (myInfo);
}
function Doc_OnKeyDown()
{
	//118  F7  清屏
	switch (event.keyCode){
		case 118:
            Clear_OnClick();
			break;
	}
}

///add tangtao 2011-06-08
function JudgeAccInvNo(InvNo)
{
	var InvNoOut=tkMakeServerCall("web.UDHCJFBaseCommon","JudgeAccInvPrt",InvNo)
	if (InvNoOut=="-1"){
		alert("发票号不存在!")
		return 0;
	}else if(InvNoOut>0){
		var str=window.confirm("有未执行医嘱,请确认是否继续办理急诊转住院!,若继续办理,该未执行医嘱费用将不计入住院费用!")
		if(str){
			return 1;
		}else{
			return 0;
		}
	}else{
		return 1;
	}
}

document.body.onload=BodyLoadHandler;
