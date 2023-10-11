var editIndex=undefined;
var IEInventoryDR=getElementValue("IEInventoryDR");
var StatusDR=getElementValue("StatusDR");
var Columns=getCurColumnsInfo('EM.G.Inventory.InventoryException','','','');

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initUserInfo();
    initMessage("InventoryException"); 	//��ȡ����ҵ����Ϣ
    initLookUp(); 				//��ʼ���Ŵ�
    defindTitleStyle();
    initButton(); 				//��ť��ʼ�� 
    initButtonWidth();
    InitEvent()
    setRequiredElements("IEEquipName^IEOriginalFee^IETransAssetDate^IEStoreLocDR_CTLOCDesc"); //������	MZY0056	1517006		2020-09-29	ȡ��ʹ�ò��ű���
    //fillData(); 				//�������
    setElement("IEInventoryNo",getElementValue("InventoryNo"))
    //initPage(); 				//��ͨ�ó�ʼ��
    setEnabled(1); 				//��ť����
    //setElementEnabled(); 		//�����ֻ������
    //initEditFields(); 		//��ȡ�ɱ༭�ֶ���Ϣ
	//initApproveButtonNew(); 		//��ʼ��������ť
	$HUI.datagrid("#DHCEQInventoryException",{
		url:$URL,
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSInventory",
	        	QueryName:"QueryInventoryException",
		        InventoryDR:IEInventoryDR
		},
		rownumbers:true,  		//���Ϊtrue����ʾ�к���
		singleSelect:true,
		//fit:true,
		//fitColumns:true,
		columns:Columns,
		pagination:true,
		pageSize:100,
		pageNumber:1,
		pageList:[100,200,300]
	});
};

function InitEvent() //��ʼ���¼�
{
	/*if (jQuery("#BComfirm").length>0)
	{
		jQuery("#BComfirm").linkbutton({iconCls: 'icon-w-ok'});
		jQuery("#BComfirm").on("click", BComfirm_Clicked);
	}*/
	// MZY0090	2021-08-23
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
}
function initPage() //��ʼ������
{
	//
}
function fillData()
{
	if (IEInventoryDR=="") return;
	var StoreLocDR=getElementValue("StoreLocDR")
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetOneInventory",IEInventoryDR,StoreLocDR);
	//alertShow(InventoryDR+"->"+jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0)
	{
		messageShow('alert','error','������ʾ',jsonData.Data)
		return;
	}
	setElementByJson(jsonData.Data);
}
function setEnabled(flag)
{
	var ReadOnly=getElementValue("ReadOnly");
	//alert("ReadOnly:"+ReadOnly)
	if (ReadOnly==1)
	{
		disableElement("BDelete",1);
		disableElement("BSave",1);
		return
	}
	disableElement("BSave",0);
	disableElement("BDelete",flag);
}

function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
	// MZY0044	1457590		2020-08-07	ɾ���ɴ�����
}

function onClickRow(index)
{
	if (editIndex==index)
	{
		editIndex = undefined;
		Clear();
		setEnabled(1);
		return
	}
	var rowData = $('#DHCEQInventoryException').datagrid('getSelected');
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
	editIndex=index;
	setEnabled(0);
}

function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
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
	/*MZY0056	1517006		2020-09-29	ȡ��ʹ�ò��ű���
	if (getElementValue("IEUserLocDR")=="")
	{
		messageShow('alert','error','������ʾ','ʹ�ò���(����)����Ϊ��!');
		return;
	}*/
	if (getElementValue("IEStoreLocDR")=="")
	{
		messageShow('alert','error','������ʾ','���ڿⷿ����Ϊ��!');
		return;
	}
	var data=getInputList();
	data=JSON.stringify(data);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","SaveInventoryException",data);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
	    var url= 'dhceq.em.inventoryexception.csp?&InventoryDR='+IEInventoryDR+'&InventoryNo='+getElementValue("InventoryNo")+'&StatusDR='+getElementValue("StatusDR")+'&QXType='+getElementValue("QXType")+'&ReadOnly='+getElementValue("ReadOnly");
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
		var url= 'dhceq.em.inventoryexception.csp?&InventoryDR='+IEInventoryDR+'&InventoryNo='+getElementValue("InventoryNo")+'&StatusDR='+getElementValue("StatusDR")+'&QXType='+getElementValue("QXType")+'&ReadOnly='+getElementValue("ReadOnly");
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
	var ObjTJob=$('#DHCEQInventoryException').datagrid('getData');
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
