//页面Gui
function InitPropertyTypeWin(){
	var obj = new Object();
	
	//属性类型列表
	obj.gridPropertyType = $("#gridPropertyType").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.RMES.PropertyTypeSrv";
				d.QueryName = "QryPropertyType";
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
			{"data": "Desc"}
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
	
	InitPropertyTypeWinEvent(obj);
	return obj;
}