function InitSystemMapWin(){
	var obj = new Object();
	
	// 子系统对照列表
	obj.gridSystemMap = $("#gridSystemMap").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.SystemMapSrv";
				d.QueryName = "QrySystemMapInfo";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{ "data": "ID"},
			{ "data": "Code"},
			{ "data": "Desc"},
			{ "data": "HISCode"},
			{ "data": "SysDesc"},
			{ "data": "HospDesc"},
			{"data": "IsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "ActDate",
				"render": function (data, type, row) {
					return data + ' ' + row["ActTime"];
				}
			},
			{ "data": "ActUserDesc"}
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
	
	InitSystemMapWinEvent(obj);
	return obj;
}