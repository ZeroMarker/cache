function BodyLoadHandler() {
    var obj=document.getElementById("Test");
	  if (obj) obj.onclick=Query_click;
	
	}
function Query_click() {
	
	var strMethod = document.getElementById("Method").value;
	var ret = cspRunServerMethod(strMethod, "");
	var obj = document.getElementById("txt");
	obj.value=ret;
	
	}

document.body.onload = BodyLoadHandler;