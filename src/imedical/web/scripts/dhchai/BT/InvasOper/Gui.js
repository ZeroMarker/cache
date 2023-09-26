//页面Gui
function InitInvasOperWin(){
	var obj = new Object();
	
	//侵害性操作列表
	obj.gridInvasOper = $("#gridInvasOper").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		order: [[ 4, 'desc' ], [ 3, 'asc' ]],
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.InvasOperSrv";
				d.QueryName = "QueryInvasOper";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{ "data": "ID"},
			{ "data": "BTCode" },
			{ "data": "BTDesc" },
			{ "data": "BTIndNo" },
			{ "data": "BTIsActive" }
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
	
	InitInvasOperWinEvent(obj);
	return obj;
}
