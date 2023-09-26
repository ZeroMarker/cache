////udhcOPHandin.FootQuery.js

function bodyLoadHandler(){
	document.onkeydown = Doc_OnKeyDown;
	
}


function Doc_OnKeyDown()
{
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
	
	///F7
	///F8
	///F9
	///F8	119   ≤È—Ø
	///Alt+R
	switch (key){
		case 119:
			FQuery_click();
			break;
	}
	
	DHCWeb_EStopSpaceKey();
}

document.body.onload=bodyLoadHandler;

