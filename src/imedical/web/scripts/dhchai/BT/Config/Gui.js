//页面Gui
function InitConfigWin(){
	var obj = new Object();
	
	//系统参数列表
	obj.gridConfig = $("#gridConfig").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.ConfigSrv";
				d.QueryName = "QueryByCode";
				d.Arg1 ="";
				d.Arg2="";
				d.ArgCnt = 2;
			}
		},
		"columns": [
			{"data": "ID"},
			{"data": "BTCode"},
			{"data": "BTDesc"},
			{"data": "Value"},
			{"data": "HospDesc"},
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
	
	InitConfigWinEvent(obj);
	return obj;
}