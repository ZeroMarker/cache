function InitHHProductsWin(){
	var obj = new Object();
	
    // 手卫生用品维护
	obj.gridHHProducts = $("#gridHHProducts").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.HandHyProductsSrv";
				d.QueryName = "QryHHProducts";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "HHPCode"},
			{"data": "HHPDesc"},
			{"data": "HHPPinyin"},
			{"data": "HHPSpec"},
			{"data": "UnitDesc"},
			{"data": "AvgAmount"},
			{"data": "IsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
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
	
	InitHHProductsWinEvent(obj);
	return obj;
}