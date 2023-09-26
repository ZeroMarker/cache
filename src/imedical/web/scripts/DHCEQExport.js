function BodyLoadHandler() 
{	
	InitPage();
}

function InitPage()
{
	var obj=document.getElementById("BExport");
	if (obj) obj.onclick=BExport_Click;
	var obj=document.getElementById("BExportDym");
	if (obj) obj.onclick=BExportDym_Click;
}

function BExportDym_Click()
{
	var Guser=curUserID;
	var num=GetNum();
	var typeinfo;
	var templatefilename;
	
	var FileName="d:\export.xls";
	if (FileName=="") {return;}
	var fd = new ActiveXObject("MSComDlg.CommonDialog");
	FileName=GetFileName();
	return;
	
	if (num<=1) 
	{
		alertShow("没有相关信息!");
		return;
	}
	var exportEquiptype=document.getElementById("ExportEquipType");
	if (exportEquiptype.selectedIndex>0)
	{
		var selOption=exportEquiptype.options[exportEquiptype.selectedIndex];
		typeinfo=selOption.value;
		templatefilename=typeinfo+"."+selOption.text+".xls";
	}
	else
	{	return;	}
	
	///alertShow(templatefilename);
	///return;
    try 
    {
	    ///var FileName=GetFileName();	    
	    var	TemplatePath=GetElementValue("TemplatePath");
	    if (TemplatePath=="") return;
	    var encmeth=GetElementValue("GetList");
	    if (encmeth=="") return;
	    
	    var encmeth1=GetElementValue("GetEquipInfoByType");
	    if (encmeth1=="") return;
	    
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+templatefilename;
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    
	    var col;
	    var Row;
	    ///alertShow(num);
	    ///num=2000;
	    for (Row=1;Row<=num;Row++)
	    { 
	    	///if (Row>1599) continue;
			var str=cspRunServerMethod(encmeth,'','',Guser,Row);
			var List=str.split("^");
			var EquipDR=List[62];
			var strDetail=cspRunServerMethod(encmeth1,typeinfo,EquipDR);
			var colList=strDetail.split("^");
			var cols=colList.length;
			///alertShow(cols);
			///xlsheet.Rows(Row+1).Insert()
			for (var col=1;col<=cols;col++)
	    	{	xlsheet.cells(Row+1,col)=colList[col-1];}		
	    }
	    xlBook.SaveAs(FileName);
	    ///xlBook.SaveAs("D:\\cgeqipsq.xls");
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	} 
	catch(e)
	{	 alertShow(e.message);	 }
}

function BExport_Click()
{
	var Guser=curUserID;
	var num=GetNum();
	if (num<=1) 
	{
		alertShow("没有相关信息!");
		return;
	}
	
    try 
    {
	    ///var FileName=GetFileName();
	    var FileName="d:\export.xls";
	    if (FileName=="") {return;}
	    var	TemplatePath=GetElementValue("TemplatePath");
	    if (TemplatePath=="") return;
	    var encmeth=GetElementValue("GetList");
	    if (encmeth=="") return;
	    
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQExport.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    
	    var col;
	    var Row;
	    ///alertShow(num);
	    ///num=2000;
	    for (Row=1;Row<=num;Row++)
	    { 
	    	///if (Row>1599) continue;
			var str=cspRunServerMethod(encmeth,'','',Guser,Row);
			var List=str.split("^")

			///xlsheet.Rows(Row+1).Insert()
			col=1;
			xlsheet.cells(Row+1,col)=List[43]; //变动方式
			col=col+1;
			xlsheet.cells(Row+1,col)=List[60]; //变动日期
			col=col+1;
			xlsheet.cells(Row+1,col)=List[47]; //设备类型
			col=col+1;
			xlsheet.cells(Row+1,col)=List[51]; //设备库房
			col=col+1;
			xlsheet.cells(Row+1,col)=List[61]; //金额
			col=col+1;
			xlsheet.cells(Row+1,col)=List[55]; //设备编号
			col=col+1;			
			xlsheet.cells(Row+1,col)=List[0]//设备名称
			col=col+1;
			xlsheet.cells(Row+1,col)=List[1]; //机型
			col=col+1;
			
			xlsheet.cells(Row+1,col)=List[2]; //固资类别
			col=col+1;
			xlsheet.cells(Row+1,col)=List[56]; //状态
			col=col+1;
			xlsheet.cells(Row+1,col)=List[21]; //设备原值
			col=col+1;
			xlsheet.cells(Row+1,col)=List[23]; //设备净残值
			col=col+1;
			xlsheet.cells(Row+1,col)=List[28]; //累计折旧合计
			col=col+1;
			xlsheet.cells(Row+1,col)=List[26]; //折旧方法
			col=col+1;
			xlsheet.cells(Row+1,col)=List[24]; //使用年限	
			for (var i=1;i<=20;i++)
			{
				xlsheet.cells(Row+1,col)=List[24]; //使用年限	
			}		
	    }
	    xlBook.SaveAs(FileName);
	    ///xlBook.SaveAs("D:\\cgeqipsq.xls");
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	} 
	catch(e)
	{	 alertShow(e.message);	 }
}

function GetNum() 
{
	var num=0;
	var getnum=document.getElementById('GetNum');
	if (getnum) {
		var encmeth=getnum.value;
		num=cspRunServerMethod(encmeth);
		} 
	return num;
}

function GetEquipType(value)
{
    GetLookUpID("EquipTypeDR",value);
    var val=value.split("^");
}

document.body.onload = BodyLoadHandler;