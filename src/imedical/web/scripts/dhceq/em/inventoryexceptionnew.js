var editIndex=undefined;
var IEInventoryDR=getElementValue("IEInventoryDR");
var StatusDR=getElementValue("StatusDR");
var Columns=getCurColumnsInfo('EM.G.Inventory.InventoryException','','','');
var curTableID="tDHCEQInventoryException"
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initUserInfo();
    initMessage("InventoryException"); 	//��ȡ����ҵ����Ϣ
    initLookUp(); 				//��ʼ���Ŵ�
	initIEquipType();			//��ʼ����������
    defindTitleStyle();
    initInventoryStatusData();
    initType();
    initButton(); 				//��ť��ʼ�� 
    //initButtonWidth("BSaveExcel1,BSaveExcel2");	MZY0157	3219574		2023-03-29
    InitEvent()
    setRequiredElements("IEEquipName^IEStoreLocDR_CTLOCDesc^IETransAssetDate^IEOriginalFee"); //Modeied by zc0124 2022-11-02 ���ӱ�����
    setEnabled(); 				//��ť����
    var vtoolbar=Inittoolbar();
	$HUI.datagrid("#tDHCEQInventoryException",{
		url:$URL,
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSInventory",
	        	QueryName:"QueryInventoryException",
		        InventoryDR:IEInventoryDR,
				InventoryPlanDR:getElementValue("InventoryPlanDR")
		},
		rownumbers:true,  		//���Ϊtrue����ʾ�к���
		singleSelect:true,
		toolbar:vtoolbar,
		columns:Columns,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30],
		onLoadSuccess:function(){
				//$("#"+curTableID).datagrid('hideColumn', "IEUnBind")
				var trs = $(this).prev().find('div.datagrid-body').find('tr');
	            //��
	            for(var i=0;i<trs.length;i++)
	                //���ڵ�Ԫ��
	                for(var j=1;j<trs[i].cells.length;j++){
	                    var row_html = trs[i].cells[j];
	                    var cell_field=$(row_html).attr('field');
	                    var cell_value=$(row_html).find('div').html();
	                    if(cell_field == 'IEEquipNo')
	                    {
		                    if(cell_value == "")
		                    {
				                $('#IEUnBindz'+i).remove();
				                $('#IEBStoreMvoez'+i).remove();  //Modefied by zc0125 2022-12-12 ��ťӰ�� begin
				                $('#IEBReducez'+i).remove();
				                $('#IEBDisuseRequestz'+i).remove();
				                $('#IEDisusez'+i).remove();
				                $('#IEBArgeez'+i).remove();
				            }
				            else
				            {
					            $('#IEBindz'+i).remove();
				                $('#IEBInStockz'+i).remove();
					        }  //Modefied by zc0125 2022-12-12 ��ťӰ�� end
	                    }
	                    else if(cell_field == 'IEInventoryStatus')
	                    {
		                    if(cell_value == "��ӯ")
		                    {
				                $('#IEExceptionz'+i).remove();
				            }
	                    }
	                    else if(cell_field == 'IEDisposeStatus')
	                    {
		                    if(cell_value == "�б��ϵ�")
		                    {
	                        	 $('#IEDisusez'+i).remove();
			                }
			                else if(cell_value == "��ӯ")
			                {
				                $('#IEExceptionz'+i).remove();
				            }
	                    }
						else if(cell_field == 'IETempNo')
	                    {
		                    if(cell_value == "")
		                    {
				                $('#IEBindz'+i).remove();
				            }
	                    }
	                    //Modefied by zc0125 2022-12-12 ��ťӰ�� begin
	                    if(cell_field == 'IEDisposeStatusID')
	                    {
		                    if(cell_value == "2")
		                    {
			                    $('#IEBReducez'+i).remove();
				                $('#IEBInStockz'+i).remove();
				                $('#IEBDisuseRequestz'+i).remove();
				                $('#IEBArgeez'+i).remove();
				            }
				            else if(cell_value == "3")
				            {
					            $('#IEBNoDealz'+i).remove();
				                $('#IEBStoreMvoez'+i).remove();
				                $('#IEBInStockz'+i).remove();
				                $('#IEBDisuseRequestz'+i).remove();
				                $('#IEBArgeez'+i).remove();
					        }
					        else if(cell_value == "5")
				            {
					            $('#IEBReducez'+i).remove();
				                $('#IEBStoreMvoez'+i).remove();
				                $('#IEBInStockz'+i).remove();
				                $('#IEBNoDealz'+i).remove();
				                $('#IEBArgeez'+i).remove();
					        }
					        else if(cell_value == "6")
				            {
					            $('#IEBReducez'+i).remove();
				                $('#IEBStoreMvoez'+i).remove();
				                $('#IEBNoDealz'+i).remove();
				                $('#IEBDisuseRequestz'+i).remove();
				                $('#IEBArgeez'+i).remove();
				                $('#IEExceptionz'+i).remove();
				                $('#IEDisusez'+i).remove();
				                $('#IEUnBindz'+i).remove();
					        }
					        else if(cell_value == "")
				            {
					            $('#IEBReducez'+i).remove();
				                $('#IEBStoreMvoez'+i).remove();
				                $('#IEBNoDealz'+i).remove();
				                $('#IEBDisuseRequestz'+i).remove();
				                $('#IEBArgeez'+i).remove();
				                $('#IEBInStockz'+i).remove();
					        }
	                    }
	                    if(cell_field == 'IEDisposeResultID')
	                    {
		                    if(cell_value != "")
		                    {
				                $('#IEBReducez'+i).remove();
				                $('#IEBStoreMvoez'+i).remove();
				                $('#IEBNoDealz'+i).remove();
				                $('#IEBDisuseRequestz'+i).remove();
				                $('#IEBArgeez'+i).remove();
				                $('#IEExceptionz'+i).remove();
				                $('#IEBindz'+i).remove();
				                $('#IEExceptionz'+i).remove();
				                $('#IEDisusez'+i).remove();
				                $('#IEUnBindz'+i).remove();
				            }
				            else
							{
								$('#BussDetailz'+i).remove();
							}
	                    }
	                    if (cell_field == 'TBussID')
						{
							if(cell_value == "")
							{
								$('#BussDetailz'+i).remove();
							}
						}
						//Modefied by zc0125 2022-12-12 ��ťӰ�� end
	                }
	                
	            }
	});
	$("#tDHCEQInventoryException").datagrid("hideColumn", "IEStartDate");
	$("#tDHCEQInventoryException").datagrid("hideColumn", "IETransAssetDate");
	$("#tDHCEQInventoryException").datagrid("hideColumn", "IEUserLoc");
	$("#tDHCEQInventoryException").datagrid("hideColumn", "IEManuFactory");
	$("#tDHCEQInventoryException").datagrid("hideColumn", "IEProvider");
	$("#tDHCEQInventoryException").datagrid("hideColumn", "IELocation");
	$("#tDHCEQInventoryException").datagrid("hideColumn", "IELeaveFactoryNo");
	$("#tDHCEQInventoryException").datagrid("hideColumn", "IERemark");
	$("#tDHCEQInventoryException").datagrid("hideColumn", "IEPictrue");
	//Modefied by zc0128 2023-02-08 ��ťԪ�ص�Ӱ�� begin
	if (getElementValue("DisposeType")=="0")
	{
		$("#tDHCEQInventoryException").datagrid("hideColumn", "IEInventoryStatus");
		$("#tDHCEQInventoryException").datagrid("hideColumn", "IEDisposeStatus");
		$("#tDHCEQInventoryException").datagrid("hideColumn", "IEDisposeResult");
		$("#tDHCEQInventoryException").datagrid("hideColumn", "BussDetail");
		$("#tDHCEQInventoryException").datagrid("hideColumn", "IEUnBind");
		$("#tDHCEQInventoryException").datagrid("hideColumn", "IEBArgee");
	}
	if (getElementValue("DisposeType")=="1")
	{
		$("#tDHCEQInventoryException").datagrid("hideColumn", "BussDetail");
		$("#tDHCEQInventoryException").datagrid("hideColumn", "IEBArgee");
	}
	if (getElementValue("DisposeType")=="2")
	{
		$("#tDHCEQInventoryException").datagrid("hideColumn", "IEUnBind");
	}
	//Modefied by zc0128 2023-02-08 ��ťԪ�ص�Ӱ�� end
	//Modefied by zc0126 2022-12-26 Ȩ�޿��� begin
	if (getElementValue("ReadOnly")=="1")
	{
		$("#tDHCEQInventoryException").datagrid("hideColumn", "IEUnBind");
		$("#tDHCEQInventoryException").datagrid("hideColumn", "IEBArgee");  //Modefied by zc0128 2023-02-08 ��ťԪ�ص�Ӱ��
	}
	//Modefied by zc0126 2022-12-26 Ȩ�޿��� end
	var IEStoreLoc=$('#tDHCEQInventoryException').datagrid('getColumnOption','IEStoreLoc');
	IEStoreLoc.title="�̵����"
	$('#tDHCEQInventoryException').datagrid();
};
function initIEquipType()
{
	$HUI.combogrid('#IEquipType',{
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.CTEquipType",
	        QueryName:"GetEquipType"
	    },
	    idField:'TRowID',
		textField:'TName',
	    multiple: true,
	    rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
	    selectOnNavigation:false,
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    columns:[[
	    	{field:'check',checkbox:true},
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'ȫѡ',width:150},
	    ]]
	});
}
function initInventoryStatusData()
{
	$("#InventoryStatus").keywords({
			   singleSelect:true,
               items:[
               	{                                 //Modefied by zc0125 2022-12-12 begin
					id: '',
					text: 'ȫ��',selected:true
				},
               	{
					id: '1',
					text: 'δ����'     //Modefied by zc0125 2022-12-12 end
				},{
					id: '2',
					text: '��ӯ'
				},{
					id: '3',
					text: '�Ѵ������ӯ'
				}],
			    onClick : function(v){				    
					var InventoryStatus=v.id
					setElement("InventoryStatus",InventoryStatus)
					BFind_Clicked()
				},

	     })
}
function Inittoolbar()
{
	var toolbar="" 
	//Modefied by zc0128 2023-02-08 ��ťԪ�ص�Ӱ�� begin
	if (getElementValue("InventoryDR")!="")
	{
		if ((getElementValue("DisposeType")=="1")||(getElementValue("DisposeType")=="2"))
		{
			toolbar=[
	        {
                iconCls: 'icon-export',
	            text:'�̵�״̬����',
	            id:'BSaveExcel1',
	            handler: function(){
	                 BSaveExcel1_Click();
	            }
	        },
	        {
                iconCls: 'icon-export',
	            text:'����״̬����',
	            id:'BSaveExcel2',
	            handler: function(){
	                 BSaveExcel2_Click();
	            }
	        }
        	]
		}
		else
		{
			toolbar=[
	        {
                iconCls: 'icon-add',
	            text:'������ӯ�豸',
	            id:'add',
	            handler: function(){
	                 Add();
	            }
	        },	// MZY0150	3193876		2023-01-29	UI����
	        {
                iconCls: 'icon-export',
	            text:'�̵�״̬����',
	            id:'BSaveExcel1',
	            handler: function(){
	                 BSaveExcel1_Click();
	            }
	        },
	        {
                iconCls: 'icon-export',
	            text:'����״̬����',
	            id:'BSaveExcel2',
	            handler: function(){
	                 BSaveExcel2_Click();
	            }
	        }
        	]
		}
	}
	//Modefied by zc0128 2023-02-08 ��ťԪ�ص�Ӱ�� end
	if (getElementValue("ReadOnly")=="1")
	{
		toolbar="" 
	}
	return toolbar;
}
function initType()
{
	var IEUseStatus = $HUI.combobox('#IEUseStatus',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: ''
			},{
				id: '1',
				text: '����'
			},{
				id: '2',
				text: '���δʹ��'
			},{
				id: '3',
				text: 'δ���'
			},{
				id: '4',
				text: '��ѹ����'
			},{
				id: '5',
				text: '��ӯ��'
			}]
	});
	//Modify By zx 2020-02-20 BUG ZX0076
	var IEPurpose = $HUI.combobox('#IEPurpose',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: ''
			},{
				id: '1',
				text: 'ҽԺ�ճ�ʹ��'		//modified by czf 20200911 begin CZF0127
			},{
				id: '2',
				text: '��������'
			}]
	});
}
function InitEvent() //��ʼ���¼�
{
	if (jQuery("#BSaveExcel").length>0)
	{
		jQuery("#BSaveExcel").linkbutton({iconCls: 'icon-w-export'});
		jQuery("#BSaveExcel").on("click", BSaveExcel_Click);
	}
	if (jQuery("#BColSet").length>0)
	{
		jQuery("#BColSet").linkbutton({iconCls: 'icon-w-config'});
		jQuery("#BColSet").on("click", BColSet_Click);
	}
	if (jQuery("#BSaveExcel1").length>0)
	{
		jQuery("#BSaveExcel1").linkbutton({iconCls: 'icon-w-export'});
		jQuery("#BSaveExcel1").on("click", BSaveExcel1_Click);
	}
	if (jQuery("#BSaveExcel2").length>0)
	{
		jQuery("#BSaveExcel2").linkbutton({iconCls: 'icon-w-export'});
		jQuery("#BSaveExcel2").on("click", BSaveExcel2_Click);
	}
	//Modefied by zc0132 2023-3-28 ������Ƿ��ظ�¼�� begin
	var obj=document.getElementById("IEEquipNo");
	if (obj) obj.onchange=IEEquipNoChange;
	//Modefied by zc0132 2023-3-28 ������Ƿ��ظ�¼�� end
}
//Modefied by zc0132 2023-3-28 ������Ƿ��ظ�¼�� begin
function IEEquipNoChange()
{
	var rtn =tkMakeServerCall("web.DHCEQ.EM.BUSInventory","CheckEquipNoInException",getElementValue("IERowID"),getElementValue("IEEquipNo"));
	if (rtn!="0")
	{
		messageShow('alert','error','������ʾ','�豸���/��ʱ���Ѵ���!');
		SetElement("IEEquipNo","");
		return;	
	}
}
//Modefied by zc0132 2023-3-28 ������Ƿ��ظ�¼�� end
function Save()
{
	
}
function Add()
{
	Clear()
	$HUI.dialog('#ExceptionInfo').open();
	$('#tDHCEQInventoryException').datagrid('unselectAll')
}
function BFind_Clicked()
{
	setElement("IEquipTypeIDs",$("#IEquipType").combogrid("getValues"))  ///Modefied by zc0125 2022-11-09 ��IEquipTypeIDsԪ�ظ�ֵ
	$HUI.datagrid("#tDHCEQInventoryException",{   
		url:$URL, 
		queryParams:{
	    	ClassName:"web.DHCEQ.EM.BUSInventory",
	    	QueryName:"QueryInventoryException",
	        InventoryDR:IEInventoryDR,
	    	User:curUserID,
	    	InventoryPlanDR:getElementValue("InventoryPlanDR"),
	    	InventoryLocDR:getElementValue("InventoryLocDR"),
	    	InventoryNo:getElementValue("IEInventoryNo"),
	    	InventoryStatus:getElementValue("InventoryStatus"),
			IEquipTypeIDs:getElementValue("IEquipTypeIDs")		 ///Modefied by zc0125 2022-11-09 ���鴮ȡֵ��Ϊ��ȡIEquipTypeIDsԪ��ֵ
		}
	});
}
function setEnabled()
{
	disableElement("BDelete",true);
	if (getElementValue("IERowID")!="")
	{
		disableElement("BDelete",false);
	}
	if (getElementValue("InventoryPlanDR")!="")
	{
		setDisableElements("InventoryLocPlan",true)
	}
	if (getElementValue("InventoryDR")!="")
	{
		setDisableElements("IEInventoryNo",true)
	}
	else
	{
		hiddenObj("BDelete",1);
		hiddenObj("BSave",1);
	}
	//Modefied by zc0126 2022-12-26 ��ť���� begin
	if (getElementValue("ReadOnly")=="1")
	{
		hiddenObj("BDelete",1);
		hiddenObj("BSave",1);
	}
	if (getElementValue("IEBussID")!="")
	{
		hiddenObj("BDelete",1);
		hiddenObj("BSave",1);
	}
	//Modefied by zc0126 2022-12-26 ��ť���� begin
	//Modefied by zc0128 2023-02-08 ��ťԪ�ص�Ӱ��  begin
	if (getElementValue("DisposeType")!="0")
	{
		hiddenObj("BDelete",1);
		hiddenObj("BSave",1);
	}
	//Modefied by zc0128 2023-02-08 ��ťԪ�ص�Ӱ�� end
}

function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
	// MZY0044	1457590		2020-08-07	ɾ���ɴ�����
	if(elementID=="InventoryLocPlan") {
		setElement("InventoryLocPlan",rowData.TName)
		setElement("InventoryPlanID",rowData.TRowID)
		setElement("InventoryPlanDR",rowData.TRowID)
	}
}

function onClickRow(index)
{
	if (editIndex==index)
	{
		editIndex = undefined;
		Clear();
		setEnabled();
		return
	}
	var rowData = $('#tDHCEQInventoryException').datagrid('getSelected');
	if (!rowData) return;
	if (rowData.IERowID=="")
	{
		messageShow('alert','error','������ʾ','��ӯ�豸�б������쳣!');
		return;
	}
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetOneIException",rowData.IERowID);
	//alertShow(rowData.IERowID+"->"+jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0)
	{
		messageShow('alert','error','������ʾ',jsonData.Data)
		return;
	}
	setElementByJson(jsonData.Data);
	setElement("IERowID",rowData.IERowID);
	$HUI.dialog('#ExceptionInfo').open();
	$('#tDHCEQInventoryException').datagrid('unselectAll')
	editIndex=index;
	setEnabled();
}

function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	//Modefied by zc0126 2022-12-26 Ԫ����� begin
	if(elementID=="InventoryLocPlan") {
		setElement("InventoryPlanID","")
		setElement("InventoryPlanDR","")
	}
	//Modefied by zc0126 2022-12-26 Ԫ����� begin
	return;
}
function Clear()
{
	SetElement("IERowID","");
	SetElement("IEEquipName","");
	SetElement("IEEquipNo","");
	SetElement("IEModel","");
	SetElement("IEOriginalFee","");
	SetElement("IETransAssetDate","");
	SetElement("IEStartDate","");
	SetElement("IEUserLocDR_CTLOCDesc","");
	SetElement("IEUserLocDR","");
	SetElement("IEStoreLocDR_CTLOCDesc","");
	SetElement("IEStoreLocDR","");
	SetElement("IELocationDR_LDesc","");
	SetElement("IELocationDR","");
	SetElement("IEProviderDR_VDesc","");
	SetElement("IEProviderDR","");
	SetElement("IEManuFactoryDR_MFDesc","");
	SetElement("IEManuFactoryDR","");
	SetElement("IELeaveFactoryNo","");
	SetElement("IERemark","");
	SetElement("IEEquipTypeDR_ETDesc",""); //add by zc0128 2023-02-07 ��ո�ֵ begin
	SetElement("IEEquipTypeDR","");
	SetElement("IEBrand","");
	SetElement("IEManuFactoryDR_MFName","");
	SetElement("IEManuFactoryDR","");
	SetElement("IEUseStatus","");
	SetElement("IEPurpose","");			//add by zc0128 2023-02-07 ��ո�ֵ end
}
function BSave_Clicked()
{
	if (getElementValue("IEEquipName")=="")
	{
		messageShow('alert','error','������ʾ','�豸���Ʋ���Ϊ��!');
		return;
	}
	if (getElementValue("IEOriginalFee")=="")
	{
		messageShow('alert','error','������ʾ','�豸ԭֵ����Ϊ��!');
		return;
	}
	if (getElementValue("IETransAssetDate")=="")
	{
		messageShow('alert','error','������ʾ','ת��(���)���ڲ���Ϊ��!');
		return;
	}
	if (getElementValue("IEStoreLocDR")=="")
	{
		messageShow('alert','error','������ʾ','���ڿⷿ����Ϊ��!');
		return;
	}
	var data=getInputList();
	data.IEUserDR=curUserID;  //Modefied by zc0126 2022-12-26 ������ӯ����Ϣ
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","SaveInventoryException",data);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		websys_showModal("options").mth();  //Modefied by zc0126 2022-12-26 ������ˢ��
	    var url= 'dhceq.em.inventoryexceptionnew.csp?&InventoryDR='+IEInventoryDR+'&InventoryPlanDR=&StatusDR='+getElementValue("StatusDR")+'&QXType='+getElementValue("QXType")+'&ReadOnly='+getElementValue("ReadOnly");
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href=url;
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
    }
}
function BDelete_Clicked()
{
	messageShow("confirm","","","�Ƿ�ȷ��ɾ����ǰ��ӯ��¼?","",DeleteIException,DisConfirmOpt);
}
function DeleteIException()
{
	if (getElementValue("IERowID")=="")
	{
		messageShow('alert','error','������ʾ','û����ӯ��¼ɾ��!');
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","DeleteIException", getElementValue("IERowID"));
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		websys_showModal("options").mth();  //Modefied by zc0126 2022-12-26 ������ˢ��
		var url= 'dhceq.em.inventoryexceptionnew.csp?&InventoryDR='+IEInventoryDR+'&InventoryPlanDR=&StatusDR='+getElementValue("StatusDR")+'&QXType='+getElementValue("QXType")+'&ReadOnly='+getElementValue("ReadOnly");
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50);
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
    }
}
function DisConfirmOpt()
{
	
}

function setElementEnabled()
{
	//var Rtn=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",103002);
	//if(Rtn=="1") disableElement("CTContractNo",true);
}
// MZY0090	2021-08-23
//������ӯ��ϸ
function BSaveExcel_Click()
{
	var ObjTJob=$('#tDHCEQInventoryException').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"]) TJob=ObjTJob.rows[0]["TJob"];
	if (TJob=="")  return;
	// MZY0122	2578403		2022-04-24	������Ǭ��ӡ
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",'990062');
	if (PrintFlag=="1")
	{
		if (!CheckColset("InventoryException"))
		{
			messageShow('popover','alert','��ʾ',"����������δ����!")
			return ;
		}
		var url="dhccpmrunqianreport.csp?reportName=DHCEQInventoryExceptionExport.raq&CurTableName=InventoryException&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+TJob;
    	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
    	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
	}
	else
	{
		var vData=GetData();
		PrintDHCEQEquipNew("InventoryException",1,TJob,vData,"InventoryException",100); 
	}
} 
//��������������
function BColSet_Click()
{
	var para="&TableName=InventoryException&SetType=0&SetID=0"
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	colSetWindows(url)
}
function GetData()
{
	var vData="^ContractTypeDR="+getElementValue("ContractType");
	vData=vData+"^Name="+getElementValue("EquipName");
	vData=vData+"^ContractName="+getElementValue("ContractName");
	vData=vData+"^ContractNo="+getElementValue("ContractNo");
	return vData;
}

function BBindClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var IETempNo = rowData.IETempNo;
	var str='dhceq.em.inventorybind.csp?&TempID='+IETempNo+"&ExceptionID="+IERowID;
	showWindow(str,"�豸��","","","icon-w-paper","modal","","","large");   //Modeied by zc0124 2022-11-07 ��ҳ�浯����С
}
function BIEClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","ChangeIEInventoryStatus",IERowID, "6");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
			$("#"+curTableID).datagrid('reload'); 
	}
	else
	{
			messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
			return;
	}
	
}
function BDisuseClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","ChangeIEInventoryStatus",IERowID, "5");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
			$("#"+curTableID).datagrid('reload'); 
	}
	else
	{
			messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
			return;
	}
}
function BUnBindClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","UnBindEquip",IERowID, "5");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
			$("#"+curTableID).datagrid('reload'); 
	}
	else
	{
			messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
			return;
	}
}
function BSaveExcel1_Click()
{
	//var fileName="DHCEQInventoryExceptionExportNew.raq&DisplayType=0&InventoryPlanDR="+getElementValue("InventoryPlanDR");
	var fileName="DHCEQInventoryExceptionExportNew.raq&DisplayType=0&InventoryDR="+IEInventoryDR+"&InventoryPlanDR="+getElementValue("InventoryPlanDR");
	//alert(fileName)
	DHCCPM_RQPrint(fileName);
}
function BSaveExcel2_Click()
{
	//var fileName="DHCEQInventoryExceptionExportNew.raq&DisplayType=1&InventoryPlanDR="+getElementValue("InventoryPlanDR");
	var fileName="DHCEQInventoryExceptionExportNew.raq&DisplayType=1&InventoryDR="+IEInventoryDR+"&InventoryPlanDR="+getElementValue("InventoryPlanDR");
	//alert(fileName)
	DHCCPM_RQPrint(fileName);
}
//Modefied by zc0125 2022-12-12 ����ҵ���� begin
function BArgeeClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","UpdateIEDisposeResult",IERowID, "1");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
			$("#"+curTableID).datagrid('reload'); 
	}
	else
	{
			messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
			return;
	}
}
function BInStockClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQOpenCheckRequest&CheckTypeDR=0&Type=0&ApproveRole=&ReadOnly=&InventoryExceptionDR='+IERowID; 
	showWindow(url,"�豸���չ���","","","icon-w-paper","modal","","","large");
}
function BStoreMoveClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var IEEquipNo = rowData.IEEquipNo;
	var EquipDR=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",IEEquipNo);
	if (EquipDR=="")
	{
		messageShow('alert','error','��ʾ',"������Ϣ:�豸�����Ч,���ܱ���");
		return;
	}
	//modified by ZY0229 20200511
	var url="dhceq.em.storemove.csp?EquipDR="+EquipDR+"&SMMoveType=1&QXType=&WaitAD=off&FromLocDR="+rowData.IEUserLocDR+"&ToLocDR="+rowData.IEStoreLocDR+"&EquipTypeDR="+rowData.IEEquipTypeDR+"&InventoryExceptionDR="+IERowID; 
	showWindow(url,"�ʲ�ת��","","","icon-w-paper","modal","","","large");   //modify by lmm 2019-02-16
}
function BNoDealClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","UpdateIEDisposeResult",IERowID, "4");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
			$("#"+curTableID).datagrid('reload'); 
	}
	else
	{
			messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
			return;
	}
	
}
function BReduceClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var IEEquipNo = rowData.IEEquipNo;
	var EquipDR=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",IEEquipNo);
	if (EquipDR=="")
	{
		messageShow('alert','error','��ʾ',"������Ϣ:�豸�����Ч,���ܼ���");
		return;
	}
	//modified by ZY0229 20200511
	var url="dhceq.em.outstock.csp?EquipDR="+EquipDR+"&ROutTypeDR=4&WaitAD=off&QXType=2&UseLocDR="+rowData.IEStoreLocDR+"&InventoryExceptionDR="+IERowID; 
	showWindow(url,"�ʲ�����","","","icon-w-paper","modal","","","large");   //modify by lmm 2019-02-16
}
function BDisuseRequestClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var IERowID = rowData.IERowID;
	var IEEquipNo = rowData.IEEquipNo;
	var EquipDR=tkMakeServerCall("web.DHCEQEquip","GetEquipIDByNo",IEEquipNo);
	if (EquipDR=="")
	{
		messageShow('alert','error','��ʾ',"������Ϣ:�豸�����Ч,���ܱ���");
		return;
	}
	var ReadOnly=0;
	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQBatchDisuseRequest&DType=1&Type=0&EquipDR='+EquipDR+"&RequestLocDR="+curLocID+"&ReadOnly="+ReadOnly+"&InventoryExceptionDR="+IERowID; //sessionֵ��Ҫ�滻
	showWindow(url,"�ʲ�����","","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-02 UI
}
function BussClick(curIndex)
{
	var rowsData = $("#"+curTableID).datagrid("getRows");
	var rowData = rowsData[curIndex];
	var TBussType = rowData.TBussType;
	var TBussID = rowData.TBussID;
	if (TBussType=="11")
	{
		var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQOpenCheckRequest&RowID='+TBussID+'&ReadOnly=1'; 
		showWindow(url,"�豸���չ���","","","icon-w-paper","modal","","","large");
	}
	else if (TBussType=="22")
	{
		var url='dhceq.em.storemove.csp?RowID='+TBussID+'&ReadOnly=1'; 
		showWindow(url,"�ʲ�ת��","","","icon-w-paper","modal","","","large");
	}
	else if (TBussType=="23")
	{
		var url='dhceq.em.outstock.csp?RowID='+TBussID+'&ReadOnly=1&&ROutTypeDR=2'; 
		showWindow(url,"�ʲ�����","","","icon-w-paper","modal","","","large");
	}
	else if (TBussType=="34")
	{
		var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQBatchDisuseRequest&RowID='+TBussID+'&ReadOnly=1'; 
		showWindow(url,"�ʲ�����","","","icon-w-paper","modal","","","large");
	}
}
//Modefied by zc0125 2022-12-12 ����ҵ���� end
