var userid = session['LOGON.USERID'];
var bookID = IsExistAcctBook();
projUrl = 'herp.acct.acctvouchsearchexe.csp';
/////////////凭证类型
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
		fieldLabel: '凭证类型',
		store: VouchTypeDs,
		valueField: 'rowid',
		displayField: 'name',
		typeAhead: true,
		triggerAction: 'all',
		emptyText: '请选择类型',
		width: 180,
		listWidth: 230,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		editable: true,
		forceSelection: 'true'
	});

/* 	 var firstDate = new Date();
firstDate.setDate(1); //第一天
var sd=firstDate.format("Y-m-d");
//alert(dd);
var endDate = new Date(firstDate);
endDate.setMonth(firstDate.getMonth()+1);
endDate.setDate(0);
var ed=endDate.format("Y-m-d"); */
//alert(ed);

//////凭证日期时间范围
var VouchDateStartField = new Ext.form.DateField({
		fieldLabel: '凭证日期开始时间',
		id: 'VouchDateStartField',
		//value:sd,
		//format : 'Y-m-d',
		width: 120,
		emptyText: ''
	});

var VouchDateEndField = new Ext.form.DateField({
		fieldLabel: '凭证日期结束时间',
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

/////////////////////凭证号范围/////////////////////////
VouchNoMax = new Ext.form.TextField({
		fieldLabel: '凭证编号',
		width: 120,
		hideLabel: false,
		//columnWidth : .142,
		selectOnFocus: true
	});
VouchNoMin = new Ext.form.TextField({
		fieldLabel: '凭证编号',
		width: 120,
		//columnWidth : .142,
		selectOnFocus: true
	});
/////////凭证处理状态
var StateStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [['0', '新增'], ['05', '审核不通过'], ['11', '提交'], ['12', '作废'],
			['21', '审核通过'], ['31', '记账'], ['41', '结账']]
	});
var StateField = new Ext.form.ComboBox({
		id: 'State',
		fieldLabel: '凭证状态',
		width: 180,
		//columnWidth : .15,
		listWidth: 240,
		selectOnFocus: true,
		// allowBlank: false,
		store: StateStore,
		//value : 0, //默认值
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

/////////////////////显示方式
var typeStore = new Ext.data.SimpleStore({
		fields: ['rowid', 'method'],
		data: [['1', '凭证显示'], ['2', '凭证分录显示']]
	});
var typenameCombo = new Ext.form.ComboBox({
		id: 'typenameCombo',
		fieldLabel: '显示方式',
		width: 180,
		listWidth: 150,
		selectOnFocus: true,
		allowBlank: true,
		store: typeStore,
		anchor: '90%',
		value: 1, //默认值
		valueNotFoundText: '',
		displayField: 'method',
		valueField: 'rowid',
		triggerAction: 'all',
		emptyText: '',
		mode: 'local', // 本地模式
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
///////凭证摘要
var VouchSummary = new Ext.form.TextField({
		fieldLabel: '凭证摘要',
		width: 200,
		//columnWidth : .142,
		selectOnFocus: true
	});

///////金额查询范围
var VouchAmtMin = new Ext.form.TextField({
		fieldLabel: '金额范围',
		width: 120,
		//columnWidth : .142,
		selectOnFocus: true
	});
///////金额查询摘要
var VouchAmtMax = new Ext.form.TextField({
		fieldLabel: '--',
		width: 120,
		//columnWidth : .142,
		selectOnFocus: true
	});

////会计科目
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
//Grid表格
var VouchSubj = new Ext.form.ComboBox({
		id: 'VouchSubj',
		fieldLabel: '会计科目',
		width: 200,
		listWidth: 300,
		allowBlank: true,
		store: SubjNameDs,
		valueField: 'subjId',
		displayField: 'subjCodeNameAll',
		triggerAction: 'all',
		//emptyText:'科目字典中末级银行科目',
		name: 'VouchSubj',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

//首先禁止使用
VouchSummary.disable();
VouchSubj.disable();
VouchAmtMax.disable();
VouchAmtMin.disable();

//////查询按钮
var data;
var findButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
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
					itemGrid.setTitle("凭证显示列表");
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
					itemGrid.setTitle("凭证分录显示列表");
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

//显示表格
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
				header: '凭证表ID',
				editable: false,
				width: 50,
				dataIndex: 'VouchID',
				hidden: true
			}, {
				id: 'AcctYear',
				header: '年',
				align: 'center',
				width: 60,
				editable: false,
				dataIndex: 'AcctYear'

			}, {
				id: 'AcctMonth',
				header: '月',
				align: 'center',
				width: 40,
				editable: false,
				dataIndex: 'AcctMonth'

			}, {
				id: 'VouchDate',
				header: '凭证日期',
				align: 'center',
				width: 100,
				editable: false,
				dataIndex: 'VouchDate'

			}, {
				id: 'VouchNo',
				header: '<div style="text-align:center">凭证号</div>',
				//align: 'center',
				editable: false,
				width: 120,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					var sf = record.data['IsDestroy']
						if (sf == "是") {
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>' + value + '</u></span>' + '<b> </b>'
							 + '<span style="color:red;cursor:hand;backgroundColor:white">冲</span>';
						} else {
							return '<span style="color:blue;cursor:hand;backgroundColor:red;src="../scripts/herp/acct/acct.html""><u>' + value + '</u></span>';
						}
				},
				dataIndex: 'VouchNo'

			}, {
				id: 'typename',
				header: '凭证类型',
				align: 'center',
				width: 80,
				editable: false,
				dataIndex: 'typename'
			}, {
				id: 'Operator',
				header: '制单人',
				align: 'center',
				width: 100,
				editable: false,
				dataIndex: 'Operator'

			}, {
				id: 'MakeBillDate',
				header: '制单日期',
				align: 'center',
				width: 100,
				editable: false,
				dataIndex: 'MakeBillDate'

			}, {
				id: 'Auditor',
				header: '审核人',
				align: 'center',
				width: 100,
				editable: false,
				dataIndex: 'Auditor'

			}, {
				id: 'Poster',
				header: '记账人',
				align: 'center',
				width: 100,
				editable: false,
				dataIndex: 'Poster'
			}, {
				id: 'VouchState',
				header: '凭证状态',
				align: 'center',
				width: 100,
				editable: false,
				dataIndex: 'VouchState'
			}, {
				id: 'VouchProgress',
				header: '凭证处理过程',
				align: 'center',
				width: 110,
				editable: false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>';
				},
				dataIndex: 'VouchProgress'
			}, {
				id: 'IsDestroy',
				header: '冲销',
				align: 'center',
				width: 70,
				editable: false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					var sf = record.data['IsDestroy']
						if (sf == "是") {
							//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:red;backgroundColor:white">' + value + '</span>';
						}
				},
				dataIndex: 'IsDestroy'
			}, {
				id: 'IsCancel',
				header: '作废',
				align: 'center',
				width: 70,
				editable: false,
				//hidden: true,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					var sf = record.data['IsCancel']
						if (sf == "是") {
							//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:red;backgroundColor:white">' + value + '</span>';
						}
				},
				dataIndex: 'IsCancel'
			}, {
				id: 'VouchState1',
				header: '凭证状态',
				width: 90,
				editable: false,
				hidden: true,
				dataIndex: 'VouchState1'
			}, {
				id: 'upload',
				header: '附件',
				hidden: true,
				allowBlank: false,
				width: 40,
				editable: false,
				dataIndex: 'upload',

				renderer: function (v, p, r) {
					return '<span style="color:blue"><u>上传</u></span>';
				}
			}, {
				id: 'download',
				header: '下载',
				allowBlank: false,
				width: 40,
				editable: false,
				hidden: true,
				dataIndex: 'download',
				renderer: function (v, p, r) {
					return '<span style="color:blue"><u>下载</u></span>';
				}
			}
		]);

var MoidLogPagTba = new Ext.PagingToolbar({
		store: MoidLogDs,
		pageSize: 25,
		displayInfo: true,
		plugins: new dhc.herp.PageSizePlugin(),
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有记录"
	});

var queryPanel = new Ext.FormPanel({
		//autoHeight : true,
		title: '凭证信息查询',
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
						value: '凭证显示方式',
						//style: 'padding-top:3px',
						width: 93
					},
					typenameCombo, {
						xtype: 'displayfield',
						value: '',
						width: 60
					}, {
						xtype: 'displayfield',
						value: '凭证号',
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
						value: '会计科目',
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
						value: '凭证处理状态',
						//style: 'padding-top:3px;',
						width: 93
					},
					StateField, {
						xtype: 'displayfield',
						value: '',
						width: 46
					}, {
						xtype: 'displayfield',
						value: '凭证日期',
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
						value: '凭证摘要',
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
						value: '凭证类型',
						style: 'padding-top:3px;',
						width: 65
					},
					VouchTypeCombo, {
						xtype: 'displayfield',
						value: '',
						width: 47
					}, {
						xtype: 'displayfield',
						value: '金额范围',
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
		title: '凭证显示列表',
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
		/* tbar:['凭证类型:',VouchTypeCombo,'-','凭证日期:',VouchDateStartField,'至',VouchDateEndField,'-','凭证号:',VouchNoMax,'至',VouchNoMin,'-','凭证处理状态:',StateField,'-','凭证显示方式:',typenameCombo,'-',findButton],   */
		bbar: MoidLogPagTba,
		loadMask: true
	});
// itemGrid.store.load({params:{start :  0,
// limit : 25}});
//凭证显示
var cmItems = [new Ext.grid.RowNumberer(), {
		id: 'VouchID',
		header: '凭证表ID',
		editable: false,
		width: 50,
		dataIndex: 'VouchID',
		hidden: true
	}, {
		id: 'AcctYear',
		header: '年',
		align: 'center',
		width: 60,
		editable: false,
		dataIndex: 'AcctYear'

	}, {
		id: 'AcctMonth',
		header: '月',
		align: 'center',
		width: 40,
		editable: false,
		dataIndex: 'AcctMonth'

	}, {
		id: 'VouchDate',
		header: '凭证日期',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'VouchDate'

	}, {
		id: 'VouchNo',
		header: '<div style="text-align:center">凭证号</div>',
		//align: 'center',
		editable: false,
		width: 120,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			var sf = record.data['IsDestroy']
				if (sf == "是") {
					return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>' + value + '</u></span>' + '<b> </b>'
					 + '<span style="color:red;cursor:hand;backgroundColor:white">冲</span>';
				} else {
					return '<span style="color:blue;cursor:hand;backgroundColor:red;src="../scripts/herp/acct/acct.html""><u>' + value + '</u></span>';
				}
		},
		dataIndex: 'VouchNo'

	}, {
		id: 'typename',
		header: '凭证类型',
		align: 'center',
		width: 80,
		editable: false,
		dataIndex: 'typename'
	}, {
		id: 'Operator',
		header: '制单人',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'Operator'

	}, {
		id: 'MakeBillDate',
		header: '制单日期',
		align: 'center',
		width: 90,
		editable: false,
		dataIndex: 'MakeBillDate'

	}, {
		id: 'Auditor',
		header: '审核人',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'Auditor'

	}, {
		id: 'Poster',
		header: '记账人',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'Poster'
	}, {
		id: 'VouchState',
		header: '凭证状态',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'VouchState'
	}, {
		id: 'VouchProgress',
		header: '凭证处理过程',
		align: 'center',
		width: 110,
		editable: false,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>';
		},
		dataIndex: 'VouchProgress'
	}, {
		id: 'IsDestroy',
		header: '冲销',
		align: 'center',
		width: 70,
		editable: false,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			var sf = record.data['IsDestroy']
				if (sf == "是") {
					//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
					return '<span style="color:red;backgroundColor:white">' + value + '</span>';
				}
		},
		dataIndex: 'IsDestroy'
	}, {
		id: 'IsCancel',
		header: '作废',
		align: 'center',
		width: 70,
		editable: false,
		//hidden: true,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			var sf = record.data['IsCancel']
				if (sf == "是") {
					//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
					return '<span style="color:red;backgroundColor:white">' + value + '</span>';
				}
		},
		dataIndex: 'IsCancel'
	}, {
		id: 'VouchState1',
		header: '凭证状态',
		width: 90,
		editable: false,
		hidden: true,
		dataIndex: 'VouchState1'
	}, {
		id: 'upload',
		header: '附件',
		hidden: true,
		allowBlank: false,
		width: 40,
		editable: false,
		dataIndex: 'upload',

		renderer: function (v, p, r) {
			return '<span style="color:blue"><u>上传</u></span>';
		}
	}, {
		id: 'download',
		header: '下载',
		allowBlank: false,
		width: 40,
		editable: false,
		hidden: true,
		dataIndex: 'download',
		renderer: function (v, p, r) {
			return '<span style="color:blue"><u>下载</u></span>';
		}
	}
];

/////凭证分录显示
var cmItems2 = [new Ext.grid.RowNumberer(), {
		id: 'VouchID',
		header: '<div style="text-align:center">id</div>',
		width: 100,
		editable: false,
		hidden: true,
		dataIndex: 'VouchID'
	}, {
		id: 'AcctYear',
		header: '<div style="text-align:center">年</div>',
		width: 60,
		editable: false,
		align: 'center',
		dataIndex: 'AcctYear'
	}, {
		id: 'AcctMonth',
		header: '<div style="text-align:center">月</div>',
		width: 40,
		editable: false,
		align: 'center',
		dataIndex: 'AcctMonth'
	}, {
		id: 'VouchDate',
		header: '<div style="text-align:center">凭证日期</div>',
		width: 100,
		editable: false,
		align: 'center',
		dataIndex: 'VouchDate'

	}, {
		id: 'VouchNo',
		header: '<div style="text-align:center">凭证号</div>',
		width: 120,
		editable: false,
		//align: 'center',
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			var sf = record.data['IsDestroy']
				if (sf == "是") {
					return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>' + value + '</u></span>' + '<b> </b>'
					 + '<span style="color:red;cursor:hand;backgroundColor:white">冲</span>';
				} else {
					return '<span style="color:blue;cursor:hand;backgroundColor:red;src="../scripts/herp/acct/acct.html""><u>' + value + '</u></span>';
				}
		},
		dataIndex: 'VouchNo'
	}, {
		id: 'VouchRow',
		header: '<div style="text-align:center">序号</div>',
		width: 60,
		editable: false,
		align: 'center',
		dataIndex: 'VouchRow'
	}, {
		id: 'Summary',
		header: '<div style="text-align:center">摘要</div>',
		width: 170,
		editable: false,
		dataIndex: 'Summary'
	}, {
		id: 'AcctSubjCode',
		header: '<div style="text-align:center">科目代码</div>',
		width: 80,
		editable: false,
		//align: 'center',
		dataIndex: 'AcctSubjCode'
	}, {
		id: 'AcctSubjName',
		header: '<div style="text-align:center">科目名称</div>',
		width: 130,
		editable: false,
		//align: 'center',
		dataIndex: 'AcctSubjName'
	}, {
		id: 'AmtDebit',
		header: '<div style="text-align:center">借方金额</div>',
		width: 130,
		editable: false,
		align: 'right',
		dataIndex: 'AmtDebit'
	}, {
		id: 'AmtCredit',
		header: '<div style="text-align:center">贷方金额</div>',
		width: 130,
		editable: false,
		align: 'right',
		dataIndex: 'AmtCredit'
	}, {
		id: 'VouchState',
		header: '<div style="text-align:center">凭证状态</div>',
		width: 90,
		align: 'center',
		editable: false,
		dataIndex: 'VouchState'
	}, {
		id: 'VouchProgress',
		header: '<div style="text-align:center">凭证处理过程</div>',
		width: 100,
		align: 'center',
		editable: false,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>'
		},
		dataIndex: 'VouchProgress'
	}, {
		id: 'Operator',
		header: '<div style="text-align:center">制单人</div>',
		width: 100,
		editable: false,
		align: 'center',
		dataIndex: 'Operator'
	}, {
		id: 'Auditor',
		header: '<div style="text-align:center">审核人</div>',
		width: 100,
		editable: false,
		align: 'center',
		dataIndex: 'Auditor'
	}, {
		id: 'Poster',
		header: '<div style="text-align:center">记账人</div>',
		width: 100,
		editable: false,
		align: 'center',
		dataIndex: 'Poster'
	}, {
		id: 'IsDestroy',
		header: '<div style="text-align:center">冲销凭证</div>',
		width: 80,
		editable: false,
		align: 'center',
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			var sf = record.data['IsDestroy']
				if (sf == "是") {
					//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
					return '<span style="color:red;backgroundColor:white">' + value + '</span>';
				}
		},
		dataIndex: 'IsDestroy'
	}, {
		id: 'IsCancel',
		header: '<div style="text-align:center">作废凭证</div>',
		width: 80,
		editable: false,
		align: 'center',
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			var sf = record.data['IsCancel']
				if (sf == "是") {
					//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
					return '<span style="color:red;backgroundColor:white">' + value + '</span>';
				}
		},
		dataIndex: 'IsCancel'
	}, {
		id: 'VouchState1',
		header: '<div style="text-align:center">凭证状态</div>',
		width: 90,
		editable: false,
		hidden: true,
		dataIndex: 'VouchState1'
	}, {
		id: 'Operator1',
		header: '<div style="text-align:center">编制人</div>',
		width: 100,
		editable: false,
		hidden: true,
		dataIndex: 'Operator1'
	}, {
		id: 'Auditor1',
		header: '<div style="text-align:center">审核人</div>',
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
		//凭证号的链接
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
					title: '凭证查看',
					width: 1093,
					height: 620,
					resizable: false,
					closable: true,
					draggable: true,
					resizable: false,
					layout: 'fit',
					modal: false,
					plain: true, // 表示为渲染window body的背景为透明的背景
					//bodyStyle : 'padding:5px;',
					items: [myPanel],
					buttonAlign: 'center',
					buttons: [{
							text: '关闭',
							type: 'button',
							handler: function () {
								win.close();
							}
						}
					]
				});
			win.show();
		}
		//凭证处理过程的链接
		if (columnIndex == b) {
			var records = itemGrid.getSelectionModel().getSelections();
			var VouchID = records[0].get("VouchID");
			VouchProgressFun(VouchID);
		}
});

//    itemGrid.btnAddHide();  //隐藏增加按钮
//    itemGrid.btnSaveHide();  //隐藏保存按钮
//    itemGrid.btnResetHide();  //隐藏重置按钮
//    itemGrid.btnDeleteHide(); //隐藏删除按钮
//    itemGrid.btnPrintHide();  //隐藏打印按钮
