//页面Gui
function InitEnviHyReusltWin(){
	var obj = new Object();
	obj.RepStaus = '';
	obj.FlowFlg = '';
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
	//设置开始日期为当月1号
	var mydate = new Date($.form.GetCurrDate('-'));
	mydate.setDate(1);
	$.form.DateTimeRender('DateFrom',mydate.format('yyyy-MM-dd'));
    $.form.DateTimeRender('DateTo',$.form.GetCurrDate('-'));
    
	$.form.SelectRender("cboRepStatus");
	$("#cboRepStatus").change(function(){
		obj.RepStaus = $.form.GetValue("cboRepStatus");
	});

	$('#btnHairMaterial').hide();
	$('#btnHairMaterialAll').hide();
	$('#btnRecSpecn').hide();
	$('#textSpenBarCode').hide();
	$('#btnEnterResult').hide();
	$.form.SelectRender1('cboBacteria',1);
	
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
	
	obj.gridReuslt = $("#gridReuslt").DataTable({
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
				var EvItem  	= '';
				var RepStatus 	= obj.RepStaus;
				d.ClassName = "DHCHAI.IRS.EnviHyReportSrv";
				d.QueryName = "QryEvReport";
				d.Arg1 =HospIDs;
				d.Arg2 =DateFrom;
				d.Arg3 =DateTo;
				d.Arg4 =ApplyLoc;
				d.Arg5 =EvItem;
				d.Arg6 =obj.RepStaus;
				d.Arg7 =obj.FlowFlg;
				d.ArgCnt = 7;
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
			{
				"data": null,
				render: function ( data, type, row ) {
					var html = '<a href="#" class="detail">'+'标本明细'+'</a>';
					return html;
				}
			},
			{
				"data": null,
				render: function ( data, type, row ) {
					var html = '<a href="#" class="result">'+'结果'+'</a>';
					return html;
				}
			},
			{"data": "StandardDesc"},
			{"data": "ApplyUserDesc"}
		],
		"columnDefs":[
			{
				
				"type":"date-euro",
				targets:[5]
			}
		],
		drawCallback: function (settings) {
		}
	});
	InitEnviHyReusltWinEvent(obj);
	return obj;
}
