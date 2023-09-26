 
function BodyLoadHandler()
{  var Printobj=document.getElementById('BtnPrint');
   Printobj.onclick=Print_Click
}
function Print_Click()
{  
    var getpath=document.getElementById('getpath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	var path=cspRunServerMethod(encmeth,'','');
	var Template=path+"JF_PrintDepositDetail.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet;
	var SelRowObj=document.getElementById('Tjobz'+1);
	var job=SelRowObj.innerText;
	var GetNumObj=document.getElementById('GetNum');
	if (GetNumObj) {var encmeth=GetNumObj.value} else {var encmeth=''};
	var Num=cspRunServerMethod(encmeth,job);
	//取医院名称，打印名称前增加医院名称

	var HospitalDesc=tkMakeServerCall("web.UDHCJFCOMMON","gethospital");
	xlsheet.cells(1,1)=HospitalDesc+"全院未结算预交金明细";
	for (i=1;i<=Num;i++)
	{   
	   var GetPrtInfoObj=document.getElementById('GetUnPaidData');
   	   if (GetPrtInfoObj) {var encmeth=GetPrtInfoObj.value} else {var encmeth=''};
       var PrtInfo=cspRunServerMethod(encmeth,job,i)
       var columns=PrtInfo.split("^")
       for (j=0;j<=columns.length-1;j++)
            {   
                xlsheet.cells(3+i,j+1).value=columns[j]
                xlsheet.Cells(3+i,j+1).Borders(9).LineStyle = 1
	            xlsheet.Cells(3+i,j+1).Borders(7).LineStyle = 1
	            xlsheet.Cells(3+i,j+1).Borders(10).LineStyle = 1
	            xlsheet.Cells(3+i,j+1).Borders(8).LineStyle = 1
            }
	}
	//var myDate = new Date();
    var CurDate= document.getElementById('printdate') //myDate.toLocaleDateString();   
    xlsheet.cells(2,9).value=CurDate.value;
	xlApp.Visible=true
	xlsheet.PrintPreview();
    xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
  	xlsheet=null
}
document.body.onload = BodyLoadHandler; 
  