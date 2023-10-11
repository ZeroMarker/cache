document.write("<script type='text/javascript' src='../scripts/DHCPrtComm.js'></script>");
document.write('<script type="text/javascript" src="../scripts_lib/lodop/LodopFuncs.js" charset="UTF-8"></script>');

function getXMLConfig(CFlag) {
	try {
		PrtAryData.length = 0;
		var PrtConfig = tkMakeServerCall('web.DHCXMLIO', 'ReadXML', 'DHCP_RecConStr', CFlag);
		for (var i = 0; i < PrtAryData.length; i++) {
			PrtAryData[i] = DHCP_TextEncoder(PrtAryData[i]);
		}
	} catch (e) {
		alert(e.message);
		return;
	}
}

/**
 * 门诊发票打印(电子票据换开纸质票据后)
 * @method oppatInvPrint
 * @param {String}
 * @author xubaobao 2020 08 14
 * oppatInvPrint("123#")
 */
function OPPatInvPrint(prtRowIdStr) {
	try {
		var myAry = prtRowIdStr.split("#");
		var prtRowId = myAry[0];
		var rePrtFlag = myAry[1] || "";  //补打标识
		var userId =session['LOGON.USERID']		 //jsonObj.PRTUsr;	
		var xmlName = "INVPrtFlag2007";
		getXMLConfig(xmlName);
		//xml打印第三个参数用"XMLInvPrint",lodop打印第三个参数用"LodopInvPrint"，默认lodop打印
		var txtInfo = tkMakeServerCall("web.UDHCOPINVPrtIF", "GetOPPrtData", "LodopInvPrint", "INVPrtFlag2007",prtRowId, userId, "", "");
		
		//xmlPrintFun(txtInfo, "");
		
	} catch (e) {
		dhcsys_alert("打印异常:" + e.message);
	}
}

//XML打印时调用
function XMLInvPrint(TxtInfo,ListInfo)
{
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
}

//Lodop打印时调用
function LodopInvPrint(TxtInfo,ListInfo)
{
	DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","lodop",{printListByText:true});	
}


/**
 * 住院发票打印
 * @method inpatInvPrint
 * @param {String}
 * @author xubaobao 2020 08 14
 * inpatInvPrint("123#")
 */
function IPPatInvPrint(prtRowIdStr) {
	try {
		var myAry = prtRowIdStr.split("#");
		var prtRowId = myAry[0];
		var rePrtFlag = myAry[1] || "";  //补打标识
	    var xmlName = "DHCJFIPReceipt";
		getXMLConfig(xmlName);
		var txtInfo = tkMakeServerCall("web.UDHCJFPRINTINV", "GetPrintInfo", prtRowId, "", rePrtFlag);
		//XMLInvPrint(txtInfo, "");		//XML打印
		LodopInvPrint(txtInfo, "");		//Lodop打印，默认采用Lodop打印
	} catch (e) {
		dhcsys_alert("打印异常:" + e.message);
	}
}


/**
 * 门诊发票打印(电子票据换开纸质票据后)
 * @method oppatInvPrint
 * @param {String}
 * @author xubaobao 2020 08 14
 * oppatInvPrint("123#")
 */
function Test() {
	try {
			alert(1234)
		var xmlName = "LodopTest";
		getXMLConfig(xmlName);
		var txtInfo = tkMakeServerCall("web.INSUTest", "Test12");
		
		DHC_PrintByLodop(getLodop(),txtInfo,"","","","");
		
	} catch (e) {
		dhcsys_alert("打印异常:" + e.message);
	}
}


