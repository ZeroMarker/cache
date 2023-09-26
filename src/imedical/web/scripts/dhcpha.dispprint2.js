
var hospname;
var prnfmt;
var phac ;  //Rowid of dispensing
var disptype; 
var prnpath;
var grp;
var isHz=0  // "hz" print mode
var ProcessID ;
var TotalCnt ;
var DetailCnt ;
var cnt;
var idTmr=""	
function BodyLoadHandler()
{
	grp=session['LOGON.GROUPID'];
	
	var obj=document.getElementById("Phac") ;
	if (obj) phac=obj.value ;
	//alert("phac:"+phac)
	//dispensing type
	var obj=document.getElementById("mPrtGetGetDispType") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	disptype=cspRunServerMethod(encmeth,'','',phac) ;
	//alert("disptype:"+disptype)
	//
	var obj=document.getElementById("mPrtHospName") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	hospname=cspRunServerMethod(encmeth,'','') ;
	//alert("hospname:"+hospname);
	//	
	var obj=document.getElementById("mPrtGetPrintFmt") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	prnfmt=cspRunServerMethod(encmeth,'','',phac) ;
	//alert("prnfmt:"+prnfmt)
	
	//if (prnfmt!="O")
	//{
	//	var obj=document.getElementById("mPrtHz") ;
	//	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	//	isHz=cspRunServerMethod(encmeth,'','',grp,disptype) ;
	//	var obj=document.getElementById("PrtHz");
	//	if (obj) obj.value=isHz ;
	//}
	//
	var obj=document.getElementById("PrtHz")
	if (obj) isHz=obj.value ;
	
	isHz=1
	
	// 
	var obj=document.getElementById("mGetPrnPath") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	prnpath=cspRunServerMethod(encmeth,'','') ;
	//
	//Prnt(phac)	
	printAll(phac)//2007-20-31
	window.close();
	}
function getDispMainInfo(phac)
{
	var obj=document.getElementById("mGetPhcDispM") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ss=cspRunServerMethod(encmeth,'','',phac) ;
	return ss ;
}

function getVal(colname,row)
{
	var obj=document.getElementById(colname+"z"+row)
	if (obj) result=obj.innerText ;
	return result 
}	
function printAll(phacStr) //2007-10-31  lq
{
	
	var i;
	var phaType;

	if(phacStr!="")
	{
		phacArr=phacStr.split("A");
		
	}

	for(i=0;i<phacArr.length;i++)
	{
		
		phaType=GetDispType(phacArr[i]);
		GetPrintFormat(phacArr[i]);
		Prnt(phacArr[i],phaType);
	}
}


function GetDispType(phac)//2007-10-31 lq
{
	 //dispensing type
     var obj=document.getElementById("mPrtGetGetDispType") ;
     if (obj) {var encmeth=obj.value;} else {var encmeth='';}
     disptype=cspRunServerMethod(encmeth,'','',phac) ;
     
     return disptype;
}


function GetPrintFormat(phac)  //2007-10-31 lq
{
	 var obj=document.getElementById("mPrtGetPrintFmt") ;
     if (obj) {var encmeth=obj.value;} else {var encmeth='';}
     gPrnfmt=cspRunServerMethod(encmeth,'','',phac) ;
}

//function Prnt(phac)
function Prnt(phac,phatype)
{ 
    if (phac=="")  return 0 ;
   // var phatype=disptype;
    
 	var tmps=getDispMainInfo(phac);
	if (tmps=="" ) return;
	var tmparr=tmps.split("^");
	var PhaLoc=tmparr[0] ;
	var WardName=tmparr[1] ;
    if (WardName=="0") 
    {   
      PrintMZ(phac,phatype)
      return ;
    }
	switch (phatype) {
		

		case "ZJ":
		   if (isHz==1)   
		   {
			 PrintFYHX(phac,phatype);//发药华西
			 PrintBYHX(phac,phatype);//摆药华西
		   }
		   //  PrintMZ(phac,phatype)  PrintHz(phac,phatype)  ;
		   //PrintZJ(phac,phatype)  以下注释为华西上线之前沿用打印 
	   	   else  PrintElse(phac,phatype);
			break;
		case "DSY":
		   if (isHz==1)  
		   {
			 PrintFYHX(phac,phatype);//发药华西
			 PrintBYHX(phac,phatype);//摆药华西
		   }
		   //PrintHz(phac,phatype)  ;
	   	   else  PrintElse(phac,phatype);
			break;
		case "KFY":
		   if (isHz==1)  {
		   PrintFYHX(phac,phatype);
		   PrintBYHX(phac,phatype);}
		  // PrintPJ(phac,phatype);  
		   else  Print2(phac,phatype); 
			break;
		case "WYY":
		   if (isHz==1)  PrintPJ(phac,phatype);  
		   else  Print2(phac,phatype); 
			break;
		case "MZYP":
		 if (isHz==1)  {
		   PrintFYHX(phac,phatype);
		   PrintBYHX(phac,phatype);}
		 //PrintMZ(phac,phatype) ;
		   else  Print2(phac,phatype); 
		 // if (isHz==1) PrintPJ(phac,phatype) ;
		//  else  Print2(phac,phatype); 
		   
		   break;
		case "JSYP":
		   if (isHz==1)   {
		   PrintFYHX(phac,phatype);
		   PrintBYHX(phac,phatype);}
		   //PrintPJ(phac,phatype);  
		   else  Print2(phac,phatype); 
			break;
		case "QT":
		   if (isHz==1)  PrintPJ(phac,phatype);  //PrintMZ(phac,phatype)   PrintHz(phac,phatype)  ;
		   else  Print2(phac,phatype); 
		   break;
		   
		   
	   }
	   
   	KillTmp();
}

function PrintElse(phac,phatype)
{
	//retrieving primary dispensing infomation...
	var tmps=getDispMainInfo(phac) ;
	if (tmps=="" ) return;
	var tmparr=tmps.split("^");
	var PhaLoc=tmparr[0] ;
	var WardName=tmparr[1] ;
	var PRTDATE=tmparr[6] ;
	var PRTTIME=tmparr[8];
	var dispsd=tmparr[2] ;
	var disped=tmparr[3] ;
	var dispUser=tmparr[5] ;
	var PrtType1=tmparr[4] ;
	var DateRange=dispsd+"--"+disped;
			
	var objtbl=document.getElementById("t"+"dhcpha_dispprint")
	if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return ;	   

	//start printing ...
	if (prnpath=="") {
		alert(t["CANNOT_FIND_TEM"]) ;
		return ;
		}
	var Template=prnpath+"STP_Else.XLS";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;
    var startNo=7 ;
    var row ;

	if (xlsheet==null) 
	{	
		alert(t["CANNOT_CREATE_PRNOBJ"]);
		return ;		}
	xlsheet.Cells(2, 1).Value = hospname;  //hospital description
	xlsheet.Cells(3, 1).Value = t['WARD_DRUGLIST']		//"ward bills of dispensing";
	xlsheet.Cells(4, 1).Value = t['PHARMACY']	+ getDesc(PhaLoc);   //"pharmacy:" 
	xlsheet.Cells(5, 1).Value=t['DISPCAT'] + getDispCatDesc(PrtType1) +"    "+ t['WARD'] + getDesc(WardName) + "    " + t['DISPDATE']+ DateRange + "   " + t['PRINTDATE']+getPrintDateTime();
    //
    for (var i=1;i<=cnt;i++)
    {//	
		var bedcode=getVal("bedcode",i);
		var name=getVal("paname",i);
		var paregno= getVal("pano",i);
		var orditemdesc=getVal("orditemdesc",i);
		var dosqty=getVal("dosqty",i);
		var freq= getVal("freq",i);
		var type=getVal("",i);
		var qty= getVal("qty",i);
		var uom=getVal("uom",i);
		var saleprice=getVal("sp",i);
		var prescno= getVal("prescno",i);  //prescript No
		var ordstatus=getVal("ordstatus",i) ;
		var instruction=getVal("instruction",i);
		var duration= getVal("duration",i);
		var admloc=getVal("admloc",i) ;
    		 
    	row=startNo+i ;     			
	    xlsheet.Cells(row, 1).Value =orditemdesc;//orderitem description 
	    xlsheet.Cells(row, 2).Value =admloc; //adm loc
	    xlsheet.Cells(row, 3).Value =name ; //patient name
	    xlsheet.Cells(row, 4).Value =paregno; //register No
	    xlsheet.Cells(row, 5).Value =bedcode; //bed code
	    xlsheet.Cells(row, 6).Value =qty; //qty
	    xlsheet.Cells(row, 7).Value =uom;	// uom
	    xlsheet.Cells(row, 8).Value =saleprice; // sale price
	    xlsheet.Cells(row, 9).Value =ordstatus; //  order status
	    xlsheet.Cells(row, 10).Value =type ;//dispensing type
	    xlsheet.Cells(row, 11).Value =dosqty;// dose qty   //
	    xlsheet.Cells(row, 12).Value =freq; // frequency
	    xlsheet.Cells(row, 13).Value =instruction; //instruction
	    xlsheet.Cells(row, 14).Value =duration;  //duration
	    xlsheet.Cells(row, 15).Value =prescno;  //prescript No
		setBottomLine(xlsheet,row,1,15)
	    		    }
    
    row=row+2;
    xlsheet.Cells(row,1).value=t['DISPEN_USER'] ;
    xlsheet.Cells(row,2).value=dispUser;
    xlsheet.Cells(row,3).value=t['REC_USER']
    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);	

	}

function  Print3(phac,phatype)
   { //ZCHY\ZCY
	//retrieving primary dispensing infomation...
	var tmps=getDispMainInfo(phac);
	if (tmps=="" ) return;
	var tmparr=tmps.split("^");
	var PhaLoc=tmparr[0] ;
	var WardName=tmparr[1] ;
	var PRTDATE=tmparr[6] ;
	var PRTTIME=tmparr[8];
	var dispsd=tmparr[2] ;
	var disped=tmparr[3] ;
	var dispUser=tmparr[5] ;
	var PrtType1=tmparr[4] ;
	var DateRange=dispsd+"--"+disped;
	
	var objtbl=document.getElementById("t"+"dhcpha_dispprint")
	if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return ;	   

	//start printing ...
	if (prnpath=="") {
		alert(t["CANNOT_FIND_TEM"]) ;
		return ;
		}
	var Template=prnpath+"STP_Zchy.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;
    var startNo=7 ;
    var i ;		

	if (xlsheet==null) 
	{	alert(t["CANNOT_CREATE_PRNOBJ"]);
		return ;		
	}
	xlsheet.Cells(2, 1).Value = hospname;  //hospital description
	xlsheet.Cells(3, 1).Value =t['WARD_DRUGLIST']  // "ward bills of dispensing";
	xlsheet.Cells(4, 1).Value = t['PHARMACY'] + getDesc(PhaLoc);   //]"pharmacy:"
	xlsheet.Cells(5, 1).Value=t['DISPCAT'] + getDispCatDesc(PrtType1) +"    "+ t['WARD'] + getDesc(WardName) + "    " + t['DISPDATE']+ DateRange + "   " +t['PRINTDATE'] + getPrintDateTime();
    //
    for (i=1;i<=cnt;i++)
    {
		var bedcode=getVal("bedcode",i);
		var name=getVal("paname",i);
		var paregno= getVal("pano",i);
		var orditemdesc=getVal("orditemdesc",i);
		var dosqty=getVal("dosqty",i);
		var freq= getVal("freq",i);
		var type=getVal("",i);
		var qty= getVal("qty",i);
		var uom=getVal("uom",i);
		var saleprice=getVal("sp",i);
		var prescno= getVal("prescno",i);  //prescript No
		var ordstatus=getVal("ordstatus",i) ;
		var instruction=getVal("instruction",i);
		var duration= getVal("duration",i);
		var admloc=getVal("admloc",i) ;
	    
	    xlsheet.Cells(startNo+i, 1).Value =bedcode ;		//bed code
	    xlsheet.Cells(startNo+i, 2).Value =name //patient name
	    xlsheet.Cells(startNo+i, 3).Value =orditemdesc  //orderitem description 
	    xlsheet.Cells(startNo+i, 4).Value =qty // qty
	    xlsheet.Cells(startNo+i, 5).Value =uom// uom
	    xlsheet.Cells(startNo+i, 6).Value =prescno // prescript No
	    xlsheet.Cells(startNo+i, 7).Value =paregno // register No
   	   setBottomLine(xlsheet,startNo+i,1,7)
	    }
    row=startNo+i+2;
    xlsheet.Cells(row,1).value=t['DISPEN_USER'] ;
    xlsheet.Cells(row,2).value=dispUser;
    xlsheet.Cells(row,3).value=t['REC_USER']
    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);	   
   }
   
function PrintPJ(phac,phatype)
{
	var tmps=getDispMainInfo(phac)
	if (tmps=="" ) return;
	var tmparr=tmps.split("^");
	var PhaLoc=tmparr[0] ;
	var WardName=tmparr[1] ;
	var PRTDATE=tmparr[6] ;
	var PRTTIME=tmparr[8];
	var dispsd=tmparr[2] ;
	var disped=tmparr[3] ;
	var dispUser=tmparr[5] ;
	var PrtType1=tmparr[4] ;
	var DateRange=dispsd+"--"+disped;
	
	var DispNo=tmparr[9] ;
	var DisTypeDesc=tmparr[10] ;
    var amt=tmparr[11] ;
    
	var tmpRegno="";
			
	getDispDetail(phac)
	if (DetailCnt<1) return ;
   
	//start printing ...
	if (prnpath=="") {
		alert(t["CANNOT_FIND_TEM"]) ;
		return ;		}
	var Template=prnpath+"STP_PJ_AH.xls";
	//var Template="C:\\STP_PJ_AH.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;
    var startNo=7 ;
    var row ;

	if (xlsheet==null) 
	{	alert(t["CANNOT_CREATE_PRNOBJ"]);
		return ;		}
	
	xlsheet.Cells(2, 1).Value = hospname+ getDesc(PhaLoc)+DisTypeDesc+t['COLL_BILL']  //hospital description
	xlsheet.Cells(3, 1).Value = t['DISP_NO'] +DispNo
	xlsheet.Cells(4, 1).Value = t['WARD'] 
	xlsheet.Cells(4, 2).Value = FilterDesc(getDesc(WardName),"t['WARD']")
	xlsheet.Cells(4, 5).Value= t['DISPDATE'] +PRTDATE+" "+PRTTIME  +"   " +t['PRINTDATE']+getPrintDateTime();
	//fontcell(xlsheet,4,1,1,14)
	   
    row=startNo;
	
	var exeDetail;
	var obj=document.getElementById("mListDispDetail")
	if (obj) exeDetail=obj.value;
	else exeDetail=""
	
    for (var i=1;i<=DetailCnt;i++)
	{	    
		var ss=cspRunServerMethod(exeDetail,ProcessID,i)   
		var datas=ss.split("^")
		
		var bedcode=datas[5]
		var name=datas[1]
		var paregno=datas[0]
		var orditemdesc=datas[10]
		var dosqty=datas[13]
		var freq= datas[14]

		var qty=datas[15]
		var uom=datas[16]
		var saleprice=datas[17]
		var prescno=datas[7] 
		var ordstatus=datas[12]
		var instruction=datas[20]
		var duration= datas[21]
		var manf=datas[25]
		var spec=datas[26];
		var eatdrugtime=datas[27] 
		if ((tmpRegno!="")&&(paregno!=tmpRegno) )
	     { //setBottomLine(xlsheet,row,1,10) 
	     setBottomDblLine(xlsheet,row,1,9)
	     
	     }
    	row++;     			
	    //xlsheet.Cells(row, 1).Value =bedcode;//bed code
	    //xlsheet.Cells(row, 2).Value =name; //patient name
	    //xlsheet.Cells(row, 3).Value =paregno ; //register No
    	if (tmpRegno=="")
    	{	
    	   	xlsheet.Cells(row, 1).Value =FilterDesc(bedcode,"床");//bed code
		    xlsheet.Cells(row, 2).Value =name; //patient name
		   xlsheet.Cells(row, 7).Value ="住院号:"
	       fontcell(xlsheet,row,1,1,12)
		   xlsheet.Cells(row, 9).Value =paregno ; //register No
	       fontcell(xlsheet,row,1,1,12)
		   // setBottomLine(xlsheet,row,1,3)
		    row++

		}
    	else
    	{if (paregno!=tmpRegno)
    		{   //row=row+1;
 	    	xlsheet.Cells(row, 1).Value =FilterDesc(bedcode,"床");//bed code
		    //mergcell(xlsheet,row,2,10)
		    xlsheet.Cells(row, 2).Value =name; //patient name
		   xlsheet.Cells(row, 7).Value ="住院号:"
	       fontcell(xlsheet,row,1,1,12)
		   xlsheet.Cells(row, 9).Value =prescno ; //register No
	       fontcell(xlsheet,row,1,1,12)
		   // setBottomLine(xlsheet,row,1,3)
		    row++
    		}
    	}
    	
    	xlsheet.Cells(row, 3).Value =paregno;
        xlsheet.Cells(row, 4).Value =NameTran(orditemdesc); //orderitem description 
	    xlsheet.Cells(row, 5).Value =dosqty //
	    xlsheet.Cells(row, 6).Value =freq //  
	    xlsheet.Cells(row, 7).Value = eatdrugtime        //  用药时间  
	    //xlsheet.Cells(row, 8).Value =qty; //  
	    xlsheet.Cells(row, 8).Value =uom; //
	    xlsheet.Cells(row, 9).Value =getDesc(manf) ;// 
	    //xlsheet.Cells(row, 10).Value =spec ;// 
	   
	   // xlsheet.Cells(row, 11).Value =freq ;// frequency
	   // xlsheet.Cells(row, 12).Value ="" ; //instruction
	   // xlsheet.Cells(row, 13).Value =duration; //duration
	   // xlsheet.Cells(row, 14).Value =prescno;  //prescript No
		setBottomLine(xlsheet,row,4,7)
		tmpRegno=paregno;
    }
	setBottomLine(xlsheet,row,1,9)
	row=row+2;
	mergcell(xlsheet,row,1,8)
    xlsheet.Cells(row,1).value=t['SUM_AMT'] +"  "+ amt
	
    row++
	mergcell(xlsheet,row,1,8)
    xlsheet.Cells(row,1).value=t['PRINT_USER'] +dispUser  + "      "+t['DISPEN_USER']+"               " +t['REC_USER'];
    fontcell(xlsheet,row,1,1,12)
    
    	
	//xlsheet.Cells(row,4).value=t['DISPEN_USER']
    //fontcell(xlsheet,row,4,4,12)
 
    //xlsheet.Cells(row,7).value=t['REC_USER']
	//fontcell(xlsheet,row,7,7,12)
    
    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);
}


function PrintZJ(phac,phatype)
{
	//retrieving primary dispensing infomation...
	//
	var tmps=getDispMainInfo(phac);
	if (tmps=="" ) return;
	var tmparr=tmps.split("^");
	var PhaLoc=tmparr[0] ;
	var WardName=tmparr[1] ;
	var PRTDATE=tmparr[6] ;
	var PRTTIME=tmparr[8];
	var dispsd=tmparr[2] ;
	var disped=tmparr[3] ;
	var dispUser=tmparr[5] ;
	var PrtType1=tmparr[4] ;
	var DateRange=dispsd+"--"+disped;
	
	var DispNo=tmparr[9] ;
	var DisTypeDesc=tmparr[10] ;

	var objtbl=document.getElementById("t"+"dhcpha_dispprint")
	if (objtbl)  cnt=getRowcount(objtbl);
	if (cnt<=0) return ;
	//
	if (prnpath=="") {
		alert(t["CANNOT_FIND_TEM"]) ;
		return ;
		}
    var Template=prnpath+"STP_ZJ_AH.xls";
	//var Template="C:\\STP_ZJ_AH.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var  xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	
    var startNo=6 ;
    var i ;
	if (xlsheet==null) 
	{alert(t["CANNOT_CREATE_PRNOBJ"]);
		return ;
	}
	getDispHZ(phac);
	
	if (TotalCnt>0) 
	{
		xlsheet.Cells(2, 1).Value = hospname+ getDesc(PhaLoc)+DisTypeDesc+t['DISP_BILL'];  //hospital description
		xlsheet.Cells(4, 1).Value =  t['WARD'] + FilterDesc(getDesc(WardName),"病区") + "   "+ t['DISP_NO'] +DispNo + "   " + t['DISPDATE'] +PRTDATE+" "+PRTTIME+"   " + t['PRINTDATE']+getPrintDateTime()
		
 		var incicode="";
 		var incidesc;
 		var uom;
 		var sp;
 		var manf;
 		var qty;
 		var amt;
 		var sumamt=0;
 		var drugform ;
 		var bedsum;	
 	
 		var datas
 		
 		var exe ;
 		var serialNo=0
 		
 		var obj=document.getElementById("mListDispTotal2")
 		if (obj) exe=obj.value;
 		else  exe="" ;
 		//
 		
 		var mm=1;
 		var sumamt=0;
 		do 
 		{
	 		datas=cspRunServerMethod(exe,mm,ProcessID);
	 		if (datas!="")
	 		{
		 		var ss=datas.split("^");
		 		incicode=ss[0];
		 		incidesc=ss[1];
				uom=ss[3];
				sp=ss[2];
				manf=ss[7];
				qty=ss[4];
				amt=ss[5];
				sumamt+=parseFloat(amt)
				inci=ss[6];
		 		drugform=ss[8];
		 		bedsum=ss[2]
          
		 		serialNo++;
		 		
				xlsheet.Cells(startNo+serialNo, 1).Value =incidesc ;		///desc .
				xlsheet.Cells(startNo+serialNo, 2).Value =qty+" "+uom ;////manf
				xlsheet.Cells(startNo+serialNo, 3).Value = bedsum; //
				xlsheet.Cells(startNo+serialNo, 4).Value = drugform; // saleprice
				xlsheet.Cells(startNo+serialNo, 5).Value =getDesc(manf) ;//
				
		 		setBottomPieceLine(xlsheet,startNo+serialNo,1,5);
		 		//nxlcenter(xlsheet,startNo+serialNo,startNo+serialNo,1,5)
		 		mm++;
		 		}
	 		else 
	 		 	{mm=0}
 		} while (datas!="")
	}
	
    var row=startNo+serialNo;
	setBottomLine(xlsheet,row,1,5);
	
     row+=2;
    //xlsheet.Cells(row,1).value= ;
    //

     sumamt=sumamt.toFixed(2)
     xlsheet.Cells(row,1).value=t['SUM_AMT']+sumamt
    
    row++ ;
    
   mergcell(xlsheet,row,1,5)
    
   xlsheet.Cells(row,1).value=t['PRINT_USER']+session['LOGON.USERNAME']+"         " + t['CHECK_USER'] + "                   "  + t['DISPEN_USER'] + "                 "  + t['REC_USER'] ;
	//xlsheet.Cells(row,2).value=t['DISPEN_USER']      //+dispUser;
   // xlsheet.Cells(row,4).value=t['REC_USER']

	xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet)	
}

function Print2(phac,phatype)
   {//PJ
	//retrieving primary dispensing infomation...
	var tmps=getDispMainInfo(phac)
	if (tmps=="" ) return;
	var tmparr=tmps.split("^");
	var PhaLoc=tmparr[0] ;
	var WardName=tmparr[1] ;
	var PRTDATE=tmparr[6] ;
	var PRTTIME=tmparr[8];
	var dispsd=tmparr[2] ;
	var disped=tmparr[3] ;
	var dispUser=tmparr[5] ;
	var PrtType1=tmparr[4] ;
	var DateRange=dispsd+"--"+disped;
	
	var tmpRegno="";
			
	var objtbl=document.getElementById("t"+"dhcpha_dispprint")
	if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return ;	   

	//start printing ...
	if (prnpath=="") {
		alert(t["CANNOT_FIND_TEM"]) ;
		return ;
		}
	var Template=prnpath+"STP_PJ.xls";
	//var Template="http://192.168.2.82/trakcare/web/temp/STP_PJ.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;
    var startNo=7 ;
    var row ;

	if (xlsheet==null) 
	{	alert(t["CANNOT_CREATE_PRNOBJ"]);
		return ;		}
	xlsheet.Cells(2, 1).Value = hospname;  //hospital description
	xlsheet.Cells(3, 1).Value = t['WARD_DRUGLIST']  ; 	//"ward bills of dispensing";
	xlsheet.Cells(4, 1).Value =t['PHARMACY']  + getDesc(PhaLoc);		//"pharmacy:"
	xlsheet.Cells(5, 1).Value= t['DISPCAT'] +getDispCatDesc( PrtType1) +"    "+ t['WARD']+ getDesc(WardName) + "    " +t['DISPDATE']+ DateRange + "   " + t['PRINTDATE']+ getPrintDateTime();
    //
    row=startNo;
    for (var i=1;i<=cnt;i++)
    {//			 
		var bedcode=getVal("bedcode",i);
		var name=getVal("paname",i);
		var paregno= getVal("pano",i);
		var orditemdesc=getVal("orditemdesc",i);
		var dosqty=getVal("dosqty",i);
		var freq= getVal("freq",i);
		var type=getVal("",i);
		var qty= getVal("qty",i);
		var uom=getVal("uom",i);
		var saleprice=getVal("sp",i);
		var prescno= getVal("prescno",i);  //prescript No
		var ordstatus=getVal("ordstatus",i) ;
		var instruction=getVal("instruction",i);
		var duration= getVal("duration",i);
		var admloc=getVal("admloc",i) ;
	
    	row=row+1 ;     			
	    //xlsheet.Cells(row, 1).Value =bedcode;//bed code
	    //xlsheet.Cells(row, 2).Value =name; //patient name
	    //xlsheet.Cells(row, 3).Value =paregno ; //register No
    	if (tmpRegno=="")
    	{	    	xlsheet.Cells(row, 1).Value =bedcode;//bed code
		    xlsheet.Cells(row, 2).Value =name; //patient name
		    xlsheet.Cells(row, 3).Value =paregno ; //register No
		}
    	else
    	{if (paregno!=tmpRegno)
    		{row=row+3;
 	    	xlsheet.Cells(row, 1).Value =bedcode;//bed code
		    xlsheet.Cells(row, 2).Value =name; //patient name
		    xlsheet.Cells(row, 3).Value =paregno ; //register No
    		}
    	}
    	
	    xlsheet.Cells(row, 4).Value =orditemdesc; //orderitem description 
	    xlsheet.Cells(row, 5).Value =qty ; //qty
	    xlsheet.Cells(row, 6).Value =uom; // uom
	    xlsheet.Cells(row, 7).Value =saleprice ;// sale price
	    xlsheet.Cells(row, 8).Value =ordstatus; //  order status
	    xlsheet.Cells(row, 9).Value =type; //dispensing type
	    xlsheet.Cells(row, 10).Value =dosqty ;// dose qty   //
	    xlsheet.Cells(row, 11).Value =freq ;// frequency
	    xlsheet.Cells(row, 12).Value =instruction ; //instruction
	    xlsheet.Cells(row, 13).Value =duration; //duration
	    xlsheet.Cells(row, 14).Value =prescno;  //prescript No
		setBottomLine(xlsheet,row,1,14)
		tmpRegno=paregno;
		
	    }
	row=row+2;
    xlsheet.Cells(row,1).value=t['DISPEN_USER'] ;
    xlsheet.Cells(row,2).value=dispUser;
    xlsheet.Cells(row,3).value=t['REC_USER']
     xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);
}	

   
function PrintHz(phac,phatype)
{ 	
	//retrieving primary dispensing infomation...
	//
	var tmps=getDispMainInfo(phac);
	if (tmps=="" ) return;
	var tmparr=tmps.split("^");
	var PhaLoc=tmparr[0] ;
	var WardName=tmparr[1] ;
	var PRTDATE=tmparr[6] ;
	var PRTTIME=tmparr[8];
	var dispsd=tmparr[2] ;
	var disped=tmparr[3] ;
	var dispUser=tmparr[5] ;
	var PrtType1=tmparr[4] ;
	var DateRange=dispsd+"--"+disped;
	
	var DispNo=tmparr[9] ;
	var DisTypeDesc=tmparr[10] ;

	var objtbl=document.getElementById("t"+"dhcpha_dispprint")
	if (objtbl)  cnt=getRowcount(objtbl);
	if (cnt<=0) return ;
	//
	if (prnpath=="") {
		alert(t["CANNOT_FIND_TEM"]) ;
		return ;
		}
	var Template=prnpath+"STP_zjhzd_AH.xls";
	//var Template="C:\\STP_zjhzd_AH.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var  xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	
    var startNo=7 ;
    var i ;
	if (xlsheet==null) 
	{alert(t["CANNOT_CREATE_PRNOBJ"]);
		return ;
	}
	getDispHZ(phac);
	
	if (TotalCnt>0) 
	{
		xlsheet.Cells(2, 1).Value = hospname+ getDesc(PhaLoc)+DisTypeDesc+t['DISP_BILL'];  //hospital description
		xlsheet.Cells(4, 1).Value =  t['WARD'] + FilterDesc(getDesc(WardName),"病区") + "                         "+ t['DISP_NO'] +DispNo  
		
 		var incicode="";
 		var incidesc;
 		var uom;
 		var sp;
 		var manf;
 		var qty;
 		var amt;
 		var sumamt=0;
 		var drugform ;
 		var resqty;
 		
 		var datas
 		
 		var exe ;
 		var serialNo=0
 		
 		var obj=document.getElementById("mListDispTotal")
 		if (obj) exe=obj.value;
 		else  exe="" ;
 		//
 		do 
 		{
	 		datas=cspRunServerMethod(exe,incicode,ProcessID);
	 		if (datas!="")
	 		{
		 		var ss=datas.split("^");
		 		incicode=ss[0];
		 		incidesc=ss[1];
				uom=ss[3];
				sp=ss[2];
				manf=ss[7];
				manf=manf.split("-");
				manf=manf[1]
				qty=ss[4];
				amt=ss[5];
				sumamt=parseFloat(sumamt)+parseFloat(amt)
				inci=ss[6];
		 		drugform=ss[8];
		 		resqty=ss[9] ;  //exclude qty
		 		serialNo++;
		 		
				xlsheet.Cells(startNo+serialNo, 1).Value =incidesc ;		///desc .
				xlsheet.Cells(startNo+serialNo, 2).Value =manf ;////manf
				xlsheet.Cells(startNo+serialNo, 3).Value = drugform; //
				xlsheet.Cells(startNo+serialNo, 4).Value =sp ; // saleprice
				xlsheet.Cells(startNo+serialNo, 5).Value =qty ;//
				xlsheet.Cells(startNo+serialNo, 6).Value = resqty;//  
				xlsheet.Cells(startNo+serialNo, 7).Value =qty-resqty ; // qty
				xlsheet.Cells(startNo+serialNo, 8).Value =uom; // unit
		 		setBottomLine(xlsheet,startNo+serialNo,1,8);
		 		}
	 		else 
	 		 	{incicode=""}
 		} while (incicode!="")
	}
	
    var row=startNo+serialNo+2;

    xlsheet.Cells(row,1).value=t['PRINT_USER']+session['LOGON.USERNAME']
	xlsheet.Cells(row,2).value=t['DISPEN_USER']      //+dispUser;
    xlsheet.Cells(row,6).value=t['REC_USER']
    
    row++ ;
    mergcell(xlsheet,row,1,8)
    xlsheet.Cells(row,1).value=t['SUM_AMT']+sumamt + "                 " +  t['PRINTDATE']  + getPrintDateTime();  
	//xlsheet.Cells(row,2).value=
    
	xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet)
  }	

function PrintMZ(phac,type)
{
	//2007-01-13
	var tmps=getDispMainInfo(phac)
	if (tmps=="" ) return;
	var tmparr=tmps.split("^");
	var PhaLoc=tmparr[0] ;
	var WardName=tmparr[1] ;
	var PRTDATE=tmparr[6] ;
	var PRTTIME=tmparr[8];
	var dispsd=tmparr[2] ;
	var disped=tmparr[3] ;
	var dispUser=tmparr[5] ;
	var PrtType1=tmparr[4] ;
	var DateRange=dispsd+"--"+disped;
	
	var DispNo=tmparr[9] ;
	var DisTypeDesc=tmparr[10] ;

	var totalAmt=tmparr[11] ;
	
	var tmpRegno="";
	
	
	var exe1;
	var obj=document.getElementById("mGetDispMZ") ;
	if (obj) exe1=obj.value;
	else exe1=""
	
	var exe2;
	var obj=document.getElementById("mListDispMZ") ;
	if (obj) exe2=obj.value;
	else exe2=""

	var exe3;
	var obj=document.getElementById("mGetDoctorLocDesc") ;
	if (obj) exe3=obj.value;
	else exe3=""
	var docloc=cspRunServerMethod(exe3,phac) ;

	var exe4;
	var obj=document.getElementById("mDispTypeNameMZ") ;
	if (obj) exe4=obj.value;
	else exe4=""
	var disptypename=cspRunServerMethod(exe4,phac) ;

	var grpnum=6; 
	
	//	alert("d0")
	var incicode=""
	ProcessID=cspRunServerMethod(exe1,phac)
	if (ProcessID>0)
	{
		if (prnpath=="") {
			alert(t["CANNOT_FIND_TEM"]) ;
			return ;		}
		var Template=prnpath+"STP_DM_AH.xls";
		//var Template="C:\\STP_DM_AH.xls";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var xlsheet = xlBook.ActiveSheet ;
	    var startNo=7 ;
	    var row ;
	
		if (xlsheet==null) 
		{	alert(t["CANNOT_CREATE_PRNOBJ"]);
			return ;		}		
		
		xlsheet.Cells(2, 1).Value = hospname+ getDesc(docloc)+disptypename+t['DISP_BILL']  //hospital description
		xlsheet.Cells(4, 1).Value =  t['COLLECTDATE']+DateRange ;
		//alert("d1")
	    row=startNo+1;

	  do 
	  {
		  result=cspRunServerMethod(exe2,ProcessID,incicode)
		 // alert(result)
		  
		  if (result!="") {
			  var ss=result.split("!")
			  var main=ss[0].split("^");
			  var detail=ss[1].split("^"); 
			  //		alert("d2")

			 // alert(detail.length)
			  incicode=main[0];
			//  alert(incicode)  ;
			  var incidesc=main[1];
			  var qty=main[2];
			  var uom=main[3];
			  var amt=main[4];
			  var manf1=main[5];
			  var manf2=manf1.split("-")
			  var manf=manf2[1]
			  var drugform=main[6];
		 
		 	  row++
			  xlsheet.Cells(row, 1).Value=incidesc;
			  xlsheet.Cells(row, 2).Value=qty+" "+uom;
			  xlsheet.Cells(row, 3).Value=amt;
			  xlsheet.Cells(row, 4).Value=drugform;
			  xlsheet.Cells(row, 5).Value=manf;
		  
	    	  var n=0
			  var i=0
			  var dets="" ;
			  do 
			  { 
			    dets=dets+"  "+detail[n]	;		  
			    if (i==grpnum)
			    {
					row++;
					fontcell(xlsheet,row,1,5,10)
					mergcell(xlsheet,row,1,5)
					xlsheet.Cells(row, 1).Value=dets;
					dets="";
					i=0;
			    }
			    i++ ;
			    n++ ;
	 		   } while(n<detail.length)
			  if (dets!="")
			  {
				row++
				fontcell(xlsheet,row,1,5,10)
				mergcell(xlsheet,row,1,5)
				xlsheet.Cells(row, 1).Value=dets;
				setBottomLine(xlsheet,row,1,5)
			  }
		  }
	  } while ((incicode!="")&&(result!=""))

	row++
	mergcell(xlsheet,row,1,5)
	
	xlsheet.Cells(row, 1).Value=t['SUM_AMT']+totalAmt
		
	row=row+2
	mergcell(xlsheet,row,1,5)
	xlsheet.Cells(row, 1).Value=t['PRINT_USER']+session['LOGON.USERNAME']+"  "+t['CHECK_USER']+"        "+ t['DISPEN_USER'] + "       "+t['REC_USER']+"      "+t['PRINTDATE']+getPrintDateTime();
	
	xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet);
	}
}

function oPrintZCY(phac,phatype)
{	
  	var objtbl=document.getElementById("t"+"dhcpha_dispprint")
	if (objtbl) cnt=getRowcount(objtbl);
	if (cnt<=0) return ;
		   
    //
	if (prnpath=="") {
		alert(t["CANNOT_FIND_TEM"]) ;
		return ;		}
	//
	var Template=prnpath+"STP_mzZCY.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;
	if (xlsheet==null) 
	{	
	alert(t["CANNOT_CREATE_PRNOBJ"]);
	return ;		}  
	xlsheet.Cells(2, 1).Value = hospname;  //hospital description	
	
	var tmpRegno="" ;
	var startNo=10 ;
    var row ;
	var drugCnt=0;
	var col ;

    for (var i=1;i<=cnt;i++)
    {
    	var bedcode=getVal("bedcode",i);
		var name=getVal("paname",i);
		var paregno= getVal("pano",i);
		var orditemdesc=getVal("orditemdesc",i);
		var dosqty=getVal("dosqty",i);
		var freq= getVal("freq",i);
		var type=getVal("",i);
		var qty= getVal("qty",i);
		var uom=getVal("uom",i);
		var saleprice=getVal("sp",i);
		var prescno= getVal("prescno",i);  //prescript No
		var ordstatus=getVal("ordstatus",i) ;
		var instruction=getVal("instruction",i);
		var duration= getVal("duration",i);
		var admloc=getVal("admloc",i) ;
		var warddesc=getVal("warddesc",i);
		var pasex=getVal("pasex",i);
		var padob=getVal("padob",i);
		var remark=getVal("remark",i);
		var OEORI=getVal("remark",i);
		 
		if (tmpRegno=="")
		{
			//
			//filling data into cells ...
			xlsheet.Cells(5, 2).Value=admloc  ; //adm loc
			xlsheet.Cells(5, 5).Value=warddesc ;  //ward
			xlsheet.Cells(5, 7).Value=bedcode  //bed code
			xlsheet.Cells(6, 2).Value=GetBingAnNo(paregno)  ; //illness archives
			xlsheet.Cells(6, 5).Value=paregno ;  //register No
			xlsheet.Cells(6, 7).Value=getPrintDate()  //date
			xlsheet.Cells(7, 2).Value=name  ; //patient name
			xlsheet.Cells(7, 5).Value=pasex ;  //sex
			xlsheet.Cells(7, 7).Value=GetAge(padob)  //age
			//
			xlsheet.Cells(8, 2).Value="";  // diagnosis
			//
			xlsheet.Cells(19, 1).Value=t['INSTRUCTION']+instruction+"---"+GetOrdItemRemark(OEORI) +"---" + GetDuration(duration);  // remark
		
			row=startNo;
			drugCnt=1 ;
		}
   		if ((tmpRegno!="")&&(paregno!=tmpRegno))
   		{	
   			//patient changed ...
   			xlsheet.printout();  //printing the prior pages
   			//clearing
			xlsheet.Cells(5, 2).Value=""  ; //adm loc
			xlsheet.Cells(5, 5).Value="" ;  //ward
			xlsheet.Cells(5, 7).Value=""  //bed code
			xlsheet.Cells(6, 2).Value=""  ; //illness archives
			xlsheet.Cells(6, 5).Value="" ;  //register No
			xlsheet.Cells(6, 7).Value=""  //date
			xlsheet.Cells(7, 2).Value=""  ; //patient name
			xlsheet.Cells(7, 5).Value="" ;  //sex
			xlsheet.Cells(7, 7).Value="";  //age
			//
			xlsheet.Cells(8, 2).Value="";  // diagnosis
			//
			xlsheet.Cells(19, 1).Value="";  // remark
   			//filling data into cells ...
			xlsheet.Cells(5, 2).Value=admloc  ; //adm loc
			xlsheet.Cells(5, 5).Value=warddesc ;  //ward
			xlsheet.Cells(5, 7).Value=bedcode  //bed code
			xlsheet.Cells(6, 2).Value=GetBingAnNo(paregno)  ; //illness archives
			xlsheet.Cells(6, 5).Value=paregno ;  //register No
			xlsheet.Cells(6, 7).Value=getPrintDate()  //date
			xlsheet.Cells(7, 2).Value=name  ; //patient name
			xlsheet.Cells(7, 5).Value=pasex ;  //sex
			xlsheet.Cells(7, 7).Value=GetAge(padob)  //age
			//
			xlsheet.Cells(8, 2).Value="";  // diagnosis
			//
			xlsheet.Cells(19, 1).Value=t['INSTRUCTION']+instruction+"---"+GetOrdItemRemark(OEORI) +"---" + GetDuration(duration);  // remark
			row=startNo;
			drugCnt=1 ;
   		}
   		var xx=drugCnt % 3;
   		if (xx==1) col=2;
   		if (xx==2) col=4;
   		if (xx==0) col=6;
   		if ((xx==1)&&(drugCnt>3)) {
	   		row=row+1; 	}
	   	
	   //	if (remark.length>0) remark="("+remark+")"
	   	if ((remark!="")&&(remark!=" ")) remark="("+remark+")"
   		xlsheet.Cells(row,col).Value=orditemdesc+" "+qty+" "+uom+remark;
   		//xlsheet.Cells(row,col+1).Value=
   		
   		drugCnt=drugCnt+1;
		tmpRegno=paregno
    }
		
	xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);	
}

function GetBingAnNo(paregno)
 {
	var obj=document.getElementById("mGetBingAnNo") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var binganno=cspRunServerMethod(encmeth,'','',paregno) ;
	return binganno
 }
function GetOrdItemRemark(oeori)
{
	var obj=document.getElementById("mGetOrdItemRemark") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var remark=cspRunServerMethod(encmeth,'','',oeori) ;
	return remark
}
function GetDuration(duration)
{
	var obj=document.getElementById("mGetDuraFactor") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var factor=cspRunServerMethod(encmeth,'','',duration) ;
	return t['TOTAL']+factor+t['SUIT'] ;
}

 
function SetNothing(app,book,sheet)
{
	app=null;
	book.Close(savechanges=false);
	sheet=null;
	window.setInterval("Cleanup();",1); 
}
 function getDispCatDesc(catcode)
{
	var CatDesc="";
	var obj=document.getElementById("mGetDispCatDesc") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	CatDesc=cspRunServerMethod(encmeth,catcode) ;
	return CatDesc
} 
function setBottomLine(objSheet,row,startcol,colnum)
{
    objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).Borders(9).LineStyle=1 ;
}

function setBottomDblLine(objSheet,row,startcol,colnum)  
{   //double line 
    objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).Borders(9).LineStyle=-4119 ;
}
function setBottomPieceLine(objSheet,row,startcol,colnum)  
{   //double line 
    objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).Borders(9).LineStyle=-4118 ;
}

function mergcell(objSheet,row,c1,c2)
{
	objSheet.Range(objSheet.Cells(row, c1), objSheet.Cells(row,c2)).MergeCells =1;
}
function nmergcell(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).MergeCells =1;
}
 function fontcell(objSheet,row,c1,c2,num)
 {
   objSheet.Range(objSheet.Cells(row, c1), objSheet.Cells(row,c2)).Font.Size =num;
 }

function KillTmp()
{
	if (ProcessID!="") 
	{
		var exe;
		var obj=document.getElementById("mKillTmp") ;
		if (obj) exe=obj.value;
		else exe=""
		
		var result=cspRunServerMethod(exe,ProcessID)
	}
}

function getDispHZ(phac)
{
	//2007-01-13
	var exe;
	var obj=document.getElementById("mGetDispTotal") ;
	if (obj) exe=obj.value;
	else exe=""
	
 	var result=cspRunServerMethod(exe,phac);
	ss=result.split("^");
	TotalCnt=ss[0];
	ProcessID=ss[1]  ; //
}

function getDispDetail(phac)
{
	//2007-01-13
	var exe;
	var obj=document.getElementById("mGetDispDetail") ;
	if (obj) exe=obj.value;
	else exe=""
	
	var result=cspRunServerMethod(exe,phac)
	var ss=result.split("^")
	DetailCnt=ss[0];
	ProcessID=ss[1]	;
}
function NameTran(Name){
	if (Name.indexOf("(")>-1){
		var DrugT=Name.split("(")
		} 
	else if (Name.indexOf("?")>-1){
		var DrugT=Name.split("(")
		}		
	else if ((Name.indexOf("(")<0)||(Name.indexOf("?")<0)){
		var DrugT = new Array()
		DrugT[0]=Name
		}
	return(DrugT[0])
}
function FilterDesc(desc,ch )
{//get rid of one or more char from one word

 var result
 result=desc.replace(ch,"")
 return result
}
function nxlcenter(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).HorizontalAlignment =-4108;
}



function PrintFYHX(phac,phatype)
{       
        //retrieving primary dispensing infomation...
        //
        var tmps=getDispMainInfo(phac);
        if (tmps=="" ) return;
        var tmparr=tmps.split("^");
        var PhaLoc=tmparr[0] ;
        var WardName=tmparr[1] ;
        var PRTDATE=tmparr[6] ;
        var PRTTIME=tmparr[8];
        var dispsd=tmparr[2] ;
        var disped=tmparr[3] ;
        var dispUser=tmparr[5] ;
        var PrtType1=tmparr[4] ;
        var DateRange=formatDate2(dispsd)+"--"+formatDate2(disped);
        var DispNo=tmparr[9] ;
        var DisTypeDesc=tmparr[10] ;
        var docloc=tmparr[13] ;
		
        if (prnpath=="") 
        {
        	alert(t["CANNOT_FIND_TEM"]) ;
            return ;
       	}
               
        var Template=prnpath+"STP_zjhzd_HX.xls";
        //var Template="C:\\STP_zjhzd_HX.xls";
        var xlApp = new ActiveXObject("Excel.Application");
        var xlBook = xlApp.Workbooks.Add(Template);
        var xlsheet = xlBook.ActiveSheet ;      
	    var startNo=5 ;
	    
	    var i ;
        if (xlsheet==null) 
        {
	        alert(t["CANNOT_CREATE_PRNOBJ"]);
            return ; 
        }
        
        getDispHZ(phac);
        if (TotalCnt>0) 
        {
             
	        xlsheet.Cells(1, 1).Value = hospname  //+ getDesc(PhaLoc)+DisTypeDesc+t['DISP_BILL'];  //hospital description    
	        xlsheet.Cells(2, 1).Value = t['DISP_BILL']
            xlsheet.Cells(3, 1).Value = t['PHARMACY']+ getDesc(PhaLoc) +"        "+t['DISP_NO'] +DispNo +"       "+t['DISPDATE']+DateRange
	        xlsheet.Cells(4, 1).Value = t['DISPCAT'] + DisTypeDesc + "         " + t['PRINTDATE']+ formatDate2(getPrintDate())+" "+getPrintTime()+"         "+t['WARD']+getDesc(WardName)
	        //xlsheet.Cells(4, 4).Value =t['WARD']+getDesc(WardName)
	       	if(WardName=="0")
	       	{
		       	
		       	xlsheet.Cells(4, 4).Value =t['DOCLOC']+getDesc(docloc);
		    }
	       
	        var incicode="";
	        var incidesc;
	        var uom;
	        var sp;
	        var manf;
	        var qty;
	        var amt;
	        var sumamt=0;
	        var drugform ;
	        var resqty;
	        var stkbin ;
	        var barcode;
	        var datas;
	        var exe ;
	        var serialNo=0
            var obj=document.getElementById("mListDispTotal")
            if (obj) exe=obj.value;
            else  exe="" ;
           
            do 
            {
	            datas=cspRunServerMethod(exe,incicode,ProcessID);
	           
	            
	            if (datas!="")
                    {
                        var ss=datas.split("^");
                        incicode=ss[0];
                        var tmpincidesc=ss[1].split("(")
                        incidesc=tmpincidesc[0];
                        var tmpuom=ss[3].split("(")
                        uom=tmpuom[0];
                        sp=ss[2];
                        manf=ss[7]
                        
                        var dex=manf.indexOf("-")
	        			if(dex>=0)
	        			{
		        			manf=manf.substr(dex+1)
		    			}
                        qty=ss[4];
                        amt=ss[5];
                        sumamt=parseFloat(sumamt)+parseFloat(amt)
                        inci=ss[6];
                        drugform=ss[8];
                        resqty=ss[9] ;  //exclude qty
                        barcode=ss[12];
                        stkbin=ss[10];
                        serialNo++;
                       
                        xlsheet.Cells(startNo+serialNo, 1).Value =serialNo;
                        xlsheet.Cells(startNo+serialNo, 2).Value =incidesc; 
                        xlsheet.Cells(startNo+serialNo, 3).Value =barcode; 
                        xlsheet.Cells(startNo+serialNo, 4).Value =drugform;
                        xlsheet.Cells(startNo+serialNo, 5).Value =qty+" "+uom ; 
                        xlsheet.Cells(startNo+serialNo, 6).Value = sp;  
                        xlsheet.Cells(startNo+serialNo, 7).Value = amt;
                        xlsheet.Cells(startNo+serialNo, 8).Value =manf;       
                        xlsheet.Cells(startNo+serialNo, 9).Value =stkbin;   
                        setBottomLine(xlsheet,startNo+serialNo,1,9);
                        cellEdgeRightLine(xlsheet,startNo+serialNo,1,9)
                    }
                else 
                {incicode=""}
            } while (incicode!="")
        }
        
     
    //总计
    var row=startNo+serialNo+1; 
    xlsheet.Cells(row,1).value=t['SUM_AMT']
    xlsheet.Cells(row,7).value=sumamt
    var row=startNo+serialNo+2;
    xlsheet.Cells(row,1).value=t['PRINT_USER']+session['LOGON.USERNAME']
    xlsheet.Cells(row,3).value=t['ADJ_USER']
    xlsheet.Cells(row,5).value=t['DISPEN_USER']
    xlsheet.Cells(row,8).value=t['REC_USER']
    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet)
 

}


function PrintBYHX(phac,phatype)
{
    var tmps=getDispMainInfo(phac) ;
    if (tmps=="" ) return;
    var tmparr=tmps.split("^");
    var PhaLoc=tmparr[0] ;
    var WardName=tmparr[1] ;
    var PRTDATE=tmparr[6] ;
    var PRTTIME=tmparr[8];
    var dispsd=tmparr[2] ;
    var disped=tmparr[3] ;
    var dispUser=tmparr[5] ;
    var PrtType1=tmparr[4] ;
    var DateRange=formatDate2(dispsd)+"--"+formatDate2(disped);
   
    var DispNo=tmparr[9] ;
    var DisTypeDesc=tmparr[10] ;

    var tmpRegno="";
    var patTotal=0;		//总计人数
                       
    getDispDetail(phac)

    if (prnpath=="") 
    {
    	alert(t["CANNOT_FIND_TEM"]) ;
        return ;                
    }
    var Template=prnpath+"STP_PJ_HX.xls";
    var xlApp = new ActiveXObject("Excel.Application");
    var xlBook = xlApp.Workbooks.Add(Template);
    var xlsheet = xlBook.ActiveSheet ;
    var startNo=5 ;
    var row ;

    if (xlsheet==null) 
    {       
    	alert(t["CANNOT_CREATE_PRNOBJ"]);
        return ;                
    }
    xlsheet.Cells(1, 1).Value = hospname
    xlsheet.Cells(2, 1).Value = t['WARD_DRUGLIST'] 
    xlsheet.Cells(3, 1).Value =t['PHARMACY']+ getDesc(PhaLoc) +"     " +t['DISP_NO'] +DispNo +"            "+t['DISPDATE']+DateRange
    xlsheet.Cells(4, 1).Value = t['DISPCAT']+DisTypeDesc +"         "+t['WARD'] + getDesc(WardName)+"       "+t['PRINTDATE']+formatDate2(getPrintDate())+" "+getPrintTime(); 
    //xlsheet.Cells(4, 4).Value = t['WARD'] + getDesc(WardName) 
    //xlsheet.Cells(4, 5).Value =t['PRINTDATE']+getPrintDateTime(); 

    row=startNo;
    var exeDetail;
    var obj=document.getElementById("mListDispDetail")
    if (obj) exeDetail=obj.value;
    else exeDetail=""
    if (TotalCnt>0)  //2007-04-17
     {    
	    for (var i=1;i<=TotalCnt;i++)
	    {           
	        var ss=cspRunServerMethod(exeDetail,ProcessID,i)   
	        var datas=ss.split("^")
	        var bedcode=datas[5];
	        var name=datas[1];
	        var paregno=datas[0];
	        var patdob=datas[3];
	        var tmpitemdesc=datas[10].split("(");
	        var orditemdesc=tmpitemdesc[0];
	        var dosqty=datas[13];
	        var freq= datas[14];
	        var qty=datas[15];
	        var tmpuom=datas[16].split("(");
	        var uom=tmpuom[0];
	        var saleprice=datas[17];
	        var prescno=datas[7];
	        var ordstatus=datas[12];
	        var instruction=datas[20];
	        var duration= datas[21];
	        var manf=datas[25];
	        var dex=manf.indexOf("-")
	        if(dex>=0)
	        {
		        manf=manf.substr(dex+1)
		    }
	        var spec=datas[26];
	        var eatdrugtime=datas[27] 
	        var amt=datas[18];
	        var orddate=datas[29];
	        var ordsttdate=datas[30];
	        var priority=datas[33];
	        var drugform=datas[34];	        
	        var doctor=datas[8];
	        var action=datas[35];
	        
	        if ((tmpRegno!="")&&(paregno!=tmpRegno) )
	         {//setBottomDblLine(xlsheet,row,1,13); 
		      	setBottomLine(xlsheet,row,1,13);
		     }  
		     row++;                        
	      //  alert(row)
	        if (tmpRegno=="")
	        {   
	        	xlsheet.Cells(row, 1).Value =paregno;    
	            xlsheet.Cells(row, 2).Value =bedcode;//bed code
	            xlsheet.Cells(row, 3).Value =name; //patient name
	            
	            xlsheet.Cells(row, 4).Value =patdob; 
	            
	            patTotal=patTotal+1;
	          	cellEdgeRightLine(xlsheet,row,1,13)
	        }
	        else
	        {if (paregno!=tmpRegno)
	            {   //row=row+1;
	            xlsheet.Cells(row, 1).Value =paregno;
	            xlsheet.Cells(row, 2).Value =bedcode;//bed code
	            xlsheet.Cells(row, 3).Value =name; //patient name
	            
	            xlsheet.Cells(row, 4).Value =patdob;  
	            
	            patTotal=patTotal+1;
	            cellEdgeRightLine(xlsheet,row,1,13)
	           // row++ 
	            }
	        }
	        xlsheet.Cells(row, 5).Value =orditemdesc; //orderitem description 
			xlsheet.Cells(row, 6).Value =spec;
			xlsheet.Cells(row, 7).Value =drugform;
			xlsheet.Cells(row, 8).Value =qty+uom;			
			xlsheet.Cells(row, 9).Value =dosqty ;			
			xlsheet.Cells(row, 10).Value =freq ;			
	        xlsheet.Cells(row, 11).Value =instruction;
	        xlsheet.Cells(row, 12).Value =doctor;
	        xlsheet.Cells(row, 13).Value =action; //医嘱备注
	        
		    cellEdgeRightLine(xlsheet,row,1,13)
	      
	       // setBottomLine(xlsheet,row,4,9)
	        tmpRegno=paregno;
	    }
	        setBottomLine(xlsheet,row,1,13)
    } //2007-04-17
	
    row+=1;
	//总计
    xlsheet.Cells(row,1).value=t['SUM_PAT']
    xlsheet.Cells(row,2).value=patTotal;
    row+=2;
    xlsheet.Cells(row,1).value=t['PRINT_USER']+session['LOGON.USERNAME']
    xlsheet.Cells(row,4).value=t['ADJ_USER']
    xlsheet.Cells(row,6).value=t['DISPEN_USER']
    xlsheet.Cells(row,9).value=t['REC_USER']
    
    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);
}


 
 function Cleanup() 
{   
    //清除打印完死进程2007-10-31 lq
    window.clearInterval(idTmr);   
    CollectGarbage();   
}     
      
      
 function cellEdgeRightLine(objSheet,row,c1,c2)
{
	for (var i=c1;i<=c2;i++)
	{
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(10).LineStyle=1;
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(7).LineStyle=1;
	}
}


document.body.onload=BodyLoadHandler;