

function BodyLoadHandler(){
    var objtbl=document.getElementById('tDHCNurSchPSPat');
	
	var i=0;
    for (i=1;i<objtbl.rows.length;i++)
	{
	  var eSrc=objtbl.rows[i];
	   var RowObj=getRow(eSrc);
       var item2=document.getElementById("arcimdesz"+i).innerText;
	   var skinY,skinN;
	   skinY=item2.indexOf("(+)");
	   skinN=item2.indexOf("(-)");
	   if (skinY!=-1){
		  RowObj.className="SkinTest"
	   }
	   if (skinN!=-1){
		  RowObj.className="Green"
	   }
	}
	var objlocdesc=document.getElementById('locdesc');
	if(objlocdesc) objlocdesc.onchange=setLocDesc;
}
function setLocDesc(){
	var objlocdesc=document.getElementById('locdesc');
	if(objlocdesc.value==""){
		obj=document.getElementById("locid")
		obj.value="";
	}	
}
function getlocid(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("locid")
	obj.value=loc[2];
	
}
document.body.onload = BodyLoadHandler;
