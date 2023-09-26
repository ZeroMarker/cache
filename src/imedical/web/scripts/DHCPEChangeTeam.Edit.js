//DHCPEChangeTeam.Edit.js
//create by zholi
//
//
function BodyLoadHandler() 
{var obj;
	obj=document.getElementById("Save");
	if (obj) {obj.onclick=Save_click;}

   

	var obj=document.getElementById("Rowid")
	if(obj)  {var PIADM=obj.value}
	
	var Instring=PIADM
    var obj=document.getElementById("IADM")
	if (obj) {var encmeth=obj.value} else{var encmeth=""}
	var returnval=cspRunServerMethod(encmeth,Instring)
 

   init(returnval)	
	}

function init(returnval)
       
    {
      var tmp=returnval.split("^")
     document.getElementById("cName").innerText=tmp[0]
     document.getElementById("cTeam").innerText=tmp[1]
	
	}


function Save_click()
{ var obj 
  obj=document.getElementById("ChangeTeam")
  if(obj)  {var Tid=obj.value}
  obj=document.getElementById("Rowid")
  if(obj)  {var id=obj.value}
  
    var Instring=id+"^"+Tid
                          
    var encmeth="";
	var encmethobj=document.getElementById("ClassBox");
	if (encmethobj) var encmeth=encmethobj.value;
	var flag=cspRunServerMethod(encmeth,'','',Instring);
	
	if (flag==0)
	{
		alert(t["Success"]);
		window.close();   
	}
	else
	{
		alert(t["ERR"]);
	}
	}
document.body.onload = BodyLoadHandler;

