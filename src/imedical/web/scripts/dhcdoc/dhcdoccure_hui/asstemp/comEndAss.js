var comEndAss=(function(){
	function Init(){
		if(typeof CAInitFlag != "undefined" && (CAInitFlag == 1)){
			$("#EndAss_User").hide();
		}else{
			$("#EndAss_User").val(LgSSUSRName)
		}
		//Ĭ�ϵ�ǰʱ��,�����������Ϊ����
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