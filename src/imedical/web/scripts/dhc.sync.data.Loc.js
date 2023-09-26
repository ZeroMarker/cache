var delClick = function(){
	$.ajaxRunServerMethod({ClassName:"dhc.sync.web.Loc", MethodName:"Del",RowId:$("#RowId").val()},function(data){
		if (data==0){
			$.messager.alert('成功',"删除成功!");
			$("#Clear").click();
			$("#Find").click();
		}else{
			$.messager.alert('失败',data.split("^")[1]);
		}
	})
}
$(function(){
	$("#State").attr("checked","checked");
	$('#Super').combogrid({
		delay: 1000,
		panelWidth:350,
		mode: 'remote',
		queryParams:{ClassName: 'dhc.sync.web.Loc',QueryName: 'Find'},
		url: 'jquery.easyui.querydatatrans.csp',
		onBeforeLoad:function(param){
			param = $.extend(param,{Code:param.q});
			return true;
		},
		idField: 'LocCode',
		textField: 'LocName',
		columns: [[{field:'LocCode',title:'代码',align:'right',width:100},
		{field:'LocName',title:'名称',align:'right',width:200},
		{field:'LocLevel',title:'LocLevel',align:'right',width:100},
		{field:'LocRowId',title:'LocRowId',align:'right',width:100},
		{field:'LocSuper',title:'LocSuper',align:'right',width:100},{field:'LocState',title:'LocState',align:'right',width:100},{field:'LocIsLast',title:'LocIsLast',align:'right',width:100},{field:'LocType',title:'LocType',align:'right',width:100},{field:'LocDGroup',title:'LocDGroup',align:'right',width:100},{field:'LocClassify',title:'LocClassify',align:'right',width:100},{field:'LocAddress',title:'LocAddress',align:'right',width:100},{field:'LocPhone',title:'LocPhone',align:'right',width:100},{field:'LocMnemonics',title:'LocMnemonics',align:'right',width:100},{field:'LocStartDate',title:'LocStartDate',align:'right',width:100},{field:'LocEndDate',title:'LocEndDate',align:'right',width:100},{field:'LocStorey',title:'LocStorey',align:'right',width:100},{field:'LocCatalogue',title:'LocCatalogue',align:'right',width:100},{field:'LocDept',title:'LocDept',align:'right',width:100},{field:'LocSysCode',title:'LocSysCode',align:'right',width:100}]]
	});
	$('#DGroup').combogrid({
		delay: 1000,
		panelWidth:350,
		mode: 'remote',
		queryParams:{ClassName: 'web.RBCDepartmentGroup',QueryName: 'LookUpDate'},
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'Code',
		textField: 'Description',
		columns: [[{field:'Description',title:'Description',align:'right',width:100},{field:'HIDDEN',title:'HIDDEN',align:'right',width:100},{field:'Code',title:'Code',align:'right',width:100}]]
	});
	
	$.ajaxRunServerQuery({ClassName:"dhc.sync.web.System",QueryName:"Find",Code:"",Active:"Y"},
		function(data,textStatus){
			if(""!==data){
				var sysData = [];
				for(var i=0; i<data.total;i++){
					sysData[i]={id:data.rows[i].SysCode,text:data.rows[i].SysCode};
				}
				$('#SysCode').combotree({
					delay: 1000,
					panelWidth:350,
					mode: 'local',
					multiple:true,
					data:[{
						"text":"子系统",
						"id":"ALL",
						"state":"open",
						"children":sysData
					}]
				});
				$('#ImportData').click(function(){
					var arr = $('#SysCode').combotree("getValues");
					if (arr && arr.length>0){
						$.messager.confirm('提示',"你确定从"+arr[0]+"系统中导入科室信息?",function(r){  
						    if (r){
							   var over = 0;
							   if ($("#overCB").attr("checked")){
									over = 1;
							   } 
						       $.ajaxRunServerMethod({ClassName:"dhc.sync.web.Loc", MethodName:"ImportData",over:over,SysCode:arr[0]},
									function(data){
										if (parseInt(data)>=0){
											$.messager.alert('成功',"成功导入 "+data+" 条科室数据!");
											$("#Clear").click();
											$("#Find").click();
										}else{
											$.messager.alert('失败',data.split("^")[1]);
										}
									})
						    }  
						});  
					}else{
						$.messager.alert('提示',"请选择系统代码");
					}
				});
				$('#ExportData').click(function(){
					var arr = $('#SysCode').combotree("getValues");
					if (arr && arr.length>0){
						$.messager.confirm('提示',"你确定批量把用户信息导出到:"+arr[0]+"系统中?",function(r){  
						    if (r){  
						       $.ajaxRunServerMethod({ClassName:"dhc.sync.web.Loc", MethodName:"ExportData",over:0,SysCode:arr[0]},
									function(data){
										if (parseInt(data)>0){
											$.messager.alert('成功',"导出"+data+" 条数据到 "+arr[0]+"系统中!");
											$("#Clear").click();
											$("#Find").click();
										}else{
											$.messager.alert('失败',data.split("^")[1]);
										}
									})
						    }  
						});  
					}else{
						$.messager.alert('提示',"请选择系统代码");
					}
				});
			}
		}
		
	);
	
	$("#Type").combobox({
		valueField:"Code",
		textField:"Desc",
		data:[
			{Code:'E',Desc:'执行科室'},
			{Code:'W',Desc:'病房'},
			{Code:'D',Desc:'药房'},
			{Code:'EM',Desc:'急诊'},
			{Code:'CL',Desc:'门诊诊室'},
			{Code:'OP',Desc:'手术室'},
			{Code:'O',Desc:'其他'}]
	});
	$("#Classify").combobox({
		valueField:"Code",
		textField:"Desc",
		data:[{Code:'E',Desc:'急诊'},{Code:'O',Desc:'门诊'},{Code:'I',Desc:'住院'},{Code:'H',Desc:'其它'}]
	});
	var getFormJson = function(){
		var State=1;
		if ($('#State').attr("checked")=="checked"){
			State = 1;
		}else{
			State = 2;
		}
		var Dept="Y";
		if ($('#Dept').attr("checked")=="checked"){
			Dept = "Y";
		}else{
			Dept = "N";
		}
		var json = {
			Code:$('#Code').val(),
			Name:$('#Name').val(),
			Super:$('#Super').combogrid("getValue"),
			State:State,
			Type:$('#Type').combobox("getValue"),
			DGroup:$('#DGroup').combogrid("getValue"),
			Classify:$('#Classify').combobox("getValue"),
			Address:$('#Address').val(),
			Phone:$('#Phone').val(),
			Mnemonics:$('#Mnemonics').val(),
			StartDate:$('#StartDate').datebox("getValue"),
			EndDate:$('#EndDate').datebox("getValue"),
			Storey:$('#Storey').val(),
			Dept:Dept,
			SysCode:$('#SysCode').combotree('getValues').join(","),
			HospCode:$('#HospCode').val()
		}
		return json;
	}
	$('#Find').click(function(){
		var q = $.extend({  ClassName:"dhc.sync.web.Loc", QueryName:"Find"},getFormJson());
		$('#tdhc_sync_data_Loc').datagrid('load',q);
	}).linkbutton({iconCls: 'icon-search'});;
	$('#Save').click(function(){
		var q = $.extend({ClassName:"dhc.sync.web.Loc", MethodName:"Save"},getFormJson());
		$.ajaxRunServerMethod(q,function(data){
			if (parseInt(data)>=0){
				$.messager.alert('成功',"保存成功!");
				$("#Clear").click();
				$("#Find").click();
			}else{
				$.messager.alert('失败',data.split("^")[1]);
			}
		})
	}); //.linkbutton({iconCls: 'icon-add'});;
	$('#Clear').click(function(){
			$('#RowId').val("");
			$('#Code').val("");
			$('#Name').val("");
			$('#Super').combogrid("setValue","");
			$('#State').attr("checked","checked");
			$('#Type').combobox("setValue","");
			$('#DGroup').combogrid("setValue","");
			$('#Classify').combobox("setValue","");
			$('#Address').val("");
			$('#Phone').val("");
			$('#Mnemonics').val("");
			$('#StartDate').datebox("setValue","");
			$('#EndDate').datebox("setValue","");
			$('#Storey').val("");
			$('#Dept').attr("checked","checked");
			$('#SysCode').combotree('setValue',"");
			$('#HospCode').val("");
			$("#Del").unbind("click",delClick).linkbutton('disable');
	});
	$("#tdhc_sync_data_Loc").datagrid("options").onClickRow = function(index,rowData){
		if (index>-1){
			$('#RowId').val(rowData["LocRowId"]);
			$('#Code').val(rowData["LocCode"]);
			$('#Name').val(rowData["LocName"]);
			$('#Super').combogrid("setValue",rowData["LocSuper"]);
			var State=rowData["LocState"];
			if (State=="有效"){
				State = "checked";
			}else{
				State = "";
			}
			$('#State').attr("checked",State);
			$('#Type').combobox("setValue",rowData["LocType"]);
			$('#DGroup').combogrid("setValue",rowData["LocDGroup"]);
			$('#Classify').combobox("setValue",rowData["LocClassify"]);
			$('#Address').val(rowData["LocAddress"]);
			$('#Phone').val(rowData["LocPhone"]);
			$('#Mnemonics').val(rowData["LocMnemonics"]);
			$('#StartDate').datebox("setValue",rowData["LocStartDate"]);
			$('#EndDate').datebox("setValue",rowData["LocEndDate"]);
			$('#Storey').val(rowData["LocStorey"]);
			$('#HospCode').val(rowData["LocHospCode"]);
			var Dept =  rowData["LocDept"];
			if (Dept=="科室"){
				Dept = "checked";
			}else{
				Dept = "";
			}
			$('#Dept').attr("checked","checked");
			$('#SysCode').combotree('setValues',rowData["LocSysCode"].split(","));
			$("#Del").bind("click",delClick).linkbutton('enable');
		}
	}
	$("#Del").linkbutton('disable').linkbutton({iconCls: 'icon-remove'});
	/*$("#tdhc_sync_data_Loc").treegrid({
		idField:"LocRowId",
		treeField:"Name",
		columns:[[
		{field:'LocRowId',title:'LocRowId',width:100,align:'right',hidden:true},
		{field:'LocCode',title:'LocCode',width:100,align:'right',hidden:false},
		{field:'LocName',title:'LocName',width:100,align:'right',hidden:false},
		{field:'LocLevel',title:'LocLevel',width:100,align:'right',hidden:true},
		{field:'LocSuper',title:'LocSuper',width:100,align:'right',hidden:false},
		{field:'LocState',title:'LocState',width:100,align:'right',hidden:false},
		{field:'LocIsLast',title:'LocIsLast',width:100,align:'right',hidden:false},
		{field:'LocType',title:'LocType',width:100,align:'right',hidden:false},
		{field:'LocDGroup',title:'LocDGroup',width:100,align:'right',hidden:false},
		{field:'LocClassify',title:'LocClassify',width:100,align:'right',hidden:false},
		{field:'LocAddress',title:'LocAddress',width:100,align:'right',hidden:false},
		{field:'LocPhone',title:'LocPhone',width:100,align:'right',hidden:false},
		{field:'LocMnemonics',title:'LocMnemonics',width:100,align:'right',hidden:false},
		{field:'LocStartDate',title:'LocStartDate',width:100,align:'right',hidden:false},
		{field:'LocEndDate',title:'LocEndDate',width:100,align:'right',hidden:false},
		{field:'LocStorey',title:'LocStorey',width:100,align:'right',hidden:false},
		{field:'LocCatalogue',title:'LocCatalogue',width:100,align:'right',hidden:true},
		{field:'LocDept',title:'LocDept',width:100,align:'right',hidden:false},
		{field:'LocSysCode',title:'LocSysCode',width:100,align:'right',hidden:false}]]
	});*/
});
