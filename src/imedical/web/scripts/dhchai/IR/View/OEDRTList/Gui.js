//页面Gui
function InitOEDRTListWin(){
	var obj = new Object();
	
	//器械相关治疗医嘱列表
	obj.gridOEItemList = $("#gridOEItemList").DataTable({
		dom: 'rt<"row"<"col-sm-7 col-xs-7"pl><"col-sm-5 col-xs-5"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		"scrollX": true,
		"scrollY":"350px",
		scrollCollapse: "true",
    	autoWidth:false,
		order: [[ 4, "desc" ]],
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.OEOrdItemSrv";
				d.QueryName = "QryOEOrdItemByDRT";
				d.Arg1 = PaadmID;
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": null,"targets": 0,orderable: false, width: "4%"},
			{"data": "OrdDesc"},
			{"data": "Priority"},
			{"data": "OrdDate",
				"render": function (data, type, row) {
					return row["OrdDate"] + ' ' + row["OrdTime"];
				}
		    },
			{"data": "OrdLoc"},
			{"data": "OrdDoc"},
			{"data": "SttDate",
				"render": function (data, type, row) {
					return row["SttDate"] + ' ' + row["SttTime"];
				}
		    },
			{"data": "EndDate",
				"render": function (data, type, row) {
					return row["EndDate"] + ' ' + row["EndTime"];
				}
		    },
			{"data": "OrdID","visible" : false}
		]
		,"fnDrawCallback": function (oSettings) {
			var api = this.api();
			var startIndex= api.context[0]._iDisplayStart;//获取到本页开始的条数
			api.column(0).nodes().each(function(cell, i) {
				cell.innerHTML = startIndex + i + 1;
			});
			
			$("#gridOEItemList_wrapper .dataTables_scrollBody").mCustomScrollbar({
				theme : "dark-thick",
				axis: "y",
				callbacks:{
					whileScrolling:function(){
						$('#gridOEItemList_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
					}
				}
			});			
			$("#gridOEItemList_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridOEItemList tr td:first"));
        }
	});
	
	InitOEDRTListWinEvent(obj);
	return obj;
}
