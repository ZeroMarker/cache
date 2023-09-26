var EpidemicExport = new Object();

EpidemicExport.Init = function(objForm) {

	EpidemicExport.objInfectionManage = ExtTool.StaticServerObject("DHCMed.EPD.Infection");	// 传染病字典对象
	EpidemicExport.objPatientManage = ExtTool.StaticServerObject("DHCMed.Base.Patient");		// 病人基本信息对象
	EpidemicExport.objPaadmManage = ExtTool.StaticServerObject("DHCMed.Base.PatientAdm");		// 病人就诊信息对象
	EpidemicExport.objRepManage = ExtTool.StaticServerObject("DHCMed.EPD.Epidemic");			// 传染病报告对象
	EpidemicExport.objEpdManage = ExtTool.StaticServerObject("DHCMed.EPDService.EpidemicSrv");
	EpidemicExport.objCtlocManage = ExtTool.StaticServerObject("DHCMed.Base.Ctloc");			// 科室对象
	EpidemicExport.objSSUserManage = ExtTool.StaticServerObject("DHCMed.Base.SSUser");			// 用户对象
	EpidemicExport.objConfigManage = ExtTool.StaticServerObject("DHCMed.SSService.ConfigSrv");	// 家长姓名复选框提示信息
	EpidemicExport.objCommonSrv = ExtTool.StaticServerObject("DHCMed.EPDService.CommonSrv");
	EpidemicExport.objDicManage = ExtTool.StaticServerObject("DHCMed.SS.Dictionary");			// 基础字典对象

	EpidemicExport.DicManage = ExtTool.StaticServerObject("DHCMed.EPDService.EpidemicReportExport");
	EpidemicExport.TemplatePath = EpidemicExport.DicManage.GetTemplatePath();
}

EpidemicExport.ExportReport = function(FilePath, objRep)
{
	var objDoc = EpidemicExport.objApp.Documents.Add(EpidemicExport.TemplatePath + "DHCMedEpidemicReportNew.dot");
	var objPatient = EpidemicExport.objPatientManage.GetObjById(objRep.MEPDPapmiDR);
	var objPatientManage = ExtTool.StaticServerObject("DHCMed.Base.Patient");
	var objPaadmManage = ExtTool.StaticServerObject("DHCMed.Base.PatientAdm")
	var objPaadm = objPaadmManage.GetObjById(objRep.MEPDText1);
	var SecretStr = ExtTool.RunServerMethod("DHCMed.SSIO.FromSecSrv","GetPatEncryptLevel",objRep.MEPDPapmiDR,"");
	var PatLevel=SecretStr.split("^")[1];
	objPatient.PatLevel=PatLevel;
	 
	 //打印的年龄与报告的年龄保持一致处理，小于一天按一天处理
	var Age = ExtTool.RunServerMethod("DHCMed.SSIO.FromHisSrv","GetPapmiAge",objRep.MEPDPapmiDR,objRep.MEPDText1,objPaadm.AdmitDate,objPaadm.AdmitTime);
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
				
	//对有效证件号打印的处理
	var CardNo=objRep.MEPDText5
	var CardType=objRep.MEPDText4	
	if ((CardNo!="")&&(CardType!="")){
		objPatient.PersonalID=CardNo
	}
	
	
	
	//主记录的装配
	var objCurrInfDic = EpidemicExport.objInfectionManage.GetObjById(objRep.MEPDICDDR);
	objRep.AppendixID = objCurrInfDic.MIFAppendix;
	var objDic = EpidemicExport.objDicManage.GetByTypeCode("EPDEMICTYPE",objCurrInfDic.MIFKind, "");
	objCurrInfDic.MIFKindDesc = objDic.Description
	objRep.ICDObj = objCurrInfDic;
	objRep.MEPDAddress = EpidemicExport.DicManage.GetPrintAddress(objRep.RowID);
	var objUser = EpidemicExport.objSSUserManage.GetObjById(objRep.MEPDRepUsrDR);
	objRep.RepUser = objUser;
	var objLocManage = EpidemicExport.objCtlocManage;
	objRep.RepDep = objLocManage.GetObjById(objRep.MEPDLocDR);
	
	if (objRep.MEPDCheckUsrDR != "") {
		var objUserManage = EpidemicExport.objSSUserManage;
		var objUser = objUserManage.GetObjById(objRep.MEPDCheckUsrDR);
		if (objUser){
			objRep.CheckUserName = objUser.Name;
		}else{
			objRep.CheckUserName = "";
		}
	}else{
		objRep.CheckUserName = "";
	}			
	
	// 主记录的附属字典
	EpidemicExport.objApp.Run("AddDic", "EpidemicReportRegion", EpidemicExport.GetDic("EpidemicReportRegion"));
	EpidemicExport.objApp.Run("AddDic", "Career", EpidemicExport.GetDic("Career"));
	EpidemicExport.objApp.Run("AddDic", "EpidemicDiagnoseDegree", EpidemicExport.GetDic("EpidemicDiagnoseDegree"));
	EpidemicExport.objApp.Run("AddDic", "EpidemicSickQuality", EpidemicExport.GetDic("EpidemicSickQuality"));
	EpidemicExport.objApp.Run("AddDic", "EpidemicContact", EpidemicExport.GetDic("EpidemicContact"));
	EpidemicExport.objApp.Run("AddDic", "EpdemicType", EpidemicExport.GetDic("EpdemicType", true)); // Add By LiYang 2011-08-03
	EpidemicExport.objApp.Run("AddEpidemicDic", EpidemicExport.GetEpidemicDic());	
	
	var objAppendDic = EpidemicExport.GetAppendixContents(objRep.RowID);
		// 附卡需要的附属字典
	var objRequest = new ActiveXObject("Msxml2.XMLHTTP");
	objRequest.open("GET", ExtToolSetting.RunQueryPageURL + 
		"?ClassName=DHCMed.EPDService.EpidemicSubSrv" + 
		"&QueryName=QryEpidemicSub" + 
		"&Arg1=" + objRep.RowID + 
		"&Arg2=" + "" + 
		"&Arg3=" + "" + 
		"&Arg4=Y" + 
		"&ArgCnt=4"
	, false);
	objRequest.send();
	var objTmpResult = eval("(" + objRequest.responseText + ")");
	for(var i = 0; i < objTmpResult.total; i ++)
	{
		var objRec = objTmpResult.record[i];
		if (objRec["ItemDic"] != "") {
			EpidemicExport.objApp.Run("AddDic", objRec["ItemDic"], EpidemicExport.GetDic(objRec["ItemDic"]));
			objAppendDic.Add(objAppendDic.Count, {
				ItemCaption : objRec["ItemCaption"],
				ItemValue : objRec["HiddenValue"],
				ItemDic : objRec["ItemDic"],
				ItemType : objRec["ItemType"]
			});		
		}
	}
	
	
	/*
	var objRec = null;
	var objAppendDic = EpidemicExport.GetAppendixContents(objRep.RowID);
	for (var i = 0; i < EpidemicExport.objForm.AppendixGridPanelStore.getCount(); i++) {
		objRec = EpidemicExport.objForm.AppendixGridPanelStore.getAt(i);
		if (objRec.get("ItemDic") != "") {
			objApp.Run("AddDic", objRec.get("ItemDic"), EpidemicExport.GetDic(objRec.get("ItemDic")));
			objAppendDic.Add(objAppendDic.Count, {
						ItemCaption : objRec.get("ItemCaption"),
						ItemValue : objRec.get("HiddenValue"),
						ItemDic : objRec.get("ItemDic"),
						ItemType : objRec.get("ItemType")
					});
		}
	}
	*/
	
	EpidemicExport.objApp.Run("AddAppendixCardList", EpidemicExport.GetAppendixDic());
	
	//Modified By LiYang 2013-04-03 处理被订报告问题
	if((objRep.MEPDStatus == '3') && (objRep.MEPDMepdDR != ""))
	{
		var objLastRep = ExtTool.RunServerMethod("DHCMed.EPD.Epidemic", "GetObjById", objRep.MEPDMepdDR);
		if((objLastRep == null)||(objLastRep == ''))
			objLastRep = objRep;
		EpidemicExport.objApp.Run("ExportToWord", objPatient, objRep, objAppendDic, objLastRep);
	}
	else
	{
		EpidemicExport.objApp.Run("ExportToWord", objPatient, objRep, objAppendDic, objRep);
	}
	
	objDoc.SaveAs(FilePath + "\\" + objPatient.PapmiNo + " " + objPatient.PatientName + " " + objRep.RowID + ".doc");
	objDoc.Close();
	
}


EpidemicExport.ExportEpidemicToWord = function(objRepArry) {
	var objSrc = new ActiveXObject("Shell.Application").BrowseForFolder(0,"请选择路径",0,"");
	if (objSrc!=null){
		//update by zf 2012-12-06
		//FilePath=objSrc.Items().Item().Path;
		if (objSrc.Self.IsFileSystem) {
			FilePath=objSrc.Self.Path;
		} else {
			alert('请选择正确路径!');
			return;
		}
	}
	
	EpidemicExport.objApp = new ActiveXObject("Word.Application");
	// objApp.Visible = true;
	for(var i = 0; i < objRepArry.length; i ++)
	{
		var objRep = objRepArry[i];
		EpidemicExport.ExportReport(FilePath, objRep);
	}
	EpidemicExport.objApp.Quit();
}

EpidemicExport.GetDic = function(DicName, UseCode) {
	var strRet = EpidemicExport.DicManage.GetDic(DicName, 1);
	var arryRows = strRet.split(String.fromCharCode(1));
	var arryFields = null;
	var objDic = new ActiveXObject("Scripting.Dictionary");
	var objItem = null;
	for (var i = 0; i < arryRows.length; i++) {
		if (arryRows[i] == "") {
			continue;
		}
		arryFields = arryRows[i].split("^");
		objItem = {
			Code : arryFields[0],
			Description : arryFields[1]
		};
		if (UseCode) {
			objDic.Add(objItem.Code, objItem);
		} else {
			objDic.Add(i, objItem);
		}

	}
	//window.alert(DicName + "   " + objDic.Count  );
	return objDic;
}

EpidemicExport.GetEpidemicDic = function() {
	var strRet = EpidemicExport.DicManage.GetEpidemicDic();
	var arryRows = strRet.split(String.fromCharCode(1));
	var arryFields = null;
	var objDic = new ActiveXObject("Scripting.Dictionary");
	var objItem = null;
	for (var i = 0; i < arryRows.length; i++) {
		if (arryRows[i] == "") {
			continue;
		}
		arryFields = arryRows[i].split("^");
		objItem = {
			RowID : arryFields[0],
			Disease : arryFields[1]
		};
		objDic.Add(arryFields[0], objItem);
	}
	return objDic;
}

EpidemicExport.GetAppendixDic = function() {
	var strRet = EpidemicExport.DicManage.GetAppendixDic();
	var arryRows = strRet.split(String.fromCharCode(1));
	var arryFields = null;
	var objDic = new ActiveXObject("Scripting.Dictionary");
	var objItem = null;
	for (var i = 0; i < arryRows.length; i++) {
		if (arryRows[i] == "") {
			continue;
		}
		arryFields = arryRows[i].split("^");
		objItem = {
			RowID : arryFields[0],
			Code : arryFields[1],
			Description : arryFields[2]
		};
		objDic.Add(i, objItem);
	}
	return objDic;
}

EpidemicExport.GetAppendixContents = function(ReportID) {
	var strRet = EpidemicExport.DicManage.GetAppendixContents(ReportID);
	// window.alert(strRet);
	var arryRows = strRet.split(String.fromCharCode(1));
	var arryFields = null;
	var objDic = new ActiveXObject("Scripting.Dictionary");
	var objItem = null;
	for (var i = 0; i < arryRows.length; i++) {
		if (arryRows[i] == "") {
			continue;
		}
		arryFields = arryRows[i].split("^");
		objItem = {
			RowID : arryFields[0],
			ItemCaption : arryFields[1],
			ItemValue : arryFields[2],
			ItemType : arryFields[3],
			ItemDic : arryFields[4]
		};
		objDic.Add(i, objItem);
	}
	return objDic;
}
