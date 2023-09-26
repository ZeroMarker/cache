var Guser,flag,job,lastenddate
var jsstdate,jsenddate,acctrowid,jsflag,err
var stdate,enddate
function BodyLoadHandler() {
	GetDefaultHospID()
	Guser=session['LOGON.USERID']
	var HospID=document.getElementById('HospID').value
	
	var getstdate=document.getElementById('getstdate');
    if (getstdate) {var encmeth=getstdate.value} else {var encmeth=''};
    document.getElementById('stdate').value=cspRunServerMethod(encmeth,"QFACOUNT",HospID)
	var stdate=cspRunServerMethod(encmeth,"QFACOUNT",HospID)
    lastenddate=stdate
	var obj=document.getElementById("Balance");
	if (obj) obj.onclick=Insert_click;	
	var obj=document.getElementById("Print");
	if (obj) obj.onclick=Print_click;
	var cancel=document.getElementById("btncancel");
    if (cancel){
     cancel.onclick=Cancel_click;	  
    }  
}
function Insert_click()
{   getdate()
    if (err==-1)
    {   alert(t['jst06'])
        return }
	if (jsflag=="Y")
	{   alert(t['jst05'])
	    return }
	if (stdate>enddate)
	{ // alert(t['06'])
	  // return 
	  }
	if (lastenddate!=document.getElementById('stdate').value)
	{
		alert(t['05'])
		document.getElementById('stdate').value=lastenddate
		return
	}
	var HospID=document.getElementById('HospID').value
	var Add=document.getElementById('Add');
	if (Add) {var encmeth=Add.value} else {var encmeth=''};
	flag="QFACOUNT"
	var SelRowObj=document.getElementById('Tjobz'+1);
    job=SelRowObj.innerText;
    
	if (cspRunServerMethod(encmeth,Guser,flag,job,HospID)=='0')
	{   alert(t['01'])}
	else 
	{   alert(t['02'])
	}
}
function getpath() {
	var getpath=document.getElementById('getpath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};	
		path=cspRunServerMethod(encmeth,'','')
	}
function Cancel_click()
 {	getdate()
    var tmp=t['jst01']+jsstdate+"--"+jsenddate+t['jst02']
    var truthBeTold = window.confirm(tmp);
    if (!truthBeTold) { return ;}
    var cancel=document.getElementById('cancel');
    if (cancel) {var encmeth=cancel.value} else {var encmeth=''};
    var err=(cspRunServerMethod(encmeth,acctrowid))
    if (err==0)
    {   alert(t['jst03'])
        return }
    else
    {   alert(t['jst04']) }
 }
function getdate()
{   jsflag=""
	stdate=document.getElementById('stdate').value
	enddate=document.getElementById('enddate').value
    var laststr=document.getElementById('getlastdate');
    if (laststr) {var encmeth=laststr.value} else {var encmeth=''};
    var laststr1=(cspRunServerMethod(encmeth,"QFACOUNT",stdate,enddate))
    lastjsdate1=laststr1.split("^")
    jsstdate=lastjsdate1[0]
    jsenddate=lastjsdate1[1]
    acctrowid=lastjsdate1[2]
    jsflag=lastjsdate1[3]
    err=lastjsdate1[4]
}
function Print_click()
{ 
    getpath()
    
    Template=path+"JF_Acount.xls"
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Template);
    xlsheet = xlBook.ActiveSheet 
    var HospName=document.getElementById('HospName').value
    
    xlsheet.cells(1,1)=t['07']
	var SelRowObj=document.getElementById('Tjobz'+1);
    job=SelRowObj.innerText;
	
	var getnum=document.getElementById('getprtnum');
    if (getnum) {var encmeth=getnum.value} else {var encmeth=''};
    var num=cspRunServerMethod(encmeth,"QFACOUNT",job)
    var getprtinfo=document.getElementById('getprtinfo');
   	if (getprtinfo) {var encmeth=getprtinfo.value} else {var encmeth=''};
    var prtinfo=cspRunServerMethod(encmeth,"QFACOUNT",job,num)
    var columns=prtinfo.split("^")
    xlsheet.cells(2,2)=t['04']+columns[0]+" "+columns[1]+"--"+columns[2]+columns[3]
    if (num!=0)
    {   
	    for (i=1;i<num;i++)
	    {
		    var getprtinfo=document.getElementById('getprtinfo');
   	        if (getprtinfo) {var encmeth=getprtinfo.value} else {var encmeth=''};
            var prtinfo=cspRunServerMethod(encmeth,"QFACOUNT",job,i)
            
            var columns=prtinfo.split("^")
            for (j=0;j<=columns.length-1;j++)
            {
	            xlsheet.cells(2+i,j+1)=columns[j]
                xlsheet.Cells(2+i,j+1).Borders(9).LineStyle = 1
	            xlsheet.Cells(2+i,j+1).Borders(7).LineStyle = 1
	            xlsheet.Cells(2+i,j+1).Borders(10).LineStyle = 1
	            xlsheet.Cells(2+i,j+1).Borders(8).LineStyle = 1
            }
	    }
    }
    xlApp.Visible=true
	xlsheet.PrintPreview();
    xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
  	xlsheet=null
}
function GetHospID(value)
{
	var HospInfo=value.split("^")
	var HospID=HospInfo[1]
	document.getElementById('HospID').value=HospID
	
}
function GetDefaultHospID()
{
	if (document.getElementById('HospName').value=="")
	{
		var LocID=session['LOGON.CTLOCID']
		var HospObj=document.getElementById('GetDefHosp');
    	if (HospObj) {var encmeth=HospObj.value} else {var encmeth=''};
    	var HospInfo=(cspRunServerMethod(encmeth,LocID))
    
    	HospInfo=HospInfo.split("^")
		document.getElementById('HospID').value=HospInfo[0]
		document.getElementById('HospName').value=HospInfo[1]
	}
}
document.body.onload = BodyLoadHandler;