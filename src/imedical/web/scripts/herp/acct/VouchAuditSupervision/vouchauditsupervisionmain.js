var userid = session['LOGON.USERID'];
var bookID = IsExistAcctBook();
var projUrl = 'herp.acct.vouchauditsupervisionexe.csp';
var Myvouchno = "";
//��ʼʱ��
var StartYMField = new Ext.form.DateField({
		id: 'StartYMField',
		fieldLabel: '��ʼ�·�',
		format: 'Y-m',
		width: 100,
		emptyText: '',
		plugins: 'monthPickerPlugin'
	});

//����ʱ��
var EndYMField = new Ext.form.DateField({
		id: 'EndYMField',
		fieldLabel: '--',
		format: 'Y-m',
		width: 100,
		emptyText: '',
		plugins: 'monthPickerPlugin'
	});

//�����Ա
var UserNameDs = new Ext.data.Store({
		autoLoad: true,
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['AcctBookID', 'AcctUserID', 'AcctUserName'])
	});
UserNameDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=getopeatorname&bookID=' + bookID + '&str=' + encodeURIComponent(Ext.getCmp('AcctUser').getRawValue()),
			method: 'POST'
		});
});
var AcctUser = new Ext.form.ComboBox({
		id: 'AcctUser',
		fieldLabel: '�����Ա',
		width: 120,
		listWidth: 260,
		allowBlank: true,
		store: UserNameDs,
		valueField: 'AcctUserID',
		displayField: 'AcctUserName',
		triggerAction: 'all',
		name: 'VouchSubj',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

/////////////////////��ʾ��ʽ
var typeStore = new Ext.data.SimpleStore({
		fields: ['rowid', 'method'],
		data: [['1', '���ϺͲ��ϸ�ƾ֤��¼'], ['2', 'ƾ֤�Ų�������֤']]
	});
var typenameCombo = new Ext.form.ComboBox({
		id: 'typenameCombo',
		fieldLabel: 'ƾ֤��ܺ����',
		width: 180,
		listWidth: 180,
		selectOnFocus: true,
		allowBlank: true,
		store: typeStore,
		// anchor: '90%',
		value: 1, //Ĭ��ֵ
		valueNotFoundText: '',
		displayField: 'method',
		valueField: 'rowid',
		triggerAction: 'all',
		emptyText: '',
		mode: 'local', // ����ģʽ
		editable: false,
		listeners: {
			'select': function () {
				var tmpDataMapping = [];
				var tmpUrl = "",
				StYM = "",
				EndYM = "";
				var yearmonthS = StartYMField.getValue();
				if (yearmonthS !== "") {
					StYM = yearmonthS.format('Y-m');
				}

				var yearmonthE = EndYMField.getValue();
				if (yearmonthE !== "") {
					EndYM = yearmonthE.format('Y-m');
				}
				var Operator = AcctUser.getValue();
				var OperatorName = AcctUser.getRawValue();
				var data = StYM + "^" + EndYM + "^" + Operator;

				if (typenameCombo.getValue() == 1) {
					itemGrid.setTitle("���ϺͲ��ϸ�ƾ֤��¼");
					// type = 1;
					SerialButton.setVisible(false); //����Ϊ������
					for (var i = 1; i < cmItemsA.length; i++) {
						tmpDataMapping.push(cmItemsA[i].dataIndex);
					}
					tmpUrl = projUrl + '?action=listRec' + '&bookID=' + bookID + '&data=' + data;
					itemGrid.url = tmpUrl;
					tmpColumnModel = new Ext.grid.ColumnModel(cmItemsA);
				}
				if (typenameCombo.getValue() == 2) {
					itemGrid.setTitle("ƾ֤�Ų��������");
					// type = 2;
					SerialButton.setVisible(true); //����Ϊ����
					// StartYMField.hide(true);
					for (var i = 1; i < cmItemsB.length; i++) {
						tmpDataMapping.push(cmItemsB[i].dataIndex);
					}
					tmpUrl = projUrl + '?action=listserial' + '&bookID=' + bookID + '&data=' + data;
					itemGrid.url = tmpUrl;
					tmpColumnModel = new Ext.grid.ColumnModel(cmItemsB);
				}

				VouchASDs.proxy = new Ext.data.HttpProxy({
						url: tmpUrl,
						method: 'POST'
					})
					VouchASDs.reader = new Ext.data.JsonReader({
						totalProperty: "results",
						root: 'rows'
					}, tmpDataMapping);

				itemGrid.store.removeAll();
				itemGrid.reconfigure(VouchASDs, tmpColumnModel);
				itemGrid.store.load({
					params: {
						start: 0,
						limit: 25,
						data: data,
						bookID: bookID,
						userid: userid
					}
				});

			}

		}
	});

//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
		iconCls: 'find',
		width: 55,
		handler: function () {
			var tmpDataMapping = [];
			var tmpUrl = "",
			StYM = "",
			EndYM = "";
			var yearmonthS = StartYMField.getValue();
			if (yearmonthS !== "") {
				StYM = yearmonthS.format('Y-m');
			}

			var yearmonthE = EndYMField.getValue();
			if (yearmonthE !== "") {
				EndYM = yearmonthE.format('Y-m');
			}
			var Operator = AcctUser.getValue();
			var OperatorName = AcctUser.getRawValue();
			var data = StYM + "^" + EndYM + "^" + Operator;
			if (typenameCombo.getValue() == 1) {
				itemGrid.setTitle("���ϺͲ��ϸ�ƾ֤��¼");
				// type = 1;
				for (var i = 1; i < cmItemsA.length; i++) {
					//alert(cmItems[i].dataIndex);
					tmpDataMapping.push(cmItemsA[i].dataIndex);
				}
				tmpUrl = projUrl + '?action=listRec' + '&data=' + data + '&bookID=' + bookID;
				itemGrid.url = tmpUrl;
				var tmpColumnModel = new Ext.grid.ColumnModel(cmItemsA);
			} else {
				itemGrid.setTitle("ƾ֤�Ų��������");
				// type = 2;
				for (var i = 1; i < cmItemsB.length; i++) {
					tmpDataMapping.push(cmItemsB[i].dataIndex);
				}
				tmpUrl = projUrl + '?action=listserial' + '&data=' + data + '&bookID=' + bookID;
				itemGrid.url = tmpUrl;
				var tmpColumnModel = new Ext.grid.ColumnModel(cmItemsB);
			}

			VouchASDs.proxy = new Ext.data.HttpProxy({
					url: tmpUrl,
					method: 'POST'
				})
				VouchASDs.reader = new Ext.data.JsonReader({
					totalProperty: "results",
					root: 'rows'
				}, tmpDataMapping);

			itemGrid.reconfigure(VouchASDs, tmpColumnModel);
			itemGrid.store.load({
				params: {
					start: 0,
					limit: 25,
					data: data,
					bookID: bookID,
					userid: userid
				}
			});
		}
	});

//ƾ֤�Ų�������� ��ť
var SerialButton = new Ext.Toolbar.Button({
		hidden: true,
		text: 'ƾ֤�Ų��������',
		tooltip: 'ƾ֤�Ų��������', //��ͣ��ʾ
		iconCls: 'add',
		handler: function () {
			var tmpUrl = "",
			StYM = "",
			EndYM = "";
			var yearmonthS = StartYMField.getValue();
			if (yearmonthS !== "") {
				StYM = yearmonthS.format('Y-m');
			}

			var yearmonthE = EndYMField.getValue();
			if (yearmonthE !== "") {
				EndYM = yearmonthE.format('Y-m');
			}
			var Operator = AcctUser.getValue();
			var OperatorName = AcctUser.getRawValue();
			var data = StYM + "^" + EndYM + "^" + Operator;
			Ext.Ajax.request({
				async: false,
				url: projUrl + '?action=checknoserial&bookID=' + bookID + '&data=' + data,
				waitMsg: '������...',
				success: function (result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Mymessage = jsonData.info;
						Myvouchno = Mymessage.split(" ")[1];
						Ext.Msg.show({
							title: '����',
							msg: 'ע��: ' + '<span style="color:red;">' + Mymessage + '</span>   ',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.ERROR
						});

						itemGrid.store.load({
							params: {
								start: 0,
								limit: 25
							}
						});
						return;
					}
				}
			});

		}
	});

//��ʾ���
var VouchASProxy = new Ext.data.HttpProxy({
		url: projUrl + '?action=listRec&bookID=' + bookID,
		method: 'POST'
	});
var VouchASDs = new Ext.data.Store({
		proxy: VouchASProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, ['AcctYear', 'AcctMonth', 'AcctBookID', 'NumIsCancel', 'NumVouchState', 'OperatorID', 'OperatorName']),
		remoteSort: true
	});

var VouchASCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				id: 'AcctYear',
				header: '��',
				align: 'center',
				width: 100,
				editable: false,
				dataIndex: 'AcctYear'

			}, {
				id: 'AcctMonth',
				header: '��',
				align: 'center',
				width: 100,
				editable: false,
				dataIndex: 'AcctMonth'
			}, {
				id: 'AcctBookID',
				header: '����',
				align: 'center',
				width: 150,
				hidden: true,
				editable: false,
				dataIndex: 'AcctBookID'
			}, {
				id: 'OperatorID',
				header: '������',
				align: 'center',
				width: 100,
				hidden: true,
				editable: false,
				dataIndex: 'OperatorID'
			}, {
				id: 'OperatorName',
				header: '������Ա',
				align: 'center',
				width: 150,
				editable: false,
				dataIndex: 'OperatorName'
			}, {
				id: 'NumIsCancel',
				header: '����ƾ֤����',
				align: 'center',
				width: 120,
				editable: false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					// alert(value)
					if (value != 0)
						return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
					return value;
				},
				dataIndex: 'NumIsCancel'
			}, {
				id: 'NumVouchState',
				header: '��˲�ͨ������',
				align: 'center',
				width: 120,
				editable: false,
				dataIndex: 'NumVouchState',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					// alert(value)
					if (value != 0)
						return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
					return value;
				}
			}
		]);

//��ҳ����
var VouchASPagTba = new Ext.PagingToolbar({
		store: VouchASDs,
		pageSize: 25,
		displayInfo: true,
		// plugins : new dhc.herp.PageSizePlugin(),
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û�м�¼"
	});

var queryPanel = new Ext.FormPanel({
		region: 'north',
		height: 45,
		frame: true,
		defaults: {
			labelAlign: 'right', //��ǩ���뷽ʽ
			labelSeparator: ' ', //�ָ���
			border: false,
			bodyStyle: 'padding:5px;'
		},
		width: 1200,
		layout: 'column',
		items: [{
				labelWidth: 110,
				// labelAlign: 'left',
				xtype: 'fieldset',
				width: 330,
				items: typenameCombo
			}, {
				xtype: 'fieldset',
				labelWidth: 60,
				width: 200,
				items: StartYMField
			},{
				xtype: 'fieldset',
				labelWidth: 25,
				style:'margin-left:-25px;',
				width: 170,
				items: EndYMField
			}, {
				xtype: 'fieldset',
				labelWidth: 60,
				width: 220,
				items: AcctUser
			}, {
				xtype: 'fieldset',
			    labelWidth: 10,
				width: 80,
				items: findButton
			}, {
				xtype: 'fieldset',
				labelWidth: 20,
				width: 165,
				items: SerialButton
			}
		]
	});

//
var itemGrid = new Ext.grid.EditorGridPanel({
		title:'ƾ֤��ܺ�����б�',
		iconCls:'list',
		region: 'center',
		pageSize: 25,
		atLoad: true,
		store: VouchASDs,
		cm: VouchASCm,
		clicksToEdit: 1,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.CheckboxSelectionModel({
			singleSelect: false
		}),
		bbar: VouchASPagTba,
		// tbar: ['����ѡ��:', typenameCombo, '��ʼ����:', StartYMField, '��������:', EndYMField, '������:', AcctUser, '-', findButton, '-', SerialButton],
		viewConfig: { //forceFit : true,   //����ҳ��ȫ�ֱ�����ʹҳ��ÿ�а��ն�Ӧ�ı�����������
			//scrollOffset: 20,//��ʾ����Ҳ�Ϊ������Ԥ���Ŀ��
			/*���������ı�Ҫ���еı���ɫ��
			��Ҫ����ҳ���½�һ��css���磺
			<style type="text/css">
			.my_row_style table{ background:Yellow}
			</style>
			Ȼ��������ķ��������ʵ���ˣ�
			 */
			getRowClass: function (record, rowIndex, rowParams, store) {
				if (record.data.VouchNo == Myvouchno) {
					return "my_row_style";
				}
				/*
				if (record.data.VouchNo == "1") {
				return "my_row_styleblue";
				}
				 */
			}
		},
		loadMask: true
	});
itemGrid.store.load({
	params: {
		start: 0,
		limit: 25
	}
});

//ƾ֤��ܺ����
var cmItemsA = [
	new Ext.grid.RowNumberer(), {
		id: 'AcctYear',
		header: '��',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'AcctYear'

	}, {
		id: 'AcctMonth',
		header: '��',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'AcctMonth'

	}, {
		id: 'AcctBookID',
		header: '����',
		align: 'center',
		width: 150,
		hidden: true,
		editable: false,
		dataIndex: 'AcctBookID'

	}, {
		id: 'OperatorID',
		header: '������ID',
		align: 'center',
		width: 100,
		hidden: true,
		editable: false,
		dataIndex: 'OperatorID'

	}, {
		id: 'OperatorName',
		header: '������Ա',
		align: 'center',
		width: 150,
		editable: false,
		dataIndex: 'OperatorName'

	}, {
		id: 'NumIsCancel',
		header: '����ƾ֤����',
		align: 'center',
		width: 120,
		editable: false,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			if (value != 0)
				return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
			return value;
		},
		dataIndex: 'NumIsCancel'

	}, {
		id: 'NumVouchState',
		header: '��˲�ͨ������',
		align: 'center',
		width: 120,
		editable: false,
		dataIndex: 'NumVouchState',
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			// alert(value)
			if (value != 0)
				return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
			return value;
		}
	}
];

//ƾ֤�Ų��������
//AcctVouchID^VouchNo^AcctYear^AcctMonth^AcctBookID^IsCancel^CancelDate^VouchState^OperatorID^OperatorName^MakeBillDate
var cmItemsB = [
	new Ext.grid.RowNumberer(), {
		id: 'AcctVouchID',
		header: 'ƾ֤ID',
		align: 'center',
		width: 100,
		hidden: true,
		editable: false,
		dataIndex: 'AcctVouchID'
	}, {
		id: 'VouchNo',
		header: 'ƾ֤��',
		align: 'center',
		width: 120,
		editable: false,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			if (value)
				return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
		},
		dataIndex: 'VouchNo'
	}, {
		id: 'AcctYear',
		header: '��',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'AcctYear'
	}, {
		id: 'AcctMonth',
		header: '��',
		align: 'center',
		width: 80,
		editable: false,
		dataIndex: 'AcctMonth'
	}, {
		id: 'MakeBillDate',
		header: '�Ƶ�����',
		align: 'center',
		width: 110,
		editable: false,
		dataIndex: 'MakeBillDate'
	}, {
		id: 'IsCancel',
		header: 'ƾ֤����',
		align: 'center',
		width: 100,
		hidden: true,
		editable: false,
		dataIndex: 'IsCancel'
	}, {
		id: 'IsCancelWord',
		header: 'ƾ֤����',
		align: 'center',
		width: 100,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			if (value)
				return '<span style="color:red;">' + value + '</span>';
		},
		editable: false,
		dataIndex: 'IsCancelWord'
	}, {
		id: 'CancelDate',
		header: '��������',
		align: 'center',
		width: 100,
		hidden: true,
		editable: false,
		dataIndex: 'CancelDate'
	}, {
		id: 'VouchState',
		header: 'ƾ֤״̬',
		align: 'center',
		width: 100,
		hidden: true,
		editable: false,
		dataIndex: 'VouchState'
	}, {
		id: 'VouchStateWord',
		header: 'ƾ֤״̬',
		align: 'center',
		width: 100,
		// hidden:true,
		editable: false,
		dataIndex: 'VouchStateWord'
	}, {
		id: 'OperatorID',
		header: '������ID',
		align: 'center',
		width: 100,
		hidden: true,
		editable: false,
		dataIndex: 'OperatorID'
	}, {
		id: 'OperatorName',
		header: '������(�Ƶ���)',
		align: 'center',
		width: 180,
		editable: false,
		dataIndex: 'OperatorName'
	}
];
//ƾ֤����
itemGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {

	var linknum = typenameCombo.getValue();
	var records = itemGrid.getSelectionModel().getSelections();
	if (linknum == 2) {
		//ƾ֤�ŵ�����
		if (columnIndex == '2') {
			//p_URL = 'acct.html?acctno=2';
			//document.getElementById("frameReport").src='acct.html';
			var VouchNo = records[0].get("VouchNo");
			var VouchState = records[0].get("VouchState");
			var myPanel = new Ext.Panel({
					layout: 'fit',
					//scrolling="auto",
					html: '<iframe id="frameReport" style="margin-top:-3px" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + userid + '&acctstate=' + '11' + '&bookID=' + bookID + '&searchFlag=' + 1 + '" /></iframe>'
					//frame : true
				});
			var win = new Ext.Window({
					title: 'ƾ֤�鿴',
					width: 1093,
					height: 620,
					resizable: false,
					closable: true,
					draggable: true,
					resizable: false,
					layout: 'fit',
					modal: false,
					plain: true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
					//bodyStyle : 'padding:5px;',
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
	} else if (linknum == 1) {

		//����ƾ֤����������
		if (columnIndex == 6) {
			if (records[0].get("NumIsCancel") != 0) {
				var AcctYear = records[0].get("AcctYear");
				var AcctMonth = records[0].get("AcctMonth");
				var OperatorID = records[0].get("OperatorID");
				var data = AcctYear + "^" + AcctMonth + "^" + OperatorID;
				LinkCancelVouch(data);

			}
		}

		//��˲�ͨ����������
		if (columnIndex == 7) {
			if (records[0].get("NumVouchState") != 0) {
				var AcctYear = records[0].get("AcctYear");
				var AcctMonth = records[0].get("AcctMonth");
				var OperatorID = records[0].get("OperatorID");
				var data = AcctYear + "^" + AcctMonth + "^" + OperatorID;

				LinkNotPassVouch(data);

			}
		}
	}

});
