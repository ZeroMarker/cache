var userid = session['LOGON.USERID'];
var bookID = IsExistAcctBook();
var projUrl = 'herp.acct.vouchauditsupervisionexe.csp';
var Myvouchno = "";
//起始时间
var StartYMField = new Ext.form.DateField({
		id: 'StartYMField',
		fieldLabel: '起始月份',
		format: 'Y-m',
		width: 100,
		emptyText: '',
		plugins: 'monthPickerPlugin'
	});

//结束时间
var EndYMField = new Ext.form.DateField({
		id: 'EndYMField',
		fieldLabel: '--',
		format: 'Y-m',
		width: 100,
		emptyText: '',
		plugins: 'monthPickerPlugin'
	});

//会计人员
var UserNameDs = new Ext.data.Store({
		autoLoad: true,
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['AcctBookID', 'AcctUserID', 'AcctUserName'])
	});
UserNameDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=getopeatorname&bookID=' + bookID + '&str=' + encodeURIComponent(Ext.getCmp('AcctUser').getRawValue()),
			method: 'POST'
		});
});
var AcctUser = new Ext.form.ComboBox({
		id: 'AcctUser',
		fieldLabel: '会计人员',
		width: 120,
		listWidth: 260,
		allowBlank: true,
		store: UserNameDs,
		valueField: 'AcctUserID',
		displayField: 'AcctUserName',
		triggerAction: 'all',
		name: 'VouchSubj',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

/////////////////////显示方式
var typeStore = new Ext.data.SimpleStore({
		fields: ['rowid', 'method'],
		data: [['1', '作废和不合格凭证记录'], ['2', '凭证号不连续验证']]
	});
var typenameCombo = new Ext.form.ComboBox({
		id: 'typenameCombo',
		fieldLabel: '凭证监管和审计',
		width: 180,
		listWidth: 180,
		selectOnFocus: true,
		allowBlank: true,
		store: typeStore,
		// anchor: '90%',
		value: 1, //默认值
		valueNotFoundText: '',
		displayField: 'method',
		valueField: 'rowid',
		triggerAction: 'all',
		emptyText: '',
		mode: 'local', // 本地模式
		editable: false,
		listeners: {
			'select': function () {
				var tmpDataMapping = [];
				var tmpUrl = "",
				StYM = "",
				EndYM = "";
				var yearmonthS = StartYMField.getValue();
				if (yearmonthS !== "") {
					StYM = yearmonthS.format('Y-m');
				}

				var yearmonthE = EndYMField.getValue();
				if (yearmonthE !== "") {
					EndYM = yearmonthE.format('Y-m');
				}
				var Operator = AcctUser.getValue();
				var OperatorName = AcctUser.getRawValue();
				var data = StYM + "^" + EndYM + "^" + Operator;

				if (typenameCombo.getValue() == 1) {
					itemGrid.setTitle("作废和不合格凭证记录");
					// type = 1;
					SerialButton.setVisible(false); //设置为不可视
					for (var i = 1; i < cmItemsA.length; i++) {
						tmpDataMapping.push(cmItemsA[i].dataIndex);
					}
					tmpUrl = projUrl + '?action=listRec' + '&bookID=' + bookID + '&data=' + data;
					itemGrid.url = tmpUrl;
					tmpColumnModel = new Ext.grid.ColumnModel(cmItemsA);
				}
				if (typenameCombo.getValue() == 2) {
					itemGrid.setTitle("凭证号不连续监测");
					// type = 2;
					SerialButton.setVisible(true); //设置为可视
					// StartYMField.hide(true);
					for (var i = 1; i < cmItemsB.length; i++) {
						tmpDataMapping.push(cmItemsB[i].dataIndex);
					}
					tmpUrl = projUrl + '?action=listserial' + '&bookID=' + bookID + '&data=' + data;
					itemGrid.url = tmpUrl;
					tmpColumnModel = new Ext.grid.ColumnModel(cmItemsB);
				}

				VouchASDs.proxy = new Ext.data.HttpProxy({
						url: tmpUrl,
						method: 'POST'
					})
					VouchASDs.reader = new Ext.data.JsonReader({
						totalProperty: "results",
						root: 'rows'
					}, tmpDataMapping);

				itemGrid.store.removeAll();
				itemGrid.reconfigure(VouchASDs, tmpColumnModel);
				itemGrid.store.load({
					params: {
						start: 0,
						limit: 25,
						data: data,
						bookID: bookID,
						userid: userid
					}
				});

			}

		}
	});

//查询按钮
var findButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'find',
		width: 55,
		handler: function () {
			var tmpDataMapping = [];
			var tmpUrl = "",
			StYM = "",
			EndYM = "";
			var yearmonthS = StartYMField.getValue();
			if (yearmonthS !== "") {
				StYM = yearmonthS.format('Y-m');
			}

			var yearmonthE = EndYMField.getValue();
			if (yearmonthE !== "") {
				EndYM = yearmonthE.format('Y-m');
			}
			var Operator = AcctUser.getValue();
			var OperatorName = AcctUser.getRawValue();
			var data = StYM + "^" + EndYM + "^" + Operator;
			if (typenameCombo.getValue() == 1) {
				itemGrid.setTitle("作废和不合格凭证记录");
				// type = 1;
				for (var i = 1; i < cmItemsA.length; i++) {
					//alert(cmItems[i].dataIndex);
					tmpDataMapping.push(cmItemsA[i].dataIndex);
				}
				tmpUrl = projUrl + '?action=listRec' + '&data=' + data + '&bookID=' + bookID;
				itemGrid.url = tmpUrl;
				var tmpColumnModel = new Ext.grid.ColumnModel(cmItemsA);
			} else {
				itemGrid.setTitle("凭证号不连续监测");
				// type = 2;
				for (var i = 1; i < cmItemsB.length; i++) {
					tmpDataMapping.push(cmItemsB[i].dataIndex);
				}
				tmpUrl = projUrl + '?action=listserial' + '&data=' + data + '&bookID=' + bookID;
				itemGrid.url = tmpUrl;
				var tmpColumnModel = new Ext.grid.ColumnModel(cmItemsB);
			}

			VouchASDs.proxy = new Ext.data.HttpProxy({
					url: tmpUrl,
					method: 'POST'
				})
				VouchASDs.reader = new Ext.data.JsonReader({
					totalProperty: "results",
					root: 'rows'
				}, tmpDataMapping);

			itemGrid.reconfigure(VouchASDs, tmpColumnModel);
			itemGrid.store.load({
				params: {
					start: 0,
					limit: 25,
					data: data,
					bookID: bookID,
					userid: userid
				}
			});
		}
	});

//凭证号不连续检查 按钮
var SerialButton = new Ext.Toolbar.Button({
		hidden: true,
		text: '凭证号不连续检查',
		tooltip: '凭证号不连续检查', //悬停提示
		iconCls: 'add',
		handler: function () {
			var tmpUrl = "",
			StYM = "",
			EndYM = "";
			var yearmonthS = StartYMField.getValue();
			if (yearmonthS !== "") {
				StYM = yearmonthS.format('Y-m');
			}

			var yearmonthE = EndYMField.getValue();
			if (yearmonthE !== "") {
				EndYM = yearmonthE.format('Y-m');
			}
			var Operator = AcctUser.getValue();
			var OperatorName = AcctUser.getRawValue();
			var data = StYM + "^" + EndYM + "^" + Operator;
			Ext.Ajax.request({
				async: false,
				url: projUrl + '?action=checknoserial&bookID=' + bookID + '&data=' + data,
				waitMsg: '保存中...',
				success: function (result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Mymessage = jsonData.info;
						Myvouchno = Mymessage.split(" ")[1];
						Ext.Msg.show({
							title: '错误',
							msg: '注意: ' + '<span style="color:red;">' + Mymessage + '</span>   ',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.ERROR
						});

						itemGrid.store.load({
							params: {
								start: 0,
								limit: 25
							}
						});
						return;
					}
				}
			});

		}
	});

//显示表格
var VouchASProxy = new Ext.data.HttpProxy({
		url: projUrl + '?action=listRec&bookID=' + bookID,
		method: 'POST'
	});
var VouchASDs = new Ext.data.Store({
		proxy: VouchASProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, ['AcctYear', 'AcctMonth', 'AcctBookID', 'NumIsCancel', 'NumVouchState', 'OperatorID', 'OperatorName']),
		remoteSort: true
	});

var VouchASCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				id: 'AcctYear',
				header: '年',
				align: 'center',
				width: 100,
				editable: false,
				dataIndex: 'AcctYear'

			}, {
				id: 'AcctMonth',
				header: '月',
				align: 'center',
				width: 100,
				editable: false,
				dataIndex: 'AcctMonth'
			}, {
				id: 'AcctBookID',
				header: '账套',
				align: 'center',
				width: 150,
				hidden: true,
				editable: false,
				dataIndex: 'AcctBookID'
			}, {
				id: 'OperatorID',
				header: '操作人',
				align: 'center',
				width: 100,
				hidden: true,
				editable: false,
				dataIndex: 'OperatorID'
			}, {
				id: 'OperatorName',
				header: '操作人员',
				align: 'center',
				width: 150,
				editable: false,
				dataIndex: 'OperatorName'
			}, {
				id: 'NumIsCancel',
				header: '作废凭证数量',
				align: 'center',
				width: 120,
				editable: false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					// alert(value)
					if (value != 0)
						return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
					return value;
				},
				dataIndex: 'NumIsCancel'
			}, {
				id: 'NumVouchState',
				header: '审核不通过数量',
				align: 'center',
				width: 120,
				editable: false,
				dataIndex: 'NumVouchState',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					// alert(value)
					if (value != 0)
						return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
					return value;
				}
			}
		]);

//分页工具
var VouchASPagTba = new Ext.PagingToolbar({
		store: VouchASDs,
		pageSize: 25,
		displayInfo: true,
		// plugins : new dhc.herp.PageSizePlugin(),
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有记录"
	});

var queryPanel = new Ext.FormPanel({
		region: 'north',
		height: 45,
		frame: true,
		defaults: {
			labelAlign: 'right', //标签对齐方式
			labelSeparator: ' ', //分隔符
			border: false,
			bodyStyle: 'padding:5px;'
		},
		width: 1200,
		layout: 'column',
		items: [{
				labelWidth: 110,
				// labelAlign: 'left',
				xtype: 'fieldset',
				width: 330,
				items: typenameCombo
			}, {
				xtype: 'fieldset',
				labelWidth: 60,
				width: 200,
				items: StartYMField
			},{
				xtype: 'fieldset',
				labelWidth: 25,
				style:'margin-left:-25px;',
				width: 170,
				items: EndYMField
			}, {
				xtype: 'fieldset',
				labelWidth: 60,
				width: 220,
				items: AcctUser
			}, {
				xtype: 'fieldset',
			    labelWidth: 10,
				width: 80,
				items: findButton
			}, {
				xtype: 'fieldset',
				labelWidth: 20,
				width: 165,
				items: SerialButton
			}
		]
	});

//
var itemGrid = new Ext.grid.EditorGridPanel({
		title:'凭证监管和审计列表',
		iconCls:'list',
		region: 'center',
		pageSize: 25,
		atLoad: true,
		store: VouchASDs,
		cm: VouchASCm,
		clicksToEdit: 1,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.CheckboxSelectionModel({
			singleSelect: false
		}),
		bbar: VouchASPagTba,
		// tbar: ['功能选项:', typenameCombo, '起始年月:', StartYMField, '结束年月:', EndYMField, '操作人:', AcctUser, '-', findButton, '-', SerialButton],
		viewConfig: { //forceFit : true,   //控制页面全局比例，使页面每列按照对应的比例填充满面板
			//scrollOffset: 20,//表示表格右侧为滚动条预留的宽度
			/*根据条件改变要求行的背景色！
			需要在主页面新建一个css例如：
			<style type="text/css">
			.my_row_style table{ background:Yellow}
			</style>
			然后用下面的方法便可以实现了！
			 */
			getRowClass: function (record, rowIndex, rowParams, store) {
				if (record.data.VouchNo == Myvouchno) {
					return "my_row_style";
				}
				/*
				if (record.data.VouchNo == "1") {
				return "my_row_styleblue";
				}
				 */
			}
		},
		loadMask: true
	});
itemGrid.store.load({
	params: {
		start: 0,
		limit: 25
	}
});

//凭证监管和审计
var cmItemsA = [
	new Ext.grid.RowNumberer(), {
		id: 'AcctYear',
		header: '年',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'AcctYear'

	}, {
		id: 'AcctMonth',
		header: '月',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'AcctMonth'

	}, {
		id: 'AcctBookID',
		header: '账套',
		align: 'center',
		width: 150,
		hidden: true,
		editable: false,
		dataIndex: 'AcctBookID'

	}, {
		id: 'OperatorID',
		header: '操作人ID',
		align: 'center',
		width: 100,
		hidden: true,
		editable: false,
		dataIndex: 'OperatorID'

	}, {
		id: 'OperatorName',
		header: '操作人员',
		align: 'center',
		width: 150,
		editable: false,
		dataIndex: 'OperatorName'

	}, {
		id: 'NumIsCancel',
		header: '作废凭证数量',
		align: 'center',
		width: 120,
		editable: false,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			if (value != 0)
				return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
			return value;
		},
		dataIndex: 'NumIsCancel'

	}, {
		id: 'NumVouchState',
		header: '审核不通过数量',
		align: 'center',
		width: 120,
		editable: false,
		dataIndex: 'NumVouchState',
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			// alert(value)
			if (value != 0)
				return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
			return value;
		}
	}
];

//凭证号不连续检查
//AcctVouchID^VouchNo^AcctYear^AcctMonth^AcctBookID^IsCancel^CancelDate^VouchState^OperatorID^OperatorName^MakeBillDate
var cmItemsB = [
	new Ext.grid.RowNumberer(), {
		id: 'AcctVouchID',
		header: '凭证ID',
		align: 'center',
		width: 100,
		hidden: true,
		editable: false,
		dataIndex: 'AcctVouchID'
	}, {
		id: 'VouchNo',
		header: '凭证号',
		align: 'center',
		width: 120,
		editable: false,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			if (value)
				return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
		},
		dataIndex: 'VouchNo'
	}, {
		id: 'AcctYear',
		header: '年',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'AcctYear'
	}, {
		id: 'AcctMonth',
		header: '月',
		align: 'center',
		width: 80,
		editable: false,
		dataIndex: 'AcctMonth'
	}, {
		id: 'MakeBillDate',
		header: '制单日期',
		align: 'center',
		width: 110,
		editable: false,
		dataIndex: 'MakeBillDate'
	}, {
		id: 'IsCancel',
		header: '凭证作废',
		align: 'center',
		width: 100,
		hidden: true,
		editable: false,
		dataIndex: 'IsCancel'
	}, {
		id: 'IsCancelWord',
		header: '凭证作废',
		align: 'center',
		width: 100,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			if (value)
				return '<span style="color:red;">' + value + '</span>';
		},
		editable: false,
		dataIndex: 'IsCancelWord'
	}, {
		id: 'CancelDate',
		header: '作废日期',
		align: 'center',
		width: 100,
		hidden: true,
		editable: false,
		dataIndex: 'CancelDate'
	}, {
		id: 'VouchState',
		header: '凭证状态',
		align: 'center',
		width: 100,
		hidden: true,
		editable: false,
		dataIndex: 'VouchState'
	}, {
		id: 'VouchStateWord',
		header: '凭证状态',
		align: 'center',
		width: 100,
		// hidden:true,
		editable: false,
		dataIndex: 'VouchStateWord'
	}, {
		id: 'OperatorID',
		header: '操作人ID',
		align: 'center',
		width: 100,
		hidden: true,
		editable: false,
		dataIndex: 'OperatorID'
	}, {
		id: 'OperatorName',
		header: '操作人(制单人)',
		align: 'center',
		width: 180,
		editable: false,
		dataIndex: 'OperatorName'
	}
];
//凭证链接
itemGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {

	var linknum = typenameCombo.getValue();
	var records = itemGrid.getSelectionModel().getSelections();
	if (linknum == 2) {
		//凭证号的链接
		if (columnIndex == '2') {
			//p_URL = 'acct.html?acctno=2';
			//document.getElementById("frameReport").src='acct.html';
			var VouchNo = records[0].get("VouchNo");
			var VouchState = records[0].get("VouchState");
			var myPanel = new Ext.Panel({
					layout: 'fit',
					//scrolling="auto",
					html: '<iframe id="frameReport" style="margin-top:-3px" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + userid + '&acctstate=' + '11' + '&bookID=' + bookID + '&searchFlag=' + 1 + '" /></iframe>'
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
	} else if (linknum == 1) {

		//作废凭证数量的链接
		if (columnIndex == 6) {
			if (records[0].get("NumIsCancel") != 0) {
				var AcctYear = records[0].get("AcctYear");
				var AcctMonth = records[0].get("AcctMonth");
				var OperatorID = records[0].get("OperatorID");
				var data = AcctYear + "^" + AcctMonth + "^" + OperatorID;
				LinkCancelVouch(data);

			}
		}

		//审核不通过数量链接
		if (columnIndex == 7) {
			if (records[0].get("NumVouchState") != 0) {
				var AcctYear = records[0].get("AcctYear");
				var AcctMonth = records[0].get("AcctMonth");
				var OperatorID = records[0].get("OperatorID");
				var data = AcctYear + "^" + AcctMonth + "^" + OperatorID;

				LinkNotPassVouch(data);

			}
		}
	}

});
