//���ӱ���Query
function Query() {

	////Schem	������ѯ������grid
	var SchemGrid = new dhc.herp.Grid({
			title: '��ѯ����ά��',
			iconCls:'maintain',
			region: 'center',
			// atLoad: true,
			url: 'herp.acct.DepAssAcctSumReportexe.csp',
			// split : true,
			viewConfig: {
				forceFit: true
			},
			fields: [//new Ext.grid.CheckboxSelectionModel({editable:false}),
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
					align: 'left',
					allowBlank: false,
					dataIndex: 'code'

				}, {
					id: 'name',
					header: '<div style="text-align:center">��������</div>',
					width: 140,
					align: 'left',
					allowBlank: false,
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

	//SchemGrid.addButton('-');
	//SchemGrid.addButton('<div style="color:red">˵�������ź�����ܱ�ķ��������ZB1301��ͷ��</div>');
	SchemGrid.btnResetHide(); //�������ð�ť
	SchemGrid.btnPrintHide(); //���ش�ӡ��ť


	//////////////���ź�����ܱ��ѯ����start//////////

	//----------------�ڼ䷶Χ-----------//

	var startYearMonth = new Ext.form.DateField({
			id: 'startYearMonth',
			name: 'STARTYEAR_MONTH',
			fieldLabel: '�ڼ䷶Χ',
			labelSeparator:'',
			emptyMsg: "��ѡ������...",
			format: 'Y-m',
			width: 100,
			triggerAction: 'all',
			allowBlank: true,
			plugins: 'monthPickerPlugin'
		});
	var endYearMonth = new Ext.form.DateField({
			id: 'endYearMonth',
			name: 'ENDYEAR_MONTH',
			labelSeparator:'',
			fieldLabel: '��',
			emptyMsg: "��ѡ������...",
			format: 'Y-m',
			width: 100,
			triggerAction: 'all',
			allowBlank: true,
			plugins: 'monthPickerPlugin'
		});

	/*
	var startYearMonth = new Ext.form.DateField({
	id:'startYearMonth',
	fieldLabel: '�ڼ䷶Χ',
	name : 'STARTYEAR_MONTH',
	format : 'Y-m',
	editable : false,
	allowBlank : false,
	emptyText:'��ѡ������...',
	// value:new Date(),
	width: 100,
	maxValue : new Date(),
	plugins: 'monthPickerPlugin',
	listeners : {
	scope : this,
	'select' : function(dft){
	}
	}
	});

	var endYearMonth = new Ext.form.DateField({
	id:'endYearMonth',
	fieldLabel: '��Ʒ�Χ',
	name : 'ENDYEAR_MONTH',
	format : 'Y-m',
	editable : false,
	allowBlank : false,
	emptyText:'��ѡ������...',
	width: 100,
	maxValue : new Date(),
	plugins: 'monthPickerPlugin',
	listeners : {
	scope : this,
	'select' : function(dft){
	}
	}
	});*/

	//----------���ҷ�Χ-----------//
	var ItemNamestartDs = new Ext.data.Store({
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['CheckItemCode', 'CheckItemName'])
		});
		//û��ȡ��isstop��ֵ���տ�ʼ��ˢ��
	/* ItemNamestartDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'../csp/herp.acct.DepAssAcctSumReportexe.csp?action=GetCIname&bookID='+bookID,method:'POST'});
	}); */

	var CheckItemNameField1 = new Ext.form.ComboBox({
			id: 'CheckItemNameField1',
			fieldLabel: '���ҷ�Χʼ',
			store: ItemNamestartDs,
			labelSeparator:'',
			valueField: 'CheckItemCode',
			displayField: 'CheckItemName',
			emptyText: '��ѡ����ҷ�Χ...',
			typeAhead: true,
			width: 150,
			listWidth: 230,
			forceSelection: true,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1

		});
	// CheckItemNameField1.render(document.body);
	var fg;
	//�ж��Ƿ����ͣ�ÿ��� focus	buttQuery
	CheckItemNameField1.on('focus', function () {

		if (fg) {

			ItemNamestartDs.load({
				params: {
					start: 0,
					limit: 25,
					bookID:bookID,
					isStop: IsStopField.getValue() ? 1 : 0
				}
			});
			fg = 0;
			return;
		} else {
			Ext.Msg.confirm('��ʾ', '�Ƿ�Ҫѡ��ͣ�ÿ��ң� ', function (id) {
				if (id == "yes") {
					// Ext.getCmp('IsStopField').setValue(true);
					IsStopField.setValue(1);
					fg = 1;

				} else {
					IsStopField.setValue(0);
					fg = 1;
				}
				// alert(Ext.getCmp('IsStopField').getValue())
				// ���ڹرպ�������ݼ�
				ItemNamestartDs.on('beforeload', function (ds, o) {
					var IsStop = IsStopField.getValue() ? 1 : 0
						ds.proxy = new Ext.data.HttpProxy({
							url: '../csp/herp.acct.DepAssAcctSumReportexe.csp?action=GetCIname&bookID=' + bookID + '&isStop=' + IsStop,
							method: 'POST'
						});
				});

			});
		}
	});

	var ItemNameEndDs = new Ext.data.Store({
			// autoLoad:true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['CheckItemCode', 'CheckItemName'])
		});
	ItemNameEndDs.on('beforeload', function (ds, o) {
		var IsStop = IsStopField.getValue() ? 1 : 0
			ds.proxy = new Ext.data.HttpProxy({
				url: '../csp/herp.acct.DepAssAcctSumReportexe.csp?action=GetCIname&bookID=' + bookID + '&isStop=' + IsStop,
				method: 'POST'
			});
	});

	var CheckItemNameField2 = new Ext.form.ComboBox({
			id: 'CheckItemNameField2',
			fieldLabel: '���ҷ�Χ��',
			store: ItemNameEndDs,
			labelSeparator:'',
			valueField: 'CheckItemCode',
			displayField: 'CheckItemName',
			emptyText: '��ѡ����ҷ�Χ...',
			typeAhead: true,
			width: 150,
			listWidth: 230,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1
		});

	//----------ȡ��ƿ�Ŀ���롢����-----------//
	var GetAcctSubjProxy = new Ext.data.HttpProxy({
			url: 'herp.acct.DepAssAcctSumReportexe.csp?action=GetAcctSubj&bookID=' + bookID, //&subjstr='+SubjCodeNameField1.getValue(),	//Ext.getCmp('SubjCodeNameField1').getRawValue(),
			method: 'POST'
		});
	var GetAcctSubjDS = new Ext.data.Store({
			proxy: GetAcctSubjProxy,
			reader: new Ext.data.JsonReader({
				root: 'rows',
				totalProperty: 'results'
			},
				['AcctSubjCode', 'AcctCodeName']),
			remoteSort: true
		});

	var GetAcctSubjField = new Ext.form.ComboBox({
			id: 'GetAcctSubjField',
			store: GetAcctSubjDS,
			displayField: 'AcctCodeName',
			labelSeparator:'',
			valueField: 'AcctSubjCode',
			fieldLabel: '��ƿ�Ŀ',
			width: 150,
			listWidth: 260,
			pageSize: 10,
			minChars: 1,
			emptyText: '��ѡ���ƿ�Ŀ...',
			selectOnFocus: true,
			triggerAction: 'all',
			forceSelection: true
		});

	//-----------��Ŀ����------------//
	var SubjLevelStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyvalue'],
			data: [['1', '1��'], ['2', '2��'], ['3', '3��'], ['4', '4��'], ['5', '5��'], ['6', '6��'], ['7', '7��'], ['8', '8��']]
		});
	var SubjLevelField = new Ext.form.ComboBox({
			id: 'SubjLevelField',
			fieldLabel: '��Ŀ����',
			labelSeparator:'',
			width: 150,
			store: SubjLevelStore,
			emptyText: '��ѡ���Ŀ����...',
			displayField: 'keyvalue',
			valueField: 'key',
			//value:'1',	//��Ĭ��ֵ
			mode: 'local',
			selectOnFocus: true,
			triggerAction: 'all',
			forceSelection: true
		});

	//------------����δ���˸�ѡ��-------------//
	var VouchStateField = new Ext.form.Checkbox({
			id: "VouchStateField",
			fieldLabel: '����δ����',
			labelSeparator:'',
			inputValue: 1,
			style: 'border:0;background:none;margin-top:0px;',
			checked: false
		});
	//------------�跽���-------------//
	var AmtDebitField = new Ext.form.Checkbox({
			id: "AmtDebitField",
			fieldLabel: '�跽���',
			labelSeparator:'',
			inputValue: 1,
			style: 'border:0;background:none;margin-top:0px;',
			checked: false
		});
	//------------������̯����-------------//
	var OutSubjCodeField = new Ext.form.Checkbox({
			id: "OutSubjCodeField",
			fieldLabel: '������̯����',
			inputValue: 1,
			labelSeparator:'',
			style: 'border:0;background:none;margin-top:0px;',
			checked: false
		});
	//------------����ͣ�ÿ���-------------//
	var IsStopField = new Ext.form.Checkbox({
			id: "IsStopField",
			fieldLabel: '����ͣ�ÿ���',
			labelSeparator:'',
			inputValue: 1,
			style: 'border:0;background:none;margin-top:0px;',
			disabled: true,
			checked: false
		});

	//////////////���ź�����ܱ��ѯ����end//////////


	var frm = new Ext.form.FormPanel({

			labelAlign: 'right',
			title: '��ѯ����',
			iconCls:'find',
			width: 400,
			heigth: 400,
			frame: true,
			region: 'east',
			labelWidth: 120,
			// buttonAlign: 'center',

			// closable: true, //������ԾͿ��Կ��ƹرո�from
			items: [{
					xtype: 'fieldset',
					style:"padding:5px;",
					//title : '��������',
					items: [startYearMonth, endYearMonth, CheckItemNameField1, CheckItemNameField2, GetAcctSubjField,
						SubjLevelField, VouchStateField, AmtDebitField, //OutSubjCodeField,
						IsStopField]
				}, {
					xtype: 'button',
					style: "margin-left:45%;",
					width: 55,
					iconCls: 'find',
					Align: 'center',
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
			//alert(SchemDesc);
			var arr = SchemDesc.split(";");

			startYearMonth.setValue(arr[0]);
			endYearMonth.setValue(arr[1]);
			CheckItemNameField1.setValue(arr[2]);
			CheckItemNameField2.setValue(arr[3]);
			GetAcctSubjField.setValue(arr[4]);
			SubjLevelField.setValue(arr[5]);

			if (arr[6] == 1) {
				VouchStateField.setValue(1);
			} else {
				VouchStateField.setValue(0);
			}
			if (arr[7] == 1) {
				AmtDebitField.setValue(1);
			} else {
				AmtDebitField.setValue(0);
			}
			if (arr[8] == 1) {
				OutSubjCodeField.setValue(1);
			} else {
				OutSubjCodeField.setValue(0);
			}
			if (arr[9] == 1) {
				IsStopField.setValue(1);
			} else {
				IsStopField.setValue(0);
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
			width: 900,
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

		//// startYearMonth endYearMonth CheckItemNameField1 CheckItemNameField2 GetAcctSubjField SubjLevelField
		// VouchStateField 	AmtDebitField OutSubjCodeField IsStopField


		var StartDate = Ext.getCmp('startYearMonth').getValue();
		//alert(StartDate);
		if (StartDate != "") {
			StartDate = StartDate.format('Y-m')
		};
		var EndDate = Ext.getCmp('endYearMonth').getValue();
		if (EndDate != "") {
			EndDate = EndDate.format('Y-m')
		};
		var ItemCode1 = Ext.getCmp('CheckItemNameField1').getRawValue();
		if (ItemCode1 != "") {
			ItemCode1 = ItemCode1.split(" ")[0];
		}
		var ItemCode2 = Ext.getCmp('CheckItemNameField2').getRawValue();
		if (ItemCode2 != "") {
			ItemCode2 = ItemCode2.split(" ")[0];
		}
		var SubjCode = Ext.getCmp('GetAcctSubjField').getRawValue();
		//  alert(SubjCode);

		var SubjLevel = Ext.getCmp('SubjLevelField').getValue();
		var VouchState = VouchStateField.getValue();
		if (VouchState == "")
			VouchState = 0;
		else
			VouchState = 1;
		var Amtdebit = AmtDebitField.getValue();
		if (Amtdebit == "")
			Amtdebit = 0;
		else
			Amtdebit = 1;
		var OutSubjcode = OutSubjCodeField.getValue();
		if (OutSubjcode == "")
			OutSubjcode = 0;
		else
			OutSubjcode = 1;
		var IsStop = IsStopField.getValue();
		if (IsStop == "")
			IsStop = 0;
		else
			IsStop = 1;
		window.close();
		var reportFrame = document.getElementById("frameReport");
		var p_URL = "";
		// alert(ItemCode1+""+ItemCode2+""+SubjCode);
		//��̨userid,startdate,enddate,itemcode1,itemcode2,subjcode,subjlevel,vouchstate,amtdebit,outsubjcode,isStop
		//ǰ̨ startdate enddate itemcode1 itemcode2 subjcode subjlevel vouchstate outsubjcode amtdebit isStop
		//��ȡ����·��
		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.DepartmentAssistantAcctSum.raq&startdate=' + StartDate + '&enddate=' + EndDate
			 + '&itemcode1=' + ItemCode1 + '&itemcode2=' + ItemCode2 + '&subjlevel=' + SubjLevel + '&vouchstate=' + VouchState
			 + '&amtdebit=' + Amtdebit + '&outsubjcode=' + OutSubjcode + '&isStop=' + IsStop + '&userid=' + userdr + '&subjcode=' + SubjCode;
		//alert(p_URL);
		reportFrame.src = p_URL;

	}

}
