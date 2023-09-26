//页面Gui
function InitHHConsumsWin(){
	var obj = new Object();
    obj.ResultID="";
    
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("cboHospital");  //渲染下拉框
	// 默认加载登录院区
	$.form.SetValue("cboHospital",$.LOGON.HOSPID,$.LOGON.HOSPDESC);
	$("#cboLoc").data("param",$.form.GetValue("cboHospital")+"^^I^W^1");
	$.form.SelectRender("cboLoc");
    
    $("#cboHospital1").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("cboHospital1");  //渲染下拉框
	// 默认加载登录院区
	$.form.SetValue("cboHospital1",$.LOGON.HOSPID,$.LOGON.HOSPDESC);
	$("#cboObsLoc").data("param",$.form.GetValue("cboHospital1")+"^^I^W^1");
	$.form.SelectRender("cboObsLoc");
    //初始化赋值
    $.form.DateTimeRender('DateFrom');
    $.form.DateTimeRender('DateTo');
    $.form.DateTimeRender('ObsDate');
    //默认获取当前日期
    var date = new Date();
    var mon = date.getMonth();
    var day = date.getDate();
    var year = date.getFullYear();
    var mydate = date.getFullYear() + "-" + (mon < 10 ? "0" + mon : mon) + "-" + (day < 10 ? "0" + day : day);
	mon++;
	if(mon<10) mon = '0'+mon;
	if(day<10) day = '0'+day;
	$("#DateFrom").val(year+'-'+mon+'-'+day);
	$("#DateTo").val(year+'-'+mon+'-'+day);
	$("#ObsDate").val(year+'-'+mon+'-'+day);
	
	// 手卫生消耗登记
	obj.gridHHConsums = $("#gridHHConsums").DataTable({
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
				d.ClassName = "DHCHAI.IRS.HandHyConsumsSrv";
				d.QueryName = "QryHHConsums";
				d.Arg1 =$.form.GetValue("cboHospital");
				d.Arg2 =$.form.GetValue("cboLoc");
				d.Arg3 =$.form.GetValue("DateFrom");
				d.Arg4 =$.form.GetValue("DateTo");
				d.ArgCnt = 4;
			}
		},
		"columns": [
			{"data": "LocDesc"},
			{"data": "ID",
				render: function (data, type, row ) {
					var ID=data;
					if ((ID!="")&(ID!=undefined)){
						return '<a href="#" class="btnReprot">'+ID+'</a>';
					}else {
						return "";
					}
				}
			},
			{"data": "ObsDate"},
			{"data": "ProductDesc"},
			{"data": "Consumption",
				render: function (data, type, row ) {
					return data+"ml";
				}
			},
			{"data": "Recipient"},
			{"data": "RepDate"},
			{"data": "RepTime"},
			{"data": "RegUserDesc"},
			{"data": "IsActive", 
				"render": function (data, type, row) {
					return (data == '1' ? '是' : '否');
				}
			},
			{"data": "Resume"}
		],"columnDefs": [{
			"type":"date-euro",
			"targets": [2,6,7]
		}],
		drawCallback: function (settings) {
        	$("#btnDelete").addClass('disabled');
		}
	});
	
	//初始化高度
	var wh = $(window).height();
	$("#divLeft").height(wh-10);
    $("#divLeft .panel-body").height(wh-70);
    $("#divMain").height(wh-1);
	//自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$("#divLeft").height(wh-10);
		$("#divLeft .panel-body").height(wh-70);
		$("#divMain").height(wh-1);
	});
	
	$("#divLeft").mCustomScrollbar({
		//scrollButtons: { enable: true },
		//autoHideScrollbar: true,
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	$("#divMain").mCustomScrollbar({
		//scrollButtons: { enable: true },
		//autoHideScrollbar: true,
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	$('body').mCustomScrollbar({
		//scrollButtons: { enable: true },
		theme: "dark-thick",
		scrollInertia : 100
	});
	
	InitHHConsumsWinEvent(obj);
	return obj;
}