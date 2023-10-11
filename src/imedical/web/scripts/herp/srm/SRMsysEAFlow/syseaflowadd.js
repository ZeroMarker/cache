

syseaflowAddFun = function() {
///////////////////类型/////////////////////////////  
var TypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '科研'],['2', '教学']]
	});		
		
var TypeCombox = new Ext.form.ComboBox({
	                   id : 'TypeCombox',
		           fieldLabel : '类型',
	                   width:200,
		               //listWidth : 260,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : TypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
		           labelSeparator:''
						  });	
//-----------------模块号
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
		fieldLabel: '系统模块',
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

//----------------------审批流------------------------
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
			fieldLabel: '主审批流',
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
		    
			title : '新增业务审批流信息',
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
				text : '保存',
				iconCls: 'save',
				handler : function() {
					if (formPanel.form.isValid()) {
					var type = TypeCombox.getValue();
					var SysModuleID = SysModuleDsField.getValue();
					
					var EAFMDr = EAFMDrDSField.getValue();

					Ext.Ajax.request({
					url:'herp.srm.syseaflowexe.csp?action=add&Type='+type+'&SysModuleID='+SysModuleID+'&EAFMDr='+EAFMDr,
					waitMsg:'保存中...',
					failure: function(result, request){		
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
						}
						else
						{
							var message="同一类型模块只能对应一个审批流！";
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  addWin.close();
				} 
				}					
			},
			{
				text : '关闭',
				iconCls : 'cancel',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
