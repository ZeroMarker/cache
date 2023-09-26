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
	initTopPanel();
}
//初始化查询头面板
function initTopPanel()
{
	var MPRowID=jQuery("#MPRowID").val();
	FillData(MPRowID);
}
jQuery('#tDHCEQHistoryExeList').datagrid({
		url:'dhceq.jquery.csp',
		border:'true',
		queryParams:{
			ClassName:"web.DHCEQPlanExecute",
			QueryName:"GetExecutePlan",
	        Arg1:$('#MPRowID').val(),
	        Arg2:'',
	        Arg3:'',
	        Arg4:'',
			ArgCnt:4
			},
		fit:true,
		rownumbers: false,
        singleSelect:true,
    	columns:[[
    	    {field:'TRow',title:'序号',align:'center',width:'3%'},
    		{field:'TRowID',title:'RowID',width:'3%',hidden:true},
        	{field:'TExeNo',title:'执行单号',align:'center',width:'10%'},
        	{field:'TExeLoc',title:'执行科室',align:'center',width:'12%'},
        	{field:'TExeDate',title:'执行开始日期',align:'center',width:'10%'},
        	{field:'TExecutor',title:'执行人',align:'center',width:'8%'},
        	{field:'TFinishDate',title:'完成日期',align:'center',width:'10%'},
        	{field:'TRemark',title:'备注',align:'center',width:'7%'},
        	{field:'TExeSchedule',title:'执行进度',align:'center',width:'10%',formatter:ExeDetail}
    	]],
		onLoadSuccess:function(data){},
		onClickRow:function(rowIndex,rowData){},
		onLoadError: function(resullt) { alertShow(JSON.stringify(resullt)) },
		rowStyler:function(index,row){},
		pagination:true,
		pageSize:30,
		pageNumber:1,
		pageList:[10,20,30,40,50]
	});
	
function ExeDetail(rowIndex, rowData)
{
	var PERowID=rowData.TRowID;
	if(PERowID!="")
	{
		var url="dhceq.em.maintplanexecute.csp?MPRowID="+$("#MPRowID").val()+"&BussType="+$('#BussType').val()+"&RowID="+PERowID;
		var btn='<A class="easyui-linkbutton" data-options="plain:true,iconCls:\'icon-add\'" onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#">'+rowData.TExeSchedule+'</A>';
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
			$("#MaintPlanName").textbox('setText',list[0]);
			$("#MaintPlanNo").textbox('setText',list[49]);
			$("#CycleNum").textbox('setText',list[6]+list[sort+9]);
			$("#MaintLoc").textbox('setText',list[sort+11]);
		}
	});
}