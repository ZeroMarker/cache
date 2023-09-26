function InitReportWord(obj)
{
	obj.ExportWord = function(objPrtReport)
	{
		if (objPrtReport.ReportType.Code == 'COMP') {
			obj.ExportInfReport(objPrtReport);
		} else if (objPrtReport.ReportType.Code == 'ICU') {
			var fileName="{DHCMed.NINF.ICUReport.raq(aReportID="+objPrtReport.RowID+")}";
        	var printObj=window.document.Dtreport1_directPrintApplet;
	    	try{
		     	printObj.print(fileName);
	       	}catch(e){//Add By LiYang 2014-07-03 Fix Bug:1596 如果打印失败，应该给出提示
				window.alert(err.message);
			}
		} else if (objPrtReport.ReportType.Code == 'NICU') {
			
		} else if (objPrtReport.ReportType.Code == 'OPR') {
			//var fileName="{DHCMed.NINF.OPRReport.raq(aReportID="+objPrtReport.RowID+")}";
       // 	var printObj=window.document.Dtreport1_directPrintApplet;
	    	//try{
		   //  	printObj.print(fileName);
	     //  	}catch(e){ }
	     ExportOPRDataToExcelNew(objPrtReport.RowID);
		} else {
			ExtTool.alert("错误提示", "无打印模板!");
			return;
		}
	}
	
	function ExportOPRDataToExcelNew(RepRowID)
{
		var obj = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.AimReportOPR");
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
		xlSheet.printout();
		//var fname = xls.Application.GetSaveAsFilename("手术调查表","Excel Spreadsheets (*.xls), *.xls");
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
