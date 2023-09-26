/////udhcOPHandin.ParkINVDetail.js

function BodyLoadHandler()
{
	var obj=document.getElementById("uName");
	if (obj){
		////alert(obj.value);
		obj.value=unescape(obj.value);
	}
}

document.body.onload = BodyLoadHandler;

