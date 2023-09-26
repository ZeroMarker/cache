var selectedRow=-1
var columns=getCurColumnsInfo('EM.G.KN.Maint.CaseReasonDealMap','','',''); 

$(document).ready(function()
{
	initDocument();
	
	defindTitleStyle();
	initLookUp();
	$HUI.datagrid("#tdhceqmccasereasondealmap",{   
    url:$URL, 
	idField:'TRowID', //����   
    border : false,
	striped : true,
    cache: false,
    fit:true,
    singleSelect:true,
		toolbar:[
			{
				iconCls:'icon-add',
				text:'����',
				handler:function(){AddGridData();}
			},
			{
				iconCls:'icon-save',
				text:'����',
				handler:function(){UpdateGridData();}
			},
			{
				iconCls:'icon-cut',
				text:'ɾ��',
				handler:function(){DeleteGridData();}
			},
			{
				iconCls:'icon-search',
				text:'��ѯ',
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
		document.getElementById('cSourceID').innerHTML="��Դ����"
		document.getElementById('cMapSourceID').innerHTML="��������"
		var MapType = $HUI.combobox('#MapType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data: [{
			id: '1',
			text: '�������������ԭ�����'
		},{
			id: '2',
			text: '����ԭ��������������'
		}],
		onChange:function(){
			if (getElementValue("MapType")==1)
			{
				document.getElementById('cSourceID').innerHTML="��������"
				document.getElementById('cMapSourceID').innerHTML="����ԭ��"
				setElement("SourceID","")
				setElement("MapSourceID","")
                singlelookup("SourceID","EM.L.FaultCase","","")
                singlelookup("MapSourceID","EM.L.FaultReason","","")
			}
			else if (getElementValue("MapType")==2)
			{
				document.getElementById('cSourceID').innerHTML="����ԭ��"
				document.getElementById('cMapSourceID').innerHTML="�������"			
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
				document.getElementById('cSourceID').innerHTML="��������"
				document.getElementById('cMapSourceID').innerHTML="����ԭ��"

			}
			else if(getElementValue("MapType")==2)
			{
				document.getElementById('cSourceID').innerHTML="����ԭ��"
				document.getElementById('cMapSourceID').innerHTML="�������"			
	
			}
			selectedRow=rowIndex;

		}
		else
		{
			ClearElement();
			$('#tdhceqmccasereasondealmap').datagrid('unselectAll');
				document.getElementById('cSourceID').innerHTML="��Դ����"
				document.getElementById('cMapSourceID').innerHTML="��������"			
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
	if(getElementValue("RowID")!=""){$.messager.alert('��ʾ','����ʧ��,�����ѡ��һ����¼��','warning');return;}
	if(getElementValue("MapType")==""){$.messager.alert('��ʾ','����ʧ��,��Ҫ���Ͳ���Ϊ�գ�','warning');return;}
	if(getElementValue("SourceIDDR")==""){$.messager.alert('��ʾ','����ʧ��,����ID����Ϊ�գ�','warning');return;}
	if(getElementValue("MapSourceIDDR")==""){$.messager.alert('��ʾ','����ʧ��,��ԴID����Ϊ�գ�','warning');return;}
   
	//modify by lmm 2018-11-28 begin
	var Data=CombineData()
	var data=tkMakeServerCall("web.DHCEQ.EM.KNMaint","SaveCaseReasonDealMapData",Data);
	if(data>0)
	{
		$.messager.show({title: '��ʾ',msg: '����ɹ�'});
		$('#tdhceqmccasereasondealmap').datagrid('reload');
		ClearElement();
	}
	else
		$.messager.alert('����ʧ�ܣ�','�������:'+data, 'warning');
	//modify by lmm 2018-11-28 end
}

function UpdateGridData()
{
	if(getElementValue("RowID")==""){$.messager.alert('��ʾ','��ѡ��һ�����ݣ�','warning');return;}
	if(getElementValue("MapType")==""){$.messager.alert('��ʾ','����ʧ��,��Ҫ���Ͳ���Ϊ�գ�','warning');return;}
	if(getElementValue("SourceIDDR")==""){$.messager.alert('��ʾ','����ʧ��,����ID����Ϊ�գ�','warning');return;}
	if(getElementValue("MapSourceIDDR")==""){$.messager.alert('��ʾ','����ʧ��,��ԴID����Ϊ�գ�','warning');return;}
	//modify by lmm 2018-11-28 begin
	var Data=CombineData()
	var data=tkMakeServerCall("web.DHCEQ.EM.KNMaint","SaveCaseReasonDealMapData",Data);
	if(data>0)
	{
		$.messager.show({title: '��ʾ',msg: '���³ɹ�'});
		$('#tdhceqmccasereasondealmap').datagrid('reload');
		ClearElement();
	}
	else
		$.messager.alert('����ʧ�ܣ�','�������:'+data, 'warning');
	//modify by lmm 2018-11-28 end

}

function DeleteGridData()
{
	if($("#RowID").val()==""){$.messager.alert('��ʾ','��ѡ��һ�����ݣ�','warning');return;}
	$.messager.confirm('ȷ��', '��ȷ��Ҫɾ����ѡ������', function(b)
	{
		if (b==false){return;}
        else
        {
			//modify by lmm 2018-11-28 begin
			var RowID=$("#RowID").val()
			var data=tkMakeServerCall("web.DHCEQ.EM.KNMaint","DeleteCaseReasonDealMapData",RowID);
			if(data==0)
			{
				$.messager.show({title: '��ʾ',msg: 'ɾ���ɹ�'});
				$('#tdhceqmccasereasondealmap').datagrid('reload');
				ClearElement();
			}
			else
				$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
        }
	});
}
///add by lmm 2018-11-01 ������dr��ֵ
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	
}
///add by lmm 2018-11-01 ������drֵ���
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}