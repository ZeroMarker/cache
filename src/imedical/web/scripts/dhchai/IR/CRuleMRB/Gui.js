//页面Gui
function InitDictionaryWin(){
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
			$('#TableBact').show();
			$('#TableAnti').hide();
			$('#TableKeys').hide();
			$('#TableIsolate').hide();
		}
		else if(val=="2")
		{
	      	$('#TableBact').hide();
			$('#TableAnti').show();
			$('#TableKeys').hide();
			$('#TableIsolate').hide();
		}
		else if(val=="3")
		{
	      	$('#TableBact').hide();
			$('#TableAnti').hide();
			$('#TableKeys').show();
			$('#TableIsolate').hide();
		}
		else {
			$('#TableBact').hide();
			$('#TableAnti').hide();
			$('#TableKeys').hide();
			$('#TableIsolate').show();
		}
		
	});
	
 	obj.gridCRuleMRB = $("#gridCRuleMRB").DataTable({
  		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
  		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CRuleMRBSrv";
				d.QueryName = "QryCRuleMRB";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "BTCode"},
			{"data": "BTDesc"},
			{"data": "BTCatDesc"},
			{"data": "BTIsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "IsKeyCheck", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "IsRuleCheck", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "AnitCatCnt"},
			{"data": "AnitCatCnt2"},
			{"data": "IsAntiCheck", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}
		]
		,drawCallback: function (settings) {
			$("#btnAdd_one").removeClass('disabled');
        	$("#btnEdit_one").addClass('disabled');
        	$("#btnDelete_one").addClass('disabled');
		}
	});

	//多重耐药菌-细菌列表
	obj.gridMRBBact = $("#gridMRBBact").DataTable({
		dom: 'rt', //<"row"f>
		select: 'single',
		paging: false,
		ordering: false,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CRuleMRBSrv";
				d.QueryName = "QryMRBBactByMRBID";
				var rd = obj.gridCRuleMRB.rows({selected: true}).data().toArray()[0];
				d.Arg1 = (rd ? rd["ID"] : '');
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "BactDesc"}
		]
		,drawCallback: function (settings) {
			var rd = obj.gridCRuleMRB.rows({selected: true}).data().toArray()[0]; //多重耐药菌
			if (rd) {
				$("#btnAdd_two").removeClass('disabled');
			}
        	$("#btnEdit_two").addClass('disabled');
        	$("#btnDelete_two").addClass('disabled');
		}
	});
	
	//多重耐药菌-抗生素列表
	obj.gridMRBAnti = $("#gridMRBAnti").DataTable({
		dom: 'rt', //<"row"f>
		select: 'single',
		paging: false,
		ordering: false,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CRuleMRBSrv";
				d.QueryName = "QryMRBAntiByMRBID";
				var rd = obj.gridCRuleMRB.rows({selected: true}).data().toArray()[0];
				d.Arg1 = (rd ? rd["ID"] : '');
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "AntiCatDesc"},
			{"data": "AntiDesc"}
		]
		,drawCallback: function (settings) {
			var rd = obj.gridCRuleMRB.rows({selected: true}).data().toArray()[0]; //多重耐药菌
			if (rd) {
				$("#btnAdd_three").removeClass('disabled');
			}
        	$("#btnEdit_three").addClass('disabled');
        	$("#btnDelete_three").addClass('disabled');
		}
	});
	
	//多重耐药菌-关键词列表
	obj.gridMRBKeys = $("#gridMRBKeys").DataTable({
		dom: 'rt', //<"row"f>
		select: 'single',
		paging: false,
		ordering: false,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CRuleMRBSrv";
				d.QueryName = "QryMRBKeysByMRBID";
				var rd = obj.gridCRuleMRB.rows({selected: true}).data().toArray()[0];
				d.Arg1 = (rd ? rd["ID"] : '');
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "KeyWord"}
		]
		,drawCallback: function (settings) {
			var rd = obj.gridCRuleMRB.rows({selected: true}).data().toArray()[0]; //多重耐药菌
			if (rd) {
				$("#btnAdd_four").removeClass('disabled');
			}
        	$("#btnEdit_four").addClass('disabled');
        	$("#btnDelete_four").addClass('disabled');
		}
	});
	
	//多重耐药菌-隔离医嘱列表
	obj.gridIsolate = $("#gridIsolate").DataTable({
		dom: 'rt', //<"row"f>
		select: 'single',
		paging: false,
		ordering: false,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CRuleMRBSrv";
				d.QueryName = "QryMRBOEOrdByMRBID";
				var rd = obj.gridCRuleMRB.rows({selected: true}).data().toArray()[0];
				d.Arg1 = (rd ? rd["ID"] : '');
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "BTOrdDesc"}
		]
		,drawCallback: function (settings) {
			var rd = obj.gridCRuleMRB.rows({selected: true}).data().toArray()[0]; //多重耐药菌
			if (rd) {
				$("#btnAdd_five").removeClass('disabled');
			}
        	$("#btnEdit_five").addClass('disabled');
        	$("#btnDelete_five").addClass('disabled');
		}
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitDictionaryWinEvent(obj);
	return obj;
}