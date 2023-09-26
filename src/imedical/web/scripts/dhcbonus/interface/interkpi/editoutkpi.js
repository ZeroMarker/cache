var InterLocSetTabUrl = '../csp/dhc.bonus.interlocsetexe.csp';
var outKpiUrl = '../csp/dhc.bonus.outkpiruleexe.csp';
editFun = function(KPIGrid, outKpiDs, outKpiGrid, outKpiPagingToolbar) {
	var rowObj = outKpiGrid.getSelections();
	var KPIObj = KPIGrid.getSelections();
	var KPIDr = "" // KPIObj[0].get("rowid");
	var len = rowObj.length;
	if (len < 1) {
		Ext.Msg.show({
					title : 'ע��',
					msg : '��ѡ����Ҫ�޸ĵĽ���ָ���¼!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	} else {

		var interLocSetDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'code', 'name', 'shortcut', 'desc',
									'active'])
				});

		interLocSetDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						//url : 'dhc.bonus.intermethodexe.csp?action=getScheme',
						url : 'dhc.bonus.outkpiruleexe.csp?action=locsetlist&searchField=type&searchValue=1',
						method : 'POST'
					})
		});

		var interLocSetField = new Ext.form.ComboBox({
					id : 'interLocSetField',
					fieldLabel : '�ӿ���',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : interLocSetDs,
					valueField : 'rowid',
					displayField : 'shortcut',
					valueNotFoundText : rowObj[0].get('InterLocSetname'),
					triggerAction : 'all',
					emptyText : '',
					// name: 'interLocSetField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});

		var outkpiRuleDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'code', 'name', 'active'])
				});

		interLocSetField.on("select", function(cmb, rec, id) {
			outkpiRuleDs.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.outkpiruleexe.csp?action=kpilist&locSetDr='
								+ Ext.getCmp('interLocSetField').getValue(),
						method : 'POST'
					})
			outkpiRuleDs.load({
						params : {
							start : 0,
							limit : outKpiPagingToolbar.pageSize,
							locSetDr : cmb.getValue()
						}
					});
			schemeTarget1Ds.load({
						params : {
							start : 0,
							limit : outKpiPagingToolbar.pageSize,
							schemeID : cmb.getValue()
						}
					});
		});
		outkpiRuleDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.outkpiruleexe.csp?action=kpilist&locSetDr='
								+ Ext.getCmp('interLocSetField').getValue()
								+ '&sort=rowid&dir=asc',
						method : 'POST'
					})
		});
		var bonusTargetTypeEDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'code', 'name'])
				});

		bonusTargetTypeEDs.on('beforeload', function(ds, o) {
					ds.proxy = new Ext.data.HttpProxy({
								url : 'dhc.bonus.base10exe.csp?action=targetTypelist',
								method : 'POST'
							})
				});
	var bonusTargetTypeEdit = new Ext.form.ComboBox({
					fieldLabel : 'ָ�����',
					width : 230,
					allowBlank : true,
					store : bonusTargetTypeEDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					minChars : 1,
					pageSize : 10,
					valueNotFoundText : rowObj[0].get('TargetTypeName'),
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});
	// �����ͺ��㵥Ԫ����
	bonusTargetTypeEdit.on("select", function(cmb, rec, id) {
				schemeTarget1Ds.load({
							params : {
								start : 0,
								limit : 10
							}
						});
			});
		var schemeTarget1Ds = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		schemeTarget1Ds.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.interkpiexe.csp?action=interkpiTarget&dataSource=1&targetType='
						+ bonusTargetTypeEdit.getValue(),
						method : 'POST'
					})
		});

		var outkpiRuleField = new Ext.form.ComboBox({
					id : 'outkpiRuleField',
					fieldLabel : '�ӿ�ָ��',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : outkpiRuleDs,
					valueField : 'rowid',
					displayField : 'name',
					valueNotFoundText : rowObj[0].get('InterTargetName'),
					triggerAction : 'all',
					emptyText : '',
					// name: 'outkpiRuleField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});

		var schemeTargetEdit = new Ext.form.ComboBox({
					id : 'schemeTargetEdit',
					fieldLabel : '����ָ��',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : schemeTarget1Ds,
					valueField : 'rowid',
					displayField : 'name',
					valueNotFoundText : rowObj[0].get('name'),
					triggerAction : 'all',
					emptyText : '',
					name : 'schemeTargetEdit',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});
		var remarkField = new Ext.form.TextField({
					id : 'remarkField',
					fieldLabel : '�ӿ�ָ������',
					name : 'remark',
					allowBlank : true,
					valueNotFoundText : rowObj[0].get('InterTargetemark'),
					// width:180,
					// listWidth : 180,
					emptyText : '',
					anchor : '90%',
					selectOnFocus : 'true'
				});

		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 80,
					items : [interLocSetField,outkpiRuleField,bonusTargetTypeEdit,schemeTargetEdit, remarkField]
				});

		formPanel.on('afterlayout', function(panel, layout) {
					this.getForm().loadRecord(rowObj[0]);

					interLocSetField.setValue(rowObj[0].get("inLocSetDr"));
					outkpiRuleField.setValue(rowObj[0].get("okrDr"));
					remarkField.setValue(rowObj[0].get("InterTargetemark"))
					schemeTargetEdit.setValue(rowObj[0].get("InterTargetDr"))
					bonusTargetTypeEdit.setValue(rowObj[0].get("TargetTypeID"))
					
				});

		interLocSetField.on("select", function(cmb, rec, id) {
					outkpiRuleDs.proxy = new Ext.data.HttpProxy({
								url : outKpiUrl + '?action=kpilist&locSetDr='
										+ interLocSetField.getValue
										+ '&sort=rowid&dir=asc'
							});
					outkpiRuleDs.load({
								params : {
									start : 0,
									limit : outkpiRuleField.pageSize
								}
							});
				});
		var editButton = new Ext.Toolbar.Button({
					text : '�޸�'
				});

		// ��Ӵ�����
		var editHandler = function() {
			var locSetDr = Ext.getCmp('interLocSetField').getValue();
			var outKPIRlue = Ext.getCmp('outkpiRuleField').getValue();
			var remark = Ext.getCmp('remarkField').getValue();
			var schemeTargetID= Ext.getCmp('schemeTargetEdit').getValue();
			
			var active = 'Y'
			locSetDr = trim(locSetDr);
			outKPIRlue = trim(outKPIRlue);
			remark = trim(remark);
			if (locSetDr == "") {
				Ext.Msg.show({
							title : '��ʾ',
							msg : '��ѡ��ӿ���!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				return false;
			};
			if (outKPIRlue == "") {
				Ext.Msg.show({
							title : '��ʾ',
							msg : '��ѡ��ӿڹ���ָ��!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				return false;
			};
			var data = schemeTargetID + '^' + outKPIRlue + '^' + remark + '^' + active;

			var rowid = rowObj[0].get("InterMaprowid");

			Ext.Ajax.request({
						url : KPIUrl + '?action=edit&data=' + data + '&rowid='
								+ rowid,
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
											msg : '�޸ĳɹ�!',
											icon : Ext.MessageBox.INFO,
											buttons : Ext.Msg.OK
										});
								// outKpiDs.load({params:{start:0,limit:outKpiPagingToolbar.pageSize,KPIDr:KPIGrid.getSelections()[0].get("rowid"),dir:'asc',sort:'rowid'}});
								KPIDs.load({
											params : {
												start : 0,
												limit : KPIPagingToolbar.pageSize
											}
										});
								win.close();
							} else {
								if (jsonData.info == 'RepKPI') {
									Handler = function() {
										CodeField.focus();
									}
									Ext.Msg.show({
												title : '��ʾ',
												msg : '���ݼ�¼�ظ�!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO,
												fn : Handler
											});
								}
								if (jsonData.info == 'rowidEmpt') {
									Handler = function() {
										CodeField.focus();
									}
									Ext.Msg.show({
												title : '��ʾ',
												msg : '��������!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO,
												fn : Handler
											});
								}
								if (jsonData.info == 'EmptyRecData') {
									Handler = function() {
										CodeField.focus();
									}
									Ext.Msg.show({
												title : '��ʾ',
												msg : '��������Ϊ��!',
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
		editButton.addListener('click', editHandler, false);

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
					title : '�޸Ľ���ָ��',
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
					buttons : [editButton, cancelButton]
				});
		win.show();
	}
}