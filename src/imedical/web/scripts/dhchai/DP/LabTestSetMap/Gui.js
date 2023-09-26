//页面Gui
var flg="";
function InitLabTestSetMapWin(){
	var obj = new Object();

	//常规检验-检验项目维护
	obj.gridLabTestSetMap = $("#gridLabTestSetMap").DataTable({
		dom: 'rt<"row"<"col-sm-7"pl><"col-sm-5"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		deferRender: true,  //数据量较多时只加载第一页
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.LabTestSetSrv";
				d.QueryName = "QryLabTestSetMap";
				d.Arg1=flg;	
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "TestSet",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "OrdDesc",
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
			$("#btnAdd_two").addClass('disabled');
			$("#btnEdit_two").addClass('disabled');
        	$("#btnDelete_two").addClass('disabled');
		}
	});
	
	obj.gridLabTestSet = $("#gridLabTestSet").DataTable({
		dom: 'rtpl',
		select: 'single',
		paging: true,
		ordering: true,
		deferRender: true,  //数据量较多时只加载第一页
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.LabTestSetSrv";
				d.QueryName = "QryLabTestSet";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "TSCode"},
			{"data": "TestSet"}
		]
	});

	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitLabTestSetMapWinEvent(obj);
	return obj;
}