var selectedRow=-1
var columns=getCurColumnsInfo('EM.G.KN.Maint.FaultEquipMap','','',''); 

$(document).ready(function()
{
	initDocument();
	initButton();
	defindTitleStyle();
	initLookUp();
	$HUI.datagrid("#tdhceqmcfaultequipmap",{   
    url:$URL, 
	idField:'TRowID', //����   
    border : false,
	// striped : true,
	fitColumns: true,
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
				iconCls:'icon-cancel',
				text:'ɾ��',
				handler:function(){DeleteGridData();}
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
	
	setRequiredElements("MapType^ESourceType^ESourceID^FaultID")//add by zyq 2022-11-09
	
});
function initDocument()
{
	
	if (jQuery("#MapType").prop("type")!="hidden")
	{
		$("#cFaultID").html("��������")
		var MapType = $HUI.combobox('#MapType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data: [{
			id: '1',
			text: '��������'
		},{
			id: '2',
			text: '����ԭ��'
		},{
			id: '3',
			text: '���Ͻ������'
		},{
			id: '4',
			text: '��������'  //modified by WY 2022-9-15 ���ӹ������͵Ķ���
		}],
		onChange:function(){
			if (getElementValue("MapType")==1)
			{
				$("#cFaultID").html("��������")
				setElement("FaultID","")
				setRequiredElements("FaultID") //add by zyq 2022-11-09
                singlelookup("FaultID","EM.L.FaultCase","","")
			}
			else if (getElementValue("MapType")==2)
			{
				$("#cFaultID").html("����ԭ��")
				setElement("FaultID","")
				setRequiredElements("FaultID") //add by zyq 2022-11-09
                singlelookup("FaultID","EM.L.FaultReason","","")
				
			}
			else if (getElementValue("MapType")==3)
			{
				$("#cFaultID").html("�������")
				setElement("FaultID","")
				setRequiredElements("FaultID") //add by zyq 2022-11-09
                singlelookup("FaultID","EM.L.DealMethod","","")
				
			}
			else if (getElementValue("MapType")==4)  //modified by WY 2022-9-15 ���ӹ������͵Ķ���
			{
				$("#cFaultID").html("��������")
				setElement("FaultID","")
                singlelookup("FaultID","EM.L.FaultType","","")
				
			}
            },
		});
		
		
	}
	if (jQuery("#ESourceType").prop("type")!="hidden")
	{
		$("#cESourceID").html("��Դ����")
		var MapType = $HUI.combobox('#ESourceType',{
		valueField:'id', textField:'text',panelHeight:"auto",
			data: [{
				id: '1',
				text: '�豸����'
			},{
				id: '2',
				text: '�豸��'
			}],
		onChange:function(){
			if (getElementValue("ESourceType")==1)
			{
				$("#cESourceID").html("�豸����")
				setElement("ESourceID","")
				setRequiredElements("ESourceID") //add by zyq 2022-11-09
                singlelookup("ESourceID","EM.L.EquipCat","","")
			}
			else if (getElementValue("ESourceType")==2)
			{
				$("#cESourceID").html("�豸��")
				setElement("ESourceID","")
				setRequiredElements("ESourceID") //add by zyq 2022-11-09
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
				document.getElementById('cFaultID').innerHTML="��������"
				}
			else if(getElementValue("MapType")==2){
				document.getElementById('cFaultID').innerHTML="����ԭ��"
				}
			else if(getElementValue("MapType")==3){
				document.getElementById('cFaultID').innerHTML="�������"
				}
			else if(getElementValue("MapType")==4){
				document.getElementById('cFaultID').innerHTML="��������" //modified by WY 2022-9-15 ���ӹ������͵Ķ���
				}
			if(getElementValue("ESourceTypeID")==1){
				document.getElementById('cESourceID').innerHTML="�豸����"
				}
			else if(getElementValue("ESourceTypeID")==2){
				document.getElementById('cESourceID').innerHTML="�豸��"
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
			document.getElementById('cFaultID').innerHTML="��������"
			document.getElementById('cESourceID').innerHTML="��Դ����"
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
	val+="^"+getElementValue("UsedFlag");      //ʹ�ñ�־
	
	
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
	if($("#RowID").val()!=""){$.messager.alert('��ʾ','����ʧ��,�����ѡ��һ����¼��','warning');return;}
	if(getElementValue("MapType")==""){$.messager.alert('��ʾ','����ʧ��,��Ҫ���Ͳ���Ϊ�գ�','warning');return;}
	if(getElementValue("FaultIDDR")==""){$.messager.alert('��ʾ','����ʧ��,����ID����Ϊ�գ�','warning');return;}
	if(getElementValue("ESourceType")==""){$.messager.alert('��ʾ','����ʧ��,��Դ���Ͳ���Ϊ�գ�','warning');return;}
	if(getElementValue("ESourceIDDR")==""){$.messager.alert('��ʾ','����ʧ��,��ԴID����Ϊ�գ�','warning');return;}
	if((getElementValue("ESourceType")==1)&(getElementValue("ModelDR")!="")){$.messager.alert('��ʾ','����ʧ��,�豸�����޻��ͣ�','warning');return;}
	
	//modify by lmm 2018-11-28 begin modify by zyq 2023-02-10 begin
	var Data=CombineData()
	var returnValue=tkMakeServerCall("web.DHCEQ.EM.KNMaint","SaveFaultEquipMapData",Data);
	var returnObj=JSON.parse(returnValue)
	if(returnObj.SQLCODE<0)
	{
		messageShow("","","",returnObj.Data);
		return;
	}
	$('#tdhceqmcfaultequipmap').datagrid('reload');
	ClearElement();
	//modify by lmm 2018-11-28 end modify by zyq 2023-02-10 end
		
}

function UpdateGridData()
{
	if($("#RowID").val()==""){$.messager.alert('��ʾ','��ѡ��һ�����ݣ�','warning');return;}
	if(getElementValue("MapType")==""){$.messager.alert('��ʾ','����ʧ��,��Ҫ���Ͳ���Ϊ�գ�','warning');return;}
	if(getElementValue("FaultID")==""){$.messager.alert('��ʾ','����ʧ��,����ID����Ϊ�գ�','warning');return;}
	if(getElementValue("ESourceType")==""){$.messager.alert('��ʾ','����ʧ��,��Դ���Ͳ���Ϊ�գ�','warning');return;}
	if(getElementValue("ESourceID")==""){$.messager.alert('��ʾ','����ʧ��,��ԴID����Ϊ�գ�','warning');return;}
	if((getElementValue("ESourceType")==1)&(getElementValue("ModelDR")!="")){$.messager.alert('��ʾ','����ʧ��,�豸�����޻��ͣ�','warning');return;}
	
	//modify by lmm 2018-11-28 begin modify by zyq 2023-02-10 begin
	var Data=CombineData()
	var returnValue=tkMakeServerCall("web.DHCEQ.EM.KNMaint","SaveFaultEquipMapData",Data);
	var returnObj=JSON.parse(returnValue);
	if(returnObj.SQLCODE<0)
	{
		messageShow("","","",returnObj.Data);
		return;
	}
	$('#tdhceqmcfaultequipmap').datagrid('reload');
	ClearElement();
	//modify by lmm 2018-11-28 end modify by zyq 2023-02-10 end
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
			var data=tkMakeServerCall("web.DHCEQ.EM.KNMaint","DeleteFaultEquipMapData",RowID);
			if(data==0)
			{
				$.messager.show({title: '��ʾ',msg: 'ɾ���ɹ�'});
				$('#tdhceqmcfaultequipmap').datagrid('reload');
				ClearElement();
			}
			else
				$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
			//modify by lmm 2018-11-28 end
	       
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
//add by zyq 2022-10-10
function getParam(vQueryParams)
{
	//alert(vQueryParams)
}

// ���ݲ�ѯ�¼�
function BFind_Clicked()
{
	FindGridData();
}
function getParam() //add by zyq 2023-02-03 ����������λ����
{}
