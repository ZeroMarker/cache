///Created By HZY 2013-10-12 HZY0059
///DHCEQMServiceMaintInfo.js

function BodyLoadHandler() 
{	
	KeyUp("Service");
	Muilt_LookUp("Service");
	InitPage();
}

function InitPage()
{
	var obj=document.getElementById("BExport");
	if (obj) obj.onclick=BExport_Click;
}

function BExport_Click()
{
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);

	var encmeth=GetElementValue("GetServiceMaintInfoExport");
	var TotalRows=cspRunServerMethod(encmeth,0);
	if(TotalRows=="")  
	{
		alertShow("无数据! "); 
		return;
	}
	var PageRows=43 //每页固定行数
	PageRows=TotalRows;
	var Pages=parseInt(TotalRows / PageRows) //总页数-1  
	var ModRows=TotalRows%PageRows //最后一页行数
	if (ModRows==0) Pages=Pages-1
	
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQMServiceMaintInfo.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    	//xlsheet.PageSetup.RightMargin=0;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=0;
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
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k;
			    var OneDetail=cspRunServerMethod(encmeth,l);
		    	var OneDetailList=OneDetail.split("^");
		    	var j=k+3;
		    	xlsheet.Rows(j).Insert();
		    	xlsheet.cells(j,1)=OneDetailList[0];
		    	xlsheet.cells(j,2)=OneDetailList[1];
		    	xlsheet.cells(j,3)=OneDetailList[2];
		    	xlsheet.cells(j,4)=OneDetailList[3];
			}
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(j+1,1)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";
			xlsheet.cells(2,1)="时间范围:"+FormatDate(GetElementValue("StartDate"))+"至"+FormatDate(GetElementValue("EndDate"));
			xlsheet.cells(j+1,4)="制表人:"+curUserName;
	    	//xlsheet.printout; //打印输出
			var savepath=GetFileName(); 
			xlBook.SaveAs(savepath);   
	    	xlBook.Close(savechanges=false);
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

function GetService(value)
{
	GetLookUpID("ServiceDR",value);
}

document.body.onload = BodyLoadHandler;