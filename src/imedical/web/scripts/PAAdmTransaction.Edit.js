var timerenabled=true;

//child = flag to test whether the window is in a child window or main medtrak window
var child=null;
if (window.parent) var child=!window.parent.frames["eprmenu"];

/*
if (child) StayOnTop();

function StayOnTop(e) {
	// only stayontop if no lookups are open, need to do it this way because websys_windows.length doesn't decrement when lookup closed
	var lookups=0;
	//for (var i=0;i<websys_windows.length;i++) if (!websys_windows[i].closed) lookups++;
	if (!lookups) this.focus();
	if (timerenabled) window.setTimeout(StayOnTop,500);
}*/

function DisableOnTop(evt) {
	timerenabled=false;
}

document.onclick=DisableOnTop;
// ab 5.05.03 - dont allow them to hide the screen in the taskbar, additional blurhandler added
//if (child) window.onblur=StayOnTop;