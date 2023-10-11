// �༭��ʽ
formula = function(type, formulaTrgg) {
	// type=1:��ʾ��Ӳ���
	// type=2:��ʾ�޸Ĳ���
	if (type == 1) {
		// ������ʾ
		globalStr = "";
		// ���ʽ����
		expreDesc = "";
		// �����˸�
		globalStr2 = "";
		// ���ڴ洢
		globalStr3 = "";
		checkStr = "";
	}
	// if(type==2){
	// ////������ʾ
	// //globalStr = node.attributes.expName;
	// ////���ʽ����
	// //expreDesc = node.attributes.expDesc;
	// ////�����˸�
	// //globalStr2 = node.attributes.expName2;
	// ////���ڴ洢
	// //globalStr3 = node.attributes.expression;
	// }

	var area = new Ext.form.TextArea({
				id : 'area',
				width : 500,
				height : 100,
				labelWidth : 20,
				fieldLabel : '���㹫ʽ',
				readOnly : true
			});

	var CalcFieldDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid','code', 'name'])
			});

	CalcFieldDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : 'herp.srm.fieldcoefficientexe.csp?action=fieldlist&sysmod='
							+ SysModComb.getValue(),
							method : 'POST'
						})
			});

	var CalcFieldComb = new Ext.form.ComboBox({
				fieldLabel : '�����ֶ�',
				width : 180,
				listWidth:250,
				allowBlank : true,
				store : CalcFieldDs,
				valueField : 'code',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});

	CalcFieldComb.on("select", function(cmb, rec, id) {
				//showValue(cmb.getRawValue(), '^T' + cmb.getValue());
				showValue(cmb.getRawValue(),cmb.getValue());
				CalcFieldComb.setValue("");
				// alert(rec.get('rowid'));
				checkStr = checkStr + ' ' + rec.get('rowid') + ' ';
				
			});

	// -----------zlg--2011-07-20--------------------------------------------
	var SysModDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'code', 'name'])
			});

	SysModDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : 'herp.srm.fieldcoefficientexe.csp?action=sysmodelist',
							method : 'POST'
						})
			});

	var SysModComb = new Ext.form.ComboBox({
				fieldLabel : 'ϵͳģ��',
				width : 180,
				listWidth:250,
				allowBlank : true,
				store : SysModDs,
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
	// 
	SysModComb.on("select", function(cmb, rec, id) {
				searchFun(cmb.getValue());

				CalcFieldDs.load({
							params : {
								start : 0,
								limit : 10
							}
						});
			});

	function searchFun(SetCfgDr) {

		CalcFieldDs.proxy = new Ext.data.HttpProxy({
					url : 'herp.srm.fieldcoefficientexe.csp?action=fieldlist&sysmod='
							+ SetCfgDr.toString(),
					method : 'POST'
				});
		CalcFieldDs.load({
					params : {
						start : 0,
						limit : 10
					}
				});
	};

	var formFormula = new Ext.form.FormPanel({
		// title: '��ʽ�༭����',
		listWidth : 10,
		frame : true,
		fileUpload : true,
		bodyStyle : 'padding:5 5 5 5',
		region : 'north',
		height : 165,
		labelSeparator : ':',
		width : 510,
		items : [area, {
							xtype : 'panel',
							layout : "table",
							isFormField : true,
							layoutConfig : {
								columns : 4
							},
							items : [{
										xtype : 'label',
										text : 'ϵͳģ�飺'
									}, SysModComb, {
										xtype : 'label',
										text : '�����ֶΣ�'
									}, CalcFieldComb]
						}]
			// ,bonusItemComb]
		});

	function showValue(name, code) {
		globalStr = globalStr + name;
		//xm20151208 �洢��ʽ
		globalStr3 = globalStr3 + code;
		//alert(globalStr3);
		if (globalStr2 == "") {
			globalStr2 = '^T' +code;
		} else {
			globalStr2 = globalStr2 + '^T' +code;
		}
		//alert(globalStr2);
		area.setValue(globalStr);
	};

	var autohisoutmedvouchForm = new Ext.form.FormPanel({
		listWidth : 20,
		// title: '��ʽ�༭����',
		region : 'center',
		frame : true,
		height : 25,
		bodyStyle : 'padding:5 5 5 5',
		labelSeparator : ':',
		width : 550,
		items : [{
					xtype : 'panel',
					layout : "column",
					hideLabel : true,
					isFormField : true,
					items : [{
								columnWidth : .05,
								xtype : 'button',
								text : '9',
								tooltip : '9',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + ' '
											+ rec.get('rowid');
									checkStr = checkStr + this.text;
									//globalStr3 = globalStr3+ this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '8',
								tooltip : '8',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '7',
								tooltip : '7',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '6',
								tooltip : '6',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '5',
								tooltip : '5',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '4',
								tooltip : '4',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '3',
								tooltip : '3',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '2',
								tooltip : '2',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '1',
								tooltip : '1',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '0',
								tooltip : '0',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '.',
								tooltip : '��',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + this.text;
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '{',
								tooltip : '�������',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '}',
								tooltip : '�Ҵ�����',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '[',
								tooltip : '��������',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : ']',
								tooltip : '��������',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '(',
								tooltip : '��С����',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : ')',
								tooltip : '��С����',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '+',
								tooltip : '�Ӻ�',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + ' ' + 'a' + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '-',
								tooltip : '����',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '*',
								tooltip : '�˺�',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '/',
								tooltip : '����',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '^',
								tooltip : 'ָ��',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "^" + this.text;
									//xm20151208
									globalStr3 = globalStr3 + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							},
			{
								columnWidth : .135,
								xtype : 'button',
								text : 'C',
								tooltip : '���',
								handler : function(b) {
									globalStr = "";
									globalStr2 = "";
									globalStr3 = "";
									checkStr = "";
									area.setValue(globalStr);
								}
							}]
				}]
	});

	var OkButton = new Ext.Toolbar.Button({
				text : '����',
				iconCls: 'save', 
				handler : function() {

					var upUrl = herpsrmUrl + "/herpsrmcalc/formulaverify?exp="
							+ encodeURIComponent(checkStr);
					// -----------------------------
					formFormula.getForm().submit({
								url : upUrl,
								method : 'POST',
								waitMsg : '���ݵ�����, ���Ե�...',
								success : function(form, action, o) {

									formulaTrgg.setValue(globalStr);
									formu = globalStr2;
									//alert(formu);
									Ext.getCmp("hiddenField").setValue(globalStr3);
									win.close();

								},
								failure : function(form, action) {
									// Ext.MessageBox.alert("��ʾ��Ϣ",

									if (jsonData.info == "failure") {
										Ext.Msg.show({
													title : '��ʾ',
													msg : '�������������,����!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO,
													width : 250
												});

									}
									if (jsonData.info == "other") {
										Ext.Msg.show({
													title : '��ʾ',
													msg : '���ʽ����,���飡',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO,
													width : 250
												});

									}

								}
							});

					/*
					 * Ext.Ajax.request({ method : 'POST', url : upUrl, waitMsg :
					 * '��֤��...', failure : function(result, request) {
					 * 
					 * Ext.Msg.show({ title : '����', msg : '������������!', buttons :
					 * Ext.Msg.OK, icon : Ext.MessageBox.ERROR, width : 250 }); },
					 * success : function(result, request) {
					 * 
					 * var jsonData = Ext.util.JSON
					 * .decode(result.responseText);
					 * 
					 * if (jsonData.info == "success") {
					 * 
					 * formulaTrgg.setValue(globalStr); formu = globalStr2;
					 * win.close(); } if (jsonData.info == "failure") {
					 * Ext.Msg.show({ title : '��ʾ', msg : '�������������,����!',
					 * buttons : Ext.Msg.OK, icon : Ext.MessageBox.INFO, width :
					 * 250 }); } if (jsonData.info == "other") { Ext.Msg.show({
					 * title : '��ʾ', msg : '���ʽ����,���飡', buttons : Ext.Msg.OK,
					 * icon : Ext.MessageBox.INFO, width : 250 }); } }, scope :
					 * this });
					 */
				}
			});

	var cancelButton = new Ext.Toolbar.Button({
				text: '�ر�',
				iconCls: 'cancel'
			});

	// ����ȡ���޸İ�ť����Ӧ����
	cancelHandler = function() {
		win.close();
	}

	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);

	win = new Ext.Window({
				title : '��ʽ�����',
				width : 715,
				height : 300,
				minWidth : 715,
				minHeight : 300,
				layout : 'border',
				plain : true,
				modal : true,
				bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : [formFormula, autohisoutmedvouchForm],
				buttons : [OkButton, cancelButton]
			});
	// ������ʾ
	win.show();
}