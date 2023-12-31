//页面Gui
function InitThWordTypeWin(){
	var obj = new Object();
	
	// 主题词分类列表
	obj.gridThWordType = $("#gridThWordType").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.RMES.ThWordTypeSrv";
				d.QueryName = "QryThWordType";
				d.ArgCnt = 0;
			}
		},
		"columns": [
			{"data": "ID"},
			{"data": "Code"},
			{"data": "Desc"},
			{"data": "ThemeTypeDesc"}
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
	
	InitThWordTypeWinEvent(obj);
	return obj;
}