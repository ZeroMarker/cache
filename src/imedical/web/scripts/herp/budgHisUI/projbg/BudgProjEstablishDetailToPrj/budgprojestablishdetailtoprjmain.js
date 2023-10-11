
var userid = session['LOGON.USERID'];
var uname = session['LOGON.USERNAME'];
var hospid = session['LOGON.HOSPID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var mainUrl = 'herp.budg.budgprojestablishdetailtoprjexe.csp';

//年度
var yearCmb = new Ext.form.ComboBox({
		fieldLabel: '年度',
		width: 150,
		listWidth: 285,
		store: new Ext.data.JsonStore({
			url: commonboxUrl + '?action=year',
			root: 'rows',
			totalProperty: "results",
			fields: ['year', 'year']
		}),
		valueField: 'year',
		displayField: 'year',
		selectOnFocus: true,
		forceSelection: true,
		emptyText: '请选择...',
		pageSize: 10,
		minChars: 1,
		triggerAction: 'all',
		listeners: {
			select: function (combo, record, index) {
				itemCmb.getStore().removeAll();
				itemCmb.setValue('');
				projCmb.getStore().removeAll();
				projCmb.setValue('');
			}
		}
	});

yearCmb.on('select', function (combo, record, index) {
	year = combo.getValue();
	Ext.Ajax.request({
		url: mainUrl + '?action=gettime&year=' + year + '&userid=' + userid,
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				var data = jsonData.info;
				var arr = data.split("^");
				var startdate = arr[0];
				var enddate = arr[1];
				var isaudit = arr[2];
				var today = new Date().format('Y-m-d');
				//alert("startdate:"+startdate+",enddate:"+enddate+",today:"+today+",isaudit:"+isaudit)
				if (((today > enddate) || (today < startdate)) && (isaudit !== "1")) {
					//alert("sss");
					addBtn.disable();
					deleteBtn.disable();
					editButton.disable();
					submitBtn.disable();
					sumBtn.disable();
				}
			}
		},
		scope: this
	});
});

//预算科目
var itemCmb = new Ext.form.ComboBox({
		fieldLabel: '预算科目',
		width: 150,
		listWidth: 285,
		store: new Ext.data.JsonStore({
			proxy: new Ext.data.HttpProxy({
				url: mainUrl + '?action=getitemname',
				listeners: {
					'beforeload': function (proxy, params) {
						if (!yearCmb.getValue()) {
							Ext.Msg.show({
								title: '注意',
								width: 200,
								msg: '请先选择年度！',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.WARNING
							});
							return false;
						}
						params.year = yearCmb.getValue();
						params.deptdr = deptCmb.getValue();
					}
				}
			}),
			root: 'rows',
			totalProperty: 'results',
			fields: ['rowid', 'name']
		}),
		valueField: 'rowid',
		displayField: 'name',
		selectOnFocus: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '请选择...',
		pageSize: 10,
		minChars: 1,
		listeners: {
			'beforequery': function (qe) {
				delete qe.combo.lastQuery;
			}
		}
	});

//项目名称
var projCmb = new Ext.form.ComboBox({
		fieldLabel: '项目名称',
		width: 150,
		listWidth: 285,
		store: new Ext.data.JsonStore({
			proxy: new Ext.data.HttpProxy({
				url: mainUrl + '?action=projList',
				listeners: {
					'beforeload': function (proxy, params) {
						if (!yearCmb.getValue()) {
							Ext.Msg.show({
								title: '注意',
								width: 200,
								msg: '请先选择年度！',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.WARNING
							});
							return false;
						}
						params.year = yearCmb.getValue();
					}
				}
			}),
			root: 'rows',
			totalProperty: 'results',
			fields: ['rowid', 'name']
		}),
		valueField: 'rowid',
		displayField: 'name',
		selectOnFocus: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '请选择...',
		pageSize: 10,
		minChars: 1,
		listeners: {
			'beforequery': function (qe) {
				delete qe.combo.lastQuery;
			}
		}
	});

//资金类型
var fundTyCmb = new Ext.form.ComboBox({
		fieldLabel: '资金类型',
		width: 150,
		listWidth: 285,
		store: new Ext.data.JsonStore({
			url: mainUrl + '?action=fundtype',
			root: 'rows',
			totalProperty: "results",
			fields: ['rowid', 'name']
		}),
		valueField: 'rowid',
		displayField: 'name',
		selectOnFocus: true,
		forceSelection: true,
		emptyText: '请选择...',
		pageSize: 10,
		minChars: 1,
		triggerAction: 'all'
	});

//责任科室
var deptCmb = new Ext.form.ComboBox({
		fieldLabel: '责任科室',
		width: 150,
		listWidth: 285,
		store: new Ext.data.JsonStore({
			url: 'herp.budg.budgprojectdictexe.csp' + '?action=calItemdept',
			root: 'rows',
			totalProperty: "results",
			fields: ['rowid', 'name']
		}),
		valueField: 'rowid',
		displayField: 'name',
		selectOnFocus: true,
		forceSelection: true,
		emptyText: '请选择...',
		pageSize: 10,
		minChars: 1,
		triggerAction: 'all'
	});

//预算科室
var bgDeptCmb = new Ext.form.ComboBox({
		fieldLabel: '预算科室',
		width: 150,
		listWidth: 285,
		store: new Ext.data.JsonStore({
			proxy: new Ext.data.HttpProxy({
				url: commonboxUrl + '?action=dept',
				listeners: {
					'beforeload': function (proxy, params) {
						params.flag = 1;
					}
				}
			}),
			root: 'rows',
			totalProperty: 'results',
			fields: ['rowid', 'name']
		}),
		valueField: 'rowid',
		displayField: 'name',
		selectOnFocus: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText: '请选择...',
		pageSize: 10,
		minChars: 1,
		listeners: {
			'beforequery': function (qe) {
				delete qe.combo.lastQuery;
			}
		}
	});

//表格嵌套
//总预算占比
var budgproField = new Ext.form.TextField({
		id: 'NameField',
		fieldLabel: '总预算占比',
		allowBlank: false,
		blankText: '输入整数即可',
		xtype: "numberfield",
		regex: /^([1-9]\d?(\.\d{1,2})?|0\.\d{1,2}|0|100|100.00)$/,
		regexText: '百分数格式不正确',
		width: 200
	});

//查询面板
var headpanel = new Ext.FormPanel({
		height: 125,
		region: 'north',
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px'
		},
		items: [{
				xtype: 'panel',
				layout: "column",
				items: [{
						xtype: 'displayfield',
						value: '<center><p style="font-weight:bold;font-size:150%">项目明细管理</p></center>',
						columnWidth: 1,
						height: '35'
					}
				]
			}, {
				columnWidth: 1,
				xtype: 'panel',
				layout: "column",
				items: [{
						xtype: 'displayfield',
						value: '年度:',
						columnWidth: .08
					}, {
						columnWidth: .15,
						items: yearCmb
					}, {
						xtype: 'displayfield',
						value: '',
						columnWidth: .02
					}, {
						xtype: 'displayfield',
						value: '预算科目:',
						columnWidth: .08
					}, {
						columnWidth: .15,
						items: itemCmb
					}, {
						xtype: 'displayfield',
						value: '',
						columnWidth: .02
					}, {
						xtype: 'displayfield',
						value: '项目名称:',
						columnWidth: .08
					}, {
						columnWidth: .15,
						items: projCmb
					}

				]
			}, {
				columnWidth: 1,
				xtype: 'panel',
				layout: "column",
				items: [{
						xtype: 'displayfield',
						value: '资金类别:',
						columnWidth: .08
					}, {
						columnWidth: .15,
						items: fundTyCmb
					}, {
						xtype: 'displayfield',
						value: '',
						columnWidth: .02
					}, {
						xtype: 'displayfield',
						value: '责任科室:',
						columnWidth: .08
					}, {
						columnWidth: .15,
						items: deptCmb
					}, {
						xtype: 'displayfield',
						value: '',
						columnWidth: .02
					}, {
						xtype: 'displayfield',
						value: '预算科室:',
						columnWidth: .08
					}, {
						columnWidth: .15,
						items: bgDeptCmb
					}, {
						xtype: 'displayfield',
						value: '',
						columnWidth: .02
					}, {
						columnWidth: .05,
						xtype: 'button',
						text: '查询',
						iconCls: 'find',
						handler: function (b) {
							itemGrid.load({
								params: {
									start: Ext
									.isEmpty(itemGrid.getBottomToolbar().cursor)
									 ? 0
									 : itemGrid.getBottomToolbar().cursor,
									limit: itemGrid.getBottomToolbar().pageSize
								}
							});
						}
					}
				]
			}
		]
	});

//添加
var addBtn = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加',
		iconCls: 'add',
		handler: function () {
			addFun();
		}
	});
//修改
var editButton = new Ext.Toolbar.Button({
		text: '修改',
		tooltip: '修改',
		iconCls: 'option',
		handler: function () {
			if (ChkBefEdit(itemGrid) == true) {
				editFun();
			} else {
				return;
			}

		}
	});
//删除
var deleteBtn = new Ext.Toolbar.Button({
		text: '删除',
		id: 'deleteBtn',
		iconCls: 'remove',
		handler: function () {
			if (ChkBefDel(itemGrid) == true) {
				del(itemGrid);
			} else {
				return;
			}
		}
	});

//提交
var submitBtn = new Ext.Toolbar.Button({
		text: '提交',
		iconCls: 'option',
		handler: function () {
			if (ChkBefSub(itemGrid) == true) {
				submit(itemGrid);
			} else {
				return;
			}
		}
	});

//把选中的项目明细汇总成一个项目
var sumBtn = new Ext.Toolbar.Button({
		text: '汇总',
		tooltip: '把选中的项目明细汇总成一个项目',
		iconCls: 'option',
		handler: function () {
			if (ChkBefSum(itemGrid) == true) {
				sum(itemGrid);
			} else {
				return;
			}
		}
	});

//明细信息面板
var itemGrid = new dhc.herp.Grid({
		title: '',
		region: 'center',
		height: 200,
		url: mainUrl,
		atLoad: true,
		viewConfig: {
			//forceFit : true
			getRowClass: function (record, rowIndex, rowParams, store) {
				if (record.data.State == "已汇总") {
					return 'cellColor4';
				} else if (record.data.State == "提交") {
					return 'cellColor3';
				} else {
					return '';
				}
			}
		},
		edit: false,
		fields: [
			new Ext.grid.CheckboxSelectionModel({
				//editable: false
			}), {
				id: 'rowid',
				header: '明细ID',
				width: 80,
				hidden: true,
				dataIndex: 'rowid'
			}, {
				id: 'projadjdr',
				header: '主表ID',
				width: 80,
				hidden: true,
				dataIndex: 'projadjdr'
			}, {
				id: 'fundtypedr',
				header: '资金类别ID',
				width: 80,
				hidden: true,
				dataIndex: 'fundtypedr'
			}, {
				id: 'fundtype',
				header: '资金类别',
				width: 120,
				hidden: false,
				dataIndex: 'fundtype'
			}, {
				id: 'projName',
				header: '项目名称',
				width: 200,
				editable: false,
				dataIndex: 'projName'
			}, {
				id: 'itemcode',
				header: '科目编码',
				width: 80,
				editable: false,
				hidden: true,
				dataIndex: 'itemcode'
			}, {
				id: 'bidlevel',
				header: '预算级别',
				width: 80,
				editable: true,
				hidden: true,
				dataIndex: 'bidlevel'
			}, {
				id: 'itemname',
				header: '科目名称',
				width: 150,
				dataIndex: 'itemname'
			}, {
				id: 'deptDR',
				header: '预算科室',
				width: 80,
				editable: false,
				hidden: true,
				dataIndex: 'deptDR'
			}, {
				id: 'deptName',
				header: '预算科室',
				width: 120,
				dataIndex: 'deptName'
			}, {
				id: 'bidislast',
				header: '是否末级',
				width: 80,
				hidden: true,
				dataIndex: 'bidislast'
			}, {
				id: 'budgprice',
				header: '预算单价',
				align: 'right',
				width: 80,
				xtype: 'numbercolumn',
				dataIndex: 'budgprice'
			}, {
				id: 'budgnum',
				header: '预算数量',
				width: 80,
				align: 'right',
				dataIndex: 'budgnum'
			}, {
				id: 'budgpro',
				header: '总预算占比(%)',
				width: 150,
				align: 'right',
				editable: true,
				dataIndex: 'budgpro'
			}, {
				id: 'budgvalue',
				header: '预算金额',
				width: 120,
				align: 'right',
				xtype: 'numbercolumn',
				editable: false,
				dataIndex: 'budgvalue'
			}, {
				id: 'isaddedit',
				header: '新增/更新',
				width: 120,
				dataIndex: 'isaddedit'
			}, {
				id: 'dutydeptDR',
				header: '责任科室ID',
				width: 80,
				hidden: true,
				dataIndex: 'dutydeptDR'
			}, {
				id: 'dutydeptName',
				header: '责任科室',
				editable: false,
				width: 120,
				dataIndex: 'dutydeptName'
			}, {
				id: 'State',
				header: '状态',
				width: 60,
				editable: false,
				dataIndex: 'State'
			}, {
				id: 'SSUSRName',
				header: '申请人',
				width: 80,
				hidden: true,
				editable: false,
				dataIndex: 'SSUSRName'
			}, {
				id: 'isaudit',
				header: '有否汇总权限',
				width: 150,
				hidden: true,
				dataIndex: 'isaudit'
			}, {
				id: 'projState',
				header: '项目状态',
				width: 120,
				hidden: true,
				dataIndex: 'projState'
			}, {
				id: 'budgdesc',
				header: '设备名称备注',
				width: 120,
				maxLength: 50,
				maxLengthText: '最大长度不超过50',
				dataIndex: 'budgdesc'
			}, {
				id: 'PerOrigin',
				header: '人员资质-原有设备',
				width: 150,
				dataIndex: 'PerOrigin'
			}, {
				id: 'FeeScale',
				header: '收费标准',
				width: 120,
				dataIndex: 'FeeScale'
			}, {
				id: 'AnnBenefit',
				header: '年效益预测',
				width: 120,
				dataIndex: 'AnnBenefit'
			}, {
				id: 'MatCharge',
				header: '耗材费',
				width: 80,
				dataIndex: 'MatCharge'
			}, {
				id: 'SupCondit',
				header: '配套条件',
				width: 120,
				dataIndex: 'SupCondit'
			}, {
				id: 'Remarks',
				header: '备注',
				width: 120,
				dataIndex: 'Remarks'
			}, {
				id: 'brand1',
				header: '推荐品牌1',
				width: 120,
				dataIndex: 'brand1'
			}, {
				id: 'spec1',
				header: '规格型号1',
				width: 120,
				dataIndex: 'spec1'
			}, {
				id: 'brand2',
				header: '推荐品牌2',
				width: 120,
				dataIndex: 'brand2'
			}, {
				id: 'spec2',
				header: '规格型号2',
				width: 120,
				dataIndex: 'spec2'
			}, {
				id: 'brand3',
				header: '推荐品牌3',
				width: 120,
				dataIndex: 'brand3'
			}, {
				id: 'spec3',
				header: '规格型号3',
				width: 120,
				dataIndex: 'spec3'
			}
		]

	});
itemGrid.addButton(addBtn);
itemGrid.addButton(editButton);
itemGrid.addButton(deleteBtn);
itemGrid.addButton(submitBtn);
itemGrid.addButton(sumBtn);

itemGrid.btnAddHide() //隐藏增加按钮
itemGrid.btnSaveHide(); //隐藏保存按钮
itemGrid.btnResetHide() //隐藏重置按钮
itemGrid.btnDeleteHide() //隐藏删除按钮
itemGrid.btnPrintHide(); //隐藏打印按钮

itemGrid.getStore().on('beforeload', function () {
	itemGrid.getStore().baseParams = {
		year: yearCmb.getValue(),
		dutydeptdr: deptCmb.getValue(),
		projdr: projCmb.getValue(),
		fundtype: fundTyCmb.getValue(),
		deptdr: bgDeptCmb.getValue(),
		itemcode: itemCmb.getValue(),
		userid: userid
	}
});

itemGrid.load({
	params: {
		start: Ext
		.isEmpty(itemGrid.getBottomToolbar().cursor)
		 ? 0
		 : itemGrid.getBottomToolbar().cursor,
		limit: itemGrid.getBottomToolbar().pageSize
	}
});

itemGrid.on('rowclick', function (grid, rowIndex, e) {
	row = rowIndex;
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	//判断是否选择了要审核的数据
	var isaudit = selectedRow[0].data['isaudit'];
	var State = selectedRow[0].data['State'];
	var projState = selectedRow[0].data['projState']; //项目状态，由此判断项目是否开始审批

	if (State == "新建") {
		submitBtn.enable();
		deleteBtn.enable();
		sumBtn.disable();
		editButton.enable(); //修改按钮可用
	}
	if (State == "提交") {
		submitBtn.disable();
		deleteBtn.disable();
		editButton.disable(); //修改按钮不可用
		sumBtn.disable();
		if (isaudit == "1") {
			editButton.enable(); //修改按钮可用
			sumBtn.enable();
			deleteBtn.enable();
		}
	}
	if (State == "已汇总") {
		submitBtn.disable();
		deleteBtn.disable();
		sumBtn.disable();
		editButton.disable() //修改按钮不可用
		if ((isaudit == "1") && ((projState == "1") || (projState == ""))) {
			editButton.enable() //修改按钮可用
			deleteBtn.enable();
		}
	}

});

//提交函数
function ChkBefEdit(grid) {
	//是否选中记录
	var rows = grid.getSelectionModel().getSelections();
	var len = rows.length;
	if (len !== 1) {
		Ext.Msg.show({
			title: '提示',
			msg: '请选择一条数据进行修改!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.INFO
		});
		return false;
	}
	//数据状态是否满足条件
	if (rows[0].get("isaudit") !== "1"
		 && rows[0].get("State") !== "新建") {
		Ext.Msg.show({
			title: '警告',
			msg: '无权限修改非"新建"状态单据！',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return false;
	}

	return true;
}

//1，明细单据是新建状态可删除
//2，明细单据是非新建状态，关联项目是新建状态，拥有汇总权限的人可删除。
function ChkBefDel(grid) {
	//是否选中记录
	var rows = grid.getSelectionModel().getSelections();
	var len = rows.length;
	if (len < 1) {
		Ext.Msg.show({
			title: '提示',
			msg: '请选择数据!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.INFO
		});
		return false;
	}
	//数据状态是否满足条件
	var flag = 1;
	var rowID = "";
	var message = "";
	for (var i = 0; i < len; i++) {
		if (rows[i].get("State") == "新建")
			continue;
		rowID = rows[i].get("rowid");
		if (rows[i].get("projState") !== "1") {
			flag = -1;
			message = '错误位置：rowID=' + rowID + '；错误原因：关联项目非"新建"状态，禁止删除！';
			break;
		}
		if (rows[i].get("isaudit") !== "1") {
			flag = -2;
			message = '错误位置：rowID=' + rowID + '；错误原因：无汇总权限，禁止删除！';
			break;
		}
	}
	if (flag !== 1) {
		Ext.Msg.show({
			title: '警告',
			msg: message,
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return false;
	}

	return true;
}

function del(grid) {
	Ext.MessageBox.confirm('提示', '确定要删除选定的数据吗？', function (btn) {
		if (btn == 'yes') {
			var rows = grid.getSelectionModel().getSelections();
			var len = rows.length;
			var data = "";
			for (var i = 0; i < len; i++) {
				if (data == "") {
					data = rows[i].get('rowid');
				} else {
					data = data + "^" + rows[i].get('rowid');
				}
			}

			Ext.Ajax.request({
				url: mainUrl + '?action=delete&data=' + data,
				waitMsg: '处理中...',
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
							title: '',
							msg: '删除成功',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.INFO
						});
						grid.getStore().reload();
					} else {
						Ext.Msg.show({
							title: '错误',
							msg: '错误信息:' + jsonData.info,
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.ERROR
						});
					}
				},
				scope: this
			});

		}
	})

}

//提交函数
function ChkBefSub(grid) {
	//是否选中记录
	var rows = grid.getSelectionModel().getSelections();
	var len = rows.length;
	if (len < 1) {
		Ext.Msg.show({
			title: '提示',
			msg: '请选择需要提交的数据!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.INFO
		});
		return false;
	}
	//数据状态是否满足条件
	var flag = 1;
	var rowID = "";
	var message = "";
	for (var i = 0; i < len; i++) {
		if (rows[i].get("State") == "新建")
			continue;
		rowID = rows[i].get("rowid");
		if (rows[i].get("State") !== "新建") {
			flag = -1;
			message = '错误位置：rowID=' + rowID + '；错误原因：已提交,不能再次提交！';
			break;
		}
	}
	if (flag !== 1) {
		Ext.Msg.show({
			title: '警告',
			msg: message,
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return false;
	}

	return true;
}

function submit(grid) {
	Ext.MessageBox.confirm('提示', '确定要提交吗？', function (btn) {
		if (btn == 'yes') {
			var rows = grid.getSelectionModel().getSelections();
			var data = "";
			//定义一个数组，用于暂存提交前被选中记录在store中的index
			var selArr = [];
			for (var i = 0; i < rows.length; i++) {
				//被选中记录的index存入数组selArr
				var RowIndex = grid.getStore().indexOf(rows[i]);
				selArr.push(RowIndex);
				//1:新建,2:提交,3:通过,4:不通过,5:完成
				if ((rows[i].data['State'] == "新建")
					 || (rows[i].data['State'] == '')) {
					if (data == "") {
						data = rows[i].data['rowid'];
					} else {
						data = data + "^" + rows[i].data['rowid'];
					}
				}
			}
			//alert(data);
			Ext.Ajax.request({
				url: mainUrl + '?action=submit&rowids=' + data,
				waitMsg: '处理中...',
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
						//显示提示成功提示信息
						Ext.Msg.show({
							title: '',
							msg: '提交成功!',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.INFO
						});

						//重新加载主表
						grid.getStore().reload({
							params: {
								start: Ext.isEmpty(grid.getBottomToolbar().cursor) ? 0 : grid.getBottomToolbar().cursor,
								limit: grid.getBottomToolbar().pageSize
							},
							callback: function (scope, success) {
								if (success) {
									//选中默认行
									for (var i = 0; i < selArr.length; i++) {
										grid.getSelectionModel().selectRow(selArr[i], true);
									}
								}
							}

						});
						//按钮权限管控
						submitBtn.disable();
						deleteBtn.disable();
						editButton.disable();
						if (rows[0].get("isaudit") == "1") {
							editButton.enable();
							sumBtn.enable();
							deleteBtn.enable();
						}
					} else {
						Ext.Msg.show({
							title: '错误',
							msg: jsonData.info,
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.INFO
						});
					}
				},
				scope: this
			});

		}
	})
}

//提交函数
function ChkBefSum(grid) {
	//是否选中记录
	var rows = grid.getSelectionModel().getSelections();
	var len = rows.length;
	if (len < 1) {
		Ext.Msg.show({
			title: '提示',
			msg: '请选择需要汇总的项目明细数据!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.INFO
		});
		return false;
	}
	//数据状态是否满足条件
	var flag = 1;
	var rowID = "";
	var message = "";
	for (var i = 0; i < len; i++) {
		if (rows[i].get("State") == "提交")
			continue;
		rowID = rows[i].get("rowid");
		if (rows[i].get("State") !== "提交") {
			flag = -1;
			message = '错误位置：rowID=' + rowID + '；错误原因：只允许汇总"提交"状态的单据！';
			break;
		}
		if (i == 0) {
			dutyDept = rows[i].get("dutydeptName");
		}
		if (dutyDept !== rows[i].get("dutydeptName")) {
			flag = -2;
			message = '错误位置：rowID=' + rowID + '；错误原因：请汇总同一责任科室的明细项！';
			break;
		}

	}
	if (flag !== 1) {
		Ext.Msg.show({
			title: '警告',
			msg: message,
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return false;
	}

	return true;
}

function sum(grid) {
	var rows = grid.getSelectionModel().getSelections();
	var data = "";
	//定义一个数组，用于暂存提交前被选中记录在store中的index
	var selArr = [];
	for (var i = 0; i < rows.length; i++) {
		//被选中记录的index存入数组selArr
		var RowIndex = grid.getStore().indexOf(rows[i]);
		selArr.push(RowIndex);
		//1:新建,2:提交,3:通过,4:不通过,5:完成
		if ((rows[i].data['State'] == "提交")
			 || (rows[i].data['State'] == '')) {
			if (data == "") {
				data = rows[i].data['rowid'];
			} else {
				data = data + "^" + rows[i].data['rowid'];
			}
		}
	}
	projsumFun(rows[0].get("dutydeptDR") + "_" + rows[0].get("dutydeptName"), mainUrl, data, rows[0].get("deptDR") + "_" + rows[0].get("deptName"), rows[0].get("itemname"), rows[0].get("isaudit"));
}
