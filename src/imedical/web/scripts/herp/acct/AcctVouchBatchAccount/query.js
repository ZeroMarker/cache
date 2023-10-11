var projUrl = "../csp/herp.acct.acctbatchauditexe.csp"

	// 定义会计期间时间控件
	var AcctYearMonthField = new Ext.form.DateField({
		id: 'AcctYearMonthField',
		name: 'AcctYearMonthField',
		fieldLabel: '会计期间',
		emptyMsg: "",
		format: 'Y-m',
		width: 150,
		triggerAction: 'all',
		allowBlank: true,
		plugins: 'monthPickerPlugin'

	});

/////////////////////凭证类别

var VouchTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['rowid', 'code', 'name'])
	});
VouchTypeDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=GetVouchType',
			method: 'POST'
		});
});
var VouchTypeCombo = new Ext.form.ComboBox({
		fieldLabel: '凭证类别',
		store: VouchTypeDs,
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		//forceSelection : true,
		triggerAction: 'all',
		emptyText: '请选择凭证类别',
		width: 192,
		listWidth: 220,
		pageSize: 10,
		minChars: 1,
		allowBlank: true
		//selectOnFocus : true
	});

//-------凭证来源
var VouchSourceDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['rowid', 'name'])
	});
VouchSourceDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=GetVouchSource',
			method: 'POST'
		});
});
var VouchSourceCombo = new Ext.form.ComboBox({
		fieldLabel: '凭证来源',
		store: VouchSourceDs,
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		//forceSelection : true,
		triggerAction: 'all',
		emptyText: '请选择凭证来源',
		width: 190,
		listWidth: 220,
		pageSize: 10,
		minChars: 1,
		allowBlank: true
		//selectOnFocus : true
	});

///////////////制单人
var OperatorDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['rowid', 'name'])
	});

OperatorDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=CalUsername&userdr=' + userdr,
			method: 'POST'
		});
});
var OperatorCombo = new Ext.form.ComboBox({
		fieldLabel: '制单人',
		store: OperatorDs,
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		//forceSelection : true,
		triggerAction: 'all',
		emptyText: '请选择制单人',
		width: 150,
		listWidth: 220,
		pageSize: 10,
		minChars: 1,
		allowBlank: true
		//selectOnFocus : true
	});

///////////////凭证号
var miniVouchNoField = new Ext.form.TextField({
		id: 'miniVouchNo',
		fieldLabel: '最小凭证号',
		width: 90,
		allowBlank: true,
		selectOnFocus: 'true'
	});

var maxVouchNoField = new Ext.form.TextField({
		id: 'maxVouchNo',
		fieldLabel: '最大凭证号',
		width: 90,
		allowBlank: true,
		selectOnFocus: 'true'
	});

/////////////////////审核状态
var VouchStateGroup = new Ext.form.RadioGroup({
		//fieldLabel:'状态',
		xtype: 'radiogroup',
		width: 190,
		defaults: {
			style: "margin:0;padding:0 0.25em;width:auto;overflow:visible;border:0;background:none;"
		},
		items: [{
				id: 'all',
				boxLabel: '全部',
				inputValue: '',
				name: 'sevType'
			}, {
				id: 'checked',
				boxLabel: '已审核',
				inputValue: '21',
				name: 'sevType'
			}, {
				id: 'unchecked',
				boxLabel: '未审核',
				inputValue: '11', //未审核为什么是11？？？
				name: 'sevType',
				checked: true
			}
		]

	});
/*
var checkstate=Ext.form.RadioGroup({


fieldLabel: 'Auto Layout',
items: [{boxLabel: 'Item 1', name: 'rb-auto', inputValue: 1,checked: true},{boxLabel: 'Item 2', name: 'rb-auto', inputValue: 2},{boxLabel: 'Item 3', name: 'rb-auto', inputValue: 3}
]

});
 */

//////////////////////制单日期
var startDateField = new Ext.form.DateField({
		id: 'startDateField',
		// fieldLabel: '起始日期',
		fieldLabel: '制单日期',
		width: 90,
		allowBlank: true,
		emptyText: '起始日期',
		//format:'Y-m-d',
		selectOnFocus: 'true'
	});

var endDateField = new Ext.form.DateField({
		id: 'endDateField',
		// fieldLabel: '终止日期',
		width: 90,
		allowBlank: true,
		emptyText: '终止日期',
		//format:'Y-m-d',
		selectOnFocus: 'true'
	});

//////////////////////其他状态
var IsDes = new Ext.form.Checkbox({
		id: 'IsDestroy',
		fieldLabel: '冲销凭证',
		style: 'border:0;background:none;margin-top:2px;'
		/* ,
		inputValue : 1,
		listeners: {
			specialKey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					applyNofield.focus();
				}
			}
		} */

	});

var IsCanc = new Ext.form.Checkbox({
		id: 'IsCancel',
		fieldLabel: '作废凭证',
		style: 'border:0;background:none;margin-top:2px;'
		/* ,
		inputValue : 1,
		listeners: {
			specialKey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					applyNofield.focus();
				}
			}
		} */

	});

/* IsCanc.on('check', function( c , checked ){
if(checked){
alert(IsCanc.getValue());
}else{
}
}); */

/////////////////////显示方式
var typeStore = new Ext.data.SimpleStore({
		fields: ['rowid', 'method'],
		data: [['1', '凭证显示'], ['2', '凭证分录显示']]
	});
var typenameCombo = new Ext.form.ComboBox({
		id: 'typenameCombo',
		fieldLabel: '显示方式',
		width: 150,
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
		editable: false
	});

var findButton = new Ext.Button({
		text: '查询',
		tooltip: '查询',
		width: 80,
		iconCls: 'find',
		handler: function () {
			//var AcctYearMonth = AcctYearMonthField.getValue()
			var AcctYearMonth = AcctYearMonthField.getRawValue();
			if (AcctYearMonth != "") {
				AcctYear = AcctYearMonth.split("-")[0];
				AcctMonth = AcctYearMonth.split("-")[1];
				//AcctYear = AcctYearMonth.format('Y');
				//AcctMonth =AcctYearMonth.format('M');
			} else {
				var AcctYear = "";
				var AcctMonth = "";
			}
			var VouchType = VouchTypeCombo.getValue();
			var VouchSource = VouchSourceCombo.getValue();
			var Operator = OperatorCombo.getValue();
			var miniVouchNo = miniVouchNoField.getValue();
			var maxVouchNo = maxVouchNoField.getValue();
			//var typename = typenameCombo.getValue();
			var VouchState = VouchStateGroup.getValue().inputValue;
			// alert(VouchState)
			var startDate = startDateField.getValue();
			if (startDate !== "") {
				startDate = startDate.format('Y-m-d');
			}
			var endDate = endDateField.getValue();
			if (endDate !== "") {
				endDate = endDate.format('Y-m-d');
			}
			var IsDestroy = IsDes.getValue();
			var IsCancel = IsCanc.getValue();
			// alert(IsDestroy+"^"+IsCancel)
			var typename = typenameCombo.getValue();

			var tmpDataMapping = [];
			var tmpUrl = ""
				if (typenameCombo.getValue() == 1) {
					itemGrid.setTitle("凭证显示");
					type = 1;
					for (var i = 1; i < cmItems.length; i++) {
						tmpDataMapping.push(cmItems[i].dataIndex);
					}
					tmpUrl = projUrl + '?action=Vouchlist' + '&AcctYear=' + AcctYear + '&AcctMonth=' + AcctMonth + '&VouchType=' + VouchType + '&VouchSource=' + VouchSource
						 + '&Operator=' + Operator + '&miniVouchNo=' + miniVouchNo + '&maxVouchNo=' + maxVouchNo + '&VouchState=' + VouchState
						 + '&startDate=' + startDate + '&endDate=' + endDate + '&IsDestroy=' + IsDestroy + '&IsCancel=' + IsCancel + '&bookID=' + bookID + '&userdr=' + userdr;
					itemGrid.url = tmpUrl;
					var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
				} else {
					itemGrid.setTitle("凭证分录显示");
					type = 2;
					for (var i = 1; i < cmItems2.length; i++) {
						tmpDataMapping.push(cmItems2[i].dataIndex);
					}
					tmpUrl = projUrl + '?action=list' + '&AcctYear=' + AcctYear + '&AcctMonth=' + AcctMonth + '&VouchType=' + VouchType + '&VouchSource=' + VouchSource
						 + '&Operator=' + Operator + '&miniVouchNo=' + miniVouchNo + '&maxVouchNo=' + maxVouchNo + '&VouchState=' + VouchState
						 + '&startDate=' + startDate + '&endDate=' + endDate + '&IsDestroy=' + IsDestroy + '&IsCancel=' + IsCancel + '&bookID=' + bookID + '&userdr=' + userdr;
					itemGrid.url = tmpUrl;
					var tmpColumnModel = new Ext.grid.ColumnModel(cmItems2);
				}
				/*
				var tmpStore = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
				url : ''
				}),
				reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
				}),
				remoteSort : true
				});*/
				MoidLogDs.proxy = new Ext.data.HttpProxy({
					url: tmpUrl,
					method: 'POST'
				})
				MoidLogDs.reader = new Ext.data.JsonReader({
					totalProperty: "results",
					root: 'rows'
				}, tmpDataMapping);
			itemGrid.reconfigure(MoidLogDs, tmpColumnModel);
			//itemGrid.bbar.bind(tmpStore);
			//itemGrid.bbar.bindStore(tmpStore);itemGrid.bbar.destroy();
			//for(var x in itemGrid.bbar.store){alert(x);};
			//alert(itemGrid.bbar.pageSize);

			itemGrid.store.load({
				params: {
					start: 0,
					limit: 25
				}
			});
		}
	});

var queryPanel = new Ext.FormPanel({
		height: 105,
		region: 'north',
		frame: true,
		items: [{
				defaults: {
					labelAlign: 'right', //标签对齐方式
					labelSeparator: ':', //分隔符
					labelWidth: 80,
					border: false,
					bodyStyle: 'padding:5 0 0 0 ;'
				},
				width: 1200,
				layout: 'column',
				items: [{
						xtype: 'fieldset',
						// columnWidth:.2,
						width: 280,
						items: [AcctYearMonthField, typenameCombo, OperatorCombo]
					}, {
						xtype: 'fieldset',
						// columnWidth:.2,
						width: 320,
						items: [
							VouchTypeCombo, {
								layout: 'column',
								bodyStyle: 'padding:2 0 2 0 ;',
								items: [{
										xtype: 'displayfield',
										width: 35
									}, {
										xtype: 'tbtext',
										width: 50,
										text: '凭证号:'
									}, miniVouchNoField, {
										xtype: 'tbtext',
										text: "--"
									}, maxVouchNoField
								]
							}, {
								layout: 'column',
								bodyStyle: 'padding:3 0 3 0 ;',
								items: [{
										xtype: 'displayfield',
										width: 20
									}, {
										xtype: 'tbtext',
										width: 65,
										text: '制单日期:'
									}, startDateField, {
										xtype: 'tbtext',
										text: "--"
									}, endDateField
								]
							}

						]

					}, {
						xtype: 'fieldset',
						// columnWidth:.25,
						width: 320,
						items: [
							VouchSourceCombo, {
								layout: 'column',
								bodyStyle: 'padding:2 0 2 0 ;',
								items: [{
										xtype: 'displayfield',
										width: 20
									}, {
										xtype: 'tbtext',
										width: 65,
										text: '审核状态:'
									}, VouchStateGroup]
							}, {
								layout: 'column',
								bodyStyle: 'padding:3 0 3 0 ;',
								items: [{
										xtype: 'displayfield',
										width: 20
									}, {
										xtype: 'tbtext',
										width: 65,
										text: '其他状态:'
									}, IsDes, {
										xtype: 'tbtext',
										text: "冲销凭证"
									}, {
										xtype: 'displayfield',
										width: 20
									}, IsCanc, {
										xtype: 'tbtext',
										text: "作废凭证"
									}
								]
							}
						]
					}, {
						xtype: 'fieldset',
						items: [/* {
							xtype: 'displayfield',
							width: 20
							},  */
							findButton]
					}

				]
			}
		]

	});

//凭证显示
var cmItems = [new Ext.grid.RowNumberer(),
	new Ext.grid.CheckboxSelectionModel({
		editable: false
	}), {
		id: 'AcctVouchID',
		header: '<div style="text-align:center">ID</div>',
		allowBlank: false,
		width: 100,
		editable: false,
		hidden: true,
		dataIndex: 'AcctVouchID'
	}, {
		id: 'AcctYear',
		header: '<div style="text-align:center">年</div>',
		width: 50,
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
		width: 90,
		editable: false,
		align: 'center',
		dataIndex: 'VouchDate'

	}, {
		id: 'VouchNo',
		header: '<div style="text-align:center">凭证号</div>',
		width: 110,
		editable: false,
		align: 'center',
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>'
		},
		dataIndex: 'VouchNo'
	}, {
		id: 'VouchBillNum',
		header: '<div style="text-align:center">附件数</div>',
		width: 60,
		editable: false,
		align: 'center',
		dataIndex: 'VouchBillNum'
	}, {
		id: 'TotalAmtDebit',
		header: '<div style="text-align:center">总金额</div>',
		width: 130,
		editable: false,
		align: 'right',
		dataIndex: 'TotalAmtDebit'
	}, {
		id: 'Operator',
		header: '<div style="text-align:center">制单人</div>',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'Operator'
	}, {
		id: 'Auditor',
		header: '<div style="text-align:center">审核人</div>',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'Auditor'
	}, {
		id: 'Poster',
		header: '<div style="text-align:center">记账人</div>',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'Poster'
	}, {
		id: 'VouchState',
		header: '<div style="text-align:center">凭证状态</div>',
		align: 'center',
		width: 80,
		editable: false,
		dataIndex: 'VouchState'
	}, {
		id: 'VouchProgress',
		header: '<div style="text-align:center">凭证处理过程</div>',
		align: 'center',
		width: 100,
		editable: false,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>'
		},
		dataIndex: 'VouchProgress'

	}, {
		id: 'IsDestroy',
		header: '<div style="text-align:center">冲销凭证</div>',
		align: 'center',
		width: 80,
		editable: false,
		dataIndex: 'IsDestroy'
	}, {
		id: 'IsCancel',
		header: '<div style="text-align:center">作废凭证</div>',
		align: 'center',
		width: 80,
		editable: false,
		dataIndex: 'IsCancel'
	}, {
		id: 'VouchState1',
		header: '<div style="text-align:center">凭证状态</div>',
		align: 'center',
		width: 80,
		editable: false,
		hidden: true,
		dataIndex: 'VouchState1'
	}, {
		id: 'Operator1',
		header: '<div style="text-align:center">编制人</div>',
		align: 'center',
		width: 100,
		editable: false,
		hidden: true,
		dataIndex: 'Operator1'
	}, {
		id: 'Auditor1',
		header: '<div style="text-align:center">审核人</div>',
		align: 'center',
		width: 100,
		editable: false,
		hidden: true,
		dataIndex: 'Auditor1'
	}
];

/////凭证分录显示
var cmItems2 = [new Ext.grid.RowNumberer(),
	new Ext.grid.CheckboxSelectionModel({
		editable: false
	}), {
		id: 'rowid',
		header: '<div style="text-align:center">id</div>',
		width: 100,
		editable: false,
		hidden: true,
		dataIndex: 'AcctVouchID'
	}, {
		id: 'AcctYear',
		header: '<div style="text-align:center">年</div>',
		width: 50,
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
		width: 110,
		editable: false,
		align: 'center',
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>'
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
		width: 150,
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
		width: 80,
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
		dataIndex: 'IsDestroy'
	}, {
		id: 'IsCancel',
		header: '<div style="text-align:center">作废凭证</div>',
		width: 80,
		editable: false,
		align: 'center',
		dataIndex: 'IsCancel'
	}, {
		id: 'VouchState1',
		header: '<div style="text-align:center">凭证状态</div>',
		width: 80,
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

function GetYearMonth() {
	Ext.Ajax.request({
		url: projUrl + '?action=GetYearMonth' + '&bookID=' + bookID,
		failure: function (result, request) {
			Ext.Msg.show({
				title: '错误',
				msg: '请检查网络连接!',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			//alert(jsonData.success );
			if (jsonData.success == 'false') {
				// alert(jsonData.info);
				var date = jsonData.info + "-01"
					AcctYearMonthField.setValue(date);
			}
		},
		scope: this
	});
}
GetYearMonth();
