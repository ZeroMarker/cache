
//名称	DHCPEPreAudit.List.js
//功能	收费状态
//组件	DHCPEPreAudit.List	
//创建	2018.09.03
//创建人  xy
document.body.style.padding="0px 10px 10px 10px"
function BodyLoadHandler()
{
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_click;
	
	inti();
}

function inti(){
	var obj;
	obj=document.getElementById("CRMADM");
	if (obj) ADMID=obj.value;
	obj=document.getElementById("ADMType");
	if (obj) type=obj.value;
    //alert(ADMID+"^"+type)
	var APAmount=tkMakeServerCall("web.DHCPE.PreAudit","GetAPAmount",type,ADMID);
	if(APAmount!=""){
		var obj=document.getElementById("APAmount");
		if(obj){obj.value=APAmount;}
	}else{
		var obj=document.getElementById("APAmount");
		if (obj) obj.style.display="none";
	}
	
	if(type=="G"){
	var IFee=tkMakeServerCall("web.DHCPE.PreAudit","GetIFee",type,ADMID);
		var obj=document.getElementById("GetIFee");
		if(obj){obj.value=IFee;}
	}
	if(type=="I"){
		var obj=document.getElementById("GetIFee");
		if (obj) obj.style.display="none";
			
	}
	
}

var selectedRow=-1;
function SelectRowHandler(index,rowdata) {
	selectedRow=index;
	if (selectedRow=="-1") return;
	if(index==selectedRow)
	{
		var RowID=rowdata.RowID;
		var myFrame=parent.frames['PreAudit.Edit'];
	    myFrame.fillData(RowID);
	
	}else
	{
		selectedRow=-1
	
	}
	
}



function BPrint_click()
{
	var ADMID="",type="",obj;
	obj=document.getElementById("CRMADM");
	if (obj) ADMID=obj.value;
	obj=document.getElementById("ADMType");
	if (obj) type=obj.value;
	var info=tkMakeServerCall("web.DHCPE.PreAudit","GetPayAmountInfo",type,ADMID);
	
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEJKD.xls';
	//alert(Templatefilepath)
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	xlsheet.cells(2,2).Value=info;
	//xlsheet.saveas("d:\\aa.xls")
	//xlsheet.printout;
	//xlBook.Close (savechanges=false);
	xlApp.Visible = true;
   	xlApp.UserControl = true;
	
}
function   Cleanup()   { 
	window.clearInterval(idTmr);   
	CollectGarbage();
  
}

document.body.onload = BodyLoadHandler;