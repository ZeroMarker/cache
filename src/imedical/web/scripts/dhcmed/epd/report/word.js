var EpidemicExport = new Object();

EpidemicExport.Init = function(objForm) {
	EpidemicExport.objForm = objForm;
	EpidemicExport.DicManage = ExtTool.StaticServerObject("DHCMed.EPDService.EpidemicReportExport");
	EpidemicExport.TemplatePath = EpidemicExport.DicManage.GetTemplatePath();
}

EpidemicExport.ExportEpidemicToWord = function(objRep) {
	var objApp = new ActiveXObject("Word.Application");
	// objApp.Visible = true;
	var objDoc = objApp.Documents.Add(EpidemicExport.TemplatePath + "DHCMedEpidemicReportNew.dot");
	var objPatientManage = ExtTool.StaticServerObject("DHCMed.Base.Patient");
	var objPaadmManage = ExtTool.StaticServerObject("DHCMed.Base.PatientAdm");		
	var objPatient = objPatientManage.GetObjById(objRep.MEPDPapmiDR);
	var objPaadm = objPaadmManage.GetObjById(objRep.MEPDText1);
	
	var SecretStr = ExtTool.RunServerMethod("DHCMed.SSIO.FromSecSrv","GetPatEncryptLevel",objRep.MEPDPapmiDR,"");
	var PatLevel=SecretStr.split("^")[1];
	objPatient.PatLevel=PatLevel;
	 
	 //��ӡ�������뱨������䱣��һ�´���С��һ�찴һ�촦��
	var Age = ExtTool.RunServerMethod("DHCMed.SSIO.FromHisSrv","GetPapmiAge",objRep.MEPDPapmiDR,objRep.MEPDText1,objPaadm.AdmitDate,objPaadm.AdmitTime);
	objPatient.Age=0, objPatient.AgeMonth=0,objPatient.AgeDay=0
	if(Age.indexOf("��")>-1){
		//objPatient.Age=Age.replace("��", "");
		objPatient.Age=Age.split("��")[0];  //modify by mxp 2018-01-12 ����Ϊ12��7�� �����ӡ��ʾΪ127��
	}else if(Age.indexOf("��")>-1){
		//objPatient.AgeMonth =Age.replace("��", "");
		objPatient.AgeMonth=Age.split("��")[0];
	}else if(Age.indexOf("��")>-1){
		objPatient.AgeDay =Age.replace("��", "");
	}else{
		objPatient.AgeDay=1
	}
	//����Ч֤���Ŵ�ӡ�Ĵ���
	var CardNo=objRep.MEPDText5
	var CardType=objRep.MEPDText4	
	if ((CardNo!="")&&(CardType!="")){
		objPatient.PersonalID=CardNo
	}
	
	// ����¼�ĸ����ֵ�
	objApp.Run("AddDic", "EpidemicReportRegion", EpidemicExport.GetDic("EpidemicReportRegion"));
	objApp.Run("AddDic", "Career", EpidemicExport.GetDic("Career"));
	objApp.Run("AddDic", "EpidemicDiagnoseDegree", EpidemicExport.GetDic("EpidemicDiagnoseDegree"));
	objApp.Run("AddDic", "EpidemicSickQuality", EpidemicExport.GetDic("EpidemicSickQuality"));
	objApp.Run("AddDic", "EpidemicContact", EpidemicExport.GetDic("EpidemicContact"));
	objApp.Run("AddDic", "EpdemicType", EpidemicExport.GetDic("EpdemicType", true)); // Add By LiYang 2011-08-03
	objApp.Run("AddEpidemicDic", EpidemicExport.GetEpidemicDic());
	
	// ������Ҫ�ĸ����ֵ�
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
	objApp.Run("AddAppendixCardList", EpidemicExport.GetAppendixDic());
	
	//Modified By LiYang 2013-04-03 ��������������
	if((objRep.MEPDStatus == '3') && (objRep.MEPDMepdDR != ""))
	{
		var objLastRep = ExtTool.RunServerMethod("DHCMed.EPD.Epidemic", "GetObjById", objRep.MEPDMepdDR);
		if((objLastRep == null)||(objLastRep == ''))
			objLastRep = objRep;
		objApp.Run("ExportToWord", objPatient, objRep, objAppendDic, objLastRep);
	}
	else
	{
		objApp.Run("ExportToWord", objPatient, objRep, objAppendDic, objRep);
	}
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

//��ȡ����ǩ��ǩ��ͼƬ
EpidemicExport.GetDocSignGif = function(UserID)
{
	var ImgBase64="";
	var ImgBase64=tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","GetDocSignGif",UserID);
	if (ImgBase64==""){
        return false;	//δ�ҵ��û�ǩ����
	}
	//��ȡ������д��c�̳�Ϊ.jpg�ļ�
	var BaseImg= new ActiveXObject("Base64IMGSave.ClsSaveBase64IMG");
	var sReigstNo = UserID;
	var sFiletype= "jpg"
	var rtn=BaseImg.WriteFile(sReigstNo,ImgBase64,sFiletype);
	if(!rtn){
	   return false;	//ǩ��ͼƬת������
	} 
	return true;
}
