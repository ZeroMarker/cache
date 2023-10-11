// var userid = session['LOGON.USERID'];
var acctbookid = IsExistAcctBook();
var userid = session['LOGON.USERID'];
var departcontrasturl = 'herp.acct.departcontrastexe.csp';

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
			url: departcontrasturl + '?action=AcctBook&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('AcctBookFieldt').getRawValue())
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
				DepartStore.removeAll();
				AcctDepartField.setValue();
				DepartStore.on('beforeload', function (ds, o) {
					ds.proxy = new Ext.data.HttpProxy({
							method: 'POST',
							url: departcontrasturl + '?action=GetDepart&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('AcctDepartField').getRawValue()) + '&AcctBookID=' + BookID
						})
				});
				DepartStore.load();

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
				rows = currow[0].data["AcctBusiDeptMapID"];
				var BookID = AcctBook.getValue(); //currow[0].data["BookName"];
				//alert(currow+"&"+BookID)
				if (BookID != "") {
					colDepartStore.removeAll();
					// AcctDepart.setValue();
					currow[0].data["AcctDeptName"] = ""; //选择账套后，科室名称列先置空
					colDepartStore.on('beforeload', function (ds, o) {
						ds.proxy = new Ext.data.HttpProxy({
								method: 'POST',
								url: departcontrasturl + '?action=GetDepart&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('AcctDepartField').getRawValue()) + '&AcctBookID=' + BookID
							})
					});
					colDepartStore.load();
				}
			}
			/*,
			scope:this  */

		}

	});
/**********会计科室*********/
var DepartStore = new Ext.data.Store({
		autoLoad: false,
		proxy: '',
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['CheckItemCode', 'CheckItemName'])
	});

var AcctDepartField = new Ext.form.ComboBox({
		id: 'AcctDepartField',
		fieldLabel: '会计科室',
		width: 150,
		listWidth: 225,
		queryModel: 'local',
		lazyRender: true, //选择时加载
		minChars: 1,
		pageSize: 10,
		store: DepartStore,
		displayField: 'CheckItemName',
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
					DepartStore.removeAll();
					AcctDepartField.setValue();
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
//会计科室数据列
var colDepartStore = new Ext.data.Store({
		autoLoad: false,
		proxy: '',
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['CheckItemCode', 'CheckItemName'])
	});

var AcctDepart = new Ext.form.ComboBox({
		id: 'AcctDepart',
		fieldLabel: '会计科室',
		width: 150,
		listWidth: 225,
		// lazyRender : true, //选择时加载
		minChars: 1,
		pageSize: 10,
		// queryModel : 'local',
		store: colDepartStore,
		displayField: 'CheckItemName',
		valueField: 'CheckItemCode',
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
				if (rows != records[0].data["AcctBusiDeptMapID"]) { //判断选择行是不是单位账套改变行
					colDepartStore.removeAll();
					AcctDepart.setValue();
					colDepartStore.on('beforeload', function (ds, o) {
						ds.proxy = new Ext.data.HttpProxy({
								method: 'POST',
								url: departcontrasturl + '?action=GetDepart&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('AcctDepartField').getRawValue()) + '&AcctBookName=' + encodeURIComponent(BookName)
							})
					});
					colDepartStore.load();
				}
			}
			/*      ,
			blur:function(){
			colDepartStore.removeAll();
			} */
		}

	});
/**********业务科室*********/
var BusiDepartField = new Ext.form.TextField({
		id: 'BusiDepartField',
		fieldLabel: '业务科室',
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
			url: departcontrasturl + '?action=GetBusiSys&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('BusiSystemField').getRawValue())
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

/**********科室类别*********/
var DeptType = new Ext.form.ComboBox({
		id: 'DeptType',
		fieldLabel: '科室类别',
		width: 150,
		mode: 'local',
		store: new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['01', '临床科室'], ['02', '管理科室'], ['90', '通用科室']]
		}),
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all'
		//typeAhead : true
	});

/**********查询按钮*********/
var findButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'find',
		handler: function () {
			var acctbookid = AcctBookFieldt.getValue(),
			acctdepart = AcctDepartField.getValue(),
			busisystem = BusiSystemField.getValue(),
			busidepart = BusiDepartField.getValue();
			var limits=Ext.getCmp("PageSizePlugin").getValue();
			 //alert(limits);
	         if(!limits){limits=25};
			gridpanel.store.load({
				params: {
					start: 0,
					limit: limits,
					AcctBookID: acctbookid,
					AcctDeptCode: acctdepart,
					BusiDeptCode: busidepart,
					SystemName: busisystem

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
/*********主数据源***********/
/* var gridStore = new Ext.data.Store({
proxy : new Ext.data.HttpProxy({
mothed : 'POST',
url : departcontrasturl + '?action=list'
}),
reader : new Ext.data.JsonReader({
totalProperty : 'results',
root : 'rows'
}, ['AcctBusiDeptMapID', 'BookName', 'SystemName', 'AcctDeptCode', 'AcctDeptName', 'BusiDeptCode', 'BusiDeptName', 'DeptType'])
}); */

//['会计账套：', AcctBookFieldt, '-', '会计科室：', AcctDepartField, '-',
// '业务科室：', BusiDepartField, '-', '业务系统：', BusiSystemField, '-', findButton],

var queryPanel = new Ext.FormPanel({
		region: 'north',
		height: 45,
		frame: true,
		defaults: {
			labelAlign: 'right', //标签对齐方式
			labelSeparator: ' ', //分隔符
			labelWidth: 60,
			width: 250,
			border: false,
			bodyStyle: 'padding:5px;'
		},
		width: 1200,
		layout: 'column',
		items: [{
				xtype: 'fieldset',
				items: AcctBookFieldt
			}, {
				xtype: 'fieldset',
				items: AcctDepartField
			},{
				xtype: 'fieldset',
				items: BusiDepartField
			},{
				xtype: 'fieldset',
				items: BusiSystemField
			}, {
				xtype: 'fieldset',
				width:100,
				items: findButton
			}
		]

	});

// var buttons = new Ext.Toolbar();
var gridpanel = new dhc.herp.Grid({
		// atLoad : true,
		region: 'center',
		trackMouseOver: true,
		stripeRows: true,
		url: departcontrasturl,
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true
		}),
		tbar: [addButton, '-', saveButton, '-', delButton, '-', importButton],
		fields: [new Ext.grid.CheckboxSelectionModel({
				editable: false
			}), {
				id: 'AcctBusiDeptMapID',
				header: '<div style="text-align:center">科室对照表ID</div>',
				dataIndex: 'AcctBusiDeptMapID',
				width: 60,
				align: 'center',
				hidden: true
			}, {
				id: 'AcctBookID',
				header: '<div style="text-align:center">会计账套ID</div>',
				dataIndex: 'AcctBookID',
				width: 180,
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
				id: 'AcctDeptCode',
				header: '<div style="text-align:center">会计科室编码</div>',
				dataIndex: 'AcctDeptCode',
				width: 180,
				align: 'left',
				hidden: true
			}, {
				id: 'AcctDeptName',
				header: '<div style="text-align:center">会计科室名称</div>',
				dataIndex: 'AcctDeptName',
				type: AcctDepart,
				allowBlank: false,
				width: 125,
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
				id: 'DeptType',
				header: '<div style="text-align:center">科室类别</div>',
				dataIndex: 'DeptType',
				type: DeptType,
				allowBlank: false,
				width: 100,
				align: 'center'
			}, {
				id: 'BusiDeptID',
				header: '<div style="text-align:center">业务科室ID</div>',
				dataIndex: 'AcctBusiDeptMapID',
				allowBlank: false,
				width: 150,
				align: 'center',
				hidden: true
			}, {
				id: 'BusiDeptCode',
				header: '<div style="text-align:center">业务科室编码</div>',
				dataIndex: 'BusiDeptCode',
				allowBlank: false,
				width: 150,
				align: 'left'
			}, {
				id: 'BusiDeptName',
				header: '<div style="text-align:center">业务科室名称</div>',
				dataIndex: 'BusiDeptName',
				allowBlank: false,
				width: 180,
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
