/// DHCEQPaymentNoticeFind.js
function BodyLoadHandler()
{
	KeyUp("Loc^Provider");
	SetStatus();
	var obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_Clicked;
	Muilt_LookUp("Loc^Provider");
}

function SetStatus()
{
	SetElement("Status",GetElementValue("StatusDR"));
}

function GetLoc(value)
{
	GetLookUpID("LocDR",value);
}

function GetProvider(value)
{
	GetLookUpID("ProviderDR",value);
}
function BSave_Clicked()
{
	//alertShow("BSave_Clicked")
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)  TJob=ObjTJob.value;
	if (TJob=="") return;
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	
	var	TemplatePath=cspRunServerMethod(encmeth);
	var encmeth=GetElementValue("GetOneAccountNoDetail");
	var TotalRows=cspRunServerMethod(encmeth,0,TJob);
	var PageRows=43; //每页固定行数
	PageRows=TotalRows;
	var Pages=parseInt(TotalRows / PageRows) //总页数-1
	var ModRows=TotalRows%PageRows //最后一页行数
	if (ModRows==0) Pages=Pages-1
	
	try
	{
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQAccountNoDetail.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//xlsheet.PageSetup.LeftMargin=0;
	    	//xlsheet.PageSetup.RightMargin=0;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=0
	    	if (ModRows==0)
	    	{
		    	OnePageRow=PageRows;
	    	}
	    	else
	    	{
	    		if (i==Pages)
	    		{
		    		OnePageRow=ModRows;
	    		}
		    	else
		    	{
			    	OnePageRow=PageRows;
		    	}
	    	}
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"));
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
			    var OneDetail=cspRunServerMethod(encmeth,l,TJob);
		    	var OneDetailList=OneDetail.split("^");
		    	//alertShow(OneDetail)
		    	//TRowID_"^"_TAccountNo_"^"_TAccountDate_"^"_TLoc_"^"_TProvider_"^"_TEquipType_"^"_TCheckDate_"^"_TTotalFee_"^"_TStatus_"^"_TRemark
		    	var j=k+3;
		    	xlsheet.Rows(j).Insert();
		    	xlsheet.cells(j,1)=OneDetailList[1];
		    	xlsheet.cells(j,2)=OneDetailList[2];
		    	xlsheet.cells(j,3)=OneDetailList[3];
		    	xlsheet.cells(j,4)=OneDetailList[4];
		    	xlsheet.cells(j,5)=OneDetailList[5];
		    	xlsheet.cells(j,6)=OneDetailList[6];
		    	xlsheet.cells(j,7)=OneDetailList[7];
		    	xlsheet.cells(j,8)=OneDetailList[8];
		    	xlsheet.cells(j,9)=OneDetailList[9];
			}
			
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(j+1,1)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";
			xlsheet.cells(2,1)="时间范围:"+FormatDate(GetElementValue("StartDate"))+"--"+FormatDate(GetElementValue("EndDate"));
			xlsheet.cells(j+1,7)="制表人:";
			xlsheet.cells(j+1,8)=curUserName;
	    	//xlsheet.printout; //打印输出
			var savepath=GetFileName();
			xlBook.SaveAs(savepath);
	    	xlBook.Close (savechanges=false);
	    
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	    alertShow("操作完成.")
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}
document.body.onload = BodyLoadHandler;