var init = function(){
	var maxWidth=$(window).width()||1366;    //获取当前宽度
	var maxHeight=$(window).height()||550;   //获取当前高度
	$("#panelTop").panel("resize",{width:maxWidth-10})
	//选择服务器
	var ServerObj = $HUI.combogrid("#ServerName",{
		panelWidth:500,
		panelHeight:400,
		//url:$URL+"?ClassName=web.DHCVISVoiceSet&QueryName=LookUpServer",
		url:$URL,
		queryParams:{
			ClassName:"web.DHCVISVoiceSet",
			QueryName:"LookUpServer",
			txtServerName:""
		},
		mode:'remote',
		delay:200,
		idField:'ServerId',
		textField:'ServerName',
		onBeforeLoad:function(param){
			param.txtServerName = param.q;
		},
		columns:[[
			{field:'ServerName',title:'服务器名称',width:100},
			{field:'ServerIP',title:'服务器IP',width:100},
			{field:'ServerId',title:'服务器ID',width:100}
			
		]],
		pagination:true
	});
	
	//选择药房窗口
	var PharmacyObj = $HUI.combogrid("#ClientLinkRoom",{
		panelWidth:400,
		panelHeight:400,
		url:$URL+"?ClassName=web.DHCVISPharmacy&QueryName=FindWindow",
		mode:'remote',
		delay:200,
		idField:'TWinId',
		textField:'TWinDesc',
		onBeforeLoad:function(param){
			param.txtCTLocId = param.q;
		},
		columns:[[
			{field:'TLocDesc',title:'LocDesc',width:120},
			{field:'TLocId',title:'LocId',width:90},
			{field:'TWinDesc',title:'WinDesc',width:90},
			{field:'TWinId',title:'WinId',width:90}
			
		]],
		displayMsg:"",
		pagination:true
	});
	
	//debugger; 调试断点
	//选择科室
	var DeptObj = $HUI.combogrid("#ClientLinkDoc",{
		panelWidth:300,
		panelHeight:400,
		url:$URL+"?ClassName=web.DHCVISVoiceSet&QueryName=DeptList",
		mode:'remote',
		delay:200,
		idField:'CTRowId',
		textField:'CTDesc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			
		},
		columns:[[
			{field:'CTRowId',title:'科室ID',width:90},
			{field:'CTDesc',title:'科室',width:130}
			
		]],
		displayMsg:"",
		pagination:true
	});
	//关联队列类型
	var ClientNoteObj = $HUI.combogrid("#ClientNote",{
		panelWidth:300,
		panelHeight:400,
		url:$URL+"?ClassName=web.DHCVISLinkQueueType&QueryName=FindQueueType",
		mode:'remote',
		delay:200,
		idField:'TypeId',
		textField:'TypeDesc',
		onBeforeLoad:function(param){
			param.typeDesc = param.q;
			
		},
		columns:[[
		    
		    {field:'TypeId',title:'TypeId',width:50},
			{field:'TypeDesc',title:'TypeDesc',width:90},
			{field:'TypeCode',title:'TypeCode',width:90},
			{field:'ActiveFlag',title:'ActiveFlag',width:50}
			
		]],
		displayMsg:"",
		pagination:true
	});
	
	
	var ClientListObj = $HUI.datagrid("#DHCVISVoiceClient",{
		
		title:"客户端信息",
		width:maxWidth-10,
		height:maxHeight-260,
		mode:'remote',
		delay:200,
		idField:'ClientId',
		url:$URL,
		queryParams:{
			ClassName:"web.DHCVISVoiceSet",
			QueryName:"LookUpClient"	
		},
	   columns:[[
			{field:'ClientId',title:'LocDesc',width:90,hidden:true},
			{field:'ClientIP',title:'IP地址',width:120},
			{field:'ClientName',title:'诊室名称',width:90},
			{field:'ServerId',title:'ServerId',width:90,hidden:true},
			{field:'ServerName',title:'服务器',width:120},
			{field:'ClientLinkRoom',title:'药房窗口',width:90},
			{field:'ClientLinkRoomId',title:'ClientLinkRoomId',width:90,hidden:true},
			{field:'ClientLinkDoc',title:'关联科室',width:90},
			{field:'ClientLinkDocId',title:'ClientLinkDocId',width:90,hidden:true},
			{field:'ClientNote',title:'ClientNote',width:90},
			{field:'ClientNoteId',title:'ClientNoteId',width:90,hidden:true},
			{field:'ClientVoiceTopIP',title:'声音终端IP',width:90},
			{field:'ClientTopIP',title:'诊室终端IP',width:90},
			{field:'ClientTopDesc',title:'终端标题',width:90},
			{field:'ClientPortNo',title:'端口',width:40},
			{field:'ClientScreenNo',title:'屏号',width:40},
			{field:'ClientScreenColorNo',title:'屏号颜色',width:90},
			{field:'ClientShowMode',title:'显示模式',width:90},
			{field:'ClientShowSpeed',title:'显示速度',width:90},
			{field:'ClientShowTime',title:'显示时间',width:90},
			{field:'ExaBoroughId',title:'ExaBoroughId',width:90},
			{field:'LocTopIP',title:'科室IP',width:90},
			{field:'LocTopDesc',title:'科室标题',width:90}	
			
		]],
		rownumbers:true,
		pagination:true,
		singleSelect:true,
		
		onClickRow:function(rowIndex,rowData){
			if (rowIndex>-1){
				
		        $("#ClientIP").val(rowData.ClientIP);
		        $("#ClientName").val(rowData.ClientName);
		        ServerObj.setValue(rowData.ServerId);
		        ServerObj.setText(rowData.ServerName);
		        PharmacyObj.setValue(rowData.ClientLinkRoomId);
		        PharmacyObj.setText(rowData.ClientLinkRoom);
		        DeptObj.setValue(rowData.ClientLinkDocId);
		        DeptObj.setText(rowData.ClientLinkDoc);
		        ClientNoteObj.setValue(rowData.ClientNoteId);
		        ClientNoteObj.setText(rowData.ClientNote);
		        $("#ClientVoiceTopIP").val(rowData.ClientVoiceTopIP);
		        $("#ClientTopIP").val(rowData.ClientTopIP);
		        $("#ClientTopDesc").val(rowData.ClientTopDesc);
		        $("#ClientPortNo").val(rowData.ClientPortNo);
		        $("#ClientScreenNo").val(rowData.ClientScreenNo);
		        $("#ClientScreenColorNo").val(rowData.ClientScreenColorNo);
		        $("#ClientShowMode").val(rowData.ClientShowMode);
		        $("#ClientShowSpeed").val(rowData.ClientShowSpeed);
		        $("#ClientShowTime").val(rowData.ClientShowTime);
		        //$("#ExaBoroughId").val(rowData.ExaBoroughId);
		        $("#LocTopIP").val(rowData.LocTopIP);
		        $("#LocTopDesc").val(rowData.LocTopDesc);
		        $("#ClientID").val(rowData.ClientId);
				
				
				
				
			}
		}
	
	});
	//删除
	$("#delete").click(function(){
		var ClientId=$("#ClientID").val();
		$.m({
	    ClassName:"web.DHCVISVoiceSet",
	    MethodName:"ClientDelete",
	    ClientId:ClientId
	    
         },function(txtData){
	        if(txtData==0){
		        $.messager.alert("提示信息","删除成功！");
		        $("#refresh").click();
		        $("#Search").click();
		    }else{   
			     $.messager.alert("提示信息",txtData);   
			}     
	    
        });
		
		})
	//刷新
	$("#refresh").click(function(){
		$(".textbox").each(function(){
			$(this).val("");
			})
		ServerObj.setValue("");
		ServerObj.setText("");
		PharmacyObj.setValue("");
		PharmacyObj.setText("");
		DeptObj.setValue("");
		DeptObj.setText("");
		ClientNoteObj.setValue("");
		ClientNoteObj.setText("");
		
		})
	//更新
	$("#Update").click(function(){
		var ClientId=$("#ClientID").val();
		var ClientIP=$("#ClientIP").val();
		var ClientName=$("#ClientName").val();
		var ServerId=ServerObj.getValue();
		var ClientLinkRoomId=PharmacyObj.getValue();
		var ClientLinkDocId=DeptObj.getValue();
		var ClientNote=ClientNoteObj.getValue();
		var ClientVoiceTopIP=$("#ClientVoiceTopIP").val();
		var ClientTopIP=$("#ClientTopIP").val();
		var ClientTopDesc=$("#ClientTopDesc").val();
		var ClientPortNo=$("#ClientPortNo").val();
		var ClientScreenNo=$("#ClientScreenNo").val();
		var ClientScreenColorNo=$("#ClientScreenColorNo").val();
		var ClientShowMode=$("#ClientShowMode").val();
		var ClientShowSpeed=$("#ClientShowSpeed").val();
		var ClientShowTime=$("#ClientShowTime").val();
		var ExaBoroughId=$("#ExaBoroughId").val();
		var LocTopIP=$("#LocTopIP").val();
		var LocTopDesc=$("#LocTopDesc").val();
	    
		$.m({
	    ClassName:"web.DHCVISVoiceSet",
	    MethodName:"ClientUpdate",
	    ClientId:ClientId,
	    ClientIP:ClientIP,
	    ClientName:ClientName,
	    ServerId:ServerId,
	    ClientPortNo:ClientPortNo,
	    ClientScreenNo:ClientScreenNo,
	    ClientScreenColorNo:ClientScreenColorNo,
	    ClientShowMode:ClientShowMode,
		ClientShowSpeed:ClientShowSpeed,
	    ClientShowTime:ClientShowTime,
	    ClientLinkRoomId:ClientLinkRoomId,
	    ClientLinkDocId:ClientLinkDocId,
	    ClientNote:ClientNote,
	    ClientTopIP:ClientTopIP,
	    ClientTopDesc:ClientTopDesc,
	    LocTopIP:LocTopIP,
	    LocTopDesc:LocTopDesc,
	    ClientVoiceTopIP:ClientVoiceTopIP
	    
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
		var ClientIP=$("#ClientIP").val();
		var ClientName=$("#ClientName").val();
		var ServerId=ServerObj.getValue();
		var ClientLinkRoomId=PharmacyObj.getValue();
		var ClientLinkDocId=DeptObj.getValue();
		var ClientNote=ClientNoteObj.getValue();
		var ClientVoiceTopIP=$("#ClientVoiceTopIP").val();
		var ClientTopIP=$("#ClientTopIP").val();
		var ClientTopDesc=$("#ClientTopDesc").val();
		var ClientPortNo=$("#ClientPortNo").val();
		var ClientScreenNo=$("#ClientScreenNo").val();
		var ClientScreenColorNo=$("#ClientScreenColorNo").val();
		var ClientShowMode=$("#ClientShowMode").val();
		var ClientShowSpeed=$("#ClientShowSpeed").val();
		var ClientShowTime=$("#ClientShowTime").val();
		var ExaBoroughId=$("#ExaBoroughId").val();
		var LocTopIP=$("#LocTopIP").val();
		var LocTopDesc=$("#LocTopDesc").val();
	    
		$.m({
	    ClassName:"web.DHCVISVoiceSet",
	    MethodName:"ClientInsert",
	    ClientIP:ClientIP,
	    ClientName:ClientName,
	    ServerId:ServerId,
	    ClientPortNo:ClientPortNo,
	    ClientScreenNo:ClientScreenNo,
	    ClientScreenColorNo:ClientScreenColorNo,
	    ClientShowMode:ClientShowMode,
	    ClientShowTime:ClientShowTime,
	    ClientLinkRoomId:ClientLinkRoomId,
	    ClientLinkDocId:ClientLinkDocId,
	    ClientNote:ClientNote,
	    ClientTopIP:ClientTopIP,
	    ClientTopDesc:ClientTopDesc,
	    LocTopIP:LocTopIP,
	    LocTopDesc:LocTopDesc,
	    ClientVoiceTopIP:ClientVoiceTopIP
	    
         },function(txtData){
	        if(txtData==0){
		        $.messager.alert("提示信息","添加成功！");
		        $("#Search").click();
		    }else{   
			     $.messager.alert("提示信息",txtData);   
			}     
	    
        });
		})
	//查询
	$("#Search").click(function(){
		var ClientName=$("#ClientName").val();
		var ClientIP=$("#ClientIP").val();
		var ServerId=ServerObj.getValue();
		var ClientTopIP=$("#ClientTopIP").val();
		var queryParams={
			ClassName:"web.DHCVISVoiceSet",
			QueryName:"LookUpClient",
			txtClientName:ClientName,
			txtServerId:ServerId,
			txtClientIP:ClientIP,
			txtClientTopIP:ClientTopIP	
		}
		ClientListObj.load(queryParams);
	
		
		})	
	
};
$(init);