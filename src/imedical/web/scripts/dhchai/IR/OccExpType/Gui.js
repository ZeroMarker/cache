//页面Gui
function InitExpTypeWin(){
	var obj = new Object();
	
	//系统参数列表
	obj.gridExpType = $("#gridExpType").DataTable({
		dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.OccExpTypeSrv";
				d.QueryName = "QryOccExpType";
				d.ArgCnt = 0;
			}
		},
		"columns": [
			{"data": "ID"},
			{"data": "BTCode"},
			{"data": "BTDesc"},
			{
			"data": null,
				render: function ( data, type, row ) {
					if (row['IsActive'] != '1') {
						return '';
					} else {
						return '<a href="#" class="btnExt">项目定义</a>';
					}
				}
			},{
			"data": null,
				render: function ( data, type, row ) {
					if (row['IsActive'] != '1') {
						return '';
					} else {
						return '<a href="#" class="btnCap">检验结果对照</a>';
					}
				}
			},{
			"data": null,
				render: function ( data, type, row ) {
					if (row['IsActive'] != '1') {
						return '';
					} else {
						return '<a href="#" class="btnLab">血清检查计划</a>';
					}
				}
			},
			{"data": "IsActDesc"},
			{"data": "Resume"}
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
	
	InitExpTypeWinEvent(obj);
	return obj;
}