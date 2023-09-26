/// 名称	DHCPEBloodStatisticInfList.js
            
/// 抽血与报表打印工作量统计
 



function BodyLoadHandler() 
{
	var obj;
	obj=document.getElementById("ExportData");
	if (obj) {
		obj.onclick=ExportData_click;
	}
	
}



function ExportData_click()
{  
   var obj;
   obj=document.getElementById("prnpath");
   if (obj && ""!=obj.value) 
   {    //alert("111")
	    var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEBloodStatisticList.xls';
		}else{
			alert("无效模板路径");
			return;
		}
		xlApp = new ActiveXObject("Excel.Application");  //固定
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
		xlsheet = xlBook.WorkSheets("Sheet1");       //Excel下标的名称
   	var SelRowObj=document.getElementById('TJob'+'z'+1);
	if (SelRowObj) {
		
		var Job=SelRowObj.value;
	}	
	
   	
    var obj=document.getElementById("UserID");
    if(obj)  {var UserID=obj.value;} 
    if (UserID==""){return false;}
    var obj=document.getElementById("Flag");
    if(obj)  {var Flag=obj.value;} 
	var encmeth=""
	if (Flag=="S"){xlsheet.cells(1,1).Value="体检扫条码工作量明细"}
	var obj=document.getElementById("GetMaxNum");
	if (obj) encmeth=obj.value;
	var MaxNum=cspRunServerMethod(encmeth,UserID,Flag,Job);
	var encmeth1=document.getElementById("GetExportData").value;

	for(i=1;i<=MaxNum;i++)
	{
	var Return=cspRunServerMethod(encmeth1,UserID,i,Flag,Job);
		//alert(Return)
	if (Return=="Quit") continue;
	var StartDate=Return.split("^")[7];
	var EndDate=Return.split("^")[8];

	xlsheet.cells(3+i,1).Value=Return.split("^")[0]
	xlsheet.cells(3+i,2).Value=Return.split("^")[1]
	xlsheet.cells(3+i,3).Value=Return.split("^")[2]
	xlsheet.cells(3+i,4).Value=Return.split("^")[3]
	xlsheet.cells(3+i,5).Value=Return.split("^")[4]
    xlsheet.cells(3+i,6).Value=Return.split("^")[6]
	xlsheet.cells(3+i,7).Value=Return.split("^")[5]
 
	
	if  (Flag=="Person") {xlsheet.cells(3+i,5).ColumnWidth = 35;}
	}

	xlsheet.cells(2,1).Value=xlsheet.cells(2,1)+""+StartDate
	xlsheet.cells(2,6).Value =xlsheet.cells(2,6)+""+EndDate
    
     //xlsheet.printout;
   xlApp.Visible = true;
   //xlApp.UserControl = true;
   xlsheet=null;
   //xlBook.Close (savechanges=false);
  // xlApp.quit();              //退出EXCEL进程
   xlApp=null;
 
   
   
	
}


document.body.onload = BodyLoadHandler;