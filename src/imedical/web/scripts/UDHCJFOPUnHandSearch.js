var path,UserRowid="",Job="",Flag="-1"
function BodyLoadHandler() 
{
	//var obj=document.getElementById("UserName");
	//obj.onkeydown=GetUser;
	//obj.onclick=ClearUser;
	var obj=document.getElementById('BPrint');
	if (obj) obj.onclick=PrtDetail;
	var obj=document.getElementById('BFindDEtail');
	if (obj) obj.onclick=BFindDEtail;
	getpath() 
}
function SelectRowHandler()	
{  
   var eSrc=window.event.srcElement;
   Objtbl=document.getElementById('tUDHCJFIPUnHandSearch');
   var rowObj=getRow(eSrc);
   var selectrow=rowObj.rowIndex;
   if (!selectrow) return;
   var SelRowObj=document.getElementById('TUserRowidz'+selectrow);
   UserRowid=SelRowObj.value;
   var SelRowObj=document.getElementById('Tjobz'+selectrow);
   Job=SelRowObj.innerText;
}
function LookUpUser(str)
{
	var Userobj=document.getElementById('UserName');
	var UserIDobj=document.getElementById('UserDr');
	var tem=str.split("^");
	UserIDobj.value=tem[1];
	//Userobj.value=tem[0];
}
function getpath() 
{
	var getpath=document.getElementById('GetPath');
    if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	path=cspRunServerMethod(encmeth,'','')
}
/*
function GetUser()
{
	var e = event?event:(window.event?window.event:null);
	 if (e.keyCode == 13) {
	      e.isLookup=true;     //设置isLookup未true
	      //e.keyCode = 117;
	      UserName_lookuphandler();
	 }
}
*/
function ClearUser()
{
	var Userobj=document.getElementById('UserName');
	var UserIDobj=document.getElementById('UserDr');
	UserIDobj.value="";
	Userobj.value="";
}
function PrtDetail()
{
	var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j
	var Template
	getpath() 
	Template=path+"JF_OPUNHandDetail.xls"
	//Template="D:\\JF_OPUNHandDetail.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet  
	xlApp.visible=true
	var SelRowObj=document.getElementById('Tjobz'+1);
	job=SelRowObj.innerText;
	var getprtnum=document.getElementById('GetPrtNum')   
	if (getprtnum) {var encmeth=getprtnum.value} else {var encmeth=''};
	var PrtNum=cspRunServerMethod(encmeth,"","",job)
	var m
	for(m=1;m<=PrtNum;m++)
	{
		var getprtdata=document.getElementById('GetPrtData')  
		if (getprtdata) {var encmeth=getprtdata.value} else {var encmeth=''};
		var PrtData=cspRunServerMethod(encmeth,"","",job,m)
		var PrtDetail=PrtData.split("^")
		xlsheet.cells(4+m,2).value=PrtDetail[0]
		xlsheet.cells(4+m,3).value=PrtDetail[1]
		xlsheet.cells(4+m,4).value=PrtDetail[2]
		xlsheet.cells(4+m,5).value=PrtDetail[3]
		xlsheet.cells(4+m,6).value=PrtDetail[4]
		xlsheet.cells(4+m,7).value=PrtDetail[5]
		xlsheet.cells(4+m,8).value=PrtDetail[6]
		
	}
	var GetToday=document.getElementById('GetToday')   
	if (GetToday) {var encmeth=GetToday.value} else {var encmeth=''};
	var Today=cspRunServerMethod(encmeth,"","")
	xlsheet.cells(4+m,2).value="制表人:"+session['LOGON.USERNAME']
	xlsheet.cells(4+m,7).value="打印日期:"+Today
	AddGrid(xlsheet,5,2,4+m,8,4,2)
	xlsheet.printout
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null     
} 
function BFindDEtail()
{
	if(UserRowid=="")
	{
		alert("请选择收款员")
		return;
	}
	if(Job=="")
	{
		alert("请重新选择记录")
		return;
	}
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillUnHanInvDetail&UserRowid='+UserRowid+'&Job='+Job
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0')
	
}
function AddGrid(objSheet,fRow,fCol,tRow,tCol,xlsTop,xlsLeft)
{        
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
}  
document.body.onload=BodyLoadHandler;