var userid = session['LOGON.USERID'];
var hospid = session['LOGON.HOSPID'];
$(function () { //初始化
	Init();
});
function Init() {
	var grid = $('#MainGrid');
	var BillTypeObj = $HUI.combobox("#BillTypebox", {
			mode: 'local',
			valueField: 'rowid',
			textField: 'name',
			onSelect: function () {
				MainGridObj.load({
					ClassName: "herp.budg.hisui.udata.uBudgBillReqCtrl",
					MethodName: "List",
					hospid: hospid,
					billtype: $('#BillTypebox').combobox('getValue'),
					method: $('#Methodbox').combobox('getValue'),
					reqdeptdr: $('#ReqDeptdrbox').combobox('getValue'),
					user: $('#Userbox').combobox('getValue'),
					reqaudeptdr: $('#ReqAuDeptdrbox').combobox('getValue')
				})
			},
			data: [{
					'rowid': "1",
					'name': "项目报销单"
				}, {
					'rowid': "2",
					'name': "项目资金申请单"
				}, {
					'rowid': "3",
					'name': "一般支出报销单"
				}, {
					'rowid': "4",
					'name': "一般支出资金申请单"
				}, {
					'rowid': "5",
					'name': "一般支出预报销"
				}
			]
		});
	//编制方式下拉框
	var MethodObj = $HUI.combobox("#Methodbox", {
			mode: 'local',
			valueField: 'rowid',
			textField: 'name',
			onSelect: function () {
				MainGridObj.load({
					ClassName: "herp.budg.hisui.udata.uBudgBillReqCtrl",
					MethodName: "List",
					hospid: hospid,
					billtype: $('#BillTypebox').combobox('getValue'),
					method: $('#Methodbox').combobox('getValue'),
					reqdeptdr: $('#ReqDeptdrbox').combobox('getValue'),
					user: $('#Userbox').combobox('getValue'),
					reqaudeptdr: $('#ReqAuDeptdrbox').combobox('getValue')
				})
			},
			data: [{
					'rowid': "1",
					'name': "个人"
				}, {
					'rowid': "2",
					'name': "代编"
				}
			]
		});

	//业务科室下拉框
	var ReqDeptdrObj = $HUI.combobox("#ReqDeptdrbox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.userdr = userid;
				param.flag = 1;
				param.str = param.q;
			},
			onSelect: function () {
				MainGridObj.load({
					ClassName: "herp.budg.hisui.udata.uBudgBillReqCtrl",
					MethodName: "List",
					hospid: hospid,
					billtype: $('#BillTypebox').combobox('getValue'),
					method: $('#Methodbox').combobox('getValue'),
					reqdeptdr: $('#ReqDeptdrbox').combobox('getValue'),
					user: $('#Userbox').combobox('getValue'),
					reqaudeptdr: $('#ReqAuDeptdrbox').combobox('getValue')
				})
			},
		})

		//操作人下拉框
		var UsersObj = $HUI.combobox("#Userbox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.userdr = userid;
				param.flag = 1;
				param.str = param.q;
			},
			onSelect: function () {
				MainGridObj.load({
					ClassName: "herp.budg.hisui.udata.uBudgBillReqCtrl",
					MethodName: "List",
					hospid: hospid,
					billtype: $('#BillTypebox').combobox('getValue'),
					method: $('#Methodbox').combobox('getValue'),
					reqdeptdr: $('#ReqDeptdrbox').combobox('getValue'),
					user: $('#Userbox').combobox('getValue'),
					reqaudeptdr: $('#ReqAuDeptdrbox').combobox('getValue')
				})
			},
		})

		//归口科室下拉框
		var ReqAuDeptdrObj = $HUI.combobox("#ReqAuDeptdrbox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.userdr = userid;
				param.flag = 8;
				param.str = param.q;
			},
			onSelect: function () {
				MainGridObj.load({
					ClassName: "herp.budg.hisui.udata.uBudgBillReqCtrl",
					MethodName: "List",
					hospid: hospid,
					billtype: $('#BillTypebox').combobox('getValue'),
					method: $('#Methodbox').combobox('getValue'),
					reqdeptdr: $('#ReqDeptdrbox').combobox('getValue'),
					user: $('#Userbox').combobox('getValue'),
					reqaudeptdr: $('#ReqAuDeptdrbox').combobox('getValue')
				})
			},
		})

		MainColumns = [[{
					field: 'ck',
					checkbox: true
				}, //复选框
				{
					field: 'rowid',
					title: '申请信息ID',
					width: 80,
					hidden: true
				}, {
					field: 'method',
					title: '编制方式',
					width: 80,
					align: 'left',
					halign: 'left',
					formatter: comboboxFormatter,
					editor: {
						type: 'combobox',
						options: {
							valueField: 'rowid',
							textField: 'name',
							required: true,
							onSelect: function (data) {
								if (data.rowid == 1) {
									var ed1 = $('#MainGrid').datagrid('getEditor', {
											'index': editIndex,
											field: 'reqaudeptdr'
										});
									$(ed1.target).combobox({
										required: false,
										width: 150,
									});
									$(ed1.target).combobox("disable");
									$(ed1.target).combobox('clear');

								} else {
									var ed1 = $('#MainGrid').datagrid('getEditor', {
											index: editIndex,
											field: 'reqaudeptdr'
										});
									$(ed1.target).combobox("enable");
								}
							},
							delay: 200,
							data: [{
									rowid: "1",
									name: "个人"
								}, {
									rowid: "2",
									name: "代编"
								}
							]
						}
					}
				}, {
					field: 'billtype',
					title: '单据类型',
					width: 150,
					align: 'left',
					halign: 'left',
					allowBlank: false,
					formatter: comboboxFormatter,
					editor: {
						type: 'combobox',
						options: {
							valueField: 'rowid',
							textField: 'name',
							delay: 200,
							required: true,
							data: [{
									rowid: "1",
									name: "项目报销单"
								}, {
									rowid: "2",
									name: "项目资金申请单"
								}, {
									rowid: "3",
									name: "一般支出报销单"
								}, {
									rowid: "4",
									name: "一般支出资金申请单"
								}, {
									rowid: "5",
									name: "一般支出预报销"
								}
							]
						}
					}
				}, {
					field: 'reqdeptdr',
					title: '业务科室',
					width: 150,
					align: 'left',
					halign: 'left',
					formatter: function (value, row, index) {
						return row.deptname;
					},
					editor: {
						type: 'combobox',
						options: {
							valueField: 'rowid',
							textField: 'name',
							url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
							delay: 200,
							mode: 'remote',
							required: true,
							onBeforeLoad: function (param) {
								param.hospid = hospid;
								param.userdr = userid;
								param.flag = 1;
								param.str = param.q;
							},
						}
					}
				}, {
					field: 'userid',
					title: '操作人',
					width: 120,
					align: 'left',
					halign: 'left',
					formatter: function (value, row, index) {
						return row.user;
					},
					editor: {
						type: 'combobox',
						options: {
							valueField: 'rowid',
							textField: 'name',
							mode: 'remote',
							url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
							delay: 200,
							required: true,
							onBeforeLoad: function (param) {
								param.hospid = hospid;
								param.userdr = userid;
								param.flag = 1;
								param.str = param.q;
							},
						}
					}
				}, {
					field: 'reqaudeptdr',
					title: '归口科室',
					width: 150,
					align: 'left',
					halign: 'left',
					formatter: function (value, row, index) {
						return row.audeptname;
					},
					editor: {
						type: 'combobox',
						options: {
							valueField: 'rowid',
							textField: 'name',
							mode: 'remote',
							url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
							delay: 200,
							required: true,
							onBeforeLoad: function (param) {
								param.hospid = hospid;
								param.userdr = userid;
								param.flag = 8;
								param.str = param.q;
							}
						}
					}
				}
			]];
	var MainGridObj = $HUI.datagrid("#MainGrid", {
			url: $URL,
			queryParams: {
				ClassName: "herp.budg.hisui.udata.uBudgBillReqCtrl",
				MethodName: "List",
				hospid: hospid,
				billtype: "",
				method: "",
				reqdeptdr: "",
				user: "",
				reqaudeptd: ""
			},
			fitColumns: false, //列固定
			loadMsg: "正在加载，请稍等…",
			autoRowHeight: true,
			rownumbers: true, //行号
			ctrlSelec: true, //在启用多行选择的时候允许使用Ctrl键+鼠标点击的方式进行多选操作
			//singleSelect: true, //只允许选中一行
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100], //页面大小选择列表
			pagination: true, //分页
			fit: true,
			columns: MainColumns,
			rowStyler: function (index, row) {
				if (index % 2 == 1) {
					return 'background-color:#FAFAFA;';
				}
			},
			onDblClickRow: onDblClickRow, //在用户双击一行的时候触发
			onClickRow:onDblClickRow,
			toolbar: '#tb'
		});

	function endEditing() {
		if (editIndex == undefined) {
			return true
		}
		if ($('#MainGrid').datagrid('validateRow', editIndex)) {
			var row = $('#MainGrid').datagrid('getRows')[editIndex];
			$('#MainGrid').datagrid('endEdit', editIndex);
			editIndex = undefined;
			return true;

		} else {
			return false;
		}
	}

	function onDblClickRow(index) {
		if (endEditing()) {
			$('#MainGrid').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
		} else {
			$('#MainGrid').datagrid('selectRow', editIndex);
		};
		var row = $('#MainGrid').datagrid('getRows')[index];
		if (row.method == "1") {
			var ed1 = $('#MainGrid').datagrid('getEditor', {
					index: editIndex,
					field: 'reqaudeptdr'
				});
			$(ed1.target).combobox({
				required: false,
				width: 150,
			});
			$(ed1.target).combobox("disable");

		} else {
			var ed1 = $('#MainGrid').datagrid('getEditor', {
					index: editIndex,
					field: 'reqaudeptdr'
				});
			$(ed1.target).combobox("enable");

		}
	};
	
	var EndEditFun = function () {
		var indexs = grid.datagrid('getEditingRowIndexs');
		if (indexs.length > 0) {
			for (i = 0; i < indexs.length; i++) {
				var ed = $('#MainGrid').datagrid('getEditor', {
						index: indexs[i],
						field: 'reqdeptdr'
					});
				var ed1 = $('#MainGrid').datagrid('getEditor', {
						index: indexs[i],
						field: 'userid'
					});
				var ed2 = $('#MainGrid').datagrid('getEditor', {
						index: indexs[i],
						field: 'reqaudeptdr'
					});
				if (ed) {
					var DeptName = $(ed.target).combobox('getText');
					$('#MainGrid').datagrid('getRows')[indexs[i]]['deptname'] = DeptName;
				}
				if (ed1) {
					var UserName = $(ed1.target).combobox('getText');
					$('#MainGrid').datagrid('getRows')[indexs[i]]['user'] = UserName;
				}
				if (ed2) {
					var AudeptName = $(ed2.target).combobox('getText');
					$('#MainGrid').datagrid('getRows')[indexs[i]]['audeptname'] = AudeptName;
				}
				grid.datagrid("endEdit", indexs[i]);
			}
		}
	}

	//查询函数
	var FindBtn = function () {
		var BillType = $('#BillTypebox').combobox('getValue'); // 单据类型
		var Method = $('#Methodbox').combobox('getValue'); // 编制方式
		var ReqDeptdr = $('#ReqDeptdrbox').combobox('getValue'); // 业务科室
		var User = $('#Userbox').combobox('getValue'); // 操作人
		var ReqAuDeptdr = $('#ReqAuDeptdrbox').combobox('getValue'); // 归口科室
		MainGridObj.load({
			ClassName: "herp.budg.hisui.udata.uBudgBillReqCtrl",
			MethodName: "List",
			hospid: hospid,
			billtype: BillType,
			method: Method,
			reqdeptdr: ReqDeptdr,
			user: User,
			reqaudeptd: ReqAuDeptdr
		})
	}

	//点击查询按钮
	$("#FindBn").click(FindBtn);

	//增加一行
	var AddRow = function (row) {
		$('#MainGrid').datagrid('endEdit', editIndex);
		$('#MainGrid').datagrid('appendRow', {
			method: ''
		});
		editIndex = $('#MainGrid').datagrid('getRows').length - 1;
		$('#MainGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
	}

	//添加按钮
	$("#AddBn").click(AddRow);

	//保存按钮
	$("#SaveBn").click(function () {
		EndEditFun();
		//取到发生变化的记录对象
		var rows = grid.datagrid("getChanges");
		var row = "",
		data = "";
		if (!rows.length) {
			$.messager.popover({
				msg: '没有要保存的内容！',
				type: 'info',
				style: {
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
					top: 10
				}
			});
			return false;
		} else {
			$.messager.confirm('确定', '确定要保存数据吗？',
				function (t) {
				if (t) {
					for (var i = 0; i < rows.length; i++) {
						row = rows[i];
						var rowid = ((row.rowid == undefined) ? '' : row.rowid);
						var hospId = hospid;
						var billtype = ((row.billtype == undefined) ? '' : row.billtype);
						var method = ((row.method == undefined) ? '' : row.method);
						var reqdeptdr = ((row.reqdeptdr == undefined) ? '' : row.reqdeptdr);
						var userid = ((row.userid == undefined) ? '' : row.userid);
						var reqaudeptdr = ((row.reqaudeptdr == undefined) ? '' : row.reqaudeptdr);

						if (saveAllowBlankVaild(grid, row) == true) {

							var datad = hospId + '|' + billtype + '|' + method + '|' + reqdeptdr + '|' + userid + '|' + reqaudeptdr

								if (rowid == "") {
									$.m({
										ClassName: 'herp.budg.hisui.udata.uBudgBillReqCtrl',
										MethodName: 'Insert',
										data: datad,
									},
										function (Data) {
										if (Data == 0) {
											$.messager.popover({
												msg: '保存成功！',
												type: 'success',
												style: {
													left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
													top: 10
												}
											});
										} else if (Data == "RepCode") {
											$.messager.popover({
												msg: "编码重复，已存在相应编码的对应关系",
												type: 'error',
												style: {
													left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
													top: 10
												}
											});
										} else {
											$.messager.popover({
												msg: "错误信息:" + Data,
												type: 'error',
												style: {
													left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
													top: 10
												}
											});
										}
									});
									grid.datagrid("reload");
								} else {
									$.m({
										ClassName: 'herp.budg.hisui.udata.uBudgBillReqCtrl',
										MethodName: 'Update',
										rowid: rowid,
										data: datad,
									},
										function (Data) {
										if (Data == 0) {
											$.messager.popover({
												msg: '保存成功！',
												type: 'success',
												style: {
													left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
													top: 10
												}
											});
										} else if (Data == "RepCode") {
											$.messager.popover({
												msg: "编码重复，已存在相应编码的对应关系",
												type: 'error',
												style: {
													left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
													top: 10
												}
											});
										} else {
											$.messager.popover({
												msg: "错误信息:" + Data,
												type: 'error',
												style: {
													left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
													top: 10
												}
											});
										}
									});
								}
								grid.datagrid("reload");
						}
					}
				}
			})
		}
	});

	//删除
	$("#DelBn").click(function () {
		$.messager.confirm('确定', '确定要删除选定的数据吗？', function (t) {
			if (t) {
				var rows = $('#MainGrid').datagrid('getSelections');
				var len = rows.length;
				var data = "";
				for (var i = 0; i < len; i++) {
					if (data == "") {
						data = rows[i].rowid;
					} else {
						data = data + "^" + rows[i].rowid;

					}
				}
				$.m({
					ClassName: 'herp.budg.hisui.udata.uBudgBillReqCtrl',
					MethodName: 'Delete',
					rowids: data
				},
					function (Data) {
					if (Data == 0) {
						$.messager.popover({
							msg: '删除成功！',
							type: 'success',
							style: {
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
								top: 10
							}

						});
						$('#MainGrid').datagrid("reload")
					} else {
						$.messager.popover({
							msg: '删除失败! 错误信息:' + Data,
							type: 'error',
							style: {
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
								top: 10
							}
						});
						$('#MainGrid').datagrid("reload")

					}
				});
			}
		})
	})
}