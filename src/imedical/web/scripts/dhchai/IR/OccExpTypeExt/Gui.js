//页面Gui
function InitExpTypeExtWin(){
	var obj = new Object();
	
	//系统参数列表
	obj.gridExpTypeExt = $("#gridExpTypeExt").DataTable({
		dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.OccExpTypeSrv";
				d.QueryName = "QryOccExpTypeExt";
				d.Arg1 = Parref;
				d.ArgCnt = 1;
			}
		},
		"columns": [
			{"data": "ID"},
			{"data": "Code"},
			{"data": "Desc"},
			{"data": "TypeDesc"},	
			{"data": "DatDesc"},
			{"data": "DicDesc"},
			{"data": "IsRequired", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}
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
	
	InitExpTypeExtWinEvent(obj);
	return obj;
}