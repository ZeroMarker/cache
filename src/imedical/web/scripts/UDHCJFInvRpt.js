var fpColumns ,gusername,prtflag,yjColumns,guserrowid,gusercode
var cyshdeposit,stje,patfee,zfnum,allnum
var fpData = new Array()
var path,job
var flag
function BodyLoadHandler() {
   
   prtflag="3"
   var paymodestr=t['jstpaymode1'].split("_")
   fpColumns = [
	t['01'], t['02'],t['03'],t['04'],t['05'],paymodestr[0],paymodestr[1],paymodestr[2],paymodestr[3],paymodestr[4],paymodestr[5],paymodestr[6],paymodestr[7],paymodestr[8],t['14'],t['15'],t['19']
 	];
   yjColumns = [
	 t['03'], t['04'], t['05'], t['06'] ,t['07'],t['08'],t['09'],t['10'],t['13'],t['14']
 	];
   guserrowid=session['LOGON.USERID']
   gusername=session['LOGON.USERNAME']
   gusercode=session['LOGON.USERCODE']
   var prt=document.getElementById("PrintFl");
   if (prt){
     prt.onclick=PrintFl_click;	  
  }
  prt=document.getElementById("prtdeposit");
   if (prt){
     prt.onclick=Printdeposit_click;	  
  }
  prt=document.getElementById("printinv");
   if (prt){
     prt.onclick=PrintInv_click;	  
  }
  prt=document.getElementById("PrtHcDetail");
  if (prt)
  {
     prt.onclick=PrintHCDetail_click;	  
  }
}
function SelectRowHandler()	{
	
	//GetSum()
	//var lastrowindex=rows - 1;
	//var rowObj=getRow(eSrc);
	//var selectrow=rowObj.rowIndex;
	SelectedRow = selectrow;
}
function GetSum()
{   var i
    var Sum=0;deposit=0;xjsum=0,zhpsum=0,hpsum=0,xyksum=0,discountsum=0,dissum=0,paysharesum=0,patsharesum=0
    var ybsum=0
    var Objtbl=parent.frames['UDHCJFInvRpt'].document.getElementById('tUDHCJFInvRpt');
	var Rows=Objtbl.rows.length;
	
	for (i=1;i<=Rows-2;i++)
	{
	   var SelRowObj=document.getElementById('Tstatusz'+i);
	   var prtstatus=SelRowObj.innerText;
	   SelRowObj=document.getElementById('Tselectz'+i);
	   var select=SelRowObj.checked;
	   SelRowObj=document.getElementById('Ttotalz'+i);
	   var payamt=SelRowObj.innerText;
	   SelRowObj=document.getElementById('Ttdepositz'+i);
	   var tdeposit=SelRowObj.innerText;
       SelRowObj=document.getElementById('Txianjinz'+i);
	   var xianjin=SelRowObj.innerText;
	   SelRowObj=document.getElementById('Tzhipiaoz'+i);
	   var zhp=SelRowObj.innerText;
	   SelRowObj=document.getElementById('Thuipiaoz'+i);
	   var hp=SelRowObj.innerText;
	   SelRowObj=document.getElementById('Txykz'+i);
	   var xyk=SelRowObj.innerText;
	   SelRowObj=document.getElementById('Tdiscountz'+i);
	   var discount=SelRowObj.innerText;
	   SelRowObj=document.getElementById('Tpayorsharez'+i);
	   var payshare=SelRowObj.innerText;
	   SelRowObj=document.getElementById('Tpatsharez'+i);
	   var patshare=SelRowObj.innerText;
	   SelRowObj=document.getElementById('Tpatnamez'+i);
	   var patname=SelRowObj.innerText;
	   SelRowObj=document.getElementById('Tybz'+i);
	   var yb=SelRowObj.innerText;
	   if ((prtstatus!=t['16'])&&(select==true)&&(patname!=t['17']))
	   {  Sum=eval(Sum)+eval(payamt) ;
	      deposit=eval(deposit)+eval(tdeposit)
	      xjsum=eval(xjsum)+eval(xianjin) ;
	      zhpsum=eval(zhpsum)+eval(zhp);
	      hpsum=eval(hpsum)+eval(hp);
	      xyksum=eval(xyksum)+eval(xyk);
	      dissum=eval(dissum)+eval(discount);
	      paysharesum=eval(paysharesum)+eval(payshare)
	      patsharesum=eval(patsharesum)+eval(patshare)
	      ybsum=eval(ybsum)+eval(yb)
	   }
	}
	var lastrow=Rows-1
	SelRowObj=document.getElementById('Ttotalz'+lastrow);
	SelRowObj.innerText=Sum.toFixed(2);
    SelRowObj=document.getElementById('Ttdepositz'+lastrow);
	SelRowObj.innerText=deposit.toFixed(2);
	SelRowObj=document.getElementById('Txianjinz'+lastrow);
	SelRowObj.innerText=xjsum.toFixed(2);
	SelRowObj=document.getElementById('Tzhipiaoz'+lastrow);
	SelRowObj.innerText=zhpsum.toFixed(2);
	SelRowObj=document.getElementById('Thuipiaoz'+lastrow);
	SelRowObj.innerText=hpsum.toFixed(2);
	SelRowObj=document.getElementById('Txykz'+lastrow);
	SelRowObj.innerText=xyksum.toFixed(2);
	SelRowObj=document.getElementById('Tpayorsharez'+lastrow);
	SelRowObj.innerText=paysharesum.toFixed(2);
	SelRowObj=document.getElementById('Tdiscountz'+lastrow);
	SelRowObj.innerText=dissum.toFixed(2);
	SelRowObj=document.getElementById('Tpatsharez'+lastrow);
	SelRowObj.innerText=patsharesum.toFixed(2);
	SelRowObj=document.getElementById('Tybz'+lastrow);
	SelRowObj.innerText=ybsum.toFixed(2);
}
function getpath() {
	var getpath=document.getElementById('getpath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};	
		path=cspRunServerMethod(encmeth,'','')
	}

function PrintFl_click()
{   var i
    var Objtbl=document.getElementById('tUDHCJFInvRpt');
	var Rows=Objtbl.rows.length;
	lastrow=Rows-1
	SelRowObj=document.getElementById('Ttdepositz'+lastrow);
	cyshdeposit=SelRowObj.innerText
	SelRowObj=document.getElementById('Ttotalz'+lastrow);
	patfee=SelRowObj.innerText
	
    stje=eval(patfee)-eval(cyshdeposit)
    stje=stje.toFixed(2).toString(10)
	SelRowObj=document.getElementById('Tjobz'+1);
    job=SelRowObj.innerText;
	getpath();
	PrintFlDetail() ;
}
function Printdeposit_click()
{   SelRowObj=document.getElementById('Tjobz'+1);
    job=SelRowObj.innerText; 
    getpath();
    printshdepositdetail() ;
}
function PrintHCDetail_click()
{
	SelRowObj=document.getElementById('Tjobz'+1);
    job=SelRowObj.innerText; 
    getpath();
    
    PrintHCDetail() ;
}
function PrintInv_click()
{   getpath();
    var i
    var Objtbl=document.getElementById('tUDHCJFdayInvRpt');
	var Rows=Objtbl.rows.length;
	allnum=Rows-2
	zfnum=0
	
	for (i=1;i<=Rows-1;i++)
	{  var SelRowObj=document.getElementById('Tpatnamez'+i);
       var patname=SelRowObj.innerText;
       SelRowObj=document.getElementById('Tregnoz'+i);
       var regno=SelRowObj.innerText;
       SelRowObj=document.getElementById('Trcptnoz'+i);
       var rcptno=SelRowObj.innerText;
       SelRowObj=document.getElementById('Ttotalz'+i);
       var total=SelRowObj.innerText;
       total=eval(total).toFixed(2).toString(10)
       SelRowObj=document.getElementById('Ttdepositz'+i);
       var tdeposit=SelRowObj.innerText;
       tdeposit=eval(tdeposit).toFixed(2).toString(10)
       //SelRowObj=document.getElementById('Txianjinz'+i);
       //var xianjin=SelRowObj.innerText;
       //SelRowObj=document.getElementById('Tzhipiaoz'+i);
       //var zhipiao=SelRowObj.innerText;
       //SelRowObj=document.getElementById('Thuipiaoz'+i);
       //var huipiao=SelRowObj.innerText;
       //SelRowObj=document.getElementById('Txykz'+i);
       //var xyk=SelRowObj.innerText;
       //SelRowObj=document.getElementById('Tjstzplyz'+i);
       //var zply=SelRowObj.innerText;
       //SelRowObj=document.getElementById('Tjsthplyz'+i);
       //var hply=SelRowObj.innerText;
       //SelRowObj=document.getElementById('Tjstxyklyz'+i);
       //var xykly=SelRowObj.innerText;
       SelRowObj=document.getElementById('Tybz'+i);
       var yb=SelRowObj.innerText;
       SelRowObj=document.getElementById('Tgfjzz'+i);
       var cjamount=SelRowObj.innerText;  
       SelRowObj=document.getElementById('Tstatusz'+i);
       var status=SelRowObj.innerText;
       SelRowObj=document.getElementById('Tprtdatez'+i);
       var prtdate=SelRowObj.innerText;
       SelRowObj=document.getElementById('Tprttimez'+i);
       var prttime=SelRowObj.innerText;
       SelRowObj=document.getElementById('Tzynoz'+i);
       var zyno=SelRowObj.innerText;
       
       var tmpfee=eval(total)-eval(tdeposit)-eval(yb)-eval(cjamount)
       bjfee="0.00",tfee="0.00"
       if (tmpfee>=0) 
       {  var bjfee=tmpfee,bjfee=eval(bjfee).toFixed(2).toString(10)   }
       else
       {  
          var tfee=Math.abs(tmpfee),tfee=eval(tfee).toFixed(2).toString(10)    }
	       
      
       //var str=patname+"^"+regno+"^"+rcptno+"^"+total+"^"+tdeposit+"^"+xianjin+"^"+zhipiao+"^"+huipiao+"^"+gfjz+"^"+sldjz+"^"+payorshare+"^"+discount+"^"+patshare+"^"+status+"^"+prtdate
       
       if ((status!=t['16'])&&(status!=t['jst27'])) 
       {   status=""      }
       else
       {   zfnum=zfnum+1  }
       var str=patname+"^"+zyno+"^"+regno+"^"+tdeposit+"^"+total+"^"+bjfee+"^"+tfee+"^"+""+"^"+rcptno+"^"+status    //+"^"+xianjin+"^"+zhipiao+"^"+zply+"^"+huipiao+"^"+hply+"^"+xyk+"^"+xykly+"^"+yb+"^"+qfamount+"^"+status+"^"+prtdate+"^"+prttime
       fpData[i-1]=str.split("^"); 
	}
    
	SelRowObj=document.getElementById('Ttotalz'+(allnum+1));
	patfee=SelRowObj.innerText
   
    PrintInvDetail()
}
document.body.onload = BodyLoadHandler;