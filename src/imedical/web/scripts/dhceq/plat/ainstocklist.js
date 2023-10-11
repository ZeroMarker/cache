var columns=getCurColumnsInfo('PLAT.G.InStock.InvoiceInStockList','','','');  
$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	defindTitleStyle(); 
	initButtonWidth();
	initButton();
	initLookUp();
	initCombobox();
	if (getElementValue("MapType")==1)
	{
		toolbar=[{
		    		id:"Save",
					iconCls:'icon-transfer', 
					text:'确认关联关闭',
					handler:function(){MapCloseInvoice();}
				},{
		    		id:"Save",
					iconCls:'icon-transfer', 
					text:'持续确认关联',
					handler:function(){MapInvoice();}
				}]
	}
	else
	{
		toolbar=[{
		    		id:"Save",
					iconCls:'icon-add', 
					text:'补录发票',
					handler:function(){AddGridData();}
				}
				/*,{
		    		id:"Save",
					iconCls:'icon-transfer', 
					text:'查询发票',
					handler:function(){FindGridData();}
				}*/
				]
		
	}
	
	$HUI.datagrid("#instocklistdatagrid",{   
    url:$URL, 
	idField:'TISLRowID', //主键   //add by lmm 2018-10-23
    border : false,
	striped : true,
    cache: false,
    fit:true,
    fitColumns:true,  //modify by lmm 2020-06-06 UI
    singleSelect:false,
    queryParams:{
        ClassName:"web.DHCEQ.Plat.BUSInvoice",
        QueryName:"GetAInStockDetail",
        ISNo:getElementValue("ISNo"),
        LocDR:'',
        StartDate:getElementValue("StartDate"),
        EndDate:getElementValue("EndDate"),
        InvoiceNos:getElementValue("InvoiceNos"),
        MinPrice:getElementValue("MinPrice"),
        MaxPrice:getElementValue("MaxPrice"),
        ProviderDR:getElementValue("ProviderDR"),
        Name:getElementValue("Name"),
        AccessoryTypeDR:getElementValue("AISAccessoryTypeDR"),
        InvoiceInfoDR:'',
        QXType:'',
        InvoiceID:getElementValue("InvoiceDR"),
        Params:getElementValue("Status")+"^"+getElementValue("StartAuditDate")+"^"+getElementValue("EndAuditDate")  //Modify by zx 2020-09-09 BUG ZX0108
	    },
		//fitColumns:true,
    	toolbar:toolbar, 			
		pagination:true,
    	columns:columns, 
	});
		
	if(getElementValue("Status")=="0")
	{
		disableElement("BAudit",true)
	}else if(getElementValue("Status")=="1"){
		//disableElement("Save",true)
	}else if(getElementValue("Status")=="2"){
		disableElement("Save",true)
		disableElement("BAudit",true)
	}else{
		disableElement("BAudit",true)
	}
	if(getElementValue("Status")=="0,1")
	{
		disableElement("Status",true)
	}
					    
}

///add by lmm 2019-09-19
///desc:入库明细查询事件
function BFind_Clicked()
{
	$HUI.datagrid("#instocklistdatagrid",{   
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.Plat.BUSInvoice",
        QueryName:"GetAInStockDetail",
        ISNo:getElementValue("ISNo"),
        LocDR:'',
        StartDate:getElementValue("StartDate"),
        EndDate:getElementValue("EndDate"),
        InvoiceNos:getElementValue("InvoiceNos"),
        MinPrice:getElementValue("MinPrice"),
        MaxPrice:getElementValue("MaxPrice"),
        ProviderDR:getElementValue("ProviderDR"),
        Name:getElementValue("Name"),
        AccessoryTypeDR:getElementValue("AISAccessoryTypeDR"),
        InvoiceInfoDR:'',
        QXType:'',
        InvoiceID:getElementValue("InvoiceDR"),
        ShowType:getElementValue("ShowType"),
        HasInvoiceType:getElementValue("HasInvoiceType"),
        Params:getElementValue("Status")+"^"+getElementValue("StartAuditDate")+"^"+getElementValue("EndAuditDate")  //Modify by zx 2020-09-09 BUG ZX0108
	    },
	    onLoadSuccess:function(){
    	if(getElementValue("Status")=="0")
		{
			disableElement("BAudit",true)
		}else if(getElementValue("Status")=="1"){
			disableElement("BAudit",false)
		}else if(getElementValue("Status")=="2"){
			disableElement("Save",true)
			disableElement("BAudit",true)
		}else{
			disableElement("BAudit",true)
		}

}

	});
	$("#instocklistdatagrid").datagrid('clearSelections');
}

///add by csj 20200102
///desc:审核发票事件
function BAudit_Clicked()
{
	if(getElementValue("Status")!="1") return
	var rows = $('#instocklistdatagrid').datagrid('getChecked');
    if (rows=="")
    {
		messageShow("","","","未选中数据！")
	    return;
	    
	}
	var combindata=""
	$.each(rows, function(rowIndex, rowData){
		if (combindata=="")
		{ 
			combindata=rowData.TISLRowID;
		}
		 else combindata=combindata+","+rowData.TISLRowID; 
	});
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "AuditInvoice",combindata,"3");
	if (Rtn=='0')
	{
		$.messager.popover({msg: '审核成功！',type:'success',timeout: 1000});
		$("#instocklistdatagrid").datagrid('reload');
		$('#instocklistdatagrid').datagrid("unselectAll"); //Modify by zx 2020-09-10 BUG ZX0108 刷新后需要清空选择
		return;
	}
	else
	{
		$.messager.popover({msg: '审核失败！',type:'error',timeout: 1000});		
		return;
	}


}

///add by lmm 2019-07-01
///desc:补录发票弹窗详细界面
function AddGridData()
{
	
    var combindata="";
    var providerinfos=""
    var rows = $('#instocklistdatagrid').datagrid('getChecked');
    if (rows=="")
    {
		messageShow("","","","未选中数据！")
	    return;
	    
	 }
	$.each(rows, function(rowIndex, rowData){
		if (combindata=="")
		{ 
			combindata=rowData.TISLRowID;
		}
		 else combindata=combindata+","+rowData.TISLRowID; 
		 if (providerinfos=="")
		 {
			providerinfos=rowData.TProviderDR
			ProviderDR=rowData.TProviderDR
		 }
		 else
		 {
			if ((","+providerinfos+",").indexOf(","+rowData.TProviderDR+",")==-1)
			{
			providerinfos=providerinfos+","+rowData.TProviderDR
			}
			 
		 }
	}); 
	var prolen=providerinfos.split(",").length
	if (prolen>1)
	{
		messageShow("","","","选中入库明细供应商不一致！")
		return
	}
	var url="dhceq.plat.invoiceinstocklist.csp?"+"&BussType="+getElementValue("BussType")+"&InStockListStr="+combindata+"&ProviderDR="+ProviderDR+"&RequestLocDR="+getElementValue("RequestLocDR");
	var title="补录入库发票"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","","large")	
}


///add by lmm 2019-09-19
///desc:回调事件
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	if (vElementID=="AISAccessoryTypeDR_ATDesc")
	{
		setElement("AISAccessoryTypeDR",item.TRowID)
	}
}

///add by lmm 2019-09-19
///desc:清空事件
function clearData(vElementID)
{
	setElement(vElementID+"DR","")	
	if (vElementID=="AISAccessoryTypeDR_ATDesc")
	{
		setElement("AISAccessoryTypeDR","")
	}
}

///add by lmm 2019-09-19
///desc:入库明细与发票持续关联
function MapInvoice()
{
	var InvoiceDR=getElementValue("InvoiceDR")
	if (InvoiceDR=="")
	{
		messageShow("","","","未选中发票！")
		return;	
		
	}
    var combindata="";
    var rows = $('#instocklistdatagrid').datagrid('getChecked');
    if (rows=="")
    {
		messageShow("","","","未选中入库设备！")
		return; 
	    
	}
	$.each(rows, function(rowIndex, rowData){
		if (combindata=="")
		{ 
			combindata=rowData.TISLRowID;
		}
		 else combindata=combindata+","+rowData.TISLRowID; 
	}); 	
		
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "InvoiceMapBuss",InvoiceDR,combindata,"1");
	if (Rtn=='0')
	{
		websys_showModal("options").mth(combindata);  
		$.messager.popover({msg: '确认关联！',type:'success',timeout: 1000});		
		$("#instocklistdatagrid").datagrid('reload');
		return;
	}
	else
	{
		$.messager.popover({msg: '关联失败！',type:'error',timeout: 1000});		
		return;
	}
	
	
}

///add by lmm 2019-09-19
///desc:入库明细与发票关联关闭
function MapCloseInvoice()
{
	var InvoiceDR=getElementValue("InvoiceDR")
	if (InvoiceDR=="")
	{
		messageShow("","","","未选中发票！")
		return;	
		
	}
    var combindata="";
    var rows = $('#instocklistdatagrid').datagrid('getChecked');
    if (rows=="")
    {
		messageShow("","","","未选中入库设备！")
		return; 
	    
	}
	$.each(rows, function(rowIndex, rowData){
		if (combindata=="")
		{ 
			combindata=rowData.TISLRowID;
		}
		 else combindata=combindata+","+rowData.TISLRowID; 
	}); 	
		
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "InvoiceMapBuss",InvoiceDR,combindata,"1");
	if (Rtn=='0')
	{
		websys_showModal("options").mth(combindata);  
		$.messager.popover({msg: '确认关联！',type:'success',timeout: 1000});		
		//$("#instocklistdatagrid").datagrid('reload');
		closeWindow("modal")
		return;
	}
	else
	{
		$.messager.popover({msg: '关联失败！',type:'error',timeout: 1000});		
		return;
	}
	
	
}

///add by csj 2020-03-04
///desc:下拉列表初始化
function initCombobox()
{	
	var Status = $HUI.combobox('#Status',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '0,1',
				text: '新增与提交'
			},{
				id: '1',
				text: '提交'
			},{
				id: '2',
				text: '审核'
			}],
		onSelect:function(record){
			BFind_Clicked()
		}
	});	
}
