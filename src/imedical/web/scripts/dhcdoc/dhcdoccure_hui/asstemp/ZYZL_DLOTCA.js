var ZYZL_DLOTCA=(function(){
	function Init(){
		$HUI.numberbox("input[id^='DLOTCA_Q']",{
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
		$("input[id^='DLOTCA_Q']").each(function(){
			var val=$(this).numberbox("getValue")
			if ( val!= ""){
				Score = Score + parseFloat(val);
			}
		});
		$("#DLOTCA_Score").numberbox('setValue',Score);
	}
	
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
})();