/// dhcpha.printphareturn.js
function BodyLoadHandler()
{
	var obj=document.getElementById("PhaRetNo")
	if (obj)
	{
		var phareturnno=obj.value;
	
		if (phareturnno!="")
		{	
		    flag=phareturnno.substr(0,2)
		    if (flag=="TR")
		     {PrintTotalbeforRet(phareturnno);
		     return;}
            //1.-------------------------------------------
            
		    tmpstr=phareturnno.split("@")
		    if (tmpstr[0]=="ALL")
		    {PrintRetTotal(tmpstr[1]);
		     return;}           //N个申请单一起审核
		    
		    //2.------------------------------------------
		    
			//PrintRet(phareturnno);
			//PrintRetAH(phareturnno)
			//PrintRetSG(phareturnno)
			//PrintRetHX(phareturnno);
			//PrintRetHXY(phareturnno)
			PrintRetBJFC(phareturnno)
		  
		}
	}
	var obj=document.getElementById("RetReqNo")
	if(obj)
	{
		var retreqno=obj.value;
		if(retreqno!="")
		{
			var arrayReqNo=retreqno.split("^")
			for(i=0;i<arrayReqNo.length;i++)
			{
			   PrintRetReq(arrayReqNo[i])
			}
		}
	}
	//window.close();
}

function PrintTotalbeforRet(reqnostr)
{
	
	   ///Description:退药前N个申请单汇总打印
	   ///Creator:lq 08-11-21
		var prnpath=getPrnPath();
		if (prnpath=="") {
			alert(t['CANNOT_FIND_PRNPATH']) ;
			return ;}
			
		var Template=prnpath+"STP_PhaRet_Total.xls";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var xlsheet = xlBook.ActiveSheet ;	
		var startrow=3 ; //begin to print from the 7th row 
		if (xlsheet==null)
			{ alert(t['CANNOT_CREATE_PRNOBJECT']) ;
			return ;		  }
		
		
	   var serialNo=0
	

	  var obj=document.getElementById("GetRetrqItmTotal") ;
      if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	  var str=cspRunServerMethod(encmeth,reqnostr) ;
	  
	  var tmp=str.split("^")
	  rowcount=tmp[0]
	  pid=tmp[1]

	  var inci=""
	  do {
	  var obj=document.getElementById("ListRetrqItmTotal") ;
      if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	  var str=cspRunServerMethod(encmeth,pid,inci) ;
	  if (str!="")
	     {
	        var tmp=str.split("^")
	        inci=tmp[0];
	        recloc=tmp[1];
	        dept=tmp[2];
	        desc=tmp[5];
	        uom=tmp[6];
	        qty=tmp[7];
            serialNo++;
            
            xlsheet.Cells(startrow+serialNo,1)=desc;
            xlsheet.Cells(startrow+serialNo,2)=uom;
            xlsheet.Cells(startrow+serialNo,3)=qty;
 

	     }
	  else(inci="")   
	  
	  }while(inci!="")
	
	
	xlsheet.Cells(1,1)=recloc+"退药清单"
	xlsheet.Cells(2,1)=dept+"     "+t['PRINTDATETIME']+formatDate2(getPrintDate())+" "+getPrintTime();
	setBottomLine(xlsheet,2,1,3)
	setBottomLine(xlsheet,startrow+serialNo,1,3)
	xlsheet.Cells(startrow+serialNo+1,1)="退药人:"+"               "+"收药人:";
	

    xlsheet.printout();
    xlApp=null;
	xlsheet=null;
	xlBook.Close(savechanges=false);
	
	PrintReqitm(pid)  
	  
}
function PrintReqitm(pid)
{
	   
	///Description:退药前打印退药申请单明细
	///Creator:LQ  2008-11-22
	
	var prnpath=getPrnPath();
		if (prnpath=="") {
			alert(t['CANNOT_FIND_PRNPATH']) ;
			return ;}
			
		var Template=prnpath+"STP_PhaReqitm.xls";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var xlsheet = xlBook.ActiveSheet ;	
		var startrow=3 ; //begin to print from the 7th row 
		if (xlsheet==null)
			{ alert(t['CANNOT_CREATE_PRNOBJECT']) ;
			return ;		  }

    var startrow=2
    var currrow=startrow
    var lastreq="";
   
    for ( var h=1;h<=rowcount;h++)
    {
	  
	  	var obj=document.getElementById("ListRetrqItm") ;
        if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	    var str=cspRunServerMethod(encmeth,pid,h) ;
	    var tmpstr=str.split("^")
	    var reqno=tmpstr[0]
	    var recloc=tmpstr[5]
	    var dept=tmpstr[6]
	    var patno=tmpstr[1]
	    var patname=tmpstr[2]
	    var bed =tmpstr[3]
	    var desc=tmpstr[9]
	    var uom =tmpstr[10]
	    var qty =tmpstr[11]
	     
	    if (lastreq!== reqno){
		    
		        currrow=currrow+1
		        
		        xlsheet.Cells(currrow,1)="申请单号:"+reqno+"   "+dept+"   "+t['PRINTDATETIME']+formatDate2(getPrintDate())+" "+getPrintTime();
		        
		        currrow=currrow+1
		        	   
			    xlsheet.Cells(currrow,1)="登记号";
			    xlsheet.Cells(currrow,2)="姓名";
			    xlsheet.Cells(currrow,3)="床位";
			    xlsheet.Cells(currrow,4)="产品名";
			    xlsheet.Cells(currrow,5)="单位";
			    xlsheet.Cells(currrow,6)="数量";
		        setBottomLine(xlsheet,currrow,1,6)
			    currrow=currrow+1
		    }
	      
	    lastreq = reqno
	    
	
	    xlsheet.Cells(currrow,1)=patno;
	    xlsheet.Cells(currrow,2)=patname;
	    xlsheet.Cells(currrow,3)=bed;
	    xlsheet.Cells(currrow,4)=desc;
	    xlsheet.Cells(currrow,5)=uom;
        xlsheet.Cells(currrow,6)=qty; 
        
        currrow=currrow+1
	 
    }
    
    xlsheet.Cells(1,1)=recloc
	xlsheet.printout();
    xlApp=null;
	xlsheet=null;
	xlBook.Close(savechanges=false);
	
}



function PrintRetTotal(retstr)
{
	///Description:N个申请单汇总打印
	///Creator:lq 08-11-08
	var incicode=""
	var serialNo=0
	var prnpath=getPrnPath();
	if (prnpath=="") {
		alert(t['CANNOT_FIND_PRNPATH']) ;
		return ;}
		
	var Template=prnpath+"STP_PhaRet_Total.xls";
	//var Template="E:\\"+"STP_PhaRet_Total.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	
	var startrow=3 ; //begin to print from the 7th row 
	if (xlsheet==null)
		{ alert(t['CANNOT_CREATE_PRNOBJECT']) ;
		return ;		  }
	var hospname=hospitalName();
	var obj=document.getElementById("mGetPid") ;
    if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var pid=cspRunServerMethod(encmeth,"") ;
	

	tmpstr=retstr.split("^")
	var strcnt=tmpstr.length


	for ( var h=0;h<=strcnt-1;h++)
	{
		  retno=tmpstr[h]
		  var obj=document.getElementById("GetRetTotal") ;
	      if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	      var ret=cspRunServerMethod(encmeth,retno,pid) ;
	}

	
	var obj=document.getElementById("mListRetTotal") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var incicode=""
	
	var userid=session['LOGON.USERID'];
	var username = session['LOGON.USERNAME'];  ///取当前登录人 bianshuai 2015-12-07
	
	do
	{
		var datas=cspRunServerMethod(encmeth,pid,incicode) ;
		if (datas!=""){
		    var ss=datas.split("^");
            incidesc=ss[0];
            spec=ss[1];
            qty=ss[2];
            uom=ss[3];
            incicode=ss[4];
            recloc=ss[5];
            dept=ss[6];
            price=ss[7];
            amt=ss[8];
            serialNo++;
            
            xlsheet.Cells(startrow+serialNo,1)=incidesc;
            xlsheet.Cells(startrow+serialNo,2)=uom;
            xlsheet.Cells(startrow+serialNo,3)=qty;
            xlsheet.Cells(startrow+serialNo,4)=price;
            xlsheet.Cells(startrow+serialNo,5)=amt;
            //xlsheet.Cells(startrow+serialNo,4)=uom
            }
        else 
        {incicode=""}
	}while (incicode!="");
	//xlsheet.Cells(1,1)=hospname
	xlsheet.Cells(1,1)=hospname+getDesc(recloc)+"退药清单"
	xlsheet.Cells(2,1)=t['WARD']+getDesc(dept)+"    "+t['PRINTDATETIME']+formatDate2(getPrintDate())+" "+getPrintTime();
	setBottomLine(xlsheet,2,1,5)
	setBottomLine(xlsheet,3,1,5)
	setBottomLine(xlsheet,startrow+serialNo,1,5)
	xlsheet.Cells(startrow+serialNo+1,1)="退药人:"+ username +"           "+"收药人:";
    xlsheet.printout();
    xlApp=null;
	xlsheet=null;
	xlBook.Close(savechanges=false);
	
	
}
function getPrnPath()
{
	var obj=document.getElementById("mGetPrnPath") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var prnpath=cspRunServerMethod(encmeth,'','') ;
	return prnpath
	}
function hospitalName()
{	var obj=document.getElementById("mPrtHospName") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var hospname=cspRunServerMethod(encmeth,'','') ;
	//alert("hospname:"+hospname);
	return hospname
	}
function getRetByNo(retno)
{	var obj=document.getElementById("mGetRetByNo") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var data=cspRunServerMethod(encmeth,'','',retno) ;
	return data
	}

function getRetDetail(pid,i)
{ 	var obj=document.getElementById("mListRet") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var data=cspRunServerMethod(encmeth,'','',pid,i) ;
	return data	
	}


/*----------------------------the following is printing generally ----------------------------*/
function PrintRet(retno)
{
	var prnpath=getPrnPath();
	if (prnpath=="") {
		alert(t['CANNOT_FIND_PRNPATH']) ;
		return ;
	}
	var Template=prnpath+"STP_PhaRet.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	
	var startrow=5 ; //
	if (xlsheet==null)
		{ alert(t['CANNOT_CREATE_PRNOBJECT']) ;
		return ;		  }
	var hospname=hospitalName();
	xlsheet.Cells(1,1)=hospname ;  //hospital name 
	var s=getRetByNo(retno);
	data=s.split("^") ;
	var pid=data[0] ;
	var cnt=data[1] ;
	if (pid=="") return;
	if (cnt<1) return ;
	  
	var pano,paname,bed,prescno,incidesc,uomdesc,retqty,retdate;
	for ( var i=1;i<=cnt;i++)
	{
		var tmps=getRetDetail(pid,i);
		data=tmps.split("^");
		
		pano=data[24] ;
		paname=data[25] ;
		bed=data[21] ;
		prescno=data[16] ;
		incidesc=data[23] ;
		uomdesc=data[27] ;
		retqty=data[17] ;
		retdate=data[1] ;
		recloc=data[12] ;
		
		xlsheet.Cells(startrow+i-1,1)= pano;
		xlsheet.Cells(startrow+i-1,2)= paname;
		xlsheet.Cells(startrow+i-1,3)= bed;
		xlsheet.Cells(startrow+i-1,4)=prescno ;
		xlsheet.Cells(startrow+i-1,5)=incidesc ;
		xlsheet.Cells(startrow+i-1,6)= uomdesc;
		xlsheet.Cells(startrow+i-1,7)= retqty;
		xlsheet.Cells(startrow+i-1,8)= retdate;
		setBottomLine(xlsheet,startrow+i-1,1,8)
	}
	xlsheet.Cells(3,1)=t['PHARMACY']+getDesc(recloc);
	xlsheet.Cells(3,5)=t['PRINTDATETIME']+getPrintDateTime();
	xlsheet.Cells(3,6)=t['RETNO']+retno;
	
	xlsheet.printout();
	//
	xlApp=null;
	xlsheet=null;
	xlBook.Close(savechanges=false);  
}	

/*--------------------------------the following is printing for An Hui----------------------------*/
function PrintRetAH(retno)
{   
// print mode of AnHui ,JiShuiTan
	var prnpath=getPrnPath();
	if (prnpath=="") {
		alert(t['CANNOT_FIND_PRNPATH']) ;
		return ;}
	var Template=prnpath+"STP_PhaRet_AH.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	
	var startrow=7 ; //begin to print from the 7th row 
	if (xlsheet==null)
		{ alert(t['CANNOT_CREATE_PRNOBJECT']) ;
		return ;		  }
	var hospname=hospitalName();
	var s=getRetByNo(retno);
	data=s.split("^") ;
	var pid=data[0] ;
	var cnt=data[1] ;
	if (pid=="") return;
	if (cnt<1) return ;
	
	//get the primary infomation of the return bill 
	var ss;
	var sss=getRetDetail(pid,i);
	
	ss=sss.split("^")
	var mWardDesc=ss[14];
	var mRecLoc=ss[12];
	var mRetDate=ss[1];
	var mRetTime=ss[2];
	var mAuditDate=ss[28];
	var mAuditTime=ss[29];
	var mOperUser=ss[4];
	var mAuditUser=ss[30];
	var mStatus=ss[31];
	var mRetNo=ss[0];

	var status;
	var dd;
	var sumamt=0;
	
	if (mStatus=="Y") 
	  {status=t['AUDITED'] ;
	    dd=t['ACK_DATE']+ mAuditDate+" "+mAuditTime	  }
	else {
	   status=t['NOTAUDITED'] ;
	   dd=t['RET_DATE']+mRetDate+" "+mRetTime
	   }
	xlsheet.Cells(1,1)=hospname+getDesc(mRecLoc)+"("+status +")";  //hospital
	xlsheet.Cells(4,1)=t['WARD']+getDesc(mWardDesc)+" "+t['RETNO']+ mRetNo +"  " +dd +"   " +t['PRINTDATETIME']+getPrintDateTime();//hospital标题
	
	var pano,paname,bed,prescno,incidesc,uomdesc,retqty,retdate;
	
	var row;
	row=startrow-1
	for ( var i=1;i<=cnt;i++)
	{  
		var tmps=getRetDetail(pid,i);
		
		data=tmps.split("^");
		pano=data[24] ;
		paname=data[25] ;
		bed=data[21] ;
		prescno=data[16] ;
		incidesc=data[23] ;
		uomdesc=data[27] ;
		retqty=data[17] ;
		retdate=data[1] ;
		recloc=data[12] ;
		var reason=data[32];
	    var amount=data[19];
	    alert(amount)
		sumamt=parseFloat(sumamt)+parseFloat(amount);
		xlsheet.Cells(row+i,1)=pano;
		xlsheet.Cells(row+i,2)=paname;
		xlsheet.Cells(row+i,3)=incidesc;
		xlsheet.Cells(row+i,4)=retqty ;
		xlsheet.Cells(row+i,5)=uomdesc ;
		xlsheet.Cells(row+i,6)=amount;
		xlsheet.Cells(row+i,7)=reason;

		setBottomLine(xlsheet,row+i,1,7)
	}	
	var endrow=row+i+2 ;
	
	xlsheet.Cells(endrow,1)=t['OPUSER']+mOperUser+"     "+t['RECUSER'] +"            "+t['SUM_AMT']+sumamt	
	//xlsheet.Cells(3,1)=t['PHARMACY']+getDesc(recloc);
	//xlsheet.Cells(3,5)=t['PRINTDATETIME']+getPrintDateTime();
	//xlsheet.Cells(3,6)=t['RETNO']+retno;
	
	xlsheet.printout();
	//
	xlApp=null;
	xlsheet=null;
	xlBook.Close(savechanges=false);  
}	

/*----------------------the following is printing for Shao Guan ------------------------------------*/
function PrintRetSG(retno)
{	//print pharmacy return for Shao Guan
	var sum=0;
	var n=0;
	var prnpath=getPrnPath();
	if (prnpath=="") 
	{
		alert(t['CANNOT_FIND_PRNPATH']) ;
		return ;
	}
	var Template=prnpath+"STP_PhaRet_SG.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	
	var startrow=3 ; //从第3行开始打印
		
	if (xlsheet==null)
	{ 	alert(t['CANNOT_CREATE_PRNOBJECT']) ;
		return ;		  
	}
	
	//hospital标题
	var hospname=hospitalName();
	xlsheet.Cells(1,1)=hospname ; 
	
	var tmpjob=getReturnByNo(retno);
	//alert(tmpjob);
	var job=tmpjob.split("^");
	var pid=job[0];
	var count=job[1];
	//alert(count);
	if (pid=="") return;
	if (count<1) return;
	
	var pano="";
	var ward,bed,diagnose,pano,paname,age,cnt,tmpa,pa;
	var incidesc,alias,uom,qty,price,amt,retreason,tmps,data;
	
	while (pano!="end")
	{
		tmpa=listRetPaNo(pid,pano);
		if (tmpa=="end") {pano=tmpa; continue;}	
		//alert(tmpa);
		pa=tmpa.split("^");
		//a1=$g(retno)_"^"_$g(dept)_"^"_$g(bed)_"^"_$g(diagnose)
	    //a2=$g(pano)_"^"_$g(paname)_"^"_$g(age)		
		pano=pa[4];
		ward=pa[1];
		bed=pa[2];
		diagnose=pa[3];
		paname=pa[5];
		age=pa[6];
		//cnt=pa[7];
		
		//alert(cnt);
		xlsheet.Cells(startrow,1)=t['WARD']+ward;
		xlsheet.Cells(startrow,4)=t['PRINTDATETIME']+getPrintDateTime();
		xlsheet.Cells(startrow,6)=t['NO']+retno;
		setBottomLine(xlsheet,startrow,1,7);
		xfontcell(xlsheet,startrow,1,7);
		
		startrow=startrow+1;
		
		xlsheet.Cells(startrow,1)= t['REGNO']+pano;
		xlsheet.Cells(startrow,2)= t['NAME']+paname;
		xlsheet.Cells(startrow,3)= t['AGE']+age;
		xlsheet.Cells(startrow,4)= t['BED']+bed;
		xlsheet.Cells(startrow,5)= t['DIAGNOSE']+diagnose;
		xfontcell(xlsheet,startrow,1,7);
		
		startrow=startrow+1;
		
		xlsheet.Cells(startrow,1)= t['DRUGNAME'];
		xlsheet.Cells(startrow,2)= t['ALIAS'];
		xlsheet.Cells(startrow,3)= t['CT_UOM'];
		xlsheet.Cells(startrow,4)= t['QTY'];
		xlsheet.Cells(startrow,5)= t['RETREASON'];
		xlsheet.Cells(startrow,6)= t['PRICE'];
		xlsheet.Cells(startrow,7)= t['AMOUNT'];
		xfontcell(xlsheet,startrow,1,7);
		
		startrow=startrow+1;
		sum=0;
		//打印药品明细
		var i=0;
		var n=0;
		while (i>=0)
		{
			tmps=listRetDetail(pid,pano,i);
			//alert(tmps);
			if (tmps=="-1") {i=-1; continue;}
			
			data=tmps.split("^");
									
	        //a3=$g(incidesc)_"^"_$g(alias)_"^"_$g(uom)_"^"_+$g(qty)_"^"_+$g(price)_"^"_+$g(amt)_"^"_$g(retreason)	
			incidesc=data[0];
			alias=data[1];
			uom=data[2];
			qty=data[3];
			price=data[4];
			amt=data[5];
			retreason=data[6];
			i=data[7];	
			
			xlsheet.Cells(startrow,1)= incidesc;
			xlsheet.Cells(startrow,2)=alias;
			xlsheet.Cells(startrow,3)=uom;
			xlsheet.Cells(startrow,4)=qty;
			xlsheet.Cells(startrow,5)=retreason;
			xlsheet.Cells(startrow,6)=price;
			xlsheet.Cells(startrow,7)=amt;
			
			sum=parseFloat(sum)+parseFloat(amt);
			n=n+1;
			startrow=startrow+1;
		}
		setLine(xlsheet,startrow-n-1,1,startrow,7)		
		//合计
		xlsheet.Cells(startrow,1)= t['SUMMATION'];
		xlsheet.Cells(startrow,2)=n;
		xlsheet.Cells(startrow,7)=sum;
		
		startrow=startrow+3;
	}
	
	//打印最后一行
	//统计?验收?校对?退药科室签收
    xlsheet.Cells(startrow, 1).Value=t['STATISTIC']+"              "+t['RECEIVE']+"             "+t['CONFIRM']+"               "+t['RETRECEIVE'];
    mergcell(xlsheet,startrow,1,7);
	
	xlsheet.printout();
	//打印后的处理
	xlApp=null;
	
	xlsheet=null;
	xlBook.Close(savechanges=false);  
}
function PrintRetHXY(retno)
{	
	//print pharmacy return for HuaXi

	var prnpath=getPrnPath();
	if (prnpath=="") {
		alert(t['CANNOT_FIND_PRNPATH']) ;
		return ;}
	var Template=prnpath+"STP_PhaRet_HXY.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	
	var startrow=4 ; //begin to print from the 7th row 
	if (xlsheet==null)
		{ alert(t['CANNOT_CREATE_PRNOBJECT']) ;
		return ;		  }
	var hospname=hospitalName();
	var s=getRetByNo(retno);
	data=s.split("^") ;
	var pid=data[0] ;
	var cnt=data[1] ;
	if (pid=="") return;
	if (cnt<1) return ;
	
	//get the primary infomation of the return bill 
	var ss;
	var sss=getRetDetail(pid,1);

	ss=sss.split("^")
	var mWardDesc=ss[14];
	var mRecLoc=ss[12];
	var mRetDate=ss[1];
	var mRetTime=ss[2];
	var mAuditDate=ss[28];
	var mAuditTime=ss[29];
	var mOperUser=ss[4];
	var mAuditUser=ss[30];
	var mStatus=ss[31];
	var mRetNo=ss[0];

	var status;
	var dd;
	var sumamt=0;
	
	if (mStatus=="Y") 
	  {status=t['AUDITED'] ;
	    //dd=t['ACK_DATE']+ formatDate2(mAuditDate)+" "+mAuditTime	 
	    dd=t['ACK_DATE']+ formatDate2(mAuditDate) }
	else {
	   status=t['NOTAUDITED'] ;
	   //dd=t['RET_DATE']+formatDate2(mRetDate)+" "+mRetTime;
	   dd=t['RET_DATE']+formatDate2(mRetDate);
	   }
	xlsheet.Cells(1,1)=getDesc(mRecLoc)+t['PRN_TITLE'];  //hospital
	xlsheet.Cells(3,1)=t['WARD']+getDesc(mWardDesc)+" "+t['RETNO']+ mRetNo +"  " +dd +"   " +t['PRINTDATETIME']+formatDate2(getPrintDate())+" "+getPrintTime();//hospital标题
	
	var pano,paname,bed,prescno,incidesc,uomdesc,retqty,retdate;
	var reason,amount,barcode,manufacture,batno;
	var row;
	var tmppano="";
	row=startrow
	for ( var i=1;i<=cnt;i++)
	{  
		var tmps=getRetDetail(pid,i);
		
		data=tmps.split("^");
		pano=data[24] ;
		paname=data[25] ;
		bed=data[21] ;
		prescno=data[16] ;
		//var tmpinci=data[23].split("(");
		//incidesc=tmpinci[0] ;
		incidesc=data[23]
		var tmpuom=data[27].split("(");
		uomdesc=tmpuom[0] ;
		retqty=data[17] ;
		retdate=data[1] ;
		recloc=data[12] ;
		reason=data[32];
	    amount=data[19];
	    barcode=data[34];
	    manufacture=data[35];
	    var dex=manufacture.indexOf("-")
	    if(dex>=0)
	    {
			manufacture=manufacture.substr(dex+1)
		}
		
	    batno=data[36];
	   	
	   	if ((tmppano=="")||(tmppano!=pano))
	   	{
		   	if(tmppano!="")
			{setBottomLine(xlsheet,row+i-1,1,7);}
			
		   	xlsheet.Cells(row+i,1)=pano;
			xlsheet.Cells(row+i,2)=paname;
			
			tmppano=pano;
			cellEdgeRightLine(xlsheet,row+i,1,7);
		}
		sumamt=parseFloat(sumamt)+parseFloat(amount);
		
		xlsheet.Cells(row+i,3)=incidesc;
		//xlsheet.Cells(row+i,4)=barcode;
		xlsheet.Cells(row+i,4)=batno;
		xlsheet.Cells(row+i,5)=manufacture;		
		xlsheet.Cells(row+i,6)=retqty+""+uomdesc ;
		xlsheet.Cells(row+i,7)=amount;
		//xlsheet.Cells(row+i,7)=reason;

		//setBottomLine(xlsheet,row+i,1,8);
		cellEdgeRightLine(xlsheet,row+i,1,7);
	}
	
	setBottomLine(xlsheet,row+i-1,1,7);	
	var endrow=row+i+2 ;
	
	xlsheet.Cells(endrow,1)=t['OPUSER']+"             "+t['RECUSER'] +"            "+t['SUM_AMT']+sumamt.toFixed(2)	
	//xlsheet.Cells(3,1)=t['PHARMACY']+getDesc(recloc);
	//xlsheet.Cells(3,5)=t['PRINTDATETIME']+getPrintDateTime();
	//xlsheet.Cells(3,6)=t['RETNO']+retno;
	
	xlsheet.printout();
	//
	xlApp=null;
	xlsheet=null;
	xlBook.Close(savechanges=false);
}
function PrintRetBJFC(retno)
{	
	//print pharmacy return for HuaXi


	var prnpath=getPrnPath();
	if (prnpath=="") {
		alert(t['CANNOT_FIND_PRNPATH']) ;
		return ;}
	var Template=prnpath+"STP_PhaRet_BJFC.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	
	var startrow=4 ; //begin to print from the 7th row 
	if (xlsheet==null)
		{ alert(t['CANNOT_CREATE_PRNOBJECT']) ;
		return ;		  }
	var hospname=hospitalName();
	var s=getRetByNo(retno);
	data=s.split("^") ;
	var pid=data[0] ;
	var cnt=data[1] ;
	if (pid=="") return;
	if (cnt<1) return ;
	
	//get the primary infomation of the return bill 
	var ss;
	var sss=getRetDetail(pid,1);

	ss=sss.split("^")
	var mWardDesc=ss[14];
	var mRecLoc=ss[12];
	var mRetDate=ss[1];
	var mRetTime=ss[2];
	var mAuditDate=ss[28];
	var mAuditTime=ss[29];
	var mOperUser=ss[4];
	var mAuditUser=ss[30];
	var mStatus=ss[31];
	var mRetNo=ss[0];
	var mOrdLoc=ss[37];
 
	var status;
	var dd;
	var sumamt=0;
	
	if (mStatus=="Y") {
		status=t['AUDITED'] ;
	    //dd=t['ACK_DATE']+ formatDate2(mAuditDate)+" "+mAuditTime	 
	    dd=t['ACK_DATE']+ mAuditDate
	   }
	else {
	   status=t['NOTAUDITED'] ;
	   //dd=t['RET_DATE']+formatDate2(mRetDate)+" "+mRetTime;
	   dd=t['RET_DATE']+mRetDate;
	   }
	xlsheet.Cells(1,1)=getDesc(mRecLoc)+t['PRN_TITLE']+"      "+"申请科室:"+mOrdLoc;  //hospital
	xlsheet.Cells(3,1)=t['WARD']+getDesc(mWardDesc)+" "+t['RETNO']+ retno +"  " +dd +"   " //hospital标题
	
	var pano,paname,bed,prescno,incidesc,uomdesc,retqty,retdate;
	var reason,amount,barcode,manufacture,batno;
	var row;
	var tmppano="";
	row=startrow
	for ( var i=1;i<=cnt;i++)
	{  
		var tmps=getRetDetail(pid,i);
		data=tmps.split("^");
		pano=data[24] ;
		paname=data[25] ;
		bed=data[21] ;
		prescno=data[16] ;
		//var tmpinci=data[23].split("(");
		//incidesc=tmpinci[0] ;
		incidesc=data[23]
		var tmpuom=data[27].split("(");
		uomdesc=tmpuom[0] ;
		retqty=data[17] ;
		retdate=data[1] ;
		recloc=data[12] ;
		reason=data[32];
		price=data[18];
	    amount=data[19];
	    barcode=data[34];
	    manufacture=data[35];
	    var dex=manufacture.indexOf("-")
	    if(dex>=0)
	    {
			manufacture=manufacture.substr(dex+1)
		}
		
	    batno=data[36];
        
	   	
	   	if ((tmppano=="")||(tmppano!=pano))
	   	{
		   	if(tmppano!="")
			{setBottomLine(xlsheet,row+i-1,1,8);}
			
		   	xlsheet.Cells(row+i,1)=pano;
			xlsheet.Cells(row+i,2)=paname;
			
			tmppano=pano;
			cellEdgeRightLine(xlsheet,row+i,1,8);
		}
		sumamt=parseFloat(sumamt)+parseFloat(amount);
		
		xlsheet.Cells(row+i,3)=incidesc;
		//xlsheet.Cells(row+i,4)=barcode;
		xlsheet.Cells(row+i,4)=batno;
		xlsheet.Cells(row+i,5)=manufacture;		
		//xlsheet.Cells(row+i,6)=retqty+""+uomdesc ;
		xlsheet.Cells(row+i,6)=retqty
		xlsheet.Cells(row+i,7)=price
		xlsheet.Cells(row+i,8)=amount;
		cellEdgeRightLine(xlsheet,row+i,1,8);
	}
	
	setBottomLine(xlsheet,row+i-1,1,8);	
	var endrow=row+i+2 ;
	xlsheet.Cells(endrow,1)=t['OPUSER']+session['LOGON.USERNAME']+"   "+t['RECUSER'] +"            "+t['SUM_AMT']+sumamt.toFixed(2) +"元"+"      打印时间:"+getPrintDateTime();
	xlsheet.printout();
	xlApp=null;
	xlsheet=null;
	xlBook.Close(savechanges=false);
	KillTMP(pid)

}
function KillTMP(pid)
{
	var obj=document.getElementById("mKillTMP") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var data=cspRunServerMethod(encmeth,pid) ;
	
}
function PrintRetHX(retno)
{	
	//print pharmacy return for HuaXi

	var prnpath=getPrnPath();
	if (prnpath=="") {
		alert(t['CANNOT_FIND_PRNPATH']) ;
		return ;}
	var Template=prnpath+"STP_PhaRet_HX.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	
	var startrow=4 ; //begin to print from the 7th row 
	if (xlsheet==null)
		{ alert(t['CANNOT_CREATE_PRNOBJECT']) ;
		return ;		  }
	var hospname=hospitalName();
	var s=getRetByNo(retno);
	data=s.split("^") ;
	var pid=data[0] ;
	var cnt=data[1] ;
	if (pid=="") return;
	if (cnt<1) return ;
	
	//get the primary infomation of the return bill 
	var ss;
	var sss=getRetDetail(pid,1);

	ss=sss.split("^")
	var mWardDesc=ss[14];
	var mRecLoc=ss[12];
	var mRetDate=ss[1];
	var mRetTime=ss[2];
	var mAuditDate=ss[28];
	var mAuditTime=ss[29];
	var mOperUser=ss[4];
	var mAuditUser=ss[30];
	var mStatus=ss[31];
	var mRetNo=ss[0];

	var status;
	var dd;
	var sumamt=0;
	
	if (mStatus=="Y") 
	  {status=t['AUDITED'] ;
	    //dd=t['ACK_DATE']+ formatDate2(mAuditDate)+" "+mAuditTime	 
	    dd=t['ACK_DATE']+ formatDate2(mAuditDate) }
	else {
	   status=t['NOTAUDITED'] ;
	   //dd=t['RET_DATE']+formatDate2(mRetDate)+" "+mRetTime;
	   dd=t['RET_DATE']+formatDate2(mRetDate);
	   }
	xlsheet.Cells(1,1)=hospname+getDesc(mRecLoc)+t['PRN_TITLE'];  //hospital
	xlsheet.Cells(3,1)=t['WARD']+getDesc(mWardDesc)+" "+t['RETNO']+ mRetNo +"  " +dd +"   " +t['PRINTDATETIME']+formatDate2(getPrintDate())+" "+getPrintTime();//hospital标题
	
	var pano,paname,bed,prescno,incidesc,uomdesc,retqty,retdate;
	var reason,amount,barcode,manufacture,batno;
	var row;
	var tmppano="";
	row=startrow
	for ( var i=1;i<=cnt;i++)
	{  
		var tmps=getRetDetail(pid,i);
		
		data=tmps.split("^");
		pano=data[24] ;
		paname=data[25] ;
		bed=data[21] ;
		prescno=data[16] ;
		var tmpinci=data[23].split("(");
		incidesc=tmpinci[0] ;
		var tmpuom=data[27].split("(");
		uomdesc=tmpuom[0] ;
		retqty=data[17] ;
		retdate=data[1] ;
		recloc=data[12] ;
		reason=data[32];
	    amount=data[19];
	    barcode=data[34];
	    manufacture=data[35];
	    var dex=manufacture.indexOf("-")
	    if(dex>=0)
	    {
			manufacture=manufacture.substr(dex+1)
		}
		
	    batno=data[36];
	   	
	   	if ((tmppano=="")||(tmppano!=pano))
	   	{
		   	if(tmppano!="")
			{setBottomLine(xlsheet,row+i-1,1,8);}
			
		   	xlsheet.Cells(row+i,1)=pano;
			xlsheet.Cells(row+i,2)=paname;
			
			tmppano=pano;
			cellEdgeRightLine(xlsheet,row+i,1,8);
		}
		sumamt=parseFloat(sumamt)+parseFloat(amount);
		
		xlsheet.Cells(row+i,3)=incidesc;
		xlsheet.Cells(row+i,4)=barcode;
		xlsheet.Cells(row+i,5)=batno;
		xlsheet.Cells(row+i,6)=manufacture;		
		xlsheet.Cells(row+i,7)=retqty+""+uomdesc ;
		xlsheet.Cells(row+i,8)=amount;
		//xlsheet.Cells(row+i,7)=reason;

		//setBottomLine(xlsheet,row+i,1,8);
		cellEdgeRightLine(xlsheet,row+i,1,8);
	}
	
	setBottomLine(xlsheet,row+i-1,1,8);	
	var endrow=row+i+2 ;
	
	xlsheet.Cells(endrow,1)=t['OPUSER']+"             "+t['RECUSER'] +"            "+t['SUM_AMT']+sumamt.toFixed(2)	
	//xlsheet.Cells(3,1)=t['PHARMACY']+getDesc(recloc);
	//xlsheet.Cells(3,5)=t['PRINTDATETIME']+getPrintDateTime();
	//xlsheet.Cells(3,6)=t['RETNO']+retno;
	
	xlsheet.printout();
	//
	xlApp=null;
	xlsheet=null;
	xlBook.Close(savechanges=false);
}

function getReturnByNo(retno)
{	
	var obj=document.getElementById("mGetReturnByNo") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var data=cspRunServerMethod(encmeth,'','',retno) ;
	return data
}

function listRetPaNo(pid,pano)
{	
	//alert(pid+pano);
	var obj=document.getElementById("mListRetPaNo") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var data=cspRunServerMethod(encmeth,'','',pid,pano) ;
	//alert(data);
	return data
}
function listRetDetail(pid,pano,i)
{	var obj=document.getElementById("mListRetDetail") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var data=cspRunServerMethod(encmeth,'','',pid,pano,i) ;
	return data
}
function setLine(objSheet,startrow,startcol,endrow,endcol)
{
    objSheet.Range(objSheet.Cells(startrow, startcol), objSheet.Cells(endrow, endcol)).Borders.LineStyle=1 ;
}
function xfontcell(objSheet,row,c1,c2)
{
	objSheet.Range(objSheet.Cells(row, c1), objSheet.Cells(row,c2)).Font.Bold =1;
}
/*----------------------Printing of Shao Guan is on the above ---------------------------------------------*/

function cellEdgeRightLine(objSheet,row,c1,c2)
{
	for (var i=c1;i<=c2;i++)
	{
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(10).LineStyle=1;
		objSheet.Range(objSheet.Cells(row, i), objSheet.Cells(row,i)).Borders(7).LineStyle=1;
	}
}
///打印退药申请单
///add by caoting
function PrintRetReq(retreqno)
{
	var prnpath=getPrnPath();
	if (prnpath=="") {
		alert(t['CANNOT_FIND_PRNPATH']) ;
		return ;}
	var Template=prnpath+"DHCSTP_PhaRetRequest.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	
	var startrow=5 ; //begin to print from the 7th row 
	if (xlsheet==null)
		{ alert(t['CANNOT_CREATE_PRNOBJECT']) ;
		return ;		  }
	var hospname=hospitalName();
	//var s=getRetByNo(retno);
	//alert(retreqno);
	var s=getRetReqByNo(retreqno);
	//alert(s);
	data=s.split("^") ;
	var pid=data[0] ;
	var cnt=data[1] ;
	if (pid=="") return;
	if (cnt<1) return ;
	
	//get the primary infomation of the return bill 
	var ss;
	var sss=getRetReqDetail(pid,1);
	ss=sss.split("^")
	var mWardDesc=ss[4];
	var mRecLoc=ss[22];
	var mRetDate=ss[1];
	var mRetTime=ss[2];
	var mAuditDate=ss[28];
	var mAuditTime=ss[29];
	var mOperUser=ss[4];
	var mAuditUser=ss[30];
	var mStatus=ss[31];
	var mRetNo=ss[0];
	var mOrdLoc=ss[37];
 
	var status;
	var dd;
	var sumamt=0;
	
	if (mStatus=="Y") 
	  {status=t['AUDITED'] ;
	    //dd=t['ACK_DATE']+ formatDate2(mAuditDate)+" "+mAuditTime	 
	    dd=t['ACK_DATE']+ formatDate2(mAuditDate) }
	else {
	   status=t['NOTAUDITED'] ;
	   //dd=t['RET_DATE']+formatDate2(mRetDate)+" "+mRetTime;
	   dd=t['RET_DATE']+formatDate2(mRetDate);
	   }
	//xlsheet.Cells(1,1)=getDesc(mRecLoc)+t['PRN_TITLE']+"      "+"申请科室:"+mOrdLoc;  //hospital
	//xlsheet.Cells(1,1)=t['TITLE']
	xlsheet.Cells(2,2)=retreqno
	xlsheet.Cells(2,6)=getDesc(mWardDesc)
	xlsheet.Cells(3,2)=getDesc(mRecLoc)
	xlsheet.Cells(3,6)=formatDate2(getPrintDate())
	//xlsheet.Cells(3,1)=t['WARD']+getDesc(mWardDesc)+" "+t['RETNO']+ mRetNo +"  " +dd +"   " +t['PRINTDATETIME']+formatDate2(getPrintDate())+" "+getPrintTime();//hospital标题
	
	var pano,paname,bed,prescno,incidesc,uomdesc,retqty,retdate;
	var reason,amount,barcode,manufacture,batno;
	var row;
	var tmppano="";
	row=startrow
	for ( var i=1;i<=cnt;i++)
	{  
		var tmps=getRetReqDetail(pid,i);
		data=tmps.split("^");
		pano=data[0] ;
		paname=data[25] ;
		bed=data[5] ;
		prescno=data[7] ;
		//var tmpinci=data[23].split("(");
		//incidesc=tmpinci[0] ;
		incidesc=data[15]
		//var tmpuom=data[27].split("(");
		uomdesc=data[24] ;
		retqty=data[8] ;
		retdate=data[1] ;
		recloc=data[12] ;
		reason=data[29];
		price=data[18];
	    amount=data[10];
	    barcode=data[34];
	    //manufacture=data[35];
	    //var dex=manufacture.indexOf("-")
	    //if(dex>=0)
	    //{
		//	manufacture=manufacture.substr(dex+1)
		//}
		//alert(incidesc)
		var dex=incidesc.indexOf("(")
		if(dex>=0)
		{
			var pack=incidesc.substr(dex+1)
			ss=pack.split(")")
			pack=ss[0]
			
		}
		var desc=incidesc.split("(")
		incidesc=desc[0];
	    batno=data[36];
        
	   	
		sumamt=parseFloat(sumamt)+parseFloat(amount);
		
		setBottomLine(xlsheet,row+i-1,1,7);
		cellEdgeRightLine(xlsheet,row+i,1,6);	
		xlsheet.Cells(row+i,1)=pano;
	    xlsheet.Cells(row+i,2)=paname;
		
		xlsheet.Cells(row+i,3)=bed;
		//xlsheet.Cells(row+i,4)=barcode;
		xlsheet.Cells(row+i,4)=prescno;
		xlsheet.Cells(row+i,5)=incidesc;		
		xlsheet.Cells(row+i,6)=uomdesc ;
		xlsheet.Cells(row+i,7)=retqty
		//xlsheet.Cells(row+i,7)=-price
		//xlsheet.Cells(row+i,8)=-amount;
		
		//xlsheet.Cells(row+i,7)=reason;

		//setBottomLine(xlsheet,row+i,1,8);
		cellEdgeRightLine(xlsheet,row+i,1,7);
		//xlsheet.Cells(3,1)=t['NAME']+paname+"        "+t['REGNO']+pano+"             "+formatDate2(getPrintDate())
	}
	
	setBottomLine(xlsheet,row+i-1,1,7);	
	var endrow=row+i+2 ;
	
	//xlsheet.Cells(endrow,1)=t['OPUSER']+"             "+t['RECUSER'] +"            "+t['SUM_AMT']+sumamt.toFixed(2)	
	//xlsheet.Cells(3,1)=t['PHARMACY']+getDesc(recloc);
	//xlsheet.Cells(3,5)=t['PRINTDATETIME']+getPrintDateTime();
	//xlsheet.Cells(3,6)=t['RETNO']+retno;
	xlsheet.Cells(endrow-1,1)="主诊医师/医疗组长(签字加处方章)"+"            "+"科室主任(签字加处方章)"
	xlsheet.Cells(endrow,1)="药剂科经手人(签章)"+"           "+"复核人(签章)"+"                   "+"退药金额    "+sumamt.toFixed(2)+"   元"
	xlsheet.printout();
	//
	xlApp=null;
	xlsheet=null;
	xlBook.Close(savechanges=false);
	
	KillTMP(pid)
}
function getRetReqByNo(retreqno)
{
	var obj=document.getElementById("mGetRetReqByNo") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var data=cspRunServerMethod(encmeth,retreqno) ;
	return data
}
function getRetReqDetail(pid,i)
{
	var obj=document.getElementById("mListRetReq") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var data=cspRunServerMethod(encmeth,pid,i) ;
	return data	
}
document.body.onload=BodyLoadHandler;


