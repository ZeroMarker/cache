function PrintOpenCheck()
{	
	var RowID=GetElementValue("RowID");
	if ((RowID=="")||(RowID<1)){
		return;
	}
	
	var encmeth=GetElementValue("fillData");
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	
	encmeth=GetElementValue("fillEquipData");
	var EquipInfo=cspRunServerMethod(encmeth,"","",list[0]);
	var EquipList=EquipInfo.split("^");
	
	var otherInfo=cspRunServerMethod(GetElementValue("GetList"),RowID);
	var otherlist=otherInfo.split("@");
	var affixlist=otherlist[0].split("&");
	var doclist=otherlist[1].split("&");
	var affixrows=affixlist.length;
	var docrows=doclist.length;
	
	var sort=54;
	var EquipSort=EquipGlobalLen;
	var rows;
	rows= affixrows;
	if (docrows>affixrows) rows=docrows;
	
	var PageRows=8; //ÿҳ�̶�����
	var Pages=parseInt(rows / PageRows); //��ҳ��-1  
	var ModRows=rows%PageRows; //���һҳ����
	if (ModRows==0) Pages=Pages-1;
	
	var TemplatePath=GetElementValue("GetRepPath");
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQCheck.xls";
	    xlApp = new ActiveXObject("Excel.Application");	    
	    for (var i=0;i<=Pages;i++)
	    {
		    xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    	//xlsheet.PageSetup.RightMargin=0;
	    	xlsheet.PageSetup.TopMargin=0;
	    	
	    	var row=2;
	    	xlsheet.cells(row,1)="�豸���:"+EquipList[70];//�豸���
	    	row=row+1;
	    	xlsheet.cells(row,2)=list[49];//�б���
	    	xlsheet.cells(row,4)=list[sort+0];//�豸����
	    	xlsheet.cells(row,8)=list[sort+13];  //����
	    	
	    	row=row+1;
	    	xlsheet.cells(row,2)=list[sort+27];//��ͬ���
	    	xlsheet.cells(row,4)=list[38];//����ʱ��
	    	xlsheet.cells(row,6)=list[50];//����ص�
	    	xlsheet.cells(row,8)=list[sort+3];  //ʹ�ÿ���
	    	row=row+1;
	    	xlsheet.cells(row,2)=list[sort+15];//�豸��λ
	    	xlsheet.cells(row,4)=list[44];//ԭֵ
	    	xlsheet.cells(row,6)=EquipList[EquipSort+24];//��;
	    	xlsheet.cells(row,8)=EquipList[71];  //��ŵص�
	    	row=row+1;
	    	xlsheet.cells(row,2)=list[sort+17];//����
	    	xlsheet.cells(row,4)=list[sort+21];//��������
	    	xlsheet.cells(row,8)=EquipList[72];  //����
	    	row=row+10;
	    	xlsheet.cells(row,4)=list[4];//�����嵥�Ƿ����
	    	xlsheet.cells(row,8)=list[9];  //����ļ��Ƿ����
	    	row=row+1;
	    	xlsheet.cells(row,4)=list[7];//�Ƿ�������
	    	xlsheet.cells(row,8)=list[6];  //��ת����Ƿ�����
	    	row=row+4;
	    	xlsheet.cells(row,8)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ";   //ʱ��
	    	
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
	    	var ss=5+(+OnePageRow);
	    	
	    	var FeeAll=0;
	    	for (var Row=1;Row<=OnePageRow;Row++)
			{				
				var Location=i*PageRows+Row-1;
				//alertShow(Location+" "+affixrows+" "+docrows);
				if (Location<affixrows)
				{
					var affix=affixlist[Location].split("^");
					xlsheet.cells(Row+7,2)=affix[0];
					xlsheet.cells(Row+7,4)=affix[1];
					xlsheet.cells(Row+7,5)=affix[2];
					xlsheet.cells(Row+7,6)=affix[3];
				}
				if (Location<docrows) xlsheet.cells(Row+7,7)=doclist[Location];				
	    	}

	    xlsheet.printout; //��ӡ���
	    //xlBook.SaveAs("D:\\Return"+i+".xls");   //lgl+
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