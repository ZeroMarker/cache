var ZYAss_SYGNPG=(function(){
	function Init(){
		var DCRowIDStr=ServerObj.DCRowIDStr
		if(DCRowIDStr==""){
			DCRowIDStr=ServerObj.DCARowId;
		}
		if(DCRowIDStr==""){
			$.cm({
				ClassName:"DHCDoc.DHCDocCure.Assessment",
				MethodName:"GetZYAssInfo",
				EpisodeID:ServerObj.EpisodeID
			},function testget(JsonObj){
				if(JsonObj != null){
					$("#SYGNPG_DiagText").html(JsonObj.Diagnosis)	
					$("#SYGNPG_JWS").val("")	
					//$("#SYGNPG_AssDateTime").datetimebox('setValue',JsonObj.DateTime)
				}
			});
		}
		
		//默认当前时间,设置最大日期为当天
		//assTempShow.js
		setDefAssDate('SYGNPG_AssDateTime');
		
		$HUI.datebox("input[class*='hisui-datebox']", {
			validParams: "YM",
			onSelect: function(date) {
			},
			formatter: function(date) {
				var y = date.getFullYear();
				var m = date.getMonth() + 1;
				m = m.toString().length == 1 ? ('0' + m) : m
				var str = y + '-' + m;
				if (_DateFormat == '4') {
					str = m + '/' + y;
				}
				return str;
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
