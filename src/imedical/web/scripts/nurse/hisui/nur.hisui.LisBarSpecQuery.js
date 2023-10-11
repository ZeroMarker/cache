/**
 * @description: ����������Ŀ��ѯ
 * @name: nur.hisui.LisBarSpecQuery.js
 * @csp: nur.hisui.LisBarSpecQuery.csp
 */
$(function(){
	$('#queryOrderBtn').click(find);

	var columns=[[
	{field:'RegNo',title:'�ǼǺ�',width:90},
	{field:'BedCode',title:'����',width:90},
	{field:'PatName',title:'����',width:90},
	{field:'Sex',title:'�Ա�',width:90},
	{field:'Age',title:'����',width:90},
	{field:'LabOrdName',title:'����ҽ������',width:90},
	{field:'SttDateTime',title:'������ĿҪ��ִ��ʱ��',width:90},
	{field:'ReceiveDateTime',title:'����ƽ���ʱ��',width:90},
	{field:'OederId',title:'ҽ��Id',width:90}
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
	