var returnValue = {};
returnValue.checkStatu = "True";
var dataStr = '';
var partDataStr = '';
$(function(){
	/* if (dataObjStr != "")
	{
		dataStr = JSON.parse(unescape(utf8to16(base64decode(dataObjStr)))); 
	} */
	dataStr = parent.dataObjStr;
	//dataStr = {"AutoRefresh":"true","SyncDialogVisible":"true"," SilentRefresh ":"false","result":"OK","Items":[{"SectionName":"基本信息","SectionCode":"S001","DisplayName":"姓名","Path":"S001_V001_L0001","OldValue":"张三 ","NewValue":"李四"},{"SectionName":"基本信息","SectionCode":"S001","DisplayName":"姓名","Path":"S001_V001_L0001","OldValue":"张三 ","NewValue":""}]}
	
	dataStr.total = dataStr.Items.length;
	dataStr = JSON.parse(JSON.stringify(dataStr).replace(/Items/g, "rows"));
	
	//把NewValue不是空值的数据拷贝到partDataStr
	partDataStr = {
			rows:[]
		};
	for (var i=0;i<dataStr.total;i++)
	{
		if(dataStr.rows[i].NewValue != "")
		{
			partDataStr.total = i+1;
			partDataStr.rows.push(dataStr.rows[i]);
		}
	}
	
	$('#differentData').datagrid({
	    loadMsg:'数据装载中......',
	    autoSizeColumn:false,
		fitColumns:true,
		pagination:false,
		fit:true,
	    columns:[[
	    		{field:'ck',checkbox:"true"},
				{field:'SectionName',title:'章节名称',width:100},
				{field:'DisplayName',title:'元素名称',width:100},
				{field:'OldValue',title:'修改前值',width:200, formatter: function (value) {
	                	return "<span title='" + value + "'>" + value + "</span>";
	            	}
				},
				{field:'NewValue',title:'修改后值',width:200, formatter: function (value) {
	                	return "<span title='" + value + "'>" + value + "</span>";
	            	}
				}
		]], 
		onSelect:function(rowIndex, rowData)
		{
			$("div").remove("#textContent div");
			$("#textContent").append("<div>修 改 前 值：</div><div>"+rowData.OldValue+"</div>");
			$("#textContent").append("<div>修 改 后 值：</div><div>"+rowData.NewValue+"</div>");
		},
		onUnselect:function(rowIndex, rowData)
		{
			$("div").remove("#textContent div");
		},
		data:partDataStr,
	});
	
	
});

//同步数据
document.getElementById("synData").onclick = function(){
	var updataStr = $("#differentData").datagrid('getSelections');
	var pathAndValueStr = [];
	if (updataStr.length !== 0)
	{
		//for循环取path和value
		for (var i=0;i<updataStr.length;i++)
		{
			var pathAndValue = {};
			pathAndValue.Path = updataStr[i].Path;
			pathAndValue.Value = updataStr[i].NewValue;
			pathAndValueStr.push(pathAndValue);
		}
		checkStatu();
		returnValue.updataStr = pathAndValueStr;
		closeWindow();
	}else{
		top.$.messager.alert("提示","请选择需要更新的数据!");
	}
}

//退出
document.getElementById("btnCancel").onclick = function(){
	checkStatu();
	closeWindow();
}

//显示所有数据
document.getElementById("accordAll").onclick = function(){
	var accordAll = $("#accordAll")[0].checked;
	if (accordAll)
	{
		$('#differentData').datagrid("loadData",dataStr)
	}
	else{
		$('#differentData').datagrid("loadData",partDataStr)
	}
}

//下次是否询问
document.getElementById("bounced").onclick = function(){
	checkStatu();
}

//记录下次是否询问的状态
function checkStatu()
{
	var checkStatu = $("#bounced")[0].checked;
	if (checkStatu) checkStatu = "False";
	if (!checkStatu) checkStatu = "True";
	returnValue.checkStatu = checkStatu;
}

//关闭窗口
function closeWindow()
{
	parent.closeDialog("dialogSynData");
}
