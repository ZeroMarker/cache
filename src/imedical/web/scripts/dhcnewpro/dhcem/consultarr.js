$(function(){

	initPage();

})

function initPage(){
	/// ���ﵽ�����ڿ���
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
    var ArrDate = $HUI.datebox(DateID).getValue();      /// ��������
	var ArrTime = $HUI.timespinner(TimeID).getValue();  /// ����ʱ��	
	$m({ClassName:"web.DHCEMConsult",MethodName:"AriCstNo","CstID":CstID,"ItmID":Itm,"LgParam":LgParam,"ArrDate":ArrDate,"ArrTime":ArrTime},
		function(ret){
			if (ret == -1){
				$.messager.alert("��ʾ","���뵥��ǰ״̬����������е��������","warning");
				return;
			}
			if (ret == -2){
				$.messager.alert("��ʾ","����ʱ�䲻�ܴ��ڵ�ǰʱ�䣡","warning");
				return;
			}
			if (ret == -3){
				$.messager.alert("��ʾ","����ʱ�䲻Ӧ���ڷ���ʱ�䣡","warning");
				return;
			}
			if (ret == -4){
				$.messager.alert("��ʾ","����ʱ�䲻Ӧ�������ʱ�䣡","warning");
				return;
			}
			if (ret == -5){
				$.messager.alert("��ʾ","����ʱ�䲻Ӧ���ڽ���ʱ�䣡","warning");
				return;
			}
			if (ret < 0){
				$.messager.alert("��ʾ","�������뵽��ʧ�ܣ�ʧ��ԭ��:"+ret,"warning");
			}else{
				$.messager.alert("��ʾ","����ɹ���","info");
				//websys_showModal('close');
			}
	});	

}

function canArr(e){
	var Obj=$(e); 
    var Itm=Obj.attr("data");
    var DateID="#Date"+Itm.split("||")[1];
    var TimeID="#Time"+Itm.split("||")[1];
    var ArrDate = $HUI.datebox(DateID).getValue();      /// ��������
    if(ArrDate==""){
		$.messager.alert("��ʾ","�޵���ʱ�䣬����ȡ�����","warning");
		return;
	}
	$m({ClassName:"web.DHCEMConsult",MethodName:"CanAriCstNo","CstID":CstID,"ItmID":Itm,"LgParam":LgParam},
		function(ret){
			if (ret == -1){
				$.messager.alert("��ʾ","�Ǳ����õ����������иò�����","warning");
				return;
			}
			if (ret < 0){
				$.messager.alert("��ʾ","ȡ������ʧ�ܣ�ʧ��ԭ��:"+ret,"warning");
			}else{
				$.messager.alert("��ʾ","ȡ������ɹ���","info");
				$HUI.datebox(DateID).setValue('');      /// ��������
				$HUI.timespinner(TimeID).setValue('');
			}
	});	
}
