var init = function(){
	var maxWidth=$(window).width()||1366;    //获取当前宽度
	var maxHeight=$(window).height()||550;   //获取当前高度
	$("#panelTop").panel("resize",{width:maxWidth-10})
	
	var DHCVISFloorObj=$HUI.datagrid("#DHCVISFloor",{
		title:"楼层数据列表",
	    width:maxWidth-10,
		height:maxHeight-150,
	    url:$URL+"?ClassName=web.DHCVISWarnQuery&QueryName=FindFloorInfo",
	    idField:'RowId',
		mode:'remote',
		delay:200,
		columns:[[
		    {field:'RowId',title:'RowId',width:90,hidden:true},
			{field:'FloorCode',title:'楼层代码',width:200},
			{field:'FloorName',title:'楼层名称',width:200},
			
		]],
		rownumbers:true,
		pagination:true,
		singleSelect:true,
		
		onClickRow:function(rowIndex,rowData){
			if (rowIndex>-1){
				$("#RowId").val(rowData.RowId);
				$("#FloorCode").val(rowData.FloorCode);
				$("#FloorName").val(rowData.FloorName);
				
				
				
			}
		}
		
		})
		$("#delete").click(function(){
		 		var RowId=$("#RowId").val();
		     $.m({
	    		ClassName:"web.DHCVISWarning",
	    		MethodName:"DeleteFloor",
	    		RowId:RowId

	    
	         },function(txtData){
		        if(txtData==0){
			        $.messager.alert("提示信息","删除成功");
			        searchList();
			    }else{   
				     $.messager.alert("提示信息",txtData);  
				     searchList(); 
				}     
	    
        	});
		 
		 
			})
	 	$("#Update").click(function(){
		 	    var RowId=$("#RowId").val();
		 		var FloorCode=$("#FloorCode").val();
				var FloorName=$("#FloorName").val();
		     $.m({
	    		ClassName:"web.DHCVISWarning",
	    		MethodName:"UpdateFloor",
	    		RowId:RowId,
	    		FloorCode:FloorCode,
				FloorName:FloorName
	    
	         },function(txtData){
		        if(txtData==0){
			        $.messager.alert("提示信息","修改成功！");
			        searchList();
			    }else{   
				     $.messager.alert("提示信息",txtData);
				     searchList();   
				}     
	    
        	});
		 
			})
			 //刷新
			$("#refresh").click(function(){

				location.reload();
			})
		
			$("#Add").click(function(){
		 		var FloorCode=$("#FloorCode").val();
				var FloorName=$("#FloorName").val();
		     $.m({
	    		ClassName:"web.DHCVISWarning",
	    		MethodName:"InsertFloor",
	    		FloorCode:FloorCode,
				FloorName:FloorName

	    
	         },function(txtData){
		        if(txtData==0){
			        $.messager.alert("提示信息","添加成功！");
			        searchList();
			    }else{   
				     $.messager.alert("提示信息",txtData); 
				     searchList()  
				}     
	    
        	});
		 
		 
			})
			function searchList(){
				$(".textbox").each(function(){
				$(this).val("");
				})
				var queryParams={
				ClassName:"web.DHCVISWarnQuery",
				QueryName:"FindFloorInfo",
				Name:""
				}
				DHCVISFloorObj.load(queryParams);
				
				
				}
			$("#Search").click(function(){
				var FloorName=$("#FloorName").val();
				var queryParams={
				ClassName:"web.DHCVISWarnQuery",
				QueryName:"FindFloorInfo",
				Name:FloorName
				}
				DHCVISFloorObj.load(queryParams);
			
			
			})
}
$(init);