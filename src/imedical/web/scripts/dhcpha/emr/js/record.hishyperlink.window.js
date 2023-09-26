$(function() {
	
	var hislink = args.unitLink.Link;
	document.title= args.unitLink.title;
	if (args.WriteBack != "" && args.WriteBack != "None")
	{
		$('#confirm').show();
	}
	$('#frameHIS').attr('src',hislink);
	
});

///确认
function btConfirm()
{
	 closeWindow();
}

//关闭
function btCancel()
{
	 closeWindow();
}

//关闭窗口
function closeWindow() {
    window.opener = null;
    window.open('', '_self');
    window.close();
}