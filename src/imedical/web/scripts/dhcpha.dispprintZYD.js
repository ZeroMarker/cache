
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
      //医生科室发药
      PrintHz(phac,phatype)  ; 
      return ;
    }
    
       //打印方式
    var objTotalPrn=document.getElementById("TotalPrn");    //汇总
    var objDetailPrn=document.getElementById("DetailPrn") ; //明细
    
    
    switch (phatype) {
       
        case "ZJ":
        
            if(objTotalPrn.value!=0){PrintHz(phac,phatype) ;	 } ; 
            if(objDetailPrn.value!=0){PrintPJ(phac,phatype);     } ; 
            //以下是默认
            if((objTotalPrn.value==0)&&(objDetailPrn.value==0))
            {
	         PrintHz(phac,phatype) ;//发药单  //(针剂)
	         PrintHz(phac,phatype) ;
                 PrintPJ(phac,phatype); //摆药单   
             }
           	break;
        case "DSY":
	        //PrintDSY(phac,phatype)  ; 
            if(objTotalPrn.value!=0){PrintHz(phac,phatype) ;	 } ; 
            if(objDetailPrn.value!=0){PrintPJ(phac,phatype); 	 } ; 
            //以下是默认
            if((objTotalPrn.value==0)&&(objDetailPrn.value==0))
            {
	         PrintHz(phac,phatype) ;//发药单  //(大输液)
	         PrintHz(phac,phatype) ;
                 PrintPJ(phac,phatype); //摆药单
             }
           	break;
        case "JMY":
           	if(objTotalPrn.value!=0){PrintHz(phac,phatype) ;	 } ; 
            if(objDetailPrn.value!=0){PrintPJ(phac,phatype); 	 } ; 
            //以下是默认
            if((objTotalPrn.value==0)&&(objDetailPrn.value==0))
            {
	         PrintHz(phac,phatype) ;//发药单  
	         PrintHz(phac,phatype) ;
                 PrintPJ(phac,phatype); //摆药单
             }
           	break;
        case "QT":
           	if(objTotalPrn.value!=0){PrintHz(phac,phatype) ;	 } ; 
            if(objDetailPrn.value!=0){PrintPJ(phac,phatype); 	 } ; 
            //以下是默认
            if((objTotalPrn.value==0)&&(objDetailPrn.value==0))
            {
	         PrintHz(phac,phatype) ;//发药单  
	         PrintHz(phac,phatype) ;
                 PrintPJ(phac,phatype); //摆药单
             }
           	break;  
        case "ZYYP":
            PrintZCY(phac,phatype) ;//中草药发药单
            //PrintZCYTIAOMA(phac,phatype);//草药条码
            break; 

        case "WYY":
           	if(objTotalPrn.value!=0){PrintHz(phac,phatype) ;	 } ; 
            if(objDetailPrn.value!=0){PrintPJ(phac,phatype); 	 } ; 
            //以下是默认
            if((objTotalPrn.value==0)&&(objDetailPrn.value==0))
            {
	         PrintHz(phac,phatype) ;//发药单  
	         PrintHz(phac,phatype) ;
                 PrintPJ(phac,phatype); //摆药单
             }
           	break;
         case "ZYJ":
           	if(objTotalPrn.value!=0){PrintHz(phac,phatype) ;	 } ; 
            if(objDetailPrn.value!=0){PrintPJ(phac,phatype); 	 } ; 
            //以下是默认
            if((objTotalPrn.value==0)&&(objDetailPrn.value==0))
            {
	         PrintHz(phac,phatype) ;//发药单  
	         PrintHz(phac,phatype) ;
                 PrintPJ(phac,phatype); //摆药单
             }
           	break;
         case "KFY":
           	if(objTotalPrn.value!=0){PrintHz(phac,phatype) ;	 } ; 
            if(objDetailPrn.value!=0){PrintPJ(phac,phatype); 	 } ; 
            //以下是默认
            if((objTotalPrn.value==0)&&(objDetailPrn.value==0))
            {
	         PrintHz(phac,phatype) ;//发药单  
	         PrintHz(phac,phatype) ;
                 PrintPJ(phac,phatype); //摆药单
             }
           	break;
           	
         case "WSGD":
           	if(objTotalPrn.value!=0){PrintHz(phac,phatype) ;	 } ; 
            if(objDetailPrn.value!=0){PrintPJ(phac,phatype); 	 } ; 
            //以下是默认
            if((objTotalPrn.value==0)&&(objDetailPrn.value==0))
            {
	         PrintHz(phac,phatype) ;//发药单  
	         PrintHz(phac,phatype) ;
                 PrintPJ(phac,phatype); //摆药单
             }
           	break;
           	
         case "ZCY":
           	if(objTotalPrn.value!=0){PrintHz(phac,phatype) ;	 } ; 
            if(objDetailPrn.value!=0){PrintPJ(phac,phatype); 	 } ; 
            //以下是默认
            if((objTotalPrn.value==0)&&(objDetailPrn.value==0))
            {
	         PrintHz(phac,phatype) ;//发药单  
	         PrintHz(phac,phatype) ;
                 PrintPJ(phac,phatype); //摆药单
             }
           	break; 	
        default:
        alert("药品类别"+phatype+"设置不匹配,请核实!")
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
       
        var DateRange=formatDate2(dispsd)+"--"+formatDate2(disped);
        var DispNo=tmparr[9] ;
        var DisTypeDesc=tmparr[10] ;
        var docloc=tmparr[13] ;
		
        if (gPrnpath=="") 
        {
        	alert(t["CANNOT_FIND_TEM"]) ;
            return ;
       	}
                
        var Template=gPrnpath+"STP_zjhzd_ZYD.xls";
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
        
        if (gTotalCnt>0) 
        {
	        var objreflag=document.getElementById("RePrintFlag")
			var reflag=""//补打标志
			if (objreflag.value==1){reflag="(补打)";}
	        xlsheet.Cells(1, 1).Value = gHospname  //+ getDesc(PhaLoc)+DisTypeDesc+t['DISP_BILL'];  //hospital description
	        xlsheet.Cells(2, 1).Value = t['DISP_BILL']+reflag
	        xlsheet.Cells(3, 1).Value = t['WARD']+getDesc(WardName)
	        xlsheet.Cells(3, 3).Value = t['DISP_NO'] +DispNo
	        xlsheet.Cells(3, 7).Value = t['DISPDATE']+DateRange
	        //xlsheet.Cells(3, 1).Value = t['PHARMACY']+ getDesc(PhaLoc) +"        "+t['DISP_NO'] +DispNo +"       "+t['DISPDATE']+DateRange
	        xlsheet.Cells(4, 1).Value = t['PHARMACY']+ getDesc(PhaLoc)
	        xlsheet.Cells(4, 3).Value = t['DISPCAT'] + DisTypeDesc
	        xlsheet.Cells(4, 7).Value = t['PRINTDATE']+ formatDate2(getPrintDate())+" "+getPrintTime()
	       
	        //xlsheet.Cells(4, 1).Value = t['DISPCAT'] + DisTypeDesc + "         " + t['PRINTDATE']+ formatDate2(getPrintDate())+" "+getPrintTime()+"         "+t['WARD']+getDesc(WardName)
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
                        //var tmpincidesc=ss[1].split("(")
                        //incidesc=tmpincidesc[0];
                        var tmpitemdesc=ss[1].split("(");
	                    var incidesc=tmpitemdesc[0];
	                    var orditemdesc1=tmpitemdesc[1];
	                    if (tmpitemdesc.length==3){incidesc=incidesc+"("+orditemdesc1}
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
      
function PrintPJOld(phac,phatype)
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
                       
    getDispDetail(phac) //取发药明细信息

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
    var obj=document.getElementById("mListDispDetail")
    if (obj) exeDetail=obj.value;
    else exeDetail=""
    
    if ((parseInt(gDetailCnt)<startno)&&(startno!="")&&(SelRowFlag==1)){
	    alert("起始值大于总记录数")
	    return;}
    
    //-------
    //置表头
    SetHead (xlsheet,0,gHospname,reflag,PhaLoc,DispNo,DateRange,DisTypeDesc,WardName,paregno,name,bedcode,patdob) 
    setBottomLine(xlsheet,5,1,7)
    row=startNo; //发药信息开始行
    SetTitle(xlsheet,row)
    
	cellEdgeRightLine(xlsheet,row,1,7)
	setBottomLine(xlsheet,row,1,7)
	

    
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
	        var priority=datas[33];
	        var drugform=datas[38];	        
	        var doctor=datas[8];
	        var action=datas[34];
	        //alert(doctor);
	        if ((tmpRegno!="")&&(paregno!=tmpRegno) )
	         { 
		      	setBottomLine(xlsheet,row,1,7);
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
	          	cellEdgeRightLine(xlsheet,row,1,7)
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
	            setBottomLine(xlsheet,row+5,1,7)
	             //置表头2
	            xlsheet.Cells(row+2, 1).Value ="("+priority+")"
	            xlsheet.Cells(row+2, 1).Font.Size = 14
	            SetHead2(xlsheet,row+5,paregno,name,bedcode,patdob,sex) 
	            SetTitle(xlsheet,row+6)
	            
	            cellEdgeRightLine(xlsheet,row+6,1,7)
	            setBottomLine(xlsheet,row+6,1,7)
	            row=row+7}
	        }
	        
	        xlsheet.Cells(row, 1).Value =orditemdesc; //orderitem description 
			xlsheet.Cells(row, 2).Value =spec;
			//xlsheet.Cells(row, 3).Value =drugform;
			xlsheet.Cells(row, 3).Value =qty+uom;			
			xlsheet.Cells(row, 4).Value =dosqty ;			
			xlsheet.Cells(row, 5).Value =freq ;			
	        xlsheet.Cells(row, 6).Value =instruction;
	        xlsheet.Cells(row, 7).Value =amt; //医嘱备注
		    cellEdgeRightLine(xlsheet,row,1,7)
	        SetWarp(xlsheet,row,1,7)
	        tmpRegno=paregno;
	        
	        if (phatype=="JMY"){tmpRegno="1"}  
	    }
	        setBottomLine(xlsheet,row,1,7)
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
}
function SetButton (xlsheet,row,doctor)
{
	xlsheet.Cells(row,1).value="医师:"+doctor+"       "+"调剂人:"+"       "+"审核人:"+"       "+t['REC_USER']+"       "+t['PRINT_USER']+session['LOGON.USERNAME']
	//xlsheet.Cells(row,2).value="审核人:"
	//xlsheet.Cells(row,3).value=t['PRINT_USER']+session['LOGON.USERNAME']
    //xlsheet.Cells(row,5).value=t['REC_USER']
    //xlsheet.Cells(row,7).value="总金额:"+sumamt.toFixed(2)
	
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
function PrintZCY(phac,phatype)
{    
	   // 中草药打印 for  北京中医院 ;   created by lq  ;2008/03/05            
	  getDispDetail(phac);
      if (gDetailCnt>0)  
     {  

        var startrow=3
        var startcol=1
        var tmpsp=0 //同一处方总金额
        var tmpno="" //处方号
        var tmpid="" //关联医嘱号
        var startcol=1
        var buttonrow=0
        var nextrow=""    //下一处方开始行
        var zrow=0 //同一处inci行号

        if (gPrnpath=="") 
          {
    	     alert(t["CANNOT_FIND_TEM"]) ;
              return ;                
          }
         
        var Template=gPrnpath+"STP_ZCYPrint.xls";
        var xlApp = new ActiveXObject("Excel.Application");
        var xlBook = xlApp.Workbooks.Add(Template);
        var xlsheet = xlBook.ActiveSheet ;
   

        if (xlsheet==null) 
        {       
    	    alert(t["CANNOT_CREATE_PRNOBJ"]);
            return ;                
        } 
        setBottomLine(xlsheet,2,1,12);
	    for (var i=1;i<=gDetailCnt;i++)
	    {
		  var exe;
          var obj=document.getElementById("ListDetailZCY") ;
          if (obj) exe=obj.value;
          else exe=""
    
          var result=cspRunServerMethod(exe,gProcessID,i)
          if (result=="")
          {alert("无法取得打印数据!请查看药品类别是否匹配");
          return;}
          var ss=result.split("^")
          var paname  =ss[1]
          var pano    =ss[0]
          var admloc  =ss[6]
          var bed     =ss[5]
          var sdate   =ss[40]
          var xdate   =ss[41]
          var Instruc =ss[37]
          if  (Instruc=="")
          {
	          alert("处方表没有插入信息,请核实")
	          return;}
          var inci    =ss[10]    
          var qty     =ss[13]//剂量
          //var uom     =ss[16] 
          var priority=ss[34]
          var facotor =ss[38]
          var prescno =ss[7]
          var price   =ss[45]
          var doctor  =ss[8]
          var relateid=ss[22]
          var orddate =ss[32]
          var ward    =ss[4]
          var notes   =ss[42]
          var priority=ss[36]
          var sattime =ss[44]
          var oeqty   =ss[39]
          var fre     =ss[43]
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
	        
	      }
	     
	     
			
			if ((tmpno!=prescno)&&(tmpid!=relateid)){
				zrow=0
            setBottomLine(xlsheet,startrow-1,1,12);
            xlsheet.Cells(startrow-2, 5).Value=gHospname
	        xlsheet.Cells(startrow-1, 9).Value="医嘱时间:"
	        xlsheet.Cells(startrow-1, 10).Value=orddate+" "+sattime
	        xlsheet.Cells(startrow, 1).Value = "姓名:"+" "+paname 
	        setBottomLine(xlsheet,startrow,1,12);
	        //xlsheet.Cells(startrow, 2).Value = paname
	        xlsheet.Cells(startrow, 3).Value = "登记号:"+" "+pano  
            //xlsheet.Cells(startrow, 4).Value = pano
            xlsheet.Cells(startrow, 5).Value = "科室:"+" "+admloc
            //xlsheet.Cells(startrow, 6).Value = admloc
            xlsheet.Cells(startrow, 7).Value = "病床号:"+" "+bed 
            xlsheet.Cells(startrow, 8).Value = bed
            xlsheet.Cells(startrow, 9).Value="执行:"
            xlsheet.Cells(startrow, 10).Value= sdate
            xlsheet.Cells(startrow,1).Borders(7).LineStyle = 1
            xlsheet.Cells(startrow,12).Borders(10).LineStyle = 1
            xlsheet.Cells(startrow+1, 1).Value= "处方:"
	        xlsheet.Cells(startrow+1, 2).Value= notes
	        xlsheet.Cells(startrow+1, 9).Value= "截止:"
	        xlsheet.Cells(startrow+1, 10).Value=xdate}
            xlsheet.Cells(startrow+1,1).Borders(7).LineStyle = 1
            xlsheet.Cells(startrow+1,12).Borders(10).LineStyle = 1
           
            xlsheet.Cells(startrow+2, startcol).Value= inci+" "+qty
            //xlsheet.Cells(startrow+2, startcol+2).Value=qty
            xlsheet.Cells(startrow+2,1).Borders(7).LineStyle = 1
            xlsheet.Cells(startrow+2,12).Borders(10).LineStyle = 1

	    
            var tmpfalg=startrow+2 //同一处方药品开始行号

            if((tmpno!=prescno)&&(tmpid!=relateid)){

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
            xlsheet.Cells(startrow+10, 1).Value= "处方说明:"
	        xlsheet.Cells(startrow+10, 2).Value= Instruc 
	        xlsheet.Cells(startrow+10, 10).Value= "剂数:" 
	        xlsheet.Cells(startrow+10, 12).Value= facotor 
	        xlsheet.Cells(startrow+10,1).Borders(7).LineStyle = 1
	        xlsheet.Cells(startrow+10,12).Borders(10).LineStyle = 1
	        xlsheet.Cells(startrow+11, 1).Value="单付合计:"
	        xlsheet.Cells(startrow+11, 2).Value= price  
	        xlsheet.Cells(startrow+11, 7).Value="总金额:" 
	        xlsheet.Cells(startrow+11, 8).Value= (price*parseFloat(facotor)).toFixed(2)
	        xlsheet.Cells(startrow+11, 10).Value="医生:"    
	        xlsheet.Cells(startrow+11, 12).Value=doctor
	        xlsheet.Cells(startrow+11,1).Borders(7).LineStyle = 1
	        xlsheet.Cells(startrow+11,12).Borders(10).LineStyle = 1
	        setBottomLine(xlsheet,startrow+11,1,12);
	        xlsheet.Cells(startrow+12, 1).Value="操作人:"  
	        xlsheet.Cells(startrow+12, 2).Value=session['LOGON.USERNAME']
	        xlsheet.Cells(startrow+12, 4).Value="调剂:"
	        xlsheet.Cells(startrow+12, 6).Value="复核:"
	        xlsheet.Cells(startrow+12, 9).Value="打印时间:"+getPrintDateTime()
	              	        
	


	        
	        setBottomLine(xlsheet,startrow+13,1,12);
	        xlsheet.Cells(startrow+14, 1).Value="科室:"+admloc+"  "+"姓名:"+paname+"  "+"床号:"+bed+"  "+"单付价:"+price+"  "+"剂数:"+facotor+"  "+"总金额:"+(price*parseFloat(facotor)).toFixed(2)

	        
		    
	        
	        var tmpno=prescno
            var tmpid=relateid
	        var startrow=startrow+17
	       
	       if (priority!="出院带药"){
	        var startcol1=1
	        var h=0 //开始打标签
	        for (var n=1;n<=parseInt(facotor)*2;n++)
	            {
            setBottomLine(xlsheet,startrow-1,1,12);
            
            xlsheet.Cells(startrow, startcol1).Value = "病区"+" "+getDesc(ward)
            
		    xlsheet.Cells(startrow+1, startcol1).Value = "床号"+" "+bed

		    xlsheet.Cells(startrow+2, startcol1).Value = "登记号"+" "+pano
	
		    xlsheet.Cells(startrow+3, startcol1).Value = "姓名"+" "+paname
	
		    xlsheet.Cells(startrow+4, startcol1).Value = "频次"+" "+fre
		
		    xlsheet.Cells(startrow+5, startcol1).Value = "剂量"+" "+oeqty

		    xlsheet.Cells(startrow+6, startcol1).Value = "用法"+" "+Instruc

		    xlsheet.Cells(startrow+7, startcol1).Value = "日期"+" "+getRelaDate2(orddate,h)

		    //if ((n%2==1)&&(n!=1)) {h=h+1}
            if ((n%2==0)&&(n!=1)) {h=h+1}
		    
		    startcol1=startcol1+3
		    buttonrow=startrow+8
		    
		     if (n%4==0){		 
		          startrow=buttonrow+2
		          startcol1=1
		          }
		    
		    		   
	            }
	        var startrow=startrow+13
	        var nextrow=startrow
	       
             }
	        
            }
            
            if (priority=="出院带药"){var nextrow=startrow}
         
	    }
	    

     }           
     xlsheet.printout();
     SetNothing(xlApp,xlBook,xlsheet); 
     
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
function SetWarp(objSheet,row,c1,c2)
{
	//自动换行设置
	for (var i=c1;i<=c2;i++)
	{
	  objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).WrapText  =  true//自动换行
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
function PrintPJ(phac,phatype)
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

document.body.onload=BodyLoadHandler;