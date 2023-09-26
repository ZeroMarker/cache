var init = function(){
	var maxWidth=$(window).width()||1366;    //获取当前宽度
	var maxHeight=$(window).height()||750;   //获取当前高度
	$("#panelTop").panel("resize",{width:maxWidth-10})
	
	
	var QueueLinkObj = $HUI.datagrid("#DHCVISQueueLinkType",{
		
		title:"关联队列类型列表",
		width:maxWidth-10,
		height:maxHeight-160,
		mode:'remote',
		delay:200,
		idField:'TypeId',
		url:$URL,
		queryParams:{
			ClassName:"web.DHCVISLinkQueueType",
			QueryName:"FindQueueType"	
		},
		//TypeId,TypeCode,TypeDesc,TypeNote,ActiveFlag
	   columns:[[
			{field:'TypeId',title:'TypeId',width:90,hidden:true},
			{field:'TypeCode',title:'类型代码',width:160},
			{field:'TypeDesc',title:'类型名称',width:160},
			{field:'TypeNote',title:'类型备注',width:160},
			{field:'ActiveFlag',title:'启用',width:160}
			
			
		]],
		rownumbers:true,
		pagination:true,
		singleSelect:true,
		
		onClickRow:function(rowIndex,rowData){
			if (rowIndex>-1){
				
		        $("#TypeId").val(rowData.TypeId);
		        $("#TypeCode").val(rowData.TypeCode);
		        $("#TypeDesc").val(rowData.TypeDesc);
		        $("#TypeNote").val(rowData.TypeNote);
		        $("#ActiveFlag").val(rowData.ActiveFlag);
		         if(rowData.ActiveFlag=="Y"){
			        //$("#ServerActive").checkbox('check');
			        $HUI.checkbox("#ActiveFlag").check();
			     }
			     else{
				     $HUI.checkbox("#ActiveFlag").uncheck();   
				 }
		
			}
		}
	
	});
	//删除
	$("#delete").click(function(){
		var TypeId=$("#TypeId").val();
		if(TypeId==""){
			$.messager.alert("提示信息","请选择需要更新的记录操作");
			return false;
		}
		$.m({
	    ClassName:"web.DHCVISLinkQueueType",
	    MethodName:"DeleteLinkQueueType",
	    typeId:TypeId
	    
         },function(txtData){
	        if(txtData==0){
		        $.messager.alert("提示信息","删除成功！");
		        //$("#refresh").click();
		        clearData();
		        $("#Search").click();
		    }else{   
			     $.messager.alert("提示信息",txtData);   
			}     
	    
        });
		
		})
	//清除数据
	function clearData(){
		$(".textbox").each(function(){
			$(this).val("");
		})
		$HUI.checkbox("#ActiveFlag").uncheck();
		
	}
	//更新
	$("#Update").click(function(){
		var TypeId=$("#TypeId").val();
		if(TypeId==""){
			$.messager.alert("提示信息","请选择需要更新的记录操作");
			return false;
		}
		if($HUI.checkbox("#ActiveFlag").getValue()){
			  var ActiveFlag="Y";
		}
		else{
			  var ActiveFlag="N";   
		}   
		
		var TypeCode=$("#TypeCode").val();
		var TypeDesc=$("#TypeDesc").val();
		var TypeNote=$("#TypeNote").val();
		
	    
		$.m({
	    ClassName:"web.DHCVISLinkQueueType",
	    MethodName:"SaveLinkQueueType",
	    typeId:TypeId,
	    typeCode:TypeCode,
	    typeDesc:TypeDesc,
	    typeNote:TypeNote,
	    activeFlag:ActiveFlag
	    
	    
         },function(txtData){
	        if(txtData==0){
		        $.messager.alert("提示信息","更新成功！");
		        $("#Search").click();
		    }else{   
			     $.messager.alert("提示信息",txtData);   
			}     
	    
        });
		})
	//增加
	$("#Add").click(function(){
		var TypeId="";
		
		if($HUI.checkbox("#ActiveFlag").getValue()){
			  var ActiveFlag="Y";
		}
		else{
			  var ActiveFlag="N";   
		}   
		
		var TypeCode=$("#TypeCode").val();
		var TypeDesc=$("#TypeDesc").val();
		var TypeNote=$("#TypeNote").val();
	    
		$.m({
	    ClassName:"web.DHCVISLinkQueueType",
	    MethodName:"SaveLinkQueueType",
	    typeId:TypeId,
	    typeCode:TypeCode,
	    typeDesc:TypeDesc,
	    typeNote:TypeNote,
	    activeFlag:ActiveFlag
	    
         },function(txtData){
	        if(txtData==0){
		        $.messager.alert("提示信息","添加成功！");
		        clearData();
		        $("#Search").click();
		    }else{   
			     $.messager.alert("提示信息",txtData);   
			}     
	    
        });
		})
	//查询
	$("#Search").click(function(){
		var TypeCode=$("#TypeCode").val();
		var TypeDesc=$("#TypeDesc").val();
		var TypeNote=$("#TypeNote").val();
		var queryParams={
			ClassName:"web.DHCVISLinkQueueType",
			QueryName:"FindQueueType",
			typeCode:TypeCode,
	    	typeDesc:TypeDesc,
	    	typeNote:TypeNote
		}
		QueueLinkObj.load(queryParams);
	
		
		})	
	
};
$(init);