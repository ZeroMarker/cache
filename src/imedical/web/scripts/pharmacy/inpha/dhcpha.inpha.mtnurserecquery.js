/*
ģ��:		�ƶ�ҩ��
��ģ��:		�ƶ�ҩ��-������ǩ�ղ�ѯ
Creator:	hulihua
CreateDate:	2017-05-25
*/
$(function(){	
	/* ��ʼ����� start*/
	/*
	var daterangeoptions={
		timePicker : true, 
		timePickerIncrement:1,
		locale: {
			format: DHCPHA_CONSTANT.PLUGINS.DATEFMT+" HH:mm:ss"
		}
	}
	$("#date-daterange").dhcphaDateRange(daterangeoptions);
	*/
	
	var daterangeoptions = {
        timePicker: true,
        timePickerIncrement: 1,
        timePicker24Hour: true,
        timePickerSeconds: true,
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT + ' HH:mm:ss'
        }
    };
    $('#date-start').dhcphaDateRange(daterangeoptions);
    $('#date-end').dhcphaDateRange(daterangeoptions);
	var startdate = FormatDateT("t-3") ;
	var enddate = FormatDateT("t") ;
    var starttime = '00:00:00';
    var endtime = '23:59:59';
    $('#date-start').data('daterangepicker').setStartDate(startdate+ ' ' + starttime);
    $('#date-start').data('daterangepicker').setEndDate(startdate+ ' ' + starttime);
    $('#date-end').data('daterangepicker').setStartDate(enddate+ ' ' + endtime);			
    $('#date-end').data('daterangepicker').setEndDate(enddate+ ' ' + endtime);				
	
  	//�������лس��¼�
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	InitNurseRecList();

	$("#nurserecdg").closest(".panel-body").height(GridCanUseHeight(1)-26);	
	
})

//��ʼ����ʿ��ǩ���б�
function InitNurseRecList(){
	var columns=[
		{header:'TPhbID',index:'TPhbID',name:'TPhbID',width:30,hidden:true},
	    {header:'���',index:'TPhbNo',name:'TPhbNo',width:60},
		{header:'����',index:'TPhbNum',name:'TPhbNum',width:30},
		{header:'ҩ��������',index:'TUserPhHand',name:'TUserPhHand',width:60},
		{header:'ҩ����������',index:'TDatePhHand',name:'TDatePhHand',width:60},
		{header:'ҩ������ʱ��',index:'TTimePhHand',name:'TTimePhHand',width:60},
		{header:'������Ա',index:'TUserLogistics',name:'TUserLogistics',width:60},
		{header:'����������',index:'TUserWardHand',name:'TUserWardHand',width:60},
		{header:'������������',index:'TDateWardHand',name:'TDateWardHand',width:60},
		{header:'��������ʱ��',index:'TTimeWardHand',name:'TTimeWardHand',width:60},
		{header:'�����˶���',index:'TUserWardChk',name:'TUserWardChk',width:60},
		{header:'�����˶�����',index:'TDateWardChk',name:'TDateWardChk',width:60},
		{header:'�����˶�ʱ��',index:'TTimeWardChk',name:'TTimeWardChk',width:60}
	    
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.MTNurseReceive.NurseReceiveQuery&MethodName=GetWardNurseRecList',	
	    height:GridCanUseHeight(1)-36,
	    shrinkToFit:true
	};
	$("#nurserecdg").dhcphaJqGrid(jqOptions);
}

///ҩ��������ͳ�Ʋ�ѯ
function Query()
{
	var startdatetime = $('#date-start').val();
    var enddatetime = $('#date-end').val();
	var startdate=startdatetime.split(" ")[0];
	var starttime=startdatetime.split(" ")[1];
	var enddate=enddatetime.split(" ")[0];
	var endtime=enddatetime.split(" ")[1];
	var params=startdate+"^"+starttime+"^"+enddate+"^"+endtime+"^"+gLocId;
	$("#nurserecdg").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
		
}

//���
function ClearConditions(){
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("t-3")+" "+"00:00:00");
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("t-3")+" "+"00:00:00");
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("t")+" "+"23:59:59");
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("t")+" "+"23:59:59");
	$('#nurserecdg').clearJqGrid();
}