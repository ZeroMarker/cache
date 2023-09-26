var init = function(){
	var maxWidth=$(window).width()||1366;    //获取当前宽度
	var maxHeight=$(window).height()||550;   //获取当前高度
	$("#panelTop").panel("resize",{width:maxWidth-10})
	//debugger; 调试断点
	//选择科室
	var DeptObj = $HUI.combogrid("#ServerLinkLoc",{
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
	//诊区
	var ExaBoroughObj = $HUI.combogrid("#ServerLinkOtherLoc",{
		panelWidth:300,
		panelHeight:400,
		url:$URL+"?ClassName=web.DHCVISVoiceSet&QueryName=FindExaBorough",
		mode:'remote',
		delay:200,
		idField:'Tid',
		textField:'Tname',
		onBeforeLoad:function(param){
			param.code = param.q;
			
		},
		columns:[[
		    {field:'Tid',title:'Tid',width:50},
		    {field:'Tcode',title:'Tcode',width:50},
			{field:'Tname',title:'Tname',width:130}
			
		]],
		displayMsg:"",
		pagination:true
	});
	
	var ServerListObj = $HUI.datagrid("#DHCVISVoiceServer",{
		
		title:"服务器信息",
		width:maxWidth-10,
		height:maxHeight-200,
		mode:'remote',
		delay:200,
		idField:'ServerId',
		url:$URL,
		queryParams:{
			ClassName:"web.DHCVISVoiceSet",
			QueryName:"LookUpServer"	
		},
		//
	   columns:[[
			{field:'ServerId',title:'ServerId',width:90,hidden:true},
			{field:'ServerIP',title:'IP地址',width:120},
			{field:'ServerName',title:'名称',width:100},
			{field:'ServerLinkLoc',title:'诊区',width:50},
			{field:'ServerLinkLocId',title:'LinkLocId',width:120,hidden:true},
			{field:'ServerLinkOtherLoc',title:'科室',width:50},
			{field:'ServerNote',title:'备注',width:40},
			{field:'ServerActive',title:'是否可用',width:70},
			{field:'ServerPortNo',title:'端口',width:40},
			{field:'ServerScreenNo',title:'屏号',width:40},
			{field:'ServerScreenColorNo',title:'屏颜色编号',width:90},
			{field:'ServerTopIP',title:'终端IP',width:70},
			{field:'ServerTopDesc',title:'终端标题',width:70},
			{field:'ServerState',title:'状态',width:40},
			{field:'ServerVoiceTopIP',title:'声音终端IP',width:90},
			{field:'ServerLinkOtherLocId',title:'OtherLocId',width:40,hidden:true},
			{field:'ServerAutoUpdate',title:'自动更新',width:70},
			{field:'Notification',title:'通知消息',width:70},
			{field:'ServerSuper',title:'超级服务',width:70}
			//{field:'WaitPaitList',title:'病人列表',width:70}
			
		]],
		rownumbers:true,
		pagination:true,
		singleSelect:true,
		
		onClickRow:function(rowIndex,rowData){
			if (rowIndex>-1){
				
		        $("#ServerId").val(rowData.ServerId);
		        $("#ServerIP").val(rowData.ServerIP);
		        $("#ServerName").val(rowData.ServerName);
		        $("#ServerNote").val(rowData.ServerNote);
		        if(rowData.ServerActive=="Y"){
			        //$("#ServerActive").checkbox('check');
			        $HUI.checkbox("#ServerActive").check();
			     }
			     else{
				     $HUI.checkbox("#ServerActive").uncheck();   
				 }
		      
		        $("#ServerPortNo").val(rowData.ServerPortNo);
		        $("#ServerScreenNo").val(rowData.ServerScreenNo);
		        $("#ServerScreenColorNo").val(rowData.ServerScreenColorNo);
		        $("#ServerTopIP").val(rowData.ServerTopIP);
		        $("#ServerTopDesc").val(rowData.ServerTopDesc);
		        $("#ServerState").val(rowData.ServerState);
		        $("#ServerVoiceTopIP").val(rowData.ServerVoiceTopIP);
		        //自动更新
		        if(rowData.ServerAutoUpdate=="Y"){
			        //$("#ServerActive").checkbox('check');
			        $HUI.checkbox("#ServerAutoUpdate").check();
			     }
			     else{
				     $HUI.checkbox("#ServerAutoUpdate").uncheck();   
				 }
				//超级服务
				if(rowData.ServerSuper=="Y"){
			        //$("#ServerActive").checkbox('check');
			        $HUI.checkbox("#ServerSuper").check();
			     }
			    else{
				     $HUI.checkbox("#ServerSuper").uncheck();   
				 }
		        $("#Notification").val(rowData.Notification);
		        $("#WaitPaitList").val(rowData.WaitPaitList);
		        
		        DeptObj.setValue(rowData.ServerLinkOtherLocId);
		        DeptObj.setText(rowData.ServerLinkOtherLoc);
		        ExaBoroughObj.setValue(rowData.ServerLinkLocId);
		        ExaBoroughObj.setText(rowData.ServerLinkLoc);
				
			}
		}
	
	});
	//删除
	$("#delete").click(function(){
		var ServerId=$("#ServerId").val();
		$.m({
	    ClassName:"web.DHCVISVoiceSet",
	    MethodName:"ServerDelete",
	    ServerId:ServerId
	    
         },function(txtData){
	        if(txtData=="0"){
		        $.messager.alert("提示信息","删除成功！");
		        ClaerDom();
		        $("#Search").click();
		        return;
		    }else{   
			     $.messager.alert("提示信息",txtData); 
			     return;  
			}     
	    
        });
		
		})
		
	function ClaerDom(){
		$(".textbox").each(function(){
			$(this).val("");
			})
		$HUI.checkbox("#ServerActive").uncheck();
		$HUI.checkbox("#ServerAutoUpdate").uncheck();
		$HUI.checkbox("#ServerSuper").uncheck();
		DeptObj.setValue("");
		DeptObj.setText("");
		ExaBoroughObj.setValue("");
		ExaBoroughObj.setText("");
		
		
		}
	//刷新
	$("#btnClear").click(function(){
		$(".textbox").each(function(){
			$(this).val("");
			})
		$HUI.checkbox("#ServerActive").uncheck();
		$HUI.checkbox("#ServerAutoUpdate").uncheck();
		$HUI.checkbox("#ServerSuper").uncheck();
		DeptObj.setValue("");
		DeptObj.setText("");
		ExaBoroughObj.setValue("");
		ExaBoroughObj.setText("");
		location.reload();
		//$(init);
		
		
		})
	//更新
	$("#Update").click(function(){
		var ServerId=$("#ServerId").val();
		var ServerIP=$("#ServerIP").val();
		var ServerName=$("#ServerName").val();
		var ServerNote=$("#ServerNote").val();
		var ServerPortNo=$("#ServerPortNo").val();  
		var ServerScreenNo=$("#ServerScreenNo").val();
		var ServerScreenColorNo=$("#ServerScreenColorNo").val();
	    var ServerTopIP=$("#ServerTopIP").val();
		var ServerTopDesc=$("#ServerTopDesc").val();
		var ServerState=$("#ServerState").val();
		var ServerVoiceTopIP=$("#ServerVoiceTopIP").val();      
		var Notification=$("#Notification").val();
		if($HUI.checkbox("#ServerActive").getValue()){
			  var ServerActive="Y";
		}
		else{
			  var ServerActive="N";   
		}   
		if($HUI.checkbox("#ServerAutoUpdate").getValue()){
			  var ServerAutoUpdate="Y";
		}
		else{
			  var ServerAutoUpdate="N";   
		}   
		if($HUI.checkbox("#ServerSuper").getValue()){
			  var ServerSuper="Y";
		}
		else{
			  var ServerSuper="N";   
		}   
		ServerLinkLocId=ExaBoroughObj.getValue();
		ServerLinkOtherLocId=DeptObj.getValue();
	    
		$.m({
	    ClassName:"web.DHCVISVoiceSet",
	    MethodName:"ServerUpdate",
	    ServerId:ServerId,
	    ServerIP:ServerIP,
	    ServerName:ServerName,
	    ServerActive:ServerActive,
	    ServerPortNo:ServerPortNo,
	    ServerScreenNo:ServerScreenNo,
	    ServerScreenColorNo:ServerScreenColorNo,
	    ServerLinkLocId:ServerLinkLocId,
	    ServerLinkOtherLoc:ServerLinkOtherLocId,
	    ServerNote:ServerNote,
	    UserId:session['LOGON.USERID'],
	    ServerTopIP:ServerTopIP,
	    ServerTopDesc:ServerTopDesc,
	    ServerVoiceTopIP:ServerVoiceTopIP,
	    ServerSuper:ServerSuper,
	    ServerAutoUpdate:ServerAutoUpdate,
	    Notification:Notification,
	    WaitPaitList:""
	    
         },function(txtData){
	        if(txtData=="0"){
		        $.messager.alert("提示信息","更新成功！");
		        $("#Search").click();
		        return false;
		    }else{   
			     $.messager.alert("提示信息",txtData);   
			     return false;
			}     
	    
        });
		})
	//增加
	$("#Add").click(function(){
		var ServerIP=$("#ServerIP").val();
		var ServerName=$("#ServerName").val();
		var ServerNote=$("#ServerNote").val();
		var ServerPortNo=$("#ServerPortNo").val();  
		var ServerScreenNo=$("#ServerScreenNo").val();
		var ServerScreenColorNo=$("#ServerScreenColorNo").val();
	    var ServerTopIP=$("#ServerTopIP").val();
		var ServerTopDesc=$("#ServerTopDesc").val();
		var ServerState=$("#ServerState").val();
		var ServerVoiceTopIP=$("#ServerVoiceTopIP").val();      
		var Notification=$("#Notification").val();
		if($HUI.checkbox("#ServerActive").getValue()){
			  var ServerActive="Y";
		}
		else{
			  var ServerActive="N";   
		}   
		if($HUI.checkbox("#ServerAutoUpdate").getValue()){
			  var ServerAutoUpdate="Y";
		}
		else{
			  var ServerAutoUpdate="N";   
		}   
		if($HUI.checkbox("#ServerSuper").getValue()){
			  var ServerSuper="Y";
		}
		else{
			  var ServerSuper="N";   
		}   
		ServerLinkLocId=ExaBoroughObj.getValue();
		ServerLinkOtherLocId=DeptObj.getValue();
	    
		$.m({
	    ClassName:"web.DHCVISVoiceSet",
	    MethodName:"ServerInsert",
	    ServerIP:ServerIP,
	    ServerName:ServerName,
	    ServerActive:ServerActive,
	    ServerPortNo:ServerPortNo,
	    ServerScreenNo:ServerScreenNo,
	    ServerScreenColorNo:ServerScreenColorNo,
	    ServerLinkLocId:ServerLinkLocId,
	    ServerLinkOtherLoc:ServerLinkOtherLocId,
	    ServerNote:ServerNote,
	    UserId:session['LOGON.USERID'],
	    ServerTopIP:ServerTopIP,
	    ServerTopDesc:ServerTopDesc,
	    ServerVoiceTopIP:ServerVoiceTopIP,
	    ServerSuper:ServerSuper,
	    ServerAutoUpdate:ServerAutoUpdate,
	    Notification:Notification,
	    WaitPaitList:""
	    
         },function(txtData){
	        if(txtData=="0"){
		        $.messager.alert("提示信息","添加成功！");
		        $("#Search").click();
		        return false;
		    }else{   
			     $.messager.alert("提示信息",txtData);  
			     return false; 
			}     
	    
        });
		})
	//查询
	$("#Search").click(function(){
		var ServerName=$("#ServerName").val();
		var ServerIP=$("#ServerIP").val();
		var ServerTopIP=$("#ServerTopIP").val();
		var queryParams={
			ClassName:"web.DHCVISVoiceSet",
			QueryName:"LookUpServer",
			txtServerName:ServerName,
			txtServerIP:ServerIP,
			txtServerTopIP:ServerTopIP,	
		}
		ServerListObj.load(queryParams);
	
		
		})	
		
function VerifyHandler()
{
	var RemoteIP=""
	var SendExecLine="VerifyVersion"     //验证更新程序
	var obj=document.getElementById("txtServerIP");
	if(obj) RemoteIP=obj.value;
	if((RemoteIP!="")&&(RemoteIP!=" "))
	{
		var element=document.getElementById("Layer");
		var Obj= new ActiveXObject("SockActive.ClsSock")
		Obj.RemotePort=5257
		Obj.RemoteHost=RemoteIP;
		Obj.SendData=SendExecLine
		Obj.Send()
		Obj=null
		alert("指令发送成功,程序的更新将在30秒内完成!")
	}
	else
	{
		alert("请选择服务地址!")
	}
}
$("#btnUploadLog").click(function(){
	UploadLogHandler();
	
})

function UploadLogHandler()
{
	var RemoteIP=""
	var SendExecLine="UploadLog"         //上传日志
	var obj=document.getElementById("txtServerIP");
	if(obj) RemoteIP=obj.value;
	if((RemoteIP!="")&&(RemoteIP!=" "))
	{
		var element=document.getElementById("Layer");
		var Obj= new ActiveXObject("SockActive.ClsSock")
		Obj.RemotePort=5257
		Obj.RemoteHost=RemoteIP;
		Obj.SendData=SendExecLine
		Obj.Send()
		Obj=null
		alert("请等候五秒到服务器指定目录查看!")
	}
	else
	{
		alert("请选择服务地址!")
	}
}
function PrtSCHandler()
{
	var RemoteIP=""
	var SendExecLine="PrtSc"               //抓屏
	//var SendExecLine="VerifyVersion"     //验证更新程序
	//var SendExecLine="UploadLog"         //上传日志
	var obj=document.getElementById("txtServerIP");
	if(obj) RemoteIP=obj.value;
	if((RemoteIP!="")&&(RemoteIP!=" "))
	{
		var element=document.getElementById("Layer");
		var Obj= new ActiveXObject("SockActive.ClsSock")
		Obj.RemotePort=5257
		Obj.RemoteHost=RemoteIP;
		Obj.SendData=SendExecLine
		Obj.Send()
		Obj=null
	}
	else
	{
		alert("请选择要抓图的服务地址!")
	}
	setTimeout("ShowPic()",1000)
}
function ShowPic()
{
	setTimeout("ShowPic()",1000)
	var obj=document.getElementById("txtServerIP");
	if(obj) RemoteIP=obj.value;
	var element=document.getElementById("Layer");
	if(element)
	{
		element.style.display ='inline';
		element.style.top =100;
		element.style.left =100;
		element=document.getElementById("picshow");
		element.src="/vis/wget/PrtSc/"+RemoteIP+".bmp"
	}
}
	
};
$(init);