//DHCOutPhOweListSub

tblobj=document.getElementById('tDHCOutPhOweListSub');
ctloc=document.getElementById("ctloc").value

function BodyLoadHandler() 
{
 
    setColor() ;
	document.onkeydown=KeyDownHandler
}

function setColor()
{
	if (tblobj.rows.length==1) {return 0;} 
	  
    for (var i=1;i<=tblobj.rows.length-1;i++)
    { 
		 var  manflag=document.getElementById("TKCFlagz"+i).value
	     if (manflag=='1')
	     {
		     ///��治��
			 var eSrc=tblobj.rows[i];
		     var RowObj=getRow(eSrc);
			 RowObj.className="RedColor";
		 }
		 
		 var  manflag=document.getElementById("TKCFlagz"+i).value
	     if (manflag=='1')
	     {
		     ///��Ч��
			 var eSrc=tblobj.rows[i];
		     var RowObj=getRow(eSrc);
			 RowObj.className="RedColor";
		 }

    }
}
function KeyDownHandler()
{
	if (window.event.keyCode==13){
		event.preventDefault(); //����keydown�¼�
		return;
		
	}
}

document.body.onload = BodyLoadHandler;
