
$(function(){
	setDataGrid();
});

//将病历锁数据加入列表
function setDataGrid()
{
	$('#lockList').datagrid({
	    fitColumns: true,
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    singleSelect:true,
	    idField:'ID', 
	    url:'../EMRservice.Ajax.lock.cls?Action=GetLockList',
	    rownumbers:true,
	    pageSize:20,
	    pageList:[10,20,30], 
	    pagination:true,
	    fit:true,
	    columns:[[  
	        {field:'ID',title:'ID',width:80,hidden: true},
	        {field:'UserID',title:'用户ID',width:80,hidden: true},
	        {field:'UserCode',title:'用户代码',width:80,hidden: true},
	        {field:'UserName',title:'用户名称',width:80},  
	        {field:'Computer',title:'计算机IP',width:80},  
	        {field:'LockDateTime',title:'锁定时间',width:100},
	        {field:'Action',title:'操作类型',width:80},
	        {field:'EpisodeID',title:'就诊号',width:60,hidden: true},
	        {field:'DocID',title:'目录ID',width:80,hidden: true},
	        {field:'DocName',title:'目录名称',width:80},
	        {field:'CategoryID',title:'模板分类ID',width:80,hidden: true},
	        {field:'TemplateID',title:'模板ID',width:80,hidden: true},
	        {field:'unLock',title:'操作', width: 70, formatter:formatOper}
	    ]]
  }); 

}
///本用户添加解锁按钮
function formatOper(val,row,index)
{  
    	return '<a href="#" onclick="unLockItem('+"'"+row.ID+"','"+index+"','"+row.Computer+"'"+')">解锁</a>';  
}  

///解锁
function unLockItem(lockId,index,ip)
{
	var currentIp = getIpAddress();
	var rowIndex = $('#lockList').datagrid('getRowIndex',lockId);
	if(!confirm("真的要解锁吗?"))
	{
		return;
	}
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
				"Class": "EMRservice.BL.BLLock",
				"Method":"UnLock",
				"OutputType":"String",
		        "p1": lockId
		      },
		success: function(d) {
			var rowObj = $('#lockList').datagrid('getSelected');
			if (d != "0") 
			{
				$('#lockList').datagrid('deleteRow',rowIndex); 
				if (IsSetToLog == "Y")
				{
					setToLog(rowObj,currentIp);
				}
			}		
		},
		error : function(d) { alert(" error");}
	});

}

///保存操作记录
function setToLog(rowObj,ipAddress)
{
	
	//var ipAddress = getIpAddress();
	var ModelName = "EMR.UnLock.UnLock";
	var Condition = "";
	Condition = Condition + '{"LockID":"' + rowObj.ID + '",';
	Condition = Condition + '"LockUserID":"' + rowObj.UserID + '",';
	Condition = Condition + '"LockUserCode":"' + rowObj.UserCode + '",';
	Condition = Condition + '"LockUserName":"' + rowObj.UserName + '",';
	Condition = Condition + '"LockComputer":"' + rowObj.Computer + '",';
	Condition = Condition + '"LockDateTime":"' + rowObj.LockDateTime + '",';
	Condition = Condition + '"Action":"' + rowObj.Action + '",';
	Condition = Condition + '"episodeID":"' + rowObj.EpisodeID + '",';
	Condition = Condition + '"LockDocID":"' + rowObj.DocID + '",';
	Condition = Condition + '"LockDocName":"' + rowObj.DocName + '",';
	Condition = Condition + '"categoryId":"' + rowObj.CategoryID + '",';
	Condition = Condition + '"templateId":"' + rowObj.TemplateID + '",';
	Condition = Condition + '"userName":"' + userName + '",';
	Condition = Condition + '"userID":"' + userId + '",';
	Condition = Condition + '"ipAddress":"' + ipAddress + '"}';
	var ConditionAndContent = Condition;
	$.ajax({ 
		type: "POST", 
		url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
		data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + SecCode
	});	
}

