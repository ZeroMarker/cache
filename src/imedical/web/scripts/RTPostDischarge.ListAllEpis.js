// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function SelectRowHandler(e) {  // *****  Log# 28200; AmiN ; 10/09/2002 *****  
	var eSrc=""; var arry=""; var rowsel=""; var EpisodeID="";
	eSrc=websys_getSrcElement(e);	 
	arry=eSrc.id.split("z");		 
	rowsel=arry[arry.length-1];	
	var eobj=document.getElementById("EpisodeIDz"+rowsel);
	if (eobj) EpisodeID=eobj.innerText;

	if (eSrc.id=="EpisodeNoz"+rowsel) {  
		//if (window.opener) eSrc.target = window.opener.name;  
		var epObj=document.getElementById("EpisodedIDz"+rowsel);
		var url="rtpostdischarge.edit.csp?EpisodeID="+EpisodeID;

		if (window.opener) window.opener.location.href=url;

		//window.close(); 
		return true;
	}	
}

