var WomenCkpanel=(function(){
	function Init(){
		/// 末次月经日期控制
		$('#MensDate').datebox({
			onSelect: function(date){
				$HUI.checkbox("#PauFlag").setValue(false);  /// 绝经
				$HUI.checkbox("#UnknownFlag").setValue(false);  /// 绝经
				return true;
			}
		});
		$('#MensDate').datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});	
		/// 胎数
		$("#PreTimes").keyup(function(){
		    var PreTimes = $("#PreTimes").val();  /// 胎数
		    var LyTimes = $("#LyTimes").val();    /// 产数
		    if ((LyTimes != "")&(PreTimes < LyTimes)){
			    $.messager.alert("提示:","胎数必须大于等于产数！");
				$("#PreTimes").val("");
			}
		});
		$("#PauFlag").click(function(){
			if ($("#PauFlag").is(":checked")){
				$HUI.checkbox("#UnknownFlag").setValue(false);  /// 绝经
				$HUI.datebox("#MensDate").setValue("");  
				}
			})
		$("#UnknownFlag").click(function(){
			if ($("#UnknownFlag").is(":checked")){
				$HUI.checkbox("#PauFlag").setValue(false);  /// 绝经
				$HUI.datebox("#MensDate").setValue("");  
				}
			})
		/// 产数
		$("#LyTimes").keyup(function(){
		    var PreTimes = $("#PreTimes").val();  /// 胎数
		    var LyTimes = $("#LyTimes").val();    /// 产数
		    if ((LyTimes != "")&(PreTimes < LyTimes)){
			    $.messager.alert("提示:","胎数必须大于等于产数！");
				$("#LyTimes").val("");
			}
		});
		if (MapCode=="TCTN"){
			$("#WomenCk").hide();
			if (ServerObj.TCTWomen!="0"){
			//$("label[for=WomenCk]").html("<label style='font-weight:bold;'>"+$g("妇科信息")+"<font color='red'>"+$g("(必填项)")+"</font></label>")
			//$("#WomenCkpanel").attr("title","<label style='font-weight:bold;'>"+$g("妇科信息")+"<font color='red'>"+$g("(必填项)")+"</font></label>");
			}else{
				$(".panel-title").each(function(){
					if($(this).text()=="妇科信息(必填项)"){
						$(this).html($g("妇科信息"))
						}
				})
				
			}
		}else{
			$("#WomenCk").nextAll().css("display","none");	
			$("#WomenCk").click(function(){
				if($("#WomenCk").is(':checked')){
					$("#WomenCk").nextAll().css("display","block");
				}else{
					$("#WomenCk").nextAll().css("display","none");
				}
				if (!$("#WomenCk").is(":checked")){
					$HUI.datebox("#MensDate").setValue("");      /// 末次月经
					$("#PreTimes").val(""); 	   		         /// 胎
					$("#LyTimes").val(""); 	   		             /// 产
					$HUI.checkbox("#PauFlag").setValue(false);   /// 绝经
				}
			});
		}
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