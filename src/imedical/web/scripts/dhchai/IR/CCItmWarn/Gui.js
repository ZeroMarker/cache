//页面Gui
function InitCCItmWarnWin(){
	var obj = new Object();
	
	//监控项目列表
	obj.gridCCItmWarn = $("#gridCCItmWarn").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CCItmWarnSrv";
				d.QueryName = "QryWarnSrv";
				d.Arg1="";
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "Desc"},
			{"data": "Desc2"},
			{"data": "KeyWords"},
			{"data": "IndNo"},
			{"data": "Arg1"},
			{"data": "Arg2"},
			{"data": "Arg3"},
			{"data": "Arg4"},
			{"data": "Arg5"},
			{"data": "IsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "ActDate", 
				"render": function (data, type, row) {
					return data + ' ' + row.ActTime;
				}
			},
			{"data": "ActUserDesc"}
			
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
	InitCCItmWarnWinEvent(obj);
	return obj;
}