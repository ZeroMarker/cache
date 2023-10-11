

srmdeptuserEditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid = rowObj[0].get("rowid");
		var tmpdeptdr =rowObj[0].get("deptdr");
		var tmpuserdr =rowObj[0].get("userdr");
		var tmpIsDirector =rowObj[0].get("IsDirector");
		var tmpmngdr =rowObj[0].get("mngdr");
		var tmpIsSecretary =rowObj[0].get("IsSecretary");
	}
	
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
		               url: 'herp.srm.srmdeptuserexe.csp'
		                     + '?action=caldept&str='
		                     + encodeURIComponent(Ext.getCmp('unitdeptField').getRawValue()),
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
			value:tmpdeptdr,
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true,
		    labelSeparator:''
	});

	/* unitdeptField.on('select',function(combo, record, index){
		tmpdeptdr = combo.getValue();
	}); */
	
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
		   url : 'herp.srm.srmdeptuserexe.csp'
		         +'?action=caluser&str='
		         +encodeURIComponent(Ext.getCmp('unituserField').getRawValue()),
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
			value:tmpuserdr,
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true,
			labelSeparator:''
	});
	
	/* unituserField.on('select',function(combo, record, index){
		tmpuserdr = combo.getValue();
	}); */

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
		   url : 'herp.srm.srmdeptuserexe.csp'
		         +'?action=caluser&str='
		         +encodeURIComponent(Ext.getCmp('mngnameField').getRawValue()),
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
			name: 'mngnameField',
			value:tmpmngdr,
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true,
			labelSeparator:''
	});
	
	/* mngnameField.on('select',function(combo, record, index){
		tmpmngdr = combo.getValue();
	}); */

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
				//valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				value:tmpIsSecretary,
				mode : 'local', // 本地模式
				triggerAction: 'all',
				//emptyText:'请选择...',
				selectOnFocus:true,
				forceSelection : true,
				labelSeparator:''
			});	
		
	        /* IsSecretaryField.on('select',function(combo, record, index){
			tmpIsSecretary = combo.getValue();
		}); */
//是否科主任
	var IsDirecterStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['N', '否'], ['Y', '是']]
		});
	var IsDirecterField = new Ext.form.ComboBox({
            id : 'IsDirecterField',
			fieldLabel : '是否科主任',
			width : 200,
			listWidth : 200,
			store : IsDirecterStore,
			//valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			mode : 'local', // 本地模式
			triggerAction: 'all',
			//name:'IsDMField',
			//emptyText:'请选择...',
			value:tmpIsDirector,
			selectOnFocus:true,
			forceSelection : true,
			labelSeparator:''
		});	
	/* IsDirecterField.on('select',function(combo, record, index){
		tmpIsDirector = combo.getValue();
	}); */
	//定义并初始化面板
 var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			labelAlign: 'right',
			items : [unitdeptField,unituserField,IsDirecterField,mngnameField,IsSecretaryField]
		});
				                                                                                            //
    //面板加载
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                              //
			this.getForm().loadRecord(rowObj[0]);
			unitdeptField.setRawValue(rowObj[0].get("deptname"));	
			unituserField.setRawValue(rowObj[0].get("username"));	
			IsDirecterField.setRawValue(rowObj[0].get("IsDirectorlist"));
			mngnameField.setRawValue(rowObj[0].get("mngname"));
			IsSecretaryField.setRawValue(rowObj[0].get("IsSecretarylist"));		                                                                        //
    });   
    
	    //定义并初始化保存修改按钮
	    var editButton = new Ext.Toolbar.Button({
				text:'保存',
				iconCls: 'save'
			});                                                                                                                                            //
                    
		        //定义修改按钮响应函数
			    editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");          
				var deptdr = unitdeptField.getValue(); 
				var userdr = unituserField.getValue(); 
				var IsDirector = IsDirecterField.getValue(); 
                var mngdr = mngnameField.getValue(); 
                var IsSecretary = IsSecretaryField.getValue(); 
                Ext.Ajax.request({
				url:'herp.srm.srmdeptuserexe.csp?action=edit&rowid='+rowid+'&deptdr='+deptdr
				+'&userdr='+userdr+'&IsDirector='+IsDirector+'&mngdr='+mngdr+'&IsSecretary='+IsSecretary,
				
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
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
					};
			},
				scope: this
			});
			editwin.close();
		};
		//添加保存修改按钮的监听事件
		editButton.addListener('click',editHandler,false);
	
		//定义并初始化取消修改按钮
		var cancelButton = new Ext.Toolbar.Button({
			text:'关闭',
			iconCls : 'cancel'
		});
	
		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		};
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//定义并初始化窗口
		var editwin = new Ext.Window({
			title: '修改组织关系信息',
			iconCls: 'pencil',
			width : 400,
			height : 260,    
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				editButton,
				cancelButton
			]
		});
		//窗口显示
		editwin.show();
	};
