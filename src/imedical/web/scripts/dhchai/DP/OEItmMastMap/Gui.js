//页面Gui
var flg="";
function InitOEItmMastMapWin(){
	var obj = new Object();
	//列表
	obj.gridOEItmMastMap = $("#gridOEItmMastMap").DataTable({
		dom: 'rt<"row"<"col-sm-7"pl><"col-sm-5"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.OEItmMastMapSrv";
				d.QueryName = "QryOEItmMastMap";
				d.Arg1 = flg;
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "BTOrdDesc"},
			{"data": "OrdCatDesc"},
			{"data": "BTMapItemDesc"},
			{"data": "HospGroup"},
			{"data": "BTIsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "BTMapNote"}
		],
		drawCallback: function (settings) {
			$("#btnAdd").addClass('disabled');
        	$("#btnEdit").addClass('disabled');
        	$("#btnDelete").addClass('disabled');
		}
	});
	//医嘱项字典
	obj.gridOEItmMast = $("#gridOEItmMast").DataTable({
		dom: 'rtpl',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.OEItmMastSrv";
				d.QueryName = "QryOEItmMast";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "BTCode"},
			{"data": "BTDesc"},
			{"data": "BTIsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}
		]
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitOEItmMastMapWinEvent(obj);
	return obj;
}