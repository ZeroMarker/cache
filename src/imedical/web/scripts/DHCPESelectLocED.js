var CurRow=0
function BodyLoadHandler() 
{
	var obj
    obj=document.getElementById("Delete")
	if (obj) {obj.onclick=Delete_click}
}

function trim(s) 
{
	if (""==s) {return ""}
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/)
	return (m == null) ? "" : m[0]
}	
function LocInfo(value) 
{
    if (value=="") return;
    var  ilocid="",irowid=""
    var tmp=value.split("^")                                   //Add By Ypp
    ilocid=tmp[1]
    var obj=document.getElementById("ParrefRowId")
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
function Delete_click()
{   
    var ilocid="",iloc="",irowid=""
	if (CurRow==0) return;
	var obj=document.getElementById("TLocIdz"+CurRow)
	if (obj) var ilocid=obj.value;
	
	var obj=document.getElementById("TRowIdz"+CurRow)
	if (obj) var irowid=obj.value;

    var obj=document.getElementById("TSelectLocz"+CurRow)
	if (obj) var iloc=obj.innerText;
		
	var string=trim(ilocid)
	                     +"^"+trim(iloc)
                         +"^"+trim(irowid)
    var encmeth="";
	var encmethobj=document.getElementById("DeleteBox")
	if (encmethobj) var encmeth=encmethobj.value
	else encmeth="";
	var flag=cspRunServerMethod(encmeth,string)	
	if (flag==0)
	{
		window.location.reload()
	}
}
		
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	
	var rowobj=getRow(eSrc);
	var Row=rowobj.rowIndex;
	if (Row==CurRow)
	{CurRow=0}
	else
	{CurRow=Row}
}	
document.body.onload=BodyLoadHandler;
