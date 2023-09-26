//页面Gui
function InitInfSuPosWin(){
	var obj = new Object();
	
	//疑似诊断列表
	obj.gridInfSuPos = $("#gridInfSuPos").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.InfSuPosSrv";
				d.QueryName = "QryInfSuPos";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{ "data": "ID"},
			{ "data": "Diagnos" ,
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{ "data": "InfPosID" ,"visible": false},
			{ "data": "InfPosCode" ,"visible": false},
			{ "data": "InfPosDesc" ,
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{ "data": "ActDate" },
			{ "data": "ActTime" },
			{ "data": "ActUserCode" ,"visible": false},
			{ "data": "ActUserDesc" }
		],
		drawCallback: function (settings) {
			$("#btnAdd").removeClass('disabled');
        	$("#btnEdit").addClass('disabled');
        	$("#btnDelete").addClass('disabled');
		}
	});
	
	//疑似诊断-关键词列表
	obj.gridSuPosKeys = $("#gridSuPosKeys").DataTable({
		dom: 'rt',
		select: 'single',
		paging: false,
		ordering: false,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CRuleInfSuSrv";
				d.QueryName = "QrySuPosKeysByID";
				var rd = obj.gridInfSuPos.rows({selected: true}).data().toArray()[0];
				d.Arg1 = (rd ? rd["ID"] : '');
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "KeyWord",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "TypeDesc", 
				"render": function (data, type, row) {
					return '<span title="'+data +'">'+data +'</span>';
				}
			},
			{"data": "Property"}
		]
		,drawCallback: function (settings) {
			var rd = obj.gridInfSuPos.rows({selected: true}).data().toArray()[0];
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
	
	InitInfSuPosWinEvent(obj);
	return obj;
}