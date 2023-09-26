//页面Gui
function InitPhraseTypeWin(){
	var obj = new Object();
	
	//短语分类列表
	obj.gridPhraseType = $("#gridPhraseType").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.PhraseTypeSrv";
				d.QueryName = "QryPhraseType";
				d.ArgCnt = 0;
			}
		},
		"columns": [
			{"data": "ID"},
			{"data": "Code"},
			{"data": "Desc"},
			{"data": "DicTypeCode"},
			{"data": "DicTypeDesc"}
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
	
	InitPhraseTypeWinEvent(obj);
	return obj;
}