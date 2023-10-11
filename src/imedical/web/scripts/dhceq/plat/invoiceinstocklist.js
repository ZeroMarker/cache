var invoicecolumns=getCurColumnsInfo('PLAT.G.InStock.Invoice','','','');  
var columns=getCurColumnsInfo('PLAT.G.InStock.InvoiceInStockList','','',''); 
var BussType=getElementValue("BussType")	//add by csj 2020-02-11 ��׼��-��ⲹ¼�����޸� 
SelectedRow=-1
$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	defindTitleStyle(); 
	initLookUp();
	initButton();
	disableElement("BSave",true) //modify by mwz 20210415 MWZ0046 
	$("#RequestLoc").validatebox() //modify by mwz 20210519 MWZ0049
	initButtonWidth();
	setRequiredElements("Provider^InvoiceNo^ProviderDR^RequestLoc"); 
	initMessage();
	$HUI.datagrid("#invoicelistdatagrid",{   
    url:$URL, 
	idField:'TRowID', //����   //add by lmm 2018-10-23
    border : false,
	striped : true,
    cache: false,
    fit:true,
    title:'��Ʊ��ϸ�б�',
    headerCls:'panel-header-gray',
    singleSelect:false,
	toolbar:[
		{
    		id:"Remove",
			iconCls:'icon-remove', 
			text:'ȡ������',
			handler:function(){RemoveGridData();}
		} ,
		{
    		id:"Delete",
			iconCls:'icon-cancel', 
			text:'��Ʊɾ��',
			handler:function(){DeleteGridData();}
		},
		{
    		id:"Insert",
			iconCls:'icon-add', 
			text:'�������з�Ʊ',
			handler:function(){MapGridData();}
		} 
	],
    queryParams:{
    ClassName:"web.DHCEQ.Plat.BUSInvoice",
    QueryName:"GetInvoice",
    InvoiceNo:'',
    ProvderDR:'',
    InStockListStr:getElementValue("InStockListStr"),
    ShowType:'off',
    BussType:BussType,//add by csj 2020-02-11 ��׼��-��ⲹ¼�����޸� 
    },
	//fitColumns:true,
	//pagination:true,
	columns:invoicecolumns, 
	onClickRow:function(rowIndex,rowData){
		if (SelectedRow==rowIndex)	{
			SelectedRow=-1
			disableElement("BSave",true)  //modify by mwz 20210415 MWZ0046 
			ClearInvoiceData()
			$('#invoicefinddatagrid').datagrid('unselectAll');}
			else{
				var InvoiceID=rowData.TRowID
				SelectedRow=rowIndex;
				disableElement("BSave",false)  //modify by mwz 20210415 MWZ0046 
				FillData(InvoiceID)

				}
	},
	});
	//add by csj 2020-02-11 ��׼��-��ⲹ¼�����޸� 
	var GetInStockListQueryName="GetInStockDetail"
	if(BussType==3) 
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
    title:'���������ϸ',
    headerCls:'panel-header-gray',
    singleSelect:false,
    queryParams:{
        ClassName:"web.DHCEQ.Plat.BUSInvoice",
        QueryName:GetInStockListQueryName,	//modified by csj 2020-02-11 ��׼��-��ⲹ¼�����޸� 
        InStockListStr:getElementValue("InStockListStr"),
        ShowType:'off',
	    },
		//fitColumns:true,			
		//pagination:true,
    	columns:columns, 
		onLoadSuccess:function(){creatToolbar();}
	});
	$('#instocklistdatagrid').datagrid('hideColumn','TFlag');
	$('#instocklistdatagrid').datagrid('hideColumn','TProvider');
	var TNo=$("#invoicelistdatagrid").datagrid('getColumnOption','TNo');
	TNo.formatter=	function(value,row,index){
			return InvoiceOperation(value,row,index)	
		}
	
	
	
	
}

///add by lmm 2019-09-19
///desc:�����ϸ�ϼƽ��
function creatToolbar()
{
	var Data = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice","GetInStockSumInfo",'');
	$("#sumTotal").html(Data);
	
}

///add by lmm 2019-09-19
///desc:ɾ����Ʊ����ȡ������
function DeleteGridData()
{
    var rows = $('#invoicelistdatagrid').datagrid('getRows');
    var CheckCount=0
	$.each(rows, function(rowIndex, rowData){
		if (rowData.TFlag=="Y")
		{
			CheckCount=CheckCount+1
			if (CheckCount==1)
			{
				FillData(rowData.TRowID)
			}			
		}
	});
	if (CheckCount==0)
	{
		messageShow("","","","����ѡ����Ҫɾ���ķ�Ʊ��!")
	    return;
	}
	if (CheckCount>1)
	{
		messageShow("","","","һ��ֻ��ɾ��һ����Ʊ!")
		return
	}
    var InvoiceDR=getElementValue("InvoiceDR")
    var InStockListStr=getElementValue("InStockListStr")
	var InInStr = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "GetInStockStrByInv",InvoiceDR,getElementValue("BussType"),InStockListStr);	// Mozy003005	1248969		2020-4-1
	
	if (InInStr!="")
	{
		messageShow("","","","�������������ϸ,����ɾ����["+InInStr+"]������Ʊ�ŵ���Ʊ��ϸ����ɾ����")
		return;		
	}
	else
	{
		var truthBeTold = window.confirm("��ȷ��Ҫɾ���÷�Ʊ��������ϸ��");
	    if (!truthBeTold) return;
	}
	
	var RtnList = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "CancelAllInvoiceMapBuss",InvoiceDR,"1");
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
		ClearInvoiceData()
		$("#invoicelistdatagrid").datagrid('reload');
		$("#instocklistdatagrid").datagrid('reload');
	}
	
}

function checkboxOnChange(TFlag,rowIndex)
{
	var row = jQuery('#invoicelistdatagrid').datagrid('getRows')[rowIndex];
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
			}
		})
	}
}

///add by lmm 2019-09-19
///desc:��ѡ��Ʊ�������ϸ�������
function RemoveGridData()
{
    var invoicestr="";
    var rows = $('#invoicelistdatagrid').datagrid('getRows');
    var CheckFlag=""
	$.each(rows, function(rowIndex, rowData){
		if (rowData.TFlag=="Y")
		{
			CheckFlag="Y"
			if (invoicestr=="")
			{ 
				invoicestr=rowData.TRowID;
			}
			 else invoicestr=invoicestr+","+rowData.TRowID;
		}
	});
	if (CheckFlag=="")
	{
		messageShow("","","","����ѡ����Ҫȡ���ķ�Ʊ��!")
	    return;
	} 
    var combindata="";
    var rows = $('#instocklistdatagrid').datagrid('getRows');
	$.each(rows, function(rowIndex, rowData){
		if (combindata=="")
		{ 
			combindata=rowData.TISLRowID;
		}
		 else combindata=combindata+","+rowData.TISLRowID; 
	}); 
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "CancelInvoiceMapBuss",invoicestr,combindata,getElementValue("BussType"));
	if (Rtn=='0')
	{
		$.messager.popover({msg: 'ȡ������!',type:'success',timeout: 1000});	
		ClearInvoiceData()	
		$("#invoicelistdatagrid").datagrid('reload');
		$("#instocklistdatagrid").datagrid('reload');
	}	else
	{
		$.messager.popover({msg: 'ȡ������ʧ��!',type:'error',timeout: 1000});		
		return;
	}
	
	
}

///add by lmm 2019-09-19
///desc:������Ʊ��Ϣ����¼�
function BAdd_Clicked()
{
	if (checkMustItemNull()) return;
	if (getElementValue("InvoiceDR")!="")
	{
		messageShow("","","","ѡ�з�Ʊ��Ϣ�޷�������")
		return;			
	}
	var InvoiceDR=""
	var InvoiceDR=SaveInvoiceData()
	if ((InvoiceDR<0)||(InvoiceDR==""))
	{
		messageShow("","","","����ʧ�ܣ�")
		return;	
	}

	AddGridData(InvoiceDR)
	$("#invoicelistdatagrid").datagrid('reload');  //add by mwz 20210415 MWZ0046 
	
}
///add by lmm 2019-09-19
///desc:�޸ķ�Ʊ��Ϣ����¼�
function BSave_Clicked()
{
	if (checkMustItemNull()) return;
	var InvoiceDR=""
	var InvoiceDR=UpdateInvoiceData()
	
    var InvoiceDR=getElementValue("InvoiceDR")
    var InStockListStr=getElementValue("InStockListStr")
	var InInStr = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "GetInStockStrByInv",InvoiceDR,getElementValue("BussType"),InStockListStr);	// Mozy003005	1248969		2020-4-1
	if (InInStr!="")
	{
		//messageShow("","","","�������������ϸ,����ɾ����["+InInStr+"]������Ʊ�ŵ���Ʊ��ϸ����ɾ����")
		//return;	
		
		//var truthBeTold = window.confirm("��ȷ��Ҫɾ���÷�Ʊ��������ϸ��");
	    //if (!truthBeTold) return;
        $.messager.confirm('��ȷ��', '�÷�Ʊ�ѹ������������ϸ['+InInStr+']�Ƿ�����޸ģ�', function (b) { 
        if (b==false)
        {
             return;
        }
        else
        {
			if ((InvoiceDR<0)||(InvoiceDR==""))
			{
				messageShow("","","","����ʧ�ܣ�")
				return;	
			}
			$("#invoicelistdatagrid").datagrid('reload');
			$("#instocklistdatagrid").datagrid('reload');
	        
	    }
        })			
	}
	else
	{
		if ((InvoiceDR<0)||(InvoiceDR==""))
		{
			messageShow("","","","����ʧ�ܣ�")
			return;	
		}
		$("#invoicelistdatagrid").datagrid('reload');
		$("#instocklistdatagrid").datagrid('reload');
		
	}

	
	
	
		

}
///add by lmm 2019-09-19
///desc:������Ʊ��Ϣ
function SaveInvoiceData()
{
	var val=""
	var val=InvoiceInfos("")  
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "SaveData",val);
	Rtn=Rtn.split("^");
	
	return 	Rtn[1]
	
}

///add by lmm 2019-09-19
///desc:�޸ķ�Ʊ��Ϣ
///modified by csj 2020-02-11 ��׼��-��ⲹ¼�����޸� 
function UpdateInvoiceData()
{
	var val=""
	var val=InvoiceInfos(getElementValue("InvoiceDR"))  
	var rows = $('#instocklistdatagrid').datagrid('getRows');
	var combindata=""
	$.each(rows, function(rowIndex, rowData){
	if (combindata=="")
		{ 
			combindata=rowData.TISLRowID;
		}
		 else combindata=combindata+","+rowData.TISLRowID; 
	}); 
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "SaveData",val,combindata,BussType);
	Rtn=Rtn.split("^");
	
	return 	Rtn[1]
	
}

///add by lmm 2019-09-19
///desc:��Ʊ��Ϣ��
function InvoiceInfos(InvoiceDR)
{
	var val=""
	var val=InvoiceDR
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
	var val=val+"^"+getElementValue("RequestLocDR")    //modify by lmm 2019-09-19 Hold1���ù����������
	var val=val+"^"+getElementValue("Hold2")    
	var val=val+"^"+getElementValue("Hold3")    
	var val=val+"^"+getElementValue("Hold4")    
	var val=val+"^"+getElementValue("Hold5") 
	return val
	
}

///add by lmm 2019-09-19
///desc:������Ʊ������
function AddGridData(InvoiceDR)
{
	//var InvoiceDR=getElementValue("InvoiceDR")
	if (InvoiceDR=="") 
	{
		messageShow("","","","δѡ�з�Ʊ��")
		return;
		
	}
    var combindata="";
    var rows = $('#instocklistdatagrid').datagrid('getRows');
	$.each(rows, function(rowIndex, rowData){
		if (combindata=="")
		{ 
			combindata=rowData.TISLRowID;
		}
		 else combindata=combindata+","+rowData.TISLRowID; 
	}); 
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "InvoiceMapBuss",InvoiceDR,combindata,BussType);//modified by csj 2020-02-11 ��׼��-��ⲹ¼�����޸� 
	if (Rtn=='0')
	{
		//websys_showModal("options").mth();  //modify by lmm 2019-02-19
		ClearInvoiceData()
		$.messager.popover({msg: 'ȷ�Ϲ�����',type:'success',timeout: 1000});		
		$("#invoicelistdatagrid").datagrid('reload');
		$("#instocklistdatagrid").datagrid('reload');
		return;
		//$.messager.alert('ȷ�Ϲ�����',data, 'warning')
	}
	else
	{
		$.messager.popover({msg: '����ʧ�ܣ�',type:'error',timeout: 1000});		
		return;
	}
}


///add by lmm 2019-09-19
///desc:��Ʊ����Ʊ����ɾ��
function BDelete_Clicked()
{	
	
	var truthBeTold = window.confirm("��ȷ��Ҫɾ��������¼��");
    if (!truthBeTold) return;
    var InvoiceDR=getElementValue("InvoiceDR")
	var Flag = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "CheckInvoiceUseMap",InvoiceDR);
	if (Flag=="1")
	{
		messageShow("","","","�÷�Ʊ������ⵥ�󶨣�")
		return;
		//var truthBeTold = window.confirm("�÷�Ʊ������ⵥ�󶨣�");
	    //if (!truthBeTold) return;
		
	}
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "DeleteInvoice",InvoiceDR);
	Rtn=Rtn.split("^");
	if (Rtn<0)
	{
		$.messager.popover({msg: '��Ʊɾ��ʧ�ܣ�',type:'error',timeout: 1000});		
	}
	else
	{
		ClearInvoiceData()
		$.messager.popover({msg: '��Ʊɾ����',type:'success',timeout: 1000});		
		$("#invoicelistdatagrid").datagrid('reload');
		$("#instocklistdatagrid").datagrid('reload');
	}
}

///add by lmm 2019-09-19
///desc:��Ʊ�������
function FillData(InvoiceID)
{
	//var InvoiceID=getElementValue("RowID")
	if (InvoiceID=="") return
	setElement("InvoiceDR",InvoiceID)
	var list = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "GetOneInvoice",InvoiceID);	
	list=list.replace(/\ +/g,"")	//ȥ���ո�
	list=list.replace(/[\r\n]/g,"")	//ȥ���س�����
	list=list.split("^");
	setElement("InvoiceCode",list[0])	
	setElement("InvoiceNo",list[1])	
	setElement("Date",list[22])	
	setElement("AmountFee",list[3])	
	setElement("ProviderDR",list[4])	
	setElement("TypeDR",list[5])	
	setElement("Customer",list[6])	
	setElement("InvoiceDept",list[7])	
	setElement("PayedAmountFee",list[8])	
	setElement("Remark",list[13])	
	setElement("CertificateDR",list[14])	
	//setElement("RequestLocDR",list[16])	//modify by lmm 2019-09-19 Hold1��Ϊ�����������  //modify by LMH 20220725 BUG LMH0005  Hold1��Ϊ��Ʊ����
	//setElement("RequestLoc",list[23])	//modify by lmm 2019-09-19 Hold1��Ϊ�����������  //modify by LMH 20220725 BUG LMH0005      Hold1��Ϊ��Ʊ����
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
///desc:����¼�
function ClearInvoiceData()
{
	
	setElement("InvoiceDR","")	
	setElement("InvoiceCode","")	
	setElement("InvoiceNo","")	
	setElement("Date","")	
	setElement("AmountFee","")	
	//setElement("ProviderDR","")	
	//setElement("Provider","")	
	setElement("TypeDR","")	
	setElement("Customer","")	
	setElement("InvoiceDept","")	
	setElement("PayedAmountFee","")	
	setElement("Remark","")	
	setElement("CertificateDR","")	
	setElement("Certificate","")	
	setElement("Hold1","")	
	setElement("Hold2","")	
	setElement("Hold3","")	
	setElement("Hold4","")	
	setElement("Hold5","")
	setElement("RequestLoc","")	//modify by lmm 2019-09-19 Hold1��Ϊ�������
	setElement("RequestLocDR","")	//modify by lmm 2019-09-19 Hold1��Ϊ�������
	
}

///add by lmm 2019-09-19
///desc:
function MapGridData()
{
	var url="dhceq.plat.invoicefind.csp?&ShowType=on&InStockListStr="+getElementValue("InStockListStr")+"&ProviderDR="+getElementValue("ProviderDR")+"&RequestLocDR="+getElementValue("RequestLocDRNew")+"&BussType="+getElementValue("BussType");	// Mozy003005	1248930		2020-4-1
	var title="��Ʊ��Ϣ"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","","large",ReloadGridData)
	
}

///add by lmm 2019-09-19
///desc:�����б�
function ReloadGridData()
{

	$("#invoicelistdatagrid").datagrid('reload');
	$("#instocklistdatagrid").datagrid('reload');
	
}

///add by lmm 2019-09-19
///desc:��Ʊ��������
function InvoiceOperation(value,row,index)
{
	var url="dhceq.plat.invoicebindinstocklist.csp?"+"&InvoiceMapType=invoice&RowID="+row.TRowID+"&BussType="+BussType+"&InvoiceNo="+value;	//Mozy003005	1248904		2020-4-1
	var title="��Ʊ��Ϣ"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	var type=""
	nfun="ReloadGridData"
		
	btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;'+type+'&quot;,&quot;&quot;,&quot;&quot;,&quot;large&quot;,'+nfun+')" href="#">'+row.TNo+'</A>';
	return btn;
	
}

