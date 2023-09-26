//页面Gui
var flg = ""
var LabAnti=""
function InitLabAntiMapWin(){
	var obj = new Object();
	//抗生素字典对照维护
	obj.gridLabAntiMap = $("#gridLabAntiMap").DataTable({
		dom: 'rt<"row"<"col-sm-7"pl><"col-sm-5"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		deferRender: true,  //数据量较多时只加载第一页
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.LabAntiSrv";
				d.QueryName = "QryLabAntiMap";
				d.Arg1 = flg;
				d.Arg2 = LabAnti;
				d.ArgCnt = 2;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "AntiDesc",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "MapItemDesc",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "MapNote",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "HospGroup",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "IsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}
		],
		drawCallback: function (settings) {
			$("#btnAdd").addClass('disabled');
        	$("#btnEdit").addClass('disabled');
        	$("#btnDelete").addClass('disabled');
		}
	});
	obj.gridLabAntibiotic = $("#gridLabAntibiotic").DataTable({
		dom: 'rtpl',
		select: 'single',
		paging: true,
		ordering: true,
		deferRender: true,  //数据量较多时只加载第一页
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.LabAntiSrv";
				d.QueryName = "QryLabAntibiotic";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "AntCode",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
		    {"data": "WCode",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "AntDesc",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "IsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}
		]
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});

	InitLabAntiMapWinEvent(obj);
	return obj;
}