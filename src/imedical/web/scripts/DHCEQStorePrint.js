///�˻���ӡ
function PrintReturn(returnid)
{	
	PrintReturnStandard(returnid);
	return;
}

///ת�ƴ�ӡ
function PrintStoreMove(storeMoveid)
{
	PrintStoreMoveStandard(storeMoveid);
	return;
}
///����ӡ
function PrintInStore(inStoreid)
{
	PrintInStoreStandard(inStoreid);
	return;
}

///�˻���ӡ
function PrintReturnStandard(returnid)
{
	if (returnid=="") return;
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var ReturnList=cspRunServerMethod(encmeth,returnid);
	
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var lista=ReturnList.split("^");
	
	//alertShow(ReturnList);
	//��ȡ������Ϣ
	var sort=28; //2011-03-10 DJ
	var OutTypeDR=lista[16];	
	var OutType=lista[sort+7];
	var No=lista[0];  //ƾ����
	var EquipType=lista[sort+5] ; //����
	var FromLoc=GetShortName(lista[sort+0],"-");//�˻�����
	if (OutTypeDR!=1)
	{	var ToDept=GetShortName(lista[sort+8],"-");}	//ȥ��
	else
	{	var ToDept=GetShortName(lista[sort+1],"-");} 	//��Ӧ��
	var Maker=lista[sort+2];//�Ƶ���
	var ReturnDate=FormatDate(lista[3]);//��������
	//alertShow(OutTypeDR+" "+OutType);
	
	var encmeth=GetElementValue("GetList");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,returnid);
	if (gbldata=="") return;
	var RLList=gbldata.split("^");
	rows=RLList.length;
	if (rows>0) rows=rows+1;
	var sumFee=0;
	var sumQty=0;
	var PageRows=6; //ÿҳ�̶�����
	var Pages=parseInt(rows / PageRows); //��ҳ��-1  
	var ModRows=rows%PageRows; //���һҳ����
	if (ModRows==0) Pages=Pages-1;
	
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	var encmeth=GetElementValue("GetOneReturnList");
	try {
        var xlApp,xlsheet,xlBook;
        
        if (OutTypeDR==1)
        {
	    	var Template=TemplatePath+"DHCEQReturnSP.xls";
        }
        else
        {
	        var Template=TemplatePath+"DHCEQOutStockSP.xls";
	    }
	    
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
		    xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	
	    	xlsheet.PageSetup.TopMargin=0;
	    	//ҽԺ�����滻 Add By DJ 2011-07-14
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	xlsheet.cells(2,2)=No;  //ƾ����
	    	xlsheet.cells(2,6)=ReturnDate;  //��������
	    	xlsheet.cells(2,8)=EquipType; //����
	    	xlsheet.cells(3,2)=FromLoc;//�˻�����
	    	if (OutTypeDR==1)
	    	{
		    	xlsheet.cells(3,6)=ToDept;//��Ӧ��
	    	}
	    	else
	    	{
		    	xlsheet.cells(3,6)=OutType;  //��������
		    	xlsheet.cells(3,8)=ToDept;//��Ӧ��
	    	}
	    	
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
			//var sort=9;
			var sort=13;
			for (var Row=1;Row<=OnePageRow;Row++)
			{
				var Location=i*PageRows+Row-1;
				if (Location==rows-1)
				{
					//xlsheet.Rows(Row+5).Insert();
					xlsheet.cells(Row+4,1)="�ϼ�";//�豸����
					xlsheet.cells(Row+4,4)=sumQty;//����
					xlsheet.cells(Row+4,6)=sumFee;//�ܼ�
				}
				else
				{
				var RLID=RLList[Location];
				var Data=cspRunServerMethod(encmeth,RLID);
				var List=Data.split("^");
				//xlsheet.Rows(Row+5).Insert();
				xlsheet.cells(Row+4,1)=List[sort+4];//�豸����
				//xlsheet.cells(Row+5,2)=List[1];//��������
				xlsheet.cells(Row+4,2)=List[sort+5];//����
				xlsheet.cells(Row+4,3)=List[sort+8];//��λ
				xlsheet.cells(Row+4,4)=List[4];//����
				xlsheet.cells(Row+4,5)=List[5];//ԭֵ
				var FeeAllm=List[4]*List[5];
				xlsheet.cells(Row+4,6)=FeeAllm;//�ܼ�
				
				//xlsheet.cells(Row+4,7)=List[sort+9];//��Ʊ��
				xlsheet.cells(Row+4,7)=List[sort+10];//�豸���
				
				//xlsheet.cells(Row+4,9)=List[sort+11];//��ͬ��
				//xlsheet.cells(Row+4,10)=List[sort+3];//�˻�ԭ��
				xlsheet.cells(Row+4,8)=List[8];//��ע
				FeeAll=FeeAll+FeeAllm;
				sumFee=sumFee+FeeAllm;
				sumQty=sumQty+List[4]*1;
				}				
	    	}
	    //xlsheet.cells(OnePageRow+7,7)="�Ƶ���:"+Maker;
	    //xlsheet.Rows(OnePageRow+6).Delete();	    
	    //xlsheet.cells(OnePageRow+9,2)=ReturnDate;
	    //xlsheet.cells(OnePageRow+9,6)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ";   //ʱ��
	    xlsheet.cells(11,8)="�Ƶ���:"+Maker;
	    xlsheet.cells(12,8)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ";     
    	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
	    var size=obj.GetPaperInfo("DHCEQInStock");
	    if (0!=size) xlsheet.PageSetup.PaperSize = size;
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


///����ӡ
///modify by lmm 2019-08-21 ������� data listdata
function PrintInStoreStandard(inStoreid,data,listdata)
{
	if (inStoreid=="") return;
	//add by lmm 2019-08-22 begin
	if (data=="") var data="fillData"
	
	var encmetha=GetElementValue(data);
	//var encmetha=GetElementValue("fillData");
	//add by lmm 2019-08-22 end
	if (encmetha=="") return;
	var ReturnList=cspRunServerMethod(encmetha,inStoreid);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var lista=ReturnList.split("^");
	//add by lmm 2019-08-22 begin
	if (listdata=="") var listdata="GetList"
	var encmeth=GetElementValue(listdata);
	//add by lmm 2019-08-22 end
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,inStoreid);
	//alertShow(ReturnList);
	//modified by zy 0111
	var list=gbldata.split(GetElementValue("SplitNumCode"));
	var Listall=list[0];
	rows=list[1];
	//rows=rows-1;
	var PageRows=6;
	var Pages=parseInt(rows / PageRows); //��ҳ��?1  3Ϊÿҳ�̶�����
	var ModRows=rows%PageRows; //���һҳ����
	if (ModRows==0) {Pages=Pages-1;}
	
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	//try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQInStockSP.xls";
	    //alertShow(Template)
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	var sort=31;
	    	//ҽԺ�����滻 Add By DJ 2011-07-14
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	xlsheet.cells(2,2)="��  ��:"+lista[13]; //��ⵥ��
	    	xlsheet.cells(2,7)=ChangeDateFormat(lista[0]);	//�������
	    	xlsheet.cells(2,9)="��  ��:"+GetShortName(lista[sort+0],"-");//�ⷿ
	    	//xlsheet.cells(3,2)="��  ��:"+lista[sort+11];
	    	xlsheet.cells(3,2)="��  ��:"+lista[sort+12];
	    	xlsheet.cells(3,7)=GetShortName(lista[sort+8],"-"); //������
	    	//xlsheet.cells(2,7)=""+lista[sort+12]; //���
	    	//xlsheet.cells(2,10)=GetShortName(lista[sort+9],"-"); //�깺����
	    	//xlsheet.cells(3,7)=ChangeDateFormat(lista[0]);	//�������
	    	//xlsheet.cells(3,9)="��Ӧ��:"+GetShortName(lista[sort+8],"-"); //������
	    	
	   		var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    		
	    	var FeeAll=0;
	    	var Lists=Listall.split(GetElementValue("SplitRowCode"));
	    	for (var j=1;j<=OnePageRow;j++)
			{
				var Listl=Lists[i*PageRows+j];
				var List=Listl.split("^");
				var Row=4+j;
				if ((List[0]=='�ϼ�')&&(i==Pages))
				{
					xlsheet.cells(10,2)=List[0];//�豸����
					xlsheet.cells(10,6)=List[4];//����
					xlsheet.cells(10,8)=List[6];//���
				}
				else
				{
					xlsheet.cells(Row,2)=List[0];//�豸����
					xlsheet.cells(Row,4)=List[2];//����
					xlsheet.cells(Row,5)=List[3];//��λ
					xlsheet.cells(Row,6)=List[4];//����
					xlsheet.cells(Row,7)=List[5];//ԭֵ
					xlsheet.cells(Row,8)=List[6];//���
					xlsheet.cells(Row,9)=List[7];//��Ʊ��
					xlsheet.cells(Row,10)=List[8];//��������
					//xlsheet.cells(Row+5,8)=List[9];//�豸���
					//xlsheet.cells(Row+5,9)=List[10];//��ͬ��				
					//xlsheet.cells(Row+5,10)=List[8];// ��ע
					FeeAll=FeeAll+List[6];
					
					var equipdr=List[11];
					//xlsheet.cells(Row,8)=lista[10];// ��ע
					/*
					//print affix info
					if (""!=equipdr)
					{
						var encmeth=GetElementValue("GetAffixsInfo");
						var affixdata=cspRunServerMethod(encmeth,equipdr);
						var affixinfos=affixdata.split("&");
						var sort=18;
						if (affixinfos.length>0)
						{
							if (affixinfos.length>4)
							{	
								xlsheet.cells(Row,8)=lista[10]+"\n"+"��������,��������б�"
							}
							else
							{
								for (i=0;i<affixinfos.length;i++)
								{
									
									affixinfo=affixinfos[i].split("^");
									xlsheet.cells(Row+i,3)=affixinfo[3];//��������
									xlsheet.cells(Row+i,4)=affixinfo[4];//����
									xlsheet.cells(Row+i,5)=affixinfo[sort+5];//��λ
									xlsheet.cells(Row+i,6)=affixinfo[6];//����
									xlsheet.cells(Row+i,7)=affixinfo[10];//���
								}
							}
						}
					}
					*/
					
				}
					var Row=Row+1;
				
	    	}
	    	
	    	xlsheet.cells(11,9)="�Ƶ���:"+username; //�Ƶ���
	    	//if (lista[19]==2) xlsheet.cells(10,9)=""; //�Ƶ���
	    	
	    	xlsheet.cells(12,10)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ";
	    	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
		    var size=obj.GetPaperInfo("DHCEQInStock");
		    if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    	
	    	xlsheet.printout; 	//��ӡ���
	
	    	//xlApp.Visible=true
    		//xlsheet.PrintPreview();

	    	//xlBook.SaveAs("D:\\InStock"+i+".xls");   //lgl+
	    	xlBook.Close (savechanges=false);
	    	
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	//} 
	//catch(e)
	//{
	//	alertShow(e.message);
	//}
}

///ת�ƴ�ӡ
///modify by lmm 2019-08-21 ������� data listdata
function PrintStoreMoveStandard(storeMoveid,data,listdata)
{
	if (storeMoveid=="") return;
	//add by lmm 2019-08-22 begin
	if (data=="") var data="fillData"
	var encmeth=GetElementValue(data);
	//add by lmm 2019-08-22 end
	if (encmeth=="") return;
	var ReturnList=cspRunServerMethod(encmeth,storeMoveid);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var lista=ReturnList.split("^");
	var movetype=lista[11];
	//alertShow(ReturnList);
	//add by lmm 2019-08-22 begin
	if (listdata=="") var listdata="GetList"
	var encmeth=GetElementValue(listdata);
	//add by lmm 2019-08-22 end
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,storeMoveid);
	//modified by zy 0111
	var list=gbldata.split(GetElementValue("SplitNumCode"));
	var Listall=list[0];
	rows=list[1];
	
	var PageRows=6;//ÿҳ�̶�����
	var Pages=parseInt(rows / PageRows); //��ҳ��-1  
	var ModRows=rows%PageRows; //���һҳ����
	if (ModRows==0) {Pages=Pages-1;}
	
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	
	try {
        var xlApp,xlsheet,xlBook;
	    var Template;
	    if (movetype=="0")
	    	{	Template=TemplatePath+"DHCEQStoreMoveSP.xls";}
	    else
	    	{	Template=TemplatePath+"DHCEQStoreMoveSP1.xls";}

	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
		    xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	/// Mozy0058	2011-8-16
	    	var sort=27;
	    	if (movetype=="3")
	    	{
		    	xlsheet.cells(1,2)="[Hospital]�豸�˿ⵥ"
	    	}
	    	//ҽԺ�����滻 Add By DJ 2011-07-14
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	xlsheet.cells(2,2)="��������:"+GetShortName(lista[sort+0],"-");//��������
	    	xlsheet.cells(3,2)="���ղ���:"+GetShortName(lista[sort+1],"-");//���ղ���
	    	xlsheet.cells(2,7)="��������:"+ChangeDateFormat(lista[4]) ;//lista[4]  //ʱ��	
	    	xlsheet.cells(3,7)="ת�Ƶ���:"+lista[0];  //ƾ����    	
	    	//xlsheet.cells(3,8)="�豸���:"+lista[sort+7] ; //����
	    	//xlsheet.cells(4,2)=lista[sort+10];//ת������
	    	
	    	var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	   		
			for (var Row=1;Row<=OnePageRow;Row++)
			{
				//alertShow(Listall);
				var Lists=Listall.split(GetElementValue("SplitRowCode"));
				var Listl=Lists[i*PageRows+Row];
				var List=Listl.split("^");
				var cellRow=Row+4;
				if (List[0]=='�ϼ�')
				{					
					Row=6;
					cellRow=Row+4;
					xlsheet.cells(cellRow,2)=List[0];//�豸����
					xlsheet.cells(cellRow,5)=List[4];//����
					xlsheet.cells(cellRow,7)=List[7];//�ܼ�

				}
				else
				{
					xlsheet.cells(cellRow,2)=List[0];//�豸����
					//xlsheet.cells(cellRow,2)=List[1];//��������
					xlsheet.cells(cellRow,3)=List[2];//����
					xlsheet.cells(cellRow,4)=List[3];//��λ
					xlsheet.cells(cellRow,5)=List[4];//����
					xlsheet.cells(cellRow,6)=List[5];//ԭֵ
					
					xlsheet.cells(cellRow,7)=List[7];//�ܼ�
					//xlsheet.cells(cellRow,8)=GetShortName(List[11],"-");//��Ӧ��  //List[8];//�豸���
					//xlsheet.cells(cellRow,9)=List[1];//��������  //List[9];//��ͬ��
					xlsheet.cells(cellRow,8)=List[6];//��ע
					//if (movetype!="0") xlsheet.cells(cellRow,10)=List[10];//�������
				}
				
	    	}
	    //xlsheet.cells(PageRows+4,3)=lista[13];//��ע
	    //xlsheet.cells(PageRows+5,8)="�Ƶ���:"+lista[sort+2];
	    
	    //xlsheet.cells(PageRows+5,7)="����:"+ChangeDateFormat(lista[4]);
	    //xlsheet.cells(15,9)=username; //�Ƶ���
	    xlsheet.cells(12,7)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ";   //ʱ��
	    var obj = new ActiveXObject("PaperSet.GetPrintInfo");
		var size=obj.GetPaperInfo("DHCEQInStock");
		if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    
	    xlsheet.printout; //��ӡ���
	    //xlBook.SaveAs("D:\\StoreMove"+i+".xls");   //lgl+
	    //modify by lmm begin 2019-08-23 begin ���ת�Ƶ�ֻ��ӡ��һҳ����
	    //xlBook.Close (savechanges=false);
	    
	    //xlsheet.Quit;
	    //xlsheet=null;
	    //modify by lmm end 2019-08-23 end
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}