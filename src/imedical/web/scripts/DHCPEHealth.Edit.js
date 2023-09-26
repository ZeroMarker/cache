function BodyLoadHandler()
{
	var obj
	obj=document.getElementById("Save")
	if(obj) {obj.onclick=Save_click} 
}

function trim(s)
{
	if (""==s) { return ""}
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/)
	return (m == null) ? "" : m[0]
}

function Save_click()
{
	var obj
	obj=document.getElementById("Get")
	if(obj) {var encmeth=obj.value} else {encmeth=""}
	var returnval=cspRunServerMethod(encmeth,'','')
    var tmp=returnval.split("^") 
	
	var i=2,Instring=""
	for(;i<=tmp[0];i=i+3)
	{
		var iItemName="",ItemName="",DisplayType="",Hidden="",j=i+1,k=i+2
		var ItemName=tmp[i],DisplayType=tmp[j],Hidden=tmp[k]
		if(DisplayType=='T')
	    {var obj
	    obj=document.getElementById(ItemName)
	    if (obj)
	    {iItemName=obj.value}}
	    
	    if(DisplayType=='C')
	    {var obj
	    obj=document.getElementById(ItemName)
	    if(obj.checked)
	    {iItemName='1'}
	    else
	    {iItemName='0'}}
	    
	    if(DisplayType=='B'||Hidden=='1')
	    {continue}
	    
	    Instring=Instring+"^"+trim(iItemName)
	}
           
	var Ins=document.getElementById("Savebox")	
    if (Ins) {var encmeth=Ins.value} else {var encmeth=""}
	var flag=cspRunServerMethod(encmeth,'','',Instring)
    if (flag==0)  
    {window.location.reload()}
}

document.body.onload=BodyLoadHandler