/// DHCEQPayPlanDetail.js
function BodyLoadHandler() 
{
	InitPage();
	fillData();
	Muilt_LookUp("Provider");
	KeyUp("Provider");
	
	RefreshData()
}
///初始化页面
function InitPage()
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	var obj=document.getElementById("BPrintTotal");
	if (obj) obj.onclick=BPrintTotal_Click;
	var obj=document.getElementById("SelectAll");
	if (obj) obj.onclick=SelectAll_Clicked;

}
function BFind_Click()
{
	var val="&LocDR="+GetElementValue("LocDR");
	val=val+"&Data="+GetData();
	//alertShow(val)
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPayPlanDetail"+val;
}
function GetData()
{
	var	val="^Desc="+GetElementValue("Desc");
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	val=val+"^PayType="+GetElementValue("PayType");
	val=val+"^ProviderDR="+GetElementValue("ProviderDR");
	val=val+"^Provider="+GetElementValue("Provider");
	val=val+"^PayAmount="+GetElementValue("PayAmount");
	val=val+"^MaxAmount="+GetElementValue("MaxAmount");
	
	return val;
}
function fillData()
{
	var Data=GetElementValue("Data")
	if (Data!="")
	{
		var list=Data.split("^");
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
function SelectAll_Clicked()
{
	var obj=document.getElementById("SelectAll");
	var Objtbl=document.getElementById("tDHCEQPayPlanDetail");
	var Rows=Objtbl.rows.length;
	//alertShow(Rows)
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById("TOperatorz"+i);
		selobj.checked=obj.checked;
	}
}
function GetProvider(value)
{
	GetLookUpID("ProviderDR",value);
}
function BPrint_Click()
{
	var PayPlanDetail=new Array;
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob) TJob=ObjTJob.value;
	if (TJob=="") return;
	var encmeth=GetElementValue("GetCurTime");
	var curTime=cspRunServerMethod(encmeth);
	
	var tmpRowIDs="";
	var objtbl=document.getElementById("tDHCEQPayPlanDetail");
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		var id=GetElementValue("TRowIDz"+i);
		var Operator=GetChkElementValue("TOperatorz"+i);
		if ((Operator)&&(id!=""))
		{
			if (tmpRowIDs!="") tmpRowIDs=tmpRowIDs+"^";
			tmpRowIDs=tmpRowIDs+GetElementValue("TRowIDz"+i);
		}
	}
	if (tmpRowIDs=="")
	{
		alertShow("未选择有效打印行.");
		return;
	}
	//alertShow(tmpRowIDs)
	
	var num=0;
	var toatlfee=0;
	var RowIDs=tmpRowIDs.split("^");
	encmeth=GetElementValue("GetList");
	for (var n=0;n<RowIDs.length;n++)
	{
		PayPlanDetail[n+1]=cspRunServerMethod(encmeth,TJob,RowIDs[n]);
		//alertShow(PayPlanDetail[n+1])
		var tmp=PayPlanDetail[n+1].split("^");
		num=+tmp[16]+num;
		toatlfee=+tmp[6]+toatlfee;
	}
	PayPlanDetail[n+1]="合计^^^^^^"+toatlfee+"^^^^^^^^^^"+num;
	
	var TotalRows=RowIDs.length+1;
	var PageRows=7; 		//每页固定行数
	var Pages=parseInt(TotalRows / PageRows); 	//总页数-1
	var ModRows=TotalRows%PageRows;				//最后一页行数
	//alertShow(TotalRows+"-"+PageRows+"-"+Pages);
	if (ModRows==0) Pages=Pages-1;
	try
	{
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQPayPlanDetail.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//xlsheet.PageSetup.LeftMargin=0;
	    	//xlsheet.PageSetup.RightMargin=0;
	    	xlsheet.PageSetup.TopMargin=0;
	    	
	    	var Provider="";
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
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	xlsheet.cells(2,1)=xlsheet.cells(2,1)+GetShortName(GetElementValue("Loc"),"-");
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	//alertShow(PayPlanDetail[l])
		    	var l=i*PageRows+k;
			    var OneDetail=PayPlanDetail[l];
		    	var OneDetailList=OneDetail.split("^");
		    	var j=k+4;
		    	if (Provider=="") Provider=OneDetailList[8];
		    	xlsheet.cells(j,1)=OneDetailList[0];	//设备名称
		    	xlsheet.cells(j,2)=OneDetailList[12];	//规格型号
		    	xlsheet.cells(j,3)=OneDetailList[14];	//使用科室
		    	xlsheet.cells(j,4)=OneDetailList[13];	//单位
		    	xlsheet.cells(j,5)=OneDetailList[16];	//数量
		    	xlsheet.cells(j,6)=OneDetailList[15];	//单价
		    	xlsheet.cells(j,7)=OneDetailList[5];	//总金额
		    	xlsheet.cells(j,8)=OneDetailList[7];	//付款比例
		    	xlsheet.cells(j,9)=OneDetailList[6];	//付款金额
		    	//xlsheet.cells(j,10)=OneDetailList[11];	//备注
		    	xlsheet.cells(j,10)=OneDetailList[1];	//付款说明
			}
			xlsheet.cells(2,10)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";
			xlsheet.cells(3,10)="打印时间:"+curTime;
			//xlsheet.cells(2,1)="时间范围:"+FormatDate(GetElementValue("StartDate"))+"至"+FormatDate(GetElementValue("EndDate"))
			xlsheet.cells(3,1)="供应商:"+Provider;
			//xlsheet.cells(j+1,6)="制表人:"
			//xlsheet.cells(j+1,7)=curUserName
	    	//xlsheet.printout; //打印输出
	    	
	    	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
		    var size=obj.GetPaperInfo("DHCEQInStock");
		    if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    	
	    	xlApp.Visible=true;
    		xlsheet.PrintPreview();
			//var savepath=GetFileName();
			//xlBook.SaveAs(savepath);
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
function BPrintTotal_Click()
{
	var PayPlanDetail=new Array;
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob) TJob=ObjTJob.value;
	if (TJob=="") return;
	var encmeth=GetElementValue("GetCurTime");
	var curTime=cspRunServerMethod(encmeth);
	
	var tmpRowIDs="";
	var objtbl=document.getElementById("tDHCEQPayPlanDetail");
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		var id=GetElementValue("TRowIDz"+i);
		var Operator=GetChkElementValue("TOperatorz"+i);
		if ((Operator)&&(id!=""))
		{
			if (tmpRowIDs!="") tmpRowIDs=tmpRowIDs+"^";
			tmpRowIDs=tmpRowIDs+GetElementValue("TRowIDz"+i);
		}
	}
	if (tmpRowIDs=="")
	{
		alertShow("未选择有效打印行.");
		return;
	}
	
	encmeth=GetElementValue("SetTotalData");
	var TotalRows=cspRunServerMethod(encmeth,TJob,tmpRowIDs);
	//alertShow(tmpRowIDs+"-"+TotalRows)
	encmeth=GetElementValue("GetTotalList");
	for (var n=1;n<=TotalRows;n++)
	{
		PayPlanDetail[n]=cspRunServerMethod(encmeth,TJob,n);
	}
	var PageRows=7; 		//每页固定行数
	var Pages=parseInt(TotalRows / PageRows); 	//总页数-1
	var ModRows=TotalRows%PageRows;				//最后一页行数
	//alertShow(TotalRows+"-"+PageRows+"-"+Pages);
	if (ModRows==0) Pages=Pages-1;
	try
	{
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQPayPlanTotal.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//xlsheet.PageSetup.LeftMargin=0;
	    	//xlsheet.PageSetup.RightMargin=0;
	    	xlsheet.PageSetup.TopMargin=0;
	    	
	    	var Provider="";
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
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k;
			    var OneDetail=PayPlanDetail[l];
			    //alertShow(PayPlanDetail[l])
		    	var OneDetailList=OneDetail.split("^");
		    	var j=k+3;
		    	
		    	//xlsheet.Rows(j).Insert();
		    	xlsheet.cells(j,1)=OneDetailList[0];	//设备名称
		    	xlsheet.cells(j,2)=OneDetailList[1];	//规格型号
		    	xlsheet.cells(j,3)=OneDetailList[2];	//使用科室
		    	xlsheet.cells(j,4)=OneDetailList[3];	//单位
		    	xlsheet.cells(j,5)=OneDetailList[4];	//数量
		    	xlsheet.cells(j,6)=OneDetailList[5];	//单价
		    	xlsheet.cells(j,7)=OneDetailList[6];	//总金额
		    	xlsheet.cells(j,8)=OneDetailList[7];	//付款比例
			}
			xlsheet.cells(2,8)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";
			xlsheet.cells(2,1)=xlsheet.cells(2,1)+curTime;
			//xlsheet.cells(2,1)="时间范围:"+FormatDate(GetElementValue("StartDate"))+"至"+FormatDate(GetElementValue("EndDate"))
			//xlsheet.cells(j+1,6)="制表人:"
			//xlsheet.cells(j+1,7)=curUserName
	    	//xlsheet.printout; //打印输出
	    	
	    	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
		    var size=obj.GetPaperInfo("DHCEQInStock");
		    if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    	
	    	xlApp.Visible=true;
    		xlsheet.PrintPreview();
			//var savepath=GetFileName();
			//xlBook.SaveAs(savepath);
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
function RefreshData()
{
	var vdata1=GetElementValue("Data");
	var vdata2=GetData();
	if (vdata1!=vdata2) BFind_Click();
}
document.body.onload = BodyLoadHandler;