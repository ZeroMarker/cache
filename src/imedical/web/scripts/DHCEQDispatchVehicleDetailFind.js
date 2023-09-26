/// DHCEQDispatchVehicleDetailFind.js
document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;
function BodyLoadHandler()
{
	InitPage();
	SetStatus();
	fillData();
	RefreshData();
	Muilt_LookUp("RequestUser^Driver");
	KeyUp("RequestUser^Driver");
}

function InitPage()
{
	var obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
}
function SetStatus()
{
	SetElement("Status",GetElementValue("StatusDR"));
}
function fillData()
{
	var vData=GetElementValue("vData");
	//alertShow(vData)
	if (vData!="")
	{
		var list=vData.split("^");
		for (var i=1; i<list.length; i++)
		{
			Detail=list[i].split("=");
			switch (Detail[0])
			{
				default :
					SetElement(Detail[0],Detail[1]);
					break;
			}
		}
	}
}

function RefreshData()
{
	var vdata1=GetElementValue("vData");
	var vdata2=GetVData();
	if (vdata1!=vdata2) BFind_Click();
}

function BFind_Click()
{
	var val="&vData="+GetVData();
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDispatchVehicleDetailFind"+val;
}

function GetVData()
{
	var val="^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	val=val+"^DispatchVehicleNo="+GetElementValue("DispatchVehicleNo");
	val=val+"^Arrive="+GetElementValue("Arrive");
	val=val+"^Status="+GetElementValue("Status");
	val=val+"^RequestUserDR="+GetElementValue("RequestUserDR");
	val=val+"^RequestUser="+GetElementValue("RequestUser");
	val=val+"^VehicleNo="+GetElementValue("VehicleNo");
	val=val+"^DriverDR="+GetElementValue("DriverDR");
	val=val+"^Driver="+GetElementValue("Driver");
	val=val+"^EquipNo="+GetElementValue("EquipNo");
	val=val+"^InvalidFlag="+GetElementValue("InvalidFlag");
	//alertShow(val)
	return val;
}

function BSave_Click()
{
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)  TJob=ObjTJob.value;
	if (TJob=="")  return;
	//0                1                 2          		3          4         		5          6          7             8
	//TRowID_"^"_TDispatchVehicleNo_"^"_TRequestDate_"^"_TStatus_"^"_TRequestUser_"^"_TArrive_"^"_TEquip_"^"_TVehicleNo_"^"_TDriver
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)  TJob=ObjTJob.value;
	if (TJob=="")  return;
	var encmeth=GetElementValue("GetOneDispatchVehicleDetail");
	var TotalRows=cspRunServerMethod(encmeth,0,TJob);
	
	var PageRows=43 //每页固定行数
	PageRows=TotalRows;
	var Pages=parseInt(TotalRows / PageRows) //总页数-1  
	var ModRows=TotalRows%PageRows //最后一页行数
	if (ModRows==0) Pages=Pages-1
	
	try
	{
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQDispatchVehicleDetail.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//xlsheet.PageSetup.LeftMargin=0;
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
			    var OneDetail=cspRunServerMethod(encmeth,l,TJob);
		    	var OneDetailList=OneDetail.split("^");
		    	var j=k+3;
		    	xlsheet.Rows(j).Insert();
		    	xlsheet.cells(j,1)=OneDetailList[1];
		    	xlsheet.cells(j,2)=OneDetailList[2];
		    	xlsheet.cells(j,3)=OneDetailList[3];
		    	xlsheet.cells(j,4)=OneDetailList[4];
		    	xlsheet.cells(j,5)=OneDetailList[5];
		    	xlsheet.cells(j,6)=OneDetailList[7];
		    	xlsheet.cells(j,7)=OneDetailList[8];
		    	xlsheet.cells(j,8)=OneDetailList[6];
			}
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(j+1,1)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";
			xlsheet.cells(2,1)="时间范围:"+FormatDate(GetElementValue("StartDate"))+"--"+FormatDate(GetElementValue("EndDate"));
			xlsheet.cells(j+1,6)="制表人:";
			xlsheet.cells(j+1,7)=curUserName;
	    	//xlsheet.printout; //打印输出
			var savepath=GetFileName();
			xlBook.SaveAs(savepath);
	    	xlBook.Close (savechanges=false);
	    
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
function GetDriverInfo(value)
{
	GetLookUpID("DriverDR",value);
}
function GetRequestUser (value)
{
    GetLookUpID("RequestUserDR",value);
}
function BodyUnLoadHandler()
{
	//var encmeth=GetElementValue("KillTempGlobal");
	//cspRunServerMethod(encmeth,"DispatchVehicleDetail");
}

