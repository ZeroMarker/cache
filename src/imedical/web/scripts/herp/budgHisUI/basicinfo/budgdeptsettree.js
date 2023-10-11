/*
Creator: Hou ShanChuan 、Liu XiaoMing
CreatDate: 2018-09-30
Description: 全面预算管理-基本信息维护-预算科室维护
CSPName: herp.budg.hisui.budgdeptsettree.csp
ClassName: herp.budg.hisui.udata.uBudgDeptSet
 */

var userid = session['LOGON.USERID'];
var hospid = session['LOGON.HOSPID'];
var addEditDlgDlgObj = ''; //用于判断添加/修改对话框是否已创建
var copyDlgObj = '';
var isAll = false; //管控是否展开所选节点所有子节点
var flag = "";

//文档就绪事件
$(function () {
	$("#CodeName").val('');
	Init();
});

function Init() {

	//点击行展开该节点的下一节点
	function onClickRow(row) {
		isAll = false;
		if ((row) && ($('#budgLocTree').treegrid('getSelected').state == 'closed')) {
			$('#budgLocTree').treegrid('expand', $('#budgLocTree').treegrid('getSelected').id)
		} else {
			$('#budgLocTree').treegrid('collapse', $('#budgLocTree').treegrid('getSelected').id)
		}
		return true;

	}

	//数据加载完成之后触发
	function onLoadSuccessFN(row, data) {
		if (row && isAll) {
			var data = $('#budgLocTree').treegrid('getChildren', row.id);
			for (i = 0; i < data.length; i++) {
				if (data[i].state == 'closed') {
					$('#budgLocTree').treegrid('expandAll', data[i].id);
				}
			}
		} else {
			return;
		}
	}

	function IsFormatter(value) {
		if (value == 1) {
			return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>';
		} else {
			return '<input type="checkbox" value="" onclick="return false"/>';
		}
	}

	//定义树形表格
	var budgLocTreeObj = $HUI.treegrid('#budgLocTree', {
			lines: true,
			border: false,
			fit: true,
			idField: 'id',
			treeField: 'name',
			rownumbers: true,
			url: $URL,
			queryParams: {
				ClassName: 'herp.budg.hisui.udata.uBudgDeptSet',
				MethodName: 'ListTree',
				searchField: '',
				searchValue: '',
				sortField: '',
				sortDir: '',
				id: ''
			},
			onClickRow: onClickRow,
			onLoadSuccess: onLoadSuccessFN,
			frozenColumns: [[{
						title: '医疗单位ID',
						field: 'hospId',
						halign: 'center',
						hidden: 'true'
					}, {
						title: '医疗单位名称',
						width: '140',
						field: 'hospNa',
						halign: 'center',
						hidden: 'true'
					}, {
						title: '预算科室ID',
						field: 'id',
						halign: 'center',
						hidden: 'true'
					}, {
						title: '预算科室编码',
						width: '120',
						field: 'code',
						halign: 'left',
						align: 'left'
					}, {
						title: '预算科室名称',
						width: '160',
						field: 'name',
						halign: 'left',
						align: 'left'
					}
				]],
			columns: [[{
						title: '拼音码',
						width: '130',
						field: 'Pym',
						halign: 'left',
						align: 'left'
					}, {
						title: '科室类别ID',
						width: '120',
						field: 'classType',
						hidden: 'true'
					}, {
						title: '科室类别',
						width: '120',
						field: 'classTypename',
						halign: 'center',
						align: 'center'
					}, {
						title: '科主任ID',
						width: '120',
						field: 'directdr',
						hidden: 'true'
					}, {
						title: '科主任',
						width: '120',
						field: 'directname',
						halign: 'left',
						align: 'left'
					}, {
						title: '科室层级',
						width: '120',
						field: 'level',
						halign: 'center',
						align: 'center'
					}, {
						title: '门诊住院',
						width: '120',
						field: 'IOflag',
						halign: 'left',
						align: 'left'
					}, {
						title: '归口科室',
						width: '70',
						field: 'isbudg',
						halign: 'center',
						align: 'center',
						editor: {
							type: 'checkbox',
							options: {
								on: '1',
								off: '0'
							}
						},
						formatter: IsFormatter
					}, {
						title: '是否有效',
						width: '70',
						field: 'sstate',
						halign: 'center',
						align: 'center',
						editor: {
							type: 'checkbox',
							options: {
								on: '1',
								off: '0'
							}
						},
						formatter: IsFormatter
					}, {
						title: '用于预算项目',
						width: '130',
						field: 'isitem',
						halign: 'center',
						align: 'center',
						editor: {
							type: 'checkbox',
							options: {
								on: '1',
								off: '0'
							}
						},
						formatter: IsFormatter
					}, {
						title: '是否末级',
						width: '130',
						field: 'islast',
						halign: 'center',
						align: 'center',
						editor: {
							type: 'checkbox',
							options: {
								on: '1',
								off: '0'
							}
						},
						formatter: IsFormatter
					}, {
						title: '上级科室ID',
						width: '120',
						field: '_parentId',
						hidden: false
					}

				]],
			toolbar: [{
					iconCls: 'icon-add',
					text: '新增',
					handler: addFn
				}, {
					iconCls: 'icon-write-order',
					text: '修改',
					handler: editFn
				}, {
					iconCls: 'icon-cancel',
					text: '删除',
					handler: delFn
				}, {
					iconCls: 'icon-paper-arrow-down',
					text: '全部展开',
					handler: expandAllFn
				}
			]

		});

	//查询方法
	$("#findBtn").click(function () {
		var codeNa = $("#CodeName").val();
		$('#budgLocTree').treegrid('load', {
			ClassName: 'herp.budg.hisui.udata.uBudgDeptSet',
			MethodName: 'ListTree',
			searchField: '',
			searchValue: codeNa,
			sortField: '',
			sortDir: '',
			id: ''
		});
	});

	function clear() {
		//$('#LHosp').clear();
		$("#Lcode").val('').validatebox("validate");
		$("#ldesc").val('').validatebox("validate");
		$("#spell").val('');
		$('#io').val('');
		$('#ibudg').checkbox('setValue', false);
		$('#istate').checkbox('setValue', false);
		$('#iitm').checkbox('setValue', false);
		$('#ilst').checkbox('setValue', false);
	}
	//名称的监听事件生成拼音码
	$('#ldesc').keyup(function (event) {
		$('#spell').val(makePy($('#ldesc').val().trim()));
	});

	//保存按钮
	$('#Save').click(AddClickHandler);
	//清屏按钮
	$('#Clear').click(clear);
	//关闭按钮
	$("#Close").click(function () {
		$("#addEditDlg").window('close');
	});

	function addFn() {
		flag = 1; //表示新增
		//判断是否添加顶级科目
		var tempIsLast = '';
		var SelectedNode = $('#budgLocTree').treegrid('getSelected');

		if (SelectedNode == null) {
			tempIsLast = 0;
		} else {
			tempIsLast = SelectedNode.islast;
		}

		if (tempIsLast == 1) {
			$.messager.alert('提示', '不允许给末级节点添加子节点！');
		} else {
			clear();

			if (addEditDlgDlgObj == '') {
				addEditDlgDlgObj = $HUI.window("#addEditDlg", {
						width: 400,
						height: 550,
						left: ($(window).width() - 400) * 0.5,
						top: ($(window).height() - 550) * 0.5,
						resizable: true,
						collapsible: false,
						minimizable: false,
						maximizable: false,
						closed: true,
						draggable: true,
						modal: true,
						onClose: function () { //关闭关闭窗口后触发
							$("#winForm").form("clear");
						}
					});

			} else {
				addEditDlgDlgObj.open();
			}

			$('#addEditDlg').window({
				title: "新增预算科室",
				iconCls: 'icon-w-new'
			});
			$("#addEditDlg").css("display", "block");
			addEditDlgDlgObj.open();

			CreateInit();
		}

	}

	//点击修改事件
	function editFn() {
		flag = 0;
		var SelectedNode = $('#budgLocTree').treegrid('getSelected');
		var rowid = SelectedNode.id;
		if ((rowid == "") || (rowid == undefined)) {
			$.messager.popover({
				msg: '请选择所要编辑的行！',
				timeout: 2000,
				type: 'alert',
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
					top: 0
				}
			});
			return;
		}

		clear();

		SetDefault(rowid);

		if (addEditDlgDlgObj == '') {
			addEditDlgDlgObj = $HUI.window("#addEditDlg", {
					width: 400,
					height: 550,
					left: ($(window).width() - 400) * 0.5,
					top: ($(window).height() - 550) * 0.5,
					resizable: true,
					collapsible: false,
					minimizable: false,
					maximizable: false,
					closed: true,
					draggable: true,
					modal: true,
					onClose: function () { //关闭关闭窗口后触发
						$("#winForm").form("clear");
					}
				});

		}

		//获取window的title属性
		//$('#addEditDlg').window('options')["title"];
		//alert($('#addEditDlg').window('options')["title"]);

		$('#addEditDlg').window({
			title: "编辑预算科室",
			iconCls: 'icon-w-edit'
		});

		$("#addEditDlg").css("display", "block");
		addEditDlgDlgObj.open();
	}

	function SetDefault(rowid) {
		CreateInit();
		var mianinfo = tkMakeServerCall("herp.budg.hisui.udata.uBudgDeptSet", "Select", rowid);
		var info = mianinfo.split("^");
		$("#Lcode").val(info[0]).validatebox("validate");
		$("#ldesc").val(info[1]).validatebox("validate");
		$("#spell").val(info[10]);
		$('#io').val(info[6]);
		if (info[7] == "1") {
			$('#ibudg').checkbox('setValue', true);
		} else {
			$('#ibudg').checkbox('setValue', false);
		}
		if (info[8] == "1") {
			$('#istate').checkbox('setValue', true);
		} else {
			$('#istate').checkbox('setValue', false);
		}
		if (info[9] == "1") {
			$('#iitm').checkbox('setValue', true);
		} else {
			$('#iitm').checkbox('setValue', false);
		}
		if (info[11] == "1") {
			$('#ilst').checkbox('setValue', true);
		} else {
			$('#ilst').checkbox('setValue', false);
		}
		$("#LHosp").combobox('setValue', info[12]);
		$("#cdr").combobox('setValue', info[2]);
		$("#Lname").combobox('setValue', info[3]);

	}

	//点击删除事件
	function delFn() {
		var SelectedNode = $('#budgLocTree').treegrid('getSelected');
		if (SelectedNode == null) {
			$.messager.popover({
				msg: '请选择所要删除的行！',
				timeout: 2000,
				type: 'alert',
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
					top: 0
				}
			});
			return;
		} else {
			$.messager.confirm('确定', '确认删除吗？', function (t) {
				if (t) {
					$.m({
						ClassName: "herp.budg.hisui.udata.uBudgDeptSet",
						MethodName: "Delete",
						rowid: SelectedNode.id
					},
						function (rtn) {
						$.messager.progress({
							title: '提示',
							msg: '正在删除，请稍候……'
						});
						if (rtn == 0) {
							$.messager.popover({
								msg: '删除成功！',
								type: 'success',
								style: {
									"position": "absolute",
									"z-index": "9999",
									left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
									top: 0
								}
							});
							$.messager.progress('close');
							var ParentNode = $('#budgLocTree').treegrid('getParent', SelectedNode.id);
							if (ParentNode) {
								$('#budgLocTree').treegrid('reload', ParentNode.id);
							} else {
								$('#budgLocTree').treegrid('reload', "");
							}
						} else {
							$.messager.popover({
								msg: '删除失败！' + rtn,
								type: 'error',
								style: {
									"position": "absolute",
									"z-index": "9999",
									left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
									top: 0
								}
							});
							$.messager.progress('close');
						}
					})
				}
			})
		}
	}
	//点击全部展开事件
	function expandAllFn() {
		isAll = true;
		var SelectedNode = $('#budgLocTree').treegrid('getSelected');
		$('#budgLocTree').treegrid('expandAll', SelectedNode.id);
	}

	//保存
	///n (rowId, CompName, code, name, class, directdr, Level, SupDeptID, IOFlag, IsBudg, State,
	///IsItem, Pym, IsLast)

	function AddClickHandler() {
		var SelectedNode = $('#budgLocTree').treegrid('getSelected');
		var data = "";
		var Level = 0;
		var SupDeptID = "";
		var rowId = "";
		var CompName = hospid;
		var classdr = $("#cdr").combobox('getValue');
		var directdr = $("#Lname").combobox('getValue');
		var code = $("#Lcode").val();
		if (code == '') {
			$.messager.popover({
				msg: '科室编码不能为空!',
				type: 'info',
				timeout: 2000,
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
					top: 10
				}
			});
			return;
		}

		var name = $("#ldesc").val();
		if (name == '') {
			$.messager.popover({
				msg: '科室名称不能为空!',
				type: 'info',
				timeout: 2000,
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
					top: 10
				}
			});
			return;
		}
		var Pym = $("#spell").val();
		var IOFlag = $("#io").val();
		var IsBudg = $("#ibudg").checkbox('getValue');
		var State = $("#istate").checkbox('getValue');
		var IsItem = $("#iitm").checkbox('getValue');
		var IsLast = $("#ilst").checkbox('getValue');
		if (IsBudg == true) {
			IsBudg = 1
		} else {
			IsBudg = 0
		}
		if (IsItem == true) {
			IsItem = 1
		} else {
			IsItem = 0
		}
		if (State == true) {
			State = 1
		} else {
			State = 0
		}
		if (IsLast == true) {
			IsLast = 1
		} else {
			IsLast = 0
		}
		if (flag == 1) {
			//新增模式

			if (SelectedNode == null) {
				Level = 1;
			} else {
				SupDeptID = SelectedNode.id;
				Level = parseInt(SelectedNode.level) + 1;

			}
		} else {
			//修改模式
			rowId = SelectedNode.id;
			SupDeptID = SelectedNode._parentId;
			Level = SelectedNode.level;
		}
		$.m({
			ClassName: "herp.budg.hisui.udata.uBudgDeptSet",
			MethodName: "Save",
			rowId: rowId,
			code: code,
			name: name,
			CompName: CompName,
			classdr: classdr,
			Level: Level,
			directdr: directdr,
			SupDeptID: SupDeptID,
			IOFlag: IOFlag,
			IsBudg: IsBudg,
			State: State,
			IsItem: IsItem,
			Pym: Pym,
			IsLast: IsLast,
			hospid: hospid

		}, function (rtn) {
			if (rtn == 0) {
				$.messager.popover({
					msg: '保存成功！',
					type: 'success',
					timeout: 1000
				});
				if (SelectedNode) {
					if (flag == 1) {
						$('#budgLocTree').treegrid('reload', SelectedNode.id);
					} else {
						var ParentNode = $('#budgLocTree').treegrid('getParent', SelectedNode.id);
						if (ParentNode) {
							$('#budgLocTree').treegrid('reload', ParentNode.id);
						} else {
							$('#budgLocTree').treegrid('reload', "");
						}
						addEditDlgDlgObj.close();
					}

				} else {
					$('#budgLocTree').treegrid('reload', "");
					addEditDlgDlgObj.close();
				}
				addEditDlgDlgObj = "";
				//DFindBtn();

			} else {
				$.messager.popover({
					msg: '保存失败：' + rtn,
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
	//创建combox
	function CreateInit() {

		$('#LHosp').combobox({
			valueField: 'rowid',
			textField: 'name',
			url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Hospital&ResultSetType=array',
			mode: 'remote',
			required: true,
			onBeforeLoad: function (param) {
				param.userdr = userid;
				param.rowid = hospid;
				param.str = param.q;
			}

		});

		$('#cdr').combobox({
			valueField: 'rowid',
			textField: 'name',
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=deptType",
			delay: 200,
			onBeforeLoad: function (param) {
				param.hospid = "";
				param.userdr = userid;
				param.str = param.q;
			}
		});
		$('#Lname').combobox({
			valueField: 'rowid',
			textField: 'name',
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
			delay: 200,
			onBeforeLoad: function (param) {
				param.str = param.q;
				param.hospid = hospid;
				param.userdr = '';
				param.flag = '1';
				param.checkflag = '';
			}
		});

	}
}
