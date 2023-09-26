addFun = function() {

	var deptSt = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});

	deptSt.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:bankAccountUrl+'?action=unitlist&start=0&limit=25',method:'GET'});
	});

	var deptCombo = new Ext.form.ComboBox({
		fieldLabel:'��������',
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
		fieldLabel: 'ҽԺ��Ա',
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
		fieldLabel: '�����˺�',
		allowBlank : false,
		anchor: '100%'
	});
	var CardNoField = new Ext.form.TextField({
		fieldLabel: '���֤��',
		allowBlank : false,
		anchor: '100%'
	});
	
	var BonusRateField = new Ext.form.NumberField({
		fieldLabel: '����ϵ��',
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
		title: '���',
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
				text: '����',
				handler: function() {
					var tmpBankNo = bankNoField.getValue();
						var tmpSchemeDr = schemeCombo.getValue();
						var tmpDept=deptCombo.getValue();
						var sCardNo = CardNoField.getValue();
						var sBonusRate = BonusRateField.getValue();
						if(tmpDept==""){Ext.Msg.show({
								title : '��ʾ',
								msg : '�������Ҳ���Ϊ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return false;};
						if(tmpSchemeDr==""){Ext.Msg.show({
								title : '��ʾ',
								msg : 'ҽԺ��Ա����Ϊ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return false;};
						if(sCardNo==""){Ext.Msg.show({
								title : '��ʾ',
								msg : '���֤�Ų���Ϊ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return false;};
						if(tmpBankNo==""){Ext.Msg.show({
								title : '��ʾ',
								msg : '�����˺Ų���Ϊ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return false;};
						if(sBonusRate==""){Ext.Msg.show({
								title : '��ʾ',
								msg : '����ϵ������Ϊ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
							return false;};
						Ext.Ajax.request({
							url: bankAccountUrl+'?action=add&BankNo='+tmpBankNo+'&unitDr='+tmpSchemeDr+'&CardNo='+sCardNo+'&BonusRate='+sBonusRate,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									bankAccountDs.load({params:{start:0, limit:bankAccountPagingToolbar.pageSize}});
								}else{
									var tmpmsg='';
									if(jsonData.info=='RepCode'){
										tmpmsg='���˻��Ѵ���!';
									}
									Ext.Msg.show({title:'����',msg:tmpmsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					
				}
			},
			{
				text: 'ȡ��',
				handler: function(){
					addWin.close();
				}
			}
		]
		
	});

	addWin.show();
};
