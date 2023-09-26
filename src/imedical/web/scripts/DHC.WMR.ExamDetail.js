//DHC.WMR.ExamDetail.JS
//Create By LiYang 2008-10-13
//Used to Display Qulity Exam Detail

var objWebServer=GetServerInfo(getElementValue("txtGetServerInfo"));
var strResultID = getElementValue("ResultID");
var objCurrResult = null;
var objPatient = null;
var objAdm = null;
var objMain = null;
var objGrade = null;
//Display exam result detail
function DisplayResultDetail(ResID)
{
	objCurrResult = GetDHCWMRExamResultByID("MethodGetDHCWMRExamResultByID", strResultID);
	if(objCurrResult == null)
	{
		window.alert(t["ResultNotFound"]);
		return;
	}
	var objVolume = GetDHCWMRMainVolumeByID("MethodGetDHCWMRMainVolumeByID", objCurrResult.VolumeID);
	objMain = GetDHCWMRMainByID("MethodGetDHCWMRMainByID", objVolume.Main_Dr);
	objPatient = GetPatientInfoByMrRowID("MethodGetPatientInfoByMrRowID", objMain.RowID);
	objGrade = GetExamGradeByID("MethodGetExamGradeByID", objCurrResult.GradeDr);
	setElementValue("txtMrNo", objMain.MRNO);
	if(objPatient.PatientNo != null)
		setElementValue("txtRegNo", objPatient.PatientNo);
	setElementValue("txtName", objPatient.PatientName);
	setElementValue("txtSex", objPatient.Sex);
	setElementValue("txtAge", objPatient.Age);
	
	objAdm = GetAdmByVolumeID("MethodGetAdmByVolumeID", objVolume.RowID);
	setElementValue("txtAdmitDate", objAdm.AdmitDate);
	setElementValue("txtAdmitDep", objAdm.AdmitDep);
	setElementValue("txtDisDate", objAdm.DischargeDate);
	setElementValue("txtDep", objAdm.DischargeDep);
	setElementValue("txtScore", objCurrResult.Score + "  " + (!objCurrResult.Veto?objGrade.Title:"") + "  " + (objCurrResult.Veto ? t["Veto"] : ""));
	setElementValue("txtActualScore", objCurrResult.ActualScore);

}

function PrintScoreReport()
{
	var objPrinter = new ActiveXObject("DHCMedWebPackage.clsPrinter");
	QueryTool.ConnectionString = objWebServer.LayOutManager;
	//QueryTool.ConnectionString = "cn_iptcp:127.0.0.1[1972]:websource";
	var arryResult = QueryTool.RunQuery("web.DHCWMRExamResultCtl", "QueryExamResultDtl", strResultID);
	objPrinter.Font = t["HeiTi"];
	objPrinter.FontBold = true;
	objPrinter.FontSize = 20;
	objPrinter.PrintContents(8, 1, t["ReportTitle"]);	
	objPrinter.Font = t["SongTi"];
	objPrinter.FontBold = false;
	objPrinter.FontSize = 10;	
	objPrinter.PrintContents(1, 2, t["PatientName"] + objPatient.PatientName);
	objPrinter.PrintContents(5, 2, t["Sex"] + objPatient.Sex);
	objPrinter.PrintContents(8, 2, t["Age"] + objPatient.Age);
	objPrinter.PrintContents(12, 2, t["RegNo"] + (objPatient.PatientNo == null ? "" : objPatient.PatientNo));
	objPrinter.PrintContents(16, 2, t["MrNo"] + objMain.MRNO);
	
	
	objPrinter.PrintContents(1, 2.5, t["AdmitDate"] + objAdm.AdmitDate);
	objPrinter.PrintContents(6, 2.5, t["AdmitDep"] + objAdm.AdmitDep);
	objPrinter.PrintContents(10, 2.5, t["DisDate"] + objAdm.DischargeDate);
	objPrinter.PrintContents(15, 2.5, t["DisDep"] + objAdm.DischargeDep);
	objPrinter.FontBold = true;
	objPrinter.PrintContents(1, 3, t["TotalScore"] + objCurrResult.Score + "  " + objGrade.Title + "  " + (objCurrResult.Veto ? t["Veto"] : ""));
	objPrinter.FontBold = false;
	objPrinter.PrintContents(1, 3.5, t["Section"]);
	objPrinter.PrintContents(4.5, 3.5, t["Entry"]);
	objPrinter.PrintContents(14, 3.5, t["Number"]);
	objPrinter.PrintContents(15, 3.5, t["Score"]);
	objPrinter.PrintContents(16, 3.5, t["People"]);
	
	objPrinter.PrintContents(1, 4, "============================================================================================================");
	var tmp = "";
	var arryTmp = null;
	var RowPerPage = 20;
	for(var i = 1; i < arryResult.length; i ++)
	{
		tmp = arryResult[i];
		arryTmp = tmp.split(String.fromCharCode(1));
		objPrinter.PrintContents(1, 4 + 0.5 * (i % RowPerPage), arryTmp[0]);
		objPrinter.PrintContents(4.5, 4 + 0.5 * (i % RowPerPage), arryTmp[1]);
		objPrinter.PrintContents(14, 4 + 0.5 * (i % RowPerPage), arryTmp[3]);
		objPrinter.PrintContents(15, 4 + 0.5 * (i % RowPerPage), arryTmp[4]);
		objPrinter.PrintContents(16, 4 + 0.5 * (i % RowPerPage), arryTmp[6]);
		if((i % RowPerPage) == (RowPerPage - 1))
		{
			objPrinter.NewPage();
		}
	}
	
	objPrinter.EndDoc();
}

function ExcelGenHandler(objExcelApp, objWorkBook, objSheet)
{
	var TitleCell = objSheet.Cells(1, 1);
	TitleCell.Value = t["ReportTitle"];
	TitleCell.HorizontalAlignment =  -4108;
	TitleCell.Font.Name = t["HeiTi"];
	TitleCell.Font.Size = 20;
	objSheet.Cells(2, 1).Value = t["PatientName"] + objPatient.PatientName;
	objSheet.Cells(2, 2).Value = t["Sex"] + objPatient.Sex;
	objSheet.Cells(2, 3).Value = t["Age"] + objPatient.Age;
	objSheet.Cells(2, 4).Value = t["RegNo"] + (objPatient.PatientNo == null ? "" : objPatient.PatientNo);
	objSheet.Cells(2, 5).Value = t["PatientName"] + objPatient.PatientName;
	objSheet.Cells(2, 6).Value = t["MrNo"] + objMain.MRNO;
	objSheet.Cells(3, 1).Value = t["AdmitDate"] + objAdm.AdmitDate;
	objSheet.Cells(3, 2).Value = t["AdmitDep"] + objAdm.AdmitDep;
	objSheet.Cells(3, 3).Value = t["DisDate"] + objAdm.DischargeDate;
	objSheet.Cells(3, 4).Value = t["DisDep"] + objAdm.DischargeDep;
	objSheet.Cells(3, 5).Value = t["DisDep"] + objAdm.DischargeDep;
	
	
	objSheet.Range(objSheet.Cells(1, 1), objSheet.Cells(1, 7)).Merge();
	objExcelApp.Visible = true;
}

function btnExcelOnClick()
{
	QueryTool.ConnectionString = objWebServer.LayOutManager;
	//QueryTool.ConnectionString = "cn_iptcp:127.0.0.1[1972]:websource";
	var arryResult = QueryTool.RunQuery("web.DHCWMRExamResultCtl", "QueryExamResultDtl", strResultID);
	QueryTool.CreateExcelFile(arryResult, 5, 1, ExcelGenHandler, null);
}

function btnPrintOnClick()
{
	PrintScoreReport();
}

function btnCloseOnClick()
{
	window.close();
}

function InitForm()
{
	document.getElementById("txtName").readOnly = true;
	document.getElementById("txtSex").readOnly = true;
	document.getElementById("txtAge").readOnly = true;
	document.getElementById("txtMrNo").readOnly = true;
	document.getElementById("txtRegNo").readOnly = true;
	document.getElementById("txtAdmitDate").readOnly = true;
	document.getElementById("txtDisDate").readOnly = true;
	document.getElementById("txtDep").readOnly = true;
	document.getElementById("txtScore").readOnly = true;
	//document.getElementById("txtGrade").readOnly = true;
	//document.getElementById("txtVeto").readOnly = true;
	

	DisplayResultDetail(strResultID);
	InitEvent();
}

function InitEvent()
{
	document.getElementById("btnClose").onclick = btnCloseOnClick;
	document.getElementById("btnPrint").onclick = btnPrintOnClick;
	document.getElementById("btnExcel").onclick = btnExcelOnClick;	
}

window.onload = InitForm;


