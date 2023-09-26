//页面Gui
function InitLocationWin(){
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
				d.ClassName = "DHCHAI.BTS.LocationSrv";
				d.QueryName = "QryLoc";
				d.Arg1 = $.form.GetValue('cboHospital');
				d.ArgCnt = 1;
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
			{"data": "GroupDesc",
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
			{"data": "IsActive"},
			{"data": "IndNo"}
			
		],
		drawCallback: function (settings) {
			$("#btnsyn").removeClass('disabled');
        	$("#btnEdit").addClass('disabled');
        	$("#btnVirtual").addClass('disabled');
		},
		initComplete: function(settings) { 
			$('#gridLocation').colResizable({liveDrag:true});
		}
	});

	//关联科室列表
	obj.gridLocLink = $("#gridLocLink").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		paging: true,
		ordering: false,
		info: true,
		select: 'single',
		"processing" : true,
		"ajax": {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.LocationSrv";
				d.QueryName = "QryLocLink";
				d.Arg1 = (typeof(obj.LinkID)=='undefined'?'':obj.LinkID);
				d.ArgCnt = 1;
			}
		},
		"columns": [
			{"data": "LinkLocDesc",
				"render": function (data, type, row) {
					return '<span title="'+data+' (' + row["LinkLocDesc"] + ' )' +'">'+data + ' (' + row["LinkLocDesc2"] + ' )'+'</span>';
				}
			}
		],
		drawCallback: function (settings) {
			$("#btnAddLink").removeClass('disabled');
        	$("#btnEditLink").addClass('disabled');
        	$("#btnDeleteLink").addClass('disabled');
		}
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});

	$("#layer_LocLink").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
    });
	    
	InitLocationWinEvent(obj);
	return obj;
}
