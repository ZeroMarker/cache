var InitGroupFlag=false;
$(document).ready(
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
	initCombogrid();
	jQuery("#BFind").click(function(){findGridData()});
	jQuery('#DHCEQMaintPlanAlert').datagrid({
		url:'dhceq.jquery.csp',
		border:'true',
		queryParams:{
			ClassName:"web.DHCEQMaintPlanNew",
			QueryName:"GetMaintPlanNew",
	        Arg1:$('#BussType').val(),
	        Arg2:'',
	        Arg3:'',  //$('#MaintLocDR').val()
	        Arg4:$('#MaintTypeDR').val(),
	        Arg5:$('#QXType').val(),
	        Arg6:'',
	        Arg7:'',
			ArgCnt:7
			},
		fit:true,
		rownumbers: false,  //如果为true，则显示一个行号列。
		singleSelect:true,
    	columns:[[
    	    {field:'TRow',title:'序号',align:'center',width:'3%'},
    		{field:'TExecute',title:'计划执行',width:'7%',align:'center',formatter:ExecuteMaintPlan},
    		{field:'TRowID',title:'RowID',width:'3%',hidden:true},
        	{field:'TMaintNo',title:'计划单号',align:'center',width:'10%'},
        	{field:'TName',title:'计划名称',align:'center',width:'12%',formatter:MaintPlanName},
        	{field:'TCycleNum',title:'周期',align:'center',width:'5%'},
        	{field:'TPreWarnDaysNum',title:'预警天数',align:'center',width:'5%'},
        	{field:'TNextExDate',title:'下次执行日期',align:'center',width:'7%'},
        	{field:'TMaintFee',title:'费用',align:'center',width:'5%'},
        	{field:'TMaintLoc',title:'执行部门',align:'center',width:'10%'},
        	{field:'TExeUser',title:'执行人',align:'center',width:'5%'},
        	{field:'TLastExDate',title:'上次执行日期',align:'center',width:'7%'},
        	{field:'TLastExSchedule',title:'上次执行进度',align:'center',width:'10%',formatter:LastExDetail},
        	{field:'THistoryExList',title:'历次执行',align:'center',width:'8%',formatter:HistoryExRecord},
    		{field:'TLastPlanExeID',title:'LastPEID',width:'3%',hidden:true}
    	]],
		onLoadSuccess:function(data){},
		onClickRow:function(rowIndex,rowData){},
		onLoadError: function(resullt) { alertShow(JSON.stringify(resullt)) },//jQuery.messager.alert("错误", "加载列表错误.");},
		rowStyler:function(index,row){},
		pagination:true,
		pageSize:30,
		pageNumber:1,
		pageList:[10,20,30,40,50]
	});

}
function test(value)
{
	//alertShow(value.TName);
}
$('#MaintUser').combogrid({
	url:'dhceq.jquery.csp', 
	panelWidth:320,
	delay:800,
	idField:'TRowID',
	textField:'TName',
	method:"post",
	mode:'remote',
	queryParams:{
		ClassName: 'web.DHCEQ.Process.DHCEQFind',
		QueryName: 'User',
		Arg1: '',
		ArgCnt: 1
	},
	columns:[[    
        {field:'TRowID',title:'rowid',hidden:true},    
        {field:'TName',title:'负责人'}
        ]],
	keyHandler: { 
		query: function(q) {
			ReloadGrid("MaintUser",q,q);}
		},
	pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75,90,105]
 });
      

function ExecuteMaintPlan(rowIndex, rowData)
{
	var LastPlanExeID=rowData.TLastPlanExeID;
	if (LastPlanExeID==""){LastPlanExeID=0}
	var MPRowID=rowData.TRowID;
	var btn='<A class="easyui-linkbutton" data-options="plain:true,iconCls:\'icon-add\'" onclick="ExecutePlan('+MPRowID+','+LastPlanExeID+')" href="#"><img border=0 complete="complete" src="../images/uiimages/enablepaper.png" />执行</A>';
	return btn;
}

function MaintPlanName(rowIndex, rowData)
{
	if(rowData.TRowID!="")
	{
		var MaintPlanName=rowData.TName
		var IconName=MaintPlanName.split("^")
		var Icon=IconName[0];
		var Name=IconName[1];
		var ImageSrc=""
		if (Icon){
			ImageSrc='<img border=0 complete="complete" src="../images/'+Icon+'" />'
		}
		var url="dhceq.process.maintplan.csp?RowID="+rowData.TRowID;
		var btn='<A onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#">'+ImageSrc+Name+'</A>';
		return btn;
	}
}

function LastExDetail(rowIndex, rowData)
{
	var MPRowID=rowData.TRowID;
	var PERowID=rowData.TLastPlanExeID;
	if(MPRowID!="")
	{
		var url="dhceqmaintplanexecute.csp?MPRowID="+MPRowID+"&BussType="+$('#BussType').val()+"&RowID="+PERowID;
		var btn='<A class="easyui-linkbutton" data-options="plain:true,iconCls:\'icon-add\'" onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#">'+rowData.TLastExSchedule+'</A>';
		return btn;
	}
}
function HistoryExRecord(rowIndex, rowData)
{
	var url="dhceqhistoryexecutelist.csp?MPRowID="+rowData.TRowID+"&BussType="+$('#BussType').val();
	var btn='<A class="easyui-linkbutton" data-options="plain:true,iconCls:\'icon-add\'" onclick="OpenNewWindow(&quot;'+url+'&quot;)" href="#"><img border=0 complete="complete" src="../scripts/dhceq/easyui/themes/icons/detail.png" /></A>';
	return btn;
}

function findGridData(){
	var val=$('#BussType').val()+"^"+$('#MaintName').val()+"^"+$('#MaintLoc').combogrid('getValue')+"^"+$('#MaintTypeDR').val()+"^"+$('#QXType').val()+"^^^"+$('#MaintNo').val()
	$('#DHCEQMaintPlanAlert').datagrid({    
	    url:'dhceq.jquery.csp', 
	    queryParams:{
	        ClassName:"web.DHCEQMaintPlanNew",
	        QueryName:"GetMaintPlanNew",
	        Arg1:$('#BussType').val(),
	        Arg2:$('#MaintName').val(),
	        Arg3:$('#MaintLoc').combogrid('getValue'),
	        Arg4:$('#MaintTypeDR').val(),
	        Arg5:$('#QXType').val(),
	        Arg6:$('#MaintNo').val(),
	        Arg7:$('#Schedule').combobox('getValue'),
	        ArgCnt:7
	    },
	    border:'true',
	    singleSelect:true
    });
}

function ExecutePlan(MPRowID,PlanExeID){
	if (PlanExeID!=0)
	{
		var truthBeTold = window.confirm("该计划单已执行过,是否重新生成执行单？");
		if (!truthBeTold) return;
	}
	if (MPRowID=="")
	{
		alertShow("请选择要执行的计划单");
		return
	}
	$.ajax({
        url :"dhceq.jquery.method.csp",
        type:"POST",
        data:{
            ClassName:"web.DHCEQMaintPlanNew",
            MethodName:"ExecuteMaintPlan",
            Arg1:MPRowID,
            ArgCnt:1
        },
        beforeSend: function () {
            $.messager.progress({
            text: '正在执行中...'
            });
        },
       	error:function(XMLHttpRequest, textStatus, errorThrown){
            alertShow(XMLHttpRequest.status);
            alertShow(XMLHttpRequest.readyState);
            alertShow(textStatus);
        },
        success:function (data, response, status) {
        $.messager.progress('close');
        if (data>0) {
        $('#DHCEQMaintPlanAlert').datagrid('reload'); 
        $.messager.show({
            title: '提示',
            msg: '执行成功'
        }); 
        }   
        else {
           $.messager.alert('执行失败！',data, 'warning')
           return;
           }
       }
   })
}

