$(function(){
	initParams();
	initPatView();
	initMethod();
	initCombobox();
	initTable();
})

function initParams(){
	
	hosNoPatOpenUrl = getParam("hosNoPatOpenUrl"); //hxy 2022-10-24 st
	hosNoPatOpenUrl?hosOpenPatList(hosNoPatOpenUrl):''; //ed
	
	EpisodeID="",PatientID=""
	var frm = dhcsys_getmenuform();
	if (frm) {
	    EpisodeID = frm.EpisodeID.value;
	    PatientID = frm.PatientID.value;
	}
	
	if((EpisodeID==undefined)||(EpisodeID=="")){//hxy 2022-10-24 st
		EpisodeID=getParam("EpisodeID"); 
		PatientID=getParam("PatientID"); 
	}//ed
			
}

function initPatView(){
	if(EpisodeID==undefined) return; //hxy 2022-10-24
	if(EpisodeID=="") return;
	InitPatInfoBanner(EpisodeID);
	//initPatInfoBar();
	initPagePatInfo();
}

function initMethod(){
	$("#patNo").bind('keypress',patNoKeyPress);	
	$("#readCard").on("click",readCard);
	$("#searchBtn").on("click",flashTable);
}

function initCombobox(){
	//状态
	$('#emStateList').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMEmStateView&MethodName=ListEmState',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onShowPanel:function(){
			
		},
		onLoadSuccess:function(){
			if(EpisodeID){
				$HUI.combobox("#patAdmList").setValue(EpisodeID);	
			}	
		}
	});
	//就诊
	$('#patAdmList').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMInComUseMethod&MethodName=JsonAdms&PatID='+PatientID+"&AdmType=E&LgHospID="+LgHospID,
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onSelect:function(option){
			EpisodeID = option.value;
			switchPat();
	    },
	});	
}
function initTable(){
	///  定义columns
	var columns=[[
		{field:'vsID',title:'vsID',width:100,align:'center',hidden:true},
		{field:'vsDesc',title:'病人状态',width:80,align:'center'},
		{field:'vsDate',title:'状态日期',width:100,align:'center'},
		{field:'vsTime',title:'状态时间',width:100,align:'center'},
		{field:'PatLoc',title:'病人科室',width:100,align:'center'},
		{field:'User',title:'操作人',width:100,align:'center'},
		{field:'Ward',title:'入院病区',width:100,align:'center'},
		{field:'vsNote',title:'备注信息',width:140,align:'center'}
	]];
	
	$HUI.datagrid('#visitStateTable',{
		url: 'dhcapp.broker.csp?ClassName=web.DHCEMVisitStat&MethodName=JsonQryVisitHis',
		fit:true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:60,  
		pageList:[30,60,90], 
		loadMsg: '正在加载信息...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		title:'患者状态查询', 
		toolbar:'#toolbar',
		queryParams:{
			EpisodeID:EpisodeID
		},
		onDblClickRow:function(index,row){
			
		},
		onLoadSuccess:function(data){

		}
    })
	
}

function patNoKeyPress(){
	if(event.keyCode == "13"){
    	patNoEnter();
	}	
}

function patNoEnter(){
	var RegNoLen=$.m({ClassName:"web.DHCEMPatCheckLevCom",MethodName:"GetPatRegNoLen"},false)
    var regno=$('#patNo').val();
    var oldLen=regno.length;
	if (regno!="") {  
	    for (i=0;i<RegNoLen-oldLen;i++){
	    	regno="0"+regno 
	    }
	}
	if(regno=="") return; 
    $.m({
		ClassName:"web.DHCEMEmStateView",
		MethodName:"GetPatAdmData",
		PatNo:regno,
		LgHospID:LgHospID,
		dataType:"text"
	},function(ret){
		var patDataArr=ret.split("^");
		if(!patDataArr[1]){
			$.messager.alert("提示:","无急诊就诊信息!","info",function(){
				//clearData();	
			});
			$("#patNo").val("");
			return;	
		}
		$("#patNo").val(regno);
		PatientID=patDataArr[0];
		EpisodeID=patDataArr[1];
		switchPat();
	});	
}

function switchPat(){
	initPatView();
	flashCombobox();
	flashTable();
	$HUI.combobox("#patAdmList").setValue(EpisodeID);
	return;
}

function initPatInfoBar(){
	$.m({ClassName:"web.DHCDoc.OP.AjaxInterface",MethodName:"GetOPInfoBar",CONTEXT:"",EpisodeID:EpisodeID,PatientID:PatientID},function(html){
		if (html!=""){
			$("#patInfo").html(reservedToHtml(html));
			$("#patInfo").mouseover(function(){
				html=reservedToHtml(html).replace(/color:#589DDA/g, "");
				layer.tips(html, '#patInfo', {
    				tips: [1, '#3595CC'],
    				area: ['800px', 'auto'],
    				time: 0
				});
			});
			$("#patInfo").mouseout(function(){
				layer.closeAll()
			});
		}else{
			$("#patInfo").html("获取病人信息失败。请检查【患者信息展示】配置。");
		}
	});		
}

function initPagePatInfo(){
	$.m({
		ClassName:"web.DHCEMEmStateView",
		MethodName:"GetPatData",
		EpisodeID:EpisodeID,
		PatientID:PatientID,
		LgHospID:LgHospID,
		dataType:"text"
	},
	function(ret){
		var patDataArr=ret.split("^");
		if(patDataArr[2]==""){
			$.messager.alert("提示:","无急诊就诊信息!");
			return;	
		}
		$("#patNo").val(patDataArr[1]);
	});		
}

function flashTable(){
	var stateId=$HUI.combobox("#emStateList").getValue();
	var stDate=$HUI.datebox("#stDate").getValue();
	var endDate=$HUI.datebox("#endDate").getValue();
	var otherParams=stDate+"^"+endDate+"^"+stateId;
	
	$HUI.datagrid('#visitStateTable').load({
		EpisodeID:EpisodeID,
		OtherParams:otherParams
	})
}

function flashCombobox(){
	var url='dhcapp.broker.csp?ClassName=web.DHCEMInComUseMethod&MethodName=JsonAdms&PatID='+PatientID+"&AdmType=E&LgHospID="+LgHospID;
	$("#patAdmList").combobox("reload",url);	
}

/// 读卡
function readCard(){
	
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
				getPatData(CardTypeRowId,Infortn.split("^")[1]);
				break;
			}else if(rtn=="-200"){
				//已经读卡成功,但是卡是无效的
				//$.messager.alert("提示","卡无效!");
				//eval('(' + callBackFun + ')')(Infortn);
				break;
			}else if(rtn=="-1"){
				//没放卡
				continue;
				eval('(' + callBackFun + ')')(Infortn);
				break;
			}
		}
		
	});
	return;
}

function getPatData(CardTypeID,CardNo){
	$cm({
		ClassName:"web.DHCEMPatientSeat",
		MethodName:"GetPatInfo",
		dataType:"text",
		CardNo:CardNo,
		CardTypeID:CardTypeID
	},function(retData){
		if(retData.split("^")[2]==""){
			$.messager.alert("提示:","未找到关联的患者!");
			return;		
		}
		$("#patNo").val(retData.split("^")[2]);
		patNoEnter();
	});
}

function reservedToHtml(str){	
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}

function clearData(){
	PatientID="";
	EpisodeID="";
	$("#patNo").val("");
	//$("#patInfo").html("");
	$HUI.combobox("#emStateList").setValue("");
	$HUI.combobox("#patAdmList").setValue("");
	$HUI.datebox("#endDate").setValue("");
	$HUI.datebox("#stDate").setValue("");
	$("#visitStateTable").datagrid('loadData',[]);
	//$("#patNo").val("");
	return;
}
