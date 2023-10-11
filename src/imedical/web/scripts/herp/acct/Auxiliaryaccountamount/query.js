function Query() {

	////Schem	������ѯ������grid
	var SchemGrid = new dhc.herp.Grid({
			title: '��ѯ����ά��',
			iconCls:'maintain',
			region: 'center',
			url: 'herp.acct.Auxiliaryaccountamountexe.csp',
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
					align: 'left',
					dataIndex: 'code'

				}, {
					id: 'name',
					header: '<div style="text-align:center">��������</div>',
					allowBlank:false,
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

	//SchemGrid.addButton('-');
	//SchemGrid.addButton('<div style="color:red">˵��������������-���ʽ�ķ��������ZB1101��ͷ��</div>');
	SchemGrid.btnResetHide() //�������ð�ť
	SchemGrid.btnPrintHide() //���ش�ӡ��ť
	//=================================��ѯ���� FormPanel==========================//
	//�ڼ䷶Χ

	var StartDate = new Ext.form.DateField({
			id: 'StartDate',
			name: 'StartDate',
			fieldLabel: '��ʼ����',
			labelSeparator:'',
			emptyMsg: "",
			format: 'Y-m',
			width: 100,
			triggerAction: 'all',
			allowBlank: true,
			plugins: 'monthPickerPlugin'
		});
	var EndDate = new Ext.form.DateField({
			id: 'EndDate',
			name: 'EndDate',
			fieldLabel: '��ֹ����',
			labelSeparator:'',
			emptyMsg: "",
			format: 'Y-m',
			width: 100,
			triggerAction: 'all',
			allowBlank: true,
			plugins: 'monthPickerPlugin'
		});
	//----------------- ���������Ŀ---------------//
	//���������Ŀstore
	var AcctSubjDs = new Ext.data.Store({
			//autoLoad:true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'name'])
		});
	AcctSubjDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: '../csp/herp.acct.Auxiliaryaccountamountexe.csp?action=GetAcctSubj&bookId=' + bookID,
				method: 'POST'
			});
	});
	//���������ĿComboBox
	var AcctSubj = new Ext.form.ComboBox({
			id: 'AcctSubj',
			fieldLabel: '���������Ŀ',
			store: AcctSubjDs,
			emptyText: '��ѡ���������Ŀ...',
			labelSeparator:'',
			valueField: 'rowid',
			displayField: 'name',
			width: 245,
			listWidth: 500,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true,
			editable: true,
			//resizable:true,
			typeAhead: true,
			listeners: {
				select: function () {
					var AcctSubjID = Ext.getCmp('AcctSubj').getValue();
					if (AcctSubjID != "") {
						Ext.getCmp('CheckType').clearValue();
						Ext.getCmp('CheckItem').clearValue();
					}
					CheckTypeDs.on('beforeload', function (ds, o) {
						ds.proxy = new Ext.data.HttpProxy({
								url: '../csp/herp.acct.Auxiliaryaccountamountexe.csp?action=GetCheckType&AcctSubjID=' + Ext.getCmp('AcctSubj').getValue()+
						'&bookId=' + bookID,
								method: 'POST'
							});
					});
					CheckType.setValue("");
					CheckTypeDs.load({
						params: {
							start: 0,
							limit: 10
						}
					});
				}
			}
		});

	//----------------- ������������-----------------//
	var CheckTypeDs = new Ext.data.Store({
			//autoLoad:true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'name'])
			//remoteSort: false
		});
	CheckTypeDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: '../csp/herp.acct.Auxiliaryaccountamountexe.csp?action=GetCheckType&AcctSubjID=' + Ext.getCmp('AcctSubj').getValue()+
						'&bookId=' + bookID,
				method: 'POST'
			});
	});
	//������������ComboBox
	var CheckType = new Ext.form.ComboBox({
			fieldLabel: '������������',
			id: 'CheckType',
			emptyText: '��ѡ������������...',
			store: CheckTypeDs,
			valueField: 'rowid',
			labelSeparator:'',
			displayField: 'name',
			width: 245,
			listWidth: 250,
			triggerAction: 'all',
			//mode: 'local', //����ģʽ
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true,
			editable: true,
			//resizable:true,
			typeAhead: true,
			listeners: {
				select: function () {
					var AcctCheckTypeID = Ext.getCmp('CheckType').getValue();
					var IsValid = Ext.getCmp('IsValid').getValue();
					CheckItemDs.on('beforeload', function (ds, o) {
						ds.proxy = new Ext.data.HttpProxy({
								url: '../csp/herp.acct.Auxiliaryaccountamountexe.csp?action=GetCheckItem&AcctCheckTypeID=' + Ext.getCmp('CheckType').getValue() +
								'&IsValid=' + Ext.getCmp('IsValid').getValue() + '&bookId=' + bookID,
								method: 'POST'
							});
					});
					CheckItem.setValue("");
					CheckItemDs.load({
						params: {
							start: 0,
							limit: 10
						}
					});
				}
			}
		});

	//----------------- ����������-----------------//
	var CheckItemDs = new Ext.data.Store({
			//autoLoad:true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'name'])
		});
	CheckItemDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: '../csp/herp.acct.Auxiliaryaccountamountexe.csp?action=GetCheckItem&AcctCheckTypeID=' + Ext.getCmp('CheckType').getValue() +
				'&IsValid=' + Ext.getCmp('IsValid').getValue() + '&bookId=' + bookID,
				method: 'POST'
			});
	});
	//����������
	var CheckItem = new Ext.form.ComboBox({
			fieldLabel: '����������',
			id: 'CheckItem',
			labelSeparator:'',
			emptyText: '��ѡ����������...',
			store: CheckItemDs,
			valueField: 'rowid',
			displayField: 'name',
			width: 245,
			listWidth: 300,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true,
			editable: true,
			typeAhead: true
		});

	//----------------- ����ͣ�ø���������-----------------//
	var IsValid = new Ext.form.Checkbox({
			fieldLabel: '����ͣ�ø���������',
			id: 'IsValid',
			labelSeparator:'',
			name: 'IsValid',
			style: 'border:0;background:none;margin-top:0px;',
			//checked:true,
			labelAlign: 'right'
		});
	//----------------- ����δ����ƾ֤-----------------//
	var VouchState = new Ext.form.Checkbox({
			fieldLabel: '����δ����ƾ֤',
			id: 'VouchState',
			labelSeparator:'',
			name: 'VouchState',
			style: 'border:0;background:none;margin-top:0px;',
			labelAlign: 'right'
		});
	//----------------- ���Ϊ���ҷ�����Ϊ�㲻��ʾ-----------------//
	var IsZero = new Ext.form.Checkbox({
			fieldLabel: '���Ϊ0�ҷ�����Ϊ0����ʾ',
			id: 'IsZero',
			name: 'IsZero',
			labelSeparator:'',
			style: 'border:0;background:none;margin-top:0px;',
			labelAlign: 'right'
		});
	//----------------- �������n������������-----------------//
	var IsTop = new Ext.form.TextField({
			id: 'IsTop',
			width: 100,
			triggerAction: 'all',
			labelSeparator:'',
			fieldLabel: '�����������������',
			style: 'text-align:left',
			name: 'IsTop',
			editable: true
		});
	//////////////����������-���ʽ��ѯ����end//////////
	var frm = new Ext.form.FormPanel({

			labelAlign: 'right',
			title: '��ѯ����',
			iconCls:'find',
			width: 470,
			frame: true,
			region: 'east',
			labelWidth: 180,
			//buttonAlign: 'center',

			//closable: true, //������ԾͿ��Կ��ƹرո�from
			items: [{
					xtype: 'fieldset',
					//title : '��������',
					style:'padding:5px;',
					items: [StartDate, EndDate, IsTop, AcctSubj, CheckType, CheckItem, IsValid, VouchState, IsZero]
				}, {
					xtype: 'button',
					//margin-top:12,
					//style:"margin:auto;",
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
			//alert(SchemDesc);
			var arr = SchemDesc.split(";");
			var startdate = arr[0];
			var enddate = arr[1];
			//var acctsubj = arr[2];
			//var checktype=arr[3];
			//var checkitem=arr[4];
			var isvalid = arr[5];
			var istop = arr[6];
			var vouchstate = arr[7];
			var iszero = arr[8];

			if (arr != "") {
				var acctsubj = arr[2];
				var AcctSubjID = acctsubj.split("-")[0];
				var checktype = arr[3];
				var AcctCheckTypeID = checktype.split(" ")[0];
			}

			AcctSubjDs.load({
				params: {
					start: 0,
					limit: 10
				}
			});
			CheckTypeDs.on('beforeload', function (ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
					url: '../csp/herp.acct.Auxiliaryaccountamountexe.csp?action=GetCheckType&AcctSubjID=' + AcctSubjID+
						'&bookId=' + bookID,
					method: 'POST'
				});
			});
			CheckItemDs.on('beforeload', function (ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
					url: '../csp/herp.acct.Auxiliaryaccountamountexe.csp?action=GetCheckItem&AcctCheckTypeID=' + AcctCheckTypeID +
					'&IsValid=' + isvalid + '&bookId=' + bookID,
					method: 'POST'
				});
			});
			setTimeout(function () {
				StartDate.setValue(startdate);
				EndDate.setValue(enddate);
				AcctSubj.setValue(acctsubj);
				CheckType.setValue(arr[3]);
				CheckItem.setValue(arr[4]);
				IsValid.setValue(isvalid);
				IsTop.setValue(istop);
				VouchState.setValue(vouchstate);
				IsZero.setValue(iszero);
			}, 200);
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
		var StartDate = Ext.getCmp('StartDate').getRawValue();
		var EndDate = Ext.getCmp('EndDate').getRawValue();
		var AcctSubj = Ext.getCmp('AcctSubj').getValue();
		AcctSubj = AcctSubj.split("-")[0];
		var CheckType = Ext.getCmp('CheckType').getValue();
		CheckType = CheckType.split(" ")[0];
		var CheckItem = Ext.getCmp('CheckItem').getValue();
		CheckItem = CheckItem.split(" ")[0];
		var IsValid = Ext.getCmp('IsValid').getValue();
		var VouchState = Ext.getCmp('VouchState').getValue();
		var IsZero = Ext.getCmp('IsZero').getValue();
		var IsTop = Ext.getCmp('IsTop').getValue();
		//alert(CheckItem)

		window.close();
		var reportFrame = document.getElementById("frameReport");
		var p_URL = "";
		//��ȡ����·��
		//SubjName,StartDate,EndDate,VouchState,IsZero,CheckType,CheckItem,IsValid,IsTop,USERID
		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.uAuxiliaryaccountamount.raq&SubjName=' + AcctSubj + '&StartDate=' + StartDate +
			'&EndDate=' + EndDate + '&VouchState=' + VouchState + '&IsZero=' + IsZero + '&CheckType=' + CheckType + '&CheckItem=' + CheckItem +
			'&IsValid=' + IsValid + '&IsTop=' + IsTop + '&USERID=' + userdr;
		reportFrame.src = p_URL;

	}

}
