var ZYAss_TYZA=(function(){
	function Init(){
		$(".item-table").on("click","input[name^='TYZA_Q']",TakCalScore)
		$HUI.radio("[name^='TYZA_Q']",{
	        onCheckChange:function(e,value){
	        	TakCalScore();
	        }
	    });
	}
	function OtherInfo(){
		return ""
	}
	function PrintInfo(){
		return ""
	}
	
	function TakCalScore(){
		var Score=0;
		var id = this.id;
		$("input[name^='TYZA_Q']:checked").each(function(){
			//alert($(this).attr("scoreval"))
			if ($(this).attr("scoreval") != ""){
				Score = Score + parseFloat($(this).attr("scoreval"));
			}
		})
		$("#TYZA_Score").val(Score);
	}
	
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
})();