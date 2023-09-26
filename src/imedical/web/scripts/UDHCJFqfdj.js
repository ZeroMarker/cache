var curdate
function BodyLoadHandler() {  
  
  var prtobj=document.getElementById("Print");
  if (prtobj){
      prtobj.onclick=Print_click;	  
  }
 
  gettoday()

}

function gettoday() {
	var gettoday=document.getElementById('gettoday');
	if (gettoday) {var encmeth=gettoday.value} else {var encmeth=''};
	
	if (cspRunServerMethod(encmeth,'setdate_val','','')=='1'){
				};
	}
function setdate_val(value)
	{
		curdate=value;
		var str=curdate.split("/")
		curdate=str[2]+"-"+str[1]+"-"+str[0]
		curdate1=str[0]+"/"+str[1]+"/"+str[2]
		var stobj=document.getElementById('StDate')
		stobj.value=curdate1
	    var endobj=document.getElementById('EndDate')
	    endobj.value=curdate1
		}
function Print_click()
{   
    var Objtbl=document.getElementById("tUDHCJFqfdj")
	Rows=Objtbl.rows.length;
	if (Rows<2) return;
    var obj=document.getElementById("Tjobz"+2)
	if (obj) {var job=obj.innerText}
	var getpath=document.getElementById('getpath');	
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	path=cspRunServerMethod(encmeth,'','');
	var xlApp,obook,osheet,xlsheet,xlBook
	var patname,patno,patdw,paymode,payamt,payamtdx,temp	    	    
	Template=path+"JF_qfdj.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	
	var stdate=document.getElementById('StDate').value
	var enddate=document.getElementById('EndDate').value
	xlsheet.cells(3,2).value=stdate+"---"+enddate
	var getnum=document.getElementById('getnum');
		
	if (getnum) {var encmeth=getnum.value} else {var encmeth=''};
	var num=cspRunServerMethod(encmeth,job);
	alert(num)
	for (i=1;i<=num;i++){
		var getdata=document.getElementById('getdata');
		
	    if (getdata) {var encmeth=getdata.value} else {var encmeth=''};
	    var data=cspRunServerMethod(encmeth,job,i);
		alert(data)
		var str=data.split("^")
		var len=str.lenght
		for (j=0;j<=len-1;j++){
		xlsheet.cells(6+i,j+1).value=str[j]
		//addgrid(xlsheet,0,0,1,13,6,1)}
		}
}
        
	xlsheet.cells(8+i,1).value=t['01']
	xlsheet.cells(8+i,2).value=session['LOGON.USERNAME']
	xlsheet.cells(8+i,4).value=t['02']
	xlsheet.cells(8+i,1).value=curdate
	xlsheet.cells(8+i,7).value=t['03']
	//xlsheet.cells(8+i,1).value=""
	xlsheet.cells(8+i,10).value=t['04']
	//xlsheet.cells(8+i,1).value=""
		
	//if (clear) {var encmeth=clear.value} else {var encmeth=''};
	//var clr=cspRunServerMethod(encmeth,job);
	//xlsheet.printout
	xlApp.Visible=true
	xlsheet.PrintPreview();
	alert("edd")
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null
	
}

function getlocid(value){
	var val=value.split("^");
	var loc=document.getElementById('locid');
	loc.value=val[1];
	
	}
function addgrid(objSheet,fRow,fCol,tRow,tCol,xlsTop,xlsLeft)
{   objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(2).LineStyle=1;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
    objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
}
  document.body.onload = BodyLoadHandler;