//页面Gui
function InitExpTypeLabWin(){
	var obj = new Object();
	
	//系统参数列表
	obj.gridExpTypeLab = $("#gridExpTypeLab").DataTable({
		dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.OccExpTypeSrv";
				d.QueryName = "QryOccExpTypeLab";
				d.Arg1 = Parref;
				d.ArgCnt = 1;
			}
		},
		"columns": [
			{"data": "ID"},
		
			{"data": "BTDesc"},
			{"data": "BTIndNo"},
			{"data": "BTDays"},
			{"data": "IsActDesc"},
			{"data": "Resume"}
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
	
	InitExpTypeLabWinEvent(obj);
	return obj;
}