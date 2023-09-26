/**
 * @Title:版本管理
 * @Author: 汪凯-DHCWL
 * @Description:版本管理界面设计
 * @Created on 2018-01-10
 */
 var param,url,kpinfor,kpiIDStr,kpiID;
 param = window.location.href;
 url = window.location.search.substr(1);
 kpinfor = url.split("&");
 kpiIDStr = kpinfor[1].split("=");
 kpiID = kpiIDStr[1];
 var myDataFlag = "";
var init = function(){
	
	/*--已选指标界面表格--*/
	var kpiSelectedObj = $HUI.datagrid("#kpiSelectedGrid",{
		url:$URL,  //固定写法
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.KPIFunction", //方法或者query路径
			QueryName:"GetSelectedKPIQuery", //query名
			kpiIDs:kpiID
		},
		//striped:true, //斑马线效果
		toolbar:"#createDataToobar",
		fitColumns:true //列填充满datagrid
	})
	
	/*--点击生成数据按钮响应--*/
	$("#creatKPIDataButton").click(function(){
		var rows = $("#kpiSelectedGrid").datagrid("getSelections");
		if (rows.length<1) {
			$.messager.alert("提示","请先选择要生成数据的指标");
			return;
		}
		var startDate="",endDate="",kpiIDs=""
		startDate = $("#startDate").datebox("getValue");
		endDate = $("#endDate").datebox('getValue');
		if ((startDate == "")||(endDate == "")){
			$.messager.alert("提示","请将日期填写完整");
			return;
		}
		for (var i = 0; i<rows.length; i++){
			if (kpiIDs == ""){
				kpiIDs = rows[i].ID;
			}else {
				kpiIDs = kpiIDs + "," + rows[i].ID;
			}
		}
		$.cm({
			ClassName:"web.DHCWL.V1.KPI.KPIFunction",
			MethodName:"CreatKPIData",
			kpiIDs:kpiIDs,
			startDate:startDate,
			endDate:endDate	
		},function(jsonData){
			if ((jsonData.tip == "ok")&&(jsonData.dataFlag)){
				myDataFlag = jsonData.dataFlag;
				porgressControl("web.DHCWL.V1.KPI.KPIFunction","getCreateDataPlan",myDataFlag,1000);
			}else{
				if (jsonData.tip == "order"){
					messageShow("开始日期不能晚于结束日期");
				}else{
					messageShow("生成过程中出现错误,请刷新浏览器重试");
				}
			}
		});
	});
	
	/*--点击清屏按钮--*/
	$("#cleanCondition").click(function(e){
		$('#startDate').datebox('setValue', '');
		$('#endDate').datebox('setValue', '');
	})
}
$(init);