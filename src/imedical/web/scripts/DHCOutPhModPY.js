//DHCOutPhModPY
//
var tblobj=document.getElementById("tDHCOutPhModPY");
var evtName;
var doneInit=0;
var focusat=null;
var SelectedRow = 0;
var pmiobj,pnameobj;
var stdateobj,enddateobj;
var phlobj,phwobj,locdescobj,phwdescobj,pydrobj,fydrobj,pynameobj,fynameobj;
var ctlocobj,useridobj;
var BResetobj,BPrintobj;
var printobj;

function BodyLoadHandler() {
  BResetobj=document.getElementById("BReset");
  if (BResetobj) BResetobj.onclick=Reset_click;
 var BUpdateobj=document.getElementById("BUpdate");
  if (BUpdateobj) BUpdateobj.onclick=updatepy;
  ctlocobj=document.getElementById("ctloc");
  useridobj=document.getElementById("userid");
 

}

function SelectRowHandler()	{
	
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	SelectedRow = selectrow;

}


function Reset_click()
{
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhModPY";
 }

function getpydr(value)
{
  var sstr=value.split("^")
  var fydrobj=document.getElementById("CPyDr")
     fydrobj.value=sstr[1]
}
function updatepy()
{
  var tblobj=document.getElementById("tDHCOutPhModPY");
  var Rows=tblobj.rows.length-1
  var pyname,pydr;
  pyname=document.getElementById("CPyName").value;
  pydr=document.getElementById("CPydr").value; 
  var i;
  for (i=1;i<=Rows;i++)
    {
	 var lh=document.getElementById("TCheckz"+i).value 
	 var phdrow=document.getElementById("TPhdrowz"+i).innerText
	 if (lh==true)
	   { 
	   var getmethod=document.getElementById('update');
        if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
        var retval=cspRunServerMethod(encmeth,phdrow,pydr)
        if (retval!=0){alert("Row"+i+t['01']);return;}
        document.getElementById("TPyNamez"+i).innerText=pyname
        document.getElementById("TPydrz"+i).innerText=pydr
	   } 
	    
    }
  	
}


document.body.onload = BodyLoadHandler;
