//界面入口
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
	initTopPanel();
}
//初始化查询头面板
function initTopPanel()
{
	
	//modify by lmm 2020-06-05 UI
	var MPRowID=jQuery("#MPRowID").val();
	FillData(MPRowID);
	$HUI.datagrid("#tDHCEQHistoryExeList",{   
	   	url:$URL, 
		idField:'TRowID', //主键   //add by lmm 2018-10-23
	    border : false,
		striped : true,
	    cache: false,
	    fit:true,
		fitColumns:true,   //add by lmm 2020-06-05 UI
	    singleSelect:false,
	    queryParams:{
	        ClassName:"web.DHCEQPlanExecute",
	        QueryName:"GetExecutePlan",
	        MaintPlanDR:getElementValue("MPRowID"),
	        Status:'',
	        ExeLocDR:'',
	        ExecuteNo:'',

		},
		//fitColumns:true,
		pagination:true,
    	columns:[[
    	    {field:'TRow',title:'序号',align:'center'},
    		{field:'TRowID',title:'RowID',hidden:true},
        	{field:'TExeNo',title:'执行单号',width:150,align:'center'},
        	{field:'TExeLoc',title:'执行科室',width:150,align:'center'},
        	{field:'TExeDate',title:'执行开始日期',width:150,align:'center'},
        	{field:'TExecutor',title:'执行人',width:150,align:'center'},
        	{field:'TFinishDate',title:'完成日期',width:150,align:'center'},
        	{field:'TRemark',title:'备注',width:150,align:'center'},
        	{field:'TExeSchedule',title:'执行进度',width:150,align:'center',formatter:ExeDetail}
    	]], 
	});	
	
}
		
	
function ExeDetail(rowIndex, rowData)
{
	var PERowID=rowData.TRowID;
	if(PERowID!="")
	{
		var url="dhceq.em.maintplanexecute.csp?MPRowID="+$("#MPRowID").val()+"&BussType="+$('#BussType').val()+"&RowID="+PERowID;
		var btn='<A class="easyui-linkbutton" data-options="plain:true,iconCls:\'icon-add\'" onclick="showWindow(&quot;'+url+'&quot;,&quot;计划执行&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;&quot;,&quot;large&quot;)" href="#">'+rowData.TExeSchedule+'</A>';
		return btn;
	}
}

function FillData(MPRowID)
{
	if(MPRowID=="") return;
	jQuery.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQMaintPlanNew',
			MethodName:'GetOneMaintPlan',
			Arg1:MPRowID,
			ArgCnt:1
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			var list=data.split("^");
			var sort=44;
			setElement("MaintPlanName",list[0])
			setElement("MaintPlanNo",list[49])
			setElement("CycleNum",list[6]+list[sort+9])
			setElement("MaintLoc",list[sort+11])
			
		}
	});
}