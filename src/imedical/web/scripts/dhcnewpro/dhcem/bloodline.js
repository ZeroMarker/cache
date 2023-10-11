var LgParams=LgHospID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgUserID;
var clickType="";
$(function(){
	initParams();
	
	initCombobox();
	
	initDatagrid();
	
	initMethod();
})

function initParams(){
	ComputerIp=GetComputerIp();
	var RetData=$cm({ClassName:"web.DHCEMBloodLine",MethodName:"GetPageData",dataType:"text","ComputerIp":ComputerIp},false);
	AssBloodRoom=RetData.split("^")[1];
	if(AssBloodRoom==""){
		//$.messager.alert("��ʾ","δ������Ѫ������!�޷��Ŷ�!")
		$("#AssBloodRoom").html($g("δ������Ѫ������!�޷��Ŷ�!"));
		$HUI.linkbutton("#LineBtn",{disabled:true})
	}else{
		$("#AssBloodRoom").html(AssBloodRoom);
	}
}

function initCombobox(){

}



function initDatagrid(){
	
	var columns = [[
         
		{ field: 'PatName',title: '����',width:50},
		{ field: 'PatSex',title: '�Ա�',width:50},
		{ field: 'PatAge',title: '����',width:50},
		{ field: 'RegNo',title: '�ǼǺ�',width:70},
		{ field: 'QueueDate',title: '��������',width:50},
		{ field: 'QueueTime',title: '����ʱ��',width:50},
		{ field: 'QueueNo',title: '�������',width:50},
		{ field: 'QueueState',title: '״̬',width:50,formatter:
			function (value, row, index){ //hxy 2022-12-15
				if(value=="Wait"){
					value=$g("�Ⱥ�");
				}else if(value=="Ready"){
					value=$g("׼��");
				}else if(value=="Call"){
					value=$g("����");
				}else if(value=="Skip"){
					value=$g("����");
				}else if(value=="Finish"){
					value=$g("���");
				}
				return '<font>'+value+'</font>'

			}
		},
		{ field: 'QueuePrior',title: '���ȼ�',width:50,formatter:
			function (value, row, index){ //hxy 2022-12-15
				if(value=="1"){
					value=$g("����");
				}else if(value=="2"){
					value=$g("����");
				}else if(value=="3"){
					value=$g("����");
				}
				return '<font>'+value+'</font>'
			}
		},
		{ field: 'CallUser',title: '�����û�',width:50},
		{ field: 'ClientName',title: '�Ŷӿͻ���',width:50}
	]]
	
	$HUI.datagrid('#BloodPat',{
		url: LINK_CSP+'?ClassName=web.DHCEMBloodLine&MethodName=ListBloodPat',
		bodyCls:'panel-header-gray', //hxy 2022-11-18
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:60,  
		pageList:[30,60,90], 
		loadMsg: $g('���ڼ�����Ϣ...'),
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		title:'', 
		toolbar:'#toolbar',
		queryParams:{
			Params:getParams()
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
	$("#ReadCard").on("click",function(){ReadCard(2)});
	$("#LineBtn").on("click",function(){ReadCard(1)});
	$("#PatCardNo").on('keypress',CardNoKeyPress);
	$("#LineCardNo").on('keypress',LineCardNoKeyPress);
	
	
}

function UpdateTreatQueOp(Prior,State){
	var rowData = $HUI.datagrid('#BloodPat').getSelected();	
	
	if(!rowData){
		$.messager.alert('��ʾ','��ѡ��һ����¼��');
		return;
	}
	var QueueState=rowData.QueueState;
	var QueuePrior=rowData.QueuePrior;
	if((Prior==1)&&(QueueState!=$g("�Ⱥ�"))&&(QueueState!=$g("����"))){
		$.messager.alert('��ʾ','�������ĵȺ�״̬�Ļ���,������˲���!');
		return;
	}

	if(((Prior==3)||(Prior==2))&&(QueueState!=$g("�Ⱥ�"))&&(QueueState!=$g("����"))&&(QueueState!=$g("����"))){
		$.messager.alert('��ʾ','�������ĵȺ���ߺ���״̬����,������˲���!');
		return;
	}
	
	var TreatId =  rowData.CurId;
	UpdateTreatQue(TreatId,Prior,State)
}

function getParams(){
	var stDate = $HUI.datebox("#StartDate").getValue();
	var endDate = $HUI.datebox("#EndDate").getValue();
	var patNo = $("#PatNo").val();
	var queStatus=$('[name="QueStatus"]:checked').length?$('[name="QueStatus"]:checked').val():"";
	var inParams = stDate+"^"+endDate+"^"+patNo+"^"+queStatus+"^"+ComputerIp;
	return inParams;
}

function FlashTable(){
	$HUI.datagrid('#BloodPat').load({
		Params:getParams()
	})
}

function PatNoKeyPress(){
	if(event.keyCode == "13")   {
    	PatNoEnter();
	}	
}

function PatNoEnter(){
    var regno=$('#PatNo').val();
    var oldLen=regno.length;
	if (regno!="") {  
	    for (i=0;i<10-oldLen;i++){
	    	regno="0"+regno 
	    }
	}
    $("#PatNo").val(regno);	
    FlashTable();
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
/// ����:
/// Type: 1-��Ѫ�Ŷ�   2-��ѯ
function ReadCard(Type){
	clickType=Type;
	DHCACC_GetAccInfo7(ReadCardCallback);
}
/// ����
function ReadCardCallback(rtnValue){
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case '0':
		if(clickType==1){
			$("#LineCardNo").val(myAry[1]);
			$("#CardTypeNew").val("");
			InsertBloodQue();
		}
		if(clickType==2){
			$("#PatCardNo").val(myAry[1]);
			//GetPatData(myAry[8],myAry[1]);
			$("#PatNo").val(myAry[5]);
			$("#SearchBtn").click();
		}
		break;
	case '-200':
		$.messager.alert("��ʾ", "����Ч", "info", function() {
			if(clickType==2){
				$("#PatNo").val("");
				$('#PatCardNo').focus();
			}
		});
		break;
	case '-201':
		if(clickType==1){
			$("#LineCardNo").val(myAry[1]);
			$("#CardTypeNew").val("");
			InsertBloodQue();
		}
		if(clickType==2){
			$("#PatCardNo").val(myAry[1]);
			//GetPatData(myAry[8],myAry[1]);
			$("#PatNo").val(myAry[5]);
			$("#SearchBtn").click();
		}
		break;
	default:
	}
}

function InsertBloodQue(){
	var ret=$cm({
		ClassName:"web.DHCNurseBlood",
		MethodName:"InsertQueueNew",
		dataType:"text",
		PatCardNo:$("#LineCardNo").val(),
		ClientIp:ComputerIp,
		HospId:LgHospID
	},false);
	var retArr=ret.split("^");
	if(retArr[0]!=0){
		$.messager.alert('��ʾ',retArr[0]);	
	}else{
		$.messager.alert('��ʾ',"�Ŷӳɹ�,�Ŷ����:"+retArr[1]+",��ǰ�Ⱥ�����:"+retArr[3]);	
		$("#LineCardNo").val("");
	}
	return;
}

function CardNoKeyPress(e){
	if (e.keyCode==13) {
		var CardNo=$('#PatCardNo').val();
		clickType=2;
		if (CardNo=="") return;
		var myrtn=DHCACC_GetAccInfo("",CardNo,"","",ReadCardCallback);
	}
}

function LineCardNoKeyPress(e){
	if (e.keyCode==13) {
		var CardNo=$('#LineCardNo').val();
		CardNo = $.trim(CardNo);
		if (CardNo=="") return;
		InsertBloodQue();
	}
}
function GetComputerIp() {
   if(window.ActiveXObject){
		var ipAddr="";
		var locator = new ActiveXObject("WbemScripting.SWbemLocator");
		var service = locator.ConnectServer(".");
		var properties = service.ExecQuery("Select * FROM Win32_NetworkAdapterconfiguration");
		var e = new Enumerator(properties);
		var p=e.item();
		for(;!e.atEnd();e.moveNext())
		{
			var p=e.item();
			ipAddr=p.IPAddress(0);
			if(ipAddr) break;
		}
		return ipAddr;
	}else{
		var ClientIPAddressIInfo = $cm({ClassName:"User.DHCClientLogin",MethodName:"GetInfo",dataType:"text"},false);
		return ClientIPAddressIInfo.split("^")[0];
	}
}

function UpdateTreatQue(TreatId,Prior,State){
	obj=new Object();
	obj.TreatRecUser=LgUserID;
	obj.TreatQuePrior=Prior;
	obj.TreatQueState=State;
	obj.ID=TreatId;
	ret=$cm({ClassName:"web.DHCEMNurTreatQueue",MethodName:"saveOrUpdate",tableName:"User.DHCNurTreatQueue",jsonStr:JSON.stringify(obj),dataType:"text"},false);
	if (ret != 0) {
		$.messager.alert("��ʾ", ret);
	}else{
		if(arguments[3]!=1) $.messager.alert("��ʾ", "�����ɹ�!");
		$("#SearchBtn").click();
	}
}
