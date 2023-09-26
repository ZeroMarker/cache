///DHCOPBillOrdDirectListInterface.js
//加载导诊单动态库
//document.write('<OBJECT ID="PrintOrdDirect" CLASSID="CLSID:5CCBCE7E-8BAA-45F5-9C3D-21EB9ACBD331" CODEBASE="../addins/client/PrintOrdDirectPrj.CAB#version=1,0,0,51">');
//document.write('<OBJECT ID="PrintOrdDirect" CLASSID="CLSID:18898D3C-C20E-4DE6-A2C5-E71298B9A7FA" CODEBASE="../addins/client/PrintOrdDirectPrj.CAB#version=1,0,0,100">');
//document.write('</OBJECT>');
//document.write('<OBJECT ID="PrintOrdDirect" CLASSID="CLSID:2FB3029E-7B0D-4592-BD82-0FFAA8E3B8A0" CODEBASE="../addins/client/PrintOrdDirectPrj.CAB#version=1,0,0,113">');
//document.write('</OBJECT>');
//document.write('<OBJECT ID="PrintOrdDirect" CLASSID="CLSID:AD294C03-A423-4157-8080-C94EB8176676" CODEBASE="../addins/client/PrintOrdDirectPrj.CAB#version=1,0,0,113">');
//document.write('</OBJECT>');
//document.write('<OBJECT ID="PrintOrdDirect" CLASSID="CLSID:74615F74-FC91-4F5B-8367-61DDA2EBF5AB" CODEBASE="../addins/client/PrintOrdDirectPrj.CAB#version=1,1,0,113">');
//document.write('</OBJECT>');
//document.write('<OBJECT ID="PrintOrdDirect" CLASSID="CLSID:B6667563-E148-409D-B52A-CC76BA4E484D" CODEBASE="../addins/client/PrintOrdDirectPrj.CAB#version=1,1,0,113">');
//document.write('</OBJECT>');
//document.write('<OBJECT ID="PrintOrdDirect" CLASSID="CLSID:5918B501-D5DB-4F6C-A631-E38910C2253F" CODEBASE="../addins/client/PrintOrdDirectPrj.CAB#version=1,1,0,113">');
//document.write('</OBJECT>');
//document.write('</OBJECT>');
document.write('<OBJECT ID="PrintOrdDirect" CLASSID="CLSID:7FC3394B-4800-43FD-9FDF-63A9C542A282" CODEBASE="../addins/client/PrintOrdDirectPrj.CAB#version=1,1,0,113">');
document.write('</OBJECT>');
///定义分割符
var CH2 = String.fromCharCode(2);
var CH3 = String.fromCharCode(3); //导引单头信息_$c(3)_导引单明细信息
var CH4 = String.fromCharCode(4); //按接收科室是分导引单，一个接受科室一张导引单
var CH5 = String.fromCharCode(5); //按adm分给导引单，根据就诊不同分别打印导引单
var CH6 = String.fromCharCode(6); //分割普通导引单，申请类导引单，其他导引单

///协和打印导诊单
function PrintOrderDriect(InvStr) {
	try {
		var InvAry = InvStr.split("^");
		for (var i = 0; i < InvAry.length; i++) {
			if (InvAry[i] > 0) {
				var Group = session['LOGON.GROUPID'];
				var myExpStr = Group + "^^^";
				var hospdesc = tkMakeServerCall("web.DHCOPBILLOrdDirectList", "GetHospDesc", session['LOGON.CTLOCID']);
				var ordInfo = tkMakeServerCall("web.DHCOPBILLOrdDirectList", "GetDirectListByPrtRowidXH", InvAry[i], myExpStr);
				var title = hospdesc + '导诊单';
				if (ordInfo != "") {
					PrintOrdDirect.PrintOrdDir(ordInfo, title, "REG");
				}
			}
		}
	} catch (e) {
		//alert(e.message);
	}
}

///接口在udhcOPCharge.js中调用，发票打印完成后，自动打印导引单
function IPrintDirectList(prtRowid, ordRowidStr, sFlag) {
	//alert(prtRowid+"**"+ordRowidStr+"**"+sFlag);
	//alert(prtRowid);
	if (prtRowid == "") {
		return;
	}
	var rtn = tkMakeServerCall("web.DHCOPBILLOrdDirectList", "GetPrintInfoByPrtRowid", prtRowid, ordRowidStr, sFlag);
	var tmp1 = rtn.split(CH6); //普通导引单、申请类导引单、其他导引单之间用 $c(6) 分割（普通导引单_$c(6)_申请类导引单_$c(6)_特殊导引单）
	//alert(rtn);
	//普通导引单
	printNDirectList(tmp1[0]);
	//申请类导引单
	printSDirectList(tmp1[1]);
	//其他类型导引单
	//printODirectList(tmp1[2]);
}

///打印普通导引单
function printNDirectList(directList) {
	DHCP_GetXMLConfig("InvPrintEncrypt", "DHCOPBillDirListNormal");
	if (directList == "") {
		return;
	}
	var tmpAdmAry = directList.split(CH5); //普通导引单,按就诊分别打印导诊单
	for (var i = 0; i < tmpAdmAry.length; i++) {
		var tmpRecDepAry = tmpAdmAry[i].split(CH4); //不同就诊科室
		for (var j = 0; j < tmpRecDepAry.length; j++) {
			//printInfoToExcel(tmpRecDepAry[j],"DHCOPBillDirList_Normal.xls","NORMAL");
			printInfoToXML(tmpRecDepAry[j], "DHCOPBillDirListNormal", "NORMAL");
		}
	}
}
///打印申请导引单
function printSDirectList(directList) {
	DHCP_GetXMLConfig("InvPrintEncrypt", "DHCOPBillDirListServer");
	if (directList == "") {
		return;
	}
	var tmpAdmAry = directList.split(CH5); //按就诊分别打印导诊单
	for (var i = 0; i < tmpAdmAry.length; i++) {
		var tmpRecDepAry = tmpAdmAry[i].split(CH4); //不同就诊科室
		for (var j = 0; j < tmpRecDepAry.length; j++) {
			//printInfoToExcel(tmpRecDepAry[j],"DHCOPBillDirList_Server.xls","SEVER");
			printInfoToXML(tmpRecDepAry[j], "DHCOPBillDirListServer", "SEVER");
		}
	}
}

///打印其他导引单
function printODirectList(directList) {
	
}

///打印到Excel
function printInfoToExcel(directListInfo, tempFileName, flag) {
	//alert(directListInfo);
	var xlApp;
	var obook;
	var osheet;
	var xlsheet;
	var xlBook;
	var temp;
	var str;
	var vbdata;
	var i;
	var j;
	var path = tkMakeServerCall("web.UDHCJFTITMP", "getpath");
	var Template = path + tempFileName;
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	var tmpHeadInfoAry = directListInfo.split(CH3)[0].split("^"); //导引单头信息
	var tmpDetailsInfoAry = directListInfo.split(CH3)[1].split("!"); //导引单明细信息
	//填充头信息
	//recDepLoc_"^"_recDepLocPosition_"^"_baseInfo_"^"_admInfo_"^"_totalAmtSum
	//baseInfo=patNo_"^"_medicare_"^"_patName_"^"_sex_"^"_age
	//admInfo=$zd(admDate,3)_"^"_admLoc
	//检验科^^0000186231^^王妍^女^34^2010-06-01^准分子近视治疗中心^81肝功^1^81^81653

	xlsheet.cells(2, 3).value = tmpHeadInfoAry[0]; //接收科室
	xlsheet.cells(2, 6).value = tmpHeadInfoAry[1]; //接收科室位置
	xlsheet.cells(3, 3).value = tmpHeadInfoAry[2]; //登记号
	xlsheet.cells(3, 5).value = tmpHeadInfoAry[4]; //姓名
	xlsheet.cells(3, 7).value = tmpHeadInfoAry[5]; //性别
	xlsheet.cells(3, 9).value = tmpHeadInfoAry[6]; //年龄
	xlsheet.cells(4, 3).value = tmpHeadInfoAry[8]; //就诊科室
	xlsheet.cells(4, 6).value = tmpHeadInfoAry[7]; //就诊日期
	xlsheet.cells(5, 3).value = tmpHeadInfoAry[9]; //总金额

	var curRow = 7;
	if (flag == "SEVER") { //对应申请类医嘱特殊处理
		xlsheet.cells(6, 3).value = tmpHeadInfoAry[10]; //临床症状
		xlsheet.cells(7, 3).value = tmpHeadInfoAry[11]; //临床诊断
		curRow = 9;                                     //改变当前行数
	}
	for (var m = 0; m < tmpDetailsInfoAry.length; m++) {
		var tmpAry = tmpDetailsInfoAry[m].split("^");
		xlsheet.cells(curRow + m, 2).value = tmpAry[0]; //医嘱名称
		xlsheet.cells(curRow + m, 4).value = tmpAry[1]; //数据
		xlsheet.cells(curRow + m, 5).value = tmpAry[2]; //单价
		xlsheet.cells(curRow + m, 6).value = tmpAry[3]; //标本
	}
	xlsSheet.printout(1, xlsSheet.HPageBreaks.count + 1, 1, false, "REG");
	//xlsheet.printout;
	//xlApp.Visible = true;
	//xlsheet.PrintPreview();
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
}

///打印到XML
function printInfoToXML(directListInfo, tempName, flag) {
	//alert(directListInfo);
	//加载XML模板
	//DHCP_GetXMLConfig("InvPrintEncrypt",tempName);
	var tmpHeadInfoAry = directListInfo.split(CH3)[0].split("^");     //导引单头信息
	var tmpDetailsInfoAry = directListInfo.split(CH3)[1].split("!");  //导引单明细信息
	//填充头信息
	//recDepLoc_"^"_recDepLocPosition_"^"_baseInfo_"^"_admInfo_"^"_totalAmtSum
	//baseInfo=patNo_"^"_medicare_"^"_patName_"^"_sex_"^"_age
	//admInfo=$zd(admDate,3)_"^"_admLoc
	//检验科^^0000186231^^王妍^女^34^2010-06-01^准分子近视治疗中心^81肝功^1^81^81653
	var TxtInfo = "RecLocDesc" + CH2 + "接收科室:" + tmpHeadInfoAry[0] + "^" + "RecLocPosition" + CH2 + "位置:" + tmpHeadInfoAry[1] + "^" + "RegNO" + CH2 + "登记号:" + tmpHeadInfoAry[2];
	TxtInfo = TxtInfo + "^" + "PatName" + CH2 + "姓名:" + tmpHeadInfoAry[4] + "^" + "PatSex" + CH2 + "性别:" + tmpHeadInfoAry[5] + "^" + "PatAge" + CH2 + "年龄:" + tmpHeadInfoAry[6];
	TxtInfo = TxtInfo + "^" + "AdmLocDesc" + CH2 + "就诊科室:" + tmpHeadInfoAry[8] + "^" + "AdmDate" + CH2 + "就诊日期:" + tmpHeadInfoAry[7] + "^" + "TotalAmt" + CH2 + "总金额:" + tmpHeadInfoAry[9];
	TxtInfo = TxtInfo + "^" + "invNO" + CH2 + "发票号:" + tmpHeadInfoAry[10] + "^" + "prtUserCode" + CH2 + "收款员:" + tmpHeadInfoAry[11];
	if (flag == "SEVER") { //对应申请类医嘱特殊处理
		TxtInfo = TxtInfo + "^" + "Symptom" + CH2 + "临床症状:" + tmpHeadInfoAry[12] + "^" + "Diagnose" + CH2 + "临床诊断:" + tmpHeadInfoAry[13];
	}
	var ListInfo = "";
	for (var m = 0; m < tmpDetailsInfoAry.length; m++) {
		var tmpAry = tmpDetailsInfoAry[m];
		if (ListInfo === "") {
			ListInfo = tmpAry;
		} else {
			ListInfo = ListInfo + "" + CH2 + tmpAry;
		}
	}
	var myobj = document.getElementById("ClsBillPrint");
	//alert(TxtInfo);
	//alert(ListInfo);
	//DHCP_PrintFun(myobj,TxtInfo,"");
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
}

function GetPrtGuideFlag() {
	var PrtGuideFlag = tkMakeServerCall("web.DHCBillInterface", "GetPrtGuideFlag");
	return PrtGuideFlag;
}
