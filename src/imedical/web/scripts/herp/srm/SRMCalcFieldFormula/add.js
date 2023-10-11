

AddFun = function() {
//���
var aYearListDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
aYearListDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : CalcFieldFormulaURL+'?action=yearlist&str='+encodeURIComponent(Ext.getCmp('aYearField').getRawValue()),
						method : 'POST'
					});
		});
var aYearField = new Ext.form.ComboBox({
            id:'aYearField',
			name:'aYearField',
			fieldLabel : '���',
			width : 180,
			listWidth : 250,
			selectOnFocus : true,
			//allowBlank : false,
			store : aYearListDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // ����ģʽ
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:'',
			forceSelection : true
		});

	//ϵͳģ���
var aSysModListDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
aSysModListDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : FieldCoefficientUrl+'?action=sysmodelist&str='+encodeURIComponent(Ext.getCmp('aSysModListField').getRawValue()),
						method : 'POST'
					});
		});
var aSysModListField = new Ext.form.ComboBox({
            id:'aSysModListField',
			name:'aSysModListField',
			fieldLabel : 'ϵͳģ��',
			width : 180,
			listWidth : 250,
			selectOnFocus : true,
			//allowBlank : false,
			store : aSysModListDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // ����ģʽ
			editable : true,
			pageSize : 10,
			minChars : 1,
			labelSeparator:'',
			selectOnFocus : true,
			forceSelection : true
		});
	var hiddenField = new Ext.form.TextField({
		id: 'hiddenField',
		fieldLabel: '�洢��ʽ',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		hidden:true,
		name: 'hiddenField',
		minChars: 1,
		pageSize: 10,
		labelSeparator:'',
		editable:true
	});
	
	var aCalculateDescField = new Ext.form.TriggerField({
				fieldLabel : '��ʽ����',
				// disabled:true,
				editable : false,
				//hidden : true,
				width : 180,
				labelSeparator:''
				// emptyText : '��ʽ����'
				//anchor : '100%'
			});

	aCalculateDescField.onTriggerClick = function() {
		formula(1, this);
		//hiddenField.setValue(formu);
		 Ext.getCmp("hiddenField").setValue(formu);
	};
	
	
	//hiddenField.setValue(formu);
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 80,
			labelAlign:'right',
			items : [aYearField,aSysModListField, aCalculateDescField]
		});
	
	var addWin = new Ext.Window({
		    
			title : '�������м�Ч��ʽ',
			iconCls: 'edit_add',
			width : 300,
			height : 200,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,
			buttons : [{		 
				text : '����',
				iconCls: 'save', 
				handler : function() {
					if (formPanel.form.isValid()) {
					var year=aYearField.getValue();
					var sysno= aSysModListField.getValue();
					var formula = aCalculateDescField.getValue();
					var codeformula = hiddenField.getValue();
					
					if(year=="")
					{
						Ext.Msg.show({title:'����',msg:'��Ȳ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					if(sysno=="")
					{
						Ext.Msg.show({title:'����',msg:'ϵͳģ�鲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					if(formula=="")
					{
						Ext.Msg.show({title:'����',msg:'���㹫ʽ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					
					Ext.Ajax.request({
					url:CalcFieldFormulaURL+'?action=add&Year='+year+'&SysNO='+encodeURIComponent(sysno)+'&Formula='+encodeURIComponent(formula)+'&CodeFormula='+encodeURIComponent(codeformula),
					waitMsg:'������...',
					failure: function(result, request){		
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGrid.load({params:{start:0, limit:25}});
						}
						else
						{
							var message="�ظ����";
							
							if(jsonData.info=='RepSysMod') message="ϵͳģ���ظ�";
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  addWin.close();
				} 
				}					
			},
			{
				text: '�ر�',
				iconCls: 'cancel',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
