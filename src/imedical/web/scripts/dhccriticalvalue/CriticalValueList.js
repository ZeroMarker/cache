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
		title:'Σ��ֵ',
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
	    	{field:'TSName',title:'ҽ������'},
	    	{field:'ReportStatus',title:'״̬',formatter:function(v,row,rowIndex){
		    	return '<a href="javascript:void(0);" onclick="openDetail(\''+rowIndex+'\')">'+v+'</a>';
		    }},
	    	{field:'ReportType',title:'����'},
	    	{field:'DateTime',title:'��������'},
	    	{field:'ApplyDT',title:'����ʱ��'},
	    	{field:'SamplingDT',title:'����ʱ��'},
	    	{field:'ReceiveDT',title:'����ʱ��'},
	    	{field:'AuditDT',title:'���ʱ��'},
	    	{field:'Specimen',title:'�걾'},
	    	{field:'DPRPAlert',title:'������ʾ'}
	    ]]

	})

}


$(init);