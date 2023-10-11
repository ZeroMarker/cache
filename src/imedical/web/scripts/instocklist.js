var columns=getCurColumnsInfo('PLAT.G.InStock.InvoiceInStockList','','','');  

$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	initUserInfo();  ///Modefied by ZC0081 2020-09-07 初始化用户信息
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
				},  ///Modefied by ZC0081 2020-09-07 添加打印按钮  begin
				{
		    		id:"Print",
					iconCls:'icon-print', 
					text:'打印',
					handler:function(){BPrint_Clicked();}
				}   ///Modefied by ZC0081 2020-09-07 添加打印按钮  end
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
        Params:getElementValue("Status")+"^"+getElementValue("StartAuditDate")+"^"+getElementValue("EndAuditDate")+"^"+getElementValue("Job")  //Modify by zx 2020-12-11 BUG ZX0121
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
	//Modify by zx 2020-12-11 BUG ZX0121 增加导出处理
	$('#BExport').on("click", BExport_Clicked);	
	///modify by mwz 20220117 mwz0057
	$('#BColSet').on("click", BColSet_Click);		    
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
        Params:getElementValue("Status")+"^"+getElementValue("StartAuditDate")+"^"+getElementValue("EndAuditDate")+"^"+getElementValue("Job")  //Modify by zx 2020-12-11 BUG ZX0121
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
	
	$('#instocklistdatagrid').datagrid("unselectAll");  //add by lmm 2021-02-02 1749740
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
		messageShow("","","","选中入库明细供应商不一致！");
		return;
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

///Modefied by CSJ 2020-11-11 添加润乾打印
function BPrint_Clicked()
{
	//Modify by zx 2020-12-11
	//var curDate=GetCurrentDate();
	var InvoiceNos=getElementValue("InvoiceNos")
	if (InvoiceNos=="")
	{
		messageShow("","","","未输入发票号查询！");
		return;
	}
	var TotalRows=tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "GetTempDataRows",'InStockDetailPrint',curUserID);	
	if (TotalRows=="")
	{
		messageShow("","","","没有数据不能打印！")
		return;
	}
	var PrintFlag=getElementValue("PrintFlag");
	if(PrintFlag==0)
	{
		//Modify by zx 2020-12-11 BUG ZX0121 打印和导出合并处理
		/*
		var	TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP", "GetPath",'','');	// Mozy003007	1260544	
		try {
	    	var xlApp,xlsheet,xlBook;
			var Template=TemplatePath+"DHCEQInvoice.xls";
			xlApp = new ActiveXObject("Excel.Application");
		    xlBook = xlApp.Workbooks.Add(Template);
		    xlsheet = xlBook.ActiveSheet;
		    xlsheet.cells.replace("[Hospital]",curHospitalName)
		    var delRow=3;
		    var sum=0
		    var sumFee=0
		    for (var j=1;j<=TotalRows;j++)
			{
			    	var OneDetail=tkMakeServerCall("web.DHCEQ.Plat.BUSInvoice", "GetTempData",'InStockDetailPrint',curUserID,j);
			    	var OneDetailList=OneDetail.split("^");
			    	///TISRowID_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLoc_"^"_TStatCat_"^"_TEquipType_"^"_TISLRowID_"^"_TEquipName_"^"_TModel_"^"_TUnit_"^"_TQuantityNum_"^"_TOriginalFee_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TInvoice
					/// 0				1			2			3		4			5			6				7				8			9			10			11					12				13			14				15			16
					xlsheet.Rows(j+2).Insert();
					xlsheet.cells(j+2,1)=OneDetailList[3];//入库单号
					xlsheet.cells(j+2,2)=OneDetailList[16];//发票号
					xlsheet.cells(j+2,3)=OneDetailList[8];//设备名称
					xlsheet.cells(j+2,4)=OneDetailList[9];//机型
					xlsheet.cells(j+2,5)=OneDetailList[1];//供应商
					xlsheet.cells(j+2,6)=OneDetailList[2];//入库日期
					xlsheet.cells(j+2,7)=OneDetailList[12];//原值
					xlsheet.cells(j+2,8)=OneDetailList[11];//数量
					xlsheet.cells(j+2,9)=OneDetailList[13];//总金额
					sum=sum+parseInt(OneDetailList[11])
					sumFee=sumFee+parseFloat(OneDetailList[13])
					var delRow=j+3;
			}
			xlsheet.cells(delRow,3)="合计";//设备名称
			xlsheet.cells(delRow,8)=sum;//设备名称
			xlsheet.cells(delRow,9)=sumFee;//设备名称
			//xlsheet.Rows(delRow).Delete();
			xlsheet.cells(delRow+1,1)="打印日期:"
			xlsheet.cells(delRow+1,2)=FormatDate(curDate);
			xlsheet.cells(delRow+1,5)="制单人:"
			xlsheet.cells(delRow+1,6)=curUserName;
		   	xlsheet.printout; 	//打印输出
		
		    xlBook.Close (savechanges=false);
		    	
		    xlsheet.Quit;
		    xlsheet=null;
		  	 	
		 	xlApp=null;
		} 
		catch(e)
		{
			alertShow(e.message);
		}
		*/
		BExcel_Operate("1");
	}
	if(PrintFlag==1)
	{
		var PreviewRptFlag=getElementValue("PreviewRptFlag");
		var fileName=""	;
        if(PreviewRptFlag==0)
        {
        fileName="{DHCEQInvoice.raq(CurUser="+curUserID+";USERNAME="+curUserName+";HOSPDESC="+curSSHospitalName+")}";
        DHCCPM_RQDirectPrint(fileName);
        }
        if(PreviewRptFlag==1)
        { 
        fileName="DHCEQInvoice.raq&CurUser="+curUserID+"&USERNAME="+curUserName+"&HOSPDESC="+curSSHospitalName;
        DHCCPM_RQPrint(fileName);
        }												
	}
  

}

//Add by zx 2020-12-11
//发票审核界面导出
//modify by mwz 20220116 mwz0057 
function BExport_Clicked()
{
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",'990062');
	if (PrintFlag=="1")
	{
		//add by mwz 20230104 mwz0066 begin
		var Rows = $('#instocklistdatagrid').datagrid('getRows');
		var RowCount=Rows.length;
		if(RowCount<=0){
			messageShow("","","","没有数据!")
			return;
		}
		//add by mwz 20230104 mwz0066 end
		// MZY0113	2435347		2022-01-25
		if (!CheckColset("EQInStockDetailInvoice"))
		{
			messageShow('popover','alert','提示',"导出数据列未设置!")
			return ;
		}
		var url="dhccpmrunqianreport.csp?reportName=DHCEQInStockDetailInvoiceExport.raq&CurTableName=EQInStockDetailInvoice&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+getElementValue("Job")
    	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
    	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');   //
	}
	else
	{
		if (getElementValue("ChromeFlag")=="1")
		{
			BSaveExcel_Chrome();
		}
		else
		{
			BSaveExcel_IE();
		}
	}
}

//Add by zx 2020-12-11
//Chrome浏览器导出处理
function BSaveExcel_Chrome()
{
	var Node="InStockDetailInvoice";
	var Job=getElementValue("Job");
	var TotalRows=tkMakeServerCall("web.DHCEQCommon","GetTempDataRows",Node,Job);	
	var PageRows=TotalRows; //每页固定行数
	var Pages=parseInt(TotalRows / PageRows) //总页数-1  
	var ModRows=TotalRows%PageRows //最后一页行数
	if (ModRows==0) Pages=Pages-1
    var TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP", "GetPath",'','');
    var Template=TemplatePath+"DHCEQInvoice.xls";
	//var Template="http://114.242.246.243:18080/imedical/med/Results/Template/DHCEQInvoice.xls"
	var AllListInfo=new Array();
	for (var i=0;i<=Pages;i++)
	{
    	var OnePageRow=PageRows;
    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
    	for (var k=1;k<=OnePageRow;k++)
    	{
	    	var l=i*PageRows+k
	    	var OneDetail=tkMakeServerCall("web.DHCEQCommon", "GetTempData",Node,Job,l);
	    	var OneDetail =OneDetail.replace(",","，");
	    	var OneDetailList=OneDetail.split("^");
	    	AllListInfo.push(OneDetail)
    	}
	}
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var NewFileName=filepath(FileName,"\\","\\\\")
	var NewFileName=NewFileName.substr(0,NewFileName.length-4)
	
	//Chorme浏览器兼容性处理
	var Str ="(function test(x){"
	Str +="var xlApp,xlsheet,xlBook;"
	Str +="xlApp = new ActiveXObject('Excel.Application');"
	Str +="for (var i=0;i<="+Pages+";i++){"
	Str +="xlBook = xlApp.Workbooks.Add('"+Template+"');"
	Str +="xlsheet = xlBook.ActiveSheet;"
	Str +="xlsheet.PageSetup.TopMargin=0;"
	Str +="var OnePageRow="+PageRows+";"
	Str +="if ((i=="+Pages+")&&("+ModRows+"!=0)) OnePageRow="+ModRows+";"
	Str +="xlsheet.cells.replace('[Hospital]','"+curSSHospitalName+"');" //modify by mwz 20210415 MWZ0046 
	Str +="for (var k=1;k<=OnePageRow;k++){"
	Str +="var l=i*"+PageRows+"+k;"
	Str +="var AllListInfoStr='"+AllListInfo+"';"
	Str +="var AllListInfo=AllListInfoStr.split(',');"
	Str +="var OneDetailList=AllListInfo[l-1].split('^');"
	Str +="var j=k+2;"   //modfiy by lmm 2020-21-2-2 1749527
	Str +="xlsheet.Rows(j).Insert();"
	Str +="var col=1;"
	Str +="xlsheet.cells(j,col++)=OneDetailList[3];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[16];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[8];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[9];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[1];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[2];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[12];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[11];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[13];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[6];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[18];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[19];"
	Str +="xlsheet.cells(j,col++)=OneDetailList[17];}"
	Str +="xlsheet.Rows(j+1).Delete();"
	Str +="var printpage='';"
	Str +="if (i>0) {printpage='_'+i;}"  
	Str +="xlsheet.cells(j+1,1)='打印日期:';" //modify by mwz 20210515 MWZ0046 begin
	Str +="xlsheet.cells(j+1,2)=FormatDate(GetCurrentDate());"      
	Str +="xlsheet.cells(j+1,11)='制单人:';" 
	Str +="xlsheet.cells(j+1,12)='"+curUserName+"';" //modify by mwz 20210515 MWZ0049  end
	Str +="var savefile='"+NewFileName+"'+printpage+'.xls';"
	Str +="xlBook.SaveAs(savefile);"
	Str +="xlBook.Close (savechanges=false);"
	Str +="xlsheet.Quit;"
	Str +="xlsheet=null;}"
	Str +="xlApp=null;"
	Str +="return 1;}());";
	//以上为拼接Excel打印代码为字符串
	CmdShell.notReturn = 0;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序
    alertShow("导出完成!");
}

//Add by zx 2020-12-11
//IE浏览器导出处理
function BSaveExcel_IE()
{
	BExcel_Operate("0");
}

//Add by zx 2020-12-11 
//excel导出或打印
function BExcel_Operate(printFlag)
{
	var Node="InStockDetailInvoice";
	var Job=getElementValue("Job");
	var TotalRows=tkMakeServerCall("web.DHCEQCommon","GetTempDataRows",Node,Job);	
	var PageRows=TotalRows; //每页固定行数
	var Pages=parseInt(TotalRows / PageRows) //总页数-1  
	var ModRows=TotalRows%PageRows //最后一页行数
	if (ModRows==0) Pages=Pages-1
	
	try
	{
        var xlApp,xlsheet,xlBook;
		var TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP", "GetPath",'','');
	    var Template=TemplatePath+"DHCEQInvoice.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=PageRows;
	    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
			var sum=0
			var sumFee=0
			var delRow=0;
		    xlsheet.cells.replace("[Hospital]",curHospitalName)
	    	for (var j=1;j<=OnePageRow;j++)
	    	{
		    	var l=i*PageRows+j
		    	var OneDetail=tkMakeServerCall("web.DHCEQCommon", "GetTempData",Node,Job,l);
		    	var OneDetailList=OneDetail.split("^");
		    	
			    xlsheet.Rows(j+2).Insert();
				xlsheet.cells(j+2,1)=OneDetailList[3];//入库单号
				xlsheet.cells(j+2,2)=OneDetailList[16];//发票号
				xlsheet.cells(j+2,3)=OneDetailList[8];//设备名称
				xlsheet.cells(j+2,4)=OneDetailList[9];//机型
				xlsheet.cells(j+2,5)=OneDetailList[1];//供应商
				xlsheet.cells(j+2,6)=OneDetailList[2];//入库日期
				xlsheet.cells(j+2,7)=OneDetailList[12];//原值
				xlsheet.cells(j+2,8)=OneDetailList[11];//数量
				xlsheet.cells(j+2,9)=OneDetailList[13];//总金额
				xlsheet.cells(j+2,10)=OneDetailList[6];//管理类组
				xlsheet.cells(j+2,11)=OneDetailList[18];//采购部门
				xlsheet.cells(j+2,12)=OneDetailList[19];//来源
				xlsheet.cells(j+2,13)=OneDetailList[17];//备注
				sum=sum+parseInt(OneDetailList[11]);
				sumFee=sumFee+parseFloat(OneDetailList[13]);
				delRow=j+3;
			}
	    	
		   	if(printFlag=="1")
		   	{
			   	xlsheet.cells(delRow,3)="合计";//设备名称
				xlsheet.cells(delRow,8)=sum;//合计数量
				xlsheet.cells(delRow,9)=sumFee;//合计金额
				//xlsheet.Rows(OnePageRow+3).Delete();
				xlsheet.cells(delRow+1,1)="打印日期:"
				xlsheet.cells(delRow+1,2)=FormatDate(GetCurrentDate());
				xlsheet.cells(delRow+1,11)="制单人:"
				xlsheet.cells(delRow+1,12)=curUserName;
			   	xlsheet.printout; 	//打印输出
			}else{
				var savepath=GetFileName();
				xlBook.SaveAs(savepath);
		    	xlBook.Close (savechanges=false);
			}
	       	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	    alertShow("导出完成!");
	} 
	catch(e)
	{
		messageShow("","","",e.message);
	}
}
//add by mwz 20220117 mwz0057
//导出数据列设置
function BColSet_Click() 
{
	var para="&TableName=EQInStockDetailInvoice&SetType=0&SetID=0"
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCColSet"+para;
	showWindow(url,"导出列设置","","","icon-w-paper","","","","large");   //modify by mwz 20220418 mwz0060 
}
