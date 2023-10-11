$(function() {

	initDatebox();

	initTable();

	initMethod();
})

function initDatebox() {

}

function initTable() {
	
	var columns = [
		[{
			field: 'specCollUser',
			title: '采血人',
			align: 'center',
			width: 200
		},{
			field: 'ordTotalNumber',
			title: '医嘱数量',
			align: 'center',
			width: 200
		},{
			field: 'specTotalNumber',
			title: '标本数量',
			align: 'center',
			width: 200
		}]
	]

	$HUI.datagrid('#bloodStatisTotalTable', {
		fit: true,
		toolbar:'#toolbar',
		pagination: true,
		singleSelect: true,
		fitColumns: true,
		title: $g('采血工作量统计'), //hxy 2018-10-09 st
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray', //配置项使表格变成灰色
		url: 'dhcapp.broker.csp?ClassName=web.DHCEMBloodStatis&MethodName=listData&type=T',
		columns: columns,
		onSelect: function(rowIndex, rowData) {
			var userId = rowData.specCollUserId;
			var params = userId;
			reloadDetailTable(params);
		}

	});
	
	var columns = [
		[{
			field: 'specCollUser',
			title: '采血人',
			align: 'center',
			width: 200
		},{
			field: 'specCollDate',
			title: '采血日期',
			align: 'center',
			width: 200
		},{
			field: 'specCollTime',
			title: '采血时间',
			align: 'center',
			width: 200
		},{
			field: 'patName',
			title: '患者姓名',
			align: 'center',
			width: 200
		},{
			field: 'age',
			title: '患者年龄',
			align: 'center',
			width: 200
		},{
			field: 'ordName',
			title: '医嘱名称',
			align: 'center',
			width: 200
		}, {
			field: 'specDesc',
			title: '标本名称',
			align: 'center',
			width: 200
		}, {
			field: 'tubeColor',
			title: '容器颜色',
			align: 'center',
			width: 200
		}]
	]

	$HUI.datagrid('#bloodStatisTable', {
		fit: true,
		toolbar:[], //hxy 2022-11-16
		pagination: true,
		singleSelect: true,
		fitColumns: true,
		title: $g('采血工作量明细'), //hxy 2018-10-09 st
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray', //配置项使表格变成灰色
		url: 'dhcapp.broker.csp?ClassName=web.DHCEMBloodStatis&MethodName=listData&type=D',
		columns: columns,
		onSelect: function(rowIndex, rowData) {

		}

	});
}

function initMethod() {
	$("#queryBtn").on("click",query);
}

function query(){
	$HUI.datagrid('#bloodStatisTotalTable').load({
		comParams:getParams()
	})
	return ;	
}

function reloadDetailTable(params){
	$HUI.datagrid('#bloodStatisTable').load({
		comParams:getParams(),
		params:params
	})
	return ;
}

function getParams(){
	var startDate = $HUI.datebox("#startDate").getValue();
	var endDate = $HUI.datebox("#endDate").getValue();
	
	return startDate+"^"+endDate;
}