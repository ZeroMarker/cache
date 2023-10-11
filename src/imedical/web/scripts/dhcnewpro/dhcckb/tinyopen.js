var dicParref = getParam("dicParref");
///设置日志查看连接  lidong  parref
function setLogCellOpen(value, rowData, rowIndex){
	var src = "../scripts_lib/hisui-0.1.0/dist/css/icons/pencil.png";
	if ((typeof HISUIStyleCode == "string") && (HISUIStyleCode == "lite")) {
		src = "../scripts_lib/hisui-0.1.0/dist/css/icons/gray_edit.png";
	}
	return "<a href='#' onclick=\"showEditWin('"+rowData.dicID+"','"+rowData.parref+"')\"><img src='"+src+"' border=0 style='border:0'/></a>";
	 

}
/// 查看日志详情  lidong dicParref
function showEditWin(ID,parref){
	/* var linkUrl = "dhcckb.tinymce.csp"
	var title = "富文本详情"
	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'?ID='+ID+'&parref='+parref+'&dicParref='+dicParref+'"></iframe>';
	window.open ("<%=path %>dhcckb.tinymce.csp?id="+id,"回复窗口","fullscreen=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no, copyhistory=no,width=350,height=140,left=200,top=300"); */
	var url='dhcckb.propertycomp.csp?ID='+ID+'&parref='+parref+'&dicParref='+dicParref+''
	if ('undefined'!==typeof websys_getMWToken){
	url += "&MWToken="+websys_getMWToken()
	}
	window.open (
	url,
	'newwindow',
	'height=1000,width=1800,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no'
	) 

}


