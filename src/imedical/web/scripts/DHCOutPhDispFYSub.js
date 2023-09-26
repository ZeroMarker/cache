//DHCOutPhDispFYSub
var bottomFrame;
var topFrame;
var tblobj=document.getElementById('tDHCOutPhDispFYSub');


function BodyLoadHandler() {
 
    if (tblobj.rows.length==1) {return 0;}
    for (var i=1;i<=tblobj.rows.length-1;i++)
    { 
	 var  manflag=document.getElementById("TManFlagz"+i).value
     if (manflag=='1'){
	 var eSrc=tblobj.rows[i];
     var RowObj=getRow(eSrc);
	 RowObj.className="RedColor";}
    }
     document.onkeydown=DHCOutPhWeb_DocumentOnKeydownFY
}

document.body.onload = BodyLoadHandler;
