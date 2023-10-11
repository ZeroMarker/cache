$(function(){

	initPage();

})

function initPage(){
	/// 会诊到达日期控制
	$(".hisui-datebox").each(function(){
		$(this).datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				var now = new Date(now.getFullYear(), now.getMonth(), now.getDate());
				return date<=now;
			}
		});
	});

	if((ModArrTime==1)||(ModArrTime==3)){
		$HUI.datebox(".hisui-datebox").enable();
		$HUI.timespinner(".hisui-timespinner").enable();
	}
	
}

function saveArr(e){
	var Obj=$(e); 
    var Itm=Obj.attr("data");
    var DateID="#Date"+Itm.split("||")[1];
    var TimeID="#Time"+Itm.split("||")[1];
    var ArrDate = $HUI.datebox(DateID).getValue();      /// 到达日期
	var ArrTime = $HUI.timespinner(TimeID).getValue();  /// 到达时间	
	$m({ClassName:"web.DHCEMConsult",MethodName:"AriCstNo","CstID":CstID,"ItmID":Itm,"LgParam":LgParam,"ArrDate":ArrDate,"ArrTime":ArrTime},
		function(ret){
			if (ret == -1){
				$.messager.alert("提示","申请单当前状态，不允许进行到达操作！","warning");
				return;
			}
			if (ret == -2){
				$.messager.alert("提示","到达时间不能大于当前时间！","warning");
				return;
			}
			if (ret == -3){
				$.messager.alert("提示","到达时间不应早于发送时间！","warning");
				return;
			}
			if (ret == -4){
				$.messager.alert("提示","到达时间不应晚于完成时间！","warning");
				return;
			}
			if (ret == -5){
				$.messager.alert("提示","到达时间不应早于接收时间！","warning");
				return;
			}
			if (ret < 0){
				$.messager.alert("提示","会诊申请到达失败，失败原因:"+ret,"warning");
			}else{
				$.messager.alert("提示","到达成功！","info");
				//websys_showModal('close');
			}
	});	

}

function canArr(e){
	var Obj=$(e); 
    var Itm=Obj.attr("data");
    var DateID="#Date"+Itm.split("||")[1];
    var TimeID="#Time"+Itm.split("||")[1];
    var ArrDate = $HUI.datebox(DateID).getValue();      /// 到达日期
    if(ArrDate==""){
		$.messager.alert("提示","无到达时间，不需取消到达！","warning");
		return;
	}
	$m({ClassName:"web.DHCEMConsult",MethodName:"CanAriCstNo","CstID":CstID,"ItmID":Itm,"LgParam":LgParam},
		function(ret){
			if (ret == -1){
				$.messager.alert("提示","非本人置到达，不允许进行该操作！","warning");
				return;
			}
			if (ret < 0){
				$.messager.alert("提示","取消到达失败，失败原因:"+ret,"warning");
			}else{
				$.messager.alert("提示","取消到达成功！","info");
				$HUI.datebox(DateID).setValue('');      /// 到达日期
				$HUI.timespinner(TimeID).setValue('');
			}
	});	
}
