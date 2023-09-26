function BodyLoadHandler()
{
	var schobj=document.getElementById("Search");
    if (schobj) {schobj.onclick=sch_click;}
    var obj=document.getElementById("printdate");
    obj.value=DateDemo();
    var userid=session['LOGON.USERID'];
	var GetUserWardId=document.getElementById("GetUserWardId").value;
	var wardstr=cspRunServerMethod(GetUserWardId,userid,session['LOGON.CTLOCID']);
	if (wardstr!="")
	{
		getwardid(wardstr);
    }
}
function DateDemo(){
   var d, s="";           
   d = new Date();                         
   s += d.getDate() + "/";                   
   s += (d.getMonth() + 1) + "/";          
   s += d.getYear();                         
   return(s);                               
}

function sch_click()
{
    
    var PrintDate=document.getElementById("printdate").value;
    var wardid=document.getElementById("wardid").value;
    var ward=document.getElementById("ward").value;
    if (wardid=="")
    {
	    alert("select ward!");
	    return false;
	}
	var loc=""
	if (session['LOGON.CTLOCID']==214)
	{
		loc=session['LOGON.CTLOCID'];
	}else
	{
		loc=""
	}
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNursePrintedPaTb"+"&curWardId="+wardid+"&fDateStr="+PrintDate+"&tDateStr="+PrintDate+"&ward="+ward+"&loc="+"";
    parent.frames['RPbottom'].location.href=lnk; 
//session['LOGON.CTLOCID'];
//	window.open(lnk,"","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=300,width=300,top=-100,left=300");

}
function OrdExcute_click()
{
	var objtbl=document.getElementById('tDHCNURSEXCUTE');
	var rowid;
	rowid="";
	for (i=1;i<objtbl.rows.length;i++)
	{
//	   var eSrc=objtbl.rows[i];
//	   var RowObj=getRow(eSrc);
	   var item=document.getElementById("seleitemz"+i);
	   if (item.checked==true)
       {
	       var basedose=document.getElementById("doseQtyUnitz"+i).innerText;
           var oeoriId=document.getElementById("oeoriIdz"+i).innerText;
           var arcicId=document.getElementById("arcicIdz"+i).innerText;
           rowid=rowid+"^"+basedose+"!"+oeoriId+"!"+arcicId+"!"+i;
           // alert(arc.innerText);
	   }
	
	}
    // alert(rowid);
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCORDEXCUTE"+"&AAA=1&BBB="+rowid;
	window.open(lnk,"Ordexcute","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=300,width=300,top=-100,left=300");
	
}
function SearCH_click()
{
	var method=document.getElementById("schord");
	var wardno=document.getElementById("wardid").value;
	var regno=document.getElementById("RegNo").value;
	var userid=session['LOGON.USERID'];
    var mthallpatient=document.getElementById("getallpatient");
	if (method) {var encmeth=method.value} else {var encmeth=''};
    if (cspRunServerMethod(encmeth,'','',wardno,regno,userid)=='0') {
		}
	if (mthallpatient) {var encmeth=mthallpatient.value} else {var encmeth=''};
    if (cspRunServerMethod(encmeth,'getallord','',userid)=='0') {
		}
}
function saveward(str)
{
	var obj=document.getElementById('wardid');
	var tem=str.split("^");
	obj.value=tem[1];
}
function getwardid(str)
{
	var obj=document.getElementById('wardid');
	var tem=str.split("|");
	var temward=tem[0].split("^");
	obj.value=temward[1];
//	alert( tem[1]);
	var obj=document.getElementById('ward');
	obj.value=temward[0];
	//var imgdept=document.getElementById("ld50116iward"); 
	//alert("ssddf");
	//imgdept.style.display ="none";

	
	return;
	
}

document.body.onload = BodyLoadHandler;