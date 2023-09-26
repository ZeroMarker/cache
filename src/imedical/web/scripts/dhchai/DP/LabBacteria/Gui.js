//页面Gui
function InitLabBacteriaWin(){
	var obj = new Object();
	//细菌
	obj.gridLabBacteria = $("#gridLabBacteria").DataTable({
		dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.LabBactSrv";
				d.QueryName = "QryLabBacteria";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "WCode"},
			{"data": "BacCode"},
			{"data": "BacDesc"},
			{"data": "BacName"},
			{"data": "TypeDesc"},
			{"data": "CatDesc"},
			{"data": "IsActive", 
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

	InitLabBacteriaWinEvent(obj);
	return obj;
}