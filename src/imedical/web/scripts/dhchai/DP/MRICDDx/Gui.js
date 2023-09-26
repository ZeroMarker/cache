//页面Gui
var flg="";
function InitDictionaryWin(){
	var obj = new Object();
	//列表 2 
	obj.gridMRICDDxMap = $("#gridMRICDDxMap").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		ordering: true,
		deferRender: true,  //数据量较多时只加载第一页
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.MRICDDxMapSrv";
				d.QueryName = "QryMRICDDxMap";
				d.Arg1 = flg;
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "BTDiagDesc",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "MapItemDesc",
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
	
	//列表
	obj.gridMRICDDx = $("#gridMRICDDx").DataTable({
		dom: 'rtpl',
		select: 'single',
		paging: true,
		ordering: true,
		deferRender: true,  //数据量较多时只加载第一页
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.MRICDDxSrv";
				d.QueryName = "QryMRICDDx";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "BTCode",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "BTDesc",
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
	
	InitDictionaryWinEvent(obj);
	return obj;
}