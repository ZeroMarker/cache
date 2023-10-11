var comEndAss=(function(){
	function Init(){
		if(typeof CAInitFlag != "undefined" && (CAInitFlag == 1)){
			$("#EndAss_User").hide();
		}else{
			$("#EndAss_User").val(LgSSUSRName)
		}
		//默认当前时间,设置最大日期为当天
		//assTempShow.js
		setDefAssDate('EndAss_DateTime');
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