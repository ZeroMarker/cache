//creat by zhouli
//DHCPEIllnessExplain.js


var CurRow=0
function BodyLoadHandler()
{	
	var obj;
	
	obj=document.getElementById("Save");
	if (obj) {obj.onclick=Save_Click;}
	
	obj=document.getElementById("LinkType");
	if (obj){var LinkType=obj.value
	if (LinkType=="2")
	{obj=document.getElementById("cIllExplain");
	 if (obj){obj.innerText="运动指导"}
	 var obj=document.getElementById("cTitle");
     if(obj){obj.innerText="运动指导";}

	}
	if (LinkType=="3")
	{obj=document.getElementById("cIllExplain");
	 if (obj){obj.innerText="饮食指导"}
	 var obj=document.getElementById("cTitle");
     if(obj){obj.innerText="饮食指导";}

	}
	}
	Init()	
}

function Init()
{   
    var Type="",IllRowID="";
	var obj=document.getElementById("LinkType");
	if (obj){Type=obj.value}
	var obj=document.getElementById("IllRowID");
    if (obj){IllRowID=obj.value};
    var Ins=document.getElementById('GetInfo')	
    if (Ins) {var encmeth=Ins.value; } 
	else {var encmeth=''; } 
    var Return=cspRunServerMethod(encmeth,IllRowID,Type) 
    var IllExplain=Return.split("@@")[0]
    var PrintFlag=Return.split("@@")[1]

    var obj=document.getElementById("IllExplain");
    if (obj) { obj.value=IllExplain};
     
    var obj=document.getElementById("PrintFlag");
    if ((obj)&&(PrintFlag=="Y")) { 
             obj.checked=true
              } ;
	}

function Save_Click()
{  
   var IllRowID="",IllExplain="",PrintFlag="N",LinkType="";
   var obj
	
    obj=document.getElementById("IllRowID");
    if (obj) { IllRowID=obj.value};
    
     obj=document.getElementById("LinkType");
    if (obj) { LinkType=obj.value};
	
	obj=document.getElementById("IllExplain");
    if (obj) { IllExplain=obj.value};
    
    obj=document.getElementById("PrintFlag");
    if (obj&&obj.checked) { PrintFlag="Y"} ;
    
    if (IllRowID=="") {
    alert(t['01']);
	return false;
	} 
     
    
    var Instring=IllRowID+"^"+IllExplain+"^"+LinkType+"^"+PrintFlag
   
	var Ins=document.getElementById('DataBox')	
    if (Ins) {var encmeth=Ins.value; } 
	else {var encmeth=''; } 
    var flag=cspRunServerMethod(encmeth,Instring) 
  
    if (flag==0)  
    
	{   parent.close();
		 
	}
	else
	{
		alert(flag);
	}
    }  
                     




document.body.onload = BodyLoadHandler;