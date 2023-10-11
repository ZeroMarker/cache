var userdr = session['LOGON.USERID']; //登录人ID
var projUrl = 'herp.acct.acctmanualdealcacelexe.csp';

//////////////////////定义起始时间控件

var startDateField = new Ext.form.DateField({
		id: 'startDateField',
		//fieldLabel: '起始日期',
		// columnWidth : .3,
		width: 110,
		allowBlank: true,
		//format:'Y-m-d',
		selectOnFocus: 'true'
	});

var endDateField = new Ext.form.DateField({
		id: 'endDateField',
		//fieldLabel: '起始日期',
		// columnWidth : .3,
		width: 110,
		allowBlank: true,
		//format:'Y-m-d',
		selectOnFocus: 'true'
	});

/////////////往来核销会计科目
var CheckSubjDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['rowid', 'SubjCode', 'SubjNameAll', 'SubjCodeNameAll'])
	});

CheckSubjDs.on('beforeload', function (ds, o) {

	ds.proxy = new Ext.data.HttpProxy({

			url: projUrl + '?action=GetCheckSubj&str=' + encodeURIComponent(Ext.getCmp('CheckSubjCombo').getRawValue()) + '&userdr=' + userdr,
			method: 'POST'
		});
});
var CheckSubjCombo = new Ext.form.ComboBox({
		id: 'CheckSubjCombo',
		fieldLabel: '会计科目',
		store: CheckSubjDs,
		displayField: 'SubjCodeNameAll',
		valueField: 'rowid',
		typeAhead: true,
		triggerAction: 'all',
		emptyText: '请选择会计科目',
		width: 200,
		listWidth: 220,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true',
		listeners: {
			"select": function (combo, record, index) {
				CheckItemDs.removeAll();
				CheckItemCombo.setValue('');
				CheckItemDs.proxy = new Ext.data.HttpProxy({
						url: projUrl + '?action=GetCheckItemName&str=' + encodeURIComponent(Ext.getCmp('CheckItemCombo').getRawValue()) + '&SubjId=' + combo.value + '&userdr=' + userdr,
						method: 'POST'
					})
					CheckItemDs.load({
						params: {
							start: 0,
							limit: 10
						}
					});
			}
		}
	});

/////////////////往来对象
var CheckItemDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['rowid', 'ItemName'])
	});

/* CheckItemDs.on('beforeload', function (ds, o) {

var SubjId = CheckSubjCombo.getValue();
if (!SubjId) {
Ext.Msg.show({
title: '注意',
msg: '请先选择会计科目',
buttons: Ext.Msg.OK,
icon: Ext.MessageBox.WARNING
});
return;
}
}); */

var CheckItemCombo = new Ext.form.ComboBox({
		id: 'CheckItemCombo',
		fieldLabel: '往来对象',
		store: CheckItemDs,
		displayField: 'ItemName',
		valueField: 'rowid',
		// typeAhead: true,
		triggerAction: 'all',
		emptyText: '请选择往来对象',
		width: 200,
		listWidth: 220,
		pageSize: 10,
		minChars: 1,
		//selectOnFocus:true,
		//forceSelection:'true',
		listeners: {
			focus: function () {

				var SubjId = CheckSubjCombo.getValue();
				if (!SubjId) {
					CheckItemDs.removeAll();
					CheckItemCombo.setValue();
					Ext.Msg.show({
						title: '注意',
						msg: '请先选择会计科目! ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.WARNING
					});
					return;
				}
			},
			"select": function (combo, record, index) {
				var CheckItemName = combo.getRawValue();
				var CheckItemId = combo.getValue();
				combo.setValue(CheckItemName.substr(12)); //用于往来对象的显示值，主要是为了去掉空格
				CheckItemCombo1.setValue(CheckItemId); //用于往来对象的传值，只能在setValue之前取,否则Value被更改为CheckItemName.substr(6)

			}
		}
	});

var CheckItemCombo1 = new Ext.form.ComboBox({ //往来对象传值取CheckItemCombo1
		id: 'CheckItemCombo',
		fieldLabel: '往来对象',
		store: CheckItemDs,
		displayField: 'ItemName',
		valueField: 'rowid',
		typeAhead: true,
		triggerAction: 'all',
		emptyText: '请选择往来对象',
		width: 120,
		listWidth: 220,
		pageSize: 10,
		minChars: 1
	});

var miniAmountField = new Ext.form.NumberField({
		id: 'miniAmountField',
		fieldLabel: '最小金额',
		// columnWidth : .155,
		width: 110,
		allowBlank: true,
		selectOnFocus: 'true'
	});

var maxAmountField = new Ext.form.NumberField({
		id: 'maxAmountField',
		fieldLabel: '最大金额',
		// columnWidth : .155,
		width: 110,
		allowBlank: true,
		selectOnFocus: 'true'
	});

/////////////////////
var ischecked = new Ext.form.RadioGroup({
		fieldLabel: '对账状态',
		width: 160,
		hideLabel: true,
		defaults: {
			style: "border:0;background:none;margin-top:0px;"
		},

		items: [{
				id: 'all',
				boxLabel: '全部',
				inputValue: '2',
				name: 'sevType'
			}, {
				id: 'checked',
				boxLabel: '已对',
				inputValue: '1',
				name: 'sevType'
			}, {
				id: 'unchecked',
				boxLabel: '未对',
				inputValue: '0',
				name: 'sevType',
				checked: true
			}
		]
	});

//////////查询按钮//////////////
function dosearch() {
	var startdate = startDateField.getValue();
	if (startdate !== "") {
		startdate = startdate.format('Y-m-d');
	}
	//alert(startdate);
	var enddate = endDateField.getValue();
	if (enddate !== "") {
		enddate = enddate.format('Y-m-d');
	}
	var checksubjId = CheckSubjCombo.getValue();
	var checkitemId = CheckItemCombo1.getValue();
	var CheckItem = CheckItemCombo.getRawValue();
	if (checksubjId == "") {
		Ext.Msg.show({
			title: '提示',
			msg: '请选择会计科目!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	} else if (CheckItem == "") {
		Ext.Msg.show({
			title: '提示',
			msg: '请选择往来对象!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	}

	var miniAmount = miniAmountField.getValue();
	var maxAmount = maxAmountField.getValue();
	var state = ischecked.getValue().inputValue;
	DebitGrid.load({
		params: {
			start: 0,
			limit: 25,
			startdate: startdate,
			enddate: enddate,
			checksubjId: checksubjId,
			checkitemId: checkitemId,
			miniAmount: miniAmount,
			maxAmount: maxAmount,
			state: state,
			userdr: userdr
		}
	});
	CreditGrid.load({
		params: {
			start: 0,
			limit: 25,
			startdate: startdate,
			enddate: enddate,
			checksubjId: checksubjId,
			checkitemId: checkitemId,
			miniAmount: miniAmount,
			maxAmount: maxAmount,
			state: state,
			userdr: userdr
		}

	});
}

var findButton = new Ext.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'find',
		width: 60,
		handler: function () {
			dosearch();
		}
	});

//////////手工对账按钮//////////////
var checkButton = new Ext.Button({
		id: 'checkbutton',
		text: '手工对账开启',
		tooltip: '手工对账开启',
		width: 100,
		locked: true,
		iconCls: 'startcheck',
		handler: function () {
			var self = this;
			check(self);

		}
	});

//////////手工对账验证保存按钮//////////////
var checkAndSaveButton = new Ext.Button({
		text: '手工对账验证保存',
		tooltip: '手工对账验证保存',
		width: 120,
		disabled: true,
		iconCls: 'save',
		handler: function () {
			var ItemName = CheckItemCombo.getRawValue();
			var SubjName = CheckSubjCombo.getRawValue();
			var checkitemId = CheckItemCombo1.getValue();
			save(ItemName, SubjName, checkitemId);
		}
	});
/*
//////////自动对账按钮//////////////
var autoCheckButton = new Ext.Button({
text: '自动对账',
tooltip: '自动对账',
iconCls: 'option',
handler: function(){

autoCheck();
}
});

 */
var queryPanel = new Ext.FormPanel({
	    title: '往来核销-手动核销',
		iconCls:'find',
		height: 140,
		region: 'north',
		frame: true,
		defaults: {
			bodyStyle: 'padding:3px'
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				width: 1200,
				//columnWidth : 1,
				items: [{
						xtype: 'displayfield',
						value: '会计科目',
						style: 'padding:0 5px;'
						//width: 70
					},
					CheckSubjCombo, {
						xtype: 'displayfield',
						value: '',
						width: 40
					}, {
						xtype: 'displayfield',
						value: '时间范围',
						style: 'padding:0 5px;'
						//width: 70
					},
					startDateField, {
						xtype: 'displayfield',
						value: '--',
						style: 'padding:0 5px;'
						//width : 10
					},
					endDateField, {
						xtype: 'displayfield',
						value: '',
						width: 40
					}, {
						xtype: 'displayfield',
						value: '对账状态',
						style: 'padding:0 5px;'
						//width: 70
					},
					ischecked]
			}, {
				xtype: 'panel',
				layout: "column",
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '往来对象',
						style: 'padding:0 5px;'
						//width: 70
					},
					CheckItemCombo, {
						xtype: 'displayfield',
						value: '',
						width: 40
					}, {
						xtype: 'displayfield',
						value: '金额范围',
						style: 'padding:0 5px;'
						//width: 70
					},
					miniAmountField, {
						xtype: 'displayfield',
						value: '--',
						style: 'padding:0 5px;'
					},
					maxAmountField, {
						xtype: 'displayfield',
						value: '',
						width: 40
					},
					findButton]
			}, {
				xtype: 'panel',
				layout: "column",
				//items: [checkButton,checkAndSaveButton]}
				items: [checkButton, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, checkAndSaveButton]
			}
		]
	});
