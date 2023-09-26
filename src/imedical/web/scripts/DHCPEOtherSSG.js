var CurRow=0
function BodyLoadHandler() 
{
    var obj;
	obj=document.getElementById("Add")
	if (obj) {obj.onclick=Add_click}
    obj=document.getElementById("Delete")
	if (obj) {obj.onclick=Delete_click}
}

function trim(s) 
{
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[0];
}	

function OtherInfo(value) 
{
	if (value=="") return;
    var tmp=value.split("^")
    var obj=document.getElementById("OtherSSG")
    obj.value=tmp[0]
    var obj=document.getElementById("OtherID")
    obj.value=tmp[1]
}
    
function Add_click()   
{  
	var iOtherID="",iOtherSSG="" 
	var obj=document.getElementById("OtherID")
    if (obj) {iOtherID=obj.value}
 
    var obj=document.getElementById("OtherSSG")
    if (obj) {iOtherSSG=obj.value}
    
    var Instring=trim(iOtherID)
	                      +"^"+trim(iOtherSSG)
    if (iOtherID=="") 
    { 
		alert(t['00']);
        return
    }  
                  
	var Ins=document.getElementById("ClassBox")	
    if (Ins) {var encmeth=Ins.value} 
	else {var encmeth=""} 
    var flag=cspRunServerMethod(encmeth,'','',Instring) 
    if (flag==0)   
	{window.location.reload()}
}

function Delete_click()
{
	var itotherid="",iotherssg=""
	if (CurRow==0) return;
	
	var obj=document.getElementById("TOtherIDz"+CurRow)
	if (obj) var itotherid=obj.value;

    var obj=document.getElementById("TOtherSSGz"+CurRow)
	if (obj) var iotherssg=obj.innerText;
		
	var string=trim(itotherid)
	                     +"^"+trim(iotherssg)
	var encmeth="";
	var encmethobj=document.getElementById("DeleteBox");
	if (encmethobj) var encmeth=encmethobj.value;
	else encmeth="";
	var flag=cspRunServerMethod(encmeth,string);	
	if (flag==0)
	{ window.location.reload()}
}
		
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	
	var objtbl=document.getElementById('tDHCPEOtherSSG');	
	var rowObj=getRow(eSrc);
	var Row=rowObj.rowIndex;
	if (Row==CurRow)
	{CurRow=0}
	else
	{CurRow=Row}
}	
document.body.onload = BodyLoadHandler;