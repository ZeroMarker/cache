/// DHCEQPayPlanDetail.js
function BodyLoadHandler() 
{
	InitPage();
	fillData();
	Muilt_LookUp("Provider");
	KeyUp("Provider");
	
	RefreshData()
}
///��ʼ��ҳ��
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
		alertShow("δѡ����Ч��ӡ��.");
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
	PayPlanDetail[n+1]="�ϼ�^^^^^^"+toatlfee+"^^^^^^^^^^"+num;
	
	var TotalRows=RowIDs.length+1;
	var PageRows=7; 		//ÿҳ�̶�����
	var Pages=parseInt(TotalRows / PageRows); 	//��ҳ��-1
	var ModRows=TotalRows%PageRows;				//���һҳ����
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
		    	xlsheet.cells(j,1)=OneDetailList[0];	//�豸����
		    	xlsheet.cells(j,2)=OneDetailList[12];	//����ͺ�
		    	xlsheet.cells(j,3)=OneDetailList[14];	//ʹ�ÿ���
		    	xlsheet.cells(j,4)=OneDetailList[13];	//��λ
		    	xlsheet.cells(j,5)=OneDetailList[16];	//����
		    	xlsheet.cells(j,6)=OneDetailList[15];	//����
		    	xlsheet.cells(j,7)=OneDetailList[5];	//�ܽ��
		    	xlsheet.cells(j,8)=OneDetailList[7];	//�������
		    	xlsheet.cells(j,9)=OneDetailList[6];	//������
		    	//xlsheet.cells(j,10)=OneDetailList[11];	//��ע
		    	xlsheet.cells(j,10)=OneDetailList[1];	//����˵��
			}
			xlsheet.cells(2,10)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ";
			xlsheet.cells(3,10)="��ӡʱ��:"+curTime;
			//xlsheet.cells(2,1)="ʱ�䷶Χ:"+FormatDate(GetElementValue("StartDate"))+"��"+FormatDate(GetElementValue("EndDate"))
			xlsheet.cells(3,1)="��Ӧ��:"+Provider;
			//xlsheet.cells(j+1,6)="�Ʊ���:"
			//xlsheet.cells(j+1,7)=curUserName
	    	//xlsheet.printout; //��ӡ���
	    	
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
		alertShow("δѡ����Ч��ӡ��.");
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
	var PageRows=7; 		//ÿҳ�̶�����
	var Pages=parseInt(TotalRows / PageRows); 	//��ҳ��-1
	var ModRows=TotalRows%PageRows;				//���һҳ����
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
		    	xlsheet.cells(j,1)=OneDetailList[0];	//�豸����
		    	xlsheet.cells(j,2)=OneDetailList[1];	//����ͺ�
		    	xlsheet.cells(j,3)=OneDetailList[2];	//ʹ�ÿ���
		    	xlsheet.cells(j,4)=OneDetailList[3];	//��λ
		    	xlsheet.cells(j,5)=OneDetailList[4];	//����
		    	xlsheet.cells(j,6)=OneDetailList[5];	//����
		    	xlsheet.cells(j,7)=OneDetailList[6];	//�ܽ��
		    	xlsheet.cells(j,8)=OneDetailList[7];	//�������
			}
			xlsheet.cells(2,8)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ";
			xlsheet.cells(2,1)=xlsheet.cells(2,1)+curTime;
			//xlsheet.cells(2,1)="ʱ�䷶Χ:"+FormatDate(GetElementValue("StartDate"))+"��"+FormatDate(GetElementValue("EndDate"))
			//xlsheet.cells(j+1,6)="�Ʊ���:"
			//xlsheet.cells(j+1,7)=curUserName
	    	//xlsheet.printout; //��ӡ���
	    	
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