//ȡ��ǰ�û�ID
var UserId = session['LOGON.USERID']
var AcctBookID = IsExistAcctBook();

var InitBankFlag;

//ɾ����ť
var delButton = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: 'ɾ��',
		iconCls: 'remove',
		handler: function () {
			itemGrid.del();
		}
	});

//���Ӱ�ť
var addButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����', //��ͣ��ʾ
		iconCls: 'add',
		handler: function () {
			itemGrid.add();
		}

	});

//���水ť
var saveButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '�������',
		iconCls: 'save',
		handler: function () {
			//���ñ��溯��
			itemGrid.save();
		}
	});

//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
		iconCls: 'find',
		width: 55, //����ť��ͼ��
		handler: function () {
			//������Ӻ���

			var StartDate = StartDateField.getValue();
			if (StartDate != "") {
				StartDate = StartDate.format('Y-m-d');
			}
			var EndDate = EndDateField.getValue();
			if (EndDate != "") {
				EndDate = EndDate.format('Y-m-d')
			}
			var AcctSubjCode = AcctSubjNameField.getValue();

			itemGrid.load({
				params: {
					start: 0,
					limit: 25,
					AcctBookID: AcctBookID,
					StartDate: StartDate,
					EndDate: EndDate,
					AcctSubjCode: AcctSubjCode

				}
			});
		}
	});

//��ʼʱ��
var StartDateField = new Ext.form.DateField({
		id: 'StartDateField',
		fieldLabel: '��ʼʱ��',
		//format : 'Y-m-d',
		width: 120,
		triggerAction: 'all',
		emptyText: '��ѡ��ʼʱ��...',
		name: 'StartDateField',
		allowBlank: true,
		editable: true
	});

//����ʱ��
var EndDateField = new Ext.form.DateField({
		id: 'EndDateField',
		fieldLabel: '����ʱ��',
		//format : 'Y-m-d',
		width: 120,
		triggerAction: 'all',
		emptyText: '��ѡ�����ʱ��...',
		name: 'EndDateField',
		allowBlank: true,
		editable: true
	});

//���п�Ŀ
var GetSubjNameDS = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['rowid', 'name', 'idName'])

	});
GetSubjNameDS.on('beforeload', function (ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
			url: 'herp.acct.acctvouchcheckdetailexe.csp?action=GetAcctSubjName&AcctBookID=' + AcctBookID,
			method: 'POST'

		});
});
var AcctSubjNameField = new Ext.form.ComboBox({
		id: 'AcctSubjNameField',
		name: 'AcctSubjNameField',
		fieldLabel: '���п�Ŀ',
		store: GetSubjNameDS,
		displayField: 'idName',
		valueField: 'rowid',
		width: 220,
		listWidth: 220,
		start: 0,
		limit: 100,
		pageSize: 10,
		minChars: 1,
		triggerAction: 'all',
		lazyRender: true,
		//mode : 'local',
		emptyText: '��ѡ�����п�Ŀ...',
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true,
		listeners: {
			select: function () {
				var subjcode = AcctSubjNameField.getValue();
				Ext.Ajax.request({
					url: 'herp.acct.acctvouchcheckdetailexe.csp?action=GetEndSum&AcctBookID=' + AcctBookID + '&AcctSubjCode=' + subjcode,
					method: 'GET',
					success: function (result, request) {
						// var respText=result.responseText;
						var respText = new Ext.util.JSON.decode(result.responseText);
						var EndSum = respText.info;

						if (EndSum != "")
							EndSumField.setValue(EndSum);
						else
							EndSumField.setValue("");

					},
					failure: function (result, request) {
						Ext.Msg.show({
							title: '����',
							msg: '�������',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.ERROR
						});
					},
					scope: this
				});
			}
		}

	});

//���п�Ŀ�ֶα༭������
var AcctSubjName = new Ext.form.ComboBox({
		id: 'AcctSubjName',
		name: 'AcctSubjName',
		fieldLabel: '���п�Ŀ',
		store: GetSubjNameDS,
		displayField: 'name',
		valueField: 'rowid',
		width: 180,
		listWidth: 220,
		start: 0,
		limit: 100,
		pageSize: 10,
		minChars: 1,
		triggerAction: 'all',
		lazyRender: true,
		//mode : 'local',
		emptyText: '��ѡ�����п�Ŀ...',
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});


//���㷽ʽ������
var GetCheqTypeNameDS = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['rowid', 'name'])

	});
GetCheqTypeNameDS.on('beforeload', function (ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
			url: 'herp.acct.acctvouchcheckdetailexe.csp?action=GetCheqTypeName',
			method: 'POST'

		});
});
var CheqTypeNameField = new Ext.form.ComboBox({
		id: 'CheqTypeNameField',
		name: 'CheqTypeNameField',
		fieldLabel: '���㷽ʽ',
		store: GetCheqTypeNameDS,
		displayField: 'name',
		valueField: 'rowid',
		width: 180,
		listWidth: 220,
		//start:0,
		//limit:100,
		pageSize: 10,
		minChars: 1,
		triggerAction: 'all',
		lazyRender: true,
		//mode : 'local',
		emptyText: '',
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});


//�����������
var EndSumField = new Ext.form.DisplayField({ //ԭΪTextField
		id: 'EndSumField',
		name: 'EndSumField',
		style: 'text-align:left;font-size:12px;', //�ı�����뷽ʽ
		triggerAction: 'all',
		editable: false
	});

var queryPanel = new Ext.FormPanel({
		title: '����δ����ά��',
		iconCls: 'maintain',
		region: 'north',
		height: 73,
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px '
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '��ʼʱ��',
						style: 'padding:0 5px;'
						//width: 70
					}, StartDateField, {
						xtype: 'displayfield',
						value: '',
						style: 'line-height: 15px;',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '����ʱ��',
						style: 'padding:0 5px;'
						///width: 70
					}, EndDateField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '���п�Ŀ',
						style: 'padding:0 5px;'
						//width: 70
					}, AcctSubjNameField, {
						xtype: 'displayfield',
						value: '',
						width: 15
					},
					findButton, {
						xtype: 'displayfield',
						value: '',
						width: 15
					}, {
						xtype: 'displayfield',
						value: '��λ�����������:',
						style: 'padding:0 5px;'
						//width: 120
					}, EndSumField
				]
			}
		]

	});


var itemGrid = new dhc.herp.Grid({
		/// title: '����δ���ʲ�ѯ�б�',
		//iconCls:'list',
		width: 400,
		pageSize: 25,
		readerModel: 'remote',
		region: 'center',
		url: 'herp.acct.acctvouchcheckdetailexe.csp',
		atLoad: true, // �Ƿ��Զ�ˢ��
		//loadmask:true,
		tbar: [addButton, '-', saveButton, '-', delButton],
		fields: [{
				header: 'rowid',
				dataIndex: 'rowid',
				hidden: true
			}, {
				id: 'AcctSubjName',
				header: '<div style="text-align:center">���п�Ŀ</div>',
				width: 155,
				type: AcctSubjName,
				allowBlank: false,
				dataIndex: 'AcctSubjName'
			}, {
				id: 'OccurDate',
				header: '<div style="text-align:center">ҵ��ʱ��</div>',
				allowBlank: true,
				width: 90,
				align: 'center',
				type: "dateField", //ʱ��ؼ�����
				dataIndex: 'OccurDate'
			}, {
				id: 'CheqTypeName',
				header: '<div style="text-align:center">���㷽ʽ</div>',
				width: 100,
				allowBlank: false,
				align: 'center',
				type: CheqTypeNameField,
				dataIndex: 'CheqTypeName'
			}, {
				id: 'CheqNo',
				header: '<div style="text-align:center">Ʊ�ݺ�</div>',
				allowBlank: true,
				width: 170,
				dataIndex: 'CheqNo'
			}, {
				id: 'Summary',
				header: '<div style="text-align:center">ժҪ</div>',
				allowBlank: true,
				width: 300,
				type: 'textfield',
				dataIndex: 'Summary'
			}, {
				id: 'AmtDebit',
				header: '<div style="text-align:center">�跽���</div>',
				allowBlank: true,
				width: 160,
				align: 'right',
				type: 'numberField',
				dataIndex: 'AmtDebit'
			}, {
				id: 'AmtCredit',
				header: '<div style="text-align:center">�������</div>',
				allowBlank: true,
				width: 160,
				type: 'numberField',
				align: 'right',
				dataIndex: 'AmtCredit'
			}
		]
		
	});
//InitBankFlag==1ʱ����ɾ�İ�ť������
//--------�жϰ�ť��־
itemGrid.store.on('load', function () {
	Ext.Ajax.request({
		url: 'herp.acct.acctvouchcheckdetailexe.csp?action=GetInitBankFlag&AcctBookID=' + AcctBookID,
		method: 'GET',
		success: function (result, request) {
			var respText = Ext.decode(result.responseText);
			var str = respText.info;
			InitBankFlag = str;
			if (InitBankFlag == 1) {
				addButton.disable();
				saveButton.disable();
				delButton.disable();
			}
		}
	});
});

//��ť��־Ϊ1ʱ�����ɽ����б༭
itemGrid.on('beforeedit', function (editor, e) {
	if (InitBankFlag == 1) {
		return false;
	}
});

//AmtDebit\AmtCredit���л��⣬�޸�һ������һ����0
itemGrid.on('afterEdit', onEdit, this);
function onEdit(e) {
	if (e.field == "AmtDebit") {
		if (e.value != 0) {
			e.record.set("AmtCredit", 0);
		}
	} else if (e.field == "AmtCredit") {
		if (e.value != 0) {
			e.record.set("AmtDebit", 0);
		}
	}

};

//ȡEndSum��ֵ������EndSumField
/* Ext.Ajax.request({
url:itemGrid.url+'?action=GetEndSum'+'&AcctBookID='+AcctBookID+'&AcctSubjCode='+subjcode,
method:'GET',
success:function(result,request){
var respText=Ext.util.JSON.decode(result,respText);
var EndSum=respText.info;
EndSumField.setValue(EndSum);
},
failure:function(result,request){
return;
}
}); */

// itemGrid.addButton('-');
// itemGrid.addButton(delButton);
// itemGrid.btnAddHide()     //�������Ӱ�ť
// itemGrid.btnSaveHide()    //���ر��水ť
// itemGrid.btnDeleteHide()  //����ɾ����ť
//itemGrid.btnResetHide()     //�������ð�ť
//itemGrid.btnPrintHide()     //���ش�ӡ��ť
