/// DHCEQAInMoveSum.js
function BodyLoadHandler() 
{	
	KeyUp("EquipType","N");
	
	var obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_Clicked;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
	Muilt_LookUp("FromLoc^ToLoc^EquipType")
}

function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}
function GetFromLoc (value)
{
    GetLookUpID("FromLocDR",value);
}
function GetToLoc (value)
{
    GetLookUpID("ToLocDR",value);
}
function BSave_Clicked()
{
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)  TJob=ObjTJob.value;
	if (TJob=="") return;
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	
	var	TemplatePath=cspRunServerMethod(encmeth);
	//TEquipType_"^"_TFromLoc_"^"_TToLoc_"^"_TQuantityNum_"^"_TAmount
	var encmeth=GetElementValue("GetOneAInMoveSumReport");
	var TotalRows=cspRunServerMethod(encmeth,0,TJob);
	var PageRows=43; //每页固定行数
	PageRows=TotalRows;
	var Pages=parseInt(TotalRows / PageRows) //总页数-1
	var ModRows=TotalRows%PageRows //最后一页行数
	if (ModRows==0) Pages=Pages-1
	
	try
	{
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQALocUsedMonthReport.xls";
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
		    	var j=k+3;
		    	xlsheet.Rows(j).Insert();
		    	xlsheet.cells(j,1)=OneDetailList[0];
		    	xlsheet.cells(j,2)=OneDetailList[1];
		    	xlsheet.cells(j,3)=OneDetailList[2];
		    	xlsheet.cells(j,4)=OneDetailList[3];
		    	xlsheet.cells(j,5)=OneDetailList[4];
			}
			
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(j+1,1)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";
			xlsheet.cells(2,1)="时间范围:"+FormatDate(GetElementValue("StartDate"))+"到"+FormatDate(GetElementValue("EndDate"));
			xlsheet.cells(j+1,4)="制表人:";
			xlsheet.cells(j+1,5)=curUserName;
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
}function BPrint_Clicked()
{
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)
	{
		TJob=ObjTJob.value;
	}
	else
	{return;} 
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	
	var	TemplatePath=cspRunServerMethod(encmeth);
	//TEquipType_"^"_TFromLoc_"^"_TToLoc_"^"_TQuantityNum_"^"_TAmount
	var encmeth=GetElementValue("GetOneAInMoveSumReport");
	var TotalRows=cspRunServerMethod(encmeth,0,TJob);
	var PageRows=6; 	//每页固定行数
	var col=1;			//每行打印组数
	//PageRows=TotalRows;
	var Pages=parseInt(TotalRows / (PageRows*col)) 	//总页数-1
	var ModCols=TotalRows%(PageRows*col) 			//最后一页输出数
	var ModRows=parseInt(ModCols / col);			//最后一页行数
	if ((ModRows==0)&&(ModCols < col)&&(ModCols > 0))
	{
		ModRows=1;
	}
	else
	{
		if ((ModRows*col)!=ModCols) ModRows=ModRows+1;
	}
	if (ModRows==0) Pages=Pages-1;
	
	try
	{
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQAInMoveSumReport.xls";
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
			
	    	for (var k=0;k<OnePageRow;k++)
	    	{
				var j=k+4;
				for (var c=1;c<=col;c++)
				{
					var l=i*(PageRows*col)+k*col+c;
					var encmeth=GetElementValue("GetOneAInMoveSumReport");
					var OneDetail=cspRunServerMethod(encmeth,l,TJob);
					var OneDetailList=OneDetail.split("^");
					//alertShow(OneDetailList[2])
					xlsheet.cells(j,(c-1)*2+1)=OneDetailList[0];
					xlsheet.cells(j,(c-1)*2+2)=OneDetailList[1];
					xlsheet.cells(j,(c-1)*2+3)=OneDetailList[2];
					xlsheet.cells(j,(c-1)*2+4)=OneDetailList[0];
					xlsheet.cells(j,(c-1)*2+5)=OneDetailList[3];
					xlsheet.cells(j,(c-1)*2+5)=OneDetailList[5];	// 科室数
					xlsheet.cells(j,(c-1)*2+6)=OneDetailList[4];
				}
			}
			
			//xlsheet.Rows(j+1).Delete();
			//xlsheet.cells(2,1)=xlsheet.cells(2,1)+curUserName;
			//xlsheet.cells(2,4)="报表月份:"+GetElementValue("MonthStr");
			xlsheet.cells(2,4)="时间范围:"+FormatDate(GetElementValue("StartDate"))+"到"+FormatDate(GetElementValue("EndDate"));
			xlsheet.cells(8,2)=OneDetailList[1];
			xlsheet.cells(8,3)=OneDetailList[2];
			//xlsheet.cells(8,5)=OneDetailList[3];
			xlsheet.cells(8,5)=OneDetailList[5];
			xlsheet.cells(8,6)=OneDetailList[4];
			var encmeth=GetElementValue("GetCurTime")
			var curTime=cspRunServerMethod(encmeth);
			xlsheet.cells(10,1)="打印日期:"+curTime;
			xlsheet.cells(10,6)="(第"+(i+1)+"页 "+"共"+(Pages+1)+"页)";
			//xlsheet.cells(j+1,4)="制表人:";
			//xlsheet.cells(j+1,5)=curUserName;
			
			var obj = new ActiveXObject("PaperSet.GetPrintInfo");
			var size=obj.GetPaperInfo("DHCEQInStock");
			if (0!=size) xlsheet.PageSetup.PaperSize = size;
			xlsheet.printout; //打印输出
			//var savepath=GetFileName();
			//xlBook.SaveAs(savepath);
	    	xlBook.Close (savechanges=false);
	    
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	    //alertShow("操作完成.")
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}
document.body.onload = BodyLoadHandler;