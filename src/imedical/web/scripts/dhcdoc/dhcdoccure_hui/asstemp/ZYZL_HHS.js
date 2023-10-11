var ZYZL_HHS=(function(){
	function Init(){
		//默认当前时间,设置最大日期为当天
		//assTempShow.js
		setDefAssDate('Date');
		
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
				$("#PatName").val(PatInfoObj.baseInfoName)
			}
		});	
		
		$HUI.radio("[name^='HHS_Q']",{
	        onCheckChange:function(e,value){
	        	TakCalScore('HHS_Q','THHScore');
	        }

	    });
	    $HUI.radio("[name^='HHS_RMSQ']",{
	        onCheckChange:function(e,value){
	        	TakCalScore('HHS_RMSQ','RMScore');
	        }
	    });
	}
	
	function TakCalScore(ele,sele){
		var count=0;
		var Score=0;
		var id = this.id;
		$("input[name^='"+ele+"']:checked").each(function(){
			if ($(this).attr("scoreval") != ""){
				Score = Score + parseFloat($(this).attr("scoreval"));
				count=count+1;
			}
		});
		$("#"+sele).numberbox('setValue',Score);
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