var ZYZLAss_HSFunc=(function(){
	function Init(){
		PageHandle();
	}
	
	function PageHandle(){
		$(".panel-body .panel").css({
			"margin-bottom":"0px"
		})
		$("#ZYZLAss_HSFunc").css({
			"margin":"10px 0px"
		})
		
		$(".item-table-line tr:last-child td").css({
			"border-bottom":"none"
		})

		$("#ZYZLAss_HSFunc").panel("resize",{height:120})
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