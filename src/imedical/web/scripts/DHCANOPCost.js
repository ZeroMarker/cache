var stdate="",enddate=""
var ctlocId=session['LOGON.CTLOCID'];
document.body.onload = BodyLoadHandler;
var isClick=1;  //选择按科室查询时isClick=1选择按病人查询时isClick=0默认按科室查询
var url=location.search;
var reg=new RegExp("(^|&)"+"isClick"+"=([^&]*)(&|$)","i");
var r=url.substr(1).match(reg);
if(r!=null) isClick=unescape(r[2]);
if(isClick==1) document.getElementById('chbByLoc').checked=true;
else document.getElementById('chbByPat').checked=true;

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
    var obj=document.getElementById('chbByLoc');
    if(obj) obj.onclick=ChbByLoc_Click;
    var obj=document.getElementById('chbByPat');
    if(obj) obj.onclick=ChbByPat_Click;    
	var obj=document.getElementById('btnSch');
	if (obj) {obj.onclick=btnSch_Click;}
	//btnSch_Click();
}
function btnSch_Click()
{
	stdate=document.getElementById("stdate").value;
	enddate=document.getElementById("enddate").value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPCost&stratdate="+stdate+"&enddate="+enddate+"&ctlocId="+ctlocId+"&isClick="+isClick;
	location.href=lnk; 
}
function ChbByLoc_Click()
{
	var obj=document.getElementById('chbByPat');
	obj.checked=false;
	isClick=1;
}
function ChbByPat_Click()
{
	var obj=document.getElementById('chbByLoc');
    obj.checked=false;
    isClick=0;

}