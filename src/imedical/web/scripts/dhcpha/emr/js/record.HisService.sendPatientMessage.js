﻿///打印病案首页成功后，调用平台接口，对外提供访问出院患者列表

//获取系统参数MedicalRecordDocID，判断是否开启此功能
function getMedicalRecordDocID(docId)
{  
	 jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : true,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLSysOption",
					"Method":"GetOptionValueByName",			
					"p1":"MedicalRecordDocID"
				},
			success : function(d) {
	           		//MedicalRecordDocID为空，则不开启此功能
	 				if (d == "")
	 				{
		 				return;
	 				} 
	 				//判断是否是病案首页
	 				if (d == docId)
	 				{
		 				sendOutpatList(docId);
	 				}
			}
		});	
}

//打印病案首页成功后，对外提供访问出院患者列表
function sendOutpatList(docId)
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : true,
			data : {
					"OutputType":"String",
					"Class":"web.DHCENS.EnsHISService",
					"Method":"EMRPrintTrigger",			
					"p1":episodeID
				}
		});	
}