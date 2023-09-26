//页面Gui
function InitS210OpPosInfWin(){
	var obj = new Object();
    var HospID=$.LOGON.HOSPID;
    
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("cboHospital");  //渲染下拉框
	// 默认加载登录院区
	$.form.SetValue("cboHospital",$.LOGON.HOSPID,$.LOGON.HOSPDESC);
	$("#DateFrom").datetimepicker({
	     format: "yyyy-mm",
	     autoclose: true,
	     todayBtn: true,
	     startView:3,
		 minView:3,
		 todayHighlight: 1,
		 forceParse: 0,
		 showMeridian: 1,
	     language: 'zh-CN',
	     fontAwesome:true    //显示字体图标
	});
	$("#DateTo").datetimepicker({
	     format: "yyyy-mm",
	     autoclose: true,
	     todayBtn: true,
	     startView:3,
		 minView:3,
		 todayHighlight: 1,
		 forceParse: 0,
		 showMeridian: 1,
	     language: 'zh-CN',
	     fontAwesome:true    //显示字体图标
	});
	var dateNow = new Date();
	var year = dateNow.getFullYear();
	var month = dateNow.getMonth();
	month++;
	if(month<10) month = '0'+month;
	$("#DateFrom").val(year+'-'+month);
	$("#DateTo").val(year+'-'+month);	
    
    
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
   	
	InitS210OpPosInfWinEvent(obj);
	return obj;
}