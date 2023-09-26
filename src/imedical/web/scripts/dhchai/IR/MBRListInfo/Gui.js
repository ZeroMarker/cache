//页面Gui
function InitMBRListInfoWin(){
	var obj = new Object();
	obj.sResultID="";
	//多耐信息列表
	obj.gridMBRInfo = $("#gridMBRInfo").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		"bAutoWidth": false,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CtlMRBSrv";
				d.QueryName = "QryMRBByEpsodeDr";
				d.Arg1=EpisodeDr;
				d.ArgCnt =1;
			}
		},
		columns: [
			{ "data": "MrNo"},
			{ "data": "PapmiNo" },
			{ "data": "PatName" },
			{ "data": "Sex" },
			{ "data": "Age" },
			{ "data": "MRBDesc" },
			{ "data": "SpeDesc" },
			{ "data": "BacDesc" },
			{ "data": "ActDate" },
			{ "data": "RepDate" },
			{ "data": "MRBActFlag" },
			{ "data": "IsolateInfo" }
		],
		drawCallback: function (settings) {
		}
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitMBRListInfoWinEvent(obj);
	return obj;
}