function BDCDSS(){
	this.init=function(){
		var screenHeight=window.screen.height;
		var screenWidth=window.screen.width;	
		windowCDSS=window.open("emr.baidu.cdss.csp","windowCDSS","height=400,width=360,top="+(screenHeight-500)+",left="+(screenWidth-460));
	}
	this.getData=function(param,actionType){
		var _this=this;
		var action=actionType.toUpperCase();
		if(typeof param == "undefined"){
			var docId = param.emrDocId	
			var instanceID = param.id
		}else{
			return
		}
		var param="AEpisodeID:"+episodeID+",AUserLocID:"+userLocID+",AHospitalID:"+hospitalID+",AUserID:"+userID+",AInstanceID:"+instanceID+",ADocID:"+docId+",AAction:"+action+",AType:"+cdssEpisodeType
		jQuery.ajax({
		type: "get",
		dataType: "text",
		url: '../EMRservice.BOCDSSService.cls',
		async: false,
		data: {
			"action":"GetCDSSData",
			"param":param
		},
		success: function(d) {
			if(d=="") return
			var data = eval('('+d+')');
			if(data.success==1){
				cdss_data=data;
				if (windowCDSS.InvokeCDSS != undefined){
					windowCDSS.InvokeCDSS(cdss_data);
				}else{
					_this.init();
					windowCDSS.InvokeCDSS(cdss_data);
				}
			}
		},
		error : function(d) { alert("cdsscode error");}
	});
	}
}