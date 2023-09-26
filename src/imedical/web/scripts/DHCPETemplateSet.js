//creat by zhouli
//DHCPETemplateSet.js


var CurRow=0
function BodyLoadHandler()
{	
	var obj;
	
	obj=document.getElementById("Add");
	if (obj) {obj.onclick=Add_Click;}
	
	obj=document.getElementById("Delete");
	if (obj) {obj.onclick=Delete_click;}
		
}



function Add_Click()
{  
   var textvalid="",value=""
   var obj
	
   obj=document.getElementById("TextValID");
    if (obj) { textvalid=obj.value};
	
	obj=document.getElementById("Value");
    if (obj) { value=obj.value};
    
    if (value=="") {
    alert(t['01']);
	return false;
	} 
     
    
    var Instring=value+"^"+textvalid
   
	var Ins=document.getElementById('AddBox')	
    if (Ins) {var encmeth=Ins.value; } 
	else {var encmeth=''; } 
    var flag=cspRunServerMethod(encmeth,'','',Instring) 
  
    if (flag==0)  
    
	{    window.location.reload();   
		//alert(t["Success"]);
		 
	}
	else
	{
		alert(t["Err"]);
	}
    }  
                     
function Delete_click()
{ 
   var num=""
  
   var id="" 
   
    if (CurRow==0) return;
    
   var obj=document.getElementById("TRowidz"+CurRow)
	
	if (obj) var num=obj.value;
	
	var obj=document.getElementById("TextValID")
	if (obj)  var id=obj.value;
	
	var Instring=id+"^"+num
	
	var encmeth="";
	var encmethobj=document.getElementById("DeleteBox");
	if (encmethobj) var encmeth=encmethobj.value;
	var flag=cspRunServerMethod(encmeth,'','',Instring);
	if (flag==0)
	{
		location.reload();
	}
	else
	{
		alert(t[flag]);
	}
	}
	
	
	
function SelectRowHandler(){  

	var eSrc=window.event.srcElement;
	
	var objtbl=document.getElementById('tDHCPETemplateSet');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	
	if (selectrow!=CurRow) {
	CurRow=selectrow;
	var obj;
	obj=document.getElementById("Delete");
	if (obj) obj.disabled=false;
	obj=document.getElementById("TRowidz"+CurRow);
	if (obj) var RowId=obj.value;
	obj=document.getElementById("Rowid");
	if (obj) obj.value=RowId;
	obj=document.getElementById("TValuez"+CurRow);
	if (obj) var RowId=obj.innerText;
	obj=document.getElementById("Value");
	if (obj) obj.value=RowId;
	}
	else { CurRow=0;
	var obj;
	obj=document.getElementById("Delete");
	if (obj) obj.disabled=true;
	obj=document.getElementById("Rowid");
	if (obj) obj.value="";
	obj=document.getElementById("Value");
	if (obj) obj.value="";}
}



document.body.onload = BodyLoadHandler;