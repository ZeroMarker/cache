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
		var kpiCode,kpiName,kpiMea,kpiExeCode,dataNode,kpiGlobal,kpiCreator,kpiUpdate,kpiDesc,kpiType,kpiSection,kpiValueType,kpiRemark
		var kpinfor = new Array();
		kpinfor[0] = $("#kpiCode").val();
		kpinfor[1] = $("#kpiName").val();
		kpinfor[2] = $("#kpiMeasure").val();
		kpinfor[3] = $("#exeCode").val();
		kpinfor[4] = $("#dataNode").val();
		kpinfor[5] = $("#creator").val();
		kpinfor[6] = $("#kpiDesc").val();
		kpinfor[7] = $("#kpiDim").val();
		kpinfor[8] = $("#kpiType").combobox("getText");
		kpinfor[9] = $("#kpiSection").combobox("getText");
		kpinfor[10] = $("#kpiValueType").combobox("getValue");
		kpinfor[11] = $("#kpiRemark").val();
		kpinforStr = kpinfor.join("@");
		window.parent.freshKPITableFun(kpinforStr);
		return;
		kpiObj.load({ClassName:"web.DHCWL.V1.KPI.KPIFunction",QueryName:"GetKPIListQuery",kpiCode:kpiCode, kpiName:kpiName, kpiDesc:kpiDesc, kpiExcode:kpiExeCode, createUser:kpiCreator, updateDate:kpiUpdate, dataNode:dataNode, getValueType:kpiValueType, dimType:kpiDimCodes, category:kpiType, section:kpiSection});  //重新加载指标信息
	})
	/*--指标查询数据清空--*/
	$("#clearDetailSearch").click(function(){
		$("#kpiCode").val("");
		$("#kpiName").val("");
		$("#kpiMeasure").val("");
		$("#exeCode").val("");
		$("#dataNode").val("");
		$("#creator").val("");
		$("#kpiDesc").val("");
		$("#kpiDim").val("");
		$("#kpiType").combobox('setValue',"");
		$("#kpiSection").combobox('setValue',"");
		$("#kpiValueType").combobox('setValue',"");
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