var itemUrl='herp.budg.budgitemdictexe.csp';
var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
// 编辑公式
formula = function(type, formulaTrgg, formulaTrgg2, year) {
	// type=1:表示添加操作
	// type=2:表示修改操作
	if (type == 1) {
		// 用于显示
		globalStr = "";
		// 表达式描述
		expreDesc = "";
		// 用于退格
		globalStr2 = "";
		// 用于存储
		globalStr3 = "";
		checkStr = "";
	}
	// if(type==2){
	// ////用于显示
	// //globalStr = node.attributes.expName;
	// ////表达式描述
	// //expreDesc = node.attributes.expDesc;
	// ////用于退格
	// //globalStr2 = node.attributes.expName2;
	// ////用于存储
	// //globalStr3 = node.attributes.expression;
	// }

	var area = new Ext.form.TextArea({
				id : 'area',
				fieldLabel : '计算公式',
				width : 500,
				height : 100,
				labelWidth : 20,
				readOnly : true
			});

	var bonusTargetDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['code', 'name'])
			});
	bonusTargetDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : commonboxURL+'?action=item&flag=1&year='+year+'&type='
							+ bonusTargetTypeComb.getValue()+'&str='
							+ encodeURIComponent(Ext.getCmp('bonusTargetComb').getRawValue()),
							method : 'POST'
						})
			});
	var bonusTargetComb = new Ext.form.ComboBox({
				id :'bonusTargetComb',
				fieldLabel : '指标',
				width : 190,
				listWidth:230,
				allowBlank : true,
				store : bonusTargetDs,
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
	bonusTargetComb.on("select", function(cmb, rec, id) {
				showValue(cmb.getRawValue(), '-T' + cmb.getValue());
				bonusTargetComb.setValue("");
				// alert(rec.get('rowid'));
				checkStr = checkStr + ' ' + rec.get('rowid') + ' ';
			});

	// -----------zlg--2011-07-20--------------------------------------------
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
							url : commonboxURL+'?action=itemtype&flag=1',
							method : 'POST'
						})
			});
	var bonusTargetTypeComb = new Ext.form.ComboBox({
				fieldLabel : '类别',
				width : 190,
				allowBlank : true,
				store : bonusTargetTypeDs,
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
	bonusTargetTypeComb.on("select", function(cmb, rec, id) {
				searchFun(cmb.getValue());
				bonusTargetDs.load({
							params : {
								start : 0,
								limit : 10
							}
						});
			});

	function searchFun(SetCfgDr) {
		bonusTargetDs.proxy = new Ext.data.HttpProxy({
					url : commonboxURL+'?action=item&flag=1&year='+year+'&type='
							+ SetCfgDr.toString(),
					method : 'POST'
				});
		bonusTargetDs.load({
					params : {
						start : 0,
						limit : 10
					}
				});
	};

	var formFormula = new Ext.form.FormPanel({
		// title: '公式编辑区域',
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
										text : '类别：'
									}, bonusTargetTypeComb,{
										xtype : 'label',
										text : '指标：'
									}, bonusTargetComb]
						}]
			// ,bonusItemComb]
		});

	function showValue(name, code) {
		globalStr = globalStr + name;
		if (globalStr2 == "") {
			globalStr2 = code;
		} else {
			globalStr2 = globalStr2 + code;
		}
		area.setValue(globalStr);
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
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "-" + this.text;
									checkStr = checkStr + ' ' + rec.get('rowid');
									checkStr = checkStr + this.text;
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
									globalStr2 = globalStr2 + "-" + this.text;
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
									globalStr2 = globalStr2 + "-" + this.text;
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
									globalStr2 = globalStr2 + "-" + this.text;
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
									globalStr2 = globalStr2 + "-" + this.text;
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
									globalStr2 = globalStr2 + "-" + this.text;
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
									globalStr2 = globalStr2 + "-" + this.text;
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
									globalStr2 = globalStr2 + "-" + this.text;
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
									globalStr2 = globalStr2 + "-" + this.text;
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
									globalStr2 = globalStr2 + "-" + this.text;
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
								tooltip : '点',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "-" + this.text;
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
								tooltip : '左大括弧',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "-" + this.text;
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
								tooltip : '右大括弧',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "-" + this.text;
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
								tooltip : '左中括弧',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "-" + this.text;
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
								tooltip : '右中括弧',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "-" + this.text;
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
								tooltip : '左小括弧',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "-" + this.text;
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
								tooltip : '右小括弧',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "-" + this.text;
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
								tooltip : '加号',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "-" + this.text;
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
								tooltip : '减号',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "-" + this.text;
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
								tooltip : '乘号',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "-" + this.text;
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
								tooltip : '除号',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "-" + this.text;
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
								tooltip : '指数',
								handler : function(b) {
									globalStr = globalStr + this.text;
									globalStr2 = globalStr2 + "-" + this.text;
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
								tooltip : '清空',
								handler : function(b) {
									globalStr = "";
									globalStr2 = "";
									checkStr = "";
									area.setValue(globalStr);
								}
							}]
				}]
	});

	var OkButton = new Ext.Toolbar.Button({
				text : '确定',
				handler : function() {
					formulaTrgg.setValue(globalStr);
					formulaTrgg2.setValue(globalStr2);
					//alert(globalStr2);
					win.close();
					/*
					var upUrl = dhcbaUrl + "/dhcba/formulaverify?exp="+ encodeURIComponent(checkStr);
					formFormula.getForm().submit({
								url : upUrl,
								method : 'POST',
								waitMsg : '数据导入中, 请稍等...',
								success : function(form, action, o) {

									formulaTrgg.setValue(globalStr);
									formu = globalStr2;
									win.close();

								},
								failure : function(form, action) {

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
	// 窗口显示
	win.show();
}