//页面Gui
function InitOccExpTypeResWin(){
	var obj = new Object();
	
	//职业暴露筛查规则
	obj.gridOccExpTypeEpd = $("#gridOccExpTypeEpd").DataTable({
		dom: 'rt<"row"<"col-sm-5"pl><"col-sm-5"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		deferRender: true,  //数据量较多时只加载第一页
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.OccExpTypeSrv";
				d.QueryName = "QryOccExpTypeEpd";
				d.Arg1= Parref;
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "EpdTypeDesc"},
			{"data": "BTDesc"},
			{"data": "LabEpdDesc",
			    render: function(data, type, row, meta) {
					return '<span title="'+ data +'">'+ data +'</span>';
		  	 	}
			},
			{"data": "IsActive",
				"render": function (data, type, row, meta) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "ActDate",
				"render": function (data, type, row, meta) {
					return row["ActDate"] + ' ' + row["ActTime"];
				}
			},
			{"data": "ActUser"},
			{"data": "Note"}
		],
		drawCallback: function (settings) {
			$("#btnAdd").removeClass('disabled');
			$("#btnEdit").addClass('disabled');
        	$("#btnDelete").addClass('disabled');
		}
	});
	
	InitOccExpTypeResWinEvent(obj);
	return obj;
}