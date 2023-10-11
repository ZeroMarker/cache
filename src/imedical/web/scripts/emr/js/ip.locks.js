
$(function(){
	 if ("undefined"==typeof HISUIStyleCode || HISUIStyleCode==""){
	 // 炫彩版
	 }
	 else if (HISUIStyleCode=="lite")
	 {
		 // 极简版
		 $('.panel-body').css("background-color","#f5f5f5");
	 }else{
		// 炫彩版
	}
	
	setDataGrid();
});

//将病历锁数据加入列表
function setDataGrid()
{
	var Type = $("#Type").combobox('getValue')
	$('#lockList').datagrid({
	    fitColumns: true,
	    loadMsg:'数据装载中......',
	    autoRowHeight: true,
	    singleSelect:true,
	    idField:'ID',
	    headerCls:'panel-header-gray', 
	    url:'../EMRservice.Ajax.lock.cls?Action=GetLockList&Type='+Type,
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
    	return '<a href="#" onclick="unLockItem('+"'"+row.ID+"','"+index+"','"+row.Computer+"'"+')">'+emrTrans("解锁")+'</a>';  
}  

///解锁
function unLockItem(lockId,index,ip)
{
	var Type = $("#Type").combobox('getValue')
	if (Type == "OP")
	{
		var className = "EMRservice.BL.BLLockOp"	
	}
	else
	{
		var className = "EMRservice.BL.BLLock"
	}
	
	var currentIp = getIpAddress();
	var rowIndex = $('#lockList').datagrid('getRowIndex',lockId);
	var text = "真的要解锁吗?";
	$.messager.confirm("操作提示", text, function (data) {
				if (!data)
				{   
				   return ;
				}
				else 
				{   
					 jQuery.ajax({
						type: "Post",
						dataType: "text",
						url: "../EMRservice.Ajax.common.cls",
						async: true,
						data: {
								"Class": className,
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
			});

}

///保存操作记录
function setToLog(rowObj,ipAddress)
{
	var Type = $("#Type").combobox('getValue')
	if (Type == "OP")
	{
		var ModelName = "EMR.OP.UnLock.UnLock";	
	}
	else
	{
		var ModelName = "EMR.UnLock.UnLock";
	}

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

//查询按钮点击事件
$("#LockQuery").click(function () {
	GetData();
});

//查询数据
function GetData()
{
	var UserName = $("#UserName").val();
	var IPAddress = $("#IPAddress").val();
	var DocName = $("#DocName").val();
	var Type = $("#Type").combobox('getValue');
	$('#lockList').datagrid('load', {
		Action: "GetLockList",
		UserName: UserName,
   	 	IPAddress: IPAddress,
   	 	DocName: DocName,
   	 	Type: Type
	});
}
