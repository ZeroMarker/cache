var tblobj=document.getElementById('tDHCOutPhQueryDispSub');
function BodyLoadHandler() {
	InitForm()
}
//医嘱为停止标志时，改为红色
function InitForm()   
{
	if (tblobj)
	{ 
	     var cnt=tblobj.rows.length-1;
	     for (var i=1;i<=cnt; i++) 
	          {		     
		           var objNostk=document.getElementById("TStatus"+"z"+i).innerText
		           if  (objNostk=="停止"){
			           var eSrc=tblobj.rows[i];
     				   var RowObj=getRow(eSrc);
					   RowObj.className="RedColor";}					
	          } 
    }
}  

document.body.onload = BodyLoadHandler;