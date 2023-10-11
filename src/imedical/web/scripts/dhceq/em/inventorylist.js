
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
    initMessage("inventory"); //获取所有业务消息
    initLookUp();
    initEquipType();
	defindTitleStyle(); 
  	initButton();
    //setEnabled(); //按钮控制
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
		rownumbers:true,  		//如果为true则显示行号列
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
function InitEvent() //初始化
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
		messageShow('alert','error','错误提示','盘点设备记录异常!');
		return;
	}
	var url= 'dhceq.em.inventorylistinfo.csp?&InventoryListDR='+rowData.ILRowID;
	showWindow(url,"盘点设备信息调整","","8row","icon-w-paper","modal","","","small");   //modify by lmm 2021-03-09 1778961
}

function PictrueClickHandler(index)
{
	if (StatusDR==0) return
	//alert("PictrueClickHandler:"+index)
	var rowData =  $('#tDHCEQInventoryList').datagrid("getRows")[index];	//modified by csj 2020-09-28 1493266
	if (!rowData) return;
	if (rowData.ILRowID=="")
	{
		messageShow('alert','error','错误提示','盘点设备列表数据异常!');
		return;
	}
	var ReadOnly=0;
	if (getElementValue("IAStatusDR")!=1) {ReadOnly=1}
	var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=53&CurrentSourceID='+rowData.ILRowID+'&Status=0&ReadOnly='+ReadOnly;
	showWindow(str,"图片信息","","","icon-w-paper","modal","","","middle");	
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
	    rowStyle:'checkbox', //显示成勾选行形式
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
	        {field:'TName',title:'全选',width:150},
	        //{field:'TCode',title:'代码',width:150},
	    ]]
	});
}
// InventoryDR As %String = "", EquipTypeIDs As %String = "", StoreLocDR As %String = "", ILStatus As %String = "", ExceptionFlag
function BListExport_Clicked()
{
	//alert("盘点表"+getElementValue("EquipType"))
	var fileName="DHCEQInventoryListExport.raq&InventoryDR="+getElementValue("InventoryDR")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&EquipTypeIDs="+$("#EquipType").combogrid("getValues")+"&EquipType="+getElementValue("EquipType");
	//alert(fileName)
	DHCCPM_RQPrint(fileName);
}
function BProfitListExport_Clicked()
{
	//alert("盘盈表")
	var fileName="DHCEQInventoryExceptionExportNew.raq&InventoryDR="+getElementValue("InventoryDR")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&EquipTypeIDs="+$("#EquipType").combogrid("getValues")+"&EquipType="+getElementValue("EquipType");
	//alert(fileName)
	DHCCPM_RQPrint(fileName);
}
function BLossListExport_Clicked()
{
	//alert("盘亏表"+$("#EquipType").combogrid("getValues"))
	var fileName="DHCEQInventoryLossListExport.raq&InventoryDR="+getElementValue("InventoryDR")+"&StoreLocDR="+getElementValue("StoreLocDR")+"&EquipTypeIDs="+$("#EquipType").combogrid("getValues")+"&EquipType="+getElementValue("EquipType");
	//alert(fileName)
	DHCCPM_RQPrint(fileName);
}

function DownloadPicture()
{
	var ftpappendfilename=tkMakeServerCall("web.DHCEQ.Process.DHCEQPicture","GetFtpStreamSrcForInventory",getElementValue("InventoryDR"),getElementValue("StoreLocDR"));
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		ftpappendfilename += "&MWToken="+websys_getMWToken()
	}
	window.open(ftpappendfilename).close();
}

