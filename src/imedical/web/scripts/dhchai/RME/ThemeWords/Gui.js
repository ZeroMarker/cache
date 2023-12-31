//页面Gui
function InitThemeWordsWin(){
	var obj = new Object();
	
	// 主题词库维护
    obj.gridThemeWords = $("#gridThemeWords").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.RMES.ThemeWordsSrv";
				d.QueryName = "QryThemeWords";
				d.Arg1 = $.form.GetValue("cboThemeTypeS");
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "KeyWord"},
			{"data": "LimitWord"},
			{"data": "WordTypeDesc"},
			{"data": "Context"},
			{"data": "IsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "ActDate", 
				"render": function (data, type, row) {
					return data + " " + row.ActTime;
				}
			},
			{"data": "ActUser"}
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
	
	InitThemeWordsEvent(obj);
	return obj;
}