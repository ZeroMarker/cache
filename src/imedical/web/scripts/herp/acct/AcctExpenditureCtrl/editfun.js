EditFun = function (itemGrid) {

	var username = session['LOGON.USERNAME'];
	var userId = session['LOGON.USERID'];
	Username = userId + '_' + username;
	var billcode = "";
	var statetitle = name + "支出申请";

	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var rowidm = selectedRow[0].data['rowid'];
	var yearmonth = selectedRow[0].data['checkyearmonth'];
	var billcode = selectedRow[0].data['billcode'];
	var dname = selectedRow[0].data['dname'];
	var uname = selectedRow[0].data['applyer'];
	var mdesc = selectedRow[0].data['applydecl'];
	var deptdr = selectedRow[0].data['deprdr'];
	var applycode = selectedRow[0].data['applycode'];
	dname = deptdr + '_' + dname;
	var billstate = selectedRow[0].data['billstate'];
	var audeprdr = selectedRow[0].data['audeprdr'];
	var audname = selectedRow[0].data['audname'];
	var audname = audeprdr + '_' + audname;
	var CheckDR = selectedRow[0].data['CheckDR'];
	var FundSour = selectedRow[0].data['FundSour'];

	/////////////////////报销单号/////////////////////////
	var applyNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value : billcode,
			disabled : true,
			selectOnFocus : true

		});
	/////////////////////申请人/////////////////////////
	var appuName = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value : uname,
			disabled : true,
			selectOnFocus : true

		});
	/////////////////////申请说明/////////////////////////
	Descfield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value : mdesc,
			disabled : true,
			selectOnFocus : true
		});
	/////////////////////预算期/////////////////////////
	var timeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['yearmonth', 'yearmonth'])
		});

	timeDs.on('beforeload', function (ds, o) {

		ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.acct.expenseaccountdetailexe.csp?action=timelist',
				method : 'POST'
			});
	});

	timeCombo = new Ext.form.ComboBox({
			fieldLabel : '预算期',
			store : timeDs,
			displayField : 'yearmonth',
			valueField : 'yearmonth',
			disabled : false,
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			value : yearmonth,
			emptyText : '请选择...',
			width : 100,
			listWidth : 220,
			columnWidth : .15,
			pageSize : 10,
			minChars : 1,
			disabled : true,
			selectOnFocus : true
		});

	/////////////////////报销科室/////////////////////////
	var dnamefield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value : dname,
			emptyText : '回车生成科室...',
			disabled : true,
			selectOnFocus : true

		});
	///////////////////////资金申请单号/////////////////////
	var applyDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'applycode'])
		});

	applyDs.on('beforeload', function (ds, o) {

		ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.acct.expenseaccountdetailexe.csp?action=applycode&&userdr=' + userId,
				method : 'POST'
			});
	});

	applyCombo = new Ext.form.ComboBox({
			fieldLabel : '资金申请单号',
			store : applyDs,
			displayField : 'applycode',
			valueField : 'rowid',
			disabled : true,
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 90,
			value : applycode,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true
		});

	applyCombo.on('focus', function (f) {
		AddReqFun(applyCombo);
	});

	///////////////归口科室////////////////////////
	var audnameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'name'])
		});

	audnameDs.on('beforeload', function (ds, o) {

		ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.budgctrlfundbillmngexe.csp?action=deptlist&flag=1',
				method : 'POST'
			});
	});

	var audnamefield = new Ext.form.ComboBox({
			fieldLabel : '归口科室',
			store : audnameDs,
			displayField : 'name',
			valueField : 'rowid',
			value : audname,
			typeAhead : true,
			disabled : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true

		});
	////////////审批流//////////////////////
	var checkflowDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'name'])
		});

	checkflowDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=checkflowlist',
				method : 'POST'
			});
	});

	var checkflowField = new Ext.form.ComboBox({
			fieldLabel : '审批流',
			store : checkflowDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			value : CheckDR,
			disabled : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 100,
			listWidth : 220,
			columnWidth : .15,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true

		});
	/////////////////////资金来源////////////////////////////
	var fundsourceStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '现金'], ['2', '银行']]
		});
	var fundsourceField = new Ext.form.ComboBox({
			id : 'fundsourceField',
			fieldLabel : '资金来源',
			width : 120,
			allowBlank : false,
			store : fundsourceStore,
			value : FundSour,
			anchor : '90%',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '选择...',
			mode : 'local', // 本地模式
			pageSize : 10,
			minChars : 15,
			columnWidth : .15,
			selectOnFocus : true,
			disabled : true,
			forceSelection : true
		});

	var queryPanel = new Ext.FormPanel({
			height : 120,
			region : 'north',
			frame : true,
			defaults : {
				bodyStyle : 'padding:5px'
			},
			items : [{
					columnWidth : 1,
					xtype : 'panel',
					layout : "column",
					items : [{
							xtype : 'displayfield',
							value : '报销单号:',
							columnWidth : .12
						}, applyNo, {
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						}, {
							xtype : 'displayfield',
							value : '报销科室:',
							columnWidth : .12
						}, dnamefield, {
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						}, {
							xtype : 'displayfield',
							value : '申请人:',
							columnWidth : .12
						}, appuName

					]
				}, {
					columnWidth : 1,
					xtype : 'panel',
					layout : "column",
					items : [{
							xtype : 'displayfield',
							value : '报销说明:',
							columnWidth : .12
						}, Descfield, {
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						}, {
							xtype : 'displayfield',
							value : '预算期:',
							columnWidth : .12
						}, timeCombo, {
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						}, {
							xtype : 'displayfield',
							value : '资金申请单号:',
							columnWidth : .12
						}, applyCombo

					]
				}, {
					columnWidth : 1,
					xtype : 'panel',
					layout : "column",
					items : [{
							xtype : 'displayfield',
							value : '归口科室:',
							columnWidth : .12
						}, audnamefield, {
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						}, {
							xtype : 'displayfield',
							value : '审批流:',
							columnWidth : .12
						}, checkflowField, {
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						}, {
							xtype : 'displayfield',
							value : '资金来源:',
							columnWidth : .12
						}, fundsourceField
					]
				}
			]
		});



	var editGrid = new dhc.herp.GridDetail({
			width : 600,
			height : 150,
			region : 'center',
			url : 'herp.acct.acctexpenditurectrlexe.csp', //'herp.acct.expenseaccountdetailexe.csp',
			fields : [{
					header : 'ID',
					width : 30,
					editable : false,
					dataIndex : 'rowid',
					hidden : true
				}, {
					id : 'billdr',
					header : '申请主表ID',
					dataIndex : 'billdr',
					width : 120,
					hidden : true
				}, {
					id : 'itemcode',
					header : '预算项编码',
					dataIndex : 'itemcode',
					hidden : true,
					width : 120
				}, {
					id : 'itemname',
					header : '预算项',
					dataIndex : 'itemname',
					editable : false,
					width : 120
				}, {
					id : 'balance',
					header : '当前预算结余',
					dataIndex : 'balance',
					align : 'right',
					xtype : 'numbercolumn',
					width : 120,
					editable : false
				}, {
					id : 'reqpay',
					header : '本次报销申请',
					dataIndex : 'reqpay',
					align : 'right',
					editable : false,
					xtype : 'numbercolumn',
					renderer : function (value, cellmeta, record, rowIndex, columnIndex, store) {
						cellmeta.css = "cellColor3"; // 设置可编辑的单元格背景色
						return '<span style="color:black;cursor:hand;backgroundColor:red">' + value + '</span>';
					},
					width : 120
				}, {
					id : 'actpay',
					header : '审批支付',
					align : 'right',
					xtype : 'numbercolumn',
					renderer : function (value, cellmeta, record, rowIndex, columnIndex, store) {
						cellmeta.css = "cellColor3"; // 设置可编辑的单元格背景色
						return '<span style="color:black;cursor:hand;backgroundColor:red">' + value + '</span>';
					},
					dataIndex : 'actpay',
					editable : false,
					width : 120
				}, {
					id : 'balance1',
					header : '审批后预算结余',
					dataIndex : 'balance1',
					align : 'right',
					xtype : 'numbercolumn',
					editable : false,
					width : 120

				}, {
					id : 'budgcotrol',
					header : '预算控制',
					dataIndex : 'budgcotrol',
					width : 100,
					renderer : function (value, cellmeta, record, rowIndex, columnIndex, store) {
						var sf = record.data['budgcotrol']
							if (sf == "超预算") {
								return '<span style="color:red;cursor:hand;">' + value + '</span>';
							} else {
								return '<span style="color:black;cursor:hand">' + value + '</span>';
							}
					},
					editable : false
				}, {
					id : 'State',
					header : '状态',
					dataIndex : 'State',
					editable : false,
					width : 80
				}
			],
			viewConfig : {
				forceFit : true
			}
		});
	editGrid.load({
		params : {
			start : 0,
			limit : 25,
			billcode : billcode
		}
	});



	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({
			text : '关闭',
			iconCls:'cancel'
		});

	// 定义取消按钮的响应函数
	cancelHandler = function () {
		window.close();
		/* itemGrid.load({
			params : {
				start : 0,
				limit : 12,
				userdr : userId
			}
		}); */
	};

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);

	// 初始化面板
	formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			layout : 'fit',
			labelWidth : 100,
			items : [queryPanel, editGrid]
		});

	var tabPanel = new Ext.Panel({
			//activeTab: 0,
			layout : 'border',
			region : 'center',
			items : [queryPanel, editGrid]//添加Tabs
		});

	var window = new Ext.Window({
			layout : 'fit',
			title : '报销申请',
			plain : true,
			width : 950,
			height : 500,
			modal : true,
			buttonAlign : 'center',
			items : tabPanel,
			buttons : [cancelButton]

		});

	window.show();

};