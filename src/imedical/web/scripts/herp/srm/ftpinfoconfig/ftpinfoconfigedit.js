
//UPDATE



srmftpinfoconfigEditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid         = rowObj[0].get("rowid");		
		var typeid 		  = rowObj[0].get("TypeDR");	
	}

var eTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '上传配置'],['2', '下载配置'], ['3', '科研绩效配置']]
	});		
		
var eTypeCombox = new Ext.form.ComboBox({
	                   id : 'eTypeCombox',
		           fieldLabel : '配置类型',
	                   width : 200,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : eTypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           value:typeid,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:''
						  });	
//Panel中会用到的输入框、下拉框、日期框等都可以用extjs源码中封装的组件来新建new:输入框定义
	var uFtpIPFieldEdit = new Ext.form.TextField({
		id: 'uFtpIPFieldEdit',
		fieldLabel: 'IP',
		width:200,
		allowBlank: false,
		listWidth : 260,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uFtpIPFieldEdit',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uFtpUserFieldEdit = new Ext.form.TextField({
		id: 'uFtpUserFieldEdit',
		fieldLabel: '用户名',
		width:200,
		allowBlank: true,
		listWidth : 200,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uFtpUserFieldEdit',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uFtpPassWordFieldEdit = new Ext.form.TextField({
		id: 'uFtpPassWordFieldEdit',
		fieldLabel: '密码',
		width:200,
		allowBlank: true,
		listWidth : 200,
		inputType: 'password',
		triggerAction: 'all',
		//emptyText:'',
		name: 'uFtpPassWordFieldEdit',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uFtpDescFieldEdit = new Ext.form.TextField({
		id: 'uFtpDescFieldEdit',
		fieldLabel: '描述',
		width:200,
		allowBlank: true,
		listWidth : 260,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uFtpDescFieldEdit',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	
	
	
		var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '.8',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								{
										xtype : 'displayfield',
										value : '',
										columnWidth : .1
									},
									eTypeCombox,
									uFtpIPFieldEdit,
									uFtpUserFieldEdit,
									uFtpPassWordFieldEdit,
								    uFtpDescFieldEdit
                       
								]	 
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									{
										xtype : 'displayfield',
										value : '',
										columnWidth : .1
									}
																
								]
							 }]
					}
				]
	

     
	var formPanel = new Ext.form.FormPanel({
			//baseCls : 'x-plain',
			labelWidth : 90,
			labelAlign:'right',
			frame: true,
			items: colItems
		});
				                                                                                         
    //面板加载，在这里控制的是在修改面板中是否有数据
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                           
			this.getForm().loadRecord(rowObj[0]);
			uFtpIPFieldEdit.setValue(rowObj[0].get("FtpIP"));	
			uFtpUserFieldEdit.setValue(rowObj[0].get("FtpUser"));
			uFtpPassWordFieldEdit.setValue(rowObj[0].get("FtpPassWord"));	
			uFtpDescFieldEdit.setValue(rowObj[0].get("FtpDesc"));	
            eTypeCombox.setRawValue(rowObj[0].get("Type"));				
			                                                                        
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
				var type = eTypeCombox.getValue();
				var ipedit = uFtpIPFieldEdit.getValue();
				var useredit = uFtpUserFieldEdit.getValue();
				var passwordedit = uFtpPassWordFieldEdit.getValue();
				var srcedit = uFtpDescFieldEdit.getValue();
               
                Ext.Ajax.request({
				url:'herp.srm.ftpinfoconfigexe.csp?action=edit&rowid='+rowid+'&type='+encodeURIComponent(type)+'&ftpip='+encodeURIComponent(ipedit)+'&ftpuser='+encodeURIComponent(useredit)
					+'&ftppassword='+encodeURIComponent(passwordedit)+'&ftpdesc='+encodeURIComponent(srcedit),
				
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'修改成功!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					itemGridDs.load({params:{start:0, limit:25}});		
				}
				else
					{
					//var message="重复添加";
					//if(jsonData.info=='RepCode') message="编号重复！";
					//if(jsonData.info=='RepName') message="名称重复！";
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
			title: '修改ftp服务器信息',
			iconCls: 'pencil',
			width : 430,
			height : 300,    
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
