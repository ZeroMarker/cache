//页面Gui
function InitInfPosWin(){
	var obj = new Object();
	obj.checkAll = "";
	//感染诊断（部位）列表
	obj.gridInfPos = $("#gridInfPos").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.InfPosSrv";
				d.QueryName = "QryInfPos";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "Code"},
			{"data": "Desc",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": null, 
				render: function ( data, type, row ) {
					if (row['DiagFlag'] != '1') {
						return '';
					} else {
						return '<a href="#" class="btnInfPosGist">诊断依据</a>';
					}
				}
			},
			{"data": "DiagFlag", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "GCode"},
			{"data": "IsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}	
		],
		drawCallback: function (settings) {
			$("#btnAdd").removeClass('disabled');
        	$("#btnEdit").addClass('disabled');
        	$("#btnDelete").addClass('disabled');
		}
	});
	//感染诊断分类列表
	obj.gridInfSub = $("#gridInfSub").DataTable({
		dom: '<"check-All">rti',
		select: 'single',
		paging: false,
		"aoColumnDefs": [ 
			{
				"bSortable": false, 
				"aTargets": [ 0 ] 
			}
		],
	    "aaSorting": [
			[
				1, "asc"
			]
		],        //去除选择那一栏的排序标志
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.InfSubSrv";
				d.QueryName = "QryInfSubByPosID";
				var InfPosID = "";
				var Flag = 0;
				if (obj.layer_rd){
					InfPosID = obj.layer_rd["ID"];
				    Flag = obj.layer_rd["DiagFlag"];
				}
				d.Arg1 =(Flag==1 ? InfPosID : '');
				d.Arg2 =(Flag==1 ? obj.checkAll : '');;
				d.ArgCnt = 2;
			}
		},
		columns: [
			{"data": "IsChecked",width:"50px",
		        "render": function (data, type, row) {
					if(data==1){
						return '<div class="icheckbox_square-blue checked" style="margin-top:4px"><input type="checkbox" style="opacity: 0;" checked></div>';
					
					}else{
						return '<div class="icheckbox_square-blue" style="margin-top:4px"><input type="checkbox" style="opacity: 0;"></div>';
					}
				}
	         },
			{"data": "ID","visible": false},
			{"data": "Desc",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			}	
		]
	});
	$(".check-All").html("<input type='checkbox' class='icheckbox_flat-blue' id='checkAll' />显示全部");
	
	obj.gridInfPosGist = $("#gridInfPosGist").DataTable({
		dom: 'rt<"row"<"col-sm-6"p><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.BTS.InfPosGistSrv";
				d.QueryName = "QryGistByInfPos";
				var Flag = 0;
				if (obj.layer_rd){
					InfPosID = obj.layer_rd["ID"];
				    Flag = obj.layer_rd["DiagFlag"];
				}
				d.Arg1 =(Flag==1 ? InfPosID : '');
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "TypeDesc"},
			{"data": "Code"},
			{"data": "Desc",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			}
		],
		drawCallback: function (settings) {
			$("#btnGistAdd").removeClass('disabled');
        	$("#btnGistEdit").addClass('disabled');
        	$("#btnGistDelete").addClass('disabled');
		}
	});
	
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitInfPosWinEvent(obj);
	return obj;
}