
var editFlag="undefined";
var SelectRowID="";
var DisplayFlag="allflag";
var StatusDR=1;
var Columns=getCurColumnsInfo('EM.G.Inventory.InventoryLocList','','','')

$(function(){
	initDocument();
	//$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	initUserInfo();
    initMessage("inventory"); //��ȡ����ҵ����Ϣ
    initLookUp();
    initEquipType();
	defindTitleStyle(); 
  	initButton();
    //setEnabled(); //��ť����
    initButtonWidth();
	InitEvent();
	$HUI.datagrid("#tDHCEQInventoryList",{
	    url:$URL,
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSInventory",
	        	QueryName:"InventoryList",
		        InventoryDR:getElementValue("InventoryDR"),
		    	StoreLocDR:getElementValue("StoreLocDR"),
		    	IStoreLocDR:"",
		    	EquipTypeIDs:"",
		    	StatCatDR:"",
		    	OriginDR:"",
		    	onlyShowDiff:getElementValue("onlyShowDiff"),
		    	FilterInfo:"",
		    	ManageLocDR:"",
		    	QXType:"",
		    	StatusDR:"",
		    	HospitalDR:"",
		    	LocIncludeFlag:"",
		    	DisplayFlag:DisplayFlag
		},
		rownumbers:true,  		//���Ϊtrue����ʾ�к���
		singleSelect:true,
		fit:true,
		//fitColumns:true,
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
	});
}
function InitEvent() //��ʼ��
{
	if (jQuery("#BListExport").length>0)
	{
		jQuery("#BListExport").linkbutton({iconCls: 'icon-w-export'});
		jQuery("#BListExport").on("click", BListExport_Clicked);
	}
	if (jQuery("#BProfitListExport").length>0)
	{
		jQuery("#BProfitListExport").linkbutton({iconCls: 'icon-w-export'});
		jQuery("#BProfitListExport").on("click", BProfitListExport_Clicked);
	}

	if (jQuery("#BLossListExport").length>0)
	{
		jQuery("#BLossListExport").linkbutton({iconCls: 'icon-w-export'});
		jQuery("#BLossListExport").on("click", BLossListExport_Clicked);
	}
	var obj=document.getElementById("BDownloadPicture");
	if (obj)
	{
		jQuery("#BDownloadPicture").linkbutton({iconCls: 'icon-w-export'});
		jQuery("#BDownloadPicture").on("click", DownloadPicture);
	}
}
function IListInfoClickHandler(index) 
{
	if (StatusDR==0) return
	//alert("IListInfoClickHandler:"+rowData.ILRowID)
	var rowData =  $('#tDHCEQInventoryList').datagrid("getRows")[index]; //modified by csj 2020-09-28 1493266
	if (!rowData) return;
	if (rowData.ILRowID=="")
	{
		messageShow('alert','error','������ʾ','�̵��豸��¼�쳣!');
		return;
	}
	var url= 'dhceq.em.inventorylistinfo.csp?&InventoryListDR='+rowData.ILRowID;
	showWindow(url,"�̵��豸��Ϣ����","","8row","icon-w-paper","modal","","","small");   //modify by lmm 2021-03-09 1778961
}

function PictrueClickHandler(index)
{
	if (StatusDR==0) return
	//alert("PictrueClickHandler:"+index)
	var rowData =  $('#tDHCEQInventoryList').datagrid("getRows")[index];	//modified by csj 2020-09-28 1493266
	if (!rowData) return;
	if (rowData.ILRowID=="")
	{
		messageShow('alert','error','������ʾ','�̵��豸�б������쳣!');
		return;
	}
	var ReadOnly=0;
	if (getElementValue("IAStatusDR")!=1) {ReadOnly=1}
	var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=53&CurrentSourceID='+rowData.ILRowID+'&Status=0&ReadOnly='+ReadOnly;
	showWindow(str,"ͼƬ��Ϣ","","","icon-w-paper","modal","","","middle");	
}
function initEquipType()
{
	$HUI.combogrid('#EquipType',{
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
	    //singleSelect: true,
		//selectOnCheck: true,
		//checkOnSelect: true
	    columns:[[
	    	{field:'check',checkbox:true},
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'ȫѡ',width:150},
	        //{field:'TCode',title:'����',width:150},
	    ]]
	});
}
// InventoryDR As %String = "", EquipTypeIDs As %String = "", StoreLocDR As %String = "", ILStatus As %String = "", ExceptionFlag
function BListExport_Clicked()
{
	//alert("�̵��"+getElementValue("EquipType"))
	var fileName="DHCEQInventoryListExport.raq&InventoryDR="+getElementValue("InventoryDR")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&EquipTypeIDs="+$("#EquipType").combogrid("getValues")+"&EquipType="+getElementValue("EquipType");
	//alert(fileName)
	DHCCPM_RQPrint(fileName);
}
function BProfitListExport_Clicked()
{
	//alert("��ӯ��")
	var fileName="DHCEQInventoryExceptionExportNew.raq&InventoryDR="+getElementValue("InventoryDR")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&EquipTypeIDs="+$("#EquipType").combogrid("getValues")+"&EquipType="+getElementValue("EquipType");
	//alert(fileName)
	DHCCPM_RQPrint(fileName);
}
function BLossListExport_Clicked()
{
	//alert("�̿���"+$("#EquipType").combogrid("getValues"))
	var fileName="DHCEQInventoryLossListExport.raq&InventoryDR="+getElementValue("InventoryDR")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&EquipTypeIDs="+$("#EquipType").combogrid("getValues")+"&EquipType="+getElementValue("EquipType");
	//alert(fileName)
	DHCCPM_RQPrint(fileName);
}

function DownloadPicture()
{
	var ftpappendfilename=tkMakeServerCall("web.DHCEQ.Process.DHCEQPicture","GetFtpStreamSrcForInventory",getElementValue("InventoryDR"),getElementValue("StoreLocDR"));
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		ftpappendfilename += "&MWToken="+websys_getMWToken()
	}
	window.open(ftpappendfilename).close();
}

