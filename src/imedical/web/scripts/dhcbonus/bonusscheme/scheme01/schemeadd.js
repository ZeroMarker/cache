schemeAddFun = function() {

	var codeField = new Ext.form.TextField({
		id: 'codeField',
		name:'code',
		fieldLabel: '方案代码',
		allowBlank: false,
		emptyText: '必填',
		anchor: '100%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		name:'name',
		fieldLabel: '方案名称',
		allowBlank: false,
		emptyText: '必填',
		anchor: '100%'
	});

	var descField = new Ext.form.TextField({
		id: 'descField',
		name:'desc',
		fieldLabel: '方案描述',
		emptyText: '',
		anchor: '100%'
	});
	var priorityField = new Ext.form.TextField({
		id: 'priorityField',
		name:'desc',
		fieldLabel: '优先级',
		emptyText: '',
		anchor: '100%'
	});

	var schemeTypeCombo = new Ext.form.ComboBox({
		fieldLabel:'方案类别',
		name:'type',
		store: schemeTypeSt,
		displayField:'name',
		allowBlank: false,
		valueField:'rowid',
		typeAhead: true,
		//mode: 'local',
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'必选',
		selectOnFocus:true,
		anchor: '100%'
	});
	
	var calFlagStore = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data : [[1,'独立核算'],[2,'混合核算']]
	});
	var calFlagField = new Ext.form.ComboBox({
		id: 'calFlagField',
		fieldLabel: '核算标示',
		//listWidth : 130,
		selectOnFocus: true,
		allowBlank: false,
		store: calFlagStore,
		anchor: '100%',
		value:1, //默认值
		valueNotFoundText:'独立核算',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'选择核算标示...',
		mode: 'local', //本地模式
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	codeField.setValue('');
	nameField.setValue('');
	descField.setValue('');
	priorityField.setValue('');
	schemeTypeCombo.setValue('');
	calFlagField.setValue('1');
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [
			codeField,
			nameField,
			descField,
			priorityField,
			schemeTypeCombo //,
			//calFlagField
		]
	});

	var addWin = new Ext.Window({
		title: '添加',
		width: 300,
		height: 250,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons:[
			{
				text: '保存',
				handler: function() {
				
					if (formPanel.form.isValid()) {
						var tmpCreatePerson=session['LOGON.USERCODE'];
						/******************************************
						方案类别SchemeType：（必填项），用户选择
											科室核算方案
											人员核算方案
						方案代码BonusSchemeCode ：录入，必输项
						方案名称BonusSchemeName ：录入，必输项
						方案描述SchemeDesc	：录入，
						创建人员CreatePerson ：系统登陆人编码
						调整人员AdjustPerson	：空
						调整时间AdjustDate	：空
						审核人员AuditingPerson	：空
						审核时间AuditingDate	：空
						是否有效IsValid	：=1
						方案状态SchemeState：（必填项），系统默认SchemeState =0
											0：新增
											1：审核完成
											2：方案调整
						********************************************/
						tmpData=codeField.getValue().trim()+"^"+nameField.getValue().trim()+"^"+descField.getValue().trim()+"^"+schemeTypeCombo.getValue()+"^"+tmpCreatePerson+"^^0^^^^1^"+priorityField.getValue()+"^"+calFlagField.getValue();
						Ext.Ajax.request({
							url: schemeUrl+'?action=schemeadd&data='+tmpData,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									schemeDs.load({
										params:{start:0, limit:schemePagingToolbar.pageSize},
										callback:function(r,o,s){
											schemeSM.selectFirstRow();
										}
									});
								}else{
									var tmpmsg='';
									if(jsonData.info=='1'){
										tmpmsg='编码重复!';
									}
									Ext.Msg.show({title:'错误',msg:tmpmsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					}
					else{
						var tmpWrongName=checkAdd(formPanel);
						Ext.Msg.show({title:'错误', msg:tmpWrongName+'不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				}
			},
			{
				text: '取消',
				handler: function(){addWin.close();}
			}
		]
		
	});

	addWin.show();

};
