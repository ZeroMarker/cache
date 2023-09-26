
function InitCSSReportEvent(obj){
	//obj.ClinReportCls = ExtTool.StaticServerObject("DHCMed.NINFService.CSS.ClinReport");
	obj.LoadEvent = function(){
		window.returnValue = ReportID;
		obj.btnReport.on("click",obj.btnReport_click,obj);
		obj.btnPrint.on("click",obj.btnPrint_click,obj);
		obj.btnClose.on("click",obj.btnClose_click,obj);
		obj.cbgIsInfection.on("change",obj.cbgIsInfection_change,obj);
		obj.cbgAnti1.on("change",obj.cbgAnti1_change,obj);
		obj.cbgOper1.on("change",obj.cbgOper1_change,obj);
		obj.InitReport();
		obj.cbgIsInfection_change();
		obj.cbgAnti1_change();
		obj.cbgOper1_change();
		
		obj.AntiInfoDiv_expand();
		obj.LabInfoDiv_expand();
		obj.OperInfoDiv_expand();
	}
	
	obj.btnClose_click = function(){
		window.close();
	}
	
	obj.cbgOper1_change = function(){
		var isFlag=(Common_GetText("cbgOper1") == '否');
		if (isFlag){
			Common_SetValue("cbgOper2",'');
			Common_SetValue("cbgOper3",'');
			Common_SetValue("cbgOper4",'');
		}
		Common_SetDisabled("cbgOper2",isFlag);
		Common_SetDisabled("cbgOper3",isFlag);
		Common_SetDisabled("cbgOper4",isFlag);
	}
	
	obj.cbgAnti1_change = function(){
		var isFlag=(Common_GetText("cbgAnti1") == '否');
		if (isFlag){
			Common_SetValue("cbgAnti2",'');
			Common_SetValue("cbgAnti3",'');
			Common_SetValue("cbgAnti4",'');
		}
		Common_SetDisabled("cbgAnti2",isFlag);
		Common_SetDisabled("cbgAnti3",isFlag);
		Common_SetDisabled("cbgAnti4",isFlag);
	}
	
	obj.cbgIsInfection_change = function(){
		var isFlag=(Common_GetText("cbgIsInfection") == '否');
		if (isFlag){
			Common_SetValue("cboInfPos1",'','');
			Common_SetValue("txtInfDate1",'');
			Common_SetValue("txtPathogen1A",'');
			Common_SetValue("txtPathogen1B",'');
			Common_SetValue("txtPathogen1C",'');
			Common_SetValue("cboInfPos2",'','');
			Common_SetValue("txtInfDate2",'');
			Common_SetValue("txtPathogen2A",'');
			Common_SetValue("txtPathogen2B",'');
			Common_SetValue("txtPathogen2C",'');
			Common_SetValue("cboInfPos3",'','');
			Common_SetValue("txtInfDate3",'');
			Common_SetValue("txtPathogen3A",'');
			Common_SetValue("txtPathogen3B",'');
			Common_SetValue("txtPathogen3C",'');
		}
		Common_SetDisabled("cboInfPos1",isFlag);
		Common_SetDisabled("txtInfDate1",isFlag);
		Common_SetDisabled("txtPathogen1A",isFlag);
		Common_SetDisabled("txtPathogen1B",isFlag);
		Common_SetDisabled("txtPathogen1C",isFlag);
		Common_SetDisabled("cboInfPos2",isFlag);
		Common_SetDisabled("txtInfDate2",isFlag);
		Common_SetDisabled("txtPathogen2A",isFlag);
		Common_SetDisabled("txtPathogen2B",isFlag);
		Common_SetDisabled("txtPathogen2C",isFlag);
		Common_SetDisabled("cboInfPos3",isFlag);
		Common_SetDisabled("txtInfDate3",isFlag);
		Common_SetDisabled("txtPathogen3A",isFlag);
		Common_SetDisabled("txtPathogen3B",isFlag);
		Common_SetDisabled("txtPathogen3C",isFlag);
	}
	
	obj.btnReport_click = function(){
		obj.SaveReport();
	}
	
	obj.btnPrint_click = function(){
		var ReportID = obj.CurrReport.RowID;
		//var objTmp = ExtTool.StaticServerObject("DHCMed.Service");
		//var TemplatePath = objTmp.GetTemplatePath();
		var TemplatePath = ExtTool.RunServerMethod("DHCMed.Service","GetTemplatePath");
		var FileName=TemplatePath+"\\\\"+"DHCMed.NINF.CSSReport.xls"
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			alert("创建Excel应用对象失败!");
			return;
		}
		xls.visible=false;
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		//var objCls = ExtTool.StaticServerObject("DHCMed.NINFService.CSS.ClinReport");
		//var flg=objCls.PrintCSSReport("fillxlSheet",ReportID);
		var flg = ExtTool.RunServerMethod("DHCMed.NINFService.CSS.ClinReport","PrintCSSReport","fillxlSheet",ReportID);
		xlSheet.printout();
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
	}
	
	obj.InitReport = function(){
		//obj.CurrReport = obj.ClinReportCls.GetReport(ReportID,EpisodeID,SurvNumber);
		obj.CurrReport = ExtTool.RunServerMethod("DHCMed.NINFService.CSS.ClinReport","GetReport",ReportID,EpisodeID,SurvNumber);
		var objReport = obj.CurrReport;
		Common_SetValue("cboLoc","",objReport.CRLoc);
		Common_SetValue("txtBed",objReport.CRBed);
		Common_SetValue("txtMRNo",objReport.CRMRNo);
		Common_SetValue("txtAdmDate",objReport.CRAdmDate);
		Common_SetValue("txtName",objReport.CRName);
		Common_SetValue("cbgSex","",objReport.CRSex);
		Common_SetValue("txtAgeY",objReport.CRAgeY);
		Common_SetValue("txtAgeM",objReport.CRAgeM);
		Common_SetValue("txtAgeD",objReport.CRAgeD);
		if (objReport.CRDiagnos){
			var strDiagnos = objReport.CRDiagnos;
			var arrDiagnos = strDiagnos.split('#');
			if (arrDiagnos.length>0) Common_SetValue("txtDiagnos1",arrDiagnos[0]);
			if (arrDiagnos.length>1) Common_SetValue("txtDiagnos2",arrDiagnos[1]);
			if (arrDiagnos.length>2) Common_SetValue("txtDiagnos3",arrDiagnos[2]);
		}
		Common_SetValue("cbgAddOns4","",objReport.CRAddOns4);
		Common_SetValue("cbgIsInfection","",objReport.CRIsInfection);
		Common_SetValue("cboInfPos1","",objReport.CRInfPos1);
		Common_SetValue("txtInfDate1",objReport.CRInfDate1);
		if (objReport.CRPathogen1){
			var strPathogen = objReport.CRPathogen1;
			var arrPathogen = strPathogen.split('#');
			if (arrPathogen.length>0) Common_SetValue("txtPathogen1A",arrPathogen[0]);
			if (arrPathogen.length>1) Common_SetValue("txtPathogen1B",arrPathogen[1]);
			if (arrPathogen.length>2) Common_SetValue("txtPathogen1C",arrPathogen[2]);
		}
		Common_SetValue("cboInfPos2","",objReport.CRInfPos2);
		Common_SetValue("txtInfDate2",objReport.CRInfDate2);
		if (objReport.CRPathogen2){
			var strPathogen = objReport.CRPathogen2;
			var arrPathogen = strPathogen.split('#');
			if (arrPathogen.length>0) Common_SetValue("txtPathogen2A",arrPathogen[0]);
			if (arrPathogen.length>1) Common_SetValue("txtPathogen2B",arrPathogen[1]);
			if (arrPathogen.length>2) Common_SetValue("txtPathogen2C",arrPathogen[2]);
		}
		Common_SetValue("cboInfPos3","",objReport.CRInfPos3);
		Common_SetValue("txtInfDate3",objReport.CRInfDate3);
		if (objReport.CRPathogen3){
			var strPathogen = objReport.CRPathogen3;
			var arrPathogen = strPathogen.split('#');
			if (arrPathogen.length>0) Common_SetValue("txtPathogen3A",arrPathogen[0]);
			if (arrPathogen.length>1) Common_SetValue("txtPathogen3B",arrPathogen[1]);
			if (arrPathogen.length>2) Common_SetValue("txtPathogen3C",arrPathogen[2]);
		}
		Common_SetValue("cbgAnti1","",objReport.CRAnti1);
		Common_SetValue("cbgAnti2","",objReport.CRAnti2);
		Common_SetValue("cbgAnti3","",objReport.CRAnti3);
		Common_SetValue("cbgAnti4","",objReport.CRAnti4);
		Common_SetValue("cbgOper1","",objReport.CROper1);
		Common_SetValue("cbgOper2","",objReport.CROper2);
		Common_SetValue("cbgOper3","",objReport.CROper3);
		Common_SetValue("cbgOper4","",objReport.CROper4);
		Common_SetValue("cbgAddOns1","",objReport.CRAddOns1);
		Common_SetValue("cbgAddOns2","",objReport.CRAddOns2);
		Common_SetValue("cbgAddOns3","",objReport.CRAddOns3);
		
		//Common_SetValue("txtSurvDate",objReport.CRSurvDate);
		Common_SetDateValue("txtSurvDate",objReport.CRSurvDate);
		Common_SetValue("txtSurvLoc",objReport.CRSurvLoc);
		if (objReport.CRSurvUser){
			Common_SetValue("txtSurvUser",objReport.CRSurvUser);
		} else {
			Common_SetValue("txtSurvUser",session['LOGON.USERNAME']);
		}
		
		objReport.CRUpdateDate = "";
		objReport.CRUpdateTime = "";
		if (objReport.CRUpdateUser == ""){
			objReport.CRUpdateUser = session['LOGON.USERID'];
		}
		if (objReport.CRUpdateLoc == ""){
			objReport.CRUpdateLoc = session['LOGON.CTLOCID'];
		}
	}
	
	obj.SaveReport = function(){
		var objReport = obj.CurrReport;
		if (objReport.CREpisodeID == '') objReport.CREpisodeID = EpisodeID;
		if (objReport.CRSurvNumber == '') objReport.CRSurvNumber = SurvNumber;
		if (objReport.CRIsActive == '') objReport.CRIsActive = 1;
		objReport.CRLoc = Common_GetText("cboLoc");
		objReport.CRBed = Common_GetValue("txtBed");
		objReport.CRMRNo = Common_GetValue("txtMRNo");
		objReport.CRAdmDate = Common_GetValue("txtAdmDate");
		objReport.CRName = Common_GetValue("txtName");
		objReport.CRSex = Common_GetText("cbgSex");
		objReport.CRAgeY = Common_GetValue("txtAgeY");
		objReport.CRAgeM = Common_GetValue("txtAgeM");
		objReport.CRAgeD = Common_GetValue("txtAgeD");
		objReport.CRDiagnos = Common_GetValue("txtDiagnos1")
			+ "#" + Common_GetValue("txtDiagnos2")
			+ "#" + Common_GetValue("txtDiagnos3")
		
		objReport.CRIsInfection = Common_GetText("cbgIsInfection");
		objReport.CRInfPos1 = Common_GetText("cboInfPos1");
		objReport.CRInfDate1 = Common_GetValue("txtInfDate1");
		objReport.CRPathogen1 = Common_GetValue("txtPathogen1A")
			+ "#" + Common_GetValue("txtPathogen1B")
			+ "#" + Common_GetValue("txtPathogen1C")
		objReport.CRInfPos2 = Common_GetText("cboInfPos2");
		objReport.CRInfDate2 = Common_GetValue("txtInfDate2");
		objReport.CRPathogen2 = Common_GetValue("txtPathogen2A")
			+ "#" + Common_GetValue("txtPathogen2B")
			+ "#" + Common_GetValue("txtPathogen2C")
		objReport.CRInfPos3 = Common_GetText("cboInfPos3");
		objReport.CRInfDate3 = Common_GetValue("txtInfDate3");
		objReport.CRPathogen3 = Common_GetValue("txtPathogen3A")
			+ "#" + Common_GetValue("txtPathogen3B")
			+ "#" + Common_GetValue("txtPathogen3C")
		
		objReport.CRAnti1 = Common_GetText("cbgAnti1");
		objReport.CRAnti2 = Common_GetText("cbgAnti2");
		objReport.CRAnti3 = Common_GetText("cbgAnti3");
		objReport.CRAnti4 = Common_GetText("cbgAnti4");
		
		objReport.CROper1 = Common_GetText("cbgOper1");
		objReport.CROper2 = Common_GetText("cbgOper2");
		objReport.CROper3 = Common_GetText("cbgOper3");
		objReport.CROper4 = Common_GetText("cbgOper4");
		
		objReport.CRAddOns1 = Common_GetText("cbgAddOns1");
		objReport.CRAddOns2 = Common_GetText("cbgAddOns2");
		objReport.CRAddOns3 = Common_GetText("cbgAddOns3");
		objReport.CRAddOns4 = Common_GetText("cbgAddOns4");
		
		objReport.CRSurvLoc = Common_GetValue("txtSurvLoc");
		objReport.CRSurvUser = Common_GetValue("txtSurvUser");
		
		var errInfo = obj.CheckReport(objReport);
		if (errInfo!=''){
			ExtTool.alert("错误提示", errInfo);
			return;
		}
		
		var strInput = '';
		strInput = strInput + CHR_1 + objReport.CREpisodeID;
		strInput = strInput + CHR_1 + objReport.CRSurvNumber;
		strInput = strInput + CHR_1 + objReport.CRSurvDate;
		strInput = strInput + CHR_1 + objReport.CRSurvLoc;
		strInput = strInput + CHR_1 + objReport.CRSurvUser;
		strInput = strInput + CHR_1 + objReport.CRIsActive;
		strInput = strInput + CHR_1 + objReport.CRMRNo;
		strInput = strInput + CHR_1 + objReport.CRName;
		strInput = strInput + CHR_1 + objReport.CRSex;
		strInput = strInput + CHR_1 + objReport.CRAgeY;
		strInput = strInput + CHR_1 + objReport.CRAgeM;
		strInput = strInput + CHR_1 + objReport.CRAgeD;
		strInput = strInput + CHR_1 + objReport.CRLoc;
		strInput = strInput + CHR_1 + objReport.CRBed;
		strInput = strInput + CHR_1 + objReport.CRAdmDate;
		strInput = strInput + CHR_1 + objReport.CRDiagnos;
		strInput = strInput + CHR_1 + objReport.CRIsInfection;
		strInput = strInput + CHR_1 + objReport.CRInfPos1;
		strInput = strInput + CHR_1 + objReport.CRInfDate1;
		strInput = strInput + CHR_1 + objReport.CRPathogen1;
		strInput = strInput + CHR_1 + objReport.CRInfPos2;
		strInput = strInput + CHR_1 + objReport.CRInfDate2;
		strInput = strInput + CHR_1 + objReport.CRPathogen2;
		strInput = strInput + CHR_1 + objReport.CRInfPos3;
		strInput = strInput + CHR_1 + objReport.CRInfDate3;
		strInput = strInput + CHR_1 + objReport.CRPathogen3;
		strInput = strInput + CHR_1 + objReport.CRAnti1;
		strInput = strInput + CHR_1 + objReport.CRAnti2;
		strInput = strInput + CHR_1 + objReport.CRAnti3;
		strInput = strInput + CHR_1 + objReport.CRAnti4;
		strInput = strInput + CHR_1 + objReport.CROper1;
		strInput = strInput + CHR_1 + objReport.CROper2;
		strInput = strInput + CHR_1 + objReport.CROper3;
		strInput = strInput + CHR_1 + objReport.CROper4;
		strInput = strInput + CHR_1 + objReport.CRAddOns1;
		strInput = strInput + CHR_1 + objReport.CRAddOns2;
		strInput = strInput + CHR_1 + objReport.CRAddOns3;
		strInput = strInput + CHR_1 + objReport.CRAddOns4;
		strInput = strInput + CHR_1 + objReport.CRUpdateDate;
		strInput = strInput + CHR_1 + objReport.CRUpdateTime;
		strInput = strInput + CHR_1 + objReport.CRUpdateLoc;
		strInput = strInput + CHR_1 + objReport.CRUpdateUser;
		
		//var ret = obj.ClinReportCls.SaveReport(strInput,CHR_1);
		var ret = ExtTool.RunServerMethod("DHCMed.NINFService.CSS.ClinReport","SaveReport",strInput,CHR_1);
		if (ret*1>0){
			ExtTool.alert("提示", "保存报告!");
			ReportID = ret;
			obj.InitReport();
			window.returnValue = ReportID;
		} else {
			ExtTool.alert("提示", "保存失败!");
			window.returnValue = "";
		}
	}
	
	obj.CheckReport = function(objReport)
	{
		var errInfo = '';
		if (objReport.CRLoc=='') errInfo += '科室为空<br>';
		if (objReport.CRBed=='') errInfo += '床位为空<br>';
		if (objReport.CRMRNo=='') errInfo += '病案号为空<br>';
		if (objReport.CRAdmDate=='') errInfo += '入院日期为空<br>';
		if (objReport.CRName=='') errInfo += '姓名为空<br>';
		if (objReport.CRSex=='') errInfo += '性别为空<br>';
		if (((objReport.CRAgeY=='')||(objReport.CRAgeY=='0'))
		&&((objReport.CRAgeM=='')||(objReport.CRAgeM=='0'))
		&&((objReport.CRAgeD=='')||(objReport.CRAgeD=='0'))){
			errInfo += '年龄(年月日)不能同时为空<br>';
		}
		if ((objReport.CRDiagnos=='##')||(objReport.CRDiagnos=='')) errInfo += '基础疾病诊断为空!<br>';
		if (objReport.CRAddOns4=='') errInfo += '过去24小时内是否有≥3次的腹泻为空!<br>';
		
		if (objReport.CRIsInfection==''){
			errInfo += '医院感染（是、否）为空!<br>';
		} else if (objReport.CRIsInfection=='是') {
			if (objReport.CRInfPos1=='') errInfo += '感染部位为空!<br>';
			if (objReport.CRInfDate1=='') errInfo += '感染日期为空!<br>';
		}
		if (((objReport.CRInfPos1=='')&&(objReport.CRInfDate1!=''))
		||((objReport.CRInfPos1!='')&&(objReport.CRInfDate1==''))
		||((objReport.CRInfPos2=='')&&(objReport.CRInfDate2!=''))
		||((objReport.CRInfPos2!='')&&(objReport.CRInfDate2==''))
		||((objReport.CRInfPos3=='')&&(objReport.CRInfDate3!=''))
		||((objReport.CRInfPos3!='')&&(objReport.CRInfDate3==''))){
			errInfo += '感染部位与感染日期应同时填写!<br>';
		}
		
		if (objReport.CRAnti1==''){
			errInfo += '抗菌药物使用（是、否）为空!<br>';
		} else if (objReport.CRAnti1=='是') {
			if (objReport.CRAnti2=='') errInfo += '抗菌药物使用-目的为空!<br>';
			if (objReport.CRAnti3=='') errInfo += '抗菌药物使用-联用为空!<br>';
			if (objReport.CRAnti4=='') errInfo += '抗菌药物使用-治疗用药前后送细菌培养为空!<br>';
		}
		
		if (objReport.CROper1==''){
			errInfo += '手术（是、否）为空!<br>';
		} else if (objReport.CROper1=='是') {
			if (objReport.CROper2=='') errInfo += '手术-术前应用抗菌药物为空!<br>';
			if (objReport.CROper3=='') errInfo += '手术-手术切口等级为空!<br>';
			if (objReport.CROper4=='') errInfo += '手术-Ⅰ、Ⅱ级切口围手术期用药为空!<br>';
		}
		
		if (objReport.CRAddOns1=='') errInfo += '动静脉插管为空!<br>';
		if (objReport.CRAddOns2=='') errInfo += '泌尿道插管为空!<br>';
		if (objReport.CRAddOns3=='') errInfo += '使用呼吸机为空!<br>';
		
		return errInfo;
	}
	
	obj.AntiInfoDiv_expand = function(){
		var divID = "div-AntiInfo";
		if (document.all[divID].style.display == 'none') {
			document.all[divID].style.display = 'block';
		} else {
			document.all[divID].style.display = 'none';
		}
		if (obj.AntiFlag == 0){
			obj.AntiFlag = 1;
			Ext.Ajax.request({
				url : ExtToolSetting.RunQueryPageURL,
				method : "POST",
				params  : {
					ClassName : 'DHCMed.NINFService.CSS.ClinSrcData',
					QueryName : 'QryAntiList',
					Arg1 : EpisodeID,
					ArgCnt : 1
				},
				success: function(response, opts) {
					var objData = Ext.decode(response.responseText);
					var arryData = new Array();
					var objItem = null;
					for(var i = 0; i < objData.total; i ++)
					{
						objItem = objData.record[i];
						arryData[arryData.length] = objItem;
					}
					obj.AntiTemplate.overwrite(divID, arryData);
					document.all[divID].style.display = 'none';
				},
				failure: function(response, opts) {
					var objTargetElement = document.getElementById(divID);
					if (objTargetElement) {
						objTargetElement.innerHTML = response.responseText;
					}
				}
			});
		}
	}
	
	obj.OperInfoDiv_expand = function(){
		var divID = "div-OperInfo";
		if (document.all[divID].style.display == 'none') {
			document.all[divID].style.display = 'block';
		} else {
			document.all[divID].style.display = 'none';
		}
		if (obj.OperFlag == 0){
			obj.OperFlag = 1;
			Ext.Ajax.request({
				url : ExtToolSetting.RunQueryPageURL,
				method : "POST",
				params  : {
					ClassName : 'DHCMed.NINFService.CSS.ClinSrcData',
					QueryName : 'QryOperList',
					Arg1 : EpisodeID,
					ArgCnt : 1
				},
				success: function(response, opts) {
					var objData = Ext.decode(response.responseText);
					var arryData = new Array();
					var objItem = null;
					for(var i = 0; i < objData.total; i ++)
					{
						objItem = objData.record[i];
						arryData[arryData.length] = objItem;
					}
					obj.OperTemplate.overwrite(divID, arryData);
					document.all[divID].style.display = 'none';
				},
				failure: function(response, opts) {
					var objTargetElement = document.getElementById(divID);
					if (objTargetElement) {
						objTargetElement.innerHTML = response.responseText;
					}
				}
			});
		}
	}
	
	obj.LabInfoDiv_expand = function(){
		var divID = "div-LabInfo";
		if (document.all[divID].style.display == 'none') {
			document.all[divID].style.display = 'block';
		} else {
			document.all[divID].style.display = 'none';
		}
		if (obj.LabFlag == 0){
			obj.LabFlag = 1;
			Ext.Ajax.request({
				url : ExtToolSetting.RunQueryPageURL,
				method : "POST",
				params  : {
					ClassName : 'DHCMed.NINFService.CSS.ClinSrcData',
					QueryName : 'QryLabList',
					Arg1 : EpisodeID,
					ArgCnt : 1
				},
				success: function(response, opts) {
					var objData = Ext.decode(response.responseText);
					var arryData = new Array();
					var objItem = null;
					for(var i = 0; i < objData.total; i ++)
					{
						objItem = objData.record[i];
						arryData[arryData.length] = objItem;
					}
					obj.LabTemplate.overwrite(divID, arryData);
					document.all[divID].style.display = 'none';
				},
				failure: function(response, opts) {
					var objTargetElement = document.getElementById(divID);
					if (objTargetElement) {
						objTargetElement.innerHTML = response.responseText;
					}
				}
			});
		}
	}
}
