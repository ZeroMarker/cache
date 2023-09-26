var init = function(){
	var maxWidth=$(window).width()||1366;    //��ȡ��ǰ���
	var maxHeight=$(window).height()||550;   //��ȡ��ǰ�߶�
	$("#panelTop").panel("resize",{width:maxWidth-10})
	//debugger; ���Զϵ�
	//ѡ�����
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
			{field:'CTRowId',title:'����ID',width:90},
			{field:'CTDesc',title:'����',width:130}
			
		]],
		displayMsg:"",
		pagination:true
	});
	//����
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
		
		title:"��������Ϣ",
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
			{field:'ServerIP',title:'IP��ַ',width:120},
			{field:'ServerName',title:'����',width:100},
			{field:'ServerLinkLoc',title:'����',width:50},
			{field:'ServerLinkLocId',title:'LinkLocId',width:120,hidden:true},
			{field:'ServerLinkOtherLoc',title:'����',width:50},
			{field:'ServerNote',title:'��ע',width:40},
			{field:'ServerActive',title:'�Ƿ����',width:70},
			{field:'ServerPortNo',title:'�˿�',width:40},
			{field:'ServerScreenNo',title:'����',width:40},
			{field:'ServerScreenColorNo',title:'����ɫ���',width:90},
			{field:'ServerTopIP',title:'�ն�IP',width:70},
			{field:'ServerTopDesc',title:'�ն˱���',width:70},
			{field:'ServerState',title:'״̬',width:40},
			{field:'ServerVoiceTopIP',title:'�����ն�IP',width:90},
			{field:'ServerLinkOtherLocId',title:'OtherLocId',width:40,hidden:true},
			{field:'ServerAutoUpdate',title:'�Զ�����',width:70},
			{field:'Notification',title:'֪ͨ��Ϣ',width:70},
			{field:'ServerSuper',title:'��������',width:70}
			//{field:'WaitPaitList',title:'�����б�',width:70}
			
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
		        //�Զ�����
		        if(rowData.ServerAutoUpdate=="Y"){
			        //$("#ServerActive").checkbox('check');
			        $HUI.checkbox("#ServerAutoUpdate").check();
			     }
			     else{
				     $HUI.checkbox("#ServerAutoUpdate").uncheck();   
				 }
				//��������
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
	//ɾ��
	$("#delete").click(function(){
		var ServerId=$("#ServerId").val();
		$.m({
	    ClassName:"web.DHCVISVoiceSet",
	    MethodName:"ServerDelete",
	    ServerId:ServerId
	    
         },function(txtData){
	        if(txtData=="0"){
		        $.messager.alert("��ʾ��Ϣ","ɾ���ɹ���");
		        ClaerDom();
		        $("#Search").click();
		        return;
		    }else{   
			     $.messager.alert("��ʾ��Ϣ",txtData); 
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
	//ˢ��
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
	//����
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
		        $.messager.alert("��ʾ��Ϣ","���³ɹ���");
		        $("#Search").click();
		        return false;
		    }else{   
			     $.messager.alert("��ʾ��Ϣ",txtData);   
			     return false;
			}     
	    
        });
		})
	//����
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
		        $.messager.alert("��ʾ��Ϣ","��ӳɹ���");
		        $("#Search").click();
		        return false;
		    }else{   
			     $.messager.alert("��ʾ��Ϣ",txtData);  
			     return false; 
			}     
	    
        });
		})
	//��ѯ
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
	var SendExecLine="VerifyVersion"     //��֤���³���
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
		alert("ָ��ͳɹ�,����ĸ��½���30�������!")
	}
	else
	{
		alert("��ѡ������ַ!")
	}
}
$("#btnUploadLog").click(function(){
	UploadLogHandler();
	
})

function UploadLogHandler()
{
	var RemoteIP=""
	var SendExecLine="UploadLog"         //�ϴ���־
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
		alert("��Ⱥ����뵽������ָ��Ŀ¼�鿴!")
	}
	else
	{
		alert("��ѡ������ַ!")
	}
}
function PrtSCHandler()
{
	var RemoteIP=""
	var SendExecLine="PrtSc"               //ץ��
	//var SendExecLine="VerifyVersion"     //��֤���³���
	//var SendExecLine="UploadLog"         //�ϴ���־
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
		alert("��ѡ��Ҫץͼ�ķ����ַ!")
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