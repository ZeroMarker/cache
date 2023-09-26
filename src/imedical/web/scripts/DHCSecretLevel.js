CompObj.cls = "web.DHCSecretLevel";
CompObj.compName = "DHCSecretLevel";
CompObj.tabelPre = "Level";
CompObj.model = ["RowId","Code", "Desc", "Alias"];
function init (){
	initEvent();
	resizeGrid();
}
function resizeGrid(){
	var h = $(window).height();
	var offset = $('#tDHCSecretLevel').closest('.datagrid').offset();
	$('#tDHCSecretLevel').datagrid("resize",{height:parseInt(h-offset.top)});
}
$(init)
