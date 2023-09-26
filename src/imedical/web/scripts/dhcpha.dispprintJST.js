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
var DetailCntPack; 

var cnt;
        
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
        
        var obj=document.getElementById("PrtHz")
        if (obj) isHz=obj.value ;
        
        isHz=1;
        
        // get print tempalate file from server 
        var obj=document.getElementById("mGetPrnPath") ;
        if (obj) {var encmeth=obj.value;} else {var encmeth='';}
        prnpath=cspRunServerMethod(encmeth,'','') ;
        
        //prnpath="c:\\moban\\"   //2007-03-18 moban change path
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
        case "ZSZJ":
           if (isHz==1) PrintHz(phac,phatype)  ;
           break;
        case "DSY":
           if (isHz==1) 
           {PrintHz(phac,phatype)  ;
            PrintHz(phac,phatype)  ;  //two times printing for DSY type 
           }
          break;
        case "ZZZJ":
           if (isHz==1) PrintHz(phac,phatype)  ;
          break;
        case "DSYG":
           if (isHz==1) PrintPJ(phac,phatype)  ;
          break;
        case "PTPJ":
           if (isHz==1) PrintPJ(phac,phatype)  ;
           break;
        case "MZYP":
           if (isHz==1) PrintPJ(phac,phatype)  ;
           break;
        case "JSYP":
           if (isHz==1) PrintPJ(phac,phatype)  ;
           break;
        case "ZCY":
			if (isHz==1) PrintZCHY(phac,phatype)  ;  //ZhongChengYao
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

        var objtbl=document.getElementById("t"+"dhcpha_dispprint")
        if (objtbl)  cnt=getRowcount(objtbl);
        if (cnt<=0) return ;
        //
        if (prnpath=="") {
                alert(t["CANNOT_FIND_TEM"]) ;
                return ;}
                
        var Template=prnpath+"STP_zjhzd_JST.xls";
        var xlApp = new ActiveXObject("Excel.Application");
        var  xlBook = xlApp.Workbooks.Add(Template);
        var xlsheet = xlBook.ActiveSheet ;      
	    var startNo=7 ;
	    var i ;
        if (xlsheet==null) 
        {alert(t["CANNOT_CREATE_PRNOBJ"]);
                return ; }
       
        getDispHZ(phac);
        
        if (TotalCnt>0) 
        {
	        xlsheet.Cells(2, 1).Value = hospname  //+ getDesc(PhaLoc)+DisTypeDesc+t['DISP_BILL'];  //hospital description
	        xlsheet.Cells(3, 1).Value = t['DISP_BILL']
	        xlsheet.Cells(4, 1).Value = t['PHARMACY']+ getDesc(PhaLoc) +"        "+t['DISP_NO'] +DispNo +"       "+t['DISPDATE']+DateRange
	        xlsheet.Cells(5, 1).Value = t['DISPCAT'] + DisTypeDesc + "         " + t['PRINTDATE']+ getPrintDateTime()
	        xlsheet.Cells(5, 4).Value =t['WARD']+getDesc(WardName)
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
                        
                        serialNo++;
                        
                        xlsheet.Cells(startNo+serialNo, 1).Value =serialNo
                        xlsheet.Cells(startNo+serialNo, 2).Value =incidesc ;            ///desc .
                        xlsheet.Cells(startNo+serialNo, 3).Value =stkbin ;////
                        xlsheet.Cells(startNo+serialNo, 4).Value =qty+" "+uom ; // 
                        xlsheet.Cells(startNo+serialNo, 5).Value = sp//  saleprice
                        xlsheet.Cells(startNo+serialNo, 6).Value = amt
                        
                        setBottomLine(xlsheet,startNo+serialNo,1,6);
                    }
                else 
                {incicode=""}
            } while (incicode!="")
        }
        
    var row=startNo+serialNo+2;

    //xlsheet.Cells(row,1).value=t['PRINT_USER']+session['LOGON.USERNAME']
    xlsheet.Cells(row,4).value=t['REC_USER']

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

    var tmpRegno="";
                        
    getDispDetail(phac)

   // if (DetailCnt<1) return ;

    //start printing ...
    if (prnpath=="") {
            alert(t["CANNOT_FIND_TEM"]) ;
            return ;                }
    var Template=prnpath+"STP_PJ_JST.xls";
    var xlApp = new ActiveXObject("Excel.Application");
    var xlBook = xlApp.Workbooks.Add(Template);
    var xlsheet = xlBook.ActiveSheet ;
    var startNo=6 ;
    var row ;

    if (xlsheet==null) 
    {       alert(t["CANNOT_CREATE_PRNOBJ"]);
            return ;                }
    
    xlsheet.Cells(2, 1).Value = hospname
    xlsheet.Cells(3, 1).Value = t['WARD_DRUGLIST'] 
    xlsheet.Cells(4, 1).Value =t['PHARMACY']+ getDesc(PhaLoc) +"     " +t['DISP_NO'] +DispNo +"    "+t['DISPDATE']+DateRange
    xlsheet.Cells(5, 1).Value = t['DISPCAT']+DisTypeDesc 
    xlsheet.Cells(5, 4).Value = t['WARD'] + getDesc(WardName) 
    xlsheet.Cells(5, 5).Value =t['PRINTDATE']+getPrintDateTime(); 

    row=startNo;
    var exeDetail;
    var obj=document.getElementById("mListDispDetail")
    if (obj) exeDetail=obj.value;
    else exeDetail=""
    
    if (DetailCnt>0)  //2007-04-17
     {    
	    for (var i=1;i<=DetailCnt;i++)
	    {           
	        var ss=cspRunServerMethod(exeDetail,ProcessID,i)   
	        var datas=ss.split("^")
	
	        var bedcode=datas[5];
	        var name=datas[1];
	        var paregno=datas[0];
	        
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
	        var priority=datas[33];
	        
	         
	        if ((tmpRegno!="")&&(paregno!=tmpRegno) )
	         {//setBottomDblLine(xlsheet,row,1,13); 
		      setBottomLine(xlsheet,row,1,13);
		       }  
		     row++;                        
	      //  alert(row)
	        if (tmpRegno=="")
	        {       
	            xlsheet.Cells(row, 1).Value =bedcode;//bed code
	            xlsheet.Cells(row, 2).Value =name; //patient name
	            xlsheet.Cells(row, 3).Value =paregno 
	          cellEdgeRightLine(xlsheet,row,1,13)
	          //row++
	        }
	        else
	        {if (paregno!=tmpRegno)
	            {   //row=row+1;
	            xlsheet.Cells(row, 1).Value =bedcode;//bed code
	            xlsheet.Cells(row, 2).Value =name; //patient name
	            xlsheet.Cells(row, 3).Value =paregno 
	            cellEdgeRightLine(xlsheet,row,1,13)
	           // row++ 
	            }
	        }
	        xlsheet.Cells(row, 4).Value =orditemdesc; //orderitem description 
			xlsheet.Cells(row, 5).Value =dosqty ;
			xlsheet.Cells(row, 6).Value =freq ;
	        xlsheet.Cells(row, 7).Value =eatdrugtime;
	        xlsheet.Cells(row, 8).Value =uom; 
	        xlsheet.Cells(row, 9).Value = orddate;
	        xlsheet.Cells(row, 10).Value = ordsttdate;
	        xlsheet.Cells(row, 11).Value = priority;
	        xlsheet.Cells(row, 12).Value = saleprice;
	        xlsheet.Cells(row, 13).Value = amt;
	        
		      cellEdgeRightLine(xlsheet,row,1,13)
	      
	       // setBottomLine(xlsheet,row,4,9)
	        tmpRegno=paregno;
	    }
	        setBottomLine(xlsheet,row,1,13)
    } //2007-04-17

	if (DetailCntPack>0)
	{
	    if (DetailCnt>0)  //2007-04-17
	     { 
		    row+=2;    
		    setBottomLine(xlsheet,row,1,13) 
		    }
	    else			//2007-04-17
	        { row=startNo; }
	    	
		var tmpRegno="" 
	    var exeDetail;
	    var obj=document.getElementById("mListDispDetailPack")
	    if (obj) exeDetail=obj.value;
	    else exeDetail=""
		
		for (var i=1;i<=DetailCntPack;i++)
		{
	        var ss=cspRunServerMethod(exeDetail,ProcessID,i)   
		    var datas=ss.split("^")
		
		    var bedcode=datas[5];
		    var name=datas[1];
		    var paregno=datas[0];
		    
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
		    var priority=datas[33];	
			
	        if ((tmpRegno!="")&&(paregno!=tmpRegno) )
	         {//setBottomDblLine(xlsheet,row,1,13); 
		      setBottomLine(xlsheet,row,1,13);
		       }  
		     row++;                        
	      //  alert(row)
	        if (tmpRegno=="")
	        {       
	            xlsheet.Cells(row, 1).Value =bedcode;//bed code
	            xlsheet.Cells(row, 2).Value =name; //patient name
	            xlsheet.Cells(row, 3).Value =paregno 
	          cellEdgeRightLine(xlsheet,row,1,13)
	          //row++
	        }
	        else
	        {if (paregno!=tmpRegno)
	            {   //row=row+1;
	            xlsheet.Cells(row, 1).Value =bedcode;//bed code
	            xlsheet.Cells(row, 2).Value =name; //patient name
	            xlsheet.Cells(row, 3).Value =paregno 
	            cellEdgeRightLine(xlsheet,row,1,13)
	           // row++ 
	            }
	        }
	        xlsheet.Cells(row, 4).Value =orditemdesc; //orderitem description 
			xlsheet.Cells(row, 5).Value =dosqty ;
			xlsheet.Cells(row, 6).Value =freq ;
	        xlsheet.Cells(row, 7).Value =eatdrugtime;
	        xlsheet.Cells(row, 8).Value =uom; 
	        xlsheet.Cells(row, 9).Value = orddate;
	        xlsheet.Cells(row, 10).Value = ordsttdate;
	        xlsheet.Cells(row, 11).Value = priority;
	        xlsheet.Cells(row, 12).Value = saleprice;
	        xlsheet.Cells(row, 13).Value = amt;
	        
		    cellEdgeRightLine(xlsheet,row,1,13)
	      
	       // setBottomLine(xlsheet,row,4,9)
	        tmpRegno=paregno;
		}
        setBottomLine(xlsheet,row,1,13)
	}
	
    row+=2;
	mergcell(xlsheet,row,1,13)
    xlsheet.Cells(row,1).value=t['DISPEN_USER'] +dispUser  + "             " +t['REC_USER'];
    
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

function cellEdgeRightLine(objSheet,row,c1,c2)
{
	for (var i=c1;i<=c2;i++)
	{
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(10).LineStyle=1;
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(7).LineStyle=1;
	}
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
    DetailCntPack=ss[2]
    
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

function PrintZCHY(phac,phatype)
{//printing ZhongChengYao
	
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

    var tmpRegno="";
                        
    getDispDetail(phac)

    if (DetailCnt<1) return ;

    //start printing ...
    if (prnpath=="") {
            alert(t["CANNOT_FIND_TEM"]) ;
            return ;                }
    var Template=prnpath+"STP_ZCHY_JST.xls";
    var xlApp = new ActiveXObject("Excel.Application");
    var xlBook = xlApp.Workbooks.Add(Template);
    var xlsheet = xlBook.ActiveSheet ;
    var startNo=6 ;
    var row ;

    if (xlsheet==null) 
    {       alert(t["CANNOT_CREATE_PRNOBJ"]);
            return ;                }
    
    xlsheet.Cells(2, 1).Value = hospname
    xlsheet.Cells(3, 1).Value = t['WARD_DRUGLIST'] 
    xlsheet.Cells(4, 1).Value =t['PHARMACY']+ getDesc(PhaLoc) + "        " +t['DISP_NO'] +DispNo +"      "+t['DISPDATE']+DateRange
    xlsheet.Cells(5, 1).Value = t['DISPCAT']+DisTypeDesc 
    xlsheet.Cells(5, 4).Value = t['WARD'] + getDesc(WardName) 
    xlsheet.Cells(5, 5).Value =t['PRINTDATE']+getPrintDateTime(); 

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
        
        var orditemdesc=datas[10];
        var dosqty=datas[13];
        var freq= datas[14];

        var qty=datas[15];
        var uom=datas[16];
        var saleprice=datas[17];
     //   var prescno=datas[7];
     //   var ordstatus=datas[12];
     //   var instruction=datas[20];
     //   var duration= datas[21];
     //   var manf=datas[25];
    //    var spec=datas[26];
      //  var eatdrugtime=datas[27] 
        var amt=datas[18];
       // var orddate=datas[29];
      //  var ordsttdate=datas[30];
      //  var priority=datas[33];
         
        if ((tmpRegno!="")&&(paregno!=tmpRegno) )
         {
	      setBottomLine(xlsheet,row,1,7);
	       }  
	     row++;                        
      //  alert(row)
        if (tmpRegno=="")
        {       
            xlsheet.Cells(row, 1).Value =bedcode;//bed code
            xlsheet.Cells(row, 2).Value =name; //patient name
            xlsheet.Cells(row, 3).Value =paregno 
          cellEdgeRightLine(xlsheet,row,1,7)
          //row++
        }
        else
        {if (paregno!=tmpRegno)
            {   //row=row+1;
            xlsheet.Cells(row, 1).Value =bedcode;//bed code
            xlsheet.Cells(row, 2).Value =name; //patient name
            xlsheet.Cells(row, 3).Value =paregno 
            cellEdgeRightLine(xlsheet,row,1,7)
           // row++ 
            }
        }
        xlsheet.Cells(row, 4).Value =orditemdesc; //orderitem description 
        xlsheet.Cells(row, 5).Value =uom; 
        xlsheet.Cells(row, 6).Value = saleprice;
        xlsheet.Cells(row, 7).Value = amt;
        
	      cellEdgeRightLine(xlsheet,row,1,7)
      
        tmpRegno=paregno;
    }
        setBottomLine(xlsheet,row,1,7)
 
    row+=2;
	mergcell(xlsheet,row,1,7)
    xlsheet.Cells(row,1).value=t['DISPEN_USER'] +dispUser  + "             " +t['REC_USER'];
    
    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);
	
}


document.body.onload=BodyLoadHandler;