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
	       	}catch(e){//Add By LiYang 2014-07-03 Fix Bug:1596 �����ӡʧ�ܣ�Ӧ�ø�����ʾ
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
			ExtTool.alert("������ʾ", "�޴�ӡģ��!");
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
			alert("����ExcelӦ�ö���ʧ��!");
			return false;
		}
		xls.visible=false;
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		
		var flg=obj.PrintReportOPR("fillxlSheet",RepRowID);
		xlSheet.printout();
		//var fname = xls.Application.GetSaveAsFilename("���������","Excel Spreadsheets (*.xls), *.xls");
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
		//ȡ��ӡģ��·��
		var TemplatePath = obj.ClsCommonClsSrv.GetTemplatePath();
		if (!TemplatePath) {
			ExtTool.alert("������ʾ", "��ӡģ��·������!");
			return;
		}
		
		var filePath = '';
		var fileName = '';
		var fileNo = '';
		filePath = TemplatePath + "DHCMedInfectionReportNew.dot";
		fileName = objPrtReport.ReportType.Description;
		fileNo = objPrtReport.RowID;
		
		if (!filePath) {
			ExtTool.alert("������ʾ", "��ӡģ��·������!");
			return;
		}
		
		//ת���������ݸ�ʽ(ת��Ϊ�������Ҫ�ĸ�ʽ,��Ҫ����������ת��)
		objPrtReport = obj.GetPrtReport(objPrtReport);
		if (!objPrtReport) {
			ExtTool.alert("������ʾ", "��ӡ���ݼ��ش���!");
			return;
		}
		
		var objPaadm = obj.CurrPaadm;
		if (!objPaadm) {
			ExtTool.alert("������ʾ", "������Ϣ���ش���!");
			return;
		}
		var PatientID = objPaadm.PatientID;
		var objPatient = obj.CurrPatient;
		if (!objPatient) {
			ExtTool.alert("������ʾ", "���˻�����Ϣ���ش���!");
			return;
		}
		//����ҽԺ�����Ű�����ȡ
		var MrNo=obj.ClsCommonClsSrv.GetMrNoByAdm(obj.CurrReport.EpisodeID);
		if (MrNo){
			objPaadm.MrNo = MrNo;
		}
		
		//���ش�ӡģ��
		try {
			var objApp = new ActiveXObject("Word.Application");
			var objDoc = objApp.Documents.Add(filePath);
		} catch (e) {
			ExtTool.alert("������ʾ", "��ӡģ����ش���!");
			objApp.Quit(0);
			objApp=null;
			return;
		}
		
		//�����ֵ�
		objApp.Run("AddDic", "NINFInfDiseasePrognosis", obj.GetPrtDic("NINFInfDiseasePrognosis"));   //����ת��
		objApp.Run("AddDic", "NINFInfDeathRelation", obj.GetPrtDic("NINFInfDeathRelation"));         //��������ϵ
		objApp.Run("AddDic", "NINFInfICUBoolean", obj.GetPrtDic("NINFInfICUBoolean"));               //��סICU[��/��]
		objApp.Run("AddDic", "NINFInfICULocation", obj.GetPrtDic("NINFInfICULocation"));             //ICU�Ʊ�
		objApp.Run("AddDic", "NINFInfOprBoolean", obj.GetPrtDic("NINFInfOprBoolean"));               //����[��/��]
		objApp.Run("AddDic", "NINFInfInfFactors", obj.GetPrtDic("NINFInfInfFactors"));               //�׸�����
		objApp.Run("AddDic", "NINFInfInvasiveOper", obj.GetPrtDic("NINFInfInvasiveOper"));           //�ֺ��Բ���
		objApp.Run("AddDic", "NINFInfLabBoolean", obj.GetPrtDic("NINFInfLabBoolean"));               //��ԭѧ����[��/��]
		objApp.Run("AddDic", "NINFInfAntiBoolean", obj.GetPrtDic("NINFInfAntiBoolean"));             //ʹ�ÿ���ҩ��[��/��]
		objApp.Run("AddDic", "NINFInfAdverseReaction", obj.GetPrtDic("NINFInfAdverseReaction"));     //������Ӧ
		objApp.Run("AddDic", "NINFInfSuperinfection", obj.GetPrtDic("NINFInfSuperinfection"));       //���ظ�Ⱦ
		
		//ֱ����ʾ
		objApp.Visible = true;
		
		//����Word
		objApp.Run("ExportToWord",objPrtReport,objPaadm,objPatient);
		
		//��ӡԤ��
		//objApp.Visible = true;
		//objApp.ActiveDocument.PrintPreview(0);
		
		//ֱ�Ӵ�ӡ
		//objApp.Visible = false;
		//objApp.ActiveDocument.PrintOut(0);
		//objApp.Quit(0);
		//objApp=null;
	}
	
	obj.GetPrtReport = function(objPrtReport) {
		//�׸�����
		var arrInfFactors = objPrtReport.ChildSumm.InfFactors;
		objPrtReport.ChildSumm.InfFactors= new ActiveXObject("Scripting.Dictionary");
		for (var ind = 0; ind < arrInfFactors.length; ind++) {
			var objDic = arrInfFactors[ind];
			if (!objDic) continue;
			objPrtReport.ChildSumm.InfFactors.add(ind,objDic);
		}
		
		//�ֺ��Բ���
		var arrInvasiveOperation = objPrtReport.ChildSumm.InvasiveOperation;
		objPrtReport.ChildSumm.InvasiveOperation= new ActiveXObject("Scripting.Dictionary");
		for (var ind = 0; ind < arrInvasiveOperation.length; ind++) {
			var objDic = arrInvasiveOperation[ind];
			if (!objDic) continue;
			objPrtReport.ChildSumm.InvasiveOperation.add(ind,objDic);
		}
		
		//�������
		var arrChild = objPrtReport.ChildDiag;
		objPrtReport.ChildDiag = new ActiveXObject("Scripting.Dictionary");
		for (var indRec = 0; indRec < arrChild.length; indRec++) {
			var objChild = arrChild[indRec];
			if (!objChild) continue;
			objPrtReport.ChildDiag.add(indRec,objChild);
		}
		
		//��Ⱦ��Ϣ
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
			
			//add by zf 20130615 �������
			if ((objChild.DiagnosisBasis != '')&&(objPrtReport.ChildSumm.DiagnosisBasis != ''))
			{
				objPrtReport.ChildSumm.DiagnosisBasis = objPrtReport.ChildSumm.DiagnosisBasis + ' ' + objChild.DiagnosisBasis;
			} else {
				objPrtReport.ChildSumm.DiagnosisBasis = objPrtReport.ChildSumm.DiagnosisBasis + objChild.DiagnosisBasis;
			}
			//add by zf 20130615 ��Ⱦ�Լ�������
			if ((objChild.DiseaseCourse != '')&&(objPrtReport.ChildSumm.DiseaseCourse != ''))
			{
				objPrtReport.ChildSumm.DiseaseCourse = objPrtReport.ChildSumm.DiseaseCourse + ' ' + objChild.DiseaseCourse;
			} else {
				objPrtReport.ChildSumm.DiseaseCourse = objPrtReport.ChildSumm.DiseaseCourse + objChild.DiseaseCourse;
			}
		}
		
		//�������
		var arrChild = objPrtReport.ChildOpr;
		objPrtReport.ChildOpr = new ActiveXObject("Scripting.Dictionary");
		for (var indRec = 0; indRec < arrChild.length; indRec++) {
			var objChild = arrChild[indRec];
			if (!objChild) continue;
			objPrtReport.ChildOpr.add(indRec,objChild);
		}
		
		//��ԭѧ����
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
		
		//������ҩ
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
