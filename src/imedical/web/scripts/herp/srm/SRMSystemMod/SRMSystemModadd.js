

SRMSystemModAddFun = function() {


	var uCodeField = new Ext.form.TextField({
		id: 'uCodeField',
		fieldLabel: '系统模块编码',
		width:130,
		listWidth : 260,
		triggerAction: 'all',
		emptyText:'',
		name: 'uCodeField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uNameField = new Ext.form.TextField({
		id: 'uNameField',
		fieldLabel: '系统模块名称',
		width:130,
		listWidth : 260,
		triggerAction: 'all',
		emptyText:'',
		name: 'uNameField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	/*var uTypeDs = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });


	uTypeDs.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.srmuserexe.csp'
		                     + '?action=caltypename&str='
		                     + encodeURIComponent(Ext.getCmp('uTypeField').getValue()),
		               method:'POST'
		              });
     	});
     
	var uTypeField = new Ext.form.ComboBox({
			id: 'uTypeField',
			fieldLabel: '用户类型',
			width:200,
			listWidth : 220,
			allowBlank: false,
			store: uTypeDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			emptyText : '',
			name: 'uTypeField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true
	});
	*/
//获取人员姓名

	
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			labelAlign:'right',
			//labelAlign: 'right',
			items : [uCodeField, uNameField]
		});
	
	var addWin = new Ext.Window({
		    
			title : '新增系统模块信息',
			iconCls : 'edit_add',
			width : 300,
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
					var code = uCodeField.getValue();
					var name = uNameField.getValue();
					//var type = uTypeField.getValue();

					
			
					Ext.Ajax.request({
					url:'herp.srm.SRMSystemModexe.csp?action=add&code='+code+'&name='+encodeURIComponent(name),
					waitMsg:'保存中...',
					failure: function(result, request){		
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGridDs.load({params:{start:0, limit:25}});
						}
						else
						{
							var message="重复添加";
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
