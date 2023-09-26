var LCPanel=(function(){
	function Init(){
		$("#PrevHisFlag1").on('click',function(){			
			if($("#"+this.id).is(':checked')){
				$HUI.checkbox("#PrevHisFlag2").setValue(false)
				$("#PrevContent").css('display','block');
			};			
		})
		$("#PrevHisFlag2").on('click',function(){			
			if($("#"+this.id).is(':checked')){
				$HUI.checkbox("#PrevHisFlag1").setValue(false)
				$("#PrevContent").css('display','none');
			};			
		})
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