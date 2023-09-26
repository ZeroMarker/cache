var init = function(){
	var maxWidth=$(window).width()||1366;    //获取当前宽度
	var maxHeight=$(window).height()||550;   //获取当前高度
	$("#panelTop").panel("resize",{width:maxWidth-10})
	//选择院区
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
			{field:'RowId',title:'院区ID',width:50},
			{field:'HosCode',title:'院区代码',width:100},
			{field:'HosName',title:'院区名称',width:200}
				
		]],
		pagination:true
	});
	
	//选择楼宇
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
			{field:'RowId',title:'楼宇ID',width:50},
			{field:'BuildCode',title:'楼宇代码',width:100},
			{field:'BuildName',title:'楼宇名称',width:100},
			
		]],
		displayMsg:"",
		pagination:true
	});
	//选择科室
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
			{field:'RowId',title:'科室ID',width:50},
			{field:'LocCode',title:'科室代码',width:130},
			{field:'LocName',title:'科室名称',width:130}
			
		]],
		displayMsg:"",
		pagination:true
	});
	//选择诊区
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
		    
		    {field:'RowId',title:'诊区ID',width:50},
			{field:'ClinicalCode',title:'诊区代码',width:90},
			{field:'ClinicalName',title:'诊区名称',width:90},
			
		]],
		displayMsg:"",
		pagination:true
	});
	//选择房间
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
		    
		    {field:'RowId',title:'房间ID',width:50},
			{field:'RoomCode',title:'房间代码',width:120},
			{field:'RoomName',title:'房间名称',width:120},
			
		]],
		displayMsg:"",
		pagination:true
	});
	//选择房间
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
		    
		    {field:'RowId',title:'楼层ID',width:50},
			{field:'FloorCode',title:'楼层代码',width:120},
			{field:'FloorName',title:'楼层名称',width:120},
			
		]],
		displayMsg:"",
		pagination:true
	});
	
	var DHCVISWarnObj = $HUI.datagrid("#DHCVISWarn",{
		
		title:"预警信息",
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
			{field:'RowId',title:'预警信息ID',width:90,hidden:true},
			{field:'WarnComputerName',title:'电脑名称',width:120},
			{field:'WarnSendAddress',title:'接收位置',width:90},
			{field:'WarnSendToComputerName',title:'接收电脑名称',width:150},
			{field:'WarnHospitalId',title:'WarnHospitalId',width:90,hidden:true},
			{field:'WarnHospitalName',title:'院区',width:150},
			{field:'WarnBuildId',title:'WarnBuildId',width:90,hidden:true},
			{field:'WarnBuildName',title:'楼宇',width:120},
			{field:'WarnFloorId',title:'WarnFloorId',width:90,hidden:true},
			{field:'WarnFloorName',title:'楼层',width:120},
			{field:'WarnClinicalId',title:'WarnClinicalId',width:90,hidden:true},
			{field:'WarnClinicalName',title:'诊区',width:120},
			{field:'WarnRoomId',title:'WarnRoomId',width:90,hidden:true},
			{field:'WarnRoomName',title:'房间',width:120},
			{field:'WarnLocId',title:'WarnLocId',width:90,hidden:true},
			{field:'WarnLocDesc',title:'报警科室',width:150},
			
			
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
	//删除
	$("#delete").click(function(){
		var RowId=$("#RowId").val();
		$.m({
	    ClassName:"web.DHCVISWarning",
	    MethodName:"DeleteWarning",
	    RowId:RowId
	    
         },function(txtData){
	        if(txtData==0){
		        $.messager.alert("提示信息","删除成功！");
		        clear();
		        $("#Search").click();
		    }else{   
			     $.messager.alert("提示信息",txtData);   
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
	//刷新
	$("#refresh").click(function(){
		location.reload();
		})
	//更新
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
			 $.messager.alert("提示信息","院区数据有误,选择院区!");
		     return false;
		}
		if((WarnBuildId==WarnBuildName)&&(WarnBuildName!="")){
			 $.messager.alert("提示信息","楼宇数据有误,选择楼宇!");
		     return false;
		}
		if((WarnFloorId==WarnFloorName)&&(WarnFloorName!="")){
			 $.messager.alert("提示信息","楼层数据有误,选择楼层!");
		     return false;
		}
		if((WarnClinicalId==WarnClinicalName)&&(WarnClinicalName!="")){
			 $.messager.alert("提示信息","诊区数据有误,选择诊区!");
		     return false;
		}
		if((WarnRoomId==WarnRoomName)&&(WarnRoomName!="")){
			 $.messager.alert("提示信息","房间数据有误,选择房间!");
		     return false;
		}
		if((WarnLocId==WarnLocName)&&(WarnLocName!="")){
			 $.messager.alert("提示信息","科室数据有误,选择科室!");
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
		        $.messager.alert("提示信息","更新成功！");
		        $("#Search").click();
		    }else{   
			     $.messager.alert("提示信息",txtData);   
			}     
	    
        });
		})
	//增加
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
			 $.messager.alert("提示信息","院区数据有误,选择院区!");
		     return false;
		}
		if((WarnBuildId==WarnBuildName)&&(WarnBuildName!="")){
			 $.messager.alert("提示信息","楼宇数据有误,选择楼宇!");
		     return false;
		}
		if((WarnFloorId==WarnFloorName)&&(WarnFloorName!="")){
			 $.messager.alert("提示信息","楼层数据有误,选择楼层!");
		     return false;
		}
		if((WarnClinicalId==WarnClinicalName)&&(WarnClinicalName!="")){
			 $.messager.alert("提示信息","诊区数据有误,选择诊区!");
		     return false;
		}
		if((WarnRoomId==WarnRoomName)&&(WarnRoomName!="")){
			 $.messager.alert("提示信息","房间数据有误,选择房间!");
		     return false;
		}
		if((WarnLocId==WarnLocName)&&(WarnLocName!="")){
			 $.messager.alert("提示信息","科室数据有误,选择科室!");
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
		        $.messager.alert("提示信息","添加成功！");
		        $("#Search").click();
		    }else{   
			     $.messager.alert("提示信息",txtData);   
			}     
	    
        });
		})
	//查询
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