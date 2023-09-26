// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentLoadHandler() {
	if (self==top) websys_reSizeT()
}

document.body.onload=DocumentLoadHandler;