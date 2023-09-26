//页面Gui
function InitCRuleDefWin(){
	var obj = new Object();
	
	//感染诊断标准
	obj.gridCRuleDef = $("#gridCRuleDef").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CCRuleDefSrv";
				d.QueryName = "QryCRuleDef";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "InfPosCode",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "InfPosDesc",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "Title",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "Note",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "IndNo",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "IsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "MaxAge"},
			{"data": "MinAge"}	
		],
		drawCallback: function (settings) {
			$("#btnAdd_one").removeClass('disabled');
        	$("#btnEdit_one").addClass('disabled');
        	$("#btnDelete_one").addClass('disabled');
		}
	});
	
	
	//感染诊断定义
	obj.gridCRuleDefExt = $("#gridCRuleDefExt").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CCRuleDefSrv";
				d.QueryName = "QryCRuleDefExt";
				var rd = obj.gridCRuleDef.rows({selected: true}).data().toArray()[0];
				d.Arg1 = (rd ? rd["ID"] : '');
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "Title",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "Note",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "TypeDesc",
			    render: function(data, type, row, meta) { 
					return '<span title="'+data +'">'+data +'</span>';
		  	 	} 
			},
			{"data": "IndNo",
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
			var rd = $('#gridCRuleDef').val(); 
			if (rd) {
				$("#btnAdd_two").removeClass('disabled');
			}
		   	$("#btnEdit_two").addClass('disabled');
        	$("#btnDelete_two").addClass('disabled');

		}
	});

	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	InitCRuleDefWinEvent(obj);
	return obj;
}