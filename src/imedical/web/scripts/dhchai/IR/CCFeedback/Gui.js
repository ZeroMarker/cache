//页面Gui
function InitCCFeedbackWin(){
	var obj = new Object();
	
	$("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //渲染下拉框	
    $("#cboHospital option:selected").next().attr("selected", true)
    $("#cboHospital").select2();
    $("#cboHospital").on("select2:select", function (e) {
        //获得选中的医院
        var data = e.params.data;
        var id = data.id;
        var text = data.text;
        $("#cboLocation").data("param", id + "^^I^E^1");
        $.form.SelectRender("cboLocation");  //渲染下拉框	
    });
	$("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^I^E^1");
	$.form.SelectRender("cboLocation");  //渲染下拉框
	
	$.form.DateTimeRender('DateFrom',$.form.GetCurrDate('-'));
    $.form.DateTimeRender('DateTo',$.form.GetCurrDate('-'));
	
	//初始化高度
	var wh = $(window).height();
	$(".listtable").height(wh-10);
	$(".listterm .panel-body").height(wh-68);
	$("#MainTable").height(wh-1);
	
	//自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$(".listtable").height(wh-10);
		$(".listterm .panel-body").height(wh-68);
		$("#MainTable").height(wh-1);
	});
	
	$('#divMain').mCustomScrollbar({
		theme: "dark-thick",
		scrollInertia : 100,
		mouseWheelPixels: 80 //滚动速度
	});
	$('#MainTable').mCustomScrollbar({
		theme: "dark-thick",
		scrollInertia : 100,
		mouseWheelPixels: 80 //滚动速度
	});
	
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	InitCCFeedbackWinEvent(obj);
	return obj;
}