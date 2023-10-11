var projUrl = '../csp/herp.acct.acctThreeBarDetailNumexe.csp';
var bookID = GetAcctBookID();
var acctbookid = bookID;

var userdr = session['LOGON.USERID']; //��¼��ID
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
	// SchemGrid.addButton('<div style="color:red">˵������Ŀ��ϸ��-�������ʽ�ķ����������ZB0302��ͷ��</div>');

	//============================�ָ���==================================================//


	//////////////��Ŀ������ϸ�˲�ѯ����start//////////


	//==�������ʽ��ƿ�Ŀ==//
	var SubjCodeZB0302Ds = new Ext.data.Store({
			autoLoad: true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'SubjCode', 'SubjName', 'SubjCodeName'])
		});
	SubjCodeZB0302Ds.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=GetNumAcctSubjZB0302&str=' + Ext.getCmp('AcctNumSubjCodeZB0302').getRawValue() + '&bookID=' + acctbookid,
				method: 'POST'
			});
	});

	var AcctNumSubjCodeZB0302 = new Ext.form.ComboBox({
			id: 'AcctNumSubjCodeZB0302',
			fieldLabel: '��ƿ�Ŀ',
			labelSeparator:'',
			store: SubjCodeZB0302Ds,
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

	//**������**//
	var YearZB0301Ds = new Ext.data.Store({
			autoLoad: true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['AcctYear'])
		});
	YearZB0301Ds.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=GetAcctYearZB0301&&bookID=' + acctbookid,
				method: 'POST'
			});
	});

	var AcctYearZB0301 = new Ext.form.ComboBox({
			id: 'AcctYearZB0301',
			fieldLabel: '������',
			labelSeparator:'',
			store: YearZB0301Ds,
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
	var MonthZB0301Ds = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['01', '01��'], ['02', '02��'], ['03', '03��'], ['04', '04��'],
				['05', '05��'], ['06', '06��'], ['07', '07��'], ['08', '08��'],
				['09', '09��'], ['10', '10��'], ['11', '11��'], ['12', '12��']]
		});

	var AcctMonthZB0301Strat = new Ext.form.ComboBox({
			id: 'AcctMonthZB0301Strat',
			fieldLabel: '��ʼ�·�',
			labelSeparator:'',
			width: 100,
			listWidth: 100,
			store: MonthZB0301Ds,
			valueNotFoundText: '',
			displayField: 'keyValue',
			valueField: 'key',
			mode: 'local', // ����ģʽ
			triggerAction: 'all',
			selectOnFocus: true,
			forceSelection: true
			//resizable:true
		});
	var AcctMonthZB0301End = new Ext.form.ComboBox({
			id: 'AcctMonthZB0301End',
			fieldLabel: '�����·�',
			labelSeparator:'',
			width: 100,
			listWidth: 100,
			store: MonthZB0301Ds,
			valueNotFoundText: '',
			displayField: 'keyValue',
			valueField: 'key',
			mode: 'local', // ����ģʽ
			triggerAction: 'all',
			selectOnFocus: true,
			forceSelection: true
		});

	//�Ƿ����Ϊ����
	var StateZB0301Field = new Ext.form.Checkbox({
			id: 'StateZB0301Field',
			fieldLabel: '����δ����',
			labelSeparator:'',
			allowBlank: false,
			style: 'border:0;background:none;margin-top:0px;',
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
			labelWidth: 80,
			items: [{
					xtype: 'fieldset',
					items: [AcctNumSubjCodeZB0302, AcctYearZB0301, AcctMonthZB0301Strat, AcctMonthZB0301End, StateZB0301Field]
				}, {
					xtype: 'button',
					style: "margin-Left:45%;",
					width: 55,
					text: '��ѯ',
					iconCls: 'find',
					handler: function () {
						FindQuery();
					}
				}
			]
		});
	var CodeStr = "";
	var ConfigItems = [];
	//������ʾ

	SchemGrid.on('rowclick', function (grid, rowIndex, e) {
		var rowObj = SchemGrid.getSelectionModel().getSelections();
		var rowObjID = rowObj[0].get("rowid");
		if (rowObjID == "" || rowObjID == null || rowObjID == undefined) {
			SchemGrid.edit = true;
		} else {
			var SchemDesc = rowObj[0].get("desc"); //��ȡ��������
			var arr = SchemDesc.split(";"); //���շֺŽ�ȡ����
			var SubjCode = arr[0]; //��ȡ��ƿ�Ŀ
			AcctNumSubjCodeZB0302.setValue(SubjCode);
			var year = arr[1]; //��ȡ��������
			AcctYearZB0301.setValue(year); //��ȡ���
			var month1 = arr[2];
			AcctMonthZB0301Strat.setValue(month1);
			var month2 = arr[3];
			AcctMonthZB0301End.setValue(month2);
			var state = arr[4];
			StateZB0301Field.setValue(state);
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

		var sjcode = Ext.getCmp('AcctNumSubjCodeZB0302').getValue();
		if (sjcode != "") {
			var codename = sjcode.split(" ");
			var sjcode = codename[0];
		}
		//var sjcode=sjcode.split(" ")[0];
		var year = Ext.getCmp('AcctYearZB0301').getValue();
		var month1 = Ext.getCmp('AcctMonthZB0301Strat').getValue();
		var month2 = Ext.getCmp('AcctMonthZB0301End').getValue();
		var state = Ext.getCmp('StateZB0301Field').getValue();

		if (state == true) {
			state = 1;
		} else {
			state = 0;
		}
		//alert(sjcode+"^"+year+"^"+month1+"^"+month2+"^"+state);
		window.close();
		var reportFrame = document.getElementById("frameReport");
		var p_URL = "";
		//��ȡ����·��
		//userid_" "_ acctYear_" "_currentSub_" "_currentObj_" "_currentType_" "_isAcct
		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.ThreeBarDetailCashNum.raq&&sjcode=' + sjcode +
			'&year=' + year + '&month1=' + month1 + '&month2=' + month2 + '&state=' + state + '&userid=' + userdr;
		reportFrame.src = p_URL;

		//}
		//����ZB0302

		//������������ϸ��


	}

}
