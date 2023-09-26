//页面Gui
function InitOEAntiMastWin(){
	var obj = new Object();
	//列表
	obj.gridOEAntiMast = $("#gridOEAntiMast").DataTable({
		dom: 'rt<"row"<"col-sm-7"pl><"col-sm-5"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.OEAntiMastSrv";
				d.QueryName = "QryOEAntiMast";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "BTCode"},
			{"data": "BTName"},
			{"data": "BTName1"},
			{"data": "BTCatDesc"},
			{"data": "BTIsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
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
	
	InitOEAntiMastWinEvent(obj);
	return obj;
}