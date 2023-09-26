///UDHCJFBillDetail.js
var Guser,BillNo
var printobj,job
var path,tmpstr,num,pross
var hospital
var valuepainfo,nameobj,panoobj,mednoobj,sexobj,ctlocobj,patareaobj
var paname,pano,medno,sex,ctloc,patarea
var job
//*****yyb
var MyPrtAry=new Array();
var MyAryIdx=0
//*****
function BodyLoadHandler() 
{
	nameobj=document.getElementById('Name');
	panoobj=document.getElementById('pano');
	mednoobj=document.getElementById('medno');
	sexobj=document.getElementById('sex');
	ctlocobj=document.getElementById('ctloc');
	patareaobj=document.getElementById('patarea');
	Guser=session['LOGON.USERID']
	var billnoobj=document.getElementById('BillNo');
	BillNo=billnoobj.value
	printobj=document.getElementById('Print');
	printobj.onclick=print_click;
	GetNum();
	getpath();
	gethospital();
	getpatinfo(); 	   
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
function getpatinfo()
{
	  p1=BillNo
	  var getpatinfoobj=document.getElementById('getpatinfo');
	  if (getpatinfoobj) {var encmeth=getpatinfoobj.value} else {var encmeth=''};
	  tmpstr=cspRunServerMethod(encmeth,'','',p1)
	  var valuepainfo1=tmpstr.split("#")[0]
	  var valuepainfo=valuepainfo1.split("^");  
	  pano=valuepainfo[0]
	  paname=valuepainfo[1]
	  medno=valuepainfo[2]
	  sex=valuepainfo[4]
	  var valueadminfo1=tmpstr.split("#")[1]
	  var valueadminfo=valueadminfo1.split("^");
	  //add by wangjian 20170412 界面日期范围为空 取计费范围日期
	  var stdate=valueadminfo[0]
	  var enddate=valueadminfo[1]
	  var stdateobj=document.getElementById("stdate")
	  var enddateobj=document.getElementById("endate")
	  if ((stdateobj)&&(!stdateobj.value)){
		  
		  stdateobj.value=stdate
		}
	if ((enddateobj)&&(!enddateobj.value)){
		  
		  enddateobj.value=enddate
		}
	  //
	  ctloc=valueadminfo[3]
	  patarea=valueadminfo[4]  
	  panoobj.innerText=pano;
	  nameobj.innerText=paname;
	  mednoobj.innerText=medno;
	  sexobj.innerText=sex;
	  ctlocobj.innerText=ctloc;
	  patareaobj.innerText=patarea;
	  var EncryptLevelObj=document.getElementById('EncryptLevel')
	  if(EncryptLevelObj){EncryptLevelObj.innerText=valuepainfo[12]}
	  var PatLevelObj=document.getElementById('PatLevel')
	  if(PatLevelObj){PatLevelObj.innerText=valuepainfo[13]}
	  var PrtLevelObj=document.getElementById('PrtLevel')
	  if(PrtLevelObj){PrtLevelObj.value=valuepainfo[14]}
}
function GetNum() 
{
	var Objtbl=document.getElementById('tUDHCJFBillDetail');
	var SelRowObj=document.getElementById('Tjobz'+1);
    job=SelRowObj.innerText;
    var getnum=document.getElementById('getnum');
	if (getnum) {var encmeth=getnum.value} else {var encmeth=''};
	var str	
	str=cspRunServerMethod(encmeth,'','',BillNo,job)
    str=str.split("^")
    num=str[0]
   
}
function ListPrt(gnum)
{   
    var list=document.getElementById('list');
	if (list) {var encmeth=list.value} else {var encmeth=''};
	var str	
	str=cspRunServerMethod(encmeth,'','',BillNo,job,gnum)
	return str
}

function print_click()
{ 
  	//PrintBillDetail();
  	var Objtbl=document.getElementById('tUDHCJFBillDetail');
	var SelRowObj=document.getElementById('Tjobz'+1);
    job=SelRowObj.innerText;
	var BillNO=document.getElementById("BillNo").value;
	var stdate=document.getElementById("stdate").value;
	var enddate=document.getElementById("endate").value;
	var rtn = tkMakeServerCall("web.UDHCJFBillDetail", "GetBillNum", BillNO,job);
	if(rtn==0){alert("没有需要打印的数据!");return;}
	var fileName="DHCIPBILLFindBillInfo.raq&BillNo="+BillNO+"&job="+job+"&stdate="+stdate+"&enddate="+enddate;

	DHCCPM_RQPrint(fileName,800,500);
  
}

function CellMerge(objSheet,r1,r2,c1,c2)
{
	var range= objSheet.Range(objSheet.Cells(r1, c1),objSheet.Cells(r2,c2))
	range.MergeCells ="True"
}
function CellLine(objSheet,row1,row2,c1,c2,Style)
{     
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(Style).LineStyle=1;
}
/*
//----- add 2008-02-21 by lc 报表生成器 -----
function CommonPrint(ReportName)
{
	var myxmlstr=(DHCDOM_WriteXMLInParameter());
	var myobj=document.getElementById('CPMReport');
	if (myobj)
	{
		myobj.PrintCommonReport(ReportName, myxmlstr);
	}
}
function print_click()
{
	var SelRowObj=document.getElementById('Tjobz'+1);
	job=SelRowObj.innerText;
	document.getElementById('job').value=document.getElementById('Tjobz'+1).innerText
	CommonPrint('UDHCJFIPbrmxqd')

}
//          ----------  end  ----------
*/
function UnloadHandler()
{	
	var KillTMPPrtGlbobj=document.getElementById("KillTmp");
	if (KillTMPPrtGlbobj) {var encmeth=KillTMPPrtGlbobj.value} else {var encmeth=''};
	var mytmp=cspRunServerMethod(encmeth,BillNo,job)
}

document.body.onload = BodyLoadHandler;
document.body.onbeforeunload=UnloadHandler;