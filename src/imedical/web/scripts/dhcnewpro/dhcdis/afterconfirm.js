

$(document).ready(function() {
	alert(0);
	initMethod();
	
});

function initMethod()
{
	//�س��¼�
     //$('#NurNo').bind('keypress',afterconfirm);
     $('#NurNo').keydown(function (e) {
     if (e.keyCode == 13) {
        afterconfirm();
     }
 	});
     $('#afterconfirm').bind('click',afterconfirm); //��֤ȷ��
}
function afterconfirm()
{
	alert(LgUserCode+"||"+ReqID+"||"+LgUserID+"||"+TypeID+"||"+StatusCode)
	var UserCode=$('#NurNo').val();
	if(UserCode==LgUserCode)
	{
		runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":StatusCode,"lgUser":LgUserID,"reason":""},
		function(data){
			if(data==0){
				alert("���Ƴɹ���");
				parent.$('#win').window('close');
				}
			},'text',false)
	}
	else{
		alert("���Ŵ���")
		$('#NurNo').val('');
	}
}