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
		idField:'TISLRowID', //主键   //add by lmm 2018-10-23
	    border : false,
	    title:'关联入库明细',
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
	$('#instocklistdatagrid').datagrid('hideColumn','TProvider');
			  
					    
}

///add by lmm 2019-07-01
///desc:入库明细合计金额
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
	var Data="总数量:"+Count+"&nbsp;&nbsp;&nbsp;总金额:"+TotalFee+"元"  
	$("#sumTotal").html(Data);
}

///add by lmm 2019-07-01
///desc:发票及已关联明细删除
function BDelete_Clicked()
{
	
    var InvoiceDR=getElementValue("RowID")
	var Flag = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "CheckInvoiceUseMap",InvoiceDR);
	if (Flag=="1")
	{
		var truthBeTold = window.confirm("发票已关联明细，已关联明细是否删除？");
	    if (!truthBeTold) return;
		
	}
	else
	{
		var truthBeTold = window.confirm("您确定要删除该条记录吗");
	    if (!truthBeTold) return;
	}
	var RtnList = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "CancelAllInvoiceMapBuss",InvoiceDR,getElementValue("BussType"));	// Mozy003005	1248904		2020-4-1
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
		websys_showModal("options").mth();  //modify by lmm 2019-02-19
	    window.location.href= "dhceq.plat.invoicebindinstocklist.csp?&RowID="+"&BussType="+getElementValue("BussType");	// Mozy003005	1248904		2020-4-1
	}
	
}

///add by lmm 2019-07-22
///描述：清空当前页面
function BClear_Clicked()
{
    window.location.href= "dhceq.plat.invoicebindinstocklist.csp?&RowID="+"&BussType="+getElementValue("BussType");	// Mozy003005	1248904		2020-4-1
	
}

///add by lmm 2019-07-22
///描述：解除发票与入库明细关联
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
		$.messager.popover({msg: '取消关联!',type:'success',timeout: 1000});	
		websys_showModal("options").mth();  //modify by lmm 2019-02-19
		$("#instocklistdatagrid").datagrid('reload');
	}	else
	{
		$.messager.popover({msg: '取消失败！',type:'error',timeout: 1000});		
		return;
	}
		
	
}


///add by lmm 2019-07-01
///描述：弹出新增绑定界面
function AddGridData()
{
	var url="dhceq.plat.instocklist.csp?"+"&MapType=1&HasInvoiceType=2"+"&ShowType=on"+"&InvoiceDR="+getElementValue("RowID")+"&ProviderDR="+getElementValue("ProviderDR")+"&MenuName=Invoice"+"&BussType="+getElementValue("BussType");	// Mozy003005	1248904		2020-4-1
	var title="入库明细列表"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(url,title,width,height,icon,showtype,"","","large",ReloadGrid)

	
}

///add by lmm 2019-09-12
///描述：保存发票信息点击事件
function BSave_Clicked()
{
	if (checkMustItemNull()) return;
	var InvoiceDR=getElementValue("RowID")
	var rows = $('#instocklistdatagrid').datagrid('getRows');
	if ((InvoiceDR!="")&&(rows!="")&&(GlobalObj.InvoiceNo!=getElementValue("InvoiceNo")))
	{
		var truthBeTold = window.confirm("已关联明细,是否修改发票号？");
	    if (!truthBeTold) return;
		
	}
	if ((InvoiceDR!="")&&(rows!="")&&(GlobalObj.ProviderDR!=getElementValue("ProviderDR")))
	{
		var truthBeTold = window.confirm("供应商修改需与关联明细取消关联");
	    if (!truthBeTold) return;
		var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "CancelAllInvoiceMapBuss",InvoiceDR,getElementValue("BussType"));	// Mozy003005	1248904		2020-4-1
		if (Rtn=='0')
		{
			$.messager.popover({msg: '取消关联!',type:'success',timeout: 1000});
			websys_showModal("options").mth();
			$("#instocklistdatagrid").datagrid('reload');
		}	else
		{
			$.messager.popover({msg: '取消失败!',type:'error',timeout: 1000});		
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
		$.messager.popover({msg: '保存失败！',type:'error',timeout: 1000});		
		return;	
	}
	
    window.location.href= "dhceq.plat.invoicebindinstocklist.csp?&RowID="+Rtn[1]+"&BussType="+getElementValue("BussType");	// Mozy003005	1248904		2020-4-1
		
	
}

///add by lmm 2019-09-12
///描述：保存发票信息点击事件
function BAdd_Clicked()
{
	var val=""
	var val=getElementValue("RowID")
	var val=val+InvoiceData()  
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "SaveData",val);
	Rtn=Rtn.split("^");
	if (Rtn<0) 
	{
		$.messager.popover({msg: '保存失败！',type:'error',timeout: 1000});		
		return;	
	}
	
    window.location.href= "dhceq.plat.invoicebindinstocklist.csp?&RowID="+Rtn[1]+"&BussType="+getElementValue("BussType");	// Mozy003005	1248904		2020-4-1
		
	
}
///add by lmm 2019-09-12
///描述：发票信息拼串
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
	var val=val+"^"+getElementValue("RequestLocDR")   //modify by lmm 2019-09-19 Hold1 占用管理科室
	var val=val+"^"+getElementValue("Hold2")    
	var val=val+"^"+getElementValue("Hold3")    
	var val=val+"^"+getElementValue("Hold4")    
	var val=val+"^"+getElementValue("Hold5")   
	return val	
	
}

///add by lmm 2019-09-19
///desc:发票数据填充
function FillData()
{
	var InvoiceID=getElementValue("RowID")
	if (InvoiceID=="") return
	var list = tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "GetOneInvoice",InvoiceID);	
	list=list.replace(/\ +/g,"")	//去掉空格
	list=list.replace(/[\r\n]/g,"")	//去掉回车换行
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
	//modify by lmm 2019-09-19 Hold1 占用管理科室类型 	
	setElement("RequestLoc",list[23])
	setElement("RequestLocDR",list[16])
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
///desc:重载列表
function ReloadGrid()
{
	$("#instocklistdatagrid").datagrid('reload');
	
}
