//页面Gui
function InitOEANTListWin(){
	var obj = new Object();
	
	//抗菌用药医嘱列表
	obj.gridOEItemList = $("#gridOEItemList").DataTable({
		dom: 'rt<"row"<"col-sm-7 col-xs-7"pl><"col-sm-5 col-xs-5"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		"scrollX": true,
		"scrollY":"480px",
		scrollCollapse: "true",
    	//autoWidth:false,
		order: [[ 4, "desc" ]],
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.INFOPSSrv";
				d.QueryName = "QryOperAnaesByAdm";
				d.Arg1 = PaadmID;
				d.ArgCnt = 1;
			}
		},
		// xID,OpertorName,AnesthDesc,ASADesc,CuteTypeDesc,HealDesc,NNISDesc "4%"
		columns: [
			{"data": null,"targets": 0,orderable: false, width: "28px"},
			{"data": "OperName"},
			{"data": "OperType"},
			{"data": "OperLocDesc"},
			{"data": "OperStartDate"},
			{"data": "OperEndDate"},
			{"data": "OperStatus"},
			{"data": "OpertorName"},
			{"data": "AnesthDesc"},
			{"data": "ASADesc"},
			{"data": "CuteTypeDesc"},
			{"data": "HealDesc"},
			{"data": "NNISDesc"}
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
	
	InitOEANTListWinEvent(obj);
	return obj;
}
