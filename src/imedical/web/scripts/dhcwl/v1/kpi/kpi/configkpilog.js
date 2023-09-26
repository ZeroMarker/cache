/**
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
	var verManageGridObj = $HUI.datagrid("#kpiLogGrid",{
		url:$URL,  //固定写法
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.KPIFunction", //方法或者query路径
			QueryName:"GetKPILogQuery", //query名
			kpiIds:kpiID
		},
		toolbar:[],
		columns:[[
			{field:'KpiLogDefinition',width:270,title:'指标定义日志',
				formatter:function(value,rec,rowIndex) {
					if (rec.KpiLogDefinition == "false") {
						return "<input type = \"checkbox\" name = \"log1\" disabled = \"true\" >";
					}else{
						return "<input type = \"checkbox\" name = \"log1\" disabled = \"true\" checked=\"checked\">";
					}
				}
			},
			{field:'KpiLogDataProcess',width:270,title:'数据处理日志',
				formatter:function(value,rec,rowIndex) {
					if (rec.KpiLogDataProcess == "false") {
						return "<input type = \"checkbox\" name = \"log1\" disabled = \"true\" >";
					}else{
						return "<input type = \"checkbox\" name = \"log1\" disabled = \"true\" checked=\"checked\">";
					}
				}
			},
			{field:'KpiLogDataQuery',width:270,title:'数据查询日志',
				formatter:function(value,rec,rowIndex) {
					if (rec.KpiLogDataQuery == "false") {
						return "<input type = \"checkbox\" name = \"log1\" disabled = \"true\" >";
					}else{
						return "<input type = \"checkbox\" name = \"log1\" disabled = \"true\" checked=\"checked\">";
					}
				
				}
			},
			{field:'KpiLogTaskErr',width:270,title:'任务错误日志',
				formatter:function(value,rec,rowIndex) {
					if (rec.KpiLogTaskErr == "false") {
						return "<input type = \"checkbox\" disabled = \"true\" name = \"log1\" >";
					}else{
						return "<input type = \"checkbox\" name = \"log1\" disabled = \"true\" checked=\"checked\">";
					}
				}
			}
		]],
		pagination:true, //允许用户通过翻页导航数据
		//striped:true, //斑马线效果
		pageSize:15,  //设置首次界面展示时每页加载条数
	    pageList:[10,15,20,50,100], //设置分页可选展示条数
		fitColumns:true //列填充满datagrid
	})
	 $("#kpiLogGrid").datagrid("getPanel").panel("setTitle","指标维度---"+kpiCode);
}
$(init);﻿﻿