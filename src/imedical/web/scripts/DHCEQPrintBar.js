///-----------------------------------------------------------------
/// Modify By DJ 2010-05-31 党军 DJ0045
/// Description:设备卡片指定打印机打印
///Public Overridable Sub PrintOut (From, To, Copies, Preview, ActivePrinter, PrintToFile, Collate, PrToFileName)
///参数说明如下:
///From:	要打印的第一页的页码。如果省略此参数，则打印从第一页开始。
///To:		要打印的最后一页的页码。如果省略此参数，则打印完最后一页后停止打印。
///Copies:	要打印的份数。如果省略此参数，则打印一份副本。
///Preview:	如果为 true，则 Microsoft Office Excel 在打印对象前调用打印预览。如果为 false，则立即打印对象。
///ActivePrinter:设置活动打印机的名称。
///PrintToFile:	为 true 时打印到文件。如果未指定 PrToFileName，则 Excel 将提示用户输入输出文件的名称。
///Collate:	如果为 true，则逐份打印多个副本。
///PrToFileName:如果 PrintToFile 设置为 true，则此参数指定要打印到的文件的名称
///-----------------------------------------------------------------
/*
DHCEQPrintBar.js  包含在需要的组件里面

组件里面添加BPrintBar  按钮
GetEQBarInfo  s val=##Class(%CSP.Page).Encrypt($lb("web.DHCEQSPrint.GetEquipBarInfo"))
PrintBarTitle s val=##class(web.DHCEQInStock).GetSysInfo("990003")
BarPrintName  s val=##class(web.DHCEQInStock).GetSysInfo("990002")

web.DHCEQSPring.cls 里面 GetEquipBarInfo 方法

DHCEQEquip.js,DHCEQOpenCheck.js,DHCEQInStock.js,DHCEQStoreMove.js  打印按钮调用具体的打印函数
*/

///document.write("<object ID='PrinterSet' WIDTH=0 HEIGHT=0 CLASSID='CLSID:C84F0E22-EB1E-4C4E-B8AF-382AFFE6182A' CODEBASE='../addins/client/paperset.CAB#version=1,0,0,0' VIEWASTEXT>");
///document.write("</object>");
///document.write("<object ID='Registry' WIDTH=0 HEIGHT=0 CLASSID='CLSID:F9D509B2-4BA1-49B5-8734-1825CC119A43' CODEBASE='../addins/client/paperset.CAB#version=1,0,0,0' VIEWASTEXT>");
///document.write("</object>");

///出库打印条码
function DHCEQStoreMovePrintBar()
{
	var RowID=GetElementValue("RowID");
	PrintEquipBar(RowID,"StoreMove");
}
///入库打印条码
function DHCEQInStockPrintBar()
{
	var RowID=GetElementValue("RowID");
	PrintEquipBar(RowID,"InStock");		//Modify DJ 2016-07-19
}
///开箱验收管理打印条码
function DHCEQOpenCheckPrintBar()
{
	var RowID=GetElementValue("RowID");
	PrintEquipBar(RowID,"OpenCheck");	//Modify DJ 2016-07-19
}
///台帐管理打印条码
function DHCEQEquipPrintBar()
{
	var RowID=GetElementValue("RowID");
	PrintBars(RowID,"tiaoma","固定资产");
	// Mozy0217  2018-11-01
	OpenCheckListDR=GetElementValue("OpenCheckListDR");
	var encmeth=GetElementValue("GetParentFlag");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,OpenCheckListDR,RowID);
	if (result!="")
	{
	  truthBeTold = window.confirm("该设备有附属设备，是否需要打印附属设备条码");	
	  if (truthBeTold)
		{
			var list=result.split("^");
			var Length=list.length
			for(i=0;i<Length;i++){
		    PrintBarStandard(list[i],"tiaoma","固定资产");	
			}
		}	
	}
}
///根据单据号,单据类型得到条码信息并打印
function PrintEquipBar(No,Type)
{
	if (No=="") return;
	var encmeth=GetElementValue("GetEQBarInfo");
	var Strs=cspRunServerMethod(encmeth,No,Type);
	if (Strs=="")
	{
		alertShow("没有设备信息,无法打印条码!");
		return;
	}
	printManyEquipNo(Strs,Type);
}
///打印多个设备条码Strs为一个字符串  EQNo1,EQName1^EQNO2,EQName2
function printManyEquipNo(Strs,type)
{
	if (Strs=="") return;
	var StrArray=Strs.split("^");
	var i=StrArray.length;
	for (var j=0;j<i;j++)
	{
		var equipinfo=StrArray[j].split(",");
		var equipNo=equipinfo[0];
		var equipName=equipinfo[1];
		var equiprowid=equipinfo[3];
		PrintBarStandard(equiprowid,"tiaoma","固定资产");		//Modify  DJ 2016-07-19
	}
}
///打印单个设备条码 equipno 设备编号 equipname 设备名称
function printOneEquipNo(equipno,equipname)
{
	var printername=GetElementValue("BarPrintName");
	if (printername=="") printername="tiaoma";
	var title=GetElementValue("PrintBarTitle");
	if (title=="") title="固定资产"
	PrintEquipNoAH(printername,title,equipno,equipname);
}
///条用动态库打印条码
function PrintEquipNoAH(printername,title,equipno,equipname)
{
	var Bar= new ActiveXObject("EquipmentBar.PrintBar");
	Bar.PrtName=printername;
	Bar.Title=title;
	Bar.EqName=equipname;
	Bar.EqNo=equipno;
	Bar.FontName="";
	Bar.PrintOut("1");	
	return;
	
	//Bar= new ActiveXObject("DHCEQPrint.PrintBar")
    //Bar.PrintEquipNo(printername,title,equipno,equipname)
    return;
    /*
	Bar= new ActiveXObject("PrintBar.PrnBar")
	Bar.PrintName="tiaoma";
    Bar.SpecNo="ABC1234";
    Bar.RecLoc="设备科";
    Bar.SpecName="血清";
    Bar.PatLoc="检验科";
    Bar.OrdName="生化六项";
    Bar.PatName="张三";
    Bar.Sex="男";
    Bar.Age="21岁";
    Bar.PrintOut();
    */
}

////print Equip Card
function PrintEQCard(rowid)
{	
	///IncludeJs("DHCEQEquipment.js");
	var objEquip=new Equipment(rowid,"");
	if (objEquip.ID=="")
	{
		alertShow("没有找到设备信息!");
		reutrn;
	}
	//PrintEQCardZGYDYY(objEquip)
	PrintEQCardNFYY(objEquip);
	return;
}

////print Equip Card 
function PrintEQCardVerso(rowid)
{
	PrintEQCardVersoZGYDYY(rowid);
}

////print Equip Card 中国医大一院
function PrintEQCardZGYDYY(objEquip)
{
	try 
    {
        var xlApp,xlsheet,xlBook
	    xlApp = new ActiveXObject("Excel.Application");
		var	Template=GetElementValue("GetRepPath")+"DHCEQCard.xls";
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;	    
		
		var Row=2;
		xlsheet.cells(Row,13)=objEquip.No;
		Row=3;
		xlsheet.cells(Row,13)=objEquip.EquiCatCode; 
		Row=6
	    xlsheet.cells(Row,3)=objEquip.Name;
	    xlsheet.cells(Row,13)=objEquip.OriginalFee;
	    Row=Row+1;
	    xlsheet.cells(Row,3)=GetShortName(objEquip.Country,"-");	// Mozy0058	2011-8-16
	    xlsheet.cells(Row,13)="壹"+objEquip.Unit;
	    Row=Row+1;
	    xlsheet.cells(Row,3)=objEquip.Model;
	    xlsheet.cells(Row,13)=objEquip.PurposeType;
	    Row=Row+1;
	    xlsheet.cells(Row,3)=objEquip.LeaveFactoryNo;
	    xlsheet.cells(Row,13)=objEquip.Origin;
	    Row=Row+1;
	    xlsheet.cells(Row,3)=objEquip.ManuFactory;
	    xlsheet.cells(Row,13)=objEquip.Hold1;
	    Row=Row+1;
	    xlsheet.cells(Row,3)=GetShortName(objEquip.Provider,"-");
	    xlsheet.cells(Row,13)=FormatDate(objEquip.TransAssetDate,"","");
	    //xlsheet.cells(Row,13)=objEquip.InStockDate;
	    Row=Row+1;
	    xlsheet.cells(Row,3)=GetShortName(objEquip.UseLoc,"-");
	    xlsheet.cells(Row,13)=FormatDate(objEquip.StartDate,"","");
	    Row=Row+1;
	    xlsheet.cells(Row,3)=objEquip.Remark;
	    
	    var encmeth=GetElementValue("GetCurTime")
		var curTime=cspRunServerMethod(encmeth);
		Row=Row+2;
	    xlsheet.cells(Row,14)=curTime;
	    	    
	    xlApp.Visible=true
		xlsheet.PrintPreview();
		xlsheet.cells(2,16)="副";
		xlsheet.PrintPreview();
	    //xlBook.printout;
	    ///xlBook.SaveAs("D:\\cgeqipsq.xls");
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	}
	catch(e)
	{	 alertShow(e.message);	 }
	
	return;	
}

////print Equip Card 
function PrintEQCardVersoZGYDYY(rowid)
{
	var pageRows=14;
	var row,page;
	var	Template=GetElementValue("GetRepPath")+"DHCEQCardVerso.xls";
	var encmeth=GetElementValue("GetAffixInfo")
	var result=cspRunServerMethod(encmeth,rowid);
	if (rowid=="")
	{
		alertShow("没有找到设备信息!");
		return;
	}
	var page=1;
	var row=1;
	try 
    {
        var xlApp,xlsheet,xlBook
	    xlApp = new ActiveXObject("Excel.Application");
	    //print affix info
	    if (result!="")
		{
			var rowinfos=result.split("&");
			var rows=rowinfos.length;
			for (i=0;i<rows;i++)
	    	{
		    	row=row+1;
		    	if (row>pageRows) 
		    	{
			    	xlsheet.printout; //打印输出
	    			//xlBook.SaveAs("D:\\Return"+i+".xls");   //lgl+
	    			xlBook.Close (savechanges=false);	    
	   				xlsheet.Quit;
	    			xlsheet=null;
			    	row=2;			    	
		    	}
		    	if (2==row)
		    	{
		    		xlBook = xlApp.Workbooks.Add(Template);
	    			xlsheet = xlBook.ActiveSheet;
	    			//xlsheet.Range("B2:G2").merge();//合并单元格
	    			//xlsheet.Range("B2:G2").value="附件及配套构成";
	    			//xlsheet.Range("B2:G2").HorizontalAlignment=3; //居中对齐
	    			//xlsheet.Range("B2:G2").Font.Bold = true;  // 粗体
	    			//xlsheet.Range("B2:G2").Font.Size=14;
	    			row=row+2;	   
	    			//xlsheet.Range(xlsheet.Cells(row+1,2),xlsheet.Cells(row+1,6)).mergecells=true;//合并单元格 
	    			//xlsheet.Range(xlsheet.Cells(row+1,2),xlsheet.Cells(row+1,6)).value="附件及配套构成";
	    			//xlsheet.Range(xlsheet.Cells(row+1,2),xlsheet.Cells(row+1,6)).Font.Size=16;
			    }
		    	
		    	var sort=18;
		    	var colinfo=rowinfos[i].split("^");
		    	xlsheet.cells(row,2)=i+1;
		    	xlsheet.cells(row,3)=colinfo[3];	// Mozy0058	2011-8-16
		    	xlsheet.cells(row,4)=colinfo[4];		    	
		    	xlsheet.cells(row,5).NumberFormatLocal = "@";
		    	xlsheet.cells(row,5).HorizontalAlignment=1; //居左对齐
		    	xlsheet.cells(row,5)=colinfo[sort+19];		// Mozy		2017-10-9	461053
		    	xlsheet.cells(row,6)=colinfo[6];
		    	xlsheet.cells(row,7).NumberFormatLocal = "0.00_ ";
		    	xlsheet.cells(row,7)=colinfo[10];
		    	
	    	}
    	}
	    //print changeaccount info
	    var encmeth=GetElementValue("GetChangeAccount")
		var result=cspRunServerMethod(encmeth,rowid);
	    if (result!="")
		{
			row=row+1;
			if (row>pageRows)
			{
				xlsheet.printout; //打印输出
	    		xlBook.Close (savechanges=false);	    
	   			xlsheet.Quit;
	    		xlsheet=null;
			    row=2;
			    xlBook = xlApp.Workbooks.Add(Template);
	    		xlsheet = xlBook.ActiveSheet;			
			}
			if (!xlsheet)
			{
				xlBook = xlApp.Workbooks.Add(Template);
	    		xlsheet = xlBook.ActiveSheet;
			}
			xlsheet.Range(xlsheet.Cells(row,2),xlsheet.Cells(row,7)).mergecells=true;//合并单元格 
			//xlsheet.Range(xlsheet.Cells(row,2),xlsheet.Cells(row,7)).Borders(8).Weight = 4;	
			
			xlsheet.cells(row,2)="设备调账记录";
			xlsheet.cells(row,2).HorizontalAlignment=3; //居中对齐
			xlsheet.cells(row,2).Font.Bold = true;  // 粗体
			xlsheet.cells(row,2).Font.Size=14;
			row=row+1;
			xlsheet.Range(xlsheet.Cells(row,2),xlsheet.Cells(row,7)).HorizontalAlignment=3; //居中对齐
			xlsheet.cells(row,2)="序号";
			xlsheet.cells(row,3)="调前原值";
			xlsheet.cells(row,4)="调整日期";
			xlsheet.cells(row,5)="调整金额";
			xlsheet.cells(row,6)="调整原因";
			xlsheet.cells(row,7)="调后原值";
	    			
			var rowinfos=result.split("&");
			var rows=rowinfos.length;
			for (i=0;i<rows;i++)
	    	{
		    	row=row+1;
		    	if (row>pageRows) 
		    	{
			    	xlsheet.printout; //打印输出
	    			//xlBook.SaveAs("D:\\Return"+i+".xls");   //lgl+
	    			xlBook.Close (savechanges=false);	    
	   				xlsheet.Quit;
	    			xlsheet=null;
			    	row=2;			    	
		    	}
		    	if (2==row)
		    	{
		    		xlBook = xlApp.Workbooks.Add(Template);
	    			xlsheet = xlBook.ActiveSheet;
					xlsheet.Range(xlsheet.Cells(row,2),xlsheet.Cells(row,7)).mergecells=true;//合并单元格 
					xlsheet.cells(row,2)="设备调账记录";
					xlsheet.cells(row,2).HorizontalAlignment=3; //居中对齐
					xlsheet.cells(row,2).Font.Bold = true;  // 粗体
					xlsheet.cells(row,2).Font.Size=14;
					row=row+1;
					xlsheet.cells(row,2)="序号";
					xlsheet.cells(row,3)="调前原值";
					xlsheet.cells(row,4)="调整日期";
					xlsheet.cells(row,5)="调整金额";
					xlsheet.cells(row,6)="调整原因";
					xlsheet.cells(row,7)="调后原值";
					row=row+1;
			    }
		    	
		    	var sort=27;
		    	var colinfo=rowinfos[i].split("^");
		    	xlsheet.cells(row,2)=i+1;
		    	xlsheet.cells(row,3).HorizontalAlignment=1; //居右对齐
		    	xlsheet.cells(row,3)=colinfo[23];
		    	xlsheet.cells(row,4).HorizontalAlignment=1; //居右对齐
		    	xlsheet.cells(row,4)=colinfo[8];		    	
		    	xlsheet.cells(row,5).NumberFormatLocal = "0.00_ ";
		    	xlsheet.cells(row,5)=colinfo[1];
		    	xlsheet.cells(row,6).HorizontalAlignment=2; //居左对齐
		    	xlsheet.cells(row,6)=colinfo[7];
		    	xlsheet.cells(row,7).NumberFormatLocal = "0.00_ ";
		    	xlsheet.cells(row,7)=colinfo[2];
	    	}
    	}
	    
	    //预览
	    if (!xlsheet)
	    {
			xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    }
	    xlApp.Visible=true
		xlsheet.PrintPreview();
		xlApp.Visible=true;// 20150902 第二次打印
		xlsheet.PrintPreview();

	    //xlBook.SaveAs("D:\\cgeqipsq.xls");
	    xlsheet.Quit;
	    xlsheet=null;
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;	    
	}
	catch(e)
	{	 alertShow(e.message);	 }
	
	return;	
}

function PrintBars(rowids,printerName,title)
{
	if (rowids=="") return;
	var arrRowId=rowids.split(",");
	var len=arrRowId.length;
	for (i=0;i<len;i++)
	{
		PrintBarStandard(arrRowId[i],printerName,title);		//Modify DJ 2016-07-19
	}
}

function PrintBarStandard(rowid,printerName,title)
{
	if (rowid=="") return;
	var objEquip=new Equipment(rowid,"");
	if (objEquip.ID=="")
	{
		alertShow("没有找到设备信息!");
		return;
	}
	var Bar=new ActiveXObject("EquipmentBar.PrintBar")
	Bar.PrtName="DHCEQBarCode";	//打印机名称
	Bar.Title=objEquip.Hospital;
	Bar.FontName="";
	Bar.EqName=objEquip.Name;
	//Bar.EqName=objEquip.Item;	//南方医打印设备项名称	
	Bar.EqNo=objEquip.No;
	Bar.FileNo = objEquip.FileNo;
	Bar.OriginalFee=objEquip.OriginalFee;
	Bar.Model=objEquip.Model;	
	Bar.LocName=GetShortName(objEquip.StoreLoc,"-");
	Bar.StartDate=FormatDate(objEquip.StartDate,"","");
	Bar.Factory=objEquip.ManuFactory;	
	Bar.FacNo=objEquip.LeaveFactoryNo;
	Bar.Location=objEquip.Location;	
	Bar.InDate=FormatDate(objEquip.TransAssetDate,"","");
	Bar.Left=150;
	Bar.Top=500;
	//var qrcode	= new QRCode(6, QRErrorCorrectLevel.H);//每条边格子数 17+3*4,纠错级别
	var ValueStr="fileno:"+objEquip.FileNo+",no:"+objEquip.No;
	var type=getTypeNumber(ValueStr,QRErrorCorrectLevel.Q);

	var qrcode	= new QRCode(type, QRErrorCorrectLevel.Q);//每条边格子数 17+3*4,纠错级别
	ValueStr=utf16to8(ValueStr);
	qrcode.addData(ValueStr);
	qrcode.make();	
	var TempCode=""
	for (var i=0;i<qrcode.modules.length;i++)
	{
		for (var j=0;j<qrcode.modules.length;j++)
		{
			TempCode+=String(Number(qrcode.modules[i][j]))
		}
	}
	Bar.QRCode=TempCode
	Bar.PrintOut("1")
	//登记已打印条码标志,可屏蔽
	var encmeth=GetElementValue("SaveOperateLog");
	if (encmeth=="") return;
	cspRunServerMethod(encmeth,"^52^"+rowid,2);
}
////print Equip Card 南方医院
function PrintEQCardNFYY(objEquip,Template)
{
	try 
    {
        var xlApp,xlsheet,xlBook
	    xlApp = new ActiveXObject("Excel.Application");
		var	Template=GetElementValue("GetRepPath")+"DHCEQCardNF.xls";
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
		xlsheet.cells(1,2)=""
		xlsheet.cells(1,7)=objEquip.FileNo;
		xlsheet.cells(2,7)=objEquip.No; 
		var Row=3;
	    xlsheet.cells(Row,3)=GetShortName(objEquip.UseLoc,"-");
	    xlsheet.cells(Row,7)=objEquip.Location;
	    Row=Row+1;
	    xlsheet.cells(Row,3)=objEquip.Name;
	    xlsheet.cells(Row,7)=objEquip.Model;
	    Row=Row+1;
	    xlsheet.cells(Row,3)=objEquip.ManuFactory;
	    xlsheet.cells(Row,7)=objEquip.LeaveFactoryNo;
	    Row=Row+1;
	    xlsheet.cells(Row,3)=GetShortName(objEquip.Provider,"-");
	    xlsheet.cells(Row,7)=FormatDate(objEquip.LeaveFactoryDate,"","");
	    Row=Row+1;
	    xlsheet.cells(Row,3)=objEquip.OriginalFee;
	    xlsheet.cells(Row,7)=objEquip.Expenditures;
	    Row=Row+1;
	    xlsheet.cells(Row,3)=objEquip.Hold1;
	    xlsheet.cells(Row,7)=FormatDate(objEquip.StartDate,"","");
	    //xlsheet.cells(Row,13)=objEquip.InStockDate;
	    Row=Row+1;
	    xlsheet.cells(Row,3)=objEquip.Remark;
	    
	    //var encmeth=GetElementValue("GetCurTime");
		var encmeth=GetElementValue("GetCurDate");
		var curTime=cspRunServerMethod(encmeth);
		Row=Row+1;
	    xlsheet.cells(Row,8)=xlsheet.cells(Row,8)+FormatDate(curTime,"","");
	    	    
	    xlApp.Visible=true
		xlsheet.PrintPreview();
		xlsheet.cells(1,8)="副";
		xlsheet.PrintPreview();
	    //xlBook.printout;
	    ///xlBook.SaveAs("D:\\cgeqipsq.xls");
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	}
	catch(e)
	{	 alertShow(e.message);	 }
	
	return;	
}
function utf16to8(str) 
{  
        var out, i, len, c;  
        out = "";  
        len = str.length;  
        for(i = 0; i < len; i++) {  
        c = str.charCodeAt(i);  
        if ((c >= 0x0001) && (c <= 0x007F)) {  
            out += str.charAt(i);  
        } else if (c > 0x07FF) {  
            out += String.fromCharCode(0xE0 | ((c >> 12) & 0x0F));  
            out += String.fromCharCode(0x80 | ((c >>  6) & 0x3F));  
            out += String.fromCharCode(0x80 | ((c >>  0) & 0x3F));  
        } else {  
            out += String.fromCharCode(0xC0 | ((c >>  6) & 0x1F));  
            out += String.fromCharCode(0x80 | ((c >>  0) & 0x3F));  
        }  
        }  
        return out;  
}
/// 打印配件标签(二维码)
function DHCEQPrintAFQrcode(rowid,PrtName,affixrowid)
{
	if ((rowid=="")||(affixrowid=="")) return;
	var objEquip=new Equipment(rowid,"");
	if (objEquip.ID=="")
	{
		alertShow("没有找到设备信息!");
		return;
	}
	var QRMaker=new ActiveXObject("EquipmentBar.PrintBar")
	QRMaker.PrtName="DHCEQBarCode";	//打印机名称
	QRMaker.FontName="";
	QRMaker.Title=objEquip.Hospital;
	//QRMaker.EqName=objEquip.Name;
	QRMaker.EqName=objEquip.Item;
	QRMaker.EqNo=objEquip.No;
	QRMaker.FileNo = objEquip.FileNo;
	QRMaker.OriginalFee=objEquip.OriginalFee;
	QRMaker.Model=objEquip.Model;
	QRMaker.LocName=GetShortName(objEquip.StoreLoc,"-");
	QRMaker.StartDate=FormatDate(objEquip.StartDate,"","");
	//QRMaker.Factory=objEquip.ManuFactory;
	//QRMaker.FacNo=objEquip.LeaveFactoryNo;
	
	//// 附件信息
	var encmeth=GetElementValue("GetAffixData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',affixrowid);
	var list=gbldata.split("^");
	var sort=29;
	QRMaker.Affix=list[3];
	QRMaker.AffixFac=list[sort+3];
	QRMaker.Model=list[4];
	QRMaker.FacNo=list[8];
	if (list[sort+8]!="") QRMaker.FacNo=list[sort+8];
	QRMaker.Left=150;
	QRMaker.Top=500;
	var qrcode	= new QRCode(6, QRErrorCorrectLevel.H);//每条边格子数 17+3*4,纠错级别
	var ValueStr="fileno:"+objEquip.FileNo+",no:"+objEquip.No;
	ValueStr=utf16to8(ValueStr);
	qrcode.addData(ValueStr);
	qrcode.make();	
	var TempCode=""
	for (var i=0;i<qrcode.modules.length;i++)
		for (var j=0;j<qrcode.modules.length;j++)
			TempCode+=String(Number(qrcode.modules[i][j]))
	QRMaker.QRCode=TempCode;
	QRMaker.PrintOutAffix("1");
}
/// 20170109 Mozy0176
function getTypeNumber(sText, nCorrectLevel)
{
	var nType = 1;
	var length = sText.length;
	
	for (var i = 0, len = QRCodeLimitLength.length; i <= len; i++)
	{
		var nLimit = 0;
		
		switch (nCorrectLevel) {
			case QRErrorCorrectLevel.L :
				nLimit = QRCodeLimitLength[i][0];
				break;
			case QRErrorCorrectLevel.M :
				nLimit = QRCodeLimitLength[i][1];
				break;
			case QRErrorCorrectLevel.Q :
				nLimit = QRCodeLimitLength[i][2];
				break;
				case QRErrorCorrectLevel.H :
				nLimit = QRCodeLimitLength[i][3];
				break;
		}
		
		if (length <= nLimit)
		{
			break;
		} else {
			nType++;
		}
	}
	
	if (nType > QRCodeLimitLength.length)
	{
		throw new Error("Too long data");
	}
	
	return nType;
}