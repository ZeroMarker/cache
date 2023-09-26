//页面Gui
function InitHospitalWin(){
	var obj = new Object();
	
	//医院列表
	obj.gridHospital = $("#gridHospital").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		"ajax": {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.HospitalSrv";
				d.QueryName = "QryHospital";
				d.ArgCnt = 0;
			}
		},
		"columns": [
			{"data": "ID"},
			{"data": "BTCode"},
			{"data": "BTDesc"},
			{"data": "BTDesc2"},
			{"data": "BTGroupDesc"},
			{"data": "BTIsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "BTActDate", 
				"render": function (data, type, row) {
					return data + ' ' + row.BTActTime;
				}
			},
			{"data": "BTActUser"}
		],
		drawCallback: function (settings) {
			$("#btnsyn").removeClass('disabled');
        	$("#btnEdit").addClass('disabled');
		}
	});
	
	$('body').mCustomScrollbar({
		theme : "dark-thick",
		axis: "y",
		scrollInertia : 100
	});
	
	InitHospitalWinEvent(obj);
	return obj;
}