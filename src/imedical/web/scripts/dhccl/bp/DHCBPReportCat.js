var columns = [
[
	{ field: 'RCode',title: '代码',width: 120,align: 'left'},
	{ field: 'RDesc', title: '名称', width: 120,align: 'left'},
	{ field: 'RFrequency', title: '频次', width: 120,align: 'left'},
]]
$(function(){
	var grid = $("#dataBox").datagrid({
		url:$URL,		
		columns:columns,
		queryParams: $.extend({
                ClassName:"web.DHCBPReportCat",
                QueryName:"FindReportCat"
        }, $("#dataBox").datagrid.queryParams || {}),
		iconCls:"icon-template",
        headerCls: 'panel-header-gray',
		fit:true,
		fitColumns:true,
		singleSelect:true,
		rownumbers:true,//行号
		pagination:true,//分页工具条
		pageSize:20,
		pageList:[20,40,60],
		toolbar: '#dataTools',
		onSelect: function(index, row) {
                $("#Code").val(row.RCode);
				$("#Description").val(row.RDesc);
				$("#RCFrequency").combobox('setValue',row.RFrequency);
            },
	});
})
$("#btnAdd").click(function(){
	var ReportCode=$("#Code").val();
	var ReportDesc=$("#Description").val();
	var ReportFrequency=$("#RCFrequency").combobox('getValue');
	if (ReportCode==""||ReportDesc==""||ReportFrequency=="")
	{
		$.messager.alert('提示','需要保存的内容不完整!','error');
		return;
	}
	$m({
		ClassName:"web.DHCBPReportCat",
		MethodName:"InsertReportCat",
		Code:ReportCode,
		Desc:ReportDesc,
		Frequency:ReportFrequency,
		},function(textData){
			if(textData.indexOf("成功")>0)
			{
				$.messager.show({
					timeout:1000,
					title:"提示",
					msg:"添加成功",
					showType:'slide'			
				});
				$('#dataBox').datagrid('reload');
			}
			else{
				alert(textData);
			}	
		}
	);
})
$("#btnEdit").click(function(){
	var Row =$('#dataBox').datagrid('getSelected');
	var ReportCode=$("#Code").val();
	var ReportDesc=$("#Description").val();
	var ReportFrequency=$("#RCFrequency").combobox('getValue');
	if (ReportCode==""||ReportDesc==""||ReportFrequency=="")
	{
		$.messager.alert('提示','需要更新的内容不完整!','error');
	}
	if (!Row){
		$.messager.alert('提示','未选中更新数据!','error');
	}else{
		$m({
		ClassName:"web.DHCBPReportCat",
		MethodName:"UpdateReportCat",
		Code:ReportCode,
		Desc:ReportDesc,
		Frequency:ReportFrequency,
		rowId:Row.RRowId
		},function(textData){
			if(textData.indexOf("成功")>0)
			{
				$.messager.show({
					timeout:1000,
					title:"提示",
					msg:"修改成功",
					showType:'slide'			
				});
				$('#dataBox').datagrid('reload');
			}
			else{
				alert(textData);
			}	
		});
	}
})

$("#btnDel").click(function(){
	var Row =$('#dataBox').datagrid('getSelected');	
	if (!Row)
	{
		$.messager.show({
			timeout:1000,
			title:"提示",
			msg:"请选中删除的数据",
			showType:'slide'
		});
	}else
	{
		var oldOk = $.messager.defaults.ok;
		var oldCancel = $.messager.defaults.cancel;
		$.messager.defaults.ok = "同意";
		$.messager.defaults.cancel = "拒绝";
		$.messager.confirm("删除", "确定删除一级目录以及二级三级目录相关数据吗?", function (r) {
		if (r) {
			$m({
				ClassName:"web.DHCBPReportCat",
				MethodName:"DeleteReportCat",
				rowId:Row.RRowId
				},function (textData){
				if(textData.indexOf("S^")!=-1)
				{	
					$.messager.show({
					timeout:1000,
					title:"提示",
					msg:"已删除",
					showType:'slide'
					});
					$('#dataBox').datagrid('reload');
				}else{
					alert(textData);	
				}
			});
		} else {
			$.messager.popover({ msg: "点击了取消" });
		}})
		$.messager.defaults.ok = oldOk;
		$.messager.defaults.cancel = oldCancel;
	}
})
$("#btnFind").click(function(){
	var ReportCode=$("#Code").val();
	var ReportDesc=$("#Description").val();
	var ReportFrequency=$("#RCFrequency").combobox('getValue');
	$("#dataBox").datagrid('load',{
		ClassName:"web.DHCBPReportCat",
		QueryName:"SelectReportCat",
		Code:ReportCode,
		Desc:ReportDesc,
		Frequency:ReportFrequency,
		});
})
