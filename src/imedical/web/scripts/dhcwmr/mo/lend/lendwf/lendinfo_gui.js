function LI_InitLendInfo(MRecords){
	var obj = new Object();
	obj.MRecords = MRecords;
	obj.LI_cboLendLoc = Common_ComboToLendLoc("LI_cboLendLoc","借阅科室<font color='red'>*</font>","E","","cboHospital");
	obj.LI_cboLendDoc = Common_ComboToLendUser("LI_cboLendDoc","借阅医生<font color='red'>*</font>","LI_cboLendLoc");
	obj.LI_txtLUserTel = Common_TextField("LI_txtLUserTel","医生电话");
	obj.LI_txtLLocTel = Common_TextField("LI_txtLLocTel","科室电话");
	obj.LI_cbgLPurpose = Common_CheckboxGroupToDic("LI_cbgLPurpose","借阅目的","LendAim",5,"","cboHospital");
	obj.LI_txtLExpBackDate = Common_DateFieldToDate("LI_txtLExpBackDate","预计归还日期");
	obj.LI_txtLExpBackDate.setValue(new Date().add(Date.DAY,5));
	obj.LI_txtLNote = Common_TextArea("LI_txtLNote","备注信息",50,500);

	obj.LI_btnSave = new Ext.Button({
		id : 'LI_btnSave'
		,iconCls : 'icon-update'
		,width: 60
		,text : '确定'
	});
	obj.LI_btnCancel = new Ext.Button({
		id : 'LI_btnCancel'
		,iconCls : 'icon-exit'
		,width: 60
		,text : '关闭'
	});
	
	
	obj.LI_WinLendInfo = new Ext.Window({
		id : 'LI_WinLendInfo'
		,height : 300
		,width : 550
		,modal : true
		,title : '借阅信息'
		,closable : false
		,layout : 'border'
		,buttonAlign : 'center'
		,items:[
			{
				region: 'center',
				layout : 'border',
				items : [
					{
						region: 'center',
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										width:300
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.LI_cboLendLoc]
									},{
										width:200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.LI_txtLLocTel]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										width:300
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.LI_cboLendDoc]
									},{
										width:200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.LI_txtLUserTel]
									}
								]
							},{
								width:500
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 90
								,items: [obj.LI_cbgLPurpose]
							},{
								width:300
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 90
								,items: [obj.LI_txtLExpBackDate]
							},{
								width:500
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 90
								,items: [obj.LI_txtLNote]
							}
						]
					}
				]
			}
		]
		,buttons : [obj.LI_btnSave,obj.LI_btnCancel]
	});
	
	LI_InitLendInfoEvent(obj);
	obj.LI_LoadEvent(arguments);
	return obj;
}

