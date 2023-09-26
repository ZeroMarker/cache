//DHCRisStatics
//var gLocID="";

function BodyLoadHandler()
{
	var Deleteobj=document.getElementById("Delete");
	if (Deleteobj)
	{
	   Deleteobj.onclick=DeleteMessage;
	}
 	
}
function DeleteMessage()
{
  var ordtab=document.getElementById("tDHCRisUnProcessHL7");
  if (ordtab) 
  {
	 var DeleteHL7OBJ=document.getElementById("DeleteFunction").value;
     for (var i=1; i<ordtab.rows.length; i++)
     {
        var selectedobj=document.getElementById("Selectz"+i);
        if ((selectedobj)&&(selectedobj.checked))
        {
	       var Index=document.getElementById("Indexz"+i).innerText;
	       var value=cspRunServerMethod(DeleteHL7OBJ,Index);
	    }
	  } 
	  
    }
    alert("Delete Success!");


	
}


document.body.onload = BodyLoadHandler;


