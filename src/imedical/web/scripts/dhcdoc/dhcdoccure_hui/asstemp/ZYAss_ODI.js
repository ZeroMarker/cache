var ZYAss_ODI=(function(){
	function Init(){
		//$(".item-table").on("click","input[name^='ODI_Q']",TakCalScore)
		$HUI.radio("[name^='ODI_Q']",{
	        onCheckChange:function(e,value){
	        	TakCalScore();
	        }
	    });
	    
	    $.m({
			ClassName:"DHCDoc.DHCDocCure.Apply",
			MethodName:"GetPatientBaseInfo",
			'DCARowId':"",
			'adm':ServerObj.EpisodeID,
			DataType:"JSON"
		},function testget(value){
			if (value!=""){
				var PatInfoObj=eval("("+value+")");
				if(typeof(PatInfoObj.baseInfoName)=='undefined'){return}
				$("#PatName").html(PatInfoObj.baseInfoName)
				$("#PatSex").html(PatInfoObj.baseInfoSex)
				$("#PatAge").html(PatInfoObj.baseInfoAge)
			}
		});
		$("#ODI_PatASSUser").val(session['LOGON.USERNAME']);
	}
	function OtherInfo(){
		return ""
	}
	function PrintInfo(){
		return ""
	}
	
	function TakCalScore(){
		var count=0;
		var Score=0;
		var id = this.id;
		$("input[name^='ODI_Q']:checked").each(function(){
			//alert($(this).attr("scoreval"))
			if ($(this).attr("scoreval") != ""){
				Score = Score + parseFloat($(this).attr("scoreval"));
				count=count+1;
			}
		});
		if(count>0){
			Score= parseFloat(Score / (5*count) * 100).toFixed(2);
		}
		$("#ODI_Score").numberbox('setValue',Score);
	}
	
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
})();