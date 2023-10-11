/*
Creator: Liu XiaoMing
CreatDate: 2018-09-16
Description: 全面预算管理-预算编制管理-归口科室年度预算审核
CSPName: herp.budg.hisui.budgschemowndept.csp
ClassName: herp.budg.hisui.udata.uBudgSchemOwnDept
 */
 
//全局变量用于checkbox状态变化
var isLast = 1;

//年度选择事件
var YearSelect = function () {
	$('#schemcb').combobox('clear');
	$('#schemcb').combobox('reload', $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=BudgSchem&ResultSetType=array');
	Search();
}

//方案下拉框初始化
function schemBefLoad(param) {
	param.str = param.q;
	param.hospid = hospid;
	param.userdr = userid;
	param.flag = 2;
	param.year = $('#yearcb').combobox('getValue');
}

//科室下拉框初始化
function deptBefLoad(param) {
	param.str = param.q;
	param.hospid = hospid;
	param.userdr = userid;
	param.flag = 1;
	param.year = $('#yearcb').combobox('getValue');
	param.audept = '';
	param.schemedr = '';
}


MainColumns = [[{
			field: 'Rowid',
			title: '方案归口ID',
			//halign: 'center',
			width: 120,
			hidden: true
		}, {
			field: 'CompName',
			title: '医疗单位',
			//halign: 'center',
			width: 200,
			hidden: true
		}, {
			field: 'Year',
			title: '年度',
			//halign: 'center',
			width: 80,
			hidden: true
		}, {
			field: 'SchemId',
			title: '方案ID',
			//halign: 'center',
			width: 100,
			hidden: true
		}, {
			field: 'Code',
			title: '方案编号',
			halign: 'center',
			width: 100
		}, {
			field: 'Name',
			title: '方案名称',
			//halign: 'center',
			width: 150
		}, {
			field: 'ObjDeptId',
			title: '方案适用科室ID',
			halign: 'center',
			width: 120,
			hidden: true
		}, {
			field: 'ObjDeptNa',
			title: '方案适用科室',
			//halign: 'center',
			width: 120
		}, {
			field: 'OrderBy',
			title: '编制顺序',
			halign: 'center',
			width: 80,
			hidden: true
		}, {
			field: 'ItemName',
			title: '结果预算项',
			//halign: 'center',
			width: 100
		}, {
			field: 'IsHelpEdit',
			title: '是否代编',
			halign: 'center',
			align: 'center',
			width: 80,
			formatter: isChecked
		}, {
			field: 'CHKFlowDR',
			title: '关联审批流ID',
			halign: 'center',
			width: 120,
			hidden: true
		}, {
			field: 'ChkFlowName',
			title: '关联审批流',
			//halign: 'center',
			width: 120
		}, {
			field: 'File',
			title: '附件',
			halign: 'center',
			width: 50
		}, {
			field: 'ChkStep',
			title: '编制步骤',
			//halign: 'center',
			align: 'center',
			width: 80,
			hidden: true
		}, {
			field: 'StateDesc',
			title: '编制状态',
			halign: 'center',
			width: 80,
			align: 'center',
			hidden: true
		}, {
			field: 'IsTwoUpDown',
			title: '两上两下模式',
			//halign: 'center',
			align: 'center',
			width: 100,
			formatter: comboboxFormatter,
			editor: {
				type: 'combobox',
				options: {
					valueField: 'rowid',
					textField: 'name',
					data: [{
							rowid: '1',
							name: '是'
						}, {
							rowid: '0',
							name: '否'
						}
					]
				}
			}
		}, {
			field: 'IsEconItem',
			title: '经济科目模式',
			//halign: 'center',
			align: 'center',
			width: 100,
			formatter: comboboxFormatter,
			editor: {
				type: 'combobox',
				options: {
					valueField: 'rowid',
					textField: 'name',
					data: [{
							rowid: '1',
							name: '是'
						}, {
							rowid: '0',
							name: '否'
						}
					]
				}
			}

		}
	]];

var schemGridObj = $HUI.datagrid("#schemGrid", {
		title: '科室预算编制方案',
		headerCls: 'panel-header-gray',
		url: $URL,
		loadMsg: "正在加载，请稍等…",
		autoRowHeight: true,
		rownumbers: true, //行号
		singleSelect: true, //只允许选中一行
		pageSize: 20,
		pageList: [10, 20, 30, 50, 100], //页面大小选择列表
		pagination: true, //分页
		fit: true,
		columns: MainColumns,
		onClickCell: function (index, field, value) {
			var rows = $('#schemGrid').datagrid('getRows');
			var row = rows[index];
			if (field == 'StateDesc') {
				schemastatefun(rows[index].rowid, userid, rows[index].SchemId);
			}
		},
		onClickRow: function (index, row) {
			//重新加载预算项目下拉框
			$('#itemcb').combobox('clear');
			$('#itemcb').combobox('reload',
				$URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItem&ResultSetType=array'
				 + '&year=' + row.Year);

			$('#LowerPartGrid').datagrid('load', {
				ClassName: "herp.budg.hisui.udata.uBudgSchemOwnDept",
				MethodName: "ListDetail",
				hospid: hospid,
				userid: userid,
				schemAuditId: row.Rowid,
				itemTyCode: $('#typecb').combobox('getValue'),
				itemcode: $('#itemcb').combobox('getValue'),
				isLast: isLast
			});
		},
		toolbar: '#tb'
	});
// 查询函数
function Search() {

	schemGridObj.load({
		ClassName: "herp.budg.hisui.udata.uBudgSchemOwnDept",
		MethodName: "List",
		hospid: hospid,
		userid: userid,
		year: $('#yearcb').combobox('getValue'),
		schemId: $('#schemcb').combobox('getValue'),
		detpId: $('#deptcb').combobox('getValue'),
		deptIsBudg: $('#deptIsBudg').combobox('getValue')
	})
}

// 点击查询按钮
$("#FindBn").click(Search);
