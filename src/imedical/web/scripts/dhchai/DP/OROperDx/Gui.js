//页面Gui
var flg ="";
function InitOROperDxWin(){
	var obj = new Object();
	//列表
	
	//列表 2 手术字典对照
	obj.gridOROperDxMap = $("#gridOROperDxMap").DataTable({
		dom: 'rt<"row"<"col-sm-7"pl><"col-sm-5"i>>',
		select: 'single',
		ordering: true,
		deferRender: true,  //数据量较多时只加载第一页
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.OROperDxMapSrv";
				d.QueryName = "QryOROperDxMap";
				d.Arg1 = flg;
				d.ArgCnt = 1;
			}
		},
		columns: [
		    {"data": "ID"},
			{"data": "BTOperDesc",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "BTMapOperDesc",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "BTMapNote",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "HospGroup",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "BTIsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}
		
		],
		drawCallback: function (settings) {		
			$("#btnAdd_two").addClass('disabled');
        	$("#btnEdit_two").addClass('disabled');
        	$("#btnDelete_two").addClass('disabled');
		}
	});
	
	obj.gridOROperDx = $("#gridOROperDx").DataTable({
		dom: 'rtpl',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		deferRender: true,  //数据量较多时只加载第一页
		ajax: { 
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.OROperDxSrv";
				d.QueryName = "QryOROperDx";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "BTOperCode",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "BTOperDesc",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "BTOperIncDesc",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "BTIsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}
			
		]
		,drawCallback: function (settings) {
			$("#btnAdd_one").removeClass('disabled');
        	$("#btnEdit_one").addClass('disabled');
        	$("#btnDelete_one").addClass('disabled');
		}
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});

	InitOROperDxWinEvent(obj);
	return obj;
}