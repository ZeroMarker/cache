var ZYAss_ZYZLFW=(function(){
	function Init(){
		if(typeof CAInitFlag != "undefined" && (CAInitFlag == 1)){
			$("#ZYZLFW_Doc").hide();
		}else{
			$("#ZYZLFW_Doc").val(LgSSUSRName);
		}
		var DCRowIDStr=ServerObj.DCRowIDStr
		if(DCRowIDStr==""){
			DCRowIDStr=ServerObj.DCARowId;
		}
		if(ServerObj.DCAssRowId==""){
			$.cm({
				ClassName:"DHCDoc.DHCDocCure.Assessment",
				MethodName:"GetZYAssInfo",
				EpisodeID:ServerObj.EpisodeID
			},function testget(JsonObj){
				if(JsonObj != null){	
					$("#ZYZLFW_Diag").val(JsonObj.Diagnosis)
					$("#ZYZLFW_ZS").val("");
					$("#ZYZLFW_PG").val("")
					//$("#ZYZLFW_ASSTime").datetimebox('setValue',JsonObj.DateTime)
				}
			});
		}
		//默认当前时间,设置最大日期为当天
		//assTempShow.js
		setDefAssDate('ZYZLFW_ASSTime');
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