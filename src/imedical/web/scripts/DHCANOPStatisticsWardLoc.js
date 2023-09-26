//DHCANOPStatisticsWardLoc.JS

function BodyLoadHandler() {
	var obj=document.getElementById('btnPrint');
	if (obj) obj.onclick=PrintWardLoc;
}

function PrintWardLoc()  //手术科室工作量统计打印
{
	var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
    var path,fileName,fso;
    var objtbl=document.getElementById('tDHCANOPStatisticsWardLoc');
    if (objtbl.rows.length<2) return;
    var objtbllength=objtbl.rows.length;
    path=GetFilePath();
    fileName=path+"wardloc.xls";
    //fileName="C:\\SSTZD.xls";
	xlsExcel = new ActiveXObject("Excel.Application");
	xlsBook = xlsExcel.Workbooks.Add(fileName);
	xlsSheet = xlsBook.ActiveSheet;
	
	//题头打印
	var hospitalDesc=document.getElementById("hospital").value;
	mergcell(xlsSheet,1,1,13);
    xlcenter(xlsSheet,1,1,13);
	fontcell(xlsSheet,1,1,13,16);
	xlsSheet.cells(1,1)=hospitalDesc+t['val:dailygoalssheet'];	
	var StartDate= parent.frames[0].document.getElementById("StartDate").value;
	StartDate=changeDateStr(StartDate);
	var EndDate= parent.frames[0].document.getElementById("EndDate").value;
	EndDate=changeDateStr(EndDate);
	var logonLocId=session['LOGON.CTLOCID']; 
	var getLocDesc=document.getElementById("getLocDesc")
	var logonLocDesc="";
	if (getLocDesc){
		logonLocDesc=cspRunServerMethod(getLocDesc.value,logonLocId);
		var tmpLogonLocDesc=logonLocDesc.split("-");
		if (tmpLogonLocDesc.length>1) logonLocDesc=tmpLogonLocDesc[1];
	}
	var userCode=session['LOGON.USERNAME'];
	var printDate=document.getElementById("curDate").value;
	printDate=changeDateStr(printDate);
	mergcell(xlsSheet,2,1,13);
	xlsSheet.cells(2,1)=t['val:sheetdate']+" "+StartDate+" 至 "+EndDate;
	nmergcell(xlsSheet,3,4,1,1);
	xlsSheet.cells(3,1)=t['val:oploc'];
	mergcell(xlsSheet,3,2,3);
	xlsSheet.cells(3,2)=t['val:SP'];
	xlsSheet.cells(4,2)=t['val:IP'];
	xlsSheet.cells(4,3)=t['val:EM'];
	mergcell(xlsSheet,3,4,5);
	xlsSheet.cells(3,4)=t['val:B'];
	xlsSheet.cells(4,4)=t['val:IP'];
	xlsSheet.cells(4,5)=t['val:EM'];
	mergcell(xlsSheet,3,6,7);
	xlsSheet.cells(3,6)=t['val:M'];
	xlsSheet.cells(4,6)=t['val:IP'];
	xlsSheet.cells(4,7)=t['val:EM'];
	mergcell(xlsSheet,3,8,9);
	xlsSheet.cells(3,8)=t['val:SM'];
	xlsSheet.cells(4,8)=t['val:IP'];
	xlsSheet.cells(4,9)=t['val:EM'];
	mergcell(xlsSheet,3,10,11);
	xlsSheet.cells(3,10)=t['val:total'];
	xlsSheet.cells(4,10)=t['val:IP'];
	xlsSheet.cells(4,11)=t['val:EM'];
	nmergcell(xlsSheet,3,4,12,12);
	xlsSheet.cells(3,12)=t['val:OP'];
	nmergcell(xlsSheet,3,4,13,13);
	xlsSheet.cells(3,13)=t['val:total'];
	
	
   	for (i=1;i<objtbllength;i++)  
	{   
        xlsSheet.cells(i+4,1)=document.getElementById("wardLocz"+i).innerText;
        xlsSheet.cells(i+4,2)=document.getElementById("opSPz"+i).innerText;
        xlsSheet.cells(i+4,3)=document.getElementById("opSPEMz"+i).innerText;
        xlsSheet.cells(i+4,4)=document.getElementById("opBz"+i).innerText;
        xlsSheet.cells(i+4,5)=document.getElementById("opBEMz"+i).innerText;
        xlsSheet.cells(i+4,6)=document.getElementById("opMz"+i).innerText;
        xlsSheet.cells(i+4,7)=document.getElementById("opMEMz"+i).innerText;
        xlsSheet.cells(i+4,8)=document.getElementById("opSMz"+i).innerText;
        xlsSheet.cells(i+4,9)=document.getElementById("opSMEMz"+i).innerText;
        xlsSheet.cells(i+4,10)=document.getElementById("opAllz"+i).innerText;
        xlsSheet.cells(i+4,11)=document.getElementById("opAllEMz"+i).innerText;
        xlsSheet.cells(i+4,12)=document.getElementById("opAllOPz"+i).innerText;
        xlsSheet.cells(i+4,13)=document.getElementById("opTotalz"+i).innerText;
    }
    gridlist(xlsSheet,3,objtbllength+3,1,13);
    mergcell(xlsSheet,objtbllength+4,1,13);
	xlsSheet.cells(objtbllength+4,1)=t['val:curloc']+" "+logonLocDesc+"    "+t['val:curuser']+" "+userCode+"    "+t['val:printdate']+" "+printDate;     
	xlsSheet.PrintOut(); 
	xlsSheet = null;
    xlsBook.Close(savechanges=false)
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;
}
function GetFilePath()
{   
	var GetPath=document.getElementById("GetPath").value;
	var path=cspRunServerMethod(GetPath);
	return path;
}
function DateDemo(){
    var d, s="";
    d = new Date();
    s += d.getYear() + "-";
    s += (d.getMonth() + 1) + "-";
    s += d.getDate();
    return(s);
}
function changeDateStr(str)
{
	var tmpStr=str.split("/");
    if (tmpStr.length>2) str=tmpStr[2]+"-"+tmpStr[1]+"-"+tmpStr[0];
    return str;    
}
document.body.onload = BodyLoadHandler;