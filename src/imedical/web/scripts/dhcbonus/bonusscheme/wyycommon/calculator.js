// 编辑公式
formula = function(scheme, type, formulaTrgg) {
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
    var DecsArry=[];    //用于存储每次增加的描述长度，以方便删除。
	var CodeArry=[];    //用于存储每次增加的编码长度，以方便删除。
	var area = new Ext.form.TextArea({
				id : 'area',
				width : 500,
				height : 100,
				labelWidth : 20,
				fieldLabel : '计算公式',
				readOnly : true
			});

			
			
	var bonusTargetDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'BonusTargetCode', 'BonusTargetName'])
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

	var bonusTargetComb = new Ext.form.ComboBox({
				fieldLabel : '指标标识',
				width : 190,
				allowBlank : true,
				store : bonusTargetDs,
				valueField : 'BonusTargetCode',
				displayField : 'BonusTargetName',
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
			url : '../csp/dhc.bonus.scheme01exe.csp?action=schemelist',
			method : 'POST'
		})
	});
	var bonusSchemeComb = new Ext.form.ComboBox({
				id:'bonusSchemeComb',
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
	//奖金方案与核算单元联动

bonusSchemeComb.on("select", function(cmb, rec, id) {
				searchFun(cmb.getValue());
				UnitField.setValue("");
				acctbookDs.load({
							params : {
								start : 0,
								limit : 10
							}
						});
			});

	function searchFun(SetCfgDr) {

		acctbookDs.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.base10exe.csp?action=GetUnit&str='+UnitField.getValue()+ '&Schemerowid='
									+ bonusSchemeComb.getValue(),
				method : 'POST'
			});
		acctbookDs.load({
					params : {
						start : 0,
						limit : 10
					}
				});
	};

//奖金核算单元
var acctbookDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		acctbookDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.base10exe.csp?action=GetUnit&str='+UnitField.getValue()+ '&Schemerowid='
									+ bonusSchemeComb.getValue(),
				method : 'POST'
				})
			});

		var UnitField = new Ext.form.ComboBox({
					id : 'UnitField',
					fieldLabel : '核算单元',
					width : 190,
					listWidth : 230,
					allowBlank : true,
					store : acctbookDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'UnitField',
					minChars : 1,
					pageSize : 10,
					anchor: '90%',
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								alert(UnitField.getValue());
							}
						}
					}
				});
	
	// 方案和奖金项目联动
	bonusSchemeComb.on("select", function(cmb, rec, id) {
				bonusItemDs.load({
							params : {
								start : 0,
								limit : 10,
								type : bonusSchemeComb.getValue()
							}
						});
			});
	var bonusTargetTypeComb = new Ext.form.ComboBox({
				fieldLabel : '指标类别',
				width : 190,
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
					url : 'dhc.bonus.base10exe.csp?action=targertList&targetType='
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

	bonusTargetDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
					url : 'dhc.bonus.base10exe.csp?action=targertList&targetType='
							+ bonusTargetTypeComb.getValue(),
					method : 'POST'
				})
	});
	bonusTargetComb.on("select", function(cmb, rec, id) {
				if (bsfunTypeField.getValue() != '') {
				    if(bsfunTypeField.getValue() != '#BonUnitTarget') {
				        showValue(bsfunTypeField.getRawValue() + '#'
									+ cmb.getRawValue(), '^'
									+ bsfunTypeField.getValue() + '#T'
									+ cmb.getValue());
					    checkStr = checkStr + ' ' + rec.get('rowid') + ' ';
				   
				   }
				   else{
					 if(UnitField.getValue()!=""){
					     showValue(bsfunTypeField.getRawValue()+'('+UnitField.getRawValue()+')'+'#'
	                               + cmb.getRawValue(), '^'+ bsfunTypeField.getValue() + '@'+UnitField.getValue()+'#T'+ cmb.getValue());
                         checkStr = checkStr + ' ' + rec.get('rowid') + ' ';
						 UnitField.setValue();
					 }
					 else{
						 Ext.Msg.show({
													title : '提示',
													msg : '请选择核算单元！',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO,
													width : 250
												});
					 
					 }
				   }	
				} 
				else {
					showValue(cmb.getRawValue(), '^T' + cmb.getValue());
					checkStr = checkStr + ' ' + rec.get('rowid') + ' ';
				}

				bonusTargetComb.setValue("");

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

	var bonusItemComb = new Ext.form.ComboBox({
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

	bonusItemComb.on("select", function(cmb, rec, id) {

				if (bsfunTypeField.getValue() != '') {
				      if(bsfunTypeField.getValue() != '#BonUnitTarget') {
					     showValue(bsfunTypeField.getRawValue() + '#'
									+ cmb.getRawValue(), '^'
									+ bsfunTypeField.getValue() + '#S'
									+ cmb.getValue());
					     checkStr = checkStr + ' ' + rec.get('rowid') + ' ';
					  }
					  else{
					     if(UnitField.getValue()!=""){
					         showValue(bsfunTypeField.getRawValue()+'('+UnitField.getRawValue()+')'+'#'
	                               + cmb.getRawValue(), '^'+ bsfunTypeField.getValue() + '@'+UnitField.getValue()+'#S'+ cmb.getValue());
                             checkStr = checkStr + ' ' + rec.get('rowid') + ' ';
							 UnitField.setValue();
					      }
					     else{
					        Ext.Msg.show({
													title : '提示',
													msg : '请选择核算单元！',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO,
													width : 250
												});
					      }
				   }	
					
				} 
				else {
					checkStr = checkStr + ' ' + rec.get('rowid') + ' ';
					showValue(cmb.getRawValue(), '^S' + cmb.getValue());
				}
				bonusItemComb.setValue("");

			});

	var periodFunStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue'],
				data : [['', '空'], ['#supTarget', '上级单位指标'],['#suppTarget', '上上级单位指标'],
						['#Sum', '同级单位求和'],['#SumChild', '取下级单位和'],['#SumSchemeTarget', '方案指标求和'], ['#Percent', '占同类百分比'], 
						['#TargetTypeSum', '指标类别求和'],['#SchemeItemAvg', '求指标平均值'],['#BSFDeptRate', '科室扣税']
						,['#BSFPositive', '取正数'],['#BSFInteger', '取整数'],['#BSFAddUp', '结余差额累加']
						,['#GetDays', '取天数']]
			});


	var bonusfuncDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['funCode', 'funName'])
			});

	bonusfuncDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : '../csp/dhc.bonus.scheme01exe.csp?action=funlist&start=0&limit=10',
			method : 'POST'
		})
	});


	var bsfunTypeField = new Ext.form.ComboBox({
				id : 'bsfunTypeField',
				fieldLabel : '奖金函数',
				width : 190,
				listWidth : 180,
				selectOnFocus : true,
				allowBlank : false,
				//store : periodFunStore,
				store:bonusfuncDs,
				anchor : '90%',
				value : '', // 默认值
				valueNotFoundText : '',
				displayField : 'funName',
				valueField : 'funCode',
				triggerAction : 'all',
				emptyText : '',
				//mode : 'local', // 本地模式
				editable : false,
				//pageSize : 20,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});
			
		bsfunTypeField.on("select", function(cmb, rec, id) {
		   if(bsfunTypeField.getValue()!='#BonUnitTarget'){
		      Ext.getCmp('UnitField').setValue("");　
		      Ext.getCmp('UnitField').setDisabled(true);　 
		   }
		   else{
		      Ext.getCmp('UnitField').setDisabled(false);　
		   }
		});
		
	var formSet = new Ext.form.FormPanel({
				// title: '公式编辑区域',
				listWidth : 10,
				frame : true,
				fileUpload : true,
				bodyStyle : 'padding:5 5 5 5',
				region : 'north',
				height : 195,
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
										text : '指标类别：'
									}, bonusTargetTypeComb, {
										xtype : 'label',
										text : '奖金指标：'
									}, bonusTargetComb, {
										xtype : 'label',
										text : '奖金方案：'
									}, bonusSchemeComb, {
										xtype : 'label',
										text : '奖金项目：'
									}, bonusItemComb, {
										xtype : 'label',
										text : '奖金函数：'
									}, bsfunTypeField, {
										xtype : 'label',
										text : '核算单元：'
									},UnitField]
						}]
			});

	function showValue(name, code) {
		globalStr = globalStr + name;
		if (globalStr2 == "") {
			globalStr2 = code;
		} else {
			globalStr2 = globalStr2 + code;
		}
		DecsArry.push(name.length);
		CodeArry.push(code.length);
		//alert(globalStr2);
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
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
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
									globalStr2 = globalStr2 + "^" + this.text;
									DecsArry.push(this.text.length);
		                            CodeArry.push(this.text.length+1);
									checkStr = checkStr + ' ' + this.text + ' ';
									area.setValue(globalStr);
								}
							}, {
								columnWidth : .035,
								xtype : 'displayfield'
							}, {
								columnWidth : .05,
								xtype : 'button',
								text : '<--',
								tooltip : '删除',
								handler : function(b) {
								    //alert(globalStr2);
								    var i = 0-DecsArry.pop();
								    var j = 0-CodeArry.pop();
								    if(i!=0)
								    globalStr=globalStr.slice(0,i);
								    if(j!=0)
								    globalStr2=globalStr2.slice(0,j);
									 //alert(globalStr2);
								    area.setValue(globalStr);
								  }
								},{
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

					var upUrl = dhcbaUrl + "/dhchxbonus/formulaverify?exp="
							+ checkStr;

					var upUrl = dhcbaUrl + "/dhchxbonus/formulaverify?exp="
							+ (checkStr);

					formulaTrgg.setValue(globalStr);
					formu = globalStr2;
					win.close();
					return;
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
				height : 340,
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