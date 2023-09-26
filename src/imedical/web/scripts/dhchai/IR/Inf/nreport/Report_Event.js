function InitNReportWinEvent(obj){
	// 初始化功能按钮
	CheckSpecificKey();
	obj.InitButtons = function(){
		$('#btnSubmit').hide();
		$('#btnCheck').hide();
		$('#btnDelete').hide();
		$('#btnReturn').hide();
		$('#btnExport').hide();
		$('#btnUnCheck').hide();
		if (PageType != 'WinOpen') {
			$('#btnClose').hide();
		}
		//增加系统参数设置是否隐藏添加
		//btnINFOPSAdd btnINFLabAdd btnINFAntiAdd
		var configVal=$.Tool.RunServerMethod("DHCHAI.BT.Config","GetValByCode","InfReportAddBtnHidden",$.LOGON.HOSPID);
		if (configVal != ''){
			var arr = configVal.split("-");
			if(arr.length>=3)
			{
				if(arr[1]=="1")
				{
					$('#btnINFLabAdd').hide();
				}
				if(arr[2]=="1")
				{
					$('#btnINFAntiAdd').hide();
				}
			}
		}
		switch (obj.RepStatusCode){
			case '2':       // 提交
				$('#btnDelete').show();
				$('#btnSubmit').show();
				//$('#btnExport').show();
				if (obj.AdminPower==1){	// 管理员
					$('#btnCheck').show();
					$('#btnReturn').show();
					$('#btnDelete').show();
				}
				break;
			case '3':       // 审核
				//$('#btnExport').show();
				if (obj.AdminPower==1){	// 管理员
					$('#btnUnCheck').show();
				}
				break;
			case '6':       // 取消审核
				$('#btnSubmit').show();
				$('#btnDelete').show();
				if (obj.AdminPower==1){	// 管理员
					$('#btnCheck').show();
					$('#btnReturn').show();
				}
				break;
			case '4':       // 删除
				break;
			case '5':       // 退回
				$('#btnSubmit').show();
				$('#btnDelete').show();
				break;
			default:
				$('#btnSubmit').show();
				break;
		}
	}
	obj.InitButtons();

	// 提交
	$('#btnSubmit').click(function (e) {
		if (!obj.CheckInputData(2)){
			return;
		}
    	if (obj.Save()){
    		layer.msg('提交成功!',{icon: 1});
    		//提交之后检查疑似病例标志
    		var flg = $.Tool.RunServerMethod("DHCHAI.IRS.CCScreenAttSrv","UpdateSusInfFlag",EpisodeID);
    	}else{
    		layer.msg('提交失败!',{icon: 2});
    	};
	});

	// 审核
	$('#btnCheck').click(function (e) {
		if (!obj.CheckInputData(3)){
			return;
		}
    	if (obj.Save()){
    		layer.msg('审核成功!',{icon: 1});
    	}else{
    		layer.msg('审核失败!',{icon: 2});
    	};
	});

	// 删除
	$('#btnDelete').click(function (e) {
    	if (obj.SaveStatus(4)){
    		layer.msg('删除成功!',{icon: 1});
    	}else{
    		layer.msg('删除失败!',{icon: 2});
    	};
	});

	// 退回
	$('#btnReturn').click(function (e) {
    	if (obj.SaveStatus(5)){
    		layer.msg('退回成功!',{icon: 1});
    	}else{
    		layer.msg('退回失败!',{icon: 2});
    	};
	});

	// 取消审核
	$('#btnUnCheck').click(function (e) {
    	if (obj.SaveStatus(6)){
    		layer.msg('取消审核成功!',{icon: 1});
    	}else{
    		layer.msg('取消审核失败!',{icon: 2});
    	};
	});
	
	// 导出
	$('#btnExport').click(function(e){
	})
	//关闭
	$('#btnClose').click(function(e){
		//if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");  //关闭
		//websys_showModal支持多层弹出，使用websys_showModel('close')关闭最近一次界面 ,websys_showModel('options') 拿到最近一次界面的配置
		websys_showModal('close');
	});
	// 数据完整性验证
	obj.CheckInputData = function (statusCode){
		obj.InputRep 		= obj.Rep_Save(statusCode);		// 报告主表信息
		obj.InputRepLog 	= obj.RepLog_Save(statusCode);	// 日志
    	obj.InputPreFactors = obj.PreFactor_Save();			// 易感因素
    	obj.InputDiag       = obj.DIAG_Save();			    // 感染诊断
    	obj.InputLab 		= obj.LAB_Save();				// 病原学送检
    	obj.InputAnti 		= obj.ANT_Save();				// 抗菌药物
		var InfDate = $.form.GetValue("txtInfDate");
    	if (InfDate==''){
    		layer.msg('感染日期不能为空!',{icon: 2});
			return false;
    	}else {
	    	if (!obj.checkDate(InfDate)){
				layer.msg('感染时间需要在住院期间!',{icon: 2});
				return false;
			}
		} 	
    	if (obj.InputDiag==''){
    		layer.msg('感染诊断不能为空!',{icon: 2});
			return false;
    	}
    	return true;
	}

	// 保存报告内容+状态
	obj.Save = function (){
    	var ret = $.Tool.RunServerMethod('DHCHAI.IRS.INFReportSrv','SaveINFReport',obj.InputRep,obj.InputPreFactors,'',obj.InputDiag,'',obj.InputLab,obj.InputAnti,obj.InputRepLog)
		if (parseInt(ret)>0){
    		ReportID = parseInt(ret);
    		obj.refreshReportInfo();
    		obj.refreshgridINFLab();
    		obj.refreshgridINFAnti();
    		obj.InitButtons();
    		return true;
    	}else{
    		return false;
    	}
	}

	// 保存报告状态
	obj.SaveStatus = function(statusCode){
		var InputRepLog 	= obj.RepLog_Save(statusCode);	// 日志
		var ret = $.Tool.RunServerMethod('DHCHAI.IRS.INFReportSrv','SaveINFReportStatus',InputRepLog,CHR_1)
    	if (parseInt(ret)>0){
    		obj.refreshReportInfo();
    		obj.InitButtons();
    		return true;
    	}else{
    		return false;
    	}
	}

	obj.checkDate = function(d){
		d = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","DateHtmlToLogical",d);
		var cDateFrom = obj.AdmInfo.record[0].AdmDate;
		var cDateTo = obj.AdmInfo.record[0].DischDate;
		if (cDateTo==''){
			cDateTo = $.form.GetCurrDate('-');
		}
		var flg1 = $.form.CompareDate(d,cDateFrom);
		var flg2 = $.form.CompareDate(cDateTo,d);
		if (flg1&&flg2){
			return true;
		}else{
			return false;
		}
	}
}

