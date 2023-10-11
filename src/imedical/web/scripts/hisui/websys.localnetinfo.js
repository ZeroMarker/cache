//websys.localnetinfo
$(function (){
	var info = $("#GetInfo").val();
	var arr = info.split("^");
	$("#LocalIP").val(arr[0]);
	$("#LocalMAC").val(arr[4]);
	$("#LocalName").val(arr[3]);
	var ecpip = $("#GetServerIP").val();
	$("#ECPIP").val(ecpip);
	$("#SessionId").val(arr[1]);
	$(".textbox ").prop('readonly',true);
	var tr0 = $('.i-tableborder tr').eq(0);
	var td3 = tr0.find('td').eq(3);
	$('<a href="#">≤‚ ‘Õ¯¬Á</a>').appendTo(td3).linkbutton({iconCls:"icon-w-run"}).click(function(){
		var urlIp = location.hostname
		var arr = [];
		arr.push("Function vbs_Test");
		arr.push('Set obj=createobject("wscript.shell")')
		arr.push('obj.run "ping '+urlIp+' -t "')
		arr.push("vbs_Test = 1");
		arr.push("End Function\n");
		var str = arr.join('\n'); 
		CmdShell.CurrentUserEvalJs(str,"vbscript")
		//CmdShell.CurrentUserEvalJs("start cmd.exe "+urlIp,"vbscript")
	});
});