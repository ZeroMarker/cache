var ZYZLAss_MusculTLL=(function(){
	function Init(){
		PageHandle();
	}
	
	function PageHandle(){
		$(".panel-body .panel").css({
			"margin-bottom":"0px"
		})
		$("#ZYZLAss_MusculTLL").css({
			"margin":"10px 0px"
		})
		
		$(".item-table-line tr:last-child td").css({
			"border-bottom":"none"
		})

		$("#ZYZLAss_MusculTLL").panel("resize",{height:365})
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