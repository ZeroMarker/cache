var userdr = session['LOGON.USERID']; //��¼��ID
//var acctbookid=GetAcctBookID();
var acctbookid = IsExistAcctBook();
//��õ�ǰϵͳ��¼�û�����Ϣ˵��
var userID = session['LOGON.USERID'];
var userCode = session['LOGON.USERCODE'];
var userName = session['LOGON.USERNAME'];
var projUrl = 'herp.acct.acctvouchoplogexe.csp';

//================��ѯ��������start================//
//����ڼ�
var YearMonth = new Ext.form.DateField({
		id: 'YearMonth',
		fieldLabel: '����ڼ�',
		format: 'Y-m',
		width: 100,
		//value:new Date(),
		emptyText: '',
		plugins: 'monthPickerPlugin'
	});
//ƾ֤����ʼֵ
var VouchNoFrom = new Ext.form.TextField({
		fieldLabel: 'ƾ֤�ŷ�Χ',
		allowBlank: true,
		align: 'right',
		width: 100
	});
//ƾ֤�Ž���ֵ***//
var VouchNoTo = new Ext.form.TextField({
		fieldLabel: '-',
		allowBlank: true,
		align: 'right',
		width: 100
	});
//������
var OpeatorDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['AcctBookID', 'AcctUserID', 'AcctUserName'])
	});

OpeatorDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=getopeator&BookID=' + acctbookid,
			method: 'POST'
		});
});
var OpeartorCombo = new Ext.form.ComboBox({
		id: 'OpeartorCombo',
		fieldLabel: '������',
		store: OpeatorDs,
		valueField: 'AcctUserID',
		displayField: 'AcctUserName',
		//typeAhead: true,
		triggerAction: 'all',
		emptyText: '������',
		width: 140,
		listWidth: 255,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true'
	});

//��������
var TaskDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['OpAct']) //,'OpResult','OpactRes'
	});

TaskDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=getTask',
			method: 'POST'
		});
});
var TaskCombo = new Ext.form.ComboBox({
		id: 'TaskCombo',
		fieldLabel: '��������',
		store: TaskDs,
		valueField: 'OpAct',
		displayField: 'OpAct',
		//typeAhead: true,
		triggerAction: 'all',
		emptyText: '��������',
		width: 150,
		listWidth: 255,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true'
	});

//================��ѯ��������end==================//

//**�����ѯ��ť**//
var QueryButton = new Ext.Toolbar.Button({
		text: '��ѯ	',
		tooltips: '��ѯ����',
		width: 55,
		iconCls: 'find',
		handler: function () {
			dosearch();
		}
	});

//***��ѯ����***//
function dosearch() {
	var yearmonth = YearMonth.getValue();
	if (yearmonth !== "") {
		yearmonth = yearmonth.format('Y-m');
	}
	var vouchnofr = VouchNoFrom.getValue();
	var vouchnoto = VouchNoTo.getValue();
	var opeatorid = OpeartorCombo.getValue();
	var task = TaskCombo.getRawValue();
	// var params=yearmonth+"^"+vouchnofr+"^"+vouchnoto;
	// alert(params);
	itemGrid.load({
		params: {
			sortField: '',
			sortDir: '',
			start: '',
			limit: 50,
			YearMonth: yearmonth, //����ڼ�
			VouchNoFr: vouchnofr, //ƾ֤��ʼֵ
			VouchNoTo: vouchnoto, //ƾ֤����ֵ
			BookID: acctbookid, //����id
			OpeatorID: opeatorid,
			Task: task,
			userdr: userdr
		}
	});
};

/*

//��ѯ���--��ѯ����
var queryPanel=new Ext.FormPanel({
region:'north',
frame:true,
defaults : {bodyStyle : 'padding:2px 0'},
items:[{
columnWidth:1,
xtype:'panel',
layout:'column',
items:[{
xtype:'displayfield',
value:'����ڼ�:',
style:'line-height: 20px;',
width:55
},YearMonth,{
xtype:'displayfield',
value:'',
width:20
},{
xtype:'displayfield',
value:'ƾ֤���:',
style:'line-height: 20px;',
width:55
},VouchNoFrom,{
xtype:'displayfield',
value:'ƾ֤���:',
style:'line-height: 20px;',
width:55
},VouchNoTo,
QueryButton
]
}]
});

 */
// tbar: ['����ڼ�:', YearMonth, '-', 'ƾ֤�ŷ�Χ:', VouchNoFrom,'--', VouchNoTo, '-', '������:', OpeartorCombo, '-','��������:', TaskCombo, '-', QueryButton],

var queryPanel = new Ext.FormPanel({
		region: 'north',
		height: 45,
		frame: true,
		defaults: {
			labelAlign: 'right', //��ǩ���뷽ʽ
			labelSeparator: ' ', //�ָ���
			border: false,
			bodyStyle: 'marginRight:-10px;'
		},
		// width: 1200,
		layout: 'hbox',
		items: [{
				labelWidth: 60,
				xtype: 'fieldset',
				width: 190,
				items: YearMonth
			}, {
				xtype: 'fieldset',
				labelWidth: 90,
				width: 220,
				items: VouchNoFrom
			}, {
				xtype: 'fieldset',
				labelWidth: 5,
				style:'marginLeft:-15px ;',
				width: 140,
				items: VouchNoTo
			}, {
				xtype: 'fieldset',
				labelWidth: 60,
				width: 240,
				items: OpeartorCombo
			}, {
				xtype: 'fieldset',
				labelWidth: 60,
				width: 240,
				items: TaskCombo
			}, {
				xtype: 'fieldset',
				labelWidth: 20,
				// style:'paddingBottom: 3px ;',
				width: 80,
				items: QueryButton
			}
		]

	});

// var json=AcctVouchOpLogID^AcctVouchID^VouchNo^OperatorID^Operator^OpDateTime^OpAct^OpResult^OpDesc
var itemGrid = new dhc.herp.Grid({
		title:'ƾ֤�����¼�б�',
		iconCls:'list',
		region: 'center',
		//width:400,
		edit: false,
		url: 'herp.acct.acctvouchoplogexe.csp',
		//viewConfig : {forceFit : true},
		fields: [{
				id: 'AcctVouchOpLogID',
				header: '<div style="text-align:center">VouchOpLogID</div>',
				allowBlank: false,
				width: 100,
				align: 'center',
				editable: false,
				hidden: true,
				sortable: true,
				dataIndex: 'AcctVouchOpLogID'
			}, {
				id: 'AcctVouchID',
				header: '<div style="text-align:center">ƾ֤ID</div>',
				allowBlank: false,
				width: 100,
				align: 'center',
				editable: false,
				hidden: true,
				dataIndex: 'AcctVouchID'
			}, {
				id: 'VouchNo',
				header: '<div style="text-align:center">ƾ֤��</div>',
				allowBlank: false,
				width: 120,
				align: 'left',
				editable: false,
				renderer: function (value, cellmeta, records, rowIndex, columnIndex, store) {
					return '<span style="color:blue;TEXT-DECORATION:underline">' + value + '</span>';
				},
				dataIndex: 'VouchNo'
			}, {
				id: 'VouchState',
				header: '<div style="text-align:center">ƾ֤״̬</div>',
				width: 100,
				editable: false,
				align: 'center',
				hidden: true,
				dataIndex: 'VouchState'
			}, {
				id: 'OperatorID',
				header: '<div style="text-align:center">������ID</div>',
				width: 100,
				editable: false,
				align: 'center',
				hidden: true,
				dataIndex: 'OperatorID'
			}, {
				id: 'Operator',
				header: '<div style="text-align:center">������</div>',
				allowBlank: false,
				editable: false,
				align: 'center',
				width: 140,
				update: true,
				dataIndex: 'Operator'
			}, {
				id: 'OpDateTime',
				header: '<div style="text-align:center">����ʱ��</div>',
				align: 'center',
				width: 180,
				editable: false,
				dataIndex: 'OpDateTime'

			}, {
				id: 'OpAct',
				header: '<div style="text-align:center">��������</div>',
				width: 140,
				align: 'center',
				editable: false,
				hidden: false,
				dataIndex: 'OpAct'
			}, {
				id: 'OpResult',
				header: '<div style="text-align:center">������</div>',
				width: 140,
				align: 'center',
				editable: false,
				dataIndex: 'OpResult'
			}, {
				id: 'OpDesc',
				header: '<div style="text-align:center">�������</div>',
				editable: false,
				align: 'left',
				width: 250,
				dataIndex: 'OpDesc',
				renderer:function(value,metadata){
					if(value.length>15) metadata.attr='ext:qtip="��ϸ��Ϣ��<br />'+value+'"';
					return value;
				}
			}
		]
	});

itemGrid.btnResetHide(); //�������ð�ť
itemGrid.btnPrintHide(); //���ش�ӡ��ť
itemGrid.btnAddHide(); //���ذ�ť
itemGrid.btnSaveHide(); //���ذ�ť
itemGrid.btnDeleteHide();

itemGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {

	if (columnIndex == '3') {
		var records = itemGrid.getSelectionModel().getSelections();
		var VouchNo = records[0].get("VouchNo");
		var VouchState = records[0].get("VouchState");
		var searchFlag = 1;
		var myPanel = new Ext.Panel({
				layout: 'fit',
				html: '<iframe id="frameReport" style="zoom:100%;margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + userdr + '&acctstate=' + VouchState + '&bookID=' + acctbookid + '&searchFlag=' + searchFlag + '" /></iframe>'
			});

		var win = new Ext.Window({
				title: 'ƾ֤�鿴',
				width: 1093,
				height: 620,
				resizable: true,
				closable: true,
				draggable: true,
				resizable: false,
				author: '50%',
				layout: 'fit',
				modal: false,
				plain: true,
				items: [myPanel],
				buttonAlign: 'center',
				buttons: [{
						text: '�ر�',
						type: 'button',
						handler: function () {
							win.close();
						}
					}
				]
			});
		win.show();
	}

});
function GetYearMonth() {
	Ext.Ajax.request({
		url: projUrl + '?action=GetCurYearMonth&BookID=' + acctbookid,
		method: 'POST',
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
			//alert(jsonData.success );
			if (jsonData.success == 'true') {
				//alert("dddd="+jsonData.info)
				YearMonth.setValue(jsonData.info + "-01");
			}
		},
		scope: this
	});
}
GetYearMonth();
