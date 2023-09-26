var cls = "websys.DHCMessageConfig"
var DHCMCSendModeMthJObj ;
function disable(arr){
	for (var i=0; i<arr.length; i++){
		$("#"+arr[i]).prop("readonly",true).css("background-color","#f0f0f0");
	}
}
function enable(arr){
	for (var i=0; i<arr.length; i++){
		$("#"+arr[i]).prop("readonly",false).css("background-color","#ffffff");
	}
}
function typeToggleFun(type){
	if (type=="HTTP"){
		disable(["AttaServerIP","AttaServerUser","AttaServerPwd","AttaServerPort"]);
		$("#TestBtn").linkbutton("disable");
	}else{
		enable(["AttaServerIP","AttaServerUser","AttaServerPwd","AttaServerPort"]);
		$("#TestBtn").linkbutton("enable");
	}
}
var init = function(){
	var type = $("#AttaServerType").combobox("getValue");
	typeToggleFun(type);
	$("#AttaServerType").combobox("options").onSelect = function(r){
		typeToggleFun(r.value);
		console.dir($("#TestBtn").linkbutton("options"));
	}
	$("#TestBtn").click(function(){
		if ($(this).linkbutton("options").disabled){
			return false;
		}
		var AttaServerIP = $("#AttaServerIP").val();
		var	AttaServerType = $("#AttaServerType").combobox("getValue");
		var	AttaServerUser = $("#AttaServerUser").val();
		var	AttaServerPwd = $("#AttaServerPwd").val();
		var	AttaServerPort = $("#AttaServerPort").val();
		if (AttaServerType=="FTP"){
			$("#Loading").css("opacity","0.3").fadeIn("fast");
			$.ajaxRunServerMethod({
				ClassName:"websys.File",
				MethodName:"FTPTest",
				IP:AttaServerIP, 
				UserName:AttaServerUser, 
				Password:AttaServerPwd, 
				Port:AttaServerPort
			},function(rtn){
				if(parseInt(rtn)>0){
					$(function(){$("#Loading").fadeOut("fast");});
					$.messager.alert("提示","连接成功!");
				}else{
					$(function(){$("#Loading").fadeOut("fast");});
					$.messager.alert("提示",rtn.split("^")[1]);
				}
			});
		}else{
			$.messager.alert('提示','非FTP协议,不能测试！');  
		}
	});
	$("#Save").click(function(){
		var ID = $("#ID").val();
		$.ajaxRunServerMethod({
			ID:ID,ClassName:cls,MethodName:"Save",
			SearchInterval:$("#DHCMCSearchInterval").val(),
			E:$("#DHCMCESendModeMth").combogrid("getValue"),
			ENS:$("#DHCMCENSSendModeMth").combogrid("getValue"),
			OA:$("#DHCMCOASendModeMth").combogrid("getValue"),
			S:$("#DHCMCSSendModeMth").combogrid("getValue"),
			Other : $("#DHCMCOtherSendModeMth").combogrid("getValue"),
			AttaServerIP :$("#AttaServerIP").val(),
			AttaServerType :$("#AttaServerType").combobox("getValue"),
			AttaServerUser :$("#AttaServerUser").val(),
			AttaServerPwd :$("#AttaServerPwd").val(),
			AttaServerPort :$("#AttaServerPort").val()
			,AudioOnNewOrAlert:$('#AudioOnNewOrAlert').prop('checked')?1:0
		},
		
			function(rtn){
				if(parseInt(rtn)>0){
					$.messager.alert("提示","操作成功!");
				}else{
					$.messager.alert("提示",rtn.split("^")[1]);
				}
			}
		);
	});	
}	
$(init);