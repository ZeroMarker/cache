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
    initMessage("InventoryException"); 	//获取所有业务消息
    initLookUp(); 				//初始化放大镜
    defindTitleStyle();
    initButton(); 				//按钮初始化 
    initButtonWidth();
    InitEvent()
    setRequiredElements("IEEquipName^IEOriginalFee^IETransAssetDate^IEStoreLocDR_CTLOCDesc"); //必填项	MZY0056	1517006		2020-09-29	取消使用部门必填
    //fillData(); 				//数据填充
    setElement("IEInventoryNo",getElementValue("InventoryNo"))
    //initPage(); 				//非通用初始化
    setEnabled(1); 				//按钮控制
    //setElementEnabled(); 		//输入框只读控制
    //initEditFields(); 		//获取可编辑字段信息
	//initApproveButtonNew(); 		//初始化审批按钮
	$HUI.datagrid("#DHCEQInventoryException",{
		url:$URL,
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSInventory",
	        	QueryName:"QueryInventoryException",
		        InventoryDR:IEInventoryDR
		},
		rownumbers:true,  		//如果为true则显示行号列
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

function InitEvent() //初始化事件
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
function initPage() //初始化界面
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
		messageShow('alert','error','错误提示',jsonData.Data)
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
	// MZY0044	1457590		2020-08-07	删除旧处理方法
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
		messageShow('alert','error','错误提示','盘盈设备列表数据异常!');
		return;
	}
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","GetOneIException",rowData.IERowID);
	//alertShow(rowData.IERowID+"->"+jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0)
	{
		messageShow('alert','error','错误提示',jsonData.Data)
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
		messageShow('alert','error','错误提示','设备名称不能为空!');
		return;
	}
	if (getElementValue("IEOriginalFee")=="")
	{
		messageShow('alert','error','错误提示','设备原值不能为空!');
		return;
	}
	if (getElementValue("IETransAssetDate")=="")
	{
		messageShow('alert','error','错误提示','转资(入库)日期不能为空!');
		return;
	}
	/*MZY0056	1517006		2020-09-29	取消使用部门必填
	if (getElementValue("IEUserLocDR")=="")
	{
		messageShow('alert','error','错误提示','使用部门(科室)不能为空!');
		return;
	}*/
	if (getElementValue("IEStoreLocDR")=="")
	{
		messageShow('alert','error','错误提示','所在库房不能为空!');
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
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href=url;
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
    }
}
function BDelete_Clicked()
{
	messageShow("confirm","","","是否确定删除当前盘盈记录?","",DeleteIException,DisConfirmOpt);
}
function DeleteIException()
{
	if (getElementValue("IERowID")=="")
	{
		messageShow('alert','error','错误提示','没有盘盈记录删除!');
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSInventory","DeleteIException", getElementValue("IERowID"));
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var url= 'dhceq.em.inventoryexception.csp?&InventoryDR='+IEInventoryDR+'&InventoryNo='+getElementValue("InventoryNo")+'&StatusDR='+getElementValue("StatusDR")+'&QXType='+getElementValue("QXType")+'&ReadOnly='+getElementValue("ReadOnly");
	    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50);
	}
	else
    {
		messageShow('alert','error','错误提示',jsonData.Data);
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
//导出盘盈明细
function BSaveExcel_Click()
{
	var ObjTJob=$('#DHCEQInventoryException').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"]) TJob=ObjTJob.rows[0]["TJob"];
	if (TJob=="")  return;
	// MZY0122	2578403		2022-04-24	增加润乾打印
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",'990062');
	if (PrintFlag=="1")
	{
		if (!CheckColset("InventoryException"))
		{
			messageShow('popover','alert','提示',"导出数据列未设置!")
			return ;
		}
		var url="dhccpmrunqianreport.csp?reportName=DHCEQInventoryExceptionExport.raq&CurTableName=InventoryException&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+TJob;
    	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
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
//导出数据列设置
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
