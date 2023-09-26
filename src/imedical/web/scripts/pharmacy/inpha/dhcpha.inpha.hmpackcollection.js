/*
ģ��:		��ҩ��
��ģ��:		��ҩ��-װ��ɼ�
Creator:	hulihua
CreateDate:	2018-01-15
*/
DhcphaTempBarCode="";
var SendVoiceStr="";

$(function(){
	/* ��ʼ����� start*/
	//$("#date-daterange").dhcphaDateRange();
	//�����ڿؼ�����ʼ��ֵ��
	//startdate=FormatDateT("t-3");
	//$("#date-daterange").data('daterangepicker').setStartDate(startdate);
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
	
	InitPhaWard(); 				//����
	InitMedBatNo();				//��ҩ����
	InitCollectDataList();
    /* ��ʼ����� end*/
    
    //������Ա���Żس������¼�
	$('#txt-userlogistics').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			SetLogisticsInfo();	 
		}     
	});
	
	//��ҩ��Żس�������ѯ�¼�
	$('#txt-barcode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			QueryCollectData();
			DhcphaTempBarCode="";	 
		}     
	});
	
    
    //�������лس��¼�
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	//�������а�ť�¼�
	$("button").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	});
		
	document.onkeydown=OnKeyDownHandler;
})

window.onload=function(){
	setTimeout("$(window).focus()",100);
}

//��ʼ����ҩ����
function InitMedBatNo(){
	var data = [
		{ id: 2, text: '�ڶ���' },
	 	{ id: 1, text: '��һ��' }
	 ];
	var selectoption={
	  data: data,
      width:'8em',
      allowClear:false,
      minimumResultsForSearch: Infinity
	};
	$("#sel-medbatno").dhcphaSelect(selectoption);			
}

//��ʼ���ɼ������б�
function InitCollectDataList(){
	var columns=[
		{header:'TphmbiId',index:'TphmbiId',name:'TphmbiId',width:5,hidden:true},
		{header:'����',index:'TWardLoc',name:'TWardLoc',width:120,align:'left'},
		{header:'�������',index:'TWardAbbr',name:'TWardAbbr',width:50,align:'left'},
		{header:'��������',index:'TPatName',name:'TPatName',width:100},
		{header:'������',index:'TPrescNo',name:'TPrescNo',width:80},
		{header:'��������',index:'TPreFormType',name:'TPreFormType',width:50},
		{header:'��ҩ����',index:'TBrothDate',name:'TBrothDate',width:60},
		{header:'����',index:'TActUnPocNum',name:'TActUnPocNum',width:50},
		{header:'�෽�ܹ���',index:'TOrPasJarNum',name:'TOrPasJarNum',width:60},
	    {header:'��ҩ��',index:'TBrothName',name:'TBrothName',width:80},
		{header:'��ҩ����',index:'TActBrothDate',name:'TActBrothDate',width:100},
		{header:'��ǰ״̬',index:'TBrothStatue',name:'TBrothStatue',width:60},
		{header:'��ע',index:'TRemark',name:'TRemark',width:80}
	];
	 var jqOptions={
		colModel: columns, //��
		url:LINK_CSP+'?ClassName=web.DHCINPHA.HMMedBroth.MedBrothDispQuery&MethodName=GetCollectDataList',
		multiselect: false,
		shrinkToFit:false,		
		rownumbers: true,	//�Ƿ���ʾ�к�
		height:GridCanUseHeight(2)+40,
	    pager: "#jqGridPager", 	//��ҳ�ؼ���id  
	    shrinkToFit:false,
		loadComplete: function(){
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				if(($('#txt-barcode').val())!=""){
					SendVoiceStr="��ҩ���ڽ�ҩ��";
					SendVocie(SendVoiceStr);
				}
				$("#grid-colldatalist").clearJqGrid();
			}else{
				if(($('#txt-barcode').val())!=""){
					ConfirmDisp();
				}
			}
			$("#txt-barcode").val("");
		}
	} 
   //����datagrid	
   $('#grid-colldatalist').dhcphaJqGrid(jqOptions);
}

///��ѯ
function QueryCollectData()
{
	$("#grid-colldatalist").jqGrid("clearGridData");
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
	var barcode=$('#txt-barcode').val();
	//��������ڽ�ҩ�����ڣ�����Ҫ�ռ����������Ľ�ҩ��Ϣ��
	//alert("barcode:"+barcode)
	if((barcode!="")&&(barcode!=null)){
		var ret=tkMakeServerCall("web.DHCINPHA.HMMedBroth.MedBrothDispQuery","SaveMedBrothNoData",barcode,gUserID,gLocId);
		if(ret!=0){
			if (ret=="-1"){
				SendVoiceStr="��������"
			}else if(ret=="-2"){
				SendVoiceStr="�ô���������"
			}else if(ret=="-3"){
				SendVoiceStr="�ô�����δ��ҩ"
			}else if(ret=="-4"){
				SendVoiceStr="�ô�����ҩ����"
			}else if(ret=="-5"){
				SendVoiceStr="�ô�����δ��ҩ"
			}else if(ret=="-6"){
				SendVoiceStr="�ô���δ��ҩ���"
			}else if(ret=="-7"){
				SendVoiceStr="�ñ�ǩ�Ѳɼ�"
			}else if(ret=="-8"){
				SendVoiceStr="�ô����Ѳɼ�"
			}else if(ret=="-9"){
				SendVoiceStr="�ô����Ǳ�Ժ������,���ʵ!"
			}else{
				SendVoiceStr="�ɼ�����ʧ��,"+ret
			}
			SendVocie(SendVoiceStr);
			return false;
		}
	}	
	var params=startdate+"^"+enddate+"^"+wardloc+"^"+gLocId+"^"+barcode;
	$("#grid-colldatalist").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

///ȷ���ռ�
function ConfirmDisp(){
	var MedBatNo=$('#sel-medbatno').val();
	if((MedBatNo=="")||(MedBatNo==null)){
		SendVoiceStr="����ѡ���ҩ����"
		SendVocie(SendVoiceStr);
		return false;
	}
	var ListDataStr="";
	var WardLoc="";
	var PatName="";
	var thisrecords=$("#grid-colldatalist").getGridParam('records');
	if (thisrecords>0){
	    var ids = $("#grid-colldatalist").getDataIDs();
	    for(var i=1;i<ids.length+1;i++){	
			var tmpselecteddata=$("#grid-colldatalist").jqGrid('getRowData',i);
			var tmpphmbiid=tmpselecteddata["TphmbiId"]; 
			if((WardLoc=="")||(PatName=="")){
				WardLoc=tmpselecteddata["TWardAbbr"];
				PatName=tmpselecteddata["TPatName"];
			}
			if(ListDataStr==""){
				ListDataStr=tmpphmbiid;
			}else{
				ListDataStr=ListDataStr+"&&"+tmpphmbiid;
			}
	    }
	}
	var ret=tkMakeServerCall("web.DHCINPHA.HMMedBroth.MedBrothDispQuery","SaveCollectData",ListDataStr,MedBatNo,gUserID);
	if(ret!=0){
		if(ret==-1){
			SendVoiceStr="����ѡ���ҩ����"
			SendVocie(SendVoiceStr);
		}else if(ret==-2){
			SendVoiceStr="ɨ�����벻����"
			SendVocie(SendVoiceStr);
		}else{
			SendVoiceStr="�ռ�����ʧ��"
			SendVocie(SendVoiceStr);
		}
	}else{
		SendVoiceStr=WardLoc;
		SendVocie(SendVoiceStr);
	}
	return false;
}

///���
function ClearConditions(){	
	//�����ڿؼ�����ʼ��ֵ��
	//$("#date-daterange").data('daterangepicker').setStartDate(FormatDateT("t-3"));
	//$("#date-daterange").data('daterangepicker').setEndDate(new Date());
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("t-3"));
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("t-3"));
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("t"));
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("t"));
	$("#sel-phaward").empty();	
	$("#txt-barcode").val("");
	$("#sel-medbatno").empty();
	InitMedBatNo();
    $('#grid-colldatalist').clearJqGrid();
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
			$("#txt-barcode").val(BarCode);
			QueryCollectData();
			DhcphaTempBarCode="";
		}else{
			DhcphaTempBarCode+=String.fromCharCode(event.keyCode);
		}
	}
}

function FindBroDisp(){
	var lnk="dhcpha/dhcpha.inpha.hmalrbrodispquery.csp";
	websys_createWindow(lnk,"�ѽ�ҩ��ѯ","width=95%,height=75%")	
}