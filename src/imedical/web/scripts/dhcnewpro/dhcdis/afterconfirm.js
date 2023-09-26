

$(document).ready(function() {
	alert(0);
	initMethod();
	
});

function initMethod()
{
	//回车事件
     //$('#NurNo').bind('keypress',afterconfirm);
     $('#NurNo').keydown(function (e) {
     if (e.keyCode == 13) {
        afterconfirm();
     }
 	});
     $('#afterconfirm').bind('click',afterconfirm); //验证确认
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
				alert("出科成功！");
				parent.$('#win').window('close');
				}
			},'text',false)
	}
	else{
		alert("工号错误！")
		$('#NurNo').val('');
	}
}