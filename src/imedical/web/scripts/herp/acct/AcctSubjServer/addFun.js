var userid = session['LOGON.USERID'];
var projUrl = '../csp/herp.acct.acctsubjserverexe.csp';
//增加方法
addFun = function () {
	//科目编码
	var usjcodeField = new Ext.form.TextField({
			fieldLabel: '科目编码',
			width: 180,
			allowBlank: false,
			selectOnFocus: 'true',
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (usjcodeField.getValue() !== "") {
							Ext.Ajax.request({
								url: '../csp/herp.acct.acctsubjserverexe.csp?action=getcoderule&acctbookid=' + acctbookid,
								success: function (result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success == 'true') {
										var data = jsonData.info;
										var arr = data.split("-");
										var j = usjcodeField.getValue().length;
										var i = 0;
										var k = 0;
										var count = 0;
										for (i = 0; i < arr.length; i++) //判断输入的编码长度是否符合要求
										{
											arr[i] = parseInt(arr[i]);
											count = count + arr[i];
											if (count == j) {
												k = 1;
												break;
											}
										}
										if (k == 1) //如果符合要求得出相应的科目级别
										{
											usjlevelField.setValue(i + 1);
											usjnameAllField.focus();
											if (i == 0)
												usupercodeField.disable();
											else
												usupercodeField.enable();
										} else {
											usjcodeField.focus();
											usjlevelField.setValue("");
											usjcodeField.setValue("");
										}
									}
								},
								scope: this
							});

						} else {
							Handler = function () {
								usjcodeField.focus();
							};
							Ext.Msg.show({
								title: '错误',
								msg: '编码不能为空!',
								buttons:

								Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler
							});
						}
					}
				}
			}
		});

	//科目名称
	var usjnameField = new Ext.form.TextField({
			fieldLabel: '科目名称',
			width: 180,
			allowBlank: false,
			//anchor: '95%',
			selectOnFocus: 'true',
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (usjnameField.getValue() != "") {
							udirectionField.focus();
						} else {
							Handler = function () {
								usjnameField.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '科室名称不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler
							});
						}
					}
				}
			}
		});

	//账套编码--去当前界面传入的值。(未完)
	var ubookidField = new Ext.form.TextField({
			fieldLabel: '当前账套',
			width: 180,
			selectOnFocus: 'true'
		});
	ubookidField.setValue(acctbookid);
	ubookidField.disable();

	//科目全称(未完)--各级名称拼接
	var usjnameAllField = new Ext.form.TextField({
			fieldLabel: '科目全称',
			width: 180,
			emptyText: '系统根据名称格式自动生成',
			disabled: true,
			selectOnFocus: 'true'
		});

	//考虑由科目名称首字母拼接
	var uspellField = new Ext.form.TextField({
			fieldLabel: '拼音码',
			width: 180,
			disabled: true,
			selectOnFocus: 'true'
		});

	var udefinecodeField = new Ext.form.TextField({
			fieldLabel: '自定义码',
			width: 180,
			//disabled:true,
			selectOnFocus: 'true'
		});

	//上级编码--自动生成，不可编辑。(未完)
	var usupercodeField = new Ext.form.TextField({
			fieldLabel: '上级编码',
			width: 180,
			editable: false,
			emptyText: '系统根据编码规则自动生成',
			tooltip: '系统根据编码规则自动生成',
			selectOnFocus: 'true'
		});
	usupercodeField.disable();

	//科目类别
	var usjtypeDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'code', 'name'])
		});
	usjtypeDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=sjtypelist&str',
				method: 'POST'
			});
	});
	var usjtypeField = new Ext.form.ComboBox({
			id: 'usjtypeField',
			fieldLabel: '科目类别',
			width: 180,
			listWidth: 250,
			store: usjtypeDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText: '请选择科目类型...',
			minChars: 1,
			pageSize: 10,
			selectOnFocus: true,
			forceSelection: 'true',
			editable: true
		});

	//科目性质
	var usjnatureDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'code', 'name'])
		});
	usjnatureDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=sjnaturelist&str',
				method: 'POST'
			});
	});
	var usjnatureField = new Ext.form.ComboBox({
			id: 'usjnatureField',
			fieldLabel: '科目性质',
			width: 180,
			listWidth: 250,
			allowBlank: true,
			store: usjnatureDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText: '请选择科目性质...',
			minChars: 1,
			pageSize: 10,
			selectOnFocus: true,
			forceSelection: 'true',
			editable: true
		});

	//科目级别
	var usjlevelDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [
				["1", '1'], ["2", '2'], ['3', '3'], ['4', '4'],
				['5', '5'], ['6', '6'], ['7', '7'], ['8', '8']
			]
		});
	var usjlevelField = new Ext.form.ComboBox({
			id: 'usjlevelField',
			fieldLabel: '科目级别',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: usjlevelDs,
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // 本地模式
			editable: false,
			emptyText: '请选择录入科目级别',
			selectOnFocus: true,
			forceSelection: true
		});

	//是否停用
	var uIsStopField = new Ext.form.Checkbox({
			id: 'uIsStopField',
			//fieldLabel: '是否停用',
			//labelSeparator : '是否停用:',
			hideLabel:true,
			height:20,
			style: 'border:0;background:none;margin-top:0px;',
			allowBlank: false
			//width: 30
		});

	//外币核算
	var uIsFcField = new Ext.form.Checkbox({
			id: 'uIsFcField',
			//fieldLabel: '外币核算',
			//labelSeparator : '外币核算:',
			hideLabel:true,
			height:20,
			style: 'border:0;background:none;margin-top:0px;',
			allowBlank: false
		});

	//数量核算
	var uIsNumField = new Ext.form.Checkbox({
			id: 'uIsNumField',
			//fieldLabel: '数量核算',
			//labelSeparator : '数量核算:',
			hideLabel:true,
			height:20,
			style: 'border:0;background:none;margin-top:0px;',
			allowBlank: false,
			listeners: {
				check: function (obj, uIsNum) {
					if (uIsNum) {
						uNumUnitField.enable();
					} else {
						uNumUnitField.disable();
						uNumUnitField.setValue("");
					}
				}
			}
		});

	//辅助核算
	var uIsCheckField = new Ext.form.Checkbox({
			id: 'uIsCheckField',
			//fieldLabel: '辅助核算',
			//labelSeparator : '辅助核算:',
			hideLabel:true,
			height:20,
			style: 'border:0;background:none;margin-top:0px;',
			allowBlank: false,
			selectOnFocus: true,
			triggerAction: 'all',
			forceSelection: true,
			listeners: {
				check: function (obj, uIsCheck) {
					if (uIsCheck) {
						CheckFieldSet.enable();
					} else {
						CheckFieldSet.disable();
					}
				}
			}
		});

	//借贷方向
	var udirectionStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '借'], ['-1', '贷']]
		});
	var udirectionField = new Ext.form.ComboBox({
			id: 'udirectionField',
			fieldLabel: '借贷方向',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: udirectionStore,
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // 本地模式
			editable: false,
			value: 1,
			selectOnFocus: true,
			forceSelection: true
		});

	//是否末级
	var uIsLastFieldStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '是'], ['0', '否']]
		});
	var uIsLastField = new Ext.form.ComboBox({
			id: 'uIsLastField',
			fieldLabel: '是否末级',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: uIsLastFieldStore,
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // 本地模式
			editable: false,
			value: '1',
			selectOnFocus: true,
			forceSelection: true
		});

	//计量单位
	var uNumUnitDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'code', 'desc'])
		});
	uNumUnitDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=numunitlist',
				method: 'POST'
			});
	});
	var uNumUnitField = new Ext.form.ComboBox({
			id: 'uNumUnitField',
			fieldLabel: '计量单位',
			width: 180,
			listWidth: 265,
			allowBlank: true,
			store: uNumUnitDs,
			valueField: 'rowid',
			displayField: 'desc',
			triggerAction: 'all',
			emptyText: '请选择计量单位',
			minChars: 1,
			pageSize: 10,
			selectOnFocus: true,
			forceSelection: 'true',
			editable: true

		});
	uNumUnitField.disable();

	//现金银行标识
	var uIsCashFieldStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '现金'], ['2', '银行'], ['0', '其他']]
		});
	var uIsCashField = new Ext.form.ComboBox({
			id: 'uIsCashField',
			fieldLabel: '现金银行标识',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: uIsCashFieldStore,
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // 本地模式
			editable: false,
			value: 0,
			selectOnFocus: true,
			forceSelection: true,
			listeners: {
				select: {
					fn: function (combo, record, index) {
						if (uIsCashField.getValue() == "1" || uIsCashField.getValue() == "2") { //如果是现金、银行,
							uIsCashFlow.enable(); //是否现金流量可用
							//如果现金流量是
							if (uIsCashFlow.getRawValue() == "是") {
								uCashFlowField.enable();
							} else {
								uCashFlowField.disable();
								
								uCashFlowField.setValue(0);
								uCashFlowField.setRawValue("");
							}

						} else {
							uIsCashFlow.disable();
							uCashFlowField.disable();
							uIsCashFlow.setValue(0);
							uIsCashFlow.setRawValue("否");
							uCashFlowField.setValue(0);
							uCashFlowField.setRawValue("");
						}
					}
				}
			}
		});

	//科目分组
	var usubjGroupStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['01', '医疗'], ['02', '药理'], ['03', '管理'], ['09', '其他']]
		});
	var usubjGroup = new Ext.form.ComboBox({
			id: 'usubjGroup',
			fieldLabel: '科目分组',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: usubjGroupStore,
			//anchor : '95%',
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // 本地模式
			editable: false,
			value: '09',
			selectOnFocus: true,
			forceSelection: true
		});

	//现金流量标识
	var uIsCashFlowStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '是'], ['0', '否']]
		});
	var uIsCashFlow = new Ext.form.ComboBox({
			id: 'uIsCashFlow',
			fieldLabel: '现金流量科目',
			//hideLabel :true,
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: uIsCashFlowStore,
			//anchor : '95%',
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // 本地模式
			editable: false,
			value: 0,
			selectOnFocus: true,
			forceSelection: true,
			listeners: {
				select: {
					fn: function (combo, record, index) {
						if (uIsCashFlow.getValue() == "1") { //如果是现金银行,现金流量项目可用
							uCashFlowField.enable();
						} else {
							uCashFlowField.disable();
							uCashFlowField.setValue(0);
							uCashFlowField.setRawValue("");
						}
					}
				}
			}
		});

	var uStartDateField = new Ext.form.DateField({
			id: 'uStartDateField',
			fieldLabel: '启用年月',
			format: 'Y-m',
			width: 180,
			emptyText: '',
			value: new Date(),
			plugins: 'monthPickerPlugin'
		});

	var uEndDateField = new Ext.form.DateField({
			id: 'uEndDateField',
			fieldLabel: '停用年月',
			format: 'Y-m',
			width: 180,
			emptyText: '',
			plugins: 'monthPickerPlugin'
		});

	//现金流量项
	var uCashFlowDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'code', 'name'])
		});
	uCashFlowDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=cashflowlist&acctbookid=' + acctbookid,
				method: 'POST'
			});
	});
	var uCashFlowField = new Ext.form.ComboBox({
			id: 'uCashFlowField',
			fieldLabel: '现金流量项',
			width: 180,
			listWidth: 280,
			hidden:true,
			hideLabel :true,
			allowBlank: true,
			store: uCashFlowDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText: '请选择现金流量项',
			minChars: 1,
			pageSize: 10,
			selectOnFocus: true,
			forceSelection: 'true',
			editable: true
		});

	var SJFieldSet = new Ext.form.FieldSet({
			//title : '添加新科目',
			height: 320,
			columnWidth: 1,
			layout: 'column',
			//labelSeparator: ':',
			items: [{
					columnWidth: .4,
					layout: 'form',
					labelWidth: 80,
					labelSeparator: " ",
					items: [{
							xtype: 'displayfield',
							value: '',
							columnWidth: .3
						},
						usjlevelField,
						usjcodeField,
						usjnameField,
						usjtypeField,
						usjnatureField,
						//usupercodeField,
						uNumUnitField,
						udefinecodeField
					]
				}, {
					columnWidth: .43,
					layout: 'form',
					labelWidth: 110,
					labelSeparator: " ",
					items: [{
							xtype: 'displayfield',
							value: '',
							columnWidth: .3
						},
						udirectionField,
						uIsLastField,
						usubjGroup,
						uIsCashField,
						uIsCashFlow,
						uCashFlowField,
						uStartDateField
						//uEndDateField
					]
				}, {
					columnWidth: .07,
					layout: 'form',
					hideLabel:true,
					style:'text-align:right',
					labelWidth: 0.005,
					items: [{
							xtype: 'displayfield',
							value: '',
							columnWidth: .3
						},
						uIsStopField,
						uIsFcField,
						uIsNumField,
						uIsCheckField
					]
				},{
					columnWidth: .1,
					layout: 'form',
					labelWidth: 0.05,
					hideLabel:true,
					//style:'padding-left:5px',
					items: [{
							xtype: 'displayfield',
							value: '',
							columnWidth: .3
						},{
							xtype: 'displayfield',
							value: '是否停用'
						},{
							xtype: 'displayfield',
							value: '外币核算'
						},{
							xtype: 'displayfield',
							value: '数量核算'
						},{
							xtype: 'displayfield',
							value: '辅助核算'
						}	]
				}
			]
		});

	//***定义结构***//
	var colItems = [{
			layout: 'column',
			border: false,
			defaults: {
				columnWidth: '1.0',
				bodyStyle: 'padding:5px',
				border: false
			},
			items: [{
					xtype: 'fieldset',
					autoHeight: true,
					items: [
						SJFieldSet
					]
				}
			]
		}
	];

	//***加载面板(框架)***//
	var formPanel = new Ext.form.FormPanel({
			//labelWidth: 90,
			labelAlign: 'right',
			frame: true,
			items: colItems
	});
		
		
	//加载面板
	formPanel.on('afterlayout', function (panel, layout) {
		Ext.Ajax.request({
			url: '../csp/herp.acct.acctsubjserverexe.csp?action=lastrec&acctbookid=' + acctbookid,
			waitMsg: '更新中...',
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					var lastrec = jsonData.info; //上次最后保存的信息
					//截取最后一次的编码信息,包括如下列
					/*
					AcctSubjID 0
					AcctBookID 1
					AcctSubjCode 2
					AcctSubjName 3
					Spell 4
					AcctSubjNameAll 5
					DefineCode 6
					SuperSubjCode 7
					SubjLevel 8
					AcctSubjTypeID 9
					SysSubjNatureID 10
					IsLast 11
					Direction 12
					IsCash 13
					IsNum 14
					NumUnit 15
					IsFc 16
					IsCheck 17
					IsStop 18
					subjGroup 19
					CashFlowID 20
					StartYear 21
					StartMonth 22
					EndYear 23
					EndMonth 24
					IsCashFlow 25
					SubjTypeName 26
					SubjNatureName 27
					CashItemName 28
					 */

					var arr = lastrec.split("^");
					lastAcctSubjID = arr[0]; //会计科目ID
					lastAcctBookID = arr[1]; //账套id
					lastAcctSubjCode = arr[2]; //科目编码
					lastAcctSubjName = arr[3]; //科目名称
					lastSpell = arr[4]; // 拼音码
					lastAcctSubjNameAll = arr[5]; //科目全称
					lastDefineCode = arr[6]; //自定义码
					lastSuperSubjCode = arr[7]; //上级编码
					lastSubjLevel = arr[8]; //科目级次
					lastAcctSubjTypeID = arr[9]; //科目类型
					lastSysSubjNatureID = arr[10]; //科目性质

					var lastDirection = arr[12]; //借贷
					var lastIsCash = arr[13]; //是否现金
					var lastIsNum = arr[14]; //数量帐
					var lastIsFc = arr[16]; //外币
					var lastIsCheck = arr[17]; //辅助核算
					var lastIsStop = arr[18]; //是否停用
					var lastCashFlowID = arr[20]; //现金流量项ID
					var lastIsCashFlow = arr[25]; //是否现金流量
					var lastSubjTypeName = arr[26]; //科目类型
					var lastSubjNatureName = arr[27]; //科目性质
					var lastCashItemName = arr[28]; //现金流量项内容
					usjcodeField.setValue(lastAcctSubjCode);
					usjnameField.setValue(lastAcctSubjName);
					udefinecodeField.setValue(lastDefineCode);
					usupercodeField.setValue(lastSuperSubjCode);
					usjlevelField.setValue(lastSubjLevel);

					uIsStopField.setValue(lastIsStop);
					uIsFcField.setValue(lastIsFc);
					uIsNumField.setValue(lastIsNum);
					uIsCheckField.setValue(lastIsCheck);

					usjtypeField.setValue(lastAcctSubjTypeID);
					usjtypeField.setRawValue(lastSubjTypeName);
					//usjtypeField.name=lastSubjTypeName;

					usjnatureField.setValue(lastSysSubjNatureID);
					usjnatureField.setRawValue(lastSubjNatureName);
					//usjnatureField.name=lastSubjNatureName;

					if (lastDirection == 1) {
						udirectionField.setValue(lastDirection);
						udirectionField.setRawValue("借");
					} else {
						udirectionField.setValue(lastDirection);
						udirectionField.setRawValue("贷");
					}
					//如果是现金、银行科目
					if (lastIsCash == 1 || lastIsCash == 2) {
						//且现金流量标识为是
						if (lastIsCashFlow == 1) {
							uIsCashFlow.setValue(lastIsCashFlow);
							uIsCashFlow.setRawValue("是");
							uCashFlowField.setValue(lastCashFlowID);
							uCashFlowField.setRawValue(lastCashItemName);
						} else {
							uIsCashFlow.setValue(0);
							uIsCashFlow.setRawValue("否");
							uCashFlowField.disable();
							uCashFlowField.setValue(0);
							uCashFlowField.setRawValue("");
						}

					} else {
						uIsCashFlow.disable();
						uIsCashFlow.setValue(0);
						uIsCashFlow.setRawValue("否");
						uCashFlowField.disable();
						uCashFlowField.setValue(0);
						uCashFlowField.setRawValue("");
					}

					/*
					var lastIsLast=arr[11];				//是否末级
					var lastDirection=arr[12];


					var lastNumUnit=arr[15];			//计量单位

					var lastsubjGroup=arr[19];			//科目分组

					var lastStartYear=arr[21];			//开始年度
					var lastStartMonth=arr[22];			//开始月份
					var lastEndYear=arr[23];			//结束年
					var lastEndMonth=arr[24];			//结束月

					 */
					//itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
				}
			},
			scope: this
		});

		/*
		usupercodeField.setValue();
		usjlevelField.setValue();
		usjtypeField.setRawValue();
		usjnatureField.setRawValue(rowObj[0].get("SubjNatureName"));
		var eIsLast=rowObj[0].get("IsLast");
		if(eIsLast=="是"){
		eIsLastField.setValue(1);
		}else{
		eIsLastField.setValue(0);
		};
		var edirection=rowObj[0].get("Direction");
		if(edirection=="借"){
		edirectionField.setValue(1);
		}else{
		edirectionField.setValue(-1);
		};
		eIsCashField.setValue(rowObj[0].get("IsCash"));
		eNumUnitField.setRawValue(rowObj[0].get("NumUnit"));
		var eIsNum=rowObj[0].get("IsNum");
		if(eIsNum=="是"){
		eIsNumField.setValue(true);
		eNumUnitField.enable();
		}else{
		eIsNumField.setValue(false);
		eNumUnitField.disable();
		};
		var eIsFc= rowObj[0].get("IsFc");
		if(eIsFc=="是"){
		eIsFcField.setValue(true);
		}else{
		eIsFcField.setValue(false);
		};
		var eIsCheck=rowObj[0].get("IsCheck");
		if(eIsCheck=="是"){
		eIsCheckField.setValue(true);
		}else{
		eIsCheckField.setValue(false);
		};
		var eIsStop=rowObj[0].get("IsStop");
		if(eIsStop=="是"){
		eIsStopField.setValue(true);
		}else{
		eIsStopField.setValue(false);
		};
		esubjGroup.setValue(rowObj[0].get("subjGroup"));
		eCashFlowField.setValue(rowObj[0].get("CashFlowID"));
		eStartDateField.setValue(rowObj[0].get("StartYM"));
		eEndDateField.setValue(rowObj[0].get("EndYM"));
		eIsCashFlow.setValue(rowObj[0].get("IsCashFlow"));
		 */

	});

	//***确定按钮***//
	addButton = new Ext.Toolbar.Button({
			text: '确定',
			iconCls:'submit'
		});

	//////////////////////////  增加按钮响应函数   //////////////////////////////
	addHandler = function () {
		var usjcode = usjcodeField.getValue();
		var usjname = usjnameField.getValue();
		var usjnameAll = usjnameAllField.getValue();
		var uspell = uspellField.getValue();
		var udefinecode = udefinecodeField.getValue();
		var usupercode = usupercodeField.getValue();
		var usjlevel = usjlevelField.getValue();
		var usjtype = usjtypeField.getValue();
		var usjnature = usjnatureField.getValue();
		var uIsLast = uIsLastField.getValue();
		var udirection = udirectionField.getValue();
		var uIsCash = uIsCashField.getValue();
		var uNumUnit = uNumUnitField.getValue();
		var uIsNum = (uIsNumField.getValue() == true) ? '1' : '0';
		var uIsFc = (uIsFcField.getValue() == true) ? '1' : '0';
		var uIsCheck = (uIsCheckField.getValue() == true) ? '1' : '0';
		var uIsStop = (uIsStopField.getValue() == true) ? '1' : '0';
		var usjGroup = usubjGroup.getValue();
		var uCashFlow = uCashFlowField.getValue();
		var uICFlow = uIsCashFlow.getValue();
		var uStartDate = uStartDateField.getValue();
		if (uStartDate !== "") {
			uStartDate = uStartDate.format('Y-m');
		};

		var uEndDate = uEndDateField.getValue();
		if (uEndDate !== "") {
			uEndDate = uEndDate.format('Y-m');
		};

		// if(uStartDate>uEndDate){
		// Ext.Msg.show({title:'错误',msg:'启用年月不能大于停用年月',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		// return;
		// };
		if ((usjname == "") || (usjcode == "")) {
			Ext.Msg.show({
				title: '错误',
				msg: '编码和名称不能为空',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
			return;
		}

		var len2 = 0;
		var flag = 1;
		Ext.Ajax.request({
			async: false,
			url: '../csp/herp.acct.acctsubjserverexe.csp?action=GetLength&acctbookid=' + acctbookid + '&usjlevel=' + usjlevel,
			waitMsg: '保存中...',
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					len2 = jsonData.info;
					var len = usjcode.length;
					if (len != len2) {
						Ext.Msg.show({
							title: '错误',
							msg: '科目编码不规范! ',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.ERROR
						});
						flag = 2;
						return;
					}else{
						var data = usjcode + "|" + usjname + "|" + udefinecode + "|" + usupercode + "|" + usjlevel + "|" + usjtype + "|" + usjnature + "|" +
							uIsLast + "|" + udirection + "|" + uIsCash + "|" + uIsNum + "|" + uNumUnit + "|" + uIsFc + "|" + uIsCheck + "|" + uIsStop + "|" +
							usjGroup + "|" + uCashFlow + "|" + uStartDate + "|" + uEndDate + "|" + uICFlow

						if (flag != 2) {
							Ext.Ajax.request({
								url: '../csp/herp.acct.acctsubjserverexe.csp?action=addsj&data=' + encodeURIComponent(data) + '&acctbookid=' + acctbookid,
								waitMsg: '保存中...',
								failure: function (result, request) {
									Ext.Msg.show({
										title: '错误',
										msg: '请检查网络连接!',
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.ERROR
									});
								},
								success: function (result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success == 'true') {
										//addwin.close(); //添加成功关闭窗口
										Ext.Msg.show({
											title: '注意',
											msg: '数据添加成功!',
											icon: Ext.MessageBox.INFO,
											buttons: Ext.Msg.OK
										});
										// itemGridDs.load(({params:{start:0,limit:25}}));
										itemGridDs.load({
											params: {
												start: 0,
												limit: itemGridPagingToolbar.pageSize
											}
										});

									} else {
										var message = "";
										if (jsonData.info == 'RepCode')
											message = '输入的编码已存在,请重新输入!';
										if (jsonData.info == 'mistake1')
											message = '请先录入该科目的上级编码！！';
										if (jsonData.info == 'mistake0')
											message = '编码长度与级别不匹配,请参照当前编码规则!';
										Ext.Msg.show({
											title: '错误',
											msg: message,
											buttons: Ext.Msg.OK,
											icon: Ext.MessageBox.ERROR
										});
									}
								},
								scope: this
							});
						}
						
						
					}
				}
			}
		});

		
		// addwin.close();

	}
	//***添加监听事件***//
	addButton.addListener('click', addHandler, false);

	cancelButton = new Ext.Toolbar.Button({
			text: '取消',
			iconCls:'back'
		});

	cancelHandler = function () {
		addwin.close();
	}

	cancelButton.addListener('click', cancelHandler, false);

	//***定义一个窗口***//
	addwin = new Ext.Window({
			title: '添加科目',
			width: 800,
			height: 350,
			layout: 'fit',
			plain: true,
			modal: true,
			bodyStyle: 'padding:5px;',
			buttonAlign: 'center',
			items: formPanel,
			buttons: [
				addButton,
				cancelButton
			]
		});
	addwin.show();

}
