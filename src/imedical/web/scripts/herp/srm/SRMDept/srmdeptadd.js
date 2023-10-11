

srmdeptuserAddFun = function() {


	var uCodeField = new Ext.form.TextField({
		id: 'uCodeField',
		fieldLabel: '���ұ���',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		////emptyText:'',
		name: 'uCodeField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uNameField = new Ext.form.TextField({
		id: 'uNameField',
		fieldLabel: '��������',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		////emptyText:'',
		name: 'uNameField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uTypeDs = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });


	uTypeDs.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.srmdeptexe.csp'
		                     + '?action=caltypename&str='
		                     + encodeURIComponent(Ext.getCmp('uTypeField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var uTypeField = new Ext.form.ComboBox({
			id: 'uTypeField',
			fieldLabel: '��������',
			width:200,
			listWidth : 225,
			allowBlank: true,
			store: uTypeDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			////emptyText : '',
			name: 'uTypeField',
			//��ʱΪ��
			disabled:true,
			pageSize: 10,
			minChars: 1,
			forceSelection : false,
			selectOnFocus:true,
		    editable:true,
		    labelSeparator:''
	});
/////////////////////�Ƿ���Ч/////////////////////////////
var aIsdriectField = new Ext.form.Checkbox({
                        id:'aIsdriectField',
						name:'aIsdriectField',
						fieldLabel : '�Ƿ���Ч',
						labelSeparator:''
					});

/////////////////////���Ҽ���/////////////////////////////					
var uDeptClassDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', 'һ������'], ['2', '��������'], ['3', '��������'],['4','�ļ�����']]
	});
	var uDeptClassField = new Ext.form.ComboBox({
	    id : 'uDeptClassField',
		fieldLabel : '���Ҽ���',
		width : 200,
		listWidth : 200,
		store : uDeptClassDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // ����ģʽ
		triggerAction: 'all',
		////emptyText:'��ѡ��...',
		selectOnFocus:true,
		forceSelection : true,
		labelSeparator:''
	});	
/////////////////////�ϼ�����/////////////////////////////					
	var uSuperDeptDs = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });

	uSuperDeptDs.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.srmdeptexe.csp'
		                     + '?action=caldeptname&str='
		                     + encodeURIComponent(Ext.getCmp('uSuperDeptField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var uSuperDeptField = new Ext.form.ComboBox({
			id: 'uSuperDeptField',
			fieldLabel: '�ϼ�����',
			width:200,
			listWidth : 250,
			allowBlank: true,
			store: uSuperDeptDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			////emptyText : '',
			name: 'uSuperDeptField',
			//��ʱΪ��
			//disabled:true,
			pageSize: 10,
			minChars: 1,
			forceSelection : false,
			selectOnFocus:true,
		    editable:true,
		    labelSeparator:''
	});
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 80,
			labelAlign: 'right',
			items : [uCodeField, uNameField,uDeptClassField,uSuperDeptField,aIsdriectField]
		});
	
	var addWin = new Ext.Window({
		    
			title : '����������Ϣ',
			iconCls: 'edit_add',
			width : 350,
			height : 210,
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
					var code = uCodeField.getValue();
					var name = uNameField.getValue();
					//var type = uTypeField.getValue();
					var type=""
					
					var IsValid = "";
			        if (Ext.getCmp('aIsdriectField').checked) {IsValid="Y";}
			        else { IsValid="N";}
			        var deptclass = uDeptClassField.getValue();
					var superdept = uSuperDeptField.getValue();
					
					if(code=="")
					{
						Ext.Msg.show({title:'����',msg:'���Ҵ��벻��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					};
					if(name=="")
					{
						Ext.Msg.show({title:'����',msg:'�������Ʋ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					};
					if(IsValid=="")
					{
						Ext.Msg.show({title:'����',msg:'��ѡ�������Ƿ���Ч',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					};
					Ext.Ajax.request({
					url:'herp.srm.srmdeptexe.csp?action=add&code='+encodeURIComponent(code)+'&name='+encodeURIComponent(name)
					+'&type='+type+'&IsValid='+IsValid+'&deptclass='+deptclass+'&superdept='+superdept,
					waitMsg:'������...',
					failure: function(result, request){		
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGridDs.load({params:{start:0, limit:25}});
						}
						else
						{
							var message=jsonData.info;
							
							if(jsonData.info=='RecordExist') message="��¼�ظ�";
							if(jsonData.info=='RepCode') message="����ظ���";
							if(jsonData.info=='RepName') message="�����ظ���";
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
				text : '�ر�',
				iconCls : 'cancel',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
