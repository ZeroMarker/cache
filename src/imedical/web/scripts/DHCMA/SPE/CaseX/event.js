function InitCaseXWinEvent(obj){
	 obj.LoadEvent = function(args){
		 $('#gridCaseX').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0

		//排除
		$('#btnRemove').on('click', function(){
			obj.btnRemove_click();
     	});
		//标记
		$('#btnConfirm').on('click', function(){
	     	obj.btnConfirm_click();
     	});
		//查询
		$('#btnSearch').on('click', function(){
	     	obj.btnSearch_click();
     	});
		//监控
		$('#btnControl').on('click', function(){
	     	obj.btnControl_Click();
     	});
	}
	
		
	
	//标记
	obj.btnConfirm_click=function(){
		var rows=$('#gridCaseX').datagrid("getSelections");
		for (var rowIndex = 0; rowIndex < rows.length; rowIndex++){
			var rd = rows[rowIndex];
			if(!rd) continue;
			var status=rd["StatusCode"];
	       
	        var Patstatus = rd["Opinion"];
	       
	        if( Patstatus === "审核"){
				$.messager.alert("提示", "该患者已审核，不允许操作!",'info');
				return;
			}
		}
		if (rows.length<1){
			$.messager.alert("提示", "请选择需要标记患者!",'info');
			return;
		}
		
		obj.ProcessCaseXStatus(rows,1,"");	
	}
	
	//排除
	obj.btnRemove_click=function(){
		var rows=$('#gridCaseX').datagrid("getSelections");
		// 判断是否审核
		for (var rowIndex = 0; rowIndex < rows.length; rowIndex++){
			var rd = rows[rowIndex];
			if(!rd) continue;
			var status=rd["StatusCode"];
	       
	        var Patstatus = rd["Opinion"];
	       
	        if( Patstatus === "审核"){
				$.messager.alert("提示", "该患者已审核，不允许操作!",'info');
				return;
			}
		}
		if (rows.length<1){
			$.messager.alert("提示", "请选择需要排除记录!",'info');
			return;
		}
		$.messager.prompt("提示", "请输入排除原因：", function (r) {
			if (r) {
				obj.ProcessCaseXStatus(rows,0,r);
			}
			else if(r===""){
				$.messager.alert("提示", "原因为空，请输入排除原因!",'info',function(r){
					obj.btnRemove_click()});
				
				}
		})
	}
	
	//监控
	obj.btnControl_Click=function(){
		var locID=session["LOGON.CTLOCID"];
		var userID=session["LOGON.USERID"];
		debugger;
		var flg=$m({
			ClassName:"DHCMed.SPEService.CaseXCtl",
			MethodName:"CtrlAdmitCaseX",
			locid:locID,
			userid:userID
		},false)
		if(parseInt(flg)<1){
			$.messager.popover({msg:"筛查失败:"+flg,type:'error',style:{top:250,left:600}});
			return false;
		}else{
			$.messager.popover({msg:"筛查成功",type:'success',style:{top:250,left:600}});			
		}
	}
	
	function SearchData(DateFrom,DateTo,ScreenItems){
		$cm({
		ClassName    : "DHCMed.SPEService.CaseXSrv",
		QueryName    : "QryCaseXList",
		ResultSetType: "array",
		aHospIDs     : $("#cboHospital").combobox('getValue'),
		aDateFrom    : DateFrom,
		aDateTo      : DateTo,
		aScreenItems : ScreenItems,
		aAdmStatus   : Common_CheckboxValue('chkAdmStatus'),
		aLocID       : $("#cboLoc").combobox('getValue'),
		//aWardID      : $("#cboWard").combobox('getValue'),
		aWard		 : $("#cboWard").combobox('getText'),
		page         : 1,
		rows         : 100
		},function(rs){
			$('#gridCaseX').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
			$("#gridCaseX").datagrid("loaded");// 在标记和排除之后会在datagrid上显示加载条，此处为了取消加载条的显示，不影响第一次的正常加载
		});
	}
	
	
	//查询
	obj.btnSearch_click=function(){
		var ScreenItems=Common_CheckboxValue("chkScreenItems");
		if (!ScreenItems) {
			$.messager.alert("提示","请选择筛查项目!",'info');
			return;
		}
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo = $('#dtDateTo').datebox('getValue');
		if ((DateFrom == '')||(DateTo == '')) {
			$.messager.alert("提示","请输入开始日期、结束日期!",'info');
			return;
		} else {
			if (Common_CompareDate(DateFrom,DateTo)>0) {
				$.messager.alert("提示","开始日期不能大于结束日期!",'info');
				return;
			}
		}
		$("#gridCaseX").datagrid("loading");
		SearchData(DateFrom,DateTo,ScreenItems);
	}
	
	//特殊患者监控 标记或排除
	obj.ProcessCaseXStatus=function(rows,aStatus,aOpinion){
		if (rows.length<1) return;
		var StatusCode=(aStatus ? 1 : 0);
		var StatusDesc=(aStatus ? "标记" : "排除");
		
		var InputStr="";
		for (var rowIndex = 0; rowIndex < rows.length; rowIndex++){
			var rd = rows[rowIndex];
			if(!rd) continue;
			
			var status=rd["StatusCode"];
			if (status == aStatus ){
				$.messager.alert("提示", "该患者已标记或排除，不允许操作!",'info');
				return;
			}		
		
			var InputStr1=rd["CaseXID"]
			InputStr1=InputStr1 + CHR_1 + StatusCode;
			InputStr1=InputStr1 + CHR_1 + aOpinion;
			InputStr1=InputStr1 + CHR_1 + session["LOGON.CTLOCID"];
			InputStr1=InputStr1 + CHR_1 + session["LOGON.USERID"];
			InputStr=InputStr + "!" + InputStr1	
		}
		$m({
			ClassName:"DHCMed.SPEService.CaseXSrv",
			MethodName:"ProcessCaseX",
			aInputStr:InputStr,
			aSeparete:CHR_1
		},function(ret){
			$("#gridCaseX").datagrid("loading");
			var success= ret.split("/")[0];
			var fail= ret.split("/")[1];
			$.messager.popover({msg: StatusDesc+'成功' + success+"条！失败: "+fail+"条！",type:'success',timeout: 3000});
			// 加载监控数据，保证加载数据在标记数据完成之后，从而加载到最新的数据
			var ScreenItems=Common_CheckboxValue("chkScreenItems");
			var DateFrom = $('#dtDateFrom').datebox('getValue');
			var DateTo = $('#dtDateTo').datebox('getValue');
			SearchData(DateFrom,DateTo,ScreenItems);
		});
	}
}