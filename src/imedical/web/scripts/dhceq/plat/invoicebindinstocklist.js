var columns=getCurColumnsInfo('PLAT.G.InStock.InvoiceInStockList','','','');  
var GlobalObj = {
	ProviderDR : "",
	InvoiceNo : "",
}

$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	defindTitleStyle(); 
	initButtonWidth();
	initButton();
	setRequiredElements("Provider^InvoiceNo^ProviderDR^RequestLoc^RequestLocDR")
	initMessage();
	jQuery("#BClear").linkbutton({iconCls: 'icon-w-clean'});
	jQuery("#BClear").on("click", BClear_Clicked);
	initLookUp();
	FillData();
	if (getElementValue("MenuName")=="Invoice")
	{
		disableElement("Provider",true)
	}	
	// Mozy003005	1248904		2020-4-1
	var GetInStockListQueryName="GetInStockDetail"
	if(getElementValue("BussType")==3) 
	{
		GetInStockListQueryName="GetAInStockDetail"
	}
		$HUI.datagrid("#instocklistdatagrid",{   
	    url:$URL, 
		idField:'TISLRowID', //����   //add by lmm 2018-10-23
	    border : false,
	    title:'���������ϸ',
	    headerCls:'panel-header-gray',
		striped : true,
	    cache: false,
	    fit:true,
	    singleSelect:false,
	    queryParams:{
	        ClassName:"web.DHCEQ.Plat.BUSInvoice",
	        QueryName:GetInStockListQueryName,	// Mozy003007	1248909		2020-04-07
	        ISNo:'',
	        LocDR:'',
	        StartDate:'',
	        EndDate:'',
	        InvoiceNos:getElementValue("InvoiceNo"),
	        MinPrice:'',
	        MaxPrice:'',
	        ProviderDR:'',
	        Name:'',
	        EquipTypeDR:'',
	        InvoiceInfoDR:'',
	        QXType:'',
	        InvoiceID:getElementValue("RowID"),
	        ShowType:'off'
		    },
			//fitColumns:true,
	    	toolbar:[
	    		{
		    		id:"Remove",
					iconCls:'icon-remove', 
					text:'ȡ������',
					handler:function(){RemoveGridData();}
				} ,
	    		{
		    		id:"Save",
					iconCls:'icon-add', 
					text:'����������ϸ',
					handler:function(){AddGridData();}
				} 
			], 			
			pagination:true,
	    	columns:columns, 
			onLoadSuccess:function(){creatToolbar();}
	});
	$('#instocklistdatagrid').datagrid('hideColumn','TProvider');
			  
					    
}

///add by lmm 2019-07-01
///desc:�����ϸ�ϼƽ��
function creatToolbar()
{
//	var Data = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice","GetInStockSumInfo",'');
//	$("#sumTotal").html(Data);
	var rows = jQuery('#instocklistdatagrid').datagrid('getRows')
    var Count=0;
    var TotalFee=0
	$.each(rows, function(rowIndex, rowData){
		Count=Count*1+rowData.TQuantityNum*1; 
		TotalFee=TotalFee*1+rowData.TTotalFee*1
	});
	var Data="������:"+Count+"&nbsp;&nbsp;&nbsp;�ܽ��:"+TotalFee+"Ԫ"  
	$("#sumTotal").html(Data);
}

///add by lmm 2019-07-01
///desc:��Ʊ���ѹ�����ϸɾ��
function BDelete_Clicked()
{
	
    var InvoiceDR=getElementValue("RowID")
	var Flag = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "CheckInvoiceUseMap",InvoiceDR);
	if (Flag=="1")
	{
		var truthBeTold = window.confirm("��Ʊ�ѹ�����ϸ���ѹ�����ϸ�Ƿ�ɾ����");
	    if (!truthBeTold) return;
		
	}
	else
	{
		var truthBeTold = window.confirm("��ȷ��Ҫɾ��������¼��");
	    if (!truthBeTold) return;
	}
	var RtnList = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "CancelAllInvoiceMapBuss",InvoiceDR,getElementValue("BussType"));	// Mozy003005	1248904		2020-4-1
	if (RtnList<0)
	{
		messageShow("","","","������ϸɾ��ʧ�ܣ�")
		return;		
	}
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "DeleteInvoice",InvoiceDR);
	Rtn=Rtn.split("^");
	if (Rtn<0) 
	{
		messageShow("","","","ɾ��ʧ�ܣ�")
		return;
	}
	else
	{
		websys_showModal("options").mth();  //modify by lmm 2019-02-19
	    window.location.href= "dhceq.plat.invoicebindinstocklist.csp?&RowID="+"&BussType="+getElementValue("BussType");	// Mozy003005	1248904		2020-4-1
	}
	
}

///add by lmm 2019-07-22
///��������յ�ǰҳ��
function BClear_Clicked()
{
    window.location.href= "dhceq.plat.invoicebindinstocklist.csp?&RowID="+"&BussType="+getElementValue("BussType");	// Mozy003005	1248904		2020-4-1
	
}

///add by lmm 2019-07-22
///�����������Ʊ�������ϸ����
function RemoveGridData()
{
	var InvoiceDR=getElementValue("RowID")
    var combindata="";
    var rows = $('#instocklistdatagrid').datagrid('getChecked');
	$.each(rows, function(rowIndex, rowData){
		if (combindata=="")
		{ 
			combindata=rowData.TISLRowID;
		}
		 else combindata=combindata+","+rowData.TISLRowID; 
	}); 
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "CancelInvoiceMapBuss",InvoiceDR,combindata,getElementValue("BussType"));	// Mozy003005	1248904		2020-4-1
	if (Rtn=='0')
	{
		$.messager.popover({msg: 'ȡ������!',type:'success',timeout: 1000});	
		websys_showModal("options").mth();  //modify by lmm 2019-02-19
		$("#instocklistdatagrid").datagrid('reload');
	}	else
	{
		$.messager.popover({msg: 'ȡ��ʧ�ܣ�',type:'error',timeout: 1000});		
		return;
	}
		
	
}


///add by lmm 2019-07-01
///���������������󶨽���
function AddGridData()
{
	var url="dhceq.plat.instocklist.csp?"+"&MapType=1&HasInvoiceType=2"+"&ShowType=on"+"&InvoiceDR="+getElementValue("RowID")+"&ProviderDR="+getElementValue("ProviderDR")+"&MenuName=Invoice"+"&BussType="+getElementValue("BussType");	// Mozy003005	1248904		2020-4-1
	var title="�����ϸ�б�"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","","large",ReloadGrid)

	
}

///add by lmm 2019-09-12
///���������淢Ʊ��Ϣ����¼�
function BSave_Clicked()
{
	if (checkMustItemNull()) return;
	var InvoiceDR=getElementValue("RowID")
	var rows = $('#instocklistdatagrid').datagrid('getRows');
	if ((InvoiceDR!="")&&(rows!="")&&(GlobalObj.InvoiceNo!=getElementValue("InvoiceNo")))
	{
		var truthBeTold = window.confirm("�ѹ�����ϸ,�Ƿ��޸ķ�Ʊ�ţ�");
	    if (!truthBeTold) return;
		
	}
	if ((InvoiceDR!="")&&(rows!="")&&(GlobalObj.ProviderDR!=getElementValue("ProviderDR")))
	{
		var truthBeTold = window.confirm("��Ӧ���޸����������ϸȡ������");
	    if (!truthBeTold) return;
		var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "CancelAllInvoiceMapBuss",InvoiceDR,getElementValue("BussType"));	// Mozy003005	1248904		2020-4-1
		if (Rtn=='0')
		{
			$.messager.popover({msg: 'ȡ������!',type:'success',timeout: 1000});
			websys_showModal("options").mth();
			$("#instocklistdatagrid").datagrid('reload');
		}	else
		{
			$.messager.popover({msg: 'ȡ��ʧ��!',type:'error',timeout: 1000});		
			return;
		}
	    
	    
		
	}
	var val=""
	var val=getElementValue("RowID")
	var val=val+InvoiceData()
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "SaveData",val);
	Rtn=Rtn.split("^");
	if (Rtn<0) 
	{
		$.messager.popover({msg: '����ʧ�ܣ�',type:'error',timeout: 1000});		
		return;	
	}
	
    window.location.href= "dhceq.plat.invoicebindinstocklist.csp?&RowID="+Rtn[1]+"&BussType="+getElementValue("BussType");	// Mozy003005	1248904		2020-4-1
		
	
}

///add by lmm 2019-09-12
///���������淢Ʊ��Ϣ����¼�
function BAdd_Clicked()
{
	var val=""
	var val=getElementValue("RowID")
	var val=val+InvoiceData()  
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "SaveData",val);
	Rtn=Rtn.split("^");
	if (Rtn<0) 
	{
		$.messager.popover({msg: '����ʧ�ܣ�',type:'error',timeout: 1000});		
		return;	
	}
	
    window.location.href= "dhceq.plat.invoicebindinstocklist.csp?&RowID="+Rtn[1]+"&BussType="+getElementValue("BussType");	// Mozy003005	1248904		2020-4-1
		
	
}
///add by lmm 2019-09-12
///��������Ʊ��Ϣƴ��
function InvoiceData()
{
	var val=""
	var val=val+"^"+getElementValue("InvoiceCode")
	var val=val+"^"+getElementValue("InvoiceNo")
	var val=val+"^"+getElementValue("Date")
	var val=val+"^"+getElementValue("AmountFee")
	var val=val+"^"+getElementValue("ProviderDR")
	var val=val+"^"+getElementValue("TypeDR")   
	var val=val+"^"+getElementValue("Customer")     
	var val=val+"^"+getElementValue("InvoiceDept")    
	var val=val+"^"+getElementValue("PayedAmountFee")    
	var val=val+"^"+getElementValue("Remark")    
	var val=val+"^"+getElementValue("CertificateDR")    
	var val=val+"^"+getElementValue("RequestLocDR")   //modify by lmm 2019-09-19 Hold1 ռ�ù������
	var val=val+"^"+getElementValue("Hold2")    
	var val=val+"^"+getElementValue("Hold3")    
	var val=val+"^"+getElementValue("Hold4")    
	var val=val+"^"+getElementValue("Hold5")   
	return val	
	
}

///add by lmm 2019-09-19
///desc:��Ʊ�������
function FillData()
{
	var InvoiceID=getElementValue("RowID")
	if (InvoiceID=="") return
	var list = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "GetOneInvoice",InvoiceID);	
	list=list.replace(/\ +/g,"")	//ȥ���ո�
	list=list.replace(/[\r\n]/g,"")	//ȥ���س�����
	list=list.split("^");
	setElement("InvoiceCode",list[0])	
	setElement("InvoiceNo",list[1])	
	GlobalObj.InvoiceNo=list[1]	
	setElement("Date",list[22])	
	setElement("AmountFee",list[3])	
	setElement("ProviderDR",list[4])
	GlobalObj.ProviderDR=list[4]	
	setElement("TypeDR",list[5])	
	setElement("Customer",list[6])	
	setElement("InvoiceDept",list[7])	
	setElement("PayedAmountFee",list[8])	
	setElement("Remark",list[13])	
	setElement("CertificateDR",list[14])	
	//setElement("Hold1",list[16])
	//modify by lmm 2019-09-19 Hold1 ռ�ù���������� 	
	setElement("RequestLoc",list[23])
	setElement("RequestLocDR",list[16])
	setElement("Hold2",list[17])	
	setElement("Hold3",list[18])	
	setElement("Hold4",list[19])	
	setElement("Hold5",list[20])	
	setElement("Provider",list[21])	
	
	
	
		
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
	$("#instocklistdatagrid").datagrid('reload');
	
}
