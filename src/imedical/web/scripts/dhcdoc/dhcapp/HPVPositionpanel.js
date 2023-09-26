var HPVPositionpanel=(function(){
	function Init(){
		if (ServerObj.CheckSpecEditor=="0"){ 
			setTimeout(function(){ 
				$("#Position").attr("disabled", false); 
			}, 1000);
		}
	}
	function OtherInfo(){
		var rtnObj = {}
		rtnObj["PisReqSpec"] = 1+"#"+$("#Position").val() +"##"+ 1 +"#"+ "" +"#"+ 1+ "#"+ "";;
		return rtnObj;
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