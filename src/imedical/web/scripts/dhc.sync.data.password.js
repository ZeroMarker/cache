var init = function(){
	$("#Save").on("click",function(){
		var passwordv = $("#UserPassword").val();
		var passwordv2 = $("#UserPassword2").val()
		var passlen = passwordv.length;
		
		if (passwordv.indexOf("^")>-1) {
			$.messager.alert('����','���벻�ܰ����ϼ�ͷ');
			return ;
		}
		if ((passlen<7) || (passlen>30)) {
			$.messager.alert('����','���볤�ȱ�����7-30λ');
			return ;
		}
		if (passwordv!=passwordv2) {
			$.messager.alert('����','�������벻 һ��');
			return ;
		}
		/*$.ajaxRunServerMethod({
			ClassName:"dhc.sync.web.User", 
			MethodName:"SavePassword",
			UserCode:$("#UserCode").val(),
			UserPassword:passwordv},function(data){
			if (data<0){
				$.messager.alert('ʧ��',data.split("^")[1]);
			}else{
				$.messager.alert('�ɹ�',"����ɹ�!");
			}
		})*/
		var data = tkMakeServerCall("dhc.sync.web.User","SavePassword",$("#UserCode").val(),passwordv);
		if (data<0){
			$.messager.alert('ʧ��',data.split("^")[1]);
		}else{
			alert(data);
			$.messager.alert('�ɹ�',"����ɹ�!");
		}
				
	});
}
$(init);