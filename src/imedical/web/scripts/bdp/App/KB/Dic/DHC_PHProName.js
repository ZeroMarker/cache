/// 名称: 药品商品名字典
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2016-9-30
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
Ext.onReady(function() {

	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';

	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHProName&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHProName&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHProName";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHProName&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHProName&pClassMethod=DeleteData";
	var BindingForm = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtForm&pClassQuery=GetDataForCmb1";
	var BindingGen = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGeneric&pClassQuery=GetDataForCmb2";
	var BindingToxicity = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHToxicity&pClassQuery=GetDataForCmb1";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var BindingManf = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHManf&pClassQuery=GetDataForCmb1";
	CanUpdate = function(id) {
		var RefText = tkMakeServerCall("web.DHCBL.KB.DHCPHProName", "GetRefFlag", id);
		if (RefText.indexOf("商品名与His对照") > 0) {
			return true;
		} else {
			return false;
		}
	};
	//初始化"别名"维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "DHC_PHProName"
	});
	/** 删除按钮 */
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id : 'del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData = function() {
			if (grid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						//	Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();
						// 获取选择列
						var rows = gsm.getSelections();
						// 根据选择列获取到所有的行
						//删除所有别名
						AliasGrid.DataRefer = rows[0].get('PHNRowId');
						AliasGrid.delallAlias();
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('PHNRowId')
							},
							callback : function(options, success, response) {
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = grid.getBottomToolbar().cursor;
												var totalnum = grid.getStore().getTotalCount();
												if (totalnum == 1) {//修改添加后只有一条，返回第一页
													var startIndex = 0;
												} else if ((totalnum - 1) % pagesize_main == 0)//最后一页只有一条
												{
													var pagenum = grid.getStore().getCount();
													if (pagenum == 1) {
														startIndex = startIndex - pagesize_main;
													} //最后一页的时候,不是最后一页则还停留在这一页
												}
												grid.getStore().load({
													params : {
														start : startIndex,
														limit : pagesize_main
													}
												});
											}
										});
									} else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:' + jsonData.info;
										}
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除失败!' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
									}
								} else {
									Ext.Msg.show({
										title : '提示',
										msg : '异步通讯失败,请检查网络连接!',
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
								}
							}
						}, this);
					}
				}, this);
			} else {
				Ext.Msg.show({
					title : '提示',
					msg : '请选择需要删除的行!',
					icon : Ext.Msg.WARNING,
					buttons : Ext.Msg.OK
				});
			}
		}
	});
	/** 创建Form表单 */
	var WinForm = new Ext.form.FormPanel({
		id : 'form-save',
		labelAlign : 'right',
		labelWidth : 90,
		title : '基本信息',
		frame : true,
		reader : new Ext.data.JsonReader({
			root : 'data'
		}, [{
			name : 'PHNRowId',
			mapping : 'PHNRowId',
			type : 'string'
		}, {
			name : 'PHNCode',
			mapping : 'PHNCode',
			type : 'string'
		}, {
			name : 'PHNDesc',
			mapping : 'PHNDesc',
			type : 'string'
		}, {
			name : 'PHNActiveFlag',
			mapping : 'PHNActiveFlag',
			type : 'string'
		}, {
			name : 'PHNSysFlag',
			mapping : 'PHNSysFlag',
			type : 'string'
		}, {
			name : 'PHNFormDr',
			mapping : 'PHNFormDr',
			type : 'string'
		}, {
			name : 'PHNGenericDr',
			mapping : 'PHNGenericDr',
			type : 'string'
		}, {
			name : 'PHNToxicity',
			mapping : 'PHNToxicity',
			type : 'string'
		}, {
			name : 'PHNFactory',
			mapping : 'PHNFactory',
			type : 'string'
		}, {
			name : 'PHNManfDR',
			mapping : 'PHNManfDR',
			type : 'string'
		}, {
			name : 'PHNWholeFlag',
			mapping : 'PHNWholeFlag',
			type : 'string'
		}]),
		defaults : {
			anchor : '92%',
			border : false
		},
		defaultType : 'textfield',
		items : [{
			fieldLabel : 'PHNRowId',
			hideLabel : 'True',
			hidden : true,
			name : 'PHNRowId'
		}, {
			fieldLabel : '<font color=red>*</font>代码',
			name : 'PHNCode',
			id : 'PHNCodeF',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHNCodeF'),
			style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHNCodeF')),
			allowBlank : false,
			validationEvent : 'blur',
			validator : function(thisText) {
				if (thisText == "") {//当文本框里的内容为空的时候不用此验证
					return true;
				}
				var className = "web.DHCBL.KB.DHCPHProName";
				//后台类名称
				var classMethod = "FormValidate";
				//数据重复验证后台函数名
				var id = "";
				if (win.title == '修改') {// 如果窗口标题为"修改",则获取rowid
					var _record = grid.getSelectionModel().getSelected();
					var id = _record.get('PHNRowId');
					//此条数据的rowid
				}
				var flag = "";
				var flag = tkMakeServerCall(className, classMethod, id, thisText, "");
				//用tkMakeServerCall函数实现与后台同步调用交互
				if (flag == "1") {//当后台返回数据位"1"时转换为相应的bool值
					return false;
				} else {
					return true;
				}
			},
			invalidText : '该代码已经存在',
			listeners : {
				'change' : Ext.BDP.FunLib.Component.ReturnValidResult
			}
		}, {
			fieldLabel : '<font color=red>*</font>描述',
			name : 'PHNDesc',
			id : 'PHNDescF',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHNDescF'),
			style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHNDescF')),
			allowBlank : false,
			validationEvent : 'blur',
			validator : function(thisText) {
				if (thisText == "") {//当文本框里的内容为空的时候不用此验证
					return true;
				}
				var className = "web.DHCBL.KB.DHCPHProName";
				//后台类名称
				var classMethod = "FormValidate";
				//数据重复验证后台函数名
				var id = "";
				if (win.title == '修改') {// 如果窗口标题为"修改",则获取rowid
					var _record = grid.getSelectionModel().getSelected();
					var id = _record.get('PHNRowId');
					//此条数据的rowid
				}
				var flag = "";
				var flag = tkMakeServerCall(className, classMethod, id, "", thisText);
				//用tkMakeServerCall函数实现与后台同步调用交互
				if (flag == "1") {//当后台返回数据位"1"时转换为相应的bool值
					return false;
				} else {
					return true;
				}
			},
			invalidText : '该描述已经存在',
			listeners : {
				'change' : Ext.BDP.FunLib.Component.ReturnValidResult
			}
		}, {
			xtype : 'bdpcombo',
			pageSize : Ext.BDP.FunLib.PageSize.Combo,
			loadByIdParam : 'rowid',
			listWidth : 250,
			fieldLabel : '剂型',
			hiddenName : 'PHNFormDr',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHNFormDrF'),
			style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHNFormDrF')),
			//id :'CTCITProvinceDR',
			store : new Ext.data.Store({
				autoLoad : true,
				proxy : new Ext.data.HttpProxy({
					url : BindingForm
				}),
				reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
					name : 'PHEFRowId',
					mapping : 'PHEFRowId'
				}, {
					name : 'PHEFDesc',
					mapping : 'PHEFDesc'
				}])
			}),
			mode : 'local',
			shadow : false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'PHEFDesc',
			valueField : 'PHEFRowId'
		}, {
			xtype : 'bdpcombo',
			pageSize : Ext.BDP.FunLib.PageSize.Combo,
			loadByIdParam : 'rowid',
			listWidth : 250,
			fieldLabel : '通用名',
			hiddenName : 'PHNGenericDr',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHNGenericDrF'),
			style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHNGenericDrF')),
			//id :'CTCITProvinceDR',
			store : new Ext.data.Store({
				baseParams : {
					libcode : 'DRUG'
				},
				autoLoad : true,
				proxy : new Ext.data.HttpProxy({
					url : BindingGen
				}),
				reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
					name : 'PHEGRowId',
					mapping : 'PHEGRowId'
				}, {
					name : 'PHEGDesc',
					mapping : 'PHEGDesc'
				}])
			}),
			mode : 'local',
			shadow : false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'PHEGDesc',
			valueField : 'PHEGRowId'
		}, {
			xtype : 'bdpcombo',
			pageSize : Ext.BDP.FunLib.PageSize.Combo,
			loadByIdParam : 'rowid',
			listWidth : 250,
			fieldLabel : '毒性',
			hiddenName : 'PHNToxicity',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHNToxicityF'),
			style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHNToxicityF')),
			//id :'CTCITProvinceDR',
			store : new Ext.data.Store({
				autoLoad : true,
				proxy : new Ext.data.HttpProxy({
					url : BindingToxicity
				}),
				reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
					name : 'ToxRowId',
					mapping : 'ToxRowId'
				}, {
					name : 'ToxDesc',
					mapping : 'ToxDesc'
				}])
			}),
			mode : 'local',
			shadow : false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'ToxDesc',
			valueField : 'ToxRowId'
		}, {
			fieldLabel : '厂家',
			name : 'PHNFactory',
			id : 'PHNFactoryF',
			hideLabel : 'True',
			hidden : true,
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHNFactoryF'),
			style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHNFactoryF'))
		}, {
			xtype : 'bdpcombo',
			pageSize : Ext.BDP.FunLib.PageSize.Combo,
			loadByIdParam : 'rowid',
			listWidth : 250,
			fieldLabel : '厂家',
			hiddenName : 'PHNManfDR',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHNManfDRF'),
			style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHNManfDRF')),
			//id :'CTCITProvinceDR',
			store : new Ext.data.Store({
				autoLoad : true,
				proxy : new Ext.data.HttpProxy({
					url : BindingManf
				}),
				reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
					name : 'PHMARowId',
					mapping : 'PHMARowId'
				}, {
					name : 'PHMADesc',
					mapping : 'PHMADesc'
				}])
			}),
			mode : 'local',
			shadow : false,
			queryParam : 'desc',
			forceSelection : true,
			selectOnFocus : false,
			displayField : 'PHMADesc',
			valueField : 'PHMARowId'
		}, {
			xtype : 'checkbox',
			fieldLabel : '是否可用',
			name : 'PHNActiveFlag',
			id : 'PHNActiveFlagF',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHNActiveFlagF'),
			style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHNActiveFlagF')),
			checked : true,
			inputValue : true ? 'Y' : 'N'
		}, {
			xtype : 'checkbox',
			fieldLabel : '是否系统标识',
			name : 'PHNSysFlag',
			id : 'PHNSysFlagF',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHNSysFlagF'),
			style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHNSysFlagF')),
			checked : true,
			inputValue : true ? 'Y' : 'N'
		}, {
			xtype : 'checkbox',
			fieldLabel : '是否整支',
			name : 'PHNWholeFlag',
			id : 'PHNWholeFlagF',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHNWholeFlagF'),
			style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHNWholeFlagF')),
			checked : true,
			inputValue : true ? 'Y' : 'N'
		}]
	});
	var tabs = new Ext.TabPanel({
		activeTab : 0,
		frame : true,
		border : false,
		height : 200,
		items : [WinForm, AliasGrid]
	});
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
		width : 480,
		height : 380,
		layout : 'fit',
		plain : true, // true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : tabs,
		buttons : [{
			text : '保存',
			id : 'save_btn',
			iconCls : 'icon-save',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
				var tempCode = Ext.getCmp("PHNCodeF").getValue();
				var tempDesc = Ext.getCmp("PHNDescF").getValue();
				if (tempCode == "") {
					Ext.Msg.show({
						title : '提示',
						msg : '代码不能为空!',
						minWidth : 200,
						icon : Ext.Msg.ERROR,
						buttons : Ext.Msg.OK
					});
					return;
				}
				if (tempDesc == "") {
					Ext.Msg.show({
						title : '提示',
						msg : '描述不能为空!',
						minWidth : 200,
						icon : Ext.Msg.ERROR,
						buttons : Ext.Msg.OK
					});
					return;
				}
				if (WinForm.form.isValid() == false) {
					return;
				}
				if (win.title == "添加") {
					var hacom = "";
					if (AliasGrid.store.getModifiedRecords().length > 0) {
						var hacom = "Y";
					}
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						params : {
							'hacom' : hacom,
							'PHNRowId' : ""
						},
						success : function(form, action) {
							if (action.result.success == 'true') {
								win.hide();
								var myrowid = action.result.id;
								// var myrowid = jsonData.id;
								Ext.Msg.show({
									title : '提示',
									msg : '添加成功!',
									icon : Ext.Msg.INFO,
									buttons : Ext.Msg.OK,
									fn : function(btn) {
										grid.getStore().load({
											params : {
												start : 0,
												limit : 1,
												rowid : myrowid
											}
										});
									}
								});
								//添加时 同时保存别名
								AliasGrid.DataRefer = myrowid;
								AliasGrid.saveAlias();
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:' + action.result.errorinfo;
								}
								Ext.Msg.show({
									title : '提示',
									msg : '添加失败!' + errorMsg,
									minWidth : 200,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
							}
						},
						failure : function(form, action) {
							Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
						}
					});
				} else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							//修改时 先保存别名
							AliasGrid.saveAlias();
							//如果对照了则不允许修改代码和描述
							var PHNid = grid.getSelectionModel().getSelections()[0].get('PHNRowId');
							var disableFlag = CanUpdate(PHNid);
							var code = "", desc = "";
							Ext.getCmp("PHNCodeF").setDisabled(disableFlag);
							Ext.getCmp("PHNDescF").setDisabled(disableFlag);
							if (disableFlag == true) {
								var code = grid.getSelectionModel().getSelections()[0].get('PHNCode');
								var desc = grid.getSelectionModel().getSelections()[0].get('PHNDesc');
							} else {
								var code = Ext.getCmp("PHNCodeF").getValue();
								var desc = Ext.getCmp("PHNDescF").getValue();
							}
							WinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								waitTitle : '提示',
								url : SAVE_ACTION_URL,
								method : 'POST',
								params : {
									'PHNCode' : code, ///code只读，修改时禁用的话参数传不到，要单独传。
									'PHNDesc' : desc   ///desc只读，修改时禁用的话参数传不到，要单独传。
								},
								success : function(form, action) {
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = "rowid=" + action.result.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib.ReturnDataForUpdate("grid", QUERY_ACTION_URL, myrowid);

											}
										});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:' + action.result.errorinfo;
										}
										Ext.Msg.show({
											title : '提示',
											msg : '修改失败!' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
									}
								},
								failure : function(form, action) {
									Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
								}
							});
						}
					}, this);
				}
			}
		}, {
			text : '继续添加',
			iconCls : 'icon-save',
			handler : function() {
				var tempCode = Ext.getCmp("PHNCodeF").getValue();
				var tempDesc = Ext.getCmp("PHNDescF").getValue();
				if (tempCode == "") {
					Ext.Msg.show({
						title : '提示',
						msg : '代码不能为空!',
						minWidth : 200,
						icon : Ext.Msg.ERROR,
						buttons : Ext.Msg.OK
					});
					return;
				}
				if (tempDesc == "") {
					Ext.Msg.show({
						title : '提示',
						msg : '描述不能为空!',
						minWidth : 200,
						icon : Ext.Msg.ERROR,
						buttons : Ext.Msg.OK
					});
					return;
				}
				if (WinForm.form.isValid() == false) {
					return;
				}
				var hacom = "";
				if (AliasGrid.store.getModifiedRecords().length > 0) {
					var hacom = "Y";
				}
				WinForm.form.submit({
					clientValidation : true, // 进行客户端验证
					waitTitle : '提示',
					url : SAVE_ACTION_URL,
					method : 'POST',
					params : {
						'hacom' : hacom,
						'PHNRowId' : ""
					},
					success : function(form, action) {
						if (action.result.success == 'true') {
							Ext.BDP.FunLib.Component.FromHideClearFlag;
							var myrowid = action.result.id;
							Ext.getCmp("form-save").getForm().reset();
							Ext.Msg.show({
										title : '提示',
										msg : '添加成功!',
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK,
										fn : function(btn) {
											grid.getStore().load({
														params : {
																	start : 0,
																	limit : 1,
																	rowid : myrowid
																}
															});
											}
						    });
							//添加时 同时保存别名
							AliasGrid.DataRefer = myrowid;
							AliasGrid.saveAlias();
							//清空别名面板grid
							AliasGrid.DataRefer = "";
							AliasGrid.clearGrid();
						} else {
							var errorMsg = '';
							if (action.result.errorinfo) {
								errorMsg = '<br/>错误信息:' + action.result.errorinfo;
							}
							Ext.Msg.show({
								title : '提示',
								msg : '添加失败!' + errorMsg,
								minWidth : 200,
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK
							});
						}
					},
					failure : function(form, action) {
						Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
					}
				});
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				win.hide();
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("form-save").getForm().findField("PHNCode").focus(true, 800);
				if (win.title == "修改") {
					win.buttons[1].hide();
				} else {
					win.buttons[1].show();
				}
			},
			"hide" : Ext.BDP.FunLib.Component.FromHideClearFlag,
			"close" : function() {
			}
		}
	});
	/** 添加按钮 */
	var btnAddwin = new Ext.Toolbar.Button({
		text : '添加',
		tooltip : '添加一条数据(Shift+A)',
		iconCls : 'icon-add',
		id : 'add_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
		handler : AddData = function() {
			win.setTitle('添加');
			win.setIconClass('icon-add');
			win.show('new1');
			WinForm.getForm().reset();
			Ext.getCmp("PHNCodeF").setDisabled(false);
			Ext.getCmp("PHNDescF").setDisabled(false);
			//激活基本信息面板
			tabs.setActiveTab(0);
			//清空别名面板grid
			AliasGrid.DataRefer = "";
			AliasGrid.clearGrid();
		},
		scope : this
	});
	/** 修改按钮 */
	var btnEditwin = new Ext.Toolbar.Button({
		text : '修改',
		tooltip : '请选择一行后修改(Shift+U)',
		iconCls : 'icon-update',
		id : 'update_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
		handler : UpdateData = function() {
			if (!grid.selModel.hasSelection()) {
				Ext.Msg.show({
					title : '提示',
					msg : '请选择需要修改的行!',
					icon : Ext.Msg.WARNING,
					buttons : Ext.Msg.OK
				});
			} else {
				var _record = grid.getSelectionModel().getSelected();
				var disableFlag = CanUpdate(_record.get('PHNRowId'));
				Ext.getCmp("PHNCodeF").setDisabled(disableFlag);
				Ext.getCmp("PHNDescF").setDisabled(disableFlag);
				win.setTitle('修改');
				win.setIconClass('icon-update');
				win.show('');
				Ext.getCmp("form-save").getForm().reset();
				Ext.getCmp("form-save").getForm().load({
					url : OPEN_ACTION_URL + '&id=' + _record.get('PHNRowId'),
					success : function(form, action) {
					},
					failure : function(form, action) {
						Ext.Msg.alert('编辑', '载入失败');
					}
				});
				//激活基本信息面板
				tabs.setActiveTab(0);
				//加载别名面板
				var _record = grid.getSelectionModel().getSelected();
				AliasGrid.DataRefer = _record.get('PHNRowId');
				AliasGrid.loadGrid();
			}
		}
	});
	/** grid数据存储 */
	var ds = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : QUERY_ACTION_URL
		}), // 调用的动作
		reader : new Ext.data.JsonReader({
			totalProperty : 'total',
			root : 'data',
			successProperty : 'success'
		}, [{
			name : 'PHNRowId',
			mapping : 'PHNRowId',
			type : 'string'
		}, {
			name : 'PHNCode',
			mapping : 'PHNCode',
			type : 'string'
		}, {
			name : 'PHNDesc',
			mapping : 'PHNDesc',
			type : 'string'
		}, {
			name : 'PHNFormDr',
			mapping : 'PHNFormDr',
			type : 'string'
		}, {
			name : 'PHNGenericDr',
			mapping : 'PHNGenericDr',
			type : 'string'
		}, {
			name : 'PHNToxicity',
			mapping : 'PHNToxicity',
			type : 'string'
		}, {
			name : 'PHNFactory',
			mapping : 'PHNFactory',
			type : 'string'
		}, {
			name : 'PHNManfDR',
			mapping : 'PHNManfDR',
			type : 'string'
		}, {
			name : 'PHNActiveFlag',
			mapping : 'PHNActiveFlag',
			type : 'string'
		}, {
			name : 'PHNSysFlag',
			mapping : 'PHNSysFlag',
			type : 'string'
		}, {
			name : 'PHNWholeFlag',
			mapping : 'PHNWholeFlag',
			type : 'string'
		}])
	});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body, {
		disabled : false,
		store : ds
	});
	/** grid加载数据 */
	ds.load({
		params : {
			start : 0,
			limit : pagesize_main
		},
		callback : function(records, options, success) {
		}
	});
	/** grid分页工具条 */
	var paging = new Ext.PagingToolbar({
		pageSize : pagesize_main,
		store : ds,
		displayInfo : true,
		displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
		emptyMsg : "没有记录",
		plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
		listeners : {
			"change" : function(t, p) {
				pagesize_main = this.pageSize;
			}
		}
	});
	/** 增删改工具条 */
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel]
	});
	/** 搜索按钮 */
	var btnSearch = new Ext.Button({
		id : 'btnSearch',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
		iconCls : 'icon-search',
		text : '搜索',
		handler : function() {
			grid.getStore().baseParams = {
				code : Ext.getCmp("textCode").getValue(),
				desc : Ext.getCmp("textDesc").getValue(),
				form : Ext.getCmp("GlPPointer").getValue()
			};
			grid.getStore().load({
				params : {
					start : 0,
					limit : pagesize_main
				}
			});
		}
	});
	/** 重置按钮 */
	var btnRefresh = new Ext.Button({
		id : 'btnRefresh',
		iconCls : 'icon-refresh',
		text : '重置',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
		handler : function() {
			Ext.getCmp("textCode").reset();
			Ext.getCmp("textDesc").reset();
			Ext.getCmp("GlPPointer").reset();
			grid.getStore().baseParams = {};
			grid.getStore().load({
				params : {
					start : 0,
					limit : pagesize_main
				}
			});
		}
	});
	/** 搜索工具条 */
	var tb = new Ext.Toolbar({
		id : 'tb',
		items : ['代码', {
			xtype : 'textfield',
			id : 'textCode',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('textCode')
		}, '-', '描述', {
			xtype : 'textfield',
			id : 'textDesc',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('textDesc')
		}, '-', '剂型', {
			xtype : 'combo',
			id : 'GlPPointer',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('GlPPointer'),
			triggerAction : 'all', // query
			queryParam : "desc",
			forceSelection : true,
			selectOnFocus : false,
			typeAhead : true,
			mode : 'remote',
			pageSize : Ext.BDP.FunLib.PageSize.Combo,
			allQuery : '',
			minChars : 1,
			listWidth : 250,
			valueField : 'PHEFRowId',
			displayField : 'PHEFDesc',
			store : new Ext.data.JsonStore({
				url : BindingForm,
				root : 'data',
				totalProperty : 'total',
				idProperty : 'PHEFRowId',
				fields : ['PHEFRowId', 'PHEFDesc'],
				remoteSort : true,
				sortInfo : {
					field : 'PHEFRowId',
					direction : 'ASC'
				}
			})
		}, '-', btnSearch, '-', btnRefresh, '->'],
		listeners : {
			render : function() {
				tbbutton.render(grid.tbar);
				// tbar.render(panel.bbar)这个效果在底部
			}
		}
	});

	/** 创建grid */
	var grid = new Ext.grid.GridPanel({
		id : 'grid',
		region : 'center',
		closable : true,
		store : ds,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
		{
			header : 'PHNRowId',
			sortable : true,
			dataIndex : 'PHNRowId',
			hidden : true
		}, {
			header : '代码',
			sortable : true,
			dataIndex : 'PHNCode'
		}, {
			header : '描述',
			sortable : true,
			dataIndex : 'PHNDesc'
		}, {
			header : '剂型',
			sortable : true,
			dataIndex : 'PHNFormDr'
		}, {
			header : '通用名',
			sortable : true,
			dataIndex : 'PHNGenericDr'
		}, {
			header : '毒性',
			sortable : true,
			dataIndex : 'PHNToxicity'
		}, {
			header : '厂家',
			hidden : true,
			sortable : true,
			dataIndex : 'PHNFactory'
		}, {
			header : '厂家',
			sortable : true,
			dataIndex : 'PHNManfDR'
		}, {
			header : '是否可用',
			sortable : true,
			dataIndex : 'PHNActiveFlag',
			renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
		}, {
			header : '是否系统标识',
			sortable : true,
			dataIndex : 'PHNSysFlag',
			renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
		}, {
			header : '是否整支标识',
			sortable : true,
			dataIndex : 'PHNWholeFlag',
			renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
		}],
		stripeRows : true,
		title : '药品商品名字典',
		//stateful : true,
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		sm : new Ext.grid.RowSelectionModel({
			singleSelect : true
		}), // 按"Ctrl+鼠标左键"也只能单选
		bbar : paging,
		tbar : tb,
		tools : Ext.BDP.FunLib.Component.HelpMsg,
		stateId : 'grid'
	});

	/** grid双击事件 */
	grid.on("rowdblclick", function(grid, rowIndex, e) {
		var _record = grid.getSelectionModel().getSelected();
		if (!_record) {
			Ext.Msg.show({
				title : '提示',
				msg : '请选择需要修改的行!',
				icon : Ext.Msg.WARNING,
				buttons : Ext.Msg.OK
			});
		} else {
			var disableFlag = CanUpdate(_record.get('PHNRowId'));
			Ext.getCmp("PHNCodeF").setDisabled(disableFlag);
			Ext.getCmp("PHNDescF").setDisabled(disableFlag);
			win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show('');
			Ext.getCmp("form-save").getForm().reset();
			Ext.getCmp("form-save").getForm().load({
				url : OPEN_ACTION_URL + '&id=' + _record.get('PHNRowId'),
				success : function(form, action) {
				},
				failure : function(form, action) {
					Ext.Msg.alert('编辑', '载入失败');
				}
			});
			//激活基本信息面板
			tabs.setActiveTab(0);
			//加载别名面板
			var _record = grid.getSelectionModel().getSelected();
			AliasGrid.DataRefer = _record.get('PHNRowId');
			AliasGrid.loadGrid();
		}
	});
	/** 布局 */
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [grid]
	});
	/** 调用keymap */
	Ext.BDP.FunLib.Component.KeyMap(AddData, UpdateData, DelData);
});
