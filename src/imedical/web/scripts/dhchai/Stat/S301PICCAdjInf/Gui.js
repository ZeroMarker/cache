//ҳ��Gui
function InitS210OpPosInfWin(){
	var obj = new Object();
    var HospID=$.LOGON.HOSPID;
    
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("cboHospital");  //��Ⱦ������
	// Ĭ�ϼ��ص�¼Ժ��
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
	     fontAwesome:true    //��ʾ����ͼ��
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
	     fontAwesome:true    //��ʾ����ͼ��
	});
	var dateNow = new Date();
	var year = dateNow.getFullYear();
	var month = dateNow.getMonth();
	month++;
	if(month<10) month = '0'+month;
	$("#DateFrom").val(year+'-'+month);
	$("#DateTo").val(year+'-'+month);	
    
    
	//��ʼ���߶�
	var wh = $(window).height();
    $("#divLeft").height(wh-10);
    $("#divMain").height(wh-11);
	$("#divPanel").height(wh-65);
	//����Ӧ�߶�
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