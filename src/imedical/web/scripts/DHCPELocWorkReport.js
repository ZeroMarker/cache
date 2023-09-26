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
         alert( "导出数据失败!您必须安装Excel电子表格软件?同时浏览器须使用?ActiveX控件??您的浏览器须允许执行控件!");
         return "";
     }
   excApp.UserControl = true;
   //excApp.visible = false; //不显示
   excApp.visible = true; //显示

   //var filename = Math.ceil(Math.random() * 1000) + ".xls";   // 随机数生成文件名
   var filename = "科室月工作量.xls";   // 随机数生成文件名
   var excBook = excApp.Workbooks.Add();
   var oSheet = excBook.Worksheets(1);
   var tbObj = document.getElementById('tDHCPELocWorkReport');
   var rowObj = tbObj.getElementsByTagName("tr");

    //oSheet.Rows(1).HorizontalAlignment = - 4108;//设置A, B列居中
   oSheet.Rows(1).Font.Name = "黑体" ;
   oSheet.Rows(1).Font.Size = 16;//字体大小
   oSheet.Rows(1).ColumnWidth=15;//列宽
   oSheet.Rows(1).RowHeight = 30; //设置行高

   if(tbObj)
   {
      var str = "";
	  //rowNumber行序号,columnNumber列序号
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
			    oSheet.cells(2,  columnNumber ).Interior.ColorIndex = 17;//设置第一行底色
			}
         }
      }
   }
   oSheet.cells(1, 2).value = "科室月工作量";
   /*
   var dir = "d:\\" + filename;//保存目录
   excBook.SaveAs(dir);
   excApp.Quit();//退出excel
   excApp=null;
   alert("导出成功保存在"+dir);
   */
    excBook.Close(savechanges = true);
	excApp.Quit();
	excApp = null;
	oSheet = null

}

document.body.onload = BodyLoadHandler;