
var gHospname;
var gPrnfmt;
var gPrnpath;
var gGrp;
var gIsHz=0  // "hz" print mode

var gProcessID ;
var gTotalCnt ;
var gDetailCnt ;
var gDetailCntPack; 

var cnt;
var gPhaCnt=0 //打印发药单数

     
function BodyLoadHandler()
{		
	var phac;

	var obj=document.getElementById("Phac") ;
	if (obj) phac=obj.value ;
	
	
	var obj=document.getElementById("PID") ;
	if (obj) pid=obj.value ;

	if (pid=="")
	{return;}
	
	gGrp=session['LOGON.GROUPID'];
	
	var obj=document.getElementById("mPrtHospName") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	gHospname=cspRunServerMethod(encmeth,'','') ;
	
	// get print tempalate path from server 
	var obj=document.getElementById("mGetPrnPath") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	gPrnpath=cspRunServerMethod(encmeth,'','') ;
    

	if (phac!=""){printAll(phac);} 
	
    if (pid!="001"){
	    ///001 - 代表已发药查询打印
        PrintNoStockReport(pid);  }   //打印库存不足药品
	     
	
	//window.close();
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

	PrtDSYHzHXY();///发送全院大输液 for 华西 一院
	
	var i;
	var phaType;
	
	if(phacStr!="")
	{
		phacArr=phacStr.split("A");
		
	}
    
	for(i=0;i<phacArr.length;i++)
	{
		phac=phacArr[i].split("B");
		phaType=GetDispType(phac[0]);
		//phaType=GetDispType(phacArr[i]);
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
     gPrnfmt=cspRunServerMethod(encmeth,'','',phac) ;
}
	
function Prnt(phac,phatype)
{ 
    
    if (phac=="")  return 0 ;
    var tmps=getDispMainInfo(phac);
    if (tmps=="" ) return;
    var tmparr=tmps.split("^");
    var PhaLoc=tmparr[0] ;
    var WardName=tmparr[1] ;
    if (WardName=="0") 
    {   
      //医生科室发药
      PrintHz(phac,phatype)  ; 
      return ;
    }
  
    switch (phatype) {
       
        case "ZJ":
        
	        PrintHz(phac,phatype)  ; //发药(针剂)
            PrintPJ(phac,phatype)  ; //摆药
           	break;
        case "DSY":

	        PrintDSY(phac,phatype)  ; //大输液
            PrintPJ(phac,phatype)  ;
            break;
        case "PJ":

	        PrintHz(phac,phatype)  ; //片剂
            PrintPJ(phac,phatype)  ; 
           	break;  
        case "ZCY":
            PrintZCY(phac,phatype) ;//中草药发药单
            //PrintZCYTIAOMA(phac,phatype);//草药条码
            break; 
        case "GZYP":
        
	        PrintHz(phac,phatype)  ; //发药
            PrintPJ(phac,phatype)  ; //摆药
           	break;
        case "MZYP":
        
	        PrintHz(phac,phatype)  ; //发药
            PrintPJ(phac,phatype)  ; //摆药
           	break;
         case "JSYP":
        
	        PrintHz(phac,phatype)  ; //发药
            PrintPJ(phac,phatype)  ; //摆药
           	break; 
         case "KFY":
        
	        PrintHz(phac,phatype)  ; //发药
            PrintPJ(phac,phatype)  ; //摆药
           	break; 
           	 	 
        default:
        alert("药品类别设置不匹配,请核实!")
	}
	KillTmp();

}

function PrintNoStockReport(pid)
{
    ///Description:打印库存不足药品
    ///Creator: LQ 2008-11-23
    
    var rowid=""
  	var xx=document.getElementById("mListNoStock");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
    var retstr=cspRunServerMethod(encmeth,pid,rowid) ;
    if (retstr==""){return;}
   
	
	var Template=gPrnpath+"STP_PrintNoStk.xls";
    var xlApp = new ActiveXObject("Excel.Application");
    var xlBook = xlApp.Workbooks.Add(Template);
    var xlsheet = xlBook.ActiveSheet ;
    var Startrow=2 
    var i=0
    
	xlsheet.Cells(Startrow-1, 1).Value = "库存不足药品"
	xlsheet.Cells(Startrow-1, 4).Value = "时间:"+getPrintDateTime();
	xlsheet.Cells(Startrow, 1).Value = "病区" 
	xlsheet.Cells(Startrow, 2).Value = "床号"
	xlsheet.Cells(Startrow, 3).Value = "姓名" 
	xlsheet.Cells(Startrow, 4).Value = "药品" 
	xlsheet.Cells(Startrow, 5).Value = "数量" 
    
  
	do{
		var xx=document.getElementById("mListNoStock");
	    if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	    var retstr=cspRunServerMethod(encmeth,pid,rowid) ;
	    
	    if (retstr!=""){
	           
			    var tmpstr=retstr.split("^")
			        rowid=tmpstr[0]
			    var ward=tmpstr[1]
			    var bed=tmpstr[2]
			    var name=tmpstr[3]
			    var incidesc=tmpstr[4]
			    var qty=tmpstr[5]
			    var orddate=tmpstr[6]
			    i=i+1
			    xlsheet.Cells(Startrow+i, 1).Value = ward 
			    xlsheet.Cells(Startrow+i, 2).Value = bed 
			    xlsheet.Cells(Startrow+i, 3).Value = name 
			    xlsheet.Cells(Startrow+i, 4).Value = incidesc
			    xlsheet.Cells(Startrow+i, 5).Value = qty
	            xlsheet.Cells(Startrow+i, 5).Value = orddate
	            
	        }else{rowid=""}
	     
	    //setBottomLine(xlsheet,Startrow-1+i,1,5);
	
	   }while(rowid!="");
	
	xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet)
    KillNoSTK(pid);
   
}

function KillNoSTK(pid)
{
		var xx=document.getElementById("mKillNoStock");
	    if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	    var retstr=cspRunServerMethod(encmeth,pid) ;
}

function PrtDSYHzHXY()
{
	var objTotalPrn=document.getElementById("TotalPrn");
	var tflag=objTotalPrn.value
	if (tflag>1) { PrintHXY(tflag);}
}
function PrintHXY(pid)
{
	///Description:全院大输液汇总打印 for HX 一院
	///Creator:lq 08-11-08
	
 try{
	 
	var inci=""
	var serialNo=0
	
    if (gPrnpath=="") 
        {
        	alert(t["CANNOT_FIND_TEM"]) ;
            return ;
       	}
                
    var Template=gPrnpath+"STP_DSY_HX.xls";
    //var Template="C:\\STP_zjhzd_HX.xls";
    var xlApp = new ActiveXObject("Excel.Application");
    var xlBook = xlApp.Workbooks.Add(Template);
    var xlsheet = xlBook.ActiveSheet ; 
	
	var startrow=3 ; 
	if (xlsheet==null)
		{ 
		return ;		  }
		
	//var hospname=hospitalName();
	var colluserid=session['LOGON.USERID']
	
	var obj=document.getElementById("ListPrtDSY") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var incicode=""
	do
	{
		
		var datas=cspRunServerMethod(encmeth,pid,colluserid,inci) ;
		if (datas!=""){
		    var ss=datas.split("^");  
		    var gen=ss[0];
            var incidesc=ss[1];
            var spec=ss[2];
            var qty=ss[4];
            var uom=ss[3];
            var manf=ss[5];
            var inci=ss[6];
            var phaloc=ss[7];
            var fdate=ss[8];
            var fdate=ss[9];
            var DateRange=formatDate2(fdate)+"--"+formatDate2(fdate);
            serialNo++;
            
            xlsheet.Cells(startrow+serialNo,1)=gen;
            xlsheet.Cells(startrow+serialNo,2)=incidesc;
            //xlsheet.Cells(startrow+serialNo,3)=spec;  
            xlsheet.Cells(startrow+serialNo,3)=uom;
            xlsheet.Cells(startrow+serialNo,4)=qty;
            xlsheet.Cells(startrow+serialNo,5)=manf;
            setBottomLine(xlsheet,startrow+serialNo,1,5);
            cellEdgeRightLine(xlsheet,startrow+serialNo,1,5)
            }
        else 
        {inci=""}
	}while (inci!="");
	
	xlsheet.Cells(1,1)="输液药品配送清单"
	xlsheet.Cells(2,1)=getDesc(phaloc) + "    "+DateRange
	
	
    xlsheet.printout();
    xlApp=null;
	xlsheet=null;
	xlBook.Close(savechanges=false);
	
 
                   }
             catch(e)
             {
	             alert(e.message);
             }	
	
}
	

function PrintHz(phac,phatype)
{    
        //retrieving primary dispensing infomation...
  try{
	    gPhaCnt=gPhaCnt+1
	    var PagNum=1;
        var objTotalPrn=document.getElementById("TotalPrn");
        if (objTotalPrn.value!=1){return;}
        var reflag="";//补打标记
	    var objRePrintFlag=document.getElementById("RePrintFlag");
        if (objRePrintFlag.value==1){var reflag="(补)"}
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
        var PrtType1=tmparr[4] ;Priority
        var Priority=tmparr[13] ;
       
        var DateRange=formatDate2(dispsd)+"--"+formatDate2(disped);
        var DispNo=tmparr[9] ;
        var DisTypeDesc=tmparr[10] ;
        var docloc=tmparr[13] ;
		
        if (gPrnpath=="") 
        {
        	alert(t["CANNOT_FIND_TEM"]) ;
            return ;
       	}
                
        var Template=gPrnpath+"STP_HZ_HXY.xls";
        //var Template="C:\\STP_zjhzd_HX.xls";
        var xlApp = new ActiveXObject("Excel.Application");
        var xlBook = xlApp.Workbooks.Add(Template);
        var xlsheet = xlBook.ActiveSheet ; 
        //-------自定义纸张 lq
       /*
	    var papersize=0;
        var paperset = new ActiveXObject("PaperSet.GetPrintInfo");
        var papersize=paperset.GetPaperInfo("stockxy");
        //alert(papersize)
        if (papersize!=0){
        xlsheet.PageSetup.PaperSize = papersize;}
            */
        //-------     
	    var startNo=5 ;
	    var i ;
	    
	    
        if (xlsheet==null) 
        {
	        alert(t["CANNOT_CREATE_PRNOBJ"]);
            return ; 
        }
        
        getDispHZ(phac);
        PagNum=+1;
        if (gTotalCnt>0) 
        {
             /*
	        xlsheet.Cells(1, 1).Value = gHospname  //+ getDesc(PhaLoc)+DisTypeDesc+t['DISP_BILL'];  //hospital description
	        
	        
	        xlsheet.Cells(2, 1).Value =getDesc(admloc) +DisTypeDesc+"药品清单"+reflag
	        //xlsheet.Cells(2, 1).Value = t['DISP_BILL']
	        xlsheet.Cells(3, 1).Value ="单号:"+DispNo
	        //xlsheet.Cells(3, 1).Value ="("+Priority+")" +"  "+ t['DISPDATE']+DateRange+reflag
	        xlsheet.Cells(4, 1).Value ="配送地点"+getDesc(admloc)+"     "+"审核医师:"+"     "+"摆药医师:"+"     "+t['PRINTDATE']+ formatDate2(getPrintDate())+" "+getPrintTime()
	        //xlsheet.Cells(4, 4).Value =t['WARD']+getDesc(WardName)
	        */
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
	        var admloc;
            
            var obj=document.getElementById("mListDispTotal")
            if (obj) exe=obj.value;
            else  exe="" ;
           
            do 
            {
	            datas=cspRunServerMethod(exe,incicode,gProcessID);
	            if (datas!="")
                    {
                        var ss=datas.split("^");
                        incicode=ss[0];
                        //var tmpincidesc=ss[1].split("(")
                        //incidesc=tmpincidesc[0];
                        incidesc=ss[1]
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
                        
                        admloc=ss[13];
   
                        drugform=ss[8];
                        resqty=ss[9] ;  //exclude qty
                        barcode=ss[12];
                        stkbin=ss[10];
                        generic=ss[11];
                        
                        serialNo++;
                      
                        
                        xlsheet.Cells(startNo+serialNo, 1).Value =getDesc(generic);
                        xlsheet.Cells(startNo+serialNo, 2).Value =incidesc;
                        xlsheet.Cells(startNo+serialNo, 3).Value =qty+" "+uom ;    
                        xlsheet.Cells(startNo+serialNo, 4).Value =drugform;
                        //xlsheet.Cells(startNo+serialNo, 5).Value =barcode; 
                        //xlsheet.Cells(startNo+serialNo, 6).Value = sp;  
                        //xlsheet.Cells(startNo+serialNo, 7).Value = amt;
                        //xlsheet.Cells(startNo+serialNo, 8).Value =manf;       
                        //xlsheet.Cells(startNo+serialNo, 9).Value =stkbin;
                        //setBottomLine(xlsheet,startNo+serialNo,1,9);
                        //cellEdgeRightLine(xlsheet,startNo+serialNo,1,9)
                    }
                else 
                {incicode=""}
            } while (incicode!="")
        }
    //总计
      //xlsheet.Cells(1, 1).Value = gHospname 
      xlsheet.Cells(2, 1).Value =getDesc(WardName) +DisTypeDesc+"药品汇总清单"+reflag
	  //xlsheet.Cells(2, 1).Value = t['DISP_BILL']
	  xlsheet.Cells(3, 1).Value ="单号:"+DispNo+"   "+"("+Priority+")"
	  //xlsheet.Cells(3, 1).Value ="("+Priority+")" +"  "+ t['DISPDATE']+DateRange+reflag
	  xlsheet.Cells(4, 1).Value ="配送地点:"+getDesc(WardName)+"   "+"审核医师:"+"       "+"摆药医师:"+"       "+t['PRINTDATE']+ formatDate2(getPrintDate())+" "+getPrintTime()+"    ("+gPhaCnt+")"
     /*
    var row=startNo+serialNo+1;
    xlsheet.Cells(row,1).value=t['SUM_AMT']
    xlsheet.Cells(row,7).value=sumamt
       
    var row=startNo+serialNo+2;
    xlsheet.Cells(row,1).value=t['PRINT_USER']+session['LOGON.USERNAME']
    xlsheet.Cells(row,3).value=t['ADJ_USER']
    CellMerge(xlsheet,row,row,5,6);
    xlsheet.Cells(row,5).value=t['DISPEN_USER']
    xlsheet.Cells(row,8).value=t['REC_USER']
    */
     // alert(startNo+serialNo)
                       
    xlsheet.printout();
    
    SetNothing(xlApp,xlBook,xlsheet)
    
                 }
             catch(e)
             {
	             alert(e.message);
             }
} 
function PrintDSY(phac,phatype)
{    
        //retrieving primary dispensing infomation...
  try{
        var objTotalPrn=document.getElementById("TotalPrn");
        if (objTotalPrn.value==0){return;}

        var reflag="";//补打标记
	    var objRePrintFlag=document.getElementById("RePrintFlag");
        if (objRePrintFlag.value==1){var reflag="(补)"}
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
        var PrtType1=tmparr[4] ;Priority
        var Priority=tmparr[13] ;
        var DateRange=formatDate2(dispsd)+"--"+formatDate2(disped);
        var DispNo=tmparr[9] ;
        var DisTypeDesc=tmparr[10] ;
        var docloc=tmparr[13] ;
		
        if (gPrnpath=="") 
        {
        	alert(t["CANNOT_FIND_TEM"]) ;
            return ;
       	}
                
        var Template=gPrnpath+"STP_HZDSY_HXY.xls";
        //var Template="C:\\STP_zjhzd_HX.xls";
        var xlApp = new ActiveXObject("Excel.Application");
        var xlBook = xlApp.Workbooks.Add(Template);
        var xlsheet = xlBook.ActiveSheet ; 
        //-------自定义纸张 lq
       /*
	    var papersize=0;
        var paperset = new ActiveXObject("PaperSet.GetPrintInfo");
        var papersize=paperset.GetPaperInfo("stockxy");
        //alert(papersize)
        if (papersize!=0){
        xlsheet.PageSetup.PaperSize = papersize;}
            */
        //-------     
	    var startNo=5 ;
	    var i ;
        if (xlsheet==null) 
        {
	        alert(t["CANNOT_CREATE_PRNOBJ"]);
            return ; 
        }
        
        getDispHZ(phac);
        
        if (gTotalCnt>0) 
        {
             /*
	        xlsheet.Cells(1, 1).Value = gHospname  //+ getDesc(PhaLoc)+DisTypeDesc+t['DISP_BILL'];  //hospital description
	        
	        
	        xlsheet.Cells(2, 1).Value =getDesc(admloc) +DisTypeDesc+"药品清单"+reflag
	        //xlsheet.Cells(2, 1).Value = t['DISP_BILL']
	        xlsheet.Cells(3, 1).Value ="单号:"+DispNo
	        //xlsheet.Cells(3, 1).Value ="("+Priority+")" +"  "+ t['DISPDATE']+DateRange+reflag
	        xlsheet.Cells(4, 1).Value ="配送地点"+getDesc(admloc)+"     "+"审核医师:"+"     "+"摆药医师:"+"     "+t['PRINTDATE']+ formatDate2(getPrintDate())+" "+getPrintTime()
	        //xlsheet.Cells(4, 4).Value =t['WARD']+getDesc(WardName)
	        */
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
	        var admloc;
            
            var obj=document.getElementById("mListDispTotal")
            if (obj) exe=obj.value;
            else  exe="" ;
           
            do 
            {
	            datas=cspRunServerMethod(exe,incicode,gProcessID);
	            if (datas!="")
                    {
                        var ss=datas.split("^");
                        incicode=ss[0];
                        //var tmpincidesc=ss[1].split("(")
                        //incidesc=tmpincidesc[0];
                        incidesc=ss[1]
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
                        
                        admloc=ss[13];
   
                        drugform=ss[8];
                        resqty=ss[9] ;  //exclude qty
                        barcode=ss[12];
                        stkbin=ss[10];
                        generic=ss[11];
                        
                        serialNo++;
                        
                        xlsheet.Cells(startNo+serialNo, 1).Value =getDesc(WardName)
                        xlsheet.Cells(startNo+serialNo, 2).Value =getDesc(generic);
                        xlsheet.Cells(startNo+serialNo, 3).Value =incidesc;
                        //xlsheet.Cells(startNo+serialNo, 4).Value =barcode;
                        xlsheet.Cells(startNo+serialNo, 4).Value =uom ;
                        xlsheet.Cells(startNo+serialNo, 5).Value =qty ;
                        xlsheet.Cells(startNo+serialNo, 6).Value =manf;    
                        //xlsheet.Cells(startNo+serialNo, 5).Value =drugform;
                        
                        //xlsheet.Cells(startNo+serialNo, 6).Value = sp;  
                        //xlsheet.Cells(startNo+serialNo, 7).Value = amt;
                        //xlsheet.Cells(startNo+serialNo, 8).Value =manf;       
                        //xlsheet.Cells(startNo+serialNo, 9).Value =stkbin;
                        setBottomLine(xlsheet,startNo+serialNo,1,7);
                        cellEdgeRightLine(xlsheet,startNo+serialNo,1,7)
                    }
                else 
                {incicode=""}
            } while (incicode!="")
        }
    //总计
      //xlsheet.Cells(1, 1).Value = gHospname 
      xlsheet.Cells(2, 1).Value ="输液药品明细清单"+reflag
	  //xlsheet.Cells(2, 1).Value = t['DISP_BILL']
	  //xlsheet.Cells(3, 1).Value ="单号:"+DispNo
	  //xlsheet.Cells(3, 1).Value ="("+Priority+")" +"  "+ t['DISPDATE']+DateRange+reflag
	  xlsheet.Cells(3, 1).Value =getDesc(PhaLoc)+"   "+DateRange
     /*
    var row=startNo+serialNo+1;
    xlsheet.Cells(row,1).value=t['SUM_AMT']
    xlsheet.Cells(row,7).value=sumamt
       
    var row=startNo+serialNo+2;
    xlsheet.Cells(row,1).value=t['PRINT_USER']+session['LOGON.USERNAME']
    xlsheet.Cells(row,3).value=t['ADJ_USER']
    CellMerge(xlsheet,row,row,5,6);
    xlsheet.Cells(row,5).value=t['DISPEN_USER']
    xlsheet.Cells(row,8).value=t['REC_USER']
    */
    xlsheet.printout();
    
    SetNothing(xlApp,xlBook,xlsheet)
    
                 }
             catch(e)
             {
	             alert(e.message);
             }
}       
function PrintPJ(phac,phatype)
{
	
 try{
		
	//gPhaCnt=gPhaCnt+1
	var objDetailPrn=document.getElementById("DetailPrn") ;
	if (objDetailPrn.value!=1) {return;}
	var reflag="";//补打标记
	var objRePrintFlag=document.getElementById("RePrintFlag");
    if (objRePrintFlag.value==1){var reflag="(补)"}
	var sumamt=0
	var PagNum=1
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
    var Priority=tmparr[13] ;
    var DateRange=formatDate2(dispsd)+"--"+formatDate2(disped);
    
    var DispNo=tmparr[9] ;
    var DisTypeDesc=tmparr[10] ;
    var tmpRegno="";
    var patTotal=0;		//总计人数                
    getDispDetail(phac)
    
    if (gPrnpath=="") 
    {
    	alert(t["CANNOT_FIND_TEM"]) ;
        return ;                
    }
    var Template=gPrnpath+"STP_MX_HXY.xls";
    var xlApp = new ActiveXObject("Excel.Application");
    var xlBook = xlApp.Workbooks.Add(Template);
    var xlsheet = xlBook.ActiveSheet ;
     //-------自定义纸张 lq
     /*
        var paperset = new ActiveXObject("PaperSet.GetPrintInfo");
        var papersize=paperset.GetPaperInfo("stockxy");
        //alert(papersize);
        if (papersize!=0){
        xlsheet.PageSetup.PaperSize = papersize;}
        */
     //-------
    var startNo=4 ;
    var row ;

    if (xlsheet==null) 
    {       
    	alert(t["CANNOT_CREATE_PRNOBJ"]);
        return ;                
    }
    /*
    xlsheet.Cells(1, 1).Value = gHospname
    xlsheet.Cells(2, 1).Value = getDesc(admloc)+DisTypeDesc+"药品名细清单"
    xlsheet.Cells(3, 1).Value = "单号:"+DispNo
    xlsheet.Cells(4, 1).Value = "配送地点"+getDesc(admloc)+"     "+"审核医师:"+"     "+"摆药医师:"+"     "+t['PRINTDATE']+ formatDate2(getPrintDate())+" "+getPrintTime()
    xlsheet.Cells(3, 1).Value ="("+Priority+")"+"  "+t['DISPDATE']+DateRange+reflag
    xlsheet.Cells(4, 1).Value = t['PRINTDATE']+formatDate2(getPrintDate())+" "+getPrintTime(); 
    xlsheet.Cells(4, 4).Value = t['WARD'] + getDesc(WardName) 
    xlsheet.Cells(4, 5).Value =t['PRINTDATE']+getPrintDateTime(); 
    */
	    
	//var LeftHeader= " "; CenterHeader= " "; RightHeader= " "; LeftFooter= " "; CenterFooter= " "; RightFooter= " ";
	//var titleRows = 0;titleCols = 0 ;
	//var CenterHeader="&14"+gHospname+"\r"+getDesc(WardName)+"  "+ getDesc(PhaLoc)+DisTypeDesc+"摆药单No."+DispNo+"\r"+"&12"+"("+Priority+")"+"  "+t['DISPDATE']+DateRange+reflag
	//var LeftHeader="\r"+"\r"+"\r"+"第"+PagNum+"页" +"   "+t['PRINTDATE']+formatDate2(getPrintDate())+" "+getPrintTime();
    //ExcelSet(xlsheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter)
    PagNum=+1;
    row=startNo;
    var exeDetail;
    var obj=document.getElementById("mListDispDetail")
    if (obj) exeDetail=obj.value;
    else exeDetail=""
    var admloc;

    if (gDetailCnt>0)  //2007-04-17
     {    
	    for (var i=1;i<=gDetailCnt;i++)
	    {           
	        var ss=cspRunServerMethod(exeDetail,gProcessID,i)   
	        var datas=ss.split("^")
	        //alert(datas)
	
	        var bedcode=datas[5];
	        var name=datas[1];
	        var sex=datas[2];
	        var paregno=datas[0];
	        var patdob=datas[3];
	        //var tmpitemdesc=datas[10].split("(");
	        //var orditemdesc=tmpitemdesc[0];
	        var orditemdesc=datas[10]
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

	        var sumamt=parseFloat(sumamt)+parseFloat(amt)
	        var orddate=datas[29];
	        var ordsttdate=datas[30];
	        var priority=datas[33];
	        var drugform=datas[38];	        
	        var doctor=datas[8];
	        var action=datas[24];
	        var sprice=datas[17];
	        var sumprice=datas[18]
	        var diag=datas[31]
	        admloc=datas[6]
	        generic=datas[32]
	        
	        if ((tmpRegno!="")&&(paregno!=tmpRegno) )
	         {//setBottomDblLine(xlsheet,row,1,13); 
		      	//setBottomLine(xlsheet,row,1,9);
		     }  
		     //row++;                        
	        if (tmpRegno=="")
	        {  
	            row=row+1
	           	mergcell(xlsheet,row,1,9)
	            xlsheet.Cells(row, 1).Value =getDesc(WardName)+" "+"床号:"+bedcode+" "+"登记号:"+paregno+" "+"姓名:"+name+" "+"性别:"+sex+" "+"年龄:"+patdob+" "+"诊断:"+diag;//bed code 
	            row=row+1;
	            xlsheet.Cells(row, 1).Value ="药品名称"
	            xlsheet.Cells(row, 2).Value ="产品名称"
	            xlsheet.Cells(row, 3).Value ="总量" 
	            xlsheet.Cells(row, 4).Value ="频次"
	            xlsheet.Cells(row, 5).Value ="剂量"
	           // xlsheet.Cells(row, 6).Value ="规格"
	            xlsheet.Cells(row, 6).Value ="用法"
	            xlsheet.Cells(row, 7).Value ="剂型"
	            xlsheet.Cells(row, 8).Value ="备注"
	            setBottomLine(xlsheet,row,1,8);
	        	//xlsheet.Cells(row, 1).Value =paregno;    
	            //xlsheet.Cells(row, 1).Value =bedcode;//bed code
	            //xlsheet.Cells(row, 2).Value =name; //patient name
	            //xlsheet.Cells(row, 3).Value =diag;
	            
	            //xlsheet.Cells(row, 4).Value =patdob; 
	            //xlsheet.Cells(row, 4).Value =orddate;
	            //mergcell(xlsheet,row,1,9)
	            //xlsheet.Cells(row, 1).Value =admloc+" "+"床号:"+bedcode+" "+"登记号:"+paregno+" "+"姓名:"+name+" "+"性别:"+sex+" "+"年龄:"+patdob+" "+"诊断:"+diag;//bed code
	            patTotal=patTotal+1;
	          	//cellEdgeRightLine(xlsheet,row,1,13)
	        }
	        else
	        {if (paregno!=tmpRegno)
	            {  
	                row=row+2 
	                mergcell(xlsheet,row,1,8)   
	                xlsheet.Cells(row, 1).Value =getDesc(WardName)+" "+"床号:"+bedcode+" "+"登记号:"+paregno+" "+"姓名:"+name+" "+"性别:"+sex+" "+"年龄:"+patdob+" "+"诊断:"+diag;//bed code
	                row=row+1;
		            xlsheet.Cells(row, 1).Value ="药品名称"
		            xlsheet.Cells(row, 2).Value ="产品名称"
		            xlsheet.Cells(row, 3).Value ="总量" 
		            xlsheet.Cells(row, 4).Value ="频次"
		            xlsheet.Cells(row, 5).Value ="剂量"
		            //xlsheet.Cells(row, 6).Value ="规格"
		            xlsheet.Cells(row, 6).Value ="用法"
		            xlsheet.Cells(row, 7).Value ="剂型"
		            xlsheet.Cells(row, 8).Value ="备注"
		            setBottomLine(xlsheet,row,1,8);
	            //xlsheet.Cells(row, 2).Value =name; //patient name
	            //xlsheet.Cells(row, 3).Value =diag;
	            
	            //xlsheet.Cells(row, 4).Value =patdob; 
	            //xlsheet.Cells(row, 4).Value =orddate; 
	            
	            patTotal=patTotal+1;
	            //cellEdgeRightLine(xlsheet,row,1,13)
	           // row++ 
	            }
	        }
	        row=row+1;
            //alert(row)
	        xlsheet.Cells(row, 1).Value =getDesc(generic); //orderitem description

			xlsheet.Cells(row, 2).Value =orditemdesc //spec;
		
			xlsheet.Cells(row, 3).Value =qty+uom ;
	
			xlsheet.Cells(row, 4).Value =freq;	
			
			xlsheet.Cells(row, 5).Value =dosqty ;	
			
			//xlsheet.Cells(row, 6).Value =spec ;
						
	        xlsheet.Cells(row, 6).Value =instruction;
	      
	        xlsheet.Cells(row, 7).Value =drugform;
	        
	        xlsheet.Cells(row, 8).Value =action; //医嘱备注
	        //xlsheet.Cells(row+1, 9).Value=sprice		//单价
	        //xlsheet.Cells(row, 14).Value=sumprice	//合计
	        
		    //cellEdgeRightLine(xlsheet,row,1,13)
	        //SetWarp(xlsheet,row,1,13)
	       // setBottomLine(xlsheet,row,4,9)
	        tmpRegno=paregno;
	    }
	       // setBottomLine(xlsheet,row+2,1,13)
    } //2007-04-17
	
    row+=1;
	//总计
	//xlsheet.Cells(1, 1).Value = gHospname
    xlsheet.Cells(2, 1).Value = getDesc(WardName)+DisTypeDesc+"药品明细清单"+reflag
    xlsheet.Cells(3, 1).Value = "单号:"+DispNo+"   "+"("+Priority+")"
    xlsheet.Cells(4, 1).Value = "配送地点:"+getDesc(WardName)+"     "+"审核医师:"+"     "+"摆药医师:"+"     "+t['PRINTDATE']+ formatDate2(getPrintDate())+" "+getPrintTime()+"    ("+gPhaCnt+")"
	/*
    xlsheet.Cells(row,1).value=t['SUM_PAT']+patTotal
    //xlsheet.Cells(row,2).value=patTotal;
    xlsheet.Cells(row,12).value="总金额:"
    xlsheet.Cells(row,13).value=sumamt.toFixed(2)
       
    row+=2;
    xlsheet.Cells(row,1).value=t['PRINT_USER']+session['LOGON.USERNAME']
    xlsheet.Cells(row,4).value=t['ADJ_USER']
    xlsheet.Cells(row,6).value=t['DISPEN_USER']
    xlsheet.Cells(row,11).value=t['REC_USER']+"             "+gPhaCnt
    */
    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);
    
                     }
             catch(e)
             {
	             alert(e.message);
             }
}


function PrintZCY(phac,phatype)
{    
	   // 中草药打印 for  北京中医院 ;   created by lq  ;2008/03/05
	   // 
	   // 
	var objRePrintFlag=document.getElementById("RePrintFlag");
    if (objRePrintFlag.value==1){
	     var docu=parent.frames['dhcpha.dispquery'].document;
	     var objDetailPrn=docu.getElementById("DetailPrn");
	     var objTotalPrn=docu.getElementById("TotalPrn");
	     if ((objDetailPrn.checked==false)&&(objTotalPrn.checked==false))
	     {   return;}
		       

	             }
      
	getDispDetail(phac);

    if (gDetailCnt>0)  
    {  

      var startrow=4
      var startcol=1
      var tmpsp=0 //同一处方总金额
      var tmpno="" //处方号
      var tmpid="" //关联医嘱号
      var startcol=1
      var buttonrow=0
      var nextrow=""    //下一处方开始行
      var zrow=0 //同一处inci行号
      var hz=1
      var onepage=16 //一页打多少行
      //var bt=""

      if (gPrnpath=="") 
      {
    	 alert(t["CANNOT_FIND_TEM"]) ;
         return ;                
      }
         
      var Template=gPrnpath+"STP_ZCYPrint_SZZY.xls";
      var xlApp = new ActiveXObject("Excel.Application");
      var xlBook = xlApp.Workbooks.Add(Template);
      var xlsheet = xlBook.ActiveSheet ;
      if (xlsheet==null) 
      {       
    	 alert(t["CANNOT_CREATE_PRNOBJ"]);
         return ;                
      } 
      
     //-------自定义纸张 lq 
     /*
        var paperset = new ActiveXObject("PaperSet.GetPrintInfo");
        var papersize=paperset.GetPaperInfo("stock");
        //alert(papersize);
        if (papersize!=0){
        xlsheet.PageSetup.PaperSize = papersize;}
        */
     //-------

      //setBottomLine(xlsheet,3,1,12);
	  for (var i=1;i<=gDetailCnt;i++)
	  {
	     var exeZCY;
	     var bt=""
	     var zj=0
         var obj=document.getElementById("mListDetailZCY")
 		 if (obj) exeZCY=obj.value;
    	 else exeZCY=""

         var result=cspRunServerMethod(exeZCY,gProcessID,i)
         if (result=="")
         {
	        alert("无法取得打印数据!请查看药品类别是否匹配");
            return;
         }
       
         var ss=result.split("^")
        
         var paname  =ss[1]
         var old     =ss[3]
         var pano    =ss[0]
         var admloc  =ss[6]
         var bed     =ss[5]
         var sdate   =ss[44]
         var xdate   =ss[45]
         //var Instruc =ss[37]  whf 080830
         var Instruc =ss[20]
   
         var inci    =ss[10]    
         var qty     =ss[13]//剂量
          //var uom     =ss[16] 
         var priority=ss[34]
         //var facotor =ss[38]
         var facotor =ss[42]
         var prescno =ss[7]
         var price   =ss[49]   //45
         var doctor  =ss[8]
         var relateid=ss[22]
         var orddate =ss[32]
         var ward    =ss[4]
         var notes   =ss[46]
         var priority=ss[36]
         var sattime =ss[45]  //44
         var oeqty   =ss[39]
         var fre     =ss[43]
         var diag    =ss[34]
         var remark  =ss[47]
         var pc      =ss[14] 
         var dj      =ss[17]
         var dmamt   =ss[18]
         var dex=Instruc.indexOf("外")
         if (dex>-1){var tmptype="@"}
         else{var tmptype=""}
         
         
         var dexgc=Instruc.indexOf("灌肠")
         if (dexgc>-1){var gc=1}
         else{var gc=0}
         
         
         var dexwy=Instruc.indexOf("外")
         if (dexwy>-1){var wy=1}
         else{var wy=0}
         
         
         
         var dexnj=Instruc.indexOf("浓煎")
         if (dexnj>-1){var nj=1}
         else{var nj=0}
         
          
         var ordcat  =ss[48]
         if ((ordcat=="266")||(ordcat=="267")||(ordcat=="277")||(ordcat=="278")||(ordcat=="289")||(ordcat=="291"))
         
         {qty=qty+"( ! )";
          bt="    (  毒麻  )"}
          
   
          
         if((ordcat=="268")||(ordcat=="279")||(ordcat=="290"))
         {
	       qty=qty+"( ! )";
           bt="    (  贵重  )"  
          }
   
         

         
         
         zrow=zrow+1
         
         if ((tmpno==prescno)&&(i>1)&&(tmpid==relateid))
         {
	        startcol=startcol+3 
	        startrow=tmpfalg-2 //同一处方不换行
	        
	        if (zrow%4==0)  //每四个药换行
	        {
		        startcol=1
		        startrow=startrow+1   
		    } 
	      }

	      if ((tmpno!=prescno)&&(tmpid!=relateid)&&(i!=1))
          {
	        startrow=nextrow //构造下一个处方开始行
	        startcol=1
	        hz=hz+1
	      
	      }
	      
		  if ((tmpno!=prescno)&&(tmpid!=relateid))
		  {
			zrow=0
			if (gc==1){bt=bt+" "+"(  灌肠  )"}
            if (wy==1){bt=bt+" "+"(  外用  )"}
            if (nj==1){bt=bt+" "+"(  浓煎  )"}

            setBottomLine(xlsheet,startrow-1,1,12);
 
            xlsheet.Cells(startrow-3, 5).Value="华西医院中药处方"+bt
            xlsheet.Cells(startrow-2, 1).Value="科室:"+admloc+" "+"病区:"+getDesc(ward)+" "+"登记号:"+pano+" "+"床号:"+bed+" "+"姓名:"+paname+" "+"年龄:"+old
	        xlsheet.Cells(startrow-1, 1).Value="医生:"+doctor+"  "+"诊断:"+diag+"  "+"备注:"+notes
	        //xlsheet.Cells(startrow-1, 9).Value="医嘱时间:"
	        //xlsheet.Cells(startrow-1, 10).Value=orddate+" "+sattime
	        xlsheet.Cells(startrow, 1).Value = "总剂数:"+facotor 
	        setBottomLine(xlsheet,startrow+1,1,12);
	        //xlsheet.Cells(startrow, 2).Value = paname
	        xlsheet.Cells(startrow, 3).Value = "日剂数:"+pc 
            //xlsheet.Cells(startrow, 4).Value = pano
            xlsheet.Cells(startrow, 8).Value = "方式:"+remark
            //xlsheet.Cells(startrow, 6).Value = remark
            xlsheet.Cells(startrow, 6).Value = "一次用量:" +fre
            //xlsheet.Cells(startrow, 8).Value = fre
            xlsheet.Cells(startrow, 10).Value="用法:"+Instruc
            //xlsheet.Cells(startrow, 11).Value=Instruc
            xlsheet.Cells(startrow,1).Borders(7).LineStyle = 1
            xlsheet.Cells(startrow,12).Borders(10).LineStyle = 1
            xlsheet.Cells(startrow+1, 1).Value= "处方类型:"+tmptype
	        //xlsheet.Cells(startrow+1, 2).Value= ""
	        xlsheet.Cells(startrow+1, 3).Value= "开方时间:"+orddate+"  "+"时间:" +sdate+"  "+"至"+"  "+xdate
	        //xlsheet.Cells(startrow+1, 5).Value="时间" +sdate+"至"+xdate
	        //xlsheet.Cells(startrow+1, 7).Value="备注:"
	   
	        //xlsheet.Cells(startrow+1, 9).Value= "截止:"
	        //xlsheet.Cells(startrow+1, 10).Value=xdate
	        }
            xlsheet.Cells(startrow+1,1).Borders(7).LineStyle = 1
            xlsheet.Cells(startrow+1,12).Borders(10).LineStyle = 1

            xlsheet.Cells(startrow+2, startcol).Value= inci+" "+qty
            //xlsheet.Cells(startrow+2, startcol+2).Value=qty
            xlsheet.Cells(startrow+2,1).Borders(7).LineStyle = 1
            xlsheet.Cells(startrow+2,12).Borders(10).LineStyle = 1
            
            var tmpfalg=startrow+2 //同一处方药品开始行号
            if((tmpno!=prescno)&&(tmpid!=relateid))
            {
	           setBottomLine(xlsheet,startrow+10,1,12);
	            
	           xlsheet.Cells(startrow+3,1).Borders(7).LineStyle = 1
	           xlsheet.Cells(startrow+3,12).Borders(10).LineStyle = 1
	           xlsheet.Cells(startrow+4,1).Borders(7).LineStyle = 1
	           xlsheet.Cells(startrow+4,12).Borders(10).LineStyle = 1
	           xlsheet.Cells(startrow+5,1).Borders(7).LineStyle = 1
	           xlsheet.Cells(startrow+5,12).Borders(10).LineStyle = 1
	           xlsheet.Cells(startrow+6,1).Borders(7).LineStyle = 1
	           xlsheet.Cells(startrow+6,12).Borders(10).LineStyle = 1
	           xlsheet.Cells(startrow+7,1).Borders(7).LineStyle = 1
	           xlsheet.Cells(startrow+7,12).Borders(10).LineStyle = 1
	           xlsheet.Cells(startrow+8,1).Borders(7).LineStyle = 1
	           xlsheet.Cells(startrow+8,12).Borders(10).LineStyle = 1
	           xlsheet.Cells(startrow+9,1).Borders(7).LineStyle = 1
	           xlsheet.Cells(startrow+9,12).Borders(10).LineStyle = 1
               //xlsheet.Cells(startrow+10, 1).Value= "处方说明:"
	           //xlsheet.Cells(startrow+10, 2).Value= Instruc 
	           //xlsheet.Cells(startrow+10, 10).Value= "剂数:" 
	           //xlsheet.Cells(startrow+10, 12).Value= facotor 
	           xlsheet.Cells(startrow+10,1).Borders(7).LineStyle = 1
	           xlsheet.Cells(startrow+10,12).Borders(10).LineStyle = 1

	           xlsheet.Cells(startrow+11, 1).Value="单付合计:"
	           xlsheet.Cells(startrow+11, 2).Value= price  
	           xlsheet.Cells(startrow+11, 7).Value="总金额:" 
	           xlsheet.Cells(startrow+11, 8).Value= (price*parseFloat(facotor)).toFixed(2)
	           //xlsheet.Cells(startrow+11, 10).Value="医生:"    
	           //xlsheet.Cells(startrow+11, 12).Value=doctor
	           xlsheet.Cells(startrow+11,1).Borders(7).LineStyle = 1
	           xlsheet.Cells(startrow+11,12).Borders(10).LineStyle = 1
	           setBottomLine(xlsheet,startrow+11,1,12);
	           xlsheet.Cells(startrow+12, 1).Value="操作人:"  
	           xlsheet.Cells(startrow+12, 2).Value=session['LOGON.USERNAME']
	           xlsheet.Cells(startrow+12, 4).Value="调剂:"
	           xlsheet.Cells(startrow+12, 6).Value="复核:"
	           xlsheet.Cells(startrow+12, 8).Value="打印时间:"+getPrintDateTime()
  	           //setBottomLine(xlsheet,startrow+13,1,12);
	           //xlsheet.Cells(startrow+14, 1).Value="科室:"+admloc+"  "+"姓名:"+paname+"  "+"床号:"+bed+"  "+"单付价:"+price+"  "+"剂数:"+facotor+"  "+"总金额:"+(price*parseFloat(facotor)).toFixed(2)
   	           var tmpno=prescno
               var tmpid=relateid
          
	           //var startrow=startrow+17
	        
	          
	           var dexzj=remark.indexOf("自")
	           if (dexzj<0){var zj=1}
	           
               var startrow=hz*onepage+1

	           if (zj!=0)
	           {
	              var startcol1=1
	              var h=0 //开始打标签
	              hz=hz+1
	              //alert(startrow)

	              //for (var n=1;n<=parseInt(facotor)*2;n++)
	              //{
	                // setBottomLine(xlsheet,startrow-1,1,12)

	                 xlsheet.Cells(startrow, startcol1+2).Value = "深圳市中医院"
	                 xlsheet.Cells(startrow+1, startcol1+2).Value = "煎药服药证"
	                 setBottomLine(xlsheet,startrow+1,1,6)
	                 xlsheet.Cells(startrow+2, startcol1).Value ="备注:"+notes
	                 xlsheet.Cells(startrow+2, startcol1+3).Value ="用法:"+Instruc
	                 xlsheet.Cells(startrow+3, startcol1).Value ="服药时间:"+sdate+"至"+xdate
	                 xlsheet.Cells(startrow+4, startcol1).Value ="总剂数:"+facotor 
	                 xlsheet.Cells(startrow+4, startcol1+3).Value ="日剂数:"+pc
	                 xlsheet.Cells(startrow+5, startcol1).Value ="方式:"+remark
	                 setBottomLine(xlsheet,startrow+5,1,6)
	                 xlsheet.Cells(startrow+6, startcol1).Value = "登记号:"+" "+pano
	                 xlsheet.Cells(startrow+6, startcol1+3).Value ="病案号:"+" "+pano
	                 xlsheet.Cells(startrow+7, startcol1).Value = "姓名:"+" "+paname
	                 xlsheet.Cells(startrow+7, startcol1+3).Value = "床号:"+" "+bed
	                 xlsheet.Cells(startrow+8, startcol1).Value = "科室:"+admloc
                     xlsheet.Cells(startrow+8, startcol1+3).Value = "病区:"+getDesc(ward)
                     xlsheet.Cells(startrow+9, startcol1).Value = "配剂:"+"        "+"煎药:"                     
                     xlsheet.Cells(startrow+9, startcol1+3).Value =getPrintDateTime()
                     
          		     //if ((n%2==1)&&(n!=1)) {h=h+1}
          		     /*
                     if ((n%2==0)&&(n!=1)) {h=h+1}

		     	     startcol1=startcol1+3
        		     buttonrow=startrow+8
        		     
        		     if (n%4==0)
        		     {		 
		                startrow=buttonrow+2
		                startcol1=1
		             }
                 */
	             // }

	              var startrow=startrow+13
	              var nextrow=startrow+3
	              //alert(hz*32+1)
	              
	               nextrow= hz*onepage+4 //带标签一页32 行
               }
              
               if (zj==0){//var nextrow=startrow+4
               nextrow=hz*onepage+4} //一页17行
            }
	    }

      xlsheet.printout();
      SetNothing(xlApp,xlBook,xlsheet); 
    }
     
}
function PrintZCYTIAOMA(phac,phatype)
{  
    var tmpno="" //处方号
    var tmpid="" //关联医嘱号


    
    try {
	   
	var objRePrintFlag=document.getElementById("RePrintFlag");
    if (objRePrintFlag.value==1){
	     var docu=parent.frames['dhcpha.dispquery'].document;
	     var objPrnLab=docu.getElementById("PrnLab");
	     
	    if (objPrnLab.checked==false){
		     return;}
	   }
    

    getDispDetail(phac);
 
    if (gDetailCnt==0)  {return;}

    for (var i=1;i<=gDetailCnt;i++)
	  {

	     var exeZCY;
         var obj=document.getElementById("mListDetailZCY")
 		 if (obj) exeZCY=obj.value;
    	 else exeZCY=""

         var result=cspRunServerMethod(exeZCY,gProcessID,i)
         if (result=="")
         {
	        alert("无法取得打印数据!请查看药品类别是否匹配"+phatype);
            return;
         }

         var ss=result.split("^")
         var pano  =ss[0]
         var paname  =ss[1]
         var bed     =ss[5]
         var ward    =ss[4]
         var facotor =ss[38]
         var fre     =ss[43]
         var prescno =ss[7]
         var relateid=ss[22]
         
         var str=pano+"^"+paname+"^"+bed+"^"+ward+"^"+facotor+"^"+fre+"^"+prescno
      //alert(tmpno) 
       // alert(prescno) 
 //alert(tmpid)
  //alert(relateid)

     if ((tmpno!=prescno)&&(tmpid!=relateid))
     {
	      Bar=new ActiveXObject("DHCSTZCYPrint.DHCSTPrnZCY");
	     //var Bar=new ActiveXObject("PrintBar.PrnBar");
	     
	     if (!Bar) return false;
	     
	     Bar.Device="YFTIAOMA";
	      Bar.PageItmStr=str;
	     /*
	     Bar.Title="深圳中医院煎药证"
	     //Bar.Device="pdfFactory Pro";
	     Bar.Device="TIAOMA";
	     Bar.PageWidth=15;
	     Bar.HeadFontSize=12;
	     Bar.BarFontSize=20;
	     Bar.BarLeftMarg=0;
	     Bar.PageLeftMargine=0;
	     Bar.PageItmStr=str;
	     Bar.PageItmStr="服药证" + "^" + "共7剂" + "^" + "250ml" + "^" + "00005678" + "^" + "张三" + "^" + "3床" + "^" + "肝病二护士站"

	     Bar.PrintDPage();
	        
	     */ 
	     ///alert("")
	     Bar.PrintDPage();
	     //Bar.PrintOut("1"); 
     }
         var tmpno=prescno
         var tmpid=relateid         



	     }
	
}
	             catch(e)
             {
	             alert(e.message);
             }
    
    
}

function PrintMXHZ(phac,phatype)
{
    //既打明细又打汇总?2007-8-6
    
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
    var docloc=tmparr[13] ;

    var tmpRegno="";
    var patTotal=0;		//总计人数
                       
    getDispDetail(phac)

    if (gPrnpath=="") 
    {
    	alert(t["CANNOT_FIND_TEM"]) ;
        return ;                
    }
    var Template=gPrnpath+"STP_HZMX_HX.xls";
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
    
    xlsheet.Cells(1, 1).Value = gHospname
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
    
    if (gDetailCnt>0)  //2007-04-17
     {    
	    for (var i=1;i<=gDetailCnt;i++)
	    {           
	        var ss=cspRunServerMethod(exeDetail,gProcessID,i)   
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
	        var spec=datas[26];
	        var eatdrugtime=datas[27] 
	        var amt=datas[18];
	        var orddate=datas[29];
	        var ordsttdate=datas[30];
	        var priority=datas[33];
	        var drugform=datas[34];	        
	        var doctor=datas[8];
	        
	        if ((tmpRegno!="")&&(paregno!=tmpRegno) )
	         {//setBottomDblLine(xlsheet,row,1,13); 
		      	setBottomLine(xlsheet,row,1,12);
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
	          	cellEdgeRightLine(xlsheet,row,1,12)
	        }
	        else
	        {if (paregno!=tmpRegno)
	            {   //row=row+1;
	            xlsheet.Cells(row, 1).Value =paregno;
	            xlsheet.Cells(row, 2).Value =bedcode;//bed code
	            xlsheet.Cells(row, 3).Value =name; //patient name
	            
	            xlsheet.Cells(row, 4).Value =patdob;  
	            
	            patTotal=patTotal+1;
	            cellEdgeRightLine(xlsheet,row,1,12)
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
	        
		    cellEdgeRightLine(xlsheet,row,1,12)
	      
	       // setBottomLine(xlsheet,row,4,9)
	        tmpRegno=paregno;
	    }
	        setBottomLine(xlsheet,row,1,12)
    } //2007-04-17
	
    row+=1;
	//总计
    xlsheet.Cells(row,1).value=t['SUM_PAT']
    xlsheet.Cells(row,2).value=patTotal;
       
    row+=2;
    xlsheet.Cells(row,1).value=t['PRINT_USER']+session['LOGON.USERNAME']
    xlsheet.Cells(row,3).value=t['ADJ_USER']
    xlsheet.Cells(row,5).value=t['DISPEN_USER']
    xlsheet.Cells(row,8).value=t['REC_USER']
    
    //打印汇总
  	var startNo=row+2 ;
	var i ;
    
    getDispHZ(phac);
        
    if (gTotalCnt>0) 
    {
		xlsheet.Cells(1, 1).Value = gHospname  //+ getDesc(PhaLoc)+DisTypeDesc+t['DISP_BILL'];  //hospital description
	    xlsheet.Cells(2, 1).Value = t['DISP_BILL']
	    xlsheet.Cells(3, 1).Value = t['PHARMACY']+ getDesc(PhaLoc) +"        "+t['DISP_NO'] +DispNo +"       "+t['DISPDATE']+DateRange
	    xlsheet.Cells(4, 1).Value = t['DISPCAT'] + DisTypeDesc + "         " + t['PRINTDATE']+ formatDate2(getPrintDate())+" "+getPrintTime()+"         "+t['WARD']+getDesc(WardName)
	    //xlsheet.Cells(4, 4).Value =t['WARD']+getDesc(WardName)
	       
	    if(WardName=="0")
	    {
			xlsheet.Cells(4, 4).Value =t['DOCLOC']+getDesc(docloc);
		}
	       
	    var incicode="",incidesc,uom,sp,manf,qty,amt,sumamt,drugform,resqty;
	    var stkbin,barcode,datas,exe;
		var serialNo=0
            
        var obj=document.getElementById("mListDispTotal")
        if (obj) exe=obj.value;
        else  exe="" ;
           
        do 
        {
	    	datas=cspRunServerMethod(exe,incicode,gProcessID);
	        if (datas!="")
            {
            	var ss=datas.split("^");
                incicode=ss[0];
                var tmpincidesc=ss[1].split("(")
                incidesc=tmpincidesc[0];
                var tmpuom=ss[3].split("(")
                uom=tmpuom[0];
                sp=ss[2];
                var tmpmanf=ss[7].split("-")
                manf=tmpmanf[1];
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
    alert(xlApp+xlBook+xlsheet);
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
function setRightLine(objSheet,row,startcol,colnum)
{
    objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).Borders(7).LineStyle=1 ;
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
    if (gProcessID!="") 
    {
	    var exe;
	    var obj=document.getElementById("mKillTmp") ;
	    if (obj) exe=obj.value;
	    else exe=""
	    
	    var result=cspRunServerMethod(exe,gProcessID)
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
        gTotalCnt=ss[0];
        gProcessID=ss[1]  ; //
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
    gDetailCnt=ss[0];
    gProcessID=ss[1] ;
    gDetailCntPack=ss[2]
    
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

    if (gDetailCnt<1) return ;

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
    
    xlsheet.Cells(2, 1).Value = gHospname
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
    for (var i=1;i<=gDetailCnt;i++)
    {           
        var ss=cspRunServerMethod(exeDetail,gProcessID,i)   
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


function CellMerge(objSheet,r1,r2,c1,c2)		
{
	var range= objSheet.Range(objSheet.Cells(r1, c1),objSheet.Cells(r2,c2))
	range.MergeCells ="True"
}

function SetWarp(objSheet,row,c1,c2)
{
	//自动换行设置  lq
	for (var i=c1;i<=c2;i++)
	{
	  objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).WrapText  =  true//自动换行
	}
}
function ExcelSet(objSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter)
{
    var titleRowsStr, titleColsStr
    if ((titleRows > 0)&&( titleRows < 6)) {titleRowsStr="$1:$"+titleRows}
    else { titleRowsStr = ""}
    titleColsStr = "";
    if (titleCols==1) titleColsStr = "$A:$A"    //'maxcols is 5
    if (titleCols==2) titleColsStr = "$A:$B"
    if (titleCols==3) titleColsStr = "$A:$C"
    if (titleCols==4) titleColsStr = "$A:$D"
    if (titleCols==5) titleColsStr = "$A:$E"
   
    objSheet.PageSetup.PrintTitleRows = titleRowsStr
    objSheet.PageSetup.PrintTitleColumns = titleColsStr
        
    objSheet.PageSetup.PrintArea = ""
    objSheet.PageSetup.LeftHeader = LeftHeader
    objSheet.PageSetup.CenterHeader = CenterHeader
    objSheet.PageSetup.RightHeader = RightHeader
    objSheet.PageSetup.LeftFooter = LeftFooter
    objSheet.PageSetup.CenterFooter = CenterFooter
    objSheet.PageSetup.RightFooter = RightFooter
}


document.body.onload=BodyLoadHandler;