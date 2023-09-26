var columns=getCurColumnsInfo('PLAT.G.InStock.Invoice','','','');  
var SelectedRow = -1; 
$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	defindTitleStyle(); 
	initButtonWidth();
	initButton();
	initLookUp();
	if (getElementValue("RequestLocDR")!="")
	{
		
		disableElement("RequestLoc",true)
		
	}
	if (getElementValue("ShowType")=="on")
	{
		disableElement("Provider",true)
		toolbar=[{
    		id:"Save",
			iconCls:'icon-add', 
			text:'确认关联关闭',
			handler:function(){MapInStockList();
			closeWindow("modal")
			}
		},{
    		id:"Save",
			iconCls:'icon-add', 
			text:'持续确认关联',
			handler:function(){MapInStockList();}
		}]
	}
	else
	{
		toolbar=[{
    		id:"Save",
			iconCls:'icon-add', 
			text:'新增',
			handler:function(){SaveGridData();}
		},{
    		id:"Update",
			iconCls:'icon-save', 
			text:'修改',
			handler:function(){UpdateGridData();}
		},{
    		id:"Delete",
			iconCls:'icon-cancel', 
			text:'删除',
			handler:function(){DeleteGridData();}
		},{
    		id:"Map",
			iconCls:'icon-transfer', 
			text:'关联入库明细',
			handler:function(){MapGridData();}
		}]
		
	}	
	
	$HUI.datagrid("#invoicefinddatagrid",{   
    url:$URL, 
	idField:'TRowID', //主键   //add by lmm 2018-10-23
    border : false,
	striped : true,
    cache: false,
    fit:true,
    singleSelect:false,
    queryParams:{
        ClassName:"web.DHCEQ.Plat.BUSInvoice",
        QueryName:"GetInvoice",
        InvoiceNo:getElementValue("InvoiceNo"),
        ProvderDR:getElementValue("ProviderDR"),
        MinAmountFee:getElementValue("MinAmountFee"),
        MaxAmountFee:getElementValue("MaxAmountFee"),
        StartDate:getElementValue("StartDate"),
        EndDate:getElementValue("EndDate"),
        InStockListStr:getElementValue("InStockListStr"),
        ShowType:getElementValue("ShowType"),
        RequestLocDR:getElementValue("RequestLocDR"),
        BussType:getElementValue("BussType"),	// Mozy003005	1248930		2020-4-1
	    },
		//fitColumns:true,
	toolbar:toolbar, 
	onClickRow:function(rowIndex,rowData){
		if (SelectedRow==rowIndex)	{
			SelectedRow=-1
			$('#invoicefinddatagrid').datagrid('unselectAll');}
			else{SelectedRow=rowIndex;}
	},
	//onSelect:function(rowIndex,rowData){SelectSum();},
					
		pagination:true,
    	columns:columns, 
		onLoadSuccess:function(){creatToolbar();}
	});
	if (getElementValue("ShowType")!="on")
	{
	var TNo=$("#invoicefinddatagrid").datagrid('getColumnOption','TNo');
	TNo.formatter=	function(value,row,index){
			return InvoiceOperation(value,row,index)	
		}
	}
			  
					    
}
function checkboxOnChange(TFlag,rowIndex)
{
	var row = jQuery('#invoicefinddatagrid').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TFlag==key)
			{
				if (((val=="N")||val==""))
				{
					row.TFlag="Y"
				}
				else
				{
					row.TFlag="N"
				}
				SelectSum()
			}
		})
	}
}
///add by lmm 2019-09-19
///desc:选中行合计入库金额，发票金额
function SelectSum()
{
	var rows = jQuery('#invoicefinddatagrid').datagrid('getRows')
	
    var MapFee="0.00";
    var AmountFee="0.00"
	$.each(rows, function(rowIndex, rowData){
		if (rowData.TFlag=="Y")
		{
			MapFee=MapFee*1+rowData.TMapFee*1; 
			AmountFee=AmountFee*1+rowData.TAmountFee*1
		} 
	}); 
	ShowFlag=getElementValue("ShowFlag")
	var Data = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice","GetInvoiceSumInfo",'',ShowFlag);
	if (ShowFlag=="on")
	{
		var Info=Data+"&nbsp;&nbsp;&nbsp;选中入库金额:"+MapFee+"&nbsp;&nbsp;&nbsp;选中发票金额:"+AmountFee
	}
	else
	{
		var Info=Data+"&nbsp;&nbsp;&nbsp;选中入库金额:"+MapFee
	}
	$("#sumTotal").html(Info);
	
}

///add by lmm 2019-09-19
///desc:选中行合计入库金额，发票金额
function creatToolbar()
{
	ShowFlag=getElementValue("ShowFlag")
	var Data = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice","GetInvoiceSumInfo",'',ShowFlag);
	$("#sumTotal").html(Data);
	
}

///add by lmm 2019-07-01
///desc:发票补录弹窗界面
function SaveGridData()
{
	var url="dhceq.plat.invoicebindinstocklist.csp?"+"&InvoiceMapType=invoice";
	var title="发票信息"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","","large",ReloadGrid)

	
}

///add by lmm 2019-07-01
///desc:发票补录弹窗界面
function UpdateGridData()
{
	var row = $('#invoicefinddatagrid').datagrid('getSelected')   //.TRowID;
	if (row==null)
	{
		messageShow("","","","未选中数据！")
	    return;
	    
	 }
    var RowID = row.TRowID;
    var ProviderDR=row.ProviderDR;
	var url="dhceq.plat.invoicebindinstocklist.csp?"+"&RowID="+RowID+"&ProviderDR="+ProviderDR+"&MenuName=Invoice";
	var title="发票信息"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","","large",ReloadGrid)
	
}

///add by lmm 2019-07-01
///desc:发票删除
function DeleteGridData()
{
	var row = $('#invoicefinddatagrid').datagrid('getSelected')   //.TRowID;
	if (row==null)
	{
		messageShow("","","","未选中数据！")
	    return;
	    
	 }
    var InvoiceDR = row.TRowID;
    
	var Flag = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "CheckInvoiceUseMap",InvoiceDR);
	if (Flag=="1")
	{
		messageShow("","","","已与入库明细关联,查看发票详细信息进行删除！")
		return;
		//var truthBeTold = window.confirm("该发票已与入库单绑定！");
	    //if (!truthBeTold) return;
		
	}
	 
	var truthBeTold = window.confirm("您确定要删除该条记录吗");
    if (!truthBeTold) return;
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "DeleteInvoice",InvoiceDR);
	Rtn=Rtn.split("^");
	if (Rtn<0) 
	{
		messageShow("","","","删除失败！")
		return;
	}
	else
	{
		$("#invoicefinddatagrid").datagrid('reload');
	}
	
	
}
///add by lmm 2019-07-01
///desc:发票查询事件
function BFind_Clicked()
{
		$HUI.datagrid("#invoicefinddatagrid",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.BUSInvoice",
	        QueryName:"GetInvoice",
	        InvoiceNo:getElementValue("InvoiceNo"),
	        ProvderDR:getElementValue("ProviderDR"),
	        MinAmountFee:getElementValue("MinAmountFee"),
	        MaxAmountFee:getElementValue("MaxAmountFee"),
	        StartDate:getElementValue("StartDate"),
	        EndDate:getElementValue("EndDate"),
	        RequestLocDR:getElementValue("RequestLocDR"),
		    },
	});
	
			$('#invoicefinddatagrid').datagrid('unselectAll');
}
///add by lmm 2019-07-01
///desc:发票详细弹窗界面
function InvoiceOperation(value,row,index)
{
	var url="dhceq.plat.invoicebindinstocklist.csp?"+"&InvoiceMapType=invoice&RowID="+row.TRowID;
	var title="发票信息"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	var type=""
	var nfun="ReloadGrid"
	//modify by lmm 2020-06-05 UI
	btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;'+type+'&quot;,&quot;&quot;,&quot;&quot;,&quot;large&quot;,'+nfun+')" href="#">'+row.TNo+'</A>';
	return btn;
	
}

///add by lmm 2019-07-01
///desc:发票补录弹窗界面
function MapGridData()
{
	
	var rows = $('#invoicefinddatagrid').datagrid('getChecked')   //.TRowID;
	if (rows=="")
	{
		messageShow("","","","未选中数据！")
	    return;
	    
	 }
	
    var combindata="";
    var providerinfos=""
	$.each(rows, function(rowIndex, rowData){
		if (combindata=="")
		{ 
			combindata=rowData.TRowID;
		}
		 else combindata=combindata+","+rowData.TRowID; 
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
	var url="dhceq.plat.invoicemapinstock.csp?&InvoiceStr="+combindata+"&ProviderDR="+ProviderDR+"&MenuName=Invoice";
	var title="发票关联入库明细"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","","large",ReloadGrid)
	
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
///desc:重载列表
function ReloadGrid()
{
	$("#invoicefinddatagrid").datagrid('reload');
	
}
///add by lmm 2019-09-19
///desc:勾选发票与入库明细关联
function MapInStockList()
{
	var rows = $('#invoicefinddatagrid').datagrid('getChecked')   
	if (rows=="")
	{
		messageShow("","","","未选中数据！")
	    return;
	    
	 }
	 var InvoiceStr=""
	$.each(rows, function(rowIndex, rowData){
		if (InvoiceStr=="")
		{ 
			InvoiceStr=rowData.TRowID;
		}
		 else InvoiceStr=InvoiceStr+","+rowData.TRowID; 
	}); 
	var InStockListStr=getElementValue("InStockListStr")
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "InvoiceMapBuss",InvoiceStr,InStockListStr,getElementValue("BussType"));	// Mozy003005	1248957		2020-4-1
	if (Rtn=='0')
	{
		websys_showModal("options").mth();  //modify by lmm 2019-02-19
		$.messager.popover({msg: '确认关联！',type:'success',timeout: 1000});		
		$("#invoicefinddatagrid").datagrid('reload');
		return;
		//$.messager.alert('确认关联！',data, 'warning')
	}
	else
	{
		$.messager.popover({msg: '关联失败！',type:'error',timeout: 1000});		
		return;
	}
	
	
}





