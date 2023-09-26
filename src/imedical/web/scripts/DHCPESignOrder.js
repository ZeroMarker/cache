//DHCPESignOrder.js
// create by zhouli
// 2008-03-19
var CurRow=0
function BodyLoadHandler() {
  
	var obj;
	obj=document.getElementById("Add");
	if (obj) {obj.onclick=Add_click;}
    obj=document.getElementById("Delete");
	if (obj) {obj.onclick=Delete_click;}
	var obj=document.getElementById('OrderName');
	if (obj) obj.onkeydown=OrderName_KeyDown;
	
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[0];
}	

function OrderInfo(value) {
	if (value=="") return;
   var tmp=value.split("^")
    var obj=document.getElementById('OrderName');
    obj.value=tmp[0];
    var obj=document.getElementById('OrderID');
   obj.value=tmp[1];
    }
    
    
function OrderName_KeyDown()
{   
	var key=websys_getKey(e);
	if (13==key) {
		var obj=document.getElementById('GDComponentID');
		if (obj) var ComponentID=obj.value;
	    var obj=document.getElementById('ld'+ComponentID+'iOrderName');
		if (obj) obj.click();return false;
		}
}   
    
    
    
    
 function Add_click()
    
 {  
 
	var ID=""
	var iOrderID="",iOrderName="" 
	var obj=document.getElementById("OrderID");
    if (obj) {iOrderID=obj.value;}
 
    var obj=document.getElementById("OrderName");
    if (obj) {iOrderName=obj.value;}
    
       var Instring=trim(iOrderID)
	                      +"^"+trim(iOrderName)
	if (iOrderID=="") { 
		
		alert(t['02']);
		return
		}  
                  
	var Ins=document.getElementById('ClassBox')	
    if (Ins) {var encmeth=Ins.value; } 
	else {var encmeth=''; } 
   
    var flag=cspRunServerMethod(encmeth,'','',Instring) 
    if (flag==0)  
    
	{    window.location.reload();   
		alert(t["Success"]);
		 
	}
	else
	{
		alert(t["Err"]);
	}
}

function Delete_click()
{   var ID=""
	if (CurRow==0) return;
	
	var obj=document.getElementById("TOrderIDz"+CurRow)
	if (obj) var ID=obj.value;

    var obj=document.getElementById("TOrderNamez"+CurRow)
	if (obj) var Sequence=obj.innerText;
		
	var string=trim(ID)
	var encmeth="";
	var encmethobj=document.getElementById("DeleteBox");
	if (encmethobj) var encmeth=encmethobj.value;
	else encmeth="";

	var flag=cspRunServerMethod(encmeth,string);
		
	if (flag==0)
	{
		location.reload();
	}
	else
	{
		alert(t[flag]);
	}
	}
	
	
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	
	var objtbl=document.getElementById('tDHCPESignOrder');	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var Row=rowObj.rowIndex;
	if (Row==CurRow)
	{
		CurRow=0      
	
	}
	else
	{
		CurRow=Row;
	}
	
  
	
	var obj=document.getElementById("TItemNamez"+CurRow)
	var objItemName=document.getElementById("ItemName")
	if (objItemName)  objItemName.value=obj.innerText;


	


      var obj=document.getElementById("TItemIDz"+CurRow)
  
	var objItemId=document.getElementById("ItemID")
	if (objItemId)  objItemId.value=obj.value;
   
    

 

	



}	

document.body.onload = BodyLoadHandler;

