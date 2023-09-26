//DHCOutPhDispPYSub
var bottomFrame;
var topFrame;
var tblobj=document.getElementById('tDHCOutPhDispPYSub');
var ctloc=document.getElementById("ctloc").value
//var maintbl=document.getElementById('tDHCOutPhDispPY');

function BodyLoadHandler() {
 
    if (tblobj.rows.length==1) {return 0;}
    for (var i=1;i<=tblobj.rows.length-1;i++)
    { 
    
    
	 var  manflag=document.getElementById("TManFlagz"+i).value
     if (manflag=='1'){
	 var eSrc=tblobj.rows[i];
     var RowObj=getRow(eSrc);
	 RowObj.className="RedColor";}
	 var orditm=document.getElementById("TOrditmz"+i).value
	 var qty=document.getElementById("TPhQtyz"+i).innerText
	 var getmethod=document.getElementById('chdispmachine');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
  
     var retval=cspRunServerMethod(encmeth,ctloc,orditm,qty)
     if (retval=="1"){document.getElementById("TDispMachinez"+i).innerText=t['dispmachine']}
     

    }
}

document.body.onload = BodyLoadHandler;
