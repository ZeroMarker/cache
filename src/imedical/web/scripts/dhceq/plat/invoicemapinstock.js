var invoicecolumns=getCurColumnsInfo('PLAT.G.InStock.Invoice','','','');  
var columns=getCurColumnsInfo('PLAT.G.InStock.InvoiceInStockList','','','');  

$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	defindTitleStyle(); 
	
	$HUI.datagrid("#invoicelistdatagrid",{   
    url:$URL, 
	idField:'TRowID', //主键   //add by lmm 2018-10-23
    border : false,
	striped : true,
    cache: false,
    fit:true,
    title:'发票明细列表',
    headerCls:'panel-header-gray',
    singleSelect:false,
    queryParams:{
        ClassName:"web.DHCEQ.Plat.BUSInvoice",
        QueryName:"GetInvoice",
        InvoiceNo:'',
        ProvderDR:'',
        InvoiceStr:getElementValue("InvoiceStr"),
        InStockListStr:getElementValue("InStockListStr"),
        ShowType:'off',
	    },
		//fitColumns:true,
		
		pagination:true,
    	columns:invoicecolumns, 
});
	$HUI.datagrid("#instocklistdatagrid",{   
    url:$URL, 
	idField:'TISLRowID', //主键   //add by lmm 2018-10-23
    border : false,
	striped : true,
    cache: false,
    fit:true,
    title:'关联入库明细',
    headerCls:'panel-header-gray',
    singleSelect:false,
    queryParams:{
        ClassName:"web.DHCEQ.Plat.BUSInvoice",
        QueryName:"GetInStockDetail",
        InvoiceNo:'',
        ProvderDR:'',
        InvoiceID:getElementValue("InvoiceStr"),
        ShowType:'off',
        InStockListStr:getElementValue("InStockListStr"),
	    },
		//fitColumns:true,
    	toolbar:[
    		{
	    		id:"Save",
				iconCls:'icon-remove', 
				text:'取消关联',
				handler:function(){RemoveGridData();}
			} ,
    		{
	    		id:"Save",
				iconCls:'icon-add', 
				text:'新增关联明细',
				handler:function(){AddGridData();}
			} 
		],	
		pagination:true,
    	columns:columns, 
		onLoadSuccess:function(){creatToolbar();}
});
			  
	if (getElementValue("MenuName")=="Invoice")
	{$('#invoicelistdatagrid').datagrid('hideColumn','TFlag');}
	$('#instocklistdatagrid').datagrid('hideColumn','TProvider');
}


///add by lmm 2019-07-01
///desc:新增关联入库明细弹窗界面
function AddGridData()
{
    var InvoiceStr="";
	if (getElementValue("MenuName")=="Invoice")
	{
    var rows = $('#invoicelistdatagrid').datagrid('getRows');
	}
	if (getElementValue("MenuName")=="InStockList")
	{
    var rows = $('#invoicelistdatagrid').datagrid('getChecked');
	}
	$.each(rows, function(rowIndex, rowData){
		if (InvoiceStr=="")
		{ 
			InvoiceStr=rowData.TRowID;
		}
		 else InvoiceStr=InvoiceStr+","+rowData.TRowID; 
	}); 
	var url="dhceq.plat.instocklist.csp?"+"&MapType=1&ShowType=on&HasInvoiceType=2&BussType="+getElementValue("BussType")+"&InvoiceDR="+InvoiceStr+"&ProviderDR="+getElementValue("ProviderDR")+"&MenuName="+getElementValue("MenuName");
	var title="入库明细列表"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","","large",ReloadGrid)
	
}

///add by lmm 2019-09-06
///desc:发票与入库明细取消关联
function RemoveGridData()
{
    var invoicestr="";
	if (getElementValue("MenuName")=="Invoice")
	{
    var rows = $('#invoicelistdatagrid').datagrid('getRows');
	}
	if (getElementValue("MenuName")=="InStockList")
	{
    var rows = $('#invoicelistdatagrid').datagrid('getChecked');
	}
	if (rows=="")
	{
		messageShow("","","","未选中发票！")
		return;
		
	}
	$.each(rows, function(rowIndex, rowData){
		if (invoicestr=="")
		{ 
			invoicestr=rowData.TRowID;
		}
		 else invoicestr=invoicestr+","+rowData.TRowID; 
	}); 
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
	
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "CancelInvoiceMapBuss",invoicestr,combindata,"1");
	if (Rtn=='0')
	{
		$.messager.popover({msg: '取消关联！',type:'success',timeout: 1000});		
		$("#instocklistdatagrid").datagrid('reload');
	}	
	else
	{
		$.messager.popover({msg: '取消失败！',type:'error',timeout: 1000});		
		return;
	}
	
	
}

///add by lmm 2019-07-03
///desc:列表数据重载
function ReloadGrid(InStockListStr)
{
	if (getElementValue("MenuName")=="InStockList")
	{
		var InStockListStr=getElementValue("InStockListStr")+","+InStockListStr
		setElement("InStockListStr",InStockListStr)
	}
	$HUI.datagrid("#instocklistdatagrid",{   
    url:$URL, 
	idField:'TRowID', //主键   //add by lmm 2018-10-23
    queryParams:{
        ClassName:"web.DHCEQ.Plat.BUSInvoice",
        QueryName:"GetInStockDetail",
        InvoiceNo:'',
        ProvderDR:'',
        InvoiceID:getElementValue("InvoiceStr"),
        ShowType:'off',
        InStockListStr:getElementValue("InStockListStr"),
	    },
});
}

///add by lmm 2019-07-03
///desc:入库明细金额合计
function creatToolbar()
{
	var Data = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice","GetInStockSumInfo",'');
	$("#sumTotal").html(Data);
	
}



