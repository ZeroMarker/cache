var ZYZLAss_MusculTUL=(function(){
	function Init(){
		PageHandle();
	}
	
	function PageHandle(){
		$(".panel-body .panel").css({
			"margin-bottom":"0px"
		})
		$("#ZYZLAss_MusculTUL").css({
			"margin":"10px 0px"
		})
		
		$(".item-table-line tr:last-child td").css({
			"border-bottom":"none"
		})

		$("#ZYZLAss_MusculTUL").panel("resize",{height:236})
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