
function BodyLoadHandler(){
	var obj=document.getElementById('Print')
	if(obj) obj.onclick=PrintAndSave;
	var itemstdate=document.getElementById('stdate').value;
	var itemenddate=document.getElementById('enddate').value;
}
function PrintAndSave(){
   var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j 
   //var Template
   //var objDate=document.getElementById('Date');
   //var Data=objDate.value.split("/");
   //Date=Data[2]+"-"+Data[1]+"-"+Data[0];
   pathpint=GetFilePath();
   path=pathpint+"12121.xls"
   //Template=path+"INSUTESTGCJ.xls";
   xlApp = new ActiveXObject("Excel.Application");
   //xlBook = xlApp.Workbooks.Add(Template);
   xlBook = xlApp.Workbooks.Add(path);
   xlsheet = xlBook.ActiveSheet ; 
   var objtbl=document.getElementById('tDHCNurStatBlood');
   //var str=objtbl.rows(1).cells(1).innerText.split("-");
   xlsheet.cells(1,1)=t['01']+document.getElementById('stdate').value;
   //alert(document.getElementById('stdate').value)
   xlsheet.cells(1,3)=t['02']+document.getElementById('enddate').value;
   xlsheet.cells(3,1)="执行人"
   xlsheet.cells(3,2)="医嘱数"
   xlsheet.cells(3,3)="标本数"
   //alert(document.getElementById('enddate').value)
   for (i=1;i<objtbl.rows.length;i++){
	   for (j=1;j<objtbl.rows(i).cells.length;j++){
		   xlsheet.cells(i+3,j)=objtbl.rows(i).cells(j).innerText;
		   
		   xlsheet.cells(i+2,j).Borders(7).LineStyle = 1;
		   xlsheet.cells(i+2,j).Borders(8).LineStyle = 1;
		   xlsheet.cells(i+2,j).Borders(9).LineStyle = 1;
		   xlsheet.cells(i+2,j).Borders(10).LineStyle = 1;
		   xlsheet.cells(i+3,j).Borders(7).LineStyle = 1;
		   xlsheet.cells(i+3,j).Borders(8).LineStyle = 1;
		   xlsheet.cells(i+3,j).Borders(9).LineStyle = 1;
		   xlsheet.cells(i+3,j).Borders(10).LineStyle = 1;
		   }
   }
   //xlsheet.cells(objtbl.rows.length+3,1)="日期";
   //xlsheet.cells(objtbl.rows.length+3,2)=objDate.value;
   //xlsheet.cells(objtbl.rows.length+3,4)="执行人";
   //xlsheet.cells(objtbl.rows.length+3,5)=GuserName;
   //打印预览
   var title="12121"+".xls";
   //var filename=xlApp.Application.GetSaveAsFilename(title, "Excel Spreadsheets (*.xls), *.xls");  //不需要功能
   //xlApp.Visible=true;  //不需要功能
   //xlsheet.PrintPreview();  //不需要功能
   //xlBook.SaveAs(filename)   //不需要功能
   xlsheet.printout();
   xlBook.Close(savechanges=false);
   //xlBook.Close();  //不需要功能
   xlApp.Quit();
   xlApp=null;
   xlsheet=null;
}
function GetFilePath()
  {   var GetPath=document.getElementById("GetPath").value;
      var pathpint=cspRunServerMethod(GetPath);
      return pathpint;
  }
document.body.onload=BodyLoadHandler;