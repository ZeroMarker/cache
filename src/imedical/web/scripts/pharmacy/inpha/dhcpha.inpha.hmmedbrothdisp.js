/*
ģ��:		��ҩ��
��ģ��:		��ҩ��-��������
Creator:	dinghongying
CreateDate:	2017-08-03
*/
DhcphaTempBarCode="";
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
       
	InitPhaLoc(); 				//ҩ������
	InitMedBatNo();				//��ҩ����
	InitPhaWard();
	InitWardList();  
	InitPrescList();
    /* ��ʼ����� end*/
    
    $('#txt-label').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			GetLableMedBroth();	 
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
	setTimeout("QueryGridMedWard()",500);
}

//��ʼ����ҩ����
function InitMedBatNo(){
	var data = [
	 { id: 1, text: '��һ��' },
	 { id: 2, text: '�ڶ���' }
	 ];
	var selectoption={
	  data: data,
      width:'8em',
      allowClear:false,
      minimumResultsForSearch: Infinity
	};
	$("#sel-medbatno").dhcphaSelect(selectoption);			
}

function FindBroDisp(){
	var lnk="dhcpha/dhcpha.inpha.hmalrbrodispquery.csp";
	websys_createWindow(lnk,"�ѽ�ҩ��ѯ","width=95%,height=75%")	
}

//��ʼ�������б�
function InitWardList(){
	//����columns
	var columns=[
			{header:'TPid',index:'TPid',name:'TPid',width:30,hidden:true},
			{header:'TWardLocId',index:'TWardLocId',name:'TWardLocId',width:200,hidden:true},
			{header:'����',index:'TWardLoc',name:'TWardLoc',width:250,align:'left'}
         ];  
         
    var jqOptions={
	    colModel: columns, //��
		url:LINK_CSP+'?ClassName=web.DHCINPHA.HMMedBroth.MedBrothDispQuery&MethodName=GetMedBrothWardList',
	    recordtext:"",
	    pgtext:"",
	    height:GridCanUseHeight(1)-40,
	    shrinkToFit:false,
	    rownumbers: true,
	    onSelectRow:function(id,status){
			SelectQueryBroth();
		},
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#grid-wardlist").clearJqGrid();
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
		
	};
   //����datagrid	
   $('#grid-wardlist').dhcphaJqGrid(jqOptions);
}

//��ʼ�������б�
function InitPrescList(){
		var columns=[
		{name:'TSelect',index:'TSelect',header:'<a id="TDispSelect" href="#" onclick="SetSelectAll()">ȫѡ</a>',
			width:35,
			editable: true,
			align: 'center',
			edittype: 'checkbox',
			formatter: "checkbox",
			formatoptions: { disabled: false }
		},
		{header:'TPhmbi',index:"TPhmbi",name:"TPhmbi",width:30,hidden:true},
		{header:'TPhmbID',index:"TPhmbID",name:"TPhmbID",width:30,hidden:true},
		{header:'Ӧ��ҩ����',index:"TUncovMedDate",name:"TUncovMedDate",width:50},
		{header:'ȫ��',index:'TAllSendStat',name:'TAllSendStat',width:40,formatter: statusFormatter,title:false},
		{header:'Ӧ�Ҵ���',index:"TUncovMedPocNum",name:"TUncovMedPocNum",width:40},
		{header:'����',index:"TPatName",name:"TPatName",width:60},
		{header:'����',index:'TBed',name:'TBed',width: 40},
		{header:'�Ա�',index:"TPatSex",name:"TPatSex",width:30},
		{header:'�ǼǺ�',index:"TPatNo",name:"TPatNo",width:60},
		{header:'������',index:"TPrescNo",name:"TPrescNo",width:60},
		{header:'�����',index:"TBarCode",name:"TBarCode",width:70},
		{header:'ԭ����',index:"TOldWardLoc",name:"TOldWardLoc",width:100,align:'left'},
		{header:'TAllSendFlag',index:"TAllSendFlag",name:"TAllSendFlag",width:20,hidden:true}
	]; 
	var jqOptions={
	    colModel: columns, //��
		url:LINK_CSP+'?ClassName=web.DHCINPHA.HMMedBroth.MedBrothDispQuery&MethodName=GetWardLocMedBrothList',
	    recordtext:"",
	    pgtext:"",
	    height:GridCanUseHeight(1)-40,
	    multiselect:false,
	    shrinkToFit:false,
	    rowNum:200,
	    rownumbers: true,
		loadComplete: function(){ 
			$("#TDispSelect").text("ȫѡ");
	    	$('input[type=checkbox][name=dhcphaswitch]').bootstrapSwitch({  
		        onText:"��",  
		        offText:"��",  
		        onColor:"success",  
		        offColor:"default",  
		        size:"small",  
		        onSwitchChange:function(event,state){  
		        	var ret=ChangeWinStat(state);
		        	if (ret==false){
			        	$(this).bootstrapSwitch('state',!state,true);
			        }
		        }
		    }) 

		}
		
	};
   //����datagrid	
   $('#grid-patpresclist').dhcphaJqGrid(jqOptions);
}

function statusFormatter(cellvalue, options, rowdata){
	if (cellvalue=="��"){
		return '<input name="dhcphaswitch" type="checkbox" checked> ' 
	}else{
		return '<input name="dhcphaswitch" type="checkbox" unchecked> ' 
	}   
}

function ChangeWinStat(state){
	var wintd = $(event.target).closest("td");
	var rowid=$(wintd).closest("tr.jqgrow").attr("id");
	var allSendStat="";
	if (state==true){
		allSendStat="1";
	}else{
		allSendStat="";
	}
    var newdata={
    	TAllSendFlag:allSendStat 
    };
    $("#grid-patpresclist").jqGrid('setRowData',rowid,newdata);
	return true;
}

function SetSelectAll(){
	var tmpSelectFlag="";
	if($("#TDispSelect").text()=="ȫѡ"){
		$("#TDispSelect").text("ȫ��");
		tmpSelectFlag="Y";
	}else{
		$("#TDispSelect").text("ȫѡ");
		tmpSelectFlag="N";
	}
	var thisrecords=$("#grid-patpresclist").getGridParam('records');
	if (thisrecords>0){
	     var ids = $("#grid-patpresclist").getDataIDs();
	     for(var i=0;i<ids.length;i++){	
	     	var newdata={
		    	TSelect:tmpSelectFlag 
		    };
		    $("#grid-patpresclist").jqGrid('setRowData',i+1,newdata);	         
	     }
	}
}

//��ѯ�����Ҫ��ҩ�Ŀ����б�
function QueryGridMedWard(){
	KillDetailTmp();
	$("#grid-wardlist").jqGrid("clearGridData");
	$("#grid-patpresclist").jqGrid("clearGridData");
	var params=GetComCodtion();
	$("#grid-wardlist").setGridParam({
		page:1,
		datatype:'json',
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
	return true
}

//��ѯѡ�в�����Ҫ��ҩ����ϸ
function SelectQueryBroth(){
	var selectid = $("#grid-wardlist").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-wardlist").jqGrid('getRowData', selectid);
	var wardlocid=selrowdata.TWardLocId;
	var pid=selrowdata.TPid;
	var params=GetComCodtion()+"^"+wardlocid+"^"+pid;
	
	$("#grid-patpresclist").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
	
}

function ConfirmBroDisp(){
	var SendVoiceStr="";
	var thisrecords=$("#grid-patpresclist").getGridParam('records');
	if (thisrecords==0){
		SendVoiceStr="û����Ҫ��ҩ�ļ�¼"
		SendVocie(SendVoiceStr);
		return false;
	}
	var medbatno=$('#sel-medbatno').val();
	if((medbatno=="")||(medbatno==null)){
		SendVoiceStr="����ѡ���ҩ����"
		SendVocie(SendVoiceStr);
		return false;
	}
	var allphmbistr="";
	if (thisrecords>0){
	    var ids = $("#grid-patpresclist").getDataIDs();
	    for(var i=0;i<ids.length;i++){	
			var rowdata = $('#grid-patpresclist').jqGrid('getRowData',i+1);
			var select=rowdata.TSelect;
			if(select=="No"){
				continue;	
			}
			var phmbi=rowdata.TPhmbi;
			var allSendStat=rowdata.TAllSendFlag;
			var actCovMedPocNum=rowdata.TUncovMedPocNum
			var remark="";
			var phmbistr=phmbi+"^"+allSendStat+"^"+actCovMedPocNum+"^"+remark+"^"+medbatno;	
			if(allphmbistr==""){
				allphmbistr=phmbistr;
			}else{
				allphmbistr=allphmbistr+"&&"+phmbistr;
			}         
		}
		if (allphmbistr==""){
			var SendVoiceStr="����ѡ����Ҫ��ҩ�ļ�¼"
			SendVocie(SendVoiceStr);
			return false;
		}
	}
	var ret=tkMakeServerCall("web.DHCINPHA.HMMedBroth.MedBrothDispQuery","SavaBrothDisp",allphmbistr,gUserID);
	if(ret==-1){
		SendVoiceStr="��ҩ��Ϣ������"
		SendVocie(SendVoiceStr);
		//dhcphaMsgBox.message("��ҩ��Ϣ������")
		dhcphaMsgBox.alert("��ҩ��Ϣ������");
		return false;
	}else if(ret=="-2"){
		SendVoiceStr="�ô����ѽ�ҩ"
		SendVocie(SendVoiceStr);
		//dhcphaMsgBox.message("�ô����ѽ�ҩ")
		dhcphaMsgBox.alert("�ô����ѽ�ҩ");
		return false;
	}else if(ret<0){
		SendVoiceStr="��ҩʧ��,"+ret
		SendVocie(SendVoiceStr);
		//dhcphaMsgBox.message("��ҩʧ��!������룺"+ret)
		dhcphaMsgBox.alert("��ҩʧ��!������룺"+ret);
		return false;
	}else{
		//dhcphaMsgBox.message("��ҩ�ɹ���")
		dhcphaMsgBox.alert("��ҩ�ɹ���");
		SendVoiceStr="��ʼ��һ������";
		SendVocie(SendVoiceStr);
	}
	$("sel-phaward").empty();
	var select2option = '<option value='+"'"+""+"'"+'selected>'+""+'</option>'
	$("#sel-phaward").append(select2option);
	SelectQueryBroth();
	return false;
}

//��ȡ����Ĺ���������Ϣ
function GetComCodtion(){
	/*
	var daterange=$("#date-daterange").val(); 
	daterange=FormatDateRangePicker(daterange);
	var stdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];
	*/
	var stdate = $('#date-start').val();
    var enddate = $('#date-end').val();
                           
	var phaloc=$('#sel-phaloc').val();
	var wardloc=$('#sel-phaward').val();
	if (wardloc==null){wardloc=""}
	var params=stdate+"^"+enddate+"^"+phaloc+"^"+wardloc;
	return params;
}

function GetLableMedBroth(){
	var SendVoiceStr="";
	DhcphaTempBarCode="";
	var barcode=$.trim($("#txt-label").val());
	if(barcode==""||barcode==null){
		return false;
	}
	var BarWardLocStr=tkMakeServerCall("web.DHCINPHA.HMMedBroth.MedBrothDispQuery","GetBarWardLoc",barcode);
	if(BarWardLocStr==""){
		SendVoiceStr="��������";
		SendVocie(SendVoiceStr);
		return false;	
	}
	var array=BarWardLocStr.split("^");
	var wardloc=$('#sel-phaward').val();
	$("#txt-label").val("");
	if(((wardloc=="")||(wardloc==null))&&(wardloc!=array[0])){
		var select2option = '<option value='+"'"+array[0]+"'"+'selected>'+array[1]+'</option>'
		$("#sel-phaward").append(select2option);
		QueryGridMedWard();
		return false;
	}
	var dispgridrows=$("#grid-patpresclist").getGridParam('records');
	var quitflag=0;
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$("#grid-patpresclist").jqGrid('getRowData',i);
		var tmpbarcode=tmpselecteddata["TBarCode"];
		if (tmpbarcode==barcode){
			quitflag=1;
			$("#grid-patpresclist").jqGrid('setSelection',i);
			var newdata={
		    	TSelect:"Y"
		    };
		    $("#grid-patpresclist").jqGrid('setRowData',i,newdata);
		    var tmpmedpocnum=tmpselecteddata["TUncovMedPocNum"];
		    var tmpallsendflag=tmpselecteddata["TAllSendFlag"];
		    if(tmpallsendflag=="1"){
				SendVoiceStr="ȫ��";    
			}else{
		    	SendVoiceStr=tmpmedpocnum+"��";
			}	
		    SendVocie(SendVoiceStr);
			return false;	
		}
	}
	if (quitflag==0){
		SendVoiceStr="�ô������ѽһ�Ǳ���������"
		SendVocie(SendVoiceStr);
		return false;
	}
}

function CheckTxtFocus(){
	var txtfocus=$("#txt-label").is(":focus");
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
				$("#txt-label").val(BarCode);
				GetLableMedBroth();
			}else if(BarCode=="9999999991"){
				ConfirmBroDisp();		//ȷ��			
			}else {
				var daterange=$("#date-daterange").val();
				daterange=FormatDateRangePicker(daterange);                       
				var stdate=daterange.split(" - ")[0];
				var type="";
				if(BarCode=="9999999992"){
					type="+1";			//��һ��	
				}else{
					type="-1";			//��һ��
				}
				var newdate=tkMakeServerCall("web.DHCINPHA.HMMedBroth.MedBrothDispQuery","GetBarDate",stdate,type);
				$("#date-daterange").data('daterangepicker').setStartDate(newdate);
				$("#date-daterange").data('daterangepicker').setEndDate(newdate);
				QueryGridMedWard();		
			}
			DhcphaTempBarCode="";
		}else{
			DhcphaTempBarCode+=String.fromCharCode(event.keyCode);
		}
	}
}

///�����ʱglobal
function KillDetailTmp(){
	var Pid="";
	if ($("#grid-wardlist").getGridParam('records')>0){
		var firstrowdata = $("#grid-wardlist").jqGrid("getRowData", 1);
		Pid=firstrowdata.TPid;
	}			
	if (Pid!=""){
		var killret=tkMakeServerCall("web.DHCINPHA.HMMedBroth.MedBrothDispQuery","KillDetailTmp",Pid);
	}
}

///�쳣�ر�
window.onbeforeunload = function (){
	KillDetailTmp();
}
