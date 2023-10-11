/*
Creator: Liu XiaoMing
CreatDate: 2018-03-29
Description: 全面预算管理-基本信息维护-预算科目
CSPName: herp.budg.hisui.budgitemdict.csp
ClassName: herp.budg.hisui.udata.uBudgItemDict
、herp.budg.udata.uBudgItemDict
 */

var hospid = session['LOGON.HOSPID'];
var userid = session['LOGON.USERID'];
var groupid = session['LOGON.GROUPID'];

var addEditDlgDlgObj = ''; //用于判断添加/修改对话框是否已创建
var isAll = false; //管控是否展开所选节点所有子节点
var flag = ''; //新增还是修改判断标志
var copyDlgDlgObj = ''; //复制面板对象
var rootData = new Array();
var allData = new Array();
var newData = new Array();

var filter = '';

//文档就绪事件
$(function () {
	$("#CodeName").val('');
	Init();
});

function Init() {

	var yearCmb = $HUI.combobox('#YearBox', {
			placeholder: '必选',
			required: true,
			valueField: 'year',
			textField: 'year',
			url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon&ResultSetType=array',
			mode: 'remote',
			onBeforeLoad: function (param) {
				param.flag = '';
				param.str = param.q;
			},
			onSelect: function (record) {
				$('#budgItemTree').treegrid('load', {
					ClassName: 'herp.budg.hisui.udata.uBudgItemDict',
					MethodName: 'List',
					userid: userid,
					hospid: hospid,
					groupid: groupid,
					id:'',
					year: $("#YearBox").combobox('getValue'),
					name: $("#CodeName").val()
				});

			}
		});


	//查询方法
	$("#findBtn").click(function () {
		//获取年度
		var year = $("#YearBox").combobox('getValue');
		if (!year) {
			$.messager.popover({
				msg: '请先选择年度!',
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
		//过滤查询
		if (year != '') {
			$('#budgItemTree').treegrid('load', {
				ClassName: 'herp.budg.hisui.udata.uBudgItemDict',
				MethodName: 'List',
				userid: userid,
				hospid: hospid,
				groupid: groupid,
				id:'',
				year: $("#YearBox").combobox('getValue'),
				name: $("#CodeName").val()
			});
		}
	});

	//定义树形表格
	var budgItemTreeObj = $HUI.treegrid('#budgItemTree', {
			fit: true,
			lines: true,
			border: false,
			idField: 'id',
			treeField: 'name',
			rownumbers: true,
			url: $URL,
			queryParams: {
				ClassName: 'herp.budg.hisui.udata.uBudgItemDict',
				MethodName: 'List',
				userid: userid,
				hospid: hospid,
				groupid: groupid,
				id:'',
				year: $("#YearBox").combobox('getValue'),
				name: $("#CodeName").val()
			},
			onClickRow: function (row) {
				isAll = false;
				if ((row) && ($('#budgItemTree').treegrid('getSelected').state == 'closed')) {
					$('#budgItemTree').treegrid('expand', $('#budgItemTree').treegrid('getSelected').id)
				} else {
					$('#budgItemTree').treegrid('collapse', $('#budgItemTree').treegrid('getSelected').id)
				}
				return true;
			},
			/*onLoadSuccess: function (row, data) {
				if (row && isAll) {
					var data = $('#budgItemTree').treegrid('getChildren', row.id);
					for (i = 0; i < data.length; i++) {
						if (data[i].state == 'closed') {
							$('#budgItemTree').treegrid('expandAll', data[i].id);
						}
					}
				} else if (bFound && $('#budgItemTree').treegrid('getRoot') != null) {
					//alert("您好1");
					isAll = true;
					bFound = false;
					var SelectedNode = $('#budgItemTree').treegrid('getRoot');
					$('#budgItemTree').treegrid('expandAll', SelectedNode.id);
				} else {
					return;
				}
			},*/
			frozenColumns: [[{
						title: '项目ID',
						field: 'id',
						hidden: 'true'
					}, {
						title: '年度',
						field: 'year',
						width: '80'
					}, {
						title: '医疗单位ID',
						field: 'compId',
						hidden: 'true'
					}, {
						title: '医疗单位名称',
						field: 'compNa',
						width: '200',
						hidden: 'true'
					}, {
						title: '项目编码',
						field: 'code',
						width: '120'
					}, {
						title: '项目名称',
						field: 'name',
						width: '200'
					}
				]],
			columns: [[{
						title: '归口科室一',
						field: 'AuDepdrOneNa',
						width: '100'
					}, /*{
						title: '归口科室二',
						field: 'AuDepdrTwoNa',
						width: '100'
					},*/ {
						title: '是否政府采购',
						field: 'IsGovBuyNa',
						width: '100'
					}, {
						title: '预算上限',
						field: 'UpperLimitBgVal',
						width: '100',
						halign: 'right',
						align: 'right'
					}, {
						title: '层级',
						field: 'level',
						width: '50'
					}, {
						title: '类别编码',
						field: 'typeCode',
						width: '100',
						hidden: 'true'
					}, {
						title: '类别名称',
						field: 'typeName',
						width: '100'
					}, {
						title: '是否计算键',
						field: 'isCalc',
						width: '100',
						hidden: 'true'
					}, {
						title: '是否计算',
						field: 'isCalcNa',
						width: '100'
					}, {
						title: '公式描述',
						field: 'formulaDesc',
						width: '300'
					}, {
						title: '计量单位ID',
						field: 'calUnitDR',
						width: '150',
						hidden: 'true'
					}, {
						title: '计量单位名称',
						field: 'calUnitNa',
						width: '150'
					}, {
						title: '是否末级键',
						field: 'isLast',
						width: '100',
						hidden: 'true'
					}, {
						title: '是否末级',
						field: 'isLastNa',
						width: '100'
					}, {
						title: '上级科目编码',
						field: '_parentId',
						width: '100',
						hidden: 'true'
					}

				]],
			toolbar: [{
					id: 'AddBn',
					iconCls: 'icon-add',
					text: '新增',
					handler: function (hospid) {
						addFn()
					}
				}, {
					id: 'SaveBn',
					iconCls: 'icon-write-order',
					text: '修改',
					handler: function (hospid) {
						editFn()
					}
				}, {
					id: 'StopBn',
					iconCls: 'icon-stop-order',
					text: '停用',
					handler: function (hospid) {
						stopFn()
					}
				}, {
					id: 'DelBn',
					iconCls: 'icon-cancel',
					text: '删除',
					handler: function (hospid) {
						delFn()
					}
				}, {
					id: 'ExpandAllBn',
					iconCls: 'icon-paper-arrow-down',
					text: '全部展开',
					handler: function (hospid) {
						expandAllFn()
					}
				}, {
					id: 'CollapseAllBn',
					iconCls: 'icon-arrow-up',
					text: '全部折叠',
					handler: function (hospid) {
						collapseAllFn()
					}
				}, {
					id: 'CopyBn',
					iconCls: 'icon-copy',
					text: '复制',
					handler: function (hospid) {
						copyFn()
					}
				}, {
					id: 'ImportBtn',
					iconCls: 'icon-import-xls',
					text: 'Excel导入',
					handler: function () {
						addimportFun();
					}
				}
			]
		});

	//初始化新增弹出面板下拉框
	//预算年度
	var YearCmb = $HUI.combobox('#Year', {
			required: true,
			valueField: 'year',
			textField: 'year',
			url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon&ResultSetType=array',
			mode: 'remote',
			onBeforeLoad: function (param) {
				param.flag = '';
				param.str = param.q;
			}
		});

	//项目名称监听事件
	$('#Name').keyup(function (event) {
		$('#Spell').val(makePy($('#Name').val().trim())).validatebox("validate");
	});

	//适用范围
	var UseRangeCmb = $HUI.combobox('#UseRange', {
			required: true,
			valueField: 'id',
			textField: 'text',
			data: [{
					id: '1',
					text: '收支预算'
				}, {
					id: '2',
					text: '指标预算'
				}, {
					id: '3',
					text: '项目预算'
				}, {
					id: '4',
					text: '采购预算'
				}
			],
			onSelect: function (record) {
				if (record.id == 3) {
					ProjDuTYDCmb.enable();
				} else {
					ProjDuTYDCmb.setValue('');
					ProjDuTYDCmb.disable();
				}
			}
		});

	//成本类型
	var SubjClassCostTypeCmb = $HUI.combobox('#SubjClassCostType', {
			valueField: 'id',
			textField: 'text',
			data: [{
					id: '1',
					text: '固定成本'
				}, {
					id: '2',
					text: '变动成本'
				}
			]
		});

	//归口科室一
	var AuDepdrOneCmb = $HUI.combobox('#AuDepdrOne', {
			valueField: 'rowid',
			textField: 'name',
			url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept&ResultSetType=array',
			mode: 'remote',
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.userdr = userid;
				param.flag = '8';
				param.str = param.q;
			}
			/*
			onLoadSuccess: function (data) {
			var val = $(this).combobox("getData");
			for (var item in val[0]) {
			if (item == "rowid") {
			$(this).combobox("select", val[0][item]);
			}
			}
			}*/
		});

	//归口科室二隐藏
	var AuDepdrTwoCmb = $HUI.combobox('#AuDepdrTwo', {
			valueField: 'rowid',
			textField: 'name',
			url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept&ResultSetType=array',
			mode: 'remote',
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.userdr = userid;
				param.flag = '8';
				param.str = param.q;
			}
	});		
	
	$('#AuDepdrTwo').next(".combo").hide();/*
			onLoadSuccess: function (data) {
			var val = $(this).combobox("getData");
			for (var item in val[0]) {
			if (item == "rowid") {
			$(this).combobox("select", val[0][item]);
			}
			}
			}*/
		

	//政府采购
	var IsGovBuyCmb = $HUI.combobox('#IsGovBuy', {
			valueField: 'id',
			textField: 'text',
			data: [{
					id: '0',
					text: '否'
				}, {
					id: '1',
					text: '是'
				}
			]
		});

	//项目类别
	var TypeCodeCmb = $HUI.combobox('#TypeCode', {
			required: true,
			valueField: 'code',
			textField: 'name',
			url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemType&ResultSetType=array',
			mode: 'remote',
			onBeforeLoad: function (param) {
				param.flag = '1';
				param.str = param.q;
			},
			onLoadSuccess: function (data) {
				var val = $(this).combobox("getData");
				for (var item in val[0]) {
					if (item == "code") {
						$(this).combobox("select", val[0][item]);
					}
				}
			}
		});

	//编制模式
	var EditModCmb = $HUI.combobox('#EditMod', {
			required: true,
			valueField: 'id',
			textField: 'text',
			data: [{
					id: '1',
					text: '自上而下'
				}, {
					id: '2',
					text: '自下而上'
				}, {
					id: '3',
					text: '上下结合'
				}
			]
		});

	//编制方式
	var EditMethCmb = $HUI.combobox('#EditMeth', {
			required: true,
			valueField: 'id',
			textField: 'text',
			data: [{
					id: '1',
					text: '零基预算'
				}, {
					id: '2',
					text: '弹性预算'
				}, {
					id: '3',
					text: '固定预算'
				}
			]
		});

	//计量单位
	var CalUnitDRCmb = $HUI.combobox('#CalUnitDR', {
			required: true,
			valueField: 'rowid',
			textField: 'name',
			url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=CalUnit&ResultSetType=array',
			mode: 'remote',
			onBeforeLoad: function (param) {
				param.str = param.q;
			},
			onLoadSuccess: function (data) {
				var val = $(this).combobox("getData");
				for (var item in val[0]) {
					if (item == "rowid") {
						$(this).combobox("select", val[0][item]);
					}
				}
			}
		});

	//责任科室
	var ProjDuTYDCmb = $HUI.combobox('#ProjDuTYD', {
			disabled: true,
			valueField: 'rowid',
			textField: 'name',
			url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept&ResultSetType=array',
			mode: 'remote',
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.userdr = userid;
				param.flag = '3';
				param.str = param.q;
			}
		});

	//指标类型
	var IdxTypeCmb = $HUI.combobox('#IdxType', {
			valueField: 'id',
			textField: 'text',
			data: [{
					id: '1',
					text: '指令性指标'
				}, {
					id: '2',
					text: '指导指标'
				}, {
					id: '3',
					text: '政策性指标'
				}, {
					id: '4',
					text: '一般'
				}, {
					id: '5',
					text: '工作量指标'
				}, {
					id: '6',
					text: '社会效益指标'
				}, {
					id: '7',
					text: '经济效益指标'
				}
			]
		});

	//数据类型
	var ProperyTypeCmb = $HUI.combobox('#ProperyType', {
			valueField: 'id',
			textField: 'text',
			data: [{
					id: '1',
					text: '状态值'
				}, {
					id: '2',
					text: '可累加'
				}
			]
		});

	//借贷方向
	var DirectionCmb = $HUI.combobox('#Direction', {
			valueField: 'id',
			textField: 'text',
			data: [{
					id: '0',
					text: '借方'
				}, {
					id: '1',
					text: '贷方'
				}
			]
		});

	//大类
	var TypeCodeFirstCmb = $HUI.combobox('#TypeCodeFirst', {
			valueField: 'id',
			textField: 'text',
			data: [{
					id: '1',
					text: '会计科目'
				}, {
					id: '2',
					text: '医疗指标'
				}
			]
		});

	//医药科目类
	var SubjClassMTCmb = $HUI.combobox('#SubjClassMT', {
			valueField: 'id',
			textField: 'text',
			data: [{
					id: '1',
					text: '药品'
				}, {
					id: '2',
					text: '医疗'
				}
			]
		});

	//支出科目类
	var SubjClassPayCmb = $HUI.combobox('#SubjClassPay', {
			valueField: 'id',
			textField: 'text',
			data: [{
					id: '1',
					text: '人员'
				}, {
					id: '2',
					text: '材料'
				}, {
					id: '3',
					text: '净药品'
				}, {
					id: '4',
					text: '设备'
				}, {
					id: '5',
					text: '后勤'
				}, {
					id: '6',
					text: '其他'
				}
			]
		});

	//保存前信息验证
	function CheckBeforeSave() {
		if (!hospid) {
			$.messager.popover({
				msg: '医疗单位不能为空!',
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

			return false;
		}
		var Year = $("#Year").combobox('getValue');
		if (!Year) {
			$.messager.popover({
				msg: '年度不能为空！',
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
			return false;
		}

		var Name = $("#Name").val();
		if (!Name) {
			$.messager.popover({
				msg: '项目名称不能为空！',
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
			return false;
		}

		var Code = $("#Code").val();
		if (!Code) {
			$.messager.popover({
				msg: '项目编码不能为空！',
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
			return false;
		}

		var Spell = $("#Spell").val();
		if (!Spell) {
			$.messager.popover({
				msg: '拼音码不能为空！',
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
			return false;
		}

		var TypeCode = $("#TypeCode").combobox('getValue');
		if (!TypeCode) {
			$.messager.popover({
				msg: '项目类别不能为空！',
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
			return false;
		}

		var EditMod = $("#EditMod").combobox('getValue');
		if (!EditMod) {
			$.messager.popover({
				msg: '编制模式不能为空！',
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
			return false;
		}

		var EditMeth = $("#EditMeth").combobox('getValue');
		if (!EditMeth) {
			$.messager.popover({
				msg: '编制方法不能为空！',
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
			return false;
		}

		var CalUnitDR = $("#CalUnitDR").combobox('getValue');
		if (!CalUnitDR) {
			$.messager.popover({
				msg: '计量单位不能为空！',
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
			return false;
		}

		var UseRange = $("#UseRange").combobox('getValue');
		var ProjDuTYD = $("#ProjDuTYD").combobox('getValue');
		if (TypeCode == '3' && !ProjDuTYD) {
			$.messager.popover({
				msg: '适用范围为"项目预算"时，责任科室不能为空！',
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
			return false;
		}

		return true;
	}

	//保存
	function AddClickHandler() {

		if (!CheckBeforeSave())
			return;
		var rowid = '';
		var SuperCode = '';
		var Level = '';
		var SelectedNode = $('#budgItemTree').treegrid('getSelected');

		if (flag == 1) {
			//新增模式
			if (SelectedNode == null) {
				SuperCode = '';
				Level = 1;
			} else {
				SuperCode = SelectedNode.code;
				Level = parseInt(SelectedNode.level) + 1;
			}
		} else {
			//修改模式
			rowid = SelectedNode.id;
			SuperCode = SelectedNode.superCode;
			if (SuperCode == undefined || SuperCode == null) {
				SuperCode = '';
			}
			Level = SelectedNode.level;
		}

		var IsCarry = $("#IsCarry").checkbox('getValue') ? 1 : 0; //结转复选框
		var IsCash = $("#IsCash").checkbox('getValue') ? 1 : 0; //现金标志复选框
		var IsLast = $("#IsLast").checkbox('getValue') ? 1 : 0; //末级复选框
		var IsSpecial = $("#IsSpecial").checkbox('getValue') ? 1 : 0; //专项标记复选框
		var IsResult = $("#IsResult").checkbox('getValue') ? 1 : 0; //最终预算项复选框
		var IsCalc = $("#IsCalc").checkbox('getValue') ? 1 : 0; //是否计算复选框
		var Formula = ''; //$("#Formula").val(); //公式代码
		var data = '';
		data = rowid
			 + '|' + hospid
			 + '|' + $("#Year").combobox('getValue')
			 + '|' + $("#Code").val()
			 + '|' + SuperCode
			 + '|' + $("#Name").val()
			 + '|' + $("#AllName").val()
			 + '|' + Level
			 + '|' + $("#TypeCodeFirst").combobox('getValue')
			 + '|' + $("#TypeCode").combobox('getValue')
			 + '|' + $("#Spell").val()
			 + '|' + $("#Direction").combobox('getValue')
			 + '|' + IsLast
			 + '|' + IsSpecial
			 + '|' + $("#SubjClassMT").combobox('getValue')
			 + '|' + $("#SubjClassPay").combobox('getValue')
			 + '|' + IsCash
			 + '|' + $("#SubjClassCostType").combobox('getValue')
			 + '|' + $("#UseRange").combobox('getValue')
			 + '|' + $("#IdxType").combobox('getValue')
			 + '|' + $("#EditMod").combobox('getValue')
			 + '|' + $("#EditMeth").combobox('getValue')
			 + '|' + IsCarry
			 + '|' + $("#ProperyType").combobox('getValue')
			 + '|' + IsCalc
			 + '|' + Formula
			 + '|' + $("#FormulaDesc").val()
			 + '|' + IsResult
			 + '|' + $("#CalUnitDR").combobox('getValue')
			 + '|' + $("#ProjDuTYD").combobox('getValue')
			 + '|' + $("#AuDepdrOne").combobox('getValue')
			 + '|' + $("#AuDepdrTwo").combobox('getValue')
			 + '|' + $("#IsGovBuy").combobox('getValue')
			 + '|' + $("#UppLimitBgVal").val();
		//alert(data);
		$.m({
			ClassName: "herp.budg.hisui.udata.uBudgItemDict",
			MethodName: "Save",
			data: data
		}, function (rtn) {
			if (rtn == 0) {
				if (flag == 1) {
					//新增模式-刷新选中的节点
					if (SelectedNode == null) {
						$('#budgItemTree').treegrid('reload');
					} else {
						$('#budgItemTree').treegrid('reload', SelectedNode.id);
					}
				} else {
					//修改模式-刷新选中的节点的父节点
					var ParentNode = $('#budgItemTree').treegrid('getParent', SelectedNode.id);
					if (ParentNode == null) {
						$('#budgItemTree').treegrid('reload');
					} else {
						$('#budgItemTree').treegrid('reload', ParentNode.id);
					}
					$('#addEditDlg').window('close');
				}
				$.messager.popover({
					msg: '保存成功',
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

	//清屏
	function Clear_Mes() {
		$("#Code").val('');
		$("#Name").val('');
		$("#AllName").val('');
		$("#Spell").val('');
		$("#FormulaDesc").val('');
		$("#UppLimitBgVal").val('');
		$("#Formula").val('');

		$("#IsCarry").checkbox('setValue', false);
		$("#IsCash").checkbox('setValue', false);
		$("#IsLast").checkbox('setValue', false);
		$("#IsSpecial").checkbox('setValue', false);
		$("#IsResult").checkbox('setValue', false);
		$("#IsCalc").checkbox('setValue', false);

	}

	//清屏
	function ClearClickHandler() {
		Clear_Mes();
	}

	//关闭
	function CloseClickHandler() {
		$('#addEditDlg').window('close');
	}

	//点击添加事件
	function addFn() {
		flag = 1; //表示新增
		//判断是否添加顶级科目
		var tempIsLast = '';
		var SelectedNode = $('#budgItemTree').treegrid('getSelected');
		if (SelectedNode == null) {
			tempIsLast = 0;
		} else {
			$("#Year").combobox('setValue', SelectedNode.year);
			tempIsLast = SelectedNode.isLast;
		}

		if (tempIsLast == 1) {
			$.messager.popover({
				msg: '不允许给末级节点添加子节点！',
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
		} else {
			$('#Name').val('').validatebox("validate");
			$('#Code').val('').validatebox("validate");
			$('#Spell').val('').validatebox("validate");

			//判断对话框是否已创建
			if (addEditDlgDlgObj == '') {
				//新增时，适用范围默认1，归口科室一、二默认1，政府采购，编制方式默认1，编制模式默认3，指标类型默认1，数据类型，方向，计量单位默认1，大类默认1，支出科目类默认1
				$("#UseRange").combobox('setValue', '1');

				$("#IsGovBuy").combobox('setValue', '0');
				$("#EditMod").combobox('setValue', '3');
				$("#EditMeth").combobox('setValue', '1');
				$("#IdxType").combobox('setValue', '1');
				$("#ProperyType").combobox('setValue', '1');
				$("#Direction").combobox('setValue', '0');

				$("#TypeCodeFirst").combobox('setValue', '1');
				$("#SubjClassMT").combobox('setValue', '1');
				$("#SubjClassPay").combobox('setValue', '1');

				$('#Save').click(
					function () {
					$.messager.confirm("保存", "确定保存?", function (r) {
						if (r) {
							AddClickHandler();
						} else {
							return;
						}
					});
				}); //注册新增方法
				$('#Clear').click(ClearClickHandler);
				$('#Close').click(CloseClickHandler);
				$("#addEditDlg").show();
				addEditDlgDlgObj = $HUI.dialog("#addEditDlg", {});
				$('#addEditDlg').window({
					title: "新增预算项目",
					iconCls: 'icon-w-new'
				});

				// 表单的垂直居中
				xycenter($("#addEditDlg"), $("#Addform"));

			} else {
				$('#addEditDlg').window({
					title: "新增预算项目",
					iconCls: 'icon-w-new'
				});
				addEditDlgDlgObj.open();
			}
			ClearClickHandler();
		}

	}

	//点击修改事件
	function editFn() {
		flag = 0; //表示修改
		var SelectedNode = $('#budgItemTree').treegrid('getSelected');
		if (SelectedNode == null) {
			$.messager.popover({
				msg: '请选择要修改的项目！',
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
		} else {
			Clear_Mes();
			var Str = tkMakeServerCall("herp.budg.hisui.udata.uBudgItemDict", "getRecAllInfo", SelectedNode.id);
			//alert(Str);

			//进入界面初始信息
			//$("#Hosp").combobox('setValue', mPiece(Str, "^", 0));
			$("#Year").combobox('setValue', mPiece(Str, "^", 1));
			$("#Code").val(mPiece(Str, "^", 2)).validatebox("validate");
			$("#Name").val(mPiece(Str, "^", 3)).validatebox("validate");
			$("#AllName").val(mPiece(Str, "^", 4));
			$("#Spell").val(mPiece(Str, "^", 5)).validatebox("validate");
			$("#IsCarry").checkbox('setValue', (mPiece(Str, "^", 6) == 1 ? true : false));
			$("#IsCash").checkbox('setValue', (mPiece(Str, "^", 7) == 1 ? true : false));
			$("#IsLast").checkbox('setValue', (mPiece(Str, "^", 8) == 1 ? true : false));
			$("#IsSpecial").checkbox('setValue', (mPiece(Str, "^", 9) == 1 ? true : false));
			$("#IsResult").checkbox('setValue', (mPiece(Str, "^", 10) == 1 ? true : false));
			$("#IsCalc").checkbox('setValue', (mPiece(Str, "^", 11) == 1 ? true : false));
			//$("#Formula").val(mPiece(Str,"^",12));
			$("#FormulaDesc").val(mPiece(Str, "^", 13));
			$("#TypeCode").combobox('setValue', mPiece(Str, "^", 14));
			$("#Direction").combobox('setValue', mPiece(Str, "^", 15));
			$("#TypeCodeFirst").combobox('setValue', mPiece(Str, "^", 16));
			$("#SubjClassMT").combobox('setValue', mPiece(Str, "^", 17));
			$("#SubjClassPay").combobox('setValue', mPiece(Str, "^", 18));
			$("#SubjClassCostType").combobox('setValue', mPiece(Str, "^", 19));
			$("#UseRange").combobox('setValue', mPiece(Str, "^", 20));
			$("#IdxType").combobox('setValue', mPiece(Str, "^", 21));
			$("#EditMod").combobox('setValue', mPiece(Str, "^", 22));
			$("#EditMeth").combobox('setValue', mPiece(Str, "^", 23));
			$("#ProperyType").combobox('setValue', mPiece(Str, "^", 24));
			$("#CalUnitDR").combobox('setValue', mPiece(Str, "^", 25));
			$("#ProjDuTYD").combobox('setValue', mPiece(Str, "^", 26));

			$("#AuDepdrOne").combobox('setValue', mPiece(Str, "^", 27));
			$("#AuDepdrTwo").combobox('setValue', mPiece(Str, "^", 28));
			$("#IsGovBuy").combobox('setValue', mPiece(Str, "^", 29));
			$("#UppLimitBgVal").val(mPiece(Str, "^", 30));

			//判断对话框是否已创建
			if (addEditDlgDlgObj == '') {
				$('#Save').click(
					function () {
					$.messager.confirm("保存", "确定保存?", function (r) {
						if (r) {
							AddClickHandler();
						} else {
							return;
						}
					});
				}); //注册修改方法
				$('#Clear').click(ClearClickHandler);
				$('#Close').click(CloseClickHandler);
				$("#addEditDlg").show();
				addEditDlgDlgObj = $HUI.dialog("#addEditDlg", {});

				$('#addEditDlg').window({
					title: "修改预算项目",
					iconCls: 'icon-w-edit'
				});
			} else {
				$('#addEditDlg').window({
					title: "修改预算项目",
					iconCls: 'icon-w-edit'
				});

				addEditDlgDlgObj.open();
			}

		}

	}

	//点击停用
	function stopFn() {
		$.messager.confirm("停用", "确定停用?", function (r) {
			if (r) {
				var SelectedNode = $('#budgItemTree').treegrid('getSelected');
				if (SelectedNode == null) {
					$.messager.popover({
						msg: '请选择要停用的项目！',
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
				} else {
					$.m({
						ClassName: "herp.budg.hisui.udata.uBudgItemDict",
						MethodName: "Stop",
						rowid: SelectedNode.id
					}, function (rtn) {
						if (rtn == 0) {
							var ParentNode = $('#budgItemTree').treegrid('getParent', SelectedNode.id);
							if (ParentNode == null) {
								$('#budgItemTree').treegrid('reload');
							} else {
								$('#budgItemTree').treegrid('reload', ParentNode.id);
							}
							$.messager.popover({
								msg: '停用成功！',
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
								msg: '停用失败：' + rtn,
								timeout: 2000,
								showType: 'show',
								style: {
									"position": "absolute",
									"z-index": "9999",
									left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
									top: 10
								}
							});
						};
					})
				}
			} else {
				return;
			}
		});
	}

	//点击删除事件
	function delFn() {
		$.messager.confirm("删除", "确定删除?", function (r) {
			if (r) {
				var SelectedNode = $('#budgItemTree').treegrid('getSelected');
				if (SelectedNode == null) {
					$.messager.popover({
						msg: '请选择要删除的项目！',
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
				} else {
					$.m({
						ClassName: "herp.budg.hisui.udata.uBudgItemDict",
						MethodName: "Delete",
						rowid: SelectedNode.id
					}, function (rtn) {
						if (rtn == 0) {
							var ParentNode = $('#budgItemTree').treegrid('getParent', SelectedNode.id);
							if (ParentNode == null) {
								$('#budgItemTree').treegrid('reload');
							} else {
								$('#budgItemTree').treegrid('reload', ParentNode.id);
							}
							$.messager.popover({
								msg: '删除成功！',
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
								msg: '删除失败：' + rtn,
								timeout: 2000,
								showType: 'show',
								style: {
									"position": "absolute",
									"z-index": "9999",
									left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //顶端中间显示
									top: 10
								}
							});
						};
					})
				}
			} else {
				return;
			}
		});

	}

	//点击全部展开
	function expandAllFn() {
		isAll = true;
		var SelectedNode = $('#budgItemTree').treegrid('getSelected');
		$('#budgItemTree').treegrid('expandAll', SelectedNode.id);
	}

	//点击全部折叠
	function collapseAllFn() {
		var SelectedNode = $('#budgItemTree').treegrid('getSelected');
		$('#budgItemTree').treegrid('collapseAll', SelectedNode.id);
	}

	//点击复制事件
	function copyFn() {
		/*
		//医疗单位
		var CopyHospCmb=$HUI.combobox('#CopyHosp',{
		required: true,
		valueField: 'rowid',
		textField: 'name',
		url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Hospital&ResultSetType=array',
		mode: 'remote',
		onBeforeLoad: function (param) {
		param.userdr = userid;
		param.rowid = hospid;
		param.str = param.q;
		}

		});
		 */

		//历史年度
		var PastYearCmb = $HUI.combobox('#PastYear', {
				required: true,
				valueField: 'year',
				textField: 'year',
				url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon&ResultSetType=array',
				mode: 'remote',
				onBeforeLoad: function (param) {
					param.flag = '';
					param.str = param.q;
				}
			});

		//预算年度
		var BudgYearCmb = $HUI.combobox('#BudgYear', {
				required: true,
				valueField: 'year',
				textField: 'year',
				url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon&ResultSetType=array',
				mode: 'remote',
				onBeforeLoad: function (param) {
					param.flag = '';
					param.str = param.q;
				}
			});

		//项目类别
		var TyCodeCmb = $HUI.combobox('#TyCode', {
				valueField: 'code',
				textField: 'name',
				url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemType&ResultSetType=array',
				mode: 'remote',
				onBeforeLoad: function (param) {
					param.flag = '1';
					param.str = param.q;
				}
			});

		//取消方法
		function CancelClickHandler() {
			copyDlgDlgObj.close();
		}

		//判断对话框是否已创建
		if (copyDlgDlgObj == '') {

			$('#Copy').click(function () {
				//var Hospid = $("#CopyHosp").combobox('getValue');
				if (!hospid) {
					$.messager.popover({
						msg: '医疗单位不能为空！',
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
					return false;
				}
				var PastYear = $("#PastYear").combobox('getValue');
				if (!PastYear) {
					$.messager.popover({
						msg: '历史年度不能为空！',
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
					return false;
				}
				var BudgYear = $("#BudgYear").combobox('getValue');
				if (!BudgYear) {
					$.messager.popover({
						msg: '预算年度不能为空！',
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
					return false;
				}

				$.messager.confirm("复制", "确定复制?", function (r) {
					if (r) {
						$.m({
							ClassName: "herp.budg.udata.uBudgItemDict",
							MethodName: "CopyInsert",
							hospid: hospid,
							year: PastYear,
							year2: BudgYear,
							type: $("#TyCode").combobox('getValue')

						}, function (rtn) {
							if (rtn == 0) {
								$('#budgItemTree').treegrid('reload');
								$.messager.popover({
									msg: '复制成功',
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
									msg: '复制失败:' + rtn,
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
							};
						});
					} else {
						return;
					}
				});
			});
			$('#Cancel').click(CancelClickHandler);
			$("#copyDlg").show();
			copyDlgDlgObj = $HUI.dialog("#copyDlg", {});
			// 表单的垂直居中
			xycenter($("#copyDlg"), $("#copyform"));
		} else {
			copyDlgDlgObj.open();
		}
	}

}
