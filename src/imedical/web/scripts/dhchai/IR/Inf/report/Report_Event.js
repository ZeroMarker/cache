/**
 * 
 * @authors liyi (124933390@qq.com)
 * @date    2017-09-13 16:25:35
 * @version v1.0
 */
function InitReportWinEvent(obj){
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
				if(arr[0]=="1")
				{
					$('#btnINFOPSAdd').hide();
				}
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
				$('#btnExport').show();
				if (obj.AdminPower==1){	// 管理员
					$('#btnCheck').show();
					$('#btnReturn').show();
					$('#btnDelete').show();
				}
				break;
			case '3':       // 审核
				$('#btnExport').show();
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
	
	//易感因素侵害性操作根据数量自动调节高度
	var maxHeight = ($("#chkPreFactor").height() > $("#chkInvasOper").height()) ? ($("#chkPreFactor").height()+10) : ($("#chkInvasOper").height()+10);
	$(".FacOperDetail").height(maxHeight);
	$(".FacOper").css("min-height",(maxHeight + $(".FacHeader").outerHeight() + 10)+"px");

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
		layer.confirm( '确认是否删除?', {
			btn: ['确认','取消'],    //btn位置对应function的位置
			btnAlign: 'c'
			},
			function(){
				if (obj.SaveStatus(4)){
					layer.msg('删除成功!',{icon: 1});
				}else{
					layer.msg('删除失败!',{icon: 2});
				};
		 });
	});

	// 退回
	$('#btnReturn').click(function (e) {
		obj.LayerReturn();
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
	/**$('#btnExport').click(function(e){
		var url="dhccpmrunqianreport.csp?reportName=DHCHAIReport.raq&aReportID="+ReportID+"&aEpisodeID="+EpisodeID;
        websys_createWindow(url,1,"width=710,height=610,top=0,left=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");

	})**/
	/**
	//导出改为润乾直接打印
	$('#btnExport').click(function(e){
		var fileName="DHCHAIReport.raq&aReportID="+ReportID+"&aEpisodeID="+EpisodeID;
		DHCCPM_RQDirectPrint(fileName);
		});
		**/
		//导出改为润乾预览印
		$('#btnExport').click(function(e){
		var fileName="DHCHAIReport.raq&aReportID="+ReportID+"&aEpisodeID="+EpisodeID;
		DHCCPM_RQPrint(fileName);
		});
	
	
	// 退回原因
	obj.LayerReturn = function(){
		$.form.iCheckRender();
		$.form.SelectRender('cboSpecimenType');
		
		layer.config({  
			extend: 'layerskin/style.css' 
		});
		layer.open({
			type: 1,
			zIndex: 100,
			area: ['400px','200px'],
			title: '退回原因', 
			content: $('#LayerReturnAtt'),
			btn: ['保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
				var ReturnReason = $.form.GetValue("txtReturnReason");
				if (ReturnReason==''){
					layer.msg('请填写退回原因!',{icon: 2});
					return;
				}else{
					if (obj.SaveStatus(5,ReturnReason)){
			    		layer.msg('退回成功!',{icon: 1});
						layer.close(index);
			    	}else{
			    		layer.msg('退回失败!',{icon: 2});
			    	};
				}
			}
		});	
	}
	
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
    	obj.InputInvasOpers = obj.InvasOper_Save();			// 侵害性操作
    	obj.InputDiag 		= obj.DIAG_Save();				// 感染信息
    	obj.InputOPS 		= obj.OPR_Save();				// 手术信息
    	obj.InputLab 		= obj.LAB_Save();				// 病原学送检
    	obj.InputAnti 		= obj.ANT_Save();				// 抗菌药物
    	if (obj.InputDiag==''){
    		layer.msg('感染信息不能为空!',{icon: 2});
			return false;
    	}
    	return true;
	}

	// 保存报告内容+状态
	obj.Save = function (){
    	var ret = $.Tool.RunServerMethod('DHCHAI.IRS.INFReportSrv','SaveINFReport',obj.InputRep,obj.InputPreFactors,obj.InputInvasOpers,obj.InputDiag,obj.InputOPS,obj.InputLab,obj.InputAnti,obj.InputRepLog)
    	if (parseInt(ret)>0){
    		ReportID = parseInt(ret);
    		obj.refreshReportInfo();
    		obj.refreshgridINFDiagnos();
    		obj.refreshgridINFOPS();
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
		var Opinion = arguments[1];
		if (typeof(Opinion)=='undefined'){
			Opinion='';
		}
		var InputRepLog 	= obj.RepLog_Save(statusCode,Opinion);	// 日志
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
	obj.checkNowDate = function(d,h){
		d = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","DateHtmlToLogical",d);
		var cNowDate = $.form.GetCurrDate('-');
		var NowTime = new Date();
		var NowTimeh = NowTime.getHours();
		var NowTimem = NowTime.getMinutes();
		if(NowTimem<10){
			NowTimem='0'+NowTimem;
		}
		var CNowTime =NowTimeh+":"+NowTimem;
		a = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","DateHtmlToLogical",d);
		b = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","DateHtmlToLogical",cNowDate);
		var flag1 = b-a;
		m1 = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","TimeHtmlToLogical",h);
		m2 = $.Tool.RunServerMethod("DHCHAI.IO.FromHisSrv","TimeHtmlToLogical",CNowTime);
		var flag2 = m1-m2;
		if((flag1 == 0)&&(flag2>=0)){
			return true;
		}else{
			return false;
		}
	}

}

