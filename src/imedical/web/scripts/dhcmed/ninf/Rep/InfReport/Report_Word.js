var xls=null;
var xlBook=null;
var xlSheet=null;

function InitReportWord(obj)
{
	obj.ExportWord = function(objPrtReport)
	{
		if (objPrtReport.ReportType.Code == 'COMP') {
			obj.ExportInfReport(objPrtReport);
		} else if (objPrtReport.ReportType.Code == 'ICU') {
			/* update by zf 20160527 注释掉改为Excel模板打印
			var fileName="{DHCMed.NINF.ICUReport.raq(aReportID="+objPrtReport.RowID+")}";
        		var printObj=window.document.Dtreport1_directPrintApplet;
	    		try{
		  	   	printObj.print(fileName);
	     	  	}catch(e){
				alert(e.message);
			}
			*/
			ExportICUDataToExcelNew(objPrtReport.RowID);
		} else if (objPrtReport.ReportType.Code == 'NICU') {
			
		} else if (objPrtReport.ReportType.Code == 'OPR') {
			/* update by zf 20160527 注释掉改为Excel模板打印
			var fileName="{DHCMed.NINF.OPRReport.raq(aReportID="+objPrtReport.RowID+")}";
			var printObj=window.document.Dtreport1_directPrintApplet;
			try{
				printObj.print(fileName);
			}catch(e){
				alert(e.message);
			}
			*/
			 ExportOPRDataToExcelNew(objPrtReport.RowID);
		} else {
			ExtTool.alert("错误提示", "无打印模板!");
			return;
		}
	}
	
	function ExportICUDataToExcelNew(RepRowID)
	{
		var obj = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.AimReportPrint");
		var objTmp = ExtTool.StaticServerObject("DHCMed.Service");
		var TemplatePath = objTmp.GetTemplatePath();
		var FileName=TemplatePath+"\\\\"+"DHCMedInfReportICU.xls"
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			alert("创建Excel应用对象失败!");
			return false;
		}
		xls.visible=false;
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		
		var flg=obj.PrintReportICU("fillxlSheet",RepRowID);
		//xlSheet.printout();
		var fname = xls.Application.GetSaveAsFilename("ICU感染监测调查表","Excel Spreadsheets (*.xls), *.xls");
		xlBook.SaveAs(fname);
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
		
		return true;
	}
	
	function ExportOPRDataToExcelNew(RepRowID)
	{
		var obj = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.AimReportPrint");
		var objTmp = ExtTool.StaticServerObject("DHCMed.Service");
		var TemplatePath = objTmp.GetTemplatePath();
		var FileName=TemplatePath+"\\\\"+"DHCMedInfReportOPR.xls"
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			alert("创建Excel应用对象失败!");
			return false;
		}
		xls.visible=false;
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		
		var flg=obj.PrintReportOPR("fillxlSheet",RepRowID);
		//xlSheet.printout();
		var fname = xls.Application.GetSaveAsFilename("手术调查表","Excel Spreadsheets (*.xls), *.xls");
		xlBook.SaveAs(fname);
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
		
		return true;
	}
	
	obj.ExportInfReport = function(objPrtReport)
	{
		//取打印模板路径
		var TemplatePath = obj.ClsCommonClsSrv.GetTemplatePath();
		if (!TemplatePath) {
			ExtTool.alert("错误提示", "打印模板路径错误!");
			return;
		}
		
		var filePath = '';
		var fileName = '';
		var fileNo = '';
		filePath = TemplatePath + "DHCMedInfectionReportNew.dot";
		fileName = objPrtReport.ReportType.Description;
		fileNo = objPrtReport.RowID;
		
		if (!filePath) {
			ExtTool.alert("错误提示", "打印模板路径错误!");
			return;
		}
		
		//转换报告数据格式(转换为宏程序需要的格式,主要是数组数据转换)
		objPrtReport = obj.GetPrtReport(objPrtReport);
		if (!objPrtReport) {
			ExtTool.alert("错误提示", "打印数据加载错误!");
			return;
		}
		
		var objPaadm = obj.CurrPaadm;
		if (!objPaadm) {
			ExtTool.alert("错误提示", "就诊信息加载错误!");
			return;
		}
		var PatientID = objPaadm.PatientID;
		var objPatient = obj.CurrPatient;
		if (!objPatient) {
			ExtTool.alert("错误提示", "病人基本信息加载错误!");
			return;
		}
        //打印的年龄与报告的年龄保持一致处理，小于一天按一天处理
		var Age = ExtTool.RunServerMethod("DHCMed.SSIO.FromHisSrv","GetPapmiAge",PatientID,obj.CurrReport.EpisodeID,obj.CurrPaadm.AdmitDate,obj.CurrPaadm.AdmitTime);
		objPatient.Age=0, objPatient.AgeMonth=0,objPatient.AgeDay=0
		if(Age.indexOf("岁")>-1){
			objPatient.Age=Age.replace("岁", "");
		}else if(Age.indexOf("月")>-1){
			objPatient.AgeMonth =Age.replace("月", "");
		}else if(Age.indexOf("天")>-1){
			objPatient.AgeDay =Age.replace("天", "");
		}else{
			objPatient.AgeDay=1
		}
		
		var SecretStr = ExtTool.RunServerMethod("DHCMed.SSIO.FromSecSrv","GetPatEncryptLevel",PatientID,"");
		objPatient.PatLevel=""
		if (SecretStr!="") {
			objPatient.PatLevel=SecretStr.split("^")[1];
		}
		//特殊医院病案号按就诊取
		var MrNo=obj.ClsCommonClsSrv.GetMrNoByAdm(obj.CurrReport.EpisodeID);
		if (MrNo){
			objPaadm.MrNo = MrNo;
		}
		
		//加载打印模板
		try {
			var objApp = new ActiveXObject("Word.Application");
			var objDoc = objApp.Documents.Add(filePath);
		} catch (e) {
			ExtTool.alert("错误提示", "打印模板加载错误!");
			objApp.Quit(0);
			objApp=null;
			return;
		}
		
		//加载字典
		objApp.Run("AddDic", "NINFInfDiseasePrognosis", obj.GetPrtDic("NINFInfDiseasePrognosis"));   //疾病转归
		objApp.Run("AddDic", "NINFInfDeathRelation", obj.GetPrtDic("NINFInfDeathRelation"));         //与死亡关系
		objApp.Run("AddDic", "NINFInfICUBoolean", obj.GetPrtDic("NINFInfICUBoolean"));               //入住ICU[是/否]
		objApp.Run("AddDic", "NINFInfICULocation", obj.GetPrtDic("NINFInfICULocation"));             //ICU科别
		objApp.Run("AddDic", "NINFInfOprBoolean", obj.GetPrtDic("NINFInfOprBoolean"));               //手术[是/否]
		objApp.Run("AddDic", "NINFInfInfFactors", obj.GetPrtDic("NINFInfInfFactors"));               //易感因素
		objApp.Run("AddDic", "NINFInfInvasiveOper", obj.GetPrtDic("NINFInfInvasiveOper"));           //侵害性操作
		objApp.Run("AddDic", "NINFInfLabBoolean", obj.GetPrtDic("NINFInfLabBoolean"));               //病原学检验[是/否]
		objApp.Run("AddDic", "NINFInfAntiBoolean", obj.GetPrtDic("NINFInfAntiBoolean"));             //使用抗菌药物[是/否]
		objApp.Run("AddDic", "NINFInfAdverseReaction", obj.GetPrtDic("NINFInfAdverseReaction"));     //不良反应
		objApp.Run("AddDic", "NINFInfSuperinfection", obj.GetPrtDic("NINFInfSuperinfection"));       //二重感染
		
		//直接显示
		objApp.Visible = true;
		
		//导出Word
		objApp.Run("ExportToWord",objPrtReport,objPaadm,objPatient);
		
		//打印预览
		//objApp.Visible = true;
		//objApp.ActiveDocument.PrintPreview(0);
		
		//直接打印
		//objApp.Visible = false;
		//objApp.ActiveDocument.PrintOut(0);
		//objApp.Quit(0);
		//objApp=null;
	}
	
	obj.GetPrtReport = function(objPrtReport) {
		//易感因素
		var arrInfFactors = objPrtReport.ChildSumm.InfFactors;
		objPrtReport.ChildSumm.InfFactors= new ActiveXObject("Scripting.Dictionary");
		for (var ind = 0; ind < arrInfFactors.length; ind++) {
			var objDic = arrInfFactors[ind];
			if (!objDic) continue;
			objPrtReport.ChildSumm.InfFactors.add(ind,objDic);
		}
		
		//侵害性操作
		var arrInvasiveOperation = objPrtReport.ChildSumm.InvasiveOperation;
		objPrtReport.ChildSumm.InvasiveOperation= new ActiveXObject("Scripting.Dictionary");
		for (var ind = 0; ind < arrInvasiveOperation.length; ind++) {
			var objDic = arrInvasiveOperation[ind];
			if (!objDic) continue;
			objPrtReport.ChildSumm.InvasiveOperation.add(ind,objDic);
		}
		
		//疾病诊断
		var arrChild = objPrtReport.ChildDiag;
		objPrtReport.ChildDiag = new ActiveXObject("Scripting.Dictionary");
		for (var indRec = 0; indRec < arrChild.length; indRec++) {
			var objChild = arrChild[indRec];
			if (!objChild) continue;
			objPrtReport.ChildDiag.add(indRec,objChild);
		}
		
		//感染信息
		var arrChild = objPrtReport.ChildInfPos;
		objPrtReport.ChildInfPos = new ActiveXObject("Scripting.Dictionary");
		for (var indRec = 0; indRec < arrChild.length; indRec++) {
			var objChild = arrChild[indRec];
			if (!objChild) continue;
			
			var arrInfPosOpr = objChild.InfPosOpr;
			objChild.InfPosOpr = new ActiveXObject("Scripting.Dictionary");
			for (var indOpr = 0; indOpr < arrInfPosOpr.length; indOpr++) {
				var objInfPosOpr = arrInfPosOpr[indOpr];
				if (!objInfPosOpr) continue;
				objChild.InfPosOpr.add(indOpr,objInfPosOpr);
			}
			objPrtReport.ChildInfPos.add(indRec,objChild);
			
			//add by zf 20130615 诊断依据
			if ((objChild.DiagnosisBasis != '')&&(objPrtReport.ChildSumm.DiagnosisBasis != ''))
			{
				objPrtReport.ChildSumm.DiagnosisBasis = objPrtReport.ChildSumm.DiagnosisBasis + ' ' + objChild.DiagnosisBasis;
			} else {
				objPrtReport.ChildSumm.DiagnosisBasis = objPrtReport.ChildSumm.DiagnosisBasis + objChild.DiagnosisBasis;
			}
			//add by zf 20130615 感染性疾病病程
			if ((objChild.DiseaseCourse != '')&&(objPrtReport.ChildSumm.DiseaseCourse != ''))
			{
				objPrtReport.ChildSumm.DiseaseCourse = objPrtReport.ChildSumm.DiseaseCourse + ' ' + objChild.DiseaseCourse;
			} else {
				objPrtReport.ChildSumm.DiseaseCourse = objPrtReport.ChildSumm.DiseaseCourse + objChild.DiseaseCourse;
			}
		}
		
		//手术相关
		var arrChild = objPrtReport.ChildOpr;
		objPrtReport.ChildOpr = new ActiveXObject("Scripting.Dictionary");
		for (var indRec = 0; indRec < arrChild.length; indRec++) {
			var objChild = arrChild[indRec];
			if (!objChild) continue;
			objPrtReport.ChildOpr.add(indRec,objChild);
		}
		
		//病原学检验
		var arrChild = objPrtReport.ChildLab;
		objPrtReport.ChildLab = new ActiveXObject("Scripting.Dictionary");
		for (var indRec = 0; indRec < arrChild.length; indRec++) {
			var objChild = arrChild[indRec];
			if (!objChild) continue;
			
			var arrPy = objChild.TestResults;
			objChild.TestResults = new ActiveXObject("Scripting.Dictionary");
			for (var indPy = 0; indPy < arrPy.length; indPy++) {
				var objTestResults = arrPy[indPy];
				if (!objTestResults) continue;
				
				var arrAnti = objTestResults.DrugSenTest;
				objTestResults.DrugSenTest = new ActiveXObject("Scripting.Dictionary");
				for (var indAnti = 0; indAnti < arrAnti.length; indAnti++) {
					var objDrugSenTest = arrAnti[indAnti];
					if (!objDrugSenTest) continue;
					
					objTestResults.DrugSenTest.add(indAnti,objDrugSenTest);
				}
				objChild.TestResults.add(indPy,objTestResults);
			}
			objPrtReport.ChildLab.add(indRec,objChild);
		}
		
		//抗菌用药
		var arrChild = objPrtReport.ChildAnti;
		objPrtReport.ChildAnti = new ActiveXObject("Scripting.Dictionary");
		for (var indRec = 0; indRec < arrChild.length; indRec++) {
			var objChild = arrChild[indRec];
			if (!objChild) continue;
			objPrtReport.ChildAnti.add(indRec,objChild);
		}
		
		return objPrtReport;
	}
	
	obj.GetPrtDic = function(DicName) {
		var objDic = new ActiveXObject("Scripting.Dictionary");
		var strItems = obj.ClsCommonClsSrv.GetSSDicList(DicName,"");
		var arrItems = strItems.split(String.fromCharCode(1));
		for (var ind = 0; ind < arrItems.length; ind++) {
			var ItemId = arrItems[ind];
			if (!ItemId) continue;
			var objItem = obj.ClsSSDictionary.GetObjById(ItemId);
			if (!objItem) continue;
			objDic.Add(ind, objItem);
		}
		return objDic;
	}
	return obj;
}
function fillxlSheet(xlSheet,cData,cRow,cCol)
{
	var cells = xlSheet.Cells;
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			cells(cRow+i,cCol+j).Value = arryDataY[j];
			//cells(cRow+i,cCol+j).Borders.Weight = 1;
		}
	}
	return cells;
}

function Cleanup(){
	window.clearInterval(idTmr);
	CollectGarbage();
}

//画单元格
function AddCells(objSheet,fRow,fCol,tRow,tCol,xTop,xLeft)
{
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(2).LineStyle=1;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
}

//单元格合并
function MergCells(objSheet,fRow,fCol,tRow,tCol)
{
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).MergeCells =1;
}

//单元格对其
//-4130 左对齐
//-4131 右对齐
//-4108 居中对齐
function HorizontCells(objSheet,fRow,fCol,tRow,tCol,HorizontNum)
{
   objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).HorizontalAlignment=HorizontNum;
}
