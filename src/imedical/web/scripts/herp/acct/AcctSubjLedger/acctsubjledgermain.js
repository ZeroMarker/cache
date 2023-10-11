var userdr = session['LOGON.USERID'];
var bookID = IsExistAcctBook();
var projUrl = "herp.acct.acctsubjledgerexe.csp";

var InitState = "";

Ext.Ajax.request({

	url: projUrl + '?action=getBookInitState&bookID=' + bookID,
	method: 'POST',
	////async:false（默认为true）  表示同步加载，会在ajax的success执行完成之后，在执行其他；

	////async:true  表示异步加载，可能会在ajax执行完成之后，就执行下面的方法，从而导致data中没有值；

	//async:false,
	success: function (result, request) {
		var jsonData = Ext.util.JSON.decode(result.responseText);
		if (jsonData.success == 'true') {

			InitState = jsonData.info;
			//alert(InitState);
			if (InitState == "1") {
				itemGrid.edit = false;
				ledgerButton.disable();
				importButton.disable();
			}
		}
	}
});


var StartMonth = "";
Ext.Ajax.request({
	url: '../csp/herp.acct.acctsubjledgerexe.csp?action=GetStartMonth&bookID=' + bookID,
	method: 'GET',
	success: function (result, request) {
		var jsonData = Ext.util.JSON.decode(result.responseText);
		if (jsonData.success == 'true') {
			StartMonth = jsonData.info;
			if (StartMonth == 1) {
				itemGrid.getColumnModel().setHidden(7, true);
				itemGrid.getColumnModel().setHidden(8, true);

			}

		}
	}
});

///////////////科目编码
var subjcodeField = new Ext.form.TextField({
		id: 'subjcodeField',
		fieldLabel: '科目编码',
		width: 130,
		allowBlank: true,
		//style: 'padding:5px;',
		selectOnFocus: 'true',
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == e.ENTER) {
					findButton.handler();
				}
			}
		}
	});

/////////////////////科目类别

var AcctTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['rowid', 'code', 'name'])
	});

AcctTypeDs.on('beforeload', function (ds, o) {

	ds.proxy = new Ext.data.HttpProxy({

			url: projUrl + '?action=GetAcctType',
			method: 'POST'
		});
});
var AcctTypeCombo = new Ext.form.ComboBox({
		fieldLabel: '科目类别',
		store: AcctTypeDs,
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		//forceSelection : true,
		triggerAction: 'all',
		emptyText: '请选择科目类别',
		width: 150,
		listWidth: 220,
		pageSize: 10,
		minChars: 1,
		allowBlank: true
		//selectOnFocus : true
	});

///////////////科目级别///////////////////////

var subjLevelDs = new Ext.data.SimpleStore({ //对账状态
		fields: ['key', 'keyValue'],
		data: [['1', '1'], ['2', '2'], ['3', '3'], ['4', '4'],
			['5', '5'], ['6', '6'], ['7', '7'], ['8', '8']]
	});
////配置下拉框--对账状态查询----IsChecked1-----////
var subjLevelField = new Ext.form.ComboBox({
		id: 'subjLevelField',
		fieldLabel: '科目级别',
		width: 120,
		listWidth: 120,
		store: subjLevelDs,
		valueNotFoundText: '',
		displayField: 'keyValue',
		valueField: 'key',
		mode: 'local', // 本地模式
		triggerAction: 'all',
		emptyText: '全部',
		selectOnFocus: true,
		forceSelection: true
	});

var tmpDataMapping = [];
var tmpUrl = "";
var tmpColumnModel = "";

/////////////////////数量外币科目

var subjnumfcStore = new Ext.data.SimpleStore({
		fields: ['rowid', 'method'],
		data: [['1', '所有'], ['2', '数量'], ['3', '外币']]
	});
var subjnumfcCombo = new Ext.form.ComboBox({
		fieldLabel: '数量外币科目',
		width: 120,
		listWidth: 120,
		selectOnFocus: true,
		allowBlank: true,
		store: subjnumfcStore,
		anchor: '90%',
		value: 1, //默认值
		valueNotFoundText: '',
		displayField: 'method',
		valueField: 'rowid',
		triggerAction: 'all',
		emptyText: '',
		mode: 'local', //本地模式

		listeners: {
			//scope : this,
			'select': function () {
				if (subjnumfcCombo.getValue() == 1) {
					itemGrid.setTitle("金额显示");
					for (var i = 1; i < cmItems.length; i++) {
						//alert(cmItems[i].dataIndex);
						tmpDataMapping.push(cmItems[i].dataIndex);
					};
					//根据ID 得到列索引
					/* 			    var cl = itemGrid.getColumnModel().getIndexById("BeginSum");
					//alert(cl);
					//设置该lie为不可编辑。
					itemGrid.getColumnModel().setEditable(cl, true);   */
					tmpUrl = "../csp/herp.acct.acctsubjledgerexe.csp";
					itemGrid.url = tmpUrl;
					itemGrid.fields = cmItems;
					tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
					itemGrid.createColumns();
					//alert(StartMonth)

				}
				if (subjnumfcCombo.getValue() == 2) {
					itemGrid.setTitle("数量显示");
					for (var i = 1; i < cmItems2.length; i++) {
						//alert(cmItems2[i].dataIndex);
						tmpDataMapping.push(cmItems2[i].dataIndex);
					}
					tmpUrl = "../csp/herp.acct.acctsubjledgernumexe.csp";
					itemGrid.url = tmpUrl;
					itemGrid.fields = cmItems2;
					tmpColumnModel = new Ext.grid.ColumnModel(cmItems2);
					itemGrid.createColumns();

				}

				if (subjnumfcCombo.getValue() == 3) {
					itemGrid.setTitle("外币显示");
					for (var i = 1; i < cmItems3.length; i++) {
						tmpDataMapping.push(cmItems3[i].dataIndex);
					}

					tmpUrl = "../csp/herp.acct.acctsubjledgerfcexe.csp";
					itemGrid.url = tmpUrl;

					itemGrid.fields = cmItems3;
					tmpColumnModel = new Ext.grid.ColumnModel(cmItems3);
					itemGrid.createColumns();
				}

				itemGrid.store.proxy = new Ext.data.HttpProxy({
						url: tmpUrl + '?action=list&bookID=' + bookID,
						method: 'POST'
					});

				itemGrid.store.reader = new Ext.data.JsonReader({
						totalProperty: "results",
						root: 'rows'
					}, tmpDataMapping);

				itemGrid.reconfigure(itemGrid.store, tmpColumnModel);

				if (StartMonth == 1) {
					if (subjnumfcCombo.getValue() == 1) {
						itemGrid.getColumnModel().setHidden(7, true);
						itemGrid.getColumnModel().setHidden(8, true);
					} else if (subjnumfcCombo.getValue() == 2) {
						itemGrid.getColumnModel().setHidden(8, true);
						itemGrid.getColumnModel().setHidden(9, true);
						itemGrid.getColumnModel().setHidden(10, true);
						itemGrid.getColumnModel().setHidden(11, true);
					} else if (subjnumfcCombo.getValue() == 3) {
						itemGrid.getColumnModel().setHidden(10, true);
						itemGrid.getColumnModel().setHidden(11, true);
						itemGrid.getColumnModel().setHidden(12, true);
						itemGrid.getColumnModel().setHidden(13, true);
					}
					//itemGrid.view.refresh();
				}
				var limits=Ext.getCmp('PageSizePlugin').getValue();
				if (!limits){limits=25;}
				var subjcode = subjcodeField.getValue();
				var AcctType = AcctTypeCombo.getValue();
				var subjLevel = subjLevelField.getValue();
				
				itemGrid.store.load({
					params: {
						start: 0,
							limit: limits,
							subjcode:subjcode,
							subjLevel:subjLevel,
							AcctType:AcctType
					}
				});

			}

		}

	});

///////////////导入数据选择///////////////////////

var importDs = new Ext.data.SimpleStore({ //对账状态
		fields: ['key', 'keyValue'],
		data: [['1', '金额数量期初余额导入'], ['2', '外币金额期初数据导入']]
	});
var importField = new Ext.form.ComboBox({
		id: 'importField',
		fieldLabel: '导入数据选择',
		width: 150,
		listWidth: 150,
		store: importDs,
		valueNotFoundText: '',
		displayField: 'keyValue',
		valueField: 'key',
		mode: 'local', // 本地模式
		triggerAction: 'all',
		emptyText: '全部',
		selectOnFocus: true,
		forceSelection: true
	});

var importButton = new Ext.Toolbar.Button({
		text: '导入',
		tooltip: '导入Excel文件',
		iconCls: 'in',
		width: 55,
		handler: function () {
			//调用保存函数
			var importFields = importField.getValue();
			if (importFields == "") {
				Ext.Msg.show({
					title: '注意',
					msg: '请选择导入数据! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.INFO
				});
			} else {
				//alert(importFields);
				doimport(importFields);
			}

		}
	});

var ledgerButton = new Ext.Toolbar.Button({
		text: '账簿生成',
		iconCls: 'submit',
		handler: function () {
			function handler(id) {
				if (id == "yes") {
					Ext.Ajax.request({
						url: projUrl + '?action=Ledgersave&bookID=' + bookID + '&userdr=' + userdr,
						waitMsg: '保存中...',
						failure: function (result, request) {
							Ext.Msg.show({
								title: '错误',
								msg: '请检查网络连接!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR
							});
						},

						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title: '注意',
									msg: '账簿生成成功!',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});
								itemGrid.load({
									params: {
										start: 0,
										limit: 25,
										bookID: bookID
									}
								});

							} else {
								if (jsonData.info = "100") {

									message = "账簿生成成功";
								}
								Ext.Msg.show({
									title: '提示',
									msg: message,
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});
							}
						},
						scope: this
					});
				} else {
					return;
				}
			}
			Ext.MessageBox.confirm('提示', '确实要生成账簿吗?', handler);
		}
	});

var findButton = new Ext.Button({
		text: '查询',
		tooltip: '查询',
		width: 55,
		iconCls: 'find',
		handler: function () {
			var subjcode = subjcodeField.getValue();
			var AcctType = AcctTypeCombo.getValue();
			var subjLevel = subjLevelField.getValue();
			//var bookID= GetAcctBookID();
			//alert(bookID);
			itemGrid.load({
				params: {
					start: 0,
					limit: 25,
					subjcode: subjcode,
					AcctType: AcctType,
					subjLevel: subjLevel,
					bookID: bookID
				}

			});

		}
	});
//删除按钮
var delButton = new Ext.Toolbar.Button({
		text: '删除',
		tooltip: '删除',
		width: 55,
		iconCls: 'remove',
		handler: function () {
			itemGrid.del();

		}
	});

//保存按钮
var saveButton = new Ext.Toolbar.Button({
		text: '保存',
		iconCls: 'save',
		width: 55,
		handler: function () {
			itemGrid.save();
			//ChangeColum();
		}

	});



  var query = new Ext.FormPanel({
	    title: '科目初始余额维护',
		iconCls:'maintain',
		region: 'north',
		height: 110,
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
						value: '科目编码',
						style: 'padding:0px 5px 0px 34px;'
						//width: 60
					}, subjcodeField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '科目类别',
						style: 'padding:0px 5px;'
						//width: 80
					}, AcctTypeCombo,{
						xtype: 'displayfield',
						value: '',
						width: 30
					},{
						xtype: 'displayfield',
						value: '科目级别',
						style: 'padding:0px 5px;'
						//width: 70
					}, subjLevelField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '数量外币科目',
						style: 'padding:0px 5px;'
						//width: 40
					}, subjnumfcCombo, {
						xtype: 'displayfield',
						value: '',
						width: 30
					},findButton
				]
			}, {
				xtype: 'panel',
				layout: 'column',
				columnWidth: 1,
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '导入数据选择',
						style: 'padding:0px 5px;'
						//width: 65
					},
					importField, {
						xtype: 'displayfield',
						value: '',
						width: 20
					},importButton, {
						xtype: 'displayfield',
						value: '',
						width: 20
					},ledgerButton
				]
			}]
	   
   }); 
   
   
   //var tbar1 = new Ext.Toolbar(['导入数据选择:', importField, '-', importButton, '-', ledgerButton]);
var tbar2 = new Ext.Toolbar([saveButton, '-', delButton]);
//tbar: ['科目编码:', subjcodeField, '-', '科目类别:', AcctTypeCombo, '-', '科目级别:', subjLevelField, '-', '数量外币科目:', subjnumfcCombo, '-', findButton],


var itemGrid = new dhc.herp.Grid({
		region: 'center',
		url: "../csp/herp.acct.acctsubjledgerexe.csp",
		atLoad: 'true', // 是否自动刷新
		layout: 'fit',
		viewConfig: {
			forceFit: true, //控制页面全局比例，使页面每列按照对应的比例填充满面板
			//scrollOffset: 20,//表示表格右侧为滚动条预留的宽度
			/*根据条件改变要求行的背景色！
			需要在主页面新建一个css例如：
			<style type="text/css">
			.my_row_style table{ background:Yellow}
			</style>
			然后用下面的方法便可以实现了！
			 */
			getRowClass: function (record, rowIndex, rowParams, store) {
				if (record.data.IsLast == "0") {
					return "my_row_style";
				}

				if (record.data.IsCheck == "1") {
					return "my_row_styleblue";
				}
			}
		},
		
		listeners: {
			'render': function () {
				//tbar1.render(itemGrid.tbar);
				tbar2.render(itemGrid.tbar);
			},

			'cellclick': function (grid, rowIndex, columnIndex, e) {
				var record = grid.getStore().getAt(rowIndex);
				//alert(columnIndex);
				//alert(record.get('IsLast'));
				//alert(InitState);
				if ((InitState == "1") || (record.get('IsLast') == "0") && ((columnIndex == 5) || (columnIndex == 6) || (columnIndex == 7) || (columnIndex == 8) || (columnIndex == 9) || (columnIndex == 10) || (columnIndex == 11) ||
						(columnIndex == 13) || (columnIndex == 14) || (columnIndex == 15) || (columnIndex == 16))) {
					return false;

				} else {
					return true;
				}

			}

		},
		fields: [
			//new Ext.grid.CheckboxSelectionModel({editable:false}),
			{
				id: 'rowid',
				header: '<div style="text-align:center">ID</div>',
				allowBlank: true,
				width: 60,
				editable: false,
				hidden: true,
				dataIndex: 'rowid'
			}, {
				id: 'AcctSubjID',
				header: '<div style="text-align:center">AcctSubjID</div>',
				allowBlank: true,
				width: 100,
				editable: false,
				hidden: true,
				dataIndex: 'AcctSubjID'
			}, {
				id: 'AcctSubjCode',
				header: '<div style="text-align:center">科目编码</div>',
				width: 160,
				editable: false,
				align: 'left',
				dataIndex: 'AcctSubjCode'
			}, {
				id: 'AcctSubjName',
				header: '<div style="text-align:center">科目名称</div>',
				width: 320,
				editable: false,
				align: 'left',
				dataIndex: 'AcctSubjName'
			}, {
				id: 'BeginSum',
				header: '<div style="text-align:center">年初余额</div>',
				width: 180,
				//editable:false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'BeginSum'

			}, {
				id: 'DirectionList',
				header: '<div style="text-align:center">借贷方向</div>',
				width: 80,
				editable: false,
				align: 'center',
				dataIndex: 'DirectionList'
			}, {
				id: 'TotalDebitSum',
				header: '<div style="text-align:center">累计借方金额</div>',
				width: 180,
				//editable:false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'TotalDebitSum'
			}, {
				id: 'TotalCreditSum',
				header: '<div style="text-align:center">累计贷方金额</div>',
				width: 180,
				//editable:false,
				//align: 'right',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'TotalCreditSum'
			}, {
				id: 'EndSum',
				header: '<div style="text-align:center">期初余额</div>',
				width: 180,
				editable:false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'EndSum'

			}, {
				id: 'IsLast',
				header: '<div style="text-align:center">是否末级</div>',
				width: 100,
				hidden: true,
				dataIndex: 'IsLast'
			}, {
				id: 'IsCheck',
				header: '<div style="text-align:center">是否辅助核算</div>',
				width: 100,
				editable: false,
				hidden: true,
				dataIndex: 'IsCheck'
			}
		]

	});

itemGrid.btnAddHide(); //隐藏增加按钮
itemGrid.btnSaveHide(); //隐藏保存按钮
itemGrid.btnDeleteHide(); //隐藏删除按钮
itemGrid.btnResetHide(); //隐藏重置按钮
itemGrid.btnPrintHide(); //隐藏打印按钮

itemGrid.on('rowclick', function () {

	if (InitState == "1") {
		itemGrid.edit = false;
		//delButton.disabled();
	}
});
