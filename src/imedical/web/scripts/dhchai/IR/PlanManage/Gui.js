//页面Gui
function InitPlanManageWin(){
	var obj = new Object();
	
	//短语分类列表
	obj.gridPlanManage = $("#gridPlanManage").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.PlanManageSrv";
				d.QueryName = "QryPlanManage";
				d.ArgCnt = 0;
			}
		},
		"columns": [
			{"data": "PlanTypeDesc"},
			{"data": "IRPlanName"},
			{"data": "IRKeys"},
			{"data": "IRContent"},
			{"data": "IRIsActive", 
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
	
	InitPlanManageWinEvent(obj);
	return obj;
}