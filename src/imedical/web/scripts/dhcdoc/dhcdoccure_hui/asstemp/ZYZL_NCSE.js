var ZYZL_NCSE=(function(){
	function Init(){
		$HUI.numberbox("input[id^='NCSE_Score_']",{
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
		$("input[id^='NCSE_Score_']").each(function(){
			var val=$(this).numberbox("getValue")
			if ( val!= ""){
				Score = Score + parseFloat(val);
			}
		});
		$("#NCSE_Score").numberbox('setValue',Score);
	}
	
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
})();