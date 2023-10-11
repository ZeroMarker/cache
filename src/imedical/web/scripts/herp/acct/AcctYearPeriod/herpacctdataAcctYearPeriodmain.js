
var acctbookid = IsExistAcctBook();
var tmpUrl = '../csp/herp.acct.acctyearperiodexe.csp';
//单位帐套下拉列表框
var unitDs = new Ext.data.Store({
		autoLoad: true,
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		},
			['rowid', 'name'])
	});

unitDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: tmpUrl + '?action=caldept&acctbookid=' + acctbookid, //&str='+encodeURIComponent(Ext.getCmp('unitField').getRawValue())});
			method: 'POST'
		});
});

// 会计期间批量生成
var yearButton = new Ext.Toolbar.Button({
		text: '会计期间批量生成',
		tooltip: '会计期间批量生成',
		iconCls: 'adds',
		handler: function () {
			//alert("ssssssssssssssss");
			addwinFun(acctbookid);
		}
	});

//会计年度
var acctYearField = new Ext.form.TextField({
		id: 'acctYearField',
		fieldLabel: '会计年度',
		width: 150,
		listWidth: 245,
		triggerAction: 'all',
		emptyText: '输入年份（如：2017）',
		name: 'acctYearField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true,
		listeners: {
			specialKey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					if (acctYearField.getValue() != "") {
						findButton.handler();
					}
				}
			}
		}
	});

//查询按钮
var findButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		width: 70,
		iconCls: 'find',
		handler: function () {

			var acctYear = acctYearField.getValue();
			//alert(acctYear);
			itemGrid.load({
				params: {
					start: 0,
					limit: 25,
					acctYear: acctYear
				}
			});
		}
	});

var unitField = new Ext.form.ComboBox({
		id: 'unitField',
		fieldLabel: '单位账套ID',
		width: 200,
		listWidth: 200,
		allowBlank: false,
		store: unitDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText: '请选择单位账套ID...',
		name: 'unitField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: true,
		editable: true
	});

var queryPanel = new Ext.form.FormPanel({
		title: '会计期间维护',
		iconCls: 'maintain',
		height: 70,
		width: 400,
		region: 'north',
		frame: true,
		labelWidth: 140,
		// labelAlign:'right',
		// autoHeight:true,
		defaults: {
			bodyStyle: 'padding:5px'
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				items: [{
						xtype: 'displayfield',
						value: '会计年度',
						width: 60
					}, acctYearField, {
						xtype: 'displayfield',
						value: '',
						style: 'padding-top:3px;',
						width: 50
					}, findButton]
			}
		]
	});

var itemGrid = new dhc.herp.Grid({
		//title: '会计期间维护',
		width: 400,
		//edit:false,                   //是否可编辑
		readerModel: 'remote',
		region: 'center',
		url: tmpUrl,

		atLoad: true, // 是否自动刷新
		loadmask: true,
		//tbar:['会计年度:',acctYearField,'-',findButton],
		fields: [{
				id: 'AcctYearPeriodID',
				header: '会计期间ID',
				editable: true,
				allowBlank: true,
				width: 130,
				dataIndex: 'rowid',
				hidden: true
			},{
				id: 'BookName',
				header: '<div style="text-align:center">单位账套名称</div>',
				calunit: true,
				allowBlank: false,
				width: 180,
				dataIndex: 'BookName',
				type: unitField
			}, {
				id: 'acctYear',
				header: '<div style="text-align:center">会计年度</div>',
				editable: true,
				allowBlank: false,
				align: 'center',
				width: 80,
				dataIndex: 'acctYear'
			}, {
				id: 'acctMonth',
				header: '<div style="text-align:center">会计月份</div>',
				editable: true,
				allowblank: false,
				align: 'center',
				width: 80,
				dataIndex: 'acctMonth'
			},  {
				id: 'beginDate',
				header: '<div style="text-align:center">开始日期</div>',
				editable: true,
				allowBlank: true,
				align: 'center',
				width: 100,
				dataIndex: 'beginDate',
				type: "dateField"
				//dateFormat: 'Y-m-d'
			}, {
				id: 'endDate',
				header: '<div style="text-align:center">结束日期</div>',
				editable: true,
				allowBlank: true,
				align: 'center',
				width: 100,
				dataIndex: 'endDate',
				type: "dateField"
				//dateFormat: 'Y-m-d'

			}, {
				id: 'periodStatus',
				header: '<div style="text-align:center">期间状态</div>',
				allowBlank: true,
				align: 'center',
				width: 90,
				dataIndex: 'periodStatus',
				editable: false
			}, {
				id: 'startFlag',
				header: '<div style="text-align:center">开始标识</div>',
				editable: true,
				allowBlank: true,
				align: 'center',
				width: 70,
				dataIndex: 'startFlag',
				hidden: true
			}, {
				id: 'cashFlag',
				header: '<div style="text-align:center">银行对账初始化</div>',
				editable: false,
				allowBlank: true,
				align: 'center',
				width: 90,
				hidden: true,
				dataIndex: 'cashFlag'
			}, {
				id: 'maxVouchNo',
				header: '<div style="text-align:center">最大凭证号</div>',
				editable: false,
				allowBlank: true,
				align: 'center',
				hidden: true,
				width: 180,
				dataIndex: 'maxVouchNo'
			}
		]
	});
//alert(acctbookid);
itemGrid.load({
	params: {
		sortField: '',
		sortDir: '',
		start: 0,
		limit: 25,
		acctbookid: acctbookid
	}
});

//itemGrid.addButton('-');
//itemGrid.addButton(findButton);
itemGrid.addButton('-');
itemGrid.addButton(yearButton);
itemGrid.btnDeleteHide(); //隐藏删除按钮
itemGrid.btnResetHide(); //隐藏重置按钮
itemGrid.btnPrintHide(); //隐藏打印按钮
