var userdr = session['LOGON.USERID']; //登录人ID

var acctbookid = IsExistAcctBook();

var itemGridUrl = 'herp.acct.acctcashflowledgerexe.csp';

//初始化状态提示
var FinStyField = new Ext.form.DisplayField({ //原为TextField
		id: 'FinStyField',
		name: 'FinStyField',
		style: 'text-align:left;color:red;', //文本框对齐方式
		triggerAction: 'all',
		disabled: false
	});
Ext.Ajax.request({
	url: '../csp/herp.acct.acctcashflowledgerexe.csp?action=Getflagsty&acctbookid=' + acctbookid,
	method: 'GET',
	success: function (result, request) {
		var jsonData = Ext.util.JSON.decode(result.responseText);
		if (jsonData.success == 'true') {
			rtndata = jsonData.info;
			FinStyField.setValue(rtndata);
			//finishButton.disabled='true';
			//introButton.disabled='true';
			//uploadButton.disabled='true';
		}
	}

});

//账套建账时间显示
var AcctYearMonthField = new Ext.form.DisplayField({ //原为TextField
		id: 'AcctYearMonthField',
		name: 'AcctYearMonthField',
		style: 'text-align:left;color:black;', //文本框对齐方式
		triggerAction: 'all',
		disabled: false
	});
Ext.Ajax.request({
	url: '../csp/herp.acct.acctcashflowledgerexe.csp?action=GetAcctCurYearMonth&acctbookid=' + acctbookid,
	method: 'GET',
	success: function (result, request) {
		var jsonData = Ext.util.JSON.decode(result.responseText);
		if (jsonData.success == 'true') {
			rtndata = jsonData.info;
			AcctYearMonthField.setValue(rtndata);
		}
	}

});

//显示资金流向//
var CFDirectionFieldDS = new Ext.data.SimpleStore({ //资金流向状态
		fields: ['key', 'keyValue'],
		data: [['0', '流入'], ['1', '流出']]
	});
////配置下拉框--资金流量状态查询----CFDirection-----////
var CFDirectionField = new Ext.form.ComboBox({
		id: 'CFDirectionField',
		fieldLabel: '资金流向',
		style: 'overflow:hidden',
		width: 120,
		blankText: "请选择资金流向",
		listWidth: 100,
		store: CFDirectionFieldDS,
		displayField: 'keyValue',
		valueField: 'key',
		mode: 'local', // 本地模式
		triggerAction: 'all',
		selectOnFocus: true,
		forceSelection: true,
		editable: true
	});

var editCFDirectionField = new Ext.form.ComboBox({
		id: 'editCFDirectionField',
		fieldLabel: '资金流向',
		blankText: "请选择资金流向",
		style: 'overflow:hidden',
		width: 100,
		listWidth: 100,
		typeAhead: true,
		store: CFDirectionFieldDS,
		editable: false,
		minChars: 1,
		//valueNotFoundText : '',
		displayField: 'keyValue',
		valueField: 'key',
		typeAhead: true,
		mode: 'local', // 本地模式
		triggerAction: 'all',
		editable: true,
		selectOnFocus: true,
		forceSelection: true
	});

//显示币种//
var CurrNameFieldDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['code', 'name'])
	});

CurrNameFieldDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: itemGridUrl + '?action=GetCurrName',
			method: 'POST'
		});
});

var CurrNameField = new Ext.form.ComboBox({
		id: 'CurrNameField',
		fieldLabel: '币种',
		width: 120,
		//listWidth : 60,
		//allowBlank : false,
		store: CurrNameFieldDs,
		displayField: 'name',
		valueField: 'code',
		triggerAction: 'all',
		//emptyText : '请选择...',
		minChars: 1,
		listWidth: 250,
		anchor: '95%',
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: true,
		editable: true,
		resizable: true
	});
CurrNameField.on('select', function (combo, record, index) {
	tmpdeptdr = combo.getValue();
});

var CurrDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['code', 'name'])
	});

CurrDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: itemGridUrl + '?action=GetCurrName',
			method: 'POST'
		});
});

var editCurrNameField = new Ext.form.ComboBox({
		id: 'editCurrNameField',
		fieldLabel: '币种',
		width: 100,
		listWidth: 220,
		store: CurrDs,
		editable: true,
		minChars: 1,
		pageSize: 10,
		displayField: 'name',
		valueField: 'code',
		//mode : 'local', // 本地模式
		triggerAction: 'all',
		emptyText: '请选择...',
		selectOnFocus: true,
		forceSelection: true
	});
editCurrNameField.on('select', function (combo, record, index) {
	tmpdeptdr = combo.getValue();
});

//查询按钮

var findButton = new Ext.Toolbar.Button({
		text: '查询',
		iconCls: 'find',
		tooltip: '查询',
		handler: function () {
			var cfdirection = CFDirectionField.getValue();
			var acctcurcode = CurrNameField.getValue();
			itemGrid.load({
				params: {
					start: 0,
					limit: 25,
					direction: cfdirection,
					acctcurcode: acctcurcode,
					acctbookid: acctbookid

				}
			});

		}
	});

///流量项引入按钮
var introButton = new Ext.Toolbar.Button({
		text: '流量项引入',
		tooltip: '流量项引入',
		iconCls: 'leadinto',
		handler: function () {
			var acctcurcode = CurrNameField.getValue();
			var rowObj = itemGrid.getSelectionModel().getSelections();

			if (acctcurcode == "") {

				Ext.Msg.show({
					title: '注意',
					msg: '请先选择币种 ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				//var rowid = rowObj[0].get("rowid");
				return;
			}
			function handler(id) {
				if (id == "yes") {
					Ext.Ajax.request({
						url: '../csp/herp.acct.acctcashflowledgerexe.csp?action=GetAcctDirection&acctbookid=' + acctbookid + '&acctcurcode=' + acctcurcode,
						waitMsg: '审核中...',
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title: '注意',
									msg: '流量项引入操作成功! ',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});
								itemGrid.load();
							} else {
								Ext.Msg.show({
									title: '提示',
									msg: '没有可引入新的数据! ',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.WARNING
								});
							}
						},
						scope: this
					});

				}
			}
			Ext.MessageBox.confirm('提示', '确实要进行流量引入操作吗? ', handler);
		}
	});

//导入按钮
var uploadButton = new Ext.Toolbar.Button({
		text: '导入',
		tooltip: '导入',
		iconCls: 'in',
		handler: function () {
			doimport();

		}
	});

//汇总计算按钮
var sumButton = new Ext.Toolbar.Button({
		text: '汇总计算',
		tooltip: '汇总计算',
		iconCls: 'calculate',
		handler: function () {

			var myData = [];
			var Title = "";
			var JName = "";
			Ext.Ajax.request({
				url: itemGridUrl + '?action=Sumlacation&acctbookid=' + acctbookid,
				success: function (result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						var money = jsonData.info;
						//alert(money);
						var arr = money.split("^");
						Title = arr[0];
						JName = arr[1];
						//alert(Title+'^'+JName);
						var a = ["流入", Title];
						var b = ["流出", JName];
						myData.push(a);
						myData.push(b);

						var store = new Ext.data.ArrayStore({
								fields: [{
										name: 'direction'
									}, {
										name: 'flowtotalsum'
									}
								]
							});
						store.loadData(myData);
						var grid = new Ext.grid.GridPanel({
								store: store,
								columns: [{

										header: '资金流向',
										width: 120,
										align: 'center',
										sortable: true,
										dataIndex: 'direction'
									}, {
										header: '金额',
										width: 150,
										align: 'center',
										sortable: true,
										renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
											return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
										},
										dataIndex: 'flowtotalsum'
									}
								]

							});
						var window = new Ext.Window({
								title: '汇总计算显示框',
								width: 300,
								height: 180,
								layout: 'fit',
								plain: true,
								modal: true,
								bodyStyle: 'padding:5px;',
								buttonAlign: 'center',
								//sumButton:'center',
								//style:"text-align:center",
								//buttonAlign : "sorth",
								items: grid,
								buttons: [{
										text: '取消',
										handler: function () {
											window.close();
										}
									}
								]
							});
						window.show();

					} else {
						var message = "";
						Ext.Msg.show({
							title: '错误',
							msg: message,
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.ERROR
						});
					}
				}

			});

		}
	});

///初始化完成按钮
var finishButton = new Ext.Toolbar.Button({
		text: '初始化完成',
		tooltip: '初始化完成',
		iconCls: 'datainit',
		//iconCls:'finish',
		handler: function () {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var date = AcctYearMonthField.getValue();
			var year = date.substr(0, 4);
			var month = date.substr(6, 7);
			function handler(id) {
				if (id == "yes") {
					Ext.Ajax.request({
						url: '../csp/herp.acct.acctcashflowledgerexe.csp?action=Compinit&acctbookid=' + acctbookid + '&userdr=' + userdr,
						waitMsg: '审核中...',
						failure: function (result, request) {
							Ext.Msg.show({
								title: '错误',
								msg: '请检查网络连接! ',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR
							});
						},
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title: '提示',
									msg: year + "年的数据" + "初始化完成! ",
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});

								var rtndata = jsonData.info;
								if (rtndata !== 0) {
									FinStyField.setValue(rtndata);

									//introButton.disabled='true';
									//uploadButton.disabled='true';
									//SaveButton.disabled='true';
									//finishButton.disabled='true';
									introButton.setEnabled
								}
								itemGrid.load()
							} else {
								Ext.Msg.show({
									title: '提示',
									msg: '初始化操作失败! ',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.WARNING
								});
							}
						},
						scope: this
					});

				}
			}
			Ext.MessageBox.confirm('提示', '确实要进行初始化操作吗? ', handler);
		}
	});

//配件数据源

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
				'flowitemid',
				'acctbookid',
				'Cilevel',
				'acctyear',
				'acctmonth',
				'itemcode',
				'itemname',
				'direction',
				'acctcurcode',
				'flowsum',
				'flowtotalsum',
				'islast',
				'isInit'

			]),
		remoteSort: true
	});

var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 25,
		store: itemGridDs,
		atLoad: true,
		displayInfo: true,
		plugins: new dhc.herp.PageSizePlugin(),
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据" //,

	});
//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('rowid', 'name');

var sysStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [['0', '预算编制'], ['1', '项目支出']]
	});
var syscomb = new Ext.form.ComboBox({
		id: 'sysno',
		fieldLabel: '应用系统',
		width: 180,
		listWidth: 180,
		selectOnFocus: true,
		allowBlank: false,
		store: sysStore,
		anchor: '90%',
		valueNotFoundText: '',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText: '选择期间类型...',
		mode: 'local', //本地模式
		editable: false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

var SaveButton = new Ext.Toolbar.Button({
		text: '保存',
		tooltip: '保存',
		iconCls: 'save',
		handler: function () {
			itemGrid.save();

			var cfdirection = CFDirectionField.getValue();
			var acctcurcode = CurrNameField.getValue();
			itemGrid.load({
				params: {
					start: 0,
					limit: 25,
					direction: cfdirection,
					acctcurcode: acctcurcode,
					acctbookid: acctbookid

				}
			});

		}
	});

var query = new Ext.FormPanel({
		title: '现金流量数据初始化',
		iconCls: 'datainit',
		region: 'north',
		height: 70,
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px '
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '初始化状态:',
						style: 'line-height: 15px;padding-Right:5px;',
						width: 80
					}, FinStyField, {
						xtype: 'displayfield',
						value: '',
						style: 'line-height: 15px;',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '账套建账时间:',
						width: 90
					}, AcctYearMonthField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '资金流向',
						style: 'line-height: 15px;',
						width: 70
					}, CFDirectionField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '币种',
						style: 'line-height: 15px;',
						width: 40
					}, CurrNameField, {
						xtype: 'displayfield',
						value: '',
						width: 15
					}, findButton
				]
			}
		]

	});
//tbar:["初始化状态:",FinStyField,"-","账套建账时间:",AcctYearMonthField,"-","资金流向:",CFDirectionField,"-","币种:",CurrNameField,"-",findButton]
//数据库数据模型

var tbar1 = new Ext.Toolbar([SaveButton, "-", introButton, "-", uploadButton, "-", sumButton, "-", finishButton]);

//表格

var itemGrid = new dhc.herp.Grid({
		//title: '现金流量数据初始化',
		width: 400, //是否可编辑
		readerModel: 'remote',
		region: 'center',
		url: 'herp.acct.acctcashflowledgerexe.csp',
		atLoad: true, // 是否自动刷新
		loadmask: true,
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true
		}),
		fields: [{
				id: 'rowid',
				header: 'id',
				dataIndex: 'rowid',
				width: 150,
				hidden: true,
				editable: true,
				sortable: true

			}, {
				id: 'ItemName',
				header: '<div style="text-align:center">项目名称</div>',
				allowBlank: true,
				dataIndex: 'itemname',
				width: 350,
				align: 'left',
				editable: false,
				hidden: false,
				sortable: true
			}, {
				id: 'direction',
				header: '<div style="text-align:center">流量方向</div>',
				allowBlank: true,
				dataIndex: 'direction',
				width: 120,
				align: 'center',
				hidden: false,
				editable: true,
				type: editCFDirectionField

			}, {
				id: 'acctcurcode',
				header: '<div style="text-align:center">币种</div>',
				dataIndex: 'acctcurcode',
				width: 120,
				align: 'center',
				editable: true,
				hidden: false,
				sortable: true,
				type: editCurrNameField
			}, {
				id: 'flowsum',
				header: '<div style="text-align:center">本期流量金额</div>',
				allowBlank: true,
				width: 150,
				align: 'right',
				hidden: true,
				editable: true,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				}, //金额格式化
				dataIndex: 'flowsum'
			}, {
				id: 'flowtotalsum',
				header: '<div style="text-align:center">累计流量金额</div>',
				allowBlank: true,
				width: 150,
				align: 'right',
				hidden: false,
				editable: true,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				}, //金额格式化
				dataIndex: 'flowtotalsum'
			}, {
				id: 'isInit',
				header: '<div style="text-align:center">是否完成初始化</div>',
				editable: false,
				hidden: true,
				width: 120,
				align: 'center',
				dataIndex: 'isInit',
				editable: true,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					var Init = record.data['isInit']
						if (Init == "1") {
							introButton.disable();
							uploadButton.disable();
							SaveButton.disable();
							finishButton.disable();
							return
						}
				}

			}, {
				id: 'islast',
				header: '<div style="text-align:center">是否末级</div>',
				editable: false,
				hidden: true,
				width: 120,
				align: 'center',
				dataIndex: 'islast',
				editable: true,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					var sf = record.data['islast']
						if (sf == "是") {
							return '<span style="cursor:hand">' + value + '</span>';
						}
						if (sf == "否") {
							return '<span style="color:blue;cursor:hand">' + value + '</span>';
						}

				}
			}
		],

		listeners: {
			'cellclick': function (grid, rowIndex, columnIndex, e) {
				var record = grid.getStore().getAt(rowIndex);
				//alert(columnIndex);
				//alert(record.get('islast'));
				//alert(InitState);
				if ((record.get('islast') == "否") || (record.get('isInit') == "1")) {
					return false;

				} else {
					return true;
				}

			},
			'render': function () {
				tbar1.render(itemGrid.tbar);
			}

		}

	});

itemGrid.btnAddHide(); //隐藏增加按钮
itemGrid.btnResetHide(); //隐藏重置按钮
itemGrid.btnDeleteHide(); //隐藏删除按钮
itemGrid.btnPrintHide(); //隐藏打印按钮
itemGrid.btnSaveHide();
