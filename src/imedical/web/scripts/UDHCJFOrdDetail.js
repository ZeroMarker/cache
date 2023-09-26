var pborowid,oldqty,newqtyGuser
var SelectedRow = 0;

function BodyLoadHandler() {
	 GetSum()    
	 Guser=session['LOGON.USERID']
	 var updobj=document.getElementById('update');
	 if (updobj) updobj.onclick=update_click;
	 
}
function update_click()
{  
	if (oldqty=="")
    {   alert(t['01'])
        return ;}
    newqty=document.getElementById('newqty').value
    if (newqty=="")
    {   alert(t['02'])
        return ;}
    if (oldqty==newqty)
    {
	    alert(t['03']);
	    return;
    }
    var upd=document.getElementById('adjust');
	if (upd) {var encmeth=upd.value} else {var encmeth=''};
   
	var err=cspRunServerMethod(encmeth,pborowid,newqty,Guser) 
	if (err!=0)
	{
		alert(t['04'])
		return;
	}
	if (err==0)
	{  alert(t['05']);
	   window.location.reload();
	   return;
	}
			
	
}
function GetSum()
{   var price,discount,payorshare,patshare,  
    sum=0;discountsum=0;payorsharesum=0;patsharesum=0;
    var Objtbl=document.getElementById('tUDHCJFOrdDetail');
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
function SelectRowHandler()	
{  	
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tUDHCJFOrdDetail');
	Rows=Objtbl.rows.length;
	GetSum()
	
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	var obj=document.getElementById('oldqty');
	obj.value=document.getElementById('Tqtyz'+selectrow).innerText
	oldqty=obj.value
	pborowid=document.getElementById('Trowidz'+selectrow).innerText
	
}
document.body.onload = BodyLoadHandler;