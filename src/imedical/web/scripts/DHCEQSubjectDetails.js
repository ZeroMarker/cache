function BodyLoadHandler()
{
	InitPage();
}

function InitPage()
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Clicked;
	var obj=document.getElementById("BSaveExcel");
	if (obj) obj.onclick=BSaveExcel_Clicked;
}

function BFind_Clicked()
{
	var val="";
  	val="&EquipTypeDR="+GetElementValue("EquipTypeDR");
	val=val+"&BeginDate="+GetElementValue("BeginDate");
	val=val+"&EndDate="+GetElementValue("EndDate");
	val=val+"&MinAmount="+GetElementValue("MinAmount");
	val=val+"&MaxAmount="+GetElementValue("MaxAmount");
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSubjectDetails'+val;
	
}

function BSaveExcel_Clicked()
{
	//0                1            2          3               4               5             6             7             		8            9
	//TEquipName_"^"_TAuditDate_"^"_TNo_"^"_TEquipType_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TAmount_"^"_TReturnNum_"^"_TReturnOriginalFee_"^"_TNum_"^"_TEQOriginalFee
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	
	var TJob=GetElementValue("TJobz1");
	if (TJob=="")  return;
	var encmeth=GetElementValue("GetSubjectDetails");
	var TotalRows=cspRunServerMethod(encmeth,0,TJob);
	
	var PageRows=TotalRows //ÿҳ�̶�����
	PageRows=TotalRows;
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1  
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	
	try {
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQSubjectDetails.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    	//xlsheet.PageSetup.RightMargin=0;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=0
	    	if (ModRows==0)
	    	{
		    	OnePageRow=PageRows
	    	}
	    	else
	    	{
	    		if (i==Pages)
	    		{
		    		OnePageRow=ModRows
	    		}
		    	else
		    	{
			    	OnePageRow=PageRows
		    	}
	    	}
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
			    var OneDetail=cspRunServerMethod(encmeth,l,TJob);
		    	var OneDetailList=OneDetail.split("^");
		    	var j=k+3;
		    	xlsheet.Rows(j).Insert();
		    	xlsheet.cells(j,1)=OneDetailList[0];	//�豸����
		    	xlsheet.cells(j,2)=OneDetailList[2];	//��ⵥ��/�豸���	
		    	xlsheet.cells(j,3)=FormatDate(OneDetailList[1]);	//�������
		    	xlsheet.cells(j,4)=OneDetailList[3];	//����
		    	xlsheet.cells(j,5)=OneDetailList[4];	//��ⵥԭֵ
		    	xlsheet.cells(j,6)=OneDetailList[5];	//�������
		    	xlsheet.cells(j,7)=OneDetailList[6];	//����ܽ��
		    	xlsheet.cells(j,8)=OneDetailList[7];	//�˻�����
		    	xlsheet.cells(j,9)=OneDetailList[8];	//�˻��ܽ��
		    	xlsheet.cells(j,10)=OneDetailList[9];	//̨������
		    	xlsheet.cells(j,11)=OneDetailList[10];	//̨���ܽ�� 
			}
			
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(j+1,1)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"
			xlsheet.cells(2,1)="ʱ�䷶Χ:"+FormatDate(GetElementValue("BeginDate"))+"--"+FormatDate(GetElementValue("EndDate"))
			xlsheet.cells(j+1,6)="�Ʊ���:"
			xlsheet.cells(j+1,7)=curUserName
	    	//xlsheet.printout; //��ӡ���
			var savepath=GetFileName();  //Modified By ZY 2009-11-17 ZY0017
			xlBook.SaveAs(savepath);   //Modified By ZY 2009-11-17 ZY0017
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

function GetEquipTypeID(value)
{
	GetLookUpID("EquipTypeDR",value);
}
document.body.onload = BodyLoadHandler;
