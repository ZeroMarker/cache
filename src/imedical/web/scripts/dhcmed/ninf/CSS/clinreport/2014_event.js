
function InitCSSReportEvent(obj){
	//obj.ClinReportCls = ExtTool.StaticServerObject("DHCMed.NINFService.CSS.ClinReport");
	obj.LoadEvent = function(){
		window.returnValue = ReportID;
		obj.btnReport.on("click",obj.btnReport_click,obj);
		obj.btnPrint.on("click",obj.btnPrint_click,obj);
		obj.btnClose.on("click",obj.btnClose_click,obj);
		obj.cbgIsInfection.on("change",obj.cbgIsInfection_change,obj);
		obj.cbgInfCategory.on("change",obj.cbgInfCategory_change,obj);
		obj.cbgAnti1.on("change",obj.cbgAnti1_change,obj);
		obj.cbgOper1.on("change",obj.cbgOper1_change,obj);
		obj.InitReport();
		obj.cbgIsInfection_change();
		obj.cbgAnti1_change();
		obj.cbgOper1_change();
		
		obj.AntiInfoDiv_expand();
		obj.LabInfoDiv_expand();
		obj.BugsInfoDiv_expand();
		obj.OperInfoDiv_expand();
	}
	
	obj.btnClose_click = function(){
		window.close();
	}
	
	obj.cbgOper1_change = function(){
		var isFlag=(Common_GetText("cbgOper1") != '是');
		if (isFlag){
			Common_SetValue("cbgOper3",'');
		}
		Common_SetDisabled("cbgOper3",isFlag);
	}
	
	obj.cbgAnti1_change = function(){
		var isFlag=(Common_GetText("cbgAnti1") != '是');
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
		var isFlag=(Common_GetText("cbgIsInfection") != '存在');
		if (isFlag){
			Common_SetValue("cbgInfCategory",'');
		}
		Common_SetDisabled("cbgInfCategory",isFlag);
		obj.cbgInfCategory_change();
	}
	
	obj.cbgInfCategory_change = function(){
		if (Common_GetText("cbgInfCategory") == '医院感染'){
			Common_SetDisabled("cboInfPos1",false);
			Common_SetDisabled("txtPathogen1A",false);
			Common_SetDisabled("txtPathogen1B",false);
			Common_SetDisabled("txtPathogen1C",false);
			Common_SetDisabled("cboInfPos2",false);
			Common_SetDisabled("txtPathogen2A",false);
			Common_SetDisabled("txtPathogen2B",false);
			Common_SetDisabled("txtPathogen2C",false);
			Common_SetDisabled("cboInfPos3",false);
			Common_SetDisabled("txtPathogen3A",false);
			Common_SetDisabled("txtPathogen3B",false);
			Common_SetDisabled("txtPathogen3C",false);
			Common_SetDisabled("cbgAddOns5",false);
			Common_SetDisabled("cboComInfPos1",true);
			Common_SetDisabled("txtComPathogen1A",true);
			Common_SetDisabled("txtComPathogen1B",true);
			Common_SetDisabled("txtComPathogen1C",true);
			Common_SetDisabled("cboComInfPos2",true);
			Common_SetDisabled("txtComPathogen2A",true);
			Common_SetDisabled("txtComPathogen2B",true);
			Common_SetDisabled("txtComPathogen2C",true);
			Common_SetDisabled("cboComInfPos3",true);
			Common_SetDisabled("txtComPathogen3A",true);
			Common_SetDisabled("txtComPathogen3B",true);
			Common_SetDisabled("txtComPathogen3C",true);
			Common_SetValue("cboComInfPos1",'','');
			Common_SetValue("txtComPathogen1A",'');
			Common_SetValue("txtComPathogen1B",'');
			Common_SetValue("txtComPathogen1C",'');
			Common_SetValue("cboComInfPos2",'','');
			Common_SetValue("txtComPathogen2A",'');
			Common_SetValue("txtComPathogen2B",'');
			Common_SetValue("txtComPathogen2C",'');
			Common_SetValue("cboComInfPos3",'','');
			Common_SetValue("txtComPathogen3A",'');
			Common_SetValue("txtComPathogen3B",'');
			Common_SetValue("txtComPathogen3C",'');
		} else if (Common_GetText("cbgInfCategory") == '社区感染'){
			Common_SetDisabled("cboInfPos1",true);
			Common_SetDisabled("txtPathogen1A",true);
			Common_SetDisabled("txtPathogen1B",true);
			Common_SetDisabled("txtPathogen1C",true);
			Common_SetDisabled("cboInfPos2",true);
			Common_SetDisabled("txtPathogen2A",true);
			Common_SetDisabled("txtPathogen2B",true);
			Common_SetDisabled("txtPathogen2C",true);
			Common_SetDisabled("cboInfPos3",true);
			Common_SetDisabled("txtPathogen3A",true);
			Common_SetDisabled("txtPathogen3B",true);
			Common_SetDisabled("txtPathogen3C",true);
			Common_SetDisabled("cbgAddOns5",true);
			Common_SetDisabled("cboComInfPos1",false);
			Common_SetDisabled("txtComPathogen1A",false);
			Common_SetDisabled("txtComPathogen1B",false);
			Common_SetDisabled("txtComPathogen1C",false);
			Common_SetDisabled("cboComInfPos2",false);
			Common_SetDisabled("txtComPathogen2A",false);
			Common_SetDisabled("txtComPathogen2B",false);
			Common_SetDisabled("txtComPathogen2C",false);
			Common_SetDisabled("cboComInfPos3",false);
			Common_SetDisabled("txtComPathogen3A",false);
			Common_SetDisabled("txtComPathogen3B",false);
			Common_SetDisabled("txtComPathogen3C",false);
			Common_SetValue("cboInfPos1",'','');
			Common_SetValue("txtPathogen1A",'');
			Common_SetValue("txtPathogen1B",'');
			Common_SetValue("txtPathogen1C",'');
			Common_SetValue("cboInfPos2",'','');
			Common_SetValue("txtPathogen2A",'');
			Common_SetValue("txtPathogen2B",'');
			Common_SetValue("txtPathogen2C",'');
			Common_SetValue("cboInfPos3",'','');
			Common_SetValue("txtPathogen3A",'');
			Common_SetValue("txtPathogen3B",'');
			Common_SetValue("txtPathogen3C",'');
			Common_SetValue("cbgAddOns5",'');
		} else {
			Common_SetDisabled("cboInfPos1",true);
			Common_SetDisabled("txtPathogen1A",true);
			Common_SetDisabled("txtPathogen1B",true);
			Common_SetDisabled("txtPathogen1C",true);
			Common_SetDisabled("cboInfPos2",true);
			Common_SetDisabled("txtPathogen2A",true);
			Common_SetDisabled("txtPathogen2B",true);
			Common_SetDisabled("txtPathogen2C",true);
			Common_SetDisabled("cboInfPos3",true);
			Common_SetDisabled("txtPathogen3A",true);
			Common_SetDisabled("txtPathogen3B",true);
			Common_SetDisabled("txtPathogen3C",true);
			Common_SetDisabled("cbgAddOns5",true);
			Common_SetDisabled("cboComInfPos1",true);
			Common_SetDisabled("txtComPathogen1A",true);
			Common_SetDisabled("txtComPathogen1B",true);
			Common_SetDisabled("txtComPathogen1C",true);
			Common_SetDisabled("cboComInfPos2",true);
			Common_SetDisabled("txtComPathogen2A",true);
			Common_SetDisabled("txtComPathogen2B",true);
			Common_SetDisabled("txtComPathogen2C",true);
			Common_SetDisabled("cboComInfPos3",true);
			Common_SetDisabled("txtComPathogen3A",true);
			Common_SetDisabled("txtComPathogen3B",true);
			Common_SetDisabled("txtComPathogen3C",true);
			Common_SetValue("cboInfPos1",'','');
			Common_SetValue("txtPathogen1A",'');
			Common_SetValue("txtPathogen1B",'');
			Common_SetValue("txtPathogen1C",'');
			Common_SetValue("cboInfPos2",'','');
			Common_SetValue("txtPathogen2A",'');
			Common_SetValue("txtPathogen2B",'');
			Common_SetValue("txtPathogen2C",'');
			Common_SetValue("cboInfPos3",'','');
			Common_SetValue("txtPathogen3A",'');
			Common_SetValue("txtPathogen3B",'');
			Common_SetValue("txtPathogen3C",'');
			Common_SetValue("cbgAddOns5",'');
			Common_SetValue("cboComInfPos1",'','');
			Common_SetValue("txtComPathogen1A",'');
			Common_SetValue("txtComPathogen1B",'');
			Common_SetValue("txtComPathogen1C",'');
			Common_SetValue("cboComInfPos2",'','');
			Common_SetValue("txtComPathogen2A",'');
			Common_SetValue("txtComPathogen2B",'');
			Common_SetValue("txtComPathogen2C",'');
			Common_SetValue("cboComInfPos3",'','');
			Common_SetValue("txtComPathogen3A",'');
			Common_SetValue("txtComPathogen3B",'');
			Common_SetValue("txtComPathogen3C",'');
		}
	}
	
	obj.btnReport_click = function(){
		obj.SaveReport();
	}
	
	obj.btnPrint_click = function(){
		var ReportID = obj.CurrReport.RowID;
		var TemplatePath = ExtTool.RunServerMethod("DHCMed.Service","GetTemplatePath");
		var FileName = ExtTool.RunServerMethod("DHCMed.NINFService.CSS.ClinReport","GetReportTEMP",SSHospCode,SurvNumber);
		if (FileName == '') return;
		FileName = TemplatePath + "\\\\" + FileName;
		
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
		Common_SetValue("txtPatNo",objReport.CRPatNo);
		Common_SetValue("cboLoc","",objReport.CRLoc);
		Common_SetValue("txtBed",objReport.CRBed);
		Common_SetValue("txtMRNo",objReport.CRMRNo);
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
		
		Common_SetValue("cbgOper1","",objReport.CROper1);
		Common_SetValue("cbgOper3","",objReport.CROper3);
		
		Common_SetValue("cbgIsInfection","",objReport.CRIsInfection);
		Common_SetValue("cbgInfCategory","",objReport.CRInfCategory);
		Common_SetValue("cboInfPos1","",objReport.CRInfPos1);
		if (objReport.CRPathogen1){
			var strPathogen = objReport.CRPathogen1;
			var arrPathogen = strPathogen.split('#');
			if (arrPathogen.length>0) Common_SetValue("txtPathogen1A",arrPathogen[0]);
			if (arrPathogen.length>1) Common_SetValue("txtPathogen1B",arrPathogen[1]);
			if (arrPathogen.length>2) Common_SetValue("txtPathogen1C",arrPathogen[2]);
		}
		Common_SetValue("cboInfPos2","",objReport.CRInfPos2);
		if (objReport.CRPathogen2){
			var strPathogen = objReport.CRPathogen2;
			var arrPathogen = strPathogen.split('#');
			if (arrPathogen.length>0) Common_SetValue("txtPathogen2A",arrPathogen[0]);
			if (arrPathogen.length>1) Common_SetValue("txtPathogen2B",arrPathogen[1]);
			if (arrPathogen.length>2) Common_SetValue("txtPathogen2C",arrPathogen[2]);
		}
		Common_SetValue("cboInfPos3","",objReport.CRInfPos3);
		if (objReport.CRPathogen3){
			var strPathogen = objReport.CRPathogen3;
			var arrPathogen = strPathogen.split('#');
			if (arrPathogen.length>0) Common_SetValue("txtPathogen3A",arrPathogen[0]);
			if (arrPathogen.length>1) Common_SetValue("txtPathogen3B",arrPathogen[1]);
			if (arrPathogen.length>2) Common_SetValue("txtPathogen3C",arrPathogen[2]);
		}
		Common_SetValue("cbgAddOns5","",objReport.CRAddOns5);
		Common_SetValue("cboComInfPos1","",objReport.CRComInfPos1);
		if (objReport.CRComPathogen1){
			var strPathogen = objReport.CRComPathogen1;
			var arrPathogen = strPathogen.split('#');
			if (arrPathogen.length>0) Common_SetValue("txtComPathogen1A",arrPathogen[0]);
			if (arrPathogen.length>1) Common_SetValue("txtComPathogen1B",arrPathogen[1]);
			if (arrPathogen.length>2) Common_SetValue("txtComPathogen1C",arrPathogen[2]);
		}
		Common_SetValue("cboComInfPos2","",objReport.CRComInfPos2);
		if (objReport.CRComPathogen2){
			var strPathogen = objReport.CRComPathogen2;
			var arrPathogen = strPathogen.split('#');
			if (arrPathogen.length>0) Common_SetValue("txtComPathogen2A",arrPathogen[0]);
			if (arrPathogen.length>1) Common_SetValue("txtComPathogen2B",arrPathogen[1]);
			if (arrPathogen.length>2) Common_SetValue("txtComPathogen2C",arrPathogen[2]);
		}
		Common_SetValue("cboComInfPos3","",objReport.CRComInfPos3);
		if (objReport.CRComPathogen3){
			var strPathogen = objReport.CRComPathogen3;
			var arrPathogen = strPathogen.split('#');
			if (arrPathogen.length>0) Common_SetValue("txtComPathogen3A",arrPathogen[0]);
			if (arrPathogen.length>1) Common_SetValue("txtComPathogen3B",arrPathogen[1]);
			if (arrPathogen.length>2) Common_SetValue("txtComPathogen3C",arrPathogen[2]);
		}
		
		if (objReport.CRBugsAntiSen){
			var strBugsAntiSen = objReport.CRBugsAntiSen;
			var arrBugsAntiSen = strBugsAntiSen.split('#');
			if (arrBugsAntiSen.length>8){
				for (var indX=0; indX<arrBugsAntiSen.length; indX++){
					var strItem = arrBugsAntiSen[indX];
					var arrItem = strItem.split('||');
					for (var indY=1; indY<arrItem.length; indY++){
						var strDic = arrItem[indY];
						var arrDic = strDic.split(':');
						if (arrDic.length>1){
							Common_SetValue("cbgAntiSen"+(indX+1)+indY,"",arrDic[1]);
						}
					}
				}
			}
		}
		
		Common_SetValue("cbgAnti1","",objReport.CRAnti1);
		Common_SetValue("cbgAnti2","",objReport.CRAnti2);
		Common_SetValue("cbgAnti3","",objReport.CRAnti3);
		Common_SetValue("cbgAnti4","",objReport.CRAnti4);
		
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
		objReport.CRPatNo = Common_GetValue("txtPatNo");
		objReport.CRName = Common_GetValue("txtName");
		objReport.CRSex = Common_GetText("cbgSex");
		objReport.CRAgeY = Common_GetValue("txtAgeY");
		objReport.CRAgeM = Common_GetValue("txtAgeM");
		objReport.CRAgeD = Common_GetValue("txtAgeD");
		objReport.CRDiagnos = Common_GetValue("txtDiagnos1")
			+ "#" + Common_GetValue("txtDiagnos2")
			+ "#" + Common_GetValue("txtDiagnos3")
		
		objReport.CROper1 = Common_GetText("cbgOper1");
		objReport.CROper3 = Common_GetText("cbgOper3");
		
		objReport.CRIsInfection = Common_GetText("cbgIsInfection");
		objReport.CRInfCategory = Common_GetText("cbgInfCategory");
		objReport.CRInfPos1 = Common_GetText("cboInfPos1");
		objReport.CRPathogen1 = Common_GetValue("txtPathogen1A")
			+ "#" + Common_GetValue("txtPathogen1B")
			+ "#" + Common_GetValue("txtPathogen1C")
		objReport.CRInfPos2 = Common_GetText("cboInfPos2");
		objReport.CRPathogen2 = Common_GetValue("txtPathogen2A")
			+ "#" + Common_GetValue("txtPathogen2B")
			+ "#" + Common_GetValue("txtPathogen2C")
		objReport.CRInfPos3 = Common_GetText("cboInfPos3");
		objReport.CRPathogen3 = Common_GetValue("txtPathogen3A")
			+ "#" + Common_GetValue("txtPathogen3B")
			+ "#" + Common_GetValue("txtPathogen3C")
		
		objReport.CRAddOns5 = Common_GetText("cbgAddOns5");
		
		objReport.CRComInfPos1 = Common_GetText("cboComInfPos1");
		objReport.CRComPathogen1 = Common_GetValue("txtComPathogen1A")
			+ "#" + Common_GetValue("txtComPathogen1B")
			+ "#" + Common_GetValue("txtComPathogen1C")
		objReport.CRComInfPos2 = Common_GetText("cboComInfPos2");
		objReport.CRComPathogen2 = Common_GetValue("txtComPathogen2A")
			+ "#" + Common_GetValue("txtComPathogen2B")
			+ "#" + Common_GetValue("txtComPathogen2C")
		objReport.CRComInfPos3 = Common_GetText("cboComInfPos3");
		objReport.CRComPathogen3 = Common_GetValue("txtComPathogen3A")
			+ "#" + Common_GetValue("txtComPathogen3B")
			+ "#" + Common_GetValue("txtComPathogen3C")
		
		objReport.CRBugsAntiSen = "金黄色葡萄球菌"
			+ "||苯唑西林:" + Common_GetText("cbgAntiSen11")
			+ "||头孢西丁:" + Common_GetText("cbgAntiSen12")
			+ "#凝固酶阴性葡萄球菌"
			+ "||苯唑西林:" + Common_GetText("cbgAntiSen21")
			+ "||头孢西丁:" + Common_GetText("cbgAntiSen22")
			+ "#粪肠球菌"
			+ "||氨苄西林:" + Common_GetText("cbgAntiSen31")
			+ "||万古霉素:" + Common_GetText("cbgAntiSen32")
			+ "#屎肠球菌"
			+ "||氨苄西林:" + Common_GetText("cbgAntiSen41")
			+ "||万古霉素:" + Common_GetText("cbgAntiSen42")
			+ "#肺炎链球菌"
			+ "||青霉素:" + Common_GetText("cbgAntiSen51")
			+ "#大肠埃希菌"
			+ "||头孢他啶:" + Common_GetText("cbgAntiSen61")
			+ "||亚胺/美罗培南:" + Common_GetText("cbgAntiSen62")
			+ "||左氧氟沙星:" + Common_GetText("cbgAntiSen63")
			+ "#肺炎克雷伯菌"
			+ "||头孢他啶:" + Common_GetText("cbgAntiSen71")
			+ "||亚胺/美罗培南:" + Common_GetText("cbgAntiSen72")
			+ "||左氧氟沙星:" + Common_GetText("cbgAntiSen73")
			+ "#铜绿假单胞菌"
			+ "||环丙沙星:" + Common_GetText("cbgAntiSen81")
			+ "||哌拉西林/他唑巴坦:" + Common_GetText("cbgAntiSen82")
			+ "||亚胺培南/美罗培南:" + Common_GetText("cbgAntiSen83")
			+ "||头孢他啶:" + Common_GetText("cbgAntiSen84")
			+ "||头孢吡肟:" + Common_GetText("cbgAntiSen85")
			+ "||阿米卡星:" + Common_GetText("cbgAntiSen86")
			+ "#鲍曼不动杆菌"
			+ "||亚胺培南/美罗培南:" + Common_GetText("cbgAntiSen91")
			+ "||头孢哌酮/舒巴坦:" + Common_GetText("cbgAntiSen92")
		
		objReport.CRAnti1 = Common_GetText("cbgAnti1");
		objReport.CRAnti2 = Common_GetText("cbgAnti2");
		objReport.CRAnti3 = Common_GetText("cbgAnti3");
		objReport.CRAnti4 = Common_GetText("cbgAnti4");
		
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
		strInput = strInput + CHR_1 + objReport.CRPatNo;
		strInput = strInput + CHR_1 + objReport.CRInfCategory;
		strInput = strInput + CHR_1 + objReport.CRComInfPos1;
		strInput = strInput + CHR_1 + objReport.CRComInfDate1;
		strInput = strInput + CHR_1 + objReport.CRComPathogen1;
		strInput = strInput + CHR_1 + objReport.CRComInfPos2;
		strInput = strInput + CHR_1 + objReport.CRComInfDate2;
		strInput = strInput + CHR_1 + objReport.CRComPathogen2;
		strInput = strInput + CHR_1 + objReport.CRComInfPos3;
		strInput = strInput + CHR_1 + objReport.CRComInfDate3;
		strInput = strInput + CHR_1 + objReport.CRComPathogen3;
		strInput = strInput + CHR_1 + objReport.CRAddOns5;
		strInput = strInput + CHR_1 + objReport.CRBugsAntiSen;
		
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
		if (objReport.CRPatNo=='') errInfo += '病人编号为空<br>';
		if (objReport.CRLoc=='') errInfo += '科室为空<br>';
		if (objReport.CRBed=='') errInfo += '床位为空<br>';
		if (objReport.CRMRNo=='') errInfo += '病案号为空<br>';
		//if (objReport.CRAdmDate=='') errInfo += '入院日期为空<br>';
		if (objReport.CRName=='') errInfo += '姓名为空<br>';
		if (objReport.CRSex=='') errInfo += '性别为空<br>';
		if (((objReport.CRAgeY=='')||(objReport.CRAgeY=='0'))
		&&((objReport.CRAgeM=='')||(objReport.CRAgeM=='0'))
		&&((objReport.CRAgeD=='')||(objReport.CRAgeD=='0'))){
			errInfo += '年龄(年月日)不能同时为空<br>';
		}
		if ((objReport.CRDiagnos=='##')||(objReport.CRDiagnos=='')) errInfo += '基础疾病诊断为空!<br>';
		
		if (objReport.CRIsInfection==''){
			errInfo += '是否存在感染为空!<br>';
		} else if ((objReport.CRIsInfection=='存在')&&(objReport.CRInfCategory=='')) {
			errInfo += '感染分类为空!<br>';
		} else if ((objReport.CRIsInfection=='存在')&&(objReport.CRInfCategory=='医院感染')) {
			if (objReport.CRInfPos1=='') errInfo += '医院感染部位为空!<br>';
		} else if ((objReport.CRIsInfection=='存在')&&(objReport.CRInfCategory=='社区感染')) {
			if (objReport.CRComInfPos1=='') errInfo += '社区感染部位为空!<br>';
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
			if (objReport.CROper3=='') errInfo += '手术切口分类为空!<br>';
		}
		
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
	
	obj.BugsInfoDiv_expand = function(){
		var divID = "div-BugsInfo";
		if (document.all[divID].style.display == 'none') {
			document.all[divID].style.display = 'block';
		} else {
			document.all[divID].style.display = 'none';
		}
		if (obj.BugsFlag == 0){
			obj.BugsFlag = 1;
			Ext.Ajax.request({
				url : ExtToolSetting.RunQueryPageURL,
				method : "POST",
				params  : {
					ClassName : 'DHCMed.NINFService.CSS.ClinSrcData',
					QueryName : 'QryBugsSenList',
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
					obj.BugsTemplate.overwrite(divID, arryData);
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
