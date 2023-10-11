var userdr = session['LOGON.USERID']; //��¼��ID
var projUrl = 'herp.acct.acctmanualdealcacelexe.csp';

//////////////////////������ʼʱ��ؼ�

var startDateField = new Ext.form.DateField({
		id: 'startDateField',
		//fieldLabel: '��ʼ����',
		// columnWidth : .3,
		width: 110,
		allowBlank: true,
		//format:'Y-m-d',
		selectOnFocus: 'true'
	});

var endDateField = new Ext.form.DateField({
		id: 'endDateField',
		//fieldLabel: '��ʼ����',
		// columnWidth : .3,
		width: 110,
		allowBlank: true,
		//format:'Y-m-d',
		selectOnFocus: 'true'
	});

/////////////����������ƿ�Ŀ
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
		fieldLabel: '��ƿ�Ŀ',
		store: CheckSubjDs,
		displayField: 'SubjCodeNameAll',
		valueField: 'rowid',
		typeAhead: true,
		triggerAction: 'all',
		emptyText: '��ѡ���ƿ�Ŀ',
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

/////////////////��������
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
title: 'ע��',
msg: '����ѡ���ƿ�Ŀ',
buttons: Ext.Msg.OK,
icon: Ext.MessageBox.WARNING
});
return;
}
}); */

var CheckItemCombo = new Ext.form.ComboBox({
		id: 'CheckItemCombo',
		fieldLabel: '��������',
		store: CheckItemDs,
		displayField: 'ItemName',
		valueField: 'rowid',
		// typeAhead: true,
		triggerAction: 'all',
		emptyText: '��ѡ����������',
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
						title: 'ע��',
						msg: '����ѡ���ƿ�Ŀ! ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.WARNING
					});
					return;
				}
			},
			"select": function (combo, record, index) {
				var CheckItemName = combo.getRawValue();
				var CheckItemId = combo.getValue();
				combo.setValue(CheckItemName.substr(12)); //���������������ʾֵ����Ҫ��Ϊ��ȥ���ո�
				CheckItemCombo1.setValue(CheckItemId); //������������Ĵ�ֵ��ֻ����setValue֮ǰȡ,����Value������ΪCheckItemName.substr(6)

			}
		}
	});

var CheckItemCombo1 = new Ext.form.ComboBox({ //��������ֵȡCheckItemCombo1
		id: 'CheckItemCombo',
		fieldLabel: '��������',
		store: CheckItemDs,
		displayField: 'ItemName',
		valueField: 'rowid',
		typeAhead: true,
		triggerAction: 'all',
		emptyText: '��ѡ����������',
		width: 120,
		listWidth: 220,
		pageSize: 10,
		minChars: 1
	});

var miniAmountField = new Ext.form.NumberField({
		id: 'miniAmountField',
		fieldLabel: '��С���',
		// columnWidth : .155,
		width: 110,
		allowBlank: true,
		selectOnFocus: 'true'
	});

var maxAmountField = new Ext.form.NumberField({
		id: 'maxAmountField',
		fieldLabel: '�����',
		// columnWidth : .155,
		width: 110,
		allowBlank: true,
		selectOnFocus: 'true'
	});

/////////////////////
var ischecked = new Ext.form.RadioGroup({
		fieldLabel: '����״̬',
		width: 160,
		hideLabel: true,
		defaults: {
			style: "border:0;background:none;margin-top:0px;"
		},

		items: [{
				id: 'all',
				boxLabel: 'ȫ��',
				inputValue: '2',
				name: 'sevType'
			}, {
				id: 'checked',
				boxLabel: '�Ѷ�',
				inputValue: '1',
				name: 'sevType'
			}, {
				id: 'unchecked',
				boxLabel: 'δ��',
				inputValue: '0',
				name: 'sevType',
				checked: true
			}
		]
	});

//////////��ѯ��ť//////////////
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
			title: '��ʾ',
			msg: '��ѡ���ƿ�Ŀ!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	} else if (CheckItem == "") {
		Ext.Msg.show({
			title: '��ʾ',
			msg: '��ѡ����������!',
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
		text: '��ѯ',
		tooltip: '��ѯ',
		iconCls: 'find',
		width: 60,
		handler: function () {
			dosearch();
		}
	});

//////////�ֹ����˰�ť//////////////
var checkButton = new Ext.Button({
		id: 'checkbutton',
		text: '�ֹ����˿���',
		tooltip: '�ֹ����˿���',
		width: 100,
		locked: true,
		iconCls: 'startcheck',
		handler: function () {
			var self = this;
			check(self);

		}
	});

//////////�ֹ�������֤���水ť//////////////
var checkAndSaveButton = new Ext.Button({
		text: '�ֹ�������֤����',
		tooltip: '�ֹ�������֤����',
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
//////////�Զ����˰�ť//////////////
var autoCheckButton = new Ext.Button({
text: '�Զ�����',
tooltip: '�Զ�����',
iconCls: 'option',
handler: function(){

autoCheck();
}
});

 */
var queryPanel = new Ext.FormPanel({
	    title: '��������-�ֶ�����',
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
						value: '��ƿ�Ŀ',
						style: 'padding:0 5px;'
						//width: 70
					},
					CheckSubjCombo, {
						xtype: 'displayfield',
						value: '',
						width: 40
					}, {
						xtype: 'displayfield',
						value: 'ʱ�䷶Χ',
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
						value: '����״̬',
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
						value: '��������',
						style: 'padding:0 5px;'
						//width: 70
					},
					CheckItemCombo, {
						xtype: 'displayfield',
						value: '',
						width: 40
					}, {
						xtype: 'displayfield',
						value: '��Χ',
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
