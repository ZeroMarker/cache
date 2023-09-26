var CurRow=0
function BodyLoadHandler() 
{
	var obj
	obj=document.getElementById("Add")
	if (obj) {obj.onclick=Add_click}
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

function OtherInfo(value) 
{
	if (value=="") return;
    var tmp=value.split("^")
    var obj=document.getElementById("OtherStation")
    obj.value=tmp[0]
    var obj=document.getElementById("OtherID")
    obj.value=tmp[1]
}
       
function Add_click()   
{
	var iOtherID="",iOtherStation="" 
	var obj=document.getElementById("OtherID")
    if (obj) {iOtherID=obj.value}
    var obj=document.getElementById("OtherStation")
    if (obj) {iOtherStation=obj.value}
    var Instring=trim(iOtherID)
	                      +"^"+trim(iOtherStation)
    if (iOtherID=="")
     { 
		alert(t['00'])
        return
     }  
    var Ins=document.getElementById("ClassBox")	
    if (Ins) 
    {
	    var encmeth=Ins.value
	} 
	else 
	{
		var encmeth=""
    } 
    var flag=cspRunServerMethod(encmeth,'','',Instring) 
    if (flag==0)   
	{
		window.location.reload()
    }
}

function Delete_click()
{   
    var itotherid="",itotherstation=""
	if (CurRow==0) return;
	var obj=document.getElementById("TOtherIDz"+CurRow)
	if (obj) var itotherid=obj.value;

    var obj=document.getElementById("TOtherStationz"+CurRow)
	if (obj) var itotherstation=obj.innerText;
		
	var string=trim(itotherid)
	                     +"^"+trim(itotherstation)
    
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

