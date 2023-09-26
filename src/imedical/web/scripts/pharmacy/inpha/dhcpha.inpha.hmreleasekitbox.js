/*
ģ��:		��ҩ��
��ģ��:		��ҩ��-��ҩ�䷢��
Creator:	hulihua
CreateDate:	2018-01-11
*/
var userlogisticsid="";		//ȡҩ��ʿ����
var SendVoiceStr="";
DhcphaTempBarCode="";
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
	InitReleaKitBoxList();
	InitTakeDrugUserModal();
    /* ��ʼ����� end*/
    
    //������Ա���Żس������¼�
	$('#txt-userlogistics').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			SetLogisticsInfo();	 
		}     
	});
	
	//��ҩ��Żس�������ѯ�¼�
	$('#txt-phboxno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			SetBarCodeSta();
			$('#txt-phboxno').val("");
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
    
    //δɨ����ѷ��Ż���
    $("#chk-dispbox").on("ifChanged",function(){
		if ($('#chk-dispbox').is(':checked')) { 
	    	$('#chk-noscan').iCheck('uncheck');
	    }
		QueryRelkitbox();
	})
	
	$("#chk-noscan").on("ifChanged",function(){
		if ($('#chk-noscan').is(':checked')) { 
	    	$('#chk-dispbox').iCheck('uncheck');
	    }
		QueryRelkitbox();
	})
	
	document.onkeydown=OnKeyDownHandler;
})

window.onload=function(){
	setTimeout("$(window).focus()",100);
}

//ɨ��������Ա����֮����֤�Լ�������
function SetLogisticsInfo(){
	var userlogisticsno=$.trim($("#txt-userlogistics").val());
	userlogisticsid="";
	$('#userlogistics').text("");
	if (userlogisticsno!=""){
		var defaultinfo=tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod","GetUserDefaultInfo",userlogisticsno);
		if (defaultinfo==null||defaultinfo==""){
			dhcphaMsgBox.alert("���빤���������ʵ!");
			$('#txt-userlogistics').val("");
			return;	
		}
		var ss=defaultinfo.split("^");
		userlogisticsid=ss[0];
		$('#userlogistics').text(ss[2]);
		$('#txt-userlogistics').val("");				
	}
}

//��ʼ��������ҩ���б�
function InitReleaKitBoxList(){
	var columns=[
		{header:'TPhboxId',index:'TPhboxId',name:'TPhboxId',width:5,hidden:true},
		{header:'���ղ���',index:'TLocDesc',name:'TLocDesc',width:100,align:'left'},
		{header:'���',index:'TPhBoxNo',name:'TPhBoxNo',width:80},
	    {header:'����',index:'TPhBoxNum',name:'TPhBoxNum',width:30},
	    {header:'װ����',index:'TUserCreate',name:'TUserCreate',width:80},
		{header:'װ������',index:'TDateCreate',name:'TDateCreate',width:100},
		{header:'������',index:'TUserPhHand',name:'TUserPhHand',width:80},
		{header:'��������',index:'TDatePhHand',name:'TDatePhHand',width:100},
		{header:'������',index:'TUserLogistics',name:'TUserLogistics',width:80},
		{header:'ҩ�䵱ǰ״̬',index:'TPhbStatus',name:'TPhbStatus',width:60},
		{header:'��ע',index:'TRemark',name:'TRemark',width:80,hidden:true},
	];
	 var jqOptions={
		colModel: columns, //��
		url:LINK_CSP+'?ClassName=web.DHCINPHA.MTBinBox.BinBoxQuery&MethodName=GetLeaseKitBoxList',
		multiselect: false,
		shrinkToFit:false,		
		rownumbers: true,	//�Ƿ���ʾ�к�
		height:GridCanUseHeight(2)+40,
	    pager: "#jqGridPager", 	//��ҳ�ؼ���id  
	    shrinkToFit:false,
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#grid-releasekitboxlist").clearJqGrid();
			}
		}
	} 
   //����datagrid	
   $('#grid-releasekitboxlist').dhcphaJqGrid(jqOptions);
}

///��ѯ
function QueryRelkitbox()
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
	var barcode=$.trim($('#txt-phboxno').val());
	var dispboxflag="N";
	if($("#chk-dispbox").is(':checked')){
		dispboxflag="Y";
	}	
	var scanflag="N"
	if($("#chk-noscan").is(':checked')){
		scanflag="Y";
	}
	var params=startdate+"^"+enddate+"^"+wardloc+"^"+gLocId+"^"+dispboxflag+"^"+scanflag+"^"+barcode;
	$("#grid-releasekitboxlist").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

//������Աѡ��
function InitTakeDrugUserModal(){
	$("#btn-userlogistics-sure").on("click",function(){
		if ((userlogisticsid=="")||(userlogisticsid==null)){
			dhcphaMsgBox.alert("������Ա����Ϊ�գ���ɨ�������˹���!");
			return;
		}
		$("#modal-userlogistics").modal('hide');
		var dispoptions={
			userlogisticsid:userlogisticsid
		}
		ExecuteDisp(dispoptions);
	});	
}

///���ſ�ʼ
function ConfirmDisp(){
	var thisrecords=$("#grid-releasekitboxlist").getGridParam('records');
	if (thisrecords==0){
		dhcphaMsgBox.alert("����ɨ����Ҫ���ŵĽ�ҩ�䣡");
		return;
	}	
	var thisrecords=$("#grid-releasekitboxlist").getGridParam('records');
	if (thisrecords>0){
	    var ids = $("#grid-releasekitboxlist").getDataIDs();
	    for(var i=1;i<ids.length+1;i++){	
			var tmpselecteddata=$("#grid-releasekitboxlist").jqGrid('getRowData',i);
			var tmpphbstatus=tmpselecteddata["TPhbStatus"];
			if(tmpphbstatus=="��ҩ���ѷ���") {
				dhcphaMsgBox.alert("�б������ѷ��ŵĽ�ҩ�䣬���ʵ��");
				return;
			}else if(tmpphbstatus=="�������"){
				dhcphaMsgBox.alert("�б�����δɨ��Ľ�ҩ�䣬���ʵ��");
				return;
			}else if(tmpphbstatus=="�����������"){
				dhcphaMsgBox.alert("�б������ѽ�����ɵĽ�ҩ�䣬���ʵ��");
				return;
			}
	    }
	}
	
	$('#modal-userlogistics').modal('show');
	userlogisticsid="";
	$('#userlogistics').text("");
	var timeout=setTimeout(function () {
		$(window).focus();
	    if (CheckTxtFocus()!=true){ 
			$("#txt-userlogistics").focus();
			return true;  
		} 
    },500);
}

///ȷ�Ϸ���
function ExecuteDisp(dispoptions){
	var userlogisticsid=dispoptions.userlogisticsid;
	var phboxidstr="";
	var thisrecords=$("#grid-releasekitboxlist").getGridParam('records');
	if (thisrecords>0){
	    var ids = $("#grid-releasekitboxlist").getDataIDs();
	    for(var i=1;i<ids.length+1;i++){	
			var tmpselecteddata=$("#grid-releasekitboxlist").jqGrid('getRowData',i);
			var tmpphboxid=tmpselecteddata["TPhboxId"]; 
			if(phboxidstr==""){
				phboxidstr=tmpphboxid;
			}else{
				phboxidstr=phboxidstr+"&&"+tmpphboxid;
			}
	    }
	}
	var ret=tkMakeServerCall("web.DHCINPHA.MTBinBox.BinBoxQuery","SaveDispBoxData",phboxidstr,gUserID,userlogisticsid,gLocId);
	if(ret!=0){
		if(ret==-1){
			dhcphaMsgBox.alert("������Ϊ�գ����ʵ!");
			return;	
		}else if(ret==-2){
			dhcphaMsgBox.alert("������ԱΪ�գ����ʵ!");
			return;
		}else{
			dhcphaMsgBox.alert("����ʧ��"+ret);
			return;
		}
	}else{
		dhcphaMsgBox.alert("���ųɹ���");
		QueryRelkitbox();
	}
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
	$('#chk-noscan').iCheck('uncheck');
	$('#chk-dispbox').iCheck('uncheck');
	$("#txt-phboxno").val("");
	$("#sel-phaward").empty();
	$('#grid-releasekitboxlist').clearJqGrid();
}

function RePrint(){
	var selectid = $("#grid-releasekitboxlist").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-releasekitboxlist").jqGrid('getRowData', selectid);
	var phboxid=selrowdata.TPhboxId;
	if ((phboxid=="")||(phboxid==null)){
		dhcphaMsgBox.alert("����ѡ����Ҫ����Ľ�ҩ�䣡");
		return;
	}
	PrintHmPhBoxLabelL(phboxid,"1")		//��ӡ����ǩ	
}

///ɨ����״̬
function SetBarCodeSta(){
	var barcode=$.trim($('#txt-phboxno').val());
	$("#txt-phboxno").val("");
	var ret=tkMakeServerCall("web.DHCINPHA.MTBinBox.BinBoxQuery","SaveBoxBarData",barcode);
	if(ret==-1){
		SendVoiceStr="����Ϊ��";
		SendVocie(SendVoiceStr);
		return;	
	}else if(ret==-2){
		SendVoiceStr="�ý�ҩ����������";
		SendVocie(SendVoiceStr);
		return;
	}else if(ret==-3){
		SendVoiceStr="��������״̬ʧ��";
		SendVocie(SendVoiceStr);
		return;
	}else{
		SendVoiceStr=ret;
		SendVocie(SendVoiceStr);
		QueryRelkitbox();
	}
}

function CheckTxtFocus(){
	var txtfocus1=$("#txt-userlogistics").is(":focus");
	var txtfocus2=$("#txt-phboxno").is(":focus");
	if ((txtfocus1!=true)&&(txtfocus2!=true)){
		return false;
	}
	return true;	
}

//����keydown,���ڶ�λɨ��ǹɨ����ֵ
function OnKeyDownHandler(){
	if (CheckTxtFocus()!=true){
		if (event.keyCode==13){
			var BarCode=tkMakeServerCall("web.DHCST.Common.JsonObj","GetData",DhcphaTempBarCode);
			$("#txt-phboxno").val(BarCode);
			SetBarCodeSta();
			DhcphaTempBarCode="";
		}else{
			DhcphaTempBarCode+=String.fromCharCode(event.keyCode);
		}
	}
}