//页面Gui
function InitScreenResultWin(){
	var obj = new Object();
	
	//疑似筛查触发条件
	obj.gridScreenResult = $("#gridScreenResult").DataTable({
		dom: 'rt<"row"<"col-sm-7 col-xs-7"pl><"col-sm-5 col-xs-5"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		"scrollX": true,
		"scrollY":"350px",
		scrollCollapse: "true",
    	autoWidth:false,
		order: [[ 1, "desc" ]],
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CCScreeningSrv";
				d.QueryName = "QryScreenResult";
				d.Arg1 = PaadmID;
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": null,"targets": 0,orderable: false, width: "4%"},
			{"data": "ResultNote"},
			{"data": "ResultCnt"},
			{"data": "ResultDate"},
			{"data": "ResultDays"},
			{"data": "FeverDays"},
			{"data": "TestAbTimes"},
			{"data": "ItmScreenID","visible" : false}
		]
		,"fnDrawCallback": function (oSettings) {
			var api = this.api();
			var startIndex= api.context[0]._iDisplayStart;//获取到本页开始的条数
			api.column(0).nodes().each(function(cell, i) {
				cell.innerHTML = startIndex + i + 1;
			});
			
			$("#gridScreenResult_wrapper .dataTables_scrollBody").mCustomScrollbar({
				theme : "dark-thick",
				axis: "y",
				callbacks:{
					whileScrolling:function(){
						$('#gridScreenResult_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
					}
				}
			});			
			$("#gridScreenResult_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridScreenResult tr td:first"));
        }
	});
	
	//疑似感染症状或体征
	obj.gridInfSymptom = $("#gridInfSymptom").DataTable({
		dom: 'rt<"row"<"col-sm-7 col-xs-7"pl><"col-sm-5 col-xs-5"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		"scrollX": true,
		"scrollY":"350px",
		scrollCollapse: "true",
    	autoWidth:false,
		order: [[ 1, "desc" ]],
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CCScreeningSrv";
				d.QueryName = "QryINFSymptom";
				d.Arg1 = PaadmID;
				d.Arg2 = 1;
				d.ArgCnt = 2;
			}
		},
		columns: [
			{"data": null,"targets": 0,orderable: false, width: "4%"},
			{"data": "ActDate"},
			{"data": "FeResult"},
			{"data": "SxResult"},
			{"data": "OpResult"},
			{"data": "ActDate","visible" : false}
		]
		,"fnDrawCallback": function (oSettings) {
			var api = this.api();
			var startIndex= api.context[0]._iDisplayStart;//获取到本页开始的条数
			api.column(0).nodes().each(function(cell, i) {
				cell.innerHTML = startIndex + i + 1;
			});
			
			$("#gridInfSymptom_wrapper .dataTables_scrollBody").mCustomScrollbar({
				theme : "dark-thick",
				axis: "y",
				callbacks:{
					whileScrolling:function(){
						$('#gridInfSymptom_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
					}
				}
			});			
			$("#gridInfSymptom_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridInfSymptom tr td:first"));
        }
	});
	
	InitScreenResultWinEvent(obj);
	return obj;
}
