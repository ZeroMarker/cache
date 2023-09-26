var currRow;
var topFrame;
var bottomFrame;
function BodyLoadHandler()
{
	/*
	var objb=document.getElementById("BodyLoaded")
	if (objb){
		if (objb.value!=1){
			var obj=document.getElementById("Grpid")
			if (obj) var grpid=obj.value;		
			var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.PLOC&Grpid="+grpid+"&BodyLoaded=1";
			window.location.href=lnk;
		}
		
	}*/
}
function SelectRowHandler()
 {
   var row=selectedRow(window);
   //retrieve 
   RetrieveOrdCat(row);
}
function RetrieveOrdCat(row)
{
	var obj=document.getElementById("Trowid"+"z"+row)
	if (obj) var rowid=obj.innerText;		
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.PRIORITYLIST&Locid="+rowid;
	parent.frames['DHCST.PIVA.PRIORITYLIST'].location.href=lnk;
	//bottomFrame.location.href=lnk;
	
}
document.body.onload=BodyLoadHandler