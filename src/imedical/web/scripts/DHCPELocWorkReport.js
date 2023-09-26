/// DHCPEGDoctorWorkStatistic.js


function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("BExport");
	
	if(obj)
	{
		obj.onclick=exportData;
	}

}

function exportData()
{	
	try {
		var excApp = new ActiveXObject("Excel.Application");
    }
    catch(e) 
	{
         alert( "��������ʧ��!�����밲װExcel���ӱ�����?ͬʱ�������ʹ��?ActiveX�ؼ�??���������������ִ�пؼ�!");
         return "";
     }
   excApp.UserControl = true;
   //excApp.visible = false; //����ʾ
   excApp.visible = true; //��ʾ

   //var filename = Math.ceil(Math.random() * 1000) + ".xls";   // ����������ļ���
   var filename = "�����¹�����.xls";   // ����������ļ���
   var excBook = excApp.Workbooks.Add();
   var oSheet = excBook.Worksheets(1);
   var tbObj = document.getElementById('tDHCPELocWorkReport');
   var rowObj = tbObj.getElementsByTagName("tr");

    //oSheet.Rows(1).HorizontalAlignment = - 4108;//����A, B�о���
   oSheet.Rows(1).Font.Name = "����" ;
   oSheet.Rows(1).Font.Size = 16;//�����С
   oSheet.Rows(1).ColumnWidth=15;//�п�
   oSheet.Rows(1).RowHeight = 30; //�����и�

   if(tbObj)
   {
      var str = "";
	  //rowNumber�����,columnNumber�����
      for(var rowNumber = 0;  rowNumber < rowObj.length;
      rowNumber ++ )
      {
         for(var columnNumber = 1; columnNumber < rowObj[rowNumber].cells.length;
         columnNumber ++ )
         {
            str = rowObj[rowNumber].cells[columnNumber].innerText;
            oSheet.cells(rowNumber+2, columnNumber ).value = str;
			if(0==rowNumber)
			{
			    oSheet.cells(2,  columnNumber ).Interior.ColorIndex = 17;//���õ�һ�е�ɫ
			}
         }
      }
   }
   oSheet.cells(1, 2).value = "�����¹�����";
   /*
   var dir = "d:\\" + filename;//����Ŀ¼
   excBook.SaveAs(dir);
   excApp.Quit();//�˳�excel
   excApp=null;
   alert("�����ɹ�������"+dir);
   */
    excBook.Close(savechanges = true);
	excApp.Quit();
	excApp = null;
	oSheet = null

}

document.body.onload = BodyLoadHandler;