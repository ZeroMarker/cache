/*
ģ��:		��ҩ��
��ģ��:		��ҩ��-��������ʿ����
Creator:	dinghongying
CreateDate:	2017-07-13
*/
$(function(){
	/* ��ʼ����� start*/
	/*
	$("#date-daterange").dhcphaDateRange();
	var tmpstartdate=FormatDateT("t-3")
	var tmpenddate=FormatDateT("t")
	$("#date-daterange").data('daterangepicker').setStartDate(tmpstartdate);
	$("#date-daterange").data('daterangepicker').setEndDate(tmpenddate);
	*/
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
	var startdate = FormatDateT("t-3") ;
	var enddate = FormatDateT("t") ;
    //var starttime = '00:00:00';
    //var endtime = '23:59:59';
    $('#date-start').data('daterangepicker').setStartDate(startdate);		// + ' ' + starttime
    $('#date-start').data('daterangepicker').setEndDate(startdate);			// + ' ' + starttime
    $('#date-end').data('daterangepicker').setStartDate(enddate);			// + ' ' + endtime
    $('#date-end').data('daterangepicker').setEndDate(enddate);				// + ' ' + endtime
	
	InitGraPrescnoList();
    /* ��ʼ����� end*/
    $("#chk-receive").on("ifChanged",function(){
		QueryPhacPre()
	})
	
	$('#txt-barcode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			GetLablePres();	 
		}     
	});
	
	//�������лس��¼�
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	});
	
	$("button").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	});
	
	document.onkeydown=OnKeyDownHandler;
})

window.onload=function(){
	setTimeout("QueryPhacPre()",500);
}

//��ʼ�������������б�
function InitGraPrescnoList(){
	var columns=[
		{header:'TPhac',index:'TPhac',name:'TPhac',width:5,align:'left',hidden:true},
	    {header:'סԺ��',index:'TPatMedNo',name:'TPatMedNo',width:50},
	    {header:'�ǼǺ�',index:'TPatNo',name:'TPatNo',width:50},
		{header:'����',index:'TPatName',name:'TPatName',width:60},
		{header:'��λ',index:'TBed',name:'TBed',width:30},
		{header:'������',index:'TPrescNo',name:'TPrescNo',width:60},
		{header:'��ҩ��ʽ',index:'TInstruc',name:'TInstruc',width:50},
		{header:'����',index:'TFacotor',name:'TFacotor',width:30,align:'right'},
		{header:'��ҩҩ��',index:'TPhaLoc',name:'TPhaLoc',width:60,align:'left'},
		{header:'��ҩ��',index:'TCollectUser',name:'TCollectUser',width:60},
		{header:'��ҩʱ��',index:'TCollectDate',name:'TCollectDate',width:80},
		{header:'������',index:'TAuditor',name:'TAuditor',width:60},
		{header:'����ʱ��',index:'TAuitDate',name:'TAuitDate',width:80}
	];
	 var jqOptions={
		colModel: columns, //��
		url:LINK_CSP+'?ClassName=web.DHCINPHA.HMNurseReceive.NurseReceiveQuery&MethodName=GetNurRecPrescnoList',
		multiselect: true,
		shrinkToFit:false,
		rownumbers:true,		//�Ƿ���ʾ�к�
		height:GridCanUseHeight(2)+34,
	    pager: "#jqGridPager", 	//��ҳ�ؼ���id  
	    shrinkToFit:false,
	} 
   //����datagrid	
   $('#grid-dispgrareceive').dhcphaJqGrid(jqOptions);
}

///��ѯ
function QueryPhacPre()
{
	/*
	var daterange=$("#date-daterange").val(); 
	daterange=FormatDateRangePicker(daterange); 
 	var startdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];
	*/
	var startdate = $('#date-start').val();
    var enddate = $('#date-end').val();
	var receive="N";
	if($("#chk-receive").is(':checked')){
		receive="Y";
	}
	var params=startdate+"^"+enddate+"^"+gWardID+"^"+receive;
	$("#grid-dispgrareceive").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

///ȷ�Ͻ���
function ConfirmReceive(){
	var selectids=$("#grid-dispgrareceive").jqGrid('getGridParam','selarrrow');
	if ((selectids=="")||(selectids==null)){
		dhcphaMsgBox.alert("����ѡ����Ҫ���յĴ�����¼");
		return;
	}
	
	var PhacStr="";
	$.each(selectids,function(){
		var rowdata = $('#grid-dispgrareceive').jqGrid('getRowData',this);
		var Phac=rowdata.TPhac;
		if(PhacStr==""){
			PhacStr=Phac;	
		}else{
			PhacStr=PhacStr+"^"+Phac;
		}
	})
	var params=PhacStr+"&&"+gUserID;
	var ret=tkMakeServerCall("web.DHCINPHA.HMNurseReceive.NurseReceiveQuery","SavaPhacNurseRevice",params);
	if(ret!=0){
		if(ret==-1){
			dhcphaMsgBox.alert("δѡ����Ҫ���յ���Ϣ�����ʵ!");
			return;	
		}else if(ret==-2){
			dhcphaMsgBox.alert("������Ϊ�գ����ʵ!");
			return;
		}else if(ret==-3){
			dhcphaMsgBox.alert("�ô����ѽ��գ����ʵ!");
			return;
		}else{
			dhcphaMsgBox.alert("��������"+ret);
			return;
		}
	}else{
		dhcphaMsgBox.alert("���ճɹ���");
		QueryPhacPre();
	}
}

///���
function ClearConditions(){	
	//�����ڿؼ�����ʼ��ֵ��
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("t-3"));
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("t-3"));
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("t"));
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("t"));
	$("#txt-barcode").val("");
	$("#chk-receive").iCheck("uncheck");
	$('#grid-dispgrareceive').clearJqGrid();
}

function GetLablePres(){
	DhcphaTempBarCode="";
	var barcode=$.trim($("#txt-barcode").val());
	if(barcode==""||barcode==null){
		return;
	}
	$("#txt-barcode").val("");
	var dispgridrows=$("#grid-dispgrareceive").getGridParam('records');
	var quitflag=0;
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$("#grid-dispgrareceive").jqGrid('getRowData',i);
		var tmpbarcode=tmpselecteddata["TPrescNo"];
		if (tmpbarcode==barcode){
			quitflag=1;
			$("#grid-dispgrareceive").jqGrid('setSelection',i);
			return;	
		}
	}
	if (quitflag==0){
		dhcphaMsgBox.alert("û����Ҫ���յĴ�����");
		return;
	}
}

function CheckTxtFocus(){
	var txtfocus=$("#txt-barcode").is(":focus");
	if (txtfocus!=true){
		return false;
	}
	return true;	
}

//����keydown,���ڶ�λɨ��ǹɨ����ֵ
function OnKeyDownHandler(){
	if (CheckTxtFocus()!=true){
		if (event.keyCode==13){
			var BarCode=tkMakeServerCall("web.DHCST.Common.JsonObj","GetData",DhcphaTempBarCode);
			if (BarCode.indexOf("I")>-1){
				$("#txt-barcode").val(BarCode);
				GetLablePres();
			}
			DhcphaTempBarCode="";
		}else{
			DhcphaTempBarCode+=String.fromCharCode(event.keyCode);
		}
	}
}