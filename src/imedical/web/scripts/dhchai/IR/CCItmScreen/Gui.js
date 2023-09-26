//页面Gui
function InitCCItmScreenWin(){
	var obj = new Object();
	
	//疑似筛查项目列表
	obj.gridCCItmScreen = $("#gridCCItmScreen").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CCItmScreenSrv";
				d.QueryName = "QryScreenSrv";
				d.Arg1="";
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "Desc"},
			{"data": "Desc2"},
			{"data": "KeyWords"},
			{"data": "Arg1"},
			{"data": "Arg2"},
			{"data": "Arg3"},
			{"data": "Arg4"},
			{"data": "Arg5"},
			{"data": "Arg6"},
			{"data": "Arg7"},
			{"data": "Arg8"},
			{"data": "Arg9"},
			{"data": "Arg10"},
			{"data": "Score"},
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
	InitCCItmScreenWinEvent(obj);
	return obj;
}