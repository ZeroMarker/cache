/// udhcOPRefundYCCL.js

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
   	var obj=document.getElementById("ReTrade");
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
	//Load Base Config
	var mygLoc=session['LOGON.GROUPID'];
	var encmeth=DHCWebD_GetObjValue("GSCFEncrypt");
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth,mygLoc);
	}
	var myary=myrtn.split("^");
	if (myary[0]==0){
		//_"^"_GSRowID_"^"_FootFlag_"^"_RecLocFlag_"^"_PrtINVFlag
		//foot Flag
		m_AbortPop=myary[7];
		m_RefundPop=myary[8];
		//Get PrtXMLName
		var myPrtXMLName=myary[10];
	}
	
	PrtXMLName=myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt",myPrtXMLName);		//INVPrtFlag	
}

function INVQuery_Click(){
	QueryInv();
}

function ReadCardQuery_OnClick(){
	var myrtn=DHCACC_GetAccInfo();
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0":
			//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			//var obj=document.getElementById("PatientID");
			//obj.value=myary[5];
			ReadCardQueryINV(myary[5]);
			//ReadPatInfo();
			break;
		case "-200":
			alert(t["-200"]);
			break;
		case "-201":
			alert(t["-201"]);
			//var obj=document.getElementById("PatientID");
			//obj.value=myary[5];
			//ReadPatInfo();
			break;
		default:
			//alert("");
	}
}

function ReadPosQuery_OnClick(){
	var myrtn=DHCACC_GetAccInfobyPos();
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0":
			//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			//var obj=document.getElementById("PatientID");
			//obj.value=myary[5];
			ReadCardQueryINV(myary[5]);
			//ReadPatInfo();
			break;
		case "-200":
			alert(t["-200"]);
			break;
		case "-201":
			alert(t["-201"]);
			//var obj=document.getElementById("PatientID");
			//obj.value=myary[5];
			//ReadPatInfo();
			break;
		default:
			//alert("");
	}
}

function ReadCardQueryINV(PAPMNo){
	var mygLocDR=session['LOGON.GROUPID'];
	var myULoadLocDR=session['LOGON.CTLOCID'];
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINVYCCL.Query";
	lnk+="&FramName=udhcOPRefundYCCL&PatientNO="+PAPMNo;
	lnk+="&AuditFlag=A&sFlag=PRT&INVStatus=N";
	lnk+="&gLocDR="+mygLocDR+"&ULoadLocDR="+myULoadLocDR;
	var NewWin=open(lnk,"udhcOPINVYCCL_Query","status=yes,scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function QueryInv()	{
	var mygLocDR=session['LOGON.GROUPID'];
	var myULoadLocDR=session['LOGON.CTLOCID'];
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINVYCCL.Query";
	lnk+="&FramName=udhcOPRefundYCCL";
	lnk+="&AuditFlag=A&sFlag=PRT&INVStatus=N";	
	lnk+="&gLocDR="+mygLocDR+"&ULoadLocDR="+myULoadLocDR;
	var NewWin=open(lnk,"udhcOPINVYCCL_Query","scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function RefundClear_Click()
{
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
		} else {
		   	var IDobj=document.getElementById("ReceipID");
		   	var rptinfoobj=document.getElementById("getReceiptinfo");
		   	if (rptinfoobj) {var encmeth=rptinfoobj.value} else {var encmeth=''};
		   	var rtn=cspRunServerMethod(encmeth,"SetReceipInfo","",IDobj.value);
		   	if(rtn=='-1')  {
			   	DHCWeb_DisBtnA("ReTrade");
			   	alert("此发票不存在！");
			   	return;
			}
	    	if (rtn=='0') {
		    	var reTradeObj = websys_$("ReTrade");
		    	DHCWeb_AvailabilityBtnA(reTradeObj, ReTrade_Click);
				var ReceipID=IDobj.value;
				parent.frames['udhcOPRefundyccl_Order'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefundyccl.Order&ReceipRowid="+ReceipID;
		   	}
		}
	}
}

function ReadINVInfo() {
	//read INV Infomation
	var IDobj=document.getElementById("ReceipID");
	var INVRID=IDobj.value;
	if (INVRID==""){
		return;
	}
	var rptinfoobj=document.getElementById("getReceiptinfo");
	if (rptinfoobj) {var encmeth=rptinfoobj.value} else {var encmeth=''};
	var rtn=cspRunServerMethod(encmeth,'SetReceipInfo','',IDobj.value);
	if (rtn=='0') {
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
	var listdoc=parent.frames["udhcOPRefundyccl_Order"].document;
	
	var StopOrderstr="",ToBillOrderstr="";
	AllExecute=1;
	RebillFlag=0;		////
	PartRefFlag=0;
	ExeFlag=0;			///
	
	var objtbl=listdoc.getElementById('tudhcOPRefundyccl_Order');
	var Rows=objtbl.rows.length;
	
	for (var j=1; j<Rows; j++)
	{
		//DHCWebD_GetCellValue(obj)
		var excobj=listdoc.getElementById('TExcuteflagz'+j);
		var sExcute=DHCWebD_GetCellValue(excobj);    //	listdoc.getElementById('TExcuteflagz'+j).innerText;
		if (sExcute==0){AllExecute=0;}
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
		
		if (selflag==false) {RebillFlag=1;}
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
	
	return (StopOrderstr)
}


function ReTrade_Click(){
	var ReceipRowid=DHCWebD_GetObjValue("ReceipID");
	var encmeth=DHCWebD_GetObjValue('getRefundRcpt');
	var rtnvalue=cspRunServerMethod(encmeth,ReceipRowid);
	var myary=rtnvalue.split(String.fromCharCode(2))
	var rtn=myary[0].split("^");
	//alert(rtnvalue);
	if(rtn[0]=="0"){
		alert(rtn[1]);
		return;
	}else{
		//add tangtao 2011-11-06   软POS
		var mystr=DHCWeb_GetListBoxValue("RefundPayMode");
		var myary1=mystr.split("^");
		var myPayModeDR=myary1[0];
		var handDR=""
	    var CommonObj=document.getElementById("GetPayModeHardComm");
	    if (CommonObj){
			var encmeth=CommonObj.value;
			handDR=cspRunServerMethod(encmeth,"OP",myPayModeDR);
	    }
	    if(handDR!=""){
            //这里需要传出DLL还是WS?从而判断是走平台还是直接调DLL
            var Status=handDR.split("^")[1];
           	if(Status=="DLL"){
	           		//软POS
	           		if(rtn[0]=="-1"){
		            	var WrongCodeObj=document.getElementById("GetPOSWrongCode");
	        			if (WrongCodeObj){
							var encmeth=WrongCodeObj.value;
								roInfo=cspRunServerMethod(encmeth,rtn[1])
								if(roInfo.split("^")[1]>2){
									alert("只能补2次交易,请手工处理")
									return;
								}
	        			}
	            		var retn=POSBankCardPay("R",myPayModeDR,"",Status,rtn[1])
	            	    if(retn!="0"){
		            	    var JudgeWrongInfoObj=document.getElementById("JudgeWrongInfo");
		            	    var WroInfo
	        				if (JudgeWrongInfoObj){
								var encmeth=JudgeWrongInfoObj.value;
									WroInfo=cspRunServerMethod(encmeth,retn)
	        				}
	        				if(WroInfo.split("^")[0]!="F"){
		            	    	alert("错误代码:"+retn+"分属类别:"+WroInfo.split("^")[0]+"错误提示:"+WroInfo.split("^")[1]+",HIS已退费,POS退费失败,请到异常处理页面补交易!")
	        				}else{
		            	    	alert("错误代码:"+retn+"分属类别:"+WroInfo.split("^")[0]+"错误提示:"+WroInfo.split("^")[1]+",请手工处理!")
	        				}
	        				return;
	            	    }
	           		}else if(rtn[0]=="-2"){
		            	var WrongCodeObj=document.getElementById("GetPOSWrongCode");
	        			if (WrongCodeObj){
							var encmeth=WrongCodeObj.value;
								roInfo=cspRunServerMethod(encmeth,rtn[2])
								if(roInfo.split("^")[0]=="1"){
									alert("分属类别为:F,请手工处理")
									return;
								}else{
									if(roInfo.split("^")[1]>2){
										alert("只能补2次交易,请手工处理")
										return;
									}
								}
	        			}
	            	    var retn=POSBankCardPay("D",myPayModeDR,rtn[1],Status,rtn[2])
	            	    if(retn!="0"){
		            	    var JudgeWrongInfoObj=document.getElementById("JudgeWrongInfo");
		            	    var WroInfo
	        				if (JudgeWrongInfoObj){
								var encmeth=JudgeWrongInfoObj.value;
									WroInfo=cspRunServerMethod(encmeth,retn)
	        				}
	        				if(WroInfo.split("^")[0]!="F"){
		            	    	alert("错误代码:"+retn+"分属类别:"+WroInfo.split("^")[0]+"错误提示:"+WroInfo.split("^")[1]+",HIS已退费,POS退费失败,请到异常处理页面补交易!")
	        				}else{
		            	    	alert("错误代码:"+retn+"分属类别:"+WroInfo.split("^")[0]+"错误提示:"+WroInfo.split("^")[1]+",请手工处理!")
	        					}
	        				return;
	            	    }else{
							BillPrintNew("^"+rtn[1]);
							alert("打印票据成功!")
	            	    }
	           		}else if(rtn[0]=="-3"){
		            	var WrongCodeObj=document.getElementById("GetPOSWrongCode");
	        			if (WrongCodeObj){
							var encmeth=WrongCodeObj.value;
								roInfo=cspRunServerMethod(encmeth,rtn[2])
								if(roInfo.split("^")[0]=="1"){
									alert("分属类别为:F,请手工处理")
									return;
								}else{
									if(roInfo.split("^")[1]>2){
										alert("只能补2次交易,请手工处理")
										return;
									}
								}
	        			}
	            		var retn=POSBankCardPay("D",myPayModeDR,rtn[1],Status,rtn[2])
	            	    if(retn!="0"){
		            	    var JudgeWrongInfoObj=document.getElementById("JudgeWrongInfo");
		            	    var WroInfo
	        				if (JudgeWrongInfoObj){
								var encmeth=JudgeWrongInfoObj.value;
									WroInfo=cspRunServerMethod(encmeth,retn)
	        				}
	        				if(WroInfo.split("^")[0]!="F"){
		            	    	alert("错误代码:"+retn+"分属类别:"+WroInfo.split("^")[0]+"错误提示:"+WroInfo.split("^")[1]+",HIS已退费,POS退费失败,请到异常处理页面补交易!")
	        				}else{
		            	    	alert("错误代码:"+retn+"分属类别:"+WroInfo.split("^")[0]+"错误提示:"+WroInfo.split("^")[1]+",请手工处理!")
	        					}
	        				return;
	            	    }else{
							BillPrintNew("^"+rtn[1]);
							alert("打印票据成功!")
	            	    }
	           		}
            	}else{
	           	 	//平台
	           	 	///alert(ReceipRowid+"--"+rtn[2]+"--"+rtn[1])
	            	var retn=BMCOPRefund("","R","26",ReceipRowid,rtn[2],rtn[1])
					if(retn=="0"){
		            	alert("补交易成功")
	            	}
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
	if (mySOrder=="") {
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
		obj.disabled=true
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
	{
		if (m_AbortPop=="1"){
			if(cobj){
				cobj.disabled=false;
				cobj.onclick=Abort_Click;
			}
		}else{
			alert(t["NoAbortPop"]);
		}
	}
   	else
   	{
	   	if (m_RefundPop=="1"){
			if(robj){
				robj.disabled=false;
				robj.onclick=Refund_Click;
			}
	   	}else{
		   	alert(t["NoRefundPop"]);
	   	}
   	}
}

function AddIDToOrder(ReceipID) {
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefundyccl.Order&ReceipRowid="+ReceipID;
	var AdmCharge=parent.frames['udhcOPRefundyccl_Order'];
	AdmCharge.location.href=lnk;
}

function IntRefMain()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefundYCCL";
	var AdmCharge=parent.frames['udhcOPRefundYCCL'];
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
document.body.onload = BodyLoadHandler;
