//页面Gui
var flg=""
function InitOEAntiMastMapWin(){
	var obj = new Object();
	//列表
	obj.gridOEAntiMastMap = $("#gridOEAntiMastMap").DataTable({
		dom: 'rt<"row"<"col-sm-7"pl><"col-sm-5"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.OEAntiMastMapSrv";
				d.QueryName = "QryOEAntiMastMap";
				d.Arg1 = flg;
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "BTAnitDesc",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "BTMapItemDesc",
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
			$("#btnAdd").addClass('disabled');
        	$("#btnEdit").addClass('disabled');
        	$("#btnDelete").addClass('disabled');
		},
		 initComplete: function(settings) { 
			$('#gridOEAntiMastMap').colResizable({liveDrag:true});
		}
	});
	
	//抗菌药物医嘱字典
	obj.gridOEAntiMast = $("#gridOEAntiMast").DataTable({
		dom: 'rtpl',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.OEAntiMastSrv";
				d.QueryName = "QryOEAntiMast";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "BTCode",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "BTName",
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
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitOEAntiMastMapWinEvent(obj);
	return obj;
}