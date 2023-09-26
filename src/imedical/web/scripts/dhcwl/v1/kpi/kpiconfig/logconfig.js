$(document).ready(function(){ 
	/*--初始化加载复选框数据--*/
	refreshCheckBox()

	/*--点击保存按钮后的响应事件--*/
	$("#logconfigButton").click(function(e){
		$.messager.confirm("提示","本次修改将所有指标生效,您确定保存么？",function(r){
			if (r){
				var processValue,queryValue,defineValue,errValue,logInfors;
				processValue = $("#GlobalKpiLogDataProcessCfg").checkbox("getValue");
				queryValue = $("#GlobalKpiLogDataQueryCfg").checkbox("getValue");
				defineValue = $("#GlobalKpiLogDefinitionCfg").checkbox("getValue");
				errValue = $("#GlobalKpiLogTaskErrCfg").checkbox("getValue");
				logInfors = "GlobalKpiLogDataProcessCfg" + "," + "指标数据处理日志全局配置" + "," + processValue;
				logInfors = logInfors + "||" + "GlobalKpiLogDataQueryCfg" + "," + "指标数据查询日志全局配置" + "," + queryValue;
				logInfors = logInfors + "||" + "GlobalKpiLogDefinitionCfg" + "," + "指标定义日志全局配置" + "," + defineValue;
				logInfors = logInfors + "||" + "GlobalKpiLogTaskErrCfg" + "," + "指标任务错误日志全局配置" + "," + errValue;
				//alert(logInfors);
				//return;
				$m({
					ClassName:'web.DHCWL.V1.KPI.SysConfigFunction',
					MethodName:'SaveLogConfig',
					logConfigs:logInfors
				},function(e){
					refreshCheckBox();
					myMsg(e);
					
				})
			}else{
				refreshCheckBox();
			}
		})
	})


	/*--刷新复选框--*/
	function refreshCheckBox()
	{
		$("#GlobalKpiLogDataProcessCfg").checkbox("uncheck");
		$("#GlobalKpiLogDataQueryCfg").checkbox("uncheck");
		$("#GlobalKpiLogDefinitionCfg").checkbox("uncheck");
		$("#GlobalKpiLogTaskErrCfg").checkbox("uncheck");
		$("#GlobalTaskInitCfg").checkbox("uncheck");
		$("#GlobalTaskSuspendCfg").checkbox("uncheck");
		$cm({
			ClassName:'web.DHCWL.V1.KPI.SysConfigFunction',
			QueryName:'GetLogConfigQuery'
		},function(e){
			if (e){
				var rows,code,value;
				rows = e.rows;
				var logArr = [];
				var len = e.rows.length;
				for(var i = 0;i < len;i++){
					code = rows[i].code;
					value = rows[i].value;
					logArr[code] = value;
				}
				if (logArr['GlobalKpiLogDataProcessCfg'] == 'true'){
					$("#GlobalKpiLogDataProcessCfg").checkbox("check");
				}
				if (logArr['GlobalKpiLogDataQueryCfg'] == 'true'){
					$("#GlobalKpiLogDataQueryCfg").checkbox("check");
				}
				if (logArr['GlobalKpiLogDefinitionCfg'] == 'true'){
					$("#GlobalKpiLogDefinitionCfg").checkbox("check");
				}
				if (logArr['GlobalKpiLogTaskErrCfg'] == 'true'){
					$("#GlobalKpiLogTaskErrCfg").checkbox("check");
				}
				if (logArr['GlobalTaskInitCfg'] == 'Y'){
					$("#GlobalTaskInitCfg").checkbox("check");
				}
				if (logArr['GlobalTaskSuspendCfg'] == 'Y'){
					$("#GlobalTaskSuspendCfg").checkbox("check");
				}
			}
		})
	}
}