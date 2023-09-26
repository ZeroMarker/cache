//页面Gui
function InitCtlMonitorWin(){
	var obj = new Object();
    obj.ResultID="";
	  obj.EpisodeID="";
   
    //初始化赋值
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //渲染下拉框
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	//给select2赋值change事件
	$("#cboHospital").on("select2:select", function (e) { 
		//获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboLocation").data("param",id+"^^I|E^W^1");
		$.form.SelectRender("cboLocation");  //渲染下拉框	
		$("#cboWard").data("param",id+"^^I|E^W^1");
		$.form.SelectRender("cboWard");  //渲染下拉框		
	});	
	$.form.SelectRender("#cboDateType");
	$("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^I|E^W^1");
	$.form.SelectRender("cboLocation");  //渲染下拉框	
	$("#cboWard").data("param",$.form.GetValue("cboHospital")+"^^I|E^W^1");
	$.form.SelectRender("cboWard");  //渲染下拉框
	$.form.SelectRender('cboInfType');	
	$.form.SelectRender('cboBacteria');	
	$.form.SelectRender('cboMRBBact');	
   
	$.form.DateTimeRender('DateFrom');
	$.form.DateTimeRender('DateTo');
    
	$("#DateFrom").val($.form.GetCurrDate('-'));
	$("#DateTo").val($.form.GetCurrDate('-'));
    
	//耐药菌列表
	obj.gridCtlResult = $("#gridCtlResult").DataTable({
		dom: 'rt<"row"<"col-sm-6 col-xs-6"pl><"col-sm-6 col-xs-6"i>>',
		select: 'single',
		paging: true,
		ordering: true,
		info: true,
		"iDisplayLength" : 50,
		"scrollX": true,
		"scrollY":($(window).height()-165)+"px",
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CtlMRBSrv";
				d.QueryName = "QryMRBMonitor";
				d.Arg1 =$("#cboHospital").val();
				d.Arg2 =$("#cboDateType").val();
				d.Arg3 =$("#DateFrom").val();
				d.Arg4 =$("#DateTo").val();
				d.Arg5 =$("#cboLocation").val();
				d.Arg6 =$("#cboInfType").val();
				d.Arg7 =$("#cboBacteria").val();
				d.Arg8 =$("#cboMRBBact").val();
				d.Arg9 =$("#cboWard").val();
				d.ArgCnt = 9;
			}
		},
		"columns": [		
			//{"data": "AdmWardDesc"},
			{"data": "LabWardDesc"},
			{"data": "PapmiNo",render: function (data, type, row) {   //病案号加不可见字符，适用导出、打印格式
				return type == 'export' ?
				String.fromCharCode(2)+row.PapmiNo:data;
				}
			},
			{"data": "MrNo",render: function (data, type, row) {   //病案号加不可见字符，适用导出、打印格式
				return type == 'export' ?
				String.fromCharCode(2)+row.MrNo:data;
				}
			},
			{"data": "PatName"},
			{"data": "Sex"},
			{"data": "Age"},
			{"data": "AdmDate"},
			{"data": null,
				render: function ( data, type, row) {
					return data.MRBDesc.replace(/,/g,'<br />');
				}
			},
			{"data": null,
				render: function ( data, type, row ) {
					return '<a href="#" class="detail">明细</a>';
				}
			},
			{"data": null,
				render: function ( data, type, row ) {
					return data.SpecBact.replace(/,/g,'<br />');
				}
			},
			{"data": "DischDate",
				render: function ( data, type, row ) {
					var editHtml = data+"&nbsp&nbsp&nbsp";
					return editHtml; 
				}
			}
		],
		"columnDefs": [
			{ 
				"type": "date-euro", 
				targets: [6,10] 	//适配日/月/年类型日期时的排序
			}
        ]
		,"fnDrawCallback": function (oSettings) {
			$("#gridCtlResult_wrapper .dataTables_scrollBody").mCustomScrollbar({
				theme : "dark-thick",
				axis: "xy",
				callbacks:{
					whileScrolling:function(){
						$('#gridCtlResult_wrapper .dataTables_scrollHead').scrollLeft(-this.mcs.left); 
					}
				}
			});			
			$("#gridCtlResult_wrapper .dataTables_scrollBody").mCustomScrollbar("scrollTo",$("#gridCtlResult tr td:first"));
        }
	});
	
	
	obj.gridIRDrugSen = $("#gridIRDrugSen").DataTable({
		dom: 'rt',
		info: true,
		paging: false,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CtlMRBSrv";
				d.QueryName = "QryResultSen";
				d.Arg1 = obj.ResultID;
				d.ArgCnt = 1;
			}
		},
		"columns": [
			{"data": "AntDesc"},
			{"data": "Sensitivity"}
		]
	});
	
	obj.gridBactDetail = $("#gridBactDetail").DataTable({
		dom: 'rt',
		info: true,
		paging: false,
		ordering: false,
		autoWidth:false,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				d.ClassName = "DHCHAI.IRS.CtlMRBSrv";
				d.QueryName = "QryBactDetail";
				d.Arg1 = obj.EpisodeID;
				d.Arg2 = $("#cboDateType").val();
				d.Arg3 =$("#DateFrom").val();
				d.Arg4 =$("#DateTo").val();
				d.ArgCnt = 4;
			}
		},
		"columns": [
			{"data": "ID"},
			{"data": "Specimen"},
			{"data": "Bacteria"},
			{"data": null, 
				render: function ( data, type, row ) {
					if (row.MRBDesc2!=""&&row.MRBDesc2!="undefined"){
						return row.MRBDesc+","+row.MRBDesc2;
					}else{
						return row.MRBDesc;
					}
				}
			},
			{"data": "ActDate"},
			{"data": "RepDate"},
			{"data": "ActLocDesc"},
			{"data": "ActUser"}
		]
	});
	
	//初始化高度
	var wh = $(window).height();
    $("#divLeft").height(wh-10);
	$("#divPanel").height(wh-65);
	//自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$("#divLeft").height(wh-10);
		$("#divPanel").height(wh-65);
	});
	
	$("#divLeft").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("#layer_one").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});	
	$("#layer_two").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("#layer_three").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});	
    $("#divPanel").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	InitCtlMonitorWinEvent(obj);
	return obj;
}