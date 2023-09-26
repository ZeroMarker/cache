function BodyLoadHandler() {
    getpath();
	var objPrint=document.getElementById('PrintAndOutPut');
	if (objPrint){objPrint.onclick=PrintAndSave};
	GuserName=session['LOGON.USERNAME'];
	//alert(GuserName)
}
function getpath() {
	var getpath=document.getElementById('getpath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	path=cspRunServerMethod(encmeth,'','')
	
	}
function PrintAndSave(){
   var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j 
   var Template
   var objDate=document.getElementById('Date');
   var Data=objDate.value.split("/");
   Date=Data[2]+"-"+Data[1]+"-"+Data[0];
   //path="http://10.10.142.1/trakcarelivenyfy/trak/med/Templates/"
   Template=path+"INSU_IPFootPatList.xls"
   xlApp = new ActiveXObject("Excel.Application");
   xlBook = xlApp.Workbooks.Add(Template);
   xlsheet = xlBook.ActiveSheet ; 
   var objtbl=document.getElementById('tInsuIPFootPatList');
   var str=objtbl.rows(1).cells(1).innerText.split("-")
   for (i=1;i<objtbl.rows.length;i++){
	   for (j=1;j<objtbl.rows(1).cells.length;j++){
		   xlsheet.cells(i+3,j)=objtbl.rows(i).cells(j).innerText;
		   xlsheet.cells(i+3,j).Borders(7).LineStyle = 1;
		   xlsheet.cells(i+3,j).Borders(8).LineStyle = 1;
		   xlsheet.cells(i+3,j).Borders(9).LineStyle = 1;
		   xlsheet.cells(i+3,j).Borders(10).LineStyle = 1;
		   }
   }
   xlsheet.cells(objtbl.rows.length+3,1)="日期";
   xlsheet.cells(objtbl.rows.length+3,2)=objDate.value;
   xlsheet.cells(objtbl.rows.length+3,4)="审核人";
   xlsheet.cells(objtbl.rows.length+3,5)=GuserName;
   //打印预览
   var title="医保上传列表"+Date+".xls"
   var filename=xlApp.Application.GetSaveAsFilename(title, "Excel Spreadsheets (*.xls), *.xls");
   xlBook.SaveAs(filename)
   xlApp.Visible=true;
   xlsheet.PrintPreview();
   xlBook.Close(savechanges=false);
   xlApp.Quit();
   xlApp=null;
   xlsheet=null;
}
document.body.onload =BodyLoadHandler;	