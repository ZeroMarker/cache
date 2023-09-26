/**
 * @Title:指标明细查询界面
 * @Author: 汪凯-DHCWL
 * @Description:指标查询界面
 * @Created on 2018-04-01
 */
 var param,url,kpinfor,kpiIDStr,kpiObj;
 param = window.location.href;
 url = window.location.search.substr(1);
 if (url.indexOf("&") != -1){
 	kpinfor = url.split("&");
 	kpiObjs = kpinfor[1].split("=");
 	kpiObj = kpiObjs[1];
 }
var init = function(){
	/*--指标查询--*/
	$("#kpiDetailSearch").click(function(){
		//--获取表单元素值
		var kpinfor = new Array();
		kpinfor[0] = $("#kpiCode").val();
		kpinfor[1] = $("#kpiName").val();
		kpinfor[2] = $("#kpiMeasure").val();
		kpinfor[3] = $("#exeCode").val();
		kpinfor[4] = $("#dataNode").val();
		kpinfor[5] = $("#creator").val();
		kpinfor[6] = $("#kpiDim").val();
		kpinfor[7] = $("#kpiType").combobox("getText");
		kpinfor[8] = $("#kpiRemark").val();
		kpinforStr = kpinfor.join("@");
		window.parent.freshKPIRuleTableFun(kpinforStr);
	})
	/*--指标查询数据清空--*/
	$("#clearDetailSearch").click(function(){
		$("#kpiCode").val("");
		$("#kpiName").val("");
		$("#kpiMeasure").val("");
		$("#exeCode").val("");
		$("#dataNode").val("");
		$("#creator").val("");
		$("#kpiDim").val("");
		$("#kpiType").combobox('setValue',"");
		$("#kpiRemark").val("");
	})
	
	/*--指标类型下拉框数据获取--*/
	var kpiTypeObj = $HUI.combobox("#kpiType",{
		url:$URL+"?ClassName=web.DHCWL.V1.KPI.KPIFunction&QueryName=GetKPITypeQuery&ResultSetType=array",
		valueField:'typeCode',
		textField:'typeName'
	});
	
	/*--指标区间下拉框数据获取--*/
	var kpiTypeObj = $HUI.combobox("#kpiSection",{
		url:$URL+"?ClassName=web.DHCWL.V1.KPI.KPIFunction&QueryName=GetKPISectionQuery&ResultSetType=array",
		valueField:'secCode',
		textField:'secName'
	});
	
	
};
$(init);﻿