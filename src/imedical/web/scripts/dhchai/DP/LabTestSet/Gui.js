//页面Gui
function InitLabTestSetWin(){
	var obj = new Object();
	
	//检验医嘱分类
	obj.gridLabSetCat = $("#gridLabSetCat").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.LabTestSetSrv";
				d.QueryName = "QryLabSetCat";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "BTCode"},
			{"data": "BTDesc"}
		],
		drawCallback: function (settings) {
			$("#btnAdd_one").removeClass('disabled');
        	$("#btnEdit_one").addClass('disabled');
        	$("#btnDelete_one").addClass('disabled');
		}
	});
	
	 $('#gridLabSetCat').on('click','tr', function(e) {
		var rd = obj.gridLabSetCat.row(this).data();
		$('#gridLabSetCat').val(rd["ID"]);
		obj.gridLabTestSet.ajax.reload();   
	}); 
	
	//常规检验项目
	obj.gridLabTestSet = $("#gridLabTestSet").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.LabTestSetSrv";
				d.QueryName = "QryLabSetByCat";
				d.Arg1=$('#gridLabSetCat').val();	
				d.Arg2="";
				d.ArgCnt = 2;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "TSCode",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "TestSet",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "CatDesc",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "IsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "Note",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			}		
		],
		drawCallback: function (settings) {
			$("#btnEdit_two").addClass('disabled');
        	$("#btnDelete_two").addClass('disabled');
		}
	});
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	InitLabTestSetWinEvent(obj);
	return obj;
}