﻿/**
  *@creator:wk
  *@creatDate:2018-04-12
  *@desc:指标预览数据界面
**/
var kpiBodyHeight = getViewportOffset().y;   // 获取屏幕高度
var kpiBodyWidth = getViewportOffset().y;   // 获取屏幕宽度
var param,url,kpinfor,kpiIDStr,kpiIDs,kpiCodeStr,kpiCodes
param = window.location.href;
url = window.location.search.substr(1);
kpinfor = url.split("&");
kpiIDStr = kpinfor[1].split("=");
kpiIDs = kpiIDStr[1];
kpiCodeStr = kpinfor[2].split("=");
kpiCodes = kpiCodeStr[1];

var kpiRuleArr = [{'text':'','id':''}];  //用于存放指标取数规则记录
var kpiFilterArr = [{'text':'','id':''}]; //用于存放过滤规则记录
/*--指标取数规则下拉框--*/
$HUI.combobox("#kpiRuleConfig",{
	valueField:'id',
	textField:'text'
})
$("#kpiRuleConfig").combobox('loadData',kpiRuleArr);

/*--指标过滤规则下拉框--*/
$HUI.combobox("#kpiFilterConfig",{
	valueField:'id',
	textField:'text'
})
$("#kpiFilterConfig").combobox('loadData',kpiFilterArr);

/*--指标数据展示表格配置--*/
var kpiDataShow = $HUI.datagrid("#kpiShowTable",{
	url:$URL,
	queryParams:{
		ClassName:"web.DHCWL.V1.KPI.KPIFunction",
		QueryName:"GetKPIDataQuery",
		kpiRule:""
	},
	columns:[[
		{field:'monDesc',title:'日期',width:100},
		{field:'kpiCode',title:'指标代码',width:100},
		{field:'kpiDesc',title:'指标描述',width:200},
		{field:'dimId',title:'维度原始值',width:100},
		{field:'dimDesc',title:'维度名称',width:200},
		{field:'value',title:'值',width:90},
		{field:'realValue',title:'实时值',width:90,formatter:function(value,row,index){   //如果实时数据和历史数据不一样，将实时数据变为红色
			if (row.value == row.realValue){
				return row.realValue;
			}else{
				return "<p style='color:red;'>" + row.realValue + "</p>";
			}
		}}
	]],
	pagination:true,
	fitColumns:true,
	//striped:true,
	pageSize:15,
	pageList:[10,15,20,50,100]
})
/*--提供给父界面设置取数规则--*/
function setKPIRule(kpiRule){
	kpiRuleArr.push({'text':kpiRule,'id':kpiRule});
	$("#kpiRuleConfig").combobox("loadData",kpiRuleArr);
	$("#kpiRuleConfig").combobox("setValue",kpiRule);
}
/*--提供给父界面设置过滤规则--*/
function setFilterRule(kpiFilterRule){
	kpiFilterArr.push({'text':kpiFilterRule,'id':kpiFilterRule});
	$("#kpiFilterConfig").combobox("loadData",kpiFilterArr);
	$("#kpiFilterConfig").combobox("setValue",kpiFilterRule);
}

/*--提示框--*/
$HUI.tooltip("#kpiFilterButton",{
	content:'<span>配置过滤规则</span>',
	position:'bottom'
});
$HUI.tooltip("#kpiRuleButton",{
	content:'<span>配置取数规则</span>',
	position:'bottom'
});

/*--打开取数规则弹出框--*/
$("#kpiRuleButton").click(function(arg){
	$('#kpiRuleConfig').combobox('setValue',$('#kpiRuleConfig').combobox('getText')); 
	var comboxValue = $("#kpiRuleConfig").combobox("getValue");
	window.parent.showKPIRuleConfig(comboxValue);
});

/*--打开过滤规则弹出框--*/
$("#kpiFilterButton").click(function(arg){
	$('#kpiRuleConfig').combobox('setValue',$('#kpiRuleConfig').combobox('getText'));
	var comboxValue = $("#kpiRuleConfig").combobox("getValue");
	window.parent.showKPIFilterConfig(comboxValue);
});

/*--日期控件设置不能手动维护--*/
$("#startDate").datebox({editable:false});

/*--点击查询按钮执行方法--*/
$("#searchDataButton").click(function(arg){
	//kpiRuleArr.push({'text':'001','id':'002'});
	//$("#kpiRuleConfig").combobox("loadData",kpiRuleArr);
	//return;
	var isSim = $("#isSim").checkbox("getValue");
	var isPer = $("#isPer").checkbox("getValue");
	var isSum = $("#isSum").checkbox("getValue");
	var isSecPro = $("#isSecPro").checkbox("getValue");
	var mode = "",contract = "";
	isSim = isSim?1:0;
	isPer = isPer?1:0;
	isSum = isSum?1:0;
	isSecPro = isSecPro?1:0;
	var radioObj = $("input[name = 'datatype']:checked");
	var radioValue = radioObj.val();
	
	var startDate = $("#startDate").datebox("getValues")[0];
	var endDate = $("#endDate").datebox("getValues")[0];
	
	
	$('#kpiRuleConfig').combobox('setValue',$('#kpiRuleConfig').combobox('getText')); 
	var kpiRule = $("#kpiRuleConfig").combobox("getValue");
	//var kpiRule = $("#kpiRuleConfig").combobox("getValues")[0];
	
	$('#kpiFilterConfig').combobox('setValue',$('#kpiFilterConfig').combobox('getText'));
	var kpiFilter = $("#kpiFilterConfig").combobox("getValue");
	//var kpiFilter = $("#kpiFilterConfig").combobox("getValues")[0];
	
	if((!kpiRule)||(!startDate)||(!endDate)){
		myMsg("取数规则、开始日期、结束日期为必填信息");
		return;
	}
	/*if (startDate > endDate){
		myMsg("结束日期需要大于开始日期");
		return;
	}*/
	
	if (isSim){   //判断是否勾选了同期数据
		if (contract){
			contract = contract + "," + "SL";
		}else{
			contract = "SL"
		}
	}
	
	if (isPer){    //判断是否勾选了上期数据
		if (contract){
			contract = contract + "," + "PP";
		}else{
			contract = "PP"
		}
	}
	if (isSum) {    //判断是否合并数据
		mode = mode + "S"
	}
	
	if (isSecPro) {   //判断是否区间升级数据
		mode = mode + "C"
	}
	if ((radioValue != "hisData")&&(isSecPro)){
		myMsg("实时模式不能勾选区间升级按钮");
		return;
	}
	
	if (radioValue == "realData") {
		mode = mode + "R"
	}
	var textData = $m({
		ClassName:"DHCWL.util.DateUtil",
		MethodName:"DateIslegitimate",
		startDate:startDate,
		endDate:endDate
	},false);
	if (textData != "ok"){
		myMsg(textData);
		return;
	}
	//$('#kpiShowTable').datagrid('loadData',{total:0,rows:[]});
	if (radioValue == "realAndHis"){
		$("#kpiShowTable").datagrid("showColumn","realValue");
		kpiDataShow.load({ClassName:"web.DHCWL.V1.KPI.KPIFunction",QueryName:"GetHisAndRealKPIDataQuery",kpiRule:kpiRule, startDate:startDate, endDate:endDate, mode:mode, contract:contract, filter:kpiFilter});
	}else{
		$("#kpiShowTable").datagrid("hideColumn","realValue");
		kpiDataShow.load({ClassName:"web.DHCWL.V1.KPI.KPIFunction",QueryName:"GetKPIDataQuery",kpiRule:kpiRule, startDate:startDate, endDate:endDate, mode:mode, contract:contract, filter:kpiFilter});
	}

})


$("#moreSearchButton").click(function(e){
	
	if (e.target.innerText=="更多"){
	    $("#moreSearchButton .l-btn-text")[0].innerText="隐藏";
    	$("#moreSearchCondition").show();
    	setHeight('45');
    }else{
	    $("#moreSearchButton .l-btn-text")[0].innerText="更多";
    	$("#moreSearchCondition").hide();
    	setHeight("-45");
	}
	function setHeight(num){
        var c=$("#my-interface");
        var p=c.layout('panel', 'north');
        var Height=parseInt(p.outerHeight())+parseInt(num);
        p.panel('resize',{height:Height}); 
        
		var p = c.layout('panel','center');	
		var Height = parseInt(p.outerHeight())-parseInt(num);
		p.panel('resize', {height:Height})
		
		if (+num>0){
			p.panel('resize',{top:126});
		}else{
			p.panel('resize',{top:81});
		}
    }
	
	
	
});

$(document).ready(function(){
	$("#kpiRuleConfig").combobox("setValue",kpiCodes);
});


