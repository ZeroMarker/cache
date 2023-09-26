///Created By HZY 2013-10-15 HZY0059
///DHCEQMMaintEngineerInfo.js
function BodyLoadHandler() 
{	
	KeyUp("Engineer");
	Muilt_LookUp("Engineer");
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

	var encmeth=GetElementValue("GetMaintEngineerInfoExport");
	var TotalRows=cspRunServerMethod(encmeth,0);
	if(TotalRows=="")  
	{
		alertShow("������! "); 
		return;
	}
	var PageRows=43 //ÿҳ�̶�����
	PageRows=TotalRows;
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1  
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQMMaintEngineerInfo.xls";
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
		    	xlsheet.cells(j,1)=OneDetailList[0]; //����ʦ
		    	xlsheet.cells(j,2)=OneDetailList[1]; //ά�޴���
		    	xlsheet.cells(j,3)=OneDetailList[2]; //����������
		    	xlsheet.cells(j,4)=OneDetailList[3]; //���Ĺ�ʱ
		    	xlsheet.cells(j,5)=OneDetailList[4]; //ά������ƽ����
		    	xlsheet.cells(j,6)=OneDetailList[5]; //����̬��ƽ����
		    	xlsheet.cells(j,7)=OneDetailList[6]; //����ʱЧ��ƽ����
			}
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(j+1,5)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ";
			xlsheet.cells(2,1)="ʱ�䷶Χ:"+FormatDate(GetElementValue("StartDate"))+"��"+FormatDate(GetElementValue("EndDate"));
			xlsheet.cells(j+1,7)="�Ʊ���:"+curUserName;
	    	//xlsheet.printout; //��ӡ���
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

function GetEngineer(value)
{
	GetLookUpID("EngineerDR",value);
}

document.body.onload = BodyLoadHandler;