//function:科室工作量统计明细
//组件:DHCPEStationWorkInfoList

function BodyLoadHandler() {
	var obj;

	//导出数据
	obj=document.getElementById("BExport") 
	if (obj) { obj.onclick=BExport_click; } 
	
}

function BExport_click()
{ 
    try{
	    
		var obj;
		var User=session['LOGON.USERID']
		obj=document.getElementById("Prnpath");

		if (obj && ""!=obj.value) {
			var prnpath=obj.value;
			var Templatefilepath=prnpath+'DHCPEStationWorkInfoList.xls';
		}else{
			alert("无效模板路径");
			return;
		}
		xlApp = new ActiveXObject("Excel.Application"); 
		xlApp.UserControl = true;
       	xlApp.visible = true; //显示 
		xlBook = xlApp.Workbooks.Add(Templatefilepath); 
		xlsheet = xlBook.WorkSheets("Sheet1"); 

		
		 var Num=tkMakeServerCall("web.DHCPE.Report.StationWorkStatistic","GetStationWorkInfoListStatisticRows",User)
	
		var k=1;
		for (j=1;j<=Num;j++)
		{ 
			    
		    	var DataStr=tkMakeServerCall("web.DHCPE.Report.StationWorkStatistic","GetStationWorkInfoListRowsInfo",User,j)
		     	var Data=DataStr.split("^")
		     	xlsheet.cells(k+j,1)=Data[1]
		     	xlsheet.cells(k+j,2)=Data[0] 
				xlsheet.cells(k+j,3)=Data[5] 
				xlsheet.cells(k+j,4)=Data[2]
		     	xlsheet.cells(k+j,5)=Data[3] 
				xlsheet.cells(k+j,6)=Data[4]
				 
			xlsheet.Range( xlsheet.Cells(k+j,1),xlsheet.Cells(k+j,6)).Borders.LineStyle = 1
			   
		} 
	
  
		xlBook.Close(savechanges = true);
		xlApp.Quit();
		xlApp = null;
		xlsheet = null; 

   	}
	catch(e)
	{
		alert(e+"^"+e.message);
	}
}


document.body.onload = BodyLoadHandler;
