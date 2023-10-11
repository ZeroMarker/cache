 /// 名称:系统配置 - 系统计数类型
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2014-4-20


Ext.onReady(function() {	
   
    var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.INCSysCounter&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.INCSysCounter";
	Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
  
    
    // 增加修改的form
	var PASSWORDWinForm = new Ext.FormPanel({
		id : 'PASSWORD-form-save',
		baseCls : 'x-plain',// form透明,不显示框框
		labelAlign : 'right',
		labelWidth : 90,
		split : true,
		frame : true,
		waitMsgTarget : true,
		reader : new Ext.data.JsonReader({
					root : 'list'
				}, [{
							name : 'PASSWORD',
							mapping : 'PASSWORD'
						
						}
				]),
		defaults : {
			anchor : '85%',
			bosrder : false
		},
		// defaultType : 'textfield',
		items : [{
					id : 'PASSWORD',
					xtype : 'textfield',
					fieldLabel : '<font color=red>*</font>密码',
					inputType : 'password',
					name : 'PASSWORD'
				}]
	});
			
	// 增加修改时弹出窗口
	var PASSWORDwin = new Ext.Window({
		title : '请输入管理员密码', 
		width : 300,
		height: 150,
		layout : 'fit',
		plain : true,
		modal : true,
		frame : true,
		autoScroll : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closable:false,
		items : PASSWORDWinForm,
		buttons : [{
			text : '确定',
			id:'PASSWORD_save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('PASSWORD_save_btn'),
			handler : function() {
					var password=Ext.getCmp("PASSWORD").getValue();
					if (password=="") {
				    	Ext.Msg.show({ title : '提示', msg : '密码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
				        return;
				    }
					var matchresponse=tkMakeServerCall("web.DHCBL.BDP.BDPConfig","MatchPassword",password);
					if (matchresponse==0) 
					{															
					    PASSWORDwin.hide();
						loadFormData();
					}else{
						
					    	Ext.Msg.show({
								title : '提示',
								msg : '密码错误，请联系管理员' ,
								minWidth : 200,
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK,
								fn : function(btn) {
									
									Ext.getCmp("PASSWORD").focus(true,300);
								}
							})
						
					}		
				
				
			}
		}],
		listeners : {
			"show" : function() {
				//Ext.getCmp("SSORD-form-save").getForm().findField("SSORDOrdCatDR").focus(true,700);
			},
			"hide" : function() {
				PASSWORDWinForm.getForm().reset();		
				
			}
		}
	});
	 // 刷新按钮
    var btnRefresh = new Ext.Toolbar.Button({
                text : '刷新',
                tooltip : '刷新一下，重新加载界面数据',
                width:100,
                iconCls : 'icon-refresh',
                id:'btnRefresh',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
                handler : function() {
                	
 					loadFormData();
                    
                },
                scope: this
    });
	// 保存按钮-病人管理
    var btnSaveAdmNo = new Ext.Toolbar.Button({
                text : '保存',
                tooltip : '保存（病人管理）',
                width:100,
                iconCls : 'icon-save',
                id:'btnSaveAdmNo',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSaveAdmNo'),
                handler : function() {
 					Ext.MessageBox.confirm('提示', '请确保不要在业务高峰期间修改，您确定要保存<病人管理>数据吗?', function(btn) {
					if (btn == 'yes') {
						var SAVE_ACTION_URL_AdmNo = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.INCSysCounter&pClassMethod=SaveEntityAdmNo&pEntityName=web.Entity.CT.INCSysCounter";
		      			formSearch.form.submit({
								url : SAVE_ACTION_URL_AdmNo,
								clientValidation : true,
								waitTitle : '提示',
								waitMsg : '正在提交数据请稍候...',
								method : 'POST', 
								success : function(form, action) {
									if (action.result.success == 'true') {
										Ext.Msg.show({
													title : '提示',
													msg : '设置成功！',
													icon : Ext.Msg.INFO,
													buttons : Ext.Msg.OK
												});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'+ action.result.errorinfo
										}
										Ext.Msg.show({
													title : '提示',
													msg : '设置失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								},
								failure : function(form, action) {
									Ext.Msg.alert('提示', '设置失败！');
								}
							})	
						}
					}, this);
                    
                },
                scope: this
    });
    // 保存按钮-临床
    var btnSaveClinic = new Ext.Toolbar.Button({
                text : '保存',
                tooltip : '保存（临床）',
                width:100,
                iconCls : 'icon-save',
                id:'btnSaveClinic',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSaveClinic'),
                handler : function() {
 					Ext.MessageBox.confirm('提示', '请确保不要在业务高峰期间修改，您确定要保存<临床>数据吗?', function(btn) {
					if (btn == 'yes') {
						var SAVE_ACTION_URL_Clinic = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.INCSysCounter&pClassMethod=SaveEntityClinic&pEntityName=web.Entity.CT.INCSysCounter";
		      			formSearch.form.submit({
								url : SAVE_ACTION_URL_Clinic,
								clientValidation : true,
								waitTitle : '提示',
								waitMsg : '正在提交数据请稍候...',
								method : 'POST', 
								success : function(form, action) {
									if (action.result.success == 'true') {
										Ext.Msg.show({
													title : '提示',
													msg : '设置成功！',
													icon : Ext.Msg.INFO,
													buttons : Ext.Msg.OK
												});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'+ action.result.errorinfo
										}
										Ext.Msg.show({
													title : '提示',
													msg : '设置失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								},
								failure : function(form, action) {
									Ext.Msg.alert('提示', '设置失败！');
								}
							})	
						}
					}, this);
                    
                },
                scope: this
    });
    // 保存按钮-系统
    var btnSaveSystem = new Ext.Toolbar.Button({
                text : '保存',
                tooltip : '保存（系统）',
                width:100,
                iconCls : 'icon-save',
                id:'btnSaveSystem',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSaveSystem'),
                handler : function() {
 					Ext.MessageBox.confirm('提示', '请确保不要在业务高峰期间修改，您确定要保存<系统>数据吗?', function(btn) {
					if (btn == 'yes') {
						var SAVE_ACTION_URL_System = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.INCSysCounter&pClassMethod=SaveEntitySystem&pEntityName=web.Entity.CT.INCSysCounter";
		      			formSearch.form.submit({
								url : SAVE_ACTION_URL_System,
								clientValidation : true,
								waitTitle : '提示',
								waitMsg : '正在提交数据请稍候...',
								method : 'POST', 
								success : function(form, action) {
									if (action.result.success == 'true') {
										Ext.Msg.show({
													title : '提示',
													msg : '设置成功！',
													icon : Ext.Msg.INFO,
													buttons : Ext.Msg.OK
												});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'+ action.result.errorinfo
										}
										Ext.Msg.show({
													title : '提示',
													msg : '设置失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								},
								failure : function(form, action) {
									Ext.Msg.alert('提示', '设置失败！');
								}
							})	
						}
					}, this);
                    
                },
                scope: this
    });
    // 保存按钮-检验号生成配置
    var btnSaveLabtrak = new Ext.Toolbar.Button({
                text : '保存',
                tooltip : '保存（检验号生成配置）',
                width:100,
                iconCls : 'icon-save',
                id:'btnSaveLabtrak',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSaveLabtrak'),
                handler : function() {
                	if(Ext.getCmp("LabtrakNumberTypeU").getValue()==true)
					{
						if(Ext.getCmp("LabtrakCurrentNumber").getValue()=="")
						{
							
							Ext.Msg.show({
	        					title : '提示',
								msg : '检验号设置里 当前号不能为空，如需从1开始，请设置当前号为0！',
								minWidth : 200,
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK
							});
	          			 	return;
							
						}
						if(Ext.getCmp("LabtrakNumberLength").getValue()=="")
						{
							
							Ext.Msg.show({
	        					title : '提示',
								msg : '检验号总长度不能为空！',
								minWidth : 250,
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK
							});
	          			 	return;
							
						}
					}
					
 					Ext.MessageBox.confirm('提示', '请确保不要在业务高峰期间修改，您确定要保存<检验号生成配置>数据吗?', function(btn) {
					if (btn == 'yes') {
						var SAVE_ACTION_URL_Labtrak = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.INCSysCounter&pClassMethod=SaveEntityLabtrak&pEntityName=web.Entity.CT.INCSysCounter";
		      			formSearch.form.submit({
								url : SAVE_ACTION_URL_Labtrak,
								clientValidation : true,
								waitTitle : '提示',
								waitMsg : '正在提交数据请稍候...',
								method : 'POST', 
								success : function(form, action) {
									if (action.result.success == 'true') {
										Ext.Msg.show({
													title : '提示',
													msg : '设置成功！',
													icon : Ext.Msg.INFO,
													buttons : Ext.Msg.OK
												});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'+ action.result.errorinfo
										}
										Ext.Msg.show({
													title : '提示',
													msg : '设置失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								},
								failure : function(form, action) {
									Ext.Msg.alert('提示', '设置失败！');
								}
							})	
						}
					}, this);
                    
                },
                scope: this
    });
    // 保存按钮-库存
    var btnSaveStock = new Ext.Toolbar.Button({
                text : '保存',
                tooltip : '保存（库存）',
                width:100,
                iconCls : 'icon-save',
                id:'btnSaveStock',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSaveStock'),
                handler : function() {
 					Ext.MessageBox.confirm('提示', '请确保不要在业务高峰期间修改，您确定要保存<库存>数据吗?', function(btn) {
					if (btn == 'yes') {
						var SAVE_ACTION_URL_Stock = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.INCSysCounter&pClassMethod=SaveEntityStock&pEntityName=web.Entity.CT.INCSysCounter";
		      			formSearch.form.submit({
								url : SAVE_ACTION_URL_Stock,
								clientValidation : true,
								waitTitle : '提示',
								waitMsg : '正在提交数据请稍候...',
								method : 'POST', 
								success : function(form, action) {
									if (action.result.success == 'true') {
										Ext.Msg.show({
													title : '提示',
													msg : '设置成功！',
													icon : Ext.Msg.INFO,
													buttons : Ext.Msg.OK
												});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'+ action.result.errorinfo
										}
										Ext.Msg.show({
													title : '提示',
													msg : '设置失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								},
								failure : function(form, action) {
									Ext.Msg.alert('提示', '设置失败！');
								}
							})	
						}
					}, this);
                    
                },
                scope: this
                
	});
	var formSearch = new Ext.form.FormPanel({
		frame:true,
		autoScroll:true,///滚动条
		title:'系统计数类型',
		border:false,
		region: 'center',
		
		///collapsible:true,
		split: true,
		//bodyStyle:'padding:5px 5px 0',
		//baseCls:'x-plain',
		
		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'PATCFIPNoPrefix',mapping:'PATCFIPNoPrefix'},
                                        {name: 'PATCFIPNoSuffix',mapping:'PATCFIPNoSuffix'},
                                        {name: 'PATCFIPNoLength',mapping:'PATCFIPNoLength'},
                                        {name: 'PATCFIPNoValue',mapping:'PATCFIPNoValue'},
                                        {name: 'PATCFOPAdmNoPrefix',mapping:'PATCFOPAdmNoPrefix'},
                                        {name: 'PATCFOPAdmNoSuffix',mapping:'PATCFOPAdmNoSuffix'},
                                        {name: 'PATCFOPAdmNoLength',mapping:'PATCFOPAdmNoLength'},
                                        {name: 'PATCFOPAdmNoValue',mapping:'PATCFOPAdmNoValue'},
                                        {name: 'PATCFIPAdmNoPrefix',mapping:'PATCFIPAdmNoPrefix'},
                                        {name: 'PATCFIPAdmNoSuffix',mapping:'PATCFIPAdmNoSuffix'},
                                        {name: 'PATCFIPAdmNoLength',mapping:'PATCFIPAdmNoLength'},
                                        {name: 'PATCFIPAdmNoValue',mapping:'PATCFIPAdmNoValue'},
                                        {name: 'PATCFEMAdmNoPrefix',mapping:'PATCFEMAdmNoPrefix'},
                                        {name: 'PATCFEMAdmNoSuffix',mapping:'PATCFEMAdmNoSuffix'},
                                        {name: 'PATCFEMAdmNoLength',mapping:'PATCFEMAdmNoLength'},
                                        {name: 'PATCFEMAdmNoValue',mapping:'PATCFEMAdmNoValue'},
                                        {name: 'PATCFProcessPrefix',mapping:'PATCFProcessPrefix'},
                                        {name: 'PATCFProcessSuffix',mapping:'PATCFProcessSuffix'},
                                        {name: 'PATCFProcessLength',mapping:'PATCFProcessLength'},
                                        {name: 'PATCFProcessValue',mapping:'PATCFProcessValue'},
                                        {name: 'PATCFHPPrefix',mapping:'PATCFHPPrefix'},
                                        {name: 'PATCFHPSuffix',mapping:'PATCFHPSuffix'},
                                        {name: 'PATCFHPLength',mapping:'PATCFHPLength'},
                                        {name: 'PATCFHPValue',mapping:'PATCFHPValue'},
                                        {name: 'PATCFAnaestPrefix',mapping:'PATCFAnaestPrefix'},
                                        {name: 'PATCFAnaestSuffix',mapping:'PATCFAnaestSuffix'},
                                        {name: 'PATCFAnaestLength',mapping:'PATCFAnaestLength'},
                                        {name: 'PATCFAnaestValue',mapping:'PATCFAnaestValue'},
                                        {name: 'PATCFOperPrefix',mapping:'PATCFOperPrefix'},
                                        {name: 'PATCFOperSuffix',mapping:'PATCFOperSuffix'},
                                        {name: 'PATCFOperLength',mapping:'PATCFOperLength'},
                                        {name: 'PATCFOperValue',mapping:'PATCFOperValue'},
                                        {name: 'SMCFErrorFileCounter',mapping:'SMCFErrorFileCounter'},
                                        {name: 'INCCNADJLength',mapping:'INCCNADJLength'},
                                        {name: 'INCCNADJPrefix',mapping:'INCCNADJPrefix'},
                                        {name: 'INCCNADJSuffix',mapping:'INCCNADJSuffix'},
                                        {name: 'INCCNADJNo',mapping:'INCCNADJNo'},
                                        {name: 'INCCNDISPLength',mapping:'INCCNDISPLength'},
                                        {name: 'INCCNDISPPrefix',mapping:'INCCNDISPPrefix'},
                                        {name: 'INCCNDISPSuffix',mapping:'INCCNDISPSuffix'},
                                        {name: 'INCCNDISPNo',mapping:'INCCNDISPNo'},
                                        {name: 'INCCNGRNLength',mapping:'INCCNGRNLength'},
                                        {name: 'INCCNGRNPrefix',mapping:'INCCNGRNPrefix'},
                                        {name: 'INCCNGRNSuffix',mapping:'INCCNGRNSuffix'},
                                        {name: 'INCCNGRNNo',mapping:'INCCNGRNNo'},
                                        {name: 'INCCNRRLength',mapping:'INCCNRRLength'},
                                        {name: 'INCCNRRPrefix',mapping:'INCCNRRPrefix'},
                                        {name: 'INCCNRRSuffix',mapping:'INCCNRRSuffix'},
                                        {name: 'INCCNRRNo',mapping:'INCCNRRNo'},
                                        {name: 'INCCNREQLength',mapping:'INCCNREQLength'},
                                        {name: 'INCCNREQPrefix',mapping:'INCCNREQPrefix'},
                                        {name: 'INCCNREQSuffix',mapping:'INCCNREQSuffix'},
                                        {name: 'INCCNREQNo',mapping:'INCCNREQNo'},
                                        {name: 'INCCNSTLength',mapping:'INCCNSTLength'},
                                        {name: 'INCCNSTPrefix',mapping:'INCCNSTPrefix'},
                                        {name: 'INCCNSTSuffix',mapping:'INCCNSTSuffix'},
                                        {name: 'INCCNSTNo',mapping:'INCCNSTNo'},
                                        {name: 'INCCNTRFLength',mapping:'INCCNTRFLength'},
                                        {name: 'INCCNTRFPrefix',mapping:'INCCNTRFPrefix'},
                                        {name: 'INCCNTRFSuffix',mapping:'INCCNTRFSuffix'},
                                        {name: 'INCCNTRFNo',mapping:'INCCNTRFNo'},
                                        {name: 'INCCNPOLength',mapping:'INCCNPOLength'},
                                        {name: 'INCCNPOPrefix',mapping:'INCCNPOPrefix'},
                                        {name: 'INCCNPOSuffix',mapping:'INCCNPOSuffix'},
                                        {name: 'INCCNPONo',mapping:'INCCNPONo'},
                                        {name: 'INCCNMRQLength',mapping:'INCCNMRQLength'},
                                        {name: 'INCCNMRQPrefix',mapping:'INCCNMRQPrefix'},
                                        {name: 'INCCNMRQSuffix',mapping:'INCCNMRQSuffix'},
                                        {name: 'INCCNMRQNo',mapping:'INCCNMRQNo'},
                                        {name: 'INCCNMOLength',mapping:'INCCNMOLength'},
                                        {name: 'INCCNMOPrefix',mapping:'INCCNMOPrefix'},
                                        {name: 'INCCNMOSuffix',mapping:'INCCNMOSuffix'},
                                        {name: 'INCCNMONo',mapping:'INCCNMONo'},
                                        {name: 'INCCNCSRLength',mapping:'INCCNCSRLength'},
                                        {name: 'INCCNCSRPrefix',mapping:'INCCNCSRPrefix'},
                                        {name: 'INCCNCSRSuffix',mapping:'INCCNCSRSuffix'},
                                        {name: 'INCCNCSRNo',mapping:'INCCNCSRNo'},
                                        {name: 'INCCNCONSLength',mapping:'INCCNCONSLength'},
                                        {name: 'INCCNCONSPrefix',mapping:'INCCNCONSPrefix'},
                                        {name: 'INCCNCONSSuffix',mapping:'INCCNCONSSuffix'},
                                        {name: 'INCCNCONSNo',mapping:'INCCNCONSNo'},
                                        {name: 'INCCNIsRetLength',mapping:'INCCNIsRetLength'},
                                        {name: 'INCCNIsRetPrefix',mapping:'INCCNIsRetPrefix'},
                                        {name: 'INCCNIsRetSuffix',mapping:'INCCNIsRetSuffix'},
                                        {name: 'INCCNIsRetNo',mapping:'INCCNIsRetNo'},
                                        {name: 'LabtrakNumberType',mapping:'LabtrakNumberType'},
                                        {name: 'LabtrakCurrentNumber',mapping:'LabtrakCurrentNumber'},
                                        {name: 'LabtrakNumberLength',mapping:'LabtrakNumberLength'}
                                        
                                        ]),
        labelWidth : 60,
        defaults:{anchor:'85%'},
        buttonAlign:'center',
		labelAlign : 'left',
		items:[{	
			
					baseCls : 'x-plain',//form透明,不显示框框
					layout:'form',
					items:[btnRefresh,{
						xtype: 'fieldset',
						title:'病人管理',
						items:[{
								
				 			 layout: 'column',  
				 			 items:[{
									columnWidth:.15,
									layout:'form',
									items:[{
										width:80,
										fieldLabel:'&nbsp&nbsp',
										labelSeparator:''					
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									
									items:[{	
										width:80,
										fieldLabel:'前缀',
										//style:'margin-left:0px',
										labelSeparator:''						
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										fieldLabel:'长度',
										labelSeparator:''					
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										fieldLabel:'后缀',
										//style:'margin-left:-40px',
										labelSeparator:''		
									}]
			     			 },{
									columnWidth:.1,
									layout:'form',
									items:[{
										width:80,
										fieldLabel:'当前值',
										labelSeparator:''				
									}]
			     			 }			 
			     			 
			     			 ]
						},{
				 			 layout: 'column', 
				 			 items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'注册编号',
										labelSeparator:'',
										id:'registration'
										//style:'margin-left:-80px',
										
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'PATCFIPNoPrefix',
										maxLength:5,		
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'PATCFIPNoLength',
										
										xtype:'numberfield',
										//style:'margin-left:-40px',
										minValue : 1,
										maxValue : 15,
										allowNegative : false,//不允许输入负数
										allowDecimals : false //不允许输入小数
										
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'PATCFIPNoSuffix',
										xtype:'textfield',
										maxLength:5
										//style:'margin-left:-40px',
										
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										 width:80,
										id:'PATCFIPNoValue',
										
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }			 
			     			 
			     			 ]
						},{
				 			 layout: 'column',     
				 			 items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'门诊病人',
										labelSeparator:'',
										id:'outpatient'
										//style:'margin-left:-80px',
										
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										 width:80,
										id:'PATCFOPAdmNoPrefix',
										maxLength:5,
										
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'PATCFOPAdmNoLength',
										minValue : 1,
										maxValue : 15,
										allowNegative : false,//不允许输入负数
										allowDecimals : false,//不允许输入小数
										
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										 width:80,
										id:'PATCFOPAdmNoSuffix',
										maxLength:5,
										
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										 width:80,
										id:'PATCFOPAdmNoValue',
										
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }			 
			     			 
			     			 ]
						},{
				 			 layout: 'column',    
				 			  items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'住院病人',
										labelSeparator:'',
										//style:'margin-left:-80px',
										id:'inpatient'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										 width:80,
										id:'PATCFIPAdmNoPrefix',
										maxLength:5,
										
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										 width:80,
										id:'PATCFIPAdmNoLength',
										minValue : 1,
										maxValue : 15,
										allowNegative : false,//不允许输入负数
										allowDecimals : false,//不允许输入小数
										//style:'margin-left:-40px',///平移
										
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80, 
										id:'PATCFIPAdmNoSuffix',
										maxLength:5,
										
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80, 
										
										id:'PATCFIPAdmNoValue',
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }			 
			     			 
			     			 ]
						},{
				 			 layout: 'column',   
				 			  items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'急诊病人',
										labelSeparator:'',
										//style:'margin-left:-80px',
										id:'emergency'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										 
										width:80,
										id:'PATCFEMAdmNoPrefix',
										maxLength:5,
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										 
										width:80,
										id:'PATCFEMAdmNoLength',
										minValue : 1,
										maxValue : 15,
										allowNegative : false,//不允许输入负数
										allowDecimals : false,//不允许输入小数
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										 
										width:80,
										id:'PATCFEMAdmNoSuffix',
										maxLength:5,
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										 
										width:80,
										id:'PATCFEMAdmNoValue',
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }			 
			     			 
			     			 ]
						},{
				 			 layout: 'column',    
				 			  items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'过程编号',
										labelSeparator:'',
										//style:'margin-left:-80px',
										id:'process'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										 width:80,
										id:'PATCFProcessPrefix',
										maxLength:4,
										
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										 
										width:80,
										id:'PATCFProcessLength',
										minValue : 1,
										maxValue : 15,
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										 width:80,
										id:'PATCFProcessSuffix',
										maxLength:4,
										
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										 
										width:80,
										id:'PATCFProcessValue',
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }			 
			     			 
			     			 ]
						},{
				 			 layout: 'column', 
				 			 items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'体检病人',
										labelSeparator:'',
										//style:'margin-left:-80px',
										id:'health'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80, 
										id:'PATCFHPPrefix',
										maxLength:5,
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										 
										width:80,
										id:'PATCFHPLength',
										minValue : 1,
										maxValue : 15,
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										 
										width:80,
										id:'PATCFHPSuffix',
										maxLength:5,
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										 
										width:80,
										id:'PATCFHPValue',
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									}]
			     			 }			 
			     			 
			     			 ]
						},{//保存按钮 2022-03-25
				 			 layout: 'column', 
				 			 items:[{
									columnWidth:.5,
									layout:'form',
									width:300,
									items:[
									{
										fieldLabel:'&nbsp',
										labelSeparator:''
									
									}]
			     			 },{
									columnWidth:.1,
									layout:'form',
									items:[btnSaveAdmNo]
			     			 }
			     			 ]
						}]
					
					
					
					},{
						xtype: 'fieldset',
						 
						title:'临床',
						items:[
							
								
						{
				 			 layout: 'column',  
				 			 items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'麻醉',
										labelSeparator:'',
										//style:'margin-left:-80px',
										id:'anaesthesia'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'PATCFAnaestPrefix',
										
										maxLength:5,
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'PATCFAnaestLength',
										minValue : 1,
										maxValue : 15,
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										maxLength:5,
										id:'PATCFAnaestSuffix',
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'PATCFAnaestValue',
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }			 
			     			 
			     			 ]
						},{
				 			 layout: 'column',    
				 			  items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'手术',
										labelSeparator:'',
										//style:'margin-left:-80px',
										id:'operations'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'PATCFOperPrefix',
										
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'PATCFOperLength',
										minValue : 1,
										maxValue : 15,
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'PATCFOperSuffix',
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'PATCFOperValue',
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }			 
			     			 
			     			 ]
						},{//保存按钮 2022-03-25
				 			 layout: 'column', 
				 			 items:[{
									columnWidth:.5,
									layout:'form',
									width:300,
									items:[
									{
										fieldLabel:'&nbsp',
										labelSeparator:''
									
									}]
			     			 },{
									columnWidth:.1,
									layout:'form',
									items:[btnSaveClinic]
			     			 }
			     			 ]
						}	
						]
					},
					{
						xtype: 'fieldset',
						labelWidth : 173,
						title:'系统',
						items:[{
							fieldLabel:'错误文件数量',
							labelSeparator:'',
							width:80,
							id:'SMCFErrorFileCounter',
							xtype:'numberfield'
							},{
								//保存按钮 2022-03-25
				 			 layout: 'column', 
				 			 items:[{
									columnWidth:.5,
									layout:'form',
									width:300,
									items:[
									{
										fieldLabel:'&nbsp',
										labelSeparator:''
									
									}]
			     			 },{
									columnWidth:.1,
									layout:'form',
									items:[btnSaveSystem]
			     			 }
			     			 ]
							}
							
							]
					},{
						xtype: 'fieldset',
						labelWidth : 173,
						title:'检验号生成配置',  ///add@20170823 交付中心需求 
						items:[{
								 layout: 'column',
					 			 items:[
					 			 	{
					 			 		layout:'form',
					 			 		width:80,
					 			 		labelWidth : 80,
										items:[
										{
											fieldLabel:'生成类型',
											labelSeparator:''
										}]
									},
					 			 	{
										width:330,
										layout:'form',
										labelWidth : 80,
										items:[
										{
											boxLabel:'计数器(从当前号开始自动+1)',   ///类型U, 从当前号开始自动加1，前面自动补0到总长度
											style:'margin-left:10px',
											labelSeparator:'',
											xtype:'radio',
											inputValue: 'U',
											name:'LabtrakNumberType',
											id:'LabtrakNumberTypeU'
										}]
				     			 },{
										width:250,
										labelWidth : 50,
										layout:'form',
										items:[{
											fieldLabel:'当前号', ///要求纯数字
											width:130,
											minValue:0,
											id:'LabtrakCurrentNumber',
											//allowNegative : false,//不允许输入负数
											//allowDecimals : false,//不允许输入小数
											name:'LabtrakCurrentNumber',
											xtype:'textfield',
											enableKeyEvents:true,
											style:"ime-mode:disabled",   //不允许中文输入
											listeners: {
						              			keydown:function(field, e){ ///2018-03-01
						              				//数量文本框,只允许输入数字0-9或 delete、backspace键
						              				if (((e.keyCode>=48)&&(e.keyCode<=57))||((e.keyCode>=96)&&(e.keyCode<=105))||(e.keyCode==8)||(e.keyCode==46)) {
						              				
						              				}
						              				else {
						              					e.stopEvent()
						              				}
						              			},
						              			keyup:function(field, e){
						              				if (Ext.getCmp("LabtrakCurrentNumber").getValue()!="")
						              				{
						              					Ext.getCmp("LabtrakCurrentNumber").setValue((parseFloat(Ext.getCmp("LabtrakCurrentNumber").getValue())))
						              				}
						              				
						              			}	
											  }
										
										}]
				     			 },{
										width:300,
										layout:'form',
										labelWidth : 100,
										items:[
										{
											fieldLabel:'检验号总长度',
											labelWidth : 100,
											width:60,
											minValue : 1,
											maxValue : 15,
											name:'LabtrakNumberLength',
											allowNegative : false,//不允许输入负数
											allowDecimals : false,//不允许输入小数
											id:'LabtrakNumberLength',
											xtype:'numberfield'
										}]
									
				     			 },{
				     			 	width:140,
									layout:'form',
									labelWidth : 100,
									items:[
									{
											fieldLabel:'',   ///类型 D, 1708230001   年月日+四位数字
											labelSeparator:'',
											labelWidth:140,
											xtype:'textfield',
											hidden : true
									}]
									
								}
				     			 		 
				     			 
				     			 ]
							
							
							},{
								boxLabel:'年月日+计数器',   ///类型 D, 1708230001   年月日+四位数字
								labelSeparator:'',
								xtype:'radio',
								inputValue: 'D',
								name:'LabtrakNumberType',
								id:'LabtrakNumberTypeD',
								listeners:{
									'check':function(checked){
										   if(checked.checked){
										   	
												Ext.getCmp("LabtrakCurrentNumber").setDisabled(true);
												Ext.getCmp("LabtrakNumberLength").setDisabled(true);
		
											}else{
												
												Ext.getCmp("LabtrakCurrentNumber").setDisabled(false);
												Ext.getCmp("LabtrakNumberLength").setDisabled(false);
												
											}
									}
								}
							///20180329 1703299999 下一个是1703600000  陈莹修改，王伟要求去掉。
							/*},{
								text:'注意：此类型为年月日+4位数字，如单日标本量超过9999（注意团队体检），则条码号会重复，请注意。',
								xtype:'label',
								style:'margin-left:180px;font-size:16px;color:red;'
							},{
								text:'（系统不设置为年月日+5位数字是因为条码号长度超过10位有些仪器不识别）',
								xtype:'label',
								style:'margin-left:200px;font-size:16px;color:red;'*/
							},{//保存按钮 2022-03-25
				 			 layout: 'column', 
				 			 items:[{
									columnWidth:.5,
									layout:'form',
									width:300,
									items:[
									{
										fieldLabel:'&nbsp',
										labelSeparator:''
									
									}]
			     			 },{
									columnWidth:.1,
									layout:'form',
									items:[btnSaveLabtrak]
			     			 }
			     			 ]
						}
							
							]
					},{
						xtype: 'fieldset',
						 
						title:'库存',
						items:[
							{
								
				 			 layout: 'column',  
				 			 items:[{
									columnWidth:.15,
									layout:'form',
									items:[{
										width:80,
										fieldLabel:'&nbsp&nbsp&nbsp',
										labelSeparator:''					
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									
									items:[{	
										width:80,
										fieldLabel:'前缀',
										//style:'margin-left:0px',
										labelSeparator:''						
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										fieldLabel:'长度',
										labelSeparator:''					
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										fieldLabel:'后缀',
										//style:'margin-left:-40px',
										labelSeparator:''		
									}]
			     			 },{
									columnWidth:.1,
									layout:'form',
									items:[{
										width:80,
										fieldLabel:'当前值',
										labelSeparator:''				
									}]
			     			 }			 
			     			 
			     			 ]
						},
								
						{
				 			 layout: 'column',
				 			 items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'调价',
										labelSeparator:'',
										//style:'margin-left:-80px',
										id:'ADJ'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'INCCNADJPrefix',
										
										maxLength:5,
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNADJLength',
										minValue : 1,
										maxValue : 15,
										allowNegative : false,//不允许输入负数
										allowDecimals : false,//不允许输入小数
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNADJSuffix',
										xtype:'textfield',
										//style:'margin-left:-40px',
										maxLength:5
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNADJNo',
										allowNegative : false,//不允许输入负数
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }			 
			     			 
			     			 ]
						},{
				 			 layout: 'column',
				 			 items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'处置',
										labelSeparator:'',
										//style:'margin-left:-80px',
										id:'DSIP'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'INCCNDISPPrefix',
										
										maxLength:5,
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNDISPLength',
										minValue : 1,
										maxValue : 15,
										allowNegative : false,//不允许输入负数
										allowDecimals : false,//不允许输入小数
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										maxLength:5,
										id:'INCCNDISPSuffix',
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNDISPNo',
										allowNegative : false,//不允许输入负数
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }]
			     		},{
				 			 layout: 'column',     
				 			 items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'货物接收',
										labelSeparator:'',
										//style:'margin-left:-80px',
										id:'GRN'
										
									
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'INCCNGRNPrefix',
										
										maxLength:5,
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNGRNLength',
										minValue : 1,
										maxValue : 15,
										allowNegative : false,//不允许输入负数
										allowDecimals : false,//不允许输入小数
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										maxLength:5,
										id:'INCCNGRNSuffix',
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNGRNNo',
										allowNegative : false,//不允许输入负数
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }]},{
				 			 layout: 'column',  
				 			  items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'货物返回',
										labelSeparator:'',
										//style:'margin-left:-80px',
										id:'RR'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'INCCNRRPrefix',
										
										maxLength:5,
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNRRLength',
										minValue : 1,
										maxValue : 15,
										allowNegative : false,//不允许输入负数
										allowDecimals : false,//不允许输入小数
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										maxLength:5,
										id:'INCCNRRSuffix',
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										
										id:'INCCNRRNo',
										allowNegative : false,//不允许输入负数
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }]},{
				 			 layout: 'column',
				 			 items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'请求',
										labelSeparator:'',
										//style:'margin-left:-80px',
										id:'REQ'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'INCCNREQPrefix',
										maxLength:5,
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNREQLength',
										minValue : 1,
										maxValue : 15,
										allowNegative : false,//不允许输入负数
										allowDecimals : false,//不允许输入小数
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										
										id:'INCCNREQSuffix',
										maxLength:5,
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNREQNo',
										allowNegative : false,//不允许输入负数
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }]},{
				 			 layout: 'column',  
				 			 items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'盘点',
										labelSeparator:'',
										//style:'margin-left:-80px',
										id:'ST'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'INCCNSTPrefix',
										
										maxLength:5,
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNSTLength',
										minValue : 1,
										maxValue : 15,
										allowNegative : false,//不允许输入负数
										allowDecimals : false,//不允许输入小数
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										maxLength:5,
										id:'INCCNSTSuffix',
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNSTNo',
										allowNegative : false,//不允许输入负数
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }]},{
				 			 layout: 'column',  
				 			 items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'转移',
										labelSeparator:'',
										//style:'margin-left:-80px',
										id:'TRF'
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'INCCNTRFPrefix',
										
										maxLength:5,
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNTRFLength',
										minValue : 1,
										maxValue : 15,
										allowNegative : false,//不允许输入负数
										allowDecimals : false,//不允许输入小数
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										maxLength:5,
										id:'INCCNTRFSuffix',
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNTRFNo',
										allowNegative : false,//不允许输入负数
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }]},{
				 			 layout: 'column',     
				 			 items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'订单',
										labelSeparator:'',
										//style:'margin-left:-80px',
										id:'PO'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'INCCNPOPrefix',
										
										maxLength:5,
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNPOLength',
										minValue : 1,
										maxValue : 15,
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										
										maxLength:5,
										id:'INCCNPOSuffix',
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNPONo',
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }]},{
				 			 layout: 'column', 
				 			 items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'生厂厂家',
										labelSeparator:'',
										//style:'margin-left:-80px',
										id:'MRQ'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'INCCNMRQPrefix',
										
										maxLength:5,
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNMRQLength',
										minValue : 1,
										maxValue : 15,
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										maxLength:5,
										id:'INCCNMRQSuffix',
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNMRQNo',
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }]},{
				 			 layout: 'column',  
							 items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'生产厂家订单',
										labelSeparator:'',
										labelWidth : 140,
										//style:'margin-left:-80px',
										id:'MO'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'INCCNMOPrefix',
										
										maxLength:5,
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNMOLength',
										minValue : 1,
										maxValue : 15,
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										maxLength:5,
										id:'INCCNMOSuffix',
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNMONo',
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }]},{
				 			 layout: 'column',  
				 			 items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'中心无菌',
										labelSeparator:'',
										//style:'margin-left:-80px',
										id:'CSR'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'INCCNCSRPrefix',
										
										maxLength:5,
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'INCCNCSRLength',
										minValue : 1,
										maxValue : 15,
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										
										id:'INCCNCSRSuffix',
										maxLength:5,
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNCSRNo',
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }]},{
				 			 layout: 'column',  
				 			 items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'消耗',
										labelSeparator:'',
										//style:'margin-left:-80px',
										id:'CONS'
										
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'INCCNCONSPrefix',
										
										maxLength:5,
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNCONSLength',
										minValue : 1,
										maxValue : 15,
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										maxLength:5,
										id:'INCCNCONSSuffix',
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNCONSNo',
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }]},{
				 			 layout: 'column', 
				 			 items:[{
									columnWidth:.1,
									layout:'form',
									items:[
									{
										fieldLabel:'问题反馈',
										labelSeparator:'',
										//style:'margin-left:-80px'，
										id:'IsRet'
										
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										width:80,
										id:'INCCNIsRetPrefix',
										
										maxLength:5,
										//style:'margin-left:-40px',///平移
										xtype:'textfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNIsRetLength',
										minValue : 1,
										maxValue : 15,
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }
			     			 ,{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										maxLength:5,
										id:'INCCNIsRetSuffix',
										//style:'margin-left:-40px',
										xtype:'textfield'
										
									
									}]
			     			 },{
									columnWidth:.2,
									layout:'form',
									items:[{
										
										width:80,
										id:'INCCNIsRetNo',
										//style:'margin-left:-40px',///平移
										xtype:'numberfield'
									
									}]
			     			 }]	 
			     			 
			     			 
						},{//保存按钮 2022-03-25
				 			 layout: 'column', 
				 			 items:[{
									columnWidth:.5,
									layout:'form',
									width:300,
									items:[
									{
										fieldLabel:'&nbsp',
										labelSeparator:''
									
									}]
			     			 },{
									columnWidth:.1,
									layout:'form',
									items:[btnSaveStock]
			     			 }
			     			 ]
						}	
						]
					}]
	
		}]
		/*,
		buttons: [{
			text: '保存',
			iconCls : 'icon-save',
			width: 100,
			id:'savepanel',
      		handler: function (){ 
      			//PASSWORDwin.show();
				if(Ext.getCmp("LabtrakNumberTypeU").getValue()==true)
				{
					if(Ext.getCmp("LabtrakCurrentNumber").getValue()=="")
					{
						
						Ext.Msg.show({
        					title : '提示',
							msg : '检验号设置里 当前号不能为空，如需从1开始，请设置当前号为0！',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
          			 	return;
						
					}
					if(Ext.getCmp("LabtrakNumberLength").getValue()=="")
					{
						
						Ext.Msg.show({
        					title : '提示',
							msg : '检验号总长度不能为空！',
							minWidth : 250,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
          			 	return;
						
					}
					
					
				}
				
      			formSearch.form.submit({
						url : SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST', 
						success : function(form, action) {
							if (action.result.success == 'true') {
								//var myrowid = action.result.id;
								 //var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '设置成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK
										});
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:'+ action.result.errorinfo
								}
								Ext.Msg.show({
											title : '提示',
											msg : '设置失败！' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
							}
						},
						failure : function(form, action) {
							Ext.Msg.alert('提示', '设置失败！');
						}
					})	
      			
      			
      	} 
		}]*/
		
	});
	
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.INCSysCounter&pClassMethod=OpenData";
	
	// 载入被选择的数据行的表单数据
    var loadFormData = function(grid) {
      
            formSearch.form.load( {
                url : OPEN_ACTION_URL ,
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	///alert("sssssss");
                },
                failure : function(form,action) {
                	Ext.Msg.alert('提示','载入失败！');
                }
            });
        
    };	
    PASSWORDwin.show();
   // loadFormData();
    var viewport = new Ext.Viewport({
        enableTabScroll: true,
        layout: 'border',
        items: [formSearch]
    });
	
	});