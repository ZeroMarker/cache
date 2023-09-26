//页面Gui
function InitAdmHistoryWin(){
	var obj = new Object();
	//就诊列表
	obj.gridAdmHistory = $("#gridAdmHistory").DataTable({
		dom: 'rt<"row"<"col-sm-7 col-xs-7"pl><"col-sm-5 col-xs-5"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		"scrollX": true,
		"scrollY": true,//"245px",
		//scrollCollapse: "true",
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.PAAdmSrv";
				d.QueryName = "QryPatAdm";
				d.Arg1 = "";
				d.Arg2 = PaadmID;
				d.ArgCnt = 2;
			}
		},
		columns: [
			{"data": "PapmiNo"},
			{"data": "PatName"},
			{"data": "Sex"},
			{"data": "Age"},
			{"data": "IdentityCode"},
			{"data": "AdmDate"},
			{"data": "AdmTime"},
			{"data": "AdmLocDesc"},
			{"data": "AdmWardDesc"},
			{"data": "DischDiag"},
			{"data": "DischDate"},
			{"data": "DischTime"},
			{"data": "DischLocDesc"},
			{"data": "DischWardDesc"}
		]
		,"fnDrawCallback": function (oSettings) {
			$("#gridAdmHistory_wrapper .dataTables_scrollBody").mCustomScrollbar({
				theme : "dark-thick",
				axis: "y",
				callbacks:{
					whileScrolling:function(){
						$('#gridAdmHistory_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
					}
				}
			});	
			$("#gridAdmHistory_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridAdmHistory tr td:first"));
        	getContentSize();
        }
	});
   	function getContentSize() {
    	var wh = document.documentElement.clientHeight; 
   		var scrollBodyH =  wh - 270;
	   	$('div.dataTables_scrollBody').css('height', scrollBodyH + "px");
	}
	InitAdmHistoryWinEvent(obj);
	return obj;
}
