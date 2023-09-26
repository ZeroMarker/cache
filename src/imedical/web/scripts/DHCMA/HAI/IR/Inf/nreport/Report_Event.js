/**
 * 
 * @authors liyi (124933390@qq.com)
 * @date    2017-09-13 16:25:35
 * @version v1.0
 */
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
		
		//增加系统参数设置是否隐藏添加
		//btnINFOPSAdd btnINFLabAdd btnINFAntiAdd
		var configVal= $m({
			ClassName:"DHCHAI.BT.Config",
			MethodName:"GetValByCode",		
			aCode: "InfReportAddBtnHidden",
			aHospDr: $.LOGON.HOSPID
		},false);
		if (configVal!= ''){
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
			$.messager.popover({msg: '提交成功！',type:'success',timeout: 2000});
		}else{
			$.messager.alert("提示", '提交失败！', 'info');
    	};
	});

	// 审核
	$('#btnCheck').click(function (e) {
		if (!obj.CheckInputData(3)){
			return;
		}
    	if (obj.Save()){
			$.messager.popover({msg: '审核成功！',type:'success',timeout: 2000});	
    	}else{
			$.messager.alert("提示", '审核失败！', 'info');
    	};
	});

	// 删除
	$('#btnDelete').click(function (e) {
		$.messager.confirm("提示", "确认是否删除", function (r) {
			if (r){				
				if (obj.SaveStatus(4)){
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 2000});
				}else{
					$.messager.alert("提示", '删除失败！', 'info');
				};
			}
		});
	});

	// 退回
	$('#btnReturn').click(function (e) {
		$.messager.confirm("退回报告", "您确定要退回这份报告吗？", function(r){
			if (r){
				$.messager.prompt("退回报告", "请输入退回原因!", function(txt){
					if (txt){
						if(obj.SaveStatus(5,txt)){
							$.messager.popover({msg:  "退回成功！",type:'success',timeout: 2000});	
						} else {
							$.messager.alert("提示", "退回失败！",'info');				
						}
					}else if (txt==='') {
						$.messager.alert("提示", "未输入退回原因,报告不能退回！",'info');
					}
				});
			}
			
		});
	});

	// 取消审核
	$('#btnUnCheck').click(function (e) {
    	if (obj.SaveStatus(6)){
			$.messager.popover({msg: '取消审核成功！',type:'success',timeout: 2000});	
    	}else{
    		$.messager.alert("提示", '取消审核失败！', 'info');
    	};
	});
	
	// 导出
	$('#btnExport').click(function(e){
	});
	
	//关闭
	$('#btnClose').click(function(e){
		if (PageType!= 'WinOpen') {
			websys_showModal('close');		
		}else {
			window.close();
		}
	});
	// 数据完整性验证
	obj.CheckInputData = function (statusCode){
		obj.InputRep 		= obj.Rep_Save(statusCode);		// 报告主表信息
		obj.InputRepLog 	= obj.RepLog_Save(statusCode);	// 日志
    	obj.InputPreFactors = obj.PreFactor_Save();			// 易感因素
    	obj.InputDiag 		= obj.DIAG_Save();				// 感染信息
    	obj.InputLab 		= obj.LAB_Save();				// 病原学送检
    	obj.InputAnti 		= obj.ANT_Save();				// 抗菌药物
		if (!obj.InputDiag) {
			return false;
		}
    	return true;
	}

	// 保存报告内容+状态
	obj.Save = function (){
		var ret = $cm({
			ClassName:"DHCHAI.IRS.INFReportSrv",
			MethodName:"SaveINFReport",
			aRepInfo:obj.InputRep, 
			aPreFactors :obj.InputPreFactors,
			aInvasOpers :'',
			aDiags :obj.InputDiag,
			aOPSs :'',
			aLabs :obj.InputLab,
			aAntis :obj.InputAnti,
			aRepLog :obj.InputRepLog,
			aCSS :''			
		},false);
     
    	if (parseInt(ret)>0){
    		ReportID = parseInt(ret);
    		obj.refreshReportInfo();
    		obj.refreshgridINFLab();
    		obj.refreshgridINFAnti();
    		obj.InitButtons();
    		
    	    if (PageType!= 'WinOpen') { //解决老版公共卫生事件打开报告无法执行的问题
				//新建报告保存成功后不关闭窗口直接刷新时，界面显示空白问题处理
				if (typeof(history.pushState) === 'function') {
				  	var Url=window.location.href;
			        Url=rewriteUrl(Url, {
				        ReportID:ReportID
			        });
			    	history.pushState("", "", Url);
			        return true;
				}
    	    }
		
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
		var InputRepLog = obj.RepLog_Save(statusCode,Opinion);	// 日志
		var ret =  $m({
			ClassName:"DHCHAI.IRS.INFReportSrv",
			MethodName:"SaveINFReportStatus",
			aRepLog :InputRepLog, 
			separete:CHR_1
		},false);
    	if (parseInt(ret)>0){
    		obj.refreshReportInfo();
    		obj.InitButtons();
    		return true;
    	}else{
    		return false;
    	}
	}
}

