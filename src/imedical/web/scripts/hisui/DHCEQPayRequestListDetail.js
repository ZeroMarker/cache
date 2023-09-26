/// DHCEQPayRequestListDetail.js
function BodyLoadHandler()
{
	InitUserInfo();	//add by csj 2019-02-19
	Muilt_LookUp("Loc^Provider");
	KeyUp("Loc^Provider");
	HiddenTableIcon("DHCEQPayRequestListDetail","TRowID","TDetail");
	initButtonWidth()
}
function GetLocID(value)
{
	GetLookUpID('LocDR',value);
}

//add by csj 2020-02-19
function GetProviderID(value)
{
	GetLookUpID("ProviderDR",value);
}

//add by csj 2020-02-13
function GetPayEquipType(value)
{
	GetLookUpID("PayEquipTypeDR",value);
}
//add by csj 20191204 付款明细导出
function BSave_Clicked()
{
	var rows=$('#tDHCEQPayRequestListDetail').datagrid('getRows')
	if(rows.length>0){
		var TJob=rows[0].TJob;
	}
	else{
		return
	}
	if (TJob=="")  return;
	var TotalRows=tkMakeServerCall("web.DHCEQCommon","GetTempDataRows","GetPayRequestListDetail",TJob);
	var PageRows=TotalRows; //每页固定行数
	var Pages=parseInt(TotalRows / PageRows) //总页数-1  
	var ModRows=TotalRows%PageRows //最后一页行数
	if (ModRows==0) Pages=Pages-1
	
	try
	{
        var xlApp,xlsheet,xlBook;
        var encmeth=GetElementValue("GetRepPath");
		if (encmeth=="") return;
		var TemplatePath=cspRunServerMethod(encmeth);
	    var Template=TemplatePath+"DHCEQPayRequestListDetail.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    var encmeth=GetElementValue("GetTempData");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=PageRows;
	    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	//xlsheet.cells(2,1)=xlsheet.cells(2,1) //+MonthStr;	//FormatDate(BeginDate)+"--"+FormatDate(EndDate);
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
		    	var OneDetail=tkMakeServerCall("web.DHCEQCommon","GetTempData","PayRequestListDetail",TJob,l);
		    	var OneDetailList=OneDetail.split("^");
		    	
		    	var j=k+3;
		    	
		    	xlsheet.Rows(j).Insert();
		    	var col=1;
				//	0				1					2			3			4		   5			6			7				8			9		10			 11			12		13			14			15				16			17		18			19		20					21				22				23
				//TRowID_"^"_TPayRequestNo_"^"_TAccountDate_"^"_TLoc_"^"_TProvider_"^"_TTotalFee_"^"_TStatus_"^"_TRemark_"^"_TPayFromType_"^"_type_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TEquipName_"^"_TEquipType_"^"_TNo_"^"_TModel_"^"_TUnit_"^"_TQuantityNum_"^"_TOriginalFee_"^"_TQuantityFee_"^"_TInvoiceNo
		    	xlsheet.cells(j,col++)=OneDetailList[17];
		    	xlsheet.cells(j,col++)=OneDetailList[15];
		    	xlsheet.cells(j,col++)=OneDetailList[18];
		    	xlsheet.cells(j,col++)=OneDetailList[19];
		    	xlsheet.cells(j,col++)=OneDetailList[20];
		    	xlsheet.cells(j,col++)=OneDetailList[21];
		    	xlsheet.cells(j,col++)=OneDetailList[22];
		    	xlsheet.cells(j,col++)=OneDetailList[23];
			}
			xlsheet.Rows(j+1).Delete();
			xlsheet.Rows(j+2).Delete();
			xlsheet.cells(j+1,1)="总金额："+OneDetailList[5]
			xlsheet.cells(j+2,1)="负责人："
			xlsheet.cells(j+2,4)="审核人："
			xlsheet.cells(j+2,7)="制表人："+curUserName
			xlsheet.cells(2,2)=GetElementValue("PayEquipType")
			xlsheet.cells(2,5)=GetElementValue("Provider")
//			xlsheet.cells(j+1,1)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页"
			//xlsheet.cells(2,1)="时间范围:"+GetElementValue("StartDate")+"--"+GetElementValue("EndDate")
			//xlsheet.cells(2,4)="制表人:"+curUserName

			var savepath=GetFileName();
			xlBook.SaveAs(savepath);
	    	xlBook.Close (savechanges=false);
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

document.body.onload = BodyLoadHandler;