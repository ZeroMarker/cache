var stdate,enddate
var path,today
var myData1= new Array()
var Guser

function BodyLoadHandler(){
	stdate=document.getElementById('stdate').value
 	enddate=document.getElementById('enddate').value
	var print=document.getElementById('print')
 	print.onclick=print_click
 	Guser=session['LOGON.USERID']
 	getpath()
 	gettoday()
 	websys_setfocus('stdate')

	}
function print_click(){
	var Objtbl=document.getElementById('tUDHCJFcpact');
	var Rownum=Objtbl.rows.length;
	if (Rownum<2) return;
	var admreason=document.getElementById('admreason').value
	//var row=1
    var i=1,j=0
    var getnum=document.getElementById('getnum');
	if (getnum) {var encmeth=getnum.value} else {var encmeth=''};
	var	patnum=cspRunServerMethod(encmeth,"","")
 	
	var xlApp,obook,osheet,xlsheet,xlBook
    var Template
    Template=path+"JF_compacts.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet 
	if (admreason!="")
	{   xlsheet.cells(1,3)=admreason+t['04'] }
	for(i=1;i<patnum;i++){
	p1=i	
 	var getdata=document.getElementById('getdata');
	if (getdata) {var encmeth=getdata.value} else {var encmeth=''};
	var	str=cspRunServerMethod(encmeth,"","",p1)
		myData1=str.split("^")
	for (j=0;j<7;j++){
	    xlsheet.cells(i+2,j+2)=myData1[j]
	    addgrid(xlsheet,0,2,1,8,i+1,2)
}		                	    	
   
}
 xlsheet.cells(i+2,2)=t['01']+Guser
 xlsheet.cells(i+2,4)=t['02']
 xlsheet.cells(i+2,6)=today
 xlsheet.cells(i+2,7)=t['03']
   xlsheet.printout       
	       xlBook.Close (savechanges=false);
	       xlApp.Quit();
	       xlApp=null;
	       xlsheet=null	 
	}
function getpath() {
			var getpath=document.getElementById('getpath');
			if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
			path=cspRunServerMethod(encmeth,'','')
}
function gettoday() {
			var gettoday=document.getElementById('gettoday');
			if (gettoday) {var encmeth=gettoday.value} else {var encmeth=''};
			today=cspRunServerMethod(encmeth,'','')
}
function getadmreasonid(value){
		var val=value.split("^");
	var obj=document.getElementById('admreasonid');
	obj.value=val[1];

	}
function addgrid(objSheet,fRow,fCol,tRow,tCol,xlsTop,xlsLeft)
{objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
 objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(2).LineStyle=1;
 objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
 objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
}
document.body.onload = BodyLoadHandler;