var selectedRow=-1
var columns=getCurColumnsInfo('EM.G.KN.Maint.FaultEquipMap','','',''); 

$(document).ready(function()
{
	initDocument();
	defindTitleStyle();
	initLookUp();
	$HUI.datagrid("#tdhceqmcfaultequipmap",{   
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
        QueryName:"GetFaultEquipMap",
        MapType:getElementValue("MapType"),
        FaultID:getElementValue("FaultID"),
        ESourceType:getElementValue("ESourceType"),
        ESourceID:getElementValue("ESourceID")
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
		$("#cFaultID").html("故障名称")
		var MapType = $HUI.combobox('#MapType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data: [{
			id: '1',
			text: '故障现象'
		},{
			id: '2',
			text: '故障原因'
		},{
			id: '3',
			text: '故障解决方法'
		}],
		onChange:function(){
			if (getElementValue("MapType")==1)
			{
				$("#cFaultID").html("故障现象")
				setElement("FaultID","")
                singlelookup("FaultID","EM.L.FaultCase","","")
			}
			else if (getElementValue("MapType")==2)
			{
				$("#cFaultID").html("故障原因")
				setElement("FaultID","")
                singlelookup("FaultID","EM.L.FaultReason","","")
				
			}
			else if (getElementValue("MapType")==3)
			{
				$("#cFaultID").html("解决方法")
				setElement("FaultID","")
                singlelookup("FaultID","EM.L.DealMethod","","")
				
			}
            },
		});
		
		
	}
	if (jQuery("#ESourceType").prop("type")!="hidden")
	{
		$("#cESourceID").html("来源名称")
		var MapType = $HUI.combobox('#ESourceType',{
		valueField:'id', textField:'text',panelHeight:"auto",
			data: [{
				id: '1',
				text: '设备分类'
			},{
				id: '2',
				text: '设备项'
			}],
		onChange:function(){
			if (getElementValue("ESourceType")==1)
			{
				$("#cESourceID").html("设备分类")
				setElement("ESourceID","")
                singlelookup("ESourceID","EM.L.EquipCat","","")
			}
			else if (getElementValue("ESourceType")==2)
			{
				$("#cESourceID").html("设备项")
				setElement("ESourceID","")
                singlelookup("ESourceID","EM.L.GetMasterItem","","")
				
			}

            },
		});
		
	}
}




function OnclickRow(rowIndex,selected)
{
		if(selectedRow!=rowIndex)
		{
			$('#RowID').val(selected.TRowID);					
			setElement("MapType",selected.TMapTypeID)
			setElement("FaultID",selected.TFault)
			setElement("FaultIDDR",selected.TFaultID)
			setElement("ESourceType",selected.TESourceTypeID)
			setElement("ESourceID",selected.TESource)
			setElement("ESourceIDDR",selected.TESourceID)
			setElement("Code",selected.TCode)
			setElement("Brand",selected.TEBrand)
			setElement("BrandDR",selected.TEBrandDR)
			setElement("ModelDR",selected.TEModelDR)
			setElement("Model",selected.TEModel)
			
			if(getElementValue("MapType")==1){
				document.getElementById('cFaultID').innerHTML="故障现象"
				}
			else if(getElementValue("MapType")==2){
				document.getElementById('cFaultID').innerHTML="故障原因"
				}
			else if(getElementValue("MapType")==3){
				document.getElementById('cFaultID').innerHTML="解决方法"
				}
			if(getElementValue("ESourceTypeID")==1){
				document.getElementById('cESourceID').innerHTML="设备分类"
				}
			else if(getElementValue("ESourceTypeID")==2){
				document.getElementById('cESourceID').innerHTML="设备项"
				}
			
			
			if(selected.TUsedFlag=="Y")
			{
				setElement("UsedFlag",true)

			}
			else{
				setElement("UsedFlag",false)
					}
			selectedRow=rowIndex;

		}
		else
		{
			ClearElement();
			$('#tdhceqmcfaultequipmap').datagrid('unselectAll');
			selectedRow =-1;
			document.getElementById('cFaultID').innerHTML="故障名称"
			document.getElementById('cESourceID').innerHTML="来源名称"
		}
}
function CombineData()
{
	var val="";
	val=getElementValue("RowID");
	val+="^"+getElementValue("MapType");
	val+="^"+getElementValue("FaultIDDR");
	val+="^"+getElementValue("ESourceType");
	val+="^"+getElementValue("ESourceIDDR");
	val+="^"+getElementValue("ModelDR");
	val+="^"+getElementValue("BrandDR");
	val+="^"+getElementValue("UsedFlag");      //使用标志
	
	
	return val;
}

function FindGridData() 
{
	$HUI.datagrid("#tdhceqmcfaultequipmap",{   
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.EM.KNMaint",
        QueryName:"GetFaultEquipMap",
        MapType:getElementValue("MapType"),
        FaultID:getElementValue("FaultIDDR"),
        ESourceType:getElementValue("ESourceType"),
        ESourceID:getElementValue("ESourceIDDR")
    },
	});
	//ClearElement();
}

function ClearElement()
{
	setElement("RowID","")
	setElement("MapType","")
	setElement("FaultID","")
	setElement("FaultIDDR","")
	setElement("ESourceType","")
	setElement("ESourceID","")
	setElement("ESourceIDDR","")
	setElement("Model","")
	setElement("Brand","")
	setElement("ModelDR","")
	setElement("BrandDR","")
	setElement("UsedFlag","")

}

function AddGridData()
{
	if($("#RowID").val()!=""){$.messager.alert('提示','新增失败,你可能选中一条记录！','warning');return;}
	if(getElementValue("MapType")==""){$.messager.alert('提示','新增失败,主要类型不能为空！','warning');return;}
	if(getElementValue("FaultIDDR")==""){$.messager.alert('提示','新增失败,故障ID不能为空！','warning');return;}
	if(getElementValue("ESourceType")==""){$.messager.alert('提示','新增失败,来源类型不能为空！','warning');return;}
	if(getElementValue("ESourceIDDR")==""){$.messager.alert('提示','新增失败,来源ID不能为空！','warning');return;}
	if((getElementValue("ESourceType")==1)&(getElementValue("ModelDR")!="")){$.messager.alert('提示','新增失败,设备分类无机型！','warning');return;}
	
	//modify by lmm 2018-11-28 begin
	var Data=CombineData()
	var data=tkMakeServerCall("web.DHCEQ.EM.KNMaint","SaveFaultEquipMapData",Data);
	if(data>0)
	{
		$.messager.show({title: '提示',msg: '保存成功'});
		$('#tdhceqmcfaultequipmap').datagrid('reload');
		ClearElement();
	}
	else
		$.messager.alert('保存失败！','错误代码:'+data, 'warning');
	//modify by lmm 2018-11-28 end
		
}

function UpdateGridData()
{
	if($("#RowID").val()==""){$.messager.alert('提示','请选择一条数据！','warning');return;}
	if(getElementValue("MapType")==""){$.messager.alert('提示','新增失败,主要类型不能为空！','warning');return;}
	if(getElementValue("FaultID")==""){$.messager.alert('提示','新增失败,故障ID不能为空！','warning');return;}
	if(getElementValue("ESourceType")==""){$.messager.alert('提示','新增失败,来源类型不能为空！','warning');return;}
	if(getElementValue("ESourceID")==""){$.messager.alert('提示','新增失败,来源ID不能为空！','warning');return;}
	if((getElementValue("ESourceType")==1)&(getElementValue("ModelDR")!="")){$.messager.alert('提示','新增失败,设备分类无机型！','warning');return;}
	
	//modify by lmm 2018-11-28 begin
	var Data=CombineData()
	var data=tkMakeServerCall("web.DHCEQ.EM.KNMaint","SaveFaultEquipMapData",Data);
	if(data>0)
	{
		$.messager.show({title: '提示',msg: '更新成功'});
		$('#tdhceqmcfaultequipmap').datagrid('reload');
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
			var data=tkMakeServerCall("web.DHCEQ.EM.KNMaint","DeleteFaultEquipMapData",RowID);
			if(data==0)
			{
				$.messager.show({title: '提示',msg: '删除成功'});
				$('#tdhceqmcfaultequipmap').datagrid('reload');
				ClearElement();
			}
			else
				$.messager.alert('删除失败！','错误代码:'+data, 'warning');
			//modify by lmm 2018-11-28 end
	       
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