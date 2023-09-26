//页面Gui
function InitEnviHyApplyWin(){
	var obj = new Object();
	// 主页面
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
    // 渲染医院
	$.form.SelectRender("#cboHospital");
	// 院区默认选择
	$.form.SetValue("cboHospital",$("#cboHospital>option:nth-child(2)").val(),$("#cboHospital>option:nth-child(2)").text());
	// 渲染科室
	$("#cboApplyLoc").data("param",$.form.GetValue("cboHospital")+"^^I^E^1");
	$.form.SelectRender("cboApplyLoc");	
	// 给select2赋值change事件
	$("#cboHospital").on("select2:select", function (e) { 
		//获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboApplyLoc").data("param",id+"^^I^E^1");
		$.form.SelectRender("cboApplyLoc");
	});	
	// $.form.DateRender('DateFrom','','',1);
	// $.form.DateRender('DateTo','','',1);
	//设置开始日期为当月1号
	var mydate = new Date($.form.GetCurrDate('-'));
	mydate.setDate(1);
	$.form.DateTimeRender('DateFrom',mydate.format('yyyy-MM-dd'));
    $.form.DateTimeRender('DateTo',$.form.GetCurrDate('-'));

	$.form.SelectRender("cboEvItem"); 


	// 弹出层
	$("#cboAHospital").data("param",$.LOGON.HOSPID);
	// 渲染医院
	$.form.SelectRender("#cboAHospital"); 
	// 一个院区默认选择
	// if ($('#cboAHospital>option').length==2){
		$.form.SetValue("cboAHospital",$("#cboAHospital>option:nth-child(2)").val(),$("#cboAHospital>option:nth-child(2)").text());
	// };
	// 渲染科室
	$("#cboALoc").data("param",$.form.GetValue("cboAHospital")+"^^I^E^1");
	$.form.SelectRender("#cboALoc");	
	//给select2赋值change事件
	$("#cboAHospital").on("select2:select", function (e) { 
		//获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboALoc").data("param",id+"^^I^E^1");
		$.form.SelectRender("#cboALoc");  //渲染下拉框
	});	
	// $.form.DateRender('AMonitorDate','','',1);
	$.form.DateTimeRender('AMonitorDate',$.form.GetCurrDate('-'));
	$.form.SelectRender('#cboAEvItem');
	$("#cboAEvItem").change(function(){
		var AEvItem = $.form.GetValue("cboAEvItem");
		$("#cboAEvObject").data("param",AEvItem);	
		$.form.SelectRender("#cboAEvObject");
		if ($('#cboAEvObject>option').length==2){
			$.form.SetValue("cboAEvObject",$("#cboAEvObject>option:nth-child(2)").val(),$("#cboAEvObject>option:nth-child(2)").text());
		};
		// 默认标本数量
		var SpenNum = $.Tool.RunServerMethod('DHCHAI.IR.EnviHyItem','GetSpenNumById',AEvItem)
		$.form.SetValue("txtSpecimenNum",SpenNum);
	});


	// 初始化高度
	var wh = $(window).height();
    $("#divLeft").height(wh-10);
    $("#divMain").height(wh);
	$("#divPanel").height(wh-65);
	// 自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$("#divLeft").height(wh-10);
		$("#divMain").height(wh);
		$("#divPanel").height(wh-65);
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
	
	$("#layerResultDetail").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	obj.gridApply = $("#gridApply").DataTable({
		dom: 'rt<"row"<"col-sm-6"pl><"col-sm-6"i>>',
		paging: true,
		select: 'single',
		ordering: true,
		info: true,
		"iDisplayLength" : 50,
		"processing" : true,
		ajax: {
			"url": "dhchai.query.datatables.csp",
			"data": function (d) {
				var HospIDs 	= $("#cboHospital").val();
				var DateFrom	= $("#DateFrom").val();
				var DateTo		= $("#DateTo").val();
				var ApplyLoc 	= $("#cboApplyLoc").val();
				var EvItem 		= $("#cboEvItem").val();
				d.ClassName = "DHCHAI.IRS.EnviHyReportSrv";
				d.QueryName = "QryEvReport";
				d.Arg1 =HospIDs;
				d.Arg2 =DateFrom;
				d.Arg3 =DateTo;
				d.Arg4 =ApplyLoc;
				d.Arg5 =EvItem;
				d.ArgCnt = 5;
			}
		},
		"columns": [
			{"data": "BarCode"},
			{"data": "EvItemDesc"},
			{"data": "ApplyLocDesc"},
			{"data": "RepStatusDesc"},
			{"data": "EvItemObjDesc"},
			{"data": "MonitorDate"},
			{"data": "SpenTypeDesc"},
			{"data": "EvItemSpenNum"},
			{"data": "ApplyUserDesc"},
			// {"data": "Result"},
			{
				"data": null,
				render: function ( data, type, row ) {
					var html = '<a href="#" class="result">'+'结果'+'</a>';
					return html;
				}
			},
			{"data": "StandardDesc"}
		],
		"columnDefs":[
			{
				
				"type":"date-euro",
				targets:[5]
			}
		],
		drawCallback: function (settings) {
        	$("#btnDelete").addClass('disabled');
        	$("#btnEdit").addClass('disabled');
        	$("#btnPrintBar").addClass('disabled');
		}
	});
	InitEnviHyApplyWinEvent(obj);
	return obj;
}
