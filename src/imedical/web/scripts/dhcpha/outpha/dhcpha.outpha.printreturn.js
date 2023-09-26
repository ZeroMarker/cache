/*d
dhcpha.outpha.printreturn.js
模块:门诊药房
子模块:门诊药房-退药单打印
createdate:2016-05-13
creator:yunhaibao
*/
var HospitalDesc=""
HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID']);
var path=tkMakeServerCall("web.DHCDocConfig","GetPath")
//退药单打印统一入口
function PrintReturn(retrowid,reprint){
	var returnPrintInfo=tkMakeServerCall("web.DHCOUTPHA.Return","GetPrintReturnInfo",retrowid)
	if (returnPrintInfo==""){return;}
	var returnArr=returnPrintInfo.split("&&")
	var maininfo=returnArr[0];
	var itminfo=returnArr[1];
	if (itminfo==""){return;}
	var mainarr=maininfo.split("^")
	var invNo=mainarr[0]
	var retusername=mainarr[1]
	var retdate=mainarr[2]
	var rettime=mainarr[3]
	var retreason=mainarr[4]
	var reqno=mainarr[5]
	var totalmoney=mainarr[6]
	var patno=mainarr[7]
	var patname=mainarr[8]
	var retloc=mainarr[9]
	var currenttime=mainarr[10]
	var xlApp,xlsheet,xlBook
	var Template=path+"yftydnew.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet 	
	xlsheet.cells(1,1).value=HospitalDesc+retloc+"退药单"
	xlsheet.cells(3,1).value="姓名:"+patname;
	xlsheet.cells(3,5).value=retdate
	xlsheet.cells(4,1).value="退药原因:"+retreason
	var itmarr=itminfo.split("!!");
	for (var itmi=0;itmi<itmarr.length;itmi++){
		var detailinfo=itmarr[itmi];
		var detailarr=detailinfo.split("^");
		var incidesc=detailarr[0];
		var retqty=detailarr[1];
		var retuom=detailarr[2];
		var retmoney=detailarr[3];
		var price=detailarr[4];
		xlsheet.cells(6+itmi,1).value=incidesc
		xlsheet.cells(6+itmi,2).value=price
		xlsheet.cells(6+itmi,3).value=retqty
		xlsheet.cells(6+itmi,4).value=detailarr[2];
		xlsheet.cells(6+itmi,5).value=retmoney
		setBottomLine(xlsheet,6+itmi,1,5)
		cellEdgeRightLine(xlsheet,6+itmi,1,5)
	}
	xlsheet.cells(12,5).value="合计:"+totalmoney
	xlsheet.cells(12,1).value="打印人:"+session['LOGON.USERNAME']+" 打印时间:"+currenttime
	//if (rows==rr){ xlsheet.cells(1,5).value= t['16'];}	
	xlsheet.printout
	xlBook.Close(savechanges=false);
	xlApp=null;
	xlsheet=null
	var content=patname+"^"+retreason+"^"+currenttime
	var logret=tkMakeServerCall("web.DHCOutPhReturn","CreateOutRetLog",patno,content);
}
function setBottomLine(objSheet,row,startcol,colnum)
{
    objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).Borders(9).LineStyle=1 ;
}
function cellEdgeRightLine(objSheet,row,c1,c2)
{
	for (var i=c1;i<=c2;i++)
	{
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(10).LineStyle=1;
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(7).LineStyle=1;
	}
}
