//ҳ��Gui
function InitCSSHDM1Win(){
	var obj = new Object();
    var HospID=$.LOGON.HOSPID;
	//$("#cboLoc").data("param",HospID+"^^I^W^1");
	//$.form.SelectRender("cboLoc");  //��Ⱦ������
	//��ֵ��ʼֵ
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("cboHospital");  //��Ⱦ������
	// Ĭ�ϼ��ص�¼Ժ��
	$.form.SetValue("cboHospital",$.LOGON.HOSPID,$.LOGON.HOSPDESC);
	$("#cboSurvNumber").data("param",$.form.GetValue("cboHospital"));
	$.form.SelectRender("cboSurvNumber");
	//��select2��ֵchange�¼�
	$("#cboHospital").on("select2:select", function (e) { 
		//���ѡ�е�ҽԺ
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboSurvNumber").data("param",id);
		$.form.SelectRender("cboSurvNumber");  //��Ⱦ������	
	});	
	
    $.form.SelectRender("cboStatType");
    $.form.SelectRender("cboInfType");
    //$("#cboInfType option:selected").next().attr("selected", true);
	//$("#cboInfType").select2();
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
   	
	InitCSSHDM1WinEvent(obj);
	return obj;
}