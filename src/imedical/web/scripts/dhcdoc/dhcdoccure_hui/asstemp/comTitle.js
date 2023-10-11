var comTitle=(function(){
	function Init(){
		$("#TitleDesc").html(ServerObj.MapDesc)
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