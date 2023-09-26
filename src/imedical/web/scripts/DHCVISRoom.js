var init = function(){
	var maxWidth=$(window).width()||1366;    //获取当前宽度
	var maxHeight=$(window).height()||550;   //获取当前高度
	$("#panelTop").panel("resize",{width:maxWidth-10})
	
	var DHCVISRoomObj=$HUI.datagrid("#DHCVISRoom",{
		title:"房间数据列表",
	    width:maxWidth-10,
		height:maxHeight-150,
	    url:$URL+"?ClassName=web.DHCVISWarnQuery&QueryName=FindRoomInfo",
	    idField:'RowId',
		mode:'remote',
		delay:200,
		columns:[[
		    {field:'RowId',title:'RowId',width:90,hidden:true},
			{field:'RoomCode',title:'房间代码',width:200},
			{field:'RoomName',title:'房间名称',width:200},
			
		]],
		rownumbers:true,
		pagination:true,
		singleSelect:true,
		
		onClickRow:function(rowIndex,rowData){
			if (rowIndex>-1){
				$("#RowId").val(rowData.RowId);
				$("#RoomCode").val(rowData.RoomCode);
				$("#RoomName").val(rowData.RoomName);
				
				
				
			}
		}
		
		})
		$("#delete").click(function(){
		 		var RowId=$("#RowId").val();
		     $.m({
	    		ClassName:"web.DHCVISWarning",
	    		MethodName:"DeleteRoom",
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
		 //刷新
		$("#refresh").click(function(){

			location.reload();
		})
	 	$("#Update").click(function(){
		 	    var RowId=$("#RowId").val();
		 		var RoomCode=$("#RoomCode").val();
				var RoomName=$("#RoomName").val();
		     $.m({
	    		ClassName:"web.DHCVISWarning",
	    		MethodName:"UpdateRoom",
	    		RowId:RowId,
	    		RoomCode:RoomCode,
				RoomName:RoomName
	    
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
			$("#Add").click(function(){
		 		var RoomCode=$("#RoomCode").val();
				var RoomName=$("#RoomName").val();
		     $.m({
	    		ClassName:"web.DHCVISWarning",
	    		MethodName:"InsertRoom",
	    		RoomCode:RoomCode,
				RoomName:RoomName

	    
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
				QueryName:"FindRoomInfo",
				Name:""
				}
				DHCVISRoomObj.load(queryParams);
				
				
				}
			$("#Search").click(function(){
				var RoomName=$("#RoomName").val();
				var queryParams={
				ClassName:"web.DHCVISWarnQuery",
				QueryName:"FindRoomInfo",
				Name:RoomName
				}
				DHCVISRoomObj.load(queryParams);
			
			
			})
}
$(init);