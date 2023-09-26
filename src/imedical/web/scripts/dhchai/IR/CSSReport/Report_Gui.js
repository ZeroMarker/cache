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
	// 渲染checkbox
	$.form.CheckBoxRender();
	$.form.iCheckRender();
	$.form.SelectRender('cboIRInfectionDr');
	$.form.SelectRender('cboInfCategoryDr');
	$.form.SelectRender('cboCSSDiagnos');
	$.form.SelectRender('cboYYInfPos11');
	$.form.SelectRender1('cboYYBacteria11',1);
	$.form.SelectRender('cboYYMDR11');
	$.form.SelectRender1('cboYYBacteria12', 1);
	$.form.SelectRender('cboYYMDR12');
	$.form.SelectRender1('cboYYBacteria13',1);
	$.form.SelectRender('cboYYMDR13');
	
	$.form.SelectRender('cboYYInfPos21');
	$.form.SelectRender1('cboYYBacteria21',1);
	$.form.SelectRender('cboYYMDR21');
	$.form.SelectRender1('cboYYBacteria22', 1);
	$("#cboYYBacteria22").attr("disabled", "disabled");
	$.form.SelectRender('cboYYMDR22');
	$.form.SelectRender1('cboYYBacteria23',1);
	$.form.SelectRender('cboYYMDR23');
	
	$.form.SelectRender('cboYYInfPos31');
	$.form.SelectRender1('cboYYBacteria31',1);
	$.form.SelectRender('cboYYMDR31');
	$.form.SelectRender1('cboYYBacteria32',1);
	$.form.SelectRender('cboYYMDR32');
	$.form.SelectRender1('cboYYBacteria33',1);
	$.form.SelectRender('cboYYMDR33');

	$.form.SelectRender('cboCSSOperLung');
	$.form.SelectRender('cboSQInfPos11');
	$.form.SelectRender1('cboSQBacteria11',1);
	$.form.SelectRender('cboSQMDR11');
	$.form.SelectRender1('cboSQBacteria12',1);
	$.form.SelectRender('cboSQMDR12');
	$.form.SelectRender1('cboSQBacteria13',1);
	$.form.SelectRender('cboSQMDR13');
	
	$.form.SelectRender('cboSQInfPos21');
	$.form.SelectRender1('cboSQBacteria21',1);
	$.form.SelectRender('cboSQMDR21');
	$.form.SelectRender1('cboSQBacteria22',1);
	$.form.SelectRender('cboSQMDR22');
	$.form.SelectRender1('cboSQBacteria23',1);
	$.form.SelectRender('cboSQMDR23');
	
	$.form.SelectRender('cboSQInfPos31');
	$.form.SelectRender1('cboSQBacteria31',1);
	$.form.SelectRender('cboSQMDR31');
	$.form.SelectRender1('cboSQBacteria32',1);
	$.form.SelectRender('cboSQMDR32');
	$.form.SelectRender1('cboSQBacteria33',1);
	$.form.SelectRender('cboSQMDR33');
	$.form.SelectRender('cboCSSIncisionr');
	$.form.DateTimeRender('OperDate',$.form.GetCurrDate('-'));
	$.form.SelectRender2('cboCSSAntiName',1);
	$.form.SelectRender('cbgAntiSen11');
	$.form.SelectRender('cbgAntiSen12');
	$.form.SelectRender('cbgAntiSen21');
	$.form.SelectRender('cbgAntiSen22');
	$.form.SelectRender('cbgAntiSen31');
	$.form.SelectRender('cbgAntiSen32');
	$.form.SelectRender('cbgAntiSen41');
	$.form.SelectRender('cbgAntiSen42');
	$.form.SelectRender('cbgAntiSen51');
	$.form.SelectRender('cbgAntiSen61');
	$.form.SelectRender('cbgAntiSen62');
	$.form.SelectRender('cbgAntiSen63');
	$.form.SelectRender('cbgAntiSen71');
	$.form.SelectRender('cbgAntiSen72');
	$.form.SelectRender('cbgAntiSen73');
	$.form.SelectRender('cbgAntiSen81');
	$.form.SelectRender('cbgAntiSen82');
	$.form.SelectRender('cbgAntiSen83');
	$.form.SelectRender('cbgAntiSen84');
	$.form.SelectRender('cbgAntiSen85');
	$.form.SelectRender('cbgAntiSen86');
	$.form.SelectRender('cbgAntiSen91');
	$.form.SelectRender('cbgAntiSen92');
	$.form.SelectRender('cboCSSMedPurpose');
	$.form.SelectRender('cboCSSCombinedMed');
	// 初始化模块
	obj.AdminPower  = AdminPower;
	obj.RepStatusCode = '';
	InitOper(obj);
	InitBase(obj);
	InitRep(obj);
	//InitDiag(obj);
	//InitLab(obj);
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