var TumorCkpanel=(function(){
	function Init(){
		
		//肿瘤信息选择后在显示详细信息 qunianpeng 2018/1/19	
		$("#TumorCk").nextAll().css("display","none");	
		$("#TumorCk").click(function(){
			if($("#TumorCk").is(':checked')){
				$("#TumorCk").nextAll().css("display","block");
			}else{
				$("#TumorCk").nextAll().css("display","none");
			}
			if (!$("#TumorCk").is(":checked")){
			$HUI.datebox("#FoundDate").setValue("");   /// 发现日期
			$("#TumPart").val(""); 	   		           /// 原发部位
			$("#TumSize").val(""); 	   		           /// 肿瘤大小
			$("#TransPos").val(""); 	   		           /// 转移部位
			$("#Remark").val(""); 	   		               /// 备注
			$HUI.checkbox("#TransFlag").setValue(false);   /// 转移
			$HUI.checkbox("#RadCureFlag").setValue(false); /// 放疗
			$HUI.checkbox("#CheCureFlag").setValue(false); /// 化疗
		}
		});
	}
	function OtherInfo(){
		return ""
	}
	function PrintInfo(){
		
	}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
	   
})();