//ҳ��Gui
function InitS800CssPosInf1Win(){
	var obj = new Object();
    var HospID=$.LOGON.HOSPID;
    obj.repName = "DHCHAI.STAT.S800CssPosInf1.raq";
	
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("cboHospital");  //��Ⱦ������
	// Ĭ�ϼ��ص�¼Ժ��
	$.form.SetValue("cboHospital",$.LOGON.HOSPID,$.LOGON.HOSPDESC);
	
    //���ÿ�ʼ����Ϊ����1��
	/*
	var currDate = $.form.GetCurrDate('-');
	var arrDate = currDate.split('-');
	var dateFrom = arrDate[0] + "-" + arrDate[1] + "-01"
    //$.form.DateTimeRender('DateFrom',dateFrom);
    $.form.DateTimeRender('DateFrom',$.form.GetCurrDate('-'));
    */
	 $("#cboSurvNumber").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboSurvNumber");  //��Ⱦ������	
	//��select2��ֵchange�¼�
	$("#cboHospital").on("select2:select", function (e) { 
		//���ѡ�е�ҽԺ
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboSurvNumber").data("param",id);
		$.form.SelectRender("cboSurvNumber");  //��Ⱦ������
	});
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
   	
	InitS800CssPosInf1WinEvent(obj);
	return obj;
}