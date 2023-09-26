
function InitwinEdit(obj){
	
	obj.CheckInfReportSrv = ExtTool.StaticServerObject("DHCMed.NINF.Rep.InfReportCheck");
	
	obj.Check_BaseInfo = Common_RadioGroupToDic("Check_BaseInfo","������Ϣ","NINFInfOprBoolean",2);
	obj.Check_DiagInfo = Common_RadioGroupToDic("Check_DiagInfo","�����Ϣ","NINFInfOprBoolean",2);
	obj.Check_OperInfo = Common_RadioGroupToDic("Check_OperInfo","������Ϣ","NINFInfOprBoolean",2);
	obj.Check_LabInfo = Common_RadioGroupToDic("Check_LabInfo","������Ϣ","NINFInfOprBoolean",2);
	obj.Check_AntiInfo = Common_RadioGroupToDic("Check_AntiInfo","����ҩ����Ϣ","NINFInfOprBoolean",2);
	
	obj.Check_txtResume = Common_TextArea("Check_txtResume","��ע",50);
	
	obj.Check_btnSave = new Ext.Button({
		id : 'Check_btnSave'
		,iconCls : 'icon-save'
		,text : '����'
		,listeners : {
							'click' : function(){
								if(obj.CurrReport.RowID=="") return;
								
								var CheckInfo=obj.CurrReport.RowID+"^^"+Common_GetValue('Check_BaseInfo')+"^"+Common_GetValue('Check_DiagInfo')+"^"+Common_GetValue('Check_OperInfo')+"^"+Common_GetValue('Check_LabInfo')+"^"+Common_GetValue('Check_AntiInfo')+"^"+Common_GetValue('Check_txtResume');
								var ret=obj.CheckInfReportSrv.Update(CheckInfo,"^");
								ParrefWindowRefresh_Handler();
								
								ExtTool.alert("��ʾ", "���۳ɹ�!");
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
		,title : '����д����ݱ��������...'
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
		Common_SetValue('Check_BaseInfo','','��');
		Common_SetValue('Check_DiagInfo','','��');
		Common_SetValue('Check_OperInfo','','��');
		Common_SetValue('Check_LabInfo','','��');
		Common_SetValue('Check_AntiInfo','','��');
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