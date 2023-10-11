//���ӱ���Query
function Query() {

	////Schem	������ѯ������grid
	var SchemGrid = new dhc.herp.Grid({
			title: '��ѯ����ά��',
			iconCls:'maintain',
			region: 'center',
			url: 'herp.acct.acctsubjledgreportexe.csp',
			split: true,
			atLoad: true,
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

	// SchemGrid.addButton('-');
	// SchemGrid.addButton('<div style="color:red">˵������Ŀ����-��ҽ��ʽ�ķ��������ZB0103��ͷ��</div>');
	SchemGrid.btnResetHide() //�������ð�ť
	SchemGrid.btnPrintHide() //���ش�ӡ��ť


	//////////////��Ŀ���˽��ʽ���������ʽ����ҽ��ʽ��ѯ����start//////////
	//----------ȡ��Ŀ���롢����-----------//
	var SubjCodeNameProxy = new Ext.data.HttpProxy({
			url: 'herp.acct.acctsubjledgreportexe.csp?action=GetSubjCodeNameCur&bookID=' + bookID, //&subjstr='+SubjCodeNameField1.getValue(),	//Ext.getCmp('SubjCodeNameField1').getRawValue(),
			method: 'POST'
		});
	var SubjCodeNameDS = new Ext.data.Store({
			proxy: SubjCodeNameProxy,
			reader: new Ext.data.JsonReader({
				root: 'rows',
				totalProperty: 'results'
			},
				['subjCode', 'subjCodeNameAll']),
			remoteSort: true
		});

	var SubjCodeNameField1 = new Ext.form.ComboBox({
			id: 'SubjCodeNameField1',
			store: SubjCodeNameDS,
			displayField: 'subjCodeNameAll',
			valueField: 'subjCode',
			fieldLabel: '��Ŀ��Χ',
			width: 200,
			listWidth: 270,
			pageSize: 10,
			minChars: 1,
			emptyText: '��ѡ��...',
			selectOnFocus: true,
			triggerAction: 'all',
			forceSelection: true
		});
	var SubjCodeNameField2 = new Ext.form.ComboBox({
			id: 'SubjCodeNameField2',
			store: SubjCodeNameDS,
			displayField: 'subjCodeNameAll',
			valueField: 'subjCode',
			width: 200,
			listWidth: 270,
			pageSize: 10,
			minChars: 1,
			emptyText: '��ѡ��...',
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
			width: 90,
			store: SubjLevelStore,
			displayField: 'keyvalue',
			valueField: 'key',
			fieldLabel: '��Ŀ����',
			value: '1', //��Ĭ��ֵ
			triggerAction: 'all',
			mode: 'local',
			selectOnFocus: true,
			triggerAction: 'all',
			forceSelection: true
		});
	//----------------������-----------//
	var AcctYearProxy = new Ext.data.HttpProxy({
			url: 'herp.acct.acctsubjledgreportexe.csp?action=GetAcctYear&bookID=' + bookID
		});
	var AcctYearDS = new Ext.data.Store({
			proxy: AcctYearProxy,
			reader: new Ext.data.JsonReader({
				root: 'rows',
				totalProperty: 'results'
			}, ['year', 'yearh']),
			remoteSort: true
		});

	var AcctYearField = new Ext.form.ComboBox({
			id: 'AcctYearField',
			store: AcctYearDS,
			displayField: 'yearh',
			valueField: 'year',
			fieldLabel: '�������',
			width: 90,
			listWidth: 187,
			pageSize: 10,
			minChars: 1,
			emptyText: '��ѡ��...',
			selectOnFocus: true,
			triggerAction: 'all',
			forceSelection: true
		});

	//------------�·�-------------//
	var MonthStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyvalue'],
			data: [['01', '1��'], ['02', '2��'], ['03', '3��'], ['04', '4��'], ['05', '5��'], ['06', '6��'],
				['07', '7��'], ['08', '8��'], ['09', '9��'], ['10', '10��'], ['11', '11��'], ['12', '12��']]
		});
	var AcctMonthField = new Ext.form.ComboBox({
			id: 'AcctMonthField',
			width: 90,
			store: MonthStore,
			displayField: 'keyvalue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local',
			emptyText: '��ѡ��...',
			selectOnFocus: true,
			triggerAction: 'all',
			forceSelection: true

		});
	//------------����δ���˸�ѡ��-------------//
	var VouchStateField = new Ext.form.Checkbox({
			id: "VouchStateField",
			name: 'EndSumFlagField',
			fieldLabel: '<div style="padding-top:2px;">����δ����:</div>',
			labelSeparator: '', //ȥ��ð��
			inputValue: 1,
			style: 'border:0;background:none;margin-top:0px;',
			checked: false
		});
	//------------���Ϊ���ҷ�����Ϊ�㲻��ʾ��ѡ��-------------//
	var EndSumFlagField = new Ext.form.Checkbox({
			id: "EndSumFlagField",
			fieldLabel: '<div style="padding-top:2px;">���Ϊ0�ҷ�����Ϊ0����ʾ:</div>',
			labelSeparator: '', //ȥ��ð��
			inputValue: 1,
			style: 'border:0;background:none;margin-top:0px;',
			checked: false
		});

	//////////////��Ŀ���˽��ʽ���������ʽ����ҽ��ʽ��ѯ����end//////////


	var frm = new Ext.form.FormPanel({

			title: '��ѯ����',
			iconCls:'find',
			width: 480,
			frame: true,
			region: 'east',
			// labelAlign: 'right',
			// labelWidth : 115,
			// buttonAlign: 'center',
			defaults: {
				style: 'padding:5px 0 0 5px;'
			},
			closable: true, //������ԾͿ��Կ��ƹرո�from
			items: [{
					xtype: 'panel',
					layout: 'column',
					columnWidth: 1,
					// width: 500,
					items: [{
							xtype: 'tbtext',
							text: '��Ŀ��Χ',
							style: 'text-align:right;padding:5px;',
							columnWidth: .7
						}, SubjCodeNameField1]
				}, {
					xtype: 'panel',
					layout: 'column',
					columnWidth: 1,
					// width: 400,
					items: [{
							xtype: 'tbtext',
							text: '',
							style: 'text-align:right;padding:5px;',
							columnWidth: .7
						}, SubjCodeNameField2]
				}, {
					xtype: 'panel',
					layout: 'column',
					columnWidth: 1,
					// width: 400,
					items: [{
							xtype: 'tbtext',
							text: '��Ŀ����',
							style: 'text-align:right;padding:5px;',
							columnWidth: .5
						}, SubjLevelField]
				}, {
					xtype: 'panel',
					layout: 'column',
					columnWidth: 1,
					// width: 400,
					items: [{
							xtype: 'tbtext',
							text: '�������',
							style: 'text-align:right;padding:5px;',
							columnWidth: .5
						}, AcctYearField]
				}, {
					xtype: 'panel',
					layout: 'column',
					columnWidth: 1,
					// width: 400,
					items: [{
							xtype: 'tbtext',
							text: '',
							style: 'text-align:right;padding:5px;',
							columnWidth: .5
						}, AcctMonthField]
				}, {
					xtype: 'panel',
					layout: 'column',
					columnWidth: 1,
					// width: 400,
					items: [{
							xtype: 'tbtext',
							text: '����δ����',
							style: 'text-align:right;padding:2px 5px;',
							columnWidth: .42
						}, VouchStateField
					]
				}, {
					xtype: 'panel',
					layout: 'column',
					columnWidth: 1,
					// width: 400,
					items: [{
							xtype: 'tbtext',
							text: '���Ϊ0�ҷ�����Ϊ0����ʾ',
							style: 'text-align:right;padding:2px 5px;',
							columnWidth: .42
						}, EndSumFlagField
					]
				},  {
					xtype: 'panel',
					layout: 'column',
					columnWidth: 1,
					// width: 400,
					items: [{
							xtype: 'button',
							style: "marginLeft:40%;", //marginLeft:170px
							width: 55,
							iconCls: 'find',
							text: '��ѯ',
							handler: function () {

								FindQuery();
							}
						}
					]
				}
			]

		});


	SchemGrid.on('rowclick', function (grid, rowIndex, e) {
		var object = SchemGrid.getSelectionModel().getSelections();
		var id = object[0].get("rowid");
		if (id == "" || id == null || id == undefined) {
			SchemGrid.edit = true;
		} else {
			var SchemDesc = object[0].get("desc");
			var arr = SchemDesc.split(";");
			SubjCodeNameField1.setValue(arr[0]);
			SubjCodeNameField2.setValue(arr[1]);
			SubjLevelField.setValue(arr[2]);
			AcctYearField.setValue(arr[3]);
			AcctMonthField.setValue(arr[4]);
			if (arr[5] == 1) {
				VouchStateField.setValue(1);
			} else {
				VouchStateField.setValue(0);
			}
			if (arr[6] == 1) {
				EndSumFlagField.setValue(1);
			} else {
				EndSumFlagField.setValue(0);
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
			width: 950,
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

		//
		var AcctSubjCode1 = Ext.getCmp('SubjCodeNameField1').getValue();
		AcctSubjCode1 = AcctSubjCode1.split(" ")[0];
		var AcctSubjCode2 = Ext.getCmp('SubjCodeNameField2').getValue();
		AcctSubjCode2 = AcctSubjCode2.split(" ")[0];
		var SubjLevel = Ext.getCmp('SubjLevelField').getValue();
		var AcctYear = Ext.getCmp('AcctYearField').getValue();
		var AcctMonth = Ext.getCmp('AcctMonthField').getValue();
		var VouchState = VouchStateField.getValue();
		if (VouchState == "")
			VouchState = 0;
		else
			VouchState = 1;
		var EndSumFlag = EndSumFlagField.getValue();
		if (EndSumFlag == "")
			EndSumFlag = 0;
		else
			EndSumFlag = 1;
		window.close();
		var reportFrame = document.getElementById("frameReport");
		var p_URL = "";
		//��ȡ����·��
		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.AcctSubjCurAmountForm.raq&AcctSubjCode1=' + AcctSubjCode1 + '&AcctSubjCode2=' + AcctSubjCode2
			 + '&SubjLevel=' + SubjLevel + '&Year=' + AcctYear + '&Month=' + AcctMonth + '&VouchState=' + VouchState + '&EndSumFlag=' + EndSumFlag + '&USERID=' + userdr;
		reportFrame.src = p_URL;

	}

}
