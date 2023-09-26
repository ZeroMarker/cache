
function BodyLoadHandler() {
	iniForm();

	}

function iniForm() {	
	var obj=document.getElementById("cDep");
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;
	  }
	}

document.body.onload = BodyLoadHandler;