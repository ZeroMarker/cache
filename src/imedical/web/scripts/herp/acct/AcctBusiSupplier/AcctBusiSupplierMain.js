// var userid = session['LOGON.USERID'];
var acctbookid = IsExistAcctBook();
var userid = session['LOGON.USERID'];
var projUrl = 'herp.acct.acctbusisupplierexe.csp';

/**********会计账套*********/
var AcctBookStore = new Ext.data.Store({
		proxy: '',
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['AcctBookID', 'AcctBookName'])
	});
AcctBookStore.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			mothed: 'POST',
			url: projUrl + '?action=AcctBook&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('AcctBookFieldt').getRawValue())
		})
});
var AcctBookFieldt = new Ext.form.ComboBox({
		id: 'AcctBookFieldt',
		fieldLabel: '会计账套',
		width: 150,
		listWidth: 220,
		minChars: 1,
		pageSize: 10,
		store: AcctBookStore,
		displayField: 'AcctBookName',
		valueField: 'AcctBookID',
		triggerAction: 'all',
		selectOnFocus: true,
		forceSelection: true,
		//typeAhead : true,
		editable: true,
		listeners: {
			select: function () {
				var BookID = AcctBookFieldt.getValue();
				SupplierStore.removeAll();
				AcctSupplierField.setValue();
				SupplierStore.on('beforeload', function (ds, o) {
					ds.proxy = new Ext.data.HttpProxy({
							method: 'POST',
							url: projUrl + '?action=GetAcctSupplier&start=0&limit=25&AcctBookID=' + BookID
						})
				});
				SupplierStore.load();
			}
		}
	});

//账套数据列下拉框
var rows;
var AcctBook = new Ext.form.ComboBox({
		id: 'AcctBook',
		fieldLabel: '会计账套',
		width: 178,
		listWidth: 220,
		lazyRender: true, //选择时加载
		minChars: 1,
		pageSize: 10,
		store: AcctBookStore,
		displayField: 'AcctBookName',
		valueField: 'AcctBookID',
		triggerAction: 'all',
		//typeAhead : true,
		forceSelection: true,
		listeners: {
			select: function (comb, records, index) {
				var currow = gridpanel.getSelectionModel().getSelections();
				rows = currow[0].data["AcctBusiSupplierMapID"];
				var BookID = AcctBook.getValue(); //currow[0].data["BookName"];
				//alert(currow+"&"+BookID)
				if (BookID != "") {
					AcctSupplierStore.removeAll();
					// AcctDepart.setValue();
					currow[0].data["AcctDeptName"] = ""; //选择账套后，科室名称列先置空
					AcctSupplierStore.on('beforeload', function (ds, o) {
						ds.proxy = new Ext.data.HttpProxy({
								method: 'POST',
								url: projUrl + '?action=GetAcctSupplier&start=0&limit=25&AcctBookID=' + BookID
							})
					});
					AcctSupplierStore.load();
				}
			}
			/*,
			scope:this  */

		}

	});
/**********会计供应商*********/
var SupplierStore = new Ext.data.Store({
		autoLoad: false,
		proxy: '',
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['CheckItemCode', 'CheckItemCodeName'])
	});
var AcctSupplierField = new Ext.form.ComboBox({
		id: 'AcctSupplierField',
		fieldLabel: '会计供应商',
		width: 180,
		listWidth: 230,
		queryModel: 'local',
		lazyRender: true, //选择时加载
		minChars: 1,
		pageSize: 10,
		store: SupplierStore,
		displayField: 'CheckItemCodeName',
		valueField: 'CheckItemCode',
		triggerAction: 'all',
		selectOnFocus: true,
		//typeAhead : true,
		forceSelection: true,
		editable: true,
		listeners: {
			focus: function () {
				var BookID = AcctBookFieldt.getRawValue();
				if (BookID == "") {
					SupplierStore.removeAll();
					AcctSupplierField.setValue();
					Ext.Msg.show({
						title: '注意',
						msg: '请先选择单位账套！',
						icon: Ext.Msg.INFO,
						buttons: Ext.Msg.OK
					});
					return;
				}
			}
		}
	});
//会计供应商数据列
var AcctSupplierStore = new Ext.data.Store({
		autoLoad: false,
		proxy: '',
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['CheckItemCodeName', 'CodeName'])
	});
var AcctSupplier = new Ext.form.ComboBox({
		id: 'AcctSupplier',
		fieldLabel: '会计供应商',
		width: 180,
		listWidth: 230,
		// lazyRender : true, //选择时加载
		minChars: 1,
		pageSize: 10,
		// queryModel : 'local',
		store: AcctSupplierStore,
		displayField: 'CheckItemCodeName',
		valueField: 'CodeName',
		triggerAction: 'all',
		//typeAhead : true,
		forceSelection: 'true',
		editable: true,
		listeners: {
			focus: function () {
				//alert(Ext.getCmp('AcctBook').getRawValue())
				var records = gridpanel.getSelectionModel().getSelections();
				var BookName = records[0].data["BookName"];
				// var AcctBookID=records[0].data["AcctBookID"];
				// alert(BookName)
				if (BookName == "") {
					Ext.Msg.show({
						title: '注意',
						msg: '请先选择单位账套！ ',
						icon: Ext.Msg.INFO,
						buttons: Ext.Msg.OK
					});
					return;
				}
				//alert(rows+"&"+records[0].data["AcctBusiDeptMapID"])
				if (rows != records[0].data["AcctBusiSupplierMapID"]) { //判断选择行是不是单位账套改变行
					AcctSupplierStore.removeAll();
					AcctSupplier.setValue();
					AcctSupplierStore.on('beforeload', function (ds, o) {
						ds.proxy = new Ext.data.HttpProxy({
								method: 'POST',
								url: projUrl + '?action=GetAcctSupplier&start=0&limit=25&AcctBookName=' + encodeURIComponent(BookName)
							})
					});
					AcctSupplierStore.load();
				}
			}
		}
	});

/**********业务供应商*********/
var BusiSupplierField = new Ext.form.TextField({
		id: 'BusiSupplierField',
		fieldLabel: '业务供应商',
		width: 150
	});

/**********业务系统*********/
var BusiSysStore = new Ext.data.Store({
		proxy: '',
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['SysBusinessID', 'SystemName'])
	});
BusiSysStore.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			method: 'POST',
			url: projUrl + '?action=GetBusiSys&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('BusiSystemField').getRawValue())
		})
});
var BusiSystemField = new Ext.form.ComboBox({
		id: 'BusiSystemField',
		fieldLabel: '业务系统',
		width: 150,
		listWidth: 220,
		minChars: 1,
		pageSize: 10,
		lazyRender: true, //选择时加载
		// emptyText:"请选择……",
		store: BusiSysStore,
		displayField: 'SystemName',
		valueField: 'SysBusinessID',
		triggerAction: 'all',
		selectOnFocus: true,
		forceSelection: true,
		//typeAhead : true,
		editable: true
	});
//数据列
var BusiSystem = new Ext.form.ComboBox({
		id: 'BusiSystem',
		fieldLabel: '业务系统',
		width: 150,
		listWidth: 220,
		lazyRender: true, //选择时加载
		store: BusiSysStore,
		displayField: 'SystemName',
		valueField: 'SysBusinessID',
		pageSize: 10,
		triggerAction: 'all',
		forceSelection: true,
		//typeAhead : true,
		selectOnFocus: true,
		editable: true
	});

/**********查询按钮*********/
var findButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'find',
		handler: function () {
			var acctbookid = AcctBookFieldt.getValue(),
			acctsupplier = AcctSupplierField.getValue(),
			busisystem = BusiSystemField.getValue(),
			busisupplier = BusiSupplierField.getValue();
			gridpanel.store.load({
				params: {
					start: 0,
					limit: 25,
					AcctBookID: acctbookid,
					AcctSupplier: acctsupplier,
					BusiSupplier: busisupplier,
					SysBusinessID: busisystem

				}
			})
		}
	});

/**********增加按钮*********/
var addButton = new Ext.Toolbar.Button({
		text: '增加',
		tooltip: '增加',
		iconCls: 'add',
		handler: function () {
			gridpanel.add()
		}
	});
/**********保存按钮*********/
var saveButton = new Ext.Toolbar.Button({
		text: '保存',
		tooltip: '保存',
		iconCls: 'save',
		handler: function () {
			gridpanel.save()
		}
	});
/**********删除按钮*********/
var delButton = new Ext.Toolbar.Button({
		text: '删除',
		tooltip: '删除',
		iconCls: 'remove',
		handler: function () {
			gridpanel.del()
		}
	});

var importButton = new Ext.Toolbar.Button({
		text: '导入',
		tooltip: '导入Excel文件',
		iconCls: 'in',
		handler: function () {
			doimport();
		}
	});

//['会计账套：', AcctBookFieldt, '-', '会计供应商：', AcctSupplierField, 
// '-', '业务供应商：', BusiSupplierField, '-', '业务系统：', BusiSystemField, '-', findButton],
var queryPanel = new Ext.FormPanel({
		region: 'north',
		height: 45,
		frame: true,
		defaults: {
			labelAlign: 'right', //标签对齐方式
			labelSeparator: ' ', //分隔符
			labelWidth: 80,
			border: false,
			bodyStyle: 'padding:5px;'
		},
		width: 1500,
		layout: 'column',
		items: [{
				xtype: 'fieldset',
				labelWidth: 60,
				width: 250,
				items: AcctBookFieldt
			}, {
				xtype: 'fieldset',
				width: 300,
				items: AcctSupplierField
			},{
				xtype: 'fieldset',
				width: 270,
				items: BusiSupplierField
			},{
				xtype: 'fieldset',
				labelWidth: 60,
				width: 250,
				items: BusiSystemField
			}, {
				xtype: 'fieldset',
				// width:100,
				items: findButton
			}
		]

	});

var gridpanel = new dhc.herp.Grid({
		// atLoad : true,
		region: 'center',
		trackMouseOver: true,
		stripeRows: true,
		url: projUrl,
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true
		}),
		tbar: [addButton, '-', saveButton, '-', delButton, '-', importButton],
		fields: [new Ext.grid.CheckboxSelectionModel({
				editable: false
			}), {
				id: 'AcctBusiSupplierMapID',
				header: '<div style="text-align:center">供应商对照表ID</div>',
				dataIndex: 'AcctBusiSupplierMapID',
				width: 100,
				align: 'center',
				hidden: true
			}, {
				id: 'AcctBookID',
				header: '<div style="text-align:center">会计账套ID</div>',
				dataIndex: 'AcctBookID',
				width: 100,
				hidden: true
			}, {
				id: 'BookName',
				header: '<div style="text-align:center">会计账套</div>',
				dataIndex: 'BookName',
				type: AcctBook,
				width: 180,
				allowBlank: false,
				align: 'left'
			}, {
				id: 'AcctSupplierCode',
				header: '<div style="text-align:center">会计供应商编码</div>',
				dataIndex: 'AcctSupplierCode',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				id: 'AcctSupplierName',
				header: '<div style="text-align:center">会计供应商</div>',
				dataIndex: 'AcctSupplierName',
				type: AcctSupplier,
				//allowBlank : false,
				width: 200,
				align: 'left'
			}, {
				id: 'SystemName',
				header: '<div style="text-align:center">业务系统</div>',
				dataIndex: 'SystemName',
				type: BusiSystem,
				width: 180,
				allowBlank: false,
				align: 'left'
			}, {
				id: 'BusiSupplierCode',
				header: '<div style="text-align:center">业务供应商编码</div>',
				dataIndex: 'BusiSupplierCode',
				allowBlank: false,
				width: 150,
				align: 'left'
			}, {
				id: 'BusiSupplierName',
				header: '<div style="text-align:center">业务供应商名称</div>',
				dataIndex: 'BusiSupplierName',
				allowBlank: false,
				width: 300,
				align: 'left'
			}
		],
		bbar: new Ext.PagingToolbar({
			store: this.store,
			pageSize: 25,
			atLoad: true,
			displayInfo: true,
			displayMsg: '当前显示{0} - {1}，共计{2}条。',
			emptyMsg: "没有数据"
		})
	});

gridpanel.btnAddHide() //隐藏增加按钮
gridpanel.btnSaveHide() //隐藏保存按钮
gridpanel.btnDeleteHide() //隐藏删除按钮
gridpanel.btnResetHide() //隐藏重置按钮
gridpanel.btnPrintHide() //隐藏打印按钮
