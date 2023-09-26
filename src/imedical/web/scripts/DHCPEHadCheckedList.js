/// DHCPEHadCheckedList.js

function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("Print");
	if (obj) {obj.onclick=Print_Click;}

}




function Print_Click()
{ 
    var obj,HadCheckType="",DateFrom="",DateTo=""
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEHadCheckedList.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	//alert(Templatefilepath)
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
	
	//xlsheet.Range(xlsheet.Cells(2,1),xlsheet.Cells(2,7)).Borders.LineStyle=1
	//xlsheet.Range(xlsheet.Cells(3,1),xlsheet.Cells(3,7)).Borders.LineStyle=1
	 xlsheet.Range(xlsheet.Cells(2,1),xlsheet.Cells(2,13)).Borders.LineStyle=1; 
     xlsheet.Range(xlsheet.Cells(3,1),xlsheet.Cells(3,13)).Borders.LineStyle=1;
     xlsheet.Range(xlsheet.Cells(2,1),xlsheet.Cells(2,13)).mergecells=true;
     xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,13)).mergecells=true;

	
	//if ((DateFrom=="")||(DateTo=="")) { 
	///xlsheet.Range(xlsheet.Cells(2,1),xlsheet.Cells(2,2)).RowHeight =0}
	
	//ExcelSheet.Range( ExcelSheet.Cells(tempRow+1,1),ExcelSheet.Cells(currRow-1,4)).RowHeight = 20;}
	
	//else { xlsheet.cells(2,1).Value="  "+"开始日期:"+DateFrom+"           "+"结束日期:"+DateFrom;}
	//var PersonString=String.split("!")[0]
	//var StringArr=PersonString.split("^");
    //var Rows=StringArr.length;
   
    var encmethObj=document.getElementById("PrintInfoBox");
    if (encmethObj) encmeth=encmethObj.value;
    /*
    var PersonInfo=cspRunServerMethod(encmeth,"");
    var infos= PersonInfo.split("@@");
   	*/
   
    Rows=tkMakeServerCall("web.DHCPE.PreGADM","GetPostionNum");
    for(i=0;i<Rows;i++)
		{
			//Position_"^"_GroupDesc_"^"_TeamDesc_"^"_IRegNo_"^"_IName_"^"_ISexDRName_"^"_IAge_"^"_IDepName_"^"_HadCheckType_"^"_DateFrom_"^"_DateTo_"^"_OneAmount_"^"_IAmt_"^"_FItemAmt_"^"_FEntAmt
		      
		      var OneInfo=cspRunServerMethod(encmeth,i+1)
		      var Info=OneInfo.split("^");
		      var HadCheckType=Info[7];
         	  if (HadCheckType=="Y"){ HadCheckType="已检人员名单"}
			  else  { HadCheckType="未检人员名单"}
		      
		      xlsheet.cells(4+i,1).Value=i+1;
		      xlsheet.cells(4+i,2).Value=Info[2];	//登记号
		      xlsheet.cells(4+i,3).Value=Info[3]; 	//姓名
		      xlsheet.cells(4+i,4).Value=Info[4]; 	//性别
		      xlsheet.cells(4+i,5).Value=Info[5]; 	//分组6
		      xlsheet.cells(4+i,6).Value=Info[10];	//年龄5
		      xlsheet.cells(4+i,7).Value=Info[1];	//部门6
		      xlsheet.cells(4+i,8).Value=Info[6]; 	//金额7
		      xlsheet.cells(4+i,9).Value=Info[11]; 	//自费金额7
		      xlsheet.cells(4+i,10).Value=Info[12]; 	//公费项目金额7
		      xlsheet.cells(4+i,11).Value=Info[13]; 	//套餐金额7
			  xlsheet.cells(4+i,12).Value=Info[14]; //移动电话
			  xlsheet.cells(4+i,13).Value=Info[15]; //到达时间

		      //xlsheet.cells(3,7).Value="部门"; 
              xlsheet.cells(1,1).Value=Info[0]+HadCheckType; 
             xlsheet.Range(xlsheet.Cells(4+i,1),xlsheet.Cells(4+i,6)).HorizontalAlignment =-4108;//居中
             xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,13)).HorizontalAlignment =-4108;//居中
         	// xlsheet.Range(xlsheet.Cells(1+i,1),xlsheet.Cells(1+i,6)).Borders(9).LineStyle=1;//居中
         	 // xlsheet.Range(xlsheet.Cells(1+i,1),xlsheet.Cells(1+i,6)).Borders(3).LineStyle=1;
         	  xlsheet.Range(xlsheet.Cells(4+i,1),xlsheet.Cells(4+i,13)).Borders.LineStyle=1; }
   //xlsheet.SaveAs("d:\\团体人员名单.xls")
   xlApp.Visible = true;
   xlApp.UserControl = true;
     

}



document.body.onload = BodyLoadHandler;
