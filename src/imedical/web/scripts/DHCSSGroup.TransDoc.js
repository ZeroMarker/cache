function BodyLoadHandler()
{
	 var objtbl=document.getElementById("t"+"DHCSSUser_TransDoc")
     if (objtbl) objtbl.ondblclick=Savedata;
}

document.body.onload=BodyLoadHandler;