//页面Gui
function InitOEAntiCatWin(){
	var obj = new Object();
	//列表
	obj.gridOEAntiCat = $("#gridOEAntiCat").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.OEAntiCatSrv";
				d.QueryName = "QryOEAntiCat";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "BTCode"},
			{"data": "BTDesc"},
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
	InitOEAntiCatWinEvent(obj);
	return obj;
}