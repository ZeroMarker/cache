//年度下拉框加载前事件
function YearBefLoad(param) {
	param.flag = '';
	param.str = param.q;
}

//科室预算编制（自编）-科室下拉框加载前事件触发方法
function selfDeptBefLoad(param) {
	param.hospid = hospid;
	param.userid = userid;
	param.str = param.q;
}

//科室预算审核-方案下拉框加载前事件触发方法
function DeptSchemsBefLoad(param) {
	param.hospid = hospid;
	param.userid = userid;
	param.year = $('#yearcb').combobox('getValue');
	param.str = param.q;
}

