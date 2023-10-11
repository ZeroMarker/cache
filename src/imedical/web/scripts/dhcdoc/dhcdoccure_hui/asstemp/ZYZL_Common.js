var ZYZL_Common=(function(){
	function Init(){
		var DCRowIDStr=ServerObj.DCRowIDStr
		if(DCRowIDStr==""){
			DCRowIDStr=ServerObj.DCARowId;
		}
		$.cm({
			ClassName:"DHCDoc.DHCDocCure.Assessment",
			MethodName:"GetZYAssInfo",
			EpisodeID:ServerObj.EpisodeID
		},function testget(JsonObj){
			if(JsonObj != null){
				$("#ZYZLCom_DiagText").val(JsonObj.Diagnosis)	
				$("#ZYZLCom_ZS").val("")	
				$("#ZYZLCom_JWS").val("")	
				//$("#ZYZLCom_AssDateTime").datetimebox('setValue',JsonObj.DateTime)
			}
		});
		//默认当前时间,设置最大日期为当天
		//assTempShow.js
		setDefAssDate('ZYZLCom_AssDateTime');
	}
	function OtherInfo(){
		return ""
	}
	function PrintInfo(){
		return ""
	}
	
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
})();