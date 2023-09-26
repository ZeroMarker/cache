/// DHCEQAVerdorStatNew.js	Mozy	2016-6-12
var SelectedRow = 0;
var rowid=0;

function BodyLoadHandler() 
{
	KeyUp("Vendor");
	Muilt_LookUp("Vendor");	
	InitButton();
	FillEquipType();
}

function InitButton()
{
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
}

function BFind_Click()
{
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAVerdorStatNew';
	lnk=lnk+'&ValEquipTypes='+GetSelectedEquipType(1);
	lnk=lnk+'&MonthStr='+GetElementValue("MonthStr");
	lnk=lnk+'&Vendor='+GetElementValue("Vendor");
	lnk=lnk+'&VendorDR='+GetElementValue("VendorDR");
	
	//alertShow(lnk);
	location.href=lnk;
}

function BSaveExcel_Click()
{
	var TemplatePath=GetElementValue("GetRepPath");
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=GetElementValue("GetRepPath")+"DHCEQAVendorReport.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    
	    var equiptypeinfos=GetSelectedEquipType(2);	    
	    
	    var strDate="日期:"+GetElementValue("StartDate")+"至"+GetElementValue("EndDate");
	    var encmeth=GetElementValue("GetVendorReport");
	    
		row=0;
	    var HadData=true;
		var PreVendorID=0;
		var sumFee=0;
		while (HadData)
		{
			var rtn=cspRunServerMethod(encmeth,PreVendorID);
			//alertShow(rtn);
			if (rtn=="")
			{ 
				HadData=false;
				if (row>0)
				{
					xlsheet.cells(4+row,1)="合计";
					xlsheet.cells(4+row,2)=sumFee;	
				}
			}
			else
			{
				xlsheet.Rows(4+row).Insert();
				rtn=rtn.split("^");
			
				xlsheet.cells(4+row,1)=rtn[2];
				xlsheet.cells(4+row,2)=rtn[0];
				PreVendorID=rtn[1];
				sumFee=parseFloat(sumFee)+parseFloat(rtn[0]);
				row++;
			}
	    }
	    ///xlsheet.printout;	// 打印输出
	    ///xlBook.SaveAs("D:\\DHCEQStatCatReport.xls");
	    var savepath=GetFileName();  
		xlBook.SaveAs(savepath);
		alertShow('保存成功,保存路径:'+savepath);   
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

function BPrint_Click()
{
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=cspRunServerMethod(GetElementValue("GetRepPath"))+"DHCEQAVendorReportNew.xls";
	    xlApp = new ActiveXObject("Excel.Application");
		var encmeth=GetElementValue("GetNum");
		var rows=cspRunServerMethod(encmeth,"AVendorReportNewPrint");
		var PageRows=30;
		var Pages=parseInt(rows / PageRows);
		var ModRows=rows%PageRows; //最后一页行数
		if (ModRows==0) {Pages=Pages-1;}
		
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	
	    	//xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc")); //医院名称替换
	    	var MonthStr=GetElementValue("MonthStr");
			MonthStr=MonthStr.replace("-","年")+"月";
	    	xlsheet.cells(3,4)=xlsheet.cells(3,4)+MonthStr;
			xlsheet.cells(3,8)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";
			
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
	    	var encmeth=GetElementValue("GetList");
			for (var Row=1;Row<=OnePageRow;Row++)
			{
				var Location=i*PageRows+Row;
				var Data=cspRunServerMethod(encmeth,"AVendorReportNewPrint",Location);
				var List=Data.split("^");
				if (Location==rows)
				{
					//xlsheet.Rows(Row+5).Insert();
					encmeth=GetElementValue("GetCurTime");
					encmeth=GetElementValue("GetCurDate");
					var curTime=cspRunServerMethod(encmeth);
					xlsheet.cells(Row+4,1)="打印日期:"+FormatDate(curTime);
					xlsheet.cells(Row+4,5)=List[0];
					xlsheet.cells(Row+4,6)=List[1];
					xlsheet.cells(Row+4,7)=List[2];
					xlsheet.cells(Row+4,8)=List[3];
				}
				else
				{
					xlsheet.cells(Row+4,1)=List[0];
					xlsheet.cells(Row+4,2)=List[1];
					xlsheet.cells(Row+4,3)=List[2];
					xlsheet.cells(Row+4,4)=List[3];
					xlsheet.cells(Row+4,5)=List[4];
					xlsheet.cells(Row+4,6)=List[5];
					xlsheet.cells(Row+4,7)=List[6];
					xlsheet.cells(Row+4,8)=List[7];
					xlsheet.cells(Row+4,9)=List[8];
				}
	    	}
	    	
	    	//xlsheet.cells(11,9)="制单人:"+username; //制单人
	    	xlsheet.printout;
	    	// 打印输出
			
			xlBook.Close(savechanges=false);
			xlApp=null;
			xlsheet.Quit;
			xlsheet=null;
		}
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

function FillEquipType()
{
	var equiptypeinfos=GetElementValue("EquipTypeInfos");
	var obj=document.getElementById("EquipType");
	var equiptypelist=equiptypeinfos.split("&");
	var typeids=GetElementValue("ValEquipTypes");
	if (typeids!="") typeids="^"+typeids+"^";
	
	for (var i=0;i<equiptypelist.length;i++)
	{
		var list=equiptypelist[i].split("^");
		obj.options.add(new Option(list[1],list[4],true,true));
		if (typeids.indexOf("^"+list[4]+"^")>-1)
		{	obj.options[i].selected=true;	}
		else
		{	obj.options[i].selected=false;	}
	}
}

///type: 1 ids  2 names
function GetSelectedEquipType(type)
{
	var typeids="";
	var obj=document.getElementById("EquipType");
	for (var i=0;i<obj.options.length;i++)
	{
		if (obj.options[i].selected!=true) continue;
		if (typeids!="") typeids=typeids+"^";
		if (type==1)
		{
			typeids=typeids+obj.options[i].value;}
		else
		{	typeids=typeids+obj.options[i].text;}
	}
	return typeids;
}

function GetVendor (value)
{
    GetLookUpID("VendorDR",value);
}

document.body.onload = BodyLoadHandler;