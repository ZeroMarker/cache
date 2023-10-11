
/////���ӱ���Query
function Query() {

	////Schem	��ѯ������grid
	var SchemGrid = new dhc.herp.Grid({
			title: '��ѯ����ά��',
			iconCls:'maintain',
			region: 'center',
			url: 'herp.acct.accountbalancemoneyexe.csp',
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
					width: 80,
					align: 'center',
					allowBlank:false,
					dataIndex: 'code'

				}, {
					id: 'name',
					header: '<div style="text-align:center">��������</div>',
					width: 180,
					align: 'left',
					allowBlank:false,
					dataIndex: 'name'
				}, {
					id: 'desc',
					header: '��������',
					width: 260,
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
	// SchemGrid.addButton('-');
	// SchemGrid.addButton('<div style="color:red">˵������Ŀ����-���ʽ�ķ��������ZB0201��ͷ��</div>');
	SchemGrid.btnResetHide() //�������ð�ť
	SchemGrid.btnPrintHide() //���ش�ӡ��ť


	//var selectedRow = itemGridDs.data.items[rowIndex];

	//rowid=selectedRow.data['rowid'];

	// alert(rowid);
	//detailGrid.load({params:{start:0,limit:12,checkmainid:rowid}});


	//////////////��Ŀ����-���ʽ ��ѯ����start//////////
	//----------------- ��ƿ�Ŀ---------------//


	//----------------- ��ƿ�Ŀ---------------//

	var SubjCodeDs = new Ext.data.Store({
			autoLoad: true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['subjId', 'subjCode', 'subjName', 'subjCodeNameAll'])
		});
	SubjCodeDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: '../csp/herp.acct.accountbalancemoneyexe.csp?action=GetAcctSubj&bookID=' + bookID + '&str=' + Ext.getCmp('AcctSubjCodeStart').getRawValue(),
				method: 'POST'
			});
	});

	var AcctSubjCodeStart = new Ext.form.ComboBox({
			id: 'AcctSubjCodeStart',
			fieldLabel: '��ƿ�Ŀ',
			labelSeparator:'',
			store: SubjCodeDs,
			valueField: 'subjCode',
			displayField: 'subjCodeNameAll',
			typeAhead: true,
			width: 235,
			listWidth: 265,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1
		});

	var SubjCodeEndDs = new Ext.data.Store({
			autoLoad: true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['subjId', 'subjCode', 'subjName', 'subjCodeNameAll'])
		});
	SubjCodeEndDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: '../csp/herp.acct.accountbalancemoneyexe.csp?action=GetAcctSubj&bookID=' + bookID + '&str=' + Ext.getCmp('AcctSubjCodeEnd').getRawValue(),
				method: 'POST'
			});
	});
	var AcctSubjCodeEnd = new Ext.form.ComboBox({
			id: 'AcctSubjCodeEnd',
			fieldLabel: '��',
			labelSeparator:'',
			store: SubjCodeEndDs,
			valueField: 'subjCode',
			displayField: 'subjCodeNameAll',
			width: 235,
			listWidth: 270,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: 'true'
		});

	///////////////��Ŀ����///////////////////////

	var levelDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '1'], ['2', '2'], ['3', '3'], ['4', '4'],
				['5', '5'], ['6', '6'], ['7', '7'], ['8', '8']]
		});

	var SubjLevel = new Ext.form.ComboBox({
			id: 'SubjLevel',
			fieldLabel: '��Ŀ����',
			labelSeparator:'',
			width: 100,
			listWidth: 100,
			store: levelDs,
			valueNotFoundText: '',
			displayField: 'keyValue',
			valueField: 'key',
			mode: 'local', // ����ģʽ
			triggerAction: 'all',
			selectOnFocus: true,
			forceSelection: true
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
				url: '../csp/herp.acct.accountbalancemoneyexe.csp?action=GetAcctYear&bookID=' + bookID + '&str=' + Ext.getCmp('AcctYear').getRawValue(),
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
			width: 100,
			listWidth: 250,
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
			fieldLabel: '����·�',
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

	//----------------- ����δ����-----------------//
	var noaccount = new Ext.form.Checkbox({
			fieldLabel: '����δ����',
			id: 'noaccount',
			name: 'noaccount',
			style: 'border:0;background:none;margin-top:0px;',
			labelSeparator:'',
			labelAlign: 'right'
		});

	//----------------- ���Ϊ0�ҷ�����Ϊ0-----------------//
	var nobalance = new Ext.form.Checkbox({
			fieldLabel: '���Ϊ0�ҷ�����Ϊ0����ʾ',
			id: 'nobalance',
			name: 'nobalance',
			style: 'border:0;background:none;margin-top:0px;',
			labelSeparator:'',
			labelAlign: 'right'
		});

	//----------------- ��ʾĩ��-----------------//
	var lastLevel = new Ext.form.Checkbox({
			fieldLabel: 'ֻ��ʾĩ��',
			id: 'lastLevel',
			name: 'lastLevel',
			style: 'border:0;background:none;margin-top:0px;',
			labelSeparator:'',
			labelAlign: 'right'
		});

	//----------------- ��ʾ�ۼ�-----------------//
	var accumulative = new Ext.form.Checkbox({
			fieldLabel: '��ʾ�ۼ�',
			id: 'accumulative',
			name: 'accumulative',
			style: 'border:0;background:none;margin-top:0px;',
			labelSeparator:'',
			labelAlign: 'right'
		});
	//////////////��Ŀ����-���ʽ��ѯ����end//////////


	var frm = new Ext.form.FormPanel({

			title: '��ѯ����',
			iconCls:'find',
			width: 500,
			frame: true,
			region: 'east',
			labelWidth: 180,
			labelAlign:'right',
			labelSeparator:'',
			//buttonAlign: 'center',

			//closable: true, //������ԾͿ��Կ��ƹرո�from
			items: [{
					xtype: 'fieldset',
					//title : '��������',
					items: [AcctSubjCodeStart, AcctSubjCodeEnd, SubjLevel, AcctYear, AcctMonthStrat, AcctMonthEnd, noaccount, lastLevel, accumulative, nobalance]
				}, {
					xtype: 'button',
					//margin-top:12,
					//style:"margin:auto",
					style: "marginLeft:45%;",
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

			AcctSubjCodeStart.setValue(arr[0]);
			AcctSubjCodeEnd.setValue(arr[1]);
			SubjLevel.setValue(arr[2]);
			AcctYear.setValue(arr[3]);
			AcctMonthStrat.setValue(arr[4]);
			AcctMonthEnd.setValue(arr[5]);
			//alert(arr[6]);
			if (arr[6] == 1) {
				noaccount.setValue(true);
				// alert(noaccount);
			} else {
				noaccount.setValue(false);
			}

			if (arr[7] == 1) {
				nobalance.setValue(true);
			} else {
				nobalance.setValue(false);
			}
			if (arr[8] == 1) {
				lastLevel.setValue(true);
			} else {
				lastLevel.setValue(false);
			}
			if (arr[9] == 1) {
				accumulative.setValue(true);
			} else {
				accumulative.setValue(false);
			}
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
			width: 1000,
			height: 500,
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

		var SubjCode1 = Ext.getCmp('AcctSubjCodeStart').getRawValue();
		if (SubjCode1 != "") {
			var codename1 = SubjCode1.split(" ");
			var SubjCode1 = codename1[0];
		}
		var SubjCode2 = Ext.getCmp('AcctSubjCodeEnd').getRawValue();
		if (SubjCode2 != "") {
			var codename2 = SubjCode2.split(" ");
			var SubjCode2 = codename2[0];
		}
		var level = Ext.getCmp('SubjLevel').getValue();
		var year = Ext.getCmp('AcctYear').getValue();
		var month1 = Ext.getCmp('AcctMonthStrat').getValue();
		var month2 = Ext.getCmp('AcctMonthEnd').getValue();
		var noaccount = Ext.getCmp('noaccount').getValue();
		if (noaccount == true) {
			noaccount = 1;
		} else {
			noaccount = 0;
		}
		var nobalance = Ext.getCmp('nobalance').getValue();
		if (nobalance == true) {
			nobalance = 1;
		} else {
			nobalance = 0;
		}
		var lastLevel = Ext.getCmp('lastLevel').getValue();
		if (lastLevel == true) {
			lastLevel = 1;
		} else {
			lastLevel = 0;
		}
		var accumulative = Ext.getCmp('accumulative').getValue();
		if (accumulative == true) {
			accumulative = 1;
		} else {
			accumulative = 0;
		}
		window.close();
		var reportFrame = document.getElementById("frameReport");
		var p_URL = "";
		//��ȡ����·��
		//userid_" "_ acctYear_" "_currentSub_" "_currentObj_" "_currentType_" "_isAcct
		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.AccountBalanceMoney.raq&&SubjCode1=' + SubjCode1 + '&SubjCode2=' + SubjCode2 +
			'&level=' + level + '&year=' + year + '&month1=' + month1 + '&month2=' + month2 +
			'&noaccount=' + noaccount + '&nobalance=' + nobalance + '&lastLevel=' + lastLevel + '&accumulative=' + accumulative + '&userdr=' + userdr;

		//alert(p_URL);
		reportFrame.src = p_URL;

	}

}
