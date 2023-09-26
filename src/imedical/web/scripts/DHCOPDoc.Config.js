document.body.onload = BodyLoadHandler;

function BodyLoadHandler(){
	var obj=document.getElementById("Update");

	if (obj){obj.onclick=SaveClickHandler;}
}

function SaveClickHandler(){
	var mystr=BuildStr();
	var encmeth=DHCC_GetElementData("SaveParaEncrypt");
	if ((encmeth!="")&&(mystr!="")){
		var rtnvalue=cspRunServerMethod(encmeth,mystr);
		alert(t["SaveOK"]);
		Update_click();
	}
}

function BuildStr(){
	var itemdataDelim = String.fromCharCode(1);
	var groupitemDelim = String.fromCharCode(2);

	var myary=new Array();
	
	myary[0]="StartRapidRegCardNo"+itemdataDelim+DHCC_GetElementData('StartRapidRegCardNo');
	myary[1]="EndRapidRegCardNo"+itemdataDelim+DHCC_GetElementData('EndRapidRegCardNo');
	//myary[2]="CurrentRapidRegCardNo"+itemdataDelim+DHCC_GetElementData('CurrentRapidRegCardNo');	
	
	var myInfo=myary.join(groupitemDelim);
	return myInfo;
}
