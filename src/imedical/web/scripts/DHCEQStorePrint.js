///退货打印
function PrintReturn(returnid)
{	
	PrintReturnStandard(returnid);
	return;
}

///转移打印
function PrintStoreMove(storeMoveid)
{
	PrintStoreMoveStandard(storeMoveid);
	return;
}
///入库打印
function PrintInStore(inStoreid)
{
	PrintInStoreStandard(inStoreid);
	return;
}

///退货打印
function PrintReturnStandard(returnid)
{
	if (returnid=="") return;
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var ReturnList=cspRunServerMethod(encmeth,returnid);
	
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var lista=ReturnList.split("^");
	
	//alertShow(ReturnList);
	//获取单子信息
	var sort=28; //2011-03-10 DJ
	var OutTypeDR=lista[16];	
	var OutType=lista[sort+7];
	var No=lista[0];  //凭单号
	var EquipType=lista[sort+5] ; //类组
	var FromLoc=GetShortName(lista[sort+0],"-");//退货部门
	if (OutTypeDR!=1)
	{	var ToDept=GetShortName(lista[sort+8],"-");}	//去向
	else
	{	var ToDept=GetShortName(lista[sort+1],"-");} 	//供应商
	var Maker=lista[sort+2];//制单人
	var ReturnDate=FormatDate(lista[3]);//减少日期
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
	var PageRows=6; //每页固定行数
	var Pages=parseInt(rows / PageRows); //总页数-1  
	var ModRows=rows%PageRows; //最后一页行数
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
	    	//医院名称替换 Add By DJ 2011-07-14
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	xlsheet.cells(2,2)=No;  //凭单号
	    	xlsheet.cells(2,6)=ReturnDate;  //减少日期
	    	xlsheet.cells(2,8)=EquipType; //类组
	    	xlsheet.cells(3,2)=FromLoc;//退货部门
	    	if (OutTypeDR==1)
	    	{
		    	xlsheet.cells(3,6)=ToDept;//供应商
	    	}
	    	else
	    	{
		    	xlsheet.cells(3,6)=OutType;  //减少类型
		    	xlsheet.cells(3,8)=ToDept;//供应商
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
					xlsheet.cells(Row+4,1)="合计";//设备名称
					xlsheet.cells(Row+4,4)=sumQty;//数量
					xlsheet.cells(Row+4,6)=sumFee;//总价
				}
				else
				{
				var RLID=RLList[Location];
				var Data=cspRunServerMethod(encmeth,RLID);
				var List=Data.split("^");
				//xlsheet.Rows(Row+5).Insert();
				xlsheet.cells(Row+4,1)=List[sort+4];//设备名称
				//xlsheet.cells(Row+5,2)=List[1];//生产厂商
				xlsheet.cells(Row+4,2)=List[sort+5];//机型
				xlsheet.cells(Row+4,3)=List[sort+8];//单位
				xlsheet.cells(Row+4,4)=List[4];//数量
				xlsheet.cells(Row+4,5)=List[5];//原值
				var FeeAllm=List[4]*List[5];
				xlsheet.cells(Row+4,6)=FeeAllm;//总价
				
				//xlsheet.cells(Row+4,7)=List[sort+9];//发票号
				xlsheet.cells(Row+4,7)=List[sort+10];//设备编号
				
				//xlsheet.cells(Row+4,9)=List[sort+11];//合同号
				//xlsheet.cells(Row+4,10)=List[sort+3];//退货原因
				xlsheet.cells(Row+4,8)=List[8];//备注
				FeeAll=FeeAll+FeeAllm;
				sumFee=sumFee+FeeAllm;
				sumQty=sumQty+List[4]*1;
				}				
	    	}
	    //xlsheet.cells(OnePageRow+7,7)="制单人:"+Maker;
	    //xlsheet.Rows(OnePageRow+6).Delete();	    
	    //xlsheet.cells(OnePageRow+9,2)=ReturnDate;
	    //xlsheet.cells(OnePageRow+9,6)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";   //时间
	    xlsheet.cells(11,8)="制单人:"+Maker;
	    xlsheet.cells(12,8)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";     
    	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
	    var size=obj.GetPaperInfo("DHCEQInStock");
	    if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    xlsheet.printout; //打印输出
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


///入库打印
///modify by lmm 2019-08-21 增加入参 data listdata
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
	var Pages=parseInt(rows / PageRows); //总页数?1  3为每页固定行数
	var ModRows=rows%PageRows; //最后一页行数
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
	    	//医院名称替换 Add By DJ 2011-07-14
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	xlsheet.cells(2,2)="单  号:"+lista[13]; //入库单号
	    	xlsheet.cells(2,7)=ChangeDateFormat(lista[0]);	//入库日期
	    	xlsheet.cells(2,9)="库  房:"+GetShortName(lista[sort+0],"-");//库房
	    	//xlsheet.cells(3,2)="类  组:"+lista[sort+11];
	    	xlsheet.cells(3,2)="类  型:"+lista[sort+12];
	    	xlsheet.cells(3,7)=GetShortName(lista[sort+8],"-"); //供货商
	    	//xlsheet.cells(2,7)=""+lista[sort+12]; //类别
	    	//xlsheet.cells(2,10)=GetShortName(lista[sort+9],"-"); //申购科室
	    	//xlsheet.cells(3,7)=ChangeDateFormat(lista[0]);	//入库日期
	    	//xlsheet.cells(3,9)="供应商:"+GetShortName(lista[sort+8],"-"); //供货商
	    	
	   		var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    		
	    	var FeeAll=0;
	    	var Lists=Listall.split(GetElementValue("SplitRowCode"));
	    	for (var j=1;j<=OnePageRow;j++)
			{
				var Listl=Lists[i*PageRows+j];
				var List=Listl.split("^");
				var Row=4+j;
				if ((List[0]=='合计')&&(i==Pages))
				{
					xlsheet.cells(10,2)=List[0];//设备名称
					xlsheet.cells(10,6)=List[4];//数量
					xlsheet.cells(10,8)=List[6];//金额
				}
				else
				{
					xlsheet.cells(Row,2)=List[0];//设备名称
					xlsheet.cells(Row,4)=List[2];//机型
					xlsheet.cells(Row,5)=List[3];//单位
					xlsheet.cells(Row,6)=List[4];//数量
					xlsheet.cells(Row,7)=List[5];//原值
					xlsheet.cells(Row,8)=List[6];//金额
					xlsheet.cells(Row,9)=List[7];//发票号
					xlsheet.cells(Row,10)=List[8];//生产厂商
					//xlsheet.cells(Row+5,8)=List[9];//设备编号
					//xlsheet.cells(Row+5,9)=List[10];//合同号				
					//xlsheet.cells(Row+5,10)=List[8];// 备注
					FeeAll=FeeAll+List[6];
					
					var equipdr=List[11];
					//xlsheet.cells(Row,8)=lista[10];// 备注
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
								xlsheet.cells(Row,8)=lista[10]+"\n"+"附件过多,请见附件列表"
							}
							else
							{
								for (i=0;i<affixinfos.length;i++)
								{
									
									affixinfo=affixinfos[i].split("^");
									xlsheet.cells(Row+i,3)=affixinfo[3];//附件名称
									xlsheet.cells(Row+i,4)=affixinfo[4];//机型
									xlsheet.cells(Row+i,5)=affixinfo[sort+5];//单位
									xlsheet.cells(Row+i,6)=affixinfo[6];//数量
									xlsheet.cells(Row+i,7)=affixinfo[10];//金额
								}
							}
						}
					}
					*/
					
				}
					var Row=Row+1;
				
	    	}
	    	
	    	xlsheet.cells(11,9)="制单人:"+username; //制单人
	    	//if (lista[19]==2) xlsheet.cells(10,9)=""; //制单人
	    	
	    	xlsheet.cells(12,10)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";
	    	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
		    var size=obj.GetPaperInfo("DHCEQInStock");
		    if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    	
	    	xlsheet.printout; 	//打印输出
	
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

///转移打印
///modify by lmm 2019-08-21 增加入参 data listdata
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
	
	var PageRows=6;//每页固定行数
	var Pages=parseInt(rows / PageRows); //总页数-1  
	var ModRows=rows%PageRows; //最后一页行数
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
		    	xlsheet.cells(1,2)="[Hospital]设备退库单"
	    	}
	    	//医院名称替换 Add By DJ 2011-07-14
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	xlsheet.cells(2,2)="供给部门:"+GetShortName(lista[sort+0],"-");//供给部门
	    	xlsheet.cells(3,2)="接收部门:"+GetShortName(lista[sort+1],"-");//接收部门
	    	xlsheet.cells(2,7)="出库日期:"+ChangeDateFormat(lista[4]) ;//lista[4]  //时间	
	    	xlsheet.cells(3,7)="转移单号:"+lista[0];  //凭单号    	
	    	//xlsheet.cells(3,8)="设备类别:"+lista[sort+7] ; //类型
	    	//xlsheet.cells(4,2)=lista[sort+10];//转移类型
	    	
	    	var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	   		
			for (var Row=1;Row<=OnePageRow;Row++)
			{
				//alertShow(Listall);
				var Lists=Listall.split(GetElementValue("SplitRowCode"));
				var Listl=Lists[i*PageRows+Row];
				var List=Listl.split("^");
				var cellRow=Row+4;
				if (List[0]=='合计')
				{					
					Row=6;
					cellRow=Row+4;
					xlsheet.cells(cellRow,2)=List[0];//设备名称
					xlsheet.cells(cellRow,5)=List[4];//数量
					xlsheet.cells(cellRow,7)=List[7];//总价

				}
				else
				{
					xlsheet.cells(cellRow,2)=List[0];//设备名称
					//xlsheet.cells(cellRow,2)=List[1];//生产厂商
					xlsheet.cells(cellRow,3)=List[2];//机型
					xlsheet.cells(cellRow,4)=List[3];//单位
					xlsheet.cells(cellRow,5)=List[4];//数量
					xlsheet.cells(cellRow,6)=List[5];//原值
					
					xlsheet.cells(cellRow,7)=List[7];//总价
					//xlsheet.cells(cellRow,8)=GetShortName(List[11],"-");//供应商  //List[8];//设备编号
					//xlsheet.cells(cellRow,9)=List[1];//生产厂商  //List[9];//合同号
					xlsheet.cells(cellRow,8)=List[6];//备注
					//if (movetype!="0") xlsheet.cells(cellRow,10)=List[10];//入库日期
				}
				
	    	}
	    //xlsheet.cells(PageRows+4,3)=lista[13];//备注
	    //xlsheet.cells(PageRows+5,8)="制单人:"+lista[sort+2];
	    
	    //xlsheet.cells(PageRows+5,7)="日期:"+ChangeDateFormat(lista[4]);
	    //xlsheet.cells(15,9)=username; //制单人
	    xlsheet.cells(12,7)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";   //时间
	    var obj = new ActiveXObject("PaperSet.GetPrintInfo");
		var size=obj.GetPaperInfo("DHCEQInStock");
		if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    
	    xlsheet.printout; //打印输出
	    //xlBook.SaveAs("D:\\StoreMove"+i+".xls");   //lgl+
	    //modify by lmm begin 2019-08-23 begin 解决转移单只打印第一页问题
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