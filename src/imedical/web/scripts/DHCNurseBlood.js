
function BodyLoadHandler(){
	var obj=document.getElementById('Print')
	if(obj) obj.onclick=btnPrint_click;
	var itemstdate=document.getElementById('stdate').value;
	var itemenddate=document.getElementById('enddate').value;
}
	///ȫ����ӡ
function btnPrint_click()
{
	alert(1);
    var xlsExcel,xlsSheet,xlsBook;
    var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
    var LeftFooter,CenterFooter,RightFooter;
    var path,fileName;
    path = GetFilePath();
    alert(path);
	fileName=path + "DHCNurStatBlood.xls";
	xlsExcel = new ActiveXObject("Excel.Application");
	xlsBook = xlsExcel.Workbooks.Add(fileName);
	xlsSheet = xlsBook.ActiveSheet;
	var xlsTop=1;var xlsLeft=1;
	var objtbl=document.getElementById('tDHCNurStatBlood');
	if ((objtbl)&&(objtbl.rows.length<=1)) return;
	var stdate=document.getElementById('stdate').value;//t['01']+
	var eddate=document.getElementById('enddate').value;//t['01']+
	var row=1;		//��ʼ��
	var i=0,j=0,n=0;
	var rownum=objtbl.rows.length;
	for (i=1;i<rownum;i++)
    {
		j++;
		
		xlsSheet.cells(row+j,1)=document.getElementById("NurNamez"+i).innerText;;  //����
		xlsSheet.cells(row+j,2)=document.getElementById("ARCIMIdz"+i).innerText;;  //ʱ��
    	xlsSheet.cells(row+j,3)=document.getElementById("labNoz"+i).innerText;;  //Ѫ��
    	//xlsSheet.cells(row+j,2)=document.getElementById("personsz"+i).innerText;;  //ǩ��
    	//xlsSheet.cells(row+j,5)=document.getElementById("LocDescz"+i).innerText;;  //��ע
	    
    
    }
    var CenterHeader = "&14"+"���߸����������޹�˾ҽԺ"+"\r"+"̩ɽҽѧԺ��������ҽԺ"+"\r"+"&18"+"��Ѫ������ͳ�Ʊ�"+"\r";
	//var LeftHead="";
	var  LeftHeader="\r\r\r\r&10"+"        "+"�������䣺"+stdate+"-"+eddate;LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
	titleRows=0;
	titleCols=0;
	RightHeader = " ";LeftFooter = "";CenterFooter = " &N - &P";RightFooter = " ";
	ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
	AddGrid(xlsSheet,0,0,row+j-1,4,1,1);
	//FrameGrid(xlsSheet,0,0,row-1,rownum,1,1);
	xlsSheet.PrintOut(); 
    xlsSheet = null;
    xlsBook.Close(savechanges=false)
    xlsBook = null;
    xlsExcel.Quit();
    xlsExcel = null;
}
function PrintAndSave0516(){
   var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j 
   //var Template
   //var objDate=document.getElementById('Date');
   //var Data=objDate.value.split("/");
   //Date=Data[2]+"-"+Data[1]+"-"+Data[0];
   pathpint=GetFilePath();
   //path=pathpint+"12121.xls"
   //Template=path+"INSUTESTGCJ.xls";
   xlApp = new ActiveXObject("Excel.Application");
   //xlBook = xlApp.Workbooks.Add(Template);
   xlBook = xlApp.Workbooks.Add(path);
   xlsheet = xlBook.ActiveSheet ; 
   var objtbl=document.getElementById('tDHCNurStatBlood');
   //var str=objtbl.rows(1).cells(1).innerText.split("-");
   xlsheet.cells(2,1)=t['01']+document.getElementById('stdate').value;
   //alert(document.getElementById('stdate').value)
   xlsheet.cells(2,3)=t['02']+document.getElementById('enddate').value;
   //alert(document.getElementById('enddate').value)
   for (i=1;i<objtbl.rows.length;i++){
	   for (j=1;j<objtbl.rows(1).cells.length;j++){
		   xlsheet.cells(i+3,j)=objtbl.rows(i).cells(j).innerText;
		   //xlsheet.cells(i+3,j).Borders(7).LineStyle = 1;
		   //xlsheet.cells(i+3,j).Borders(8).LineStyle = 1;
		   //xlsheet.cells(i+3,j).Borders(9).LineStyle = 1;
		   xlsheet.cells(i+3,j).Borders(10).LineStyle = 1;
		   }
   }
   //xlsheet.cells(objtbl.rows.length+3,1)="����";
   //xlsheet.cells(objtbl.rows.length+3,2)=objDate.value;
   //xlsheet.cells(objtbl.rows.length+3,4)="ִ����";
   //xlsheet.cells(objtbl.rows.length+3,5)=GuserName;
   //��ӡԤ��
   var title="12121"+".xls";
   //var filename=xlApp.Application.GetSaveAsFilename(title, "Excel Spreadsheets (*.xls), *.xls");  //����Ҫ����
   //xlApp.Visible=true;  //����Ҫ����
   //xlsheet.PrintPreview();  //����Ҫ����
   //xlBook.SaveAs(filename)   //����Ҫ����
   xlsheet.printout();
   xlBook.Close(savechanges=false);
   //xlBook.Close();  //����Ҫ����
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