//页面Gui
function InitCRuleOperWin(){
	var obj = new Object();
	 //类型为全院：根据登陆医院查找分组下所有医院的科室，院区、科室：根据登陆医院查找医院的科室
	$("#cboType").on("select2:select", function (e) { 
		//获得类型
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		if (id!=1) {
			$("#cboLocation").data("param",$.LOGON.HOSPID);
			$.form.SelectRender("cboLocation");  //渲染下拉框
		}	
	});	
	//手术列表
	obj.gridCRuleOper = $("#gridCRuleOper").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CRuleOperSrv";
				d.QueryName = "QryCRuleOper";
				d.ArgCnt = 0;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "Type",
				"render": function (data, type, row) {
					switch(data){
						case "1":
							return "全院";
							break;
						case "2":
							return "院区";
							break;
						case "3":
							return "科室";
							break;
						default:
							return "全院";
					}
				}
			},
			{"data": "GrpDesc"},
			{"data": "HospDesc"},
			{"data": "LocDesc"},
			{"data": "IncDesc"},
			{"data": "Operation"},
			{"data": "IsActive",
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			}
		]
		,drawCallback: function (settings) {
			$("#btnAdd").removeClass('disabled');
        	$("#btnEdit").addClass('disabled');
        	$("#btnDelete").addClass('disabled');
		}
	});
	
	//手术关键词
	obj.gridCRuleOperKeys = $("#gridCRuleOperKeys").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CRuleOperSrv";
				d.QueryName = "QryCRuleOperKeys";
				var rd = obj.gridCRuleOper.rows({selected: true}).data().toArray()[0];
				d.Arg1 = (rd ? rd["ID"] : '');
				d.ArgCnt = 1;
			}
		},
		columns: [
			{"data": "ID"},
			{"data": "InWord"},
			{"data": "ExWords"}
		]
		,drawCallback: function (settings) {
			var rd = obj.gridCRuleOper.rows({selected: true}).data().toArray()[0];
			if (rd) {
				$("#btnAdd_Keys").removeClass('disabled');
			}
        	$("#btnEdit_Keys").addClass('disabled');
        	$("#btnDelete_Keys").addClass('disabled');
		}
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitCRuleOperWinEvent(obj);
	return obj;
}