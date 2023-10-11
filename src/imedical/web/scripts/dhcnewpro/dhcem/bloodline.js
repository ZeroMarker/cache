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
		//$.messager.alert("提示","未关联采血服务器!无法排队!")
		$("#AssBloodRoom").html($g("未关联采血服务器!无法排队!"));
		$HUI.linkbutton("#LineBtn",{disabled:true})
	}else{
		$("#AssBloodRoom").html(AssBloodRoom);
	}
}

function initCombobox(){

}



function initDatagrid(){
	
	var columns = [[
         
		{ field: 'PatName',title: '姓名',width:50},
		{ field: 'PatSex',title: '性别',width:50},
		{ field: 'PatAge',title: '年龄',width:50},
		{ field: 'RegNo',title: '登记号',width:70},
		{ field: 'QueueDate',title: '报道日期',width:50},
		{ field: 'QueueTime',title: '报道时间',width:50},
		{ field: 'QueueNo',title: '队列序号',width:50},
		{ field: 'QueueState',title: '状态',width:50,formatter:
			function (value, row, index){ //hxy 2022-12-15
				if(value=="Wait"){
					value=$g("等候");
				}else if(value=="Ready"){
					value=$g("准备");
				}else if(value=="Call"){
					value=$g("呼叫");
				}else if(value=="Skip"){
					value=$g("过号");
				}else if(value=="Finish"){
					value=$g("完成");
				}
				return '<font>'+value+'</font>'

			}
		},
		{ field: 'QueuePrior',title: '优先级',width:50,formatter:
			function (value, row, index){ //hxy 2022-12-15
				if(value=="1"){
					value=$g("优先");
				}else if(value=="2"){
					value=$g("正常");
				}else if(value=="3"){
					value=$g("过号");
				}
				return '<font>'+value+'</font>'
			}
		},
		{ field: 'CallUser',title: '呼叫用户',width:50},
		{ field: 'ClientName',title: '排队客户端',width:50}
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
		loadMsg: $g('正在加载信息...'),
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
		$.messager.alert('提示','请选择一条记录！');
		return;
	}
	var QueueState=rowData.QueueState;
	var QueuePrior=rowData.QueuePrior;
	if((Prior==1)&&(QueueState!=$g("等候"))&&(QueueState!=$g("正常"))){
		$.messager.alert('提示','非正常的等候状态的患者,不允许此操作!');
		return;
	}

	if(((Prior==3)||(Prior==2))&&(QueueState!=$g("等候"))&&(QueueState!=$g("呼叫"))&&(QueueState!=$g("正常"))){
		$.messager.alert('提示','非正常的等候或者呼叫状态患者,不允许此操作!');
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
	if(value=="1级"){value=$g("Ⅰ级");}
	if(value=="2级"){value=$g("Ⅱ级");}
	if(value=="3级"){value=$g("Ⅲ级");}
	if(value=="4级"){value=$g("Ⅳa级");}
	if(value=="5级"){value=$g("Ⅳb级");}
	return value;
}
/// 读卡:
/// Type: 1-采血排队   2-查询
function ReadCard(Type){
	clickType=Type;
	DHCACC_GetAccInfo7(ReadCardCallback);
}
/// 读卡
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
		$.messager.alert("提示", "卡无效", "info", function() {
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
		$.messager.alert('提示',retArr[0]);	
	}else{
		$.messager.alert('提示',"排队成功,排队序号:"+retArr[1]+",当前等候人数:"+retArr[3]);	
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
		$.messager.alert("提示", ret);
	}else{
		if(arguments[3]!=1) $.messager.alert("提示", "操作成功!");
		$("#SearchBtn").click();
	}
}
