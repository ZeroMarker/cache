//页面Gui
function InitRMEWordsWin(){
	var obj = new Object();
	obj.ThemeWordsDr = '';
	
	// 主题词库
    obj.gridThemeWords = $("#gridThemeWords").DataTable({
		dom: 'rt<"row"<"col-sm-12"pl><"col-sm-12"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.RMES.ThemeWordsSrv";
				d.QueryName = "QryThemeWords";
				d.Arg1 = $.form.GetValue("cboThemeType");
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "KeyWord",
				"render": function (data, type, row) {
					if (row.LimitWord!=""){
						return data+"("+row.LimitWord+")";
					}else{
						return data;
					}
				}
			},
			{"data": "Context"},
			{"data": "IsActive",
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}
		],
		drawCallback: function (settings) {
			
		}
	});
	
	// 语义词标注
    obj.gridThWordsMap = $("#gridThWordsMap").DataTable({
		dom: 'rt<"row"<"col-sm-12"pl><"col-sm-12"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.RMES.ThWordsMapSrv";
				d.QueryName = "QryThWordsKeys";
				d.Arg1 = obj.ThemeWordsDr;
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ParserWordDr"},
			{"data": "ParserWord"},
			{"data": "LimitWord"},
			{"data": "Context"},
			{"data": "OneWord"},
			{"data": "IsCheck",
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "IsActive",
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}
		],
		drawCallback: function (settings) {
			
		}
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitRMEWordsWinEvent(obj);
	return obj;
}