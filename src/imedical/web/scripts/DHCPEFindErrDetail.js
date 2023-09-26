/// DHCPEQMType.js

var CurrentSel=0

function BodyLoadHandler() {
   
	var obj;
	var tbl=document.getElementById("tDHCPEFindErrDetail");
	if(tbl) tbl.ondblclick=DHC_SelectErrDetail;
	

}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
function DHC_SelectErrDetail() { 
    var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow !=0) {
		var value="",ErrDetail="",ErrUserID="",ErrUser="";
		var obj=document.getElementById("ErrDetailz"+selectrow);
		if (obj) ErrDetail=obj.innerText;
		var obj=document.getElementById("UserIDz"+selectrow);
		if (obj) ErrUserID=obj.value;
		var obj=document.getElementById("UserNamez"+selectrow);
		if (obj) ErrUser=obj.innerText;
		var ExpStr="";
		var obj=document.getElementById("ExpStr");
		var ExpStr=obj.value;
		if (opener){
			var obj=opener.document.getElementById("ErrDetail");
			if (obj) obj.value=ErrDetail;
			if ((ExpStr!="GA")&&(ExpStr!="GR")){
				var obj=opener.document.getElementById("ErrUserID");
				if (obj) obj.value=ErrUserID;
				var obj=opener.document.getElementById("ErrUser");
				if (obj) obj.value=ErrUser;
			}
		}
		window.close();
	}
}
document.body.onload = BodyLoadHandler;