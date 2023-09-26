//页面Gui
function InitS800CssPosInf1Win(){
	var obj = new Object();
    var HospID=$.LOGON.HOSPID;
    obj.repName = "DHCHAI.STAT.S800CssPosInf1.raq";
	
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("cboHospital");  //渲染下拉框
	// 默认加载登录院区
	$.form.SetValue("cboHospital",$.LOGON.HOSPID,$.LOGON.HOSPDESC);
	
    //设置开始日期为当月1号
	/*
	var currDate = $.form.GetCurrDate('-');
	var arrDate = currDate.split('-');
	var dateFrom = arrDate[0] + "-" + arrDate[1] + "-01"
    //$.form.DateTimeRender('DateFrom',dateFrom);
    $.form.DateTimeRender('DateFrom',$.form.GetCurrDate('-'));
    */
	 $("#cboSurvNumber").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboSurvNumber");  //渲染下拉框	
	//给select2赋值change事件
	$("#cboHospital").on("select2:select", function (e) { 
		//获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboSurvNumber").data("param",id);
		$.form.SelectRender("cboSurvNumber");  //渲染下拉框
	});
	//初始化高度
	var wh = $(window).height();
    $("#divLeft").height(wh-10);
    $("#divMain").height(wh-11);
	$("#divPanel").height(wh-65);
	//自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$("#divLeft").height(wh-10);
		$("#divMain").height(wh-11);
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
   	
	InitS800CssPosInf1WinEvent(obj);
	return obj;
}