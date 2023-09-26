var init = function(){
	var maxWidth=$(window).width()||1366;    //��ȡ��ǰ���
	var maxHeight=$(window).height()||550;   //��ȡ��ǰ�߶�
	$("#panelTop").panel("resize",{width:maxWidth-10})
	//ѡ��Ժ��
	var WarnHospitalNameObj = $HUI.combogrid("#WarnHospitalName",{
		panelWidth:380,
		panelHeight:280,
		//url:$URL+"?ClassName=web.DHCVISVoiceSet&QueryName=LookUpServer",
		url:$URL,
		queryParams:{
			ClassName:"web.DHCVISWarnQuery",
			QueryName:"FindHosInfo",
			Name:""
		},
		mode:'remote',
		delay:200,
		idField:'RowId',
		textField:'HosName',
		onBeforeLoad:function(param){
			param.Name = param.q;
		},
		columns:[[
			{field:'RowId',title:'Ժ��ID',width:50},
			{field:'HosCode',title:'Ժ������',width:100},
			{field:'HosName',title:'Ժ������',width:200}
				
		]],
		pagination:true
	});
	
	//ѡ��¥��
	var WarnBuildNameObj = $HUI.combogrid("#WarnBuildName",{
		panelWidth:300,
		panelHeight:300,
		url:$URL+"?ClassName=web.DHCVISWarnQuery&QueryName=FindBuildingInfo",
		mode:'remote',
		delay:200,
		idField:'RowId',
		textField:'BuildName',
		onBeforeLoad:function(param){
			param.Name = param.q;
		},
		columns:[[
			{field:'RowId',title:'¥��ID',width:50},
			{field:'BuildCode',title:'¥�����',width:100},
			{field:'BuildName',title:'¥������',width:100},
			
		]],
		displayMsg:"",
		pagination:true
	});
	//ѡ�����
	var WarnLocDescObj = $HUI.combogrid("#WarnLocDesc",{
		panelWidth:300,
		panelHeight:400,
		url:$URL+"?ClassName=web.DHCVISWarnQuery&QueryName=FindLocInfo",
		mode:'remote',
		delay:200,
		idField:'RowId',
		textField:'LocName',
		onBeforeLoad:function(param){
			var hospitalId=WarnHospitalNameObj.getValue();
			param.Name = param.q;
			param.HosId = hospitalId;
			
		},
		onShowPanel:function () {
			$('#WarnLocDesc').combogrid('grid').datagrid('reload');
    	},
		columns:[[
			{field:'RowId',title:'����ID',width:50},
			{field:'LocCode',title:'���Ҵ���',width:130},
			{field:'LocName',title:'��������',width:130}
			
		]],
		displayMsg:"",
		pagination:true
	});
	//ѡ������
	var WarnClinicalNameObj = $HUI.combogrid("#WarnClinicalName",{
		panelWidth:300,
		panelHeight:400,
		url:$URL+"?ClassName=web.DHCVISWarnQuery&QueryName=FindClinicalInfo",
		mode:'remote',
		delay:200,
		idField:'RowId',
		textField:'ClinicalName',
		onBeforeLoad:function(param){
			param.Name = param.q;
			
		},
		columns:[[
		    
		    {field:'RowId',title:'����ID',width:50},
			{field:'ClinicalCode',title:'��������',width:90},
			{field:'ClinicalName',title:'��������',width:90},
			
		]],
		displayMsg:"",
		pagination:true
	});
	//ѡ�񷿼�
	var WarnRoomNameObj = $HUI.combogrid("#WarnRoomName",{
		panelWidth:300,
		panelHeight:400,
		url:$URL+"?ClassName=web.DHCVISWarnQuery&QueryName=FindRoomInfo",
		mode:'remote',
		delay:200,
		idField:'RowId',
		textField:'RoomName',
		onBeforeLoad:function(param){
			param.Name = param.q;
			
		},
		columns:[[
		    
		    {field:'RowId',title:'����ID',width:50},
			{field:'RoomCode',title:'�������',width:120},
			{field:'RoomName',title:'��������',width:120},
			
		]],
		displayMsg:"",
		pagination:true
	});
	//ѡ�񷿼�
	var WarnFloorNameObj = $HUI.combogrid("#WarnFloorName",{
		panelWidth:300,
		panelHeight:400,
		url:$URL+"?ClassName=web.DHCVISWarnQuery&QueryName=FindFloorInfo",
		mode:'remote',
		delay:200,
		idField:'RowId',
		textField:'FloorName',
		onBeforeLoad:function(param){
			param.Name = param.q;
			
		},
		columns:[[
		    
		    {field:'RowId',title:'¥��ID',width:50},
			{field:'FloorCode',title:'¥�����',width:120},
			{field:'FloorName',title:'¥������',width:120},
			
		]],
		displayMsg:"",
		pagination:true
	});
	
	var DHCVISWarnObj = $HUI.datagrid("#DHCVISWarn",{
		
		title:"Ԥ����Ϣ",
		width:maxWidth-10,
		height:maxHeight-260,
		mode:'remote',
		delay:200,
		idField:'RowId',
		url:$URL,
		queryParams:{
			ClassName:"web.DHCVISWarnQuery",
			QueryName:"FindWarningInfo"	
		},
	   columns:[[
			{field:'RowId',title:'Ԥ����ϢID',width:90,hidden:true},
			{field:'WarnComputerName',title:'��������',width:120},
			{field:'WarnSendAddress',title:'����λ��',width:90},
			{field:'WarnSendToComputerName',title:'���յ�������',width:150},
			{field:'WarnHospitalId',title:'WarnHospitalId',width:90,hidden:true},
			{field:'WarnHospitalName',title:'Ժ��',width:150},
			{field:'WarnBuildId',title:'WarnBuildId',width:90,hidden:true},
			{field:'WarnBuildName',title:'¥��',width:120},
			{field:'WarnFloorId',title:'WarnFloorId',width:90,hidden:true},
			{field:'WarnFloorName',title:'¥��',width:120},
			{field:'WarnClinicalId',title:'WarnClinicalId',width:90,hidden:true},
			{field:'WarnClinicalName',title:'����',width:120},
			{field:'WarnRoomId',title:'WarnRoomId',width:90,hidden:true},
			{field:'WarnRoomName',title:'����',width:120},
			{field:'WarnLocId',title:'WarnLocId',width:90,hidden:true},
			{field:'WarnLocDesc',title:'��������',width:150},
			
			
		]],
		rownumbers:true,
		pagination:true,
		singleSelect:true,
		
		onClickRow:function(rowIndex,rowData){
			if (rowIndex>-1){
				
		        WarnHospitalNameObj.setValue(rowData.WarnHospitalId);
		        WarnHospitalNameObj.setText(rowData.WarnHospitalName);
		        WarnBuildNameObj.setValue(rowData.WarnBuildId);
		        WarnBuildNameObj.setText(rowData.WarnBuildName);
		        WarnFloorNameObj.setValue(rowData.WarnFloorId);
		        WarnFloorNameObj.setText(rowData.WarnFloorName);
		        WarnClinicalNameObj.setValue(rowData.WarnClinicalId);
		        WarnClinicalNameObj.setText(rowData.WarnClinicalName);
		        WarnRoomNameObj.setValue(rowData.WarnRoomId);
		        WarnRoomNameObj.setText(rowData.WarnRoomName);
		        WarnLocDescObj.setValue(rowData.WarnLocId);
		        WarnLocDescObj.setText(rowData.WarnLocDesc);
		        $("#WarnComputerName").val(rowData.WarnComputerName);
		        $("#WarnSendAddress").val(rowData.WarnSendAddress);
		        $("#WarnSendToComputerName").val(rowData.WarnSendToComputerName);
		        $("#RowId").val(rowData.RowId);
			}
		}
	
	});
	//ɾ��
	$("#delete").click(function(){
		var RowId=$("#RowId").val();
		$.m({
	    ClassName:"web.DHCVISWarning",
	    MethodName:"DeleteWarning",
	    RowId:RowId
	    
         },function(txtData){
	        if(txtData==0){
		        $.messager.alert("��ʾ��Ϣ","ɾ���ɹ���");
		        clear();
		        $("#Search").click();
		    }else{   
			     $.messager.alert("��ʾ��Ϣ",txtData);   
			}     
	    
        });
		
		})
	function clear(){
		$(".textbox").each(function(){
			$(this).val("");
			})
		WarnHospitalNameObj.setValue("");
        WarnHospitalNameObj.setText("");
        WarnBuildNameObj.setValue("");
        WarnBuildNameObj.setText("");
        WarnFloorNameObj.setValue("");
        WarnFloorNameObj.setText("");
        WarnClinicalNameObj.setValue("");
        WarnClinicalNameObj.setText("");
        WarnRoomNameObj.setValue("");
        WarnRoomNameObj.setText("");
        WarnLocDescObj.setValue("");
        WarnLocDescObj.setText("");
        $("#RowId").val("");
		
	}
	//ˢ��
	$("#refresh").click(function(){
		location.reload();
		})
	//����
	$("#Update").click(function(){
		var RowId=$("#RowId").val();
		var WarnComputerName=$("#WarnComputerName").val();
		var WarnHospitalId=WarnHospitalNameObj.getValue();
		var WarnHospitalName=WarnHospitalNameObj.getText();
		var WarnBuildId=WarnBuildNameObj.getValue();
		var WarnBuildName=WarnBuildNameObj.getText();
		var WarnFloorId=WarnFloorNameObj.getValue();
		var WarnFloorName=WarnFloorNameObj.getText();
		var WarnClinicalId=WarnClinicalNameObj.getValue();
		var WarnClinicalName=WarnClinicalNameObj.getText();
		var WarnRoomId=WarnRoomNameObj.getValue();
		var WarnRoomName=WarnRoomNameObj.getText();
		var WarnLocId=WarnLocDescObj.getValue();
		var WarnLocName=WarnLocDescObj.getText();
		var WarnSendAddress=$("#WarnSendAddress").val();
		var WarnSendToComputerName=$("#WarnSendToComputerName").val();
	    if((WarnHospitalId==WarnHospitalName)&&(WarnHospitalName!="")){
			 $.messager.alert("��ʾ��Ϣ","Ժ����������,ѡ��Ժ��!");
		     return false;
		}
		if((WarnBuildId==WarnBuildName)&&(WarnBuildName!="")){
			 $.messager.alert("��ʾ��Ϣ","¥����������,ѡ��¥��!");
		     return false;
		}
		if((WarnFloorId==WarnFloorName)&&(WarnFloorName!="")){
			 $.messager.alert("��ʾ��Ϣ","¥����������,ѡ��¥��!");
		     return false;
		}
		if((WarnClinicalId==WarnClinicalName)&&(WarnClinicalName!="")){
			 $.messager.alert("��ʾ��Ϣ","������������,ѡ������!");
		     return false;
		}
		if((WarnRoomId==WarnRoomName)&&(WarnRoomName!="")){
			 $.messager.alert("��ʾ��Ϣ","������������,ѡ�񷿼�!");
		     return false;
		}
		if((WarnLocId==WarnLocName)&&(WarnLocName!="")){
			 $.messager.alert("��ʾ��Ϣ","������������,ѡ�����!");
		     return false;
		}
		$.m({
	    ClassName:"web.DHCVISWarning",
	    MethodName:"UpdateWarning",
	    RowId:RowId,
	    WarnComputerName:WarnComputerName,
	    WarnHospitalId:WarnHospitalId,
	    WarnBuildId:WarnBuildId,
	    WarnFloorId:WarnFloorId,
	    WarnClinicalId:WarnClinicalId,
	    WarnRoomId:WarnRoomId,
	    WarnLocId:WarnLocId,
	    WarnSendAddress:WarnSendAddress,
	    WarnSendToComputerName:WarnSendToComputerName
	    
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
		
		var WarnComputerName=$("#WarnComputerName").val();
		var WarnHospitalId=WarnHospitalNameObj.getValue();
		var WarnHospitalName=WarnHospitalNameObj.getText();
		var WarnBuildId=WarnBuildNameObj.getValue();
		var WarnBuildName=WarnBuildNameObj.getText();
		var WarnFloorId=WarnFloorNameObj.getValue();
		var WarnFloorName=WarnFloorNameObj.getText();
		var WarnClinicalId=WarnClinicalNameObj.getValue();
		var WarnClinicalName=WarnClinicalNameObj.getText();
		var WarnRoomId=WarnRoomNameObj.getValue();
		var WarnRoomName=WarnRoomNameObj.getText();
		var WarnLocId=WarnLocDescObj.getValue();
		var WarnLocName=WarnLocDescObj.getText();
		var WarnSendAddress=$("#WarnSendAddress").val();
		var WarnSendToComputerName=$("#WarnSendToComputerName").val();
	    if((WarnHospitalId==WarnHospitalName)&&(WarnHospitalName!="")){
			 $.messager.alert("��ʾ��Ϣ","Ժ����������,ѡ��Ժ��!");
		     return false;
		}
		if((WarnBuildId==WarnBuildName)&&(WarnBuildName!="")){
			 $.messager.alert("��ʾ��Ϣ","¥����������,ѡ��¥��!");
		     return false;
		}
		if((WarnFloorId==WarnFloorName)&&(WarnFloorName!="")){
			 $.messager.alert("��ʾ��Ϣ","¥����������,ѡ��¥��!");
		     return false;
		}
		if((WarnClinicalId==WarnClinicalName)&&(WarnClinicalName!="")){
			 $.messager.alert("��ʾ��Ϣ","������������,ѡ������!");
		     return false;
		}
		if((WarnRoomId==WarnRoomName)&&(WarnRoomName!="")){
			 $.messager.alert("��ʾ��Ϣ","������������,ѡ�񷿼�!");
		     return false;
		}
		if((WarnLocId==WarnLocName)&&(WarnLocName!="")){
			 $.messager.alert("��ʾ��Ϣ","������������,ѡ�����!");
		     return false;
		}
	    
		$.m({
	    ClassName:"web.DHCVISWarning",
	    MethodName:"InsertWarning",
	    WarnComputerName:WarnComputerName,
	    WarnHospitalId:WarnHospitalId,
	    WarnBuildId:WarnBuildId,
	    WarnFloorId:WarnFloorId,
	    WarnClinicalId:WarnClinicalId,
	    WarnRoomId:WarnRoomId,
	    WarnLocId:WarnLocId,
	    WarnSendAddress:WarnSendAddress,
	    WarnSendToComputerName:WarnSendToComputerName
	    
         },function(txtData){
	        if(txtData==0){
		        $.messager.alert("��ʾ��Ϣ","��ӳɹ���");
		        $("#Search").click();
		    }else{   
			     $.messager.alert("��ʾ��Ϣ",txtData);   
			}     
	    
        });
		})
	//��ѯ
	$("#Search").click(function(){
		var ComputerName=$("#WarnComputerName").val();
		var HospitalId=WarnHospitalNameObj.getValue();
		var BuildId=WarnBuildNameObj.getValue();
		var FloorId=WarnFloorNameObj.getValue();
		var ClinicalId=WarnClinicalNameObj.getValue();
		var RoomId=WarnRoomNameObj.getValue();
		var CtlocId=WarnLocDescObj.getValue();
		var queryParams={
			ClassName:"web.DHCVISWarnQuery",
			QueryName:"FindWarningInfo",
			ComputerName:ComputerName,
			HospitalId:HospitalId,
			CtlocId:CtlocId,
			BuildId:BuildId,
			FloorId:FloorId,
			ClinicalId:ClinicalId,
			RoomId:RoomId
				
		}
		DHCVISWarnObj.load(queryParams);
	
		
		})	
	
};
$(init);