//添加用户配置信息
function addUserConfigData(userID,userLocID,type,config)
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLUserConfig",
					"Method":"AddData",			
					"p1":userID,
					"p2":userLocID,
					"p3":type,
					"p4":config
				},
			success : function(d) {
			},
			error : function(d) { }
		});	
}

//获取用户配置信息
function getUserConfigData(userID,userLocID,type)
{
	var config = ""
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLUserConfig",
					"Method":"GetConfig",			
					"p1":userID,
					"p2":userLocID,
					"p3":type
				},
			success : function(d) {
					if (d != "")
					{
						config = d;
					}
			},
			error : function(d) { }
		});
	return config;	
}

