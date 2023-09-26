function InitViewport1Event(obj) {
	obj.ServiceCls = ExtTool.StaticServerObject("DHCMed.NINFService.CSS.Service");
	obj.SurveyExecCls = ExtTool.StaticServerObject("DHCMed.NINF.CSS.SurveyExec");
	
	obj.LoadEvent = function(){
		obj.cboSurvNumber.on('select',obj.cboSurvNumber_OnSelect,obj);
		obj.btnSave.on("click", obj.btnSave_click, obj);
		obj.cboHospital.on('expand',obj.cboHospital_expand,obj);		//add by yanjf 20140422
		obj.cboHospital.on('select',obj.cboHospital_Select,obj);		//add by yanjf 20140422
  	};
	
	//add by yanjf 20140417
    obj.cboHospital_expand=function(){
	    obj.cboLoc.setValue();
		obj.cboSurvNumber.setValue();
	}
	obj.cboHospital_Select=function(){
		obj.cboLoc.getStore().removeAll();
	    obj.cboLoc.getStore().load({}); 
		obj.cboSurvNumber.getStore().removeAll();
	    obj.cboSurvNumber.getStore().load({}); 
	}
	
	obj.cboSurvNumber_OnSelect = function() {

		//update by likai 20141105 for bug:3542
		obj.cboLoc.clearValue();
		obj.cboLoc.getStore().removeAll();   
		obj.cboLoc.getStore().load({}); 
		obj.dtSurvDate.setValue('');
		
		var SurvNum = obj.cboSurvNumber.getRawValue();
		if (!SurvNum) return;
		
		var SurvType = obj.SurveyExecCls.GetSurvMethod(SurvNum);
		if (SurvType == '1') {
			obj.cboLoc.setValue('');
			obj.cboLoc.setRawValue('全院');
			obj.cboLoc.setDisabled(true);
		} else if(SurvType == '2') {
			obj.cboLoc.setValue('');
			obj.cboLoc.setRawValue('');
			obj.cboLoc.setDisabled(false);
		} else {}
		
		obj.GridPanelStore.load({});
	};
	
	obj.btnSave_click = function() {
	  	var SurvNum = obj.cboSurvNumber.getRawValue();
	  	var SurvDate = obj.dtSurvDate.getRawValue();
	  	var SurvLoc = obj.cboLoc.getValue();
	  	if (SurvNum == "") {
	  		ExtTool.alert('错误提示', '请选择调查编号!');
			return;
	  	}
	  	//add by likai for bug:3886
	  	if (SurvDate == "") {
	  		ExtTool.alert('错误提示', '请选择调查日期!');
			return;
	  	}
		var SurvType = obj.SurveyExecCls.GetSurvMethod(SurvNum);
		if ((SurvType == '2')&&(SurvLoc == '')) {
			ExtTool.alert('错误提示', '分科调查必须选择科室!');
			return;
		}
		
		try {
			var ret=obj.ServiceCls.BuildBedSurvLog(SurvNum,SurvDate,SurvLoc,session['LOGON.USERID']);
			if (parseInt(ret) > 0) {
				ExtTool.alert('提示', '保存成功！');
			} else {
				ExtTool.alert('错误提示', '保存失败！Error:' + ret);
				return;
			}
			obj.GridPanelStore.load({});
		} catch(err) {
			ExtTool.alert("错误提示", err.description, Ext.MessageBox.ERROR);
		}
	};
}
