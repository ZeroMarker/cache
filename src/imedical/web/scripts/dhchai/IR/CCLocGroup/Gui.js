//页面Gui
function InitCCLocGroupWin(){
	var obj = new Object();
	
	//科室列表
	obj.gridLocation = $("#gridLocation").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		deferRender: true,
		"ajax": {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CCLocGroupSrv";
				d.QueryName = "QryLoc";
				d.Arg1 = $.form.GetValue('cboHospital');
				d.Arg2 = $.form.GetValue('cboLocGrpType');
				d.ArgCnt = 2;
			}
		},
		"columns": [
			{"data": "ID"},
			{"data": "LocCode",
				"render": function ( data, type, row ) {
					return '<span title="'+data +'">'+data+'</span>';
				}
			},
			{"data": "LocDesc",
				"render": function (data, type, row) {
					return '<span title="'+data+' (' + row["LocDesc2"] + ' )' +'">'+data + ' (' + row["LocDesc2"] + ' )'+'</span>';
				}
				
		    },
			{"data": "LocTypeDesc",
				"render": function ( data, type, row ) {
					return '<span title="'+data +'">'+data+'</span>';
				}
			},
			{"data": "LocCateDesc",
				"render": function ( data, type, row ) {
					return '<span title="'+data +'">'+data+'</span>';
				}
			},
			{"data": "LocUser",
				"render": function ( data, type, row ) {
					return '<span title="'+data +'">'+data+'</span>';
				}
			},
			{"data": "HospDesc",
				"render": function ( data, type, row ) {
					return '<span title="'+data +'">'+data+'</span>';
				}
			},
			{"data": "IsOPER"},
			{"data": "IsICU"},
			{"data": "IsNICU"},
			{"data": "ICUTpDesc"},
			{"data": "IsActive"}
			
		],
		drawCallback: function (settings) {
        	$("#btnEdit").addClass('disabled');
		}
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitCCLocGroupWinEvent(obj);
	return obj;
}
