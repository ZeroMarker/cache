var hospname;
var prnpath;
var PCODROWID ;
function BodyLoadHandler()
{	
	//
	var obj=document.getElementById("PCODROWID") ;
	if (obj) PCODROWID=obj.value;
	//Print();    //print mode of Anhui,JiShuiTan
	PrintShaoGuan(); //print mode of ShaoGuan
	
	window.close();
}

function Print()
{  //print mode for AnHui,Jst
	var cnt ;

 	if (PCODROWID=="" ) return ;
	var obj=document.getElementById("mPrtHospName") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	hospname=cspRunServerMethod(encmeth,'','') ;
	//alert("hospname:"+hospname);

	var obj=document.getElementById("mGetPrnPath") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	prnpath=cspRunServerMethod(encmeth,'','') ;
	if (prnpath=="") {
		alert(t["CANNOT_FIND_TEM"]) ;
		return ;
		}

	//retrieving primary dispensing infomation...
	var startNo=6;
	var DispUser=session['LOGON.USERNAME']
	//
	var Template=prnpath+"STP_DrugOut.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	

    var i ;
	if (xlsheet==null) 
	{alert(t["CANNOT_CREATE_PRNOBJ"]);
		return ;
	}

	var obj=document.getElementById("mGetOutCollect") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var data=cspRunServerMethod(encmeth,PCODROWID) ;
	var ss=data.split("^");
	var pid=ss[1];
	cnt=ss[0];
	
	//if not items the quit
	if (cnt<1) 
	{
		alert(t['NO_ ANY_ITEMS']) ;
		return ;
	}
	
	var i;
	var pano;
	var paname;
	var pasex;
	var paage;
	var disploc;
	var sumamt=0;
	var warddesc ;
	var diagnose;
	var idno ;
	var withdmy;
	var doctorname ;
	
	var objList=document.getElementById("mListOutCollect") ;
	if (objList) {xxxx=objList.value;} else {xxxx='';}
	var data=cspRunServerMethod(xxxx,pid,1);
	var ss=data.split("^");
	//alert(ss)
	pano=ss[0];
	paname=ss[1];
	pasex=ss[2];
	paage=ss[3];
	disploc=ss[19];
	warddesc=ss[22];
	diagnose=ss[20];
	idno=ss[21];
	withdmy=ss[23];
	doctorname=ss[6];
	
	//alert(warddesc);
	
	xlsheet.Cells(1, 1).Value = hospname;  //hospital description
    if (withdmy=="1") xlsheet.Cells(2, 1).Value=xlsheet.Cells(2, 1).Value+"(" +t['WITH_DMY']+")"
 
	xlsheet.Cells(3, 1).Value=t['PA_NO']+pano+"     "+t['WARD']+FilterDesc(getDesc(warddesc),"病区");
	xlsheet.Cells(3, 2).Value=t['PA_NAME']+paname +"    "+t['PA_SEX']+pasex+"    "+t['PA_AGE']+paage;
		
	xlsheet.Cells(4, 1).Value=t['PHARMACY']+getDesc(disploc);
	xlsheet.Cells(4, 2).Value=t['PRINTDATE']+getPrintDateTime();
	
	xlsheet.Cells(5, 1).Value=t['DIAGNOSE']+diagnose;
	if (withdmy=="1") xlsheet.Cells(5, 2).Value=t['ID_NO']+idno;

	for (i=1;i<=cnt;i++)  
	{
		var data=cspRunServerMethod(xxxx,pid,i) ;
		var ss=data.split("^")
		var desc=ss[8];
		//var dosqty=ss[10];
		var freq= ss[11];
	
		var qty= ss[12];
		var uom=ss[13];
		var saleprice=ss[14];
		var amt=ss[15];
		var instruction=ss[16];
		var dmyflag=ss[24];
		
		sumamt=parseFloat(sumamt)+parseFloat(amt)
		xlsheet.Cells(startNo+i, 1).Value =desc ; //desc
		xlsheet.Cells(startNo+i, 2).Value =qty // qty
		xlsheet.Cells(startNo+i, 3).Value =uom // unit 
		xlsheet.Cells(startNo+i, 4).Value =saleprice // sp
		xlsheet.Cells(startNo+i, 5).Value =amt // amount
		xlsheet.Cells(startNo+i, 6).Value =freq // freq
		xlsheet.Cells(startNo+i, 7).Value =instruction // instruction
		xlsheet.Cells(startNo+i, 8).Value =dmyflag  //dmy flag 
	}
	row=startNo+i
	setBottomLine(xlsheet,row,1,7)
	
	row++;
	xlsheet.Cells(row, 1).Value=t['DOCTOR']+doctorname
	row++;
	sumamt=sumamt.toFixed(2)
	xlsheet.Cells(row, 1).Value =t['SUM_AMT']+sumamt

    row+=2;
    //xlsheet.Cells(row,1).value= ;
    mergcell(xlsheet,row,1,7)
    //xlsheet.Cells(row,1).value=t['DISPEN_USER']+DispUser+"                  "+t['REC_USER'];
    
    xlsheet.Cells(row,1).value=t['OPUSER']+DispUser+"               "+t['DISPEN_USER'] + "                " +t['AUDITOR'];
	
	xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet)
}
/*--------------------------------the printing for Shao Guan----------------------------------*/
function PrintShaoGuan()
{  // print mode for ShaoGuan
	var cnt ;
	var i;
	var pano;
	var paname;
	var pasex;
	var paage;
	var disploc;
	var ward;                
	var bed;
	var dispno;
	var diagnose;
	var sum=0;      //合计
	var startNo=5;
	var i ;
	
 	if (PCODROWID=="" ) return ;
	var obj=document.getElementById("mPrtHospName") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	hospname=cspRunServerMethod(encmeth,'','') ;
	//alert("hospname:"+hospname);

	var obj=document.getElementById("mGetPrnPath") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	prnpath=cspRunServerMethod(encmeth,'','') ;
	if (prnpath=="") {
		alert(t["CANNOT_FIND_TEM"]) ;
		return ;
		}

	//retrieving primary dispensing infomation...
	var DispUser=session['LOGON.USERNAME']
	//
	var Template=prnpath+"STP_DrugOut.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	
   
	if (xlsheet==null) 
	{alert(t["CANNOT_CREATE_PRNOBJ"]);
		return ;
	}

	var obj=document.getElementById("mGetOutCollect") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var data=cspRunServerMethod(encmeth,PCODROWID) ;
	var ss=data.split("^");
	var pid=ss[1];
	cnt=ss[0];
	
	//if not items the quit
	if (cnt<1) 
	{
		alert(t['NO_ ANY_ITEMS']) ;
		return ;
	}
	var objList=document.getElementById("mListOutCollect") ;
	if (objList) {xxxx=objList.value;} else {xxxx='';}
	var data=cspRunServerMethod(xxxx,pid,1);
	var ss=data.split("^");
	//alert(ss)
	pano=ss[0];
	paname=ss[1];
	pasex=ss[2];
	paage=ss[3];
	ward=ss[25];
	bed=ss[26];
	disploc=ss[19];
	dispno=ss[29];
	diagnose=ss[20];
	
	xlsheet.Cells(1, 1).Value = hospname;  //hospital description
	
	xlsheet.Cells(3,1).Value=t['WARD']+getDesc(ward);
	xlsheet.Cells(3,2).Value=t['PRINTDATE']+getPrintDateTime();
	xlsheet.Cells(3,3).Value=t['DISPNO']+dispno;
	
	xlsheet.Cells(4, 1).Value=t['PA_NO']+pano;
	xlsheet.Cells(4, 2).Value=t['PA_NAME']+paname;
	//xlsheet.Cells(4, 3).Value=t['PA_SEX']+pasex;
	xlsheet.Cells(4, 3).Value=t['PA_AGE']+paage;
	xlsheet.Cells(4, 4).Value=t['BED']+bed;
	xlsheet.Cells(4, 6).Value=t['DIAGNOSE']+diagnose;
		
	//xlsheet.Cells(4, 1).Value=t['PHARMACY']+getDesc(disploc);
	//xlsheet.Cells(4, 2).Value=t['PRINTDATE']+getPrintDateTime();

	for (i=1;i<=cnt;i++)  
	{
		var data=cspRunServerMethod(xxxx,pid,i) ;
		var ss=data.split("^")
		var desc=ss[8];
		var alias=ss[27];
		var dosqty=ss[28];
		var freq= ss[11];
	
		var qty= ss[12];
		var uom=ss[13];
		var saleprice=ss[14];
		var amt=ss[15];
		//var prescno= ss[5];  //prescript No
		//var ordstatus=ss[9] ;
		var instruction=ss[16];
		//var duration= ss[17];
		//var admloc=ss[4] ;
		xlsheet.Cells(startNo+i, 1).Value =desc ; //desc
		xlsheet.Cells(startNo+i, 2).Value=alias;
		xlsheet.Cells(startNo+i, 3).Value =uom; // unit 
		xlsheet.Cells(startNo+i, 4).Value =qty; // qty
		xlsheet.Cells(startNo+i, 5).Value=dosqty;
		xlsheet.Cells(startNo+i, 6).Value=freq;
		xlsheet.Cells(startNo+i, 7).Value=instruction;
		xlsheet.Cells(startNo+i, 8).Value =saleprice // sp
		xlsheet.Cells(startNo+i, 9).Value =amt // amount
		
		sum=parseFloat(sum)+parseFloat(amt);
	}
    
    //xlsheet.Cells(row,1).value= ;
    //合计
    xlsheet.Cells(startNo+i, 1).Value=t['SUMMATION']
    xlsheet.Cells(startNo+i, 2).Value=cnt;
    xlsheet.Cells(startNo+i, 9).Value=sum;
    
    row=startNo+i+1;
    //xlsheet.Cells(row,1).value=t['DISPEN_USER']+DispUser;
    //xlsheet.Cells(row,4).value=t['REC_USER']
    //统计?调配?发药?签收?送药
    xlsheet.Cells(row, 1).Value=t['STATISTIC']+"              "+t['PREPARE']+"             "+t['DISP']+"               "+t['RECIEVE']+"               "+t['SEND'];
    mergcell(xlsheet,row,1,9);
	setLine(xlsheet,startNo,1,startNo+i,9);
	//xlsheet.PrintPreview();
	
	xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet)
}

function setLine(objSheet,startrow,startcol,endrow,endcol)
{
    objSheet.Range(objSheet.Cells(startrow, startcol), objSheet.Cells(endrow, endcol)).Borders.LineStyle=1 ;
}

document.body.onload=BodyLoadHandler;
