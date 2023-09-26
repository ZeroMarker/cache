//页面Gui
function InitCRuleAntiWin(){
	var obj = new Object();
	$("#cboLocation").attr("data-param",$.LOGON.HOSPID);
    //类型为全院：根据登陆医院查找分组下所有医院的科室，院区、科室：根据登陆医院查找医院的科室
	$("#cboType").on("select2:select", function (e) { 
		//获得类型
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboLocation").data("param",$.LOGON.HOSPID+"^^^^1^"+id);
		$.form.SelectRender("cboLocation");  //渲染下拉框	
	});	
	//抗菌用药列表
	obj.gridCRuleAnti = $("#gridCRuleAnti").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CRuleAntiSrv";
				d.QueryName = "QryCRuleAnti";
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
			{"data": "AntiCatDesc"},
			{"data": "AntiMastDesc"},
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
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitCRuleAntiWinEvent(obj);
	return obj;
}