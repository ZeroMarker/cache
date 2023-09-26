$(document).ready(function () {
InitForm();
$('#logdatagrid').datagrid({    
    url:'dhcclinic.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCCLMappingData",
        QueryName:"FindLogInfo",
        Arg1:$("#StartDate").datebox('getValue'),
        Arg2:$("#StartTime").timespinner('getValue'),
        Arg3:$("#EndDate").datebox('getValue'),
        Arg4:$("#EndTime").timespinner('getValue'),
        Arg5:"",
        Arg6:$("#LogDesc").textbox("getValue"),
        Arg7:$("#LogSeq").textbox("getValue"),
        Arg8:$("#LogContent").textbox("getValue"),
        Arg9:"",
        ArgCnt:9
    },
    border:'true',
    singleSelect:true,
    columns:[[    
        {field:'LogType',title:'类型',width:60},    
        {field:'LogDesc',title:'描述',width:100},    
        {field:'LogSeq',title:'序号',width:50},  
        {field:'LogContent',title:'内容',width:400}, 
        {field:'LogStatus',title:'状态',width:50},
        {field:'LogDate',title:'日期',width:100},
        {field:'LogTime',title:'时间',width:100},
        {field:'RowId',title:'RowId',width:50}
    ]],
    onClickCell:function(rowIndex,field,value){
	    if(field=="LogContent")
	    {
	       $("#content").dialog("open");
	       document.getElementById("cont").value=value;		    
	    }
    },
    rowStyler:function(rowIndex,rowData){
        //根据状态不同行背景颜色颜色不同
		switch(rowData.LogStatus)
		{
			case 'X':
				return 'background-color:#FF0000';
				break;
			case 'E':
				return 'background-color:#FFA07A';
			    break;
			case 'W':
				return 'background-color: #FFFF00';
			    break;			    
			default:
			    break;
			}
        },
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60]
});

$("#BtnFind").click(function(){
	var typedata=$('#LogStyle').datagrid('getSelections');
	var typelen=typedata.length;
	var logtypestr="";
	for(var i=0;i<typelen;i++)
	{
		if(logtypestr=="") logtypestr=typedata[i].Code;
		else  logtypestr=logtypestr+"^"+typedata[i].Code;
	}
	var statusdata=$('#LogStatus').datagrid('getSelections');
	var statuslen=statusdata.length;
	var logstatusstr="";
	for(var j=0;j<statuslen;j++)
	{
		if(logstatusstr=="") logstatusstr=statusdata[j].code;
		else  logstatusstr=logstatusstr+"^"+statusdata[j].code;
	}	
	var queryParams = $("#logdatagrid").datagrid('options').queryParams;
    queryParams.Arg1 = $("#StartDate").datebox('getValue'); 
    queryParams.Arg2 = $("#StartTime").timespinner('getValue');
    queryParams.Arg3 = $("#EndDate").datebox('getValue');
    queryParams.Arg4 = $("#EndTime").timespinner('getValue');
    queryParams.Arg5 = logtypestr;
    queryParams.Arg6 = $("#LogDesc").textbox("getValue");
    queryParams.Arg7 = $("#LogSeq").textbox("getValue");
    queryParams.Arg8 = $("#LogContent").textbox("getValue");
    queryParams.Arg9 = logstatusstr;
    $("#logdatagrid").datagrid('reload');
});

})

function InitForm()
{
	/*$.fn.datebox.defaults.formatter = function(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	return y+'-'+m+'-'+d;
    }*/
    
    $("#StartDate").datebox({
        width: 160
    });	
    $("#StartTime").timespinner({
        width: 160
    });	
    $("#EndDate").datebox({
        width: 160
    });	
    $("#EndTime").timespinner({
        width: 160
    });	
    $("#LogSeq").textbox({
        width: 160
    });	   
    $("#LogDesc").textbox({
        width: 160
    });
    $("#LogContent").textbox({
        width: 160
    });    
    
    var NowDate=new Date();
    var y =NowDate.getFullYear();
    var m = NowDate.getMonth();
    var d = NowDate.getDate();
    var hh = NowDate.getHours();
    var mm = NowDate.getMinutes();
    var ss = NowDate.getSeconds(); 
    $("#StartDate").datebox('setValue',(y+"-"+m+"-"+d))
    $("#EndDate").datebox('setValue',(y+"-"+m+"-"+d))
    if(mm>=20){
	    $("#StartTime").timespinner('setValue',hh+":"+(mm-20)+":"+ss);
	    $("#EndTime").timespinner('setValue',hh+":"+mm+":"+ss);	    
    }
    if(mm<20)
    {
	   	$("#StartTime").timespinner('setValue',(hh-1)+":"+(mm+60-20)+":"+ss);
	    $("#EndTime").timespinner('setValue',hh+":"+mm+":"+ss); 
    }
    
    $("#LogStyle").datagrid({
        url:'dhcclinic.jquery.csp', 
        queryParams:{
            ClassName:"web.DHCCLMappingData",
            QueryName:"FindMappingService",
            ArgCnt:0
        },
        border:'true',
        columns:[[
            { field: "ck", checkbox: true },  
            {field:'RowId',title:'Id',width:30},    
            {field:'Code',title:'Code',width:100}
        ]],
        onLoadSuccess:function(){
	         $("#LogStyle").datagrid('checkAll');
	    }    
    })
    
  
   
   var status=[
	    {desc:"ExternalError",code:"X"},
		{desc:"Error",code:"E"},
		{desc:"Warning",code:"W"},
		{desc:"Success",code:"S"}
		];
    $("#LogStatus").datagrid({
        url:null, 
        border:'true',
        columns:[[
            {field: "ck", checkbox: true},  
            {field:'code',title:'code',width:30},    
            {field:'desc',title:'desc',width:100}
    ]]  
    })
    $("#LogStatus").datagrid("loadData",status);
    
    $("#LogStatus").datagrid('checkAll');
    
    $("#content").dialog({
		title:"编辑",
		width:500,
		height:250,
		closed:true
	})
}