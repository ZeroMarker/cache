//页面Gui
var flg=""
function InitLabBactMapWin(){
	var obj = new Object();
   
	//细菌字典对照维护	
	obj.gridLabBactMap = $("#gridLabBactMap").DataTable({
		dom: 'rt<"row"<"col-sm-7 col-xs-7 col-xs-7"pl><"col-sm-5 col-xs-5"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		deferRender: true,  //数据量较多时只加载第一页
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.LabBactSrv";
				d.QueryName = "QryLabBactMap";
				d.Arg1 =  flg;
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "Bacteria",
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
	
	obj.gridLabBacteria = $("#gridLabBacteria").DataTable({
		dom: 'rtpl',
		select: 'single',
		paging: true,
		ordering: true,
		deferRender: true,  //数据量较多时只加载第一页
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.LabBactSrv";
				d.QueryName = "QryLabBacteria";
				d.ArgCnt = 0;
			}
		},
		columns: [	
			/*{"data": "BacCode",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},*/	
			{"data": "WCode",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "BacDesc",
			    render: function(data, type, row, meta) {
					return '<span title="' + data + "(" + row["BacName"] +')">'+ data + "(" + row["BacName"] +')</span>';
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

	InitLabBactMapWinEvent(obj);
	return obj;
}