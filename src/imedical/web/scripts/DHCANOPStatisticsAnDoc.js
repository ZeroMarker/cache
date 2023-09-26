//DHCANOPStatisticsAnDoc.JS

function BodyLoadHandler() {
	var obj=document.getElementById('btnPrint');
	if (obj) obj.onclick=PrintWardLoc;
}

function PrintWardLoc()  //手术医生工作量统计打印
{
	var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
    var path,fileName,fso;
    var objtbl=document.getElementById('tDHCANOPStatisticsAnDoc');
    if (objtbl.rows.length<2) return;
    var objtbllength=objtbl.rows.length;
    var WardLoc= parent.frames[0].document.getElementById("OpLoc").value;
	if (WardLoc=="") {alert(t['val:selloc']);return;}
    var tmpWardLoc=WardLoc.split("-");
	if (tmpWardLoc.length>1) WardLoc=tmpWardLoc[1];
    path=GetFilePath();
    fileName=path+"andoc.xls";
	xlsExcel = new ActiveXObject("Excel.Application");
	xlsBook = xlsExcel.Workbooks.Add(fileName);
	xlsSheet = xlsBook.ActiveSheet;
	
	var col=16; //设置共打印16列
	//报表列显示内容都写在模版里面andoc.xls,共16列,第二行要左对齐
	var hospitalDesc=document.getElementById("hospital").value;
	mergcell(xlsSheet,1,1,col);
    xlcenter(xlsSheet,1,1,col);
	fontcell(xlsSheet,1,1,col,16);
	xlsSheet.cells(1,1)=hospitalDesc+t['val:goalssheet'];	

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
	mergcell(xlsSheet,2,1,col);
	xlsSheet.cells(2,1)=t['val:sheetdate']+" "+StartDate+" 至 "+EndDate+"   "+t['val:wardloc']+" "+WardLoc;

   	for (i=1;i<objtbllength;i++)  
	{   
        xlsSheet.cells(i+4,1)=document.getElementById("anDocz"+i).innerText;
        xlsSheet.cells(i+4,2)=document.getElementById("anDocSPz"+i).innerText;
        xlsSheet.cells(i+4,3)=document.getElementById("anDocBz"+i).innerText;
        xlsSheet.cells(i+4,4)=document.getElementById("anDocMz"+i).innerText;
        xlsSheet.cells(i+4,5)=document.getElementById("anDocSMz"+i).innerText;
        xlsSheet.cells(i+4,6)=document.getElementById("anDocAllz"+i).innerText;
        xlsSheet.cells(i+4,7)=document.getElementById("assAnDocSPz"+i).innerText;
        xlsSheet.cells(i+4,8)=document.getElementById("assAnDocBz"+i).innerText;
        xlsSheet.cells(i+4,9)=document.getElementById("assAnDocMz"+i).innerText;
        xlsSheet.cells(i+4,10)=document.getElementById("assAnDocSMz"+i).innerText;
        xlsSheet.cells(i+4,11)=document.getElementById("assAnDocAllz"+i).innerText;      
        xlsSheet.cells(i+4,12)=document.getElementById("anNurSPz"+i).innerText;
        xlsSheet.cells(i+4,13)=document.getElementById("anNurBz"+i).innerText;
        xlsSheet.cells(i+4,14)=document.getElementById("anNurMz"+i).innerText;
        xlsSheet.cells(i+4,15)=document.getElementById("anNurSMz"+i).innerText;
        xlsSheet.cells(i+4,16)=document.getElementById("anNurAllz"+i).innerText;      
    }
    gridlist(xlsSheet,3,objtbllength+3,1,col);
    mergcell(xlsSheet,objtbllength+4,1,col);
	xlsSheet.cells(objtbllength+4,1)=t['val:printloc']+" "+logonLocDesc+"    "+t['val:printuser']+" "+userCode+"    "+t['val:printdate']+" "+printDate;     
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