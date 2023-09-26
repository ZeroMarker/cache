///UDHCJFDayDetail.js
var SelectedRow = 0;
var regnoobj
var fromdate,todate,warddesc,path
var myData1= new Array();
var myData2= new Array();
var myData3= new Array();
var hbflag;
var hb2
var hospital
var patcount //patient num
var p1,p2,p3,p4
var patstr
var cols
var patwardobj,orddept,DepGroup
var typeobj
var tmppat
var findflag
var Guser

function BodyLoadHandler() {
	findflag="Y"
	regnoobj=document.getElementById('RegNo');
	regnoobj.onkeydown = getpat;
	var obj=document.getElementById('Print');
	obj.onclick=Print_click;
	//var obj=document.getElementById('PrintDay');
	//obj.onclick=PrintDay_click; //病区汇总单
	hb2=document.getElementById('hb');
	hb2.onclick=hb1_click;
	var obj=document.getElementById('stdate');
	obj.onchange=change_click;
	var obj=document.getElementById('enddate');
	obj.onchange=change_click;
	
	hbflag=document.getElementById('hbflag');
	//hbflag.value="1"
	if (hb2.checked==true)
	{  hbflag.value=1 }
	
	if (hbflag.value==1)
	{ 
	   hb2.checked=true }
	else
	{  hb2.checeked=false  }
	//insert by cx 2006.05.26
	typeobj=document.getElementById('type');
	typeobj.onkeydown=gettype;
	patwardobj=document.getElementById('patward');
	patwardobj.onkeydown=getpatward;
	patwardobj.onkeyup=clearpatwardid;
	orddept=document.getElementById('orddept');
	orddept.onkeyup=clearorddeptid
	DepGroup=document.getElementById('DepGroup');
	DepGroup.onkeyup=clearDepGroupid
	var listobj=document.getElementById('PatList');
	Guser=session['LOGON.USERID']
	document.getElementById('Guser').value=Guser
	
	listselected(listobj);
	getpath();
	gethospital();
	//GetRegNoWard();
	//ad 080619
	var objWardID=document.getElementById('wardid')
	if(objWardID.value=="")
	{
	objWardID.value=session['LOGON.WARDID']
			//alert("wardID")
	}
	if(objWardID) 
	{
			wardID=objWardID.value
			var getWardDescByID=document.getElementById('getWardDescByID')
			if(getWardDescByID)
			{
					var wardDesc=cspRunServerMethod(getWardDescByID.value,wardID)
					var objWard=document.getElementById('patward')
					if(objWard)
					{
							objWard.value=wardDesc
					}
			}
	}
}
function Find_click()
{
	findflag="Y"
}
function change_click()
{
	findflag="N"

}
//qse add 20060706
function GetRegNoWard()
{
	var Adm=document.getElementById("EpisodeID").value;
	var WardLoc=session['LOGON.CTLOCID'];
	var RegNo=document.getElementById("RegNo");
	var wardid=document.getElementById("wardid");
	var patward=document.getElementById("patward");
	var GetRegNo=document.getElementById("GetRegNo").value;
	var Getward=document.getElementById("wardfun").value;
	//if ((Adm!="")||(RegNo.value!=""))
	//{
	//	var patinfo=cspRunServerMethod(GetRegNo,Adm);
	//	var tem=patinfo.split("^");
	//	RegNo.value=tem[0];
	//}
	
	var str=cspRunServerMethod(Getward);
	
	if (str!="")
	{
		var t=str.split("^");
		wardid.value=t[0];
		patward.value=t[1];
	}
}
function gethospital()
{
	var gethospital=document.getElementById('gethospital');
	if (gethospital) {var encmeth=gethospital.value} else {var encmeth=''};
		
	hospital=cspRunServerMethod(encmeth)
	
}
function hb1_click()
{  
   if (hb2.checked==true) 
	{   
		hbflag.value="1"  }
	else
	{   hbflag.value="0"  }
	
}
function getpath() {
		   
			var getpath=document.getElementById('getpath');
			if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
		
			path=cspRunServerMethod(encmeth,'','')
			
	}
function LookUpWard(str)
{   
	var obj=document.getElementById('wardid');
	var tem=str.split("^");
	obj.value=tem[1];
}
function LookUpType(str)
{
	var obj=document.getElementById('typeid');
	var tem=str.split("^");
	obj.value=tem[1];
}
function PrintDay_click()
{
	var num=tkMakeServerCall("web.UDHCJFDayDetail","ReDayData",Guser)
	tsData =new Array()
	for (var i=1;i<=num;i++)
	{	
		var str=tkMakeServerCall("web.UDHCJFDayDetail","GetDayData",i)
		//alert(str)
		tsData[i] = str.split("^");//存入tsData用^分割
	}
	
	getpath();
		
	var Template=path+"DHCJFDay.xls"
	//var Template="d:\\DHCJFDay.xls"
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet
	
	var stdate=document.getElementById('stdate');
	fromdate=stdate.value
	//var str=fromdate.split("/")
	//fromdate=str[2]+"-"+str[1]+"-"+str[0]
	var enddate=document.getElementById('enddate');
	todate=enddate.value
	//str=todate.split("/")
	//todate=str[2]+"-"+str[1]+"-"+str[0]
	
	temp=tsData.join("!")
	vbdata=temp.split("!")
	
	for (i=0;i<=vbdata.length-1;i++)
	{   
	    str=vbdata[i].split(",")
	    for (j=0;j<=str.length-1;j++)
	    {    
	    	xlsheet.cells(i+3,j+1)=str[j]    	      
	    }	    
	}
	xlsheet.cells(i+4,8)="制表人:"
	xlsheet.cells(i+4,9)=session['LOGON.USERNAME'];
	xlsheet.cells(2,3)=fromdate
	xlsheet.cells(2,6)=todate
    //画表格
    var hrow=vbdata.length-1
    //alert(vbdata.length)
    //alert(str.length)
	var lrow=str.length+1
	Grid(xlsheet,3,1,hrow,lrow) 	
	
	xlApp.Visible=true;
	xlsheet.PrintPreview();
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null;
	
}
function Grid(objSheet,xlsTop,xlsLeft,hrow,lrow)
{   
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(1).LineStyle=1 ;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(2).LineStyle=1;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(3).LineStyle=1 ;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop+hrow,lrow)).Borders(4).LineStyle=1 ;
}
function Print_click()
{  
    if (findflag=="N") 
    {   alert(t['16'])
        return }
	var patward=document.getElementById('patward');
	warddesc=patward.value
	var wardid=document.getElementById('wardid').value;
	var stdate=document.getElementById('stdate');
	fromdate=stdate.value;
	fromdate=tkMakeServerCall("web.UDHCJFBaseCommon","FormDateTime",fromdate,"");
	//var str=fromdate.split("/")
	//fromdate=str[2]+"-"+str[1]+"-"+str[0]
	var enddate=document.getElementById('enddate');
	todate=enddate.value
	todate=tkMakeServerCall("web.UDHCJFBaseCommon","FormDateTime",todate,"")
	//str=todate.split("/")
	//todate=str[2]+"-"+str[1]+"-"+str[0]
	
	var Objtbl=document.getElementById('tUDHCJFDayDetail');
	var Rows=Objtbl.rows.length;
	if (Rows<2) return;
	var listobj=document.getElementById('PatList')
	var listnum=listobj.options.length
	tmppat=""
	for (i=0;i<listnum;i++){
		if (listobj.options[i].selected==true)
		{
			var mydata = new Array();
			var str=listobj.options[i].value
			mydata=str.split("^")
			
			tmppat=tmppat+"^"+mydata[0]
			
			}
		
		}
	tmppat=tmppat+"^"

	if (regnoobj.value!="") tmppat="^"+regnoobj.value+"^"
	var row=1
	var SelRowObj=document.getElementById('Tjobz'+row);
	var jj=SelRowObj.innerText;
	//var jj=SelRowObj.value;
	p1=jj
	/*
	if (regnoobj.value!="")
	(
	    p2=regnoobj.value
	)
	else
	{
	    p2=wardid
	}
	*/
	var getNo=document.getElementById('getNo');
	if (getNo) {var encmeth=getNo.value} else {var encmeth=''};
	var	p2=cspRunServerMethod(encmeth,p1,Guser)
	var j=0
	var title= new Array();
	var getpatno=document.getElementById('getpatno');
	if (getpatno) {var encmeth=getpatno.value} else {var encmeth=''};
	var	patnum=cspRunServerMethod(encmeth,p1,Guser)
	patstr=patnum.split("^")

	patcount=patstr.length
	//alert("p2"+p2+"wardid"+wardid)
	if (regnoobj.value=="") {p2=wardid}
	//alert("p2"+p2+"wardid"+wardid)
	if (hb2.checked==true)
	{
		printDayDetail(p1,p2)
	}
	else
	{	
		printDayDetailSplit(p1,p2)
	}
}
function getpat() {
	var e = event?event:(window.event?window.event:null);
	var key=websys_getKey(e);
	if (key==13) {
		if (regnoobj.value!=""){
			p1=regnoobj.value
		
			var getregno=document.getElementById('getadm');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				if (cspRunServerMethod(encmeth,'setpat_val','',p1)=='1'){
				};
			
			}
		}
	}
function setpat_val(value)
	{
		var val=value.split("^");
		regnoobj.value=val[0];
		var EncryptLevelObj=document.getElementById('EncryptLevel')
    if(EncryptLevelObj) {EncryptLevelObj.value=val[15]}
    var PatLevelObj=document.getElementById('PatLevel')
    if(PatLevelObj) {PatLevelObj.value=val[16]}
	
		
		}	
function LookUppapno(str)
{
	var obj=document.getElementById('papno');
	var tem=str.split("^");
	obj.value=tem[0];
}

function LookUpDepGroup(str)
{
	var obj=document.getElementById('DepGroupid');
	var tem=str.split("^");
	obj.value=tem[1];
}
function getpatward()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  patward_lookuphandler();
		}
	}
function gettype()
{	
	var obj=document.getElementById('typeid');
	obj.value="";
   
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  type_lookuphandler();
		}
	}
function listselected(listobj)
{
	var num=listobj.options.length
	
	for (i=0;i<num;i++){
		listobj.options[i].selected=true;
		}
	}
function clearpatwardid()
{
	if (patwardobj.value==""){
	var obj=document.getElementById('wardid');
	obj.value="";
	}
}
function clearorddeptid()//
{
	if (orddept.value==""){
	var obj=document.getElementById('orddeptid');
	obj.value="";
	}
}
function clearDepGroupid()//
{
	if (DepGroup.value==""){
	var obj=document.getElementById('DepGroupid');
	obj.value="";
	}
}

function getlocid(str){
	
	var obj=document.getElementById('orddeptid');
	var tem=str.split("^");
	obj.value=tem[1];
}
function SelectRowHandler()	
{    
     var win=top.frames['eprmenu'];
     if (win){
	     var frm=win.document.forms['fEPRMENU'];
         frm.EpisodeID.value=document.getElementById("EpisodeID").value;
        
     }
     
}
document.body.onload = BodyLoadHandler;