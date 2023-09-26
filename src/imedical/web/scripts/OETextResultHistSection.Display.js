// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// this will be done on the load - we will open our own document
document.body.onload = BodyLoadHandler;

function BodyLoadHandler() {
	var obj=document.getElementById('Results');
	if (obj) {
		obj.readOnly=true;
		websys_firstfocus();
	}
}

