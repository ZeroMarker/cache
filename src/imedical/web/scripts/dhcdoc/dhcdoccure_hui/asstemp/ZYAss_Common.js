var ZYAss_ZYZLFW=(function(){
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
				$("#ZYZLCom_AssDateTime").datetimebox('setValue',JsonObj.DateTime)
			}
		});
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