jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
	
);
function initDocument()
{
	initPanel();
}
function initPanel()
{
	initTopPanel();		
}
//初始化查询头面板
function initTopPanel()
{
	initMessage(""); //获取所有业务消息  Modiedy by zc0056 20200204
	showBtnIcon('BFind',false); //modified by LMH 20230202 动态设置是否极简显示按钮图标
	initButtonWidth();
	jQuery('#BFind').on("click", BFind_Clicked);
	initSourceTypeData();
	defindTitleStyle();
	setRequiredElements("SourceType");
	initDHCEQRiskEvaluateSoucre();			//初始化表格

}
function initSourceTypeData()
{
	var SourceType = $HUI.combobox('#SourceType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: ''
			},{
				id: '0',
				text: '设备类型'
			},{
				id: '1',
				text: '设备分类'
			},{
				id: '2',
				text: '设备项'
			},{
				id: '3',
				text: '设备'
			}]
});
}	
function BFind_Clicked()
{
	if (checkMustItemNull()) return;
	initDHCEQRiskEvaluateSoucre()
}
function initDHCEQRiskEvaluateSoucre()
{
	$HUI.datagrid("#tDHCEQRiskEvaluateSoucre",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Risk.BUSEvaluate",
	        QueryName:"GetRiskEvaluateSoucre",
	        SourceType:getElementValue("SourceType"),
			Desc:getElementValue("Desc"),
	    },
	    singleSelect:true,
		//fitColumns:true,	//modified by LMH 20230202  列少时默认向左对齐
		//modified by LMH 20230202  列少时默认向左对齐修改列宽度,避免查询的文字显示不全问题
    	columns:[[
			{field:'TRowID',title:'TRowID',width:0,align:'center',hidden:true},
			{field:'TSourceType',title:'TSourceType',width:0,align:'center',hidden:true},
			{field:'TSourceTypeDesc',title:'来源类型',width:80,align:'center'},
			{field:'TName',title:'名称',width:120,align:'center'},
			{field:'TCode',title:'代码',width:80,align:'center'},
			{field:'TOpt',title:'评估',width:100,align:'center',formatter: detailOperation},
		]],
		pagination:true,
    	pageSize:15,
    	pageNumber:1,
    	pageList:[15,30,45,60,75]  
});
}
function detailOperation(value,row,index)
{
	var result=tkMakeServerCall("web.DHCEQ.Risk.BUSEvaluate","GetRecentRiskEvaluate",row.TSourceType,row.TRowID);
    var str= "dhceq.em.riskevaluate.csp?&ReadOnly=0&SourceType="+row.TSourceType+"&SourceID="+row.TRowID+"&Name="+row.TName+"&RowID="+result ; 
	var width=""
	var height="19row"
	var icon="icon-paper"
	var title="医疗设备风险等级评估"	
	var btn='<A onclick="showWindow(&quot;'+str+'&quot;,&quot;'+title+'&quot;,&quot;'+width+'&quot;,&quot;'+height+'&quot;,&quot;'+icon+'&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;large&quot;)" href="#"><span class="icon-paper" style="display:inline-block;height:24px;width:24px;"></span></A>'  // modfied by yh 2020-02-17 1161616
	return btn;
}
