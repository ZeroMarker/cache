base10AddFun = function() {

	var BonusTargetCodeField = new Ext.form.TextField({
				id : 'BonusTargetCodeField',
				name : 'BonusTargetCode',
				fieldLabel : '编码',
				allowBlank : false,
				emptyText : '必填',
				anchor : '100%'
			});

	var BonusTargetNameField = new Ext.form.TextField({
				id : 'BonusTargetNameField',
				name : 'BonusTargetName',
				fieldLabel : '名称',
				allowBlank : false,
				emptyText : '必填',
				anchor : '100%'
			});

	var TargetSpellField = new Ext.form.TextField({
				id : 'TargetSpellField',
				name : 'TargetSpell',
				fieldLabel : '拼音码',
				emptyText : '',
				anchor : '100%'
			});

	var CalculateDescField = new Ext.form.TextField({
				id : 'CalculateDescField',
				name : 'CalculateDesc',
				fieldLabel : '公式描述',
				emptyText : '',
				anchor : '100%'
			});

	var DataSourceSt = new Ext.data.ArrayStore({
				fields : ['rowid', 'name'],
				data : [['1', DataSourceValue[1]], ['2', DataSourceValue[2]],
						['3', DataSourceValue[3]], ['4', DataSourceValue[4]],['9', DataSourceValue[9]],['10', DataSourceValue[10]]
						,['11', DataSourceValue[11]],['12', DataSourceValue[12]],['13', DataSourceValue[13]],['14', DataSourceValue[14]]]
			});
//, ['8', DataSourceValue[8]]
	var DataSourceCombo = new Ext.form.ComboBox({
				fieldLabel : '数据来源',
				name : 'DataSource',
				store : DataSourceSt,
				displayField : 'name',
				allowBlank : false,
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '必选',
				selectOnFocus : true,
				anchor : '100%'
			});

	DataSourceCombo.on('select', function(combo, record, index) {
				// alert(combo.getValue());
				tmpV = combo.getValue();
				if (tmpV == 1) {
					bonusTargetCombo.setDisabled(true);
					formulaTrgg.hide();
					formu = '';
					formulaTrgg.setValue('');
				} else if (tmpV == 2) {
					bonusTargetCombo.setDisabled(true);
					formulaTrgg.show();
				} else if ((tmpV == 3) || (tmpV == 6) || (tmpV == 7)
						|| (tmpV == 8)) {
					bonusTargetCombo.setDisabled(false);
					formulaTrgg.hide();
					formu = '';
					formulaTrgg.setValue('');
				} else if (tmpV == 4) {
					bonusTargetCombo.setDisabled(true);
					formulaTrgg.hide();
					formu = '';
					formulaTrgg.setValue('');
				}

			});

	var TargetPropertySt = new Ext.data.ArrayStore({
				fields : ['rowid', 'name'],
				data : [['1', TargetPropertyValue[1]],
						['2', TargetPropertyValue[2]]]
			});

	var TargetPropertyCombo = new Ext.form.ComboBox({
				fieldLabel : '指标属性',
				name : 'TargetProperty',
				store : TargetPropertySt,
				displayField : 'name',
				allowBlank : false,
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '必填',
				selectOnFocus : true,
				anchor : '100%'
			});

	var targetTypeCombo = new Ext.form.ComboBox({
				id : 'targetTypeCombo',
				name : 'TargetTypeName',
				fieldLabel : '指标类别',
				anchor : '100%',
				// listWidth : 260,
				allowBlank : false,
				store : targetTypeComboDs,
				valueField : 'rowid',
				displayField : 'TargetTypeName',
				triggerAction : 'all',
				emptyText : '必选',
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});

	var calUnitCombo = new Ext.form.ComboBox({
				id : 'calUnitCombo',
				name : 'CalUnitName',
				fieldLabel : '计量单位',
				anchor : '100%',
				// listWidth : 260,
				allowBlank : false,
				store : calUnitDs,
				valueField : 'rowid',
				displayField : 'CalUnitName',
				triggerAction : 'all',
				emptyText : '必选',
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});

	var bonusTargetCombo = new Ext.form.ComboBox({
		id : 'bonusTargetCombo',
		name : 'ParameterTargetName',
		fieldLabel : '参数指标',
		anchor : '100%',
		// listWidth : 260,
		// allowBlank: false,
		store : bonusTargetDs,
		valueField : 'rowid',
		displayField : 'TargetNameType',
		triggerAction : 'all',
		disabled : true,
		emptyText : '',
		pageSize : 10,
		minChars : 1,
		selectOnFocus : true
			// ,
			// forceSelection: true
		});

	var calFlagStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue'],
				data : [["", '无级别'], [1, '人员级别'], [2, '科室级别']]
			});
	var calFlagField = new Ext.form.ComboBox({
				id : 'calFlagField',
				fieldLabel : '数据级别',
				// listWidth : 130,
				selectOnFocus : true,
				allowBlank : true,
				store : calFlagStore,
				anchor : '100%',
				value : "", // 默认值
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : '选择数据级别...',
				mode : 'local', // 本地模式
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});

	var formulaTrgg = new Ext.form.TriggerField({
				fieldLabel : '公式设置',
				// disabled:true,
				editable : false,
				hidden : true,
				emptyText : '公式设置',
				anchor : '100%'
			});

	formulaTrgg.onTriggerClick = function() {
		formula(1, this);

	};

	var TargetDsecArea = new Ext.form.TextArea({
				id : 'TargetDsecArea',
				name : 'TargetDsec',
				fieldLabel : '描述',
				emptyText : '',
				anchor : '100%'
			});

	var InitValueField = new Ext.form.NumberField({
				id : 'InitValueField',
				name : 'InitValue',
				decimalPrecision :6,
				fieldLabel : '默认值',
				emptyText : '',
				anchor : '100%'
			});
	
	var MaxValueField = new Ext.form.NumberField({
		id : 'MaxValueField',
		name : 'MaxValue',
		decimalPrecision :6,
		fieldLabel : '最大值',
		emptyText : '',
		anchor : '100%'
	});

	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 70,
				items : [BonusTargetCodeField, BonusTargetNameField,
						TargetSpellField, targetTypeCombo,
						calUnitCombo,
						DataSourceCombo,
						formulaTrgg,
						// 公式
						// CalculateDescField,
						// TargetPropertyCombo = 2
						bonusTargetCombo, calFlagField,
						InitValueField,MaxValueField, TargetDsecArea]
			});

	var addWin = new Ext.Window({
		title : '添加',
		width : 300,
		height : 430,
		layout : 'fit',
		plain : true,
		modal : true,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		items : formPanel,
		buttons : [{
			text : '保存',
			handler : function() {
				if (formPanel.form.isValid()) {
					if ((DataSourceCombo.getValue() == 2)
							&& (formulaTrgg.getValue() == '')) {
						Ext.Msg.show({
									title : '注意',
									msg : '公式不能为空!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.WARNING
								});
						return;
					}
					var tmpCreatePerson = session['LOGON.USERCODE'];
					var dt = new Date();
					dt = dt.format('Y-m-d');

					var tmpData = BonusTargetCodeField.getValue().trim() + "|"
							+ BonusTargetNameField.getValue().trim() + "|"
							+ calUnitCombo.getValue() + "|"
							+ targetTypeCombo.getValue() + "|"
							+ TargetSpellField.getValue().trim();
					tmpData = tmpData
							+ "|"
							+ DataSourceCombo.getValue()
							+ "|"
							+ TargetDsecArea.getValue()
							+ "|"
							+ encodeURIComponent(formu)
							+ "|"
							+ decodeURI(encodeURIComponent(formulaTrgg
									.getValue())) + "|1|1|1|"
							+ bonusTargetCombo.getValue() + "|1|0||" + dt + "|"
							+ calFlagField.getValue() + "|"
							+ InitValueField.getValue()+ "|"
							+ MaxValueField.getValue();
					// alert(tmpData);
					Ext.Ajax.request({
						url : base10Url + '?action=base10add&data=' + tmpData,
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
								Ext.Msg.show({
											title : '注意',
											msg : '操作成功!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
								base10Ds.load({
											params : {
												start : 0,
												limit : base10PagingToolbar.pageSize
											}
										});
							} else {
								var tmpmsg = '';
								if (jsonData.info == '1') {
									tmpmsg = '编码重复!';
								}
								if (jsonData.info == '2') {
									tmpmsg = '名称重复!';
								}
								Ext.Msg.show({
											title : '错误',
											msg : tmpmsg,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
						},
						scope : this
					});
				} else {
					var tmpWrongName = checkAdd(formPanel);
					Ext.Msg.show({
								title : '错误',
								msg : tmpWrongName + '不能为空!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				}
			}
		}, {
			text : '取消',
			handler : function() {
				addWin.close();
			}
		}]

	});

	addWin.show();

};
