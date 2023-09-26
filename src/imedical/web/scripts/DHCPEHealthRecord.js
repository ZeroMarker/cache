var CurRow=0
function BodyLoadHandler() 
{
	var obj
	obj=document.getElementById("Save")
	if (obj) {obj.onclick=Save_click}
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

function Save_click()   
{
	var iRowId="",iCode="",iCName="",iHealthName=""
	
	var obj=document.getElementById("RowId")
    if (obj) {iRowId=obj.value}
	var obj=document.getElementById("Code")
    if (obj) {iCode=obj.value}
    var obj=document.getElementById("CName")
    if (obj) {iCName=obj.value}
    var obj=document.getElementById("HealthName")
    if (obj) {iHealthName=obj.value}
       
    if(iCode=="")
    {
	    alert(t["00"]);
        return
    }
    
    var Instring=trim(iRowId)
	                      +"^"+trim(iCode)
	                      +"^"+trim(iCName)
	                      +"^"+trim(iHealthName)
 
    var Ins=document.getElementById("ClassBox")	
    if (Ins) 
    {var encmeth=Ins.value} 
	else 
	{var encmeth=""} 
    var flag=cspRunServerMethod(encmeth,'','',Instring) 
    if (flag==0)   
	{
		window.location.reload()
    }
}

function Delete_click()
{   
    var itrowid=""
	if (CurRow==0){return}
	var obj=document.getElementById("TRowIdz"+CurRow)
	if (obj) {var itrowid=obj.value}
    
	var string=trim(itrowid)
    
    var encmeth=""
	var encmethobj=document.getElementById("DeleteBox")
	if (encmethobj) {var encmeth=encmethobj.value}
	else {encmeth=""}
	var flag=cspRunServerMethod(encmeth,string)	
	if (flag==0)
	{
		window.location.reload()
	}
}
		
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement	
	var rowobj=getRow(eSrc)
	var Row=rowobj.rowIndex
	if (Row==CurRow)
	{CurRow=0}
	else
	{CurRow=Row}
}
document.body.onload=BodyLoadHandler









			
