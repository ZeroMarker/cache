//ҳ��Gui
function InitCtlResultWin(){
	var obj = new Object();
    obj.ResultID="";
	
	var datevalue=$.form.MonthRender('DateFrom',$.form.GetCurrDate('-').substr(0,7));
	
	//��ʼ���߶�
	var wh = $(window).height();
    $("#divMain").height(wh);
	//����Ӧ�߶�
	$(window).resize(function(){
		var wh = $(window).height();
		$("#divMain").height(wh);
	});

	$("#divMain").mCustomScrollbar({
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
	obj.loadEvent()
	return obj;
}