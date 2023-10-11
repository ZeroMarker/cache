/// 将gridpanel里的数据导出到excel表格中  孙凤超
Ext.namespace("Ext.dhcc");
Ext.dhcc.DataToExcelTool = function() {
    this.gridSaveAsExcel=gridSaveAsExcel;
	return this;
}();

 function gridSaveAsExcel(grid)
{
     if (grid.getStore().getCount()==0)
   {
      alert ("没有需要导出的数据！")
      return;
   };  

   var fd = new ActiveXObject("MSComDlg.CommonDialog");
   fd.Filter = "Microsoft Office Excel(*.xls)|*.xls";
   fd.FilterIndex = 1;
 
   // 必须设置MaxFileSize. 否则出错
   fd.MaxFileSize = 32767;
   // 显示对话框
   fd.ShowSave();
   var fileName=fd.FileName;
   if (fileName=='') return;
   //
   try
   {
    var xlApp=new ActiveXObject("Excel.Application");
   }
   catch (e)
   {
     alert ("必须安装excel,同时浏览器允许执行ActiveX控件！")
     return "";
   }
 
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    if(fso.FileExists(fileName)){
    var fileArr=fileName.split("\\");
    var fileDesc=fileArr[fileArr.length-1];
    if(confirm('文件"'+fileDesc+'"已经存在，是否替换原有文件？')==false){
      xlApp.Quit(); 
      xlApp=null;
      return;
    }
   }
 
   xlApp.Visible=true; /// 可设置为false，设置为false时导出数据表的过程看不到。
   xlApp.DisplayAlerts = true;
   var xlBook=xlApp.Workbooks.Add();
   var xlSheet=xlBook.Worksheets(1); 
    
   var cm=grid.getColumnModel();
   var colCount=cm.getColumnCount();
   var temp_obj=[];

   for (i=1;i<colCount;i++)
   {
     if (cm.isHidden(i) ==true)
     {
     }
     else
     {
      temp_obj.push(i);  //只存没有隐藏的列
     }
   }

   //Excel第一行存放标题
   for (l=1;l<=temp_obj.length;l++)
   {
    xlSheet.Cells(1,l).Value=cm.getColumnHeader(temp_obj[l-1]); ///取标题
   }

   var store=grid.getStore();
   var recordCount=store.getCount();
   var view=grid.getView();
   for (k=1;k<=recordCount;k++)
   {
     for (j=1;j<=temp_obj.length;j++)
     {
      xlSheet.Cells(k+1,j).Value=view.getCell(k-1,temp_obj[j-1]).innerText; ///通过gridview取grid中的数据,返回第row行，第col列的单元格
     }
   }     
   try
   {
      var ss = xlBook.SaveAs(fileName);  
      if (ss==false)
     {
       alert ("另存失败！")
     }  
   }
   catch(e){
       alert ("另存失败！")
   }

   xlApp.Quit(); 
   xlApp=null;
   xlBook=null;
   xlSheet=null;
  }
DataToExcelTool = Ext.dhcc.DataToExcelTool;