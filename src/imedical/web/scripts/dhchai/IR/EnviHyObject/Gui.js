//页面Gui
function InitEnviHyObjectWin(){
	var obj = new Object();
	
	//监测对象列表
	obj.gridEvObject = $("#gridEvObject").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.EnviHyObjectSrv";
				d.QueryName = "QryEvObject";
				d.ArgCnt =0;
			}
		},
		columns: [
			{ "data": "ID"},
			{ "data": "ObjectDesc"},
			{ "data": "SpecimenTypeDesc" },
			{ "data": "IsActDesc" }
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
	
	InitEnviHyObjectWinEvent(obj);
	return obj;
}