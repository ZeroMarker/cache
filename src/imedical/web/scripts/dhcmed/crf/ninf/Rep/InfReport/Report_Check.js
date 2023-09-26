
function InitwinEdit(obj){
	
	obj.CheckInfReportSrv = ExtTool.StaticServerObject("DHCMed.NINF.Rep.InfReportCheck");
	
	obj.Check_BaseInfo = Common_RadioGroupToDic("Check_BaseInfo","基本信息","NINFInfOprBoolean",2);
	obj.Check_DiagInfo = Common_RadioGroupToDic("Check_DiagInfo","诊断信息","NINFInfOprBoolean",2);
	obj.Check_OperInfo = Common_RadioGroupToDic("Check_OperInfo","手术信息","NINFInfOprBoolean",2);
	obj.Check_LabInfo = Common_RadioGroupToDic("Check_LabInfo","检验信息","NINFInfOprBoolean",2);
	obj.Check_AntiInfo = Common_RadioGroupToDic("Check_AntiInfo","抗菌药物信息","NINFInfOprBoolean",2);
	
	obj.Check_txtResume = Common_TextArea("Check_txtResume","备注",50);
	
	obj.Check_btnSave = new Ext.Button({
		id : 'Check_btnSave'
		,iconCls : 'icon-save'
		,text : '保存'
		,listeners : {
							'click' : function(){
								if(obj.CurrReport.RowID=="") return;
								
								var CheckInfo=obj.CurrReport.RowID+"^^"+Common_GetValue('Check_BaseInfo')+"^"+Common_GetValue('Check_DiagInfo')+"^"+Common_GetValue('Check_OperInfo')+"^"+Common_GetValue('Check_LabInfo')+"^"+Common_GetValue('Check_AntiInfo')+"^"+Common_GetValue('Check_txtResume');
								var ret=obj.CheckInfReportSrv.Update(CheckInfo,"^");
								ParrefWindowRefresh_Handler();
								
								ExtTool.alert("提示", "评价成功!");
								obj.winEdit.close();	
							}
						}
});
	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,height : 180
		,region : 'center'
		,layout : 'form'
		,frame : true
		,items:[
			obj.Check_BaseInfo
			,obj.Check_DiagInfo
			,obj.Check_OperInfo
			,obj.Check_LabInfo
			,obj.Check_AntiInfo
			,obj.Check_txtResume
		]
	,	buttons:[
			obj.Check_btnSave
		]
	});
	obj.winEdit = new Ext.Window({
		id : 'winEdit'
		,buttonAlign : 'center'
		,width : 300
		,height : 300
		,title : '请填写对这份报告的评价...'
		,layout : 'fit'
		,modal : true
		,renderTo : document.body
		,items:[
			obj.fPanel
		]
	});

obj.Check_iniFun = function() {
	var CheckInfo=obj.CheckInfReportSrv.GetCheckInfo(obj.CurrReport.RowID);
	if(CheckInfo=="")
	{
		Common_SetValue('Check_BaseInfo','','是');
		Common_SetValue('Check_DiagInfo','','是');
		Common_SetValue('Check_OperInfo','','是');
		Common_SetValue('Check_LabInfo','','是');
		Common_SetValue('Check_AntiInfo','','是');
	}else{
		obj.Check_BaseInfo.setValue(CheckInfo.split("^")[0]);
		obj.Check_DiagInfo.setValue(CheckInfo.split("^")[1]);
		obj.Check_OperInfo.setValue(CheckInfo.split("^")[2]);
		obj.Check_LabInfo.setValue(CheckInfo.split("^")[3]);
		obj.Check_AntiInfo.setValue(CheckInfo.split("^")[4]);
		obj.Check_txtResume.setValue(CheckInfo.split("^")[5]);
		
	}
}

obj.Check_iniFun();
  return obj;
}