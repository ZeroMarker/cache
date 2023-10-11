
var userID = session['LOGON.USERID'];
var bookID = IsExistAcctBook();
/////////////////////��Ŀ����

var levelStore = new Ext.data.SimpleStore({
		fields: ['rowid', 'level'],
		data: [['1', '1��'], ['2', '2��'], ['3', '3��'], ['4', '4��'], ['5', '5��'], ['6', '6��'], ['7', '7��'], ['8', '8��']]
	});
var subjlevelname = new Ext.form.ComboBox({
		fieldLabel: '��Ŀ����',
		width: 80,
		listWidth: 80,
		selectOnFocus: true,
		allowBlank: false,
		store: levelStore,
		anchor: '90%',
		value: 1, //Ĭ��ֵ
		valueNotFoundText: '',
		displayField: 'level',
		valueField: 'rowid',
		triggerAction: 'all',
		// emptyText : '1',
		mode: 'local', // ����ģʽ
		editable: false,
		//pageSize : 10,
		minChars: 1,
		editable: false,
		listeners: {
			select: function () {

				dosearch()
			}

		},
		selectOnFocus: true,
		forceSelection: true

	});

var balanceField = new Ext.form.DisplayField({
		id: 'balanceField',
		fieldLabel: '����ƽ����',
		width: 80,
		// disabled:true,
		// style: 'padding-left:5px;margin-top:-1px;font-size:12px;',
		selectOnFocus: true

	});

/*
var findButton = new Ext.Button({
text: '��ѯ',
tooltip: '��ѯ',
iconCls: 'option',
handler: function(){

dosearch();
}
});
 */

function dosearch() {
	var subjlevel = subjlevelname.getValue()
	var limits=Ext.getCmp("PageSizePlugin").getValue();
			 //alert(limits);
	 if(!limits){limits=25};
		itemGrid.load({
			params: {
				start: 0,
				limit: limits,
				subjlevel: subjlevel
				//bookID:bookID
			}

		});

}
//////////����ƽ�ⰴť//////////////
var trialButton = new Ext.Button({
		text: '����ƽ��',
		tooltip: '����ƽ��',
		width: 90,
		iconCls: 'trialbalance',
		handler: function () {
			trial();
			itemGrid.load({
				params: {
					start: 0,
					limit: 25
				}
			});
		}
	});

//////////��������//////////////
var acctstartButton = new Ext.Button({
		text: '��������',
		tooltip: '��������',
		width: 90,
		iconCls: 'StartAcctbook',
		handler: function () {
			acctstart();

		}
	});
Ext.Ajax.request({
	url: '../csp/herp.acct.AcctTrialBalanceexe.csp?action=getLedgerFlag' + '&bookID=' + bookID,
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
			if (jsonData.info == 1) {
				balanceField.setValue("ƽ��");
				trialButton.disable();
				acctstartButton.disable();
			}
		}
		scope: this
	}
});

var queryPanel = new Ext.FormPanel({
		height: 70,
		region: 'north',
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px'
		},
		items: [{
				// columnWidth : 1,
				xtype: 'panel',
				layout: "column",
				items:
				[{
						xtype: 'displayfield',
						value: '��Ŀ����',
						width: 65
					},
					subjlevelname, {
						xtype: 'displayfield',
						value: '',
						width: 20
					}, trialButton, {
						xtype: 'displayfield',
						value: '',
						width: 20
					}, acctstartButton]
			}, {
				xtype: 'panel',
				layout: "column",
				items: [{
						xtype: 'displayfield',
						value: '����ƽ����:',
						width: 95
					},
					balanceField
				]
			}

			/* ,{
			xtype: 'compositefield',
			//fieldLabel: '��ѯ����',
			// msgTarget : 'side',
			layout:'column',
			hideLabel: true,
			//anchor    : '-20',
			defaults: {
			flex: 1
			},
			items: [{
			xtype : 'displayfield',
			value : '',
			width : 10
			}


			]  } */
		]
	});

var itemGrid = new dhc.herp.Grid({
		title:'����ƽ���б�',
		iconCls:'list',
		region: 'center',
		url: '../csp/herp.acct.accttrialbalanceexe.csp',
		// atLoad:true,
		/* viewConfig : {
		forceFit : true,
		getRowClass : function(record,rowIndex,rowParams,store){

		//var dow =record.data.upmoney
		if(true)
	{alert("fdgh");
		return 'x-grid-record-blue'; }
		else
	{return 'x-grid-record-red';}

		}
		},   */

		fields: [
			//new Ext.grid.CheckboxSelectionModel({editable:false}),
			{
				id: 'AcctSubjCode',
				header: '<div style="text-align:center">��Ŀ����</div>',
				allowBlank: false,
				width: 100,
				editable: false,
				update: true,
				dataIndex: 'AcctSubjCode'
			}, {
				id: 'AcctSubjNameAll',
				header: '<div style="text-align:center">��Ŀȫ��</div>',
				allowBlank: false,
				editable: false,
				allowBlank: false,
				width: 150,
				update: true,
				dataIndex: 'AcctSubjNameAll'

			}, {
				id: 'Direction',
				header: '<div style="text-align:center">�������</div>',
				editable: false,
				allowBlank: false,
				align: 'center',
				width: 70,
				update: true,
				dataIndex: 'Direction'
			}, {

				id: 'BeginDebtSum',
				header: '<div style="text-align:center">����跽���</div>',
				editable: false,
				//renderer:Ext.util.Format.number(value,'0,000.00'),
				// type:'numberField',
				allowBlank: false,
				align: 'right',
				width: 140,
				update: true,
				dataIndex: 'BeginDebtSum',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				}
			}, {

				id: 'BeginCreditSum',
				header: '<div style="text-align:center">����������</div>',
				editable: false,
				//renderer:Ext.util.Format.number(value,'0,000.00'),
				allowBlank: false,
				//type:'numberField',
				align: 'right',
				width: 140,
				update: true,
				dataIndex: 'BeginCreditSum',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				}

			}, {
				id: 'TDebtSum',
				header: '<div style="text-align:center">�ۼƽ跽���</div>',
				editable: false,
				allowBlank: false,
				// type:'numberField',
				//renderer:Ext.util.Format.number(value,'0,000.00'),
				align: 'right',
				width: 140,
				update: true,
				dataIndex: 'TDebtSum',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				}

			}, {

				id: 'TCreditSum',
				header: '<div style="text-align:center">�ۼƴ������</div>',
				editable: false,
				allowBlank: false,
				//renderer:Ext.util.Format.number(value,'0,000.00'),
				// type:'numberField',
				align: 'right',
				width: 140,
				update: true,
				dataIndex: 'TCreditSum',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				}
			}, {

				id: 'EndDebtSum',
				header: '<div style="text-align:center">�ڳ��跽���</div>',
				editable: false,
				allowBlank: false,
				// type:'numberField',

				align: 'right',
				width: 140,
				update: true,
				dataIndex: 'EndDebtSum',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				}
			}, {

				id: 'EndCreditSum',
				header: '<div style="text-align:center">�ڳ��������</div>',
				editable: false,
				allowBlank: false,
				//type:'numberField',
				//renderer:Ext.util.Format.number('0,000.00'),
				align: 'right',
				width: 140,
				update: true,
				dataIndex: 'EndCreditSum',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				}

			}
		]
	});

itemGrid.load({
	params: {
		start: 0,
		limit: 25,
		bookID: bookID
	}
});

itemGrid.btnAddHide(); //�������Ӱ�ť
itemGrid.btnSaveHide(); //���ر��水ť
itemGrid.btnDeleteHide(); //����ɾ����ť
itemGrid.btnResetHide() //�������ð�ť
itemGrid.btnPrintHide() //���ش�ӡ��ť
