
//���ӱ���Query
function Query() {
	//alert(bookID);

	////Schem	������ѯ������grid
	var SchemGrid = new dhc.herp.Grid({
			title: '��ѯ����ά��',
			iconCls: 'maintain',
			region: 'center',
			url: 'herp.acct.acctmulticolumnaccountexe.csp',
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
					header: '<div style="text-align:center">��������</div>',
					width: 100,
					align: 'left',
					dataIndex: 'code'

				}, {
					id: 'name',
					header: '<div style="text-align:center">��������</div>',
					width: 140,
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

	SchemGrid.addButton('-');
	// SchemGrid.addButton('<div style="color:red">˵������Ŀ������-���ʽ�ķ��������ZB0401��ͷ��</div>');


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
				url: '../csp/herp.acct.acctmulticolumnaccountexe.csp?action=GetAcctSubj&bookID=' + bookID + '&str=' + Ext.getCmp('AcctSubjCode').getRawValue(),
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
			width: 180,
			listWidth: 220,
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
				url: '../csp/herp.acct.acctmulticolumnaccountexe.csp?action=GetAcctYear&bookID=' + bookID + '&str=' + Ext.getCmp('AcctYear').getRawValue(),
				method: 'POST'
			});
	});

	var AcctYear = new Ext.form.ComboBox({
			id: 'AcctYear',
			fieldLabel: '������',
			labelSeparator:'',
			store: YearDs,
			valueField: 'year',
			displayField: 'year',
			width: 180,
			listWidth: 220,
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
			fieldLabel: '��',
			labelSeparator:'',
			width: 100,
			listWidth: 100,
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
			fieldLabel: '��',
			labelSeparator:'',
			width: 100,
			listWidth: 100,
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
			width: 30
		});

	//////////////��Ŀ�����˲�ѯ����end//////////

	//============================�ָ���==================================================//
	var frm = new Ext.form.FormPanel({

			labelAlign: 'right',
			title: '��ѯ����',
			iconCls: 'find',
			width: 350,
			frame: true,
			region: 'east',
			labelWidth: 115,
			labelSeparator:'',
			//buttonAlign: 'center',
			//closable: true, //������ԾͿ��Կ��ƹرո�from
			items: []
		});
	var CodeStr = "";
	var ConfigItems = [];
	SchemGrid.on('rowclick', function (grid, rowIndex, e) {
		alert(11);
		var object = SchemGrid.getSelectionModel().getSelections();
		var rowObjID = object[0].get("rowid");
		if (rowObjID == "" || rowObjID == null || rowObjID == undefined) {
			SchemGrid.edit = true;
		} else {

			var code = object[0].get("code");
			if (code === "ZB0401") {
				if (CodeStr === code)
					return;
				var TempItems = [{
						xtype: 'fieldset',
						id: 'ZB0401_Item0',
						items: [AcctSubjCode, AcctYear, AcctMonthStrat, AcctMonthEnd]
					}, {
						xtype: 'button',
						id: 'ZB0401_Item1',
						text: 'ȷ&nbsp;&nbsp;��',
						handler: function () {
							FindQuery(code);
						}
					}
				];
				ChangeItems(code, TempItems);
			}
		}
	});

	//�滻panel�е����
	function ChangeItems(code, TempItems) {
		if (CodeStr !== "") {
			for (var i = 0; i < ConfigItems.length; i++) {
				frm.remove(Ext.getCmp(CodeStr + '_Item' + i), false);
				Ext.getCmp(CodeStr + '_Item' + i).setVisible(false);
			}
			frm.doLayout();
		}
		CodeStr = code;
		ConfigItems = TempItems.slice(); ////splice() �������ڲ��롢ɾ�����滻�����Ԫ�ء�

		for (var j = 0; j < ConfigItems.length; j++)
			frm.add(ConfigItems[j]);
		frm.doLayout();
		return;
	}
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
			width: 800,
			height: 450,
			modal: true,
			buttonAlign: 'center',
			items: fullForm,
			buttons: [{
					text: '�ر�',
					handler: function () {
						window.close();
					}
				}
			]

		});
	window.show();

	function FindQuery(code) {

		// if(code==="ZB0401"){
		var SubjCode = Ext.getCmp('AcctSubjCode').getValue();
		var year = Ext.getCmp('AcctYear').getValue();
		var month1 = Ext.getCmp('AcctMonthStrat').getValue();
		var month2 = Ext.getCmp('AcctMonthEnd').getValue();
		window.close();
		var reportFrame = document.getElementById("frameReport");
		var p_URL = "";
		//��ȡ����·��
		//userid_" "_ acctYear_" "_currentSub_" "_currentObj_" "_currentType_" "_isAcct
		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.MultiColumnAccount.raq&&SubjCode=' + SubjCode +
			'&year=' + year + '&month1=' + month1 + '&month2=' + month2 + '&userdr=' + userdr;
		reportFrame.src = p_URL;
		//   }

	}

}
