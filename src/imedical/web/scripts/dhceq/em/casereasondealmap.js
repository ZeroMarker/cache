var selectedRow=-1
var columns=getCurColumnsInfo('EM.G.KN.Maint.CaseReasonDealMap','','',''); 

$(document).ready(function()
{
	initDocument();
	
	defindTitleStyle();
	initLookUp();
	$HUI.datagrid("#tdhceqmccasereasondealmap",{   
    url:$URL, 
	idField:'TRowID', //主键   
    border : false,
	striped : true,
    cache: false,
    fit:true,
    singleSelect:true,
		toolbar:[
			{
				iconCls:'icon-add',
				text:'新增',
				handler:function(){AddGridData();}
			},
			{
				iconCls:'icon-save',
				text:'保存',
				handler:function(){UpdateGridData();}
			},
			{
				iconCls:'icon-cut',
				text:'删除',
				handler:function(){DeleteGridData();}
			},
			{
				iconCls:'icon-search',
				text:'查询',
				handler:function(){FindGridData();}
			}
		],
    queryParams:{
        ClassName:"web.DHCEQ.EM.KNMaint",
        QueryName:"GetCaseReasonDealMap",
        MapType:getElementValue("MapType"),
        SourceID:getElementValue("SourceID"),
        MapSourceID:getElementValue("MapSourceID")
    },
	//fitColumns:true,
	pagination:true,
	columns:columns, 
	onClickRow:function(rowIndex,rowData){OnclickRow(rowIndex,rowData);},
	});
	

	
});
function initDocument()
{
	if (jQuery("#MapType").prop("type")!="hidden")
	{
		document.getElementById('cSourceID').innerHTML="来源名称"
		document.getElementById('cMapSourceID').innerHTML="对照名称"
		var MapType = $HUI.combobox('#MapType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data: [{
			id: '1',
			text: '故障现象与故障原因对照'
		},{
			id: '2',
			text: '故障原因与解决方法对照'
		}],
		onChange:function(){
			if (getElementValue("MapType")==1)
			{
				document.getElementById('cSourceID').innerHTML="故障现象"
				document.getElementById('cMapSourceID').innerHTML="故障原因"
				setElement("SourceID","")
				setElement("MapSourceID","")
                singlelookup("SourceID","EM.L.FaultCase","","")
                singlelookup("MapSourceID","EM.L.FaultReason","","")
			}
			else if (getElementValue("MapType")==2)
			{
				document.getElementById('cSourceID').innerHTML="故障原因"
				document.getElementById('cMapSourceID').innerHTML="解决方法"			
				setElement("SourceID","")
				setElement("MapSourceID","")
                singlelookup("SourceID","EM.L.FaultReason","","")
                singlelookup("MapSourceID","EM.L.DealMethod","","")
			}
			
			},
		});
	}
		
		
		
}

function OnclickRow(rowIndex,selected)
{
		if(rowIndex!=selectedRow)
		{
			setElement("RowID",selected.TRowID)
			setElement("MapType",selected.TMapTypeID)
			setElement("SourceID",selected.TSource)
			setElement("SourceIDDR",selected.TSourceID)
			setElement("MapSourceID",selected.TMapSource)
			setElement("MapSourceIDDR",selected.TMapSourceID)
			if(getElementValue("MapType")==1)
			{
				document.getElementById('cSourceID').innerHTML="故障现象"
				document.getElementById('cMapSourceID').innerHTML="故障原因"

			}
			else if(getElementValue("MapType")==2)
			{
				document.getElementById('cSourceID').innerHTML="故障原因"
				document.getElementById('cMapSourceID').innerHTML="解决方法"			
	
			}
			selectedRow=rowIndex;

		}
		else
		{
			ClearElement();
			$('#tdhceqmccasereasondealmap').datagrid('unselectAll');
				document.getElementById('cSourceID').innerHTML="来源名称"
				document.getElementById('cMapSourceID').innerHTML="对照名称"			
			selectedRow= -1;
		}
}
function CombineData()
{
	var val="";
	val=getElementValue("RowID");
	val+="^"+getElementValue("MapType");
	val+="^"+getElementValue("SourceIDDR");
	val+="^"+getElementValue("MapSourceIDDR");
	
	return val;
}

function FindGridData() 
{
	$HUI.datagrid("#tdhceqmccasereasondealmap",{   
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.EM.KNMaint",
        QueryName:"GetCaseReasonDealMap",
        MapType:getElementValue("MapType"),
        SourceID:getElementValue("SourceID"),
        MapSourceID:getElementValue("MapSourceID")
    },
	});
}

function ClearElement()
{
	setElement("RowID","")
	setElement("MapType","")
	setElement("SourceID","")
	setElement("MapSourceID","")
	setElement("SourceIDDR","")
	setElement("MapSourceIDDR","")

}

function AddGridData()
{
	if(getElementValue("RowID")!=""){$.messager.alert('提示','新增失败,你可能选中一条记录！','warning');return;}
	if(getElementValue("MapType")==""){$.messager.alert('提示','新增失败,主要类型不能为空！','warning');return;}
	if(getElementValue("SourceIDDR")==""){$.messager.alert('提示','新增失败,故障ID不能为空！','warning');return;}
	if(getElementValue("MapSourceIDDR")==""){$.messager.alert('提示','新增失败,来源ID不能为空！','warning');return;}
   
	//modify by lmm 2018-11-28 begin
	var Data=CombineData()
	var data=tkMakeServerCall("web.DHCEQ.EM.KNMaint","SaveCaseReasonDealMapData",Data);
	if(data>0)
	{
		$.messager.show({title: '提示',msg: '保存成功'});
		$('#tdhceqmccasereasondealmap').datagrid('reload');
		ClearElement();
	}
	else
		$.messager.alert('保存失败！','错误代码:'+data, 'warning');
	//modify by lmm 2018-11-28 end
}

function UpdateGridData()
{
	if(getElementValue("RowID")==""){$.messager.alert('提示','请选择一条数据！','warning');return;}
	if(getElementValue("MapType")==""){$.messager.alert('提示','新增失败,主要类型不能为空！','warning');return;}
	if(getElementValue("SourceIDDR")==""){$.messager.alert('提示','新增失败,故障ID不能为空！','warning');return;}
	if(getElementValue("MapSourceIDDR")==""){$.messager.alert('提示','新增失败,来源ID不能为空！','warning');return;}
	//modify by lmm 2018-11-28 begin
	var Data=CombineData()
	var data=tkMakeServerCall("web.DHCEQ.EM.KNMaint","SaveCaseReasonDealMapData",Data);
	if(data>0)
	{
		$.messager.show({title: '提示',msg: '更新成功'});
		$('#tdhceqmccasereasondealmap').datagrid('reload');
		ClearElement();
	}
	else
		$.messager.alert('更新失败！','错误代码:'+data, 'warning');
	//modify by lmm 2018-11-28 end

}

function DeleteGridData()
{
	if($("#RowID").val()==""){$.messager.alert('提示','请选择一条数据！','warning');return;}
	$.messager.confirm('确认', '您确定要删除所选的行吗？', function(b)
	{
		if (b==false){return;}
        else
        {
			//modify by lmm 2018-11-28 begin
			var RowID=$("#RowID").val()
			var data=tkMakeServerCall("web.DHCEQ.EM.KNMaint","DeleteCaseReasonDealMapData",RowID);
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
///add by lmm 2018-11-01 下拉框dr赋值
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	
}
///add by lmm 2018-11-01 下拉框dr值清空
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}