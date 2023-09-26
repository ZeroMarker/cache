// DHCPEOrdSets.SelLoc.js
var CurRow=0;

function BodyLoadHandler() {
	var obj=document.getElementById("BDelete");
	if (obj) { obj.onclick=BDelete_click; }
	
	obj=document.getElementById("BClose");
	if (obj) { obj.onclick=BClose_click; }
}

function trim(s) {
	if (""==s) { return; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[0];
}	

// 添加科室
function LocInfo(value) {
    if (value=="") return;
    var ilocid="",irowid="";
    var tmp=value.split("^");                                      
    ilocid=tmp[1];
    	
    var obj=document.getElementById("ARCOSRowId");
    if(obj){irowid=obj.value};	
    var Instring=trim(ilocid)+"^"+trim(irowid);
    var flag=tkMakeServerCall("web.DHCPE.OrderSets","OrdSetsSetLoc",Instring,1);
    if (flag==0) { 
    location.reload(); 
    }
}
      
function BDelete_click() {
    var ilocid="",irowid="";
	if (CurRow>0) {
		var obj=document.getElementById("LocIdz"+CurRow);
		if (obj) var ilocid=obj.value;
	
		var obj=document.getElementById("ARCOSRowId");
		if (obj) var irowid=obj.value;
  	
		var Instring=trim(ilocid)+"^"+trim(irowid);
		var flag=tkMakeServerCall("web.DHCPE.OrderSets","OrdSetsSetLoc",Instring,0);

		if (flag==0) { window.location.reload(); }
	} else {
		alert("请选择科室！");
		return false;
	}
}

function BClose_click() {
	window.opener.location.reload(); 
	opener.BClear_click(); 
	window.self.close();
}
	
function SelectRowHandler()	{	
	var eSrc = window.event.srcElement;	
	var rowobj=getRow(eSrc);
	var Row=rowobj.rowIndex;
	if (Row==CurRow) { CurRow=0; }
	else { CurRow=Row; }
}	
document.body.onload=BodyLoadHandler;