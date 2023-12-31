//页面Gui
function InitResultTypeWin(){
	var obj = new Object();
	
	//结果类型列表
	obj.gridResultType = $("#gridResultType").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.RMES.ResultTypeSrv";
				d.QueryName = "QryResultType";
				d.ArgCnt = 0;
			}
		},
		"columns": [
			{"data": "ID"},
			{"data": "Code", //&， 大于，小于，双引号，单引号
				render: function(data, type, row, meta) {
					return (data.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
					.replace(/"/g, "&quot;").replace(/'/g, "&#39;"));
				}
			},
			{"data": "Desc"},
			{"data": "CatDesc"}
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
	
	InitResultTypeWinEvent(obj);
	return obj;
}