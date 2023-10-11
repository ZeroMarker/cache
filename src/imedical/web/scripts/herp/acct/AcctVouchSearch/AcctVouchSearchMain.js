var userid = session['LOGON.USERID'];
var bookID = IsExistAcctBook();
projUrl = 'herp.acct.acctvouchsearchexe.csp';
/////////////ƾ֤����
var VouchTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['rowid', 'name'])
	});
VouchTypeDs.on('beforeload', function (ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=GetVouchType&str=' + encodeURIComponent(Ext.getCmp('VouchTypeCombo').getRawValue()),
			method: 'POST'
		});
});
var VouchTypeCombo = new Ext.form.ComboBox({
		id: 'VouchTypeCombo',
		fieldLabel: 'ƾ֤����',
		store: VouchTypeDs,
		valueField: 'rowid',
		displayField: 'name',
		typeAhead: true,
		triggerAction: 'all',
		emptyText: '��ѡ������',
		width: 180,
		listWidth: 230,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		editable: true,
		forceSelection: 'true'
	});

/* 	 var firstDate = new Date();
firstDate.setDate(1); //��һ��
var sd=firstDate.format("Y-m-d");
//alert(dd);
var endDate = new Date(firstDate);
endDate.setMonth(firstDate.getMonth()+1);
endDate.setDate(0);
var ed=endDate.format("Y-m-d"); */
//alert(ed);

//////ƾ֤����ʱ�䷶Χ
var VouchDateStartField = new Ext.form.DateField({
		fieldLabel: 'ƾ֤���ڿ�ʼʱ��',
		id: 'VouchDateStartField',
		//value:sd,
		//format : 'Y-m-d',
		width: 120,
		emptyText: ''
	});

var VouchDateEndField = new Ext.form.DateField({
		fieldLabel: 'ƾ֤���ڽ���ʱ��',
		id: 'VouchDateEndField',
		//value:ed,
		//format : 'Y-m-d',
		width: 120,
		emptyText: ''
	});

Ext.Ajax.request({
	url: projUrl + '?action=GetDate&userid=' + userid,
	method: 'GET',
	success: function (result, request) {
		var respText = Ext.util.JSON.decode(result.responseText);
		date = respText.info;
		strs = date.split('^');
		sd = strs[0];
		ed = strs[1];
		VouchDateStartField.setValue(sd);
		VouchDateEndField.setValue(ed);
	},
	failure: function (result, request) {
		return;
	}
});

/////////////////////ƾ֤�ŷ�Χ/////////////////////////
VouchNoMax = new Ext.form.TextField({
		fieldLabel: 'ƾ֤���',
		width: 120,
		hideLabel: false,
		//columnWidth : .142,
		selectOnFocus: true
	});
VouchNoMin = new Ext.form.TextField({
		fieldLabel: 'ƾ֤���',
		width: 120,
		//columnWidth : .142,
		selectOnFocus: true
	});
/////////ƾ֤����״̬
var StateStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [['0', '����'], ['05', '��˲�ͨ��'], ['11', '�ύ'], ['12', '����'],
			['21', '���ͨ��'], ['31', '����'], ['41', '����']]
	});
var StateField = new Ext.form.ComboBox({
		id: 'State',
		fieldLabel: 'ƾ֤״̬',
		width: 180,
		//columnWidth : .15,
		listWidth: 240,
		selectOnFocus: true,
		// allowBlank: false,
		store: StateStore,
		//value : 0, //Ĭ��ֵ
		anchor: '90%',
		valueNotFoundText: '',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText: '',
		mode: 'local',
		editable: true,
		selectOnFocus: true,
		forceSelection: true
	});

/////////////////////��ʾ��ʽ
var typeStore = new Ext.data.SimpleStore({
		fields: ['rowid', 'method'],
		data: [['1', 'ƾ֤��ʾ'], ['2', 'ƾ֤��¼��ʾ']]
	});
var typenameCombo = new Ext.form.ComboBox({
		id: 'typenameCombo',
		fieldLabel: '��ʾ��ʽ',
		width: 180,
		listWidth: 150,
		selectOnFocus: true,
		allowBlank: true,
		store: typeStore,
		anchor: '90%',
		value: 1, //Ĭ��ֵ
		valueNotFoundText: '',
		displayField: 'method',
		valueField: 'rowid',
		triggerAction: 'all',
		emptyText: '',
		mode: 'local', // ����ģʽ
		editable: false,
		listeners: {
			select: {
				fn: function (value, combo, record, index) {
					if (typenameCombo.getValue() == 1) {
						VouchSummary.disable();
						VouchSubj.disable();
						VouchAmtMax.disable();
						VouchAmtMin.disable();

						VouchSummary.setValue('');
						VouchSubj.setValue('');
						VouchAmtMax.setValue('');
						VouchAmtMin.setValue('');
					} else if (typenameCombo.getValue() == 2) {
						VouchSummary.enable();
						VouchSubj.enable();
						VouchAmtMax.enable();
						VouchAmtMin.enable();

					}
				}
			}
		}
	});
///////ƾ֤ժҪ
var VouchSummary = new Ext.form.TextField({
		fieldLabel: 'ƾ֤ժҪ',
		width: 200,
		//columnWidth : .142,
		selectOnFocus: true
	});

///////����ѯ��Χ
var VouchAmtMin = new Ext.form.TextField({
		fieldLabel: '��Χ',
		width: 120,
		//columnWidth : .142,
		selectOnFocus: true
	});
///////����ѯժҪ
var VouchAmtMax = new Ext.form.TextField({
		fieldLabel: '--',
		width: 120,
		//columnWidth : .142,
		selectOnFocus: true
	});

////��ƿ�Ŀ
var SubjNameDs = new Ext.data.Store({
		autoLoad: true,
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['subjId', 'subjCode', 'subjName', 'subjCodeName', 'subjCodeNameAll'])
	});

SubjNameDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=GetSubj&bookID=' + bookID + '&str=' + encodeURIComponent(Ext.getCmp('VouchSubj').getRawValue()),
			method: 'POST'
		});
});
//Grid���
var VouchSubj = new Ext.form.ComboBox({
		id: 'VouchSubj',
		fieldLabel: '��ƿ�Ŀ',
		width: 200,
		listWidth: 300,
		allowBlank: true,
		store: SubjNameDs,
		valueField: 'subjId',
		displayField: 'subjCodeNameAll',
		triggerAction: 'all',
		//emptyText:'��Ŀ�ֵ���ĩ�����п�Ŀ',
		name: 'VouchSubj',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

//���Ƚ�ֹʹ��
VouchSummary.disable();
VouchSubj.disable();
VouchAmtMax.disable();
VouchAmtMin.disable();

//////��ѯ��ť
var data;
var findButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
		iconCls: 'find',
		width: 80,
		handler: function () {
			var vouchtype = VouchTypeCombo.getValue();
			var vouchdatestart = VouchDateStartField.getValue();
			if (vouchdatestart !== "") {
				vouchdatestart = vouchdatestart.format('Y-m-d');
			}
			var vouchdateend = VouchDateEndField.getValue();
			if (vouchdateend !== "") {
				vouchdateend = vouchdateend.format('Y-m-d');
			}
			var vouchnomax = VouchNoMax.getValue();
			var vouchnomin = VouchNoMin.getValue();
			var state = StateField.getValue();
			var vouchsummary = VouchSummary.getRawValue();
			var vouchsubj = VouchSubj.getValue();
			var vouchAmtmax = VouchAmtMax.getValue();
			var vouchAmtmin = VouchAmtMin.getValue();
			data = vouchtype + "^" + vouchdatestart + "^" + vouchdateend + "^" + vouchnomax + "^" + vouchnomin + "^" + state + "^"
				+vouchsummary + "^" + vouchsubj + "^" + vouchAmtmax + "^" + vouchAmtmin;
			var typename = typenameCombo.getValue();
			// alert(data);
			var tmpDataMapping = [];
			var tmpUrl = ""

				if (typenameCombo.getValue() == 1) {
					itemGrid.setTitle("ƾ֤��ʾ�б�");
					type = 1;
					//VouchSummary.hide();
					//VouchSummary.setDisplayed(false);
					VouchSummary.disable();
					VouchSubj.disable();
					VouchAmtMax.disable();
					VouchAmtMin.disable();

					VouchSummary.setValue('');
					VouchSubj.setValue('');
					VouchAmtMax.setValue('');
					VouchAmtMin.setValue('');
					for (var i = 1; i < cmItems.length; i++) {
						//alert(cmItems[i].dataIndex);
						tmpDataMapping.push(cmItems[i].dataIndex);
					}
					tmpUrl = projUrl + '?action=list'; //+ '&data=' + data + '&userid=' + userid;
					itemGrid.url = tmpUrl;
					var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
				} else {
					itemGrid.setTitle("ƾ֤��¼��ʾ�б�");
					type = 2;
					VouchSummary.enable();
					VouchSubj.enable();
					VouchAmtMax.enable();
					VouchAmtMin.enable();
					for (var i = 1; i < cmItems2.length; i++) {
						tmpDataMapping.push(cmItems2[i].dataIndex);
					}
					tmpUrl = projUrl + '?action=listEntry'; //+ '&data=' + data + '&userid=' + userid;
					itemGrid.url = tmpUrl;
					var tmpColumnModel = new Ext.grid.ColumnModel(cmItems2);
				}
				MoidLogDs.proxy = new Ext.data.HttpProxy({
					url: tmpUrl,
					method: 'POST'
				})

				MoidLogDs.reader = new Ext.data.JsonReader({
					totalProperty: "results",
					root: 'rows'
				}, tmpDataMapping);

			itemGrid.reconfigure(MoidLogDs, tmpColumnModel);
			var limits=Ext.getCmp("PageSizePlugin").getValue();
			 //alert(limits);
	         if(!limits){limits=25};
			itemGrid.store.load({
				params: {
					start: 0,
					limit: limits,
					data: data,
					userid: userid
				}
			});
		}
	});

//��ʾ���
var MoidLogProxy = new Ext.data.HttpProxy({
		url: projUrl + '?action=list&userid=' + userid,
		method: 'POST'
	});
var MoidLogDs = new Ext.data.Store({
		proxy: MoidLogProxy,
		//autoLoad:true,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, ['VouchID', 'AcctYear', 'AcctMonth', 'VouchDate', 'VouchNo', 'typename',
				'Operator', 'MakeBillDate', 'Auditor', 'Poster',
				'VouchState', 'VouchProgress', 'IsDestroy', 'IsCancel', 'VouchState1', 'upload', 'download']),
		// turn on remote sorting
		remoteSort: true
	});

MoidLogDs.on('beforeload', function () {
	// console.log(MoidLogDs);
	MoidLogDs.baseParams.data = MoidLogDs.paramNames.data || data;
	MoidLogDs.baseParams.userid = MoidLogDs.paramNames.userid || userid;
	// console.log(MoidLogDs);
});

var MoidLogCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			//new Ext.grid.CheckboxSelectionModel(),
			{
				id: 'VouchID',
				header: 'ƾ֤��ID',
				editable: false,
				width: 50,
				dataIndex: 'VouchID',
				hidden: true
			}, {
				id: 'AcctYear',
				header: '��',
				align: 'center',
				width: 60,
				editable: false,
				dataIndex: 'AcctYear'

			}, {
				id: 'AcctMonth',
				header: '��',
				align: 'center',
				width: 40,
				editable: false,
				dataIndex: 'AcctMonth'

			}, {
				id: 'VouchDate',
				header: 'ƾ֤����',
				align: 'center',
				width: 100,
				editable: false,
				dataIndex: 'VouchDate'

			}, {
				id: 'VouchNo',
				header: '<div style="text-align:center">ƾ֤��</div>',
				//align: 'center',
				editable: false,
				width: 120,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					var sf = record.data['IsDestroy']
						if (sf == "��") {
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>' + value + '</u></span>' + '<b> </b>'
							 + '<span style="color:red;cursor:hand;backgroundColor:white">��</span>';
						} else {
							return '<span style="color:blue;cursor:hand;backgroundColor:red;src="../scripts/herp/acct/acct.html""><u>' + value + '</u></span>';
						}
				},
				dataIndex: 'VouchNo'

			}, {
				id: 'typename',
				header: 'ƾ֤����',
				align: 'center',
				width: 80,
				editable: false,
				dataIndex: 'typename'
			}, {
				id: 'Operator',
				header: '�Ƶ���',
				align: 'center',
				width: 100,
				editable: false,
				dataIndex: 'Operator'

			}, {
				id: 'MakeBillDate',
				header: '�Ƶ�����',
				align: 'center',
				width: 100,
				editable: false,
				dataIndex: 'MakeBillDate'

			}, {
				id: 'Auditor',
				header: '�����',
				align: 'center',
				width: 100,
				editable: false,
				dataIndex: 'Auditor'

			}, {
				id: 'Poster',
				header: '������',
				align: 'center',
				width: 100,
				editable: false,
				dataIndex: 'Poster'
			}, {
				id: 'VouchState',
				header: 'ƾ֤״̬',
				align: 'center',
				width: 100,
				editable: false,
				dataIndex: 'VouchState'
			}, {
				id: 'VouchProgress',
				header: 'ƾ֤�������',
				align: 'center',
				width: 110,
				editable: false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>';
				},
				dataIndex: 'VouchProgress'
			}, {
				id: 'IsDestroy',
				header: '����',
				align: 'center',
				width: 70,
				editable: false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					var sf = record.data['IsDestroy']
						if (sf == "��") {
							//cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							return '<span style="color:red;backgroundColor:white">' + value + '</span>';
						}
				},
				dataIndex: 'IsDestroy'
			}, {
				id: 'IsCancel',
				header: '����',
				align: 'center',
				width: 70,
				editable: false,
				//hidden: true,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					var sf = record.data['IsCancel']
						if (sf == "��") {
							//cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							return '<span style="color:red;backgroundColor:white">' + value + '</span>';
						}
				},
				dataIndex: 'IsCancel'
			}, {
				id: 'VouchState1',
				header: 'ƾ֤״̬',
				width: 90,
				editable: false,
				hidden: true,
				dataIndex: 'VouchState1'
			}, {
				id: 'upload',
				header: '����',
				hidden: true,
				allowBlank: false,
				width: 40,
				editable: false,
				dataIndex: 'upload',

				renderer: function (v, p, r) {
					return '<span style="color:blue"><u>�ϴ�</u></span>';
				}
			}, {
				id: 'download',
				header: '����',
				allowBlank: false,
				width: 40,
				editable: false,
				hidden: true,
				dataIndex: 'download',
				renderer: function (v, p, r) {
					return '<span style="color:blue"><u>����</u></span>';
				}
			}
		]);

var MoidLogPagTba = new Ext.PagingToolbar({
		store: MoidLogDs,
		pageSize: 25,
		displayInfo: true,
		plugins: new dhc.herp.PageSizePlugin(),
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û�м�¼"
	});

var queryPanel = new Ext.FormPanel({
		//autoHeight : true,
		title: 'ƾ֤��Ϣ��ѯ',
		region: 'north',
		frame: true,
		iconCls: 'find',
		height: 140,
		defaults: {
			bodyStyle: 'padding:5px;'
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				columnWidth: 1,
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: 'ƾ֤��ʾ��ʽ',
						//style: 'padding-top:3px',
						width: 93
					},
					typenameCombo, {
						xtype: 'displayfield',
						value: '',
						width: 60
					}, {
						xtype: 'displayfield',
						value: 'ƾ֤��',
						//style: 'padding-top:3px;',
						width: 50
					},
					VouchNoMax, {
						xtype: 'displayfield',
						value: '--'
					},
					VouchNoMin, {
						xtype: 'displayfield',
						value: '',
						width: 50
					}, {
						xtype: 'displayfield',
						value: '��ƿ�Ŀ',
						//style: 'padding-top:3px;',
						width: 65
					},
					VouchSubj, {
						xtype: 'displayfield',
						value: '',
						width: 30
					},
					findButton
				]
			}, {
				columnWidth: 1,
				xtype: 'panel',
				layout: "column",
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: 'ƾ֤����״̬',
						//style: 'padding-top:3px;',
						width: 93
					},
					StateField, {
						xtype: 'displayfield',
						value: '',
						width: 46
					}, {
						xtype: 'displayfield',
						value: 'ƾ֤����',
						//style: 'padding-top:3px;',
						width: 65
					},
					VouchDateStartField, {
						xtype: 'displayfield',
						value: '--'
					},
					VouchDateEndField, {
						xtype: 'displayfield',
						value: '',
						width: 50
					}, {
						xtype: 'displayfield',
						value: 'ƾ֤ժҪ',
						//style: 'padding-top:3px;',
						width: 65
					},
					VouchSummary

				]
			}, {
				xtype: 'panel',
				layout: 'column',
				columnWidth: 1,
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '',
						width: 28
					}, {
						xtype: 'displayfield',
						value: 'ƾ֤����',
						style: 'padding-top:3px;',
						width: 65
					},
					VouchTypeCombo, {
						xtype: 'displayfield',
						value: '',
						width: 47
					}, {
						xtype: 'displayfield',
						value: '��Χ',
						style: 'padding-top:3px;',
						width: 65
					},
					VouchAmtMin, {
						xtype: 'displayfield',
						value: '--'
					},
					VouchAmtMax, {
						xtype: 'displayfield',
						value: '',
						width: 20
					}

				]
			}
		]
	});
var itemGrid = new Ext.grid.EditorGridPanel({
		title: 'ƾ֤��ʾ�б�',
		iconCls: 'list',
		region: 'center',
		pageSize: 25,
		store: MoidLogDs,
		cm: MoidLogCm,
		//atLoad : true,
		clicksToEdit: 1,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.CheckboxSelectionModel({
			singleSelect: false
		}),
		/* tbar:['ƾ֤����:',VouchTypeCombo,'-','ƾ֤����:',VouchDateStartField,'��',VouchDateEndField,'-','ƾ֤��:',VouchNoMax,'��',VouchNoMin,'-','ƾ֤����״̬:',StateField,'-','ƾ֤��ʾ��ʽ:',typenameCombo,'-',findButton],   */
		bbar: MoidLogPagTba,
		loadMask: true
	});
// itemGrid.store.load({params:{start :  0,
// limit : 25}});
//ƾ֤��ʾ
var cmItems = [new Ext.grid.RowNumberer(), {
		id: 'VouchID',
		header: 'ƾ֤��ID',
		editable: false,
		width: 50,
		dataIndex: 'VouchID',
		hidden: true
	}, {
		id: 'AcctYear',
		header: '��',
		align: 'center',
		width: 60,
		editable: false,
		dataIndex: 'AcctYear'

	}, {
		id: 'AcctMonth',
		header: '��',
		align: 'center',
		width: 40,
		editable: false,
		dataIndex: 'AcctMonth'

	}, {
		id: 'VouchDate',
		header: 'ƾ֤����',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'VouchDate'

	}, {
		id: 'VouchNo',
		header: '<div style="text-align:center">ƾ֤��</div>',
		//align: 'center',
		editable: false,
		width: 120,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			var sf = record.data['IsDestroy']
				if (sf == "��") {
					return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>' + value + '</u></span>' + '<b> </b>'
					 + '<span style="color:red;cursor:hand;backgroundColor:white">��</span>';
				} else {
					return '<span style="color:blue;cursor:hand;backgroundColor:red;src="../scripts/herp/acct/acct.html""><u>' + value + '</u></span>';
				}
		},
		dataIndex: 'VouchNo'

	}, {
		id: 'typename',
		header: 'ƾ֤����',
		align: 'center',
		width: 80,
		editable: false,
		dataIndex: 'typename'
	}, {
		id: 'Operator',
		header: '�Ƶ���',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'Operator'

	}, {
		id: 'MakeBillDate',
		header: '�Ƶ�����',
		align: 'center',
		width: 90,
		editable: false,
		dataIndex: 'MakeBillDate'

	}, {
		id: 'Auditor',
		header: '�����',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'Auditor'

	}, {
		id: 'Poster',
		header: '������',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'Poster'
	}, {
		id: 'VouchState',
		header: 'ƾ֤״̬',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'VouchState'
	}, {
		id: 'VouchProgress',
		header: 'ƾ֤�������',
		align: 'center',
		width: 110,
		editable: false,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>';
		},
		dataIndex: 'VouchProgress'
	}, {
		id: 'IsDestroy',
		header: '����',
		align: 'center',
		width: 70,
		editable: false,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			var sf = record.data['IsDestroy']
				if (sf == "��") {
					//cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
					return '<span style="color:red;backgroundColor:white">' + value + '</span>';
				}
		},
		dataIndex: 'IsDestroy'
	}, {
		id: 'IsCancel',
		header: '����',
		align: 'center',
		width: 70,
		editable: false,
		//hidden: true,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			var sf = record.data['IsCancel']
				if (sf == "��") {
					//cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
					return '<span style="color:red;backgroundColor:white">' + value + '</span>';
				}
		},
		dataIndex: 'IsCancel'
	}, {
		id: 'VouchState1',
		header: 'ƾ֤״̬',
		width: 90,
		editable: false,
		hidden: true,
		dataIndex: 'VouchState1'
	}, {
		id: 'upload',
		header: '����',
		hidden: true,
		allowBlank: false,
		width: 40,
		editable: false,
		dataIndex: 'upload',

		renderer: function (v, p, r) {
			return '<span style="color:blue"><u>�ϴ�</u></span>';
		}
	}, {
		id: 'download',
		header: '����',
		allowBlank: false,
		width: 40,
		editable: false,
		hidden: true,
		dataIndex: 'download',
		renderer: function (v, p, r) {
			return '<span style="color:blue"><u>����</u></span>';
		}
	}
];

/////ƾ֤��¼��ʾ
var cmItems2 = [new Ext.grid.RowNumberer(), {
		id: 'VouchID',
		header: '<div style="text-align:center">id</div>',
		width: 100,
		editable: false,
		hidden: true,
		dataIndex: 'VouchID'
	}, {
		id: 'AcctYear',
		header: '<div style="text-align:center">��</div>',
		width: 60,
		editable: false,
		align: 'center',
		dataIndex: 'AcctYear'
	}, {
		id: 'AcctMonth',
		header: '<div style="text-align:center">��</div>',
		width: 40,
		editable: false,
		align: 'center',
		dataIndex: 'AcctMonth'
	}, {
		id: 'VouchDate',
		header: '<div style="text-align:center">ƾ֤����</div>',
		width: 100,
		editable: false,
		align: 'center',
		dataIndex: 'VouchDate'

	}, {
		id: 'VouchNo',
		header: '<div style="text-align:center">ƾ֤��</div>',
		width: 120,
		editable: false,
		//align: 'center',
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			var sf = record.data['IsDestroy']
				if (sf == "��") {
					return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>' + value + '</u></span>' + '<b> </b>'
					 + '<span style="color:red;cursor:hand;backgroundColor:white">��</span>';
				} else {
					return '<span style="color:blue;cursor:hand;backgroundColor:red;src="../scripts/herp/acct/acct.html""><u>' + value + '</u></span>';
				}
		},
		dataIndex: 'VouchNo'
	}, {
		id: 'VouchRow',
		header: '<div style="text-align:center">���</div>',
		width: 60,
		editable: false,
		align: 'center',
		dataIndex: 'VouchRow'
	}, {
		id: 'Summary',
		header: '<div style="text-align:center">ժҪ</div>',
		width: 170,
		editable: false,
		dataIndex: 'Summary'
	}, {
		id: 'AcctSubjCode',
		header: '<div style="text-align:center">��Ŀ����</div>',
		width: 80,
		editable: false,
		//align: 'center',
		dataIndex: 'AcctSubjCode'
	}, {
		id: 'AcctSubjName',
		header: '<div style="text-align:center">��Ŀ����</div>',
		width: 130,
		editable: false,
		//align: 'center',
		dataIndex: 'AcctSubjName'
	}, {
		id: 'AmtDebit',
		header: '<div style="text-align:center">�跽���</div>',
		width: 130,
		editable: false,
		align: 'right',
		dataIndex: 'AmtDebit'
	}, {
		id: 'AmtCredit',
		header: '<div style="text-align:center">�������</div>',
		width: 130,
		editable: false,
		align: 'right',
		dataIndex: 'AmtCredit'
	}, {
		id: 'VouchState',
		header: '<div style="text-align:center">ƾ֤״̬</div>',
		width: 90,
		align: 'center',
		editable: false,
		dataIndex: 'VouchState'
	}, {
		id: 'VouchProgress',
		header: '<div style="text-align:center">ƾ֤�������</div>',
		width: 100,
		align: 'center',
		editable: false,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>'
		},
		dataIndex: 'VouchProgress'
	}, {
		id: 'Operator',
		header: '<div style="text-align:center">�Ƶ���</div>',
		width: 100,
		editable: false,
		align: 'center',
		dataIndex: 'Operator'
	}, {
		id: 'Auditor',
		header: '<div style="text-align:center">�����</div>',
		width: 100,
		editable: false,
		align: 'center',
		dataIndex: 'Auditor'
	}, {
		id: 'Poster',
		header: '<div style="text-align:center">������</div>',
		width: 100,
		editable: false,
		align: 'center',
		dataIndex: 'Poster'
	}, {
		id: 'IsDestroy',
		header: '<div style="text-align:center">����ƾ֤</div>',
		width: 80,
		editable: false,
		align: 'center',
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			var sf = record.data['IsDestroy']
				if (sf == "��") {
					//cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
					return '<span style="color:red;backgroundColor:white">' + value + '</span>';
				}
		},
		dataIndex: 'IsDestroy'
	}, {
		id: 'IsCancel',
		header: '<div style="text-align:center">����ƾ֤</div>',
		width: 80,
		editable: false,
		align: 'center',
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			var sf = record.data['IsCancel']
				if (sf == "��") {
					//cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
					return '<span style="color:red;backgroundColor:white">' + value + '</span>';
				}
		},
		dataIndex: 'IsCancel'
	}, {
		id: 'VouchState1',
		header: '<div style="text-align:center">ƾ֤״̬</div>',
		width: 90,
		editable: false,
		hidden: true,
		dataIndex: 'VouchState1'
	}, {
		id: 'Operator1',
		header: '<div style="text-align:center">������</div>',
		width: 100,
		editable: false,
		hidden: true,
		dataIndex: 'Operator1'
	}, {
		id: 'Auditor1',
		header: '<div style="text-align:center">�����</div>',
		width: 100,
		editable: false,
		hidden: true,
		dataIndex: 'Auditor1'
	}
]

//uploadMainFun(itemGrid,'VouchID','P007',16);
//downloadMainFun(itemGrid,'VouchID','P007',17);

itemGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {
	var a = typenameCombo.getValue()
		if (a == 2) {
			var b = 13
		} else {
			var b = 12
		}
		//ƾ֤�ŵ�����
		if (columnIndex == '5') {
			//p_URL = 'acct.html?acctno=2';
			//document.getElementById("frameReport").src='acct.html';
			var records = itemGrid.getSelectionModel().getSelections();
			var VouchNo = records[0].get("VouchNo");
			var VouchState = records[0].get("VouchState1");
			var myPanel = new Ext.Panel({
					layout: 'fit',
					//scrolling="auto"
					html: '<iframe id="frameReport" style="margin-top:-3px" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + userid + '&acctstate=' + VouchState + '&bookID=' + bookID + '&searchFlag=' + 1 + '" /></iframe>'
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
		//ƾ֤������̵�����
		if (columnIndex == b) {
			var records = itemGrid.getSelectionModel().getSelections();
			var VouchID = records[0].get("VouchID");
			VouchProgressFun(VouchID);
		}
});

//    itemGrid.btnAddHide();  //�������Ӱ�ť
//    itemGrid.btnSaveHide();  //���ر��水ť
//    itemGrid.btnResetHide();  //�������ð�ť
//    itemGrid.btnDeleteHide(); //����ɾ����ť
//    itemGrid.btnPrintHide();  //���ش�ӡ��ť
