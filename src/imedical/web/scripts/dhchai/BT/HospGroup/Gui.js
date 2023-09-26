//页面Gui
function InitHospGroupWin(){
	var obj = new Object();
	
	//医院分组列表
	obj.gridHospGroup = $("#gridHospGroup").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.HospGroupSrv";
				d.QueryName = "QueryHospGroup";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{ "data": "ID"},
			{ "data": "BTCode" },
			{ "data": "BTDesc" }
		],
		drawCallback: function (settings) {
			$("#btnAdd").removeClass('disabled');
        	$("#btnEdit").addClass('disabled');
        	$("#btnDelete").addClass('disabled');
		}
	});
	
	$('body').mCustomScrollbar({
		theme : "dark-thick",
		axis: "y",
		scrollInertia : 100
	});
	
	InitHospGroupWinEvent(obj);
	return obj;
}