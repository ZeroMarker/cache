
//���ӱ���Query
function Query() {

	////Schem	������ѯ������grid
	var SchemGrid = new dhc.herp.Grid({
			title: '��ѯ����ά��',
			iconCls:'maintain',
			region: 'center',
			url: 'herp.acct.multicolumnaccountexe.csp',
			split: true,
			viewConfig: {
				forceFit: true
			},
			fields: [//new Ext.grid.CheckboxSelectionModel({editable:false}),
				//  s jsonTitle=rowid^bookid^code^name^desc
				{
					id: 'rowid',
					header: 'ID',
					width: 100,
					editable: false,
					hidden: true,
					dataIndex: 'rowid'
				}, {
					id: 'bookid',
					header: '<div style="text-align:center">����id</div>',
					align: 'right',
					editable: false,
					width: 140,
					hidden: true,
					dataIndex: 'bookid'
				}, {
					id: 'code',
					header: '<div style="text-align:center">�������</div>',
					width: 50,
					allowBlank:false,
					align: 'center',
					dataIndex: 'code'

				}, {
					id: 'name',
					header: '<div style="text-align:center">��������</div>',
					width: 140,
					allowBlank:false,
					align: 'left',
					dataIndex: 'name'
				}, {
					id: 'desc',
					header: '��������',
					width: 220,
					allowBlank: true,
					hidden: true,
					dataIndex: 'desc'
				}
			]
		});
	SchemGrid.load({
		params: {
			start: 0,
			limit: 10,
			bookID: bookID
		}
	});

	SchemGrid.btnResetHide() //�������ð�ť
	SchemGrid.btnPrintHide() //���ش�ӡ��ť
	SchemGrid.addButton('-');
	//SchemGrid.addButton('<div style="color:red">˵������Ŀ������--�����������ZB0401��ͷ��</div>');

	//var selectedRow = itemGridDs.data.items[rowIndex];

	//rowid=selectedRow.data['rowid'];

	// alert(rowid);
	//detailGrid.load({params:{start:0,limit:12,checkmainid:rowid}});


	//////////////��Ŀ�����˲�ѯ����start//////////
	//----------------- ��ƿ�Ŀ---------------//

	var SubjCodeDs = new Ext.data.Store({
			autoLoad: true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['subjId', 'subjCode', 'subjName', 'subjCodeName'])
		});
	SubjCodeDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: '../csp/herp.acct.multicolumnaccountexe.csp?action=GetAcctSubj&bookID=' + bookID + '&str=' + Ext.getCmp('AcctSubjCode').getRawValue(),
				method: 'POST'
			});
	});

	var AcctSubjCode = new Ext.form.ComboBox({
			id: 'AcctSubjCode',
			fieldLabel: '��ƿ�Ŀ',
			labelSeparator:'',
			store: SubjCodeDs,
			valueField: 'subjCode',
			displayField: 'subjCodeName',
			width: 255,
			listWidth: 255,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: 'true'
		});

	/////////������////////
	var YearDs = new Ext.data.Store({
			autoLoad: true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'year', 'month', 'AcctYearMonth'])
		});
	YearDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: '../csp/herp.acct.multicolumnaccountexe.csp?action=GetAcctYear&bookID=' + bookID + '&str=' + Ext.getCmp('AcctYear').getRawValue(),
				method: 'POST'
			});
	});

	var AcctYear = new Ext.form.ComboBox({
			id: 'AcctYear',
			labelSeparator:'',
			fieldLabel: '������',
			store: YearDs,
			valueField: 'year',
			displayField: 'year',
			width: 255,
			listWidth: 255,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: 'true'
		});

	/////////����·�////////
	var MonthDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['01', '01��'], ['02', '02��'], ['03', '03��'], ['04', '04��'],
				['05', '05��'], ['06', '06��'], ['07', '07��'], ['08', '08��'],
				['09', '09��'], ['10', '10��'], ['11', '11��'], ['12', '12��']]
		});

	var AcctMonthStrat = new Ext.form.ComboBox({
			id: 'AcctMonthStrat',
			fieldLabel: '��ʼ�·�',
			labelSeparator:'',
			width: 120,
			listWidth: 120,
			store: MonthDs,
			valueNotFoundText: '',
			displayField: 'keyValue',
			valueField: 'key',
			mode: 'local', // ����ģʽ
			triggerAction: 'all',
			selectOnFocus: true,
			forceSelection: true
			//resizable:true
		});
	var AcctMonthEnd = new Ext.form.ComboBox({
			id: 'AcctMonthEnd',
			fieldLabel: '�����·�',
			labelSeparator:'',
			width: 120,
			listWidth: 120,
			store: MonthDs,
			valueNotFoundText: '',
			displayField: 'keyValue',
			valueField: 'key',
			mode: 'local', // ����ģʽ
			triggerAction: 'all',
			selectOnFocus: true,
			forceSelection: true
		});

	//�Ƿ����Ϊ����
	var StateField = new Ext.form.Checkbox({
			id: 'StateField',
			fieldLabel: '����δ����',
			labelSeparator:'',
			allowBlank: false,
			style: 'border:0;background:none;margin-top:0px;',
			width: 30
		});

	//////////////��Ŀ�����˲�ѯ����end//////////


	var frm = new Ext.form.FormPanel({

			labelAlign: 'right',
			title: '��ѯ����',
			iconCls:'find',
			width: 430,
			frame: true,
			region: 'east',
			labelWidth: 120,
			//buttonAlign: 'center',

			//closable: true, //������ԾͿ��Կ��ƹرո�from
			items: [{
					xtype: 'fieldset',
					//title : '��������',
					items: [AcctSubjCode, AcctYear, AcctMonthStrat, AcctMonthEnd, StateField]
				}, {
					xtype: 'button',
					//margin-top:12,
					//style:"margin:auto",
					style: "marginLeft:40%;",
					width: 55,
					iconCls: 'find',
					text: '��ѯ',
					handler: function () {
						FindQuery();
					}
				}
			]

		});

	SchemGrid.on('rowclick', function (grid, rowIndex, e) {
		var object = SchemGrid.getSelectionModel().getSelections();
		var rowObjID = object[0].get("rowid");
		if (rowObjID == "" || rowObjID == null || rowObjID == undefined) {
			SchemGrid.edit = true;
		} else {

			var code = object[0].get("code");
			var SchemDesc = object[0].get("desc");
			var arr = SchemDesc.split(";");
			var subjcode = arr[0];
			var year = arr[1];
			var monthstart = arr[2];
			var monthend = arr[3];
			var state = arr[4];

			AcctSubjCode.setValue(subjcode);
			AcctYear.setValue(year);
			AcctMonthStrat.setValue(monthstart);
			AcctMonthEnd.setValue(monthend);
			StateField.setValue(state);
		}

	});

	//�ܰ�������panel����Ext.panel
	var fullForm = new Ext.Panel({
			//title: '��ѯ��������',
			closable: true,
			border: true,
			layout: 'border',
			items: [SchemGrid, frm]
		});

	var window = new Ext.Window({
			// title: '��ѯ��������',
			layout: 'fit',
			plain: true,
			width: 900,
			height: 450,
			modal: true,
			buttonAlign: 'center',
			items: fullForm,
			buttons: [{
					text: '�ر�',
					iconCls:'cancel',
					handler: function () {
						window.close();
					}
				}
			]

		});
	window.show();

	function FindQuery() {
		var SubjCode = Ext.getCmp('AcctSubjCode').getRawValue();
		if (SubjCode != "") {
			var codename = SubjCode.split(" ");
			var SubjCode = codename[0];
		}

		//alert(SubjCode);
		var year = Ext.getCmp('AcctYear').getValue();
		var month1 = Ext.getCmp('AcctMonthStrat').getValue();
		var month2 = Ext.getCmp('AcctMonthEnd').getValue();

		var state = Ext.getCmp('StateField').getValue();
		if (state == true) {
			state = 1;
			//alert(state);
		} else {
			state = 0;
		}
		window.close();
		var reportFrame = document.getElementById("frameReport");
		var p_URL = "";
		//��ȡ����·��
		//userid_" "_ acctYear_" "_currentSub_" "_currentObj_" "_currentType_" "_isAcct
		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.MultiColumnAccount.raq&&SubjCode=' + SubjCode +
			'&year=' + year + '&month1=' + month1 + '&month2=' + month2 + '&state=' + state + '&userdr=' + userdr;
		reportFrame.src = p_URL;

	}

}
