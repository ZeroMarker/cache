/**
* @ Creator   : wk
* @ CreatDate : 2018-05-02
* @ Desc      : 指标预览数据的取数规则和过滤规则配置界面(显示在主界面中)
*/﻿

//***********************************************************************
//----------------------指标取数规则配置界面-----------------------------
//***********************************************************************

//var kpiBodyHeight = getViewportOffset().y;   // 获取屏幕高度
/*--定义数组用来记录选中指标(取数规则配置)--*/
	var selectedKPICodeListForRule,kpiRuleObjForRule;
	selectedKPICodeListForRule = [],kpiRuleObjForRule={};
	var ruleKPIShowTableObj;

/*--指标预览数据的取数规则弹出框(为了弹窗的全屏显示)--*/
function showKPIRuleConfig(kpiRuleValue){
	$('#kpiRuleSearchKPIInfor').searchbox("setValue","");
	//将选中的指标信息转换成数组
	kpiRuleObjForRule={};
	selectedKPICodeListForRule = [];
	resolveKPIRule(kpiRuleValue);
	
	//弹出取数规则配置页面
	$("#kpiRuleConfigDialog").show();
	$HUI.dialog("#kpiRuleConfigDialog",{
		height:kpiBodyHeight-10,
		iconCls:'icon-w-config',
		resizable:true,
		modal:true
	});
	
	//加载指标表格
	ruleKPIShowTableObj = $HUI.datagrid("#kpiTableForSearch",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.KPIFunction",  //调用方法或query的路径
			QueryName:"GetKPIListQuery"  //调用query名
		},
		pagination:true,
		striped:true,
		pageSize:15,
		pageList:[10,15,20,50,100],
		toolbar:"#kpiRuleSearchAllBox",
		onLoadSuccess:function(data){
			$(".datagrid-header-check").html("");
		    var rows = data.rows;
		    for (var i = 0;i < rows.length;i++){
			    if ($.inArray(rows[i].kpiCode,selectedKPICodeListForRule) > -1 ){
				    $("#kpiTableForSearch").datagrid("selectRow",i);
			    }
		    }
	    },
	    onSelect:function(rowIndex,rowData){
		    var kpiCode = rowData.kpiCode;
		    selectedKPICodeListForRule.unshift(kpiCode);
		    if (!kpiRuleObjForRule.hasOwnProperty(kpiCode)){
			    kpiRuleObjForRule[kpiCode] = {};
			    kpiRuleValue =  refreshKPIRule(kpiRuleObjForRule);
				$("#kpiRuleListBox").val(kpiRuleValue);
				kpiDimTreeObj.load({ClassName:"web.DHCWL.V1.KPI.KPIFunction",QueryName:"GetKPIRuleTreeQuery",inputRule:kpiRuleValue,rows:10000,page:1});
		    }
	    },
	    onUnselect:function(rowIndex,rowData){
		    var kpiCode = rowData.kpiCode;
		   	for (x in selectedKPICodeListForRule) {
		    	if (selectedKPICodeListForRule[x] == rowData.kpiCode){
			    	selectedKPICodeListForRule.splice(x,1);
		    	}
	    	}
		    if (kpiRuleObjForRule.hasOwnProperty(kpiCode)){
			    delete kpiRuleObjForRule[kpiCode];
			    kpiRuleValue =  refreshKPIRule(kpiRuleObjForRule);
				$("#kpiRuleListBox").val(kpiRuleValue);
				kpiDimTreeObj.load({ClassName:"web.DHCWL.V1.KPI.KPIFunction",QueryName:"GetKPIRuleTreeQuery",inputRule:kpiRuleValue,rows:10000,page:1});
		    }
	    }
	});
	
	
	//将父页面的取数规则放到取数规则列表中
	refreshKPIRuleObj(kpiRuleValue);
	kpiRuleValue =  refreshKPIRule(kpiRuleObjForRule);
	$("#kpiRuleListBox").val(kpiRuleValue);
	//$("#configKPIRuleTree").treegrid('loadData',{total:0,rows:[]})
	
	//指标取数规则配置树
	var kpiDimTreeObj = $HUI.treegrid("#configKPIRuleTree",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.KPIFunction",
			QueryName:"GetKPIRuleTreeQuery",
			inputRule:kpiRuleValue,
			rows:10000,
			page:1
		},
		fitColumns:true,
		toolbar:"#kpiRuleList",
		onCheckNode:function(row,checked){
			if (row){
				var type = row.type;
				if (type == "KPIDIM"){
					code = row.code;
					kpiNode = $("#configKPIRuleTree").treegrid("getParent",row.ID);
					kpiCode = kpiNode.code;
					if (checked){
						if (!kpiRuleObjForRule.hasOwnProperty(kpiCode)){
							kpiRuleObjForRule[kpiCode] = {};
						}
						if (!kpiRuleObjForRule[kpiCode].hasOwnProperty(code)){
							kpiRuleObjForRule[kpiCode][code] = {};
						}
					}else{
						if (isOwnEmpty(kpiRuleObjForRule[kpiCode][code])){
							delete kpiRuleObjForRule[kpiCode][code];
						}
					}
				}else if(type == "DIMPRO"){
					code = row.code;
					dimNode = $("#configKPIRuleTree").treegrid("getParent",row.ID);
					dimCode = dimNode.code;
					kpiNode = $("#configKPIRuleTree").treegrid("getParent",dimNode.ID);
					kpiCode = kpiNode.code;
					if (checked){
						if (!kpiRuleObjForRule.hasOwnProperty(kpiCode)){
							kpiRuleObjForRule[kpiCode] = {};
						}
						if (!kpiRuleObjForRule[kpiCode].hasOwnProperty(dimCode)){
							kpiRuleObjForRule[kpiCode][dimCode] = {};
						}
						if (!kpiRuleObjForRule[kpiCode][dimCode].hasOwnProperty(code)){
							kpiRuleObjForRule[kpiCode][dimCode][code] = "";
						}
					}else{
						delete kpiRuleObjForRule[kpiCode][dimCode][code];
						if ((!dimNode.checked)&&(isOwnEmpty(kpiRuleObjForRule[kpiCode][dimCode]))){
							delete kpiRuleObjForRule[kpiCode][dimCode]
						}
					}
				}else if(type =="SECDIM"){
					code = row.code;
					kpiNode = $("#configKPIRuleTree").treegrid("getParent",row.ID);
					kpiCode = kpiNode.code;
					code = "$" + code;
					if (checked){
						if (!kpiRuleObjForRule.hasOwnProperty(kpiCode)){
							kpiRuleObjForRule[kpiCode] = {};
						}
						if (!kpiRuleObjForRule[kpiCode].hasOwnProperty(code)){
							kpiRuleObjForRule[kpiCode][code] = {};
						}
					}else{
						if (isOwnEmpty(kpiRuleObjForRule[kpiCode][code])){
							delete kpiRuleObjForRule[kpiCode][code];
						}
					}
				}else if (type == "SECDIMPRO"){
					code = row.code;
					secDimNode = $("#configKPIRuleTree").treegrid("getParent",row.ID);
					secDimCode = "$" + secDimNode.code;
					kpiNode = $("#configKPIRuleTree").treegrid("getParent",secDimNode.ID);
					kpiCode = kpiNode.code;
					if (checked){
						if (!kpiRuleObjForRule.hasOwnProperty(kpiCode)){
							kpiRuleObjForRule[kpiCode] = {};
						}
						if (!kpiRuleObjForRule[kpiCode].hasOwnProperty(secDimCode)){
							kpiRuleObjForRule[kpiCode][secDimCode] = {};
						}
						if (!kpiRuleObjForRule[kpiCode][secDimCode].hasOwnProperty(code)){
							kpiRuleObjForRule[kpiCode][secDimCode][code] = "";
						}
					}else{
						delete kpiRuleObjForRule[kpiCode][secDimCode][code];
						if ((!secDimNode.checked)&&(isOwnEmpty(kpiRuleObjForRule[kpiCode][secDimCode]))){
							delete kpiRuleObjForRule[kpiCode][secDimCode]
						}
					}
				}
			}
			var kpiRuleValue =  refreshKPIRule(kpiRuleObjForRule);
			$("#kpiRuleListBox").val(kpiRuleValue);
		}
	
	});
}


//根据查询条件检查
$('#kpiRuleSearchKPIInfor').searchbox({
	searcher:function(value,name){
		ruleKPIShowTableObj.load({ClassName:"web.DHCWL.V1.KPI.KPIFunction",QueryName:"GetKPIListQuery",filterValue:value});  //重新加载指标信息
	}
});

function freshKPIRuleTableFun(kpiInforList){
	var kpiCode,kpiName,kpiMea,kpiExeCode,dataNode,kpiCreator,kpiDimCodes,kpiDesc,kpiType,kpiSection,kpiValueType,kpiRemark
	kpiInforArr = kpiInforList.split("@");
	kpiCode = kpiInforArr[0];
	kpiName = kpiInforArr[1];
	kpiMea = kpiInforArr[2];
	kpiExeCode = kpiInforArr[3];
	dataNode = kpiInforArr[4];
	kpiCreator = kpiInforArr[5];
	kpiDimCodes = kpiInforArr[6];
	kpiType = kpiInforArr[7];
	kpiRemark = kpiInforArr[8];
	ruleKPIShowTableObj.load({ClassName:"web.DHCWL.V1.KPI.KPIFunction",QueryName:"GetKPIListQuery",kpiCode:kpiCode, kpiName:kpiName, kpiExcode:kpiExeCode, createUser:kpiCreator, dataNode:dataNode, dimType:kpiDimCodes, category:kpiType,nodeMark:kpiRemark,filterMea:kpiMea});  //重新加载指标信息
}

//重新加载取数规则对象(将取数规则转换成对象)
function refreshKPIRuleObj(kpiRules)
{
	var kpiRulesArr,kpiRuleArr,kpiRule,kpiCode,rule,i;
	kpiRulesArr = [],kpiRuleArr = [],kpiRule="",kpiCode = "",rule = "";
	kpiRulesArr = kpiRules.split(",");
	for (i in kpiRulesArr){
		kpiRule = kpiRulesArr[i];
		if(typeof kpiRule === "function"){
			continue;
		}
		kpiRuleArr = kpiRule.split(":");
		kpiCode = kpiRuleArr[0];
		rule = kpiRuleArr[1];
		kpiRuleObjForRule[kpiCode] = {};
		var ruleArr = [];
		if (rule){
			ruleArr = rule.split("^");
		}
		var j;
		for (j in ruleArr){
			if(typeof ruleArr[j] === "function"){
				continue;
			}
			var dimArr = ruleArr[j].split(".");
			dimCode = dimArr[0];
			dimProCode = dimArr[1];
			if (dimCode){
				if (!(kpiRuleObjForRule[kpiCode].hasOwnProperty(dimCode))){
					kpiRuleObjForRule[kpiCode][dimCode] = {};
				}
				if(dimProCode) {
					if (!(kpiRuleObjForRule[kpiCode][dimCode].hasOwnProperty(dimProCode))){
						kpiRuleObjForRule[kpiCode][dimCode][dimProCode] = "";
					}
				}
			}
		}
	}
} 

//点击取数规则确定按钮时响应
$("#defineButton").click(function(){
	var value = $("#kpiRuleListBox").val();
	//alert(value);
	$HUI.dialog("#kpiRuleConfigDialog").close();
	document.getElementById("viewKPIData").contentWindow.setKPIRule(value);
})

//点击取数规则确定按钮时响应(模块与报表版本)
$("#defineDsButton").click(function(){
	$.messager.confirm("更新","当前取数规则将覆盖选中数据集原来的取数规则,确定更新么？",function(e){
		if(e){
			var value = $("#kpiRuleListBox").val();
			$HUI.dialog("#kpiRuleConfigDialog").close();
			saveKPIRule(value);
		}else{
			return;
		}
	})
})

//取数规则解析函数(将取数规则中的指标编码取出来,放到数组中)
function resolveKPIRule(kpiRuleValue)
{
	kpiRuleValue = kpiRuleValue || "";
	var kpiRuleListArr = kpiRuleValue.split(",");
	var i,kpiRuleListValue,kpiCode;
	for (i in kpiRuleListArr){
		kpiRuleListValue = kpiRuleListArr[i];
		if(typeof kpiRuleListValue === "function"){
			continue;
		}
		kpiCode = kpiRuleListValue.split(":")[0];
		selectedKPICodeListForRule.unshift(kpiCode);
	}
}


//***********************************************************************
//----------------------指标过滤规则配置界面-----------------------------
//***********************************************************************

/*--指标预览数据的过滤规则弹出框(为了弹窗的全屏显示)--*/
var kpiFilterParamsArr = [];
var arr = [];

/*--监听用户点击确定按钮--*/
$("#saveFilterFunButton").click(function(){
	var comboxValue = $("#operatorList").combobox("getValue");
	var value = $("#filterValue").val();
	if ((!value)) {
		myMsg("过滤值不能为空");
		return;
	}
	$HUI.dialog("#operatorSelector").close();
	datagridConfig(kpiFilterParamsArr[0],comboxValue,kpiFilterParamsArr[1],kpiFilterParamsArr[2],value);
})


function showKPIFilterConfig(kpiFilterValue,filterType,dsID){
	//首先移除所有的之前配置的过滤规则
	arr = [];
	$("#kpiFilterConfigDialog").show();
	$HUI.dialog("#kpiFilterConfigDialog",{
		height:kpiBodyHeight-50,
		width:kpiBodyWidth-50,
		iconCls:'icon-w-config',
		resizable:true,
		modal:true
	});
	
	
	/*--加载指标树--*/
	var kpiFilterTreeObj = $HUI.treegrid("#kpiFilterTree",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.KPIFunction",
			QueryName:"GetKPIRuleTreeQuery",
			inputRule:kpiFilterValue,
			rows:10000,
			page:1
		},
		toolbar:[],
		fitColumns:true,
		onDblClickRow:function(rowData){
			getFilterTreeAndFilterFun();
		}
	});
	
	var filterFunObj = $HUI.combogrid("#filterFun",{
		panelWidth:420,
		url:$URL+"?ClassName=web.DHCWL.V1.KPI.KPIFunction&QueryName=GetFilterFunQuery",
		mode:'remote',
		delay:200,
		idField:'FilterFuncCode',
		textField:'FilterFuncCode',
		onBeforeLoad:function(param){
			param.kpiCode = param.q;
		},
		columns:[[
			{field:'FilterFuncCode',title:'函数编码',width:100},
			{field:'Desc',title:'函数描述',width:100}
		]],
		fitColumns:true,
		pagination:true,
		pageSize:15,
		pageList:[10,15,20,50,100]
	});
	var ON_EDIT_FILTERROW = '-1';
	if (filterType == "module"){
		/*--加载过滤函数表达式表格--*/
		$HUI.propertygrid("#filterRuleGrid",{
			columns:[[
				{field:'operator',title:'运算规则',width:100,align:'left',editor:'text'},
				{field:'kpiRule',title:'指标规则',width:200,align:'left'},
				{field:'filterFun',title:'过滤函数',width:100,align:'left'},
				{field:'value',title:'过滤值',width:100,align:'left'},
				{field:'rightBracket',title:'运算符',width:100,align:'left',editor:'text'}
				
			]],
			showGroup:true,
			scrollbarSize: 0,
			fitColumns:true,
			toolbar:"#filterToobar"/*,
			onDblClickCell:function(rowIndex, field, value){
				if (ON_EDIT_FILTERROW == rowIndex){
					$('#filterRuleGrid').datagrid('endEdit', rowIndex);
					ON_EDIT_FILTERROW = "-1";
				}else if(ON_EDIT_FILTERROW != "-1"){
					$('#filterRuleGrid').datagrid('endEdit', ON_EDIT_FILTERROW);
					$('#filterRuleGrid').datagrid('beginEdit', rowIndex);
					ON_EDIT_FILTERROW = rowIndex;
				}else{
					$('#filterRuleGrid').datagrid('beginEdit', rowIndex);
					ON_EDIT_FILTERROW = rowIndex;
				}
			}*/
		})
	}else{
		/*--加载过滤函数表达式表格--*/
		$HUI.propertygrid("#filterRuleGrid",{
			columns:[[
				{field:'operator',title:'运算规则',width:100,align:'left',editor:'text'},
				{field:'kpiRule',title:'指标规则',width:200,align:'left'},
				{field:'filterFun',title:'过滤函数',width:100,align:'left'},
				{field:'value',title:'过滤值',width:100,align:'left'},
				{field:'rightBracket',title:'运算符',width:100,align:'left',editor:'text'}
				
			]],
			showGroup:true,
			scrollbarSize: 0,
			fitColumns:true,
			toolbar:"#filterToobar"/*,
			onDblClickCell:function(rowIndex, field, value){
				if (ON_EDIT_FILTERROW == rowIndex){
					$('#filterRuleGrid').datagrid('endEdit', rowIndex);
					ON_EDIT_FILTERROW = "-1";
				}else if(ON_EDIT_FILTERROW != "-1"){
					$('#filterRuleGrid').datagrid('endEdit', ON_EDIT_FILTERROW);
					$('#filterRuleGrid').datagrid('beginEdit', rowIndex);
					ON_EDIT_FILTERROW = rowIndex;
				}else{
					$('#filterRuleGrid').datagrid('beginEdit', rowIndex);
					ON_EDIT_FILTERROW = rowIndex;
				}
			}*/
		})
	}
	
	//初始化过滤表达式表格
	$('#filterRuleGrid').propertygrid('loadData',[{}]);
	/*--移除所有的过滤函数表格数据--*/
	var rows = $('#filterRuleGrid').datagrid('getRows');
	for (var i = rows.length - 1;i >= 0;i--){
		var  index = $("#filterRuleGrid").datagrid('getRowIndex',rows[i]);
		$("#filterRuleGrid").datagrid('deleteRow',index);
	}
	
	
}





/*--过滤函数确定按钮--*/
$("#filterDefineButton").click(function(e){
	var kpiFilterRules = changeFilterTableToRule();
	document.getElementById("viewKPIData").contentWindow.setFilterRule(kpiFilterRules);
	$HUI.dialog("#kpiFilterConfigDialog").close();
})

/*--过滤函数[]按钮--*/
$("#filterSymButton").click(function(e){
	var rows = $("#filterRuleGrid").propertygrid("getSelections");
	var len = rows.length;
	if (!len){
		myMsg("请先选中需要维护[]的表达式");
		return;
	}else{
		//检测需要加[]的记录是否都属于一个指标
		var kpiCode = rows[0].group;
		var operator,rightBracket;
		for (var i = 0;i < len;i++){
			kpiCodeForTest = rows[i].group;
			if (kpiCodeForTest != kpiCode){
				myMsg("只能选择同一个指标的记录哟~");
				return;
			} 
			
		}
		var start = $("#filterRuleGrid").propertygrid("getRowIndex",rows[0]);
		var end = $("#filterRuleGrid").propertygrid("getRowIndex",rows[len-1]);
		if ((end - start + 1) != len){
			myMsg("只能选择连续的数据");
			return;
		}
		var operator = rows[0].operator;         //为开始结束记录添加[]
		var rightBracket = rows[len-1].rightBracket;
		if (!rightBracket){
			rightBracket = "";
		}
		
		var calLeftStr = operator.substr(0,2);
		if ((calLeftStr == "&&")||(calLeftStr == "||")){
			var otherStr = operator.substr(2);
			operator = calLeftStr + "[" + otherStr;
		}else{
			operator = "[" + operator
		}
		
		$("#filterRuleGrid").propertygrid("updateRow",{   //将开始记录加[
			index:start,
			row:{
				operator:operator
			}
		})
		$("#filterRuleGrid").propertygrid("updateRow",{   //将结束记录加]
			index:end,
			row:{
				rightBracket:rightBracket + "]"
			}
		})
		//mergeCellByKpiCode(rows[0].kpiCode); //重新合并单元格
	}
})

/*--过滤函数!按钮--*/
$("#filterNoButton").click(function(e){
	var row = $("#filterRuleGrid").propertygrid("getSelected");
	if (!row){
		myMsg("请先选择维护的表达式");
		return;
	}
	var rows = $("#filterRuleGrid").propertygrid("getSelections");
	if (rows.length > 1){
		myMsg("只能选择一条记录进行维护");
		return;
	}
	var index = $("#filterRuleGrid").propertygrid("getRowIndex",row);
	var operator = row.operator;         //为开始结束记录添加!
	if (!operator){
		operator = "";
	}
	var calLeftStr = operator.substr(0,2);
	if ((calLeftStr == "&&")||(calLeftStr == "||")){
		var otherStr = operator.substr(2);
		operator = calLeftStr + "!" + otherStr;
	}else{
		operator = "!" + operator;
	}
	$("#filterRuleGrid").propertygrid("updateRow",{   //将开始记录
		index:index,
		row:{
			operator:operator
		}
	})
	//mergeCellByKpiCode(row.kpiCode); //重新合并单元格
})


/*--生成过滤规则--*/
$("#filterRuleButton").click(function(e){
	$("#filterShowDialog").show();
	$HUI.dialog("#filterShowDialog",{
		iconCls:'icon-w-list',
		resizable:true,
		modal:true
	});
	var kpiFilterRules = changeFilterTableToRule();
	$("#filterShowTextbox").val(kpiFilterRules);
})

/*--清空过滤表格数据--*/
$("#clearFilterRuleButton").click(function(e){
	arr = [];
	$("#filterRuleGrid").propertygrid('loadData',{total:0,rows:[]});
})



/*--将过滤规则的表格形式转换成表达式的形式--*/
function changeFilterTableToRule(){
	var rows = $("#filterRuleGrid").propertygrid("getRows");
	var len = rows.length,kpiCode;
	var kpiCode,operator,kpiRule,filterFun,value,rightBracket,kpiFilterRule;
	var filterObj = {};
	for (var i = 0;i < len;i++){
		kpiCode = rows[i].group;
		operator = rows[i].operator;
		kpiRule = rows[i].kpiRule;
		filterFun = rows[i].filterFun;
		value = rows[i].value;
		rightBracket = rows[i].rightBracket;
		var operatorValue = "";
		if (operator){
			operatorValue = " " + operator;
		}
		if (!rightBracket){
			rightBracket = "";
		}
		kpiFilterRule = operatorValue + "[{" + kpiRule + "} " + filterFun + " " + value + "]" + rightBracket;
		if (!filterObj.hasOwnProperty(kpiCode)){
			if ((operator.indexOf ("&&") > -1) || (operator.indexOf ("||") > -1)){
				myMsg("过滤规则配置有误");
				return;
			}else{
				filterObj[kpiCode] = kpiFilterRule;
			}
		}else{
			if ((operator.indexOf ("&&") > -1) || (operator.indexOf ("||") > -1)){
				filterObj[kpiCode] = filterObj[kpiCode] + kpiFilterRule;
			}else{
				myMsg("过滤规则配置有误");
				return;
			}
		}
	}
	var kpiFilterRules,kpiCode;
	for (kpiCode in filterObj){
		if (kpiFilterRules){
			kpiFilterRules = kpiFilterRules + "," + kpiCode + ":(" + filterObj[kpiCode] + ")";
		}else{
			kpiFilterRules = kpiCode + ":(" + filterObj[kpiCode] + ")";
		}
	}
	return kpiFilterRules;
}

/*--双击树节点和过滤函数之后运行的方法--*/
function getFilterTreeAndFilterFun(){	
	var row,kpiCode,kpiRule,dataGrid;
	row = $("#kpiFilterTree").treegrid("getSelected");
	if (!row){
		myMsg("请先选择指标信息");
		return;
	}
	
	if (row){
		var type = row.type;
		if (type == "KPIDIM"){
			code = row.code;
			kpiNode = $("#kpiFilterTree").treegrid("getParent",row.ID);
			kpiCode = kpiNode.code;
			kpiRule = code;
		}else if(type == "DIMPRO"){
			code = row.code;
			dimNode = $("#kpiFilterTree").treegrid("getParent",row.ID);
			dimCode = dimNode.code;
			kpiNode = $("#kpiFilterTree").treegrid("getParent",dimNode.ID);
			kpiCode = kpiNode.code;
			kpiRule = dimCode + "." +code;
		}else if(type =="SECDIM"){
			code = row.code;
			kpiNode = $("#kpiFilterTree").treegrid("getParent",row.ID);
			kpiCode = kpiNode.code;
			code = "$" + code;
			kpiRule = code;
		}else if (type == "SECDIMPRO"){
			code = row.code;
			secDimNode = $("#kpiFilterTree").treegrid("getParent",row.ID);
			secDimCode = "$" + secDimNode.code;
			kpiNode = $("#kpiFilterTree").treegrid("getParent",secDimNode.ID);
			kpiCode = kpiNode.code;
			kpiRule = secDimCode + "." + code;
		}
	}
	
	var filterFun;
	if (dataGrid){
		filterFun = dataGrid.FilterFuncCode;
	}
	
	if ((kpiRule) && (kpiCode)){
		$("#filterValue").val("");
		$("#operatorList").combobox("setValue","");
		$('#filterFun').combogrid('setValue', "");
		var rows = $("#filterRuleGrid").propertygrid("getRows");
		var len = rows.length,myKPICode,flag;
		flag = 0;
		for (var i = 0;i < len;i++){   //flag记录要插入的指标是否在过滤函数中已经存在,flag为1时表示已经存在
			myKPICode = rows[i].group;
			if (myKPICode == kpiCode){
				flag = 1;
				break;
			}
		}
		if (flag == 1){    //指标已经存在时可以选择运算符，不存在时不能选择
			var data = $("#operatorList").combobox('getData'); //可以选择时，提供默认选择值
			$("#operatorList").combobox('select',data[0].text);
			$("#operatorList").combobox("enable");
		}else{
			$("#operatorList").combobox("disable");
		}
		//弹窗运算符和过滤值界面
		$("#operatorSelector").show();
		$HUI.dialog("#operatorSelector",{
			resizable:true,
			modal:true,
			iconCls:'icon-w-add',
			buttons:[{
				text:'保存',
				handler:function(){
					var comboxValue = $("#operatorList").combobox("getValue");
					var value = $("#filterValue").val();
					if ((!value)) {
						myMsg("过滤值不能为空");
						return;
					}
					var g = $('#filterFun').combogrid('grid');	// get datagrid object
					var r = g.datagrid('getSelected');	// get the selected row
					var filterFun = r.FilterFuncCode;
					kpiFilterParamsArr = [kpiCode,kpiRule,filterFun];
					$HUI.dialog("#operatorSelector").close();
					datagridConfig(kpiFilterParamsArr[0],comboxValue,kpiFilterParamsArr[1],kpiFilterParamsArr[2],value);
				
				}
			},{
				text:'关闭',
				handler:function(e){
					$HUI.dialog("#operatorSelector").close();
				}
			}]
		});
		
	}
	
	
}

/*--用于插入表格数据(合并单元格)--*/
function datagridConfig(kpiCode,operation,rule,filterFun,value){
	var obj = {
		group:kpiCode,
		operator:operation,
		value:value,
		kpiRule:rule,
		filterFun:filterFun
	}
	arr.push(obj);
	$('#filterRuleGrid').propertygrid('loadData',arr);
	
}


/*--指标过滤规则配置树--*/


//*********************指标过滤规则配置界面结束***************************