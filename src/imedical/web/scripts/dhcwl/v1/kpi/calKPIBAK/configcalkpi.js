﻿/**
*  Creator    : wk
*  CreatDate  : 2018-05-02
*  Desc       : 计算指标的配置界面js文件
*/

$HUI.datagrid("#kpiForSelectTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.KPI.KPIFunction',
		QueryName:'GetKPIListQuery'
	},
	pagination:true,   //分页可用
	striped:true,	   //表格斑马线
	pageSize:15,			
	pageList:[5,10,15,20,50,100]
})