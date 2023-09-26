/// dhcpha.dispprintBJFC.js
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
var arrayPage = new Array();
var conflag=0 //续打标志 
var cntPerPage=10  //每页打印记录条数   
function BodyLoadHandler()
{		
	var phac;
    
	var obj=document.getElementById("Phac") ;
	if (obj) phac=obj.value ;
	
	//GetPageCount(phac);
	
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
	     
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispprintBJFC"
	document.location.href=lnk;
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

	//PrtDSYHzHXY();///发送全院大输液 for 华西 一院
	
	var i;
	var phaType;
	
	if(phacStr!="")
	{  
	
		phacArr=phacStr.split("A");
		
	}
	var objRePrintFlag=document.getElementById("RePrintFlag");
	
	/*
	if(objRePrintFlag){
		if (objRePrintFlag.value==1){	    
		    var ret=confirm("是否续打?");
		    if (ret==true){
			conflag=1;
		    }
		}
	}
	*/
	
	for(i=0;i<phacArr.length;i++)
	{
		phac=phacArr[i].split("B");
		phaType=GetDispType(phac[0]);
		//phaType=GetDispType(phacArr[i]);
		//alert(phaType)
		//GetPageCount(phacArr[i]);  zdm,2012-03-26,导致多余临时global
		//Prnt(phacArr[i],phaType,conflag);
		Prnt(phac[0],phaType,conflag);
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
	
function Prnt(phac,phatype,conflag)
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
    
    getDispHZ(phac);
    KillTmp();
    PagCnt=Math.ceil(gTotalCnt/cntPerPage);   //每张发药单的打印页数
    //打印方式
    var objTotalPrn=document.getElementById("TotalPrn");    //汇总
    var objDetailPrn=document.getElementById("DetailPrn") ; //明细
    
    //默认设置
    var configStr=GetPrtTypeConfig(phatype).split("^")
    var conDetail=configStr[1]  //汇总
    var conTotal=configStr[2]   //明细
    var conOther=configStr[3]   //其它
    var conReserve=configStr[8]   //是否冲抵
    
    if ((conDetail==0)&&(conTotal==0)&&(conOther=="")) 
    {alert("药品类别"+phatype+"设置不匹配,请核实!")} 
  
    if((objTotalPrn.value==0)&&(objDetailPrn.value==0))
    {  
              
            
	        if (conOther!="") 
	        {  
		        switch (phatype) 
		     	    {
		              case "KFY":
		                   PrintPJQZ(phac,phatype) ; 
		                   break;
		                   
		              case "JDMK":
		                   PrintPJDMY(phac,phatype) ;
		                   break;
		                   
		              case "JSMK":
		                   PrintPJDMY(phac,phatype) ;
		                   break;
		                     
		              case "ZCY":
		                   PrintZCY(phac,phatype) ;
		                   break;      
		             }
		     }
    
	          else
	          {
		          if(conflag==0){
			          
	                  //if (conTotal==1) {PrintHzRet(phac,phatype) ;}
	                 
	                  if (conTotal==1) {

		                  if (conReserve==1)
		                  {
			                 //PrintHzRet(phac,phatype) ; 
			                 PrintHzRetBed(phac,phatype)
		                  }
		                  else
		                  {
			                  PrintHz(phac,phatype) ;
		                  }
		                  
		                 
		              }
			          //if (conDetail==1){PrintKFYLabel(phac,phatype) ;} 
			          if (conDetail==1){PrintPJHNZL(phac,phatype) ;}
		          }
		          else{
			          page=continuePrintDialog(PagCnt)
			          if (page=="") return;
			          if (conTotal==1) {PrintConHz(phac,phatype,page) ;}   //选择页码续打
			          if (conDetail==1){PrintConPJ(phac,phatype,page);}
			      }
	          }
    

		    
    }
    
    if(objTotalPrn.value==1)
    {
	    if (conOther=="")    
	    {
		    
		    if(conflag==0)
		    {
			    if (conReserve==1)
				{
					PrintHzRetBed(phac,phatype) ; 
				}
				else
		        {
			    	PrintHz(phac,phatype) ;
		        }
			}
            else
            {
            page=continuePrintDialog(PagCnt)
            	if (page=="") return;
            PrintConHz(phac,phatype,page) ;
            }
	    }
    }
    if(objDetailPrn.value==1)
    {
	    if (conOther=="")
	    {
		    if(conflag==0){
	        PrintPJHNZL(phac,phatype) ;
		    }
		    else
		    {
			    page=continuePrintDialog(PagCnt)
			    if (page=="") return;
			    PrintConPJ(phac,phatype,page);
			}
	    }
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
			    var bed=tmpstr[4]
			    var name=tmpstr[5]
			    var incidesc=tmpstr[3]
			    var qty=tmpstr[6]
			    var orddate=tmpstr[7]
			    var oedis=tmpstr[8]
			    i=i+1
			    xlsheet.Cells(Startrow+i, 1).Value = ward 
			    xlsheet.Cells(Startrow+i, 2).Value = bed 
			    xlsheet.Cells(Startrow+i, 3).Value = name
			    xlsheet.Cells(Startrow+i, 4).Value = incidesc
			    xlsheet.Cells(Startrow+i, 5).Value = qty
	            xlsheet.Cells(Startrow+i, 6).Value = orddate
	            rowid=rowid+"^"+oedis
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
        //打印汇总单
  
  try{
	  
	   
	    gPhaCnt=gPhaCnt+1
	    var PagNum=1;
        //var objTotalPrn=document.getElementById("TotalPrn");
        //var objDetailPrn=document.getElementById("DetailPrn") ;
        //if ((objTotalPrn.value==0)&&(objDetailPrn.value!=0)){return;}

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
        //var Priority=tmparr[13] ;
        var Priority=tmparr[12] ;
       
        var DateRange=formatDate2(dispsd)+"--"+formatDate2(disped);
        var DispNo=tmparr[9] ;
        var DisTypeDesc=tmparr[10] ;
        //var docloc=tmparr[13] ;
        var docloc="";
        if (gPrnpath=="") 
        {
        	alert(t["CANNOT_FIND_TEM"]) ;
            return ;
       	}
                
        var Template=gPrnpath+"STP_HZ_BJFC.xls";
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
        //PagCnt=Math.ceil(gTotalCnt/10);
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
	        var note="";
            
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
                        
                        inci=ss[6];
                        note=ss[14];
                        if(note!=""){note="("+note+")"}
                        facqty=qty-resqty;
                        var objqty=document.getElementById("mgetPackQty")
	                    if (objqty) exeqty=objqty.value; else  exeqty="" ;
	                    //alert(exeqty);
	                    qtystr=cspRunServerMethod(exeqty,inci,qty,resqty,facqty);
	                    var tmpqtystr=qtystr.split("||")
                        //qty= tmpqtystr[0];
	                    //resqty=tmpqtystr[1];
	                    //facqty=tmpqtystr[2];	

                        serialNo++;
                        
                        
                        //xlsheet.Cells(startNo+serialNo, 1).Value =getDesc(generic);
                        xlsheet.Cells(startNo+serialNo, 1).Value =incidesc+note;
                        //xlsheet.Cells(startNo+serialNo, 2).Value =qty+" "+uom ;  
                        xlsheet.Cells(startNo+serialNo, 2).Value =qty;    
                        xlsheet.Cells(startNo+serialNo, 3).Value =drugform;
                        //xlsheet.Cells(startNo+serialNo, 5).Value =barcode; 
                        xlsheet.Cells(startNo+serialNo, 4).Value = sp;  
                        xlsheet.Cells(startNo+serialNo, 5).Value = amt;
                        //xlsheet.Cells(startNo+serialNo, 6).Value =note;
                        //xlsheet.Cells(startNo+serialNo, 8).Value =manf;       
                        //xlsheet.Cells(startNo+serialNo, 9).Value =stkbin;
                        setBottomLine(xlsheet,startNo+serialNo,1,5);
                        //cellEdgeRightLine(xlsheet,startNo+serialNo,1,9)
                    }
                else 
                {incicode=""}
            } while (incicode!="")
        }
    //总计
      //xlsheet.Cells(1, 1).Value = gHospname 
      xlsheet.Cells(2, 1).Value =gHospname+""+"药品汇总清单"+reflag
	  //xlsheet.Cells(2, 1).Value = t['DISP_BILL']
	  var PrioStr="";
	  if (Priority!=""){PrioStr="("+Priority+")"}
	  xlsheet.Cells(3, 1).Value ="单号:"+DispNo+"   "+PrioStr+"    药房:"+PhaLoc+"    类别:"+DisTypeDesc
	  //xlsheet.Cells(3, 1).Value ="("+Priority+")" +"  "+ t['DISPDATE']+DateRange+reflag
	  xlsheet.Cells(4, 1).Value ="病房:"+getDesc(WardName)+"   "+"发药人:"+"        "+"领药人:"+"         "+t['PRINTDATE']+ formatDate2(getPrintDate())+" "+getPrintTime();	//+" ("+gPhaCnt+")"
    
    //var row=startNo+serialNo+1;
    xlsheet.Cells(startNo+serialNo+1,1).value=t['SUM_AMT'];
    xlsheet.Cells(startNo+serialNo+1,5).value=sumamt;
     /*   
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
             
   KillTmp();
}
 
function PrintConHz(phac,phatype,page)
{    
        //retrieving primary dispensing infomation...
        //续打汇总单
  var pageArray=page.split("-");
  var frompage=pageArray[0];
  frompage=(frompage-1)*cntPerPage+1;
  
  var topage=pageArray[1];  
  topage=topage*cntPerPage+1;
  //alert(frompage);
  //alert(topage);
  try{
	    gPhaCnt=gPhaCnt+1
	    var PagNum=1;
        //var objTotalPrn=document.getElementById("TotalPrn");
        //var objDetailPrn=document.getElementById("DetailPrn") ;
        //if ((objTotalPrn.value==0)&&(objDetailPrn.value!=0)){return;}

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
        //var Priority=tmparr[13] ;
        var Priority=tmparr[12];
       
        var DateRange=formatDate2(dispsd)+"--"+formatDate2(disped);
        var DispNo=tmparr[9] ;
        var DisTypeDesc=tmparr[10] ;
        //var docloc=tmparr[13] ;
	var docloc=""
        if (gPrnpath=="") 
        {
        	alert(t["CANNOT_FIND_TEM"]) ;
            return ;
       	}
                
        var Template=gPrnpath+"STP_HZ_BJFC.xls";
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
        //PagCnt=Math.ceil(gTotalCnt/10);
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
	        
            var obj=document.getElementById("mListDispTotalByPage")
            if (obj) exe=obj.value;
            else  exe="" ;
            incicode=cspRunServerMethod(exe,incicode,gProcessID,frompage);
            //alert(incicode);
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
                        
                        inci=ss[6];
                        facqty=qty-resqty;
                        var objqty=document.getElementById("mgetPackQty")
	                    if (objqty) exeqty=objqty.value; else  exeqty="" ;
	                    //alert(exeqty);
	                    qtystr=cspRunServerMethod(exeqty,inci,qty,resqty,facqty);
	                    var tmpqtystr=qtystr.split("||")
                        //qty= tmpqtystr[0];
	                    //resqty=tmpqtystr[1];
	                    //facqty=tmpqtystr[2];	

                        serialNo++;
                        
                        
                        //xlsheet.Cells(startNo+serialNo, 1).Value =getDesc(generic);
                        xlsheet.Cells(startNo+serialNo, 1).Value =incidesc;
                        //xlsheet.Cells(startNo+serialNo, 2).Value =qty+" "+uom ;  
                        xlsheet.Cells(startNo+serialNo, 2).Value =qty;  
                        //xlsheet.Cells(startNo+serialNo, 2).Value =qty;    
                        xlsheet.Cells(startNo+serialNo, 3).Value =serialNo;
                        //xlsheet.Cells(startNo+serialNo, 5).Value =barcode; 
                        xlsheet.Cells(startNo+serialNo, 4).Value = sp;  
                        xlsheet.Cells(startNo+serialNo, 5).Value = amt;
                        //xlsheet.Cells(startNo+serialNo, 8).Value =manf;       
                        //xlsheet.Cells(startNo+serialNo, 9).Value =stkbin;
                        //setBottomLine(xlsheet,startNo+serialNo,1,9);
                        //cellEdgeRightLine(xlsheet,startNo+serialNo,1,9)
                    }
                else 
                {incicode=""}
            } while ((incicode!="")&&(serialNo<topage-frompage))
        }
    //总计
      //xlsheet.Cells(1, 1).Value = gHospname 
     	xlsheet.Cells(2, 1).Value =gHospname+""+"药品汇总清单"+reflag
	  //xlsheet.Cells(2, 1).Value = t['DISP_BILL']
	  var PrioStr="";
	  if (Priority!=""){PrioStr="("+Priority+")"}
	  xlsheet.Cells(3, 1).Value ="单号:"+DispNo+"   "+PrioStr+"    药房:"+PhaLoc+"    类别:"+DisTypeDesc
	  //xlsheet.Cells(3, 1).Value ="("+Priority+")" +"  "+ t['DISPDATE']+DateRange+reflag
	  xlsheet.Cells(4, 1).Value ="病房:"+getDesc(WardName)+"发药人:"+"        "+"领药人:"+"         "+t['PRINTDATE']+ formatDate2(getPrintDate())+" "+getPrintTime()+" ("+gPhaCnt+")"
    
    //var row=startNo+serialNo+1;
    xlsheet.Cells(startNo+serialNo+1,1).value=t['SUM_AMT']
    xlsheet.Cells(startNo+serialNo+1,5).value=sumamt
     /*   
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
             
             KillTmp();
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
             
     KillTmp();
}       

function PrintPJNoPackAndPack(phac,phatype)
{
	///片剂整包装和散包装分开打印
	///先打散包装再打整包装
	
 try{	
	gPhaCnt=gPhaCnt+1

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
    var Template=gPrnpath+"STP_MX_BJFC.xls";
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
	           	mergcell(xlsheet,row,1,7)
	            xlsheet.Cells(row, 1).Value =getDesc(WardName)+" "+"床号:"+bedcode+" "+"登记号:"+paregno+" "+"姓名:"+name+" "+"性别:"+sex+" "+"年龄:"+patdob+" "+"诊断:"+diag;//bed code 
	            row=row+1;
	            xlsheet.Cells(row, 1).Value ="药品名称"
	            //xlsheet.Cells(row, 2).Value ="产品名称"
	            xlsheet.Cells(row, 2).Value ="总量" 
	            xlsheet.Cells(row, 3).Value ="频次"
	            xlsheet.Cells(row, 4).Value ="剂量"
	           // xlsheet.Cells(row, 6).Value ="规格"
	            xlsheet.Cells(row, 5).Value ="用法"
	            xlsheet.Cells(row, 6).Value ="剂型"
	            xlsheet.Cells(row, 7).Value ="备注"
	            setBottomLine(xlsheet,row,1,7);
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
	                mergcell(xlsheet,row,1,7)   
	                xlsheet.Cells(row, 1).Value =getDesc(WardName)+" "+"床号:"+bedcode+" "+"登记号:"+paregno+" "+"姓名:"+name+" "+"性别:"+sex+" "+"年龄:"+patdob+" "+"诊断:"+diag;//bed code
	                row=row+1;
		            xlsheet.Cells(row, 1).Value ="药品名称"
		            //xlsheet.Cells(row, 2).Value ="产品名称"
		            xlsheet.Cells(row, 2).Value ="总量" 
		            xlsheet.Cells(row, 3).Value ="频次"
		            xlsheet.Cells(row, 4).Value ="剂量"
		            //xlsheet.Cells(row, 6).Value ="规格"
		            xlsheet.Cells(row, 5).Value ="用法"
		            xlsheet.Cells(row, 6).Value ="剂型"
		            xlsheet.Cells(row, 7).Value ="备注"
		            setBottomLine(xlsheet,row,1,7);
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
	        //xlsheet.Cells(row, 1).Value =getDesc(generic); //orderitem description

			xlsheet.Cells(row, 1).Value =orditemdesc //spec;
		
			xlsheet.Cells(row, 2).Value =qty+uom ;
	
			xlsheet.Cells(row, 3).Value =freq;	
			
			xlsheet.Cells(row, 4).Value =dosqty ;	
			
			//xlsheet.Cells(row, 6).Value =spec ;
						
	        xlsheet.Cells(row, 5).Value =instruction;
	      
	        xlsheet.Cells(row, 6).Value =drugform;
	        
	        xlsheet.Cells(row, 7).Value =action; //医嘱备注
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
    xlsheet.Cells(4, 1).Value = "配送地点:"+getDesc(WardName)+"      "+"领药人:"+"      "+"摆药药师:"+"     "+t['PRINTDATE']+ formatDate2(getPrintDate())+" "+getPrintTime()+"    ("+gPhaCnt+")"

    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);
    
    
    PrintPJPACK(gProcessID,tmps)
    

   }
             catch(e)
             {
	             alert(e.message);
             }
             
     KillTmp();
}
function PrintPJNOPACK(gProcessID,tmps,exeDetail)
{
	        //打印散包装
	        //
	        var startNo=1 ;
		    var row ;
		    PagNum=+1;
		    row=startNo;
	        var tmpRegno="";
	        var tmpDate="";
	        var admloc;
            var col=1;
            var rowflag=0;  //换行标志,换行次数
            var cardnum=1;  //卡片打印个数
            var reflag="";  //补打标记
            var rowcountflag=0; //一个卡片每10条记录换卡片
			var objRePrintFlag=document.getElementById("RePrintFlag");
		    if (objRePrintFlag.value==1){var reflag="(补)"}
            
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
	        
	        var Template=gPrnpath+"STP_PJ_QZ.xls";
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
		
		    if (xlsheet==null) 
		    {       
		    	alert(t["CANNOT_CREATE_PRNOBJ"]);
		        return ;                
		    }
     
     
      
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
	        //var orditemdesc=datas[10]
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
	       var  qtyfac=datas[40];
	  
	        
	        
	        if ((tmpRegno!="")&&(paregno!=tmpRegno) )
	         {//setBottomDblLine(xlsheet,row,1,13); 
		      	//setBottomLine(xlsheet,row,1,9);
		     }  
		     //row++;                        
	        if (tmpRegno=="")
	        {  
	            row=row+1
	            
	            
	            xlsheet.Cells(row, col).Value=ordsttdate
	            xlsheet.Cells(row, col+2).Value=paregno
	            xlsheet.Cells(row+1, col).Value="床号:"+bedcode
                xlsheet.Cells(row+1, col+2).Value="病区:"+getDesc(WardName)
                xlsheet.Cells(row+2, col).Value=name
                xlsheet.Cells(row+2, col+2).Value="年龄:"+patdob
               
          
                setBottomLine(xlsheet,row,col,parseInt(col+2));
                setBottomLine(xlsheet,row+2,col,parseInt(col+2));
	        }
	        else
	        {if ((paregno!=tmpRegno)||(ordsttdate!=tmpDate)||(rowcountflag==11))
	            {  
	                //每换登记号后初始化
	                cardnum=cardnum+1;
	                
	                col=col+4 ;
	                
	                if (((cardnum%3)==1)&&(cardnum!=1))
	                { 
	                     //每三个卡片后初始化
		                 col=1;
	                     rowflag=rowflag+1
	                     startNo=(13*rowflag)+1
	                 }
	                 
	                rowcountflag=1;
	                
	                row=startNo+1
	                
	                xlsheet.Cells(row, col).Value=ordsttdate
	                xlsheet.Cells(row, col+2).Value=paregno
	                xlsheet.Cells(row+1, col).Value="床号:"+bedcode
                    xlsheet.Cells(row+1, col+2).Value="病区:"+getDesc(WardName)
                    xlsheet.Cells(row+2, col).Value=name
                    xlsheet.Cells(row+2, col+2).Value="年龄:"+patdob
                   
    
		            xlsheet.Cells(row,col).Borders(9).LineStyle = 1
		            xlsheet.Cells(row,parseInt(col+1)).Borders(9).LineStyle = 1
		            xlsheet.Cells(row,parseInt(col+2)).Borders(9).LineStyle = 1
		           
		            xlsheet.Cells(row+2,col).Borders(9).LineStyle = 1
		            xlsheet.Cells(row+2,parseInt(col+1)).Borders(9).LineStyle = 1
		            xlsheet.Cells(row+2,parseInt(col+2)).Borders(9).LineStyle = 1
		    

	                //cellEdgeRightLine(xlsheet,row,1,13)
	         
	            }
	           if ((paregno==tmpRegno)&&(ordsttdate==tmpDate)&&(rowcountflag!=11))
	           {row=row+1;//同一卡片换行
	           } 
	  
	            
	        }
	        rowcountflag+=1;
	        
	        var proflag=""
	        if  (Priority=="取药医嘱") {var proflag="*"}
            if (proflag=="*") {freq=freq+"*"}
            xlsheet.Cells(row+3, col).Value="("+qty+")"+orditemdesc
            xlsheet.Cells(row+3, col+2).Value=dosqty+" "+freq //+" "+qty+uom

	        tmpRegno=paregno;
	        tmpDate=ordsttdate;
	
	    }
	row+=1;
	//总计
	//xlsheet.Cells(1, 1).Value = gHospname
    //xlsheet.Cells(2, 1).Value = getDesc(WardName)+DisTypeDesc+"药品明细清单"+reflag
    //xlsheet.Cells(3, 1).Value = "单号:"+DispNo+"   "+"("+Priority+")"
    //xlsheet.Cells(4, 1).Value = "配送地点:"+getDesc(WardName)+"      "+"领药人:"+"      "+"摆药药师:"+"     "+t['PRINTDATE']+ formatDate2(getPrintDate())+" "+getPrintTime()+"    ("+gPhaCnt+")"
    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet); 
}

function PrintPJPACK(gProcessID,tmps)

{
        //打印整包装
        //
        if (gDetailCntPack==0){return;}
        
	    gPhaCnt=gPhaCnt+1
	    var PagNum=1;

        var reflag="";//补打标记
	    var objRePrintFlag=document.getElementById("RePrintFlag");
        if (objRePrintFlag.value==1){var reflag="(补)"}
        //var tmps=getDispMainInfo(phac);
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
                
        var Template=gPrnpath+"STP_HZ_BJFC.xls";
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
        
        //getDispHZ(phac);
        PagNum=+1;

        if (gDetailCntPack>0) 
        {

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
            
            
            var obj=document.getElementById("mListDispDetailPack")
            
            if (obj) exe=obj.value;
            else  exe="" ;
            
            for (var i=1;i<=gDetailCntPack;i++)
	         {           
	            
	            var datas=cspRunServerMethod(exe,gProcessID,i)
	            
	            if (datas!="")
                    {
                        var ss=datas.split("^");
                        //incicode=ss[0];
                        //var tmpincidesc=ss[1].split("(")
                        //incidesc=tmpincidesc[0];
                        incidesc=ss[10]
                        var tmpuom=ss[3].split("(")
                        uom=tmpuom[0];
                        sp=ss[17];
                        var dex=sp.indexOf("@")
	        			if(dex>=0)
	        			{
		        			var tmpsp=sp.split("@")
		        			sp=tmpsp[0]
		    			}
		    			
                        manf=ss[7]
                        var dex=manf.indexOf("-")
	        			if(dex>=0)
	        			{
		        			manf=manf.substr(dex+1)
		    			}
                        qty=ss[15];
                        amt=ss[18];
                        sumamt=parseFloat(sumamt)+parseFloat(amt)
                        
                        admloc=ss[13];
   
                        drugform=ss[38];
                        resqty=ss[9] ;  //exclude qty
                        barcode=ss[12];
                        stkbin=ss[10];
                        generic=ss[11];
                        
                        serialNo++;
                        
                        
                        //xlsheet.Cells(startNo+serialNo, 1).Value =getDesc(generic);
                        xlsheet.Cells(startNo+serialNo, 1).Value =incidesc;
                        //xlsheet.Cells(startNo+serialNo, 2).Value =qty+" "+uom ;  
                        xlsheet.Cells(startNo+serialNo, 2).Value =qty;    
                        xlsheet.Cells(startNo+serialNo, 3).Value =drugform;
                        //xlsheet.Cells(startNo+serialNo, 5).Value =barcode; 
                        xlsheet.Cells(startNo+serialNo, 4).Value = sp;  
                        xlsheet.Cells(startNo+serialNo, 5).Value = amt;
                        //xlsheet.Cells(startNo+serialNo, 8).Value =manf;       
                        //xlsheet.Cells(startNo+serialNo, 9).Value =stkbin;
                        //setBottomLine(xlsheet,startNo+serialNo,1,9);
                        //cellEdgeRightLine(xlsheet,startNo+serialNo,1,9)
                    }

            } 
        }
    //总计
      //xlsheet.Cells(1, 1).Value = gHospname 
      xlsheet.Cells(2, 1).Value =getDesc(WardName) +DisTypeDesc+"药品汇总清单"+reflag
	  //xlsheet.Cells(2, 1).Value = t['DISP_BILL']
	  xlsheet.Cells(3, 1).Value ="单号:"+DispNo+"   "+"("+Priority+")"
	  //xlsheet.Cells(3, 1).Value ="("+Priority+")" +"  "+ t['DISPDATE']+DateRange+reflag
	  xlsheet.Cells(4, 1).Value ="配送地点:"+getDesc(WardName)+"   "+"领药人:"+"        "+"摆药药师:"+"        "+t['PRINTDATE']+ formatDate2(getPrintDate())+" "+getPrintTime()+"    ("+gPhaCnt+")"
    
    //var row=startNo+serialNo+1;
    xlsheet.Cells(startNo+serialNo+1,1).value=t['SUM_AMT']
    xlsheet.Cells(startNo+serialNo+1,5).value=sumamt

                       
    xlsheet.printout();

	SetNothing(xlApp,xlBook,xlsheet);
	
	KillTmp();
}



function PrintPJSY(phac,phatype)
{
	//中国医大摆药单?说明:
	//1.以病区?类别?床号为序
	//2.以每个登记号为一个处方打印
	//3.精麻药以单个药为一个处方打印
	//4.周末三天药品汇总打印
	//
	gPhaCnt=gPhaCnt+1
    var sumamt=0
    var tmpsumamt=0
	var tmp=0
	var startno=""
	var endno=""
    var tmps=getDispMainInfo(phac) ;  //取发药主记录信息
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
                       
    getDispHZOrd(phac) //取发药明细信息

    if (gPrnpath=="") 
    {
    	alert(t["CANNOT_FIND_TEM"]) ;
        return ;                
    }
    var Template=gPrnpath+"STP_PY_ZYD.xls";
    var xlApp = new ActiveXObject("Excel.Application");
    var xlBook = xlApp.Workbooks.Add(Template);
    var xlsheet = xlBook.ActiveSheet ;
    var startNo=6 ;
    var row ;

    if (xlsheet==null) 
    {       
    	alert(t["CANNOT_CREATE_PRNOBJ"]);
        return ;                
    }
    //-------   补打用,正常发药不调用
    var objSelRowFlag=document.getElementById("SelRowFlag") ; //是否选择发药单
    var SelRowFlag=0;
    if (objSelRowFlag){SelRowFlag=objSelRowFlag.value;}
    var objreflag=document.getElementById("RePrintFlag")
    var regno=""   
    var longord=""
    var shortord=""
    var reflag=""//补打标志
    if (objreflag.value==1){
	                   reflag="(补打)"  
	    var docu=parent.frames['dhcpha.dispquery'].document 
	    var objstartno=docu.getElementById("StartNo") //选中单个发药单开始行
	    if (objstartno){var startno=trim(objstartno.value) }
	    var objendno=docu.getElementById("EndNo")//选中单个发药单结束行
	    if (objstartno){var endno=trim(objendno.value)}                             
	                    }
    
    var exeDetail;
    //var obj=document.getElementById("mListDispDetail")
    var obj=document.getElementById("mListDispHZOrd")
    if (obj) exeDetail=obj.value;
    else exeDetail=""
    
    if ((parseInt(gDetailCnt)<startno)&&(startno!="")&&(SelRowFlag==1)){
	    alert("起始值大于总记录数")
	    return;}
    
    //-------
    //置表头
    SetHead (xlsheet,0,gHospname,reflag,PhaLoc,DispNo,DateRange,DisTypeDesc,WardName,paregno,name,bedcode,patdob) 
    setBottomLine(xlsheet,5,1,8)
    row=startNo; //发药信息开始行
    SetTitle(xlsheet,row)
    
	cellEdgeRightLine(xlsheet,row,1,8)
	setBottomLine(xlsheet,row,1,8)
	

    
    if (gDetailCnt>0)  //列发药明细信息
     {    
	    for (var i=1;i<=gDetailCnt;i++)
	    {   
	        if ((i<startno)&&(startno!="")&&(SelRowFlag==1)){continue;}
	        if ((i>endno)&&(endno!="")&&(SelRowFlag==1)){continue;}        
	        var ss=cspRunServerMethod(exeDetail,gProcessID,i)   
	        var datas=ss.split("^")
	        var bedcode=datas[5];
	        var name=datas[1];
	        var sex=datas[2];
	        var paregno=datas[0];
	        var patdob=datas[3];
	        //var tmpitemdesc=datas[10]
	        var tmpitemdesc=datas[10].split("(");
	        var orditemdesc=tmpitemdesc[0];
	        var orditemdesc1=tmpitemdesc[1];
	        if (tmpitemdesc.length==3){orditemdesc=orditemdesc+"("+orditemdesc1}
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
	        var ordedate=""
            var dex=ordsttdate.indexOf("||")
	        if(dex>=0)
	        {  
	            var tmpordsdate=ordsttdate.split("||");
		        ordsdate=tmpordsdate[0]
		        ordedate=tmpordsdate[1]
		    }
		    if (ordedate!=""){var ordsttdate=ordsdate+" 至 "+ordedate}
		    
	        var priority=datas[33];
	        var drugform=datas[38];	        
	        var doctor=datas[8];
	        var action=datas[34];
	        //alert(doctor);
	        if ((tmpRegno!="")&&(paregno!=tmpRegno) )
	         { 
		      	setBottomLine(xlsheet,row,1,8);
		      	tmpsumamt =sumamt
		      	sumamt=0
		     }  
		     row++;  
		                           
	        var sumamt=parseFloat(sumamt)+parseFloat(amt)
	        if (tmpRegno=="")
	        {    
	            //置表头2
	            xlsheet.Cells(row-5, 1).Value ="("+priority+")"
	            xlsheet.Cells(row-5, 1).Font.Size = 14
	            SetHead2(xlsheet,row-2,paregno,name,bedcode,patdob,sex)
	            tmp=row-2
	            //xlsheet.Cells(row-2, 1).Value ="登记号:"+paregno+"   "+"姓名:"+name+"   "+"床号:"+bedcode+"   "+"年龄:"+patdob   
	            patTotal=patTotal+1;
	          	cellEdgeRightLine(xlsheet,row,1,8)
	        }
	        else        
	        {if (trim(paregno)!=trim(tmpRegno))
	             //换下一登记号
	            { 
		         xlsheet.Cells(row,1).value="总金额:"
                 xlsheet.Cells(row,7).value=tmpsumamt.toFixed(2)
		         SetButton(xlsheet,row+1,doctor)        
                 xlsheet.Cells(row+1,8).value="("+(i-1)+"/"+gDetailCnt+")"
     
                 //xlsheet.Cells(row, 8).Font.Size = 7
                 //row=13
                //row=tmp+9
	            row=row+2
                 //置表头
                SetHead (xlsheet,row,gHospname,reflag,PhaLoc,DispNo,DateRange,DisTypeDesc,WardName,paregno,name,bedcode,patdob)
	            setBottomLine(xlsheet,row+5,1,8)
	             //置表头2
	            xlsheet.Cells(row+2, 1).Value ="("+priority+")"
	            xlsheet.Cells(row+2, 1).Font.Size = 14
	            SetHead2(xlsheet,row+5,paregno,name,bedcode,patdob,sex) 
	            SetTitle(xlsheet,row+6)
	            
	            cellEdgeRightLine(xlsheet,row+6,1,8)
	            setBottomLine(xlsheet,row+6,1,8)
	            row=row+7}
	        }
	        
	        xlsheet.Cells(row, 1).Value =orditemdesc; //orderitem description 
			xlsheet.Cells(row, 2).Value =spec;
			//xlsheet.Cells(row, 3).Value =drugform;
			xlsheet.Cells(row, 3).Value =qty+uom;
			xlsheet.Cells(row, 3).Value =qty;			
			xlsheet.Cells(row, 4).Value =dosqty ;			
			xlsheet.Cells(row, 5).Value =freq ;			
	        xlsheet.Cells(row, 6).Value =instruction;
	        xlsheet.Cells(row, 7).Value =ordsttdate;
	        xlsheet.Cells(row, 8).Value =amt; //医嘱备注
		    cellEdgeRightLine(xlsheet,row,1,8)
	        SetWarp(xlsheet,row,1,8)
	        tmpRegno=paregno;
	        
	        if (phatype=="JMY"){tmpRegno="1"}  
	    }
	        setBottomLine(xlsheet,row,1,8)
    } //2007-04-17
    //row+=1;
	//总计
    //xlsheet.Cells(row,1).value=t['SUM_PAT']
    //xlsheet.Cells(row,2).value=patTotal;
    //xlsheet.Cells(row,9).value="总金额:"+sumamt.toFixed(2)
       
    row+=1;
    xlsheet.Cells(row,1).value="总金额:"
    xlsheet.Cells(row,7).value=sumamt.toFixed(2)
    row+=1;
    SetButton(xlsheet,row,doctor)
    xlsheet.Cells(row,8).value=row
    xlsheet.Cells(row,8).value="("+(i-1)+"/"+gDetailCnt+"/"+gPhaCnt //每张处方第几条明细/每张处方明细总数/总发药单数
    xlsheet.Cells(row, 8).Font.Size = 9
    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);
    
    KillTmp();
}

function PrintZCY(phac,phatype)
{    
	   // 中草药打印 for  北京中医院 ;   created by lq  ;2008/03/05
	   // 
	   // 
	
	var objRePrintFlag=document.getElementById("RePrintFlag");
	/*
    if (objRePrintFlag.value==1){
	     var docu=parent.frames['dhcpha.dispquery'].document;
	     var objDetailPrn=docu.getElementById("DetailPrn");
	     var objTotalPrn=docu.getElementById("TotalPrn");
	     if ((objDetailPrn.checked==false)&&(objTotalPrn.checked==false))
	     {   return;}
		       

	             }
    */  
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
         var price   =ss[55]   //45
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
         var emergency=ss[49]
         var medicareno=ss[54]
         
         
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
            if (emergency!=""){bt=bt+" "+emergency} //急煎标志
 
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
	           // wyx add 2014-11-07住院煎药打印 ---start
               //var YyDate="至"+xdate
                //var liststr=paname+"^"+facotor+"^"+ward+"^"+bed+"^"+medno+"^"+YyDate+"^"+dreat+"^"+Instruc+"^"+notes+"^"+jzcnt+"^"+jztime+"^"+qzfre+"^"+prescno
               
              //if(remark=="代煎"){PrintJYZ(liststr);}   
              ////wyx add 2014-11-07住院煎药打印 ---end
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
	                 xlsheet.Cells(startrow+6, startcol1+3).Value ="病案号:"+" "+medicareno
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
    
    KillTmp();
    
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
	    	alert(datas);
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
                
                var objqty=document.getElementById("mgetPackQty")
	            if (objqty) exeqty=objqty.value; else  exeqty="" ;
	            qtystr=cspRunServerMethod(exeqty,inci,qty,resqty,facqty);
	            var tmpqtystr=qtystr.split("||")
	        
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
    
    KillTmp();
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
	KillTmp();
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

function GetPrtTypeConfig(type)
{
  ///Description:取住院药房配置
  ///Input:item
  ///Return:config
  ///Creator:LQ 2009-01-20
  var docu=parent.frames['dhcpha.getphaconfig'].document
  var obj=docu.getElementById("GetPrnTypeConfig")
  if (obj) {var encmeth=obj.value;} else {var encmeth='';}
  var config=cspRunServerMethod(encmeth,type)
  return config
  
}
function PrintPJQZ(phac,phatype)
{
 ///片剂小卡片打印 :衢州
 ///同一登记号不同日期打印不同卡片
 try{
	 
			getDispDetail(phac)
			var tmps=getDispMainInfo(phac) ;

		    var exeDetail;
		    var obj=document.getElementById("mListDispDetail")
		    if (obj) exeDetail=obj.value;
		    else exeDetail=""

		    if (gDetailCnt>0)  
			     {   
			        //打印散包装
			
			         PrintPJNOPACK(gProcessID,tmps,exeDetail)
			     } 
			
		
		      
		     if (gDetailCntPack>0)
			     {
				     //打印整包装
			           PrintPJPACK(gProcessID,tmps)
			     }
    
    }
                               
                     
     catch(e)
     {
         alert(e.message);
     }
    KillTmp();         
 
}
function SetHead (xlsheet,row,gHospname,reflag,PhaLoc,DispNo,DateRange,DisTypeDesc,WardName,paregno,name,bedcode,patdob)
{
     xlsheet.Cells(row+1, 3).Value = gHospname
     xlsheet.Cells(row+2, 3).Value = t['WARD_DRUGLIST']+reflag
     xlsheet.Cells(row+3, 1).Value = t['WARD'] + getDesc(WardName)   
     xlsheet.Cells(row+3, 2).Value = t['DISP_NO'] +DispNo
     xlsheet.Cells(row+3, 5).Value = t['DISPDATE']+DateRange
     xlsheet.Cells(row+4, 1).Value = t['PHARMACY']+ getDesc(PhaLoc)
     xlsheet.Cells(row+4, 2).Value = t['DISPCAT']+DisTypeDesc
     xlsheet.Cells(row+4, 5).Value = t['PRINTDATE']+formatDate2(getPrintDate())+" "+getPrintTime(); 
	
	}
function SetHead2(xlsheet,row,paregno,name,bedcode,patdob,sex)
{
     xlsheet.Cells(row, 1).Value ="登记号:"+paregno+"   "+"姓名:"+name+"   "+"床号:"+bedcode+"   "+"年龄:"+patdob+"   "+"性别:"+sex  
	
	}
function SetTitle (xlsheet,row)
{
     xlsheet.Cells(row, 1).Value ="药品名称"
	 xlsheet.Cells(row, 2).Value ="规格"
	 xlsheet.Cells(row, 3).Value ="数量"
	 xlsheet.Cells(row, 4).Value ="用量"
	 xlsheet.Cells(row, 5).Value ="频次"
	 xlsheet.Cells(row, 6).Value ="用法"
	 xlsheet.Cells(row, 7).Value ="用药时间"
	 xlsheet.Cells(row, 8).Value ="金额"
	
}
function SetButton (xlsheet,row,doctor)
{
	xlsheet.Cells(row,1).value="医师:"+doctor+"       "+"调剂人:"+"       "+"审核人:"+"       "+t['REC_USER']+"       "+t['PRINT_USER']+session['LOGON.USERNAME']

}
function getDispHZOrd(phac)
{
    //2009-04-20
    var exe;
    var obj=document.getElementById("mGetDispHZOrd") ;
    if (obj) exe=obj.value;
    else exe=""
    var result=cspRunServerMethod(exe,phac)
    var ss=result.split("^")
    gDetailCnt=ss[0];
    gProcessID=ss[1] ;
    gDetailCntPack=ss[2]
    
}
function PrintPJSZ(phac,phatype)
{

 try{
	gPhaCnt=gPhaCnt+1
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
   
    var Template=gPrnpath+"STP_PJ_SZZY.xls";
    var xlApp = new ActiveXObject("Excel.Application");
    var xlBook = xlApp.Workbooks.Add(Template);
    var xlsheet = xlBook.ActiveSheet ;
    /*
     //-------自定义纸张 lq
        var paperset = new ActiveXObject("PaperSet.GetPrintInfo");
        var papersize=paperset.GetPaperInfo("stockxy");
        //alert(papersize);
        if (papersize!=0){
        xlsheet.PageSetup.PaperSize = papersize;}
     //-------
    */
    var startNo=5 ;
    var row ;

    if (xlsheet==null) 
    {       
    	alert(t["CANNOT_CREATE_PRNOBJ"]);
        return ;                
    }
  	
    row=startNo;
    var exeDetail;
    var obj=document.getElementById("mListDispDetail")
    if (obj) exeDetail=obj.value;
    else exeDetail=""

    if (gDetailCnt>0)  
     {    
	    for (var i=1;i<=gDetailCnt;i++)
	    {           
	        var ss=cspRunServerMethod(exeDetail,gProcessID,i)   
	        var datas=ss.split("^")
	        //alert(datas)
	
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

	        var sumamt=parseFloat(sumamt)+parseFloat(amt)
	        var orddate=datas[29];
	        var ordsttdate=datas[30];
	        var priority=datas[33];
	        var drugform=datas[34];	        
	        var doctor=datas[8];
	        //var action=datas[35];
	        var sprice=datas[17];
	        var sumprice=datas[18]
	        var diag=datas[31]
	         generic=datas[32]
	        
            if ((tmpRegno!="")&&(paregno!=tmpRegno) )
	         {//setBottomDblLine(xlsheet,row,1,13); 
		      	setBottomLine(xlsheet,row,1,9)
		     }  
		     //row++;                        
	        if (tmpRegno=="")
	        {  
	            row=row+1
	           	mergcell(xlsheet,row-2,1,9)
	           	mergcell(xlsheet,row-1,1,9) 
	           	xlsheet.Cells(row-2, 1).HorizontalAlignment = 3;
	            xlsheet.Cells(row-1, 1).HorizontalAlignment = 3;
	           	xlsheet.Cells(row-2, 1).Value =getDesc(WardName)+"  "+ getDesc(PhaLoc)+DisTypeDesc+"摆药单No."+DispNo
	           	xlsheet.Cells(row-1, 1).Value ="("+Priority+")"+"  "+t['DISPDATE']+DateRange+reflag
	            xlsheet.Cells(row, 1).Value ="床号:"+bedcode+" "+"姓名:"+name+" "+"诊断:"+diag+" "+t['PRINTDATE']+getPrintDateTime(); 
	            row=row+1;
	            xlsheet.Cells(row, 1).Value ="医嘱时间"
		        xlsheet.Cells(row, 2).Value ="药品名称"
		        xlsheet.Cells(row, 3).Value ="规格"
		        xlsheet.Cells(row, 4).Value ="数量"
		        xlsheet.Cells(row, 5).Value ="剂量" 
	            xlsheet.Cells(row, 6).Value ="频次"
	            xlsheet.Cells(row, 7).Value ="用法"
	            xlsheet.Cells(row, 8).Value ="医师"
	            xlsheet.Cells(row, 9).Value ="单价"
	            setBottomLine(xlsheet,row,1,9);

	            patTotal=patTotal+1;
	          	//cellEdgeRightLine(xlsheet,row,1,13)
	        }
	        else
	        {if (paregno!=tmpRegno)
	            {  
	                row=row+6 
	                mergcell(xlsheet,row-2,1,9)
	                mergcell(xlsheet,row-1,1,9) 
	                xlsheet.Cells(row-2, 1).HorizontalAlignment = 3;
	                xlsheet.Cells(row-1, 1).HorizontalAlignment = 3;
	                xlsheet.Cells(row-2, 1).Value =getDesc(WardName)+"  "+ getDesc(PhaLoc)+DisTypeDesc+"摆药单No."+DispNo
	           	    xlsheet.Cells(row-1, 1).Value ="("+Priority+")"+"  "+t['DISPDATE']+DateRange+reflag  
	                xlsheet.Cells(row, 1).Value ="床号:"+bedcode+" "+"姓名:"+name+" "+"诊断:"+diag+" "+t['PRINTDATE']+getPrintDateTime(); 
	                row=row+1;
		            xlsheet.Cells(row, 1).Value ="医嘱时间"
			        xlsheet.Cells(row, 2).Value ="药品名称"
			        xlsheet.Cells(row, 3).Value ="规格"
			        xlsheet.Cells(row, 4).Value ="数量"
			        xlsheet.Cells(row, 5).Value ="剂量" 
		            xlsheet.Cells(row, 6).Value ="频次"
		            xlsheet.Cells(row, 7).Value ="用法"
		            xlsheet.Cells(row, 8).Value ="医师"
		            xlsheet.Cells(row, 9).Value ="单价"
		            setBottomLine(xlsheet,row,1,9);

	            patTotal=patTotal+1;
	            //cellEdgeRightLine(xlsheet,row,1,13)
	           // row++ 
	            }
	        }
	        row=row+1;
            xlsheet.Cells(row, 1).Value =ordsttdate
            
			xlsheet.Cells(row, 2).Value =getDesc(generic)+"/"+orditemdesc //spec;
		
			xlsheet.Cells(row, 3).Value =spec ;
	
			xlsheet.Cells(row, 4).Value =qty;	
			
			xlsheet.Cells(row, 5).Value =dosqty ;	
			
			xlsheet.Cells(row, 6).Value =freq;
						
	        xlsheet.Cells(row, 7).Value =instruction;
	      
	        xlsheet.Cells(row, 8).Value =doctor;
	     
	        xlsheet.Cells(row, 9).Value=sprice		//单价
	        
	        
		    //cellEdgeRightLine(xlsheet,row,1,13)
	        //SetWarp(xlsheet,row,1,13)
	       // setBottomLine(xlsheet,row,4,9)
	        tmpRegno=paregno;

	    }
	        setBottomLine(xlsheet,row,1,9)
    } 
	
    row+=1;

    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);
    
                     }
             catch(e)
             {
	             alert(e.message);
             }
             
    KillTmp();
}

function PrintPJ(phac,phatype)
{
	///通用明细打印
	
try{
		gPhaCnt=gPhaCnt+1;
		var objDetailPrn=document.getElementById("DetailPrn") ;
		//if (objDetailPrn.value!=1) {return;}
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
	    //var Priority=tmparr[13] ;
	    var Priority=tmparr[12] ;
	    var DateRange=formatDate2(dispsd)+"--"+formatDate2(disped);
	    
	    var DispNo=tmparr[9] ;
	    var DisTypeDesc=tmparr[10] ;
	    var tmpRegno="";
	    gTotalPat=0;		//总计人数  
	    gTotalAmount=0;              
	    getDispDetail(phac);
	    
	    if (gPrnpath=="") 
	    {
	    	alert(t["CANNOT_FIND_TEM"]) ;
	        return ;                
	    }
	    var Template=gPrnpath+"STP_PJ_XZ.xls";
	    var xlApp = new ActiveXObject("Excel.Application");
	    var xlBook = xlApp.Workbooks.Add(Template);
	    var xlsheet = xlBook.ActiveSheet ;
	     //-------自定义纸张 lq
	     //   var paperset = new ActiveXObject("PaperSet.GetPrintInfo");
	     //   var papersize=paperset.GetPaperInfo("stockxy");
	        //alert(papersize);
	     //   if (papersize!=0){
	     //   xlsheet.PageSetup.PaperSize = papersize;}
	     //-------
	    var startNo=5;
	   
	    if (xlsheet==null) 
	    {       
	    	alert(t["CANNOT_CREATE_PRNOBJ"]);
	        return ;                
	    }	    
	    xlsheet.Cells(1, 1).Value = gHospname+""+"摆药单"+reflag;
	    xlsheet.Cells(2, 1).Value ="No."+DispNo+"  "+Priority+"    药房:"+getDesc(PhaLoc)+"    发药类别"+DisTypeDesc;
	    xlsheet.Cells(3, 1).Value = t['WARD'] + getDesc(WardName) +"        "+t['PRINTDATE']+formatDate2(getPrintDate())+" "+getPrintTime(); //+t['PRINT_USER']+
	  
	    var exeDetail;
	    var obj=document.getElementById("mListDispDetail");
	    if (obj) exeDetail=obj.value;
	    else exeDetail=""
		gRow=startNo;
		//MergeByOrd(gProcessID);  //同一医嘱不同批次合并
		for (var i=1;i<=gDetailCnt;i++)
		{		
			var ss=cspRunServerMethod(exeDetail,gProcessID,i);
			if(ss!="")
			{			
			//if(gRow>=(15+startNo))
			//{	
			//	xlcenter(xlsheet,startNo,7,gRow,7);					
			//	xlsheet.printout();			
			//	ClearBorders(xlsheet,startNo,1,gRow+1,12);
			//	ClearContents(xlsheet,startNo,1,gRow+1,12);
			//	gRow=startNo;
			//	tmpRegno=WriteSheetPJ(xlsheet,ss,tmpRegno,1);
			//}
			//else
			//{				
				tmpRegno=WriteSheetPJ(xlsheet,ss,tmpRegno,0);
			//}
			//var datas=ss.split("^");
			//var priority=datas[33];
			}
				
		}
		//xlsheet.Cells(1, 1).Value = getDesc(PhaLoc)+DisTypeDesc+"摆药单No."+DispNo+"  "+priority+" "+reflag;				
		//写总计,打印最后一页
		//xlcenter(xlsheet,startNo,7,gRow,7);						
		setBottomLine(xlsheet,gRow-1,1,8);					
		//xlsheet.Cells(gRow+1,1).value=t['SUM_PAT']+gTotalPat+"      "+"总金额:"+gTotalAmount.toFixed(2)+"      "+t['PRINT_USER']+session['LOGON.USERNAME']+"      "+"发药人:"+"             "+"领药人:";
		xlsheet.printout();
	}
	catch(e)
	{
		alert(e.message);
	}
	
	SetNothing(xlApp,xlBook,xlsheet);
	
	KillTmp();
}

function PrintConPJ(phac,phatype,page)
{
	///明细续打
  var pageArray=page.split("-");
  var frompage=pageArray[0];
  frompage=(frompage-1)*cntPerPage+1;
  
  var topage=pageArray[1];  
  topage=topage*cntPerPage //+1;
try{
		gPhaCnt=gPhaCnt+1;
		var objDetailPrn=document.getElementById("DetailPrn") ;
		//if (objDetailPrn.value!=1) {return;}
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
	    gTotalPat=0;		//总计人数  
	    gTotalAmount=0;              
	    getDispDetail(phac)
	    
	    if (gPrnpath=="") 
	    {
	    	alert(t["CANNOT_FIND_TEM"]) ;
	        return ;                
	    }
	    var Template=gPrnpath+"STP_PJ_XZ.xls";
	    var xlApp = new ActiveXObject("Excel.Application");
	    var xlBook = xlApp.Workbooks.Add(Template);
	    var xlsheet = xlBook.ActiveSheet ;
	     //-------自定义纸张 lq
	     //   var paperset = new ActiveXObject("PaperSet.GetPrintInfo");
	     //   var papersize=paperset.GetPaperInfo("stockxy");
	        //alert(papersize);
	     //   if (papersize!=0){
	     //   xlsheet.PageSetup.PaperSize = papersize;}
	     //-------
	    var startNo=5 ;
	   
	    if (xlsheet==null) 
	    {       
	    	alert(t["CANNOT_CREATE_PRNOBJ"]);
	        return ;                
	    }	    
	    xlsheet.Cells(1, 1).Value = gHospname+""+"摆药单"+reflag;
	    xlsheet.Cells(2, 1).Value ="No."+DispNo+"  "+Priority+"    药房:"+getDesc(PhaLoc)+"    发药类别"+DisTypeDesc;
	    xlsheet.Cells(3, 1).Value = t['WARD'] + getDesc(WardName) +"      "+t['PRINTDATE']+formatDate2(getPrintDate())+" "+getPrintTime(); //+t['PRINT_USER']+
	    
	                
	    var exeDetail;
	    var obj=document.getElementById("mListDispDetail");
	    if (obj) exeDetail=obj.value;
	    else exeDetail=""
		gRow=startNo;
		//MergeByOrd(gProcessID);  //同一医嘱不同批次合并
		for (var i=frompage;i<topage;i++)
		{		
			var ss=cspRunServerMethod(exeDetail,gProcessID,i);	
			if(ss!="")
			{		
			//if(gRow>=(15+startNo))
			//{	
			//	xlcenter(xlsheet,startNo,7,gRow,7);					
			//	xlsheet.printout();			
			//	ClearBorders(xlsheet,startNo,1,gRow+1,12);
			//	ClearContents(xlsheet,startNo,1,gRow+1,12);
			//	gRow=startNo;
			//	tmpRegno=WriteSheetPJ(xlsheet,ss,tmpRegno,1);
			//}
			//else
			//{				
				tmpRegno=WriteSheetPJ(xlsheet,ss,tmpRegno,0);
			//}
			//var datas=ss.split("^");
			//var priority=datas[33];
			}
				
		}
		//xlsheet.Cells(1, 1).Value = getDesc(PhaLoc)+DisTypeDesc+"摆药单No."+DispNo+"  "+priority+" "+reflag;				
		//写总计,打印最后一页
		//xlcenter(xlsheet,startNo,7,gRow,7);						
		//xlsheet.Cells(gRow+1,1).value=t['SUM_PAT']+gTotalPat+"      "+"总金额:"+gTotalAmount.toFixed(2)+"      "+t['PRINT_USER']+session['LOGON.USERNAME']+"      "+"发药人:"+"             "+"领药人:";
		setBottomLine(xlsheet,gRow-1,1,8);
		xlsheet.printout();
	}
	catch(e)
	{
		alert(e.message);
	}
	
	SetNothing(xlApp,xlBook,xlsheet);
}

function ClearBorders(objSheet,fRow,fCol,tRow,tCol)
{        
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).Borders(1).LineStyle=0 ;
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).Borders(2).LineStyle=0 ;
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).Borders(3).LineStyle=0 ;
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).Borders(4).LineStyle=0 ;   
} 
function ClearContents (objSheet,fRow,fCol,tRow,tCol)
{        
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).ClearContents();
    //objSheet.Range(objSheet.Cells(srow, c1), objSheet.Cells(erow,c2)).ClearContents();
}
function xlcenter(objSheet,fRow,fCol,tRow,tCol)
{
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).HorizontalAlignment =-4108;
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).VerticalAlignment =-4108;
}
function WriteSheetPJ(xlsheet,ss,tmpRegno,prnPat)
{	var datas=ss.split("^");
	var bedcode=datas[5];
    var name=datas[1];
    var paregno=datas[0];   
    var orditemdesc=datas[10];
    var dex=orditemdesc.indexOf("[")
    //alert(datas[43]);
	if(dex>=0)
	{
		var tmpDesc=orditemdesc.split("[");
		orditemdesc=tmpDesc[0];
	}
    var dosqty=datas[13];
    var freq= datas[14];
    //var qty=datas[41];
    var qty=datas[15];
    var priority=datas[33];
       if (priority=="出院带药")
    {
	    var qty=datas[15];
    }
    
    //var tmpuom=datas[42].split("(");
    var uom=datas[42];   
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

    gTotalAmount=parseFloat(gTotalAmount)+parseFloat(amt);
    var orddate=datas[29];
    var ordsttdate=datas[30];
    var priority=datas[33];
    var drugform=datas[34];	        
    var doctor=datas[8];
    //var action=datas[35];
    var sprice=datas[17];
    var dex=sprice.indexOf("@")
	if(dex>=0)
	{
		var tmpsp=sprice.split("@")
		sprice=tmpsp[0]
	}  
    
    var sumprice=datas[18]
    var diag=datas[31]
	/*if ((tmpRegno!="")&&(paregno!=tmpRegno) )
    {
	    setBottomLine(xlsheet,gRow,1,12); 
      	gRow++;
    }  	*/
    if (tmpRegno=="")
    {   
        xlsheet.Cells(gRow, 1).Value =bedcode;//bed code
        xlsheet.Cells(gRow, 2).Value =name; //patient name

        gTotalPat=gTotalPat+1;
      	//cellEdgeRightLine(xlsheet,gRow,1,12);
      	//setBottomLine(xlsheet,gRow,1,12);      	
    }
    else
    {
	    if (paregno!=tmpRegno)
        {          
	        xlsheet.Cells(gRow, 1).Value =bedcode;//bed code
	        xlsheet.Cells(gRow, 2).Value =name; //patient name
	      
	        gTotalPat=gTotalPat+1;
	        //cellEdgeRightLine(xlsheet,gRow,1,12);
	        setBottomLine(xlsheet,gRow-1,1,8);	      
        }
        else if(prnPat==1)
        {
	    	xlsheet.Cells(gRow, 1).Value =bedcode;//bed code
	        xlsheet.Cells(gRow, 2).Value =name; //patient name	      
	       
	        //cellEdgeRightLine(xlsheet,gRow,1,12);
	        setBottomLine(xlsheet,gRow,1,8);
	    }
        
    }
    xlsheet.Cells(gRow, 3).Value =orditemdesc; //orderitem description 
	xlsheet.Cells(gRow, 4).Value =qty;
	xlsheet.Cells(gRow, 5).Value =freq;
	xlsheet.Cells(gRow, 6).Value =dosqty;
	xlsheet.Cells(gRow, 7).Value =amt;	
	xlsheet.Cells(gRow, 8).Value =priority;	

    cellEdgeRightLine(xlsheet,gRow,1,8);
    setBottomLine(xlsheet,gRow,3,6);
    gRow++;
    return paregno;
    	        
}
function PrintPJDMY(phac,phatype)
{
 
 ///毒麻药处方打印: 衢州
 ///毒麻药片剂打整包装为处方样式,散包装为床卡明细样式
	
 try{
	 
	 	
	gPhaCnt=gPhaCnt+1

	var reflag="";//补打标记
	var rowflag=1
	var denum=1
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

    var startNo=4 ;
	var row ;
    PagNum=+1;
    row=startNo;
    var exeDetail;
    var obj=document.getElementById("mListDispDetailPack")
    if (obj) exeDetail=obj.value;
    else exeDetail=""
    var admloc;
      
    if (gDetailCntPack>0)  
     {   
        ///打整包装为处方样式
        var Template=gPrnpath+"STP_MX_DMY.xls";
	    var xlApp = new ActiveXObject("Excel.Application");
	    var xlBook = xlApp.Workbooks.Add(Template);
	    var xlsheet = xlBook.ActiveSheet ;

	
	    if (xlsheet==null) 
	    {       
	    	alert(t["CANNOT_CREATE_PRNOBJ"]);
	        return ;                
	    }
 
      
	    for (var i=1;i<=gDetailCntPack;i++)
	    {           
	        var ss=cspRunServerMethod(exeDetail,gProcessID,i)   
	        var datas=ss.split("^")
	        //alert(datas)
	
	        var bedcode=datas[5];
	        var name=datas[1];
	        var sex=datas[2];
	        var paregno=datas[0];
	        var patdob=datas[3];
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
	        if  (i==1){var diag1=diag}
	        admloc=datas[6]
	        generic=datas[32]
	        
	        if ((tmpRegno!="")&&(paregno!=tmpRegno) )
	         {//setBottomDblLine(xlsheet,row,1,13); 
		      	//setBottomLine(xlsheet,row,1,9);
		     }  
		     //row++;                        
	        if (tmpRegno=="")
	        {  
	            
	            denum=1
	            row=row+1
	           	mergcell(xlsheet,row,1,7)
	            xlsheet.Cells(row, 1).Value ="病区:"+getDesc(WardName)+" "+"床号:"+bedcode+" "+"登记号:"+paregno+" "+"姓名:"+name+" "+"性别:"+sex+" "+"年龄:"+patdob//bed code 
	            row=row+1;
	            xlsheet.Cells(row, 1).Value ="药品名称"
	            xlsheet.Cells(row, 2).Value ="数量" 
	            xlsheet.Cells(row, 3).Value ="频次"
	            xlsheet.Cells(row, 4).Value ="剂量"
	            xlsheet.Cells(row, 5).Value ="用法"
	            setBottomLine(xlsheet,row,1,7);
	            patTotal=patTotal+1;

	        }
	        else
	        {if (paregno!=tmpRegno)
	            {  
	            
	                denum=1
	                rowflag=rowflag+1
	                if (row<14){row=15}
                    else(row=row+1)
	                row=row+2 
	                xlsheet.Cells(row, 1).Value="诊断:"+diag1;//第一个明细的诊断
                    setBottomLine(xlsheet,row,1,7);
                    row=row+1 
                    xlsheet.Cells(row, 1).Value = "请保妥善保管(非打印无效)"+"医生:"+doctor+"  "+"发药日期:"+PRTDATE+"  "+t['PRINTDATE']+ formatDate2(getPrintDate())+"  "+"发药:"+dispUser+"  "+"核对:"
	                row=row+2 
	                mergcell(xlsheet,row,1,7)
	                
	                xlsheet.Cells(row, 1).Value ="                            "+"衢州市人民医院麻醉科麻醉管制药品处方"+reflag
	                xlsheet.Cells(row, 1).Font.Size = 12
	                row=row+1
	                xlsheet.Cells(row, 1).Value ="单号:"+DispNo+"   "+"("+Priority+")"+"   "+"处方号:"+prescno  
	                row=row+1
	                xlsheet.Cells(row, 1).Value ="病区:"+getDesc(WardName)+" "+"床号:"+bedcode+" "+"登记号:"+paregno+" "+"姓名:"+name+" "+"性别:"+sex+" "+"年龄:"+patdob
	                row=row+1;
		            xlsheet.Cells(row, 1).Value ="药品名称"
		            xlsheet.Cells(row, 2).Value ="数量" 
		            xlsheet.Cells(row, 3).Value ="频次"
		            xlsheet.Cells(row, 4).Value ="剂量"
		            xlsheet.Cells(row, 5).Value ="用法"
		            setBottomLine(xlsheet,row,1,7);    
	                patTotal=patTotal+1;

	            }
	        }
	        row=row+1;
	        denum=denum+1

    
			xlsheet.Cells(row, 1).Value =orditemdesc //spec;
		
			xlsheet.Cells(row, 2).Value =qty+uom ;
	
			xlsheet.Cells(row, 3).Value =freq;	
			
			xlsheet.Cells(row, 4).Value =dosqty ;	
					
	        xlsheet.Cells(row, 5).Value =instruction;

	        tmpRegno=paregno;
	    }

		    row+=1;
			//总计
			//xlsheet.Cells(1, 1).Value = gHospname
		    xlsheet.Cells(2, 1).Value = "衢州市人民医院麻醉科麻醉管制药品处方"+reflag
		    xlsheet.Cells(2, 1).Font.Size = 12
		    xlsheet.Cells(3, 1).Value = "单号:"+DispNo+"   "+"("+Priority+")"+"   "+"处方号:"+prescno
		   
		    if (denum%10!=0){row=row+(11-denum)}
		    else(row=row+1)
		
		    setBottomLine(xlsheet,row,1,7);
		    xlsheet.Cells(row, 1).Value="诊断:"+diag //最后一个明细的诊断
		    xlsheet.Cells(row+1, 1).Value = "请保妥善保管(非打印无效)"+"医生:"+doctor+"  "+"发药日期:"+PRTDATE+"  "+t['PRINTDATE']+ formatDate2(getPrintDate())+"  "+"发药:"+dispUser+"  "+"核对:"

		    xlsheet.printout();
		    SetNothing(xlApp,xlBook,xlsheet);
	      
        } 
	

             if (gDetailCnt>0)
             
			     {
				     ///打印散包装
                    var exeDetail;
				    var obj=document.getElementById("mListDispDetail")
				    if (obj) exeDetail=obj.value;
				    else exeDetail=""
                    PrintPJNOPACK(gProcessID,tmps,exeDetail)  
                 }  
                    
                    
     }
                     
                   
             catch(e)
             {
	             alert(e.message);
             }
             
             KillTmp();
}
///Description:发药时有冲减退药
///Creator:Liang Qiang
///CreatDate:2009-08-05
function PrintHzRet(phac,phatype)
{    
        //retrieving primary dispensing infomation...
        //打印汇总单
  try{
	    gPhaCnt=gPhaCnt+1
	    var PagNum=1;

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
        var Template=gPrnpath+"STP_HZ_QZRET.xls";
        //var Template="E:\\STP_HZ_QZRET.xls";
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
	        var resqty;
	        var facqty;

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
                        resqty=ss[9];
                        facqty=ss[15];                       
                        serialNo++;

                        //xlsheet.Cells(startNo+serialNo, 1).Value =getDesc(generic);
                        xlsheet.Cells(startNo+serialNo, 1).Value =stkbin;
                        xlsheet.Cells(startNo+serialNo, 2).Value =incidesc;
                        //xlsheet.Cells(startNo+serialNo, 3).Value =manf; 
                        xlsheet.Cells(startNo+serialNo, 3).Value =facqty ;  
                        xlsheet.Cells(startNo+serialNo, 4).Value =drugform;
                        //xlsheet.Cells(startNo+serialNo, 5).Value =barcode; 
                        xlsheet.Cells(startNo+serialNo, 5).Value = sp;  
                        xlsheet.Cells(startNo+serialNo, 6).Value = amt;
                        //xlsheet.Cells(startNo+serialNo, 7).Value =qty; 
                        xlsheet.Cells(startNo+serialNo, 7).Value =resqty;
                        xlsheet.Cells(startNo+serialNo, 8).Value =qty;      
                        //xlsheet.Cells(startNo+serialNo, 9).Value =stkbin;
                        setBottomLine(xlsheet,startNo+serialNo,1,8);
                        cellEdgeRightLine(xlsheet,startNo+serialNo,1,8)
                    }
                else 
                {incicode=""}
            } while (incicode!="")
        }
    //总计
      xlsheet.Cells(1, 1).Value = gHospname 
      xlsheet.Cells(2, 1).Value =getDesc(PhaLoc) +DisTypeDesc+"药品汇总清单"+reflag
	  xlsheet.Cells(3, 1).Value ="单号:"+DispNo+"   "+"("+Priority+")"
	  xlsheet.Cells(4, 1).Value ="病区:"+getDesc(WardName)+" "+"发药人:"+"      "+"核对人:"+"      "+t['PRINTDATE']+ formatDate2(getPrintDate())+" "+getPrintTime()+"  ("+gPhaCnt+")"
      xlsheet.Cells(startNo+serialNo+1,1).value=t['SUM_AMT']
      xlsheet.Cells(startNo+serialNo+1,6).value=sumamt
                
      xlsheet.printout();
      SetNothing(xlApp,xlBook,xlsheet)

                 }
             catch(e)
             {
	             alert(e.message);
             }
} 




///Description:发药时有冲减退药
///Creator:Liang Qiang
///CreatDate:2013-04-22
function PrintHzRetBed(phac,phatype)
{    
 try{
	  
	  
	    gPhaCnt=gPhaCnt+1
	    var PagNum=1;

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
       	
     
       	
        var Template=gPrnpath+"STP_HZ_RET_BED.xls";
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
	        var resqty;
	        var facqty;

            var obj=document.getElementById("mListDispTotalBed")
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
                        incidesc=ss[1];
                       // tmpinci=incidesc;
                       
                       /*
                        var dex=incidesc.indexOf("[")
	        	     	if(dex>=0)
	        	  		{
                        
                         var tmpincistr=incidesc.split("[")
                         var name1=tmpincistr[0]
                         var name2=tmpincistr[1]
                         
                         var tmpincistr=name2.split("]")
                         var incistr1=tmpincistr[0]
                     
                         incidesc=incistr1+"("+name1+")"
                        }
                        */
                        
                        var spec=ss[12]
                  
                                     
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
                        resqty=ss[9];
                        facqty=qty-resqty;
                        beddata=ss[16];
   
                        serialNo++;
                        
                        //xlsheet.Cells(startNo+serialNo, 1).Value =getDesc(generic);
                        xlsheet.Cells(startNo+serialNo, 1).Value =serialNo;
                        xlsheet.Cells(startNo+serialNo, 2).Value =incidesc;
                        xlsheet.Cells(startNo+serialNo, 3).Value =spec;
                          
                        //xlsheet.Cells(startNo+serialNo, 4).Value =uom ;  
                        //xlsheet.Cells(startNo+serialNo, 3).Value =drugform;
                        //xlsheet.Cells(startNo+serialNo, 5).Value =barcode; 
                        //xlsheet.Cells(startNo+serialNo, 5).Value = sp;  
                        //xlsheet.Cells(startNo+serialNo, 6).Value = amt;
                        xlsheet.Cells(startNo+serialNo, 6).Value =qty; 
                        xlsheet.Cells(startNo+serialNo, 5).Value =resqty;
                        xlsheet.Cells(startNo+serialNo, 4).Value =facqty;   
                        xlsheet.Cells(startNo+serialNo, 7).Value =beddata;    
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
      xlsheet.Cells(2, 1).Value =getDesc(PhaLoc) +DisTypeDesc+" 汇总领药单"+reflag
	  xlsheet.Cells(3, 1).Value ="单号:"+DispNo+"   "+t['PRINTDATE']+ formatDate2(getPrintDate())+" "+getPrintTime()+"   "+"打印人:"+session['LOGON.USERNAME']
	  xlsheet.Cells(4, 1).Value ="病区:"+getDesc(WardName)+" "+"起始:"+dispsd+" "+"截止:"+disped+" "+"调剂人:"+"    领药人:"
      //xlsheet.Cells(startNo+serialNo+1,1).value=t['SUM_AMT']
      //xlsheet.Cells(startNo+serialNo+1,5).value=sumamt
      
      
      
           //---冲减日志---
            
            var obj=document.getElementById("mGetPresLogForPrt")
            if (obj) exe=obj.value; else  exe="" ;
            logcnt=cspRunServerMethod(exe,gProcessID);
            if (logcnt>0)
            {
	              
	                serialNo=serialNo+2
                    xlsheet.Cells(startNo+serialNo, 2).Value ="---冲减日志---";
	                for (var xx=1;xx<=logcnt;xx++)
	                {
		                var obj=document.getElementById("mListPresLogForPrt")
	            		if (obj) exe=obj.value; else  exe="" ;
	            		datas=cspRunServerMethod(exe,gProcessID,xx);
	            	
	            		var ss=datas.split("^");
                        
                        incidesc=ss[2];
                        
                        /*
                        var dex=incidesc.indexOf("[")
	        	     	if(dex>=0)
	        	  		{
                        
                         var tmpincistr=incidesc.split("[")
                         var name1=tmpincistr[0]
                         var name2=tmpincistr[1]
                         
                         var tmpincistr=name2.split("]")
                         var incistr1=tmpincistr[0]
                     
                         incidesc=incistr1+"("+name1+")"
                        }
                        
                        */
                        
                        
                        
                        bed=ss[0];
                        name=ss[1];
                        qty=ss[3];
                        retno=ss[5];
                        serialNo=serialNo+1
                        setBottomLine(xlsheet,startNo+serialNo,1,7);
                        
                        
                        xlsheet.Cells(startNo+serialNo, 2).Value =incidesc
                        xlsheet.Cells(startNo+serialNo, 3).Value =bed+"床 "+name
                        xlsheet.Cells(startNo+serialNo, 5).Value =qty;
                        xlsheet.Cells(startNo+serialNo, 7).Value =retno;
            		
	                }
	                
	                
            }
      
            
              
              
              //xlsheet.printout(1,100,1,false,"ZhongXinYaoFang")  
      xlsheet.printout();
      SetNothing(xlApp,xlBook,xlsheet)

                 }
             catch(e)
             {
	             alert(e.message);
             }
             
             
} 





function printBar(Bar,WardName,String)
{
	
          Bar.PageItmStr=String;
          
          Bar.HeadFontSize=10;
          
          //Bar.HeadFontSize=14;
          
          //Bar.ItmFontSize=11;
          //
          Bar.Cell1X=2500; //剂量Y坐标
          
          Bar.Cell2X=3200; //频次Y坐标
          
          Bar.LineEndX=3500; //标题横线结束Y
          
          Bar.Title=getDesc(WardName)+"口服药标贴";
          
          Bar.TitleY=100;
          
  		  //Bar.PatInfoStr=String;
  		  
  		  Bar.ItmSpace=30;   //基本信息行间距

  		  Bar.PageSpace=300; //明细行间距
  		  
          Bar.IfPrintBar=false; //是否打印条码
          
          Bar.BarcodeY=400;
          
	      Bar.PrintPJ(); //打印

}

function PrintKFYLabel(phac,phatype)
{
	         
	///病区口服药标贴?1?
	///IB0302 许文云  90005117 (条码)
	///服用时间   2008-2-6    早  
	///丙戊酸钠片0.2g   1片   餐后
	///丙戊酸钠片0.2g   1片   餐后
	///丙戊酸钠片0.2g   1片   餐中
	///丙戊酸钠片0.2g   1片   餐后

   try{
			var tmps=getDispMainInfo(phac) ;

            if (tmps=="" ) return;
	        var tmparr=tmps.split("^");
	        var WardName=tmparr[1] ;
	        //
	        var freqinfo;
		    var obj=document.getElementById("mGetDispByFreq")
		    if (obj) exeDetail=obj.value;
		    else exeDetail=""
		    var freqinfo=cspRunServerMethod(exeDetail,phac)
            //
            var pidarr=freqinfo.split("^");
            var pid=pidarr[1];
            //
	        var exeDetail;
		    var obj=document.getElementById("mGetDispFreqCnt")
		    if (obj) exeDetail=obj.value;
		    else exeDetail=""
		    var dispcnt=cspRunServerMethod(exeDetail,pid)  
		    if  (dispcnt==0){return;}
            //
		    var exeDetail;
		    var obj=document.getElementById("mListDispFreq")
		    if (obj) exeDetail=obj.value;
		    else exeDetail=""
            //
            Bar=new ActiveXObject("DHCSTPrintLable.PrintPJ");     
		    if (!Bar) return false;
		    //
		    for (var i=1;i<=dispcnt;i++)
		    {      
		           
		        var String=cspRunServerMethod(exeDetail,pid,i) 

		        printBar(Bar,WardName,String);
			         
			 }        

       }
                               
                     
     catch(e)
     {
         alert(e.message);
     }
             
 
}
function GetPageCount(phac)
{
	var pagecount=0;
    var phacItem;
    var pageItem=0;
	getDispHZ(phac);
	pageItem=pageItem+gTotalCnt;
			
			
		//arrayPage[i]=Math.ceil(pageItem/2);	
		//pagecount=pagecount+Math.ceil(pageItem/2);
		
		
	
	var obj=document.getElementById("mGetPage")
	if(obj)obj.value=pageItem;
	//alert(arrayObj[0]);
}
function continuePrintDialog(page)
{
	var pagecnt=showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.continueprintdialog&page='+page,'','dialogHeight:180px;dialogWidth:550px;center:yes;help:no;resizable:no;status:no;scroll:no')
	//pageArray=pagecnt.split("-");
	//var frompage=pageArray[0];
	//var topage=pageArray[1];
	//var objfrompage=document.getElementById("frompage") ;
	//objfrompage.value=pageArray[0];
	//var objtopage=document.getElementById("topage") ;
	//objtopage.value=pageArray[1];
	return pagecnt;
}
function MergeByOrd(gProcessID)
{
	var obj=document.getElementById("mMergeByOrd");
	if (obj) exeMerge=obj.value;
	var ss=cspRunServerMethod(exeMerge,gProcessID);
	
}
function PrintPJZYD(phac,phatype)
{
	//中国医大摆药单?说明:
	//1.以病区?类别?床号为序
	//2.以每个登记号为一个处方打印
	//3.精麻药以单个药为一个处方打印
	//
	gPhaCnt=gPhaCnt+1
    var sumamt=0
    var tmpsumamt=0
	var tmp=0
	var startno=""
	var endno=""
    var tmps=getDispMainInfo(phac) ;  //取发药主记录信息
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
                       
    getDispHZOrd(phac) //取发药明细信息

    if (gPrnpath=="") 
    {
    	alert(t["CANNOT_FIND_TEM"]) ;
        return ;                
    }
    var Template=gPrnpath+"STP_PY_ZYD.xls";
    var xlApp = new ActiveXObject("Excel.Application");
    var xlBook = xlApp.Workbooks.Add(Template);
    var xlsheet = xlBook.ActiveSheet ;
    var startNo=6 ;
    var row ;

    if (xlsheet==null) 
    {       
    	alert(t["CANNOT_CREATE_PRNOBJ"]);
        return ;                
    }
    //-------   补打用,正常发药不调用
    var objSelRowFlag=document.getElementById("SelRowFlag") ; //是否选择发药单
    var SelRowFlag=0;
    if (objSelRowFlag){SelRowFlag=objSelRowFlag.value;}
    var objreflag=document.getElementById("RePrintFlag")
    var regno=""   
    var longord=""
    var shortord=""
    var reflag=""//补打标志
    if (objreflag.value==1){
	                   reflag="(补打)" 
	      //             if (GetPrintFlag(phac,phatype)!=""){reflag=GetPrintFlag(phac,phatype); }	
	    var docu=parent.frames['dhcpha.dispquery'].document 
	    var objstartno=docu.getElementById("StartNo") //选中单个发药单开始行
	    if (objstartno){var startno=trim(objstartno.value) }
	    var objendno=docu.getElementById("EndNo")//选中单个发药单结束行
	    if (objstartno){var endno=trim(objendno.value)}                             
	                    }
    
    var exeDetail;
    //var obj=document.getElementById("mListDispDetail")
    var obj=document.getElementById("mListDispHZOrd")
    if (obj) exeDetail=obj.value;
    else exeDetail=""
    
    if ((parseInt(gDetailCnt)<startno)&&(startno!="")&&(SelRowFlag==1)){
	    alert("起始值大于总记录数")
	    return;}
    
    //-------
    //置表头
    SetHead (xlsheet,0,gHospname,reflag,PhaLoc,DispNo,DateRange,DisTypeDesc,WardName,paregno,name,bedcode,patdob) 
    setBottomLine(xlsheet,5,1,9)
    row=startNo; //发药信息开始行
    SetTitle(xlsheet,row)
    
	cellEdgeRightLine(xlsheet,row,1,9)
	setBottomLine(xlsheet,row,1,9)
	

    
    if (gDetailCnt>0)  //列发药明细信息
     {    
	    for (var i=1;i<=gDetailCnt;i++)
	    {   
	        if ((i<startno)&&(startno!="")&&(SelRowFlag==1)){continue;}
	        if ((i>endno)&&(endno!="")&&(SelRowFlag==1)){continue;}        
	        var ss=cspRunServerMethod(exeDetail,gProcessID,i)   
	        var datas=ss.split("^")
	        var bedcode=datas[5];
	        var name=datas[1];
	        var sex=datas[2];
	        var paregno=datas[0];
	        var patdob=datas[3];
	        //var tmpitemdesc=datas[10]
	        var tmpitemdesc=datas[10].split("(");
	        var orditemdesc=tmpitemdesc[0];
	        var orditemdesc1=tmpitemdesc[1];
	        if (tmpitemdesc.length==3){orditemdesc=orditemdesc+"("+orditemdesc1}
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
	        var ordedate=""
            var dex=ordsttdate.indexOf("||")
	        if(dex>=0)
	        {  
	            var tmpordsdate=ordsttdate.split("||");
		        ordsdate=tmpordsdate[0]
		        ordedate=tmpordsdate[1]
		    }
		    if (ordedate!=""){var ordsttdate=ordsdate+" 至 "+ordedate}
		    
	        var priority=datas[33];
	        var drugform=datas[38];	        
	        var doctor=datas[8];
	        var action=datas[34];
	        //alert(doctor);
	        if ((tmpRegno!="")&&(paregno!=tmpRegno) )
	         { 
		      	setBottomLine(xlsheet,row,1,9);
		      	tmpsumamt =sumamt
		      	sumamt=0
		     }  
		     row++;  
		                           
	        var sumamt=parseFloat(sumamt)+parseFloat(amt)
	        if (tmpRegno=="")
	        {    
	            //置表头2
	            //xlsheet.Cells(row-5, 1).Value ="("+priority+")"
	            //xlsheet.Cells(row-5, 1).Font.Size = 14
	            SetHead2(xlsheet,row-2,paregno,name,bedcode,patdob,sex)
	            tmp=row-2
	            //xlsheet.Cells(row-2, 1).Value ="登记号:"+paregno+"   "+"姓名:"+name+"   "+"床号:"+bedcode+"   "+"年龄:"+patdob   
	            patTotal=patTotal+1;
	          	cellEdgeRightLine(xlsheet,row,1,9)
	        }
	        else        
	        {if (trim(paregno)!=trim(tmpRegno))
	             //换下一登记号
	            { 
		         xlsheet.Cells(row,1).value="总金额:"
                 xlsheet.Cells(row,7).value=tmpsumamt.toFixed(2)
                 //alert(doctor);
		         //SetButton(xlsheet,row+1,doctor)   //注释掉 xiachunrong
		         SetButton(xlsheet,row+1,doctor1)     //add   by xiachunrong
                 xlsheet.Cells(row+1,8).value="("+(i-1)+"/"+gDetailCnt+")"
     
                 //xlsheet.Cells(row, 8).Font.Size = 7
                 //row=13
                //row=tmp+9
	            row=row+2
                 //置表头
                SetHead (xlsheet,row,gHospname,reflag,PhaLoc,DispNo,DateRange,DisTypeDesc,WardName,paregno,name,bedcode,patdob)
	            setBottomLine(xlsheet,row+5,1,9)
	             //置表头2
	            //xlsheet.Cells(row+2, 1).Value ="("+priority+")"
	            //xlsheet.Cells(row+2, 1).Font.Size = 14
	            SetHead2(xlsheet,row+5,paregno,name,bedcode,patdob,sex) 
	            SetTitle(xlsheet,row+6)
	            
	            cellEdgeRightLine(xlsheet,row+6,1,9)
	            setBottomLine(xlsheet,row+6,1,9)
	            row=row+7}
	        }
	        
	        xlsheet.Cells(row, 1).Value =orditemdesc; //orderitem description 
			xlsheet.Cells(row, 2).Value =spec;
			//xlsheet.Cells(row, 3).Value =drugform;
			xlsheet.Cells(row, 3).Value =qty+uom;
			//xlsheet.Cells(row, 3).Value =qty;			
			xlsheet.Cells(row, 4).Value =dosqty ;			
			xlsheet.Cells(row, 5).Value =freq ;			
	        xlsheet.Cells(row, 6).Value =instruction;
	        xlsheet.Cells(row, 7).Value =ordsttdate;
	        xlsheet.Cells(row, 8).Value =amt; //医嘱备注
                xlsheet.Cells(row, 9).Value =priority;
		    cellEdgeRightLine(xlsheet,row,1,9)
	        SetWarp(xlsheet,row,1,8)
	        tmpRegno=paregno;
	        var doctor1=doctor //add   by xiachunrong 修改原因?打印的医师串了
	        if (phatype=="JMY"){tmpRegno="1"}  
	    }
	        setBottomLine(xlsheet,row,1,9)
    } //2007-04-17
    //row+=1;
	//总计
    //xlsheet.Cells(row,1).value=t['SUM_PAT']
    //xlsheet.Cells(row,2).value=patTotal;
    //xlsheet.Cells(row,9).value="总金额:"+sumamt.toFixed(2)
       
    row+=1;
    xlsheet.Cells(row,1).value="总金额:"
    xlsheet.Cells(row,7).value=sumamt.toFixed(2)
    row+=1;
    //alert(doctor)
    SetButton(xlsheet,row,doctor)
    xlsheet.Cells(row,8).value=row
    xlsheet.Cells(row,8).value="("+(i-1)+"/"+gDetailCnt+"/"+gPhaCnt //每张处方第几条明细/每张处方明细总数/总发药单数
    xlsheet.Cells(row, 8).Font.Size = 9
    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);
}
function SetTitle (xlsheet,row)
{
         xlsheet.Cells(row, 1).Value ="药品名称"
	 xlsheet.Cells(row, 2).Value ="规格"
	 xlsheet.Cells(row, 3).Value ="数量"
	 xlsheet.Cells(row, 4).Value ="用量"
	 xlsheet.Cells(row, 5).Value ="频次"
	 xlsheet.Cells(row, 6).Value ="用法"
	 xlsheet.Cells(row, 7).Value ="用药时间"
	 xlsheet.Cells(row, 8).Value ="金额"
	 xlsheet.Cells(row, 9).value="医嘱类型"
}	
function SetPrintFlag(coll,phatype)
{
    ///设打印标志
   // if ((phatype!="JMY")&(phatype!="ZJ")&(phatype!="KFY")&(phatype!="WYY")){return;}
    if (coll!="") 
    {
	    var exe;
	    var obj=document.getElementById("mSetPrintFlag") ;
	    if (obj) exe=obj.value;
	    else exe=""
	    var result=cspRunServerMethod(exe,coll)
     }
     
}
function GetPrintFlag(coll,phatype)
{
    ///设打印标志
   // if  ((phatype!="JMY")&(phatype!="ZJ")&(phatype!="KFY")&(phatype!="WYY")){return "" ;}
    if (coll!="") 
    {
	    var exe;
	    var obj=document.getElementById("mGetPrintFlag") ;
	    if (obj) exe=obj.value;
	    else exe=""
	    var num=cspRunServerMethod(exe,coll)
	    return "(补打"+num+")"
     }
     
}   
function PrintPJHNZL(phac,phatype)
{
	var sumamt=0
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
	
	if (gPrnpath=="") 
	{
		alert(t["CANNOT_FIND_TEM"]) ;
		return ;                
	}
	var Template=gPrnpath+"STP_PJ_BJDT.xls";
	//var Template="d:\\STP_PJ_BJDT.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;
	//var startNo=4 ;
	var row=0 ;
	if (xlsheet==null) 
	{       
		alert(t["CANNOT_CREATE_PRNOBJ"]);
		return ;                
	} 
	//xlsheet.Cells(row, 1).Value ="NO:"+ DispNo
	//xlsheet.Cells(row, 3).Value = gHospname+getDesc(PhaLoc)
	//xlsheet.Cells(1, 10).Value = ordtypedesc
	//row++;
	//xlsheet.Cells(row, 1).Value = getDesc(WardName)
	//xlsheet.Cells(row, 3).Value = PRTDATE
	//xlsheet.Cells(row, 6).Value = getPrintDateTime() 
	//xlsheet.Cells(2, 10).Value = t['PAGE']+PRTDATE
	var exeSYZ;
	var strSYZ="";
	var objSYZ=document.getElementById("mGetSYZ")
	if(objSYZ) exeSYZ=objSYZ.value;
	else exeSYZ=""
	var exeDetail;
	var obj=document.getElementById("mListDispDetail")
	if (obj) exeDetail=obj.value;
	else exeDetail=""
	var obj=document.getElementById("mListDispDetailPack")
	if (obj) exeDetailPack=obj.value;
	else exeDetailPack=""
	if (gDetailCnt>0) //2007-04-17
	{    
		for (var i=1;i<=gDetailCnt;i++)
		{           
	 		var ss=cspRunServerMethod(exeDetail,gProcessID,i)   
	 		var datas=ss.split("^")
	 		var bedcode=datas[5];
	 		var name=datas[1];
	 		var paregno=datas[0];
	 		var patdob=datas[3];
	 		var orditemdesc=datas[10] ;
	 		var dosqty=datas[13];
	 		var doseunit=datas[13];
	 		var freq= datas[14];	
	 		var qty=datas[15];
	 		var tmpuom=datas[16].split("(");
	 		var uom=tmpuom[0];
	 		var saleprice=datas[17];
	 		var prescno=datas[7];
	 		var ordstatus=datas[12];
	 		var instruction=datas[20];
	 		var duration= datas[21];
	 		//var manf=datas[25];
	 		var spec=datas[26];
	 		var eatdrugtime=datas[27] 
	 		var amt=datas[18];	
	 		var sumamt=parseFloat(sumamt)+parseFloat(amt)
	 		var orddate=datas[29];
	 		var ordsttdate=datas[30];
	 		var priority=datas[33];
	 		var drugform=datas[34];	        
	 		var doctor=datas[8];
	 		var action=datas[35];	
	 		var oeori=datas[22];
	 		//alert(oeori);
	 		var strSYZ=cspRunServerMethod(exeSYZ,oeori)
	 		//alert(strSYZ)
	 		if ((tmpRegno!="")&&(paregno!=tmpRegno) )
  			{//setBottomDblLine(xlsheet,row,1,13); 
				setBottomLine(xlsheet,row,1,11);
			}
			
			row++;
			SetFontBold(xlsheet,row,1,11)
			mergcell(xlsheet,row,1,2)
			SetFontDQStyle(xlsheet,row,1,2,2)
			xlsheet.Cells(row, 1).Value ="NO:"+ DispNo
			mergcell(xlsheet,row,3,9)
			SetFontDQStyle(xlsheet,row,3,9,3)
			fontcell(xlsheet,row,3,9,15)
	        xlsheet.Cells(row, 3).Value = gHospname+getDesc(PhaLoc)
	        //xlsheet.Cells(1, 10).Value = ordtypedesc
	        row++;
	        SetFontBold(xlsheet,row,1,11)
	        mergcell(xlsheet,row,1,2)
			SetFontDQStyle(xlsheet,row,1,2,2)
	        xlsheet.Cells(row, 1).Value = getDesc(WardName)
	        mergcell(xlsheet,row,3,5)
			SetFontDQStyle(xlsheet,row,3,3,3)
	        xlsheet.Cells(row, 3).Value = PRTDATE
	        SetCellStyle(xlsheet,row,6,4)
	        mergcell(xlsheet,row,6,9)
	        SetFontDQStyle(xlsheet,row,6,4,4)
	        
	        //SetCellStyle(xlsheet,row,6,1)
	        
	        xlsheet.Cells(row, 6).Value = getPrintDateTime() 
	        setBottomLine(xlsheet,row,1,11)
	        row++; 
			xlsheet.Cells(row, 1).Value="床号"
			xlsheet.Cells(row, 2).Value="病人姓名"
			mergcell(xlsheet,row,3,5)
			xlsheet.Cells(row, 3).Value="药品名称"
			xlsheet.Cells(row, 6).Value="单次量"
			xlsheet.Cells(row, 7).Value="频率"
			xlsheet.Cells(row, 8).Value="总量"
			xlsheet.Cells(row, 9).Value="用法"
			xlsheet.Cells(row, 10).Value="开始时间"
			xlsheet.Cells(row, 11).Value="医师姓名"
			setBottomLine(xlsheet,row,1,11)
			cellEdgeRightLine(xlsheet,row,1,11)
			row++;                        
			//  alert(row)
 			if (tmpRegno=="")
 			{   
				xlsheet.Cells(row, 1).Value =bedcode;  //bed code
				xlsheet.Cells(row, 2).Value =name; //patient name
				//xlsheet.Cells(row, 3).Value =orditemdesc
				//xlsheet.Cells(row, 6).Value =dosqty
				//xlsheet.Cells(row, 7).Value =doseunit;
				//xlsheet.Cells(row, 8).Value =freq;
				//xlsheet.Cells(row, 9).Value =instruction;
				//xlsheet.Cells(row, 10).Value =ordsttdate;		
				patTotal=patTotal+1;
				//cellEdgeRightLine(xlsheet,row,1,10)
 			}
 			else
 			{
		 		if (paregno!=tmpRegno)
	   			{   //row=row+1;
	   				//xlsheet.Cells(row, 1).Value =paregno;
	   				//xlsheet.Cells(row, 1).Value =bedcode;//bed code
	   				//xlsheet.Cells(row, 2).Value =name; //patient name	   
	   				//xlsheet.Cells(row, 4).Value =patdob;  	   
	   				patTotal=patTotal+1;
	   				//cellEdgeRightLine(xlsheet,row,1,10)
	  				// row++ 
	   			}
 			} 
			 xlsheet.Cells(row, 1).Value =bedcode;  //bed code
			 xlsheet.Cells(row, 2).Value =name; //patient name
 			xlsheet.Cells(row, 3).Value =orditemdesc
 			xlsheet.Cells(row, 6).Value =dosqty
 			xlsheet.Cells(row, 7).Value =freq;
 			xlsheet.Cells(row, 8).Value =qty   //+uom;
 			xlsheet.Cells(row, 9).Value =instruction;
 			xlsheet.Cells(row, 10).Value =ordsttdate; 
 			xlsheet.Cells(row, 11).Value =doctor;
			cellEdgeRightLine(xlsheet,row,1,11)	
			// setBottomLine(xlsheet,row,4,9)
			setBottomLine(xlsheet,row,1,11)
 			tmpRegno=paregno;
 			
 			row+=1;
	//总计
	xlsheet.Cells(row,1).value="摆药人"+session['LOGON.USERNAME']
	row++;
	xlsheet.Cells(row,1).value="适应症"+strSYZ
	xlsheet.Cells(row,6).value="领药人签字"
	row++;
	xlsheet.Cells(row,1).value="审核/调配签名"
	xlsheet.Cells(row,6).value="核对/发药签名"
	row=row+2;
		}
	 	//setBottomLine(xlsheet,row,1,11)
	 	
	} //2007-04-17
	
	if (gDetailCntPack>0) //2007-04-17
	{    
		for (var i=1;i<=gDetailCntPack;i++)
		{           
	 		var ss=cspRunServerMethod(exeDetailPack,gProcessID,i)   
	 		var datas=ss.split("^")
	 		var bedcode=datas[5];
	 		var name=datas[1];
	 		var paregno=datas[0];
	 		var patdob=datas[3];
	 		var orditemdesc=datas[10] ;
	 		var dosqty=datas[13];
	 		var doseunit=datas[13];
	 		var freq= datas[14];	
	 		var qty=datas[15];
	 		var tmpuom=datas[16].split("(");
	 		var uom=tmpuom[0];
	 		var saleprice=datas[17];
	 		var prescno=datas[7];
	 		var ordstatus=datas[12];
	 		var instruction=datas[20];
	 		var duration= datas[21];
	 		//var manf=datas[25];
	 		var spec=datas[26];
	 		var eatdrugtime=datas[27] 
	 		var amt=datas[18];	
	 		var sumamt=parseFloat(sumamt)+parseFloat(amt)
	 		var orddate=datas[29];
	 		var ordsttdate=datas[30];
	 		var priority=datas[33];
	 		var drugform=datas[34];	        
	 		var doctor=datas[8];
	 		var action=datas[35];	
	 		var oeori=datas[22];
	 		//alert(oeori);
	 		var strSYZ=cspRunServerMethod(exeSYZ,oeori)
	 		//alert(strSYZ)
	 		if ((tmpRegno!="")&&(paregno!=tmpRegno) )
  			{//setBottomDblLine(xlsheet,row,1,13); 
				setBottomLine(xlsheet,row,1,11);
			}
			
			row++;
			SetFontBold(xlsheet,row,1,11)
			mergcell(xlsheet,row,1,2)
			SetFontDQStyle(xlsheet,row,1,2,2)
			xlsheet.Cells(row, 1).Value ="NO:"+ DispNo
			mergcell(xlsheet,row,3,9)
			SetFontDQStyle(xlsheet,row,3,9,3)
			fontcell(xlsheet,row,3,9,15)
	        xlsheet.Cells(row, 3).Value = gHospname+getDesc(PhaLoc)
	        //xlsheet.Cells(1, 10).Value = ordtypedesc
	        row++;
	        SetFontBold(xlsheet,row,1,11)
	        mergcell(xlsheet,row,1,2)
			SetFontDQStyle(xlsheet,row,1,2,2)
	        xlsheet.Cells(row, 1).Value = getDesc(WardName)
	        mergcell(xlsheet,row,3,5)
			SetFontDQStyle(xlsheet,row,3,3,3)
	        xlsheet.Cells(row, 3).Value = PRTDATE
	        SetCellStyle(xlsheet,row,6,4)
	        mergcell(xlsheet,row,6,9)
	        SetFontDQStyle(xlsheet,row,6,4,4)
	        
	        //SetCellStyle(xlsheet,row,6,1)
	        
	        xlsheet.Cells(row, 6).Value = getPrintDateTime() 
	        setBottomLine(xlsheet,row,1,11)
	        row++; 
			xlsheet.Cells(row, 1).Value="床号"
			xlsheet.Cells(row, 2).Value="病人姓名"
			mergcell(xlsheet,row,3,5)
			xlsheet.Cells(row, 3).Value="药品名称"
			xlsheet.Cells(row, 6).Value="单次量"
			xlsheet.Cells(row, 7).Value="频率"
			xlsheet.Cells(row, 8).Value="总量"
			xlsheet.Cells(row, 9).Value="用法"
			xlsheet.Cells(row, 10).Value="开始时间"
			xlsheet.Cells(row, 11).Value="医师姓名"
			setBottomLine(xlsheet,row,1,11)
			cellEdgeRightLine(xlsheet,row,1,11)
			row++;                        
			//  alert(row)
 			if (tmpRegno=="")
 			{   
				xlsheet.Cells(row, 1).Value =bedcode;  //bed code
				xlsheet.Cells(row, 2).Value =name; //patient name
				//xlsheet.Cells(row, 3).Value =orditemdesc
				//xlsheet.Cells(row, 6).Value =dosqty
				//xlsheet.Cells(row, 7).Value =doseunit;
				//xlsheet.Cells(row, 8).Value =freq;
				//xlsheet.Cells(row, 9).Value =instruction;
				//xlsheet.Cells(row, 10).Value =ordsttdate;		
				patTotal=patTotal+1;
				//cellEdgeRightLine(xlsheet,row,1,10)
 			}
 			else
 			{
		 		if (paregno!=tmpRegno)
	   			{   //row=row+1;
	   				//xlsheet.Cells(row, 1).Value =paregno;
	   				//xlsheet.Cells(row, 1).Value =bedcode;//bed code
	   				//xlsheet.Cells(row, 2).Value =name; //patient name	   
	   				//xlsheet.Cells(row, 4).Value =patdob;  	   
	   				patTotal=patTotal+1;
	   				//cellEdgeRightLine(xlsheet,row,1,10)
	  				// row++ 
	   			}
 			} 
			 xlsheet.Cells(row, 1).Value =bedcode;  //bed code
			 xlsheet.Cells(row, 2).Value =name; //patient name
 			xlsheet.Cells(row, 3).Value =orditemdesc
 			xlsheet.Cells(row, 6).Value =dosqty
 			xlsheet.Cells(row, 7).Value =freq;
 			xlsheet.Cells(row, 8).Value =qty   //+uom;
 			xlsheet.Cells(row, 9).Value =instruction;
 			xlsheet.Cells(row, 10).Value =ordsttdate; 
 			xlsheet.Cells(row, 11).Value =doctor;
			cellEdgeRightLine(xlsheet,row,1,11)	
			// setBottomLine(xlsheet,row,4,9)
			setBottomLine(xlsheet,row,1,11)
 			tmpRegno=paregno;
 			
 			row+=1;
	//总计
	xlsheet.Cells(row,1).value="摆药人"+session['LOGON.USERNAME']
	row++;
	xlsheet.Cells(row,1).value="适应症"+strSYZ
	xlsheet.Cells(row,6).value="领药人签字"
	row++;
	xlsheet.Cells(row,1).value="审核/调配签名"
	xlsheet.Cells(row,6).value="核对/发药签名"
	row=row+2;
		}
	 	//setBottomLine(xlsheet,row,1,11)
	 	
	} //2007-04-17
	
	xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet);
	
	KillTmp();
} 

///creator:yunhaibao
///createdate:20130411
///description:住院代煎药单打印
function PrintJYZ(ListStr)
{
      var tmparr=ListStr.split("^")
      var paname=tmparr[0]	
      var fsqty=tmparr[1]
      var ward=tmparr[2]
      var bed=tmparr[3]
      var medno=tmparr[4]
      var YyDate=tmparr[5]
      var dreat=tmparr[6]
      var instruc=tmparr[7]
 	var notes=tmparr[8]
 	var jzcnt=tmparr[9]   //煎煮次数
	var jztime=tmparr[10]  //煎煮时间
	var jzstr=jzcnt
	if (jztime!="") {jzstr=jzstr+","+jztime}
	var qzfre=tmparr[11]  //取汁量
	var qzfre="共取汁"+qzfre+"毫升"
      	var prescno=tmparr[12]
      	
      	var MyPara="";
      	var MyList=""
      
 	  	DHCP_GetXMLConfig("InvPrintEncrypt","DHCPharmacyJYZ")    //InvPrintEncrypt是读取xml的方法调用
 	  	
	    MyPara=MyPara+"PatName"+String.fromCharCode(2)+paname;
	    MyPara=MyPara+"^FsQty"+String.fromCharCode(2)+fsqty;
	    MyPara=MyPara+"^PatWard"+String.fromCharCode(2)+ward;
	    MyPara=MyPara+"^BedNo"+String.fromCharCode(2)+bed;
	    MyPara=MyPara+"^MedNo"+String.fromCharCode(2)+medno;
	    MyPara=MyPara+"^YyTime"+String.fromCharCode(2)+YyDate;
	    if (dreat=="Y")
	    { MyPara=MyPara+"^DYES"+String.fromCharCode(2)+"√";}
	    else
	    {MyPara=MyPara+"^DNO"+String.fromCharCode(2)+"√";}
	    
	    if(instruc.indexOf("外")>=0)
	    { MyPara=MyPara+"^WY"+String.fromCharCode(2)+"√";}
	    else
	    { MyPara=MyPara+"^KF"+String.fromCharCode(2)+"√";}	    
	    //MyPara=MyPara+"^Remark"+String.fromCharCode(2)+notes;
	    MyPara=MyPara+"^Remark"+String.fromCharCode(2)+jzstr; 
	    //MyPara=MyPara+"^Yf"+String.fromCharCode(2)+jyway.substring(0,20);
	    //MyPara=MyPara+"^Yf1"+String.fromCharCode(2)+jyway.substring(21,jyway.length);	   
	    MyPara=MyPara+"^PrescNo"+String.fromCharCode(2)+"*"+prescno+"*";
	    MyPara=MyPara+"^PrescNo2"+String.fromCharCode(2)+prescno; 
	    MyPara=MyPara+"^Remark2"+String.fromCharCode(2)+qzfre;
	     
	    var myobj=document.getElementById("ClsBillPrint");
		DHCP_PrintFun(myobj,MyPara,"");	
 }

 
function SetCellStyle(objSheet,row,startcol,colnum)
{objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).NumberFormatLocal = "@"}
function SetFontDQStyle(objSheet,row,startcol,colnum,num)
{objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).HorizontalAlignment = num}
function SetFontBold(objSheet,row,startcol,colnum)
{objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).Font.Bold = true}
document.body.onload=BodyLoadHandler;

document.body.onbeforeunload=function(){

   KillTmp();
  } 