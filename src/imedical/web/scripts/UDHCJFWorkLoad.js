
///UDHCJFWorkLoad.js
var stdate,enddate,path
function BodyLoadHandler() 
{  //alert("00")
 //Insertpaymode();
  var prtobj=document.getElementById("Print");
  if (prtobj)
  {
      prtobj.onclick=Print_click;	  
  }
}
function Print_click()
{
	//CommonPrint('UDHCJFIPYJGZL');
	//alert("00")
	var stdate=document.getElementById("stdate").value;
	var enddate=document.getElementById("enddate").value;
	var grp=document.getElementById("grp").value;
	var fileName="DHCBill_住院工作量统计.raq&stdate="+stdate+"&enddate="+enddate+"&grp="+grp
	//alert("fileName="+fileName)
	DHCCPM_RQPrint(fileName,800,500);
}
/*
function Print_click()
{   
    stdate=document.getElementById("stdate").value;
    enddate=document.getElementById("enddate").value;
	var getpath=document.getElementById('getpath');	
	if (getpath) 
	{
		var encmeth=getpath.value
	} 
	else 
	{
      var encmeth=''
    }
	path=cspRunServerMethod(encmeth,'','');
	var gettoday=document.getElementById('gettoday');
		if (gettoday) {
			var encmeth=gettoday.value
		}
		else{
			var encmeth=''
		}
			today=cspRunServerMethod(encmeth)
			myData1=today.split("^")
			datetoday=myData1[0]	
	PrintWorkLoadNX()
}
*/
function Insertpaymode()
{  
	var catobj=document.getElementById("getpaymode");
	if (catobj) {var encmeth=catobj.value} else {var encmeth=''};
	var payminfo=cspRunServerMethod(encmeth);
	var objtbl=document.getElementById("tUDHCJFWorkLoad");
	var Rows=objtbl.rows.length;
	var firstRow=objtbl.rows[0];
	///alert(firstRow);
	var RowItems=firstRow.all;
	///alert(catinfo);
	var paymtmp =payminfo.split("^");
	var paymnum=paymtmp.length;
	for (var i=1;i<=paymnum;i++)
	{
		var ColName="Tpay"+i;
		for (var j=0;j<RowItems.length;j++) 
		{
			if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH'))
			{
				RowItems[j].innerHTML=paymtmp[i-1];
			}
		}
	}
}
document.body.onload = BodyLoadHandler;