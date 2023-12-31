/*
Creator: Zhou WenJie 、Hao ShanShan、Liu XiaoMing
CreatDate:
Description: 全面预算管理-基本信息维护-政府采购品目维护
CSPName: herp.budg.hisui.budgpurchasingitems.csp
ClassName: herp.budg.hisui.udata.ubudgpurchasingitems
 */
var groupid = session['LOGON.GROUPID'];
var hospid = session['LOGON.HOSPID'];
var userid = session['LOGON.USERID'];
$(function () { //初始化
	$("#nameM").val('');
	Init();
});
function Init() {
	//定义表格
	var hospid = session['LOGON.HOSPID'];
	var budgpurchasingTreeObj = $HUI.treegrid("#budgpurchasingTree", {
			url: $URL,
			queryParams: {
				ClassName: "herp.budg.hisui.udata.ubudgpurchasingitems",
				MethodName: "itemList",
				hospid: hospid
			},
			rownumbers: true,
			animate: true,
			collapsible: true,
			lines: true,
			fit: true,
			/*onLoadSuccess: function (node, data) {
				if (data) {
					$(data).each(function (index, d) {
						if (this.state == 'closed') {
							$('#budgpurchasingTree').treegrid('expandAll');
						}
					})
				}
			},*/
			idField: 'rowid',
			treeField: 'Year',
			columns: [[{
						field: 'rowid',
						title: 'ID',
						hidden: true
					}, {
						field: 'CompDR',
						hidden: true
					}, {
						field: 'Year',
						title: '年度',
						width: 180,
						align: 'left',
						halign: 'left'
					}, {
						field: 'Code',
						title: '品目编码',
						width: 120,
						align: 'left',
						halign: 'left'
					}, {
						field: 'Name',
						title: '品目名称',
						width: 180,
						align: 'left',
						halign: 'left'
					}, {
						field: 'SupCode',
						title: '上级编码',
						width: 120,
						align: 'left',
						halign: 'left'
					}, {
						field: 'IsLast',
						title: '是否末级',
						width: 80,
						align: 'center',
						halign: 'center',
						formatter: function (value) {
							if (value == 1) {
								return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>'
							} else {
								return '<input type="checkbox" value="" onclick="return false"/>'
							}
						}
					}, {
						field: 'ReMark',
						title: '拼音码',
						width: 150,
						align: 'left',
						halign: 'left'
					}, {
						field: 'Level',
						title: '层级',
						width: 80,
						align: 'center',
						halign: 'center'
					}, {
						field: 'Desc',
						title: '说明',
						width: 800,
						align: 'left',
						halign: 'left'
					}
				]],

			toolbar: [{
					id: 'Add',
					iconCls: 'icon-add',
					text: '新增',
					handler: function (hospid) {
						add()
					}
				}, {
					id: 'Edit',
					iconCls: 'icon-write-order',
					text: '编辑',
					handler: function () {
						edit()
					}
				}, {
					id: 'Del',
					iconCls: 'icon-cancel',
					text: '删除',
					handler: function () {
						delect()
					}
				}, {
					id: 'expAll',
					iconCls: 'icon-paper-arrow-down',
					text: '全部展开',
					handler: function () {
						expandAll()
					}
				}, {
					id: 'colAll',
					iconCls: 'icon-arrow-up',
					text: '全部折叠',
					handler: function () {
						collapseAll()
					}
				}, {
					id: 'Copy',
					iconCls: 'icon-copy',
					text: '复制',
					handler: function () {
						copy()
					}
				}
			],

		});

	//年度的下拉框
	var yearM = $HUI.combobox("#YearM", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
			mode: 'remote',
			delay: 200,
			valueField: 'year',
			textField: 'year',
			onBeforeLoad: function (param) {
				param.str = param.q,
				param.flag = ""
			}
		});

	//查询方法
	$("#FindBtn").click(function () {
		var Year = $('#YearM').combobox('getValue')
			var SupCode1 = $('#SupercodeM').val()
			var name = $('#nameM').val()
			var Level = $('#LevelM').val()
			//console.log("dataa:"+JSON.stringify(dataa))
			if (Year == "") {
				$.messager.popover({
					msg: '请选择年度！',
					timeout: 2000,
					type: 'alert',
					showType: 'show',
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 1
					}
				})
				return;
			};
		$.m({
			ClassName: 'herp.budg.hisui.udata.ubudgpurchasingitems',
			MethodName: 'List',
			hospid: hospid,
			name: name,
			Year: Year,
			Level: Level,
			SupCode1: SupCode1
		},
			function (rtn) {
			if (rtn == "") {
				$.messager.popover({
					msg: '该条数据不存在',
					type: 'error',
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 1
					}
				})
			} else {
				$('#budgpurchasingTree').treegrid('collapseAll');
				$("#budgpurchasingTree").treegrid('selectAll');
				$('#budgpurchasingTree').treegrid('expandTo', rtn).treegrid('select', rtn)
			}
		})
	})

	//删除方法
	function delect() {
		var row = $('#budgpurchasingTree').treegrid('getSelected');
		//console.log(JSON.stringify(row));
		if (row == null) {
			$.messager.popover({
				msg: '请选择所要删除的行！',
				timeout: 2000,
				type: 'alert',
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
					top: 1
				}
			});
			return;
		};
		var rows = $('#budgpurchasingTree').treegrid('getChildren', row.rowid);
		var obj = JSON.stringify(rows);
		var rowid = row.rowid;
		var IsLast = row.IsLast;
		var Code = row.Code;
		var Year = row.Year;
		var parentid = row._parentId
			if ((IsLast == 1) || ((obj == '[]') && (IsLast == 0))) {
				$.messager.confirm('确定', '确认删除吗？', function (t) {
					if (t) {
						$.m({
							ClassName: 'herp.budg.hisui.udata.ubudgpurchasingitems',
							MethodName: 'Delete',
							rowid: rowid,
							hospid: hospid,
							Code: Code,
							Year: Year
						},
							function (SQLCODE) {
							$.messager.progress({
								title: '提示',
								msg: '正在删除，请稍候……'
							});
							if (SQLCODE == 0) {
								$.messager.popover({
									msg: '删除成功！',
									type: 'success',
									style: {
										"position": "absolute",
										"z-index": "9999",
										left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
										top: 1
									}
								});
								$.messager.progress('close');
								$("#budgpurchasingTree").treegrid("reload", parentid);
							} else {
								$.messager.popover({
									msg: '删除失败！' + SQLCODE,
									type: 'error',
									style: {
										"position": "absolute",
										"z-index": "9999",
										left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
										top: 1
									}
								});
								$.messager.progress('close');
							}
						})
					}
				})
			} else {
				$.messager.confirm('确定', '此记录含有子集，确认删除吗？', function (t) {
					if (t) {
						var rowid = row.rowid;
						$.m({
							ClassName: 'herp.budg.hisui.udata.ubudgpurchasingitems',
							MethodName: 'Delete',
							rowid: rowid,
							hospid: hospid,
							Code: Code,
							Year: Year
						},

							function (SQLCODE) {
							$.messager.progress({
								title: '提示',
								msg: '正在删除，请稍候……'
							});
							if (SQLCODE == 0) {
								$.messager.popover({
									msg: '删除成功！',
									type: 'success',
									style: {
										"position": "absolute",
										"z-index": "9999",
										left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
										top: 1
									}
								});
								$.messager.progress('close');
								$('#budgpurchasingTree').treegrid("reload");
							} else {
								$.messager.popover({
									msg: '删除失败！' + SQLCODE,
									type: 'error',
									style: {
										"position": "absolute",
										"z-index": "9999",
										left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
										top: 1
									}
								});
								$.messager.progress('close');
							}
						})
					}
				})
			}
			$("#budgpurchasingTree").treegrid("unselectAll");
	};

	//全部展开
	function expandAll() {
		$('#budgpurchasingTree').treegrid('expandAll');
	};
	//全部折叠
	function collapseAll() {
		$('#budgpurchasingTree').treegrid('collapseAll');
	}
};
//
