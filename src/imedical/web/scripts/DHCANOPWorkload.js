var stdate="",enddate=""
var ctlocId=session['LOGON.CTLOCID'];
var careprovdr="";
var url=location.search;
var reg=new RegExp("(^|&)"+"andocId"+"=([^&]*)(&|$)","i");
var r=url.substr(1).match(reg);
if(r!=null) careprovdr=unescape(r[2]);
document.getElementById("careprovdr").value=careprovdr;

function BodyLoadHandler()
{
	//var myDate=new Date();
	//var myYear=myDate.getFullYear();
	//var myMonth=myDate.getMonth()+1;
	//var myDay=myDate.getDate();
	//var obj=document.getElementById('opdate');
	//if(obj.value=="") obj.value=myDay+"/"+myMonth+"/"+myYear;
	//alert(date.toLocaleDateString())
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
	//btnSch_Click();
}
function btnSch_Click()
{
	stdate=document.getElementById("stdate").value;
	enddate=document.getElementById("enddate").value;
	careprovdr=document.getElementById("careprovdr").value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPWorkload&stratdate="+stdate+"&enddate="+enddate+"&andocId="+careprovdr+"&ctlocId="+ctlocId;
	location.href=lnk; 
}
function btnDetails_Click()
{
	stdate=document.getElementById("stdate").value;
	enddate=document.getElementById("enddate").value;
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPWorkloadDetails&stratdate="+stdate+"&enddate="+enddate+"&andocId="+careprovdr+"&ctlocId="+ctlocId;
	//location.href=lnk;
	if(careprovdr=="") careprovdr=document.getElementById("careprovdr").value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPWorkloadDetails&stratdate="+stdate+"&enddate="+enddate+"&andocId="+careprovdr+"&ctlocId="+ctlocId;
	window.open(lnk,'_blank',"width="+screen.width+",height="+screen.height+",scrollbars=yes,top=0,left=0,toolbar=yes,menubar=yes,resizable=yes,location=yes,statue=yes");
}
function SelectRowHandler()
{
	var objtbl=document.getElementById('tDHCANOPWorkload');
    var eSrc=window.event.srcElement;
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    //var selrow=document.getElementById("selRow");
    //selrow.value=DHCWeb_GetRowIdx(window);
    //careprovdr=document.getElementById("ctctpdrz"+selectrow).innerText;
    careprovdr=document.getElementById("ctctpdrz"+selectrow).value;
}
function GetCareprovdesc(str)
{
	var careprovStr=str.split("^");
	var obj=document.getElementById("careprovdesc")
	obj.value=careprovStr[1];
	var obj=document.getElementById("careprovdr")
	if(obj) obj.value=careprovStr[0];
}
document.body.onload = BodyLoadHandler;