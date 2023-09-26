//页面Gui
var flg="";
function InitRBItmMastWin(){
	var obj = new Object();
	
	//列表 2 
	obj.gridRBItmMastMap = $("#gridRBItmMastMap").DataTable({
		dom: 'rt<"row"<"col-sm-7"pl><"col-sm-5"i>>',
		select: 'single',
		ordering: true,
		deferRender: true,  //数据量较多时只加载第一页
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.RBItmMastMapSrv";
				d.QueryName = "QryRBItmMastMap";
				d.Arg1 = flg;
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "BTMRCHKItem",
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
	obj.gridRBItmMast = $("#gridRBItmMast").DataTable({
		dom: 'rtpl',
		select: 'single',
		paging: true,
		ordering: true,
		deferRender: true,  //数据量较多时只加载第一页
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.RBItmMastSrv";
				d.QueryName = "QryRBItmMast";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "BTCode",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "BTCName",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "BTIsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}
		],drawCallback: function (settings) {
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

	InitRBItmMastWinEvent(obj);
	return obj;
}