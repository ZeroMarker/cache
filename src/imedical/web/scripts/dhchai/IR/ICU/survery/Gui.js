//页面Gui
function InitSurveryWin(){
	var obj = new Object();	
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //渲染下拉框
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	
	//日期 注意:不通用 格式只到 年-月
	obj.dateCom = $("#startDate").datetimepicker({
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
	/*
	if(month==0){
		month = 12;
		year--;
	}
	else
	{
		month++;
	}
	*/
	var lastDay = new Date(year,month,0).getDate();
	if(month<10) month = '0'+month;
	$("#startDate").val(year+'-'+month);
	
	
	//导出Excel过滤器
	function createCellPos( n ){
		var ordA = 'A'.charCodeAt(0);
		var ordZ = 'Z'.charCodeAt(0);
		var len = ordZ - ordA + 1;
		var s = "";
	 
		while( n >= 0 ) {
			s = String.fromCharCode(n % len + ordA) + s;
			n = Math.floor(n / len) - 1;
		}
	 
		return s;
	}
		
	//默认表格显示icu
	//$('.nicu-mode-list').hide();
	//初始化高度
	var wh = $(window).height();
    $("#divLeft").height(wh-10);
    $("#divMain").height(wh-1);
    $("#divPanel").height(wh-152);
	
	//自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$("#divLeft").height(wh-10);
		$("#divMain").height(wh-1);
		$("#divPanel").height(wh-152);
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
	$("#divPanel").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	
	$("#winICULogsEditModal").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});

	
	InitSurveryWinEvent(obj);
	return obj;
}