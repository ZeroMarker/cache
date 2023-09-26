﻿/**
 * @Title:版本管理
 * @Author: 汪凯-DHCWL
 * @Description:版本管理界面设计
 * @Created on 2018-01-10
 */
 
 var param = window.location.href;
 var url = window.location.search.substr(1);
 var kpinfor = url.split("&");
 var kpiIDStr = kpinfor[1].split("=");
 var kpiID = kpiIDStr[1];
 var kpiCodeStr = kpinfor[2].split("=");
 var kpiCode = kpiCodeStr[1];
var init = function(){
	
	/*--版本管理主界面展示--*/
	var verManageGridObj = $HUI.datagrid("#kpiDimGrid",{
		url:$URL,  //固定写法
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.KPIFunction", //方法或者query路径
			QueryName:"GetKPIDimQuery", //query名
			kpiID:kpiID
		},
		toolbar:[],
		//pagination:true, //允许用户通过翻页导航数据
		striped:true, //斑马线效果
		pageSize:15,  //设置首次界面展示时每页加载条数
	    pageList:[10,15,20,50,100], //设置分页可选展示条数
		fitColumns:true //列填充满datagrid
	})
	 $("#kpiDimGrid").datagrid("getPanel").panel("setTitle","指标维度---"+kpiCode);
}
$(init);﻿