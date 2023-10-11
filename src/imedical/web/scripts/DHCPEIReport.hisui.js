//DHCPEIReport.hisui.js
//功能	个人报告	
//创建	2019.04.02
//创建人  xy
$(function () {
	InitCombobox();

	InitIReportDataGrid();

	//查询
	$("#BFind").click(function () {
		BFind_click();
	});

	//清屏 
	$("#BClear").click(function () {
		BClear_click();
	});

	$("#RegNo").keydown(function (e) {
		if (e.keyCode == 13) {
			RegNoOnChange();
		}
	});
	
	//导出结论
	$("#BExportED").click(function () {
		BExportED_click();
	});
	
	//复查报告
	$("#BFCPrint").click(function () {
		BZYFCPrint("Print");
	});
	
	//复查报告
	$("#BFCPrintView").click(function () {
		BZYFCPrint("View");
	});
	
	Init();
});


function Init() {
	var NewVerReportFlag = tkMakeServerCall("web.DHCPE.HISUICommon", "GetSettingByLoc", session['LOGON.CTLOCID'], "NewVerReport");
	if (NewVerReportFlag == "Lodop") {
		$("#BExport").css('display', 'none');//隐藏 
	} else {
		$("#BExport").css('display', 'block');//显示
	}
}

function RegNoOnChange() {
	var RegNo = $("#RegNo").val();
	if (RegNo != "") {
		var RegNo = $.m({
			"ClassName": "web.DHCPE.DHCPECommon",
			"MethodName": "RegNoMask",
			"RegNo": RegNo
		}, false);

		$("#RegNo").val(RegNo)
	}

	if (RegNo == "") return false;
	BFind_click();
}

//查询
function BFind_click() {
	var iSTatus = ""

	//未审核
	var iSTatusNA = $("#STatusIsNoAudit").checkbox('getValue');
	if (iSTatusNA) { iSTatus = iSTatus + "^" + "NA"; }

	//已审核
	var iSTatusA = $("#STatusIsCheched").checkbox('getValue');
	if (iSTatusA) { iSTatus = iSTatus + "^" + "A"; }

	//已完成
	var iSTatusC = $("#HadCompete").checkbox('getValue');
	if (iSTatusC) { iSTatus = iSTatus + "^" + "C"; }

	//已打印
	var iSTatusP = $("#STatusIsPrint").checkbox('getValue');
	if (iSTatusP) { iSTatus = iSTatus + "^" + "P"; }

	//已取报告
	var iSTatusS = $("#STatusIsSend").checkbox('getValue');
	if (iSTatusS) { iSTatus = iSTatus + "^" + "S"; }

	//是否发送短信
	//var iSTatusS=$("#IsSendMessage").checkbox('getValue');
	//if(iSTatusS) {iSTatus=iSTatus+"^"+"S"; }


	$("#IReportQueryTab").datagrid('load', {
		ClassName: "web.DHCPE.Report",
		QueryName: "SearchIReport",
		RegNo: $("#RegNo").val(),
		PatName: $("#PatName").val(),
		DepartName: $("#DepartName").val(),
		DateFrom: $("#DateFrom").datebox('getValue'),
		DateTo: $("#DateTo").datebox('getValue'),
		AuditDateFrom: $("#AuditDateFrom").datebox('getValue'),
		AuditDateEnd: $("#AuditDateEnd").datebox('getValue'),
		VIPLevel: $("#VIPLevel").combobox('getValue'),
		GroupID: $("#GroupName").combogrid('getValue'),
		TeamID: $("#TeamName").combogrid('getValue'),
		IsSecret: IsSecret,
		DocDR: $("#DocName").combogrid('getValue'),
		ReportStatus: iSTatus,
		HospID: session['LOGON.HOSPID']
	});
}

//清屏 
function BClear_click() {
	$("#RegNo,#PatName,#DepartName").val("");
	$(".hisui-combobox").combobox('setValue', "");
	$(".hisui-combogrid").combogrid('setValue', "");
	$(".hisui-checkbox").checkbox('setValue', false);
	$("#DateFrom,#DateTo,#AuditDateFrom,#AuditDateEnd").datebox('setValue', "")
	InitCombobox();
	BFind_click();
}

//导出结论
function BExportED_cmdshell() {
	var iPAADMDRStr = ""
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//获取的是数组，多行数据
	for (var i = 0; i < selectrow.length; i++) {

		var iPAADMDR = selectrow[i].RPT_PAADM_DR;
		if (iPAADMDRStr = "") { iPAADMDRStr = iPAADMDR; }
		else { iPAADMDRStr = iPAADMDRStr + "^" + iPAADMDR; }

	}

	if (iPAADMDRStr == "") {
		$.messager.alert("提示", "请选择待导出结论的人员", "info");
		return false;
	}
	
	var wdCharacter = 1;
	var Str = "(function test(x){" +
		"var WordApp=new ActiveXObject('Word.Application'); " +

		"var wdOrientLandscape = 1;" +
		"WordApp.Application.Visible=true;" + //执行完成之后是否弹出已经生成的word 
		"var myDoc=WordApp.Documents.Add();" +//创建新的空文档 
		//WordApp.ActiveDocument.PageSetup.Orientation = wdOrientLandscape//页面方向设置为横向 
		"WordApp.Selection.ParagraphFormat.Alignment=0;" + //1居中对齐,0为居右 
		"WordApp.Selection.Font.Bold=false;" +
		"WordApp.Selection.Font.Size=20;" +
		"WordApp.Selection.TypeText('建议结果汇总');" +
		"WordApp.Selection.MoveRight(" + wdCharacter + ");" +　　　　//光标右移字符 
		"WordApp.Selection.TypeParagraph();" + //插入段落 
		"WordApp.Selection.Font.Size=8;" +
		"WordApp.Selection.TypeParagraph();" + //插入段落 
		"var myTable=myDoc.Tables.Add(WordApp.Selection.Range,1,3);" + //1行7列的表格 
		"myTable.Style='网格型';" +
		//设置列宽
		"myTable.Columns(1).Width=45;" +
		"myTable.Columns(2).Width=35;" +
		"myTable.Columns(3).Width=380;" +
		//输出表头信息
		"myTable.Cell(1,1).Range.Text ='ID号';" +
		"myTable.Cell(1,2).Range.Text ='姓名';" +
		"myTable.Cell(1,3).Range.Text ='建议';";
	var appendStr = "";
	var iPAADMDR = "", RegNo = "", Name = "";
	var Row = 1;
	for (var i = 0; i < selectrow.length; i++) {

		var iPAADMDR = selectrow[i].RPT_PAADM_DR;
		var Info = tkMakeServerCall("web.DHCPE.ReportGetInfor", "GetGeneralAdviceByAdmJS", iPAADMDR);
		appendStr = "myTable.Rows.add();";//新增行
		Row = Row + 1;
		appendStr = appendStr + "myTable.Cell(" + Row + ",3).Range.Text='" + Info + "';";
		RegNo = selectrow[i].RPT_RegNo;
		appendStr = appendStr + "myTable.Cell(" + Row + ",1).Range.Text='" + RegNo + "';";;
		Name = selectrow[i].RPT_IADM_DR_Name;
		appendStr = appendStr + "myTable.Cell(" + Row + ",2).Range.Text='" + Name + "';";;

	}
	Str = Str + appendStr + "return 1;}());";
	CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
}

//导出结论
function BExportED_click() {
	if (EnableLocalWeb == 1) {
		return BExportED_cmdshell();
	}
	var iPAADMDRStr = ""
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//获取的是数组，多行数据
	for (var i = 0; i < selectrow.length; i++) {

		var iPAADMDR = selectrow[i].RPT_PAADM_DR;
		if (iPAADMDRStr = "") { iPAADMDRStr = iPAADMDR; }
		else { iPAADMDRStr = iPAADMDRStr + "^" + iPAADMDR; }

	}

	if (iPAADMDRStr == "") {
		$.messager.alert("提示", "请选择待导出结论的人员", "info");
		return false;
	}
	
	var WordApp = new ActiveXObject("Word.Application");
	var wdCharacter = 1
	var wdOrientLandscape = 1
	WordApp.Application.Visible = true; //执行完成之后是否弹出已经生成的word 
	var myDoc = WordApp.Documents.Add();//创建新的空文档 
	//WordApp.ActiveDocument.PageSetup.Orientation = wdOrientLandscape//页面方向设置为横向 
	WordApp.Selection.ParagraphFormat.Alignment = 0 //1居中对齐,0为居右 
	WordApp.Selection.Font.Bold = false;
	WordApp.Selection.Font.Size = 20
	WordApp.Selection.TypeText("建议结果汇总");
	WordApp.Selection.MoveRight(wdCharacter);　　　　//光标右移字符 
	WordApp.Selection.TypeParagraph() //插入段落 
	WordApp.Selection.Font.Size = 8
	WordApp.Selection.TypeParagraph() //插入段落 
	var myTable = myDoc.Tables.Add(WordApp.Selection.Range, 1, 3) //1行7列的表格 
	myTable.Style = "网格型"
	var TableRange;
	//设置列宽
	myTable.Columns(1).Width = 45;
	myTable.Columns(2).Width = 35;
	myTable.Columns(3).Width = 380;
	//输出表头信息
	myTable.Cell(1, 1).Range.Text = "ID号";
	myTable.Cell(1, 2).Range.Text = "姓名";
	myTable.Cell(1, 3).Range.Text = "建议";

	var iPAADMDR = "", RegNo = "", Name = "";
	var Row = 1;
	for (var i = 0; i < selectrow.length; i++) {

		var iPAADMDR = selectrow[i].RPT_PAADM_DR;
		var Info = tkMakeServerCall("web.DHCPE.ReportGetInfor", "GetGeneralAdviceByAdm", iPAADMDR);
		myTable.Rows.add();//新增行
		Row = Row + 1;
		myTable.Cell(Row, 3).Range.Text = Info;
		RegNo = selectrow[i].RPT_RegNo;
		myTable.Cell(Row, 1).Range.Text = RegNo;
		Name = selectrow[i].RPT_IADM_DR_Name;
		myTable.Cell(Row, 2).Range.Text = Name;

	}
}

function BPrintViewLodop(e) {
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//获取的是数组，多行数据
	for (var i = 0; i < selectrow.length; i++) {
		var iPAADMDR = selectrow[i].RPT_PAADM_DR;
		var printerName = tkMakeServerCall("web.DHCPE.Report", "GetVirtualPrinter");
		if (e.id == "BPrint") {//打印报告
			PEPrintReport("P", iPAADMDR, printerName);
		} else if (e.id == "BPrintView") {//打印预览
			PEPrintReport("V", iPAADMDR, printerName);
		} else if (e.id == "BPrintYGReport") {  // 乙肝报告
			var YGItemFlag = tkMakeServerCall("web.DHCPE.ResultDiagnosis", "GetYGItemFlag", iPAADMDR, "PAADM");
			if (YGItemFlag != "3") {
				if (YGItemFlag == "0") $.messager.alert("提示", "无乙肝项目！", "info");
				else if (YGItemFlag == "2") $.messager.alert("提示", "乙肝项目已弃检！", "info");
				else $.messager.alert("提示", "乙肝项目无结果！", "info");
				return false;
			}
			PEPrintReport("P", iPAADMDR, printerName, "YGBG");
		} else {//导出报告
			PEPrintReport("E", iPAADMDR, printerName);
		}
	}

	return false;
}

function BPrintViewLodopNew(sourceID, jarPAADM) {
	var printerName = tkMakeServerCall("web.DHCPE.Report", "GetVirtualPrinter");
	var paadmArr = jarPAADM.split("#");
	for (var i = 0; i < paadmArr.length; i++) {
		var iPAADMDR = paadmArr[i];
		if (sourceID == "BPrint") {//打印报告
			PEPrintReport("P", iPAADMDR, printerName, "");
		} else if (sourceID == "BPrintView") {//打印预览
			PEPrintReport("V", iPAADMDR, printerName, "");
		} else if (sourceID == "BPrintYGReport") {  // 乙肝报告
			var YGItemFlag = tkMakeServerCall("web.DHCPE.ResultDiagnosis", "GetYGItemFlag", iPAADMDR, "PAADM");

			if (YGItemFlag != "3") {
				if (YGItemFlag == "0") $.messager.alert("提示", "无乙肝项目！", "info");
				else if (YGItemFlag == "2") $.messager.alert("提示", "乙肝项目已弃检！", "info");
				else $.messager.alert("提示", "乙肝项目无结果！", "info");
				return false;
			}
			PEPrintReport("P", iPAADMDR, printerName, "YGBG");
		} else {//导出报告
			PEPrintReport("E", iPAADMDR, printerName, "");
		}
	}

	return false;
}

function BPrintView(e) {
    var LocID=session['LOGON.CTLOCID'];
	var MainDoctorGroup=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",LocID,"MainDoctorGroup"); //是否复检

	var iPAADMStr = "", jarPAADM = "", statusStr = "";
	var IRowIdArr = new Array();
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//获取的是数组，多行数据
	for (var i = 0; i < selectrow.length; i++) {

		var iReportStatus = selectrow[i].RPT_Status_Name; //报告状态
		if(e.id=="BPrint"){
			if(MainDoctorGroup=="Y"){
				if((iReportStatus=="未初检")||(iReportStatus=="已初检未复检")) continue;
			}else{
				if (iReportStatus=="未初检") continue;
			}
		}

		var iPAADMDR = selectrow[i].RPT_PAADM_DR;
		IRowIdArr.push(iPAADMDR);
		var Template = tkMakeServerCall("web.DHCPE.Report", "GetTemplateName", iPAADMDR);
		if (Template != "") {
			if (iPAADMStr == "") { iPAADMStr = iPAADMDR + ";" + Template; }
			else { iPAADMStr = iPAADMStr + "^" + iPAADMDR + ";" + Template; }
		} else {
			if (jarPAADM == "") jarPAADM = iPAADMDR;
			else jarPAADM = jarPAADM + "#" + iPAADMDR;
		}
	}

	if (IRowIdArr.length == 0) {
		$.messager.alert("提示", "请选择待打印报告", "info");
		return false;
	}
	
	/*
	if (statusStr.indexOf("未") > 0) {
		$.messager.alert("提示", "未初检，请核实报告状态", "info");
		return false;
	}
	*/

	if (e.id == "BPrintView" && IRowIdArr.length > 1) {
		$.messager.alert("提示", "不可批量预览，请重新选择！", "info");
		return false;
	}
	var NewVerReportFlag = tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",LocID,"NewVerReport");
	if (jarPAADM != "") {
		if (NewVerReportFlag == "Word") {
			websocoket_report(e.id, jarPAADM);
		} else if (NewVerReportFlag == "Lodop") {
			BPrintViewLodopNew(e.id, jarPAADM);
		} else {
			$.messager.alert("提示", "无对应打印格式，请前往体检配置中维护！", "info");
			return false;
		}
	}
	if (iPAADMStr != "") {
		PrintTemplateReport(e.id, iPAADMStr);
	}

	return false;

	var iPAADMStr = "", iRowID = "", jarPAADM = "", statusStr = "";
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//获取的是数组，多行数据
	for (var i = 0; i < selectrow.length; i++) {
		var iPAADMDR = selectrow[i].RPT_PAADM_DR;
		if (jarPAADM == "") jarPAADM = iPAADMDR;
		else jarPAADM = jarPAADM + "#" + iPAADMDR;
		var Template = tkMakeServerCall("web.DHCPE.Report", "GetTemplateName", iPAADMDR);
		if (Template != "") {
			if (iPAADMStr == "") { iPAADMStr = iPAADMDR + ";" + Template; }
			else { iPAADMStr = iPAADMStr + "^" + iPAADMDR + ";" + Template; }
		} else {
			var RowID = selectrow[i].RPT_RowId;
			if (iRowID == "") { iRowID = RowID; }
			else { iRowID = iRowID + "^" + RowID; }
		}

	}
	
	var NewVerReportFlag = tkMakeServerCall("web.DHCPE.HISUICommon", "GetSettingByLoc", LocID, "NewVerReport");
	
	if (NewVerReportFlag == "Word") {

		if (e.id == "BExport" || e.id == "BPrint" || e.id == "BExportPDF" || e.id == "NoCoverPrint" || e.id == "BExportHtml" || e.id == "BPrintView") {
			if (jarPAADM == "") {
				$.messager.alert("提示", "请选择待打印报告", "info");
			} else if (statusStr.indexOf("未") > 0) {
				$.messager.alert("提示", "未初检，请核实报告状态", "info");
			} else if (e.id == "BPrintView" && jarPAADM.split("#").length > 1) {
				$.messager.alert("提示", "不可批量预览，请重新选择！", "info");

			} else {
				websocoket_report(e.id, jarPAADM);
			}
			return false;
		} else if (e.id == "BPrintYGReport") {  // 乙肝报告只打印CSP模板
			BPrintViewLodop(e);
		}

	} else if (NewVerReportFlag == "Lodop") {
		BPrintViewLodop(e);

	} else {

		if ((iRowID != "") || (iPAADMStr != "")) {
			//alert(iRowID+"  @@iPAADMStr"+iPAADMStr);
			ShowPrintWindows(iRowID, iPAADMStr, e);
		} else {
			$.messager.alert("提示", "请选择待打印报告！", "info");
		}
	}
	return false;
}

/**
 * [websocket 客户端通信]
 * @param    {[Date]}    date [日期]
 * @return   {[String]}         [格式化的日期]
 * @Author   wangguoying
 * @DateTime 2021-01-28
 */
function websocoket_report(sourceID, jarPAADM) {
	var opType = (sourceID == "BPrint" || sourceID == "NoCoverPrint" || sourceID == "BPrintYGReport") ? "2" : (sourceID == "BPrintView" ? "5" : (sourceID == "BUploadReport" ? "4" : "1"));
	var fileType = (sourceID == "BExportPDF") || (sourceID == "BUploadReport") ? "pdf" : (sourceID == "BExportHtml" ? "html" : "word");
	var method = (sourceID== "BPrintYGReport") ? "-New" : "";
	
	var execParam = {
		business: "REPORT", //报告固定为REPORT
		admId: jarPAADM,
		opType: opType,
		fileType: fileType,
		printType: "1" + method  //1为个人报告
	};

	//打印预览——增加水印
	if(execParam.opType == "2") execParam.extStr="HS10322,"+session["LOGON.USERID"];
	if(execParam.opType == "5") execParam.extStr="WaterMark:PreView";

	var json = JSON.stringify(execParam);
	$PESocket.sendMsg(json, peSoceket_onMsg);
}


/**
 * [websocket 客户端通信回调函数]
 * @param    {[String]}    param [客户端接收到的 json串]
 * @return   {[Object]}    event [客户端返回的信息内容]
 * @Author   wangguoying
 * @DateTime 2021-01-28
 */
function peSoceket_onMsg(param, event) {
	var paramObj = JSON.parse(param);
	var FileName = paramObj.files;
	var retObj = JSON.parse(event.data);
	if (retObj.code == "0") {
		
	} else {
		$.messager.alert("提示", "<br><span style='color:red;font-weight:600;'>执行失败，详情请查询日志</span>", "info");
	}
}

//外部协议打开体检报告程序 
function calPEReportProtocol(sourceID, jarPAADM) {
	var opType = (sourceID == "BPrint" || sourceID == "NoCoverPrint") ? "2" : (sourceID == "BPrintView" ? "5" : "1");
	if (opType == "2") {
		jarPAADM = jarPAADM + "@" + session['LOGON.USERID'];
	}
	var saveType = sourceID == "BExportPDF" ? "pdf" : (sourceID == "BExportHtml" ? "html" : "word");
	var printType = sourceID == "NoCoverPrint" ? "2" : "1";
	location.href = "PEReport://" + jarPAADM + ":" + opType + ":" + saveType + ":" + printType
}

function PrintTemplateReport(sourceID, PAADMs) {
	if (sourceID == "BPrintView") {

	} else if (sourceID == "BExportPDF") {

	} else {

	}

	var PAADMsArr = PAADMs.split("^");
	for (var i = 0; i < PAADMsArr.length; i++) {
		var PaadmStr = PAADMsArr[i];
		if (PaadmStr == "") continue;
		var Paadm = PaadmStr.split(";")[0];
		var Template = PaadmStr.split(";")[1];
		if (Template.indexOf(".xls") > 0) {
			var Data = $cm({
				ClassNethod: "web.DHCPE.ReportGetInfor",
				MethodName: "TableReportInfo",  //"TableDataTest"
				paadm: Paadm
			}, false);
			if (Object.keys(Data).length <= 0) continue;
			if (("undefined" == typeof EnableLocalWeb) || (0 == EnableLocalWeb)) PrintReportExcel(Data, Template);
			else PrintReportExcelCMD(Data, Template);
		} else if (Template.indexOf(".doc") > 0) {
			var Data = $cm({
				ClassNethod: "web.DHCPE.ReportGetInfor",
				MethodName: "TableDataTest"  // TableReportInfo, paadm:Paadm
			}, false);
			if (Object.keys(Data).length <= 0) continue;
			if (("undefined" == typeof EnableLocalWeb) || (0 == EnableLocalWeb)) PrintReportWord(Data, Template, "", "");
			else PrintReportWordCMD(Data, Template);
		} else if (Template.indexOf(".ftl") > 0) {
			websocoket_report(sourceID, Paadm);
		} else if (Template.indexOf(".csp") > 0) {

		}
	}
}

// Excel 打印
function PrintReportExcel(ReportData, Template) {
	var obj = document.getElementById("prnpath");
	if (obj && "" != obj.value) {
		var prnpath = obj.value;
		var prnpath = "D:\\DHCPE\\";
		var Templatefilepath = prnpath + Template;
	} else {
		alert("无效模板路径");
		return;
	}

	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	//xlsheet = xlBook.WorkSheets("Sheet1");
	xlsheet = xlBook.ActiveSheet;

	var ReportDataJson = eval('(' + ReportData + ')');

	var nameSize = xlBook.Names.Count;
	for (var ii = 1; ii <= nameSize; ii++) {
		var key = xlBook.Names(ii).Name;
		if (key != "") {
			xlsheet.Range(key).value = ReportDataJson[key];
		}
	}

	xlsheet.printout;
	xlBook.Close(savechanges = false);
	xlApp = null;
	xlsheet = null;
}

// Excel 打印
function PrintReportExcelCMD(Type, ReportData, Template) {
	try {
		var prnpath = tkMakeServerCall("web.DHCPE.Report.MonthStatistic", "getpath");
		var Templatefilepath = prnpath + Template;

		var Str = "(function test(x){"
			+ "var xlApp=new ActiveXObject('Excel.Application');"
			+ "var xlBook=xlApp.Workbooks.Add('" + Templatefilepath + "');"
			+ "var xlsheet=xlBook.ActiveSheet;"
			;

		Str = Str + "var ReportDataJson = eval('(" + ReportData + ")');";

		Str = Str + "var nameSize = xlBook.Names.Count;";
		Str = Str + "for (var ii = 1; ii <= nameSize; ii++) {";
		Str = Str + "var key = xlBook.Names(ii).Name;";
		Str = Str + "if (key != '') {";
		Str = Str + "xlsheet.Range(key).value = ReportDataJson[key];";
		Str = Str + "}";
		Str = Str + "}";

		//		for (var key in ReportDataJson) {
		//			Str = Str + "xlsheet.Range('" + key + "').value='" + ReportDataJson[key] + "';";
		//		}

		if (Type == "View") {
			Str = Str
				+ "xlApp.UserControl=true;"
				+ "xlApp.Visible=true;"
				//+ "xlsheet.PrintPreview;"
				//+ "xlBook.Close(false);"
				+ "xlApp=null;"
				+ "xlsheet=null;"
				;

		} else {
			Str = Str
				+ "xlsheet.printout;"
				+ "xlBook.Close(savechanges=false);"
				+ "xlApp=null;"
				+ "xlsheet=null;"
				+ "CollectGarbage();"
				;
		}
		Str = Str
			+ "return 1;"
			+ "}());"
			;
		console.log(Str);
		//以上为拼接Excel打印代码为字符串
		CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序
		if (rtn.status == 500) {
			$.messager.alert("提示", "错误：错误为 " + rtn.msg, "info");  // {status: 500,  "处理请求异常:未结束的字符串常量", rtn: ""}
		}
		return;
	} catch (e) {
		$.messager.alert("提示", "错误：错误为" + e.message, "info");
		return false;
	}
}

// word 打印
function PrintReportWord(ReportData, Template, LisData, RisData) {
	var obj = document.getElementById("prnpath")
	if (obj && "" != obj.value) {
		var prnpath = obj.value;
		var Templatefilepath = prnpath + Template;
	} else {
		var prnpath = tkMakeServerCall("web.DHCPE.Report.MonthStatistic", "getpath");
		var Templatefilepath = prnpath + Template;

	}

	Templatefilepath = "C:\\Users\\Dr.cheng\\Desktop\\test.doc";

	//alert("无效模板路径");
	//return;
	try {
		var word = new ActiveXObject("Word.Application");
		if (!word) {
			alert("word生成失败");
			return;
		}
		word.visible = false;
		myDoc = word.Documents.open(Templatefilepath);
		if (!myDoc) {
			alert("地址出现错误");
			return;
		}

		var ReportDataJson = eval('(' + ReportData + ')');
		var LisDataJson = eval('(' + LisData + ')');
		var RisDataJson = eval('(' + RisData + ')');

		var range = null;
		for (var key in ReportDataJson) {
			try {
				range = myDoc.Bookmarks(key).Range;
				range.InsertBefore(ReportDataJson[key]); //书签后插入内容
			} catch (e) {

			}
		}
		
		// 检验结果 表格

		// 循环项目
		$.each(LisDataJson["ItemInfo"], function (i, itemJson) {

			if (i == 0) {  // 增加分页符
				range = myDoc.Sections(1).Range;
				range.Collapse(Direction = 0);
				range.insertBreak(7);
			}

			// 项目名
			range = myDoc.Sections(1).Range;
			range.Collapse(Direction = 0);
			range.InsertAfter(itemJson.Desc);

			// 表头 + 细项行
			range.Collapse(Direction = 0);
			range.InsertParagraphAfter();

			var lisTotalRows = 1 + itemJson.OrdDetailNum;
			var lisTotalCols = 7;
			var lisTableHead = new Array("序号", "项目名称", "英文名", "检查结果", "提示", "参考范围", "单位");
			var lisTableList = new Array("Sort", "ItemDesc", "CTTCSynonym", "Result", "Arrow", "TestStandard", "Unit");
			var lisTabColWid = new Array(35, 120, 60, 70, 35, 85, 90);

			var lisTab = myDoc.Tables.Add(range, lisTotalRows, lisTotalCols);
			lisTab.Borders(1).LineStyle = 1;
			lisTab.Borders(1).LineWidth = 2;

			for (var lisRow = 1; lisRow <= lisTotalRows; lisRow++) {
				for (var lisCol = 1; lisCol <= lisTotalCols; lisCol++) {
					if (lisRow == 1) {	// 表头
						lisTab.Cell(lisRow, lisCol).Range.Text = lisTableHead[lisCol - 1];
						lisTab.Columns(lisCol).SetWidth(lisTabColWid[lisCol - 1], 0);  // 设置宽度
					} else {
						lisTab.Cell(lisRow, lisCol).Range.Text = itemJson["OrdDetail"][lisRow - 2][lisTableList[lisCol - 1]];
					}
				}
			}

			// 医生行
			range = myDoc.Sections(1).Range;
			range.Collapse(Direction = 0);
			//range.ParagraphFormat.Alignment = 2;  // 0 left  1 center  2 right
			range.InsertAfter("        录入者：" + itemJson.Checker + "        审核者：" + itemJson.Auditer + "        检查日期：" + itemJson.CheckDate);

			// 空行
			range = myDoc.Sections(1).Range;
			range.Collapse(Direction = 0);
			range.InsertParagraphAfter();
			myDoc.Tables.Add(range, 1, 1);
		});
		
		word.Application.Printout();  // 打印  PrintPreview

		//alert("打印完成");
	} catch (e) {
		setTimeout("CollectGarbage();", 10);
		alert(e);
	} finally {
		myDoc.Close(savechanges = false);
		word.quit();
		word = null;
	}
}

//旧版打印报告
function ShowPrintWindows(iRowID, iPAADMStr, e) {
	var iPAADMDR = '', iPAPMIDR = "", iReportID = "", iprnpath = "", VipReturn = "1", IsSendMessage = "N"
	//alert(e.id)
	obj = document.getElementById("PAADMDR");
	if (obj) { iPAADMDR = obj.value; }
	obj = document.getElementById("PAPMIDR");
	if (obj) { iPAPMIDR = obj.value; }
	obj = document.getElementById("GetIReportStatus");
	if (obj) var encmeth = obj.value;

	obj = document.getElementById("IsSendMessage");
	if (obj && obj.checked) IsSendMessage = "Y";

	var flag = cspRunServerMethod(encmeth, iPAPMIDR, "I");
	if (flag != 0) {
		var eSrc = window.event.srcElement;
		if (eSrc.id != "BPrintView") {

			if (!confirm(t[flag])) {
				return false;
			}
		}
	}
	var Type = "Export", OnlyAdvice = "";
	var eSrc = window.event.srcElement;
	//alert(eSrc.id)
	if (eSrc.id == "BPrintView") {
		Type = "View"
	} else if (eSrc.id == "BPrint") {
		Type = "Print"
		var CoverFlag = "0"
	} else if (eSrc.id == "BExportHtml") {
		Type = "ExportHTML"
	} else if (eSrc.id == "SimPrint") {
		Type = "Print"
		OnlyAdvice = "N";
		var CoverFlag = "0"
	} else if (eSrc.id == "NoCoverPrint") {
		Type = "Print"
		var CoverFlag = "1"
	} else if (eSrc.id == "BExportPDF") {
		Type = "ExportPDF";
	}

	//alert(Type);
	obj = document.getElementById("prnpath");
	if (obj) { iprnpath = obj.value; }
	//alert(iPAADMStr);

	if (iPAADMStr != "") {
		PrintTemplateReport(iPAADMStr);
	}

	if (iRowID == "") return true;
	obj = document.getElementById("ReportNameBox");
	if (obj) { var iReportName = obj.value; }
	var width = screen.width - 60;
	var height = screen.height - 10;
	var nwin = 'toolbar=no,alwaysLowered=yes,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width=' + width + ',height=' + height + ',left=30,top=5';

	if ((Type == "Print") || ((Type == "ExportPDF"))) {
		var Arr = iRowID.split("^");

		var Length = Arr.length;
		for (var i = 0; i < Length; i++) {
			var OneID = Arr[i]
			var lnk = iReportName + "?PatientID=" + iPAADMDR + "&ReportID=" + OneID + "&prnpath=" + iprnpath + "&Type=" + Type + "&OnlyAdvice=" + OnlyAdvice + "&CoverFlag=" + CoverFlag + "&IsSendMessage=" + IsSendMessage;
			var ret = window.showModalDialog(lnk, "", "dialogwidth:800px;dialogheight:600px;center:1");
			//open(lnk,"_blank",nwin);
		}
	} else {
		var lnk = iReportName + "?PatientID=" + iPAADMDR + "&ReportID=" + iRowID + "&prnpath=" + iprnpath + "&Type=" + Type + "&OnlyAdvice=" + OnlyAdvice + "&CoverFlag=" + CoverFlag;
		open(lnk, "_blank", nwin);
	}
	return false;
}
function InitIReportDataGrid() {
	$HUI.datagrid("#IReportQueryTab", {
		url: $URL,
		fit: true,
		border: false,
		striped: true,
		fitColumns: false,
		autoRowHeight: false,
		rownumbers: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 100, 200],
		singleSelect: false,
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: true,
		queryParams: {
			ClassName: "web.DHCPE.Report",
			QueryName: "SearchIReport",
			RegNo: $("#RegNo").val(),
			PatName: $("#PatName").val(),
			DepartName: $("#DepartName").val(),
			DateFrom: $("#DateFrom").datebox('getValue'),
			DateTo: $("#DateTo").datebox('getValue'),
			AuditDateFrom: $("#AuditDateFrom").datebox('getValue'),
			AuditDateEnd: $("#AuditDateEnd").datebox('getValue'),
			VIPLevel: $("#VIPLevel").combobox('getValue'),
			GroupID: $("#GroupName").combogrid('getValue'),
			TeamID: $("#TeamName").combogrid('getValue'),
			ReportStatus: "",
			IsSecret: IsSecret,
			DocDR: $("#DocName").combogrid('getValue'),
			HospID: session['LOGON.HOSPID']
		},
		frozenColumns: [[
			{ title: '选择', field: 'Select', width: 60, checkbox: true },
			{ field: 'RPT_RegNo', width: '100', title: '登记号' },
		]],
		columns: [[
			{ field: 'RPT_RowId', title: 'RPT_RowId', hidden: true },
			{ field: 'RPT_IADM_DR', title: 'RPT_IADM_DR', hidden: true },
			{ field: 'RPT_PAADM_DR', title: 'RPT_PAADM_DR', hidden: true },
			{ field: 'GSType', width: '60', title: '总检类型', hidden: true },
			{ field: 'RPT_IADM_DR_Name', width: '100', title: '姓名' },
			{ field: 'RPT_IADM_Sex', width: '60', title: '性别' },
			{ field: 'RPT_Age', width: '60', title: '年龄' },
			{ field: 'TDepartName', width: '100', title: '部门' },
			{ field: 'Tel', width: '110', title: '联系电话' },
			{ field: 'TVIPLevel', width: '60', title: 'VIP等级' },
			{ field: 'THPNo', width: '100', title: '体检号' },
			{ field: 'RPT_AduitUser_DR_Name', width: '100', title: '审核人' },
			{ field: 'RPT_AduitDate', width: '100', title: '审核日期 ' },
			{ field: 'RPT_PrintUser_DR_Name', width: '100', title: '打印人' },
			{ field: 'RPT_PrintDate', width: '100', title: '打印日期' },
			{ field: 'RPT_Status_Name', width: '100', title: '报告状态' },
			{ field: 'FetchReportUser', width: '100', title: '取报告人' },
			{ field: 'FetchReportDate', width: '100', title: '取报告时间' },
			{ field: 'RPT_SendUser_DR', width: '100', title: '发送人', hidden: true },
			{ field: 'RPT_SendDate', width: '100', title: '发送时间', hidden: true },
			{ field: 'UnAppedItems', width: '200', title: '未完成项目' },
			{ field: 'RPT_IADM_RegDate', width: '100', title: '到达日期' },
			{ field: 'ReChkFlag', width: '60', title: '复查' },
			{ field: 'RPT_GADM_DR_Name', width: '200', title: '团体' },
			{ field: 'TeamDRName', width: '100', title: '分组' },
			{ field: 'TPhotoFlag', width: '60', title: '片子' },
			{ field: 'PACCardDesc', width: '90', title: '证件类型' },
			{ field: 'IDCard', width: '180', title: '证件号' }
		]],
		onCheck: function(rowIndex, rowData){
			updBtnStatus("");
		},
		onUncheck: function(rowIndex, rowData){
			updBtnStatus("");
		},
		onCheckAll: function(rowData){
			updBtnStatus(rowData);
		},
		onUncheckAll: function(rowData){
			updBtnStatus(rowData);
			// $("#BFCPrint, #BFCPrintView").linkbutton("disable");
		}
	});
}

function InitCombobox() {
	// VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel", {
		url: $URL + "?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID=" + session['LOGON.CTLOCID'],
		valueField: 'id',
		textField: 'desc'
	});

	//团体
	var GroupNameObj = $HUI.combogrid("#GroupName", {
		panelWidth: 450,
		url: $URL + "?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode: 'remote',
		delay: 200,
		idField: 'TRowId',
		textField: 'TGDesc',
		onBeforeLoad: function (param) {
			param.GBIDesc = param.q;
			param.ShowPersonGroup = "1";
		},
		onChange: function () {
			TeamNameObj.clear();
		},
		columns: [[
			{ field: 'TRowId', title: '团体ID', width: 80 },
			{ field: 'TGDesc', title: '团体名称', width: 140 },
			{ field: 'TGStatus', title: '状态', width: 100 },
			{ field: 'TAdmDate', title: '日期', width: 100 }
		]]
	});

	//分组
	var TeamNameObj = $HUI.combogrid("#TeamName", {
		panelWidth: 250,
		url: $URL + "?ClassName=web.DHCPE.DHCPEGAdm&QueryName=DHCPEGItemList",
		mode: 'remote',
		delay: 200,
		idField: 'GT_RowId',
		textField: 'GT_Desc',
		onBeforeLoad: function (param) {

			var PreGId = $("#GroupName").combogrid("getValue");
			param.GID = PreGId;
		},
		onShowPanel: function () {
			$('#TeamName').combogrid('grid').datagrid('reload');
		},
		columns: [[
			{ field: 'GT_Desc', title: '分组名称', width: 140 },
			{ field: 'GT_RowId', title: '分组ID', width: 80 }
		]]
	});

	//医生
	var DocNameObj = $HUI.combogrid("#DocName", {
		panelWidth: 400,
		panelHeight: 240,
		url: $URL + "?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUserNew&Type=GAuditStationS^JGAUDITSTATIONS^GMainAuditStationS^KGMAINAUDITSTATIONS",
		mode: 'remote',
		delay: 200,
		pagination: true,
		minQueryLen: 1,
		rownumbers: true,//序号 
		fit: true,
		pageSize: 5,
		pageList: [5, 10],
		idField: 'DocDr',
		textField: 'DocName',
		onBeforeLoad: function (param) {
			param.Desc = param.q;
			param.FType = "F";
			param.LocID = session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];
		},
		columns: [[
			{ field: 'DocDr', title: 'ID', width: 100 },
			{ field: 'DocName', title: '姓名', width: 250 }
		]]
	});
}

/// 复查报告打印
function BZYFCPrint(PrtType) {
	var statusStr = "";
	var IRowIdArr = new Array();
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//获取的是数组，多行数据
	for(var i=0; i<selectrow.length; i++) {
		var iPAADMDR = selectrow[i].RPT_PAADM_DR;
		IRowIdArr.push(iPAADMDR);
	}
	
	if (IRowIdArr.length == 0) {
		$.messager.alert("提示","请选择待打印报告","info");
		return false;
	}
	
	if(statusStr.indexOf("未") > 0){
		$.messager.alert("提示","未初检，请核实报告状态","info");
		return false;
	}
	
	if(PrtType == "View" && IRowIdArr.length > 1) {
		$.messager.alert("提示","不可批量预览，请重新选择！","info");
		return false;
	}
	
	if (PrtType == "Print") {
		for(var k=0; k<IRowIdArr.length; k++) {
			PEPrintReport("P", IRowIdArr[k], "", "FCBG");
		}
	} else if (PrtType == "View") {
		PEPrintReport("V", IRowIdArr[0], "", "FCBG");
	}
}

function updBtnStatus(data) {
	if (data != "") {
		var SelRowData = data;
	} else {
		var SelRowData = $("#IReportQueryTab").datagrid("getChecked");//获取的是数组，多行数据
	}
	var FCFlag = 0;
	for(var i=0; i<SelRowData.length; i++) {
		var GSType = SelRowData[i].GSType;
		if (GSType != "ZYJK") {
			FCFlag = -1;
			break;
		}
		var ReChkFlag = SelRowData[i].ReChkFlag;
		if (ReChkFlag != "Y") {
			FCFlag = -1;
			break;
		}
		FCFlag = 1;
	}
	if (FCFlag == 1) {
		$("#BFCPrint, #BFCPrintView").linkbutton("enable");
	} else {
		$("#BFCPrint, #BFCPrintView").linkbutton("disable");
	}
}
