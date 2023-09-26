function InitViewPortEvent(obj) {
	obj.ClsCaseFollow = ExtTool.StaticServerObject("DHCMed.EPD.CaseFollow");
	obj.ClsDictionary = ExtTool.StaticServerObject("DHCMed.SS.Dictionary");
	obj.PatientManage = ExtTool.StaticServerObject("DHCMed.Base.Patient");
	
	obj.LoadEvent = function(args)
    {
		obj.cboFollowStatus.on('select',obj.cboFollowStatus_select,obj);
		obj.cbgIsHIVTest.on('change',obj.cbgIsHIVTest_change,obj);
		obj.cboIsDead.on('select',obj.cboIsDead_select,obj);
		obj.cboDeathPlace.on('select',obj.cboDeathPlace_select,obj);
		obj.cbgDeathReasonSource.on('change',obj.cbgDeathReasonSource_change,obj);
		obj.cboDeathReason.on('select',obj.cboDeathReason_select,obj);
		obj.chkNeverHIVTest.on('check',obj.chkNeverHIVTest_check,obj);
		
		obj.btnSave.on('click',obj.btnSave_click,obj);
		obj.btnDelete.on('click',obj.btnDelete_click,obj);
		obj.btnExport.on('click',obj.btnExport_click,obj);
		obj.btnPrint.on('click',obj.btnPrint_click,obj);
		
		obj.InitViewPort();
		obj.SetAllDisabled();
  	};
	
	obj.SetAllDisabled = function(){
		Common_SetDisabled("txtPatName",true);
		Common_SetDisabled("txtPatSex",true);
		Common_SetDisabled("txtParentName",true);
		Common_SetDisabled("txtPatNo",true);
		Common_SetDisabled("txtPhoneNo",true);
		Common_SetDisabled("txtAddress",true);
		Common_SetDisabled("cboReasons",true);
		Common_SetDisabled("txtFollowTimes",true);
		Common_SetDisabled("cboIsCustody",true);
	}
	
	obj.cboFollowStatus_select = function(){
		var FollowStatus=Common_GetText('cboFollowStatus');
		if (FollowStatus=='随访') {
			Common_SetDisabled("cboReasons",true);
			Common_SetDisabled("txtFollowTimes",false);
			Common_SetDisabled("cboIsCustody",false);
		}else if(FollowStatus=="失访"){
			Common_SetDisabled("cboReasons",false);
			Common_SetDisabled("txtFollowTimes",true);
			Common_SetDisabled("cboIsCustody",true);
		}else {
			Common_SetDisabled("cboReasons",true);
			Common_SetDisabled("txtFollowTimes",true);
			Common_SetDisabled("cboIsCustody",true);
		}
	}
	
	obj.cbgIsHIVTest_change = function(){
		var IsHIVTest=Common_GetText('cbgIsHIVTest');
		if (IsHIVTest=='是') {
			Common_SetDisabled("chkNeverHIVTest",false);
			Common_SetDisabled("txtLastHIVTestDate",false);
			Common_SetDisabled("txtFirstHIVTestDate",false);
			Common_SetDisabled("txtHIVTestTimes",false);
		}else {
			Common_SetDisabled("chkNeverHIVTest",true);
			Common_SetDisabled("txtLastHIVTestDate",true);
			Common_SetDisabled("txtFirstHIVTestDate",true);
			Common_SetDisabled("txtHIVTestTimes",true);
		}
	}
	
	obj.cboIsDead_select = function(){
		var IsDead=Common_GetText('cboIsDead');
		if (IsDead=='是') {
			Common_SetDisabled("txtDeathDate",false);
			Common_SetDisabled("cboDeathStage",false);
			Common_SetDisabled("cboDeathPlace",false);
			//Common_SetDisabled("txtDeathOtherPlace",false);
			Common_SetDisabled("cbgDeathReasonSource",false);
			//Common_SetDisabled("txtDeathOtherSource",false);
			Common_SetDisabled("cboDeathReason",false);
			//Common_SetDisabled("cbgDeathReasonHIV",false);
			//Common_SetDisabled("cbgDeathReasonOthers",false);
		}else {
			Common_SetDisabled("txtDeathDate",true);
			Common_SetDisabled("cboDeathStage",true);
			Common_SetDisabled("cboDeathPlace",true);
			Common_SetDisabled("txtDeathOtherPlace",true);
			Common_SetDisabled("cbgDeathReasonSource",true);
			Common_SetDisabled("txtDeathOtherSource",true);
			Common_SetDisabled("cboDeathReason",true);
			Common_SetDisabled("cbgDeathReasonHIV",true);
			Common_SetDisabled("cbgDeathReasonOthers",true);
		}
	}
	
	obj.cboDeathPlace_select = function(){
		var DeathPlace=Common_GetText('cboDeathPlace');
		if (DeathPlace=='其他地点') {
			Common_SetDisabled("txtDeathOtherPlace",false);
		}else {
			Common_SetDisabled("txtDeathOtherPlace",true);
		}
	}
	
	obj.cbgDeathReasonSource_change = function(){
		var DeathReasonSource=Common_GetText('cbgDeathReasonSource');
		if (DeathReasonSource.indexOf('其他信息来源')>-1) {
			Common_SetDisabled("txtDeathOtherSource",false);
		}else {
			Common_SetDisabled("txtDeathOtherSource",true);
		}
	}
	
	obj.cboDeathReason_select = function(){
		var DeathReason=Common_GetText('cboDeathReason');
		if (DeathReason=='艾滋病相关疾病死亡') {
			Common_SetDisabled("cbgDeathReasonHIV",false);
			Common_SetDisabled("cbgDeathReasonOthers",true);
		}else if(DeathReason=='艾滋病无关死亡'){
			Common_SetDisabled("cbgDeathReasonHIV",true);
			Common_SetDisabled("cbgDeathReasonOthers",false);
		}else{
			Common_SetDisabled("cbgDeathReasonHIV",true);
			Common_SetDisabled("cbgDeathReasonOthers",true);
		}
	}
	
	obj.chkNeverHIVTest_check = function(){
		var HIVTest=Common_GetValue('chkNeverHIVTest');
		if (HIVTest){
			Common_SetValue('txtLastHIVTestDate',"");
			Common_SetDisabled("txtLastHIVTestDate",true);
		}else{
			Common_SetDisabled("txtLastHIVTestDate",false);
		}
	}
	
	obj.InitViewPort = function(){
		var objPatient=obj.PatientManage.GetObjById(PatientID);
		var EPDRepInfo=obj.ClsCaseFollow.GetEPDInfoByAdm(EpisodeID);
		Common_SetValue('txtPatName',objPatient.PatientName);
		Common_SetValue('txtPatSex',objPatient.Sex);
		Common_SetValue('txtParentName',EPDRepInfo.split("^")[1]);
		Common_SetValue('txtPatNo',objPatient.PersonalID);
		Common_SetValue('txtPhoneNo',EPDRepInfo.split("^")[2]);
		Common_SetValue('txtAddress',EPDRepInfo.split("^")[3]);
		if(obj.ReportID==""){
			return;
		}else{
			var objReport=obj.ClsCaseFollow.GetObjById(obj.ReportID);
			Common_SetValue('txtFollowNo',objReport.FollowNo);
			var objDic1=obj.ClsDictionary.GetObjById(objReport.FollowStatus);
			Common_SetValue('cboFollowStatus',objDic1.RowID,objDic1.Description);
			Common_SetValue('txtFollowTimes',objReport.FollowTimes);
			var objDic2=obj.ClsDictionary.GetObjById(objReport.IsCustody);
			Common_SetValue('cboIsCustody',objDic2.RowID,objDic2.Description);
			var objDic3=obj.ClsDictionary.GetObjById(objReport.Reasons);
			Common_SetValue('cboReasons',objDic3.RowID,objDic3.Description);
			
			var objDic4=obj.ClsDictionary.GetObjById(objReport.IsHIVTest);
			Common_SetValue('cbgIsHIVTest',objDic4.RowID,objDic4.Description);
			Common_SetValue('chkNeverHIVTest',(objReport.NeverHIVTest==1?true:false));
			Common_SetValue('txtLastHIVTestDate',objReport.LastHIVTestDate);
			Common_SetValue('txtFirstHIVTestDate',objReport.FirstHIVTestDate);
			Common_SetValue('txtHIVTestTimes',objReport.HIVTestTimes);
			
			var objDic5=obj.ClsDictionary.GetObjById(objReport.IsDead);
			Common_SetValue("cboIsDead",objDic5.RowID,objDic5.Description)
			Common_SetValue("txtDeathDate",objReport.DeathDate);
			var objDic6=obj.ClsDictionary.GetObjById(objReport.DeathStage);
			Common_SetValue("cboDeathStage",objDic6.RowID,objDic6.Description);
			var objDic7=obj.ClsDictionary.GetObjById(objReport.DeathPlace);
			Common_SetValue("cboDeathPlace",objDic7.RowID,objDic7.Description);
			Common_SetValue("txtDeathOtherPlace",objReport.DeathOtherPlace);
			var arrSourceRowID=obj.ClsCaseFollow.GetFieldById(obj.ReportID,"DeathReasonSource");
			Common_SetValue("cbgDeathReasonSource",arrSourceRowID);
			Common_SetValue("txtDeathOtherSource",objReport.DeathOtherSource);
			var objDic8=obj.ClsDictionary.GetObjById(objReport.DeathReason);
			Common_SetValue("cboDeathReason",objDic8.RowID,objDic8.Description);
			var arrReasonHIVRowID=obj.ClsCaseFollow.GetFieldById(obj.ReportID,"DeathReasonHIV");
			Common_SetValue("cbgDeathReasonHIV",arrReasonHIVRowID);
			var arrReasonOthersRowID=obj.ClsCaseFollow.GetFieldById(obj.ReportID,"DeathReasonOthers");
			Common_SetValue("cbgDeathReasonOthers",arrReasonOthersRowID);
			
			obj.cboFollowStatus_select();
			obj.cbgIsHIVTest_change();
			obj.cboIsDead_select();
			obj.cboDeathPlace_select();
			obj.cbgDeathReasonSource_change();
			obj.cboDeathReason_select();
			
			var arrHIVRowID=obj.ClsCaseFollow.GetFieldById(obj.ReportID,"HIVManifestation");
			Common_SetValue("cboHIVManifestation",arrHIVRowID);
			
			var objDic9=obj.ClsDictionary.GetObjById(objReport.CourseStage);
			Common_SetValue("cboCourseStage",objDic9.RowID,objDic9.Description);
			Common_SetValue("txtHIVDate",objReport.HIVDate);
			var objDic10=obj.ClsDictionary.GetObjById(objReport.SpouseSituation);
			Common_SetValue("cboSpouseSituation",objDic10.RowID,objDic10.Description);
			var objDic11=obj.ClsDictionary.GetObjById(objReport.SpouseHIV);
			Common_SetValue("cboSpouseHIV",objDic11.RowID,objDic11.Description);
			Common_SetValue("txtSpouseHIVDate",objReport.SpouseHIVDate);
			Common_SetValue("txtSpouseCaseNo",objReport.SpouseCaseNo);
			Common_SetValue("txtChildren",objReport.Children);
			Common_SetValue("txtChildren1",objReport.Children1);
			Common_SetValue("txtChildren2",objReport.Children2);
			Common_SetValue("txtChildren3",objReport.Children3);
			Common_SetValue("txtChildren4",objReport.Children4);
			var objDic12=obj.ClsDictionary.GetObjById(objReport.HIVSurvey1);
			Common_SetValue("cboHIVSurvey1",objDic12.RowID,objDic12.Description);
			var objDic13=obj.ClsDictionary.GetObjById(objReport.HIVSurvey2);
			Common_SetValue("cboHIVSurvey2",objDic13.RowID,objDic13.Description);
			Common_SetValue("txtHIVSurvey2No",objReport.HIVSurvey2No);
			var objDic14=obj.ClsDictionary.GetObjById(objReport.HIVSurvey3);
			Common_SetValue("cboHIVSurvey3",objDic14.RowID,objDic14.Description);
			var objDic15=obj.ClsDictionary.GetObjById(objReport.HIVSurvey4);
			Common_SetValue("cboHIVSurvey4",objDic15.RowID,objDic15.Description);
			Common_SetValue("txtHIVSurvey4No",objReport.HIVSurvey4No);
			var objDic16=obj.ClsDictionary.GetObjById(objReport.HIVSurvey5);
			Common_SetValue("cboHIVSurvey5",objDic16.RowID,objDic16.Description);
			Common_SetValue("txtHIVSurvey5No",objReport.HIVSurvey5No);
			Common_SetValue("txtHIVSurvey5No1",objReport.HIVSurvey5No1);
			var objDic17=obj.ClsDictionary.GetObjById(objReport.HIVSurvey6);
			Common_SetValue("cboHIVSurvey6",objDic17.RowID,objDic17.Description);
			Common_SetValue("txtHIVSurvey6No",objReport.HIVSurvey6No);
			var objDic18=obj.ClsDictionary.GetObjById(objReport.HIVSurvey7);
			Common_SetValue("cboHIVSurvey7",objDic18.RowID,objDic18.Description);
			var objDic19=obj.ClsDictionary.GetObjById(objReport.IsHIVSurvey7);
			Common_SetValue("cbgIsHIVSurvey7",objDic19.RowID,objDic19.Description);
			var objDic20=obj.ClsDictionary.GetObjById(objReport.HIVSurvey8a);
			Common_SetValue("cboHIVSurvey8a",objDic20.RowID,objDic20.Description);
			Common_SetValue("txtHIVSurvey8aNo1",objReport.HIVSurvey8aNo1);
			Common_SetValue("txtHIVSurvey8aNo2",objReport.HIVSurvey8aNo2);
			var objDic21=obj.ClsDictionary.GetObjById(objReport.HIVSurvey8b);
			Common_SetValue("cboHIVSurvey8b",objDic21.RowID,objDic21.Description);
			var objDic22=obj.ClsDictionary.GetObjById(objReport.HIVSurvey8c);
			Common_SetValue("cboHIVSurvey8c",objDic22.RowID,objDic22.Description);
			var arrHIVSurvey9RowID=obj.ClsCaseFollow.GetFieldById(obj.ReportID,"HIVSurvey9");
			Common_SetValue("cboHIVSurvey9",arrHIVSurvey9RowID);
			var objDic24=obj.ClsDictionary.GetObjById(objReport.IsHIVSurvey10);
			Common_SetValue("cbgIsHIVSurvey10",objDic24.RowID,objDic24.Description);
			var objDic25=obj.ClsDictionary.GetObjById(objReport.HIVSurvey10);
			Common_SetValue("cboHIVSurvey10",objDic25.RowID,objDic25.Description);
			var objDic26=obj.ClsDictionary.GetObjById(objReport.IsHIVSurvey11);
			Common_SetValue("cbgIsHIVSurvey11",objDic26.RowID,objDic26.Description);
			Common_SetValue("txtIsHIVSurvey11No",objReport.IsHIVSurvey11No);

			Common_SetValue("txtCD4TestTimes",objReport.CD4TestTimes);
			Common_SetValue("txtCD4TestResult",objReport.CD4TestResult);
			Common_SetValue("txtCD4TestDate",objReport.CD4TestDate);
			Common_SetValue("txtCD4TestUnit",objReport.CD4TestUnit);
			Common_SetValue("txtSurveyOrgan",objReport.SurveyOrgan);
			Common_SetValue("txtSurveyName",objReport.SurveyName);
			Common_SetValue("txtSurveyDate",objReport.SurveyDate);
			Common_SetValue("txtComments",objReport.Comments);
		}
	}
	
	obj.GetRepData = function(){
		var inputStr=obj.ReportID;
		//报告标题
		inputStr=inputStr+"^"+Common_GetValue('txtFollowNo');
		inputStr=inputStr+"^"+Common_GetValue('cboFollowStatus');
		inputStr=inputStr+"^"+Common_GetValue('txtFollowTimes');
		inputStr=inputStr+"^"+Common_GetValue('cboIsCustody');
		inputStr=inputStr+"^"+Common_GetValue('cboReasons');

		//基本信息
		
		inputStr=inputStr+"^"+""	//Common_GetValue('txtPatName');
		inputStr=inputStr+"^"+""	//Common_GetValue('txtPatSex');
		inputStr=inputStr+"^"+""	//Common_GetValue('txtParentName');
		inputStr=inputStr+"^"+""	//Common_GetValue('txtPatNo');
		inputStr=inputStr+"^"+""	//Common_GetValue('txtPhoneNo');
		inputStr=inputStr+"^"+""	//Common_GetValue('txtAddress');
		
		//HIV检测信息
		inputStr=inputStr+"^"+Common_GetValue('cbgIsHIVTest');
		inputStr=inputStr+"^"+(Common_GetValue('chkNeverHIVTest') ? 1 : 0); //Common_GetValue('chkNeverHIVTest');
		inputStr=inputStr+"^"+Common_GetValue('txtLastHIVTestDate');
		inputStr=inputStr+"^"+Common_GetValue('txtFirstHIVTestDate');
		inputStr=inputStr+"^"+Common_GetValue('txtHIVTestTimes');

		//死亡个案
		inputStr=inputStr+"^"+Common_GetValue('cboIsDead');
		inputStr=inputStr+"^"+Common_GetValue('txtDeathDate');
		inputStr=inputStr+"^"+Common_GetValue('cboDeathStage');
		inputStr=inputStr+"^"+Common_GetValue('cboDeathPlace');
		inputStr=inputStr+"^"+Common_GetValue('txtDeathOtherPlace');
		inputStr=inputStr+"^"+Common_GetValue('cbgDeathReasonSource');
		inputStr=inputStr+"^"+Common_GetValue('txtDeathOtherSource');
		inputStr=inputStr+"^"+Common_GetValue('cboDeathReason');
		inputStr=inputStr+"^"+Common_GetValue('cbgDeathReasonHIV');
		inputStr=inputStr+"^"+Common_GetValue('cbgDeathReasonOthers');

		//临床表现
		inputStr=inputStr+"^"+Common_GetValue('cboHIVManifestation');

		//HIV调查
		inputStr=inputStr+"^"+Common_GetValue('cboCourseStage');
		inputStr=inputStr+"^"+Common_GetValue('txtHIVDate');
		inputStr=inputStr+"^"+Common_GetValue('cboSpouseSituation');
		inputStr=inputStr+"^"+Common_GetValue('cboSpouseHIV');
		inputStr=inputStr+"^"+Common_GetValue('txtSpouseHIVDate');
		inputStr=inputStr+"^"+Common_GetValue('txtSpouseCaseNo');
		inputStr=inputStr+"^"+Common_GetValue('txtChildren');
		inputStr=inputStr+"^"+Common_GetValue('txtChildren1');
		inputStr=inputStr+"^"+Common_GetValue('txtChildren2');
		inputStr=inputStr+"^"+Common_GetValue('txtChildren3');
		inputStr=inputStr+"^"+Common_GetValue('txtChildren4');
		inputStr=inputStr+"^"+Common_GetValue('cboHIVSurvey1');
		inputStr=inputStr+"^"+Common_GetValue('cboHIVSurvey2');
		inputStr=inputStr+"^"+Common_GetValue('txtHIVSurvey2No');
		inputStr=inputStr+"^"+Common_GetValue('cboHIVSurvey3');
		inputStr=inputStr+"^"+Common_GetValue('cboHIVSurvey4');
		inputStr=inputStr+"^"+Common_GetValue('txtHIVSurvey4No');
		inputStr=inputStr+"^"+Common_GetValue('cboHIVSurvey5');
		inputStr=inputStr+"^"+Common_GetValue('txtHIVSurvey5No');
		inputStr=inputStr+"^"+Common_GetValue('txtHIVSurvey5No1');
		inputStr=inputStr+"^"+Common_GetValue('cboHIVSurvey6');
		inputStr=inputStr+"^"+Common_GetValue('txtHIVSurvey6No');
		inputStr=inputStr+"^"+Common_GetValue('cboHIVSurvey7');
		inputStr=inputStr+"^"+Common_GetValue('cbgIsHIVSurvey7');
		inputStr=inputStr+"^"+Common_GetValue('txtHIVSurvey8');
		inputStr=inputStr+"^"+Common_GetValue('cboHIVSurvey8a');
		inputStr=inputStr+"^"+Common_GetValue('txtHIVSurvey8aNo1');
		inputStr=inputStr+"^"+Common_GetValue('txtHIVSurvey8aNo2');
		inputStr=inputStr+"^"+Common_GetValue('cboHIVSurvey8b');
		inputStr=inputStr+"^"+Common_GetValue('cboHIVSurvey8c');
		inputStr=inputStr+"^"+Common_GetValue('cboHIVSurvey9');
		inputStr=inputStr+"^"+Common_GetValue('cbgIsHIVSurvey10');
		inputStr=inputStr+"^"+Common_GetValue('cboHIVSurvey10');
		inputStr=inputStr+"^"+Common_GetValue('cbgIsHIVSurvey11');
		inputStr=inputStr+"^"+Common_GetValue('txtIsHIVSurvey11No');

		//CD4检测
		inputStr=inputStr+"^"+Common_GetValue('txtCD4TestTimes');
		inputStr=inputStr+"^"+Common_GetValue('txtCD4TestResult');
		inputStr=inputStr+"^"+Common_GetValue('txtCD4TestDate');
		inputStr=inputStr+"^"+Common_GetValue('txtCD4TestUnit');

		//随访信息
		inputStr=inputStr+"^"+Common_GetValue('txtSurveyOrgan');
		inputStr=inputStr+"^"+Common_GetValue('txtSurveyName');
		inputStr=inputStr+"^"+Common_GetValue('txtSurveyDate');
		inputStr=inputStr+"^"+Common_GetValue('txtComments');
		
		inputStr=inputStr+"^"+PatientID;
		inputStr=inputStr+"^"+EpisodeID;
		
		return inputStr;
	}
	
	obj.btnSave_click = function(){
		var InputStr=obj.GetRepData();
		var ret=obj.ClsCaseFollow.Update(InputStr,"^");
		if(parseInt(ret)>0){
			obj.ReportID=ret;
			ExtTool.alert("提示","保存成功！");
		}else {
			ExtTool.alert('错误提示','报告保存错误!Error=' + ret);
			return ;
		}
	}
	
	obj.btnDelete_click = function(){
		if(obj.ReportID!=""){
			Ext.MessageBox.confirm('删除', '是否删除该报告?', function(btn,text){
				if(btn=="yes"){
					var ret=obj.ClsCaseFollow.DeleteById(obj.ReportID);
					if(parseInt(ret)>0){
						ExtTool.alert("提示","删除成功！");
						window.close;
					}else {
						ExtTool.alert('错误提示','报告删除错误!Error=' + ret);
						return ;
					}
				}
			});
		}
	}
	obj.btnExport_click = function(){
		var cArguments=obj.ReportID;
		var flg=ExportDataToExcel("","","",cArguments);
	}
	
	obj.btnPrint_click = function(){
		var cArguments=obj.ReportID;
		var flg=PrintDataToExcel("","","",cArguments);
	}
}	