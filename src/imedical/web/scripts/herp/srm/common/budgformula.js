// 编辑公式

	
	
budgformula = function(scheme, type, parentItemGrid) {
	// type=1:表示添加操作
	// type=2:表示修改操作
	
	var gFormulaDesc=""  //预算项目公式表达式
	var gFormulaSet="" //预算项目公式描述
	 //var gFormulaDesc=""; 
	 //var gFormulaSet="";
	
	var checkStr="";
	if (type == 1) {
		// 用于显示
		gFormulaDesc = "";
		// 表达式描述
		expreDesc = "";
		// 用于退格
		gFormulaSet = "";
		// 用于存储
		globalStr3 = "";
		checkStr = "";
	}
	// if(type==2){
	// ////用于显示
	// //gFormulaDesc = node.attributes.expName;
	// ////表达式描述
	// //expreDesc = node.attributes.expDesc;
	// ////用于退格
	// //gFormulaSet = node.attributes.expName2;
	// ////用于存储
	// //globalStr3 = node.attributes.expression;
	// }

	var area = new Ext.form.TextArea({
				id : 'area',
				width : 500,
				height : 100,
				labelWidth : 20,
				fieldLabel : '计算公式',
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
				fieldLabel : '预算项目',
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
				fieldLabel : '奖金方案',
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
	// 方案和核算单元联动
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
				fieldLabel : '预算类别',
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
	// 方案和核算单元联动
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
				fieldLabel : '奖金项目',
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
				// title: '公式编辑区域',
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
										text : '预算类别：'
									}, fitemTypeComb, {
										xtype : 'label',
										text : '预算项目：'
									}, formulaItemComb
									/*, {
										xtype : 'label',
										text : '奖金方案：'
									}, bonusSchemeComb, {
										xtype : 'label',
										text : '奖金项目：'
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
		// title: '公式编辑符号',
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
								tooltip : '点',
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
								tooltip : '左大括弧',
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
								tooltip : '右大括弧',
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
								tooltip : '左中括弧',
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
								tooltip : '右中括弧',
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
								tooltip : '左小括弧',
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
								tooltip : '右小括弧',
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
								tooltip : '加号',
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
								tooltip : '减号',
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
								tooltip : '乘号',
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
								tooltip : '除号',
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
								tooltip : '指数',
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
								tooltip : '清空',
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
				text : '确定',
				handler : function() {
				// gFormulaDesc  //预算项目公式表达式
				// gFormulaSet //预算项目公式描述

					
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
								waitMsg : '数据导入中, 请稍等...',
								success : function(form, action, o) {

									formulaTrgg.setValue(gFormulaDesc);
									formu = gFormulaSet;
									win.close();

								},
								failure : function(form, action) {
									// Ext.MessageBox.alert("提示信息",

									if (jsonData.info == "failure") {
										Ext.Msg.show({
													title : '提示',
													msg : '计算操作符错误,请检查!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO,
													width : 250
												});

									}
									if (jsonData.info == "other") {
										Ext.Msg.show({
													title : '提示',
													msg : '表达式错误,请检查！',
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
				text : '取消'
			});

	// 定义取消修改按钮的响应函数
	cancelHandler = function() {
		win.close();
	}

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);

	win = new Ext.Window({
				title : '公式设计器',
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
	// 窗口显示
	win.show();
}