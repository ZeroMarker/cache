//页面Gui
function InitCSSSurWin(){
	var obj = new Object();
	
	//系统参数列表
	obj.gridCSSSur = $("#gridCSSSur").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.SurveyExecSrv";
				d.QueryName = "QueryByCode";
				d.Arg1 ="";
				d.ArgCnt = 1;
			}
		},
		"columns": [
			{"data": "ID"},
			{"data": "SESurvNumber"},
			{"data": "SESurvSttDate"},
			{"data": "SESurvEndDate"},
			{"data": "HospDesc"},
			{"data": "UserDesc"}
		],"columnDefs": [{
			"type":"date-euro",
			"targets": [1,2]
		}],
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
	
	InitCSSSurWinEvent(obj);
	return obj;
}