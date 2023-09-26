var hospname;
var prnpath;
var PCODROWID ;
var AllWard
function BodyLoadHandler()
{	
	//
	var obj=document.getElementById("PCODROWID") ;
	if (obj) PCODROWID=obj.value;
	var obj=document.getElementById("AllWard") ;
	if (obj) AllWard=obj.value;
	//Print();    //print mode of Anhui,JiShuiTan
	var objTotalPrn=document.getElementById("TotalPrn");
	var objDetailPrn=document.getElementById("DetailPrn");
    if(objDetailPrn.value==1){
	PrintMX();
    }
    if (objTotalPrn.value==1){PrintHZ(); }
	//2.按病区打
	/*
	var objTotalPrn=document.getElementById("TotalPrn");
	if (objTotalPrn.value==1){PrintOutTotal_SZZY(); }
    var objDetailPrn=document.getElementById("DetailPrn");
    if (objDetailPrn.value==1){PrintOutDetail_SZZY(); }
    */
    //PrintHuaXi(); //print mode of ShaoGuan ///descrition?按单个患者打印出院带药单
	window.close();
}
function PrintOutDetail_SZZY()
{
	///descrition:出院带药病区打印明细for 深圳中医
	///creator:lq 08-10-10
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
	var tmppano=""
	var PagNum=1
	var i ;
	var rePrnFlag=""
	
 	if (PCODROWID=="" ) return ;
 	var objRePrintFlag=document.getElementById("RePrintFlag");
    if (objRePrintFlag.value==1){rePrnFlag="(补)";}
 	
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
	var Template=prnpath+"STP_DrugOutDetail_SZZY.xls";
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
    var ward=ss[25];
    var disploc=ss[19];
    
	//xlsheet.Cells(1, 1).Value = hospname;  //hospital description
	xlsheet.Cells(1, 1).Value=getDesc(ward)+"   "+getDesc(disploc)+"出院带药单(明细)"
	xlsheet.Cells(2, 1).Value=t['PRINTDATE']+formatDate2(getPrintDate())+getPrintTime()+"    "+rePrnFlag;
	
	//var LeftHeader= " "; CenterHeader= " "; RightHeader= " "; LeftFooter= " "; CenterFooter= " "; RightFooter= " ";
	//var titleRows = 0;titleCols = 0 ;
	//var CenterHeader="&14"+hospname+"\r"+getDesc(ward)+"  "+ getDesc(disploc)+"出院带药单(明细)"
	//var LeftHeader="\r"+"\r"+"\r"+"&12"+"第"+PagNum+"页"+"   "+t['PRINTDATE']+formatDate2(getPrintDate())+"   "+getPrintTime()+"  "+rePrnFlag;
    //ExcelSet(xlsheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter)
    //PagNum=+1;
	for (i=1;i<=cnt;i++)  
	{
		
		var data=cspRunServerMethod(xxxx,pid,i) ;
		var ss=data.split("^")
		var pano=ss[0];
	    var paname=ss[1];
	    var pasex=ss[2];
	    var paage=ss[3];
	    var bed=ss[26];
	    var dispno=ss[29];
	    var diagnose=ss[20];
		var desc=ss[8];
		var alias=ss[27];
		var barcode=ss[30];
		var form=ss[32];
		var qty= ss[12];
		var uom=ss[13];
		var saleprice=ss[14];
		var amt=ss[15];
		var manf=ss[31];
		var ind=manf.indexOf("-");
		if(ind>=0)
		{
			manf=manf.substr(ind+1);
		}
		var oeordate=ss[33];
		var oeortime=ss[34];
		var freq=ss[11];
		var ins=ss[16];
		var doctor=ss[6];
		
		tmprow=startNo+i
		if (tmppano==""){   	    xlsheet.Cells(startNo+i, 1).Value =bed;
		xlsheet.Cells(startNo+i, 2).Value =paname;
		xlsheet.Cells(startNo+i, 3).Value =diagnose;}
		//xlsheet.Cells(startNo+i, 1).Value =bed;
		//xlsheet.Cells(startNo+i, 2).Value =paname;
		//xlsheet.Cells(startNo+i, 3).Value =diagnose;
		xlsheet.Cells(startNo+i, 4).Value =oeordate+" "+oeortime;	
		xlsheet.Cells(startNo+i, 5).Value =desc ;
		xlsheet.Cells(startNo+i, 6).Value=barcode;
		xlsheet.Cells(startNo+i, 8).Value =qty+uom;  
		xlsheet.Cells(startNo+i, 9).Value =form;
		xlsheet.Cells(startNo+i, 10).Value=freq;
		xlsheet.Cells(startNo+i, 11).Value =ins;
		xlsheet.Cells(startNo+i, 12).Value =doctor; 
		xlsheet.Cells(startNo+i, 13).Value =saleprice;
		 
		sum=parseFloat(sum)+parseFloat(amt);

		if ((tmppano!="")&&(pano!=tmppano) )
	    {
   	    xlsheet.Cells(startNo+i, 1).Value =bed;
		xlsheet.Cells(startNo+i, 2).Value =paname;
		xlsheet.Cells(startNo+i, 3).Value =diagnose;
	    setBottomLine(xlsheet,startNo+i-1,1,13);   }
		cellEdgeRightLine(xlsheet,startNo+i,1,13)
		tmppano=pano
	    SetWarp(xlsheet,startNo+i,1,13)
	    var tmpnum=startNo+i
	   // setBottomLine(xlsheet,startNo+i-1,1,13);
	 
	}

    setBottomLine(xlsheet,startNo+i-1,1,13); 
    //合计
    xlsheet.Cells(startNo+i, 1).Value=t['SUMMATION']
    xlsheet.Cells(startNo+i, 2).Value=cnt;
    xlsheet.Cells(startNo+i, 12).Value=sum;
   
    row=startNo+i+1;

    xlsheet.Cells(row, 1).Value=t['STATISTIC']+"              "+t['PREPARE']+"             "+t['DISPEN_USER']+"              "+t['RECIEVE']+"              "+t['PRINT_USER']+session['LOGON.USERNAME'];
    mergcell(xlsheet,row,1,13);
    
	//setLine(xlsheet,startNo,1,startNo+i,13);

	xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet)
	
}
function PrintOutTotal_SZZY()
{
	///descrition?按病区打印出院带药单 for 深圳中医院?(汇总)
	///creator:  lq 08-10-10
	///
	///
	var sum=0;      //合计
	var startNo=5;
	var incicode="";
	var serialNo=0
	var rePrnFlag=""
 	if (PCODROWID=="" ) return ;
 	var objRePrintFlag=document.getElementById("RePrintFlag");
    if (objRePrintFlag.value==1){rePrnFlag="(补)";}
    
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
	var Template=prnpath+"STP_DrugOutTotal_SZZY.xls";
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
	
	
	var obj=document.getElementById("mListOutMainInfo") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var data2=cspRunServerMethod(encmeth,pid) ;
	
	var ss2=data2.split("^");
    var ward=ss2[0];
    var disploc=ss2[1];
	xlsheet.Cells(1, 1).Value =getDesc( ward)+"       "+getDesc(disploc)+"出院带药单(汇总)"
	xlsheet.Cells(2, 1).Value ="打印时间:"+ formatDate2(getPrintDate())+" "+getPrintTime()+"   "+rePrnFlag 
	var obj=document.getElementById("mListDispTotal")
            if (obj) exe=obj.value;
            else  exe="" ;
           
            do 
            {
	            datas=cspRunServerMethod(exe,incicode,pid);
	            
	            if (datas!="")
                    {

                        var ss=datas.split("^");
                        incicode=ss[0];
                        var tmpincidesc=ss[1].split("(")
                        incidesc=tmpincidesc[0];
                        var tmpuom=ss[8].split("(")
                        uom=tmpuom[0];
                        sp=ss[5];
                        manf=ss[7];
                        
                        var dex=manf.indexOf("-")
	        			if(dex>=0)
	        			{
		        			manf=manf.substr(dex+1)
		    			}
		    			
                        qty=ss[4];
                        amt=ss[6];
    
                        sum=parseFloat(sum)+parseFloat(amt)
                    
                        drugform=ss[3]
                          
                        barcode=ss[2];
        
                        serialNo++;
  
                        xlsheet.Cells(startNo+serialNo, 1).Value =serialNo;
                        xlsheet.Cells(startNo+serialNo, 2).Value =incidesc; 
                        xlsheet.Cells(startNo+serialNo, 3).Value =barcode; 
                        xlsheet.Cells(startNo+serialNo, 4).Value =drugform;
                        xlsheet.Cells(startNo+serialNo, 5).Value =qty+" "+uom ; 
                        xlsheet.Cells(startNo+serialNo, 6).Value = sp;  
                        xlsheet.Cells(startNo+serialNo, 7).Value = amt;
                        xlsheet.Cells(startNo+serialNo, 8).Value =manf; 
                            
                        //xlsheet.Cells(startNo+serialNo, 9).Value =stkbin;
                        setBottomLine(xlsheet,startNo+serialNo,1,8);
                        cellEdgeRightLine(xlsheet,startNo+serialNo,1,8)
                    }
                else 
                {incicode=""}
            } while (incicode!="")	
	xlsheet.Cells(startNo+serialNo+1, 1).Value ="总金额:"
	xlsheet.Cells(startNo+serialNo+1, 7).Value =sum
	xlsheet.Cells(startNo+serialNo+2, 1).Value ="制单人:"+session['LOGON.USERNAME']+"          "+"调剂人:"+"          "+"发药/审核人:"+"          "+"领药人:"+"          "+"取药人:"
	xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet)
	
 
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
	prnpath="D:\\DHCC\\"
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
	var obj=document.getElementById("RePrintFlag")
	if (obj) RePrintFlag=obj.value; 
	if (RePrintFlag>0)
		{ xlsheet.Cells(2,1)=xlsheet.Cells(2,1)+t['RE_PRINT'];  }
	xlsheet.Cells(3,1).Value=t['WARD']+ward;
	xlsheet.Cells(3,3).Value=t['PRINTDATE']+getPrintDateTime();
	xlsheet.Cells(3,7).Value=t['DISPNO']+dispno;
	
	xlsheet.Cells(4, 1).Value=t['PA_NO']+pano;
	xlsheet.Cells(4, 2).Value=t['PA_NAME']+paname;
	//xlsheet.Cells(4, 3).Value=t['PA_SEX']+pasex;
	xlsheet.Cells(4, 3).Value=t['PA_AGE']+paage;
	xlsheet.Cells(4, 5).Value=t['BED']+bed;
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
		//var manf=ss[30]
		var manf=ss[31]
		//var prescno= ss[5];  //prescript No
		//var ordstatus=ss[9] ;
		var instruction=ss[16];
		//var duration= ss[17];
		//var admloc=ss[4] ;
		xlsheet.Cells(startNo+i, 1).Value =desc ; //desc
		xlsheet.Cells(startNo+i, 2).Value=manf;
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

function PrintHuaXi()
{
	//zdm,2007-8-7,华西医院出院带药单
	//last modified:2007-8-14,zdm
	
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
	var startNo=6;
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
	var Template=prnpath+"STP_DrugOut_HX.xls";
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
	//alert(ss);
	pano=ss[0];
	paname=ss[1];
	pasex=ss[2];
	paage=ss[3];
	ward=ss[25];
	bed=ss[26];
	disploc=ss[19];
	dispno=ss[29];
	diagnose=ss[20];
	
	//xlsheet.Cells(1, 1).Value = hospname;  //hospital description
	
	xlsheet.Cells(3, 1).Value=t['PA_NO']+pano;
	xlsheet.Cells(3, 3).Value=t['PA_NAME']+paname;
	xlsheet.Cells(3, 5).Value=t['PA_SEX']+pasex;
	xlsheet.Cells(3, 7).Value=t['PA_AGE']+paage;
	
	xlsheet.Cells(4, 1).Value=t['PHARMACY']+getDesc(disploc);
	xlsheet.Cells(4, 3).Value=t['WARD']+getDesc(ward);
	xlsheet.Cells(4, 7).Value=t['PRINTDATE']+formatDate2(getPrintDate())+getPrintTime();
	
	xlsheet.Cells(5, 1).Value=t['DISPNO']+dispno;	
	xlsheet.Cells(5, 3).Value=t['DIAGNOSE']+diagnose;
	//alert("print");
	for (i=1;i<=cnt;i++)  
	{
		var data=cspRunServerMethod(xxxx,pid,i) ;
		var ss=data.split("^")
		var desc=ss[8];
		var alias=ss[27];
		var barcode=ss[30];
		var form=ss[32];
		var qty= ss[12];
		var uom=ss[13];
		var saleprice=ss[14];
		var amt=ss[15];
		var manf=ss[31];
		var ind=manf.indexOf("-");
		if(ind>=0)
		{
			manf=manf.substr(ind+1);
		}
			
		xlsheet.Cells(startNo+i, 1).Value =desc ;
		xlsheet.Cells(startNo+i, 2).Value=getDesc(alias);
		xlsheet.Cells(startNo+i, 3).Value =barcode;  
		xlsheet.Cells(startNo+i, 4).Value =form;
		xlsheet.Cells(startNo+i, 5).Value=qty+""+uom;
		xlsheet.Cells(startNo+i, 6).Value =saleprice;
		xlsheet.Cells(startNo+i, 7).Value =amt;
		xlsheet.Cells(startNo+i, 8).Value =manf;  
		
		sum=parseFloat(sum)+parseFloat(amt);
	}
    
    //xlsheet.Cells(row,1).value= ;
    //合计
    xlsheet.Cells(startNo+i, 1).Value=t['SUMMATION']
    xlsheet.Cells(startNo+i, 2).Value=cnt;
    xlsheet.Cells(startNo+i, 7).Value=sum;
    
    row=startNo+i+1;
   
    //统计?调配?发药?签收?送药
    xlsheet.Cells(row, 1).Value=t['STATISTIC']+"              "+t['PREPARE']+"             "+t['DISPEN_USER']+"              "+t['RECIEVE']+"              "+t['PRINT_USER']+session['LOGON.USERNAME'];
    mergcell(xlsheet,row,1,8);
	setLine(xlsheet,startNo,1,startNo+i,8);

	xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet)
}
function PrintHZ()
{
	//打印出院带药单汇总
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
	var startNo=6;
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
    var DispUser=session['LOGON.USERNAME']
	//
	var Template=prnpath+"STP_DrugOut_HZ.xls";
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
	//alert(ss);
	pano=ss[0];
	paname=ss[1];
	pasex=ss[2];
	paage=ss[3];
	ward=ss[25];
	bed=ss[26];
	disploc=ss[19];
	dispno=ss[29];
	diagnose=ss[20];
	
	//xlsheet.Cells(1, 1).Value = hospname;  //hospital description
	
	//xlsheet.Cells(3, 1).Value=t['PA_NO']+pano;
	//xlsheet.Cells(3, 3).Value=t['PA_NAME']+paname;
	//xlsheet.Cells(3, 5).Value=t['PA_SEX']+pasex;
	//xlsheet.Cells(3, 7).Value=t['PA_AGE']+paage;
	
	xlsheet.Cells(4, 1).Value=t['PHARMACY']+getDesc(disploc);
	xlsheet.Cells(4, 3).Value=t['WARD']+getDesc(ward);
	xlsheet.Cells(4, 7).Value=t['PRINTDATE']+formatDate2(getPrintDate())+getPrintTime();
	
	xlsheet.Cells(5, 1).Value=t['DISPNO']+dispno;
	if (AllWard==1) {xlsheet.Cells(5, 1).Value=""}	
	xlsheet.Cells(5, 3).Value=t['DIAGNOSE']+diagnose;
	//alert("print");
	for (i=1;i<=cnt;i++)  
	{
		var data=cspRunServerMethod(xxxx,pid,i) ;
		var ss=data.split("^")
		var desc=ss[8];
		var alias=ss[27];
		var barcode=ss[30];
		var form=ss[32];
		var qty= ss[12];
		var uom=ss[13];
		var saleprice=ss[14];
		var amt=ss[15];
		var manf=ss[31];
		var ind=manf.indexOf("-");
		if(ind>=0)
		{
			manf=manf.substr(ind+1);
		}
			
		xlsheet.Cells(startNo+i, 1).Value =desc ;
		xlsheet.Cells(startNo+i, 2).Value=getDesc(alias);
		xlsheet.Cells(startNo+i, 3).Value =barcode;  
		xlsheet.Cells(startNo+i, 4).Value =form;
		xlsheet.Cells(startNo+i, 5).Value=qty+""+uom;
		xlsheet.Cells(startNo+i, 6).Value =saleprice;
		xlsheet.Cells(startNo+i, 7).Value =amt;
		xlsheet.Cells(startNo+i, 8).Value =manf;  
		
		sum=parseFloat(sum)+parseFloat(amt);
	}
    
    //xlsheet.Cells(row,1).value= ;
    //合计
    xlsheet.Cells(startNo+i, 1).Value=t['SUMMATION']
    xlsheet.Cells(startNo+i, 2).Value=cnt;
    xlsheet.Cells(startNo+i, 7).Value=sum;
    
    row=startNo+i+1;
   
    //统计?调配?发药?签收?送药
    xlsheet.Cells(row, 1).Value=t['STATISTIC']+"              "+t['PREPARE']+"             "+t['DISPEN_USER']+"              "+t['RECIEVE']+"              "+t['PRINT_USER']+session['LOGON.USERNAME'];
    mergcell(xlsheet,row,1,8);
	setLine(xlsheet,startNo,1,startNo+i,8);

	xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet)
}
function PrintMX()
{
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
	var startNo=6;
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
	var Template=prnpath+"STP_DrugOut_MX.xls";
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
	//alert(ss);
	pano=ss[0];
	paname=ss[1];
	pasex=ss[2];
	paage=ss[3];
	ward=ss[25];
	bed=ss[26];
	disploc=ss[19];
	dispno=ss[29];
	diagnose=ss[20];
	
	//xlsheet.Cells(1, 1).Value = hospname;  //hospital description
	
	//xlsheet.Cells(3, 1).Value=t['PA_NO']+pano;
	//xlsheet.Cells(3, 3).Value=t['PA_NAME']+paname;
	//xlsheet.Cells(3, 5).Value=t['PA_SEX']+pasex;
	//xlsheet.Cells(3, 7).Value=t['PA_AGE']+paage;
	
	xlsheet.Cells(4, 1).Value=t['PHARMACY']+getDesc(disploc);
	xlsheet.Cells(4, 3).Value=t['WARD']+getDesc(ward);
	xlsheet.Cells(4, 5).Value=t['PRINTDATE']+formatDate2(getPrintDate())+"  "+getPrintTime();
	
	xlsheet.Cells(5, 1).Value=t['DISPNO']+dispno;
	if (AllWard==1) {xlsheet.Cells(5, 1).Value=""}	
	xlsheet.Cells(5, 3).Value=t['DIAGNOSE']+diagnose;
	//alert("print");
	for (i=1;i<=cnt;i++)  
	{
		var data=cspRunServerMethod(xxxx,pid,i) ;
		var ss=data.split("^")
		pano=ss[0];
	    paname=ss[1];
		var desc=ss[8];
		var alias=ss[27];
		var barcode=ss[30];
		var form=ss[32];
		var qty= ss[12];
		var uom=ss[13];
		var saleprice=ss[14];
		var amt=ss[15];
		var manf=ss[31];
		var ind=manf.indexOf("-");
		if(ind>=0)
		{
			manf=manf.substr(ind+1);
		}
		xlsheet.Cells(startNo+i, 1).Value =pano ;
		xlsheet.Cells(startNo+i, 2).Value =paname ;	
		xlsheet.Cells(startNo+i, 3).Value =desc ;
		xlsheet.Cells(startNo+i, 4).Value=getDesc(alias);
		xlsheet.Cells(startNo+i, 5).Value =barcode;  
		xlsheet.Cells(startNo+i, 6).Value =form;
		xlsheet.Cells(startNo+i, 7).Value=qty+""+uom;
		xlsheet.Cells(startNo+i, 8).Value =saleprice;
		xlsheet.Cells(startNo+i, 9).Value =amt;
		//xlsheet.Cells(startNo+i, 10).Value =manf;  
		
		sum=parseFloat(sum)+parseFloat(amt);
	}
    
    //xlsheet.Cells(row,1).value= ;
    //合计
    xlsheet.Cells(startNo+i, 1).Value=t['SUMMATION']
    xlsheet.Cells(startNo+i, 2).Value=cnt;
    xlsheet.Cells(startNo+i, 9).Value=sum;
    
    row=startNo+i+1;
   
    //统计?调配?发药?签收?送药
    xlsheet.Cells(row, 1).Value=t['STATISTIC']+"              "+t['PREPARE']+"             "+t['DISPEN_USER']+"              "+t['RECIEVE']+"              "+t['PRINT_USER']+session['LOGON.USERNAME'];
    mergcell(xlsheet,row,1,8);
	setLine(xlsheet,startNo,1,startNo+i,9);

	xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet)
}
function setLine(objSheet,startrow,startcol,endrow,endcol)
{
    objSheet.Range(objSheet.Cells(startrow, startcol), objSheet.Cells(endrow, endcol)).Borders.LineStyle=1 ;
}
function cellEdgeRightLine(objSheet,row,c1,c2)
{
	for (var i=c1;i<=c2;i++)
	{
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(10).LineStyle=1;
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(7).LineStyle=1;
	}
}
function SetWarp(objSheet,row,c1,c2)
{
	//自动换行设置  lq
	for (var i=c1;i<=c2;i++)
	{
	  objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).WrapText  =  true//自动换行
	}
}
function CellMerge(objSheet,r1,r2,c1,c2)		
{
	alert("")
	var range= objSheet.Range(objSheet.Cells(r1, c1),objSheet.Cells(r2,c2))
	range.MergeCells ="True"
}
document.body.onload=BodyLoadHandler;
