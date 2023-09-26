/*
 *ģ��:			��ҩ��
 *��ģ��:		��ҩ��-��ҩ��ȡ�Ǽ�
 *createdate:	2017-07-06
 *creator:		dinghongying
*/
DhcphaTempBarCode="";
var reguserid="";	//�Ǽ��˹���
$(function(){
	/* ��ʼ����� start*/
	var daterangeoptions={
		timePicker : true, 
		timePickerIncrement:1,
		locale: {
			format: DATEFMT
		}
	}
	$("#date-daterange").dhcphaDateRange(daterangeoptions);
	
	//�����ڿؼ�����ʼ��ֵ��
	var configstr=tkMakeServerCall("web.DHCSTPHALOC","GetPhaflag",gLocId);
	var configarr=configstr.split("^");
	var startdate=configarr[2];
	var enddate=configarr[3] ;
	startdate=FormatDateT(startdate);
	enddate=FormatDateT(enddate);
	$("#date-daterange").data('daterangepicker').setStartDate(startdate);
	$("#date-daterange").data('daterangepicker').setEndDate(enddate);
	
	InitGirdWardList();
	InitGirdPreList();
	
	/* ��Ԫ���¼� start*/
	//����ʧȥ���㴥���¼�
	$('#txt-cardno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			SetUserInfo();	 
		}     
	});
	
	$('#txt-label').on('keypress',function(event){
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
	
	$("#chk-register").on("ifChanged",function(){
		QueryGridRegWard();
	})
		
	document.onkeydown=OnKeyDownHandler;
})

//ɨ��������빤��֮����֤�Լ�������
function SetUserInfo(){
	DhcphaTempBarCode="";
	var cardno=$.trim($("#txt-cardno").val());
	$('#currentnurse').text("");
	$('#currentctloc').text("");
	$('#txt-cardno').val("");
	if (cardno!=""){
		var defaultinfo=tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod","GetUserDefaultInfo",cardno);
		if (defaultinfo==null||defaultinfo==""){
			dhcphaMsgBox.alert("���빤���������ʵ!");
			return;
		}
		var ss=defaultinfo.split("^");
		reguserid=ss[0];
		$('#currentnurse').text(ss[2]);
		$('#currentctloc').text(ss[4]);				
	}
	QueryGridRegWard();
	$("#txt-label").focus();
}

//��ʼ���ѷ����Ǽǲ����б�table
function InitGirdWardList(){
	var columns=[
		{header:'TWardId',index:'TWardId',name:'TWardId',width:30,hidden:true},
		{header:'����',index:'TWard',name:'TWard',width:160,align:'left'}
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery&MethodName=GetDurgRegWardList',	
	    height: TakeRegHeight(),
	    recordtext:"",
	    pgtext:"",
	    rownumbers: true,
	    shrinkToFit:false,
	    onSelectRow:function(id,status){
			QueryGridPreList();
		},loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				if(reguserid!=""){
					dhcphaMsgBox.alert("���ʵ�Ƿ�Ϊ��ʿ�Ĺ��Ż�û�ʿ���ڵĲ���û����Ҫ��ȡ�Ĵ���!");
				}
				$("#grid-wardlist").clearJqGrid();
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
		
	};
	$("#grid-wardlist").dhcphaJqGrid(jqOptions);
}

//��ʼ�������б�table
function InitGirdPreList(){
	var columns=[
		{header:'TPhac',index:'TPhac',name:'TPhac',width:10,hidden:true},
		{header:'���',index:'TCount',name:'TCount',width:30},
		{header:'״̬',index:'TStatue',name:'TStatue',width:50,cellattr: addCollStatCellAttr},
		{header:'������',index:'TPrescNo',name:'TPrescNo',width:80},
		{header:'�÷�',index:'TInstruc',name:'TInstruc',width:60},
		{header:'����',index:'TFactor',name:'TFactor',width:40},
		{header:'��ҩ��ʽ',index:'TCookType',name:'TCookType',width:60},
		{header:'��ע',index:'TNote',name:'TNote',width:40},
		{header:'�ǼǺ�',index:'TPatNo',name:'TPatNo',width:70},
		{header:'������',index:'TPameNo',name:'TPameNo',width:60},
		{header:'����',index:'TPatName',name:'TPatName',width:60},
		{header:'�Ա�',index:'TPatSex',name:'TPatSex',width:30},
		{header:'��ҩ��',index:'TCollectUserName',name:'TCollectUserName',width:60},
		{header:'��ҩ����',index:'TCollectDate',name:'TCollectDate',width:60},
		{header:'��ҩʱ��',index:'TCollectTime',name:'TCollectTime',width:60}
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery&MethodName=GetWardPrescnoList',	
	    height: TakeRegHeight(),
	    recordtext:"",
	    pgtext:"",
	    rownumbers: true,
	   	multiselect: true,
	    shrinkToFit:false,
		
	};
	$("#grid-presclist").dhcphaJqGrid(jqOptions);
}


//��ѯ���ǼǵĲ����б�
function QueryGridRegWard(){
	$("#grid-wardlist").jqGrid("clearGridData");
	$("#grid-presclist").jqGrid("clearGridData");
	var params=GetComCodtion();
	$("#grid-wardlist").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

//ͨ������ID��ѯ�ò�ȥ�Ĵ�����Ϣ�б�
function QueryGridPreList(){
	var selectid = $("#grid-wardlist").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-wardlist").jqGrid('getRowData', selectid);
	var wardid=selrowdata.TWardId;
	var params=GetComCodtion()+"^"+wardid;
	$("#grid-presclist").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

//��ȡ����Ĺ���������Ϣ
function GetComCodtion(){
	var currentnurse=$.trim($("#currentnurse").text());
	var currentctloc=$.trim($("#currentctloc").text());
	if (currentnurse==null||currentnurse==""||currentctloc==null||currentctloc==""){
	    dhcphaMsgBox.alert("����ˢ��ҩ�˵Ŀ��������빤��!");
	    return;
	}
	var daterange=$("#date-daterange").val(); 
	daterange=FormatDateRangePicker(daterange);                       
 	var stdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];
	var chkregflag="N";
	if($("#chk-register").is(':checked')){
		chkregflag="Y";
	}	
	var params=stdate+"^^"+enddate+"^^"+gLocId+"^"+chkregflag+"^"+reguserid;
	return params;
}

//�����ȡ���õķ���
function ReceivePrescno(){
	var selectids=$("#grid-presclist").jqGrid('getGridParam','selarrrow');
	if ((selectids=="")||(selectids==null)){
		dhcphaMsgBox.alert("����ѡ����Ҫ��ȡ�Ĵ���!");
		return;
	}
	var phacrowidstr="";
	$.each(selectids, function(){
		var selrowdata = $("#grid-presclist").jqGrid('getRowData', this);
		var phacrowid=selrowdata.TPhac;
		if (phacrowidstr==""){
			phacrowidstr=phacrowid;
		}else{
			phacrowidstr=phacrowidstr+"#"+phacrowid;
		}
	})
	var params=phacrowidstr+"^"+reguserid;
	runClassMethod("web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery","SavePreReg", 
			{'params':params},
			function(data){
				if(data==-1){
					dhcphaMsgBox.alert("δѡ�д��������ʵ!");
					return;	
			    }else if(data==-2){
				    dhcphaMsgBox.alert("�Ǽ���Ϊ�գ����ʵ!");
					return;
				}else if(data==-3){
				    dhcphaMsgBox.alert("���±�����ʧ�ܣ����ʵ!");
					return;
				}else{
					dhcphaMsgBox.alert("�Ǽǳɹ�!");
					QueryGridRegWard();
					return ;
				}	
	});	
}

//���
function ClearConditions(){
	$('#currentnurse').text("");
	$('#currentctloc').text("");
	$("#grid-wardlist").clearJqGrid();
	$("#grid-presclist").clearJqGrid();
	reguserid="";
}

//��ҳ��table���ø߶�
function TakeRegHeight(){
	var height1=$("[class='container-fluid dhcpha-condition-container']").height();
	var height2=parseFloat($("[class='panel-heading']").height());					
	var tableheight=$(window).height()-2*height1-height2-70 
	return tableheight;
}

//ɨ���ǩʵ���Զ���λ���Զ��Ǽǹ��ܣ�
function GetLablePres(){
	DhcphaTempBarCode="";
	var barcode=$.trim($("#txt-label").val());
	if(barcode==""||barcode==null){
		return;
	}
	$("#txt-label").val("");
	if (reguserid==null||reguserid==""){
	    dhcphaMsgBox.alert("����ˢ��ҩ�˵Ŀ��������빤��!");
	    return;
	}
	var dispgridrows=$("#grid-presclist").getGridParam('records');
	var quitflag=0;
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$("#grid-presclist").jqGrid('getRowData',i);
		var tmpprescno=tmpselecteddata["TPrescNo"];
		if (tmpprescno==barcode){
			quitflag=1;
			$("#grid-presclist").jqGrid('setSelection',i);
			var newdata={
		    	TStatue:"�ѵǼ�"
		    };
		    $("#grid-presclist").jqGrid('setRowData',i,newdata);
			var phacrowid=tmpselecteddata["TPhac"];;
			var params=phacrowid+"^"+reguserid;
			runClassMethod("web.DHCINPHA.HMTakeDurgReg.TakeDurgRegQuery","SavePreReg", 
					{'params':params},
					function(data){
						if(data==-1){
							dhcphaMsgBox.alert("δѡ�д��������ʵ!");
							return;	
					    }else if(data==-2){
						    dhcphaMsgBox.alert("�Ǽ���Ϊ�գ����ʵ!");
							return;
						}else if(data==-3){
						    dhcphaMsgBox.alert("���±�����ʧ�ܣ����ʵ!");
							return;
						}else{
							return ;
						}	
			});	
		}
	}
	if (quitflag==0){
		dhcphaMsgBox.alert("�ô����Ѿ����߻��߲��Ǳ��������������ʵ!");
		return;
	}
}

function CheckTxtFocus(){
	var txtfocus1=$("#txt-cardno").is(":focus");
	var txtfocus2=$("#txt-label").is(":focus");
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
			if (BarCode.indexOf("I")>-1){
				$("#txt-label").val(BarCode);
				GetLablePres();
			}else{			
				$("#txt-cardno").val(BarCode);
				SetUserInfo();
			}
			DhcphaTempBarCode="";
		}else{
			DhcphaTempBarCode+=String.fromCharCode(event.keyCode);
		}
	}
}

//��״̬������ɫ
function addCollStatCellAttr(rowId, val, rawObject, cm, rdata){
	if (val.indexOf("�ѵǼ�")>=0){
		return "class=dhcpha-record-presregister";
	}else{
		return "";
	}
}