

srmdeptuserAddFun = function() {

//获取科室名称
	var unitdeptDs = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });


	unitdeptDs.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.srmdeptuserexe.csp'+ '?action=caldept&str='+ encodeURIComponent(Ext.getCmp('unitdeptField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var unitdeptField = new Ext.form.ComboBox({
			id: 'unitdeptField',
			fieldLabel: '科室名称',
			width:200,
			listWidth : 250,
			allowBlank: false,
			store: unitdeptDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			//emptyText : '请选择科室名称...',
			name: 'unitdeptField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true,
		    labelSeparator:''
	});
//获取人员姓名
	var unituserDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
			           totalProperty:'results',
			           root:'rows'
			       },['rowid','name'])
     });
     
	unituserDs.on('beforeload', function(ds, o){
		   ds.proxy = new Ext.data.HttpProxy({
		   url : 'herp.srm.srmdeptuserexe.csp'+'?action=caluser&str='+encodeURIComponent(Ext.getCmp('unituserField').getRawValue()),
		         method:'POST'
		       });
	});

	var unituserField = new Ext.form.ComboBox({
			id: 'unituserField',
			fieldLabel: '人员名称',
			width:200,
			listWidth :250,
			allowBlank: false,
			store: unituserDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			//emptyText:'请选择人员姓名...',
			name: 'unituserField',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true,
			labelSeparator:''
	});

//获取上级领导姓名
	var mngnameDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
			           totalProperty:'results',
			           root:'rows'
			       },['rowid','name'])
	     });
     
	mngnameDs.on('beforeload', function(ds, o){
		   ds.proxy = new Ext.data.HttpProxy({
		   url : 'herp.srm.srmdeptuserexe.csp'+'?action=caluser&str='+encodeURIComponent(Ext.getCmp('mngnameField').getRawValue()),
		         method:'POST'
		       });
	});

	var mngnameField = new Ext.form.ComboBox({
			id: 'mngnameField',
			fieldLabel: '上级领导',
			width:200,
			listWidth :250,
			//allowBlank: false,
			store: mngnameDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			//emptyText:'请选择人员姓名...',
			name: 'unituserField',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true,
			labelSeparator:''
	});

//是否科主任
	var IsDMStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['N', '否'], ['Y', '是']]
		});
	var IsDMField = new Ext.form.ComboBox({
            id : 'IsDMField',
			fieldLabel : '是否科主任',
			width : 200,
			listWidth : 200,
			store : IsDMStore,
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			mode : 'local', // 本地模式
			triggerAction: 'all',
			//emptyText:'请选择...',
			selectOnFocus:true,
			forceSelection : true,
			labelSeparator:''
		});	
	
//是否科秘书
	var IsSecretaryStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['N', '否'], ['Y', '是']]
		});
	var IsSecretaryField = new Ext.form.ComboBox({
            id : 'IsSecretaryField',
			fieldLabel : '是否科秘书',
			width : 200,
			listWidth : 200,
			store : IsSecretaryStore,
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			mode : 'local', // 本地模式
			triggerAction: 'all',
			//emptyText:'请选择...',
			selectOnFocus:true,
			forceSelection : true,
			labelSeparator:''
		});	
	
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			labelAlign: 'right',
			items : [unitdeptField, unituserField,IsDMField,mngnameField,IsSecretaryField]
		});
	
	var addWin = new Ext.Window({
		    
			title : '新增组织关系信息',
			iconCls: 'edit_add',
			width : 400,
			height : 260,
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
					var deptdr = unitdeptField.getValue();
					var userdr = unituserField.getValue();
					var IsDirector = IsDMField.getValue();
					var mngdr = mngnameField.getValue();
					var IsSecretary = IsSecretaryField.getValue();
					
			
					Ext.Ajax.request({
					url:'herp.srm.srmdeptuserexe.csp?action=add&deptdr='+deptdr+'&userdr='+userdr
					+'&IsDirector='+IsDirector+'&mngdr='+mngdr+'&IsSecretary='+IsSecretary,
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
							var message=jsonData.info;
							if(message=="RepName"){
								Ext.Msg.show({title:'错误',msg:'该条数据已存在！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
							if(message=="RepUser"){
								Ext.Msg.show({title:'错误',msg:'此人的组织关系已维护！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
							
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
