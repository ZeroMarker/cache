schemeAddFun = function() {

	var codeField = new Ext.form.TextField({
		id: 'codeField',
		name:'code',
		fieldLabel: '��������',
		allowBlank: false,
		emptyText: '����',
		anchor: '100%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		name:'name',
		fieldLabel: '��������',
		allowBlank: false,
		emptyText: '����',
		anchor: '100%'
	});

	var descField = new Ext.form.TextField({
		id: 'descField',
		name:'desc',
		fieldLabel: '��������',
		emptyText: '',
		anchor: '100%'
	});
	var priorityField = new Ext.form.TextField({
		id: 'priorityField',
		name:'desc',
		fieldLabel: '���ȼ�',
		emptyText: '',
		anchor: '100%'
	});

	var schemeTypeCombo = new Ext.form.ComboBox({
		fieldLabel:'�������',
		name:'type',
		store: schemeTypeSt,
		displayField:'name',
		allowBlank: false,
		valueField:'rowid',
		typeAhead: true,
		//mode: 'local',
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'��ѡ',
		selectOnFocus:true,
		anchor: '100%'
	});
	
	var calFlagStore = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data : [[1,'��������'],[2,'��Ϻ���']]
	});
	var calFlagField = new Ext.form.ComboBox({
		id: 'calFlagField',
		fieldLabel: '�����ʾ',
		//listWidth : 130,
		selectOnFocus: true,
		allowBlank: false,
		store: calFlagStore,
		anchor: '100%',
		value:1, //Ĭ��ֵ
		valueNotFoundText:'��������',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'ѡ������ʾ...',
		mode: 'local', //����ģʽ
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
		title: '���',
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
				text: '����',
				handler: function() {
				
					if (formPanel.form.isValid()) {
						var tmpCreatePerson=session['LOGON.USERCODE'];
						/******************************************
						�������SchemeType������������û�ѡ��
											���Һ��㷽��
											��Ա���㷽��
						��������BonusSchemeCode ��¼�룬������
						��������BonusSchemeName ��¼�룬������
						��������SchemeDesc	��¼�룬
						������ԱCreatePerson ��ϵͳ��½�˱���
						������ԱAdjustPerson	����
						����ʱ��AdjustDate	����
						�����ԱAuditingPerson	����
						���ʱ��AuditingDate	����
						�Ƿ���ЧIsValid	��=1
						����״̬SchemeState�����������ϵͳĬ��SchemeState =0
											0������
											1��������
											2����������
						********************************************/
						tmpData=codeField.getValue().trim()+"^"+nameField.getValue().trim()+"^"+descField.getValue().trim()+"^"+schemeTypeCombo.getValue()+"^"+tmpCreatePerson+"^^0^^^^1^"+priorityField.getValue()+"^"+calFlagField.getValue();
						Ext.Ajax.request({
							url: schemeUrl+'?action=schemeadd&data='+tmpData,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									schemeDs.load({
										params:{start:0, limit:schemePagingToolbar.pageSize},
										callback:function(r,o,s){
											schemeSM.selectFirstRow();
										}
									});
								}else{
									var tmpmsg='';
									if(jsonData.info=='1'){
										tmpmsg='�����ظ�!';
									}
									Ext.Msg.show({title:'����',msg:tmpmsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					}
					else{
						var tmpWrongName=checkAdd(formPanel);
						Ext.Msg.show({title:'����', msg:tmpWrongName+'����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				}
			},
			{
				text: 'ȡ��',
				handler: function(){addWin.close();}
			}
		]
		
	});

	addWin.show();

};
