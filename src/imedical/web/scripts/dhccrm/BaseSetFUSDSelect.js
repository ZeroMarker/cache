var sdsevent = function(sdsstore, selectedfusdrow, selectedsdsrow, buttontype) {

	Ext.QuickTips.init();

	var sdsrowid = '';
	var Flag=false;
	var selectFlag=false;

	if (buttontype == 'sdsedit') {
		sdsrowid = selectedsdsrow.get('SDSRowId');
		var select=selectedfusdrow.get('SDType'); //单选、多选、文本、数值
		if(select=="单选"){
		selectFlag=true;
	}
	}
	if (buttontype == 'sdslook') {
		sdsrowid = selectedsdsrow.get('SDSRowId');
		Flag=true;
	}
	if (buttontype == 'sdsadd') {
		sdsrowid = '';
		var select=selectedfusdrow.get('SDType'); //单选、多选、文本、数值
		//alert(select);
		if(select=="单选"){
		selectFlag=true;
		}
		//alert(selectFlag)
	}

	var sdststore = new Ext.data.Store({

				url : 'dhccrmbaseset1.csp?actiontype=sdstlist&SDSRowId='
						+ sdsrowid,

				reader : new Ext.data.JsonReader({

							totalProperty : 'results',
							root : 'rows',
							id : 'SDSTRowId'

						}, [{
									name : 'SDSTParRef'
								}, {
									name : 'SDSTRowId'
								}, {
									name : 'SDSTTextVal'
								}, {
									name : 'SDSTSequence'
								}])
			});

	sdststore.load();

	var sdstcm = new Ext.grid.ColumnModel([{

				header : '关联编码',
				dataIndex : 'SDSTTextVal'
			}, {
				header : '顺序号',
				dataIndex : 'SDSTSequence'
			}]);

	var sdsttbar = new Ext.Toolbar({

		items : [{
					xtype : 'tbbutton',
					text : '添加',
					iconCls : 'add',
					handler : function() {
						var sdstrow = null;
						sdstevent(sdststore, sdsrowid, sdstrow, 'sdstadd');
					}
				}, {
					xtype : 'tbbutton',
					text : '修改',
					iconCls : 'option',
					handler : function() {
						var rows = sdstgrid.getSelectionModel().getSelections();
						var sdstrow = sdstgrid.getSelectionModel()
								.getSelected();
						if (rows.length == 0) {
							Ext.Msg.show({
										title : '错误',
										msg : '请选择要修改的行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						} else if (rows.length > 1) {

							Ext.Msg.show({
										title : '错误',
										msg : '只允许选择一行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						} else {
							sdstevent(sdststore, sdsrowid, sdstrow, 'sdstedit');
						}

					}
				}, {
					xtype : 'tbbutton',
					text : '删除',
					iconCls : 'remove',
					handler : function() {
						var rows = sdstgrid.getSelectionModel().getSelections();
						var sdstrow = sdstgrid.getSelectionModel()
								.getSelected();
						var sdstrowid = sdstrow.get('SDSTRowId');
						if (rows.length == 0) {
							Ext.Msg.show({
										title : '错误',
										msg : '请选择要修改的行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						} else if (rows.length > 1) {

							Ext.Msg.show({
										title : '错误',
										msg : '只允许选择一行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						} else {
							var sdstUrl = 'dhccrmbaseset1.csp?actiontype='
									+ 'sdstdel' + '&SDSTRowId=' + sdstrowid;
							Ext.Ajax.request({
								url : sdstUrl,
								waitMsg : '删除中...',
								failure : function(result, request) {
									Ext.Msg.show({
												title : '错误',
												msg : '请检查网络连接!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									
									if (jsonData.success == 'true') {

										sdststore.load({
													params : {
														start : 0,
														limit : 20
													}
												});

									} else {
										Ext.MessageBox.show({
													title : '错误',
													msg : jsonData.info,
													buttons : Ext.MessageBox.OK,
													icon : Ext.MessageBox.ERROR
												});
									}
								}
							});
						}

					}
				}]
	});

	var sdstgrid = new Ext.grid.GridPanel({

				collapsible : true,
				width : 440,
				height : 200,
				frame : true,
				title : '选择关联',
				viewConfig : {
					forceFit : true
				},
				store : sdststore,
				cm : sdstcm,
				tbar : sdsttbar
			});

	var sdsform = new Ext.form.FormPanel({

				frame : true,
				labelWidth : 80,
				autoHeight : true,
				items : [{
							layout : 'column',
							items : [{
										columnWidth : 1,
										layout : 'form',
										items : [{
													xtype : 'textfield',
													fieldLabel : '主题内容ID',
													id : 'SDSParRef',
													name : 'SDSParRef',
													auchor : '90%',
													width : 350
												}]
									}]
						}, {
							layout : 'column',
							items : [{
										columnWidth : 1,
										layout : 'form',
										items : [{
													xtype : 'textfield',
													fieldLabel : '文本值',
													id : 'SDSTextVal',
													name : 'SDSTextVal',
													auchor : '90%',
													width : 350
												}]
									}]
						}, {
							layout : 'column',
							items : [{
										columnWidth : 1,
										layout : 'form',
										items : [{
													xtype : 'textfield',
													fieldLabel : '单位',
													id : 'SDSUnit',
													name : 'SDSUnit',
													auchor : '90%',
													width : 350
												}]
									}]
						}, {
							layout : 'column',
							items : [{
										columnWidth : 0.5,
										layout : 'form',
										items : [{
													xtype : 'checkbox',
													boxLabel : '默认',
													id : 'SDSDefaultValue',
													labelSeparator : '',
													name : 'SDSDefaultValue'
												}]
									}]
						}, {
							layout : 'column',
							items : [{
										columnWidth : 0.5,
										layout : 'form',
										items : [{
													xtype : 'checkbox',
													boxLabel : '描述项',
													id : 'SDSDesc',
													labelSeparator : '',
													name : 'SDSDesc'
												}]
									}]
						}, {
							layout : 'column',
							items : [{
										columnWidth : 1,
										layout : 'form',
										items : [{
													xtype : 'numberfield',
													fieldLabel : '顺序号',
													id : 'SDSSequence',
													name : 'SDSSequence',
													auchor : '90%',
													width : 350
												}]
									}]
						}, sdstgrid]

			});

	if (buttontype == 'sdsadd') {
		sdstgrid.hide();
	};

	var sdssave = function() {

		var sdsUrl = 'dhccrmbaseset1.csp?actiontype=' + buttontype
				+ '&SDSParRef=' + Ext.getCmp('SDSParRef').getValue()
				+ '&SDSRowId=' + sdsrowid + '&SDSTextVal='
				+ encodeURI(encodeURI(Ext.getCmp('SDSTextVal').getValue())) + '&SDSUnit='
				+ encodeURI(encodeURI(Ext.getCmp('SDSUnit').getValue())) + '&SDSDefaultValue='
				+ Ext.getCmp('SDSDefaultValue').getValue() + '&SDSSequence='
				+ Ext.getCmp('SDSSequence').getValue() + '&SDSDesc='
				+ Ext.getCmp('SDSDesc').getValue()

		;
		if (sdsform.form.isValid()) {
			Ext.Ajax.request({
				url : sdsUrl,
				waitMsg : '保存中...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						/*
						 * Ext.Msg.show({ title: '提示', msg: '数据保存成功!', buttons:
						 * Ext.Msg.OK, icon: Ext.MessageBox.INFO });
						 */
						sdsstore.proxy.conn.url = 'dhccrmbaseset1.csp?actiontype=sdslist&SDRowId='
								+ Ext.getCmp('SDSParRef').getValue();

						sdsstore.load({
									params : {
										start : 0,
										limit : 20
									}
								});
						window.close();
						/*
						 * if (sdsrowid == '') { sdsrowid = jsonData.info; }
						 * 
						 * buttontype = 'sdsedit';
						 */
						if (buttontype == 'sdsadd') {
							sdsform.getForm().reset();
						}
					} else {
						Ext.MessageBox.show({
									title : '错误',
									msg : jsonData.info,
									buttons : Ext.MessageBox.OK,
									icon : Ext.MessageBox.ERROR
								});
					}
				},
				scope : this
			});
		} else {
			Ext.Msg.show({
						title : '错误',
						msg : '请修正页面提示的错误后提交',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
		}
	}

	sdsform.on('afterlayout', function(form, layout) {
				if (buttontype == 'sdsedit') {
					if(selectFlag){
						var IsorNot="0";
						sdsstore.each(function(record) {
                       var dFlag=record.get('SDSDefaultValue');
                       if(dFlag=="true"){
                       IsorNot="1";
                       return false;
                       }
                       });
                       if(IsorNot=="1"){
						if(selectedsdsrow.get('SDSDefaultValue')=="false"){
					Ext.getCmp('SDSDefaultValue').disable();
						}
                       }
						
                       }
					this.getForm().loadRecord(selectedsdsrow);
					
				}
				if (buttontype == 'sdslook') {
					this.getForm().loadRecord(selectedsdsrow);
					Ext.getCmp('SDSParRef').disable();
					Ext.getCmp('SDSTextVal').disable();
					Ext.getCmp('SDSUnit').disable();
					Ext.getCmp('SDSDefaultValue').disable();
					Ext.getCmp('SDSDesc').disable();
					Ext.getCmp('SDSSequence').disable();
					sdstgrid.disable();
					
					
				}
				if (buttontype == 'sdsadd') {
					Ext.getCmp('SDSParRef').setValue(selectedfusdrow
							.get('SDRowId'));
					if(selectFlag){		
					sdsstore.each(function(record) {
                       var dFlag=record.get('SDSDefaultValue');
                       if(dFlag=="true"){
                       Ext.getCmp('SDSDefaultValue').disable();
                       return false;
                       }
                       
                       });
                       }
				}

				Ext.getCmp('SDSParRef').disable();

			});
	var sdsreset = function() {
		sdsform.getForm().reset();
		buttontype = 'sdsadd';
	}
	var sdscancel = function() {
		window.close();
	}

	var window = new Ext.Window({

				title : '内容选择',
				width : 500,
				height : 450,
				layout : 'fit',
				plain : true,
				modal : true,
				bodyStyle : 'padding:10px;',
				buttonAlign : 'center',
				items : sdsform,
				buttons : [{
					        hidden:Flag,
							xtype : 'tbbutton',
							text : '保存',
							handler : sdssave
						}, {
							xtype : 'tbbutton',
							text : '取消',
							handler : sdscancel
						}]
			});

	window.show();

}

var sdstevent = function(sdststore, sdsrowid, sdstrow, buttontype) {

	Ext.QuickTips.init();

	var sdstrowid = '';

	if (buttontype == 'sdstedit') {
		sdstrowid = sdstrow.get('SDSTRowId');
	}
	if (buttontype == 'sdstadd') {
		sdstrowid = '';
	}

	var sdstform = new Ext.form.FormPanel({

				frame : true,
				labelWidth : 80,
				autoHeight : true,
				items : [{
							layout : 'column',
							items : [{
										columnWidth : 1,
										layout : 'form',
										items : [{
													xtype : 'textfield',
													fieldLabel : '内容选择ID',
													id : 'SDSTParRef',
													name : 'SDSTParRef',
													auchor : '90%',
													width : 350
												}]
									}]
						}, {
							layout : 'column',
							items : [{
										columnWidth : 1,
										layout : 'form',
										items : [{
													xtype : 'textfield',
													fieldLabel : '关联编码',
													id : 'SDSTTextVal',
													name : 'SDSTTextVal',
													auchor : '90%',
													width : 350
												}]
									}]
						}, {
							layout : 'column',
							items : [{
										columnWidth : 1,
										layout : 'form',
										items : [{
													xtype : 'numberfield',
													fieldLabel : '顺序号',
													id : 'SDSTSequence',
													name : 'SDSTSequence',
													auchor : '90%',
													width : 350
												}]
									}]
						}]

			});

	var sdstsave = function() {

		var sdstUrl = 'dhccrmbaseset1.csp?actiontype=' + buttontype
				+ '&SDSTParRef=' + Ext.getCmp('SDSTParRef').getValue()
				+ '&SDSTRowId=' + sdstrowid + '&SDSTTextVal='
				+ Ext.getCmp('SDSTTextVal').getValue() + '&SDSTSequence='
				+ Ext.getCmp('SDSTSequence').getValue();

		if (sdstform.form.isValid()) {
			Ext.Ajax.request({
						url : sdstUrl,
						waitMsg : '保存中...',
						failure : function(result, request) {
							Ext.Msg.show({
										title : '错误',
										msg : '请检查网络连接!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								/*
								 * Ext.Msg.show({ title: '提示', msg: '数据保存成功!',
								 * buttons: Ext.Msg.OK, icon:
								 * Ext.MessageBox.INFO });
								 */
								sdststore.load();
								window.close();
								if (sdstrowid == '') {
									sdstrowid = jsonData.info;
								}

								// buttontype = 'sdstedit';
							} else {
								Ext.MessageBox.show({
											title : '错误',
											msg : jsonData.info,
											buttons : Ext.MessageBox.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
						},
						scope : this
					});
		} else {
			Ext.Msg.show({
						title : '错误',
						msg : '请修正页面提示的错误后提交',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
		}
	}

	sdstform.on('afterlayout', function(form, layout) {
				if (buttontype == 'sdstedit') {
					this.getForm().loadRecord(sdstrow);
				}
				if (buttontype == 'sdstadd') {
					Ext.getCmp('SDSTParRef').setValue(sdsrowid);
				}

				Ext.getCmp('SDSTParRef').disable();

			});

	var sdstcancel = function() {
		window.close();
	}

	var window = new Ext.Window({

				title : '选择关联',
				width : 500,
				height : 300,
				layout : 'fit',
				plain : true,
				modal : true,
				bodyStyle : 'padding:10px;',
				buttonAlign : 'center',
				items : sdstform,
				buttons : [{
							xtype : 'tbbutton',
							text : '保存',
							handler : sdstsave
						}, {
							xtype : 'tbbutton',
							text : '取消',
							handler : sdstcancel
						}]
			});

	window.show();

}
