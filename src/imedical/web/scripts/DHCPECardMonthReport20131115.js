var SelRow=0;
document.body.onload = BodyLoadHandler;
function BodyLoadHandler(){
	var obj;
	obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_click;
	obj=document.getElementById("BCreateReport");
	if (obj) obj.onclick=BCreateReport_click;
	obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_click;
	obj=document.getElementById("BOutCardMoneyStatistic");
	if (obj) obj.onclick=OutCardStatistic_click;
}
function OutCardStatistic_click(){
	
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+"DHCPECardDaySumSXT.xlsx";
	
	
	var obj,StartDate="",EndDate="";
	obj=document.getElementById("StartDate");
	if (obj) StartDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	// $zdh(Date,4)
	if(StartDate==""){
		alert("请输入日期");
		return;}
	if(EndDate==""){
		alert("请输入日期");
		return;}
	var Infos=tkMakeServerCall("web.DHCPE.CardMonthReport","OutCardStatistic",StartDate,EndDate);
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	if(Infos==0){return false;}
	//alert(Infos)
	//return;
	var Info=Infos.split("$");
	var k=Info.length;
	for (var l=0;l<k;l++)
	{
		//alert(Info[l])
		var Datas=Info[l];
		var Data=Datas.split("^");
		xlsheet.cells(l+7,1).Value=Data[0];
		xlsheet.cells(l+7,2).Value=Data[1];
		xlsheet.cells(l+7,3).Value=Data[2];
		xlsheet.cells(l+7,4).Value=Data[3];
		xlsheet.cells(l+7,5).Value=Data[4];
		xlsheet.cells(l+7,6).Value=Data[5];
	
		
	}

	xlApp.Visible = true;
	xlApp.UserControl = true;

	
	
	
	}
function BPrint_click()
{
	if (SelRow==0) return false;
	var ParRef="";
	var obj;
	obj=document.getElementById("TIDz"+SelRow);
	if (obj) ParRef=obj.value;
	if (ParRef=="") return false;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPECardMonthReport.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	obj=document.getElementById("GetReportInfoClass");
	var encmeth=obj.value;
	xlApp = new ActiveXObject("Excel.Application");  
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  
	xlsheet = xlBook.WorkSheets("Sheet1");
	var ChangeAmount=0;
	var ChangeAmountobj=document.getElementById("ChangeAmount");
	if (ChangeAmountobj&&ChangeAmountobj.checked) ChangeAmount="1";
	var Info=cspRunServerMethod(encmeth,ParRef,"","D");
	var Row=4;
	while (Info!="")
	{
		var DataArr=Info.split("^");
		var DataLength=DataArr.length;
		var PreAmt=DataArr[4];
		var CurAmt=DataArr[11];
		
		Info=cspRunServerMethod(encmeth,ParRef,DataArr[0],"D"); //注意这句的位置，不能在continue后边，否则是死循环

		if((PreAmt==CurAmt)&&(ChangeAmount==1)){
			continue;
		}
		
		xlsheet.Rows(Row).insert();
		for (i=1;i<DataLength;i++)
		{
			//水平对齐方式枚举* (1-常规，2-靠左，3-居中，4-靠右，5-填充 6-两端对齐，7-跨列居中，8-分散对齐) 
			//xlsheet.cells(Row,i).HorizontalAlignment = 4; 
			//xlsheet.cells(Row,i).NumberFormatLocal = "0.00";
			xlsheet.cells(Row,i).value=DataArr[i];
		}
		Row=Row+1;
		//if(Row==30)break;
	}
	xlsheet.Range(xlsheet.cells(4,2),xlsheet.cells(Row-1,3)).HorizontalAlignment=2;
	xlsheet.Range(xlsheet.cells(4,4),xlsheet.cells(Row-1,14)).HorizontalAlignment=4;
	xlsheet.Range(xlsheet.cells(4,4),xlsheet.cells(Row-1,14)).NumberFormatLocal = "0.00";
	
	var Info=cspRunServerMethod(encmeth,ParRef,"","M");
	var DataArr=Info.split("^");
	var DataLength=DataArr.length;
	for (i=1;i<DataLength-3;i++)
	{
		xlsheet.cells(Row,i).value=DataArr[i];
	}
	
	xlsheet.Rows(Row+1).Delete;
	xlsheet.cells(Row+1,1).value=xlsheet.cells(Row+1,1)+DataArr[DataLength-3];
	xlsheet.cells(2,1).value=xlsheet.cells(2,1)+DataArr[DataLength-2];
	xlsheet.cells(Row+1,7).value=xlsheet.cells(Row+1,7)+DataArr[DataLength-1];
	xlsheet.cells(Row+1,4).value=xlsheet.cells(Row+1,4)+session['LOGON.USERNAME'];
	//xlsheet.printout;
	//xlBook.Close (savechanges=false);
	//xlApp.Quit();
	//xlApp=null;
	//xlsheet=null;
	xlApp.Visible = true;
   	xlApp.UserControl = true;
}
function BCreateReport_click()
{
	var obj,encmeth="";
	obj=document.getElementById("CreateClass");
	if (obj) encmeth=obj.value;
	var UserID=session['LOGON.USERID'];
	var ret=cspRunServerMethod(encmeth,UserID);
	window.location.reload();
}
function BFind_click()
{
	var obj,StartDate="",EndDate="";
	obj=document.getElementById("StartDate");
	if (obj) StartDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPECardMonthReport&StartDate="+StartDate+"&EndDate="+EndDate;
	window.location.href=lnk;
}
function SelectRowHandler()	
{
	var eSrc = window.event.srcElement;	//触发事件的
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (SelRow==selectrow){
		
	}else{
		SelRow=selectrow;
		var ParRef="",ChangeAmount="0";
		var obj=document.getElementById("TIDz"+SelRow);
		if (obj) ParRef=obj.value;
		var obj=document.getElementById("ChangeAmount");
		if (obj&&obj.checked) ChangeAmount="1";
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPECardMonthReportDetail&ParRef="+ParRef+"&ChangeAmount="+ChangeAmount ;
		parent.frames["Detail"].location.href=lnk;
	}
}