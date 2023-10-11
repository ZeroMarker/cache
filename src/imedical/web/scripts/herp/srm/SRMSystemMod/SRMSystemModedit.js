

SRMSystemModEditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid = rowObj[0].get("Rowid");
		var code =rowObj[0].get("Code");
		var name =rowObj[0].get("Name");
		var IsValid =rowObj[0].get("IsValid");

	}
	

	var uCodeField = new Ext.form.TextField({
		id: 'uCodeField',
		fieldLabel: '系统模块编码',
		width:150,
		listWidth : 260,
		triggerAction: 'all',
		emptyText:'',
		name: 'uCodeField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var uNameField = new Ext.form.TextField({
		id: 'uNameField',
		fieldLabel: '系统模块名称',
		width:150,
		listWidth : 260,
		triggerAction: 'all',
		emptyText:'',
		name: 'uNameField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	/*
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
		               url: 'herp.srm.srmuserexe.csp'
		                     + '?action=caltypename&str='
		                     + encodeURIComponent(Ext.getCmp('uTypeField').getRawValue()),
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
	});*/
 var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			items : [uCodeField, uNameField]
		});
				                                                                                            //
    //面板加载
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                              //
			this.getForm().loadRecord(rowObj[0]);
			uCodeField.setValue(rowObj[0].get("Code"));	
			uNameField.setValue(rowObj[0].get("Name"));	
			//uTypeField.setValue(rowObj[0].get("Type"));
			                                                                        //
    });   
    
	    //定义并初始化保存修改按钮
	    var editButton = new Ext.Toolbar.Button({
				text:'保存'
			});                                                                                                                                            //
                    
		        //定义修改按钮响应函数
			    editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("Rowid");          
				var code = uCodeField.getValue();
				var name = uNameField.getValue(); 
				//var type = uTypeField.getValue(); 

                Ext.Ajax.request({
				url:'herp.srm.SRMSystemModexe.csp?action=edit&rowid='+rowid+'&code='+code
				+'&name='+encodeURIComponent(name),
				
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:25}});		
				}
				else
					{
						var message="已存在相同记录";
						Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
			text:'取消'
		});
	
		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		};
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//定义并初始化窗口
		var editwin = new Ext.Window({
			title: '修改记录',
			width : 300,
			height : 200,    
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
