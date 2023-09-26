//页面Gui
function InitDicTypeWin(){
	var obj = new Object();
	
	//字典分组列表
	obj.gridDicType = $("#gridDicType").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.DicTypeSrv";
				d.QueryName = "QryDicType";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{ "data": "ID"},
			{ "data": "Code" },
			{ "data": "Desc" }
		],
		drawCallback: function (settings) {
			$("#btnAdd").removeClass('disabled');
        	$("#btnEdit").addClass('disabled');
        	$("#btnDelete").addClass('disabled');
		}
	});
	
	$('body').mCustomScrollbar({
		theme : "dark-thick",
		axis: "y",
		scrollInertia : 100
	});
	
	InitDicTypeWinEvent(obj);
	return obj;
}