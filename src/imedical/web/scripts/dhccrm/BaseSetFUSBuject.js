var fusbevent = function(fusbstore, selectedrow, buttontype) {

	Ext.QuickTips.init();

	var fusrowid = '';
	var Flag=false;

	if (buttontype == 'edit') {
		fusrowid = selectedrow.get('FUSRowId');
	}
	 if (buttontype == 'Look') {
        fusrowid = selectedrow.get('FUSRowId');
        Flag=true;
    }
	if (buttontype == 'add') {
		fusrowid = '';
	}
	var fusbform = new Ext.form.FormPanel({

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
													fieldLabel : '编码',
													id : 'FUSCode',
													name : 'FUSCode',
													auchor : '90%',
													allowBlank : false,
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
													fieldLabel : '名称',
													id : 'FUSDesc',
													name : 'FUSDesc',
													auchor : '90%',
													allowBlank : false,
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
													boxLabel : '日期限制',
													id : 'FUSDateLimit',
													labelSeparator : '',
													name : 'FUSDateLimit'
												}]
									}]
						}, {
							layout : 'column',
							items : [{
										columnWidth : 0.5,
										layout : 'form',
										items : [{
													xtype : 'checkbox',
													boxLabel : '发布',
													id : 'FUSActive',
													labelSeparator : '',
													name : 'FUSActive'
												}]
									}]
						}, {
							layout : 'column',
							items : [{
										columnWidth : 1,
										layout : 'form',
										items : [{
													xtype : 'datefield',
													fieldLabel : '开始日期',
													id : 'FUSDateBegin',
													name : 'FUSDateBegin',
													disabled : true,
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
													xtype : 'datefield',
													fieldLabel : '结束日期',
													id : 'FUSDateEnd',
													name : 'FUSDateEnd',
													disabled : true,
													auchor : '90%',
													width : 350
												}]
									}]
						}]

			});

	Ext.getCmp('FUSDateLimit').on('check', function() {

				if (Ext.getCmp('FUSDateLimit').getValue()) {
					Ext.getCmp('FUSDateBegin').enable();
					Ext.getCmp('FUSDateEnd').enable();
				} else {
					Ext.getCmp('FUSDateBegin').setValue('');
					Ext.getCmp('FUSDateBegin').disable();
					Ext.getCmp('FUSDateEnd').setValue('');
					Ext.getCmp('FUSDateEnd').disable();
				}
			});

	var fusbsave = function() {

		var startdate = '';
		if (Ext.getCmp('FUSDateBegin').getValue() != '') {
			startdate = Ext.getCmp('FUSDateBegin').getValue().format('Y-m-d')
					.toString();
		}
		var enddate = '';
		if (Ext.getCmp('FUSDateEnd').getValue() != '') {
			enddate = Ext.getCmp('FUSDateEnd').getValue().format('Y-m-d')
					.toString();
		}

		var fusbUrl = 'dhccrmbaseset1.csp?actiontype=' + buttontype
				+ '&FUSRowId=' + fusrowid + '&FUSCode='
				+ Ext.getCmp('FUSCode').getValue() + '&FUSDesc='
				+ encodeURI(encodeURI(Ext.getCmp('FUSDesc').getValue())) + '&FUSDateLimit='
				+ Ext.getCmp('FUSDateLimit').getValue() + '&FUSDateBegin='
				+ startdate + '&FUSDateEnd=' + enddate + '&FUSActive='
				+ Ext.getCmp('FUSActive').getValue();
		
		var FUSActive = Ext.getCmp('FUSActive').getValue()
		if (fusbform.getForm().isValid()) {
			
			Ext.Ajax.request({
						url : fusbUrl,
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
								window.close();
								fusbstore.load({
											params : {
												start : 0,
												limit : 20
											}
										});

								if (FUSActive) {

									location.reload();
								}
								/*
								 * if (fusrowid == '') { fusrowid =
								 * jsonData.info; }
								 * 
								 * buttontype = 'edit';
								 */
								if (buttontype == 'add') {
									fusbform.getForm().reset();
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

	fusbform.on('afterlayout', function(form, layout) {
				if (buttontype == 'edit') {
					this.getForm().loadRecord(selectedrow);
				}
				if (buttontype == 'Look') {
            this.getForm().loadRecord(selectedrow);
            Ext.getCmp('FUSCode').disable();
            Ext.getCmp('FUSDesc').disable();
            Ext.getCmp('FUSDateLimit').disable();
            Ext.getCmp('FUSActive').disable();
            Ext.getCmp('FUSDateBegin').disable();
            Ext.getCmp('FUSDateEnd').disable();
            
            
        }
			});
	var fusbreset = function() {
		fusbform.getForm().reset();
		buttontype = 'add';
	}
	var fusbcancel = function() {
		window.close();
	}

	var window = new Ext.Window({

				title : '主题信息',
				width : 500,
				height : 300,
				layout : 'fit',
				plain : true,
				modal : true,
				bodyStyle : 'padding:10px;',
				buttonAlign : 'center',
				items : fusbform,
				buttons : [{
					        hidden:Flag,
							xtype : 'tbbutton',
							text : '保存',
							handler : fusbsave
						}, {
							xtype : 'tbbutton',
							text : '取消',
							handler : fusbcancel
						}]
			});

	window.show();

}
