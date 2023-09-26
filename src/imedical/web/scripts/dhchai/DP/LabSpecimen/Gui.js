//页面Gui
function InitLabSpecimenWin(){
	var obj = new Object();
	
	//标本列表
	obj.gridLabSpecimen = $("#gridLabSpecimen").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.LabSpecSrv";
				d.QueryName = "QryLabSpecimen";
				d.Arg1='';
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "SpecCode"},
			{"data": "SpecDesc"},
			{"data": "WCode"},
			{"data": "IsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "PropertyDesc"}
			
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
	
	InitLabSpecimenWinEvent(obj);
	return obj;
}