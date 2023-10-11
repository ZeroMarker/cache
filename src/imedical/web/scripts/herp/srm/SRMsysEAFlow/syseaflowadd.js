

syseaflowAddFun = function() {
///////////////////����/////////////////////////////  
var TypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '����'],['2', '��ѧ']]
	});		
		
var TypeCombox = new Ext.form.ComboBox({
	                   id : 'TypeCombox',
		           fieldLabel : '����',
	                   width:200,
		               //listWidth : 260,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : TypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : 'ѡ��...',
		           mode : 'local', // ����ģʽ
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
		           labelSeparator:''
						  });	
//-----------------ģ���
var SysModuleDs = new Ext.data.Store({
	      autoLoad:true,
	      proxy : "",
	      reader : new Ext.data.JsonReader({
	                 totalProperty : 'results',
	                 root : 'rows'
	              }, ['rowid','name'])
});


SysModuleDs.on('beforeload', function(ds, o){

	     ds.proxy=new Ext.data.HttpProxy({
	               url: 'herp.srm.syseaflowexe.csp'
	                     + '?action=listSysModule&str='
	                     + encodeURIComponent(Ext.getCmp('SysModuleDsField').getRawValue()),
	               method:'POST'
	              });
	});

var SysModuleDsField = new Ext.form.ComboBox({
		id: 'SysModuleDsField',
		fieldLabel: 'ϵͳģ��',
		width:200,
		listWidth : 250,
		allowBlank: false,
		store: SysModuleDs,
		displayField: 'name',
		valueField: 'rowid',
		triggerAction: 'all',
		typeAhead : true,
		//triggerAction : 'all',
		emptyText : '',
		name: 'SysModuleDsField',
		pageSize: 10,
		minChars: 1,
		forceSelection : true,
		selectOnFocus:true,
	    editable:true,
	    labelSeparator:''
});

//----------------------������------------------------
	var EAFMDrDS = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });


	EAFMDrDS.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.syseaflowexe.csp'
		                     + '?action=listEAFMain&str='
		                     + encodeURIComponent(Ext.getCmp('EAFMDrDSField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var EAFMDrDSField = new Ext.form.ComboBox({
			id: 'EAFMDrDSField',
			fieldLabel: '��������',
			width:200,
			listWidth : 250,
			allowBlank: false,
			store: EAFMDrDS,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			//triggerAction : 'all',
			emptyText : '',
			name: 'EAFMDrDSField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true,
		    labelSeparator:''
	});


//------------------------------------------------------	
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			labelAlign: 'right',
			items : [ TypeCombox,SysModuleDsField,EAFMDrDSField]
		});
	
	var addWin = new Ext.Window({
		    
			title : '����ҵ����������Ϣ',
			iconCls: 'edit_add',
			width : 400,
			height : 180,
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
					var type = TypeCombox.getValue();
					var SysModuleID = SysModuleDsField.getValue();
					
					var EAFMDr = EAFMDrDSField.getValue();

					Ext.Ajax.request({
					url:'herp.srm.syseaflowexe.csp?action=add&Type='+type+'&SysModuleID='+SysModuleID+'&EAFMDr='+EAFMDr,
					waitMsg:'������...',
					failure: function(result, request){		
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
						}
						else
						{
							var message="ͬһ����ģ��ֻ�ܶ�Ӧһ����������";
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
