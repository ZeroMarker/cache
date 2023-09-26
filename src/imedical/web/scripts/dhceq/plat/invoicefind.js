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
			text:'ȷ�Ϲ����ر�',
			handler:function(){MapInStockList();
			closeWindow("modal")
			}
		},{
    		id:"Save",
			iconCls:'icon-add', 
			text:'����ȷ�Ϲ���',
			handler:function(){MapInStockList();}
		}]
	}
	else
	{
		toolbar=[{
    		id:"Save",
			iconCls:'icon-add', 
			text:'����',
			handler:function(){SaveGridData();}
		},{
    		id:"Update",
			iconCls:'icon-save', 
			text:'�޸�',
			handler:function(){UpdateGridData();}
		},{
    		id:"Delete",
			iconCls:'icon-cancel', 
			text:'ɾ��',
			handler:function(){DeleteGridData();}
		},{
    		id:"Map",
			iconCls:'icon-transfer', 
			text:'���������ϸ',
			handler:function(){MapGridData();}
		}]
		
	}	
	
	$HUI.datagrid("#invoicefinddatagrid",{   
    url:$URL, 
	idField:'TRowID', //����   //add by lmm 2018-10-23
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
///desc:ѡ���кϼ�������Ʊ���
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
		var Info=Data+"&nbsp;&nbsp;&nbsp;ѡ�������:"+MapFee+"&nbsp;&nbsp;&nbsp;ѡ�з�Ʊ���:"+AmountFee
	}
	else
	{
		var Info=Data+"&nbsp;&nbsp;&nbsp;ѡ�������:"+MapFee
	}
	$("#sumTotal").html(Info);
	
}

///add by lmm 2019-09-19
///desc:ѡ���кϼ�������Ʊ���
function creatToolbar()
{
	ShowFlag=getElementValue("ShowFlag")
	var Data = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice","GetInvoiceSumInfo",'',ShowFlag);
	$("#sumTotal").html(Data);
	
}

///add by lmm 2019-07-01
///desc:��Ʊ��¼��������
function SaveGridData()
{
	var url="dhceq.plat.invoicebindinstocklist.csp?"+"&InvoiceMapType=invoice";
	var title="��Ʊ��Ϣ"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","","large",ReloadGrid)

	
}

///add by lmm 2019-07-01
///desc:��Ʊ��¼��������
function UpdateGridData()
{
	var row = $('#invoicefinddatagrid').datagrid('getSelected')   //.TRowID;
	if (row==null)
	{
		messageShow("","","","δѡ�����ݣ�")
	    return;
	    
	 }
    var RowID = row.TRowID;
    var ProviderDR=row.ProviderDR;
	var url="dhceq.plat.invoicebindinstocklist.csp?"+"&RowID="+RowID+"&ProviderDR="+ProviderDR+"&MenuName=Invoice";
	var title="��Ʊ��Ϣ"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","","large",ReloadGrid)
	
}

///add by lmm 2019-07-01
///desc:��Ʊɾ��
function DeleteGridData()
{
	var row = $('#invoicefinddatagrid').datagrid('getSelected')   //.TRowID;
	if (row==null)
	{
		messageShow("","","","δѡ�����ݣ�")
	    return;
	    
	 }
    var InvoiceDR = row.TRowID;
    
	var Flag = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "CheckInvoiceUseMap",InvoiceDR);
	if (Flag=="1")
	{
		messageShow("","","","���������ϸ����,�鿴��Ʊ��ϸ��Ϣ����ɾ����")
		return;
		//var truthBeTold = window.confirm("�÷�Ʊ������ⵥ�󶨣�");
	    //if (!truthBeTold) return;
		
	}
	 
	var truthBeTold = window.confirm("��ȷ��Ҫɾ��������¼��");
    if (!truthBeTold) return;
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "DeleteInvoice",InvoiceDR);
	Rtn=Rtn.split("^");
	if (Rtn<0) 
	{
		messageShow("","","","ɾ��ʧ�ܣ�")
		return;
	}
	else
	{
		$("#invoicefinddatagrid").datagrid('reload');
	}
	
	
}
///add by lmm 2019-07-01
///desc:��Ʊ��ѯ�¼�
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
///desc:��Ʊ��ϸ��������
function InvoiceOperation(value,row,index)
{
	var url="dhceq.plat.invoicebindinstocklist.csp?"+"&InvoiceMapType=invoice&RowID="+row.TRowID;
	var title="��Ʊ��Ϣ"
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
///desc:��Ʊ��¼��������
function MapGridData()
{
	
	var rows = $('#invoicefinddatagrid').datagrid('getChecked')   //.TRowID;
	if (rows=="")
	{
		messageShow("","","","δѡ�����ݣ�")
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
		messageShow("","","","ѡ�������ϸ��Ӧ�̲�һ�£�")
		return
	}
	var url="dhceq.plat.invoicemapinstock.csp?&InvoiceStr="+combindata+"&ProviderDR="+ProviderDR+"&MenuName=Invoice";
	var title="��Ʊ���������ϸ"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","","large",ReloadGrid)
	
}
///add by lmm 2019-09-19
///desc:�ص��¼�
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}

///add by lmm 2019-09-19
///desc:����¼�
function clearData(vElementID)
{
	setElement(vElementID+"DR","")	
}

///add by lmm 2019-09-19
///desc:�����б�
function ReloadGrid()
{
	$("#invoicefinddatagrid").datagrid('reload');
	
}
///add by lmm 2019-09-19
///desc:��ѡ��Ʊ�������ϸ����
function MapInStockList()
{
	var rows = $('#invoicefinddatagrid').datagrid('getChecked')   
	if (rows=="")
	{
		messageShow("","","","δѡ�����ݣ�")
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
		$.messager.popover({msg: 'ȷ�Ϲ�����',type:'success',timeout: 1000});		
		$("#invoicefinddatagrid").datagrid('reload');
		return;
		//$.messager.alert('ȷ�Ϲ�����',data, 'warning')
	}
	else
	{
		$.messager.popover({msg: '����ʧ�ܣ�',type:'error',timeout: 1000});		
		return;
	}
	
	
}





