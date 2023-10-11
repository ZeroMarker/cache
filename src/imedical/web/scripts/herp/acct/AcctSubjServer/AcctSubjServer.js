var userid = session['LOGON.USERID'];

var acctbookid = GetAcctBookID();
// ���嵱ǰ��Ŀ����¼��Ĺ���
var ParamCode = new Ext.form.TextField({
		fieldLabel: '��ǰ�������:',
		id: 'ParamCode',
		width: 120,
		editable: false,
		columnWidth: .2,
		disabled: true,
		selectOnFocus: true
	});
	
		
PageSizePlugin = function() {
	PageSizePlugin.superclass.constructor.call(this, {
				store : new Ext.data.SimpleStore({
							fields : ['text', 'value'],
							data : [['10', 10], ['20', 20], ['30', 30],
									['50', 50], ['100', 100]]
						}),
				mode : 'local',
				id:'PageSizePluginm',
				displayField : 'text',
				valueField : 'value',
				editable : false,
				allowBlank : false,
				triggerAction : 'all',
				width : 40
			});
};

Ext.extend(PageSizePlugin, Ext.form.ComboBox, {
			init : function(paging) {
				paging.on('render', this.onInitView, this);
			},

			onInitView : function(paging) {
				paging.add('-', this, '-');
				this.setValue(paging.pageSize);
				this.on('select', this.onPageSizeChanged, paging);
			},

			onPageSizeChanged : function(combo) {
				this.pageSize = parseInt(combo.getValue());
				this.doLoad(0);
			}
		});
		
		
Ext.Ajax.request({
	url: 'herp.acct.acctbookparamexe.csp?action=list&acctbookid=' + acctbookid,
	waitMsg: '������...',
	failure: function (result, request) {
		Ext.Msg.show({
			title: '����',
			msg: '������������!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.ERROR
		});
	},
	success: function (result, request) {
		var resultstr = result.responseText;
		var strs = new Array();
		strs = resultstr.split("|");
		var paramcode = ParamCode.setValue(strs[2].split("^")[2]);
		//document.getElementById("paramcode").style.color="red";
		//document.getElementById("ParamCode").style.font="bold"

		/*
		ParamValue.setValue(strs[2].split("^")[2]);
		Control.setValue(strs[3].split("^")[2]);
		EditCheck.setValue(strs[4].split("^")[2]);
		ExtracteType.setValue(strs[5].split("^")[2]);
		ExtractePer.setValue(strs[6].split("^")[2]*100);
		IsGroup.setValue(strs[7].split("^")[2]);
		 */
	},
	scope: this
});

/* //��õ�ǰϵͳ��¼�û�����Ϣ˵��
var userID = session['LOGON.USERID'];
var userCode = session['LOGON.USERCODE'];
var userName = session['LOGON.USERNAME'];
 */
var itemGridUrl = '../csp/herp.acct.acctsubjserverexe.csp';
var projUrl = '../csp/herp.acct.acctsubjserverexe.csp';
//�������Դ
var itemGridProxy = new Ext.data.HttpProxy({
		url: itemGridUrl + '?action=list'
	});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
				'rowid',
				'BookID',
				'SubjCode',
				'SubjName',
				'Spell',
				'SubjNameAll',
				'DefineCode',
				'SuperSubjCode',
				'SubjLevel',
				'SubjTypeID',
				'SubjTypeName',
				'SubjNatureID',
				'SubjNatureName',
				'IsLast',
				'Direction',
				'IsCash',
				'IsNum',
				'NumUnit',
				'IsFc',
				'IsCheck',
				'IsStop',
				'subjGroup',
				'CashFlowID',
				'StartYear',
				'StartMonth',
				'StartYM',
				'EndYear',
				'EndtMonth',
				'EndYM',
				'IsCashFlow',
				'CashItemName'
			]),
		remoteSort: true
	});

var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 25,
		store: itemGridDs,
		atLoad: true,
		plugins : new PageSizePlugin(),
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"
	});

//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('rowid', 'name');


//��Ŀ����--��ѯ�����
var sjcodeField = new Ext.form.TextField({
		id: 'sjcodeField',
		fieldLabel: '��Ŀ����',
		width: 180,
		listWidth: 245,
		triggerAction: 'all',
		emptyText: '����ģ����ѯ...',
		name: 'sjcodeField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true,
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == e.ENTER) {
					QueryButton.handler();
				}
			}
		}
	});

//��Ŀ����--��ѯ�����
var sjnameField = new Ext.form.TextField({
		id: 'sjnameField ',
		fieldLabel: '��Ŀ����',
		width: 180,
		listWidth: 245,
		triggerAction: 'all',
		emptyText: '����ģ����ѯ...',
		name: 'sjnameField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true,
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == e.ENTER) {
					QueryButton.handler();
				}
			}
		}
	});

var sjtypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['rowid', 'code', 'name'])
	});

sjtypeDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=sjtypelist&str',
			method: 'POST'
		});
});

var sjtypeField = new Ext.form.ComboBox({
		id: 'sjtypeField',
		fieldLabel: '��Ŀ���',
		width: 200,
		listWidth: 200,
		allowBlank: true,
		store: sjtypeDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText: '��ѡ���Ŀ����...',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

//��Ŀ����--��ѯ������//
var sjnatureDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['rowid', 'code', 'name'])
	});

sjnatureDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=sjnaturelist&str',
			method: 'POST'
		});
});

var sjnatureField = new Ext.form.ComboBox({
		id: 'sjnatureField',
		fieldLabel: '��Ŀ����',
		width: 200,
		listWidth: 200,
		allowBlank: true,
		store: sjnatureDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText: '��ѡ���Ŀ����...',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

//��Ŀ����--��ѯ������//
var sjlevelDs = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [
			['1', '1'], ['2', '2'], ['3', '3'], ['4', '4'],
			['5', '5'], ['6', '6'], ['7', '7'], ['8', '8']
		]
	});

var sjlevelField = new Ext.form.ComboBox({
		id: 'sjlevelField',
		fieldLabel: '��Ŀ����',
		width: 140,
		listWidth: 140,
		allowBlank: true,
		store: sjlevelDs,
		valueField: 'key',
		displayField: 'keyValue',
		triggerAction: 'all',
		emptyText: '��ѡ���Ŀ����...',
		// minChars: 1,
		// pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		mode: 'local', // ����ģʽ
		editable: true
	});

var IsStopField = new Ext.form.Checkbox({
		id: 'IsStopField',
		labelSeparator: '�Ƿ�ͣ��:',
		style: 'border:0;background:none;margin-top:0px;',
		allowBlank: false
	});

var IsFcField = new Ext.form.Checkbox({
		id: 'IsFcField',
		labelSeparator: '��Һ���:',
		style: 'border:0;background:none;margin-top:0px;',
		allowBlank: false
	});

var IsNumField = new Ext.form.Checkbox({
		id: 'IsNumField',
		labelSeparator: '��������:',
		style: 'border:0;background:none;margin-top:0px;',
		allowBlank: false
	});

var IsCheckField = new Ext.form.Checkbox({
		id: 'IsCheckField',
		labelSeparator: '����Ӧ��:',
		style: 'border:0;background:none;margin-top:0px;',
		allowBlank: false
	});

var startDate = new Ext.form.DateField({
		id: 'startDate',
		format: 'Y-m',
		width: 140,
		emptyText: '',
		plugins: 'monthPickerPlugin'
	});

//��ѯ��ť
var QueryButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
		iconCls: 'find',
		width: 55,
		handler: function () {
			var sjcode = sjcodeField.getValue();
			var sjname = sjnameField.getValue();
			var sjlevel = sjlevelField.getValue();
			var sjnature = sjnatureField.getValue();
			var sjtype = sjtypeField.getValue();
			var IsStop = (IsStopField.getValue() == true) ? '1' : '0';
			var IsCheck = (IsCheckField.getValue() == true) ? '1' : '0';
			var IsFc = (IsFcField.getValue() == true) ? '1' : '0';
			var IsNum = (IsNumField.getValue() == true) ? '1' : '0';
			var startTime = startDate.getValue();
			if (startTime !== "") {
				startTime = startTime.format('Y-m');
			}

			itemGridDs.proxy = new Ext.data.HttpProxy({
					url: itemGridUrl + '?action=list&sjcode=' + sjcode + '&sjname=' + encodeURIComponent(sjname) + '&acctbookid=' + acctbookid
					 + '&sjlevel=' + sjlevel + '&sjnature=' + sjnature + '&sjtype=' + sjtype + '&IsStop=' + IsStop + '&IsCheck=' + IsCheck + '&IsFc=' + IsFc + '&IsNum=' + IsNum + '&startDate=' + startTime
				});
				
			var limits=Ext.getCmp("PageSizePluginm").getValue();
			 //alert(limits);
	         if(!limits){limits=25};	
			itemGridDs.load(({
					params: {
						start: 0,
						limit: limits
					}
				}));
		}
	});

var addButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '���',
		iconCls: 'add',
		handler: function () {
			addFun();
		}
	});

var exportExcel = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����',
		iconCls: 'down',
		handler: function () {
			ExportAllToExcel(itemGrid,"D:\\��ƿ�Ŀ.xls");
		}
	});
	
var editButton = new Ext.Toolbar.Button({
		text: '�޸�',
		tooltip: '�޸�',
		iconCls: 'edit ',
		handler: function () {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len < 1) {
				Ext.Msg.show({
					title: 'ע��',
					msg: '��ѡ����Ҫ�޸ĵ�����!',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			} else if (len == 1) {
				for (var i = 0; i < len; i++) {
					editFun();
				}

			} else {
				Ext.Msg.show({
					title: 'ע��',
					msg: 'ѡ����Ҫ�޸ĵ����ݹ���!',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			}
		}
	});

var delButton = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: 'ɾ��',
		iconCls: 'remove',
		handler: function () {
			delFun();
		}
	});

var importButton = new Ext.Toolbar.Button({
		text: '����Excelģ��',
		tooltip: '����',
		iconCls: 'in',
		handler: function () {
			doimport();
		}
	});

var reloadButton = new Ext.Toolbar.Button({
		text: 'ͬ����Ŀ����<span style="color:green;cursor:hand">(�༭�����Ŀ���뵥��)</span>',
		tooltip: '���ڱ༭���빦�ܺ�,ͬ����Ŀ�������',
		iconCls: 'reload ',
		handler: function () {
			reloadFun();
		}
	});

//��ѯ���
var queryPanel = new Ext.FormPanel({
		height: 85,
		region: 'north',
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px'
		},
		items: [{
				columnWidth: 1,
				xtype: 'panel',
				layout: "column",
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '��Ŀ����',
						style: 'line-height: 20px;',
						width: 60
					},
					sjcodeField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '��Ŀ����',
						style: 'line-height: 20px;',
						width: 60
					},
					sjtypeField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: ' ��Ŀ����',
						style: 'line-height: 20px;',
						width: 60
					},sjlevelField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					},IsStopField, {
						xtype: 'displayfield',
						value: '��Ŀͣ�� ',
						//style: 'padding-top:5px;',
						width: 60
					}, {
						xtype: 'displayfield',
						value: '',
						width: 30
					},IsCheckField, {
						xtype: 'displayfield',
						value: '�������� ',
						//style: 'padding-top:5px;',
						width: 60
					},{
						xtype: 'displayfield',
						value: '',
						width: 30
					}
				]
			}, {
				columnWidth: 1,
				xtype: 'panel',
				layout: "column",
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '��Ŀ����',
						style: 'line-heigth:22px',
						width: 60
					},
					sjnameField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '��Ŀ����',
						style: 'line-heigth:22px',
						width: 60
					},
					sjnatureField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '����ʱ��',
						style: 'line-height: 20px;',
						width: 60
					},startDate,
					 {
						xtype: 'displayfield',
						value: '',
						width: 30
					},
					IsFcField, {
						xtype: 'displayfield',
						value: '��Һ��� ',
						//style: 'padding-top:5px;',
						width: 60
					}, {
						xtype: 'displayfield',
						value: '',
						width: 30
					},
					IsNumField, {
						xtype: 'displayfield',
						value: '�������� ',
						//style: 'padding-top:5px;',
						width: 60
					}, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, QueryButton
				]
			}
		]
	});

//���ݿ�����ģ��
var itemGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			new Ext.grid.CheckboxSelectionModel({
				editable: false
			}), {
				id: 'rowid',
				header: 'id',
				dataIndex: 'rowid',
				width: 50,
				hidden: true,
				align: 'center',
				sortable: true
			}, {
				id: 'BookID',
				header: '<div style="text-align:center">���ױ���</div>',
				dataIndex: 'BookID',
				width: 60,
				hidden: true,
				sortable: true
			}, {
				id: 'SubjCode',
				header: '��Ŀ����',
				dataIndex: 'SubjCode',
				width: 160,
				sortable: true
			}, {
				id: 'SubjName',
				header: '��Ŀ����',
				dataIndex: 'SubjName',
				width: 280,
				align: 'left',
				sortable: true
			}, {
				id: 'SubjNameAll',
				header: '��Ŀȫ��',
				dataIndex: 'SubjNameAll',
				hidden: true,
				width: 200,
				sortable: true
			}, {
				id: 'SubjLevel',
				header: '��Ŀ����',
				dataIndex: 'SubjLevel',
				width: 70,
				align: 'center',
				sortable: true
			}, {
				id: 'SuperSubjCode',
				header: '�ϼ�����',
				dataIndex: 'SuperSubjCode',
				width: 70,
				hidden: true,
				align: 'left',
				sortable: true
			}, {
				id: 'IsLast',
				header: '�Ƿ�ĩ��',
				dataIndex: 'IsLast',
				width: 70,
				align: 'center',
				sortable: true
			}, {
				id: 'Direction',
				header: '�������',
				dataIndex: 'Direction',
				width: 70,
				align: 'center',
				sortable: true
			}, {
				id: 'SubjTypeID',
				header: '���ID',
				dataIndex: 'SubjTypeID',
				width: 70,
				align: 'center',
				hidden: true,
				sortable: true
			}, {
				id: 'SubjTypeName',
				header: '��Ŀ���',
				dataIndex: 'SubjTypeName',
				align: 'center',
				width: 90,
				sortable: true
			}, {
				id: 'SubjNatureID',
				header: '����ID',
				dataIndex: 'SubjNatureID',
				width: 70,
				align: 'center',
				hidden: true,
				sortable: true
			}, {
				id: 'SubjNatureName',
				header: '��Ŀ����',
				dataIndex: 'SubjNatureName',
				width: 80,
				align: 'center',
				sortable: true
			}, {
				id: 'IsStop',
				header: '�Ƿ�ͣ��',
				width: 70,
				align: 'center',
				dataIndex: 'IsStop'
			}, {
				id: 'IsCheck',
				header: '������',
				width: 60,
				align: 'center',
				//hidden: true,
				dataIndex: 'IsCheck'
			}, {
				id: 'IsFc',
				header: '�����',
				width: 60,
				align: 'center',
				dataIndex: 'IsFc'
			}, {
				id: 'IsNum',
				header: '������',
				width: 60,
				align: 'center',
				dataIndex: 'IsNum'
			}, {
				id: 'StartYM',
				header: '��������',
				width: 80,
				align: 'center',
				//hidden: true,
				dataIndex: 'StartYM'
			}, {
				id: 'EndYM',
				header: 'ͣ������',
				width: 80,
				align: 'center',
				dataIndex: 'EndYM'
			}, {
				id: 'Spell',
				header: 'ƴ����',
				dataIndex: 'Spell',
				width: 60,
				hidden: true,
				sortable: true
			}, {
				id: 'DefineCode',
				header: '�Զ���...',
				dataIndex: 'DefineCode',
				width: 60,
				align: 'center',
				hidden: true,
				sortable: true
			}, {
				id: 'IsCash',
				header: '�ֽ����б�־',
				dataIndex: 'IsCash',
				width: 80,
				align: 'center',
				hidden: true,
				sortable: true
			}, {
				id: 'NumUnit',
				header: '������λ',
				width: 60,
				align: 'center',
				hidden: true,
				dataIndex: 'NumUnit'
			}, {
				id: 'subjGroup',
				header: '��Ŀ����',
				width: 100,
				align: 'center',
				hidden: true,
				dataIndex: 'subjGroup'
			}, {
				id: 'CashFlowID',
				header: '�ֽ�������ID',
				width: 100,
				align: 'center',
				hidden: true,
				dataIndex: 'CashFlowID'
			}, {
				id: 'IsCashFlow',
				header: '�Ƿ��ֽ�����',
				width: 80,
				align: 'center',
				hidden: true,
				dataIndex: 'IsCashFlow'
			}, {
				id: 'CashItemName',
				header: '�ֽ�����������',
				width: 150,
				align: 'center',
				hidden: true,
				dataIndex: 'CashItemName'
			}

		]);

//��ʼ��Ĭ��������
itemGridCm.defaultSortable = true;

//���
var itemGrid = new Ext.grid.GridPanel({
		title: '��ƿ�Ŀ�б�',
		iconCls: 'list',
		region: 'center',
		layout: 'fit',
		width: 750,
		readerModel: 'local',
		url: 'herp.acct.acctsubjserverexe.csp',
		//atLoad : true, // �Ƿ��Զ�ˢ��
		store: itemGridDs,
		cm: itemGridCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.CheckboxSelectionModel({
			singleSelect: false
		}),
		loadMask: true,
		tbar: [addButton, '-', editButton, '-', delButton, '-', importButton, '-', '<span style="color:red;cursor:hand">' + "��ǰ�������:" + '&nbsp;' + '</span>', ParamCode, '-', reloadButton, ""],
		bbar: itemGridPagingToolbar
	});
itemGridDs.load({
	params: {
		start: 0,
		limit: itemGridPagingToolbar.pageSize
	},
	callback: function (record, options, success) {
		//itemGrid.fireEvent('rowclick',this,0);
	}
});

//--------------------------------�����������------------------------------------------//

//�������
var vCheckTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['rowid', 'code', 'name'])
	});
vCheckTypeDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=sjchecktypelist&str',
			method: 'POST'
		});
});
var CheckTypeName = new Ext.form.ComboBox({
		id: 'CheckTypeName',
		fieldLabel: '�����������',
		width: 180,
		listWidth: 265,
		allowBlank: true,
		store: vCheckTypeDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText: '��ѡ��...',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

//��������
var CheckSYear = new Ext.form.TextField({
		fieldLabel: '������������',
		width: 180,
		value: new Date().format('Y'),
		selectOnFocus: 'true'
	});
//new Date().format('Y');

//
//�����·�
var StartMonthStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [
			["01", '1��'], ["02", '2��'], ['03', '3��'], ['04', '4��'],
			['05', '5��'], ['06', '6��'], ['07', '7��'], ['08', '8��'],
			['09', '9��'], ['10', '10��'], ['11', '11��'], ['12', '12��']
		]
	});
var CheckSMonth = new Ext.form.ComboBox({
		id: 'CheckSMonth',
		fieldLabel: '������������',
		width: 180,
		selectOnFocus: true,
		allowBlank: true,
		store: StartMonthStore,
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		mode: 'local', // ����ģʽ
		editable: true,
		selectOnFocus: true,
		forceSelection: true
	});
/*
//�Ƿ�ͣ��
var CheckIsStop = new Ext.form.Checkbox({
id : 'CheckIsStop',
fieldLabel: '�����Ƿ�ͣ��',
allowBlank : false,
listeners : {
check: function (obj, vIsStop) {
if (vIsStop) {
CheckFieldSet.disable();
} else {
CheckFieldSet.enable();
}
}
}
});
 */
var IsStopStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [['1', '��'], ['0', '��']]
	});
var CheckIsStop = new Ext.form.ComboBox({
		id: 'CheckIsStop',
		fieldLabel: '�������Ƿ�ͣ��',
		width: 180,
		selectOnFocus: true,
		allowBlank: true,
		store: IsStopStore,
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		mode: 'local', // ����ģʽ
		editable: false,
		value: 0,
		selectOnFocus: true,
		forceSelection: true
	});

var CheckEYear = new Ext.form.TextField({
		fieldLabel: '������ͣ����',
		width: 180,
		selectOnFocus: true
	});

//ͣ���·�
var vEndMonthStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [
			['01', '1��'], ['02', '2��'], ['03', '3��'], ['04', '4��'],
			['05', '5��'], ['06', '6��'], ['07', '7��'], ['08', '8��'],
			['09', '9��'], ['10', '10��'], ['11', '11��'], ['12', '12��']
		]
	});
var CheckEMonth = new Ext.form.ComboBox({
		id: 'CheckEMonth',
		fieldLabel: '������ֹͣ��',
		width: 180,
		listWidth: 80,
		selectOnFocus: true,
		allowBlank: true,
		store: vEndMonthStore,
		//anchor : '95%',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		mode: 'local', // ����ģʽ
		editable: true,
		//value:01,
		selectOnFocus: true,
		forceSelection: true
	});

//ɾ����ť
var delButton1 = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: 'ɾ��',
		iconCls: 'remove',
		handler: function () {
			CheckitemGrid.del();
		}
	});

//���Ӱ�ť
var addButton1 = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����', //��ͣ��ʾ
		iconCls: 'add',
		handler: function () {
			CheckitemGrid.add();
		}
	});

//���水ť
var saveButton1 = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '�������',
		iconCls: 'save',
		handler: function () {
			//���ñ��溯��
			CheckitemGrid.save();
		}
	});

//�����¼�
itemGrid.on('rowclick', function (grid, rowIndex, e) {
	var selectedRow = itemGridDs.data.items[rowIndex];
	var rowid = selectedRow.data['rowid'];
	var IsCheck = selectedRow.data['IsCheck'];
	if (IsCheck == "��") {
		CheckitemGrid.disable();
	} else {
		CheckitemGrid.enable();
	};
	CheckitemGrid.store.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=listcheck&rowid=' + rowid
		});
	CheckitemGrid.load({
		params: {
			start: 0,
			limit: 25
		}
	});

});

var CheckitemGrid = new dhc.herp.Grid({
		title: '��Ӧ�������б�',
		iconCls: 'list',
		width: 425,
		split: true,
		region: 'east',
		tbar: [addButton1, '-', saveButton1, '-', delButton1, '-'],
		url: projUrl,
		atLoad: true,
		collapsible: true,
		fields: [
			new Ext.grid.CheckboxSelectionModel({
				editable: false
			}), {
				header: 'ID',
				dataIndex: 'CheckMaprowid',
				hidden: true
			}, {
				id: 'CheckTypeID',
				header: '<div style="text-align:center">��������ID</div>',
				align: 'center',
				dataIndex: 'CheckTypeID',
				hidden: true
			}, {
				id: 'CheckTypeName',
				header: '<div style="text-align:center">��������</div>',
				width: 100,
				align: 'center',
				type: CheckTypeName,
				dataIndex: 'CheckTypeName'
			}, {
				id: 'CheckSYear',
				header: '<div style="text-align:center">������</div>',
				width: 50,
				align: 'center',
				allowBlank: true,
				dataIndex: 'CheckSYear'
			}, {
				id: 'CheckSMonth',
				header: '<div style="text-align:center">������</div>',
				width: 50,
				align: 'center',
				allowBlank: true,
				type: CheckSMonth,
				dataIndex: 'CheckSMonth'
			}, {
				id: 'CheckIsStop',
				header: '<div style="text-align:center">�Ƿ�ͣ��</div>',
				width: 70,
				align: 'center',
				allowBlank: true,
				type: CheckIsStop,
				dataIndex: 'CheckIsStop'
			}, {
				id: 'CheckEYear',
				header: '<div style="text-align:center">ͣ����</div>',
				width: 50,
				align: 'center',
				allowBlank: true,
				dataIndex: 'CheckEYear'
			}, {
				id: 'CheckEMonth',
				header: '<div style="text-align:center">ͣ����</div>',
				width: 50,
				type: CheckEMonth,
				align: 'center',
				allowBlank: true,
				dataIndex: 'CheckEMonth'
			}
		]
	});

CheckitemGrid.btnResetHide(); //�������ð�ť
CheckitemGrid.btnPrintHide(); //���ش�ӡ��ť
CheckitemGrid.btnAddHide(); //���ذ�ť
CheckitemGrid.btnSaveHide(); //���ذ�ť
CheckitemGrid.btnDeleteHide();
var acctbookid = IsExistAcctBook(); //�жϵ�ǰ�����Ƿ����

//var   acctbookid=IsExistAcctBook(); //�жϵ�ǰ�����Ƿ����
