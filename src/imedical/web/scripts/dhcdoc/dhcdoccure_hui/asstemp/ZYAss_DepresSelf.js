var ZYAss_DepresSelf=(function(){
	function Init(){
		$(".item-table").on("click","input[name^='DSA_Q']",TakCalScore)
		$HUI.radio("[name^='DSA_Q']",{
	        onCheckChange:function(e,value){
	        	TakCalScore();
	        }
	    });
	    $("#DSA_Grade").val("*");
	}
	function OtherInfo(){
		return ""
	}
	function PrintInfo(){
		return ""
	}
	
	function TakCalScore(){
		var TotalScore=0;	//总分
		var ScaledScore=0;	//标准分
		var id = this.id;
		$("input[name^='DSA_Q']:checked").each(function(){
			//alert($(this).attr("scoreval"))
			if ($(this).attr("scoreval") != ""){
				TotalScore = TotalScore + parseFloat($(this).attr("scoreval"));
			}
		})
		ScaledScore=Math.round(TotalScore*1.25);		//标准分=总分*1.25，四舍五入取整数
		$("#DSA_TotalScore").val(TotalScore);
		$("#DSA_ScaledScore").val(ScaledScore);
		if((ScaledScore>="25")&&(ScaledScore<="49")){
			$("#DSA_Grade").val("正常");
		}else if((ScaledScore>="50")&&(ScaledScore<="59")){
			$("#DSA_Grade").val("轻度抑郁");
		}else if((ScaledScore>="60")&&(ScaledScore<="69")){
			$("#DSA_Grade").val("中度抑郁");
		}else if(ScaledScore>="70"){
			$("#DSA_Grade").val("严重抑郁");
		}else{
			$("#DSA_Grade").val("*");
		}
	}
	
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
})();