//页面Gui
var iSearch = "";
function InitSectionTypeWin() {
	var obj = new Object();
	//段落分类列表
	obj.gridSectionType = $("#gridSectionType").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.RMES.SectionTypeSrv";
				d.QueryName = "QrySectionType";
				d.Arg1 = iSearch;
				d.ArgCnt = 1;
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
	
	InitSectionTypeWinEvent(obj);
	return obj;
}