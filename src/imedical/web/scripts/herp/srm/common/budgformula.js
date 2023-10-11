// �༭��ʽ

	
	
budgformula = function(scheme, type, parentItemGrid) {
	// type=1:��ʾ��Ӳ���
	// type=2:��ʾ�޸Ĳ���
	
	var gFormulaDesc=""  //Ԥ����Ŀ��ʽ���ʽ
	var gFormulaSet="" //Ԥ����Ŀ��ʽ����
	 //var gFormulaDesc=""; 
	 //var gFormulaSet="";
	
	var checkStr="";
	if (type == 1) {
		// ������ʾ
		gFormulaDesc = "";
		// ���ʽ����
		expreDesc = "";
		// �����˸�
		gFormulaSet = "";
		// ���ڴ洢
		globalStr3 = "";
		checkStr = "";
	}
	// if(type==2){
	// ////������ʾ
	// //gFormulaDesc = node.attributes.expName;
	// ////���ʽ����
	// //expreDesc = node.attributes.expDesc;
	// ////�����˸�
	// //gFormulaSet = node.attributes.expName2;
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

	// expdesc.setValue(expreDesc);


	var fitemTypeDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'code', 'name'])
			});

	fitemTypeDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : 'herp.budg.budgchemdetailexe.csp?action=itemType',
							method : 'POST'
						})
			});
			
	var formulaItemDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'code', 'name'])
			});

	var formulaItemComb = new Ext.form.ComboBox({
				fieldLabel : 'Ԥ����Ŀ',
				width : 190,
				allowBlank : true,
				store : formulaItemDs,
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
	var SchemeDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

	SchemeDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : '../csp/dhc.bonus.bonustargetcollectexe.csp?action=schemelist',
			method : 'POST'
		})
	});
	var bonusSchemeComb = new Ext.form.ComboBox({
				fieldLabel : '���𷽰�',
				width : 190,
				allowBlank : true,
				store : SchemeDs,
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
	bonusSchemeComb.on("select", function(cmb, rec, id) {
			bonusItemDs.load({
							params : {
								start : 0,
								limit : 10,
								type : bonusSchemeComb.getValue()
							}
						});
			});
	var fitemTypeComb = new Ext.form.ComboBox({
				fieldLabel : 'Ԥ�����',
				width : 190,
				allowBlank : true,
				store : fitemTypeDs,
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
	// �����ͺ��㵥Ԫ����
	fitemTypeComb.on("select", function(cmb, rec, id) {
				searchFun(cmb.getValue());

				formulaItemDs.load({
							params : {
								start : 0,
								limit : 10
							}
						});
			});

	function searchFun(SetCfgDr) {

		formulaItemDs.proxy = new Ext.data.HttpProxy({
					url : 'herp.budg.budgchemdetailexe.csp?action=getitem&itemtype='
							+ SetCfgDr.toString(),
					method : 'POST'
				});
		formulaItemDs.load({
					params : {
						start : 0,
						limit : 10
					}
				});
	};

	formulaItemDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
					url : 'herp.budg.budgchemdetailexe.csp?action=getitem&itemtype='
							+ fitemTypeComb.getValue(),
					method : 'POST'
				})
	});
	formulaItemComb.on("select", function(cmb, rec, id) {
				showValue(cmb.getRawValue(), '^' + cmb.getValue());
				formulaItemComb.setValue("");
				// alert(rec.get('rowid'));
				checkStr = checkStr + ' ' + rec.get('rowid') + ' ';
			});

	var bonusItemDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'SchemeItemCode', 'SchemeItemName'])
			});

	bonusItemDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : 'dhc.bonus.scheme01exe.csp?action=itemlist&type='
									+ bonusSchemeComb.getValue(),
							method : 'POST'
						})
			});

	var formula2ItemComb = new Ext.form.ComboBox({
				fieldLabel : '������Ŀ',
				width : 190,
				allowBlank : true,
				store : bonusItemDs,
				valueField : 'SchemeItemCode',
				displayField : 'SchemeItemName',
				triggerAction : 'all',
				emptyText : '',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});

	formula2ItemComb.on("select", function(cmb, rec, id) {
				showValue(cmb.getRawValue(), '^S' + cmb.getValue());
				formula2ItemComb.setValue("");
				checkStr = checkStr + ' ' + rec.get('rowid') + ' ';
			});

	var formSet = new Ext.form.FormPanel({
				// title: '��ʽ�༭����',
				listWidth : 10,
				frame : true,
				fileUpload : true,
				bodyStyle : 'padding:5 5 5 5',
				region : 'north',
				height : 185,
				labelSeparator : ':',
				width : 510,
				items : [area,

				{
							xtype : 'panel',
							layout : "table",
							isFormField : true,
							layoutConfig : {
								columns : 4
							},
							items : [{
										xtype : 'label',
										text : 'Ԥ�����'
									}, fitemTypeComb, {
										xtype : 'label',
										text : 'Ԥ����Ŀ��'
									}, formulaItemComb
									/*, {
										xtype : 'label',
										text : '���𷽰���'
									}, bonusSchemeComb, {
										xtype : 'label',
										text : '������Ŀ��'
									}, formula2ItemComb */
									]
						}]
			});

	function showValue(name, code) {
		gFormulaDesc = gFormulaDesc + name;
		if (gFormulaSet == "") {
			gFormulaSet = code;
		} else {
			gFormulaSet = gFormulaSet + code;
		}
		area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									//checkStr = checkStr + ' '+ rec.get('rowid');
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + this.text;
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + ' ' + 'a' + ' ';
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
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
									gFormulaDesc = gFormulaDesc + this.text;
									gFormulaSet = gFormulaSet + "^" + this.text;
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(gFormulaDesc);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .135,
								xtype : 'button',
								text : 'C',
								tooltip : '���',
								handler : function(b) {
									gFormulaDesc = "";
									gFormulaSet = "";
									checkStr = "";
									area.setValue(gFormulaDesc);
								}
							}]
				}]
	});

	var OkButton = new Ext.Toolbar.Button({
				text : 'ȷ��',
				handler : function() {
				// gFormulaDesc  //Ԥ����Ŀ��ʽ���ʽ
				// gFormulaSet //Ԥ����Ŀ��ʽ����

					
					//fIdRecord.set(gFormulaDesc);
					//fDescRecord.set(gFormulaSet);
					
		var records = parentItemGrid.getSelectionModel().getSelections();
		records[0].set("formulaset",gFormulaSet)
		records[0].set("formuladesc",gFormulaDesc)
		
		//var fIdRecord = records[0].get("formulaset")
		//var fDescRecord = records[0].get("formuladesc")
		
					
					
					win.close();
/*
					var upUrl = dhcbaUrl + "/dhcba/formulaverify?exp="
							+ checkStr;

					var upUrl = dhcbaUrl + "/dhcba/formulaverify?exp="
							+ encodeURIComponent(checkStr);

					// prompt('upUrl', upUrl)

					formSet.getForm().submit({
								url : upUrl,
								method : 'POST',
								waitMsg : '���ݵ�����, ���Ե�...',
								success : function(form, action, o) {

									formulaTrgg.setValue(gFormulaDesc);
									formu = gFormulaSet;
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
							*/

				}
			});

	var cancelButton = new Ext.Toolbar.Button({
				text : 'ȡ��'
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
				height : 320,
				minWidth : 715,
				minHeight : 320,
				layout : 'border',
				plain : true,
				modal : true,
				bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : [formSet, autohisoutmedvouchForm],
				buttons : [OkButton, cancelButton]
			});
	// ������ʾ
	win.show();
}