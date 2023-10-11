var acctbookid = IsExistAcctBook();
// window.location.reload();


//*******************���ݿ�汾***********************//

	var dataVersion = new Ext.form.ComboBox({
		id:'dataVersion',
		fieldLabel: '���ݿ�汾��',
		width: 255,
		listWidth: 255,
		//anchor: '37%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', 'V8.0.0'], ['2', 'V8.1.0']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		value: '1',
		editable: false,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: 'ѡ��...',
		selectOnFocus: 'true'
	});
	
	
//*******************��λ����***********************//
var acctBookField = new Ext.form.TextField({
	id:'acctBookField',
	fieldLabel: '��λ����',
	emptyText: '',
	width: 255
})
//Ϊ�ı�������Ĭ����ʾֵ
Ext.Ajax.request({
	url: 'herp.acct.acctbookparamexe.csp?action=acctbooklist&str=' + acctbookid,
	success: function (result, request) {
		var resultstr = result.responseText;
		//alert(resultstr);
		acctBookField.setValue(resultstr);
	},
	scope: this
});

//*****************��Ŀ�������*************************//
var ParamCode = new Ext.form.TextField({
		fieldLabel: '��Ŀ�������',
		width: 255,
		emptyText: '��ʽ��4-2-2-2...',
		regex: /^[1-9](\-[1-9])+$/,
		regexText: '���ϸ�����ʾ��ʽ���룡',
		allowBlank: false,
		blankText: '�������Ŀ�������',
		msgTarget: 'title'
	});

//*******************�˲�����***********************//

var ParamValue = new Ext.form.ComboBox({
		fieldLabel: '�˲�����',
		width: 255,
		listWidth: 255,
		//anchor: '37%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', '���Ŀ����һ��'], ['2', '���������������']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		value: '1',
		editable: false,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: 'ѡ��...',
		selectOnFocus: 'true'
	});

//*******************ƾ֤�޸Ŀ���***********************//

var Control = new Ext.form.ComboBox({
		fieldLabel: 'ƾ֤�޸Ŀ���',
		width: 255,
		listWidth: 255,
		//anchor: '37%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['0', '�����޸�����ƾ֤'], ['1', '�����޸�����ƾ֤']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		value: '1',
		editable: false,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: 'ѡ��...',
		selectOnFocus: 'true'
	});

//*********************ƾ֤�����Ƿ���޸�********************//
var DateEdit = new Ext.form.ComboBox({
		fieldLabel: 'ƾ֤�����Ƿ���޸�',
		width: 255,
		listWidth: 255,
		store: new Ext.data.ArrayStore({
			fields: ['value', 'key'],
			data: [['0', '��'], ['1', '��']]
		}),
		displayField: 'key',
		valueField: 'value',
		mode: 'local',
		editable: false,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '��ѡ��...',
		selectOnFocus: 'true'

	});
//*******************����ǩ�ֿ����޸�֧Ʊ�й���Ϣ***********************//

var EditCheck = new Ext.form.ComboBox({
		fieldLabel: '����ǩ�ֿ����޸�֧Ʊ�й���Ϣ',
		width: 255,
		listWidth: 255,
		//anchor: '37%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', '����'], ['0', '������']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		value: '1',
		editable: false,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: 'ѡ��...',
		selectOnFocus: 'true'
	});

/*******************�Ƿ�����������ռ���***********************/

var IsLedgerToJournal = new Ext.form.ComboBox({
		fieldLabel: '�Ƿ�����������ռ���',
		width: 255,
		listWidth: 255,
		//anchor: '37%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', '��'], ['0', '��']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		value: '1',
		editable: false,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: 'ѡ��...',
		selectOnFocus: 'true'
	});

/*******************�ռ����Ƿ���������ƾ֤***********************/

var IsJournalOBOToVouch = new Ext.form.ComboBox({
		fieldLabel: '�ռ����Ƿ���������ƾ֤',
		width: 255,
		listWidth: 255,
		//anchor: '37%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', '��'], ['0', '��']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		value: '1',
		editable: false,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: 'ѡ��...',
		selectOnFocus: 'true'
	});

/************ƾ֤�Ƿ���Ҫ���ɸ���************/
var IsVouchReCheck = new Ext.form.ComboBox({
		fieldLabel: "ƾ֤�Ƿ�����ɸ���",
		width: 255,
		listWidth: 255,
		mode: 'local',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'value'],
			data: [['1', '��'], ['0', '��']]
		}),
		displayField: 'value',
		valueField: 'rowid',
		value: 1,
		forceSelection: true,
		triggerAction: 'all',
		selectOnFocus: true,
		editable: false
	});

//*******************������ȡ��ʽ***********************//

var ExtracteType = new Ext.form.ComboBox({
		fieldLabel: '������ȡ��ʽ',
		width: 255,
		listWidth: 255,
		//anchor: '37%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', '���ٷֱȷ�'], ['2', '���������']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		// typeAhead : true,
		mode: 'local',
		// value : '1',
		editable: false,
		// forceSelection : true,
		triggerAction: 'all',
		emptyText: 'ѡ��...',
		selectOnFocus: 'true',
		listeners: {
			select: function () {
				if (ExtracteType.getValue() == 1) {
					ExtractePer.enable();
					ExtractePer.allowBlank = false;
				} else {
					ExtractePer.setValue();
					ExtractePer.disable();
				}

			}

		}
	});
//*******************������ȡ�ٷֱ�***********************//

var ExtractePer = new Ext.form.TextField({
		fieldLabel: '������ȡ�ٷֱ�(%)',
		width: 255,
		emptyText: '100����,ֻ�����������ּ���',
		regex: /^[0-9]{1,2}$/,
		regexText: '������100���ڵ�������',
		msgTarget: 'title'
	});

/*******************�Ƿ��Ż�����***********************/

var IsGroup = new Ext.form.ComboBox({
		fieldLabel: '�Ƿ��Ż�����',
		width: 255,
		listWidth: 255,
		//anchor: '37%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', '��'], ['0', '��']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		value: '1',
		editable: false,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: 'ѡ��...',
		selectOnFocus: 'true'
	});

Ext.Ajax.request({
	url: 'herp.acct.acctbookparamexe.csp?action=list&acctbookid=' + acctbookid,
	waitMsg: '������...',
	failure: function (result, request) {
		Ext.Msg.show({
			title: '����',
			msg: '������������!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.ERROR
		});
	},
	success: function (result, request) {
		var resultstr = result.responseText;
		var strs = new Array();
		strs = resultstr.split("|");
       
		/* ParamCode.setValue(strs[1].split("^")[2]);
		ParamValue.setValue(strs[2].split("^")[2]);
		Control.setValue(strs[3].split("^")[2]);
		EditCheck.setValue(strs[4].split("^")[2]);
		IsLedgerToJournal.setValue(strs[5].split("^")[2]);
		IsVouchReCheck.setValue(strs[6].split("^")[2]);
		ExtracteType.setValue(strs[7].split("^")[2]);

		//ҳ�������ɺ󣬸������׼��᷽ʽ�жϻ�����ȡ�ٷֱ��Ƿ�ɱ༭
		if(strs[7].split("^")[2]==1){
		ExtractePer.enable();
		ExtractePer.setValue(strs[8].split("^")[2] * 100);
		} else {
		ExtractePer.disable();
		ExtractePer.setValue()
		}
		DateEdit.setValue(strs[9].split("^")[2]);
		IsGroup.setValue(strs[10].split("^")[2]); */

		for (var i = 0; i < strs.length; i++) {
			if (strs[i].split("^")[0] == '100')
				dataVersion.setValue(strs[i].split("^")[2]);
			if (strs[i].split("^")[0] == '101')
				ParamCode.setValue(strs[i].split("^")[2]);
			if (strs[i].split("^")[0] == '102')
				ParamValue.setValue(strs[i].split("^")[2]);
			if (strs[i].split("^")[0] == '103')
				Control.setValue(strs[i].split("^")[2]);
			if (strs[i].split("^")[0] == '104')
				EditCheck.setValue(strs[i].split("^")[2]);
			if (strs[i].split("^")[0] == '105')
				IsLedgerToJournal.setValue(strs[i].split("^")[2]);
			if (strs[i].split("^")[0] == '106')
				IsVouchReCheck.setValue(strs[i].split("^")[2]);
			if (strs[i].split("^")[0] == '107')
				IsJournalOBOToVouch.setValue(strs[i].split("^")[2]);
			if (strs[i].split("^")[0] == '401')
				ExtracteType.setValue(strs[i].split("^")[2]);
			if (strs[i].split("^")[0] == '402') {
				if (ExtracteType.getValue() == 1) {
					// alert(ExtracteType.getValue()+" "+strs[i].split("^")[2])
					ExtractePer.enable();
					var extracte_per=Math.round(strs[i].split("^")[2] * 100);
					ExtractePer.setValue(extracte_per);
				} else {
					ExtractePer.disable();
					ExtractePer.setValue()
				}
			}
			if (strs[i].split("^")[0] == '801')
				DateEdit.setValue(strs[i].split("^")[2]);
			if (strs[i].split("^")[0] == '901')
				IsGroup.setValue(strs[i].split("^")[2]);
		}
	},
	scope: this
});
//������Ϣ
var saveButton = new Ext.Toolbar.Button({
		text: '����',
		iconCls: 'save',
		handler: function () {
			/* var acctbookid = acctBookField.getValue();
			
			if (!acctbookid) {
				Ext.Msg.show({
					title: 'ע��',
					msg: '����ѡ��λ����',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			}
			
			var acctbookid = acctBookField.getValue(); */
			var dataversion = dataVersion.getValue();
			var paramcode = ParamCode.getValue();
			var paramvalue = ParamValue.getValue();
			var isgroup = IsGroup.getValue();
			var data = acctbookid + "^" + paramcode + "^" + paramvalue + "^" + isgroup +"^"+ dataversion
			
			
			var saveurl = "herp.acct.acctbookparamexe.csp?action=save"
			SaveData(data, saveurl, queryPanel);
		}
	});
//ƾ֤����
var saveButton1 = new Ext.Toolbar.Button({
		text: '����',
		iconCls: 'save',
		handler: function () {
			/* var acctbookid = acctBookField.getValue();
			if (!acctbookid) {
				Ext.Msg.show({
					title: 'ע��',
					msg: '����ѡ��λ����',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			}
			var acctbookid = acctBookField.getValue(); */
			var control = Control.getValue();
			var dateedit = DateEdit.getValue();
			var editCheck = EditCheck.getValue();
			var isvouchrecheck = IsVouchReCheck.getValue();
			var data = acctbookid + "^" + control + "^" + editCheck + "^" + dateedit + "^" + isvouchrecheck
				var saveurl = "herp.acct.acctbookparamexe.csp?action=save1"
				SaveData(data, saveurl, queryPanel1);
		}
	});
var saveButton2 = new Ext.Toolbar.Button({
		text: '����',
		iconCls: 'save',
		handler: function () {
			/* var acctbookid = acctBookField.getValue();
			if (!acctbookid) {
				Ext.Msg.show({
					title: 'ע��',
					msg: '����ѡ��λ����',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			}
			var acctbookid = acctBookField.getValue(); */
			var isledgertojournal = IsLedgerToJournal.getValue();
			var isjournalobotovouch = IsJournalOBOToVouch.getValue();
			var data = acctbookid + "^" + isledgertojournal + "^" + isjournalobotovouch
			var saveurl = "herp.acct.acctbookparamexe.csp?action=save2"
			SaveData(data, saveurl, queryPanel2);
		}
	});
//��ĩ����
var saveButton3 = new Ext.Toolbar.Button({
		text: '����',
		iconCls: 'save',
		handler: function () {
			/* var acctbookid = acctBookField.getValue();
			if (!acctbookid) {
				Ext.Msg.show({
					title: 'ע��',
					msg: '����ѡ��λ����',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			} */
			//var acctbookid = acctBookField.getValue();
			var extractetype = ExtracteType.getValue();
			var extractePer = ExtractePer.getValue();
			var data = acctbookid + "^" + extractetype + "^" + extractePer
			//alert(data);
			var saveurl = "herp.acct.acctbookparamexe.csp?action=save3"
			SaveData(data, saveurl, queryPanel3);
		}
	});
var queryPanel = new Ext.form.FormPanel({
		//title:'������Ϣ����',
		height: 50,
		width: 400,
		region: 'center',
		frame: true,
		labelWidth: 100,
		labelAlign:'right',
		labelSeparator: " ",
		// autoHeight:true,
		defaults: {
			bodyStyle: 'padding:5px'
		},
		items: [
			dataVersion,acctBookField, ParamCode, ParamValue, IsGroup
		]
	});
var queryPanel1 = new Ext.form.FormPanel({
		//title:'ƾ֤��������',
		height: 50,
		width: 400,
		region: 'center',
		frame: true,
		labelWidth: 200,
		labelAlign:'right',
		labelSeparator: " ",
		// autoHeight:true,
		
		defaults: {
			
			bodyStyle: 'padding:5px'
		},
		items: [
		    
			Control, DateEdit, EditCheck, IsVouchReCheck
		]
	});
var queryPanel2 = new Ext.form.FormPanel({
		//title:'�ֽ���������',
		height: 50,
		width: 400,
		region: 'center',
		frame: true,
		labelWidth: 160,
	    labelAlign:'right',
		labelSeparator: " ",
		// autoHeight:true,
		defaults: {
			bodyStyle: 'padding:5px'
		},
		items: [
			IsLedgerToJournal, IsJournalOBOToVouch
		]
	});
var queryPanel3 = new Ext.form.FormPanel({
		//title:'��ĩ��������',
		height: 50,
		width: 400,
		region: 'center',
		frame: true,
		labelWidth: 130,
		labelAlign:'right',
		labelSeparator: " ",
		// autoHeight:true,
		defaults: {
			bodyStyle: 'padding:5px'
		},
		items: [
			ExtracteType, ExtractePer
		]
	});

function SaveData(data, url, queryPanel) {
	//�ж���Ҫ��֤�ı��Ƿ���д��ȷ
	var formName = queryPanel.getForm().isValid(); //.findField();
	if (!formName) {
		Ext.Msg.show({
			title: '����',
			msg: '�����������Ƿ���ȷ�� ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.ERROR
		});
		return;
	} else {
		//alert(data)
		Ext.MessageBox.confirm('��ʾ', '��ȷ���Ƿ񱣴�?', function (btn) {
			if (btn == 'yes') {
				Ext.Ajax.request({
					url: url + '&data=' + data,
					waitMsg: '������...',
					failure: function (result, request) {
						Ext.Msg.show({
							title: '����',
							msg: '������������!',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.ERROR
						});
					},
					success: function (result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Ext.MessageBox.alert('��ʾ', '����ɹ�!');
						} else {
							var message = "SQLErr: " + jsonData.info;
							Ext.Msg.show({
								title: '����',
								msg: message,
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR
							});
						}
					},
					scope: this
				});
			}
		})
	}
}
