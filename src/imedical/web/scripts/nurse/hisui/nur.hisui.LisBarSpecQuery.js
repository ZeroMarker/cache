/**
 * @description: 病区检验项目查询
 * @name: nur.hisui.LisBarSpecQuery.js
 * @csp: nur.hisui.LisBarSpecQuery.csp
 */
$(function(){
	$('#queryOrderBtn').click(find);

	var columns=[[
	{field:'RegNo',title:'登记号',width:90},
	{field:'BedCode',title:'床号',width:90},
	{field:'PatName',title:'姓名',width:90},
	{field:'Sex',title:'性别',width:90},
	{field:'Age',title:'年龄',width:90},
	{field:'LabOrdName',title:'检验医嘱名称',width:90},
	{field:'SttDateTime',title:'检验项目要求执行时间',width:90},
	{field:'ReceiveDateTime',title:'检验科接收时间',width:90},
	{field:'OederId',title:'医嘱Id',width:90}
	]];
	
	var grid=$HUI.datagrid('#ordGrid',{
		columns:columns,
		url:$URL,
		queryParams:{
			ClassName:'web.OrderQuery',
			QueryName:'GetListBywebsys'
			},
			fitColumns:true,
			pagination:true,
			pageSize:20,
			pageList:[20,40,60],
		});
	
	function find(){
		var wardId=session['LOGON.WARDID'];
		var startDate=$('#startDate').datebox('getValue');
		var endDate=$('#endDate').datebox('getValue');
		var parr=wardId+"^"+startDate+"^"+endDate;
		$("#ordGrid").datagrid("load",{
			ClassName:'web.OrderQuery',
			QueryName:'GetListBywebsys',
			'parr':parr
			})
	}
})
	