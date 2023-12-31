//页面Gui
function InitDocTypeWin(){
	var obj = new Object();
	
	//文档类型列表
	obj.gridDocType = $("#gridDocType").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.RMES.DocTypeSrv";
				d.QueryName = "QryDocType";
				d.ArgCnt = 0;
			}
		},
		"columns": [
			{"data": "ID"},
			{"data": "Code"},
			{"data": "Desc"}
		],
		drawCallback: function (settings) {
			$("#btnAdd").removeClass('disabled');
        	$("#btnEdit").addClass('disabled');
        	$("#btnDelete").addClass('disabled');
		}
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitDocTypeWinEvent(obj);
	return obj;
}