
var hospname;
var prnfmt;
var phac ;  //Rowid of dispensing
var disptype; 
var prnpath;
var grp;
var isHz=0  // "hz" print mode
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
	// 
	var obj=document.getElementById("mGetPrnPath") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	prnpath=cspRunServerMethod(encmeth,'','') ;
	//
	Prnt(phac)	
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

function opPrint(phac,phatype)
{
	//
	if (phatype=="DSY")
	{	oPrintDSY(phac,phatype)	;
		return;
	}
	if (phatype=="ZJ")
	{	oPrintDSY(phac,phatype)	;
		return;
	}

	if (phatype=="PJ")
	{	oPrintPJ(phac,phatype)	;
		return;
	}	
	if (phatype=="WYY")
	{	oPrintPJ(phac,phatype)	;
		return;
	}	
	
}

function Prnt(phac)

{
	alert("aaa") 
    if (phac=="")  return 0 ;
    var phatype=disptype;
	//alert(phatype) ;	
	switch (phatype) {
		case "ZJ":
		   if (prnfmt=="O") 
		   	{opPrint(phac,phatype)	;}
		   else
			   {
				   if (isHz==1) PrintHz(phac,phatype)  ;
			   	   else  PrintElse(phac,phatype);
			    } //total format
		  break;
		case "DSY":
		   alert("aaaa")
		   if (prnfmt=="O") 
		   	{opPrint(phac,phatype)	;}
		   else
			   {
				   if (isHz==1) PrintHz(phac,phatype)  ;
			   	   else  PrintElse(phac,phatype);
			    } //total format
		  break;
		case "PJ":
		   if (prnfmt=="O") 
			   {opPrint(phac,phatype)	;}
		   else
			   { 
			   if (isHz==1) PrintHz(phac,phatype)  ;
			   else  Print2(phac,phatype); }
		   break;
		case "DY":
		   if (prnfmt=="O") 
			   {opPrint(phac,phatype)	;}
		   else
			   { 
			   if (isHz==1) PrintHz(phac,phatype)  ;
			   else  Print2(phac,phatype); }
		   break;
		case "MZ":
		   if (prnfmt=="O") 
			   {opPrint(phac,phatype)	;}
		   else
			   { 
			   if (isHz==1) PrintHz(phac,phatype)  ;
			   else  Print2(phac,phatype); }
		   break;
		case "JSY":
		   if (prnfmt=="O") 
			   {opPrint(phac,phatype)	;}
		   else
			   { 
			   if (isHz==1) PrintHz(phac,phatype)  ;
			   else  Print2(phac,phatype); }
		   break;  
		case "ZCHY":
			if (prnfmt=="O") 
			   {oPrintZCY(phac,phatype)	;}
			else
			{
			   if (isHz==1) PrintHz(phac,phatype)  ;
			   else Print3(phac,phatype);
			   break;
			}
	   }
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
    	
    	
//    	||(paregno!=tmpRegno)  ) 	{
//	    	row=row+1;
//	    	xlsheet.Cells(row, 1).Value =bedcode;//bed code
//		    xlsheet.Cells(row, 2).Value =name; //patient name
//		    xlsheet.Cells(row, 3).Value =paregno ; //register No
	   // }
	    
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
	//
	if (prnpath=="") {
		alert(t["CANNOT_FIND_TEM"]) ;
		return ;
		}
    alert("prnpath"+prnpath)
	var Template=prnpath+"STP_zjhzd.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var  xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	
    var startNo=7 ;
    var i ;
	if (xlsheet==null) 
	{alert(t["CANNOT_CREATE_PRNOBJ"]);
		return ;
	}
	
	xlsheet.Cells(2, 1).Value = hospname;  //hospital description
	xlsheet.Cells(3, 1).Value = t['WARD_DRUGLIST']  // "ward bills of dispensing";
	xlsheet.Cells(4, 1).Value = t['PHARMACY']+ getDesc(PhaLoc); // "pharmacy:" 
	xlsheet.Cells(5, 1).Value=t['DISPCAT']+ getDispCatDesc(PrtType1) +"    "+ t['WARD'] + getDesc(WardName) + "    " +t['DISPDATE']+ DateRange + "   " +t['PRINTDATE']+ getPrintDateTime();
    //
    for (i=1;i<=cnt;i++)
    {
		//var bedcode=getVal("bedcode",i);
		//var name=getVal("paname",i);
		//var paregno= getVal("pano",i);
		var orditemdesc=getVal("incidesc",i);
		
		//var dosqty=getVal("dosqty",i);
		//var freq= getVal("freq",i);
		//var type=getVal("",i);
		var qty= getVal("qty",i);
		var uom=getVal("uom",i);
		var saleprice=getVal("sp",i);
		//var prescno= getVal("prescno",i);  //prescript No
		//var ordstatus=getVal("ordstatus",i) ;
		//var instruction=getVal("instruction",i);
		//var duration= getVal("duration",i);
		//var admloc=getVal("admloc",i) ;
		//
		var incicode=getVal("incicode",i)
		var manf=getVal("manf",i)
		
		xlsheet.Cells(startNo+i, 1).Value =i ;		// No.
		xlsheet.Cells(startNo+i, 2).Value =incicode ;//code
		xlsheet.Cells(startNo+i, 3).Value =orditemdesc ; //desc
		xlsheet.Cells(startNo+i, 4).Value =manf ; //manf
		xlsheet.Cells(startNo+i, 5).Value =qty // qty
		xlsheet.Cells(startNo+i, 6).Value =uom // unit 
		xlsheet.Cells(startNo+i, 7).Value =saleprice // sp
		xlsheet.Cells(startNo+i, 8).Value =qty*saleprice // amount

    }
    row=startNo+i+2;
    //xlsheet.Cells(row,1).value= ;
    xlsheet.Cells(row,3).value=t['DISPEN_USER']+dispUser;
    xlsheet.Cells(row,4).value=t['REC_USER']
	xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet)
  }	

function PrintHzShortOrd(phac,phatype)
   { 	// short order item
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
	//
	if (prnpath=="") {
		alert(t["CANNOT_FIND_TEM"]) ;
		return ;
		}
	var Template=prnpath+"STP_zjhzd.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var  xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	
    var startNo=7 ;
    var i ;
	if (xlsheet==null) 
	{alert(t["CANNOT_CREATE_PRNOBJ"]);
		return ;
	}
	
	xlsheet.Cells(2, 1).Value = hospname;  //hospital description
	xlsheet.Cells(3, 1).Value = t['WARD_DRUGLIST']  // "ward bills of dispensing";
	xlsheet.Cells(4, 1).Value = t['PHARMACY']+ getDesc(PhaLoc); // "pharmacy:" 
	xlsheet.Cells(5, 1).Value=t['DISPCAT']+ getDispCatDesc(PrtType1) +"    "+ t['WARD'] + getDesc(WardName) + "    " +t['DISPDATE']+ DateRange + "   " +t['PRINTDATE']+ getPrintDateTime();
    //
    for (i=1;i<=cnt;i++)
    {
		//var bedcode=getVal("bedcode",i);
		//var name=getVal("paname",i);
		//var paregno= getVal("pano",i);
		var orditemdesc=getVal("incidesc",i);
		
		//var dosqty=getVal("dosqty",i);
		//var freq= getVal("freq",i);
		//var type=getVal("",i);
		var qty= getVal("qty",i);
		var uom=getVal("uom",i);
		var saleprice=getVal("sp",i);
		//var prescno= getVal("prescno",i);  //prescript No
		//var ordstatus=getVal("ordstatus",i) ;
		//var instruction=getVal("instruction",i);
		//var duration= getVal("duration",i);
		//var admloc=getVal("admloc",i) ;
		//
		var incicode=getVal("incicode",i)
		var manf=getVal("manf",i)
		
		xlsheet.Cells(startNo+i, 1).Value =i ;		// No.
		xlsheet.Cells(startNo+i, 2).Value =incicode ;//code
		xlsheet.Cells(startNo+i, 3).Value =orditemdesc ; //desc
		xlsheet.Cells(startNo+i, 4).Value =manf ; //manf
		xlsheet.Cells(startNo+i, 5).Value =qty // qty
		xlsheet.Cells(startNo+i, 6).Value =uom // unit 
		xlsheet.Cells(startNo+i, 7).Value =saleprice // sp
		xlsheet.Cells(startNo+i, 8).Value =qty*saleprice // amount
		
    }
    row=startNo+i+2;
    //xlsheet.Cells(row,1).value= ;
    xlsheet.Cells(row,3).value=t['DISPEN_USER']+dispUser;
    xlsheet.Cells(row,4).value=t['REC_USER']
	xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet)
  }	

function oPrintDSY(phac,phatype)
	{
		//<ZJ>printing in out pharmacy.
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
				
		var objtbl=document.getElementById("t"+"dhcpha_dispprint");
		if (objtbl) cnt=getRowcount(objtbl);
		if (cnt<=0) return ;	   
		
		//start printing ...
		if (prnpath=="") 
		{
			alert(t["CANNOT_FIND_TEM"]) ;
			return ;
			}
		var Template=prnpath+"STP_ZJmzShort.xls";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var xlsheet = xlBook.ActiveSheet ;
	    var startNo=7 ;
	    var row ;

		if (xlsheet==null) 
		{	alert(t["CANNOT_CREATE_PRNOBJ"]);
			return ;		}
		xlsheet.Cells(2, 1).Value = hospname;  //hospital description
		xlsheet.Cells(3, 1).Value = t["WARD_DRUGLIST"];  //ward bills of dispensing
		xlsheet.Cells(4, 1).Value = t['PHARMACY'] +getDesc( PhaLoc);  //pharmacy
		xlsheet.Cells(5, 1).Value=t['DISPCAT'] + getDispCatDesc(PrtType1) +"    "+ t["WARD"] + getDesc(WardName) + "    " +t['DISPDATE']+ DateRange + "   " +t['PRINTDATE']+ getPrintDateTime();
		//drug dispensing type
		
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

	    	row=startNo+i ;     			
		    xlsheet.Cells(row, 1).Value =orditemdesc ;//order item desc
		    xlsheet.Cells(row, 2).Value = name; //patient name
		    xlsheet.Cells(row, 3).Value = paregno ; //register No
		    xlsheet.Cells(row, 4).Value =bedcode ; //bed code
		    xlsheet.Cells(row, 5).Value =qty ; //qty
		    xlsheet.Cells(row, 6).Value = uom; //uom
		    xlsheet.Cells(row, 7).Value = saleprice;//  sale price
		    xlsheet.Cells(row, 8).Value =ordstatus ; // order status
		    xlsheet.Cells(row, 9).Value = dosqty; // dose qty
		    xlsheet.Cells(row, 10).Value =instruction ;//instruction
		    xlsheet.Cells(row, 11).Value =qty * saleprice;//amount
		    xlsheet.Cells(row, 12).Value =prescno; // prescript No
			setBottomLine(xlsheet,row,1,12)
		    		    }
	    row=row+2;
	    xlsheet.Cells(row,1).value=t['DISPEN_USER'] ;
	    xlsheet.Cells(row,3).value=dispUser;
	    xlsheet.Cells(row,4).value=t['REC_USER']

	    xlsheet.printout();
	    SetNothing(xlApp,xlBook,xlsheet);	
	}	
function oPrintPJ(phac,phatype)
{	//<ZJ>printing in out-patient pharmacy
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
	var Template=prnpath+"STP_PJmzShort.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;

	if (xlsheet==null) 
	{	
		alert(t["CANNOT_CREATE_PRNOBJ"]);
		return ;		}
	xlsheet.Cells(2, 1).Value = hospname;  //hospital description
	xlsheet.Cells(3, 1).Value = t['WARD_DRUGLIST']	// "ward bills of dispensing";
	xlsheet.Cells(4, 1).Value = t['PHARMACY']+ getDesc(PhaLoc); //"pharmacy:" 
	xlsheet.Cells(5, 1).Value=t['DISPCAT'] + getDispCatDesc(PrtType1) +"    "+ t['WARD']  + getDesc(WardName) + "    " +t['DISPDATE']+ DateRange + "   " + t['PRINTDATE']+getPrintDateTime();
    //
    var startNo=7 ;
    var row ;
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
		
    	row=startNo+i ;     			
	    xlsheet.Cells(row, 1).Value =name; //patient name
	    xlsheet.Cells(row, 2).Value =paregno ; //register No
	    xlsheet.Cells(row, 3).Value =orditemdesc ;//order item desc
	    xlsheet.Cells(row, 4).Value =bedcode; //bed code
	    xlsheet.Cells(row, 5).Value = qty; //qty
	    xlsheet.Cells(row, 6).Value =uom; //uom
	    xlsheet.Cells(row, 7).Value =saleprice;//  sale price
	    xlsheet.Cells(row, 8).Value =ordstatus; // order status
	    xlsheet.Cells(row, 9).Value =dosqty; // dose qty
	    xlsheet.Cells(row, 10).Value =instruction;//instruction
	    xlsheet.Cells(row, 11).Value = qty*saleprice ;//amount
	    xlsheet.Cells(row, 12).Value = prescno; // prescript No
		setBottomLine(xlsheet,row,1,12)
	    		    }
    row=row+2;
    xlsheet.Cells(row,1).value=t['DISPEN_USER'] ;
    xlsheet.Cells(row,2).value=dispUser;
    xlsheet.Cells(row,3).value=t['REC_USER']
    
    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);	
	
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
	}
 function getDispCatDesc(catcode)
 {
	//if (dispcat=="") return "" ;
	//var ff=dispcat+"_DESC"
	//return t[ff]
	
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

document.body.onload=BodyLoadHandler;