///Created By HZY 2013-10-12 HZY0059
///DHCEQMMaintPartInfo.js

function BodyLoadHandler() 
{
	initButtonWidth();		/// Mozy		1006659	2019-8-28	Hisui����
	KeyUp("Accessory");
	Muilt_LookUp("Accessory");
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

	var encmeth=GetElementValue("GetMaintPartInfoExport");
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
	    var Template=TemplatePath+"DHCEQMMaintPartInfo.xls";
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
		    	xlsheet.cells(j,1)=OneDetailList[0]; //�������
		    	xlsheet.cells(j,2)=OneDetailList[1]; //��  ��
		    	xlsheet.cells(j,3)=OneDetailList[2]; //��   ��
		    	xlsheet.cells(j,4)=OneDetailList[3]; //�� �� ��
			}
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(j+1,1)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ";
			xlsheet.cells(2,1)="ʱ�䷶Χ:"+FormatDate(GetElementValue("StartDate"))+"��"+FormatDate(GetElementValue("EndDate"));
			xlsheet.cells(j+1,4)="�Ʊ���:"+curUserName;
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
// add by zx 2015-09-14 BugZX0032 
function GetAccessory(value)
{
	var Info=value.split("^");
	SetElement('Accessory',Info[2]);
	SetElement('AccessoryDR',Info[0]);
}

document.body.onload = BodyLoadHandler;