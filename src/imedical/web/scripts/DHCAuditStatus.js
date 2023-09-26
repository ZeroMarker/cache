CompObj.cls = "web.DHCAuditStatus";
CompObj.compName = "DHCAuditStatus";
CompObj.tabelPre = "Status";
function init (){
	initEvent();
	resizeGrid();
}
function resizeGrid(){
	var h = $(window).height();
	var offset = $('#tDHCAuditStatus').closest('.datagrid').offset();
	$('#tDHCAuditStatus').datagrid("resize",{height:parseInt(h-offset.top)});
}
$(init)

