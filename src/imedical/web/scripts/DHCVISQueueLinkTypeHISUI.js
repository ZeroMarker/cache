var init = function(){
	var maxWidth=$(window).width()||1366;    //��ȡ��ǰ���
	var maxHeight=$(window).height()||750;   //��ȡ��ǰ�߶�
	$("#panelTop").panel("resize",{width:maxWidth-10})
	
	
	var QueueLinkObj = $HUI.datagrid("#DHCVISQueueLinkType",{
		
		title:"�������������б�",
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
			{field:'TypeCode',title:'���ʹ���',width:160},
			{field:'TypeDesc',title:'��������',width:160},
			{field:'TypeNote',title:'���ͱ�ע',width:160},
			{field:'ActiveFlag',title:'����',width:160}
			
			
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
	//ɾ��
	$("#delete").click(function(){
		var TypeId=$("#TypeId").val();
		if(TypeId==""){
			$.messager.alert("��ʾ��Ϣ","��ѡ����Ҫ���µļ�¼����");
			return false;
		}
		$.m({
	    ClassName:"web.DHCVISLinkQueueType",
	    MethodName:"DeleteLinkQueueType",
	    typeId:TypeId
	    
         },function(txtData){
	        if(txtData==0){
		        $.messager.alert("��ʾ��Ϣ","ɾ���ɹ���");
		        //$("#refresh").click();
		        clearData();
		        $("#Search").click();
		    }else{   
			     $.messager.alert("��ʾ��Ϣ",txtData);   
			}     
	    
        });
		
		})
	//�������
	function clearData(){
		$(".textbox").each(function(){
			$(this).val("");
		})
		$HUI.checkbox("#ActiveFlag").uncheck();
		
	}
	//����
	$("#Update").click(function(){
		var TypeId=$("#TypeId").val();
		if(TypeId==""){
			$.messager.alert("��ʾ��Ϣ","��ѡ����Ҫ���µļ�¼����");
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
		        $.messager.alert("��ʾ��Ϣ","���³ɹ���");
		        $("#Search").click();
		    }else{   
			     $.messager.alert("��ʾ��Ϣ",txtData);   
			}     
	    
        });
		})
	//����
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
		        $.messager.alert("��ʾ��Ϣ","��ӳɹ���");
		        clearData();
		        $("#Search").click();
		    }else{   
			     $.messager.alert("��ʾ��Ϣ",txtData);   
			}     
	    
        });
		})
	//��ѯ
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