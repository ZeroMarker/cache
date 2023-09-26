var hospname;
var prnfmt;
var phac ;  //Rowid of dispensing
var disptype; 
var prnpath;
var grp;
var isHz=0  // "hz" print mode

var ProcessID="" ;
var TotalCnt ;
var DetailCnt ;

var cnt;
var reprnFlag ;

        
function BodyLoadHandler()
{		
 		grp=session['LOGON.GROUPID'];
 
       	var obj=document.getElementById("Phac") ;
        if (obj) phac=obj.value ;
       
        var obj=document.getElementById("mPrtHospName") ;
        if (obj) {var encmeth=obj.value;} else {var encmeth='';}
        hospname=cspRunServerMethod(encmeth,'','') ;
       
        var obj=document.getElementById("PrtHz")
        if (obj) isHz=obj.value ;
        
        isHz=1;
        
        // get print tempalate file from server 
        var obj=document.getElementById("mGetPrnPath") ;
        if (obj) {var encmeth=obj.value;} else {var encmeth='';}
        prnpath=cspRunServerMethod(encmeth,'','') ;
        
        prnpath="D:\\DHCC\\"   //2007-03-18 moban change path
        
        //whether printing is reprint or not
        if (getRePrintFlag()) reprnFlag=t['RE_PRINT']
        else reprnFlag="";
        
        printAll(phac);      
        window.close();
}

function getDispMainInfo(phac)
{
        var obj=document.getElementById("mGetPhcDispM") ;
        if (obj) {var encmeth=obj.value;} else {var encmeth='';}
        var ss=cspRunServerMethod(encmeth,'','',phac) ;
        return ss ;
}

function printAll(phacStr)
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

function GetDispType(phac)
{
	 //dispensing type
     var obj=document.getElementById("mPrtGetGetDispType") ;
     if (obj) {var encmeth=obj.value;} else {var encmeth='';}
     disptype=cspRunServerMethod(encmeth,'','',phac) ;
     
     return disptype;
}

function GetPrintFormat(phac)
{
	 var obj=document.getElementById("mPrtGetPrintFmt") ;
     if (obj) {var encmeth=obj.value;} else {var encmeth='';}
     prnfmt=cspRunServerMethod(encmeth,'','',phac) ;
}

function Prnt(phac)
{ 

    if (phac=="")  return 0 ;
    var phatype=disptype;
    var tmps=getDispMainInfo(phac);
        if (tmps=="" ) return;
        var tmparr=tmps.split("^");
        var PhaLoc=tmparr[0] ;
        var WardName=tmparr[1] ;
        
    if (WardName=="0") 
    {   
      PrintPJ(phac,phatype) 
      return ;
    }
        
    
    switch (phatype) {
	    case "01":  //口服 
           if (isHz==1) PrintPJ(phac,phatype)  ;
           break;
	    case "03": 	//中成药
           if (isHz==1) PrintPJ(phac,phatype)  ;
          break;
        case "02":  //针剂
           if (isHz==1)  PrintHz(phac,phatype) ;
          break;
        case "06":  //外用药
           if (isHz==1) PrintWYY(phac,phatype)  ;  
           break;
        case "05":   //管制药
           if (isHz==1) PrintPJ(phac,phatype)  ;
           break;
        case "04":   //中草药
			if (isHz==1) PrintCY(phac,phatype)  ;
		     break;
		}
	KillTmp();

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

		var phacpr=tmparr[12];
        //var objtbl=document.getElementById("t"+"dhcpha_dispprint")
        //if (objtbl)  cnt=getRowcount(objtbl);
       // if (cnt<=0) return ;
        //
        if (prnpath=="") {
                alert(t["CANNOT_FIND_TEM"]) ;
                return ;}
                
        var Template=prnpath+"STP_Zjhzd_SG.xls";
        var xlApp = new ActiveXObject("Excel.Application");
        var  xlBook = xlApp.Workbooks.Add(Template);
        var xlsheet = xlBook.ActiveSheet ;      
	    var startNo=5 ;
	    var i ;
        if (xlsheet==null) 
        {alert(t["CANNOT_CREATE_PRNOBJ"]);
                return ; }
       
        getDispHZ(phac);
        
        if (TotalCnt>0) 
        {
	        xlsheet.Cells(2, 1).Value = hospname  + getDesc(PhaLoc)+t['DISP_BILL']+"("+phacpr+DisTypeDesc+")"+reprnFlag;  //hospital description
	        xlsheet.Cells(4, 1).Value = t['WARD'] +getDesc(WardName) + "      " + t['PRINTDATE']+ getPrintDateTime() +"        "+"No.:" +DispNo
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
                        qty=ss[4];
                        amt=ss[5];
                        sumamt=parseFloat(sumamt)+parseFloat(amt)
                        inci=ss[6];
                        drugform=ss[8];
                        resqty=ss[9] ;  //exclude qty
                        
                        stkbin=ss[10]
                        generic=ss[11];
                        
                        serialNo++;
                        
                        xlsheet.Cells(startNo+serialNo, 1).Value =incidesc//desc .
                        xlsheet.Cells(startNo+serialNo, 2).Value = manf              
                        xlsheet.Cells(startNo+serialNo, 3).Value =uom ;////
                        xlsheet.Cells(startNo+serialNo, 4).Value =qty ; // 
                        xlsheet.Cells(startNo+serialNo, 5).Value = sp//  saleprice
                        xlsheet.Cells(startNo+serialNo, 6).Value = amt
                        
                         gridlist(xlsheet,startNo+serialNo,startNo+serialNo,1,6) ;
                        //setBottomLine(xlsheet,startNo+serialNo,1,6);
                    }
                else 
                {incicode=""}
            } while (incicode!="")
        }
        
    var row=startNo+serialNo;
    row++;
	xlsheet.Cells(row,1).value =t['SUM']
	xlsheet.Cells(row,2).value =serialNo
	xlsheet.Cells(row,6).value =sumamt
    gridlist(xlsheet,row,row,1,6) ;
    row+=2
    mergcell(xlsheet,row,1,6)
    xlsheet.Cells(row,1).value=t['COLLECT']+ "               " +t['PACK']+"              " +t['DISPEN_USER']+"               "+t['SIGN_USER']+  "              "+ t['SENDER']

    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet)
  } 
      
function PrintPJ(phac,phatype)
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
    var DateRange=dispsd+"--"+disped;
    
    var DispNo=tmparr[9] ;
    var DisTypeDesc=tmparr[10] ;

	var phacpr=tmparr[12] ; 
    var tmpRegno="";
    
    
    if (phacpr==t['LONG_ORD']) 
    {   
     PrintLongOrdPJ(phac,phatype);
     return ;
    }
                        
    getDispDetail(phac)

    if (DetailCnt<1) return ;

    //start printing ...
    if (prnpath=="") {
            alert(t["CANNOT_FIND_TEM"]) ;
            return ;                }
    var Template=prnpath+"STP_PJ_SG.xls";
    var xlApp = new ActiveXObject("Excel.Application");
    var xlBook = xlApp.Workbooks.Add(Template);
    var xlsheet = xlBook.ActiveSheet ;
    var startNo=5 ;
    var row ;

    if (xlsheet==null) 
    {       alert(t["CANNOT_CREATE_PRNOBJ"]);
            return ;                }
    
    xlsheet.Cells(2, 1).Value =hospname  + getDesc(PhaLoc)+t['DISP_BILL']+"("+phacpr+DisTypeDesc+")"+reprnFlag;  
    xlsheet.Cells(4, 1).Value =t['WARD'] + getDesc(WardName)+ "     " +t['PRINTDATE']+getPrintDateTime()+"      " +t['DISP_NO'] +DispNo
    
    row=startNo;
    var exeDetail;
    var obj=document.getElementById("mListDispDetail")
    if (obj) exeDetail=obj.value;
    else exeDetail=""
    var serialNo=0   
    for (var i=1;i<=DetailCnt;i++)
    {           
        var ss=cspRunServerMethod(exeDetail,ProcessID,i)   
        var datas=ss.split("^")

        var bedcode=datas[5];
        var name=datas[1];
        var paregno=datas[0];
        var paage=datas[3];
        
        var orditemdesc=datas[10];
        var dosqty=datas[13];
        var freq= datas[14];

        var qty=datas[15];
        var uom=datas[16];
        var saleprice=datas[17];
        var prescno=datas[7];
        var ordstatus=datas[12];
        var instruction=datas[20];
        var duration= datas[21];
        var manf=datas[25];
        var spec=datas[26];
        var eatdrugtime=datas[27] 
        var amt=datas[18];
        var orddate=datas[29];
        var ordsttdate=datas[30];
            
        var diagnose=  datas[31]; 
        var generic= datas[32]; 
        
        //if ((tmpRegno!="")&&(paregno!=tmpRegno) )
       //  { 
	    //   row++;         
	    //   }  
	                   
        if (tmpRegno=="")
        {    //row+=2;
             mergcell(xlsheet,row,1,9) ;
            xlsheet.Cells(row, 1).value =t['PA_BEDNO'] + bedcode + "    "  +t['PA_NO'] + paregno + "  "+ t['PA_NAME']+ name+ "  " +t['PA_AGE']+ paage + "    "  + "  "+ t['PA_DIAGNOSE'] +diagnose
            row++
            Head1(xlsheet,row)
            gridlist(xlsheet,row,row,1,9) ;
           
            row++
        }
        else
        {if (paregno!=tmpRegno)
            {   row=row+2;
            mergcell(xlsheet,row,1,9) ;
            xlsheet.Cells(row, 1).value =t['PA_BEDNO'] + bedcode + "    "  +t['PA_NO'] + paregno + "  "+ t['PA_NAME']+ name+ "  " +t['PA_AGE']+ paage + "    "  + "  "+ t['PA_DIAGNOSE'] +diagnose
            row++
            Head1(xlsheet,row)
             gridlist(xlsheet,row,row,1,9) ;
            row++ }
        }
         serialNo++;
        xlsheet.Cells(row, 1).Value =orditemdesc; //orderitem description 
        xlsheet.Cells(row, 2).Value =manf   ;
        xlsheet.Cells(row, 3).Value =uom ; // eatdrugtime;
        xlsheet.Cells(row, 4).Value =qty ;   ;
        xlsheet.Cells(row, 5).Value =dosqty; 
        xlsheet.Cells(row, 6).Value = freq  ;
        xlsheet.Cells(row, 7).Value = instruction;
        xlsheet.Cells(row, 8).Value = saleprice;
        xlsheet.Cells(row, 9).Value = amt ;
     
      //  setBottomLine(xlsheet,row,1,9)
	    gridlist(xlsheet,row,row,1,9) ;
        row++;
        tmpRegno=paregno;
    }
	xlsheet.Cells(row,1).value ="合计:"
	xlsheet.Cells(row,2).value =serialNo
    gridlist(xlsheet,row,row,1,9) ;
    row+=2;
	mergcell(xlsheet,row,1,9)
    xlsheet.Cells(row,1).value=t['COLLECT']+ "           " +t['PACK']+"           " +t['DISPEN_USER']+"           "+t['SIGN_USER']+  "          "+ t['SENDER']+ "        "+"合计种类:"+serialNo
    
    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);
}


function PrintLongOrdPJ(phac,phatype)
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
    var DateRange=dispsd+"--"+disped;
    var DispNo=tmparr[9] ;
    var DisTypeDesc=tmparr[10] ;
	var phacpr=tmparr[12] ; 
    var tmpRegno="";
    getDispDetail(phac)
    if (DetailCnt<1) return ;
     var huizong=0
    //start printing ...
    if (prnpath=="") {
            alert(t["CANNOT_FIND_TEM"]) ;
            return ;                }
    var Template=prnpath+"STP_PJ_LongOrd_SG.xls";
    var xlApp = new ActiveXObject("Excel.Application");
    var xlBook = xlApp.Workbooks.Add(Template);
    var xlsheet = xlBook.ActiveSheet ;
    var startNo=5 ;
    var row ;

    if (xlsheet==null) 
    {       alert(t["CANNOT_CREATE_PRNOBJ"]);
            return ;                }
    
    xlsheet.Cells(2, 1).Value =hospname  + getDesc(PhaLoc)+t['DISP_BILL']+"("+phacpr+DisTypeDesc+")"+reprnFlag;  
    xlsheet.Cells(4, 1).Value =t['WARD'] + getDesc(WardName)+ "     " +t['PRINTDATE']+getPrintDateTime()+"      " +t['DISP_NO'] +DispNo
    
    row=startNo;
    var exeDetail;
    var obj=document.getElementById("mListDispDetail")
    if (obj) exeDetail=obj.value;
    else exeDetail=""
        
    for (var i=1;i<=DetailCnt;i++)
    {           
        var ss=cspRunServerMethod(exeDetail,ProcessID,i)   
        var datas=ss.split("^")

        var bedcode=datas[5];
        var name=datas[1];
        var paregno=datas[0];
        var paage=datas[3];
        
        var orditemdesc=datas[10];
        var dosqty=datas[13];
        var freq= datas[14];

        var qty=datas[15];
        var uom=datas[16];
        var saleprice=datas[17];
        var prescno=datas[7];
        var ordstatus=datas[12];
        var instruction=datas[20];
        var duration= datas[21];
        var manf=datas[25];
        var spec=datas[26];
        var eatdrugtime=datas[27] 
        var amt=datas[18];
        var orddate=datas[29];
        var ordsttdate=datas[30];
            
        var diagnose=  datas[31]; 
        var generic= datas[32]; 
        
        //if ((tmpRegno!="")&&(paregno!=tmpRegno) )
       //  { 
	    //   row++;         
	    //   }  
	                   
        if (tmpRegno=="")
        {    //row+=2;
             mergcell(xlsheet,row,1,10) ;
            xlsheet.Cells(row, 1).value =t['PA_BEDNO'] + bedcode + "  " +t['PA_NO'] + paregno + "  "+ t['PA_NAME']+ name+ "  " +t['PA_AGE']+ paage + "    " + t['PA_DIAGNOSE'] +diagnose
            row++
            Head2(xlsheet,row)
            gridlist(xlsheet,row,row,1,10) ;
           
            row++
        }
        else
        {if (paregno!=tmpRegno)
            {   row=row+2;
            mergcell(xlsheet,row,1,10) ;
            xlsheet.Cells(row, 1).value =t['PA_BEDNO'] + bedcode + "  " +t['PA_NO'] + paregno + "  "+ t['PA_NAME']+ name+ "  " +t['PA_AGE']+ paage + "    " + t['PA_DIAGNOSE'] +diagnose
            row++
            Head4(xlsheet,row)
             gridlist(xlsheet,row,row,1,10) ;
            row++ }
        }
        huizong=huizong+1
        xlsheet.Cells(row, 1).Value =orditemdesc; //orderitem description 
        xlsheet.Cells(row, 2).Value =manf   ;
        xlsheet.Cells(row, 3).Value =uom ; // eatdrugtime;
        xlsheet.Cells(row, 4).Value =qty ;   ;
        xlsheet.Cells(row, 5).Value =dosqty; 
        xlsheet.Cells(row, 6).Value = freq  ;
        xlsheet.Cells(row, 7).Value = instruction;
        xlsheet.Cells(row, 8).Value = eatdrugtime;
        xlsheet.Cells(row, 9).Value = "" ;
         xlsheet.Cells(row, 10).Value =ordsttdate 
     
      //  setBottomLine(xlsheet,row,1,9)
	    gridlist(xlsheet,row,row,1,10) ;
        row++;
        tmpRegno=paregno;
    }
   xlsheet.Cells(row,1).value ="合计:"
   xlsheet.Cells(row,2).value =huizong
    gridlist(xlsheet,row,row,1,10) ;

    row+=2;
	mergcell(xlsheet,row,1,10)
    xlsheet.Cells(row,1).value=t['COLLECT']+ "           " +t['PACK']+"            " +t['DISPEN_USER']+"          "+t['SIGN_USER']+  "        "+ t['SENDER']+ "        "+"合计种类:"+huizong
    
    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);
}
function PrintWYY(phac,phatype)
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
    var DateRange=dispsd+"--"+disped;
    
    var DispNo=tmparr[9] ;
    var DisTypeDesc=tmparr[10] ;

	var phacpr=tmparr[12] ; 
    var tmpRegno="";
    
    getDispDetail(phac)

    if (DetailCnt<1) return ;

    //start printing ...
    if (prnpath=="") {
            alert(t["CANNOT_FIND_TEM"]) ;
            return ;                }
    var Template=prnpath+"STP_WYY_SG.xls";
    var xlApp = new ActiveXObject("Excel.Application");
    var xlBook = xlApp.Workbooks.Add(Template);
    var xlsheet = xlBook.ActiveSheet ;
    var startNo=5 ;
    var row ;

    if (xlsheet==null) 
    {       alert(t["CANNOT_CREATE_PRNOBJ"]);
            return ;                }
    
    xlsheet.Cells(2, 1).Value =hospname  + getDesc(PhaLoc)+t['DISP_BILL']+"("+phacpr+DisTypeDesc+")"+reprnFlag;  
    xlsheet.Cells(4, 1).Value =t['WARD'] + getDesc(WardName)+ "     " +t['PRINTDATE']+getPrintDateTime()+"      " +t['DISP_NO'] +DispNo
    
    row=startNo;
    var exeDetail;
    var obj=document.getElementById("mListDispDetail")
    if (obj) exeDetail=obj.value;
    else exeDetail=""
        
    for (var i=1;i<=DetailCnt;i++)
    {           
        var ss=cspRunServerMethod(exeDetail,ProcessID,i)   
        var datas=ss.split("^")

        var bedcode=datas[5];
        var name=datas[1];
        var paregno=datas[0];
        var paage=datas[3];
        
        var orditemdesc=datas[10];
        var dosqty=datas[13];
        var freq= datas[14];

        var qty=datas[15];
        var uom=datas[16];
        var saleprice=datas[17];
        var prescno=datas[7];
        var ordstatus=datas[12];
        var instruction=datas[20];
        var duration= datas[21];
        var manf=datas[25];
        var spec=datas[26];
        var eatdrugtime=datas[27] 
        var amt=datas[18];
        var orddate=datas[29];
        var ordsttdate=datas[30];
            
        var diagnose=  datas[31]; 
        var generic= datas[32]; 
        
        //if ((tmpRegno!="")&&(paregno!=tmpRegno) )
       //  { 
	    //   row++;         
	    //   }  
	                   
        if (tmpRegno=="")
        {    //row+=2;
             mergcell(xlsheet,row,1,6) ;
            xlsheet.Cells(row, 1).value =t['PA_BEDNO'] +bedcode + "  " +t['PA_NO'] + paregno + "  "+ t['PA_NAME']+ name+ "  " +t['PA_AGE']+ paage + "    " + t['PA_DIAGNOSE'] +diagnose
            row++
            Head3(xlsheet,row)
            gridlist(xlsheet,row,row,1,6) ;
           
            row++
        }
        else
        {if (paregno!=tmpRegno)
            {   row=row+2;
            mergcell(xlsheet,row,1,6) ;
            xlsheet.Cells(row, 1).value =t['PA_BEDNO'] +bedcode + "  " +t['PA_NO'] + paregno + "  "+ t['PA_NAME']+ name+ "  " +t['PA_AGE']+ paage + "    " + t['PA_DIAGNOSE'] +diagnose
            row++
            Head3(xlsheet,row)
             gridlist(xlsheet,row,row,1,6) ;
            row++ }
        }
        xlsheet.Cells(row, 1).Value =orditemdesc; //orderitem description 
        xlsheet.Cells(row, 2).Value =manf   ;
        xlsheet.Cells(row, 3).Value =uom ; // eatdrugtime;
        xlsheet.Cells(row, 4).Value =qty ;   ;
       // xlsheet.Cells(row, 5).Value =dosqty; 
       // xlsheet.Cells(row, 6).Value = freq  ;
      //  xlsheet.Cells(row, 7).Value = instruction;
        xlsheet.Cells(row, 5).Value = saleprice;
        xlsheet.Cells(row, 6).Value = amt ;
     
      //  setBottomLine(xlsheet,row,1,9)
	    gridlist(xlsheet,row,row,1,6) ;
        row++;
        tmpRegno=paregno;
    }
       
 
    row+=2;
	mergcell(xlsheet,row,1,6)
    xlsheet.Cells(row,1).value=t['COLLECT']+ "            " +t['PACK']+"            " +t['DISPEN_USER']+"            "+t['SIGN_USER']+  "           "+ t['SENDER']
    
    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);
}

function Head1(sheet,row)
{
	sheet.Cells(row,1).value=t['DRG_DESC']
	sheet.Cells(row,2).value=t['DRG_MANF']
	sheet.Cells(row,3).value=t['DRG_UOM']
	sheet.Cells(row,4).value=t['DRG_QTY']
	sheet.Cells(row,5).value=t['DRG_DOSE']
	sheet.Cells(row,6).value=t['DRG_FREQ']
	sheet.Cells(row,7).value=t['DRG_INSTRUC']
	sheet.Cells(row,8).value=t['DRG_SP']
	sheet.Cells(row,9).value=t['DRG_AMT']
	nxlcenter(sheet,row,row,1,9)
}
function Head2(sheet,row)
{
	sheet.Cells(row,1).value=t['DRG_DESC']
	sheet.Cells(row,2).value=t['DRG_MANF']
	sheet.Cells(row,3).value=t['DRG_UOM']
	sheet.Cells(row,4).value=t['DRG_QTY']
	sheet.Cells(row,5).value=t['DRG_DOSE']
	sheet.Cells(row,6).value=t['DRG_FREQ']
	sheet.Cells(row,7).value=t['DRG_INSTRUC']
	sheet.Cells(row,8).value=t['DRG_EXE_DATETIME']
	sheet.Cells(row,9).value=t['DRG_EXECUTOR']
	nxlcenter(sheet,row,row,1,9)
}
function Head3(sheet,row)
{
	sheet.Cells(row,1).value=t['DRG_DESC']
	sheet.Cells(row,2).value=t['DRG_MANF']
	sheet.Cells(row,3).value=t['DRG_UOM']
	sheet.Cells(row,4).value=t['DRG_QTY']
	sheet.Cells(row,5).value=t['DRG_SP']
	sheet.Cells(row,6).value=t['DRG_AMT']
	nxlcenter(sheet,row,row,1,6)
}
function Head4(sheet,row)
{
	sheet.Cells(row,1).value=t['DRG_DESC']
	sheet.Cells(row,2).value=t['DRG_MANF']
	sheet.Cells(row,3).value=t['DRG_UOM']
	sheet.Cells(row,4).value=t['DRG_QTY']
	sheet.Cells(row,5).value=t['DRG_DOSE']
	sheet.Cells(row,6).value=t['DRG_FREQ']
	sheet.Cells(row,7).value=t['DRG_INSTRUC']
	sheet.Cells(row,8).value=t['DRG_EXE_DATETIME']
	sheet.Cells(row,9).value=t['DRG_EXECUTOR']
	sheet.Cells(row,10).value=t['DRG_STORD']
	nxlcenter(sheet,row,row,1,10)
}
function Head5(sheet,row)
{
	sheet.Cells(row,1).value=t['DRG_DESC']
  sheet.Cells(row,2).value=t['DRG_DOSE']
	sheet.Cells(row,3).value=t['DRG_QTY']
	sheet.Cells(row,4).value=t['DRG_jishu']
  sheet.Cells(row,5).value=t['DRG_UOM']
  sheet.Cells(row,6).value=t['DRG_SP']
	sheet.Cells(row,7).value=t['DRG_AMT']
	sheet.Cells(row,8).value=t['DRG_INSTRUC']
	sheet.Cells(row,9).value=t['DRG_FREQ']
  sheet.Cells(row,10).value=t['DRG_TREAT']
	sheet.Cells(row,11).value=t['DRG_BEIZU']
	sheet.Cells(row,12).value=t['DRG_pre']
	sheet.Cells(row,13).value=t['DRG_cyjy']
	nxlcenter(sheet,row,row,1,13)
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

function getDispCatDesc(catcode)
{
        var CatDesc="";
        var obj=document.getElementById("mGetDispCatDesc") ;
        if (obj) {var encmeth=obj.value;} else {var encmeth='';}
        CatDesc=cspRunServerMethod(encmeth,catcode) ;
        return CatDesc
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
    ProcessID=ss[1] ;
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
function getRePrintFlag()
{  
    var flag;
	var obj=document.getElementById("RePrintFlag") ;
	if (obj) flag=obj.value;
	if (flag=="") return false
	return true
}
function PrintCY(phac,phatype)
{    
    var sumamt=0;
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
    
    var DispNo=tmparr[9] ;
    var DisTypeDesc=tmparr[10] ;

	var phacpr=tmparr[12] ; 
    var tmpRegno="";
    
    
    if (phacpr==t['LONG_ORD'])   //如果按长期医嘱来开的话
    {   
     PrintLongOrdPJ(phac,phatype);
     return ;
    }
                        
    getDispDetail(phac)

    if (DetailCnt<1) return ;

    //start printing ...
    if (prnpath=="") {
            alert(t["CANNOT_FIND_TEM"]) ;
            return ;                }
    var Template=prnpath+"STP_CY_SG.xls";
    var xlApp = new ActiveXObject("Excel.Application");
    var xlBook = xlApp.Workbooks.Add(Template);
    var xlsheet = xlBook.ActiveSheet ;
    var startNo=5 ;
    var row ;

    if (xlsheet==null) 
    {       alert(t["CANNOT_CREATE_PRNOBJ"]);
            return ;                }
    
    xlsheet.Cells(2, 1).Value =hospname  + getDesc(PhaLoc)+t['DISP_BILL']+"("+phacpr+DisTypeDesc+")"+reprnFlag;  
    xlsheet.Cells(4, 1).Value =t['WARD'] + getDesc(WardName)+ "     " +t['PRINTDATE']+getPrintDateTime()+"      " +t['DISP_NO'] +DispNo
    
    row=startNo;
    var exeDetail;
    var obj=document.getElementById("mListDispDetail")
    if (obj) exeDetail=obj.value;
    else exeDetail=""
    //alert("exeDetail"+exeDetail)
        
    for (var i=1;i<=DetailCnt;i++)
    {           
        var ss=cspRunServerMethod(exeDetail,ProcessID,i)   
        
        var datas=ss.split("^")
         //alert("dates"+datas)
        var bedcode=datas[5];
        var name=datas[1];
        var paregno=datas[0];
        var paage=datas[3];
        
        var orditemdesc=datas[10];
        var dosqty=datas[13];
        var freq= datas[14];

        var qty=datas[15];
        var uom=datas[16];
        var saleprice=datas[17];
        var prescno=datas[7];
        var ordstatus=datas[12];
        var instruction=datas[20];
        var duration= datas[21];
        var manf=datas[25];
        var spec=datas[26];
        var eatdrugtime=datas[27] 
        var amt=datas[18];
        var orddate=datas[29];
        var ordsttdate=datas[30];
            
        var diagnose=  datas[31]; 
        var generic= datas[32]; 
        var beizhu= datas[34]; 
        var jishu=datas[35]
        var prescno1=datas[36]
        var cyjyfs=datas[37]
          
        
        //if ((tmpRegno!="")&&(paregno!=tmpRegno) )
       //  { 
	    //   row++;         
	    //   }  
	                   
        if (tmpRegno=="")
        {    //row+=2;
             mergcell(xlsheet,row,1,13) ;
            xlsheet.Cells(row, 1).value =t['PA_BEDNO'] + bedcode + "    "  +t['PA_NO'] + paregno + "  "+ t['PA_NAME']+ name+ "  " +t['PA_AGE']+ paage + "    "  + "  "+ t['PA_DIAGNOSE'] +diagnose
            row++
            Head5(xlsheet,row)
            gridlist(xlsheet,row,row,1,13) ;
           
            row++
        }
        else
        {if (paregno!=tmpRegno)
            {   row=row+2;
            mergcell(xlsheet,row,1,13) ;
            xlsheet.Cells(row, 1).value =t['PA_BEDNO'] + bedcode + "    "  +t['PA_NO'] + paregno + "  "+ t['PA_NAME']+ name+ "  " +t['PA_AGE']+ paage + "    "  + "  "+ t['PA_DIAGNOSE'] +diagnose
            row++
            Head5(xlsheet,row)
             gridlist(xlsheet,row,row,1,13) ;
            row++ }
        }
        sumamt=parseFloat(sumamt)+parseFloat(amt)
        xlsheet.Cells(row, 1).Value =orditemdesc; //orderitem description 
        xlsheet.Cells(row, 2).Value =dosqty;
        xlsheet.Cells(row, 3).Value =qty ; 
        xlsheet.Cells(row, 4).Value = jishu;  
         xlsheet.Cells(row, 5).Value =uom   ;
         xlsheet.Cells(row, 6).Value = saleprice;
        xlsheet.Cells(row, 7).Value = amt ;
         xlsheet.Cells(row, 8).Value =instruction; // eatdrugtime
        xlsheet.Cells(row, 9).Value = freq ;
        xlsheet.Cells(row, 10).Value = duration;
        xlsheet.Cells(row, 11).Value = beizhu;
        xlsheet.Cells(row, 12).Value = prescno1;
         xlsheet.Cells(row, 13).Value = cyjyfs;
    
  
     
      //  setBottomLine(xlsheet,row,1,9)
	    gridlist(xlsheet,row,row,1,13) ;
        row++;
        tmpRegno=paregno;
    }
       //row+=1;
       
      sumamt=sumamt.toFixed(2)
	xlsheet.Cells(row, 8).Value =t['SUM_AMT']+sumamt
    row+=1;
	mergcell(xlsheet,row,1,13)
    xlsheet.Cells(row,1).value=t['COLLECT']+ "            " +t['PACK']+"            " +t['DISPEN_USER']+"            "+t['SIGN_USER']+  "           "+ t['SENDER']
    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);
}

document.body.onload=BodyLoadHandler;