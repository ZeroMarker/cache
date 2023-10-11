var ZYZL_MOCA=(function(){
	function Init(){
		$HUI.numberbox("input[id^='MOCA_Q']",{
			isKeyupChange:true,
	        onChange:function(n,o){
		        $HUI.numberbox(this).validate();
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
		$("input[id^='MOCA_Q']").each(function(){
			var val=$(this).numberbox("getValue")
			if ( val!= ""){
				Score = Score + parseFloat(val);
			}
		});
		$("#MOCA_Score").numberbox('setValue',Score);
	}
	
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
})();