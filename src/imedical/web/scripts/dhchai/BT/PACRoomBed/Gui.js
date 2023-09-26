//页面Gui
function InitPACRoomBedWin(){
	var obj = new Object();
	obj.RoomType="";
	// 病区列表
	obj.gridPACWard = $("#gridPACWard").DataTable({
		dom: 'rt<"row"<"col-sm-12"pl><"col-sm-12">>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.PACWardSrv";
				d.QueryName = "QryPACWard";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "LocDesc"},
			{"data": "IsMainWard", 
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
	
	//房间列表
	obj.gridRoom = $("#gridRoom").DataTable({
		dom: 'rt<"row"<"col-sm-12"pl><"col-sm-12">>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.PACRoomBedSrv";
				d.QueryName = "QryPACRoomSrv";
				var rd = obj.gridPACWard.rows({selected: true}).data().toArray()[0];
				d.Arg1 = (rd ? rd["ID"] : '');
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "RoomDesc"},
			{"data": "SubNo"},
			{"data": "LeftBedCnt"},
			{"data": "RightBedCnt"},
			{"data": "ContBedCnt"}
		]
		,drawCallback: function (settings) {
			var rd = obj.gridPACWard.rows({selected: true}).data().toArray()[0];
			if (rd) {
				$("#btnAdd_two").removeClass('disabled');
			}
        	$("#btnEdit_two").addClass('disabled');
        	$("#btnDelete_two").addClass('disabled');
        	$("#btnLocOper_two").addClass('disabled');
		}
	});
	
	//床位列表
	obj.gridBed = $("#gridBed").DataTable({
		dom: 'rt<"row"<"col-sm-12"pl><"col-sm-12">>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.PACRoomBedSrv";
				d.QueryName = "QryPACBedSrv";
				var rd = obj.gridPACWard.rows({selected: true}).data().toArray()[0];
				d.Arg1 = (rd ? rd["ID"] : '');
				var rd = obj.gridRoom.rows({selected: true}).data().toArray()[0];
				d.Arg2 = (rd ? rd["ID"] : '');
				d.ArgCnt = 2;
			}
		},
		order: [[ 3, "desc" ]],
		columns: [
			{"data": "ID"},
			{"data": "BedDesc",
				"render": function (data, type, row) {
					return (row.IsRoomBed == '1' ? '【+】' : '') + data;
				}
			},
			{"data": "IndNo"},
			{"data": "",
				"render": function (data, type, row) {
					if (obj.RoomType=="病房") {
						if(row.IsRoomFlag == '1') {
							return '<a href="#" class="editor_canceledit"><img src="../scripts/dhchai/img/取消关联.png">取消关联</a>';
						}else if(row.IsRoomBed == '0') {
							return '<a href="#" class="editor_edit"><img src="../scripts/dhchai/img/关联.png">关联</a>';
						}else{
							return '';
						}
					}else {
						return '';
					}
				}
			},
			{"data": "IsActive",
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}
		]
		,drawCallback: function (settings) {
			var rd = obj.gridRoom.rows({selected: true}).data().toArray()[0];
			if (rd) {
				$("#btnAdd_three").removeClass('disabled');
			}
        	$("#btnEdit_three").addClass('disabled');
        	$("#btnDelete_three").addClass('disabled');
		}
	});
	
	$("#divLeft").mCustomScrollbar({
		//scrollButtons: { enable: true },
		//autoHideScrollbar: true,
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("#divCenter").mCustomScrollbar({
		//scrollButtons: { enable: true },
		//autoHideScrollbar: true,
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("#divRight").mCustomScrollbar({
		//scrollButtons: { enable: true },
		//autoHideScrollbar: true,
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitPACRoomBedWinEvent(obj);
	return obj;
}