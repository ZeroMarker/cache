//DHCPEOrdSets.js
// create by zhouli

var CurRow=0
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("Delete");
	if (obj) {obj.onclick=Delete_click;}
    obj=document.getElementById("DeitFlag");
	if (obj) {obj.onclick=DeitFlag_click;}
	var obj=document.getElementById('ItemName');
	if (obj) obj.onkeydown=ItemName_KeyDown;
	obj=document.getElementById("SelectLoc")
	if(obj) {obj.onclick=SelectLoc_click}  
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[0];
}	
function LocInfo(value) 
{
    if (value=="") return;
    var  ilocid="",irowid=""
    var tmp=value.split("^")
    if (CurRow==0)
    {var obj=document.getElementById("AddLoc")
     obj.value="Œ¥—°‘Ò“Ω÷ˆ"
     return}
    var obj=document.getElementById("LocId")
    obj.value=tmp[1]                                       //Add By Ypp
    ilocid=tmp[1]
    var obj=document.getElementById("ROWIDz"+CurRow)
    if(obj){irowid=obj.value}
    var Instring=trim(ilocid)+"^"+trim(irowid)
    var Ins=document.getElementById("AddBox")	
    if (Ins) 
    {var encmeth=Ins.value} 
    else 
    {var encmeth=""} 
    var flag=cspRunServerMethod(encmeth,Instring) 
    if (flag==0)
	{location.reload()}
}
function OrdSetsAfter(value) {
	
	if (value=="") return;
    var tmp=value.split("^")
    var obj=document.getElementById('OrderID');
    obj.value=tmp[1];
    if (tmp[3]!="")
    {
	var Instring=tmp[1] ; 
                    
    var Ins=document.getElementById('classbox')	    
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring); 
	
	if (flag==0) location.reload();   
    }
 }
 

function Delete_click()
{   var ID=""
	if (CurRow==0) return;
	var obj=document.getElementById("ROWIDz"+CurRow)
	if (obj) var ID=obj.value;
	var encmeth="";
	var encmethobj=document.getElementById("DeleteBox");
	if (encmethobj) var encmeth=encmethobj.value;
	var flag=cspRunServerMethod(encmeth,ID);
	if (flag==0)
	{
		location.reload();
	}
	else
	{
		alert(t[flag]);
	}
}
	
	
	// create 2-16
	// ≈–∂œ «∑Ò”–‘Á≤Õ
function DeitFlag_click()
{ 
    var obj=document.getElementById("TDeitFlagz"+CurRow)
    if ( "N"==obj.innerText)  {obj.innerText="Y"}
    else if ("Y"==obj.innerText)  {obj.innerText="N"}
    var id=document.getElementById("ROWIDz"+CurRow)
    var Instring=obj.innerText+"^"+id.value; //trim(id)              
    var Ins=document.getElementById('Save')	    
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring); 
	if (flag==0) location.reload();   
	
}	
function SelectLoc_click()
{
    var rowid=""
    if (CurRow==0) return;
    var obj=document.getElementById("ROWIDz"+CurRow)                //Add by Ypp
    if (obj) var rowid=obj.value;
    var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCPESelectLocOrd&RowId='+rowid
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top=200,left=500,width=300,height=400')
}	
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	                    
	var objtbl=document.getElementById('tDHCPEOrdSets');	
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
	var rowid=""
	if (CurRow==0) return;
	var obj=document.getElementById("ROWIDz"+CurRow)
	if (obj) var rowid=obj.value;
	var Ins=document.getElementById("Info")	         //Add by Ypp
        if (Ins) {var encmeth=Ins.value} 
        else {var encmeth=""} 
        var flag=cspRunServerMethod(encmeth,rowid)
	obj=document.getElementById("Loc");
	if (obj){obj.value=flag;}
}	

document.body.onload = BodyLoadHandler;

