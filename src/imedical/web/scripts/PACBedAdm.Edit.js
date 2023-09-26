var timerenabled=true;
/*
function documentLoadHandler() {
	StayOnTop();
}

function StayOnTop() {
	// only stayontop if no lookups are open, need to do it this way because websys_windows.length doesnt decrement when lookup closed
	var lookups=0;
	//for (var i=0;i<websys_windows.length;i++) if (!websys_windows[i].closed) lookups++;
	if (!lookups) this.focus();
	if (timerenabled) window.setTimeout(StayOnTop,500);
}*/

function BedAdmBodyOnloadHandler() {
	var obj=document.getElementById("Date");
	if (obj) obj.onblur=StartDateBlurHandler;
}

function DisableOnTop() {
	timerenabled=false;
}

function StartDateBlurHandler(e) {
	var eobj=websys_getSrcElement(e);
	if (eobj) {
		var obj=document.getElementById("DateH");
		if ((obj)&&(eobj.value!="")) obj.value=DateStringTo$H(eobj.value);
		if ((obj)&&(eobj.value=="")) obj.value=obj.defaultValue;
	}
}

// ab 5.05.03 - dont allow them to hide the screen in the taskbar, additional blurhandler added
//window.onblur=StayOnTop;
//document.body.onload=documentLoadHandler;
document.onclick=DisableOnTop;
document.body.onload = BedAdmBodyOnloadHandler;