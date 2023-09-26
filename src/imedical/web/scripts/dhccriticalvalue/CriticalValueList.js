function openDetail(rowIndex){
	//alert(rowIndex)	
	var row=$('#tCVList').datagrid('getRows')[rowIndex];
	var url="criticalvalue.trans.hisui.csp?ReportId="+row.ReportId+"&RepType="+row.DPRPType;
	
	$('#win').dialog('open');
	$('#iframeCV').attr('src',url);
}
function closeTransWin(){
	$('#win').dialog('close');
	$('#iframeCV').attr('src','');
}
var init=function(){
	$('#tCVList').datagrid({
		title:'危急值',
		headerCls:'panel-header-gray',
        pagination: true,
        striped:true,
        singleSelect:true,
        idField:'name',
        rownumbers:true,
        toolbar:[],
        url:$URL,
        queryParams:{
	        ClassName:'web.DHCCVCommon',
	        QueryName:'CVReportFromAdm',
	        EpisodeId:EpisodeId,
	        TransStatus:TransStatus
	    },
	    fit:true,
	    fitColumns:true,
	    columns:[[
	    	{field:'TSName',title:'医嘱名称'},
	    	{field:'ReportStatus',title:'状态',formatter:function(v,row,rowIndex){
		    	return '<a href="javascript:void(0);" onclick="openDetail(\''+rowIndex+'\')">'+v+'</a>';
		    }},
	    	{field:'ReportType',title:'类型'},
	    	{field:'DateTime',title:'报告日期'},
	    	{field:'ApplyDT',title:'申请时间'},
	    	{field:'SamplingDT',title:'采样时间'},
	    	{field:'ReceiveDT',title:'接收时间'},
	    	{field:'AuditDT',title:'审核时间'},
	    	{field:'Specimen',title:'标本'},
	    	{field:'DPRPAlert',title:'警戒提示'}
	    ]]

	})

}


$(init);