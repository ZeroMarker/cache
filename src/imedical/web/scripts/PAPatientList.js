// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyOnloadHandler() {
	EPR_ClearSelectedEpisode();
}

function BodyOnUnloadHandler() {
	EPR_SaveSelectedEpisode();
}

function ClickHandler(e) {
	EPR_SelectEpisode(e);
	return false;
}
function KeypressHandler(e) {
	return EPR_GotoShortcutMenu(e);
}

document.body.onload=BodyOnloadHandler;
//document.body.onunload=BodyOnUnloadHandler;
document.onclick = ClickHandler;
document.onkeypress = KeypressHandler;