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
 * ���﷢Ʊ��ӡ(����Ʊ�ݻ���ֽ��Ʊ�ݺ�)
 * @method oppatInvPrint
 * @param {String}
 * @author xubaobao 2020 08 14
 * oppatInvPrint("123#")
 */
function OPPatInvPrint(prtRowIdStr) {
	try {
		var myAry = prtRowIdStr.split("#");
		var prtRowId = myAry[0];
		var rePrtFlag = myAry[1] || "";  //�����ʶ
		var userId =session['LOGON.USERID']		 //jsonObj.PRTUsr;	
		var xmlName = "INVPrtFlag2007";
		getXMLConfig(xmlName);
		//xml��ӡ������������"XMLInvPrint",lodop��ӡ������������"LodopInvPrint"��Ĭ��lodop��ӡ
		var txtInfo = tkMakeServerCall("web.UDHCOPINVPrtIF", "GetOPPrtData", "LodopInvPrint", "INVPrtFlag2007",prtRowId, userId, "", "");
		
		//xmlPrintFun(txtInfo, "");
		
	} catch (e) {
		dhcsys_alert("��ӡ�쳣:" + e.message);
	}
}

//XML��ӡʱ����
function XMLInvPrint(TxtInfo,ListInfo)
{
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
}

//Lodop��ӡʱ����
function LodopInvPrint(TxtInfo,ListInfo)
{
	DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","lodop",{printListByText:true});	
}


/**
 * סԺ��Ʊ��ӡ
 * @method inpatInvPrint
 * @param {String}
 * @author xubaobao 2020 08 14
 * inpatInvPrint("123#")
 */
function IPPatInvPrint(prtRowIdStr) {
	try {
		var myAry = prtRowIdStr.split("#");
		var prtRowId = myAry[0];
		var rePrtFlag = myAry[1] || "";  //�����ʶ
	    var xmlName = "DHCJFIPReceipt";
		getXMLConfig(xmlName);
		var txtInfo = tkMakeServerCall("web.UDHCJFPRINTINV", "GetPrintInfo", prtRowId, "", rePrtFlag);
		//XMLInvPrint(txtInfo, "");		//XML��ӡ
		LodopInvPrint(txtInfo, "");		//Lodop��ӡ��Ĭ�ϲ���Lodop��ӡ
	} catch (e) {
		dhcsys_alert("��ӡ�쳣:" + e.message);
	}
}


/**
 * ���﷢Ʊ��ӡ(����Ʊ�ݻ���ֽ��Ʊ�ݺ�)
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
		dhcsys_alert("��ӡ�쳣:" + e.message);
	}
}


