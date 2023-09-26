var init = function(){
	var maxWidth=$(window).width()||1366;    //获取当前宽度
	var maxHeight=$(window).height()||550;   //获取当前高度
	$("#panelTop").panel("resize",{width:maxWidth-10})
	
	var DHCVISBuildObj=$HUI.datagrid("#DHCVISBuild",{
		title:"楼宇数据列表",
	    width:maxWidth-10,
		height:maxHeight-150,
	    url:$URL+"?ClassName=web.DHCVISWarnQuery&QueryName=FindBuildingInfo",
	    idField:'RowId',
		mode:'remote',
		delay:200,
		columns:[[
		    {field:'RowId',title:'RowId',width:90,hidden:true},
			{field:'BuildCode',title:'楼宇代码',width:200},
			{field:'BuildName',title:'楼宇名称',width:200},
			
		]],
		rownumbers:true,
		pagination:true,
		singleSelect:true,
		
		onClickRow:function(rowIndex,rowData){
			if (rowIndex>-1){
				$("#RowId").val(rowData.RowId);
				$("#BuildCode").val(rowData.BuildCode);
				$("#BuildName").val(rowData.BuildName);
				
				
				
			}
		}
		
		})
		$("#delete").click(function(){
		 		var RowId=$("#RowId").val();
		     $.m({
	    		ClassName:"web.DHCVISWarning",
	    		MethodName:"DeleteBuilding",
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
		 		var BuildCode=$("#BuildCode").val();
				var BuildName=$("#BuildName").val();
		     $.m({
	    		ClassName:"web.DHCVISWarning",
	    		MethodName:"UpdateBuilding",
	    		RowId:RowId,
	    		BuildCode:BuildCode,
				BuildName:BuildName
	    
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
		 		var BuildCode=$("#BuildCode").val();
				var BuildName=$("#BuildName").val();
		     $.m({
	    		ClassName:"web.DHCVISWarning",
	    		MethodName:"InsertBuilding",
	    		BuildCode:BuildCode,
				BuildName:BuildName

	    
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
				QueryName:"FindBuildingInfo",
				Name:""
				}
				DHCVISBuildObj.load(queryParams);
				
				
				}
			$("#Search").click(function(){
				var BuildName=$("#BuildName").val();
				var queryParams={
				ClassName:"web.DHCVISWarnQuery",
				QueryName:"FindBuildingInfo",
				Name:BuildName
				}
				DHCVISBuildObj.load(queryParams);
			
			
			})
}
$(init);