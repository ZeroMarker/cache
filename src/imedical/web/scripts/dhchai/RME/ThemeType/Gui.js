//页面Gui
function InitThemeTypeWin(){
	var obj = new Object();
	
	// 主题分类列表
	obj.gridThemeType = $("#gridThemeType").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.RMES.ThemeTypeSrv";
				d.QueryName = "QryThemeType";
				d.Arg1 = $.form.GetValue("cboVerSearch");
				d.ArgCnt = 1;
			}
		},
		"columns": [
			{"data": "ID"},
			{"data": "Code"},
			{"data": "Desc"},
			{"data": "VerDesc"},
			{"data": "IsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "ActDate",
				"render": function (data, type, row) {
					return data + ' ' + row["ActTime"];
				}
			},
			{ "data": "ActUser"}
		],
		drawCallback: function (settings) {
			$("#btnAdd").removeClass('disabled');
        	$("#btnEdit").addClass('disabled');
        	$("#btnDelete").addClass('disabled');
		}
	});
	//$(".check-KeyWord").html('<select id="cboKeyTpye" data-set="DHCHAI.BTS.DictionarySrv:QryDic" data-param="s#InfSuPosKeyTpye" data-col="ID^DicDesc"></select>');
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitThemeTypeWinEvent(obj);
	return obj;
}