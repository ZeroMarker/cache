// 页面Gui
function InitCRuleRBAbWin(){
	var obj = new Object();
	// 影像学筛查标准
	obj.gridCRuleRBAb = $("#gridCRuleRBAb").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CRuleRBAbSrv";
				d.QueryName = "QryCRuleRBAb";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "RBCode"},
			{"data": "RBPos"},
			{"data": "RBNote"},
			{"data": "RBCFlag", 
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
	//影像学筛查标准-检查项目列表
	obj.gridCRuleRBCode = $("#gridCRuleRBCode").DataTable({
		dom: 'rt',
		select: 'single',
		paging: false,
		ordering: false,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CRuleRBCodeSrv";
				d.QueryName = "QryCRuleRBCodeByID";
				var rd = obj.gridCRuleRBAb.rows({selected: true}).data().toArray()[0];
				d.Arg1 = (rd ? rd["ID"] : '');
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "RBCodeDesc"},
			{"data": "ActDate", 
				"render": function (data, type, row) {
					return data + ' ' + row.ActTime;
				}
			},
			{"data": "ActUser"}
		]
		,drawCallback: function (settings) {
			var rd = obj.gridCRuleRBAb.rows({selected: true}).data().toArray()[0];
			if (rd) {
				$("#btnAdd_two").removeClass('disabled');
			}
        	$("#btnEdit_two").addClass('disabled');
        	$("#btnDelete_two").addClass('disabled');
		}
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	InitCRuleRBAbWinEvent(obj);
	return obj;
}