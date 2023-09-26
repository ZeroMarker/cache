/**
 * 
 * @authors liyi (124933390@qq.com)
 * @date    2017-09-13 16:25:11
 * @version v1.0
 */
var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var CHR_3 = String.fromCharCode(3);
var CHR_4 = String.fromCharCode(4);
var CHR_5 = String.fromCharCode(5);
var CHR_6 = String.fromCharCode(6);
var CHR_7 = String.fromCharCode(7);
var CHR_8 = String.fromCharCode(8);

function InitReportWin()
{
	var obj = new Object();
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    } 	
	// 渲染checkbox
	$.form.CheckBoxRender();
	$.form.iCheckRender();
	// 初始化模块
	obj.AdminPower  = AdminPower;
	obj.RepStatusCode = '';
	InitBase(obj);
	InitRep(obj);
	InitDiag(obj);
	InitOper(obj);
	InitLab(obj);
	InitAnt(obj);

	var wh = $(window).height();
	$("body").height(wh);
	$(window).resize(function(){
		 $("body").height(wh);
	});

	$("#LayerDiagBasis").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("#LayerDiagCourse").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
//	$("#divbody").mCustomScrollbar({
//		theme: "dark-thick",
//		axis: "y",
//		scrollInertia: 100
//	});
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("#LayerOpenINFOPSSync").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("#LayerOpenINFLabSync").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
//	$("LayerOpenINFLabEdit").mCustomScrollbar({
//		theme: "dark-thick",
//		axis: "y",
//		scrollInertia: 100
//	});
	$("#LayerOpenINFAntiSync").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$('body').css('overflow-y','hidden');
	$('body').css('overflow-x','hidden');
	InitReportWinEvent(obj);
	return obj;
}