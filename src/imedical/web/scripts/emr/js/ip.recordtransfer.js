$(function(){
	
	$('#gridToSection').datagrid({  
		title:'可转移至列表',
		iconCls:'icon-paper',
		fit:true,
		headerCls:'panel-header-gray',
		toolbar:'#toolbar',
		singleSelect:true,
	    url:'../EMRservice.Ajax.appointdeptmanager.cls?AppType=List&EpisodeID='+episodeID+'&Type='+"HISUI",  
	    columns:[[  
	        {field:'deptID',title:'deptID',hidden:true},  
	        {field:'deptName',title:'科室名称',width:100},  
	        {field:'TransStartDate',title:'进入日期',width:120,align:'left'},
	        {field:'TransStartTime',title:'进入时间',width:120,align:'left'} 
	    ]]  
	});
	
	$('#gridStatus').datagrid({  
		title:'已转移至列表',
		iconCls:'icon-paper',
		fit:true,
		singleSelect:true,
		headerCls:'panel-header-gray',
		toolbar:[],
	    url:'../EMRservice.Ajax.appointdeptmanager.cls?AppType=Status&EpisodeID='+episodeID+'&Type='+"HISUI", 
	    //data:[{"emrDept":"ke1","endDate":"2018-1-1","endTime":"12"},{"emrDept":"ke1","endDate":"2018-1-1","endTime":"12"},{"emrDept":"ke1","endDate":"2018-1-1","endTime":"12"}],
	    columns:[[  
	        {field:'emrDept',title:'目前科室',width:100},  
	        {field:'endDate',title:'结束日期',width:120,align:'left'},
	        {field:'endTime',title:'结束时间',width:120,align:'left'},
	        {field:'operate',title:'回收病历',width:80,align:'left',formatter:formatOper}  
	    ]],
	     onLoadSuccess:function(){
		    $.parser.parse(); 
	     } 
	});
	
	$('#btnConfirmTC').click(function(){
		confirm();
	});	
});


function formatOper(val,row,index){
	return '<a href="#" title="回收病历" class="hisui-linkbutton" data-options="plain:true,iconCls:'+"'icon-cancel-select-grant big'" +'" onclick="withdraw('+index+')"></a>';
}

function confirm() 
{
	var hour = $('#txtHourTC').val();
	if (hour == "")
	{
		setMessage('转出时间不能为空','alert');
		return;
	}
	if(hour > 100)
	{
		setMessage('病历转移时间最多为100小时!','alert');
		return;
	}
	var seleRow = $('#gridToSection').datagrid('getSelected');  
	if (seleRow == null)
	{
		setMessage('请选择一个科室!','alert');
		return;
	}
	$.ajax({ 
        type: "get", 
        dataType: "json",
        async: true,
        url: "../EMRservice.Ajax.appointdeptmanager.cls", 
        data: "AppType=Appoint"+"&EpisodeID=" +episodeID+"&EMRDept="+seleRow.deptID+"&Times="+hour, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            setMessage(textStatus,'error'); 
        }, 
        success: function (d) 
        { 
            if (d.success == "true")
			{
				$('#gridToSection').datagrid('reload');
				$('#gridStatus').datagrid('reload');
			} 
			else
			{
				setMessage('病历转移失败!','alert');
			}			
        } 
    });	
}

function setMessage(msg,type)
{
	$.messager.popover({
		msg:msg,
		type:type,
		style:{
			bottom:-document.body.scrollTop - document.documentElement.scrollTop+40, //显示到右下角
			right:20
		}
	});	
}

//收回病历转移
function withdraw(index) {
	$('#gridStatus').datagrid('selectRow',index);
	var seleRow = $('#gridStatus').datagrid('getSelected'); 
	if (seleRow == null)
	{
		setMessage('请选择回收的科室!','alert');
		return;
	}
	$.ajax({ 
        type: "get", 
        dataType: "text",
        async: true,
        url: "../EMRservice.Ajax.appointdeptmanager.cls", 
        data: "AppType=Withdraw"+"&EpisodeID=" +episodeID, 
        error: function (XMLHttpRequest, textStatus, errorThrown) 
        { 
            setMessage(textStatus,'error'); 
        }, 
        success: function (d) 
        { 
	        if (d == "Y")
			{
				$('#gridStatus').datagrid('reload');
			} 
			else
			{
				setMessage('收回病历失败!','alert');
			}			
        } 
    });	
	
}