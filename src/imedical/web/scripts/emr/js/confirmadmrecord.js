$(function(){
	if (isEnableRevokeComplete == "N")
	{
		document.getElementById("revoke").style.display="none";
	}
	InitData();
});

//初始化列表
function InitData()
{
	$('#logData').datagrid({ 
			width:'100%',
			height:106, 
			fitColumns: true,
			loadMsg:'数据装载中......',
			autoRowHeight: true,
			url:'../EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.BL.BLAdmRecordStatusLog&Method=GetLogData&p1=' + episodeID,
			singleSelect:true,
			idField:'LogID', 
			rownumbers:false,
			pagination:false,
			fit:true,
			remoteSort:false,
			columns:[[  
				{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
				{field:'LogID',title:'LogID',width:80,hidden: true},
				{field:'OperateDate',title:'操作日期',width:50,sortable:true},
				{field:'OperateTime',title:'操作时间',width:50,sortable:true},
				{field:'Action',title:'操作动作',width:50,sortable:true},
				{field:'UserName',title:'操作人',width:50,sortable:true},
				{field:'IPAddress',title:'操作IP地址',width:50,sortable:true},
				{field:'ProductSource',title:'操作产品来源',width:40,sortable:true},
				{field:'Remark',title:'备注',width:60,sortable:true},
				{field:'Status',title:'病历状态',width:30,sortable:true,formatter: statusFormat}
			]]
		});
 }
 
function statusFormat(val){
    var retStr = "";
    if (val == '1') {
        retStr = emrTrans('已提交');
    }else if (val == '-1') {
        retStr = emrTrans('已退回');
    }else if (val == '0') {
        retStr = emrTrans('已撤销');
    }
    return retStr;
}
 
function confirm()
{
 	var status = getAdmRecordStatus();
 	if (status == "1")
 	{
	 	$.messager.alert("提示", "患者病历已提交，无需重复提交！",'info');
		return;
 	}
 	window.returnValue = "confirm";
 	closeWindow();
}
 
function revoke()
{
	var status = getAdmRecordStatus();
 	if (status != "1")
 	{
	 	$.messager.alert("提示", "患者病历还未提交，无需撤销提交！",'info');
		return;
 	}
	
	var tipMsg = "是否确认撤销提交病历?";
	$.messager.confirm("提示",tipMsg, function (r) {
		if (!r) return;
		window.returnValue = "revoke";
		closeWindow();
	});
	
}

function getAdmRecordStatus()
{
	var result = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLAdmRecordStatus",
					"Method":"GetAdmRecordStatus",			
					"p1":episodeID
				},
			success: function(d) {
				if (d != "") result = d;
			},
			error : function(d) { alert("getAdmRecordStatus error");}
		});	
	return result;	
}

//关闭窗口
function closeWindow()
{
	window.opener=null;
	window.open('','_self');
	window.close();	
}