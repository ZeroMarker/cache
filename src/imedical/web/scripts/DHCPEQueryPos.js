function BodyLoadHandler()
{		
	//var obj=document.getElementById("BFind")
	//if (obj) obj.onclick=BFind_click;
	var obj=document.getElementById("BExport")
	if (obj) obj.onclick=BExport_click;

}

function EndDate(){
   var s=""; 
 	var date = new Date(); 
    var y = date.getFullYear(); 
    var m = date.getMonth()+1; 
    var d = date.getDate(); 
    var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
		if (dtformat=="YMD"){
			var s=y+"-"+m+"-"+d;
		}else if (dtformat=="DMY"){
			var s=d+"/"+m+"/"+y;
		} 
   return(s); 
}

function BExport_click()
{
	try{
		
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	    var Templatefilepath=prnpath+'DHCPEQueryPos.xls';
	   
	    xlApp = new ActiveXObject("Excel.Application"); //固定
	    xlApp.UserControl = true;
        xlApp.visible = true; 
		xlBook = xlApp.Workbooks.Add(Templatefilepath); //固定
		xlsheet = xlBook.WorkSheets("Sheet1"); //Excel下标的名称
		
		var obj,iBeginDate="",iEndDate="";
		obj=document.getElementById("SDate");
		if (obj){ iBeginDate=obj.value; }
		obj=document.getElementById("EDate");
		if (obj){ iEndDate=obj.value; }
	 	if (iEndDate==""){ iEndDate=EndDate();}
	 	
		xlsheet.cells(1,1)=iBeginDate+"--"+iEndDate+"阳性体征统计";
		
		var User=session['LOGON.USERID']
		var Rows=tkMakeServerCall("web.DHCPE.Report.PosQuery","GetQueryPosRows",User);
		
		for (var i=1;i<=Rows;i++){
			var Datas=tkMakeServerCall("web.DHCPE.Report.PosQuery","GetQueryPosData",User,i)

			var DayData=Datas.split("^");
			for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
				xlsheet.cells(i+2, iDayLoop+1)=DayData[iDayLoop];
			}

		} 
		xlsheet.Range(xlsheet.Cells(2,1),xlsheet.Cells(parseInt(Rows)+2,7)).Borders.LineStyle=1; 
		xlBook.Close(savechanges = true);
		xlApp.Quit();
		xlApp = null;
		xlsheet = null;

   	}
	catch(e)
	{
		alert(e+"^"+e.message);
	}

}
function BFind_click()
{
	var obj;
	var ODDR="",SResult="",EResult="",SDate="",EDate="";
	obj=getobj("ODDR")
	if (obj) ODDR=obj.value;
	obj=getobj("SResult")
	if (obj) SResult=obj.value;
	obj=getobj("EResult")
	if (obj) EResult=obj.value;
	obj=getobj("SDate")
	if (obj) SDate=obj.value;
	obj=getobj("EDate")
	if (obj) EDate=obj.value;
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEQueryPos"
		+"&ODDR="+ODDR
		+"&SResult="+SResult
		+"&EResult="+EResult
		+"&SDate="+SDate
		+"&EDate="+EDate;
	//alert(lnk)
	location.href=lnk;
}
function SearchODDesc(value)
{
	if (value=="") return;
	var Arr=value.split("^");
	var obj=document.getElementById("ODDR");
	if (obj) obj.value=Arr[2]
}
function getobj(id)
{
	var obj=document.getElementById(id)
	return obj
}
document.body.onload = BodyLoadHandler;