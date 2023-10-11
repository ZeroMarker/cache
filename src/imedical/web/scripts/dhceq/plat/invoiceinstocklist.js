var invoicecolumns=getCurColumnsInfo('PLAT.G.InStock.Invoice','','','');  
var columns=getCurColumnsInfo('PLAT.G.InStock.InvoiceInStockList','','',''); 
var BussType=getElementValue("BussType")	//add by csj 2020-02-11 标准版-入库补录程序修改 
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
	idField:'TRowID', //主键   //add by lmm 2018-10-23
    border : false,
	striped : true,
    cache: false,
    fit:true,
    title:'发票明细列表',
    headerCls:'panel-header-gray',
    singleSelect:false,
	toolbar:[
		{
    		id:"Remove",
			iconCls:'icon-remove', 
			text:'取消关联',
			handler:function(){RemoveGridData();}
		} ,
		{
    		id:"Delete",
			iconCls:'icon-cancel', 
			text:'发票删除',
			handler:function(){DeleteGridData();}
		},
		{
    		id:"Insert",
			iconCls:'icon-add', 
			text:'关联已有发票',
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
    BussType:BussType,//add by csj 2020-02-11 标准版-入库补录程序修改 
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
	//add by csj 2020-02-11 标准版-入库补录程序修改 
	var GetInStockListQueryName="GetInStockDetail"
	if(BussType==3) 
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
    title:'关联入库明细',
    headerCls:'panel-header-gray',
    singleSelect:false,
    queryParams:{
        ClassName:"web.DHCEQ.Plat.BUSInvoice",
        QueryName:GetInStockListQueryName,	//modified by csj 2020-02-11 标准版-入库补录程序修改 
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
///desc:入库明细合计金额
function creatToolbar()
{
	var Data = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice","GetInStockSumInfo",'');
	$("#sumTotal").html(Data);
	
}

///add by lmm 2019-09-19
///desc:删除发票及并取消关联
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
		messageShow("","","","请先选择需要删除的发票号!")
	    return;
	}
	if (CheckCount>1)
	{
		messageShow("","","","一次只能删除一个发票!")
		return
	}
    var InvoiceDR=getElementValue("InvoiceDR")
    var InStockListStr=getElementValue("InStockListStr")
	var InInStr = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "GetInStockStrByInv",InvoiceDR,getElementValue("BussType"),InStockListStr);	// Mozy003005	1248969		2020-4-1
	
	if (InInStr!="")
	{
		messageShow("","","","关联其他入库明细,不能删除！["+InInStr+"]请点击发票号到发票详细界面删除！")
		return;		
	}
	else
	{
		var truthBeTold = window.confirm("您确定要删除该发票及关联明细吗");
	    if (!truthBeTold) return;
	}
	
	var RtnList = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "CancelAllInvoiceMapBuss",InvoiceDR,"1");
	if (RtnList<0)
	{
		messageShow("","","","关联明细删除失败！")
		return;		
	}
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "DeleteInvoice",InvoiceDR);
	Rtn=Rtn.split("^");
	if (Rtn<0) 
	{
		messageShow("","","","删除失败！")
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
///desc:勾选发票与入库明细解除关联
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
		messageShow("","","","请先选择需要取消的发票号!")
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
		$.messager.popover({msg: '取消关联!',type:'success',timeout: 1000});	
		ClearInvoiceData()	
		$("#invoicelistdatagrid").datagrid('reload');
		$("#instocklistdatagrid").datagrid('reload');
	}	else
	{
		$.messager.popover({msg: '取消关联失败!',type:'error',timeout: 1000});		
		return;
	}
	
	
}

///add by lmm 2019-09-19
///desc:新增发票信息点击事件
function BAdd_Clicked()
{
	if (checkMustItemNull()) return;
	if (getElementValue("InvoiceDR")!="")
	{
		messageShow("","","","选中发票信息无法新增！")
		return;			
	}
	var InvoiceDR=""
	var InvoiceDR=SaveInvoiceData()
	if ((InvoiceDR<0)||(InvoiceDR==""))
	{
		messageShow("","","","保存失败！")
		return;	
	}

	AddGridData(InvoiceDR)
	$("#invoicelistdatagrid").datagrid('reload');  //add by mwz 20210415 MWZ0046 
	
}
///add by lmm 2019-09-19
///desc:修改发票信息点击事件
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
		//messageShow("","","","关联其他入库明细,不能删除！["+InInStr+"]请点击发票号到发票详细界面删除！")
		//return;	
		
		//var truthBeTold = window.confirm("您确定要删除该发票及关联明细吗");
	    //if (!truthBeTold) return;
        $.messager.confirm('请确认', '该发票已关联其他入库明细['+InInStr+']是否继续修改？', function (b) { 
        if (b==false)
        {
             return;
        }
        else
        {
			if ((InvoiceDR<0)||(InvoiceDR==""))
			{
				messageShow("","","","保存失败！")
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
			messageShow("","","","保存失败！")
			return;	
		}
		$("#invoicelistdatagrid").datagrid('reload');
		$("#instocklistdatagrid").datagrid('reload');
		
	}

	
	
	
		

}
///add by lmm 2019-09-19
///desc:新增发票信息
function SaveInvoiceData()
{
	var val=""
	var val=InvoiceInfos("")  
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "SaveData",val);
	Rtn=Rtn.split("^");
	
	return 	Rtn[1]
	
}

///add by lmm 2019-09-19
///desc:修改发票信息
///modified by csj 2020-02-11 标准版-入库补录程序修改 
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
///desc:发票信息串
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
	var val=val+"^"+getElementValue("RequestLocDR")    //modify by lmm 2019-09-19 Hold1改用管理科室类型
	var val=val+"^"+getElementValue("Hold2")    
	var val=val+"^"+getElementValue("Hold3")    
	var val=val+"^"+getElementValue("Hold4")    
	var val=val+"^"+getElementValue("Hold5") 
	return val
	
}

///add by lmm 2019-09-19
///desc:新增发票及关联
function AddGridData(InvoiceDR)
{
	//var InvoiceDR=getElementValue("InvoiceDR")
	if (InvoiceDR=="") 
	{
		messageShow("","","","未选中发票！")
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
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "InvoiceMapBuss",InvoiceDR,combindata,BussType);//modified by csj 2020-02-11 标准版-入库补录程序修改 
	if (Rtn=='0')
	{
		//websys_showModal("options").mth();  //modify by lmm 2019-02-19
		ClearInvoiceData()
		$.messager.popover({msg: '确认关联！',type:'success',timeout: 1000});		
		$("#invoicelistdatagrid").datagrid('reload');
		$("#instocklistdatagrid").datagrid('reload');
		return;
		//$.messager.alert('确认关联！',data, 'warning')
	}
	else
	{
		$.messager.popover({msg: '关联失败！',type:'error',timeout: 1000});		
		return;
	}
}


///add by lmm 2019-09-19
///desc:发票及发票关联删除
function BDelete_Clicked()
{	
	
	var truthBeTold = window.confirm("您确定要删除该条记录吗");
    if (!truthBeTold) return;
    var InvoiceDR=getElementValue("InvoiceDR")
	var Flag = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "CheckInvoiceUseMap",InvoiceDR);
	if (Flag=="1")
	{
		messageShow("","","","该发票已与入库单绑定！")
		return;
		//var truthBeTold = window.confirm("该发票已与入库单绑定！");
	    //if (!truthBeTold) return;
		
	}
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "DeleteInvoice",InvoiceDR);
	Rtn=Rtn.split("^");
	if (Rtn<0)
	{
		$.messager.popover({msg: '发票删除失败！',type:'error',timeout: 1000});		
	}
	else
	{
		ClearInvoiceData()
		$.messager.popover({msg: '发票删除！',type:'success',timeout: 1000});		
		$("#invoicelistdatagrid").datagrid('reload');
		$("#instocklistdatagrid").datagrid('reload');
	}
}

///add by lmm 2019-09-19
///desc:发票数据填充
function FillData(InvoiceID)
{
	//var InvoiceID=getElementValue("RowID")
	if (InvoiceID=="") return
	setElement("InvoiceDR",InvoiceID)
	var list = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "GetOneInvoice",InvoiceID);	
	list=list.replace(/\ +/g,"")	//去掉空格
	list=list.replace(/[\r\n]/g,"")	//去掉回车换行
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
	//setElement("RequestLocDR",list[16])	//modify by lmm 2019-09-19 Hold1改为管理科室类型  //modify by LMH 20220725 BUG LMH0005  Hold1改为发票数量
	//setElement("RequestLoc",list[23])	//modify by lmm 2019-09-19 Hold1改为管理科室类型  //modify by LMH 20220725 BUG LMH0005      Hold1改为发票数量
	setElement("Hold2",list[17])	
	setElement("Hold3",list[18])	
	setElement("Hold4",list[19])	
	setElement("Hold5",list[20])	
	
	setElement("Provider",list[21])	
	
	
	
		
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
///desc:清空事件
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
	setElement("RequestLoc","")	//modify by lmm 2019-09-19 Hold1改为管理科室
	setElement("RequestLocDR","")	//modify by lmm 2019-09-19 Hold1改为管理科室
	
}

///add by lmm 2019-09-19
///desc:
function MapGridData()
{
	var url="dhceq.plat.invoicefind.csp?&ShowType=on&InStockListStr="+getElementValue("InStockListStr")+"&ProviderDR="+getElementValue("ProviderDR")+"&RequestLocDR="+getElementValue("RequestLocDRNew")+"&BussType="+getElementValue("BussType");	// Mozy003005	1248930		2020-4-1
	var title="发票信息"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","","large",ReloadGridData)
	
}

///add by lmm 2019-09-19
///desc:重载列表
function ReloadGridData()
{

	$("#invoicelistdatagrid").datagrid('reload');
	$("#instocklistdatagrid").datagrid('reload');
	
}

///add by lmm 2019-09-19
///desc:发票弹窗界面
function InvoiceOperation(value,row,index)
{
	var url="dhceq.plat.invoicebindinstocklist.csp?"+"&InvoiceMapType=invoice&RowID="+row.TRowID+"&BussType="+BussType+"&InvoiceNo="+value;	//Mozy003005	1248904		2020-4-1
	var title="发票信息"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	var type=""
	nfun="ReloadGridData"
		
	btn='<A onclick="showWindow(&quot;'+url+'&quot;,&quot;'+title+'&quot;,&quot;&quot;,&quot;&quot;,&quot;'+icon+'&quot;,&quot;'+type+'&quot;,&quot;&quot;,&quot;&quot;,&quot;large&quot;,'+nfun+')" href="#">'+row.TNo+'</A>';
	return btn;
	
}

