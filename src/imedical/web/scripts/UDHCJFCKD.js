///UDHCJFCKD.js
var path,wardid,warddesc,today;
var num,job
var hospital
var printflag 
var wardobj
function BodyLoadHandler() {
	var obj=document.getElementById('Print');
	if (obj) obj.onclick = PrintCKD_Click;
	var obj=document.getElementById('BtnSelectPrint');
	if (obj) obj.onclick=SelectCKDPrint_Click;
	var prtobj=document.getElementById("outExp");
  	if (prtobj)
  	{
     	 prtobj.onclick=outExp_click;	  
  	}

	
	var obj=document.getElementById('RegNo');
	if (obj) obj.onkeydown = getadm;
       wardobj=document.getElementById('ward');
	if (wardobj) wardobj.onkeyup=clearwardid;
	if (wardobj) wardobj.onkeydown=getward;
	getpath();
	gettoday();
	gethospital();
	printflag="All"
	if (document.getElementById('getwardid').value==""){
		var DefWardID=session['LOGON.WARDID']
		document.getElementById('getwardid').value=DefWardID
		var DefWardDesc=tkMakeServerCall("web.UDHCJFCKD","getWardDescByID",DefWardID)
		document.getElementById('ward').value=DefWardDesc
	}
	var balanceobj=document.getElementById('balance');
	if (balanceobj){
		balanceobj.onkeypress = balance_KeyPress;
	}
}
function getadm()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	    var regno=document.getElementById('RegNo').value
           var getadm=document.getElementById('getadm');
           if (getadm) {var encmeth=getadm.value} else {var encmeth=''};
	    var adm=cspRunServerMethod(encmeth,regno)
           document.getElementById('Adm').value=adm;
           window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFCKD&Adm="+adm}
	}
function gethospital()
{
	var gethospital=document.getElementById('gethospital');
	if (gethospital) {var encmeth=gethospital.value} else {var encmeth=''};
	hospital=cspRunServerMethod(encmeth)
}
function getpath() 
{
	var getpath=document.getElementById('getpath');
    if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	    path=cspRunServerMethod(encmeth,'','')
}
function clearwardid()
{
	var wardidobj=document.getElementById('getwardid');
	//wardidobj.value="";
	//document.getElementById('ward').value=""
	if (document.getElementById('ward').value==""){
		wardidobj.value="";
		}
}
function gettoday(){
	var gettoday=document.getElementById('gettoday');
	if (gettoday) {var encmeth=gettoday.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'setdate_val','','')=='1'){};
	}
function setdate_val(value)
	{
		today=value;
		}
function GetNum() {
	var Objtbl=document.getElementById('tUDHCJFCKD');
	var SelRowObj=document.getElementById('Tjobz'+1);
    //job=SelRowObj.innerText;
    job=SelRowObj.value;
	wardid=document.getElementById('getwardid').value;
    var getnum=document.getElementById('getnum');
	if (getnum) {var encmeth=getnum.value} else {var encmeth=''};
	var str	
	//str=cspRunServerMethod(encmeth,'','',wardid,job)
    str=cspRunServerMethod(encmeth,'','',job)
    str=str.split("^")
    num=str[0]
     
	}
function ListPrt(gnum)
{   var list=document.getElementById('list');
	if (list) {var encmeth=list.value} else {var encmeth=''};
	var str	
	//str=cspRunServerMethod(encmeth,'','',wardid,job,gnum)
	
	str=cspRunServerMethod(encmeth,'','',job,gnum)
	return str
}
	


function getwardid(value)	{
	var val=value.split("^");
	var obj=document.getElementById('getwardid');
	obj.value=val[1];
       

}
function getward()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  ward_lookuphandler();
		}
	}
function gettypeid(value)	{

	var val=value.split("^");
	//var obj=document.getElementById('typeid');
	//obj.value=val[1];

}

function outExp_click()
{
	//CommonPrint('UDHCJFIPYJGZL');
  //getwardid As %String, balance As %String, Adm As %String, admreasondesc 
	var getwardid=document.getElementById("getwardid").value;
	var balance=document.getElementById("balance").value;
	var Adm=document.getElementById("Adm").value;
	var admreasondesc=document.getElementById("admreasondesc").value;
	
	var fileName="DHCBill_押金催款单.raq&getwardid="+getwardid+"&balance="+balance+"&Adm="+Adm+"&admreasondesc="+admreasondesc
	//alert("fileName="+fileName)
	DHCCPM_RQPrint(fileName,800,500);
}
/**
 * Creator: Zhli
 * CreatDate: 2018-02-27
 * Description: 控制只能输入数字
 */
function balance_KeyPress() {
	var key = event.keyCode;
	if (((key > 47) && (key < 58)) || (key == 46)||((key == 45)) || (key == 13)) {
		//如果输入金额过长导致溢出计算有误
		if (this.value.length > 11) {
			window.event.keyCode = 0;
			return websys_cancel();
		}
	} else {
		
		window.event.keyCode = 0;
		return websys_cancel();
	}
}
document.body.onload = BodyLoadHandler;
