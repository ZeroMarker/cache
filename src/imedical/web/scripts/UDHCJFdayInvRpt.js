var fpColumns ,gusername,prtflag,yjColumns,guserrowid,gusercode
var cyshdeposit,stje,patfee,zfnum,allnum
var fpData = new Array()
var path,job,hidden="false"
var tjdate

function BodyLoadHandler() {
   
   Initialpaym();

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
   document.getElementById("Guser").value=guserrowid;
   var obj=parent.frames['UDHCJFSearch'].document.getElementById("stdate").value
   document.getElementById("stdate").value=obj;
   var obj=parent.frames['UDHCJFSearch'].document.getElementById("enddate").value
   document.getElementById("enddate").value=obj;
   var obj=parent.frames['UDHCJFSearch'].document.getElementById("handin").value
   if (obj=="on") {document.getElementById("handin").value="Y";}
   else {document.getElementById("handin").value="N";}
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

function Initialpaym()
{
	///unescape
	var catobj=document.getElementById("getpaym");
	if (catobj) {var encmeth=catobj.value} else {var encmeth=''};
	var payminfo=cspRunServerMethod(encmeth);
	var objtbl=document.getElementById("tUDHCJFdayInvRpt");
	var Rows=objtbl.rows.length;
	var firstRow=objtbl.rows[0];
	var paymtmp =payminfo.split("^");
	var paymnum=paymtmp.length-1;
	var reg=/TPaym(\d+)/
	var THList = firstRow.getElementsByTagName("TH");
	var len = THList.length;
	//wanghc
	for (var j=0; j < len; j++)	{
		if (typeof (THList[j].innerHTML)!="undefined")
		{
			if (reg.test(THList[j].innerHTML)){
				var payColIndex = RegExp.$1
				if(payColIndex<=paymnum){
					THList[j].innerText = paymtmp[payColIndex];
				}else{
					THList[j].style.display="none";			//没有对应支付方式的col隐藏
					for (var i=1;i<Rows;i++) {
						var sLable=document.getElementById("TPaym"+payColIndex+'z'+i);
						var sTD=sLable.parentElement;
						sTD.style.display="none";
					}
				}
			}
		}
	}
	/*for (var i=1;i<=paymnum-1;i++)
	{
		var ColName="TPaym"+i;
		for (var j=0;j<RowItems.length;j++) 
		{
			if ((RowItems[j].value==ColName+" ")&(RowItems[j].tagName=='TH'))
			{
				RowItems[j].value=paymtmp[i];
			}
		}
	}*/
	/*
	for (var i=paymnum;i<=16;i++){
		HiddenTblColumn(objtbl,"TPaym"+i,i);
	}*/
	
}

function HiddenTblColumn(tbl,ColName,ColIdx){
	///
	///
	var row=tbl.rows.length;
	var firstRow=tbl.rows[0];
	var RowItems=firstRow.all;
	
	for (var j=0;j<RowItems.length;j++) {
		///alert(RowItems[j].childNodes.length);
		///if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
		if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
			RowItems[j].style.display="none";
		} else {
		}
	}

	row=row-1;
	for (var j=1;j<row+1;j++) {
		var sLable=document.getElementById("TPaym"+ColIdx+'z'+j);
		var sTD=sLable.parentElement;
		sTD.style.display="none";
	}
}

function GetSum()
{   var i
    var Sum=0;deposit=0;xjsum=0,zhpsum=0,hpsum=0,xyksum=0,discountsum=0,dissum=0,paysharesum=0,patsharesum=0
    var ybsum=0
    var Objtbl=parent.frames['UDHCJFInvRpt'].document.getElementById('tUDHCJFdayInvRpt');
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
    var Objtbl=document.getElementById('tUDHCJFdayInvRpt');
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
/*
function PrintInv_click()
{   getpath();
    alert("0err");
    var i
    var Objtbl=document.getElementById('tUDHCJFdayInvRpt');
	var Rows=Objtbl.rows.length;
	var tdeptsum,patsum,sksum,tksum,ybsum
	tdeptsum=0,patsum=0,sksum=0,tksum=0,ybsum=0
	allnum=Rows-2
	zfnum=0
	
	for (i=1;i<=Rows-2;i++)
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
       SelRowObj=document.getElementById('Tstatusz'+i);
       var status=SelRowObj.innerText;       
       SelRowObj=document.getElementById('Tprtdatez'+i);
       var prtdate=SelRowObj.innerText;       
       SelRowObj=document.getElementById('Tprttimez'+i);
       var prttime=SelRowObj.innerText;       
       SelRowObj=document.getElementById('Tzynoz'+i);
       var zyno=SelRowObj.innerText;       
       SelRowObj=document.getElementById('Tybz'+i);
       var yb=SelRowObj.innerText;       
       if (status!=t['16']) 
       {tdeptsum=eval(tdeptsum)+eval(tdeposit)
        patsum=eval(patsum)+eval(total)
        ybsum=eval(ybsum)+eval(yb)}
        var tmpfee=eval(total)-eval(tdeposit)-eval(yb)
       
       bjfee="0.00",tfee="0.00"
       if (eval(tmpfee)>=0) 
       {  var bjfee=tmpfee
          if (status!=t['16']){ 
             sksum=eval(sksum)+eval(bjfee)}
          bjfee=eval(bjfee).toFixed(2).toString(10)   }
       else
       {  var tfee=tmpfee
          if (status!=t['16']){ 
             tksum=eval(tksum)+eval(tfee)}
          tfee=eval(tfee).toFixed(2).toString(10)    }      
      
       //var str=patname+"^"+regno+"^"+rcptno+"^"+total+"^"+tdeposit+"^"+xianjin+"^"+zhipiao+"^"+huipiao+"^"+gfjz+"^"+sldjz+"^"+payorshare+"^"+discount+"^"+patshare+"^"+status+"^"+prtdate
       
       if (status!=t['16']) 
       {   status=""      }
       else
       {   zfnum=zfnum+1  }
       yb=eval(yb).toFixed(2).toString(10)
       var str=patname+"^"+zyno+"^"+regno+"^"+tdeposit+"^"+total+"^"+yb+"^"+bjfee+"^"+tfee+"^"+""+"^"+rcptno+"^"+status    //+"^"+xianjin+"^"+zhipiao+"^"+zply+"^"+huipiao+"^"+hply+"^"+xyk+"^"+xykly+"^"+yb+"^"+qfamount+"^"+status+"^"+prtdate+"^"+prttime
       fpData[i-1]=str.split("^"); 
	}
	
	if (allnum>=1){
	   tdeptsum=eval(tdeptsum).toFixed(2).toString(10)
	   patsum=eval(patsum).toFixed(2).toString(10)
	   sksum=eval(sksum).toFixed(2).toString(10)
	   tksum=eval(tksum).toFixed(2).toString(10)
	   ybsum=eval(ybsum).toFixed(2).toString(10)
	   var str=t['17']+"^"+""+"^"+""+"^"+tdeptsum+"^"+patsum+"^"+ybsum+"^"+sksum+"^"+tksum+"^"+""+"^"+""+"^"+""    //+"^"+xianjin+"^"+zhipiao+"^"+zply+"^"+huipiao+"^"+hply+"^"+xyk+"^"+xykly+"^"+yb+"^"+qfamount+"^"+status+"^"+prtdate+"^"+prttime
       fpData[i-1]=str.split("^"); 
	}	
	SelRowObj=document.getElementById('Ttotalz'+(allnum+1));
	patfee=SelRowObj.innerText    
    PrintInvDetail()
    
}
*/
function PrintInv_click()
{
	CommonPrint('UDHCJFIPPrintInv');
}
document.body.onload = BodyLoadHandler;