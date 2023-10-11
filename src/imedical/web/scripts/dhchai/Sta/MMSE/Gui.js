//页面Gui
function InitNavigationWin(){
	var obj = new Object();
	obj.reportName="";
	//监控项目列表
	obj.gridNavigation = $("#gridNavigation").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.STAS.NavigationSrv";
				d.QueryName = "QryMMSE";
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
			{"data": "StatDesc",
				"render": function ( data, type, row ) {
					return '<a href="#" class="btnSta"'+'title="'+data +'">'+data+'</a>';
				}
			},
			{"data": "Method",
				"render": function ( data, type, row ) {
					return '<span title="'+data +'">'+data+'</span>';
				}
			}
			
		],
		drawCallback: function (settings) {
			$("#btnAdd").removeClass('disabled');
        	$("#btnEdit").addClass('disabled');
        	$("#btnDelete").addClass('disabled');
		}		
	});
	$('body').mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia : 100
	});
	InitNavigationWinEvent(obj);
	return obj;
}