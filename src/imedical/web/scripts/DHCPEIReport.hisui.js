//DHCPEIReport.hisui.js
//����	���˱���	
//����	2019.04.02
//������  xy
$(function () {
	InitCombobox();

	InitIReportDataGrid();

	//��ѯ
	$("#BFind").click(function () {
		BFind_click();
	});

	//���� 
	$("#BClear").click(function () {
		BClear_click();
	});

	$("#RegNo").keydown(function (e) {
		if (e.keyCode == 13) {
			RegNoOnChange();
		}
	});
	
	//��������
	$("#BExportED").click(function () {
		BExportED_click();
	});
	
	//���鱨��
	$("#BFCPrint").click(function () {
		BZYFCPrint("Print");
	});
	
	//���鱨��
	$("#BFCPrintView").click(function () {
		BZYFCPrint("View");
	});
	
	Init();
});


function Init() {
	var NewVerReportFlag = tkMakeServerCall("web.DHCPE.HISUICommon", "GetSettingByLoc", session['LOGON.CTLOCID'], "NewVerReport");
	if (NewVerReportFlag == "Lodop") {
		$("#BExport").css('display', 'none');//���� 
	} else {
		$("#BExport").css('display', 'block');//��ʾ
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

//��ѯ
function BFind_click() {
	var iSTatus = ""

	//δ���
	var iSTatusNA = $("#STatusIsNoAudit").checkbox('getValue');
	if (iSTatusNA) { iSTatus = iSTatus + "^" + "NA"; }

	//�����
	var iSTatusA = $("#STatusIsCheched").checkbox('getValue');
	if (iSTatusA) { iSTatus = iSTatus + "^" + "A"; }

	//�����
	var iSTatusC = $("#HadCompete").checkbox('getValue');
	if (iSTatusC) { iSTatus = iSTatus + "^" + "C"; }

	//�Ѵ�ӡ
	var iSTatusP = $("#STatusIsPrint").checkbox('getValue');
	if (iSTatusP) { iSTatus = iSTatus + "^" + "P"; }

	//��ȡ����
	var iSTatusS = $("#STatusIsSend").checkbox('getValue');
	if (iSTatusS) { iSTatus = iSTatus + "^" + "S"; }

	//�Ƿ��Ͷ���
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

//���� 
function BClear_click() {
	$("#RegNo,#PatName,#DepartName").val("");
	$(".hisui-combobox").combobox('setValue', "");
	$(".hisui-combogrid").combogrid('setValue', "");
	$(".hisui-checkbox").checkbox('setValue', false);
	$("#DateFrom,#DateTo,#AuditDateFrom,#AuditDateEnd").datebox('setValue', "")
	InitCombobox();
	BFind_click();
}

//��������
function BExportED_cmdshell() {
	var iPAADMDRStr = ""
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//��ȡ�������飬��������
	for (var i = 0; i < selectrow.length; i++) {

		var iPAADMDR = selectrow[i].RPT_PAADM_DR;
		if (iPAADMDRStr = "") { iPAADMDRStr = iPAADMDR; }
		else { iPAADMDRStr = iPAADMDRStr + "^" + iPAADMDR; }

	}

	if (iPAADMDRStr == "") {
		$.messager.alert("��ʾ", "��ѡ����������۵���Ա", "info");
		return false;
	}
	
	var wdCharacter = 1;
	var Str = "(function test(x){" +
		"var WordApp=new ActiveXObject('Word.Application'); " +

		"var wdOrientLandscape = 1;" +
		"WordApp.Application.Visible=true;" + //ִ�����֮���Ƿ񵯳��Ѿ����ɵ�word 
		"var myDoc=WordApp.Documents.Add();" +//�����µĿ��ĵ� 
		//WordApp.ActiveDocument.PageSetup.Orientation = wdOrientLandscape//ҳ�淽������Ϊ���� 
		"WordApp.Selection.ParagraphFormat.Alignment=0;" + //1���ж���,0Ϊ���� 
		"WordApp.Selection.Font.Bold=false;" +
		"WordApp.Selection.Font.Size=20;" +
		"WordApp.Selection.TypeText('����������');" +
		"WordApp.Selection.MoveRight(" + wdCharacter + ");" +��������//��������ַ� 
		"WordApp.Selection.TypeParagraph();" + //������� 
		"WordApp.Selection.Font.Size=8;" +
		"WordApp.Selection.TypeParagraph();" + //������� 
		"var myTable=myDoc.Tables.Add(WordApp.Selection.Range,1,3);" + //1��7�еı�� 
		"myTable.Style='������';" +
		//�����п�
		"myTable.Columns(1).Width=45;" +
		"myTable.Columns(2).Width=35;" +
		"myTable.Columns(3).Width=380;" +
		//�����ͷ��Ϣ
		"myTable.Cell(1,1).Range.Text ='ID��';" +
		"myTable.Cell(1,2).Range.Text ='����';" +
		"myTable.Cell(1,3).Range.Text ='����';";
	var appendStr = "";
	var iPAADMDR = "", RegNo = "", Name = "";
	var Row = 1;
	for (var i = 0; i < selectrow.length; i++) {

		var iPAADMDR = selectrow[i].RPT_PAADM_DR;
		var Info = tkMakeServerCall("web.DHCPE.ReportGetInfor", "GetGeneralAdviceByAdmJS", iPAADMDR);
		appendStr = "myTable.Rows.add();";//������
		Row = Row + 1;
		appendStr = appendStr + "myTable.Cell(" + Row + ",3).Range.Text='" + Info + "';";
		RegNo = selectrow[i].RPT_RegNo;
		appendStr = appendStr + "myTable.Cell(" + Row + ",1).Range.Text='" + RegNo + "';";;
		Name = selectrow[i].RPT_IADM_DR_Name;
		appendStr = appendStr + "myTable.Cell(" + Row + ",2).Range.Text='" + Name + "';";;

	}
	Str = Str + appendStr + "return 1;}());";
	CmdShell.notReturn = 1;   //�����޽�����ã�����������
	var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ���� 
}

//��������
function BExportED_click() {
	if (EnableLocalWeb == 1) {
		return BExportED_cmdshell();
	}
	var iPAADMDRStr = ""
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//��ȡ�������飬��������
	for (var i = 0; i < selectrow.length; i++) {

		var iPAADMDR = selectrow[i].RPT_PAADM_DR;
		if (iPAADMDRStr = "") { iPAADMDRStr = iPAADMDR; }
		else { iPAADMDRStr = iPAADMDRStr + "^" + iPAADMDR; }

	}

	if (iPAADMDRStr == "") {
		$.messager.alert("��ʾ", "��ѡ����������۵���Ա", "info");
		return false;
	}
	
	var WordApp = new ActiveXObject("Word.Application");
	var wdCharacter = 1
	var wdOrientLandscape = 1
	WordApp.Application.Visible = true; //ִ�����֮���Ƿ񵯳��Ѿ����ɵ�word 
	var myDoc = WordApp.Documents.Add();//�����µĿ��ĵ� 
	//WordApp.ActiveDocument.PageSetup.Orientation = wdOrientLandscape//ҳ�淽������Ϊ���� 
	WordApp.Selection.ParagraphFormat.Alignment = 0 //1���ж���,0Ϊ���� 
	WordApp.Selection.Font.Bold = false;
	WordApp.Selection.Font.Size = 20
	WordApp.Selection.TypeText("����������");
	WordApp.Selection.MoveRight(wdCharacter);��������//��������ַ� 
	WordApp.Selection.TypeParagraph() //������� 
	WordApp.Selection.Font.Size = 8
	WordApp.Selection.TypeParagraph() //������� 
	var myTable = myDoc.Tables.Add(WordApp.Selection.Range, 1, 3) //1��7�еı�� 
	myTable.Style = "������"
	var TableRange;
	//�����п�
	myTable.Columns(1).Width = 45;
	myTable.Columns(2).Width = 35;
	myTable.Columns(3).Width = 380;
	//�����ͷ��Ϣ
	myTable.Cell(1, 1).Range.Text = "ID��";
	myTable.Cell(1, 2).Range.Text = "����";
	myTable.Cell(1, 3).Range.Text = "����";

	var iPAADMDR = "", RegNo = "", Name = "";
	var Row = 1;
	for (var i = 0; i < selectrow.length; i++) {

		var iPAADMDR = selectrow[i].RPT_PAADM_DR;
		var Info = tkMakeServerCall("web.DHCPE.ReportGetInfor", "GetGeneralAdviceByAdm", iPAADMDR);
		myTable.Rows.add();//������
		Row = Row + 1;
		myTable.Cell(Row, 3).Range.Text = Info;
		RegNo = selectrow[i].RPT_RegNo;
		myTable.Cell(Row, 1).Range.Text = RegNo;
		Name = selectrow[i].RPT_IADM_DR_Name;
		myTable.Cell(Row, 2).Range.Text = Name;

	}
}

function BPrintViewLodop(e) {
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//��ȡ�������飬��������
	for (var i = 0; i < selectrow.length; i++) {
		var iPAADMDR = selectrow[i].RPT_PAADM_DR;
		var printerName = tkMakeServerCall("web.DHCPE.Report", "GetVirtualPrinter");
		if (e.id == "BPrint") {//��ӡ����
			PEPrintReport("P", iPAADMDR, printerName);
		} else if (e.id == "BPrintView") {//��ӡԤ��
			PEPrintReport("V", iPAADMDR, printerName);
		} else if (e.id == "BPrintYGReport") {  // �Ҹα���
			var YGItemFlag = tkMakeServerCall("web.DHCPE.ResultDiagnosis", "GetYGItemFlag", iPAADMDR, "PAADM");
			if (YGItemFlag != "3") {
				if (YGItemFlag == "0") $.messager.alert("��ʾ", "���Ҹ���Ŀ��", "info");
				else if (YGItemFlag == "2") $.messager.alert("��ʾ", "�Ҹ���Ŀ�����죡", "info");
				else $.messager.alert("��ʾ", "�Ҹ���Ŀ�޽����", "info");
				return false;
			}
			PEPrintReport("P", iPAADMDR, printerName, "YGBG");
		} else {//��������
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
		if (sourceID == "BPrint") {//��ӡ����
			PEPrintReport("P", iPAADMDR, printerName, "");
		} else if (sourceID == "BPrintView") {//��ӡԤ��
			PEPrintReport("V", iPAADMDR, printerName, "");
		} else if (sourceID == "BPrintYGReport") {  // �Ҹα���
			var YGItemFlag = tkMakeServerCall("web.DHCPE.ResultDiagnosis", "GetYGItemFlag", iPAADMDR, "PAADM");

			if (YGItemFlag != "3") {
				if (YGItemFlag == "0") $.messager.alert("��ʾ", "���Ҹ���Ŀ��", "info");
				else if (YGItemFlag == "2") $.messager.alert("��ʾ", "�Ҹ���Ŀ�����죡", "info");
				else $.messager.alert("��ʾ", "�Ҹ���Ŀ�޽����", "info");
				return false;
			}
			PEPrintReport("P", iPAADMDR, printerName, "YGBG");
		} else {//��������
			PEPrintReport("E", iPAADMDR, printerName, "");
		}
	}

	return false;
}

function BPrintView(e) {
    var LocID=session['LOGON.CTLOCID'];
	var MainDoctorGroup=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",LocID,"MainDoctorGroup"); //�Ƿ񸴼�

	var iPAADMStr = "", jarPAADM = "", statusStr = "";
	var IRowIdArr = new Array();
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//��ȡ�������飬��������
	for (var i = 0; i < selectrow.length; i++) {

		var iReportStatus = selectrow[i].RPT_Status_Name; //����״̬
		if(e.id=="BPrint"){
			if(MainDoctorGroup=="Y"){
				if((iReportStatus=="δ����")||(iReportStatus=="�ѳ���δ����")) continue;
			}else{
				if (iReportStatus=="δ����") continue;
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
		$.messager.alert("��ʾ", "��ѡ�����ӡ����", "info");
		return false;
	}
	
	/*
	if (statusStr.indexOf("δ") > 0) {
		$.messager.alert("��ʾ", "δ���죬���ʵ����״̬", "info");
		return false;
	}
	*/

	if (e.id == "BPrintView" && IRowIdArr.length > 1) {
		$.messager.alert("��ʾ", "��������Ԥ����������ѡ��", "info");
		return false;
	}
	var NewVerReportFlag = tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",LocID,"NewVerReport");
	if (jarPAADM != "") {
		if (NewVerReportFlag == "Word") {
			websocoket_report(e.id, jarPAADM);
		} else if (NewVerReportFlag == "Lodop") {
			BPrintViewLodopNew(e.id, jarPAADM);
		} else {
			$.messager.alert("��ʾ", "�޶�Ӧ��ӡ��ʽ����ǰ�����������ά����", "info");
			return false;
		}
	}
	if (iPAADMStr != "") {
		PrintTemplateReport(e.id, iPAADMStr);
	}

	return false;

	var iPAADMStr = "", iRowID = "", jarPAADM = "", statusStr = "";
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//��ȡ�������飬��������
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
				$.messager.alert("��ʾ", "��ѡ�����ӡ����", "info");
			} else if (statusStr.indexOf("δ") > 0) {
				$.messager.alert("��ʾ", "δ���죬���ʵ����״̬", "info");
			} else if (e.id == "BPrintView" && jarPAADM.split("#").length > 1) {
				$.messager.alert("��ʾ", "��������Ԥ����������ѡ��", "info");

			} else {
				websocoket_report(e.id, jarPAADM);
			}
			return false;
		} else if (e.id == "BPrintYGReport") {  // �Ҹα���ֻ��ӡCSPģ��
			BPrintViewLodop(e);
		}

	} else if (NewVerReportFlag == "Lodop") {
		BPrintViewLodop(e);

	} else {

		if ((iRowID != "") || (iPAADMStr != "")) {
			//alert(iRowID+"  @@iPAADMStr"+iPAADMStr);
			ShowPrintWindows(iRowID, iPAADMStr, e);
		} else {
			$.messager.alert("��ʾ", "��ѡ�����ӡ���棡", "info");
		}
	}
	return false;
}

/**
 * [websocket �ͻ���ͨ��]
 * @param    {[Date]}    date [����]
 * @return   {[String]}         [��ʽ��������]
 * @Author   wangguoying
 * @DateTime 2021-01-28
 */
function websocoket_report(sourceID, jarPAADM) {
	var opType = (sourceID == "BPrint" || sourceID == "NoCoverPrint" || sourceID == "BPrintYGReport") ? "2" : (sourceID == "BPrintView" ? "5" : (sourceID == "BUploadReport" ? "4" : "1"));
	var fileType = (sourceID == "BExportPDF") || (sourceID == "BUploadReport") ? "pdf" : (sourceID == "BExportHtml" ? "html" : "word");
	var method = (sourceID== "BPrintYGReport") ? "-New" : "";
	
	var execParam = {
		business: "REPORT", //����̶�ΪREPORT
		admId: jarPAADM,
		opType: opType,
		fileType: fileType,
		printType: "1" + method  //1Ϊ���˱���
	};

	//��ӡԤ����������ˮӡ
	if(execParam.opType == "2") execParam.extStr="HS10322,"+session["LOGON.USERID"];
	if(execParam.opType == "5") execParam.extStr="WaterMark:PreView";

	var json = JSON.stringify(execParam);
	$PESocket.sendMsg(json, peSoceket_onMsg);
}


/**
 * [websocket �ͻ���ͨ�Żص�����]
 * @param    {[String]}    param [�ͻ��˽��յ��� json��]
 * @return   {[Object]}    event [�ͻ��˷��ص���Ϣ����]
 * @Author   wangguoying
 * @DateTime 2021-01-28
 */
function peSoceket_onMsg(param, event) {
	var paramObj = JSON.parse(param);
	var FileName = paramObj.files;
	var retObj = JSON.parse(event.data);
	if (retObj.code == "0") {
		
	} else {
		$.messager.alert("��ʾ", "<br><span style='color:red;font-weight:600;'>ִ��ʧ�ܣ��������ѯ��־</span>", "info");
	}
}

//�ⲿЭ�����챨����� 
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

// Excel ��ӡ
function PrintReportExcel(ReportData, Template) {
	var obj = document.getElementById("prnpath");
	if (obj && "" != obj.value) {
		var prnpath = obj.value;
		var prnpath = "D:\\DHCPE\\";
		var Templatefilepath = prnpath + Template;
	} else {
		alert("��Чģ��·��");
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

// Excel ��ӡ
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
		//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
		CmdShell.notReturn = 1;   //�����޽�����ã�����������
		var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ����
		if (rtn.status == 500) {
			$.messager.alert("��ʾ", "���󣺴���Ϊ " + rtn.msg, "info");  // {status: 500,  "���������쳣:δ�������ַ�������", rtn: ""}
		}
		return;
	} catch (e) {
		$.messager.alert("��ʾ", "���󣺴���Ϊ" + e.message, "info");
		return false;
	}
}

// word ��ӡ
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

	//alert("��Чģ��·��");
	//return;
	try {
		var word = new ActiveXObject("Word.Application");
		if (!word) {
			alert("word����ʧ��");
			return;
		}
		word.visible = false;
		myDoc = word.Documents.open(Templatefilepath);
		if (!myDoc) {
			alert("��ַ���ִ���");
			return;
		}

		var ReportDataJson = eval('(' + ReportData + ')');
		var LisDataJson = eval('(' + LisData + ')');
		var RisDataJson = eval('(' + RisData + ')');

		var range = null;
		for (var key in ReportDataJson) {
			try {
				range = myDoc.Bookmarks(key).Range;
				range.InsertBefore(ReportDataJson[key]); //��ǩ���������
			} catch (e) {

			}
		}
		
		// ������ ���

		// ѭ����Ŀ
		$.each(LisDataJson["ItemInfo"], function (i, itemJson) {

			if (i == 0) {  // ���ӷ�ҳ��
				range = myDoc.Sections(1).Range;
				range.Collapse(Direction = 0);
				range.insertBreak(7);
			}

			// ��Ŀ��
			range = myDoc.Sections(1).Range;
			range.Collapse(Direction = 0);
			range.InsertAfter(itemJson.Desc);

			// ��ͷ + ϸ����
			range.Collapse(Direction = 0);
			range.InsertParagraphAfter();

			var lisTotalRows = 1 + itemJson.OrdDetailNum;
			var lisTotalCols = 7;
			var lisTableHead = new Array("���", "��Ŀ����", "Ӣ����", "�����", "��ʾ", "�ο���Χ", "��λ");
			var lisTableList = new Array("Sort", "ItemDesc", "CTTCSynonym", "Result", "Arrow", "TestStandard", "Unit");
			var lisTabColWid = new Array(35, 120, 60, 70, 35, 85, 90);

			var lisTab = myDoc.Tables.Add(range, lisTotalRows, lisTotalCols);
			lisTab.Borders(1).LineStyle = 1;
			lisTab.Borders(1).LineWidth = 2;

			for (var lisRow = 1; lisRow <= lisTotalRows; lisRow++) {
				for (var lisCol = 1; lisCol <= lisTotalCols; lisCol++) {
					if (lisRow == 1) {	// ��ͷ
						lisTab.Cell(lisRow, lisCol).Range.Text = lisTableHead[lisCol - 1];
						lisTab.Columns(lisCol).SetWidth(lisTabColWid[lisCol - 1], 0);  // ���ÿ��
					} else {
						lisTab.Cell(lisRow, lisCol).Range.Text = itemJson["OrdDetail"][lisRow - 2][lisTableList[lisCol - 1]];
					}
				}
			}

			// ҽ����
			range = myDoc.Sections(1).Range;
			range.Collapse(Direction = 0);
			//range.ParagraphFormat.Alignment = 2;  // 0 left  1 center  2 right
			range.InsertAfter("        ¼���ߣ�" + itemJson.Checker + "        ����ߣ�" + itemJson.Auditer + "        ������ڣ�" + itemJson.CheckDate);

			// ����
			range = myDoc.Sections(1).Range;
			range.Collapse(Direction = 0);
			range.InsertParagraphAfter();
			myDoc.Tables.Add(range, 1, 1);
		});
		
		word.Application.Printout();  // ��ӡ  PrintPreview

		//alert("��ӡ���");
	} catch (e) {
		setTimeout("CollectGarbage();", 10);
		alert(e);
	} finally {
		myDoc.Close(savechanges = false);
		word.quit();
		word = null;
	}
}

//�ɰ��ӡ����
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
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
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
			{ title: 'ѡ��', field: 'Select', width: 60, checkbox: true },
			{ field: 'RPT_RegNo', width: '100', title: '�ǼǺ�' },
		]],
		columns: [[
			{ field: 'RPT_RowId', title: 'RPT_RowId', hidden: true },
			{ field: 'RPT_IADM_DR', title: 'RPT_IADM_DR', hidden: true },
			{ field: 'RPT_PAADM_DR', title: 'RPT_PAADM_DR', hidden: true },
			{ field: 'GSType', width: '60', title: '�ܼ�����', hidden: true },
			{ field: 'RPT_IADM_DR_Name', width: '100', title: '����' },
			{ field: 'RPT_IADM_Sex', width: '60', title: '�Ա�' },
			{ field: 'RPT_Age', width: '60', title: '����' },
			{ field: 'TDepartName', width: '100', title: '����' },
			{ field: 'Tel', width: '110', title: '��ϵ�绰' },
			{ field: 'TVIPLevel', width: '60', title: 'VIP�ȼ�' },
			{ field: 'THPNo', width: '100', title: '����' },
			{ field: 'RPT_AduitUser_DR_Name', width: '100', title: '�����' },
			{ field: 'RPT_AduitDate', width: '100', title: '������� ' },
			{ field: 'RPT_PrintUser_DR_Name', width: '100', title: '��ӡ��' },
			{ field: 'RPT_PrintDate', width: '100', title: '��ӡ����' },
			{ field: 'RPT_Status_Name', width: '100', title: '����״̬' },
			{ field: 'FetchReportUser', width: '100', title: 'ȡ������' },
			{ field: 'FetchReportDate', width: '100', title: 'ȡ����ʱ��' },
			{ field: 'RPT_SendUser_DR', width: '100', title: '������', hidden: true },
			{ field: 'RPT_SendDate', width: '100', title: '����ʱ��', hidden: true },
			{ field: 'UnAppedItems', width: '200', title: 'δ�����Ŀ' },
			{ field: 'RPT_IADM_RegDate', width: '100', title: '��������' },
			{ field: 'ReChkFlag', width: '60', title: '����' },
			{ field: 'RPT_GADM_DR_Name', width: '200', title: '����' },
			{ field: 'TeamDRName', width: '100', title: '����' },
			{ field: 'TPhotoFlag', width: '60', title: 'Ƭ��' },
			{ field: 'PACCardDesc', width: '90', title: '֤������' },
			{ field: 'IDCard', width: '180', title: '֤����' }
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
	// VIP�ȼ�	
	var VIPObj = $HUI.combobox("#VIPLevel", {
		url: $URL + "?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID=" + session['LOGON.CTLOCID'],
		valueField: 'id',
		textField: 'desc'
	});

	//����
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
			{ field: 'TRowId', title: '����ID', width: 80 },
			{ field: 'TGDesc', title: '��������', width: 140 },
			{ field: 'TGStatus', title: '״̬', width: 100 },
			{ field: 'TAdmDate', title: '����', width: 100 }
		]]
	});

	//����
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
			{ field: 'GT_Desc', title: '��������', width: 140 },
			{ field: 'GT_RowId', title: '����ID', width: 80 }
		]]
	});

	//ҽ��
	var DocNameObj = $HUI.combogrid("#DocName", {
		panelWidth: 400,
		panelHeight: 240,
		url: $URL + "?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUserNew&Type=GAuditStationS^JGAUDITSTATIONS^GMainAuditStationS^KGMAINAUDITSTATIONS",
		mode: 'remote',
		delay: 200,
		pagination: true,
		minQueryLen: 1,
		rownumbers: true,//��� 
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
			{ field: 'DocName', title: '����', width: 250 }
		]]
	});
}

/// ���鱨���ӡ
function BZYFCPrint(PrtType) {
	var statusStr = "";
	var IRowIdArr = new Array();
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//��ȡ�������飬��������
	for(var i=0; i<selectrow.length; i++) {
		var iPAADMDR = selectrow[i].RPT_PAADM_DR;
		IRowIdArr.push(iPAADMDR);
	}
	
	if (IRowIdArr.length == 0) {
		$.messager.alert("��ʾ","��ѡ�����ӡ����","info");
		return false;
	}
	
	if(statusStr.indexOf("δ") > 0){
		$.messager.alert("��ʾ","δ���죬���ʵ����״̬","info");
		return false;
	}
	
	if(PrtType == "View" && IRowIdArr.length > 1) {
		$.messager.alert("��ʾ","��������Ԥ����������ѡ��","info");
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
		var SelRowData = $("#IReportQueryTab").datagrid("getChecked");//��ȡ�������飬��������
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
