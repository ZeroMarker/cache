function openDetail(rowIndex){
	//alert(rowIndex)	
	var row=$('#tCVList').datagrid('getRows')[rowIndex];
	var url="criticalvalue.trans.hisui.csp?ReportId="+row.ReportId+"&RepType="+row.ReportType;
	url=common.getTokenUrl(url);
	
	$('#win').dialog('open').dialog('center');
	$('#iframeCV').attr('src',url);
}

function openOrderView(rowIndex){
	var row=$('#tCVList').datagrid('getRows')[rowIndex];
	var ord=(row.ordItem||'').split(',').join('^');
	var url="dhc.orderview.csp?ord="+ord;
	
	common.easyModal('医嘱状态',url,1200,400);
	
}

function closeTransWin(){
	$('#win').dialog('close');
	$('#iframeCV').attr('src','');
}
var init=function(){
	var pPapmiNo="",columns=[];
	if (SearchByPat=='1') {
		pPapmiNo='^'+PatientID;
		columns=columns.concat([
			{title:'就诊时间',field:'admDT',width:160},
			{title:'就诊科室',field:'Location',width:120},
			{title:'医生',field:'Doctor',width:80},
		])
	}else{
		pPapmiNo='^'+PatientID+'^'+EpisodeID;
	}
	columns=columns.concat([
		{title:'报告时间',field:'DPRPDate',width:160,formatter:function(val,row,ind){
			return val+' '+row['DPRPTime'];
		}},
		{title:'类型',field:'repTypeDesc',width:60},
		{title:'医嘱名称',field:'TestSet',width:200,formatter:function(v,row,rowIndex){
		    return '<a href="javascript:void(0);" onclick="openOrderView(\''+rowIndex+'\')">'+v+'</a>';
		}},
		{field:'repStatusDesc',title:'状态',formatter:function(v,row,rowIndex){
		    	return '<a href="javascript:void(0);" onclick="openDetail(\''+rowIndex+'\')">'+v+'</a>';
		},width:80},
		{title:'危急值报告结果',field:'repResult',width:600},
	])
	
	$('#tCVList').datagrid({

		bodyCls:'panel-header-gray',
        pagination: true,
        striped:true,
        singleSelect:true,
        idField:'name',
        rownumbers:true,
        nowrap:false,
        url:$URL,
        queryParams:{
	        ClassName:'web.DHCAntCVReportSearch',
	        QueryName:'GetCVReportNew',
	        pPapmiNo:pPapmiNo,
	        TransStatus:TransStatus
	    },
	    fit:true,
	    toolbar:'#tb',
	    //fitColumns:true,
	    columns:[columns]

	})
	
	$('#pStatus').combobox({
		data:pStatusData,
		panelHeight:'auto',
		onSelect:function(row){
			$('#tCVList').datagrid('load',{
		        ClassName:'web.DHCAntCVReportSearch',
		        QueryName:'GetCVReportNew',
		        pPapmiNo:pPapmiNo,
		        TransStatus:row.value
			}) 
			
		}
	}).combobox('setValue',TransStatus)

}


$(init);