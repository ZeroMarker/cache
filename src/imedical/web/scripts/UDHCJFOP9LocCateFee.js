var path
function BodyLoadHandler() {
	InitOPCat()
	var obj=document.getElementById('Print');
	if (obj) obj.onclick=Print_Click;
}
function LookUpUser(str)
{ 
	var tem=str.split("^");
	var obj=document.getElementById('UserRowId');
	obj.value=tem[1];
}
function InitOPCat()
{	var catobj=document.getElementById("getOPCAT");
	if (catobj) {var encmeth=catobj.value} else {var encmeth=''};
	var catinfo=cspRunServerMethod(encmeth);
	var objtbl=document.getElementById("tUDHCJFOP9LocCateFee");
	var Rows=objtbl.rows.length;
	var firstRow=objtbl.rows[0];
	var RowItems=firstRow.all;
	
	var cattmp =catinfo.split("^");
	var catnum=cattmp.length;
	for (var i=1;i<=catnum;i++)
	{
		var ColName="cat"+i;
		for (var j=0;j<RowItems.length;j++) 
		{ 
			if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH'))
			{
				RowItems[j].innerHTML=cattmp[i-1];
			}
		}
	}
}
function Print_Click()
{
    
    getpath()
    var Template=path+"JF_OPLocCatFee.xls"
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Template);
    xlsheet = xlBook.ActiveSheet 
         
	var SelRowObj=document.getElementById('TJobz'+1);
    job=SelRowObj.value;
    
	var getnum=document.getElementById('GetPrtNum');
    if (getnum) {var encmeth=getnum.value} else {var encmeth=''};
    var num=cspRunServerMethod(encmeth,job)
    
    var stdate=document.getElementById("StDate").value
    var enddate=document.getElementById("EndDate").value
    var UserName=session['LOGON.USERNAME']
    xlsheet.cells(2,2).value=stdate+"---"+enddate
    xlsheet.cells(2,7).value=UserName
    if (num!=0)
    {   
	    for (i=0;i<=num;i++)
	    {   
		    var getprtinfo=document.getElementById('GetPrtInfo');
   	        if (getprtinfo) {var encmeth=getprtinfo.value} else {var encmeth=''};
            var prtinfo=cspRunServerMethod(encmeth,job,i)          
            var columns=prtinfo.split("^")
            for (j=0;j<=columns.length-1;j++)
            {   
             	xlsheet.cells(3+i,j+1).value=columns[j]
                xlsheet.Cells(3+i,j+1).Borders(9).LineStyle = 1
	            xlsheet.Cells(3+i,j+1).Borders(7).LineStyle = 1
	            xlsheet.Cells(3+i,j+1).Borders(10).LineStyle = 1
	            xlsheet.Cells(3+i,j+1).Borders(8).LineStyle = 1
            }
	    }
    }
    //xlApp.Visible=true
	xlsheet.PrintOut;
    xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
  	xlsheet=null
}
function getpath() {
	var getpath=document.getElementById('GetPath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};	
		path=cspRunServerMethod(encmeth,'','')
	}

document.body.onload=BodyLoadHandler