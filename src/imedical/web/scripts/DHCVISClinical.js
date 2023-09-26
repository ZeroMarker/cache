var init = function(){
	var maxWidth=$(window).width()||1366;    //��ȡ��ǰ���
	var maxHeight=$(window).height()||550;   //��ȡ��ǰ�߶�
	$("#panelTop").panel("resize",{width:maxWidth-10})
	
	var DHCVISClinicalObj=$HUI.datagrid("#DHCVISClinical",{
		title:"���������б�",
	    width:maxWidth-10,
		height:maxHeight-150,
	    url:$URL+"?ClassName=web.DHCVISWarnQuery&QueryName=FindClinicalInfo",
	    idField:'RowId',
		mode:'remote',
		delay:200,
		columns:[[
		    {field:'RowId',title:'RowId',width:90,hidden:true},
			{field:'ClinicalCode',title:'��������',width:200},
			{field:'ClinicalName',title:'��������',width:200},
			
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
			        $.messager.alert("��ʾ��Ϣ","ɾ���ɹ�");
			        searchList();
			    }else{   
				     $.messager.alert("��ʾ��Ϣ",txtData);  
				     searchList(); 
				}     
	    
        	});
		 
		 
			})
		 //ˢ��
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
			        $.messager.alert("��ʾ��Ϣ","�޸ĳɹ���");
			        searchList();
			    }else{   
				     $.messager.alert("��ʾ��Ϣ",txtData);
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
			        $.messager.alert("��ʾ��Ϣ","��ӳɹ���");
			        searchList();
			    }else{   
				     $.messager.alert("��ʾ��Ϣ",txtData); 
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