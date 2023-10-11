/*
Creator: Liu XiaoMing
CreatDate: 2018-03-23
Description: 控制项管理-设置控制项
CSPName: herp.budg.hisui.budgitemmonitor.csp
ClassName: herp.budg.hisui.udata.uBudgItemMonitor
 */
var hospid = session['LOGON.HOSPID'];
var init = function () {
	//树形表格
	var ctrlItemsObj = $HUI.treegrid("#setCtrlItems", {
			//title: '支出控制项设置',
			//headerCls: 'panel-header-gray',
			lines: true,
			border: false,
			fit: true,
			idField: 'id',
			treeField: 'Name',
			rownumbers: true,
			autoSizeColumn: false,
			checkbox: true,
			url: $URL,
			queryParams: {
				ClassName: "herp.budg.hisui.udata.uBudgItemMonitor",
				MethodName: "List",
				hospid: hospid
			},
			/*
			onLoadSuccess: function (row, data) {
			if (data) {
			$.each(data, function (index, item) {
			alert(item.checked);

			});
			}
			},
			 */
			onCheckNode: function (row, checked) {
				var p = ctrlItemsObj.getPanel();
				var nodes = ctrlItemsObj.getCheckedNodes();
				/*
				if (nodes.length) {
				p.find("#addCItems").linkbutton("enable");
				p.find("#delCItems").linkbutton("enable");
				} else {
				p.find("#addCItems").linkbutton("disable");
				p.find("#delCItems").linkbutton("disable");
				}
				 */
			},
			columns: [[{
						field: 'id',
						width: '250',
						hidden: true,
						title: 'ID'
					}, {
						field: 'Name',
						width: '250',
						title: '名称'
					}, {
						field: 'Code',
						width: '150',
						title: '编码'
					}, {
						field: 'Year',
						width: '100',
						title: '年度'
					}, {
						field: 'CompDR',
						width: '200',
						title: '医院名称'
					}, {
						field: 'Active',
						width: '120',
						title: '是否控制'
					}, {
						field: '_parentId',
						width: '120',
						hidden: true,
						title: '上级编码'
					}
				]],
			toolbar: [{
					iconCls: 'icon-add',
					text: '支出控制',
					id: 'addCItems',
					//disabled: true,
					handler: function () {
						save(ctrlItemsObj);
					}
				}, {
					iconCls: 'icon-cancel',
					text: '删除',
					id: 'delCItems',
					//disabled: true,
					handler: function () {
						del(ctrlItemsObj);
					}
				}
			]

		});

	//支出控制方法
	var save = function (treegridObj) {
		//alert(getNoChiChkedNodesId(treegridObj));
		if (getNoChiChkedNodesId(treegridObj)) {
			$.m({
				ClassName: "herp.budg.hisui.udata.uBudgItemMonitor",
				MethodName: "Save",
				rowids: getNoChiChkedNodesId(treegridObj)
			}, function (rtn) {
				if (rtn == 0) {
					treegridObj.reload();
					$.messager.popover({
						msg: '设置成功！',
						type: 'success',
						timeout: 3000,
						showType: 'show',
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 10
						}
					});

				} else {
					$.messager.popover({
						msg: '设置失败' + rtn,
						type: 'error',
						timeout: 3000,
						showType: 'show',
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 10
						}
					});
				};
			});
		}
	}

	//删除方法
	var del = function (treegridObj) {
		if (getNoChiChkedNodesId(treegridObj)) {
			$.m({
				ClassName: "herp.budg.hisui.udata.uBudgItemMonitor",
				MethodName: "Del",
				rowids: getNoChiChkedNodesId(treegridObj)
			}, function (rtn) {
				if (rtn == 0) {
					treegridObj.reload();
					$.messager.popover({
						msg: '删除成功！',
						type: 'success',
						timeout: 1000,
						showType: 'show',
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 10
						}
					});

				} else {
					$.messager.popover({
						msg: '删除失败：' + rtn,
						type: 'error',
						timeout: 3000,
						showType: 'show',
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
							top: 10
						}
					});

				};
			});
		} else {
			return;
		}

	}
};

$(init);
