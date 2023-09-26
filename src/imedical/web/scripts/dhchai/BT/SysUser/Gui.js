//页面Gui
function InitSysUserWin(){
	var obj = new Object();
	
	//用户列表
	obj.gridSysUser = $("#gridSysUser").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		"ajax": {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.SysUserSrv";
				d.QueryName = "QrySysUser";
				d.ArgCnt = 0;
			}
		},
		"columns": [
			{"data": "ID"},
			{"data": "UserCode"},
			{"data": "UserDesc"},
			{"data": "LocDesc"},
			{"data": "TypeDesc"},
			{"data": "Active", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "ActDate", 
				"render": function (data, type, row) {
					return data + ' ' + row.ActTime;
				}
			},
			{"data": "ActUser"}
		],
		"columnDefs": [{
			"type":"date-euro",
			"targets": [6]
		}]
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitSysUserWinEvent(obj);
	return obj;
}