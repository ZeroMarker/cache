$(function(){
	//兼容showModalDialog和hisui的dialog写法
	if ((arrayStr != "")&&(openWay == "editor"))
    {
	    obj = JSON.parse(unescape(utf8to16(base64decode(arrayStr)))); 
    }
	init(obj.data);
});

//患者基本信息数据列表
function init(data)
{
	$('#MessageGrid').datagrid({
		fitColumns:true,
		loadMsg:'数据装载中......',
		autoRowHeight:true,
		data:data,
		idField:'RowId',
		columns:[[
		    {field:'RowId',hidden:true},
			{field:'Check',title:'选择',checkbox:true},
			{field:'Desc',title:'单元名称',width:150,align:'center'},
			{field:'CurrentCode',title:'现内容编码',hidden:true},
			{field:'Current',title:'现内容',width:200,align:'center'},
			{field:'Original',title:'原内容',width:200,align:'center'},
			{field:'Code',title:'订阅项数据编码',hidden:true},
			{field:'Glossary',title:'术语编码',hidden:true},
			{field:'Type',title:'定义数据类型',hidden:true}
		]]
	});
}

//保存
$('#save').click(function()
{
	var rows = $('#MessageGrid').datagrid('getSelections');
	if (rows == "")
	{
		alert("请选择同步数据项!");
		return;
	}
	var ChangeData="";
	for (var i=0; i<rows.length; i++)
	{
		var ItemCode = rows[i].Code;
		var ItemCurrent = rows[i].Current;
		var ItemCurrentCode = rows[i].CurrentCode;
		var ItemOriginal = rows[i].Original;
		if (ChangeData == "")
		{
			var ChangeData=ItemCode+'^'+ItemCurrent+'^'+ItemCurrentCode+'^'+ItemOriginal;
		}
		else
		{
			var ChangeData=ChangeData+'&'+ItemCode+'^'+ItemCurrent+'^'+ItemCurrentCode+'^'+ItemOriginal;
		}
	}
	
	var result = false;
	$.ajax({
		type: "Get", 
        dataType: "text", 
        url: "../EMRservice.Ajax.common.cls",
        async : false,
        data:{
			"OutputType":"String",
			"Class":"EMRservice.Observer",
			"Method":"BLUpdateData",
			"p1":obj.patientID,
			"p2":ChangeData,
			"p3":obj.userID,
			"p4":ipAddress
		}, 
		error: function(data)
		{
			alert("error"); 
        }, 
        success: function (data)
        {
        	if (data == "1")
			{
				result = true;
			}
        } 
        
	});
	window.returnValue = result;
	window.close();
})

//关闭窗口
$('#close').click(function()
{
	window.returnValue = false;
	if (openWay == "editor")
	{
		parent.closeDialog("observerDialog");
	}
	else
	{
		//兼容showModalDialog写法
		window.close();	
	}
})

