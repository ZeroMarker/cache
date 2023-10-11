var comArcimDesc=(function(){
	function Init(){
		var DCRowIDStr=ServerObj.DCRowIDStr
		if(DCRowIDStr==""){
			DCRowIDStr=ServerObj.DCARowId;
		}
		$.m({
			ClassName:"DHCDoc.DHCDocCure.Assessment",
			MethodName:"GetArcimDesc",
			'DCRowIDStr':DCRowIDStr
		},function testget(value){
			if (value!=""){
				$("#ArcimDesc_Text").html(value)
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