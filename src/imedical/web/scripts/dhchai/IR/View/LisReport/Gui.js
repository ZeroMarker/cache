//页面Gui
function InitLisReportWin(){
	var obj = new Object();
	obj.ReportID = "";
	obj.LabOeordDesc = "";  // 检验医嘱名称
	obj.AbFlagBack = new Array(); //异常标示颜色
	obj.AbFlagBack["H"]="#EEEE00"; //高
	obj.AbFlagBack["L"]="#EEEE00"; //低
	obj.AbFlagBack["PH"]="#FF3333"; //高危急值
	obj.AbFlagBack["PL"]="#FF3333"; //低危急值
	
	//送检标本列表
	obj.gridLabVisitNumber = $("#gridLabVisitNumber").DataTable({
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
				d.ClassName = "DHCHAI.DPS.LabVisitRepSrv";
				d.QueryName = "QryLabVisitNumber";
				d.Arg1 = PaadmID;
				d.Arg2 = '';
				d.Arg3 = '';
				d.Arg4 = $.form.GetValue('cboTestSet');
				d.ArgCnt = 4;
			}
		},
		columns: [
			{"data": "EpisodeNo"},
			{"data": "OrdTSDesc",
				"render": function (data, type, row) {
					return '<span title="'+data+' (' + row["Specimen"] + ' )' +'">'+data + ' (' + row["Specimen"] + ' )'+'</span>';
				}
		    },
			{"data": "LocDesc"},
			{"data": "CollDate"},
			{"data": "AuthDate"},
			{"data": "VisitReportID","visible" : false}
		]
		,"fnDrawCallback": function (oSettings) {
			$("#gridLabVisitNumber_wrapper .dataTables_scrollBody").mCustomScrollbar({
				theme : "dark-thick",
				axis: "y",
				callbacks:{
					whileScrolling:function(){
						$('#gridLabVisitNumber_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
					}
				}
			});			
			$("#gridLabVisitNumber_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridLabVisitNumber tr td:first"));
        }
	});

	obj.gridLabVisitRepResult = $("#gridLabVisitRepResult").DataTable({
		dom: 'rtl',
		select: 'single',
		processing: true,
		paging: false,
		ordering: false,
		info: true,
		scrollX: true,
		scrollY: "385px",
    	scrollCollapse: "true",
    	autoWidth:false,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.DPS.LabVisitRepSrv";
				d.QueryName = "QryVisitRepResult";
				d.Arg1= obj.ReportID;
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "TestDesc"},
			{"data": "Result",
				"render": function (data, type, row) {
					var val = data + ' ' + row["Unit"] + (row["MDRResult"] == '1' ? '（多耐菌）' : '')
					return '<span title="'+ val +'">' + val + '</span>';
				}
		    },
			{"data": null,
				"render": function (data, type, row) {
					if (typeof obj.AbFlagBack[data.AbFlag] != "undefined"){
						return '<div style="background:'+obj.AbFlagBack[data.AbFlag]+';width:100%;">'+data.AbFlag+'</div>';
					} else {
						return data.AbFlag;
					}
				}
			},
			{"data": "RefRanges"}
		]
		,"fnDrawCallback": function (oSettings) {
			$("#gridLabVisitRepResult_wrapper .dataTables_scrollBody").mCustomScrollbar({
				theme : "dark-thick",
				axis: "y",
				callbacks:{
					whileScrolling:function(){
						$('#gridLabVisitRepResult_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
					}
				}
			});			
			$("#gridLabVisitRepResult_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridLabVisitRepResult tr td:first"));
        }
	});

    $("#LabHisData").height(390);
	$("#LabHisData").mCustomScrollbar({
		theme: "dark-thick",
		axis: "xy",
		scrollInertia: 100
	});
	
	InitLisReportWinEvent(obj);
	return obj;
}
