var CurRow=0
function BodyLoadHandler() 
{
	var obj
    obj=document.getElementById("Delete")
	if (obj) {obj.onclick=Delete_click}
	obj=document.getElementById("Close")
	if (obj) {obj.onclick=Close_click}
}

function trim(s) 
{
	if (""==s) {return ""}
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/)
	return (m == null) ? "" : m[0]
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
function Close_click()
{
	window.opener.location.reload();
	window.self.close();
	
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
