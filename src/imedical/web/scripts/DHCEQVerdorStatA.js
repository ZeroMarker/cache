/// Modified By HZY 2012-04-27.HZY0029.
/// 修改函数:FillEquipType
/// ------------------------------------------------------
/// Created By HZY 2011-10-27 HZY0020

var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{
	/// 20150918  Mozy0166
	//KeyUp("Vendor");
	//Muilt_LookUp("Vendor");	
	InitButton();	// 262464 Modify By BRB 2016-10-10	
	//FillEquipType()
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
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQVerdorStatA';
	lnk=lnk+'&ValEquipTypes='+GetSelectedEquipType(1);
	lnk=lnk+'&StartDate='+GetElementValue("StartDate");
	lnk=lnk+'&EndDate='+GetElementValue("EndDate");	
	lnk=lnk+'&Vendor='+GetElementValue("Vendor");
	lnk=lnk+'&VendorDR='+GetElementValue("VendorDR");
	lnk=lnk+'&QXType='+GetElementValue("QXType");
	///alertShow(lnk);
	location.href=lnk;
}

function BPrint_Click()
{
	var templateName="DHCEQVendorReportA.xls";
	var isSave=1;	//1为导出保存,其他为直接打印出来.
	var savefilename=GetFileName();
	if (savefilename=="") return;
	//var colset="1:1^2:2^3:0^4:3";///列x1:输出结果第y1位^列x2:输出结果第y2位.....
	var colset="1:0^2:1^3:2^4:3^5:4^6:5^7:6^8:7^9:8^10:9^11:10^12:11^13:12^14:13^15:14^16:15^17:16^18:17";
	
	var TemplatePath=GetElementValue("GetRepPath");
	var encmeth=GetElementValue("GetVendorReport");
	try {
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+templateName; 
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet;
 
	    var HadData=true;		
		var num=1;
		var row=2;
		while (HadData)
		{
			var rtn=cspRunServerMethod(encmeth,num);
			if (rtn=="")
			{
				HadData=false;
			}
			else
			{
				row=row+1;
				fillRowData(xlsheet,row,rtn,colset);
				num=num+1;
			}
		}    

	    if (isSave==1)
	    {	
	    	xlBook.SaveAs(savefilename);
	    	alertShow('保存成功,保存路径:'+savefilename);
	    }
	    else
	    {	
	    	xlsheet.printout;	
	    }	// 打印输出
	    
	    xlBook.Close(savechanges=false);
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

/// Modified By HZY 2012-04-27.HZY0029.
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
		obj.options.add(new Option(list[1],list[13],true,true));	//Modified By HZY 2012-04-27.HZY0029.因DHC_EQCEquipType表结构变化,这里将原来的'4'改为现在的'13'.	
		if (typeids.indexOf("^"+list[13]+"^")>-1)
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
		{	typeids=typeids+obj.options[i].value;}
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