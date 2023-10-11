var comFirstPanel=(function(){
	function Init(){
		$.m({
			ClassName:"DHCDoc.DHCDocCure.Apply",
			MethodName:"GetPatientBaseInfo",
			'DCARowId':"",
			'adm':ServerObj.EpisodeID,
			DataType:"JSON"
		},function testget(value){
			if (value!=""){
				var PatInfoObj=eval("("+value+")");
				if(typeof(PatInfoObj.baseInfoName)=='undefined'){return}
				$("#PatName").html(PatInfoObj.baseInfoName)
				$("#PatSex").html(PatInfoObj.baseInfoSex)
				$("#PatAge").html(PatInfoObj.baseInfoAge)
				$("#PatTel").html(PatInfoObj.baseInfoTel)
				$("#PatRegNo").html(PatInfoObj.baseInfoRegNo)
				$("#PatAdmLoc").html(PatInfoObj.baseInfoAdmDept)
				$("#PatAdmDiagnos").html(PatInfoObj.baseInfoDiag)
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