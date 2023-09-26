////udhcOPInv.SingleOrder.js

function bodyLoadHandler(){
	document.onkeydown = Doc_OnKeyDown;
	
}


function Doc_OnKeyDown()
{
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	var e=window.event;	
	parent.window.FrameShutCutKeyFrame(e);	
	
	DHCWeb_EStopSpaceKey();
}

document.body.onload=bodyLoadHandler;

