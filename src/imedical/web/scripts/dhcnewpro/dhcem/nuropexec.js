
$(function(){




	$("#startDate").change(function(){
  		parent.startDate= $('#startDate').datebox('getValue')
	});
	$("#endDate").change(function(){
  		parent.endDate=$('#endDate').datebox('getValue')
	});
	$("#searcBTN").click(function(){
  		   
  		 search();

	});
	$("#showDetailBTN").click(function(){
  		
	});
	$(".btn-group > button").click(function(){
  		
  		$(".btn-group > button").removeClass("btn-success");
  		$(this).addClass("btn-success");
  		$("#QueryTypeCode").val($(this).attr("id"));
  		search();
	});
	$("#QueryTypeCode").val($(".btn-group > .btn-success").attr("id"));
	search();
	
});	

function onSelectStart(date){
	parent.startDate=date.Format("yyyy-MM-dd")
}

function onSelectEnd(date){
	parent.endDate=date.Format("yyyy-MM-dd")
}
function search(){
		if($("#RegNo").val()==""){
			$("#RegNo").val(parent.$('#datagrid').datagrid('getSelected').CardNo)
		}
		runClassMethod("web.DHCEasyuiColumn","getColumn",
				{
					HospitalRowId:$("#hospId").val(),
					queryTypeCode:$("#QueryTypeCode").val()
				},function(ret){
					 regNo=$("#RegNo").val(); //+"^"+$("#EpisodeID").val();
			  		 stdate=$("#startDate").datebox('getValue');
			  		 edate=$("#endDate").datebox('getValue');
			  		 queryTypeCode=$("#QueryTypeCode").val();
			  		 userId=$("#UserId").val();
			  		 admType="OE";
  		 
				     $('#execgrid').datagrid({
					     'columns':ret,
				         'url':'dhcapp.broker.csp?ClassName=web.DHCEMNurExe&MethodName=getExeOrders',
				  		 'queryParams':{    
				    		RegNo: regNo,    
				    		QueryType: queryTypeCode,
				    		StartDate:stdate,
				    		EndDate:edate,
				    		HospId:$("#hospId").val() 
					 }}); 
		 })

  		 
  		 return;
  		 var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNUROPEXEC"+"&regNo="+regNo+"&startDate="+stdate+"&endDate="+edate+"&queryTypeCode="+queryTypeCode+"&HospitalRowId="+$("#hospId").val()+"&userId="+userId+"&admType="+admType;
    
  		 $("#OrdList").attr("src",lnk)
    	 var reportType=$("#ReportList").val();
    	 lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOPExecAttach"+"&wardId=-1&regNo="+regNo+"&startDate="+stdate+"&endDate="+edate+"&queryTypeCode="+queryTypeCode+"&ReportType="+reportType;
   		 $("#OrdAttach").attr("src",lnk)
}
function OnSelect(rowIndex, rowData){
	
	var check=0;
	$.each($("#execgrid").datagrid("getSelections"),function(i,n){
    	if(rowData.oeoreId==n.oeoreId){
	    	check=1;
	    }
	})
	var rows = $("#execgrid").datagrid("getRows");
	for(var i=0;i<rows.length;i++)
	{
		if(i==rowIndex){
			continue;
		}
		if(rowData.mainOeoreId==rows[i].mainOeoreId){
			if(check==1){
				$("#execgrid").datagrid('selectRow',i);
			}else{
				$("#execgrid").datagrid('unselectRow',i);
			}
			
		}
	}
}
function exeAndPrint(exeflag,printflag){
	
	var ids = [];
	var rows = $('#execgrid').datagrid('getSelections');
	for(var i=0; i<rows.length; i++){
		
		ids.push(rows[i].oeoreId);
	}
	if(ids.length==0){
		$.messager.alert('警告','请选择医嘱'); 
		return;
	}
	runClassMethod("web.DHCEMNurExe","UpdateOrdGroup",
				  {
					HospitalRowId:$("#hospId").val(),
					queryTypeCode:$("#QueryTypeCode").val(),
					execStatusCode:exeflag,
					oeoreIdStr:ids.join("^"),
					userId:LgUserID,
					userDeptId:LgCtLocID
				 },function(ret){
					 if(ret==0){
						$.messager.alert('提示','成功');
						$('#execgrid').datagrid('reload')
					 }else{
					 	$.messager.alert('警告','执行失败:'+ret); 	 
					 }
				 },"text");	
}

function SetSkinTestResult(abnormalFlag){
	
	var ids = [];
	var rows = $('#execgrid').datagrid('getSelections');
	for(var i=0; i<rows.length; i++){
		if(rows[i].disposeStatDesc=="皮试"){
			ids.push(rows[i].oeoreId);
		}
		
	}
	if(ids.length==0){
		$.messager.alert('警告','没有需要皮试的医嘱'); 
		return;
	}
	if(ids.length>1){
		$.messager.alert('警告','请选择一条皮试医嘱'); 
		return;
	}
	runClassMethod("web.DHCEMNurExe","SetSkinTestResult",
				  {

					flag:abnormalFlag,
					oeoreId:ids[0],
					userId:LgUserID,
					userDeptId:LgCtLocID
				 },function(ret){
					 if(ret==0){
						$.messager.alert('提示','成功');
						
					 }else{
					 	$.messager.alert('警告','执行失败:'+ret); 	 
					 }
				 },"text");	
}


