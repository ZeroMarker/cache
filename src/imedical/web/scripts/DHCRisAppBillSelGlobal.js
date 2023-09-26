////DHCRisAppBillSelGlobal
var selectrow;

function BodyLoadHandler()
{	
    var exitObj=document.getElementById("exit");
	if (exitObj)
	{
		exitObj.onclick=exitObj_click1;
	}
	
	var AddObj=document.getElementById("Add");
	if (AddObj)
	{
		AddObj.onclick=Add_click1;
	}
}

function exitObj_click1()
{
	close();
}

function Add_click1()
{
  var GlobalDesc="";
  
  var ordtab=document.getElementById("tDHCRisAppBillSelGlobal");
  if (ordtab) 
  {
     for (var i=1; i<ordtab.rows.length; i++)
     {
        var selectedobj=document.getElementById("SelGlobalz"+i);
        if ((selectedobj)&&(selectedobj.checked))
        {
	        var perGlobal=document.getElementById("GlobalDescz"+i).innerText;
	        if (GlobalDesc!="")
	        {
	        	GlobalDesc=GlobalDesc+","+perGlobal;
	        }
	        else
	        {
		        GlobalDesc=perGlobal;
		    }	        
	    }
	  } 
   }
  // alert(GlobalDesc);
   var orddoc=opener.document;
   var purposetxt=orddoc.getElementById("purpose");
   if (purposetxt)
   {
	 purposetxt.innerText=GlobalDesc;
	    
   }
   close();
  
}




document.body.onload = BodyLoadHandler;


