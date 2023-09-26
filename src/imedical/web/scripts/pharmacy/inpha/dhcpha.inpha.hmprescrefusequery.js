/*
ģ��:		��ҩ��
��ģ��:		��ҩ��-�ܾ���ҩ��ѯ����
Creator:	pushaungcai
CreateDate:	2017-12-25
*/
$(function(){
	InitPhaConfig(); 
	/* ��ʼ����� start*/
	var daterangeoptions = {
        timePicker: true,
        timePickerIncrement: 1,
        timePicker24Hour: true,
        timePickerSeconds: true,
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT + " HH:mm:ss"
        }
    };
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
	InitPhaLoc(); 				//ҩ������
	InitPhaWard(); 				//����
	InitGridPrescList();		//��ʼ�������б�
	//�������лس��¼�
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	/* ��Ԫ���¼� end */
	InitBodyStyle();
})

function InitBodyStyle(){
	var wardtitleheight=$("#gview_grid-presclist .ui-jqgrid-hbox").height();
	var wardheight=DhcphaJqGridHeight(1,0)-wardtitleheight-10;
	var prescheight=DhcphaJqGridHeight(1,0)-15;
	var winWidth=$(window).width()
	var gridWidth=winWidth*0.5-22
	$("#grid-presclist").setGridWidth(gridWidth);
	$("#grid-presclist").setGridHeight(wardheight);
	$("#ifrm-presc").height(prescheight);
}

window.onload=function(){
	setTimeout("QueryInPhDispList()",500);
}

function InitPhaLoc(){
	var selectoption={
		minimumResultsForSearch: Infinity,
		allowClear:false,
		url:ChangeCspPathToAll(LINK_CSP)+"?ClassName=web.DHCSTPharmacyCommon&MethodName=GetPhaLocByGrp&style=select2&grpdr="+gGroupId,
	}
	$("#sel-phaloc").dhcphaSelect(selectoption)
	var select2option = '<option value='+"'"+gLocId +"'"+'selected>'+gLocDesc+'</option>'
	$("#sel-phaloc").append(select2option); 
}

//��ʼ��ҩ������
function InitPhaConfig(){
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: ChangeCspPathToAll(LINK_CSP)+"?ClassName=web.DHCSTPharmacyCommon&MethodName=GetInPhaConfig&locId="+gLocId, 
		data: "",
		success:function(value){   
			if (value!=""){
				SetPhaLocConfig(value)
			}   
		},    
		error:function(){        
			dhcphaMsgBox.alert("��ȡסԺҩ����������ʧ��!");
		}
	});
}
//����ҩ������
function SetPhaLocConfig(configstr){
	var configarr=configstr.split("^");
	var startdate=configarr[2];
	var enddate=configarr[3] ;
	startdate=FormatDateT(startdate);
	enddate=FormatDateT(enddate);
	$("#date-start").data('daterangepicker').setStartDate(startdate + " 00:00:00");
    $("#date-start").data('daterangepicker').setEndDate(startdate + " 00:00:00");
    $("#date-end").data('daterangepicker').setStartDate(enddate + ' 23:59:59');
    $("#date-end").data('daterangepicker').setEndDate(enddate + ' 23:59:59');
}

//��ʼ�������б�table
function InitGridPrescList(){
		var columns=[
		{name:"TCurWard",index:"TCurWard",header:'TCurWard',width:10,hidden:true},	
		{name:"TDodis",index:"TDodis",header:'TDodis',width:10,hidden:true},
		{name:"TWardDesc",index:"TWardDesc",header:'����',width:150,align:'left'},
		{name:"TCurBedcode",index:"TCurBedcode",header:'����',width:60},
		{name:"TPatNo",index:"TPatNo",header:'�ǼǺ�',width:100},
		{name:"TPatName",index:"TPatName",header:'����',width:80},
		{name:"TPrescNo",index:"TPrescNo",header:'������',width:120},
		{name:"TRefuseName",index:"TRefuseName",header:'�ܾ���',width:80},
		{name:"TDate",index:"TDate",header:'�ܾ�����',width:150},
		{name:"TReason",index:"TReason",header:'�ܾ�ԭ��',width:100}				
	]; 
	var params=GetMainCodParams();
	var jqOptions={
	    colModel: columns, //��
	    url: ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery&MethodName=RefuseDrugQuery', //��ѯ��̨	
	    height: DhcphaJqGridHeight(1,1)-35,
	    fit:true,
	    multiselect: false,
	    shrinkToFit:false,
	    rownumbers: true,
	    datatype:"local",
	    onSelectRow:function(id,status){
			QueryGridDispSub();
		},
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#ifrm-presc").attr("src","");
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
	};
	$('#grid-presclist').dhcphaJqGrid(jqOptions);
}
//��ѯ��ϸ����
function QueryInPhDispList(){
	var params=GetMainCodParams();
	var Ward=$('#sel-phaward').val();
	if(Ward==null) Ward="";
	params=params+"^"+Ward
	$("#grid-presclist").setGridParam({
			datatype:'json',
			page:1,
			postData:{
				'Params':params
			}
		}).trigger("reloadGrid");
	$("#ifrm-presc").empty();	//��ʼ������Ԥ��
	return true;
} 

//��ȡ��ѯ����
function GetMainCodParams(){
	var startdatetime = $("#date-start").val();
	var startdate = startdatetime.split(" ")[0];
	var sttime = startdatetime.split(" ")[1];
    var enddatetime = $("#date-end").val();
    var enddate = enddatetime.split(" ")[0];
    var entime = enddatetime.split(" ")[1];
	var phaloc=$('#sel-phaloc').val();
	if (phaloc==null){phaLoc=""}
	if (phaloc==""){
		dhcphaMsgBox.alert("ҩ��������Ϊ��!");
		return;
	}
	var params=startdate+"^"+sttime+"^"+enddate+"^"+entime+"^"+phaloc;
	return params;
}

//��ѯ��ҩ��ϸ
function QueryGridDispSub(){
	var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
	var prescno=selrowdata.TPrescNo;
    QueryPrescDetail(prescno);
}
function QueryPrescDetail(prescno)
{
	$("#ifrm-presc").empty();
	var htmlstr=GetPrescHtml(prescno);
	$("#ifrm-presc").append(htmlstr);
}

function GetPrescHtml(prescno)
{
	var cyflag="Y";
	var phartype="DHCINPHA";
	var paramsstr=phartype+"^"+prescno+"^"+cyflag;
	$("#ifrm-presc").attr("src",ChangeCspPathToAll("dhcpha/dhcpha.common.prescpreview.csp")+"?paramsstr="+paramsstr+"&PrtType=DISPPREVIEW");
}

//ȡ���ܾ�
function CancelRefuse(){
	var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
	if(selectid==null) {
		dhcphaMsgBox.alert("��ѡ��һ��������");
		return;
	}
	var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
	var PrescNo=selrowdata.TPrescNo;
	var Dodis=selrowdata.TDodis;
	var params=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID'];
	var ret=tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.SqlDbTrialDrugDisp","CancelRefuse",PrescNo,Dodis,params);
	if(ret==-2){
		dhcphaMsgBox.alert("�ü�¼�Ѿ�����ִ�л�ִֹͣ�У�����ȡ���ܾ���");
		return;
	}else if (ret<0)
	{
		dhcphaMsgBox.alert("ȡ���ܾ�ʧ�ܣ�");
		return;
	}else{
		dhcphaMsgBox.alert("ȡ���ܾ��ɹ���");
		}
	QueryInPhDispList();
	$("#ifrm-presc").empty();	//��ʼ������Ԥ��
}

window.onresize = InitBodyStyle;
