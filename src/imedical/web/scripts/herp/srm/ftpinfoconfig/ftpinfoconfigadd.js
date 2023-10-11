

srmftpinfoconfigAddFun = function() {

var aTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '上传配置'],['2', '下载配置'], ['3', '科研绩效配置']]
	});		
		
var aTypeCombox = new Ext.form.ComboBox({
	                   id : 'aTypeCombox',
		           fieldLabel : '配置类型',
	                   width : 200,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : aTypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:''
						  });	
	var uFtpIPFieldAdd = new Ext.form.TextField({
		id: 'uFtpIPFieldAdd',
		fieldLabel: 'IP',
		width:200,
		allowBlank: false,
		listWidth : 260,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uFtpIPFieldAdd',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uFtpUserFieldAdd = new Ext.form.TextField({
		id: 'uFtpUserFieldAdd',
		fieldLabel: '用户名',
		width:200,
		allowBlank: true,
		listWidth : 200,
		triggerAction: 'all',
		////emptyText:'',
		name: 'uFtpUserFieldAdd',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});

	var uFtpPassWordFieldAdd = new Ext.form.TextField({
		id: 'uFtpPassWordFieldAdd',
		fieldLabel: '密码',
		width:200,
		allowBlank: true,
		inputType: 'password',
		listWidth : 200,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uFtpPassWordFieldAdd',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''

	});
	var uFtpDescFieldAdd = new Ext.form.TextField({
		id: 'uFtpDescFieldAdd',
		fieldLabel: '描述',
		width:200,
		allowBlank: true,
		listWidth : 260,
		triggerAction: 'all',
		//emptyText:'',
		name: 'uFtpDescFieldAdd',
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
								aTypeCombox,
								uFtpIPFieldAdd,
								uFtpUserFieldAdd,
								uFtpPassWordFieldAdd,
								uFtpDescFieldAdd
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
			//items : [uCodeField,uNameField,uTypeField,uSexField,uBirthDayField,uIDNumField,uTitleDrField,uPhoneField,uEMailField,uDegreeField,uCompDRField,uMonographNumField,uPaperNumField,uPatentNumField,uInvInCustomStanNumField,uTrainNumField,uHoldTrainNumField,uInTrainingNumField]
		});
	
	var addWin = new Ext.Window({
		    
			title : '新增配置信息',
			iconCls: 'edit_add',
			width : 430,
			height : 300,
			layout : 'fit',//添加页面背景的高度
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',//添加页面的内边距
			buttonAlign : 'center',//添加页面的确定按钮和取消按钮的位置
			items : formPanel,
			buttons : [{		 
				text : '保存',
				iconCls: 'save',
				handler : function() {
					if (formPanel.form.isValid()) {
					var type = aTypeCombox.getValue();
					var ipadd = uFtpIPFieldAdd.getValue();
					var useradd = uFtpUserFieldAdd.getValue();
					var passwordadd = uFtpPassWordFieldAdd.getValue();
                    var srcadd = uFtpDescFieldAdd.getValue();

					

				Ext.Ajax.request({
					url:'herp.srm.ftpinfoconfigexe.csp?action=add&type='+encodeURIComponent(type)+'&ftpip='+encodeURIComponent(ipadd)
					+'&ftpuser='+encodeURIComponent(useradd)+'&ftppassword='+encodeURIComponent(passwordadd)+'&ftpdesc='+encodeURIComponent(srcadd),
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
						{	//var message="重复添加";
							//if(jsonData.info=='RepCode') message="编号重复！";
							//if(jsonData.info=='RepName') message="名称重复！";
							
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