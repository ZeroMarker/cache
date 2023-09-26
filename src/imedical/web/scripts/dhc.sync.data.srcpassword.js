var init = function(){
	$("#Save").on("click",function(){
		var passwordv = $("#UserPassword").val();
		var passwordv2 = $("#UserPassword2").val()
		var passlen = passwordv.length;
		
		if (passwordv.indexOf("^")>-1) {
			$.messager.alert('错误','密码不能包含上箭头');
			return ;
		}
		if ((passlen<7) || (passlen>30)) {
			$.messager.alert('错误','密码长度必须是7-30位');
			return ;
		}
		if (passwordv!=passwordv2) {
			$.messager.alert('错误','二次密码不 一样');
			return ;
		}
		$.ajaxRunServerMethod({
			ClassName:"dhc.sync.web.User", 
			MethodName:"SavePasswordBySrc",
			UserCode:$("#UserCode").val(),
			SrcPassword:$("#SrcPassword").val(),
			UserPassword:passwordv},function(data){
			if (data<0){
				$.messager.alert('失败',data.split("^")[1]);
			}else{
				$.messager.alert('成功',"保存成功!");
			}
		})		
	});
}
$(init);