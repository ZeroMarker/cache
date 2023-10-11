var preRowID=0
var t=[]             //add hly 20190724
t[-3003]="数据重复"  //add hly 20190724
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
	showBtnIcon('BFind',false); //modified by LMH 20230202 动态设置是否极简显示按钮图标
	initButtonWidth();
	jQuery('#BFind').on("click", BFind_Clicked);
	defindTitleStyle();
	initMessage("");   //Modefied by zc 2018-12-21  zc0047  修改弹出提示undefined
	initLookUp();	//CZF0134 2021-02-23
	setRequiredElements("Code^Desc")
	initDHCEQCRiskGrade();			//初始化表格

}	
function CombineData()
{
	var val="";
	val=$("#RowID").val();
	val+="^"+$("#Code").val();
	val+="^"+$("#Desc").val();
	val+="^"+$("#MinValue").val();
	val+="^"+$("#MaxValue").val();
	val+="^"+$("#Remark").val();
	val+="^"+$("#CycleNum").val();		//CZF0134 2021-02-23
	val+="^"+$("#CycleUnitDR").val();
	return val;
}

function OnclickRow()
{
	var selected=$('#tDHCEQCRiskGrade').datagrid('getSelected');
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
			$('#tDHCEQCRiskGrade').datagrid('unselectAll');
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
			ClassName:'web.DHCEQ.Risk.CTGrade',
			MethodName:'GetOneRiskGrade',
			Arg1:rowid,
			ArgCnt:1
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			var list=data.split("^");
			//messageShow("","","",list)
			$('#Code').val(list[0]);
			$('#Desc').val(list[1]);
			$('#MinValue').val(list[2]);
			$('#MaxValue').val(list[3]);
			$('#Remark').val(list[4]);
			$('#CycleNum').val(list[6]);	//CZF0134 2021-02-23
			$('#CycleUnitDR').val(list[7]);
			$('#CycleUnit').val(list[8]);
		}
	});
}
function ClearElement()
{
	$('#RowID').val("");
	$('#Code').val("");
	$('#Desc').val("");
	$('#MinValue').val("");
	$('#MaxValue').val("");
	$('#Remark').val("");
	$('#CycleNum').val("");		//CZF0134 2021-02-23
	$('#CycleUnitDR').val("");
	$('#CycleUnit').val("");
}
function BFind_Clicked()
{
	initDHCEQCRiskGrade()
}

function AddGridData()
{
	if($("#RowID").val()!=""){$.messager.alert('提示','新增失败,你可能选中一条记录！','warning');return;}
	if (checkMustItemNull()) return;
	$.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQ.Risk.CTGrade',
			MethodName:'SaveData',
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
				$('#tDHCEQCRiskGrade').datagrid('reload');
				ClearElement();
			}
			else
			{
				$.messager.alert('保存失败！',t[data], 'warning');  //modify hly 20190724
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
			ClassName:'web.DHCEQ.Risk.CTGrade',
			MethodName:'SaveData',
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
				$('#tDHCEQCRiskGrade').datagrid('reload');
				ClearElement();
			}
			else
				$.messager.alert('更新失败！',t[data], 'warning'); //modify hly 20190724
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
					ClassName:'web.DHCEQ.Risk.CTGrade',
					MethodName:'SaveData',
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
					$('#tDHCEQCRiskGrade').datagrid('reload');
					ClearElement();
				}
				else
					$.messager.alert('删除失败！','错误代码:'+data, 'warning');
			}
		});
        }
	});
}
function initDHCEQCRiskGrade()
{
	$HUI.datagrid("#tDHCEQCRiskGrade",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Risk.CTGrade",
	        QueryName:"GetRiskGrade",
	        Code:getElementValue("Code"),
			Desc:getElementValue("Desc"),
			MinValue:getElementValue("MinValue"),
			MaxValue:getElementValue("MaxValue"),
	    },
	    //border : false,
	    fit:true,  //midified by LMH 20230202 UI布局调整 错误修改
	    singleSelect:true,
		//fitColumns:true, //midified by LMH 20230202 UI布局调整
		pagination:true,
    	columns:[[
			{field:'TRowID',title:'TRowID',width:0,align:'center',hidden:true},
			{field:'TCode',title:'代码',width:100,align:'center'},
			{field:'TDesc',title:'描述',width:250,align:'center'},
			{field:'TMinValue',title:'最小值',width:100,align:'center'},
			{field:'TMaxValue',title:'最大值',width:100,align:'center'},
			{field:'TCycle',title:'周期',width:100,align:'center'},		//CZF0134 2021-02-23
			{field:'TCycleNum',title:'周期',width:20,align:'center',hidden:true},
			{field:'TCycleUnitDR',title:'TCycleUnitDR',width:20,align:'center',hidden:true},
			{field:'TRemark',title:'备注',width:100,align:'center'},
		]],
    	toolbar:[
			{
				id:"add",
				iconCls:'icon-add',
				text:'新增',
				handler:function(){AddGridData();}
			},  //modify by lmm 2020-03-30 UI布局调整
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
//CZF0134 2021-02-23
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	
}
