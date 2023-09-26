//页面Gui
function InitCRuleTestSrvWin(){
	var obj = new Object();
	
	//表格页签事件
	$('#ulTableNav > li').click(function (e) {
		e.preventDefault();
		$('#ulTableNav > li').removeClass('active');
		$(this).addClass('active');
		var val = $(this).val();
		$('#ulTableNav').val(val);
		if(val=="1")
		{
			$('#TableTSSpec').show();
			$('#TableTSCode').hide();
			$('#TableTSResult').hide();
			$('#TableTSAbRstFlag').hide();
		}
		else if(val=="2")
		{
	      	$('#TableTSSpec').hide();
			$('#TableTSCode').show();
			$('#TableTSResult').hide();
			$('#TableTSAbRstFlag').hide();
		}
		else if(val=="3")
		{
			$('#TableTSSpec').hide();
			$('#TableTSCode').hide();
			$('#TableTSResult').show();
			$('#TableTSAbRstFlag').hide();
	
		}else {
			$('#TableTSSpec').hide();
			$('#TableTSCode').hide();
			$('#TableTSResult').hide();
			$('#TableTSAbRstFlag').show();
		}
		
	});
	
	
    obj.gridCRuleTsAb = $("#gridCRuleTsAb").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CRuleTestSrv";
				d.QueryName = "QryCRuleTestAb";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "TestSet"},
			{"data": "TestCode"},
			{"data": "IsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}, 
			{"data": "TSPFlag", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "TRFFlag", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}, 
			{"data": "TRFlag", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}, 
			{"data": "TRVMaxFlag", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}, 
			{"data": "MaxValM"}, 
			{"data": "MaxValF"}, 
			{"data": "TRVMinFlag", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}, 
			{"data": "MinValM"}, 
			{"data": "MinValF"} 
		],
		drawCallback: function (settings) {
			$("#btnAdd_one").removeClass('disabled');
        	$("#btnEdit_one").addClass('disabled');
        	$("#btnDelete_one").addClass('disabled');
		}
	});
	$('#gridCRuleTsAb').on('click','tr', function(e) {
		var rd = obj.gridCRuleTsAb.row(this).data();
		$('#gridCRuleTsAb').val(rd["ID"]);
		obj.gridCRuleTSSpec.ajax.reload(); 
		obj.gridCRuleTSCode.ajax.reload();   
		obj.gridCRuleTSResult.ajax.reload();   
		obj.gridCRuleTsAbRstFlag.ajax.reload();   
	}); 
	
	//常规检验-标本维护
	obj.gridCRuleTSSpec = $("#gridCRuleTSSpec").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',	
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CRuleTestSrv";
				d.QueryName = "QryTSSpecByTsAb";
				d.Arg1=$('#gridCRuleTsAb').val();	
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "TSSpec"},
			{"data": "MapSpec"}
		],
		drawCallback: function (settings) {
			var rd = $('#gridCRuleTsAb').val(); 
			if (rd) {
				$("#btnAdd_two").removeClass('disabled');
			}
        	$("#btnEdit_two").addClass('disabled');
        	$("#btnDelete_two").addClass('disabled');
		},
		"autoWidth": false
	});
	
	
	//常规检验-检验项目维护
	obj.gridCRuleTSCode = $("#gridCRuleTSCode").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',	
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CRuleTestSrv";
				d.QueryName = "QryTSCodeByTsAb";
				d.Arg1=$('#gridCRuleTsAb').val();	
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "TCMCode"},
			{"data": "TCMDesc"},
			{"data": "MapRstFormat"}
		],
		drawCallback: function (settings) {
			var rd = $('#gridCRuleTsAb').val(); 
			if (rd) {
				$("#btnAdd_three").removeClass('disabled');
			}
        	$("#btnEdit_three").addClass('disabled');
        	$("#btnDelete_three").addClass('disabled');
		},
		"autoWidth": false
	});
	
	//常规检验-检验结果维护
	obj.gridCRuleTSResult = $("#gridCRuleTSResult").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',	
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CRuleTestSrv";
				d.QueryName = "QryTSResultByTsAb";
				d.Arg1=$('#gridCRuleTsAb').val();	
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "TestCode"},
			{"data": "TestResult"},
			{"data": "MapText"}
		],
		drawCallback: function (settings) {
			var rd = $('#gridCRuleTsAb').val(); 
			if (rd) {
				$("#btnAdd_four").removeClass('disabled');
			}
        	$("#btnEdit_four").addClass('disabled');
        	$("#btnDelete_four").addClass('disabled');
		},
		"autoWidth": false
	});
	
	//常规检验-异常标志维护
	obj.gridCRuleTsAbRstFlag = $("#gridCRuleTsAbRstFlag").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',	
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CRuleTestSrv";
				d.QueryName = "QryTSAbFlagByTsAb";
				d.Arg1=$('#gridCRuleTsAb').val();	
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "TestCode"},
			{"data": "TSRstFlag"},
			{"data": "MapText"}
		],
		drawCallback: function (settings) {
			var rd = $('#gridCRuleTsAb').val(); 
			if (rd) {
				$("#btnAdd_five").removeClass('disabled');
			}
        	$("#btnEdit_five").addClass('disabled');
        	$("#btnDelete_five").addClass('disabled');
		},
		"autoWidth": false
	});
	//初始化高度
	var wh = $(window).height();
    $("#divLeft").height(wh);
    $("#divMain").height(wh-50);
	
	//自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$("#divLeft").height(wh);
		$("#divMain").height(wh-50);
	});
	
	$("#divLeft").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	$("#divMain").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitCRuleTestSrvWinEvent(obj);
	return obj;
}