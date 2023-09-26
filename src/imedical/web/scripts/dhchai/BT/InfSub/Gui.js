//页面Gui
function InitInfSubWin(){
	var obj = new Object();
	
	//感染诊断分类列表
	obj.gridInfSub = $("#gridInfSub").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.InfSubSrv";
				d.QueryName = "QryInfSub";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{ "data": "ID"},
			{ "data": "Code" },
			{ "data": "Desc" },
			{ "data": "IsActive"}
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
	
	InitInfSubWinEvent(obj);
	return obj;
}