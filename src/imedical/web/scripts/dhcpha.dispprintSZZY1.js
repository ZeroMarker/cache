
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
var gPhaCnt=0 //��ӡ��ҩ����

     
function BodyLoadHandler()
{		
	var phac;

	var obj=document.getElementById("Phac") ;
	if (obj) phac=obj.value ;
	if (phac=="")
	{return;}
	
	gGrp=session['LOGON.GROUPID'];
	
	var obj=document.getElementById("mPrtHospName") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	gHospname=cspRunServerMethod(encmeth,'','') ;
	
	// get print tempalate path from server 
	var obj=document.getElementById("mGetPrnPath") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	gPrnpath=cspRunServerMethod(encmeth,'','') ;


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
      //ҽ�����ҷ�ҩ
      PrintHz(phac,phatype)  ; 
      return ;
    }
    
    switch (phatype) {

        case "ZJ":
	        PrintHz(phac,phatype)  ; //��ҩ(���)
            PrintPJ(phac,phatype)  ; //��ҩ
           	break;
        case "DSY":
	        PrintHz(phac,phatype)  ; //����Һ 
	        PrintPJ(phac,phatype)  ; 	 
          	break;
        case "KFY":
           	PrintHz(phac,phatype)  ; //�ڷ�ҩ
            PrintPJ(phac,phatype)  ; //��ҩ
           	break;
        case "WYY":
           	PrintHz(phac,phatype)  ; //����ҩ
            PrintPJ(phac,phatype)  ;  //��ҩ
           	break;
        case "DMY":
            PrintHz(phac,phatype)  ; //����ҩ
            PrintPJ(phac,phatype)  ; ; //��ҩ
           	break;
        case "ZCY":
            PrintZCY(phac,phatype) ;//�в�ҩ��ҩ��
            PrintZCYTIAOMA(phac,phatype);//��ҩ����
            break;  
        case "GZY":
            PrintHz(phac,phatype) ; //��ɢ�൤
         	PrintPJ(phac,phatype) ;
         	break;
        default:
        alert("ҩƷ������ò�ƥ��,���ʵ!")
	}
	KillTmp();

}

function PrintHz(phac,phatype)
{    
        //retrieving primary dispensing infomation...
  try{
        var objTotalPrn=document.getElementById("TotalPrn");
        if (objTotalPrn.value!=1){return;}
        var reflag="";//������
	    var objRePrintFlag=document.getElementById("RePrintFlag");
        if (objRePrintFlag.value==1){var reflag="(��)"}
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
                
        var Template=gPrnpath+"STP_zjhzd_SZZY.xls";
        //var Template="C:\\STP_zjhzd_HX.xls";
        var xlApp = new ActiveXObject("Excel.Application");
        var xlBook = xlApp.Workbooks.Add(Template);
        var xlsheet = xlBook.ActiveSheet ; 
        //-------�Զ���ֽ�� lq
       
	    var papersize=0;
        var paperset = new ActiveXObject("PaperSet.GetPrintInfo");
        var papersize=paperset.GetPaperInfo("stockxy");
        //alert(papersize)
        if (papersize!=0){
        xlsheet.PageSetup.PaperSize = papersize;}

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

	        xlsheet.Cells(1, 1).Value = gHospname  //+ getDesc(PhaLoc)+DisTypeDesc+t['DISP_BILL'];  //hospital description
	        
	        
	        xlsheet.Cells(2, 1).Value = getDesc(WardName)+"   "+getDesc(PhaLoc) +DisTypeDesc+"��ҩ��NO."+" "+DispNo
	        //xlsheet.Cells(2, 1).Value = t['DISP_BILL']
	        xlsheet.Cells(3, 1).Value ="("+Priority+")" +"  "+ t['DISPDATE']+DateRange+reflag
	        xlsheet.Cells(4, 1).Value =t['PRINTDATE']+ formatDate2(getPrintDate())+" "+getPrintTime()
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
    //�ܼ�
    var row=startNo+serialNo+1;
    xlsheet.Cells(row,1).value=t['SUM_AMT']
    xlsheet.Cells(row,7).value=sumamt
       
    var row=startNo+serialNo+2;
    xlsheet.Cells(row,1).value=t['PRINT_USER']+session['LOGON.USERNAME']
    xlsheet.Cells(row,3).value=t['ADJ_USER']
    CellMerge(xlsheet,row,row,5,6);
    xlsheet.Cells(row,5).value=t['DISPEN_USER']
    xlsheet.Cells(row,8).value=t['REC_USER']

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
		
	gPhaCnt=gPhaCnt+1
	var objDetailPrn=document.getElementById("DetailPrn") ;
	if (objDetailPrn.value!=1) {return;}
	var reflag="";//������
	var objRePrintFlag=document.getElementById("RePrintFlag");
    if (objRePrintFlag.value==1){var reflag="(��)"}
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
    var patTotal=0;		//�ܼ�����                
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
     //-------�Զ���ֽ�� lq
        var paperset = new ActiveXObject("PaperSet.GetPrintInfo");
        var papersize=paperset.GetPaperInfo("stockxy");
        //alert(papersize);
        if (papersize!=0){
        xlsheet.PageSetup.PaperSize = papersize;}
     //-------
    var startNo=5 ;
    var row ;

    if (xlsheet==null) 
    {       
    	alert(t["CANNOT_CREATE_PRNOBJ"]);
        return ;                
    }
    xlsheet.Cells(1, 1).Value = gHospname
    xlsheet.Cells(2, 1).Value = getDesc(WardName)+"  "+ getDesc(PhaLoc)+DisTypeDesc+"��ҩ��No."+DispNo
    xlsheet.Cells(3, 1).Value ="("+Priority+")"+"  "+t['DISPDATE']+DateRange+reflag
    xlsheet.Cells(4, 1).Value = t['PRINTDATE']+formatDate2(getPrintDate())+" "+getPrintTime(); 
    xlsheet.Cells(4, 4).Value = t['WARD'] + getDesc(WardName) 
    xlsheet.Cells(4, 5).Value =t['PRINTDATE']+getPrintDateTime(); 

	    
	//var LeftHeader= " "; CenterHeader= " "; RightHeader= " "; LeftFooter= " "; CenterFooter= " "; RightFooter= " ";
	//var titleRows = 0;titleCols = 0 ;
	//var CenterHeader="&14"+gHospname+"\r"+getDesc(WardName)+"  "+ getDesc(PhaLoc)+DisTypeDesc+"��ҩ��No."+DispNo+"\r"+"&12"+"("+Priority+")"+"  "+t['DISPDATE']+DateRange+reflag
	//var LeftHeader="\r"+"\r"+"\r"+"��"+PagNum+"ҳ" +"   "+t['PRINTDATE']+formatDate2(getPrintDate())+" "+getPrintTime();
    //ExcelSet(xlsheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter)
    //PagNum=+1;
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
	        
	        if ((tmpRegno!="")&&(paregno!=tmpRegno) )
	         {//setBottomDblLine(xlsheet,row,1,13); 
		      	setBottomLine(xlsheet,row,1,13);
		     }  
		     row++;                        
	      //  alert(row)
	        if (tmpRegno=="")
	        {   
	        	//xlsheet.Cells(row, 1).Value =paregno;    
	            xlsheet.Cells(row, 1).Value =bedcode;//bed code
	            xlsheet.Cells(row, 2).Value =name; //patient name
	            xlsheet.Cells(row, 3).Value =diag;
	            
	            //xlsheet.Cells(row, 4).Value =patdob; 
	            xlsheet.Cells(row, 4).Value =orddate;
	            
	            patTotal=patTotal+1;
	          	//cellEdgeRightLine(xlsheet,row,1,13)
	        }
	        else
	        {if (paregno!=tmpRegno)
	            {   //row=row+1;
	            
	            xlsheet.Cells(row, 1).Value =bedcode;//bed code
	            xlsheet.Cells(row, 2).Value =name; //patient name
	            xlsheet.Cells(row, 3).Value =diag;
	            
	            //xlsheet.Cells(row, 4).Value =patdob; 
	            xlsheet.Cells(row, 4).Value =orddate; 
	            
	            patTotal=patTotal+1;
	            //cellEdgeRightLine(xlsheet,row,1,13)
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
	        //xlsheet.Cells(row, 13).Value =action; //ҽ����ע
	        xlsheet.Cells(row, 13).Value=sprice		//����
	        //xlsheet.Cells(row, 14).Value=sumprice	//�ϼ�
	        
		    //cellEdgeRightLine(xlsheet,row,1,13)
	        SetWarp(xlsheet,row,1,13)
	       // setBottomLine(xlsheet,row,4,9)
	        tmpRegno=paregno;
	    }
	        setBottomLine(xlsheet,row,1,13)
    } //2007-04-17
	
    row+=1;
	//�ܼ�
    xlsheet.Cells(row,1).value=t['SUM_PAT']+patTotal
    //xlsheet.Cells(row,2).value=patTotal;
    xlsheet.Cells(row,12).value="�ܽ��:"
    xlsheet.Cells(row,13).value=sumamt.toFixed(2)
       
    row+=2;
    xlsheet.Cells(row,1).value=t['PRINT_USER']+session['LOGON.USERNAME']
    xlsheet.Cells(row,4).value=t['ADJ_USER']
    xlsheet.Cells(row,6).value=t['DISPEN_USER']
    xlsheet.Cells(row,11).value=t['REC_USER']+"             "+gPhaCnt
    
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
	   // �в�ҩ��ӡ for  ������ҽԺ ;   created by lq  ;2008/03/05
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
      var tmpsp=0 //ͬһ�����ܽ��
      var tmpno="" //������
      var tmpid="" //����ҽ����
      var startcol=1
      var buttonrow=0
      var nextrow=""    //��һ������ʼ��
      var zrow=0 //ͬһ��inci�к�
      var hz=1
      var onepage=16 //һҳ�������
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
      
     //-------�Զ���ֽ�� lq 
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
	        alert("�޷�ȡ�ô�ӡ����!��鿴ҩƷ����Ƿ�ƥ��");
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
         var qty     =ss[13]//����
          //var uom     =ss[16] 
         var priority=ss[34]
         var facotor =ss[38]
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
         var dex=Instruc.indexOf("��")
         if (dex>-1){var tmptype="@"}
         else{var tmptype=""}
         
         
         var dexgc=Instruc.indexOf("�೦")
         if (dexgc>-1){var gc=1}
         else{var gc=0}
         
         
         var dexwy=Instruc.indexOf("��")
         if (dexwy>-1){var wy=1}
         else{var wy=0}
         
         
         
         var dexnj=Instruc.indexOf("Ũ��")
         if (dexnj>-1){var nj=1}
         else{var nj=0}
         
          
         var ordcat  =ss[48]
         if ((ordcat=="266")||(ordcat=="267")||(ordcat=="277")||(ordcat=="278")||(ordcat=="289")||(ordcat=="291"))
         
         {qty=qty+"( ! )";
          bt="    (  ����  )"}
          
   
          
         if((ordcat=="268")||(ordcat=="279")||(ordcat=="290"))
         {
	       qty=qty+"( ! )";
           bt="    (  ����  )"  
          }
   
         

         
         
         zrow=zrow+1
         
         if ((tmpno==prescno)&&(i>1)&&(tmpid==relateid))
         {
	        startcol=startcol+3 
	        startrow=tmpfalg-2 //ͬһ����������
	        
	        if (zrow%4==0)  //ÿ�ĸ�ҩ����
	        {
		        startcol=1
		        startrow=startrow+1   
		    } 
	      }

	      if ((tmpno!=prescno)&&(tmpid!=relateid)&&(i!=1))
          {
	        startrow=nextrow //������һ��������ʼ��
	        startcol=1
	        hz=hz+1
	      
	      }
	      
		  if ((tmpno!=prescno)&&(tmpid!=relateid))
		  {
			zrow=0
			if (gc==1){bt=bt+" "+"(  �೦  )"}
            if (wy==1){bt=bt+" "+"(  ����  )"}
            if (nj==1){bt=bt+" "+"(  Ũ��  )"}

            setBottomLine(xlsheet,startrow-1,1,12);
 
            xlsheet.Cells(startrow-3, 5).Value="��������ҽԺ��ҩ����"+bt
            xlsheet.Cells(startrow-2, 1).Value="����:"+admloc+"  "+"����:"+getDesc(ward)+"  "+"�ǼǺ�:"+pano+"  "+"����:"+bed+"  "+"����:"+paname+"  "+"����:"+old
	        xlsheet.Cells(startrow-1, 1).Value="ҽ��:"+doctor+"  "+"���:"+diag+"  "+"��ע:"+notes
	        //xlsheet.Cells(startrow-1, 9).Value="ҽ��ʱ��:"
	        //xlsheet.Cells(startrow-1, 10).Value=orddate+" "+sattime
	        xlsheet.Cells(startrow, 1).Value = "�ܼ���:"+facotor 
	        setBottomLine(xlsheet,startrow+1,1,12);
	        //xlsheet.Cells(startrow, 2).Value = paname
	        xlsheet.Cells(startrow, 3).Value = "�ռ���:"+pc 
            //xlsheet.Cells(startrow, 4).Value = pano
            xlsheet.Cells(startrow, 8).Value = "��ʽ:"+remark
            //xlsheet.Cells(startrow, 6).Value = remark
            xlsheet.Cells(startrow, 6).Value = "һ������:" +fre
            //xlsheet.Cells(startrow, 8).Value = fre
            xlsheet.Cells(startrow, 10).Value="�÷�:"+Instruc
            //xlsheet.Cells(startrow, 11).Value=Instruc
            xlsheet.Cells(startrow,1).Borders(7).LineStyle = 1
            xlsheet.Cells(startrow,12).Borders(10).LineStyle = 1
            xlsheet.Cells(startrow+1, 1).Value= "��������:"+tmptype
	        //xlsheet.Cells(startrow+1, 2).Value= ""
	        xlsheet.Cells(startrow+1, 3).Value= "����ʱ��:"+orddate+"  "+"ʱ��:" +sdate+"  "+"��"+"  "+xdate
	        //xlsheet.Cells(startrow+1, 5).Value="ʱ��" +sdate+"��"+xdate
	        //xlsheet.Cells(startrow+1, 7).Value="��ע:"
	   
	        //xlsheet.Cells(startrow+1, 9).Value= "��ֹ:"
	        //xlsheet.Cells(startrow+1, 10).Value=xdate
	        }
            xlsheet.Cells(startrow+1,1).Borders(7).LineStyle = 1
            xlsheet.Cells(startrow+1,12).Borders(10).LineStyle = 1

            xlsheet.Cells(startrow+2, startcol).Value= inci+" "+qty
            //xlsheet.Cells(startrow+2, startcol+2).Value=qty
            xlsheet.Cells(startrow+2,1).Borders(7).LineStyle = 1
            xlsheet.Cells(startrow+2,12).Borders(10).LineStyle = 1
            
            var tmpfalg=startrow+2 //ͬһ����ҩƷ��ʼ�к�
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
               //xlsheet.Cells(startrow+10, 1).Value= "����˵��:"
	           //xlsheet.Cells(startrow+10, 2).Value= Instruc 
	           //xlsheet.Cells(startrow+10, 10).Value= "����:" 
	           //xlsheet.Cells(startrow+10, 12).Value= facotor 
	           xlsheet.Cells(startrow+10,1).Borders(7).LineStyle = 1
	           xlsheet.Cells(startrow+10,12).Borders(10).LineStyle = 1

	           xlsheet.Cells(startrow+11, 1).Value="�����ϼ�:"
	           xlsheet.Cells(startrow+11, 2).Value= price  
	           xlsheet.Cells(startrow+11, 7).Value="�ܽ��:" 
	           xlsheet.Cells(startrow+11, 8).Value= (price*parseFloat(facotor)).toFixed(2)
	           //xlsheet.Cells(startrow+11, 10).Value="ҽ��:"    
	           //xlsheet.Cells(startrow+11, 12).Value=doctor
	           xlsheet.Cells(startrow+11,1).Borders(7).LineStyle = 1
	           xlsheet.Cells(startrow+11,12).Borders(10).LineStyle = 1
	           setBottomLine(xlsheet,startrow+11,1,12);
	           xlsheet.Cells(startrow+12, 1).Value="������:"  
	           xlsheet.Cells(startrow+12, 2).Value=session['LOGON.USERNAME']
	           xlsheet.Cells(startrow+12, 4).Value="����:"
	           xlsheet.Cells(startrow+12, 6).Value="����:"
	           xlsheet.Cells(startrow+12, 8).Value="��ӡʱ��:"+getPrintDateTime()
  	           //setBottomLine(xlsheet,startrow+13,1,12);
	           //xlsheet.Cells(startrow+14, 1).Value="����:"+admloc+"  "+"����:"+paname+"  "+"����:"+bed+"  "+"������:"+price+"  "+"����:"+facotor+"  "+"�ܽ��:"+(price*parseFloat(facotor)).toFixed(2)
   	           var tmpno=prescno
               var tmpid=relateid
          
	           //var startrow=startrow+17
	        
	          
	           var dexzj=remark.indexOf("��")
	           if (dexzj<0){var zj=1}
	           
               var startrow=hz*onepage+1

	           if (zj!=0)
	           {
	              var startcol1=1
	              var h=0 //��ʼ���ǩ
	              hz=hz+1
	              //alert(startrow)

	              //for (var n=1;n<=parseInt(facotor)*2;n++)
	              //{
	                // setBottomLine(xlsheet,startrow-1,1,12)

	                 xlsheet.Cells(startrow, startcol1+2).Value = "��������ҽԺ"
	                 xlsheet.Cells(startrow+1, startcol1+2).Value = "��ҩ��ҩ֤"
	                 setBottomLine(xlsheet,startrow+1,1,6)
	                 xlsheet.Cells(startrow+2, startcol1).Value ="��ע:"+notes
	                 xlsheet.Cells(startrow+2, startcol1+3).Value ="�÷�:"+Instruc
	                 xlsheet.Cells(startrow+3, startcol1).Value ="��ҩʱ��:"+sdate+"��"+xdate
	                 xlsheet.Cells(startrow+4, startcol1).Value ="�ܼ���:"+facotor 
	                 xlsheet.Cells(startrow+4, startcol1+3).Value ="�ռ���:"+pc
	                 xlsheet.Cells(startrow+5, startcol1).Value ="��ʽ:"+remark
	                 setBottomLine(xlsheet,startrow+5,1,6)
	                 xlsheet.Cells(startrow+6, startcol1).Value = "�ǼǺ�:"+" "+pano
	                 xlsheet.Cells(startrow+6, startcol1+3).Value ="������:"+" "+pano
	                 xlsheet.Cells(startrow+7, startcol1).Value = "����:"+" "+paname
	                 xlsheet.Cells(startrow+7, startcol1+3).Value = "����:"+" "+bed
	                 xlsheet.Cells(startrow+8, startcol1).Value = "����:"+admloc
                     xlsheet.Cells(startrow+8, startcol1+3).Value = "����:"+getDesc(ward)
                     xlsheet.Cells(startrow+9, startcol1).Value = "���:"+"        "+"��ҩ:"                     
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
	              
	               nextrow= hz*onepage+4 //����ǩһҳ32 ��
               }
              
               if (zj==0){//var nextrow=startrow+4
               nextrow=hz*onepage+4} //һҳ17��
            }
	    }

      xlsheet.printout();
      SetNothing(xlApp,xlBook,xlsheet); 
    }
     
}
function PrintZCYTIAOMA(phac,phatype)
{  
    var tmpno="" //������
    var tmpid="" //����ҽ����


    
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
	        alert("�޷�ȡ�ô�ӡ����!��鿴ҩƷ����Ƿ�ƥ��"+phatype);
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
	     Bar.Title="������ҽԺ��ҩ֤"
	     //Bar.Device="pdfFactory Pro";
	     Bar.Device="TIAOMA";
	     Bar.PageWidth=15;
	     Bar.HeadFontSize=12;
	     Bar.BarFontSize=20;
	     Bar.BarLeftMarg=0;
	     Bar.PageLeftMargine=0;
	     Bar.PageItmStr=str;
	     Bar.PageItmStr="��ҩ֤" + "^" + "��7��" + "^" + "250ml" + "^" + "00005678" + "^" + "����" + "^" + "3��" + "^" + "�β�����ʿվ"

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
    //�ȴ���ϸ�ִ����?2007-8-6
    
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
    var patTotal=0;		//�ܼ�����
                       
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
	//�ܼ�
    xlsheet.Cells(row,1).value=t['SUM_PAT']
    xlsheet.Cells(row,2).value=patTotal;
       
    row+=2;
    xlsheet.Cells(row,1).value=t['PRINT_USER']+session['LOGON.USERNAME']
    xlsheet.Cells(row,3).value=t['ADJ_USER']
    xlsheet.Cells(row,5).value=t['DISPEN_USER']
    xlsheet.Cells(row,8).value=t['REC_USER']
    
    //��ӡ����
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
    //�ܼ�
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
	//�Զ���������  lq
	for (var i=c1;i<=c2;i++)
	{
	  objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).WrapText  =  true//�Զ�����
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