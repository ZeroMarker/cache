//页面Gui
var gridThWordsMapArgs = new Object();
gridThWordsMapArgs.ThemeTypeDr="";
gridThWordsMapArgs.ThemeWordsDr="";
gridThWordsMapArgs.Flag=0;  // 控制主题词和归一词都选中时添加按钮才显示
function InitThemeWordsMapWin(){
	var obj = new Object();
	
	//主题词映射
	obj.gridThWordsMap = $("#gridThWordsMap").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.RMES.ThWordsMapSrv";
				d.QueryName = "QryThWordsMap";
				d.Arg1 = gridThWordsMapArgs.ThemeWordsDr;   //获取主题词的ID
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "ThemeWord","width":"120px",
				"render": function (data, type, row) {
					if (row.LimitWord!=""){
						return data+"("+row.LimitWord+")";
					}else{
						return data;
					}
				}
			},
			{"data": "OneWord","width":"120px"},
			{"data": "DocProperty"},
			{"data": "PropertyTypeDesc"},
			{"data": "SectionTypeDesc"},
			{"data": "DocTypeDesc"},
			{"data": "ThemeWordAct",
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "ActDate"},
			{"data": "ActUser"}
		],
		drawCallback: function (settings) {
			$("#btnEdit").addClass('disabled');
        	$("#btnDelete").addClass('disabled');
		}
	});
	
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
			{"data": "Context","width": "400px"},
			{"data": "IsActive","width": "70px",
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "ActDate","width": "100px"}
		],
		drawCallback: function (settings) {
			
		}
	});
	
	// 归一词库
    obj.gridOneWords = $("#gridOneWords").DataTable({
		dom: 'rt<"row"<"col-sm-12"pl><"col-sm-12"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.RMES.ThWordsMapSrv";
				d.QueryName = "QryOneWords";
				d.Arg1 = $.form.GetValue("cboThemeType");
				d.Arg2 = 0;
				d.ArgCnt = 2;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "OneWord"},
			{"data": "ThemeWord"},
			{"data": "ActDate","width": "100px"}
		],
		drawCallback: function (settings) {
			
		}
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitThemeWordsMapEvent(obj);
	return obj;
}