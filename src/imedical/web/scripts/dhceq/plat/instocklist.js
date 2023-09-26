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
	// Mozy003007	1260544		2020-04-07
	var GetInStockListQueryName="GetInStockDetail"
	if(getElementValue("BussType")==3) 
	{
		GetInStockListQueryName="GetAInStockDetail"
	}
	
	$HUI.datagrid("#instocklistdatagrid",{   
    url:$URL, 
	idField:'TISLRowID', //主键   //add by lmm 2018-10-23
    border : false,
	striped : true,
    cache: false,
    fit:true,
    singleSelect:false,
    queryParams:{
        ClassName:"web.DHCEQ.Plat.BUSInvoice",
        QueryName:GetInStockListQueryName,		// Mozy003007	1260544		2020-04-07
        ISNo:getElementValue("ISNo"),
        LocDR:'',
        StartDate:getElementValue("StartDate"),
        EndDate:getElementValue("EndDate"),
        InvoiceNos:getElementValue("InvoiceNos"),
        MinPrice:getElementValue("MinPrice"),
        MaxPrice:getElementValue("MaxPrice"),
        ProviderDR:getElementValue("ProviderDR"),
        Name:getElementValue("Name"),
        EquipTypeDR:getElementValue("EquipTypeDR"),
        InvoiceInfoDR:'',
        QXType:'',
        InvoiceID:getElementValue("InvoiceDR"),
        ShowType:getElementValue("ShowType"),
        HasInvoiceType:getElementValue("HasInvoiceType"),
        Status:getElementValue("Status"),	//add by csj 20200102
	    },
		fitColumns:true,   //modify by lmm 2020-06-04
    	toolbar:toolbar, 			
		pagination:true,
    	columns:columns, 
	});
	if (getElementValue("MenuName")!="")
	{
		disableElement("Provider",true)
		$('#instocklistdatagrid').datagrid('hideColumn','TProvider');
	}
	
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
	// Mozy003007	1260544		2020-04-07
	var GetInStockListQueryName="GetInStockDetail"
	if(getElementValue("BussType")==3) 
	{
		GetInStockListQueryName="GetAInStockDetail"
	}
	$HUI.datagrid("#instocklistdatagrid",{   
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCEQ.Plat.BUSInvoice",
        QueryName:GetInStockListQueryName,		// Mozy003007	1260544		2020-04-07
        ISNo:getElementValue("ISNo"),
        LocDR:'',
        StartDate:getElementValue("StartDate"),
        EndDate:getElementValue("EndDate"),
        InvoiceNos:getElementValue("InvoiceNos"),
        MinPrice:getElementValue("MinPrice"),
        MaxPrice:getElementValue("MaxPrice"),
        ProviderDR:getElementValue("ProviderDR"),
        Name:getElementValue("Name"),
        EquipTypeDR:getElementValue("EquipTypeDR"),
        InvoiceInfoDR:'',
        QXType:'',
        InvoiceID:getElementValue("InvoiceDR"),
        ShowType:getElementValue("ShowType"),
        HasInvoiceType:getElementValue("HasInvoiceType"),
        Status:getElementValue("Status"),	//add by csj 20200102
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
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "AuditInvoice",combindata,getElementValue("BussType"));	// Mozy003007	1260544		2020-04-07
	if (Rtn=='0')
	{
		$.messager.popover({msg: '审核成功！',type:'success',timeout: 1000});
		$("#instocklistdatagrid").datagrid('reload');
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


///add by lmm 2019-07-02
///发票查询界面 已弃用
function FindGridData()
{
    var combindata="";
    var providerinfos=""
    var rows = $('#instocklistdatagrid').datagrid('getChecked');
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
	var url="dhceq.plat.invoicemapinstock.csp?"+"&BussType="+getElementValue("BussType")+"&InStockListStr="+combindata+"&ProviderDR="+ProviderDR+"&MenuName=InStockList";
	var title="入库明细发票查询列表"
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
}

///add by lmm 2019-09-19
///desc:清空事件
function clearData(vElementID)
{
	setElement(vElementID+"DR","")	
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
		
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "InvoiceMapBuss",InvoiceDR,combindata,getElementValue("BussType"));	// Mozy003007	1260544		2020-04-07
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
		
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "InvoiceMapBuss",InvoiceDR,combindata,getElementValue("BussType"));	// Mozy003007	1260544		2020-04-07
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

///add by lmm 2019-09-19
///desc:下拉列表初始化
function initCombobox()
{
	var HasInvoiceType = $HUI.combobox('#HasInvoiceType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: '所有明细'
			},{
				id: '1',
				text: '包含关联发票'
			},{
				id: '2',
				text: '不包含关联发票'
			}]
	});	
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
