// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyOnloadHandler() {
	EPR_ClearSelectedEpisode();
}

function BodyOnUnloadHandler() {
	EPR_SaveSelectedEpisode();
}

function ClickHandler(evt) {
	var eSrc=websys_getSrcElement(evt);
	EPR_SelectEpisode(eSrc);
	return false;
}
function KeypressHandler(evt) {
	return EPR_GotoShortcutMenu(evt);
}

document.body.onload=BodyOnloadHandler;
//document.body.onunload=BodyOnUnloadHandler;
document.onclick = ClickHandler;
document.onkeypress = KeypressHandler;