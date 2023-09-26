//DHCANOPStatisticsOpNur.JS

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
    var objtbl=document.getElementById('tDHCANOPStatisticsOpNur');
    if (objtbl.rows.length<2) return;
    var objtbllength=objtbl.rows.length;
    var WardLoc= parent.frames[0].document.getElementById("OpLoc").value;
	if (WardLoc=="") {alert(t['val:selloc']);return;}
	var tmpWardLoc=WardLoc.split("-");
	if (tmpWardLoc.length>1) WardLoc=tmpWardLoc[1];
    path=GetFilePath();
    fileName=path+"opnur.xls";
	xlsExcel = new ActiveXObject("Excel.Application");
	xlsBook = xlsExcel.Workbooks.Add(fileName);
	xlsSheet = xlsBook.ActiveSheet;
	
	var col=23; //设置共打印23列
	var row=5;  //设置从第5行开始打印数据
	//报表列显示内容都写在模版里面opnur.xls,共23列,第二行要左对齐
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
        xlsSheet.cells(i+row,1)=document.getElementById("opNurz"+i).innerText;
        xlsSheet.cells(i+row,2)=document.getElementById("instrNurSPz"+i).innerText;
        xlsSheet.cells(i+row,3)=document.getElementById("instrNurSPHz"+i).innerText;
        xlsSheet.cells(i+row,4)=document.getElementById("instrNurBz"+i).innerText;
        xlsSheet.cells(i+row,5)=document.getElementById("instrNurBHz"+i).innerText;
        xlsSheet.cells(i+row,6)=document.getElementById("instrNurMz"+i).innerText;
        xlsSheet.cells(i+row,7)=document.getElementById("instrNurMHz"+i).innerText;
        xlsSheet.cells(i+row,8)=document.getElementById("instrNurSMz"+i).innerText;
        xlsSheet.cells(i+row,9)=document.getElementById("instrNurSMHz"+i).innerText;
        xlsSheet.cells(i+row,10)=document.getElementById("instrNurAllz"+i).innerText;
        xlsSheet.cells(i+row,11)=document.getElementById("instrNurAllHz"+i).innerText;      
        xlsSheet.cells(i+row,12)=document.getElementById("cirNurSPz"+i).innerText;
        xlsSheet.cells(i+row,13)=document.getElementById("cirNurSPHz"+i).innerText;
        xlsSheet.cells(i+row,14)=document.getElementById("cirNurBz"+i).innerText;
        xlsSheet.cells(i+row,15)=document.getElementById("cirNurBHz"+i).innerText;
        xlsSheet.cells(i+row,16)=document.getElementById("cirNurMz"+i).innerText;    
        xlsSheet.cells(i+row,17)=document.getElementById("cirNurMHz"+i).innerText;      
        xlsSheet.cells(i+row,18)=document.getElementById("cirNurSMz"+i).innerText;      
        xlsSheet.cells(i+row,19)=document.getElementById("cirNurSMHz"+i).innerText;      
        xlsSheet.cells(i+row,20)=document.getElementById("cirNurAllz"+i).innerText;      
        xlsSheet.cells(i+row,21)=document.getElementById("cirNurAllHz"+i).innerText;      
        xlsSheet.cells(i+row,22)=document.getElementById("opNurAllz"+i).innerText;      
        xlsSheet.cells(i+row,23)=document.getElementById("opNurAllHz"+i).innerText;      
    }
    gridlist(xlsSheet,3,objtbllength+row-1,1,col);
    mergcell(xlsSheet,objtbllength+row,1,col);
	xlsSheet.cells(objtbllength+row,1)=t['val:printloc']+" "+logonLocDesc+"    "+t['val:printuser']+" "+userCode+"    "+t['val:printdate']+" "+printDate;     
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