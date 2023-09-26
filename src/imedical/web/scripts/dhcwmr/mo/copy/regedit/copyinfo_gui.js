function BC_InitCopyInfo(Records){
	var obj = new Object();
	obj.Records = Records;
	obj.BC_ClientName 			= Common_TextField("BC_ClientName","委托人<font color='red'>*</font>");
	obj.BC_cboClientRelation 	= Common_ComboToDic("BC_cboClientRelation","与患者关系<font color='red'>*</font>","RelationType");
	obj.BC_cboCardType 			= Common_ComboToDic("BC_cboCardType","证明材料<font color='red'>*</font>","Certificate");
	obj.BC_txtPersonalID 		= Common_TextField("BC_txtPersonalID","证件号码<font color='red'>*</font>");
	obj.BC_txtTelephone 		= Common_TextField("BC_txtTelephone","联系电话<font color='red'>*</font>");
	obj.BC_txtAddress 			= Common_TextField("BC_txtAddress","联系地址");
	obj.BC_cbgPurpose 			= Common_CheckboxGroupToDC("BC_cbgPurpose","复印目的<font color='red'>*</font>","CopyAim",5,"cboHospital");
	obj.BC_cbgContent 			= Common_CheckboxGroupToDC("BC_cbgContent","复印内容","MrCopyInfo",5,"cboHospital");
	obj.BC_txtResume 			= Common_TextField("BC_txtResume","备注信息");

	obj.BC_btnSave = new Ext.Button({
		id : 'BC_btnSave'
		,iconCls : 'icon-update'
		,width: 60
		,text : '确定'
	});
	obj.BC_btnCancel = new Ext.Button({
		id : 'BC_btnCancel'
		,iconCls : 'icon-exit'
		,width: 60
		,text : '关闭'
	});
	
	
	obj.BC_WinCopy = new Ext.Window({
		id: 'BC_WinCopy'
		,height : 400
		,width : 750
		,modal : true
		,title : '复印信息录入'
		,closable : true
		,layout : 'border'
		,buttonAlign:'center'
		,items:[
			{
				region:'center'
				,layout:'border'
				,items:[
					{
						region:'center'
						,layout:'form'
						,height: 300
						,frame: true
						,items:[
							{
								layout : 'column',
								items : [
									{
										width:350
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.BC_ClientName]
									},{
										width:350
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.BC_cboClientRelation]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										width:350
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.BC_cboCardType]
									},{
										width:350
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.BC_txtPersonalID]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										width:350
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.BC_txtTelephone]
									},{
										width:350
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 90
										,items: [obj.BC_txtAddress]
									}
								]
							},{
								height : 1
							},{
								width:700
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.BC_cbgPurpose]
							},{
								height : 1
							},{
								width:700
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.BC_cbgContent]
							},{
								height : 1
							},{
								layout : 'column',
								items : [
									{
										width:650
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.BC_txtResume]
									}
								]
							}
						]
					}
				]
			}
		]
		,buttons:[obj.BC_btnSave,obj.BC_btnCancel]
	});
	
	BC_InitInfoEvent(obj);
	obj.BC_LoadEvents(arguments);
	return obj;
}

