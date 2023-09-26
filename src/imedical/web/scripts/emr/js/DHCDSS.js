function DHCDSS(){
	this.getData=function(param,actionType){
		var _this=this;
		var action=actionType.toUpperCase();
		var instanceId = param.id;
		var paramter =  "AEpisodeID:"+episodeID+",AUserID:"+userID+",AUserLocID:"+userLocID+",ADocID:"+param.emrDocId+",AInstanceID:"+instanceId+",AAction:"+action+",AType:"+cdssEpisodeType
		jQuery.ajax({
			type: "post",
			dataType: "text",
			url: '../EMRservice.BOCDSSService.cls',
			async: false,
			data: {
				"action":"GetCDSSData",
				"param":paramter
			},
			success: function(d){
				data=JSON.parse(d);
				if(data.success==1){
					 parent.StartCDSS(data.message)
				}
			},
			error: function(d){console.log("取病历数据出错");}
		});
	}	
}