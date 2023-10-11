var userid = session['LOGON.USERID'];
editFun = function () {

	var rowObj = itemGrid.getSelectionModel().getSelections();

	var rowid = rowObj[0].get("rowid");
	var esjcodeField = new Ext.form.TextField({
			fieldLabel: '科目编码',
			width: 180,
			//anchor: '100%',
			allowBlank: false,
			selectOnFocus: 'true',
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (esjcodeField.getValue() != "") {
							esjnameField.focus();
						} else {
							Handler = function () {
								esjcodeField.focus();
							}
							Ext.Msg.show({
								title: '错误',
								msg: '科目编码不能为空!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler
							});
						}
					}
				}
			}

		});

	//科目名称
	var esjnameField = new Ext.form.TextField({
			fieldLabel: '科目名称',
			width: 180,
			allowBlank: false,
			selectOnFocus: 'true',
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (esjnameField.getValue() != "") {
							edirectionField.focus();
						} else {
							Handler = function () {
								esjnameField.focus();
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
	var ebookidField = new Ext.form.TextField({
			fieldLabel: '当前账套',
			width: 180,
			selectOnFocus: 'true'
		});
	ebookidField.setValue(acctbookid);
	ebookidField.disable();

	//科目全称(未完)--各级名称拼接
	var esjnameAllField = new Ext.form.TextField({
			fieldLabel: '科目全称',
			width: 180,
			emptyText: '系统根据编码规则自动生成',
			disabled: true,
			selectOnFocus: 'true'
		});

	//考虑由科目名称首字母拼接
	var espellField = new Ext.form.TextField({
			fieldLabel: '拼音码',
			width: 180,
			disabled: true,
			selectOnFocus: 'true'
		});

	var edefinecodeField = new Ext.form.TextField({
			fieldLabel: '自定义码',
			width: 180,
			//disabled:true,
			selectOnFocus: 'true'
		});

	//上级编码--自动生成，不可编辑。(未完)
	var esupercodeField = new Ext.form.TextField({
			fieldLabel: '上级编码',
			width: 180,
			//disabled:true,
			selectOnFocus: 'true'
		});
	ebookidField.disable();

	//科目类别
	var esjtypeDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'code', 'name'])
		});
	esjtypeDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=sjtypelist&str',
				method: 'POST'
			});
	});
	var esjtypeField = new Ext.form.ComboBox({
			id: 'esjtypeField',
			fieldLabel: '科目类别',
			width: 180,
			listWidth: 265,
			store: esjtypeDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText: '请选择科目类型...',
			name:'SubjTypeName',
			minChars: 1,
			pageSize: 10,
			selectOnFocus: true,
			forceSelection: 'true',
			editable: true
		});

	//科目性质
	var esjnatureDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'code', 'name'])
		});
	esjnatureDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=sjnaturelist&str',
				method: 'POST'
			});
	});
	var esjnatureField = new Ext.form.ComboBox({
			id: 'esjnatureField',
			fieldLabel: '科目性质',
			width: 180,
			listWidth: 265,
			allowBlank: true,
			store: esjnatureDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			name:'SubjNatureName',
			emptyText: '请选择科目性质...',
			minChars: 1,
			pageSize: 10,
			selectOnFocus: true,
			forceSelection: 'true',
			typeAhead : true,
			editable: true
		});

	//科目级别
	var esjlevelDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [
				['1', '1'], ['2', '2'], ['3', '3'], ['4', '4'],
				['5', '5'], ['6', '6'], ['7', '7'], ['8', '8']
			]
		});
	var esjlevelField = new Ext.form.ComboBox({
			id: 'esjlevelField',
			fieldLabel: '科目级别',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: esjlevelDs,
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // 本地模式
			editable: false,
			selectOnFocus: true,
			forceSelection: true
		});

	//是否停用
	var eIsStopField = new Ext.form.Checkbox({
			id: 'eIsStopField',
			//fieldLabel: '是否停用',
			hideLabel:true,
			labelAlign :'left',
			height:20,
			//labelSeparator : '是否停用:',
			style: 'border:0;background:none;margin-top:0px;',
			allowBlank: false
		});
	//外币核算
	var eIsFcField = new Ext.form.Checkbox({
			id: 'eIsFcField',
			hideLabel:true,
			height:20,
			//fieldLabel: '外币核算',
			//labelSeparator : '外币核算:',
			style: 'border:0;background:none;margin-top:0px;',
			allowBlank: false
		});
	//数量核算
	var eIsNumField = new Ext.form.Checkbox({
			id: 'eIsNumField',
			hideLabel:true,
			height:20,
			//fieldLabel: '数量核算',
			//labelSeparator : '数量核算:',
			style: 'border:0;background:none;margin-top:0px;',
			allowBlank: false,
			listeners: {
				check: function (obj, eIsNum) {
					if (eIsNum) {
						eNumUnitField.enable();
					} else {
						eNumUnitField.disable();
					}
				}
			}
		});
	//辅助核算
	var eIsCheckField = new Ext.form.Checkbox({
			id: 'eIsCheckField',
			hideLabel:true,
			height:20,
			//fieldLabel: '辅助核算',
			//labelSeparator : '辅助核算:',
			style: 'border:0;background:none;margin-top:0px;',
			allowBlank: false,
			selectOnFocus: true,
			triggerAction: 'all',
			forceSelection: true,
			listeners: {
				check: function (obj, eIsCheck) {
					if (eIsCheck) {
						// eCheckFieldSet.enable();
					} else {
						// eCheckFieldSet.disable();
					}
				}
			}
		});

	//借贷方向
	var edirectionStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '借'], ['-1', '贷']]
		});
	var edirectionField = new Ext.form.ComboBox({
			id: 'edirectionField',
			fieldLabel: '借贷方向',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: edirectionStore,
			//anchor : '95%',
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
	var eIsLastFieldStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '是'], ['0', '否']]
		});
	var eIsLastField = new Ext.form.ComboBox({
			id: 'eIsLastField',
			fieldLabel: '是否末级',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: eIsLastFieldStore,
			//anchor : '95%',
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // 本地模式
			editable: false,
			value: 1,
			selectOnFocus: true,
			forceSelection: true
		});

	//计量单位
	var eNumUnitDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'code', 'desc'])
		});
	eNumUnitDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=numunitlist',
				method: 'POST'
			});
	});
	var eNumUnitField = new Ext.form.ComboBox({
			id: 'eNumUnitField',
			fieldLabel: '计量单位',
			width: 180,
			listWidth: 265,
			allowBlank: true,
			store: eNumUnitDs,
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
	eNumUnitField.disable();
	//现金银行标识
	var eIsCashFieldStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '现金'], ['2', '银行'], ['0', '其他']]
		});
	var eIsCashField = new Ext.form.ComboBox({
			id: 'eIsCashField',
			fieldLabel: '现金银行标识',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: eIsCashFieldStore,
			//anchor : '95%',
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // 本地模式
			editable: false,
			value: '0',
			selectOnFocus: true,
			forceSelection: true,
			listeners: {
				select: {
					fn: function (combo, record, index) {
						if (eIsCashField.getValue() == "1" || eIsCashField.getValue() == "2") { //如果现金、银行的科目
							eIsCashFlow.enable(); //是否现金流量启用
							//如果现金流量是
							if (eIsCashFlow.getRawValue() == "是") {
								eCashFlowField.enable();
							} else {
								eCashFlowField.disable();
								eCashFlowField.setValue(0);
								eCashFlowField.setRawValue("");
							}

						} else { //否则相关项置空
							eIsCashFlow.disable();
							eCashFlowField.disable();
							eIsCashFlow.setValue(0);
							eIsCashFlow.setRawValue("否");
							eCashFlowField.setValue(0);
							eCashFlowField.setRawValue("");
						}
					}
				}
			}
		});

	//科目分组
	var esubjGroupStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['01', '医疗'], ['02', '药理'], ['03', '管理'], ['09', '其他']]
		});
	var esubjGroup = new Ext.form.ComboBox({
			id: 'esubjGroup',
			fieldLabel: '科目分组',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: esubjGroupStore,
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

	//现金银行标识
	var eIsCashFlowStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '是'], ['0', '否']]
		});
	var eIsCashFlow = new Ext.form.ComboBox({
			id: 'eIsCashFlow',
			fieldLabel: '现金流量科目',
			width: 180,
			selectOnFocus: true,
			//allowBlank : false,
			store: eIsCashFlowStore,
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
						if (eIsCashFlow.getValue() == "1") { //如果是现金,现金流量项目可用
							eCashFlowField.enable();
						} else {
							eCashFlowField.disable();
							eCashFlowField.setValue(0);
							eCashFlowField.setRawValue("");
						}
					}
				}
			}
		});

	var eStartDateField = new Ext.form.DateField({
			id: 'eStartDateField',
			fieldLabel: '启用年月',
			format: 'Y-m',
			width: 180,
			emptyText: '',
			plugins: 'monthPickerPlugin'
		});

	var eEndDateField = new Ext.form.DateField({
			id: 'eEndDateField',
			fieldLabel: '停用年月',
			format: 'Y-m',
			width: 180,
			emptyText: '',
			plugins: 'monthPickerPlugin'
		});

	//现金流量项
	var eCashFlowDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'code', 'name'])
		});
	eCashFlowDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=cashflowlist&acctbookid=' + acctbookid,
				method: 'POST'
			});
	});
	var eCashFlowField = new Ext.form.ComboBox({
			id: 'eCashFlowField',
			fieldLabel: '现金流量项',
			width: 180,
			listWidth: 265,
			allowBlank: true,
			hidden:true,
			hideLabel :true,
			store: eCashFlowDs,
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

	var eSJFieldSet = new Ext.form.FieldSet({
			//title : '修改会计科目',
			height: 320,
			columnWidth: 1,
			layout: 'column',
			//labelSeparator: '：',
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
						esjlevelField,
						esjcodeField,
						esjnameField,
						esjtypeField,
						esjnatureField,
						esupercodeField,
						edefinecodeField,
						eNumUnitField
					]
				}, {
					columnWidth: .44,
					layout: 'form',
					labelWidth: 110,
					labelSeparator: " ",
					items: [{
							xtype: 'displayfield',
							value: '',
							columnWidth: .3
						},
						edirectionField,
						eIsLastField,
						esubjGroup,
						eIsCashField,
						eIsCashFlow,
						eCashFlowField,
						eStartDateField,
						eEndDateField
					]
				},{
					columnWidth: .06,
					layout: 'form',
					hideLabel:true,
					style:'text-align:right',
					labelWidth: 0.005,
					items: [{
							xtype: 'displayfield',
							value: '',
							columnWidth: .3
						},
						eIsStopField,
						eIsFcField,
						eIsNumField,
						eIsCheckField
					]},{
					columnWidth: .1,
					layout: 'form',
					labelWidth: 0.5,
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
						eSJFieldSet
					]
				}
			]
		}
	];

	//***加载面板(框架)***//
	var formPanel = new Ext.form.FormPanel({
			//labelWidth: 100,
			labelAlign: 'right',
			frame: true,
			items: colItems
		});
	formPanel.on('afterlayout', function (panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
		esjcodeField.setValue(rowObj[0].get("SubjCode")); //编辑时,科目编码
		var SubjNames = rowObj[0].get("SubjName"); //科目名称--此时从页面拿值(带有空格)
		var SubjNames = SubjNames.split(";");
		SubjName = SubjNames[SubjNames.length - 1]; //科目名称去掉空格
		esjnameField.setRawValue(SubjName);
		//
		edefinecodeField.setValue(rowObj[0].get("DefineCode")); //自定义编码
		esupercodeField.setValue(rowObj[0].get("SuperSubjCode")); //上级编码
		esupercodeField.disable();

		var esjlevel = rowObj[0].get("SubjLevel"); //科目级次
		esjlevelField.setValue(esjlevel);
		
		//esjtypeField.setValue(rowObj[0].get("SubjTypeID")); //获取科目类型ID
		//esjtypeField.setRawValue(rowObj[0].get("SubjTypeName")); //显示科目类型名称

        //esjnatureField.setValue(rowObj[0].get("SubjNatureID")); //获取科目性质ID
		//esjnatureField.setRawValue(rowObj[0].get("SubjNatureName")); //显示科目性质名称
		
		//是否末级科目
		var eIsLast = rowObj[0].get("IsLast"); //是否末级科目
		if (eIsLast == "是") {
			eIsLastField.setValue(1);
		} else {
			eIsLastField.setValue(0);
		};
		//借贷方向
		var edirection = rowObj[0].get("Direction");
		if (edirection == "借") {
			edirectionField.setValue(1);
		} else {
			edirectionField.setValue(-1);
		};

		//现金流量科目
		var iscashflow = rowObj[0].get("IsCashFlow")
			if (iscashflow == "是") {
				eIsCashFlow.setValue(1);
				eIsCashFlow.setRawValue("是");
			} else {
				eIsCashFlow.setValue(0);
				eIsCashFlow.setRawValue("否");
				eCashFlowField.disable();
				eCashFlowField.setValue(0);
				eCashFlowField.setRawValue("");
			}

			//现金银行其他(现金银行标志)
			var eiscash = rowObj[0].get("IsCash");
		if (eiscash == "现金") {
			eIsCashField.setValue(1);
		} else if (eiscash == "银行") {
			eIsCashField.setValue(2);
		} else {
			eIsCashField.setValue(0); //现金银行标志其他

			eIsCashFlow.disable();
			eIsCashFlow.setValue(0); //是否现金流量科目
			eIsCashFlow.setRawValue("否"); //否
			eCashFlowField.disable(); //
			eCashFlowField.setValue(0); //现金流量项置空
			eCashFlowField.setRawValue("");

		}
		//计量单位
		eNumUnitField.setRawValue(rowObj[0].get("NumUnit"));
		//数量核算
		var eIsNum = rowObj[0].get("IsNum");
		if (eIsNum == "是") {
			eIsNumField.setValue(true);
			eNumUnitField.enable();
		} else {
			eIsNumField.setValue(false);
			eNumUnitField.disable();
		};
		//外币核算
		var eIsFc = rowObj[0].get("IsFc");
		if (eIsFc == "是") {
			eIsFcField.setValue(true);
		} else {
			eIsFcField.setValue(false);
		};
		//辅助核算
		var eIsCheck = rowObj[0].get("IsCheck");
		if (eIsCheck == "是") {
			eIsCheckField.setValue(true);
		} else {
			eIsCheckField.setValue(false);
		};
		//是否停用
		var eIsStop = rowObj[0].get("IsStop");
		if (eIsStop == "是") {
			eIsStopField.setValue(true);
		} else {
			eIsStopField.setValue(false);
		};

		//科目分组
		var esubjgroup = rowObj[0].get("subjGroup");
		if (esubjgroup == "医疗") {
			esubjGroup.setValue("01");
		} else if (esubjgroup == "药理") {
			esubjGroup.setValue("02");
		} else if (esubjgroup == "管理") {
			esubjGroup.setValue("02");
		} else {
			esubjGroup.setValue("09");
		}

		//现金流量项
		eCashFlowField.setValue(rowObj[0].get("CashFlowID"));
		eCashFlowField.setRawValue(rowObj[0].get("CashItemName"));

		eStartDateField.setValue(rowObj[0].get("StartYM"));
		eEndDateField.setValue(rowObj[0].get("EndYM"));

	});

	//***确定按钮***//
	addButton = new Ext.Toolbar.Button({
			text: '保存修改',
			iconCls:'save'
		});

	//////////////////////////  增加按钮响应函数   //////////////////////////////
	addHandler = function () {

		var esjcode = esjcodeField.getValue();
		var esjname = esjnameField.getValue();
		var esjnameAll = esjnameAllField.getValue();
		var espell = espellField.getValue();

		var edefinecode = edefinecodeField.getValue();
		var esupercode = esupercodeField.getValue();
		var esjlevel = esjlevelField.getValue();
		var esjtype = esjtypeField.getValue();
		if(esjtype==rowObj[0].get("SubjTypeName")){esjtype=""};
		var esjnature = esjnatureField.getValue();
		//alert(esjnature);
		if(esjnature==rowObj[0].get("SubjNatureName")){esjnature=""};
		var eIsLast = eIsLastField.getValue();
		var edirection = edirectionField.getValue();
		var eNumUnit = eNumUnitField.getValue();

		var eIsCash = eIsCashField.getValue();
		var eIsNum = (eIsNumField.getValue() == true) ? '1' : '0';
		var eIsFc = (eIsFcField.getValue() == true) ? '1' : '0';
		var eIsCheck = (eIsCheckField.getValue() == true) ? '1' : '0';
		var eIsStop = (eIsStopField.getValue() == true) ? '1' : '0';
		var esjGroup = esubjGroup.getValue();
		var eCashFlow = eCashFlowField.getValue();
		var eStartDate = eStartDateField.getValue();
		if (eStartDate !== "") {
			eStartDate = eStartDate.format('Y-m');
		}

		var eEndDate = eEndDateField.getValue();
		if (eEndDate !== "") {
			eEndDate = eEndDate.format('Y-m');
		}

		var eICFlow = eIsCashFlow.getValue();

		if ((esjname == "") || (esjcode == "")) {
			Ext.Msg.show({
				title: '错误',
				msg: '编码和名称不能为空',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
			return;
		};

		var len3 = 0;
		var flag = 1;
		Ext.Ajax.request({
			async: false,
			url: '../csp/herp.acct.acctsubjserverexe.csp?action=editLength&acctbookid=' +
			acctbookid + '&esjlevel=' + esjlevel,
			waitMsg: '保存中...',
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					len3 = jsonData.info;
					var len4 = esjcode.length;
					if (len4 != len3) {
						Ext.Msg.show({
							title: '错误',
							msg: '科目编码不规范! ',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.ERROR
						});
						flag = 2;
						return;
					} else {
						var edata = esjcode + "|" + esjname + "|" + edefinecode + "|" + esupercode + "|" +
							esjlevel + "|" + esjtype + "|" + esjnature + "|" +
							eIsLast + "|" + edirection + "|" + eIsCash + "|" + eIsNum + "|" + eNumUnit + "|" +
							eIsFc + "|" + eIsCheck + "|" + eIsStop + "|" +
							esjGroup + "|" + eCashFlow + "|" + eStartDate + "|" + eEndDate + "|" + eICFlow
							
						Ext.Ajax.request({
							url: '../csp/herp.acct.acctsubjserverexe.csp?action=updatesj&edata=' +
							encodeURIComponent(edata) + '&acctbookid=' + acctbookid + '&rowid=' + rowid,
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
									addwin.close(); //添加成功关闭窗口
									Ext.Msg.show({
										title: '注意',
										msg: '数据修改成功!',
										icon: Ext.MessageBox.INFO,
										buttons: Ext.Msg.OK
									});
									itemGridDs.load(({
											params: {
												start: 0,
												limit: 25
											}
										}));
									CheckitemGrid.load({
										params: {
											start: 0,
											limit: 25
										}
									});
									//保存成功后停留在当前页
									var tbarnum = itemGrid.getBottomToolbar();
									tbarnum.doLoad(tbarnum.cursor);
								} else {
									var message = "";
									if (jsonData.info == 'RepCode')
										message = '录入的编码已存在,请您核对后重新输入! ';
									if (jsonData.info == 'err1')
										message = '科目级别与科目编码规则不匹配! ';
									if (jsonData.info == 'err2')
										message = '未找到上级科目编码,请先录入上级科目! ';
									if (jsonData.info == 'NotExist')
										message = '请勿直接修改非同级编码！ ';
									if (jsonData.info == 'NotStop')
										message = '科目正在使用，不能停用！ ';
									Ext.Msg.show({
										title: '错误',
										msg: message,
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.ERROR
									});
									return;
								}
							},
							scope: this
						});
					}
				}
			}
		});

		//addwin.close();

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
			title: '修改科目',
			width: 800,
			height: 380,
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
