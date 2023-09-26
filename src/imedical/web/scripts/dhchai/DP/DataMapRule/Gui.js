//页面Gui
function InitMapRuleWin(){
	var obj = new Object();
	//细菌
	obj.gridMapRule = $("#gridMapRule").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.DataMapRuleSrv";
				d.QueryName = "QryRulebByCat";
				d.Arg1 = $.form.GetValue('cboCat');
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "Desc"},
			{"data": "MapDesc"},
			{"data": "TypeDesc"}
			
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

	InitMapRuleWinEvent(obj);
	return obj;
}