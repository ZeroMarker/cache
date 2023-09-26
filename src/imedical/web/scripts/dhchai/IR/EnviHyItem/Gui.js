//页面Gui
function InitEnviHyItemWin(){
	var obj = new Object();
	
	//监测项目列表
	obj.gridEvItem = $("#gridEvItem").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.EnviHyItemSrv";
				d.QueryName = "QryEvItem";
				d.ArgCnt =0;
			}
		},
		columns: [
			{ "data": "ID"},
			{ "data": "ItemTypeDesc"},
			{ "data": "ItemDesc"},
			{ "data": "SpecimenTypeDesc" },
			{ "data": "Norm" },
			{ "data": "NormMax" },
			{ "data": "NormMin" },
			{ "data": "SpecimenNum" },
			{ "data": "CenterNum" },
			{ "data": "SurroundNum" },
			{ "data": "ForMula", 
				"render": function (data, type, row) {
					if (data==""){
						return data;
					}else{
						return '<div title="计算公式'+data+':N代表录结果界面录入的细菌数，数字代表对应的稀释倍数；通过计算公式：'+data+' 得到稀释后的细菌数，再去计算是否合格。">'+data+'</div>';
					}
				}
			},
			{ "data": "Freq" },
			{ "data": "Uom" },
			{ "data": "EnvironmentCateDesc"},
			{ "data": "IsActDesc" }
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
	
	InitEnviHyItemWinEvent(obj);
	return obj;
}