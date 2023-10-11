var IRowID=getElementValue("IRowID");
var StatusDR=getElementValue("StatusDR");
var Columns=getCurColumnsInfo('EM.G.Inventory.InventoryList','','','');
var DisplayFlag="allflag";

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
    initLookUp(); 				//��ʼ���Ŵ�
    initIEquipType();			//��ʼ����������
    defindTitleStyle();
    initButton(); 				//��ť��ʼ�� 
    initButtonWidth();
    InitEvent()
    setRequiredElements("ILStatus_Desc"); //������
    fillData(); 				//�������
    //initPage(); 				//��ͨ�ó�ʼ��
    //setEnabled(); 			//��ť����
	$HUI.datagrid("#DHCEQInventoryList",{
		url:$URL,
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSInventory",
	        	QueryName:"InventoryList",
		        InventoryDR:IRowID,
		    	StoreLocDR:getElementValue("StoreLocDR"),
		    	IStoreLocDR:getElementValue("IStoreLocDR"),
		    	EquipTypeIDs:getElementValue("IEquipTypeIDs"),
		    	StatCatDR:getElementValue("IStatCatDR"),
		    	OriginDR:getElementValue("IOriginDR"),
		    	onlyShowDiff:getElementValue("onlyShowDiff"),
		    	FilterInfo:getElementValue("FilterInfo"),
		    	ManageLocDR:getElementValue("IManageLocDR"),
		    	QXType:getElementValue("QXType"),
		    	StatusDR:StatusDR,
		    	HospitalDR:getElementValue("IHospitalDR"),
		    	LocIncludeFlag:getElementValue("ILocIncludeFlag"),
		    	DisplayFlag:DisplayFlag,
		    	Data:GetLnk()
		},
		rownumbers:true,  		//���Ϊtrue����ʾ�к���
		singleSelect:true,
		//fit:true,
		//fitColumns:true,
		columns:Columns,
		pagination:true,
		pageSize:100,
		pageNumber:1,
		pageList:[100,200,300],
		onLoadSuccess:function(){
			$("#DHCEQInventoryList").datagrid("hideColumn", "ILStatus_Display");
			$("#DHCEQInventoryList").datagrid("hideColumn", "ILActerStoreLoc");
			$("#DHCEQInventoryList").datagrid("hideColumn", "ILCondition_Display");
			$("#DHCEQInventoryList").datagrid("hideColumn", "TResultType");
			$("#DHCEQInventoryList").datagrid("hideColumn", "ILProcessFlag_Display");
			$("#DHCEQInventoryList").datagrid("hideColumn", "IListInfo");
			$("#DHCEQInventoryList").datagrid("hideColumn", "ILPictrue");
		}
	});
};

function InitEvent() //��ʼ��
{
	if (jQuery("#BExactFind").length>0)
	{
		jQuery("#BExactFind").linkbutton({iconCls: 'icon-w-find'});
		jQuery("#BExactFind").on("click", BFind_Clicked);
	}
	if (jQuery("#BBatchUpdate").length>0)
	{
		jQuery("#BBatchUpdate").linkbutton({iconCls: 'icon-w-save'});
		jQuery("#BBatchUpdate").on("click", BBatchUpdate_Clicked);
	}
}
function initPage() //��ʼ��
{
	//
}
function fillData()
{
	if (IRowID=="") return;
	var StoreLocDR=getElementValue("StoreLocDR")
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetOneInventory",IRowID,StoreLocDR);
	//alertShow(InventoryDR+"->"+jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0)
	{
		messageShow('alert','error','������ʾ',jsonData.Data)
		return;
	}
	setElementByJson(jsonData.Data);
	if (jsonData.Data.IEquipTypeIDs!="")
	{
		var arr=jsonData.Data.IEquipTypeIDs.split(",");
		$('#IEquipType').combogrid('setValues', arr);
	}
}
function setEnabled()
{
}
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
function setSelectValue(elementID,rowData)
{
	setDefaultElementValue(elementID,rowData)
	//if(elementID=="IStoreLocDR_CTLOCDesc") {setElement("IStoreLocDR",rowData.TRowID)}
	//else if(elementID=="IHospitalDR_HDesc") {setElement("IHospitalDR",rowData.TRowID)}
}
function endEditing()
{
}
function onClickRow(index)
{
}
function bindGridEvent()
{
}
function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	return;
}

function BFind_Clicked()
{
	setElement("IEquipTypeIDs",$("#IEquipType").combogrid("getValues"));
	var lnk=GetLnk();
	$HUI.datagrid("#DHCEQInventoryList",{   
		url:$URL, 
		queryParams:{
	    	ClassName:"web.DHCEQ.EM.BUSInventory",
	    	QueryName:"InventoryList",
	        InventoryDR:IRowID,
	    	StoreLocDR:getElementValue("StoreLocDR"),
	    	IStoreLocDR:getElementValue("IStoreLocDR"),
	    	EquipTypeIDs:getElementValue("IEquipTypeIDs"),
	    	StatCatDR:getElementValue("IStatCatDR"),
	    	OriginDR:getElementValue("IOriginDR"),
	    	onlyShowDiff:getElementValue("onlyShowDiff"),
	    	FilterInfo:getElementValue("FilterInfo"),
	    	ManageLocDR:getElementValue("IManageLocDR"),
	    	QXType:getElementValue("QXType"),
	    	StatusDR:StatusDR,
	    	HospitalDR:getElementValue("IHospitalDR"),
	    	LocIncludeFlag:getElementValue("ILocIncludeFlag"),
	    	DisplayFlag:DisplayFlag,
	    	Data:lnk
		}
	});
}
function GetLnk()
{
	var lnk="^BatchFlag=1";
	lnk=lnk+"^EQNo="+getElementValue("EQNo");
	lnk=lnk+"^EQName="+getElementValue("EQName");
	
	return lnk
}
function BBatchUpdate_Clicked()
{
	if ($('#DHCEQInventoryList').datagrid('getRows').length<1)
	{
		messageShow("","","","û������!");
		return;
	}
	if (getElementValue("ILStatus")=="")
	{
		messageShow('alert','error','������ʾ','�̵�״̬����Ϊ��!');
		return;
	}
	if ((getElementValue("ILCondition")=="")&&(tkMakeServerCall("web.DHCEQCommon","GetSysInfo", "992006")==1))
	{
		if (getElementValue("ILStatus")<3)
		{
			alertShow("���״̬����Ϊ��.������!");
			return;
		}
	}
	messageShow("confirm","","","�Ƿ�ȷ��ȫ�����µ�ǰ�̵㵥���̵���Ϣ?","",BatchUpdate,DisBatchUpdate);
}
function BatchUpdate()
{
	var data=getElementValue("ILStatus")+"^"+getElementValue("ILCondition");
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","BatchUpdate",data,$('#DHCEQInventoryList').datagrid('getRows')[0].ILJob);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		alertShow("�����ɹ�.");
		websys_showModal("options").mth();
		fillData();
		BFind_Clicked();
	    //window.location.reload()
		//var url='dhceq.em.inventorybatch.csp?&IRowID='+IRowID+"&StatusDR="+StatusDR+"&IAStatusDR="+getElementValue("IAStatusDR")+"&QXType="+getElementValue("QXType")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&ManageLocDR="+getElementValue("ManageLocDR");
		//window.location.href=url;
	}
	else
    {
		messageShow('alert','error','������ʾ',jsonData.Data);
    }
}
function DisBatchUpdate()
{
	
}
function GetStatus(index, data)
{
	
}
function GetLoc(index, data)
{
	
}
function GetCondition(index, data)
{
	
}
function GetLocation(index, data)
{
	
}
function GetKeeper(index, data)
{
	
}
function GetUseStatus(index, data)
{
	
}
function GetLossReason(index, data)
{
	
}
function GetPurpose(index, data)
{
	
}

function setElementEnabled()
{
	
}
