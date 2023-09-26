// dhcmed.fbd.report.csp
var xls=null;
var xlBook=null;
var xlSheet=null;
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);

// ʳԴ�Լ��������ӡ
function ExportReportToExcel(reportID) {
	var objPrint = ExtTool.StaticServerObject("DHCMed.FBDService.PrintSrv");
	var objService = ExtTool.StaticServerObject("DHCMed.Service");
	var TemplatePath = objService.GetTemplatePath();
	var FileName = TemplatePath + "" + "DHCMed.FBD.Report.xls";
	try {
		xls = new ActiveXObject("Excel.Application");
	} catch(e) {
		alert("����ExcelӦ�ö���ʧ��!");
		return false;
	}
	xls.visible = false;
	xlBook = xls.Workbooks.Add(FileName);
	xlSheet = xlBook.Worksheets.Item(1);
	var flg = objPrint.FBDReportPrint("fillxlSheet", reportID);
	xlSheet.printout();
	xlSheet = null;
	xlBook.Close(savechanges=false);
	xls.Quit();
	xlSheet = null;
	xlBook = null;
	xls = null;
	idTmr = window.setInterval("Cleanup();", 1);
	return true;
}

function fillxlSheet(xlSheet, cData, cRow, cCol) {
	var cells = xlSheet.Cells;
	if ((cRow=="") || (typeof(cRow)=="undefined")) { cRow = 1; }
	if ((cCol=="") || (typeof(cCol)=="undefined")) { cCol = 1; }
	var arryDataX = cData.split(CHR_2);
	for (var i=0; i<arryDataX.length; ++i) {
		var arryDataY = arryDataX[i].split(CHR_1);
		for (var j=0; j<arryDataY.length; ++j) {
			cells(cRow + i, cCol + j).Value = arryDataY[j];
			//cells(cRow+i,cCol+j).Borders.Weight = 1;
		}
	}
	return cells;
}

function Cleanup() {
	window.clearInterval(idTmr);
	CollectGarbage();
}

//����Ԫ��
function AddCells(objSheet, fRow, fCol, tRow, tCol, xTop, xLeft) {
	objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(1).LineStyle = 1;
	objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(2).LineStyle = 1;
	objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(3).LineStyle = 1;
	objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(4).LineStyle = 1;
}

//��Ԫ��ϲ�
function MergCells(objSheet, fRow, fCol, tRow, tCol) {
	objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow, tCol)).MergeCells = 1;
}

//��Ԫ�����
//-4130 �����
//-4131 �Ҷ���
//-4108 ���ж���
function HorizontCells(objSheet, fRow, fCol, tRow, tCol, HorizontNum) {
	objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow, tCol)).HorizontalAlignment = HorizontNum;
}

//��Ԫ��߿�
function BorderCells(objSheet, fRow, fCol, tRow, tCol, Style) {
	var xStyle = Style.split("#");	// 1#2#3  1zuo2you3shang4xia
	for (var i=0; i<xStyle.length; i++) {
		var j = +xStyle[i];
		if (j<1 || j>4) { continue; }
		objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow, tCol)).Borders(j).LineStyle = 1;
	}
}