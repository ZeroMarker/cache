/*
ģ��:		��ҩ��
��ģ��:		��ҩ��-����ǰ����
Creator:	hulihua
CreateDate:	2017-09-21
*/
$(function(){
	/* ��ʼ����� start*/
	//$("#date-daterange").dhcphaDateRange();
	var daterangeoptions = {
        timePicker: false,
        timePickerIncrement: 1,
        timePicker24Hour: true,
        timePickerSeconds: true,
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT		//+ ' HH:mm:ss'
        }
    };
    $('#date-start').dhcphaDateRange(daterangeoptions);
    $('#date-end').dhcphaDateRange(daterangeoptions);
	var startdate = FormatDateT("t") ;
	var enddate = FormatDateT("t") ;
    //var starttime = '00:00:00';
    //var endtime = '23:59:59';
    $('#date-start').data('daterangepicker').setStartDate(startdate);		// + ' ' + starttime
    $('#date-start').data('daterangepicker').setEndDate(startdate);			// + ' ' + starttime
    $('#date-end').data('daterangepicker').setStartDate(enddate);			// + ' ' + endtime
    $('#date-end').data('daterangepicker').setEndDate(enddate);				// + ' ' + endtime
    
	InitPhaWard(); 				//����
	InitGraPrescnoList();
    /* ��ʼ����� end*/
})

window.onload=function(){
	setTimeout("QueryBSealPre()",200);
}

//��ʼ�������������б�
function InitGraPrescnoList(){
	var columns=[
		{header:'TPhmbi',index:'TPhmbi',name:'TPhmbi',width:5,hidden:true},
		{header:'TOldWardLocDr',index:'TOldWardLocDr',name:'TOldWardLocDr',width:5,hidden:true},
		{header:'TAdmWardLocDr',index:'TAdmWardLocDr',name:'TAdmWardLocDr',width:5,hidden:true},
		{header:'�ѽҲ���',index:'TOldWardLoc',name:'TOldWardLoc',width:100},
		{header:'�²���',index:'TAdmWardLoc',name:'TAdmWardLoc',width:100},
	    {header:'סԺ��',index:'TPatCardNo',name:'TPatCardNo',width:50},
	    {header:'�ǼǺ�',index:'TPatNo',name:'TPatNo',width:50},
		{header:'����',index:'TPatName',name:'TPatName',width:60},
		{header:'��λ',index:'TBed',name:'TBed',width:30},
		{header:'������',index:'TPrescNo',name:'TPrescNo',width:60},
		{header:'����',index:'TActUncovMedPocNum',name:'TActUncovMedPocNum',width:30,align:'right'},
		{header:'��ҩ��',index:'TBrothDispUser',name:'TBrothDispUser',width:60},
		{header:'��ҩʱ��',index:'TActUncovMedDate',name:'TActUncovMedDate',width:80},
	];
	 var jqOptions={
		colModel: columns, //��
		url:LINK_CSP+'?ClassName=web.DHCINPHA.HMBSealReCheck.BSealReCheckQuery&MethodName=GetBSealPrescnoList',
		multiselect: true,
		shrinkToFit:false,		
		rownumbers: true,	//�Ƿ���ʾ�к�
		height:GridCanUseHeight(2)+34,
	    pager: "#jqGridPager", 	//��ҳ�ؼ���id  
	    shrinkToFit:false,
	} 
   //����datagrid	
   $('#grid-bsealchprelist').dhcphaJqGrid(jqOptions);
}

///��ѯ
function QueryBSealPre()
{
	/*
	var daterange=$("#date-daterange").val(); 
	daterange=FormatDateRangePicker(daterange); 
 	var startdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];
	*/
	var startdate = $('#date-start').val();
    var enddate = $('#date-end').val();
	var wardloc=$('#sel-phaward').val();
	if (wardloc==null){wardloc=""};
	var params=startdate+"^"+enddate+"^"+wardloc;
	$("#grid-bsealchprelist").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

///ȷ�Ͻ���
function ConfirmReceive(){
	var selectids=$("#grid-bsealchprelist").jqGrid('getGridParam','selarrrow');
	if ((selectids=="")||(selectids==null)){
		dhcphaMsgBox.alert("����ѡ����Ҫ���˵Ĵ�����¼");
		return;
	}
	
	var ListDataStr="";
	$.each(selectids,function(){
		var rowdata = $('#grid-bsealchprelist').jqGrid('getRowData',this);
		var Phmbi=rowdata.TPhmbi;
		if(ListDataStr==""){
			ListDataStr=Phmbi;	
		}else{
			ListDataStr=ListDataStr+"&&"+Phmbi;
		}
	})
	
	var RetResult=tkMakeServerCall("web.DHCINPHA.HMBSealReCheck.BSealReCheckQuery","SaveBSealPre",ListDataStr);
	var RetCode=RetResult.split("^")[0];
	var RetMessage=RetResult.split("^")[1];
	if(RetCode!=0){
		dhcphaMsgBox.alert("����ʧ�ܣ�"+RetMessage);
		return;
	}else{
		dhcphaMsgBox.alert("���˳ɹ���");
		QueryBSealPre();
	}
}

///���
function ClearConditions(){	
	//�����ڿؼ�����ʼ��ֵ��
	//$("#date-daterange").data('daterangepicker').setStartDate(new Date());
	//$("#date-daterange").data('daterangepicker').setEndDate(new Date());
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("t"));
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("t"));
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("t"));
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("t"));
	$("#sel-phaward").empty();
	$('#grid-bsealchprelist').clearJqGrid();
}