var path,wardid,warddesc,today;
var num,job
var typeobj,bylocobj
function BodyLoadHandler() {
	bylocobj=document.getElementById('Byloc');
	typeobj=document.getElementById('type');
	
	var obj=document.getElementById('Print');
	if (obj) obj.onclick = Print_Click;
	
	bylocobj.onclick=getbylocobjfun;
	bylocobj.checked=true
	typeobj.value="1";
	getpath();
}
function getpath() {
		   
			var getpath=document.getElementById('getpath');
			if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
		
			path=cspRunServerMethod(encmeth,'','')
			
	}


function getbylocobjfun()
{
	if (bylocobj.checked==true) 
	{typeobj.value="1";
	}
	else
	{typeobj.value=""}
	}


function Print_Click() {
	 
	 
	}


document.body.onload = BodyLoadHandler;