addFun = function() {

	var deptSt = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});

	deptSt.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:bankAccountUrl+'?action=unitlist&start=0&limit=25',method:'GET'});
	});

	var deptCombo = new Ext.form.ComboBox({
		fieldLabel:'所属科室',
		store: deptSt,
		displayField:'name',
		valueField:'rowid',
		allowBlank : false,
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		selectOnFocus:true,
		anchor: '100%'
	});

	var schemeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});

	schemeDs.on('beforeload',function(ds,o){
		ds.proxy=new Ext.data.HttpProxy({url:bankAccountUrl+'?action=personslist&unitDr='+deptCombo.getValue()+'&start=0&limit=100',method:'GET'});
		//schemeCombo.setRawValue('');
		//schemeDs.load();
		
	});

	var schemeCombo = new Ext.form.ComboBox({
		fieldLabel: '医院人员',
		store: schemeDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		allowBlank : false,
		//pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true,
		anchor: '100%'
	});
	
	var bankNoField = new Ext.form.TextField({
		fieldLabel: '银行账号',
		allowBlank : false,
		anchor: '100%'
	});
	var CardNoField = new Ext.form.TextField({
		fieldLabel: '身份证号',
		allowBlank : false,
		anchor: '100%'
	});
	
	var BonusRateField = new Ext.form.NumberField({
		fieldLabel: '技术系数',
		allowBlank : false,
		anchor: '100%'
	});
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 60,
		items: [
			deptCombo,
			schemeCombo,
			CardNoField,
			bankNoField,
			BonusRateField
		]
	});

	var addWin = new Ext.Window({
		title: '添加',
		width: 250,
		height: 220,
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
					var tmpBankNo = bankNoField.getValue();
						var tmpSchemeDr = schemeCombo.getValue();
						var tmpDept=deptCombo.getValue();
						var sCardNo = CardNoField.getValue();
						var sBonusRate = BonusRateField.getValue();
						if(tmpDept==""){Ext.Msg.show({
								title : '提示',
								msg : '所属科室不能为空!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return false;};
						if(tmpSchemeDr==""){Ext.Msg.show({
								title : '提示',
								msg : '医院人员不能为空!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return false;};
						if(sCardNo==""){Ext.Msg.show({
								title : '提示',
								msg : '身份证号不能为空!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return false;};
						if(tmpBankNo==""){Ext.Msg.show({
								title : '提示',
								msg : '银行账号不能为空!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return false;};
						if(sBonusRate==""){Ext.Msg.show({
								title : '提示',
								msg : '技术系数不能为空!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return false;};
						Ext.Ajax.request({
							url: bankAccountUrl+'?action=add&BankNo='+tmpBankNo+'&unitDr='+tmpSchemeDr+'&CardNo='+sCardNo+'&BonusRate='+sBonusRate,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									bankAccountDs.load({params:{start:0, limit:bankAccountPagingToolbar.pageSize}});
								}else{
									var tmpmsg='';
									if(jsonData.info=='RepCode'){
										tmpmsg='该账户已存在!';
									}
									Ext.Msg.show({title:'错误',msg:tmpmsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					
				}
			},
			{
				text: '取消',
				handler: function(){
					addWin.close();
				}
			}
		]
		
	});

	addWin.show();
};
