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
		$('#FtpCmdTranslateTable').combobox('disable');
	}else{
		enable(["AttaServerIP","AttaServerUser","AttaServerPwd","AttaServerPort"]);
		$("#TestBtn").linkbutton("enable");
		$('#FtpCmdTranslateTable').combobox('enable');
	}
}
var g_encpwd = "";
var g_defpwd="********";
var init = function(){
	$('#FtpCmdTranslateTable').combobox({
		data:[
			{value:'AUTO',text:'自动'}
			,{value:'GB18030',text:'GB18030'}
			,{value:'UTF8',text:'UTF8'}
		],panelHeight:'auto'
	})
	
	var AttaServerPwd = $("#AttaServerPwd").val();
	if (AttaServerPwd!="") {
		g_encpwd = AttaServerPwd;
		$("#AttaServerPwd").val(g_defpwd);
	}
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
		if (AttaServerPwd===g_defpwd) {
			AttaServerPwd = g_encpwd;
		}else{
			AttaServerPwd = simpleEncrypt(AttaServerPwd,"AttaServerPwd");
		}
		var AttaServerPort = $("#AttaServerPort").val();
		var AttaServerSSLConfig = $("#AttaServerSSLConfig").val();
		if (AttaServerType=="FTP"){
			$("#Loading").css("opacity","0.3").fadeIn("fast");
			$.ajaxRunServerMethod({
				ClassName:"websys.File",
				MethodName:"FTPTest",
				IP:AttaServerIP, 
				UserName:AttaServerUser, 
				Password:AttaServerPwd, 
				Port:AttaServerPort,
				SSLConfig:AttaServerSSLConfig
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
		var	AttaServerPwd = $("#AttaServerPwd").val();
		if (AttaServerPwd===g_defpwd) {
			AttaServerPwd = g_encpwd;
		}else{
			AttaServerPwd = simpleEncrypt(AttaServerPwd,"AttaServerPwd");
		}
		var	AttaServerSSLConfig = $("#AttaServerSSLConfig").val();
		var FtpCmdTranslateTable= $('#FtpCmdTranslateTable').combobox('getValue')||'';
		///按大类显示消息
		var ShowByCatgory=$('#ShowByCatgory').prop('checked')?'Y':'N';
		/// 回复消息不弹框
		var ReplyIsGeneral=$('#ReplyIsGeneral').prop('checked')?'Y':'N';
		///显示【一键阅读】
		var ShowOneKeyRead=$('#ShowOneKeyRead').prop('checked')?'Y':'N';
		
		$.ajaxRunServerMethod({
			ID:ID,ClassName:cls,MethodName:"Save",
			SearchInterval:$("#DHCMCSearchInterval").val(),
			E:$("#DHCMCESendModeMth").length>0?$("#DHCMCESendModeMth").combogrid("getValue"):'',
			ENS:$("#DHCMCENSSendModeMth").length>0?$("#DHCMCENSSendModeMth").combogrid("getValue"):'',
			OA:$("#DHCMCOASendModeMth").length>0?$("#DHCMCOASendModeMth").combogrid("getValue"):'',
			S:$("#DHCMCSSendModeMth").length>0?$("#DHCMCSSendModeMth").combogrid("getValue"):'',
			Other : $("#DHCMCOtherSendModeMth").length>0?$("#DHCMCOtherSendModeMth").combogrid("getValue"):'',
			AttaServerIP :$("#AttaServerIP").val(),
			AttaServerType :$("#AttaServerType").combobox("getValue"),
			AttaServerUser :$("#AttaServerUser").val(),
			AttaServerPwd :AttaServerPwd,
			AttaServerPort :$("#AttaServerPort").val()
			,AudioOnNewOrAlert:$('#AudioOnNewOrAlert').prop('checked')?1:0
			,AttaServerSSLConfig:AttaServerSSLConfig
			,FtpCmdTranslateTable:FtpCmdTranslateTable
			,ShowByCatgory:ShowByCatgory
			,ReplyIsGeneral:ReplyIsGeneral
			,ShowOneKeyRead:ShowOneKeyRead
		},function(rtn){
				if(parseInt(rtn)>0){
					$.messager.alert("提示","操作成功!");
				}else{
					$.messager.alert("提示",rtn.split("^")[1]);
				}
			}
		);
	});	
	$("#UserSearchIntervalBtn").click(function(){
		websys_createWindow("websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCMessageConfigUser&rowid="+$("#ID").val())
	});
}	
$(init);