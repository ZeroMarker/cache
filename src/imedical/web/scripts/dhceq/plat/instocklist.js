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
					text:'ȷ�Ϲ����ر�',
					handler:function(){MapCloseInvoice();}
				},{
		    		id:"Save",
					iconCls:'icon-transfer', 
					text:'����ȷ�Ϲ���',
					handler:function(){MapInvoice();}
				}]
	}
	else
	{
		toolbar=[{
		    		id:"Save",
					iconCls:'icon-add', 
					text:'��¼��Ʊ',
					handler:function(){AddGridData();}
				}
				/*,{
		    		id:"Save",
					iconCls:'icon-transfer', 
					text:'��ѯ��Ʊ',
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
	idField:'TISLRowID', //����   //add by lmm 2018-10-23
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
///desc:�����ϸ��ѯ�¼�
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
///desc:��˷�Ʊ�¼�
function BAudit_Clicked()
{
	if(getElementValue("Status")!="1") return
	var rows = $('#instocklistdatagrid').datagrid('getChecked');
    if (rows=="")
    {
		messageShow("","","","δѡ�����ݣ�")
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
		$.messager.popover({msg: '��˳ɹ���',type:'success',timeout: 1000});
		$("#instocklistdatagrid").datagrid('reload');
		return;
	}
	else
	{
		$.messager.popover({msg: '���ʧ�ܣ�',type:'error',timeout: 1000});		
		return;
	}


}

///add by lmm 2019-07-01
///desc:��¼��Ʊ������ϸ����
function AddGridData()
{
	
    var combindata="";
    var providerinfos=""
    var rows = $('#instocklistdatagrid').datagrid('getChecked');
    if (rows=="")
    {
		messageShow("","","","δѡ�����ݣ�")
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
		messageShow("","","","ѡ�������ϸ��Ӧ�̲�һ�£�")
		return
	}
	var url="dhceq.plat.invoiceinstocklist.csp?"+"&BussType="+getElementValue("BussType")+"&InStockListStr="+combindata+"&ProviderDR="+ProviderDR+"&RequestLocDR="+getElementValue("RequestLocDR");
	var title="��¼��ⷢƱ"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","","large")

	
}


///add by lmm 2019-07-02
///��Ʊ��ѯ���� ������
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
		messageShow("","","","ѡ�������ϸ��Ӧ�̲�һ�£�")
		return
	}
	var url="dhceq.plat.invoicemapinstock.csp?"+"&BussType="+getElementValue("BussType")+"&InStockListStr="+combindata+"&ProviderDR="+ProviderDR+"&MenuName=InStockList";
	var title="�����ϸ��Ʊ��ѯ�б�"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","","large")
	
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
///desc:�����ϸ�뷢Ʊ��������
function MapInvoice()
{
	var InvoiceDR=getElementValue("InvoiceDR")
	if (InvoiceDR=="")
	{
		messageShow("","","","δѡ�з�Ʊ��")
		return;	
		
	}
    var combindata="";
    var rows = $('#instocklistdatagrid').datagrid('getChecked');
    if (rows=="")
    {
		messageShow("","","","δѡ������豸��")
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
		$.messager.popover({msg: 'ȷ�Ϲ�����',type:'success',timeout: 1000});		
		$("#instocklistdatagrid").datagrid('reload');
		return;
	}
	else
	{
		$.messager.popover({msg: '����ʧ�ܣ�',type:'error',timeout: 1000});		
		return;
	}
	
	
}

///add by lmm 2019-09-19
///desc:�����ϸ�뷢Ʊ�����ر�
function MapCloseInvoice()
{
	var InvoiceDR=getElementValue("InvoiceDR")
	if (InvoiceDR=="")
	{
		messageShow("","","","δѡ�з�Ʊ��")
		return;	
		
	}
    var combindata="";
    var rows = $('#instocklistdatagrid').datagrid('getChecked');
    if (rows=="")
    {
		messageShow("","","","δѡ������豸��")
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
		$.messager.popover({msg: 'ȷ�Ϲ�����',type:'success',timeout: 1000});		
		//$("#instocklistdatagrid").datagrid('reload');
		closeWindow("modal")
		return;
	}
	else
	{
		$.messager.popover({msg: '����ʧ�ܣ�',type:'error',timeout: 1000});		
		return;
	}
	
	
}

///add by lmm 2019-09-19
///desc:�����б��ʼ��
function initCombobox()
{
	var HasInvoiceType = $HUI.combobox('#HasInvoiceType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: '������ϸ'
			},{
				id: '1',
				text: '����������Ʊ'
			},{
				id: '2',
				text: '������������Ʊ'
			}]
	});	
	var Status = $HUI.combobox('#Status',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '0,1',
				text: '�������ύ'
			},{
				id: '1',
				text: '�ύ'
			},{
				id: '2',
				text: '���'
			}],
			onSelect:function(record){
				BFind_Clicked()
			}
		});	
}
