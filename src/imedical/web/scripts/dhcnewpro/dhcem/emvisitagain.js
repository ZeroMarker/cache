var LgParams=LgHospID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgUserID;

$(function(){
	initParams();
	
	initCombobox();
	
	initDatagrid();
	
	initMethod();
})

function initParams(){
	$HUI.radio("[name='QueStatus']",{
	    onChecked:function(e,value){
	        $("#SearchBtn").click();
	    }
	});
}

function initCombobox(){
	
	//����
	$('#EmLocID').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatLoc',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		mode:'remote',
		onSelect:function(option){
			var url = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatChkCare&LocID="+option.value;
	        $("#EmCheckNo").combobox('reload', url);
			$("#EmCheckNo").combobox('setValue', "");			
	    }
	})
	
	//�ű�
	$('#EmCheckNo').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatChkCare',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onShowPanel:function(){
			var EmLocID =$("#EmLocID").combobox("getValue"); 
	        var url = LINK_CSP+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonGetEmPatChkCare&LocID="+EmLocID;
	        $("#EmCheckNo").combobox('reload', url);
		}
	});	
	
	
}



function initDatagrid(){
	var columns = [[
        { field: 'AdmLoc',title: '�������',width:100}, 
		{ field: 'AdmCare',title: '����ű�',width:100},
		{ field: 'PatName',title: '����',width:100},
		{ field: 'PatSex',title: '�Ա�',width:50},
		{ field: 'PatAge',title: '����',width:50},
		{ field: 'PatNo',title: '�ǼǺ�',width:70},
		{ field: 'PatDoctor',title: 'ҽ��',width:100},
		{ field: 'PAAdmPriority',title: '��ǰ�ּ�',width:50,formatter:formatChkLev},
		{ field: 'PatChkLev',title: 'Ԥ��ּ�',width:50,formatter:formatChkLev},
		{ field: 'AdmStatus',title: '״̬',width:50},
		{ field: 'AdmDate',title: '��������',width:100},
		{ field: 'AdmTime',title: '����ʱ��',width:100},
	]]
	
	$HUI.datagrid('#emAdmPat',{
		url: LINK_CSP+'?ClassName=web.DHCEMEmVisitAgain&MethodName=ListEmAdmData',
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:60,  
		pageList:[30,60,90], 
		loadMsg: '���ڼ�����Ϣ...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		headerCls:'panel-header-gray', //ed
		title:'���︴��', 
		iconCls:'icon-paper',
		toolbar:'#toolbar',
		queryParams:{
			Params:getParams(),
			LgParams:LgParams
		},
		onDblClickRow:function(index,row){
			
		},
		onLoadSuccess:function(data){

		}
    })
}

function initMethod(){
	$("#SearchBtn").on("click",FlashTable);
	$("#PatNo").bind('keypress',PatNoKeyPress);
	$("#ReadCard").on("click",ReadCard);
	$("#PatCardNo").on('keypress',CardNoKeyPress);
}

function getParams(){
	var stDate = $HUI.datebox("#StartDate").getValue();
	var endDate = $HUI.datebox("#EndDate").getValue();
	var patNo = $("#PatNo").val();
	var emLocID = $HUI.combobox("#EmLocID").getValue();
	var emCheckNo = $HUI.combobox("#EmCheckNo").getValue();
	var queStatus=$('[name="QueStatus"]:checked').length?$('[name="QueStatus"]:checked').val():"";
	var inParams = stDate+"^"+endDate+"^"+patNo+"^"+emLocID+"^"+emCheckNo+"^"+queStatus;
	return inParams;
}

function FlashTable(){
	$HUI.datagrid('#emAdmPat').load({
		Params:getParams(),
		LgParams:LgParams
	})
}

function PatNoKeyPress(){
	if(event.keyCode == "13")   {
    	PatNoEnter();
	}	
}

function PatNoEnter(){
    var RegNoLen=$.m({ClassName:"web.DHCEMPatCheckLevCom",MethodName:"GetPatRegNoLen"},false)
	var regno=$('#PatNo').val();
    var oldLen=regno.length;
	if (regno!="") {  
	    for (i=0;i<RegNoLen-oldLen;i++){
	    	regno="0"+regno 
	    }
	}
    $("#PatNo").val(regno);	
    FlashTable();
}

function QueAgainclick(){
	var rowData = $HUI.datagrid('#emAdmPat').getSelected();	
	
	if(!rowData){
		$.messager.alert('��ʾ','��ѡ����Ҫ����ļ�¼��');
		return;
	}
	var PatName = rowData.PatName;
	var queId =  rowData.QueDr;
	 $.cm({
		ClassName:"web.DHCEMEmVisitAgain", 
		MethodName:"PatAgain",
		dataType:"text",
		QueID:queId,UserID:LgUserID
	},function(rtn){
		if (rtn!=0){
			$.messager.alert("��ʾ","����ʧ��!"+rtn);
			return false;
		}
		$.messager.alert("��ʾ",$g("����")+PatName+$g("����ɹ�")+"!");
		FlashTable();
	})
}


function CancleQueAgainclick(){
	var rowData = $HUI.datagrid('#emAdmPat').getSelected();	
	
	if(!rowData){
		$.messager.alert('��ʾ','��ѡ����Ҫȡ������ļ�¼��');
		return;
	}
	if(rowData.ChAdmStatus!="����"){ //AdmStatus
		$.messager.alert('��ʾ','��ǰ״̬�Ǹ���״̬������ȡ��!');
		return;
	}
	
	var PatName = rowData.PatName;
	var queId =  rowData.QueDr;
	
	$.cm({
		ClassName:"web.DHCAlloc", 
		MethodName:"CancleQueAgain",
		dataType:"text",
		QueID:queId,UserID:LgUserID
	},function(rtn){
		if (rtn!=0){
			$.messager.alert("��ʾ","ȡ������ʧ��!"+rtn);
			return false;
		}
		$.messager.alert("��ʾ",$g("����")+PatName+$g("ȡ������ɹ�")+"!");
		FlashTable();
	})
}

//hxy 2020-02-20
function formatChkLev(value,row,index){
	if(value=="1��"){value=$g("��");}
	if(value=="2��"){value=$g("��");}
	if(value=="3��"){value=$g("��");}
	if(value=="4��"){value=$g("��a��");}
	if(value=="5��"){value=$g("��b��");}
	return value;
}



/// ����
function ReadCard(){
	
	$cm({
		ClassName:"web.DHCEMPatCheckLevCom",
		MethodName:"CardTypeDefineListBroker",
	},function(jsonData){
		
		for (var k=0;k<jsonData.length;k++){
			var myoptval=jsonData[k]["value"];
			var myEquipDR=myoptval.split("^")[14];
			if ((myoptval.split("^")[16]=="Handle")||(myEquipDR=="")) continue;
			var CardTypeRowId=myoptval.split("^")[0];
			var Infortn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
			var myary=Infortn.split("^");
			var rtn=myary[0];
			if ((rtn=="0")||(rtn=="-201")){
				$("#CardTypeNew").val(myoptval.split("^")[2]);
				$("#PatCardNo").val(Infortn.split("^")[1]);
				GetPatData(CardTypeRowId,Infortn.split("^")[1]);
				break;
			}else if(rtn=="-200"){
				//�Ѿ������ɹ�,���ǿ�����Ч��
				//$.messager.alert("��ʾ","����Ч!");
				//eval('(' + callBackFun + ')')(Infortn);
				break;
			}else if(rtn=="-1"){
				//û�ſ�
				continue;
				eval('(' + callBackFun + ')')(Infortn);
				break;
			}
		}
		
	});

	return;
}
function GetPatData(CardTypeID,CardNo){
	$cm({
		ClassName:"web.DHCEMPatientSeat",
		MethodName:"GetPatInfo",
		dataType:"text",
		CardNo:CardNo,
		CardTypeID:CardTypeID
	},function(retData){
		$("#PatNo").val(retData.split("^")[2]);
		$("#SearchBtn").click();
	});
}

function CardNoKeyPress(e){
	if (e.keyCode==13) {
		var CardNo=$('#PatCardNo').val();
		if (CardNo=="") return;
		var myrtn=DHCACC_GetAccInfo("",CardNo,"","","CardNoKeyDownCallBack");
	}
}

function CardNoKeyDownCallBack(myrtn){
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "-200": 
			$.messager.alert("��ʾ","����Ч!","info",function(){
				$("#PatNo").val("");
				$('#PatCardNo').focus();
			});
			break;
		default:
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$('#PatCardNo').val(CardNo);
			$("#PatNo").val(myary[5]);
			$("#SearchBtn").click();
			break;
	}
}



