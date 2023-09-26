//页面Gui
function InitCRuleTsAbWin(){
	var obj = new Object();
	
	//常规检验项目
	obj.gridCRuleTsAb = $("#gridCRuleTsAb").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CRuleTestSrv";
				d.QueryName = "QryCRuleTestAb";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "TestSet"},
			{"data": "TestCode"}, 
			{"data": "TCFlag", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}, 
			{"data": "TSPFlag", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "TRFFlag", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}, 
			{"data": "TRFlag", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}, 
			{"data": "TRVMaxFlag", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}, 
			{"data": "MaxValM"}, 
			{"data": "MaxValF"}, 
			{"data": "TRVMinFlag", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}, 
			{"data": "MinValM"}, 
			{"data": "MinValF"} 
		
		],
		drawCallback: function (settings) {
			$("#btnAdd").removeClass('disabled');
        	$("#btnEdit").addClass('disabled');
        	$("#btnDelete").addClass('disabled');
		}
	});
	$('body').mCustomScrollbar({
		scrollButtons: { enable: true },
		theme: "dark-thick",
		scrollInertia : 100
	});
	InitCRuleTsAbWinEvent(obj);
	return obj;
}