/**
 * 模块:门诊药房
 * 子模块:门诊药房-工作量统计
 * DHCOutPhGZL
 */

var tblobj = document.getElementById("tDHCOutPhGZL");
var evtName;
var doneInit = 0;
var focusat = null;
var SelectedRow = 0;
var pmiobj, pnameobj;
var stdateobj, enddateobj;
var ctlocobj;
var BResetobj, BRetrieveobj, BPrintobj;

function BodyLoadHandler() {
    BResetobj = document.getElementById("BReset");
    if (BResetobj) BResetobj.onclick = Reset_click;
    BPrintobj = document.getElementById("BPrint");
    if (BPrintobj) BPrintobj.onclick = Print_click;
    ctlocobj = document.getElementById("ctloc");
    useridobj = document.getElementById("userid");
}

function SelectRowHandler() {
    var eSrc = window.event.srcElement;
    if (eSrc.tagName == "IMG") eSrc = window.event.srcElement.parentElement;
    var eSrcAry = eSrc.id.split("z");
    var rowObj = getRow(eSrc);
    var selectrow = rowObj.rowIndex;
    if (!selectrow) return;
    SelectedRow = selectrow;

}

function Reset_click() {
    location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhGZL";
}

function Print_click() {
    if (tblobj.rows.length == 0) { 
    	alert(t['01']); 
    	return 0; 
    }
    var rows, Rrow, prt, name, pmino, printflag, inv;
    rows = tblobj.rows.length - 1 ;
    var path
    var Ls_orderitemtmp, i;
    var getmethod = document.getElementById('gpath');
    if (getmethod) { 
    	var encmeth = getmethod.value; 
    } else { 
    	var encmeth = '' ;
    }
    var path = cspRunServerMethod(encmeth);
    var datest = document.getElementById('CDateSt');
    var dateend = document.getElementById('CDateEnd');
    var hosname;
    var getmethod = document.getElementById('ghosname');
    if (getmethod) { 
    	var encmeth = getmethod.value ;
    } else { 
    	var encmeth = '' ;
    };
    hosname = cspRunServerMethod(encmeth);
    var xlApp, obook, osheet, xlsheet, xlBook ;
    var paymoney ;
    var pagerow = 30 ;
    var Template;
    Template = path + "yfgzl.xls";
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Template);
    xlsheet = xlBook.ActiveSheet;
    var HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID']);
    var LocInfo=tkMakeServerCall("web.DHCSTKUTIL","GetLocInfoByRowId",session['LOGON.CTLOCID']);
	xlsheet.cells(1,1).value=HospitalDesc+"门诊工作量统计" ;
	xlsheet.cells(2,1).value = "药房:" + LocInfo.split("^")[1];
	xlsheet.cells(2,7).value = "统计范围:"+datest.value + t['02'] + dateend.value;
	xlsheet.cells(3,1).value="打印时间:"+getPrintDateTime();
	xlsheet.cells(3,11).value="打印人:"+session['LOGON.USERNAME'];	
    var pagenum;
    var startrow = 4 ; //打印内容首行 
    if (Math.floor(rows / pagerow) == (rows / pagerow)) {
	    pagenum = Math.floor(rows / pagerow); 
	} else { 
		pagenum = Math.floor(rows / pagerow) + 1; 
	}
    var k, j, l, RowNum, count;
    var lastnum = rows - (pagenum - 1) * pagerow
    for (k = 1; k <= pagenum; k++) {
        if (k == pagenum) { 
        	RowNum = lastnum; 
        } else { 
        	RowNum = pagerow; 
        }
        for (l = startrow+1; l <= pagerow + startrow; l++) { 
        	for (j = 1; j <= 15; j++) { 
        		xlsheet.Cells(l, j).value = "" ;
        	} 
        }
        for (i = 1; i <= RowNum; i++) {
            var orditm, phdesc, uom, qty, price, money, jl, pc, yf, lc, doctor ;
            xlsheet.cells(startrow + i, 1).value = document.getElementById("TPhNamez" + (i + (k - 1) * pagerow)).innerText;
            xlsheet.cells(startrow + i, 2).value = document.getElementById("TPYRCz" + (i + (k - 1) * pagerow)).innerText;
            xlsheet.cells(startrow + i, 3).value = document.getElementById("TFYRCz" + (i + (k - 1) * pagerow)).innerText;
            xlsheet.cells(startrow + i, 4).value = document.getElementById("TPYJEz" + (i + (k - 1) * pagerow)).innerText;
            xlsheet.cells(startrow + i, 5).value = document.getElementById("TFYJEz" + (i + (k - 1) * pagerow)).innerText;
            xlsheet.cells(startrow + i, 6).value = document.getElementById("TPYLz" + (i + (k - 1) * pagerow)).innerText;
            xlsheet.cells(startrow + i, 7).value = document.getElementById("TFYLz" + (i + (k - 1) * pagerow)).innerText;
            xlsheet.cells(startrow + i, 8).value = document.getElementById("TRetPrescz" + (i + (k - 1) * pagerow)).innerText;
            xlsheet.cells(startrow + i, 9).value = document.getElementById("TRetMoneyz" + (i + (k - 1) * pagerow)).innerText;
            xlsheet.cells(startrow + i, 10).value = document.getElementById("TRetYLz" + (i + (k - 1) * pagerow)).innerText;
            xlsheet.cells(startrow + i, 11).value = document.getElementById("TPyFSz" + (i + (k - 1) * pagerow)).innerText;
            xlsheet.cells(startrow + i, 12).value = document.getElementById("TFyFSz" + (i + (k - 1) * pagerow)).innerText;
            xlsheet.cells(startrow + i, 13).value = document.getElementById("TTyFSz" + (i + (k - 1) * pagerow)).innerText;
            xlsheet.cells(startrow + i, 14).value = document.getElementById("TJYFSz" + (i + (k - 1) * pagerow)).innerText;
            xlsheet.cells(startrow + i, 15).value = document.getElementById("TJYCFz" + (i + (k - 1) * pagerow)).innerText;
            xlsheet.Range(xlsheet.Cells(startrow, 1), xlsheet.Cells((startrow + i), 15)).Borders(1).LineStyle = 1;
            xlsheet.Range(xlsheet.Cells(startrow, 1), xlsheet.Cells((startrow + i), 15)).Borders(2).LineStyle = 1;
            xlsheet.Range(xlsheet.Cells(startrow, 1), xlsheet.Cells((startrow + i), 15)).Borders(3).LineStyle = 1;
            xlsheet.Range(xlsheet.Cells(startrow, 1), xlsheet.Cells((startrow + i), 15)).Borders(4).LineStyle = 1;
        }
        xlsheet.printout;
    }
    xlBook.Close(savechanges = false);
    xlApp = null;
    xlsheet = null;
}

document.body.onload = BodyLoadHandler;