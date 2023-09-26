var preRowID=0
var GlobalObj = {
	MapTypeID : "",
	ClearData : function(vElementID)
	{
		if (vElementID=="ESourceID") this.ItemDR="";
	},
	ClearAll : function()
	{
		this.MapTypeID = "";
	}
}

$(document).ready(function()
{
	initDocument();
	$('#tdhceqmccasereasondealmap').datagrid({
		url:'dhceq.jquery.csp',
		border:'true',
		fit:'true',
		queryParams:{
			ClassName:"web.DHCEQM.DHCEQMCCaseReasonDealMap",
			QueryName:"GetCaseReasonDealMap",
			Arg1:$("#MapType").val(),
			Arg2:$("#SourceID").combogrid("getValue"),
			Arg3:$("#MapSourceID").combogrid("getValue"),
			ArgCnt:3
			},
		rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:true,
		toolbar:[
			{
				iconCls:'icon-add',
				text:'新增',
				handler:function(){AddGridData();}
			},'-----------------------------------',
			{
				iconCls:'icon-save',
				text:'保存',
				handler:function(){UpdateGridData();}
			},'-----------------------------------',
			{
				iconCls:'icon-cut',
				text:'删除',
				handler:function(){DeleteGridData();}
			},'-----------------------------------',
			{
				iconCls:'icon-search',
				text:'查询',
				handler:function(){FindGridData();}
			}
		],
		columns:[[
			{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
			{field:'TMapTypeID',title:'主要类型ID',width:100,align:'center',hidden:true}, 
			{field:'TMapType',title:'主要类型',width:150,align:'center'},
			{field:'TSourceID',title:'来源ID',width:50,align:'center',hidden:true}, 
			{field:'TSource',title:'来源名称',width:100,align:'center'},
			{field:'TMapSourceID',title:'对照ID',width:100,align:'center',hidden:true},
			{field:'TMapSource',title:'对照名称',width:150,align:'center'},
		]],
		onClickRow:function(rowIndex,rowData){OnclickRow();},
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75]
	});

	
});
function initDocument()
{
	GlobalObj.ClearAll();
	if (jQuery("#MapType").prop("type")!="hidden")
	{
		document.getElementById('TDSourceID').innerHTML="来源名称"
		document.getElementById('TDMapSourceID').innerHTML="对照名称"
		jQuery("#MapType").combobox({
			width:150,
			height: 24,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '1',
				text: '故障现象与故障原因对照'
			},{
				id: '2',
				text: '故障原因与解决方法对照'
			}],
			onSelect: function() {GlobalObj.MapTypeID=jQuery("#MapType").combobox("getValue");
			if (GlobalObj.MapTypeID==1)
			{
				document.getElementById('TDSourceID').innerHTML="故障现象"
				document.getElementById('TDMapSourceID').innerHTML="故障原因"
				$("#SourceID").combogrid({
				idField:'TRowID',
				textField:'TName',
				url:'dhceq.jquery.csp',
				queryParams:{
					ClassName:'web.DHCEQ.Process.DHCEQFind',
					QueryName:'FaultCase',
					Arg1:'',Arg2:'',Arg3:'',
					ArgCnt:3
					},
				columns:[[
					{field:'TRowID',title:'单位',width:30,align:'center',hidden:true},
					{field:'TCode',title:'代码',width:30,align:'center'},
					{field:'TName',title:'描述',width:170,align:'center'}
				]],
				pagination:true,
				pageSize:15,
				pageNumber:1,
				pageList:[15,30,45,60,75]

			});
				$("#MapSourceID").combogrid({
				idField:'TRowID',
				textField:'TName',
				url:'dhceq.jquery.csp',
				queryParams:{
					ClassName:'web.DHCEQ.Process.DHCEQFind',
					QueryName:'Faultreason',
					Arg1:'',Arg2:'',Arg3:'',
					ArgCnt:3
					},
				columns:[[
					{field:'TRowID',title:'单位',width:30,align:'center',hidden:true},
					{field:'TCode',title:'代码',width:30,align:'center'},
					{field:'TName',title:'描述',width:170,align:'center'}
				]],
				//fit:'true',
				pagination:true,
				pageSize:15,
				pageNumber:1,
				pageList:[15,30,45,60,75]
			});			
			}
			else if(GlobalObj.MapTypeID==2) 
			{
				document.getElementById('TDSourceID').innerHTML="故障原因"
				document.getElementById('TDMapSourceID').innerHTML="解决方法"			
				$("#SourceID").combogrid({
				idField:'TRowID',
				textField:'TName',
				url:'dhceq.jquery.csp',
				queryParams:{
					ClassName:'web.DHCEQ.Process.DHCEQFind',
					QueryName:'Faultreason',
					Arg1:'',Arg2:'',Arg3:'',
					ArgCnt:3
					},
				columns:[[
					{field:'TRowID',title:'单位',width:30,align:'center',hidden:true},
					{field:'TCode',title:'代码',width:30,align:'center'},
					{field:'TName',title:'描述',width:170,align:'center'}
				]],
				pagination:true,
				pageSize:15,
				pageNumber:1,
				pageList:[15,30,45,60,75]

			});			
				$("#MapSourceID").combogrid({
				idField:'TRowID',
				textField:'TName',
				url:'dhceq.jquery.csp',
				queryParams:{
					ClassName:'web.DHCEQ.Process.DHCEQFind',
					QueryName:'DealMethod',
					Arg1:'',Arg2:'',Arg3:'',
					ArgCnt:3
					},
				columns:[[
					{field:'TRowID',title:'单位',width:30,align:'center',hidden:true},
					{field:'TCode',title:'代码',width:30,align:'center'},
					{field:'TName',title:'描述',width:170,align:'center'}
				]],
				pagination:true,
				pageSize:15,
				pageNumber:1,
				pageList:[15,30,45,60,75]
			});		
			}
			}
		});
	}
}

function OnclickRow()
{
	var selected=$('#tdhceqmccasereasondealmap').datagrid('getSelected');
	if(selected)
	{
		var selectedRowID=selected.TRowID;
		if(preRowID!=selectedRowID)
		{
			$('#RowID').val(selected.TRowID);					
			$('#MapTypeID').val(selected.TMapTypeID);
			GlobalObj.MapTypeID=selected.TMapTypeID;
			$('#MapType').combobox('setText',selected.TMapType);
			$('#SourceID').combogrid('setValue',selected.TSourceID);
			$('#SourceID').combogrid('setText',selected.TSource);
			//$('#Source').combogrid('setValue',selected.TSource);
			$('#MapSourceID').combogrid('setValue',selected.TMapSourceID);
			$('#MapSourceID').combogrid('setText',selected.TMapSource);
			if(GlobalObj.MapTypeID==1)
			{
				document.getElementById('TDSourceID').innerHTML="故障现象"
				document.getElementById('TDMapSourceID').innerHTML="故障原因"

			}
			else if(GlobalObj.MapTypeID==2)
			{
				document.getElementById('TDSourceID').innerHTML="故障原因"
				document.getElementById('TDMapSourceID').innerHTML="解决方法"			
	
			}
			preRowID=selectedRowID;

		}
		else
		{
			ClearElement();
			$('#tdhceqmccasereasondealmap').datagrid('unselectAll');
				document.getElementById('TDSourceID').innerHTML="来源名称"
				document.getElementById('TDMapSourceID').innerHTML="对照名称"			
			selectedRowID = 0;
			preRowID=0;
		}
	}
}
function CombineData()
{
	var val="";
	val=$("#RowID").val();
	val+="^"+GlobalObj.MapTypeID;
	val+="^"+$("#SourceID").combogrid("getValue");
	val+="^"+$("#MapSourceID").combogrid("getValue");
	
	return val;
}

function FindGridData() 
{
	$('#tdhceqmccasereasondealmap').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
			ClassName:'web.DHCEQM.DHCEQMCCaseReasonDealMap',
			QueryName:'GetCaseReasonDealMap',
			Arg1:$("#MapType").val(),
			Arg2:$("#SourceID").combogrid("getValue"),
			Arg3:$("#MapSourceID").combogrid("getValue"),
			ArgCnt:3
		}
	});
	ClearElement();
}

function ClearElement()
{
	$('#RowID').val('');
	GlobalObj.MapTypeID="";
	$('#MapType').combobox('setValue',''); 
	$('#SourceID').combogrid('setValue','');
	$('#MapSourceID').combogrid('setValue','');

}

function AddGridData()
{
	if($("#RowID").val()!=""){$.messager.alert('提示','新增失败,你可能选中一条记录！','warning');return;}
	if(GlobalObj.MapTypeID==""){$.messager.alert('提示','新增失败,主要类型不能为空！','warning');return;}
	if($("#SourceID").combogrid('getValue')==""){$.messager.alert('提示','新增失败,故障ID不能为空！','warning');return;}
	if($("#MapSourceID").combogrid('getValue')==""){$.messager.alert('提示','新增失败,来源ID不能为空！','warning');return;}
    $.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQM.DHCEQMCCaseReasonDealMap',
			MethodName:'SaveData',
			Arg1:CombineData(),
			ArgCnt:1
			
		},		
		beforeSend:function(){$.messager.progress({text:'正在保存中'})		
		},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			messageShow("","","",XMLHttpRequest.status);
			messageShow("","","",XMLHttpRequest.readyState);
			messageShow("","","",textStatus);
		},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			if(data>0)
			{
				$.messager.show({title: '提示',msg: '保存成功'});
				$('#tdhceqmccasereasondealmap').datagrid('reload');
				ClearElement();
			}
			else
				$.messager.alert('保存失败！','错误代码:'+data, 'warning');
		}
	});
}

function UpdateGridData()
{
	//messageShow("","","",CombineData())
	if($("#RowID").val()==""){$.messager.alert('提示','请选择一条数据！','warning');return;}
	//if(GlobalObj.MapTypeID==""){$.messager.alert('提示','主要类型不能为空！','warning');return;}
	if($("#SourceID").combogrid('getValue')==""){$.messager.alert('提示','故障ID不能为空！','warning');return;}
	//if(GlobalObj.ESourceTypeID==""){$.messager.alert('提示','来源类型不能为空！','warning');return;}
	if($("#MapSourceID").combogrid('getValue')==""){$.messager.alert('提示','来源ID不能为空！','warning');return;}
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQM.DHCEQMCCaseReasonDealMap',
			MethodName:'SaveData',
			Arg1:CombineData(),
			ArgCnt:1
		},
		beforeSend:function(){$.messager.progress({text:'正在保存中'})},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			if(data>0)
			{
				$.messager.show({title: '提示',msg: '更新成功'});
				$('#tdhceqmccasereasondealmap').datagrid('reload');
				ClearElement();
			}
			else
				$.messager.alert('更新失败！','错误代码:'+data, 'warning');
		}
	});
}

function DeleteGridData()
{
	if($("#RowID").val()==""){$.messager.alert('提示','请选择一条数据！','warning');return;}
	$.messager.confirm('确认', '您确定要删除所选的行吗？', function(b)
	{
		if (b==false){return;}
        else
        {
		$.ajax({
			url:'dhceq.jquery.method.csp',
			type:'POST',
			data:{
				ClassName:'web.DHCEQM.DHCEQMCCaseReasonDealMap',
				MethodName:'DeleteData',
				Arg1:$("#RowID").val(),
				ArgCnt:1
			},
			beforeSend:function(){$.messager.progress({text:'正在删除中'})},
			success:function(data,response,status)
			{
				$.messager.progress('close');
				if(data==0)
				{
					$.messager.show({title: '提示',msg: '删除成功'});
					$('#tdhceqmccasereasondealmap').datagrid('reload');
					ClearElement();
				}
				else
					$.messager.alert('删除失败！','错误代码:'+data, 'warning');
			}
		});
        }
	});
}