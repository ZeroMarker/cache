/// 
//名称	DHCPENoResultItems.js
//功能	按科室统计某时间段的未回传结果的项目
//组件	DHCPENoResultItems
//对象	
//创建	20121103
//最后修改时间	
//最后修改人	
//完成
var TFORM="tDHCPENoResultItems"; 
function BodyLoadHandler() {

	var obj; 
	obj=document.getElementById("ExportNoResultItems");
	if (obj){	
		 obj.onclick=ExportNoResultItems_click;
	} 
	obj=document.getElementById("RecLoc");
	if (obj){	
		 obj.onchange=RecLoc_change;
	}
	websys_setfocus("DateFrom"); 
}  

function SelectRowHandler()
{
	//获得行号
	var eSrc = window.event.srcElement
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex; 
	
	//获得对应行对应列的值
	var SelRowObj=document.getElementById('TComPhonez'+selectrow)
	var ComName = SelRowObj.innerText; 
}
function ExportNoResultItems_click()
{  
    try{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPENoResultItems.xlsx';
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
    
   	if(TFORM.length==0)
   	{
		alert("此次查询结果为空")
	   	return;
	}  

	var DateFromTo=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetDateFromTo");
	xlsheet.cells(1,1).value="查询时间段:"+DateFromTo;
	var QueryTime=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetQueryTime");

	if(QueryTime=="")
	{
		alert("请重新查询");
		return; 
	}
	xlsheet.cells(2,1).value="打印时间:"+QueryTime;
	var RowsLen=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetRowLength");  
	if(RowsLen==0){		
		alert("此次查询结果为空")
	   	return;
	}
	var k=2
	for(var i=1;i<=RowsLen;i++)
	{  
		var DataStr=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetRowData",i); 
		var tempcol=DataStr.split("^");
		k=k+1
		xlsheet.Rows(k+1).insert(); 
		if((tempcol[1]==""))
		{   
			xlsheet.cells(k,1)=tempcol[0]; //写科室名称
			var Range=xlsheet.Cells(k,1);
	        xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,4)).mergecells=true; //合并单元格
	        k=k+1
			xlsheet.Rows(k+1).insert();  
			xlsheet.cells(k,1)="姓名"
			xlsheet.cells(k,2)="登记号" 
			xlsheet.cells(k,3)="到达时间" 
			xlsheet.cells(k,4)="项目" 
			xlsheet.Columns(2).NumberFormatLocal="@";  //设置登记号为文本型 
			xlsheet.Columns(3).NumberFormatLocal="@";   
		}
		else
		{
			xlsheet.cells(k,1)=tempcol[0]
			xlsheet.cells(k,2)=tempcol[1]
			xlsheet.cells(k,3)=tempcol[2]
			xlsheet.cells(k,4)=tempcol[3]
			                          
		}  
	}
	var FileName="d:\\未回传结果项目.xls";
	var obj=document.getElementById("savepath");
	if (obj) FileName=obj.value;
	
	///删除最后的空行
	//xlsheet.Rows(k+1).Delete;
	/*xlsheet.SaveAs(FileName);
	xlApp.Visible = true;
	xlApp.UserControl = true;	 
	idTmr   =   window.setInterval("Cleanup();",1);  
	*/ 

    xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null

	idTmr   =   window.setInterval("Cleanup();",1); 
	 
}

catch(e)
	{
		alert(e+"^"+e.message);
	}
}
function SetStationID(value)
{
	if (value=="") return false;
	var DataArry=value.split("^");
	var obj=document.getElementById("StationId");
	if (obj) obj.value=DataArry[1];
}
function RecLocSelectAfter(value)
{
	if (value=="") return false;
	Arr=value.split("^");
	var obj=document.getElementById("RecLocID");
	if (obj) obj.value=Arr[1];
}
function RecLoc_change()
{
	var obj=document.getElementById("RecLocID");
	if (obj) obj.value="";
	
}
document.body.onload = BodyLoadHandler;