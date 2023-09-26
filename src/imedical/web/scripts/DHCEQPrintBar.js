///-----------------------------------------------------------------
/// Modify By DJ 2010-05-31 ���� DJ0045
/// Description:�豸��Ƭָ����ӡ����ӡ
///Public Overridable Sub PrintOut (From, To, Copies, Preview, ActivePrinter, PrintToFile, Collate, PrToFileName)
///����˵������:
///From:	Ҫ��ӡ�ĵ�һҳ��ҳ�롣���ʡ�Դ˲��������ӡ�ӵ�һҳ��ʼ��
///To:		Ҫ��ӡ�����һҳ��ҳ�롣���ʡ�Դ˲��������ӡ�����һҳ��ֹͣ��ӡ��
///Copies:	Ҫ��ӡ�ķ��������ʡ�Դ˲��������ӡһ�ݸ�����
///Preview:	���Ϊ true���� Microsoft Office Excel �ڴ�ӡ����ǰ���ô�ӡԤ�������Ϊ false����������ӡ����
///ActivePrinter:���û��ӡ�������ơ�
///PrintToFile:	Ϊ true ʱ��ӡ���ļ������δָ�� PrToFileName���� Excel ����ʾ�û���������ļ������ơ�
///Collate:	���Ϊ true������ݴ�ӡ���������
///PrToFileName:��� PrintToFile ����Ϊ true����˲���ָ��Ҫ��ӡ�����ļ�������
///-----------------------------------------------------------------
/*
DHCEQPrintBar.js  ��������Ҫ���������

����������BPrintBar  ��ť
GetEQBarInfo  s val=##Class(%CSP.Page).Encrypt($lb("web.DHCEQSPrint.GetEquipBarInfo"))
PrintBarTitle s val=##class(web.DHCEQInStock).GetSysInfo("990003")
BarPrintName  s val=##class(web.DHCEQInStock).GetSysInfo("990002")

web.DHCEQSPring.cls ���� GetEquipBarInfo ����

DHCEQEquip.js,DHCEQOpenCheck.js,DHCEQInStock.js,DHCEQStoreMove.js  ��ӡ��ť���þ���Ĵ�ӡ����
*/

///document.write("<object ID='PrinterSet' WIDTH=0 HEIGHT=0 CLASSID='CLSID:C84F0E22-EB1E-4C4E-B8AF-382AFFE6182A' CODEBASE='../addins/client/paperset.CAB#version=1,0,0,0' VIEWASTEXT>");
///document.write("</object>");
///document.write("<object ID='Registry' WIDTH=0 HEIGHT=0 CLASSID='CLSID:F9D509B2-4BA1-49B5-8734-1825CC119A43' CODEBASE='../addins/client/paperset.CAB#version=1,0,0,0' VIEWASTEXT>");
///document.write("</object>");

///�����ӡ����
function DHCEQStoreMovePrintBar()
{
	var RowID=GetElementValue("RowID");
	PrintEquipBar(RowID,"StoreMove");
}
///����ӡ����
function DHCEQInStockPrintBar()
{
	var RowID=GetElementValue("RowID");
	PrintEquipBar(RowID,"InStock");		//Modify DJ 2016-07-19
}
///�������չ����ӡ����
function DHCEQOpenCheckPrintBar()
{
	var RowID=GetElementValue("RowID");
	PrintEquipBar(RowID,"OpenCheck");	//Modify DJ 2016-07-19
}
///̨�ʹ����ӡ����
function DHCEQEquipPrintBar()
{
	var RowID=GetElementValue("RowID");
	PrintBars(RowID,"tiaoma","�̶��ʲ�");
	// Mozy0217  2018-11-01
	OpenCheckListDR=GetElementValue("OpenCheckListDR");
	var encmeth=GetElementValue("GetParentFlag");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,OpenCheckListDR,RowID);
	if (result!="")
	{
	  truthBeTold = window.confirm("���豸�и����豸���Ƿ���Ҫ��ӡ�����豸����");	
	  if (truthBeTold)
		{
			var list=result.split("^");
			var Length=list.length
			for(i=0;i<Length;i++){
		    PrintBarStandard(list[i],"tiaoma","�̶��ʲ�");	
			}
		}	
	}
}
///���ݵ��ݺ�,�������͵õ�������Ϣ����ӡ
function PrintEquipBar(No,Type)
{
	if (No=="") return;
	var encmeth=GetElementValue("GetEQBarInfo");
	var Strs=cspRunServerMethod(encmeth,No,Type);
	if (Strs=="")
	{
		alertShow("û���豸��Ϣ,�޷���ӡ����!");
		return;
	}
	printManyEquipNo(Strs,Type);
}
///��ӡ����豸����StrsΪһ���ַ���  EQNo1,EQName1^EQNO2,EQName2
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
		PrintBarStandard(equiprowid,"tiaoma","�̶��ʲ�");		//Modify  DJ 2016-07-19
	}
}
///��ӡ�����豸���� equipno �豸��� equipname �豸����
function printOneEquipNo(equipno,equipname)
{
	var printername=GetElementValue("BarPrintName");
	if (printername=="") printername="tiaoma";
	var title=GetElementValue("PrintBarTitle");
	if (title=="") title="�̶��ʲ�"
	PrintEquipNoAH(printername,title,equipno,equipname);
}
///���ö�̬���ӡ����
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
    Bar.RecLoc="�豸��";
    Bar.SpecName="Ѫ��";
    Bar.PatLoc="�����";
    Bar.OrdName="��������";
    Bar.PatName="����";
    Bar.Sex="��";
    Bar.Age="21��";
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
		alertShow("û���ҵ��豸��Ϣ!");
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

////print Equip Card �й�ҽ��һԺ
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
	    xlsheet.cells(Row,13)="Ҽ"+objEquip.Unit;
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
		xlsheet.cells(2,16)="��";
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
		alertShow("û���ҵ��豸��Ϣ!");
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
			    	xlsheet.printout; //��ӡ���
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
	    			//xlsheet.Range("B2:G2").merge();//�ϲ���Ԫ��
	    			//xlsheet.Range("B2:G2").value="���������׹���";
	    			//xlsheet.Range("B2:G2").HorizontalAlignment=3; //���ж���
	    			//xlsheet.Range("B2:G2").Font.Bold = true;  // ����
	    			//xlsheet.Range("B2:G2").Font.Size=14;
	    			row=row+2;	   
	    			//xlsheet.Range(xlsheet.Cells(row+1,2),xlsheet.Cells(row+1,6)).mergecells=true;//�ϲ���Ԫ�� 
	    			//xlsheet.Range(xlsheet.Cells(row+1,2),xlsheet.Cells(row+1,6)).value="���������׹���";
	    			//xlsheet.Range(xlsheet.Cells(row+1,2),xlsheet.Cells(row+1,6)).Font.Size=16;
			    }
		    	
		    	var sort=18;
		    	var colinfo=rowinfos[i].split("^");
		    	xlsheet.cells(row,2)=i+1;
		    	xlsheet.cells(row,3)=colinfo[3];	// Mozy0058	2011-8-16
		    	xlsheet.cells(row,4)=colinfo[4];		    	
		    	xlsheet.cells(row,5).NumberFormatLocal = "@";
		    	xlsheet.cells(row,5).HorizontalAlignment=1; //�������
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
				xlsheet.printout; //��ӡ���
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
			xlsheet.Range(xlsheet.Cells(row,2),xlsheet.Cells(row,7)).mergecells=true;//�ϲ���Ԫ�� 
			//xlsheet.Range(xlsheet.Cells(row,2),xlsheet.Cells(row,7)).Borders(8).Weight = 4;	
			
			xlsheet.cells(row,2)="�豸���˼�¼";
			xlsheet.cells(row,2).HorizontalAlignment=3; //���ж���
			xlsheet.cells(row,2).Font.Bold = true;  // ����
			xlsheet.cells(row,2).Font.Size=14;
			row=row+1;
			xlsheet.Range(xlsheet.Cells(row,2),xlsheet.Cells(row,7)).HorizontalAlignment=3; //���ж���
			xlsheet.cells(row,2)="���";
			xlsheet.cells(row,3)="��ǰԭֵ";
			xlsheet.cells(row,4)="��������";
			xlsheet.cells(row,5)="�������";
			xlsheet.cells(row,6)="����ԭ��";
			xlsheet.cells(row,7)="����ԭֵ";
	    			
			var rowinfos=result.split("&");
			var rows=rowinfos.length;
			for (i=0;i<rows;i++)
	    	{
		    	row=row+1;
		    	if (row>pageRows) 
		    	{
			    	xlsheet.printout; //��ӡ���
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
					xlsheet.Range(xlsheet.Cells(row,2),xlsheet.Cells(row,7)).mergecells=true;//�ϲ���Ԫ�� 
					xlsheet.cells(row,2)="�豸���˼�¼";
					xlsheet.cells(row,2).HorizontalAlignment=3; //���ж���
					xlsheet.cells(row,2).Font.Bold = true;  // ����
					xlsheet.cells(row,2).Font.Size=14;
					row=row+1;
					xlsheet.cells(row,2)="���";
					xlsheet.cells(row,3)="��ǰԭֵ";
					xlsheet.cells(row,4)="��������";
					xlsheet.cells(row,5)="�������";
					xlsheet.cells(row,6)="����ԭ��";
					xlsheet.cells(row,7)="����ԭֵ";
					row=row+1;
			    }
		    	
		    	var sort=27;
		    	var colinfo=rowinfos[i].split("^");
		    	xlsheet.cells(row,2)=i+1;
		    	xlsheet.cells(row,3).HorizontalAlignment=1; //���Ҷ���
		    	xlsheet.cells(row,3)=colinfo[23];
		    	xlsheet.cells(row,4).HorizontalAlignment=1; //���Ҷ���
		    	xlsheet.cells(row,4)=colinfo[8];		    	
		    	xlsheet.cells(row,5).NumberFormatLocal = "0.00_ ";
		    	xlsheet.cells(row,5)=colinfo[1];
		    	xlsheet.cells(row,6).HorizontalAlignment=2; //�������
		    	xlsheet.cells(row,6)=colinfo[7];
		    	xlsheet.cells(row,7).NumberFormatLocal = "0.00_ ";
		    	xlsheet.cells(row,7)=colinfo[2];
	    	}
    	}
	    
	    //Ԥ��
	    if (!xlsheet)
	    {
			xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    }
	    xlApp.Visible=true
		xlsheet.PrintPreview();
		xlApp.Visible=true;// 20150902 �ڶ��δ�ӡ
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
		alertShow("û���ҵ��豸��Ϣ!");
		return;
	}
	var Bar=new ActiveXObject("EquipmentBar.PrintBar")
	Bar.PrtName="DHCEQBarCode";	//��ӡ������
	Bar.Title=objEquip.Hospital;
	Bar.FontName="";
	Bar.EqName=objEquip.Name;
	//Bar.EqName=objEquip.Item;	//�Ϸ�ҽ��ӡ�豸������	
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
	//var qrcode	= new QRCode(6, QRErrorCorrectLevel.H);//ÿ���߸����� 17+3*4,������
	var ValueStr="fileno:"+objEquip.FileNo+",no:"+objEquip.No;
	var type=getTypeNumber(ValueStr,QRErrorCorrectLevel.Q);

	var qrcode	= new QRCode(type, QRErrorCorrectLevel.Q);//ÿ���߸����� 17+3*4,������
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
	//�Ǽ��Ѵ�ӡ�����־,������
	var encmeth=GetElementValue("SaveOperateLog");
	if (encmeth=="") return;
	cspRunServerMethod(encmeth,"^52^"+rowid,2);
}
////print Equip Card �Ϸ�ҽԺ
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
		xlsheet.cells(1,8)="��";
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
/// ��ӡ�����ǩ(��ά��)
function DHCEQPrintAFQrcode(rowid,PrtName,affixrowid)
{
	if ((rowid=="")||(affixrowid=="")) return;
	var objEquip=new Equipment(rowid,"");
	if (objEquip.ID=="")
	{
		alertShow("û���ҵ��豸��Ϣ!");
		return;
	}
	var QRMaker=new ActiveXObject("EquipmentBar.PrintBar")
	QRMaker.PrtName="DHCEQBarCode";	//��ӡ������
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
	
	//// ������Ϣ
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
	var qrcode	= new QRCode(6, QRErrorCorrectLevel.H);//ÿ���߸����� 17+3*4,������
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