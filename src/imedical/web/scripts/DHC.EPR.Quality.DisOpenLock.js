$(function(){
	$("#User").hide();
	$('#AllLock').attr("checked",true);
	$('#seekform').find(':radio').change(function(){
		if (this.id == "Period"){
			$("#User").show();
		    }else{
			$("#User").hide();
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
			url:'../web.eprajax.lockpatiet.cls?Action=GetDataList',
			singleSelect:true,
			idField:'rowID', 
			rownumbers:true,
			fit:true,
			columns:[[
			    {field:'rowID',title:'RowID',hidden:true},  
				{field:'Name',title:'患者姓名',width:80},
				{field:'UserName',title:'封锁操作用户',width:80},
				{field:'StartDate',title:'封锁日期',width:100},
				{field:'IsUnLockUserName',title:'有权限医生',width:100},
				{field:'AllLock',title:'是否全部用户封锁',width:100},
				{field:'IsLock',title:'有无权限',width:120}
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
		url:'../web.eprajax.lockpatiet.cls?Action=GetCTLocID&Type=E',
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
		url:'../web.eprajax.lockpatiet.cls?Action=GetUserID&LocId='+locId 
    });
}



//取消
function cancel()
{
	if($("input[name='Auth']:checked").val()==0){
	var userId=$("#UserID").combobox('getValue');
	var seleRow = $('#AuthorityData').datagrid('getSelected');
    if (seleRow){
	    $.ajax({
		    type:"Post",
			url:'../web.eprajax.lockpatiet.cls?Action=SetData',
			data:{"IsUnLockUserID":userId,"EpisodeID":seleRow.EpisodeID,
			"UserID":seleRow.UserID,"AllLock":"0"
			},
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
	else if($("input[name='Auth']:checked").val()==1)
	{
		
		var seleRow = $('#AuthorityData').datagrid('getSelected');
		alert(seleRow.rowID);
	    if (seleRow){
		    $.ajax({
			    type:"Post",
				url:'../web.eprajax.lockpatiet.cls?Action=DeletData',
				data:{"RowId":seleRow.rowID},
				success: function (data) {
					if (data != "0")
	        		{
		        		$.messager.alert('提示消息','解除成功!');
		        		$('#AuthorityData').datagrid('reload');
		        	}else{
			        	$.messager.alert('提示信息','解除失败,未选中取消行!');
			        }
			    }
			 });
	}
	}	
	
}

