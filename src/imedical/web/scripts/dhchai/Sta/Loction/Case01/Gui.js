//ҳ��Gui
function InitCtlResultWin(){
	var obj = new Object();
    obj.ResultID="";
 
	//���ÿ�ʼ����Ϊ����1��
	var mydate = new Date($.form.GetCurrDate('-'));
	mydate.setDate(1);
	$.form.MonthRender('DateFrom',$.form.GetCurrDate('-').substr(0,7));
    $.form.MonthRender('DateTo',$.form.GetCurrDate('-').substr(0,7));
    
	//��ʼ���߶�
	var wh = $(window).height();
    $("#divLeft").height(wh-10);
    $("#divMain").height(wh);
	$("#divPanel").height(wh-65);
	//����Ӧ�߶�
	$(window).resize(function(){
		var wh = $(window).height();
		$("#divLeft").height(wh-10);
		$("#divMain").height(wh);
		$("#divPanel").height(wh-65);
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
    $("#divPanel").mCustomScrollbar({
		//scrollButtons: { enable: true },
		//autoHideScrollbar: true,
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});

	
	
	InitCtlResultWinEvent(obj);
	return obj;
}