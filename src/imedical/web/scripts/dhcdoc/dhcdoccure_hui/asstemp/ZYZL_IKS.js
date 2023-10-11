var ZYZL_IKS=(function(){
	function Init(){
		//默认当前时间,设置最大日期为当天
		//assTempShow.js
		setDefAssDate('ExaminationDate');
		
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
				$("#PatSex").val(PatInfoObj.baseInfoSex)
				$("#PatAge").val(PatInfoObj.baseInfoAge)
			}
		});	
		
		$HUI.radio("[name^='IKS_Q']",{
	        onCheckChange:function(e,value){
	        	TakCalScore();
	        }

	    });
	}
	
	function TakCalScore(newvalue,oldvalue){
		var count=0;
		var Score=0;
		var id = this.id;
		$("input[name^='IKS_Q']:checked").each(function(){
			if ($(this).attr("scoreval") != ""){
				Score = Score + parseFloat($(this).attr("scoreval"));
				count=count+1;
			}
		});
		$("#TotalScore").numberbox('setValue',Score);
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