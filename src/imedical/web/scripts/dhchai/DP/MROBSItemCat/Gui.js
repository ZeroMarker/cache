//页面Gui
function InitMROBSItemCatWin(){
	var obj = new Object();
	//护理分类维护 列表
	obj.gridMROBSItemCat = $("#gridMROBSItemCat").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.MROBSItemCatSrv";
				d.QueryName = "QryMROBSItemCat";
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
	
	InitMROBSItemCatWinEvent(obj);
	return obj;
}