var ZYAss_AnxSelf=(function(){
	function Init(){
		$(".item-table").on("click","input[name^='ASA_Q']",TakCalScore)
		$HUI.radio("[name^='ASA_Q']",{
	        onCheckChange:function(e,value){
	        	TakCalScore();
	        }
	    });
	    $("#ASA_Grade").val("*");
	}
	function OtherInfo(){
		return ""
	}
	function PrintInfo(){
		return ""
	}
	
	function TakCalScore(){
		var TotalScore=0;	//�ܷ�
		var ScaledScore=0;	//��׼��
		var id = this.id;
		$("input[name^='ASA_Q']:checked").each(function(){
			//alert($(this).attr("scoreval"))
			if ($(this).attr("scoreval") != ""){
				TotalScore = TotalScore + parseFloat($(this).attr("scoreval"));
			}
		})
		ScaledScore=Math.round(TotalScore*1.25);		//��׼��=�ܷ�*1.25����������ȡ����
		$("#ASA_TotalScore").val(TotalScore);
		$("#ASA_ScaledScore").val(ScaledScore);
		if(ScaledScore=="0"){
			$("#ASA_TotalScore").val("");
			$("#ASA_ScaledScore").val("");
			$("#ASA_Grade").val("*");
		}else if(ScaledScore<"46"){
			$("#ASA_Grade").val("����");
		}else if((ScaledScore>="46")&&(ScaledScore<="50")){
			$("#ASA_Grade").val("��Ƚ���");
		}else{
			$("#ASA_Grade").val("����");
		}
	}
	
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
})();