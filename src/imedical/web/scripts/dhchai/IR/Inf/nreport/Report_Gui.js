var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var CHR_3 = String.fromCharCode(3);
var CHR_4 = String.fromCharCode(4);
var CHR_5 = String.fromCharCode(5);
var CHR_6 = String.fromCharCode(6);
var CHR_7 = String.fromCharCode(7);
var CHR_8 = String.fromCharCode(8);

function InitNReportWin()
{
	var obj = new Object();
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    } 	
	// 渲染checkbox
	$.form.CheckBoxRender();
	$.form.iCheckRender();
	$.form.DateRender('txtInfDate','');
	// 初始化模块
	obj.AdminPower  = AdminPower;
	obj.RepStatusCode = '';
	InitBase(obj);
	InitRep(obj);
	InitLab(obj);
	InitAnt(obj);

	var wh = $(window).height();
	$("body").height(wh);
	$(window).resize(function(){
		 $("body").height(wh);
	});
    $("#LayerOpenINFLabSync").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("#LayerOpenINFAntiSync").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$('body').css('overflow-y','hidden');
    $('body').css('overflow-x','hidden');
	InitNReportWinEvent(obj);
	return obj;
}