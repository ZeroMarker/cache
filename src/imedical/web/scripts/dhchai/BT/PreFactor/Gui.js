//页面Gui
function InitPreFactorWin(){
	var obj = new Object();
	
	//易感因素列表
	obj.gridPreFactor = $("#gridPreFactor").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.PreFactorSrv";
				d.QueryName = "QueryPreFactor";
				d.Arg1="";
				d.ArgCnt =1;
			}
		},
		columns: [
			{ "data": "ID"},
			{ "data": "BTCode" },
			{ "data": "BTDesc" },
			{ "data": "BTIndNo" },
			{ "data": "BTIsNewborn" },
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
	
	InitPreFactorWinEvent(obj);
	return obj;
}