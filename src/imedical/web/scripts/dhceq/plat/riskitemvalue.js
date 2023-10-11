var preRowID=0
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
	
);
function initDocument()
{
	initPanel();
}
function initPanel()
{
	initTopPanel();		
}
//初始化查询头面板
function initTopPanel()
{
	//showBtnIcon('BFind',false); //modified by LMH 20230202 动态设置是否极简显示按钮图标
	//initButtonWidth();  //modified by LMH 20230302 UI
	jQuery('#BFind').on("click", BFind_Clicked);
	defindTitleStyle();
	initMessage("");   //Modefied by zc 2018-12-21  zc0047  修改弹出提示undefined
	setRequiredElements("Weight^Desc")
	initDHCEQCRiskItemValue();			//初始化表格

}	
function BFind_Clicked()
{
	initDHCEQCRiskItemValue()
}
function initDHCEQCRiskItemValue()
{
	$HUI.datagrid("#tDHCEQCRiskItemValue",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Risk.CTItem",
	        QueryName:"GetRiskItemValue",
	        RiskItem:getElementValue("RiskItem"),
	        Weight:getElementValue("Weight"),
			Desc:getElementValue("Desc"),
	    },
	    //border : false,
	    singleSelect:true,
		//fitColumns:true, //modified by LMH 20230202  列少时默认向左对齐
		pagination:true,
    	columns:[[
			{field:'TRowID',title:'TRowID',width:0,align:'center',hidden:true},
			{field:'TDesc',title:'描述',width:250,align:'center'},
			{field:'TWeight',title:'权重',width:100,align:'center'},
			{field:'TRemark',title:'备注',width:100,align:'center'},
		]],
    	toolbar:[
			{
				id:"add",
				iconCls:'icon-add',
				text:'新增',
				handler:function(){AddGridData();}
			},
			{
				id:"update",
				iconCls:'icon-update',
				text:'更新',
				handler:function(){UpdateGridData();}
			},
			{
				id:"delete",
				iconCls:'icon-cancel',  //modify by zc0062 2020-04-03 UI评审按钮图标调整
				text:'删除',
				handler:function(){DeleteGridData();}
			}
		], 
		onClickRow:function(rowIndex,rowData){OnclickRow();},

});
}
function CombineData()
{
	var val="";
	val=$("#RowID").val();
	val+="^"+$("#RiskItem").val();
	val+="^"+$("#Weight").val();
	val+="^"+$("#Desc").val();
	val+="^"+$("#Remark").val();
	return val;
}

function OnclickRow()
{
	var selected=$('#tDHCEQCRiskItemValue').datagrid('getSelected');
	if(selected)
	{
		var selectedRowID=selected.TRowID;
		if(preRowID!=selectedRowID)
		{
			FillData(selectedRowID)
			$("#RowID").val(selectedRowID)
			preRowID=selectedRowID;
		}
		else
		{
			ClearElement();
			$('#tDHCEQCRiskItemValue').datagrid('unselectAll');
			selectedRowID = 0;
			preRowID=0;
		}
	}
}
function FillData(rowid)
{
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQ.Risk.CTItem',
			MethodName:'GetOneRiskItemValue',
			Arg1:rowid,
			ArgCnt:1
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			var list=data.split("^");
			//messageShow("","","",list)
			$('#Weight').val(list[1]);
			$('#Desc').val(list[2]);
			$('#Remark').val(list[3]);
		}
	});
}
function ClearElement()
{
	$('#RowID').val("");
	$('#Weight').val("");
	$('#Desc').val("");
	$('#Remark').val("");
}
function AddGridData()
{
	if($("#RowID").val()!=""){$.messager.alert('提示','新增失败,你可能选中一条记录！','warning');return;}
	if (checkMustItemNull()) return;
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQ.Risk.CTItem',
			MethodName:'SaveRiskItemValue',
			Arg1:CombineData(),
			Arg2:'',
			ArgCnt:2
		},
		beforeSend:function(){$.messager.progress({text:'正在保存中'})},
		error:function(XMLHttpRequest,textStatus,errorThrown){
			messageShow("","","",XMLHttpRequest.status);
			messageShow("","","",XMLHttpRequest.readyState);
			messageShow("","","",textStatus);
		},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			data=data.split("^");
			if(data>0)
			{
				$.messager.show({title: '提示',msg: '保存成功'});
				$('#tDHCEQCRiskItemValue').datagrid('reload');
				ClearElement();
			}
			else
			{
				$.messager.alert('保存失败！','错误代码:'+data, 'warning');
			}
		}
	});
}
function UpdateGridData()
{
	if($("#RowID").val()==""){$.messager.alert('提示','更新失败,你要选中一条记录！','warning');return;}
	if (checkMustItemNull()) return;

	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQ.Risk.CTItem',
			MethodName:'SaveRiskItemValue',
			Arg1:CombineData(),
			Arg2:'',
			ArgCnt:2
		},
		beforeSend:function(){$.messager.progress({text:'正在保存中'})},
		success:function(data,response,status)
		{
			$.messager.progress('close');
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			data=data.split("^");
			if(data>0)
			{
				$.messager.show({title: '提示',msg: '更新成功'});
				$('#tDHCEQCRiskItemValue').datagrid('reload');
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
					ClassName:'web.DHCEQ.Risk.CTItem',
					MethodName:'SaveRiskItemValue',
					Arg1:CombineData(),
					Arg2:'1',
					ArgCnt:2
			},
			beforeSend:function(){$.messager.progress({text:'正在删除中'})},
			success:function(data,response,status)
			{
				$.messager.progress('close');
				if(data>0)
				{
					$.messager.show({title: '提示',msg: '删除成功'});
					$('#tDHCEQCRiskItemValue').datagrid('reload');
					ClearElement();
				}
				else
					$.messager.alert('删除失败！','错误代码:'+data, 'warning');
			}
		});
        }
	});
}

