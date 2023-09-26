var init = function(){
	var maxWidth=$(window).width()||1366;    //获取当前宽度
	var maxHeight=$(window).height()||550;   //获取当前高度
	$("#panelTop").panel("resize",{width:maxWidth-10})
	
	var TroomObj=$HUI.combogrid("#Troom",{
		panelWidth:230,
		panelHeight:400,
		url:$URL+"?ClassName=web.DHCExaBorough&QueryName=FindDHCExaRoom",
		mode:'remote',
		delay:200,
		idField:'rid',
		textField:'name',
		onBeforeLoad:function(param){
			param.typeDesc = param.q;
			
		},
		columns:[[
		    {field:'name',title:'name',width:130},
			{field:'rid',title:'rid',width:100}
			
		]],
		displayMsg:"",
		pagination:true
	});
	
	var DHCRoomCompObj=$HUI.datagrid("#DHCRoomComp",{
		title:"诊室计算机IP列表",
	    width:maxWidth-10,
		height:maxHeight-150,
	    url:$URL+"?ClassName=web.DHCExaBorough&QueryName=UFindDHCRoomComp",
	    idField:'Tid',
		mode:'remote',
		delay:200,
		columns:[[
		    {field:'Tid',title:'Tid',width:90,hidden:true},
			{field:'Tcode',title:'Tcode',width:120},
			{field:'Tname',title:'Tname',width:120},
			{field:'Tip',title:'Tip',width:120},
			{field:'Troom',title:'Troom',width:120},
			{field:'Troomid',title:'Troomid',width:90,hidden:true}
			
			
		]],
		rownumbers:true,
		pagination:true,
		singleSelect:true,
		
		onClickRow:function(rowIndex,rowData){
			if (rowIndex>-1){
				$("#Tid").val(rowData.Tid);
				$("#Tcode").val(rowData.Tcode);
				$("#Tname").val(rowData.Tname);
				$("#Tip").val(rowData.Tip);
				TroomObj.setValue(rowData.Troomid);
				TroomObj.setText(rowData.Troom);
				
				
				
			}
		}
		
		})
		$("#delete").click(function(){
		 		var Tid=$("#Tid").val();
		     $.m({
	    		ClassName:"web.DHCExaBorough",
	    		MethodName:"delRoomCompHISUI",
	    		itmjs:"",
	    		itmjsex:"",
	    		rid:Tid

	    
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
		 	    var Tid=$("#Tid").val();
		 		var Tcode=$("#Tcode").val();
				var Tname=$("#Tname").val();
				var Tip=$("#Tip").val();
		        var Troomid=TroomObj.getValue();
		     $.m({
	    		ClassName:"web.DHCExaBorough",
	    		MethodName:"updateRoomCompHISUI",
	    		itmjs:"",
	    		itmjsex:"",
	    		code:Tcode,
	    		name:Tname,
	    		ip:Tip,
	    		roomdr:Troomid,
	    		rowid:Tid

	    
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
		 		var Tcode=$("#Tcode").val();
				var Tname=$("#Tname").val();
				var Tip=$("#Tip").val();
		        var Troomid=TroomObj.getValue();
		 
		     $.m({
	    		ClassName:"web.DHCExaBorough",
	    		MethodName:"insertRoomCompHISUI",
	    		itmjs:"",
	    		itmjsex:"",
	    		code:Tcode,
	    		name:Tname,
	    		ip:Tip,
	    		roomdr:Troomid

	    
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
				TroomObj.setValue();
				TroomObj.setText();
				var queryParams={
				ClassName:"web.DHCExaBorough",
				QueryName:"UFindDHCRoomComp",
				roomid:""
				}
				DHCRoomCompObj.load(queryParams);
				
				
				}
			$("#Search").click(function(){
				var Tcode=$("#Tcode").val();
				var Tname=$("#Tname").val();
				var Tip=$("#Tip").val();
		        var Troomid=TroomObj.getValue();
				var queryParams={
				ClassName:"web.DHCExaBorough",
				QueryName:"UFindDHCRoomComp",
				roomid:Troomid
				}
				DHCRoomCompObj.load(queryParams);
			
			
			})
}
$(init);