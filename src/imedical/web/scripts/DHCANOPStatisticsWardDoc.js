//DHCANOPStatisticsWardDoc.JS

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
    var objtbl=document.getElementById('tDHCANOPStatisticsWardDoc');
    if (objtbl.rows.length<2) return;
    var objtbllength=objtbl.rows.length;
    var WardLoc= parent.frames[0].document.getElementById("WardLoc").value;
	if (WardLoc=="") {alert(t['val:selloc']);return;}
    var tmpWardLoc=WardLoc.split("-");
	if (tmpWardLoc.length>1) WardLoc=tmpWardLoc[1];
    path=GetFilePath();
    fileName=path+"warddoc.xls";
	xlsExcel = new ActiveXObject("Excel.Application");
	xlsBook = xlsExcel.Workbooks.Add(fileName);
	xlsSheet = xlsBook.ActiveSheet;
	
	var col=26; //设置共打印26列
	//报表列显示内容都写在模版里面warddoc.xls,共26列,第二行要左对齐
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
        xlsSheet.cells(i+4,1)=document.getElementById("opDocz"+i).innerText;
        xlsSheet.cells(i+4,2)=document.getElementById("opDocSPz"+i).innerText;
        xlsSheet.cells(i+4,3)=document.getElementById("opDocBz"+i).innerText;
        xlsSheet.cells(i+4,4)=document.getElementById("opDocMz"+i).innerText;
        xlsSheet.cells(i+4,5)=document.getElementById("opDocSMz"+i).innerText;
        xlsSheet.cells(i+4,6)=document.getElementById("opDocAllz"+i).innerText;
        xlsSheet.cells(i+4,7)=document.getElementById("assistDocISPz"+i).innerText;
        xlsSheet.cells(i+4,8)=document.getElementById("assistDocIBz"+i).innerText;
        xlsSheet.cells(i+4,9)=document.getElementById("assistDocIMz"+i).innerText;
        xlsSheet.cells(i+4,10)=document.getElementById("assistDocISMz"+i).innerText;
        xlsSheet.cells(i+4,11)=document.getElementById("assistDocIAllz"+i).innerText;      
        xlsSheet.cells(i+4,12)=document.getElementById("assistDocIISPz"+i).innerText;
        xlsSheet.cells(i+4,13)=document.getElementById("assistDocIIBz"+i).innerText;
        xlsSheet.cells(i+4,14)=document.getElementById("assistDocIIMz"+i).innerText;
        xlsSheet.cells(i+4,15)=document.getElementById("assistDocIISMz"+i).innerText;
        xlsSheet.cells(i+4,16)=document.getElementById("assistDocIIAllz"+i).innerText;      
        xlsSheet.cells(i+4,17)=document.getElementById("assistDocIIISPz"+i).innerText;
        xlsSheet.cells(i+4,18)=document.getElementById("assistDocIIIBz"+i).innerText;
        xlsSheet.cells(i+4,19)=document.getElementById("assistDocIIIMz"+i).innerText;
        xlsSheet.cells(i+4,20)=document.getElementById("assistDocIIISMz"+i).innerText;
        xlsSheet.cells(i+4,21)=document.getElementById("assistDocIIIAllz"+i).innerText;      
        xlsSheet.cells(i+4,22)=document.getElementById("assistDocIVSPz"+i).innerText;
        xlsSheet.cells(i+4,23)=document.getElementById("assistDocIVBz"+i).innerText;
        xlsSheet.cells(i+4,24)=document.getElementById("assistDocIVMz"+i).innerText;
        xlsSheet.cells(i+4,25)=document.getElementById("assistDocIVSMz"+i).innerText;
        xlsSheet.cells(i+4,26)=document.getElementById("assistDocIVAllz"+i).innerText;
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