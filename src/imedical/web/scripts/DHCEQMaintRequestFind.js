var RowID;
function BodyLoadHandler() 
{	
	SetBAddType();
	KeyUp("Model^RequestLoc^Equip");
	Muilt_LookUp("Model^RequestLoc^Equip");
	SetStatus();
	var obj=document.getElementById("BAdd");
	if(obj) obj.onclick=BAdd_Clicked;
	var obj=document.getElementById("BAddNew");
	if(obj) obj.onclick=BAddNew_Clicked;
	var obj=document.getElementById("BExport");
	if(obj) obj.onclick=BExport_Click;
	SetBEnable();
	/// Mozy0103	2013-12-10
	if (GetElementValue("ReloadFlag")!="")
	{
		var objtbl=document.getElementById("tDHCEQMaintRequestFind");
		var rows=objtbl.rows.length;
		for (var i=1;i<rows;i++)
		{
			var id=GetElementValue("TOperateIDz"+i);
			BPrint_Click(id);
		}
		setTimeout('RefreshMe()',300000);		// 延迟毫秒
	}
}
function BAdd_Clicked()
{
	//var obj=document.getElementById("Add");
	//if (obj.value==1) return;
	window.location.href= "dhceqmaintrequest.csp?RowID="+""+"&Status=新增"+"&EquipDR="+""+"&Add="+obj.value;
}
function BAddNew_Clicked()
{
	//var obj=document.getElementById("Add");
	//if (obj.value==1) return;
	window.location.href= "dhceqmaintrequestnew.csp?RowID=&Status=0"+"&EquipDR=";
}
function SetBAddType()
{
	//var obj=document.getElementById("Add");
	//if (obj.value==1) {DisableBElement("BAdd",true);}
}


function GetRequestLoc(value)
{
	GetLookUpID('RequestLocDR',value);
}
function GetModel(value)
{
	GetLookUpID('ModelDR',value);
}
function GetEquip(value){
	var user=value.split("^");
	var obj=document.getElementById('EquipDR');
	obj.value=user[1];
}
function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatus"))
}

function SetBEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD!="off")
	{
		DisableBElement("BAddNew",true);
	}
}
/// Mozy0103	2013-12-10
function BPrint_Click(RowID)
{
	if (RowID=="") return;
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	//alertShow(RowID+"   ReturnList="+ReturnList);
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	try
	{
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQMaintNew.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
    	xlsheet = xlBook.ActiveSheet;
    	
    	var list=ReturnList.split("^");
	    //alertShow(list[72])
	    xlsheet.cells(2,2)=list[42];
	    xlsheet.cells(2,4)=ChangeDateFormat(list[12]);
	    xlsheet.cells(3,2)=list[47];
	    xlsheet.cells(3,4)=list[72];
	    xlsheet.cells(4,2)=list[73];
	    xlsheet.cells(4,4)=list[74];
	    xlsheet.cells(5,2)=ChangeDateFormat(list[8])
	    xlsheet.cells(5,4)=list[49];
	    xlsheet.cells(6,2)=list[3];
	    xlsheet.cells(7,2)=GetShortName(list[58],"-");
	    xlsheet.cells(7,4)=list[56];
	    xlsheet.cells(8,2)=list[23];
	    xlsheet.cells(9,2)=list[27];
	    
	    xlsheet.cells(10,2)=ChangeDateFormat(list[15]);
	    xlsheet.cells(10,4)=list[53];
	    if (list[52]!="") xlsheet.cells(11,2)=list[52];
		if (list[55]!="") xlsheet.cells(11,4)=list[55];
	    xlsheet.cells(12,2)=list[50];
	    xlsheet.cells(13,2)=list[5];
	    xlsheet.cells(14,2)=list[51];
	    xlsheet.cells(15,2)=ChangeDateFormat(list[10]);
	    xlsheet.cells(15,4)=list[41];
	    xlsheet.cells(16,2)=list[39];
	    var encmeth=GetElementValue("GetCurTime")
		var curTime=cspRunServerMethod(encmeth);
	    xlsheet.cells(19,4)="打印时间:"+curTime;
	    
	    //var obj = new ActiveXObject("PaperSet.GetPrintInfo");
		//var size=obj.GetPaperInfo("DHCEQInStock");
		//if (0!=size) xlsheet.PageSetup.PaperSize = size;
		//xlApp.Visible=true;
	   	//xlsheet.PrintPreview();
	   	xlsheet.printout;		//默认打印机使用
	   	//xlBook.SaveAs("D:\\Return"+i+".xls");
		
		xlBook.Close (savechanges=false);
		xlsheet.Quit;
	    xlsheet=null;
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
	var encmeth=GetElementValue("SaveOperateLog");
	if (encmeth=="") return;
	cspRunServerMethod(encmeth,"^31^"+RowID);
}

function RefreshMe()
{
	location.reload();
}
function BExport_Click()
{
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)  TJob=ObjTJob.value;
	if (TJob=="")  return;
	PrintDHCEQEquipNew("MaintRequestList",1,TJob,GetElementValue("vData"))
}

document.body.onload = BodyLoadHandler;