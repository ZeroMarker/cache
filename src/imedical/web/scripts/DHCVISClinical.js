var init = function(){
	var maxWidth=$(window).width()||1366;    //获取当前宽度
	var maxHeight=$(window).height()||550;   //获取当前高度
	$("#panelTop").panel("resize",{width:maxWidth-10})
	
	var DHCVISClinicalObj=$HUI.datagrid("#DHCVISClinical",{
		title:"诊区数据列表",
	    width:maxWidth-10,
		height:maxHeight-150,
	    url:$URL+"?ClassName=web.DHCVISWarnQuery&QueryName=FindClinicalInfo",
	    idField:'RowId',
		mode:'remote',
		delay:200,
		columns:[[
		    {field:'RowId',title:'RowId',width:90,hidden:true},
			{field:'ClinicalCode',title:'诊区代码',width:200},
			{field:'ClinicalName',title:'诊区名称',width:200},
			
		]],
		rownumbers:true,
		pagination:true,
		singleSelect:true,
		
		onClickRow:function(rowIndex,rowData){
			if (rowIndex>-1){
				$("#RowId").val(rowData.RowId);
				$("#ClinicalCode").val(rowData.ClinicalCode);
				$("#ClinicalName").val(rowData.ClinicalName);
				
				
				
			}
		}
		
		})
		$("#delete").click(function(){
		 		var RowId=$("#RowId").val();
		     $.m({
	    		ClassName:"web.DHCVISWarning",
	    		MethodName:"DeleteClinical",
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
		 		var ClinicalCode=$("#ClinicalCode").val();
				var ClinicalName=$("#ClinicalName").val();
		     $.m({
	    		ClassName:"web.DHCVISWarning",
	    		MethodName:"UpdateClinical",
	    		RowId:RowId,
	    		ClinicalCode:ClinicalCode,
				ClinicalName:ClinicalName
	    
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
		 		var ClinicalCode=$("#ClinicalCode").val();
				var ClinicalName=$("#ClinicalName").val();
		     $.m({
	    		ClassName:"web.DHCVISWarning",
	    		MethodName:"InsertClinical",
	    		ClinicalCode:ClinicalCode,
				ClinicalName:ClinicalName

	    
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
				QueryName:"FindClinicalInfo",
				Name:""
				}
				DHCVISClinicalObj.load(queryParams);
				
				
				}
			$("#Search").click(function(){
				var ClinicalName=$("#ClinicalName").val();
				var queryParams={
				ClassName:"web.DHCVISWarnQuery",
				QueryName:"FindClinicalInfo",
				Name:ClinicalName
				}
				DHCVISClinicalObj.load(queryParams);
			
			
			})
}
$(init);