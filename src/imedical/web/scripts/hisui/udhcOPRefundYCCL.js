/// udhcOPRefundYCCL.js

var m_AbortPop = 0;
var m_RefundPop = 0;
var PrtXMLName = "";
var m_YBConFlag = "0";
var listobj = parent.frames["udhcOPRefundyccl_Order"];
var SuccessFlag = "Y";

$(function() {
	init_Layout();
	
	$HUI.combobox('#RefundPayMode',{
		disabled: true,
		url: $URL + '?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array',
		method: 'GET',
		editable: false,
		valueField: 'CTPMRowID',
		textField: 'CTPMDesc',
		onBeforeLoad: function(param) {
			param.GPRowID = session['LOGON.GROUPID'];
			param.HospID = session['LOGON.HOSPID'];
			param.TypeFlag = "FEE";
		}
	});

	IntDoc();
	
	$("#ReceipNO").keydown(function(e) {
		ReceipNO_KeyDown(e);
	});
	disableById("Abort");
	disableById("Refund");
	
	$HUI.linkbutton("#RefClear", {
		onClick: function () {
			RefundClear_Click();
		}
	});
	$HUI.linkbutton("#BtnQuery", {
		onClick: function () {
			INVQuery_Click();
		}
	});
	$HUI.linkbutton("#ReadCardQuery", {
		onClick: function () {
			ReadCardQuery_OnClick();
		}
	});
	$HUI.linkbutton("#ReadPos", {
		onClick: function () {
			ReadPosQuery_OnClick();
		}
	});
		
	$HUI.linkbutton("#ReTrade", {
		onClick: function () {
			ReTrade_Click();
		}
	});
	
	$HUI.linkbutton("#RePrintAcert", {
		onClick: function () {
			RePrintAcert_OnClick();
		}
	});
	
	var encmeth = getValueById("ReadOPBaseEncrypt");
	if (encmeth != ""){
		var myrtn = cspRunServerMethod(encmeth, session['LOGON.HOSPID']);
		var myary = myrtn.split("^");
		m_YBConFlag = myary[12];
	}
	
	focusById("ReceipNO");
});

function IntDoc() {
	//Load Base Config
	var encmeth = getValueById("GSCFEncrypt");
	if (encmeth != "") {
		var myrtn=cspRunServerMethod(encmeth, session['LOGON.GROUPID'], session['LOGON.HOSPID']);
	}
	var myary = myrtn.split("^");
	if (myary[0] == 0){
		//_"^"_GSRowID_"^"_FootFlag_"^"_RecLocFlag_"^"_PrtINVFlag
		//foot Flag
		m_AbortPop = myary[7];
		m_RefundPop = myary[8];
		//Get PrtXMLName
		var myPrtXMLName=myary[10];
	}
	
	PrtXMLName = myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName);
}

function INVQuery_Click() {
	QueryInv();
}

function ReadCardQuery_OnClick() {
	var myrtn = DHCACC_GetAccInfo();
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn){
		case "0":
			//setValueById("PatientID", myary[5]);
			ReadCardQueryINV(myary[5]);
			//ReadPatInfo();
			break;
		case "-200":
			listobj.NoHideAlert(t["-200"]);
			break;
		case "-201":
			listobj.NoHideAlert(t["-201"]);
			//setValueById("PatientID", myary[5]);
			//ReadPatInfo();
			break;
		default:
			//listobj.NoHideAlert("");
	}
}

function ReadPosQuery_OnClick(){
	var myrtn = DHCACC_GetAccInfobyPos();
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn){
		case "0":
			//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			//setValueById("PatientID", myary[5]);
			ReadCardQueryINV(myary[5]);
			//ReadPatInfo();
			break;
		case "-200":
			listobj.NoHideAlert(t["-200"]);
			break;
		case "-201":
			listobj.NoHideAlert(t["-201"]);
			//setValueById("PatientID", myary[5]);
			//ReadPatInfo();
			break;
		default:
			//listobj.NoHideAlert("");
	}
}

function ReadCardQueryINV(PAPMNo){
	var mygLocDR=session['LOGON.GROUPID'];
	var myULoadLocDR=session['LOGON.CTLOCID'];
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPINVYCCL.Query";
	lnk+="&FramName=udhcOPRefundYCCL&PatientNO="+PAPMNo;
	lnk+="&AuditFlag=A&sFlag=PRT&INVStatus=N";
	lnk+="&gLocDR="+mygLocDR+"&ULoadLocDR="+myULoadLocDR;
	var NewWin=open(lnk,"udhcOPINVYCCL_Query","status=yes,scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function QueryInv()	{
	var mygLocDR=session['LOGON.GROUPID'];
	var myULoadLocDR=session['LOGON.CTLOCID'];
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPINVYCCL.Query";
	lnk+="&FramName=udhcOPRefundYCCL";
	lnk+="&AuditFlag=A&sFlag=PRT&INVStatus=N";	
	lnk+="&gLocDR="+mygLocDR+"&ULoadLocDR="+myULoadLocDR;
	var NewWin=open(lnk,"udhcOPINVYCCL_Query","scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function RefundClear_Click() {
	IntRefMain();
	AddIDToOrder("");
}

function ReceipNO_KeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
	   	var ReceipNo = getValueById("ReceipNO");
		if (!ReceipNo) {
			return;
		}
	  	var encmeth = getValueById("getReceipID");
		var rtn = cspRunServerMethod(encmeth, 'SetReceipID', '', ReceipNo,"",session['LOGON.HOSPID']);
		var ReceipID = getValueById("ReceipID");
	  	if (ReceipID == "") {
		  	$("#ReTrade").linkbutton('disable');
			listobj.NoHideAlert(t['06']);
			focusById('ReceipNO');
			return websys_cancel();
		} else {
		   	var ReceipID = getValueById("ReceipID");
		   	var encmeth = getValueById("getReceiptinfo");
		   	var rtn = cspRunServerMethod(encmeth, "SetReceipInfo", "", ReceipID,session['LOGON.HOSPID']);
		   	if (rtn == '-1') {
			   	$("#ReTrade").linkbutton('disable');
			   	listobj.NoHideAlert("此发票不存在！");
			   	return;
			}
	    	if (rtn == '0') {
		    	$("#ReTrade").linkbutton('enable');
				if(SuccessFlag == "Y") {
					parent.frames['udhcOPRefundyccl_Order'].location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPRefundyccl.Order&ReceipRowid="+ReceipID;
				}
		   	}
		}
	}
}

function ReTrade_Click() {
	var ReceipRowid = getValueById("ReceipID");
	var encmeth = getValueById('getRefundRcpt');
	var rtnvalue = cspRunServerMethod(encmeth, ReceipRowid);
	var myary = rtnvalue.split(String.fromCharCode(2));
	var rtn = myary[0].split("^");
	if(rtn[0] == "0") {
		listobj.NoHideAlert(rtn[1]);
		return;
	}else{
		//add tangtao 2011-11-06 软POS
		var mystr = getValueById("RefundPayMode");
		var myary1 = mystr.split("^");
		var myPayModeDR = myary1[0];
		var handDR = "";
	    var encmeth = getValueById("GetPayModeHardComm");
	    if (encmeth) {
			handDR = cspRunServerMethod(encmeth, "OP", myPayModeDR);
	    }
	    if(handDR != "") {
            //这里需要传出DLL还是WS?从而判断是走平台还是直接调DLL
            var Status = handDR.split("^")[1];
           	if (Status == "DLL") {
           		//软POS
           		if(rtn[0] == "-1") {
	           		var roInfo = "";
	            	var encmeth = getValueById("GetPOSWrongCode");
        			if (encmeth){
	        			roInfo = cspRunServerMethod(encmeth, rtn[1]);
						if(roInfo.split("^")[1] > 2) {
							listobj.NoHideAlert("只能补2次交易,请手工处理");
							return;
						}
        			}
            		var retn = POSBankCardPay("R", myPayModeDR,"", Status, rtn[1]);
            	    if (retn != "0") {
	            	    var WroInfo = "";
	            	    var encmeth = getValueById("JudgeWrongInfo");
        				if (encmeth){
							WroInfo = cspRunServerMethod(encmeth, retn);
        				}
        				if(WroInfo.split("^")[0] != "F") {
	            	    	listobj.NoHideAlert("错误代码:"+retn+"分属类别:"+WroInfo.split("^")[0]+"错误提示:"+WroInfo.split("^")[1]+",HIS已退费,POS退费失败,请到异常处理页面补交易!");
        				}else {
	            	    	listobj.NoHideAlert("错误代码:"+retn+"分属类别:"+WroInfo.split("^")[0]+"错误提示:"+WroInfo.split("^")[1]+",请手工处理!");
        				}
        				return;
            	    }
           		}else if(rtn[0] == "-2") {
	           		var roInfo = "";
	            	var encmeth = getValueById("GetPOSWrongCode");
        			if (encmeth){
						roInfo = cspRunServerMethod(encmeth, rtn[2]);
						if(roInfo.split("^")[0]=="1") {
							listobj.NoHideAlert("分属类别为:F,请手工处理");
							return;
						}else {
							if(roInfo.split("^")[1]>2) {
								listobj.NoHideAlert("只能补2次交易,请手工处理");
								return;
							}
						}
        			}
            	    var retn = POSBankCardPay("D", myPayModeDR, rtn[1], Status, rtn[2]);
            	    if(retn != "0") {
	            	   	var WroInfo = "";
	            	    var encmeth = getValueById("JudgeWrongInfo");
        				if (encmeth){
							WroInfo = cspRunServerMethod(encmeth, retn);
        				}
        				if(WroInfo.split("^")[0] != "F"){
	            	    	listobj.NoHideAlert("错误代码:"+retn+"分属类别:"+WroInfo.split("^")[0]+"错误提示:"+WroInfo.split("^")[1]+",HIS已退费,POS退费失败,请到异常处理页面补交易!");
        				}else{
	            	    	listobj.NoHideAlert("错误代码:"+retn+"分属类别:"+WroInfo.split("^")[0]+"错误提示:"+WroInfo.split("^")[1]+",请手工处理!");
        				}
        				return;
            	    }else{
						BillPrintNew("^" + rtn[1]);
						listobj.NoHideAlert("打印票据成功!");
            	    }
           		}else if(rtn[0]=="-3") {
	           		var roInfo = "";
	            	var encmeth = getValueById("GetPOSWrongCode");
        			if (encmeth) {
						roInfo = cspRunServerMethod(encmeth, rtn[2]);
						if(roInfo.split("^")[0] == "1") {
							listobj.NoHideAlert("分属类别为:F,请手工处理");
							return;
						}else {
							if(roInfo.split("^")[1]>2){
								listobj.NoHideAlert("只能补2次交易,请手工处理");
								return;
							}
						}
        			}
            		var retn = POSBankCardPay("D", myPayModeDR, rtn[1], Status, rtn[2]);
            	    if (retn != "0"){
	            		var WroInfo = "";
	            	    var encmeth = getValueById("JudgeWrongInfo");
        				if (encmeth) {
							WroInfo = cspRunServerMethod(encmeth, retn);
        				}
        				if(WroInfo.split("^")[0]!="F") {
	            	    	listobj.NoHideAlert("错误代码:"+retn+"分属类别:"+WroInfo.split("^")[0]+"错误提示:"+WroInfo.split("^")[1]+",HIS已退费,POS退费失败,请到异常处理页面补交易!");
        				}else {
	            	    	listobj.NoHideAlert("错误代码:"+retn+"分属类别:"+WroInfo.split("^")[0]+"错误提示:"+WroInfo.split("^")[1]+",请手工处理!");
        				}
        				return;
            	    }else {
						BillPrintNew("^" + rtn[1]);
						listobj.NoHideAlert("打印票据成功!");
            	    }
           		}
        	}else {
           	 	//平台
            	var retn = BMCOPRefund("","R","26",ReceipRowid,rtn[2], rtn[1]);
				if(retn == "0") {
	            	listobj.NoHideAlert("补交易成功");
            	}
        	}
		}else{
			listobj.NoHideAlert("获取配置失败,该支付方式没有银医卡或者软POS支付配置,不能补交易");
		}
	}
}

function BillPrintNew(INVstr){
	if (PrtXMLName==""){
		return;
	}
	var INVtmp = INVstr.split("^");
	DHCP_GetXMLConfig("InvPrintEncrypt",PrtXMLName);
	for (var invi = 1; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != ""){
			var encmeth = getValueById('getSendtoPrintinfo');
			var PayMode = "";
			var Guser = session['LOGON.USERID'];
			var sUserCode = session["LOGON.USERCODE"];
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew", PrtXMLName, INVtmp[invi], sUserCode, PayMode, "");
		}
	}
}

function InvPrintNew(TxtInfo, ListInfo) {
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, TxtInfo, ListInfo);
}

function SetReceipID(value) {
	try {
		var myAry = value.split('^');
		var ReceipID = myAry[0];
		var sFlag = myAry[1];
		if (sFlag == 'PRT') {
			setValueById("ReceipID", ReceipID);
		}
	} catch(e) {
	}
}

function SetReceipInfo(value) {
	var GUser = session['LOGON.USERID'];
	var Split_Value = value.split("^");
	setValueById("PatientID", Split_Value[0]);
	setValueById("PatientName", Split_Value[1]);
	setValueById("PatientSex", Split_Value[2]);
	setValueById("Sum", parseFloat(Split_Value[3]).toFixed(2));
	setValueById("INSDivDR", Split_Value[13]);
	setValueById("InsType", Split_Value[17]);
	disableById("Abort");
	disableById("Refund");
	if (Split_Value[9] != "") {
		setValueById("RefundPayMode", Split_Value[17]);
	}
	if (((Split_Value[8]!="Y")&&!((Split_Value[6] == GUser)&&(Split_Value[7]=="")))||(Split_Value[14]=="Y")) {
		listobj.NoHideAlert(t['10']);
		focusById('ReceipNO');
		SuccessFlag = "N";
		return websys_cancel();
	}
	
	var myColPFlag = Split_Value[10];
	if (myColPFlag == "1"){
		listobj.NoHideAlert(t["ColPTip"]);
		SuccessFlag = "N";
		focusById('ReceipNO');
		return websys_cancel();		
	}
	
	if (Split_Value[4]=="A") {
		listobj.NoHideAlert(t['11']);
		SuccessFlag="N";
		focusById('ReceipNO');
		return websys_cancel();
	}
	if (Split_Value[5]=="1") {
		listobj.NoHideAlert(t['12']);
		SuccessFlag = "N";
		focusById('ReceipNO');
		return websys_cancel();
	}
	if ((Split_Value[6] == GUser)&&(Split_Value[7] == "")) {
		if (m_AbortPop == "1") {
			enableById("Abort");
		}else{
			listobj.NoHideAlert(t["NoAbortPop"]);
			SuccessFlag = "N";
		}
	} else {
	   	if (m_RefundPop == "1") {
			enableById("Refund");
	   	}else{
		   	listobj.NoHideAlert(t["NoRefundPop"]);
		   	SuccessFlag = "N";
	   	}
   	}
}

function AddIDToOrder(ReceipID) {
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPRefundyccl.Order&ReceipRowid="+ReceipID;
	var AdmCharge=parent.frames['udhcOPRefundyccl_Order'];
	AdmCharge.location.href=lnk;
}

function IntRefMain() {
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPRefundYCCL";
	var AdmCharge=parent.frames['udhcOPRefundYCCL'];
	AdmCharge.location.href=lnk;
}

function RePrintAcert() {
	var IDobj=document.getElementById("ReceipID");
}

function RePrintAcert_OnClick() {
	var UserName = session['LOGON.USERNAME'];
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCOPBillFindBankTrade";
	lnk+="&FramName=udhcOPRefundYCCL";
	lnk+="&UserName=" + UserName;
	var NewWin=open(lnk,"DHCOPBillFindBankTrade","scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function init_Layout(){
	$('#cReceipNO').parent().parent().css("width", "57px");
	DHCWeb_ComponentLayout();
}
