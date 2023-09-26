//页面Gui
function InitLabAntibioticWin(){
	var obj = new Object();
	
	//抗生素
	obj.gridLabAntibiotic = $("#gridLabAntibiotic").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.LabAntiSrv";
				d.QueryName = "QryLabAntibiotic";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "AntCode"},
			{"data": "AntDesc"},
			{"data": "CatDesc"},
			{"data": "WCode"},
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

	
	InitLabAntibioticWinEvent(obj);
	return obj;
}