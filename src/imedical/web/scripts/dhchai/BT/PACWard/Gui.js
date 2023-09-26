//页面Gui
function InitPACWardWin(){
	var obj = new Object();
	// 病区分布定义
	obj.gridPACWard = $("#gridPACWard").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.PACWardSrv";
				d.QueryName = "QryWard";
				d.ArgCnt = 0;
			}
		},
		"columns": [
			{"data": "ID"},
			{"data": "LocDesc"},
			{"data": "SubNo"},
			{"data": "AreaColor"},
			{"data": "Building"},
			{"data": "Floor"},
			{"data": "Area"},
		],
		drawCallback: function (settings) {
        	$("#btnEdit").addClass('disabled');
        	$("#btnDelete").addClass('disabled');
        	$("#btnWardSubNo").addClass('disabled');
		}
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitPACWardWinEvent(obj);
	return obj;
}