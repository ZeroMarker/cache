function BodyLoadHandler() {
	 GetSum()    
}
function GetSum()
{   var price,discount,payorshare,patshare  
    sum=0;discountsum=0;payorsharesum=0;patsharesum=0;
    var Objtbl=document.getElementById('tUDHCJFItmDetail');
	var Rows=Objtbl.rows.length;
	for (i=1;i<=Rows-2;i++)
	{
	   SelRowObj=document.getElementById('Tpricez'+i);
	   price=SelRowObj.innerText; 
	   SelRowObj=document.getElementById('Tdiscountz'+i);
	   discount=SelRowObj.innerText;
	   SelRowObj=document.getElementById('Tpayorsharez'+i);
	   payorshare=SelRowObj.innerText;
	   SelRowObj=document.getElementById('Tpatsharez'+i);
	   patshare=SelRowObj.innerText;
	   
	   sum=eval(sum)+eval(price)
	   discountsum=eval(discountsum)+eval(discount)
	   payorsharesum=eval(payorsharesum)+eval(payorshare)
	   patsharesum=eval(patsharesum)+eval(patshare)
	   obj=document.getElementById('sum');
	   obj.value=sum.toFixed(2)
	   obj=document.getElementById('discount');
	   obj.value=discountsum.toFixed(2)
	   obj=document.getElementById('payorshare');
	   obj.value=payorsharesum.toFixed(2)
	   obj=document.getElementById('patshare');
	   obj.value=patsharesum.toFixed(2)
	}
}
function bill() {
    if (Adm!=""){
	    p1=Adm;
	    var useridobj=document.getElementById('userid');
		p2=useridobj.value;
		var getbill=document.getElementById('getbill');
		if (getbill) {var encmeth=getbill.value} else {var encmeth=''};
		if (cspRunServerMethod(encmeth,'','',p1)=='1'){
					alert(t['01']);
				}
		else
		{alert(t['02']);}				
			}		
	}

document.body.onload = BodyLoadHandler;