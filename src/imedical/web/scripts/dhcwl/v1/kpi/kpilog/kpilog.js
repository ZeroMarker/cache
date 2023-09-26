$HUI.datagrid("#logShowGrid",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.KPI.LogFunction',
		QueryName:'GetLogInforQuery'
	},
	pagination:true,
	pageList:[10,15,20,50,100,500],
	pageSize:15,
	rownumbers:true,
	//fitColumns:true,
	toolbar:"#tableToolbar",
	onDblClickCell: function(index,field,value){
		$("#logShowDialog").show();
		$HUI.dialog("#logShowDialog",{
			modal:true,
			resizable:true
		})
		$("#logShowTextbox").val(value);
		//$(this).datagrid('beginEdit', index);
		//var ed = $(this).datagrid('getEditor', {index:index,field:field});
		//$(ed.target).focus();
	}
})
$("#logShowTextbox").attr('readonly',true);

/*--监听主界面下拉框的选择--*/
$("#logType").combobox({
	onSelect:function(e){
		chageLogShowCol(e.value);
		var value = e.value;
		value = chageLogTypeName(value);
		var startDate = $("#startDate").datebox("getValue");
		var endDate = $("#endDate").datebox("getValue");
		$("#logShowGrid").datagrid("load",{ClassName:'web.DHCWL.V1.KPI.LogFunction',QueryName:'GetLogInforQuery',loginType:value,startDate:startDate,endDate:endDate});
		//KpiLogTaskErr,KpiLogDataProcess,KpiLogDataQuery,KpiLogDefinition
	}
});


/*--日志查询--*/
$("#defineButton").click(function(e){
	var logType = $("#logType").combobox("getValue");
	var startDate = $("#startDate").datebox("getValue");
	var endDate = $("#endDate").datebox("getValue");
	chageLogShowCol(logType);
	
	var value = logType;
	value = chageLogTypeName(value);
	$("#logShowGrid").datagrid("load",{ClassName:'web.DHCWL.V1.KPI.LogFunction',QueryName:'GetLogInforQuery',loginType:value,startDate:startDate,endDate:endDate});
	//alert(logType+"^"+startDate);
})

/*--清空选择框--*/
$("#cleanButton").click(function(e){
	$("#startDate").datebox("setValue","");
	$("#endDate").datebox("setValue","");
	var logType = $("#logType").combobox("getValue");
	chageLogShowCol(logType);
	
	var value = logType;
	value = chageLogTypeName(value);
	$("#logShowGrid").datagrid("load",{ClassName:'web.DHCWL.V1.KPI.LogFunction',QueryName:'GetLogInforQuery',loginType:value});
})

/*--下拉框选择后转换选中的日志类型名称--*/
function chageLogTypeName(value)
{
	if (value == "defineLog"){
		value = "KpiLogDefinition";
	}else if(value == "processLog"){
		value = "KpiLogDataProcess";
	}else if(value == "queryLog"){
		value = "KpiLogDataQuery";
	}else if(value == "errLog"){
		value = "KpiLogTaskErr";
	}
	return value;
}
/*--日志局部配置---*/
$("#configKPILog").click(function(e){
	$HUI.datagrid("#logConfigGrid",{
		url:$URL,  //固定写法
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.KPIFunction", //方法或者query路径
			QueryName:"GetKPILogQuery", //query名
			kpiIds:"",
			type:"",
			isLogConfig:"1"
		},
		columns:[[
			{field:'box',checkbox:true,width:100,title:'box'},
			{field:'kpiCode',width:470,title:'指标编码'},
			{field:'KpiLogDefinition',width:270,title:'指标定义日志',
				formatter:function(value,rec,rowIndex) {
					if (rec.KpiLogDefinition == "false") {
						return '<input type = \"checkbox\" id="KpiLogDefinition_'+rowIndex+'" name = \"log1\" >';
					}else{
						return '<input type = \"checkbox\" id="KpiLogDefinition_'+rowIndex+'" name = \"log1\" checked=\"checked\">';
					}
				}
			},
			{field:'KpiLogDataProcess',width:270,title:'数据处理日志',
				formatter:function(value,rec,rowIndex) {
					if (rec.KpiLogDataProcess == "false") {
						return '<input type = \"checkbox\" id="KpiLogDataProcess_'+rowIndex+'" name = \"log1\" >';
					}else{
						return '<input type = \"checkbox\" id="KpiLogDataProcess_'+rowIndex+'" name = \"log1\" checked=\"checked\">';
					}
				}
			},
			{field:'KpiLogDataQuery',width:270,title:'数据查询日志',
				formatter:function(value,rec,rowIndex) {
					if (rec.KpiLogDataQuery == "false") {
						return '<input type = \"checkbox\" id="KpiLogDataQuery'+rowIndex+'" name = \"log1\" >';
					}else{
						return '<input type = \"checkbox\" id="KpiLogDataQuery'+rowIndex+'" name = \"log1\" checked=\"checked\">';
					}
				
				}
			},
			{field:'KpiLogTaskErr',width:270,title:'任务错误日志',
				formatter:function(value,rec,rowIndex) {
					if (rec.KpiLogTaskErr == "false") {
						return '<input type = \"checkbox\" id="KpiLogTaskErr'+rowIndex+'" name = \"log1\" >';
					}else{
						return '<input type = \"checkbox\" id="KpiLogTaskErr'+rowIndex+'" name = \"log1\" checked=\"checked\">';
					}
				}
			}
		]],
		onClickRow:function(index,row){
			//$('#configKPILog').datagrid('clearSelections');
			if($('#KpiLogDefinition_'+index).get(0).checked){
				row.KpiLogDefinition = "true";
			}else{
				row.KpiLogDefinition = "false";
			}
			if($('#KpiLogDataProcess_'+index).get(0).checked){
				row.KpiLogDataProcess = "true";
			}else{
				row.KpiLogDataProcess = "false";
			} 
			if($('#KpiLogDataQuery'+index).get(0).checked){
				row.KpiLogDataQuery = "true";
			}else{
				row.KpiLogDataQuery = "false";
			}
			if($('#KpiLogTaskErr'+index).get(0).checked){
				row.KpiLogTaskErr = "true";
			}else{
				row.KpiLogTaskErr = "false";
			}
		},
		fitColumns:true,
		toolbar:"#dialogToolbar"
	})
	
	$("#logPartConfig").show();
	$HUI.dialog("#logPartConfig",{
		iconCls:'icon-w-config',
		title:'日志局部配置',
		resizable:true,
		modal:true
	})
})

/*--指标选择界面--*/
$("#addButton").click(function(e){
	$("#searchKPIText").searchbox("setValue","");
	var kpiCodes = GetKPICodeList();
	$HUI.datagrid("#kpiSelectGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.LogFunction",  //调用方法或query的路径
			QueryName:"GetAllKPINOCFGQuery",  //调用query名
			kpiCodes:kpiCodes
		},
		pagination:true,
		pageSize:15,
		pageList:[10,15,30,50,100,500],
		fitColumns:true,
		toolbar:'#KPISearchTool',
		onDblClickRow:function(rowIndex,field,value){
			var rules = field.kpiCode + ",false" + ",false" + ",false" + ",false";
			$m({
				ClassName:'web.DHCWL.V1.KPI.LogFunction',
				MethodName:'UpDateKPILogMain',
				logConfigRules:rules,
				type:'add'
			},function(textData){
				myMsg(textData);
				$("#logConfigGrid").datagrid("reload");
				$HUI.dialog("#kpiSelectDialog").close();
			})
			/*$("#logConfigGrid").datagrid("insertRow",{
				row:{
					kpiCode:field.kpiCode,
					KpiLogDefinition:"false",
					KpiLogDataProcess:"false",
					KpiLogDataQuery:"false",
					KpiLogTaskErr:"false"
				}
			})*/
		}
	})
	$("#kpiSelectDialog").show();
	$HUI.dialog("#kpiSelectDialog",{
		iconCls:'icon-w-add',
		title:'尚未配置局部日志的指标',
		resizable:true,
		modal:true
	})
})

/*--查询指标--*/
$("#searchKPIText").searchbox({
	searcher:function(value,name){
		var kpiCodes = GetKPICodeList();
		$("#kpiSelectGrid").datagrid("load",{ClassName:'web.DHCWL.V1.KPI.LogFunction',QueryName:'GetAllKPINOCFGQuery',kpiCodes:kpiCodes,filterValue:value})
	}
})

/*--执行该方法用于根据用户选择的日志类型动态隐藏列--*/
function chageLogShowCol(logType)
{
	$("#logShowGrid").datagrid("showColumn","calledFunction");
	$("#logShowGrid").datagrid("showColumn","MKPIIdList");
	$("#logShowGrid").datagrid("showColumn","prePropertyList");
	$("#logShowGrid").datagrid("showColumn","postPropertyList");
	$("#logShowGrid").datagrid("showColumn","paraKPIRule");
	$("#logShowGrid").datagrid("showColumn","paraFilterRule");
	$("#logShowGrid").datagrid("showColumn","paraDateScope");
	$("#logShowGrid").datagrid("showColumn","paraOther");
	$("#logShowGrid").datagrid("showColumn","operateState");
	$("#logShowGrid").datagrid("showColumn","otherContent");
	switch (logType)
	{
		case "defineLog":
			$("#logShowGrid").datagrid("hideColumn","calledFunction");
			$("#logShowGrid").datagrid("hideColumn","paraKPIRule");
			$("#logShowGrid").datagrid("hideColumn","paraFilterRule");
			$("#logShowGrid").datagrid("hideColumn","paraDateScope");
			$("#logShowGrid").datagrid("hideColumn","paraOther");
			$("#logShowGrid").datagrid("hideColumn","operateState");
			break;
		case "processLog":
			$("#logShowGrid").datagrid("hideColumn","prePropertyList");
			$("#logShowGrid").datagrid("hideColumn","postPropertyList");
			$("#logShowGrid").datagrid("hideColumn","operateState");
			break;
		case "errLog":
			$("#logShowGrid").datagrid("hideColumn","MKPIIdList");
		case "queryLog":
			$("#logShowGrid").datagrid("hideColumn","prePropertyList");
			$("#logShowGrid").datagrid("hideColumn","postPropertyList");
			$("#logShowGrid").datagrid("hideColumn","paraKPIRule");
			$("#logShowGrid").datagrid("hideColumn","paraFilterRule");
			break;
			
	}
}

/*--获取当前已配置日志的指标编码列表--*/
function GetKPICodeList()
{
	var rows,rowLen,kpiCodes;
	rows = $("#logConfigGrid").datagrid("getRows");
	rowLen = rows.length;
	if (rowLen > 0){
		for (var i = 0;i < rows.length;i++){
			kpiCode = rows[i].kpiCode;
			if (kpiCodes){
				kpiCodes = kpiCodes + "," +kpiCode;
			}else{
				kpiCodes = kpiCode;
			}
		}
	}
	return kpiCodes;
}

/*--日志局部配置删除--*/
$("#deleteButton").click(function(e){
	var rows = $("#logConfigGrid").datagrid("getChecked");
	var rowLen = rows.length;
	if(rows.length == 0){
		myMsg("请先选择需要删除的指标");
		return;
	}
	var kpiCode,kpiCodes = "";
	for(var i = 0;i < rowLen;i++){  //获取选中记录的指标串
		kpiCode = rows[i].kpiCode;
		if (kpiCodes){
			kpiCodes = kpiCodes + ";" + kpiCode;
		}else{
			kpiCodes = kpiCode;
		}
	}
	$.messager.confirm("删除","删除后将不能恢复,确定要删除么？",function(e){
		if(e){
			$m({  //调用后台方法删除选中的指标配置
				ClassName:'web.DHCWL.V1.KPI.LogFunction',
				MethodName:'DeleteKPILogConfig',
				kpisCodeStr:kpiCodes
			},function(textData){
				myMsg(textData);
				$("#logConfigGrid").datagrid('load');
			});
		}
	})
})

/*--日志局部配置保存--*/
$("#saveButton").click(function(e){
	var row = $("#logConfigGrid").datagrid("getChecked");
	var rowLen = row.length;
	if (rowLen < 1){
		myMsg("请先选择需要保存的指标");
		return;
	}
	var logRules = "",logRule = "",kpiCode = "",defineLog = "",handlerLog = "",inquireLog = "",errLog = "";
	for (var i = 0;i < rowLen;i++){
		kpiCode = row[i].kpiCode;
		defineLog = row[i].KpiLogDefinition;
		handlerLog = row[i].KpiLogDataProcess;
		inquireLog = row[i].KpiLogDataQuery;
		errLog = row[i].KpiLogTaskErr;
		logRule = kpiCode + "," + defineLog + "," + handlerLog + "," + inquireLog + "," + errLog
		if (logRules == ""){
			logRules = logRule;
		}else{
			logRules = logRules + "||" + logRule;
		}
	}
	//alert(logRules);
	//return;
	$m({
		ClassName:'web.DHCWL.V1.KPI.LogFunction',
		MethodName:'UpDateKPILogMain',
		logConfigRules:logRules
	},function(textData){
		myMsg(textData);
		$("#logConfigGrid").datagrid("load");
	})
})

/*--日志局部配置查询--*/
$("#inquireButton").click(function(e){
	var kpiValue = $("#kpiCodeInput").val();
	var typeValue = $("#logFunType").combobox("getValue");
	//alert(kpiValue+"^"+typeValue);
	$("#logConfigGrid").datagrid("load",{ClassName:'web.DHCWL.V1.KPI.KPIFunction',QueryName:'GetKPILogQuery',kpiIds:'',type:typeValue,filterValue:kpiValue,isLogConfig:'1'});
})