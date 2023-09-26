//DHCRisAppTemplList.js
//DHCRisAppTemplList.js
var selectrow;

function BodyLoadHandler()
{	
    var QueryFeeObj=document.getElementById("Find");
	if (QueryFeeObj)
	{
		QueryFeeObj.onclick=Find_click1;
	}
	var AddObj=document.getElementById("Add");
	if (AddObj)
	{
		AddObj.onclick=Add_click1;
	}
	var CancelObj=document.getElementById("Cancel");
	if (CancelObj)
	{
		CancelObj.onclick=Cancel_click1;
	}
	var PersonTempObj=document.getElementById("PersonTemp");
	if (PersonTempObj)
	{
		PersonTempObj.onclick=PersonTempClick;
	}
	var DeleteObj=document.getElementById("Delete")
	if (DeleteObj)
	{
		DeleteObj.onclick=DeleteClick1;
	}
	
  
}
function PersonTempClick()
{
	var UserIDOBJ=document.getElementById("UserID");
	var PersonTempObj=document.getElementById("PersonTemp");
    if (PersonTempObj.checked)
    {
	    UserIDOBJ.value="";
	   
    }
    else
    {
	    UserIDOBJ.value=session['LOGON.USERID']; 
	    
    }

	
}
function Add_click1()
{
    var Content=document.getElementById("Contentz"+selectrow).innerText;
	var orddoc=opener.document;
    var ordtab=orddoc.getElementById("PatientNow");
    if (ordtab)
    {
	  ordtab.innerText=Content   
    }
    close();
    
}
function Cancel_click1()
{
	//alert("close");
	close();
	
}
function Find_click1()
{
	  //alert("cc");
	  var  UserIDOBJ=document.getElementById("UserID");
	  var CheckOBj=document.getElementById("PersonTemp");
	  //alert(CheckObj);
	  
  	  if (CheckOBj.checked)
  	  {
	  	  UserIDOBJ.value="";
	  	  //session['LOGON.USERID'];
	  	  //alert(UserIDOBJ.value);
  	  }
  	 
	return Find_click();
	
	
	
}
function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisAppTemplList');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	selectrow=rowObj.rowIndex;
     
    
    var Content=document.getElementById("Contentz"+selectrow).innerText;
    var orddoc=opener.document;
    var ordtab=orddoc.getElementById("PatientNow");
    //alert(ordtab);
    if (ordtab)
    {
	  ordtab.innerText=Content   
    }
    
}

function DeleteClick1()
{
	//alert("aa");
	var Rowid=document.getElementById("ROWIDz"+selectrow).value;
	var DeleteFunction=document.getElementById("DeleteStatus").value;
	var SQLCODE=cspRunServerMethod(DeleteFunction,Rowid);
	//alert(SQLCODE);
	if (SQLCODE!="0")
	{
	   alert("Delete Failure");
	}
    return Delete_click();
 }

document.body.onload = BodyLoadHandler;

