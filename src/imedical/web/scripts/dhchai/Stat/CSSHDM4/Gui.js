//页面Gui
function InitCSSHDM4Win(){
	var obj = new Object();
    var HospID=$.LOGON.HOSPID;
	//赋值初始值
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("cboHospital");  //渲染下拉框
	// 默认加载登录院区
	$.form.SetValue("cboHospital",$.LOGON.HOSPID,$.LOGON.HOSPDESC);
	$("#cboSurvNumber").data("param",$.form.GetValue("cboHospital"));
	$.form.SelectRender("cboSurvNumber");
	//给select2赋值change事件
	$("#cboHospital").on("select2:select", function (e) { 
		//获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboSurvNumber").data("param",id);
		$.form.SelectRender("cboSurvNumber");  //渲染下拉框	
	});
    $.form.SelectRender("#cboStatType");
    $.form.SelectRender("#cboInfType");
    
    $("#cboStatType").on("change", function (e) { 
		var text =$.form.GetText("cboStatType");;
		if (text=="按科室统计"){
			$("#cboLocation").data("param",HospID+"^^I^E^1");
			$.form.SelectRender("cboLocation");
		}else{
			$("#cboLocation").data("param",HospID+"^^I^W^1");
			$.form.SelectRender("cboLocation");
		}
	});
	
    //$("#cboInfType option:selected").next().attr("selected", true);
	//$("#cboInfType").select2();
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
   	
	InitCSSHDM4WinEvent(obj);
	return obj;
}