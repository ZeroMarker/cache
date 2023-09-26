//页面Gui
function InitKeyWordWin(){
	var obj = new Object();
	
	//关键词列表
	obj.gridKeyWord = $("#gridKeyWord").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CCKeyWordSrv";
				d.QueryName = "QryKeyWordSrv";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "Desc"},
			{"data": "Note"}
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
	InitKeyWordWinEvent(obj);
	return obj;
}