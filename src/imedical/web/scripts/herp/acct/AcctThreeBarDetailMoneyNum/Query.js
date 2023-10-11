var projUrl = '../csp/herp.acct.acctThreeBarDetailMoneyNumexe.csp';
var bookID = GetAcctBookID();
var acctbookid = bookID;

var userdr = session['LOGON.USERID']; //��¼��ID
//���ӱ���Query
//���ӱ���Query
function Query() {
	//��ѯ����Grid�Ķ���
	var SchemGrid = new dhc.herp.Grid({
			title: '��ѯ����ά��',
			iconCls:'maintain',
			region: 'center',
			atLoad: true,
			url: projUrl,
			split: true,
			//edit:false,
			viewConfig: {
				forceFit: true
			},
			fields: [
				//var json=rowid^bookid^code^name^desc
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
					width: 50,
					allowBlank:false,
					align: 'left',
					dataIndex: 'code'

				}, {
					id: 'name',
					header: '<div style="text-align:center">��������</div>',
					width: 140,
					align: 'left',
					allowBlank:false,
					dataIndex: 'name'
				}, {
					id: 'desc',
					header: '��������',
					width: 220,
					editable: false,
					allowBlank: true,
					hidden: true,
					dataIndex: 'desc'
				}
			]
		});
	//���ݼ���
	SchemGrid.load({
		params: {
			start: 0,
			limit: 10,
			bookID: bookID
		}
	});
	SchemGrid.btnResetHide(); //�������ð�ť
	SchemGrid.btnPrintHide(); //���ش�ӡ��ť
	SchemGrid.addButton('-');
	//SchemGrid.addButton('<div style="color:red">˵������Ŀ��ϸ��-���ʽ�ķ����������ZB0301��ͷ��</div>');

	//============================�ָ���==================================================//


	//////////////��Ŀ������ϸ�˲�ѯ����start//////////

	//��ƿ�Ŀ1
	var SubjCodeDs = new Ext.data.Store({
			autoLoad: true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'SubjCode', 'SubjName', 'SubjCodeName'])
		});
	SubjCodeDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=GetNumAcctSubjZB0302&str=' + Ext.getCmp('AcctNumSubjCodeZB0302').getRawValue() + '&bookID=' + acctbookid,
				method: 'POST'
			});
	});

	var AcctSubjCodeA = new Ext.form.ComboBox({
			id: 'AcctSubjCodeA',
			fieldLabel: '��ƿ�Ŀ',
			labelSeparator:'',
			store: SubjCodeDs,
			valueField: 'SubjCode',
			displayField: 'SubjCodeName',
			width: 220,
			listWidth: 260,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: 'true'
		});

	//��ƿ�Ŀ2
	var AcctSubjCodeB = new Ext.form.ComboBox({
			id: 'AcctSubjCodeB',
			fieldLabel: '��ƿ�Ŀ',
			labelSeparator:'',
			store: SubjCodeDs,
			valueField: 'SubjCode',
			displayField: 'SubjCodeName',
			width: 220,
			listWidth: 260,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: 'true'
		});

	//��Ŀ����
	var SubjLevelDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [
				["1", '1'], ["2", '2'], ['3', '3'], ['4', '4'],
				['5', '5'], ['6', '6'], ['7', '7'], ['8', '8']
			]
		});
	var AcctSubjLevel = new Ext.form.ComboBox({
			id: 'AcctSubjLevel',
			fieldLabel: '��Ŀ����',
			labelSeparator:'',
			width: 220,
			selectOnFocus: true,
			allowBlank: false,
			store: SubjLevelDs,
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // ����ģʽ
			editable: false,
			emptyText: '��ѡ��¼���Ŀ����',
			selectOnFocus: true,
			forceSelection: true
		});

	//**������**//
	var YearDs = new Ext.data.Store({
			autoLoad: true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['AcctYear'])
		});
	YearDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=GetAcctYearZB0301&&bookID=' + acctbookid,
				method: 'POST'
			});
	});

	var AcctYearField = new Ext.form.ComboBox({
			id: 'AcctYearField',
			fieldLabel: '������',
			labelSeparator:'',
			store: YearDs,
			valueField: 'AcctYear',
			displayField: 'AcctYear',
			width: 220,
			listWidth: 250,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: 'true'
		});

	//**����·�**//
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
			fieldLabel: '�����·�',
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
			style: 'border:0;background:none;margin-top:0px;',
			width: 30
		});

	//��ϸ��Ŀ��ʾ
	var NotIsLastField = new Ext.form.Checkbox({
			id: 'NotIsLastField',
			labelSeparator:'',
			fieldLabel: '����ϸ��Ŀ��ʾ',
			allowBlank: false,
			width: 30
		});

	//============================�ָ���==================================================//
	var frm = new Ext.form.FormPanel({
			//autoLoad:true,
			labelAlign: 'right',
			title: '��ѯ����',
			iconCls:'find',
			width: 400,
			frame: true,
			region: 'east',
			defaults: {
				bodyStyle: ' padding:2.5px 0 ' //,
				//anchor: '200%',
			},
			labelWidth: 80,
			//labelWidth : 115,
			items: [{
					// defaults: {anchor: '90%'},
					// layout:'fit',
					xtype: 'fieldset',
					items: [AcctSubjCodeA, AcctSubjCodeB, AcctSubjLevel, AcctYearField, AcctMonthStrat, AcctMonthEnd, StateField]
				}, {
					xtype: 'button',
					style: "margin-Left:45%;",
					width: 55,
					text: '��ѯ',
					iconCls: 'find',
					//fontSize:200,
					handler: function () {
						FindQuery();
					}
				}
			]
		});
	var CodeStr = "";
	var ConfigItems = [];
	//������ʾ

	//rowdblclick ˫��; rowclick ����
	SchemGrid.on('rowclick', function (grid, rowIndex, e) {
		var rowObj = SchemGrid.getSelectionModel().getSelections();
		var rowObjID = rowObj[0].get("rowid");
		if (rowObjID == "" || rowObjID == null || rowObjID == undefined) {
			SchemGrid.edit = true;
		} else {
			var SchemDesc = rowObj[0].get("desc"); //��ȡ��������
			var code = rowObj[0].get("code");
			var arr = SchemDesc.split(";"); //���շֺŽ�ȡ����

			var SubjCodeA = arr[0]; //��ȡ��ƿ�ĿA
			AcctSubjCodeA.setValue(SubjCodeA);

			var SubjCodeB = arr[1]; //��ȡ��ƿ�ĿB
			AcctSubjCodeB.setValue(SubjCodeB);

			var SubjLevel = arr[2];
			AcctSubjLevel.setValue(SubjLevel);
			var year = arr[3]; //��ȡ��������
			AcctYearField.setValue(year); //��ȡ���
			var month1 = arr[4];
			AcctMonthStrat.setValue(month1);
			var month2 = arr[5];
			AcctMonthEnd.setValue(month2);
			var state = arr[6];
			StateField.setValue(state);
			var notlastsj = arr[7];
			NotIsLastField.setValue(notlastsj);
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
		var sjcode1 = Ext.getCmp('AcctSubjCodeA').getValue();
		var sjcode1 = sjcode1.split(" ")[0];
		var sjcode2 = Ext.getCmp('AcctSubjCodeB').getValue();
		var sjcode2 = sjcode2.split(" ")[0];
		var sjlevel = Ext.getCmp('AcctSubjLevel').getValue();
		var year = Ext.getCmp('AcctYearField').getValue();
		var month1 = Ext.getCmp('AcctMonthStrat').getValue();
		var month2 = Ext.getCmp('AcctMonthEnd').getValue();
		var state = Ext.getCmp('StateField').getValue();
		var notlastsj = Ext.getCmp('NotIsLastField').getValue();

		if (state == true) {
			state = 1;
		} else {
			state = 0;
		}
		if (notlastsj == true) {
			notlastsj = 1;
		} else {
			notlastsj = 0;
		}

		//alert(sjcode+"^"+year+"^"+month1+"^"+month2+"^"+state);
		window.close();
		var reportFrame = document.getElementById("frameReport");
		var p_URL = "";
		//��ȡ����·��
		//userid_" "_ acctYear_" "_currentSub_" "_currentObj_" "_currentType_" "_isAcct
		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.AcctThreeBarDetailMoneyNum.raq&&sjcode1=' + sjcode1 +
			'&sjcode2=' + sjcode2 + '&sjlevel=' + sjlevel + '&year=' + year + '&month1=' + month1 + '&month2=' + month2 +
			'&state=' + state + '&notlastsj=' + notlastsj + '&userid=' + userdr;
		// alert(p_URL);
		reportFrame.src = p_URL;
		//}


	}

}
