jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
	
);
function initDocument()
{
	defindTitleStyle();
	initDHCEQRiskEvaluateHistory();
}
function initDHCEQRiskEvaluateHistory()
{
	$HUI.datagrid("#tDHCEQRiskEvaluateHistory",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Risk.BUSEvaluate",
	        QueryName:"GetRiskEvaluateHistory",
	        SourceType:getElementValue("SourceType"),
	        SourceID:getElementValue("SourceID"),
			RowID:getElementValue("RowID"),
	    },
	    fit:true,
		singleSelect:true,
		rownumbers: true,  //如果为true，则显示一个行号列
		columns:[[
			{field:'TRiskEvaluationDR',title:'TRiskEvaluationDR',width:200,align:'center',hidden:true},
			{field:'TEvaluateUser',title:'评估人',width:200,align:'center'},
			{field:'TEvaluateDate',title:'评估日期',width:200,align:'center'},
			{field:'TRiskGrade',title:'评估结果',width:110,align:'center'},
			{field:'TWeight',title:'评估分数',width:110,align:'center'},
			{field:'TEvaluateDetail',title:'评估详细',width:110,align:'center',formatter: DetailOperation}
		]],
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75]

});
}
function DetailOperation(value,row,index){
	var str="dhceq.em.riskevaluate.csp?&RowID="+row.TRiskEvaluationDR+"&ReadOnly=1"+"&SourceType="+jQuery('#SourceType').val()+"&SourceID="+jQuery('#SourceID').val()+"&Name="+jQuery('#Name').val();
	//add by lmm 2020-06-05 UI
	//modified by wy 2020-6-24 需求	1381833 begin
	var title="评估详细"      
	var icon="icon-w-edit"
	var btn='<A onclick="showWindow(&quot;'+str+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;large&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" /></A>' /// Modfied by lmm 2020-04-27 1292448
	return btn;
}


