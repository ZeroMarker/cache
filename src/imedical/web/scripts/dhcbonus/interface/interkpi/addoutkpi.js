function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
addFun = function(KPIGrid, outKpiDs, outKpiGrid, outKpiPagingToolbar) {

	var rowObj = KPIGrid.getSelections();
	var len = 1 // rowObj.length;

	if (len < 1) {
		Ext.Msg.show({
					title : '��ʾ',
					msg : '��ѡ��Ҫ���յ�ָ��!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
		return false;
	} else {
		// var KPIDr = rowObj[0].get("rowid");
		var locSetDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name', 'shortcut'])
				});

		locSetDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				// url : 'dhc.bonus.intermethodexe.csp?action=getScheme',
				url : 'dhc.bonus.outkpiruleexe.csp?action=locsetlist&searchField=type&searchValue=1',
				method : 'POST'
			})
		});

		var locSetField = new Ext.form.ComboBox({
					id : 'locSetField',
					fieldLabel : '�ӿ���',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : locSetDs,
					valueField : 'rowid',
					displayField : 'shortcut',
					triggerAction : 'all',
					emptyText : '',
					name : 'locSetField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});

		locSetField.on("select", function(cmb, rec, id) {
			outKPIRlueDs.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.outkpiruleexe.csp?action=kpilist&locSetDr='
								+ Ext.getCmp('locSetField').getValue(),
						method : 'POST'
					})
			outKPIRlueDs.load({
						params : {
							start : 0,
							limit : outKpiPagingToolbar.pageSize,
							locSetDr : cmb.getValue()
						}
					});
			schemeTargetDs.load({
						params : {
							start : 0,
							limit : outKpiPagingToolbar.pageSize,
							schemeID : cmb.getValue()
						}
					});
		});

		var outKPIRlueDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'code', 'name'])
				});

		outKPIRlueDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.outkpiruleexe.csp?action=kpilist&locSetDr='
								+ Ext.getCmp('locSetField').getValue(),
						method : 'POST'
					})
		});
		var bonusTargetTypeDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'code', 'name'])
				});

		bonusTargetTypeDs.on('beforeload', function(ds, o) {
					ds.proxy = new Ext.data.HttpProxy({
								url : 'dhc.bonus.base10exe.csp?action=targetTypelist',
								method : 'POST'
							})
				});

		var bonusTargetTypeComb = new Ext.form.ComboBox({
					fieldLabel : 'ָ�����',
					width : 230,
					allowBlank : true,
					store : bonusTargetTypeDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});
	// �����ͺ��㵥Ԫ����
	bonusTargetTypeComb.on("select", function(cmb, rec, id) {
				schemeTargetDs.load({
							params : {
								start : 0,
								limit : 10
							}
						});
			});
		var schemeTargetDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		schemeTargetDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : 'dhc.bonus.interkpiexe.csp?action=interkpiTarget&dataSource=1&targetType='
						+ bonusTargetTypeComb.getValue(),
				method : 'POST'
			})
		});

		var outKPIRlueField = new Ext.form.ComboBox({
					id : 'outKPIRlueField',
					fieldLabel : '�ӿ�ָ��',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : outKPIRlueDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'outKPIRlueField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});

		var bonusTargetField = new Ext.form.ComboBox({
					id : 'bonusTargetField',
					fieldLabel : '����ָ��',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : schemeTargetDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'bonusTargetField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});
		var remarkField = new Ext.form.TextField({
					id : 'remarkField',
					fieldLabel : 'ָ������',
					allowBlank : true,
					emptyText : '',
					anchor : '90%',
					selectOnFocus : 'true'
				});

		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 60,
					items : [locSetField, outKPIRlueField, bonusTargetTypeComb,
							bonusTargetField, remarkField]
				});

		var addButton = new Ext.Toolbar.Button({
					text : '���'
				});

		// ��Ӵ�����
		var addHandler = function() {

			var locSetDr = Ext.getCmp('locSetField').getValue();
			var outKPIRlue = Ext.getCmp('outKPIRlueField').getValue();
			var remark = Ext.getCmp('remarkField').getValue();
			var schemeTargetID = Ext.getCmp('bonusTargetField').getValue();

			locSetDr = trim(locSetDr);
			outKPIRlue = trim(outKPIRlue);
			remark = trim(remark);
			if (locSetDr == "") {
				Ext.Msg.show({
							title : '��ʾ',
							msg : '��ѡ���𷽰�!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				return false;
			};
			if (outKPIRlue == "") {
				Ext.Msg.show({
							title : '��ʾ',
							msg : '��ѡ�ӿ�ָ��!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				return false;
			};
			if (schemeTargetID == "") {
				Ext.Msg.show({
							title : '��ʾ',
							msg : '��ѡ����ָ��!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				return false;
			};
			var data = schemeTargetID + '^' + outKPIRlue + '^' + remark;
			// prompt('data', data)
			Ext.Ajax.request({
						url : KPIUrl + '?action=add&data=' + data,
						waitMsg : '�����..',
						failure : function(result, request) {
							Ext.Msg.show({
										title : '����',
										msg : '������������!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
											title : '��ʾ',
											msg : '��ӳɹ�!',
											icon : Ext.MessageBox.INFO,
											buttons : Ext.Msg.OK
										});
								// outKpiDs.load({params:{start:0,
								// limit:outKpiPagingToolbar.pageSize,locSetDr:locSetDr,dir:'asc',sort:'rowid'}});
								KPIDs.load({
											params : {
												start : 0,
												limit : KPIPagingToolbar.pageSize
											}
										});
								// win.close();

							} else {
								if (jsonData.info == 'RepKPI') {
									Handler = function() {
										codeField.focus();
									}
									Ext.Msg.show({
												title : '��ʾ',
												msg : '���ݼ�¼�ظ�!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO,
												fn : Handler
											});
								}
							}
						},
						scope : this
					});
		}

		// ��Ӱ�ť����Ӧ�¼�
		addButton.addListener('click', addHandler, false);

		// ����ȡ����ť
		var cancelButton = new Ext.Toolbar.Button({
					text : 'ȡ��'
				});

		// ȡ��������
		var cancelHandler = function() {
			win.close();
		}

		// ȡ����ť����Ӧ�¼�
		cancelButton.addListener('click', cancelHandler, false);

		var win = new Ext.Window({
					title : '���KPIָ��',
					width : 355,
					height : 230,
					minWidth : 355,
					minHeight : 200,
					layout : 'fit',
					plain : true,
					modal : true,
					bodyStyle : 'padding:5px;',
					buttonAlign : 'center',
					items : formPanel,
					buttons : [addButton, cancelButton]
				});
		win.show();
	}
}