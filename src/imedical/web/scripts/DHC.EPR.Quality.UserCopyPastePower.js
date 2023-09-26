$(function(){
	$("#DateTime").hide();
	$('#Forever').attr("checked",true);
	$('#seekform').find(':radio').change(function(){
		if (this.id == "Period"){
			$("#DateTime").show();
			$("#stDateTime").datetimebox('setValue','${notices.release_time}');
		    }else{
			$("#DateTime").hide();
		}
	})
	initcombox();
	InitAuthorityDataList();
});
//列表初始化
function InitAuthorityDataList()
{
	$('#AuthorityData').datagrid({ 
			pageSize:10,
			pageList:[10,20,30], 
			fitColumns: true,
			loadMsg:'数据装载中......',
			autoRowHeight: true,
			url:'../web.eprajax.usercopypastepower.cls?Action=GetDataList',
			singleSelect:true,
			idField:'rowID', 
			rownumbers:true,
			fit:true,
			columns:[[
			    {field:'rowID',title:'RowID',hidden:true},  
				{field:'SSGroup',title:'科室',width:80},
				{field:'UserName',title:'用户',width:80},
				{field:'StartDate',title:'禁止开始日期',width:100},
				{field:'StartTime',title:'禁止开始时间',width:100},
				{field:'EndDate',title:'禁止结束日期',width:100},
				{field:'EndTime',title:'禁止结束时间',width:100},  
				{field:'Foreverban',title:'是否永久禁止',width:100},
				{field:'IsAllowCopyPaste',title:'有无粘贴复制权限',width:120}
			]],
		  loadFilter:function(data)
		  {
			  if(typeof data.length == 'number' && typeof data.splice == 'function'){
				  data={total: data.length,rows: data}
			  }
    		  var dg=$(this);
    		  var opts=dg.datagrid('options');
              var pager=dg.datagrid('getPager');
              pager.pagination({
    	      	onSelectPage:function(pageNum, pageSize){
	    	      	opts.pageNumber=pageNum;
        	 	  	opts.pageSize=pageSize;
        	     	pager.pagination('refresh',{pageNumber:pageNum,pageSize:pageSize});
        	     	dg.datagrid('loadData',data);
        	    }
              });
    		  if(!data.originalRows){
	    		  data.originalRows = (data.rows);
              }
   		 	  var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
              var end = start + parseInt(opts.pageSize);
              data.rows = (data.originalRows.slice(start, end));
              return data;
          }
	  }); 
}

//科室、用户初始化
function initcombox()
{
	$('#CTLocID').combobox
	({
		
		valueField:'ID',  
	    textField:'Name',
		url:'../web.eprajax.usercopypastepower.cls?Action=GetCTLocID&Type=E',
		onSelect: function(record){
			initUserID(record.ID);
	    } 
    });
}
function initUserID(locId)
{
	$('#UserID').combobox
	({
		valueField:'UserID',
	    textField:'UserDesc',
		url:'../web.eprajax.usercopypastepower.cls?Action=GetUserID&LocId='+locId 
    });
}
//确定
function confirm()
{
	var userId=$("#UserID").combobox('getValue');
	var ssgroupId=$("#CTLocID").combobox('getValue')
	if($("input[name='Auth']:checked").val()==0)
	{
        var foreverban="0";
        var startDT=$("#stDateTime").datetimebox('getValue');
	    var	endDT=$("#endDateTime").datetimebox('getValue');
	    if((userId!="")&&(ssgroupId!="")&&(startDT!="")&&(endDT!="")){
		    $.ajax({ 
				type:"Post",
				url:'../web.eprajax.usercopypastepower.cls?Action=SetData',
				data:{"UserID":userId,"SSGroupID":ssgroupId,
		    	 	 "StartDateTime":startDT,"EndDateTime":endDT,
		      	 	 "Foreverban":foreverban},
				success: function (data) {
					if (data!="0")
        			{
	        			$.messager.alert('提示消息','提交成功!');
	        			$('#AuthorityData').datagrid('reload');
	        		}else
        			{
	        			$.messager.alert('提示信息','提交失败,有未选项!');
	        		}
	     		}
			});
		}else{
			$.messager.alert('提示信息','提交失败,有未选项!');
		}
	}else if($("input[name='Auth']:checked").val()==1)
	{
		var foreverban="1";
		var startDT="";
	    var	endDT="";
	    if((userId!="")&&(ssgroupId!="")){
		    $.ajax({ 
				type:"Post",
				url:'../web.eprajax.usercopypastepower.cls?Action=SetData',
				data:{"UserID":userId,"SSGroupID":ssgroupId,
		    	 	 "StartDateTime":startDT,"EndDateTime":endDT,
		      	 	 "Foreverban":foreverban},
				success: function (data) {
					if (data!="0")
        			{
	        			$.messager.alert('提示消息','提交成功!');
	        			$('#AuthorityData').datagrid('reload');
	        		}else
        			{
	        			$.messager.alert('提示信息','提交失败,有未选项!');
	        		}
	     		}
			});
		}else{
			$.messager.alert('提示信息','提交失败,有未选项!');
		}
	}	
}
//取消
function cancel()
{
	var seleRow = $('#AuthorityData').datagrid('getSelected');
    if (seleRow){
	    $.ajax({
		    type:"Post",
			url:'../web.eprajax.usercopypastepower.cls?Action=DeletData',
			data:{"RowId":seleRow.rowID},
			success: function (data) {
				if (data != "0")
        		{
	        		$.messager.alert('提示消息','取消成功!');
	        		$('#AuthorityData').datagrid('reload');
	        	}else{
		        	$.messager.alert('提示信息','取消失败,未选中取消行!');
		        }
		    }
		 });
	}
}

