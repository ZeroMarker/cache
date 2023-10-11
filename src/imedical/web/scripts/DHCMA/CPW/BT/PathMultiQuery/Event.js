//页面Event
function InitCheckQueryWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
		//查询
		$('#btnQuery').on('click', function(){
			obj.CheckQueryLoad();
		});
		
		//导出
		$('#btnExport').on('click', function(){
			obj.btnExport("GridPathMultiQry",obj.GridPathMultiQry,"路径条件查询结果");
		});
	}
	
  	// 查询事件
	obj.CheckQueryLoad = function(){
		$('#GridPathMultiQry').datagrid('loadData',{total:0,rows:[]});
		
		var valFormKWs = $('#cboFormKWs').combobox('getValues').toString()
		var valApplyStatus = $('#cboApplyStatus').combobox('getValue')
		var valPubStatus = $('#cboPubStatus').combobox('getValue')
		var strFormKeyIDs = valFormKWs + "^" + valApplyStatus + "^" + valPubStatus
		// aHospID,aLocID,aPathType,aAdmType,aPathIsActive,aNameKeyWord,aFlagVer,aPathKeyIDs,aFormKeyIDs
		$cm ({
			ClassName:"DHCMA.CPW.BTS.PathMultiQuerySrv",
			QueryName:"QryMultiCondPath",
			aHospID: $('#cboSSHosp').combobox('getValue'),
			aLocID: $('#cboLoc').combobox('getValue'), 
			aPathType: $('#cboPathType').combobox('getValue'), 
			aAdmType: $('#cboAdmType').combobox('getValue'),
			aPathIsActive: $('#cboCPWIsActive').combobox('getValue'),
			aNameKeyWord: $("#txtPathName").val(),
			aFlagVer:$('#cboPathVer').combobox('getValue'),
			aPathKeyIDs:$('#cboPathKWs').combobox('getValues').join(','),
			aFormKeyIDs:strFormKeyIDs, 
			page:1,
			rows:999999
		},function(rs){
			if (rs.rows.length==0) $.messager.popover({msg: '没有符合条件的数据！',type:'info',timeout: 1000});
			else $('#GridPathMultiQry').datagrid({loadFilter:pagerFilter,nowrap:true}).datagrid('loadData', rs);				
		});	
    }
    
    // 导出方法
    obj.btnExport = function(id,objExport,TitleDesc){
		var rows = objExport.getRows().length; 
		
		if (rows>0) {
		   grid2excel($('#'+id), {IE11IsLowIE: false,filename:TitleDesc,allPage: true});
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
		}
	}

}