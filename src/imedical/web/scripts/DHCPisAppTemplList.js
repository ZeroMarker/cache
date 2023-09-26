//DHCPisAppTemplList.js

var selectrow;

function BodyLoadHandler()
{	
    
	var AddObj=document.getElementById("Add");
	if (AddObj)
	{
		AddObj.onclick=Addkey;
	}

	var DeleteObj=document.getElementById("Delete")
	if (DeleteObj)
	{
		DeleteObj.onclick=Deletekey;
	}
	
  
}

function Addkey()
{
	//alert("1")
	var DCCode=document.getElementById("DCCodez"+selectrow).value;
	//alert(DCCode)
    var Content=document.getElementById("DCContentz"+selectrow).innerText;
	var orddoc=opener.document;
    var Crtab=orddoc.getElementById("ClinicRecord");
    var Ostab=orddoc.getElementById("OperationSee");
    if (DCCode==2)
    {
	    //alert("2")
	  Crtab.innerText=Content   
    }
    else if (DCCode==3)
    {
	    //alert("3")
	  Ostab.innerText=Content 
	}
    close();
    
}

function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	//alert(eSrc)
	var objtbl=document.getElementById('tDHCPisAppTemplList');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	selectrow=rowObj.rowIndex;
     
    /*
    var Content=document.getElementById("Contentz"+selectrow).innerText;
    var orddoc=opener.document;
    var ordtab=orddoc.getElementById("PatientNow");
    //alert(ordtab);
    if (ordtab)
    {
	  ordtab.innerText=Content   
    }
    */
}

function Deletekey()
{
	
	var Rowid=document.getElementById("DCRowidz"+selectrow).value;

	var DeleteFunction=document.getElementById("DeleteStatus").value;
	var SQLCODE=cspRunServerMethod(DeleteFunction,Rowid);
    Refresh();
 }
 
 function Refresh()
 {
	var DirDR=document.getElementById("DirDR").value;
	var docdr=document.getElementById("docdr").value;
	var DCCode=document.getElementById("DCCodez"+selectrow).value;
    location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCPisAppTemplList"+"&DirDR="+DirDR+"&UserID="+docdr+"&Code="+DCCode;
    
 }

document.body.onload = BodyLoadHandler;

