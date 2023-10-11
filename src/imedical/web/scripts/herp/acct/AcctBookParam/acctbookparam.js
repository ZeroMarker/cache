var acctbookid = IsExistAcctBook();
// window.location.reload();


//*******************数据库版本***********************//

	var dataVersion = new Ext.form.ComboBox({
		id:'dataVersion',
		fieldLabel: '数据库版本号',
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
		emptyText: '选择...',
		selectOnFocus: 'true'
	});
	
	
//*******************单位帐套***********************//
var acctBookField = new Ext.form.TextField({
	id:'acctBookField',
	fieldLabel: '单位帐套',
	emptyText: '',
	width: 255
})
//为文本框设置默认显示值
Ext.Ajax.request({
	url: 'herp.acct.acctbookparamexe.csp?action=acctbooklist&str=' + acctbookid,
	success: function (result, request) {
		var resultstr = result.responseText;
		//alert(resultstr);
		acctBookField.setValue(resultstr);
	},
	scope: this
});

//*****************科目编码规则*************************//
var ParamCode = new Ext.form.TextField({
		fieldLabel: '科目编码规则',
		width: 255,
		emptyText: '格式：4-2-2-2...',
		regex: /^[1-9](\-[1-9])+$/,
		regexText: '请严格按照提示格式输入！',
		allowBlank: false,
		blankText: '请输入科目编码规则！',
		msgTarget: 'title'
	});

//*******************账簿余额方向***********************//

var ParamValue = new Ext.form.ComboBox({
		fieldLabel: '账簿余额方向',
		width: 255,
		listWidth: 255,
		//anchor: '37%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', '与科目余额方向一致'], ['2', '根据余额正负调节']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		value: '1',
		editable: false,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '选择...',
		selectOnFocus: 'true'
	});

//*******************凭证修改控制***********************//

var Control = new Ext.form.ComboBox({
		fieldLabel: '凭证修改控制',
		width: 255,
		listWidth: 255,
		//anchor: '37%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['0', '不可修改他人凭证'], ['1', '可以修改他人凭证']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		value: '1',
		editable: false,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '选择...',
		selectOnFocus: 'true'
	});

//*********************凭证日期是否可修改********************//
var DateEdit = new Ext.form.ComboBox({
		fieldLabel: '凭证日期是否可修改',
		width: 255,
		listWidth: 255,
		store: new Ext.data.ArrayStore({
			fields: ['value', 'key'],
			data: [['0', '否'], ['1', '是']]
		}),
		displayField: 'key',
		valueField: 'value',
		mode: 'local',
		editable: false,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '请选择...',
		selectOnFocus: 'true'

	});
//*******************出纳签字可以修改支票有关信息***********************//

var EditCheck = new Ext.form.ComboBox({
		fieldLabel: '出纳签字可以修改支票有关信息',
		width: 255,
		listWidth: 255,
		//anchor: '37%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', '可以'], ['0', '不可以']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		value: '1',
		editable: false,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '选择...',
		selectOnFocus: 'true'
	});

/*******************是否从总账引入日记账***********************/

var IsLedgerToJournal = new Ext.form.ComboBox({
		fieldLabel: '是否从总账引入日记账',
		width: 255,
		listWidth: 255,
		//anchor: '37%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', '是'], ['0', '否']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		value: '1',
		editable: false,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '选择...',
		selectOnFocus: 'true'
	});

/*******************日记账是否逐条生成凭证***********************/

var IsJournalOBOToVouch = new Ext.form.ComboBox({
		fieldLabel: '日记账是否逐条生成凭证',
		width: 255,
		listWidth: 255,
		//anchor: '37%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', '是'], ['0', '否']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		value: '1',
		editable: false,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '选择...',
		selectOnFocus: 'true'
	});

/************凭证是否需要出纳复核************/
var IsVouchReCheck = new Ext.form.ComboBox({
		fieldLabel: "凭证是否需出纳复核",
		width: 255,
		listWidth: 255,
		mode: 'local',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'value'],
			data: [['1', '是'], ['0', '否']]
		}),
		displayField: 'value',
		valueField: 'rowid',
		value: 1,
		forceSelection: true,
		triggerAction: 'all',
		selectOnFocus: true,
		editable: false
	});

//*******************坏账提取方式***********************//

var ExtracteType = new Ext.form.ComboBox({
		fieldLabel: '坏账提取方式',
		width: 255,
		listWidth: 255,
		//anchor: '37%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', '余额百分比法'], ['2', '账龄分析法']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		// typeAhead : true,
		mode: 'local',
		// value : '1',
		editable: false,
		// forceSelection : true,
		triggerAction: 'all',
		emptyText: '选择...',
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
//*******************坏账提取百分比***********************//

var ExtractePer = new Ext.form.TextField({
		fieldLabel: '坏账提取百分比(%)',
		width: 255,
		emptyText: '100以内,只输入整数部分即可',
		regex: /^[0-9]{1,2}$/,
		regexText: '请输入100以内的整数！',
		msgTarget: 'title'
	});

/*******************是否集团化管理***********************/

var IsGroup = new Ext.form.ComboBox({
		fieldLabel: '是否集团化管理',
		width: 255,
		listWidth: 255,
		//anchor: '37%',
		store: new Ext.data.ArrayStore({
			fields: ['rowid', 'name'],
			data: [['1', '是'], ['0', '否']]
		}),
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		mode: 'local',
		value: '1',
		editable: false,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '选择...',
		selectOnFocus: 'true'
	});

Ext.Ajax.request({
	url: 'herp.acct.acctbookparamexe.csp?action=list&acctbookid=' + acctbookid,
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

		//页面加载完成后，根据账套计提方式判断坏账提取百分比是否可编辑
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
//基础信息
var saveButton = new Ext.Toolbar.Button({
		text: '保存',
		iconCls: 'save',
		handler: function () {
			/* var acctbookid = acctBookField.getValue();
			
			if (!acctbookid) {
				Ext.Msg.show({
					title: '注意',
					msg: '请先选择单位帐套',
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
//凭证管理
var saveButton1 = new Ext.Toolbar.Button({
		text: '保存',
		iconCls: 'save',
		handler: function () {
			/* var acctbookid = acctBookField.getValue();
			if (!acctbookid) {
				Ext.Msg.show({
					title: '注意',
					msg: '请先选择单位帐套',
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
		text: '保存',
		iconCls: 'save',
		handler: function () {
			/* var acctbookid = acctBookField.getValue();
			if (!acctbookid) {
				Ext.Msg.show({
					title: '注意',
					msg: '请先选择单位帐套',
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
//期末处理
var saveButton3 = new Ext.Toolbar.Button({
		text: '保存',
		iconCls: 'save',
		handler: function () {
			/* var acctbookid = acctBookField.getValue();
			if (!acctbookid) {
				Ext.Msg.show({
					title: '注意',
					msg: '请先选择单位帐套',
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
		//title:'基础信息设置',
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
		//title:'凭证管理设置',
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
		//title:'现金银行设置',
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
		//title:'期末处理设置',
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
	//判断需要验证的表单是否填写正确
	var formName = queryPanel.getForm().isValid(); //.findField();
	if (!formName) {
		Ext.Msg.show({
			title: '错误',
			msg: '请检查所有项是否正确！ ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.ERROR
		});
		return;
	} else {
		//alert(data)
		Ext.MessageBox.confirm('提示', '请确定是否保存?', function (btn) {
			if (btn == 'yes') {
				Ext.Ajax.request({
					url: url + '&data=' + data,
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
							Ext.MessageBox.alert('提示', '保存成功!');
						} else {
							var message = "SQLErr: " + jsonData.info;
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
		})
	}
}
