document.body.onload = BodyLoadHandler;
var stdate="",enddate=""
var careprovdr=""
var ctlocId=session['LOGON.CTLOCID'];
var url=location.search;
var reg=new RegExp("(^|&)"+"andocId"+"=([^&]*)(&|$)","i");
var r=url.substr(1).match(reg);
if(r!=null) careprovdr=unescape(r[2]);
document.getElementById("careprovdr").value=careprovdr;

function BodyLoadHandler()
{
	var objstdate=document.getElementById("stdate");
	var objenddate=document.getElementById("enddate");
    var today=document.getElementById("getToday").value;
    if (objstdate.value=="") {objstdate.value=today;}
    if (objenddate.value=="") {objenddate.value=today;}
    stdate=objstdate.value;
    enddate=objenddate.value;
	var obj=document.getElementById('btnSch');
	if (obj) {obj.onclick=btnSch_Click;}
	var obj=document.getElementById('btnDetails');
	if (obj) {obj.onclick=btnDetails_Click;}
}
function btnSch_Click()
{
	stdate=document.getElementById("stdate").value;
	enddate=document.getElementById("enddate").value;
	careprovdr=document.getElementById("careprovdr").value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPAnDocWork&stratdate="+stdate+"&enddate="+enddate+"&andocId="+careprovdr+"&ctlocId="+ctlocId;
	location.href=lnk; 
}
function GetCareprovdesc(str)
{
	var careprovStr=str.split("^");
	var obj=document.getElementById("careprovdesc")
	obj.value=careprovStr[1];
	var obj=document.getElementById("careprovdr")
	if(obj) obj.value=careprovStr[0];
}
function btnDetails_Click()
{
	stdate=document.getElementById("stdate").value;
	enddate=document.getElementById("enddate").value;
	if(careprovdr=="") careprovdr=document.getElementById("careprovdr").value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPWorkload&stratdate="+stdate+"&enddate="+enddate+"&andocId="+careprovdr+"&ctlocId="+ctlocId;
	//location.href=lnk;
	window.open(lnk,'_blank',"width="+screen.width+",height="+screen.height+",scrollbars=yes,top=0,left=0,toolbar=yes,menubar=yes,resizable=yes,location=yes,statue=yes");
}
function SelectRowHandler()
{
	var objtbl=document.getElementById('tDHCANOPAnDocWork');
    var eSrc=window.event.srcElement;
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    careprovdr=document.getElementById("ctctpdrz"+selectrow).value;
}