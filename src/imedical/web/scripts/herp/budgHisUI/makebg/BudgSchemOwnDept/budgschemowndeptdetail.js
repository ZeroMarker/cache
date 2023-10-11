/*
Creator: Liu XiaoMing
CreatDate: 2018-09-16
Description: 全面预算管理-预算编制管理-归口科室年度预算审核
CSPName: herp.budg.hisui.budgschemowndept.csp
ClassName: herp.budg.hisui.udata.uBudgSchemOwnDept
 */


//项目类别下拉框选择事件
function typecbSelectFn() {
	$('#itemcb').combobox('clear');
	$('#itemcb').combobox('reload');
	LowerPartLoad('');
}

//预算项目下拉框加载前事件触发方法
function itemBefLoad(param) {
	param.hospid = hospid;
	param.userdr = userid;
	param.flag = '1^3';
	param.type = $('#typecb').combobox('getValue');
	param.level = '';
	param.supercode = '';
	param.str = param.q;
}

//预算项目下拉框选择事件
function itemcbSelectFn() {
	LowerPartLoad('');
}

//末级复选框变化事件
function checkChangeFn(e, value) {
	isLast = value ? 1 : '';
	LowerPartLoad('');
}

DetailColumns = [[{
			field: 'ckbox',
			checkbox: true
		}, {
			field: 'rowid',
			title: 'ID',
			idth: 80,
			hidden: true
		}, {
			field: 'Year',
			title: '年度',
			width: 80,
			hidden: true
		}, {
			field: 'ItemCode',
			title: '项目编码',
			width: 150
		}, {
			field: 'ItemName',
			title: '项目名称',
			width: 200
		}, {
			field: 'PlanValue',
			title: '本年预算',
			width: 120,
			align: 'right',
			formatter: ValueFormatter
		}, {
			field: 'OneUpVaule',
			title: '一上预算',
			width: 120,
			align: 'right',
			formatter: dataFormat
		}, {
			field: 'OneDownVaule',
			title: '一下预算',
			width: 120,
			align: 'right',
			formatter: dataFormat
		}, {
			field: 'TwoUpVaule',
			title: '二上预算',
			width: 120,
			align: 'right',
			formatter: dataFormat
		}, {
			field: 'TwoDownVaule',
			title: '二下预算',
			width: 120,
			align: 'right',
			formatter: dataFormat
		}
	]];

var LowerPartGridObj = $HUI.datagrid("#LowerPartGrid", {
		title: '科室预算明细',
		headerCls: 'panel-header-gray',
		url: $URL,
		delay: 200,
		fitColumns: false,
		loadMsg: "正在加载，请稍等…",
		autoRowHeight: true,
		rownumbers: true, //行号
		pageSize: 20,
		pageList: [10, 20, 30, 50, 100], //页面大小选择列表
		pagination: true, //分页
		singleSelect: true, //只允许选中一行
		fit: true,
		columns: DetailColumns,
		onClickCell: function (index, field, value) {

			var schemRow = $('#schemGrid').datagrid('getSelected');

			$('#LowerPartGrid').datagrid('selectRow', index);
			var LowerPartrow = $('#LowerPartGrid').datagrid('getSelected');

			if ((LowerPartrow.IsLast == 1) && (field == 'PlanValue')) {
				DetailFun(schemRow, LowerPartrow);
			}
		},
		toolbar: '#ltb'
	});

// 查询函数
function LowerPartLoad(rowData) {

	if (!$('#schemGrid').datagrid('getSelected')) {
		$.messager.popover({
			msg: '请选择对应方案!',
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
	} else {
		rowData = $('#schemGrid').datagrid('getSelected');
	}

	LowerPartGridObj.load({
		ClassName: "herp.budg.hisui.udata.uBudgSchemOwnDept",
		MethodName: "ListDetail",
		hospid: hospid,
		userid: userid,
		schemAuditId: rowData.Rowid,
		itemTyCode: $('#typecb').combobox('getValue'),
		itemcode: $('#itemcb').combobox('getValue'),
		isLast: isLast
	});

}

// 点击查询按钮
$("#lFindBn").click(LowerPartLoad);
