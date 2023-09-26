// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function SSUserDefWindow_List_BodyLoadHandler(e) {
   	//if (self==top) websys_reSizeT(e);
	//Create links against the items that have audit fields to display
	tk_DisableRowLink("tSSUserDefWindow_List","WINDesc","HasComponent","N");
}
document.body.onload = SSUserDefWindow_List_BodyLoadHandler;
