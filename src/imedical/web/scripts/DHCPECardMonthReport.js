var SelRow=0;
document.body.onload = BodyLoadHandler;
function BodyLoadHandler(){
	var obj;
	obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_click;
	obj=document.getElementById("BCreateReport");
	if (obj) obj.onclick=BCreateReport_click;
	//收支报表
	obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_click;
	//收支汇总
	obj=document.getElementById("BPrintTotal");
	if (obj) obj.onclick=BPrintTotal_click;
	//收入报表
	obj=document.getElementById("BOutCardMoneyStatistic");
	if (obj) obj.onclick=OutCardStatistic_click;
	//收入汇总
	obj=document.getElementById("BInTotal");
	if (obj) obj.onclick=BInTotal_click;
	
	//生成预览
	obj=document.getElementById("BCreatePrivew");
	if (obj) obj.onclick=BCreatePrivew_click;
	
}
function BInTotal_click()
{
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+"DHCPECardDaySumSXT.xls";
	var obj,StartDate="",EndDate="";
	obj=document.getElementById("StartDate");
	if (obj) StartDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	IDs=GetIDs();
	if (IDs=="-1"){
		alert("输入工号不存在");
		return false;
	}
	var Arr=IDs.split("$");
	var UserName=Arr[1];
	IDs=Arr[0];

	if ((IDs=="")&&(UserName!="")){
		
		alert("输入工号没有对应的月报")
		return false;
	}

	if (IDs=="") return false
	var IDArr=IDs.split("^");
	var IDLength=IDArr.length;
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	var HosName=""
	var HosName=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetHospitalName");
    xlsheet.cells(1,1).Value=HosName+"体检卡收入日报表";	
	var TotalAmt0=0;
	var TotalAmt1=0;
	var TotalAmt2=0;
	var TotalAmt3=0;
	var Rows=0;
	for (var j=0;j<IDLength;j++)
	{
		var ParRef=IDArr[j];
		var Infos=tkMakeServerCall("web.DHCPE.CardMonthReport","GetCardInAmt",ParRef);
		if (Infos=="") continue;
		var Info=Infos.split("$");
		var k=Info.length;
		for (var l=0;l<k-1;l++)
		{
			var Datas=Info[l];
			var Data=Datas.split("^");
			xlsheet.cells(Rows+7,1).Value=Data[0];
			xlsheet.cells(Rows+7,2).Value=Data[1];
			xlsheet.cells(Rows+7,3).Value=Data[2];
			xlsheet.cells(Rows+7,4).Value=Data[3];
			xlsheet.cells(Rows+7,5).Value=Data[4];
			xlsheet.cells(Rows+7,6).Value=Data[5];
			TotalAmt1=TotalAmt1+(+Data[5]);
			xlsheet.cells(Rows+7,7).Value=Data[6];
			TotalAmt2=TotalAmt2+(+Data[6]);
			xlsheet.cells(Rows+7,8).Value=Data[7];
			TotalAmt3=TotalAmt3+(+Data[7]);
			Rows=Rows+1;
		}
	}
	TotalAmt0=TotalAmt1+TotalAmt2+TotalAmt3;
	xlsheet.cells(Rows+7,1).Value="收费员";
	xlsheet.cells(Rows+7,2).Value=UserName;
	xlsheet.cells(Rows+7,5).Value="总计："+TotalAmt0;
	xlsheet.cells(Rows+7,6).Value=TotalAmt1;
	xlsheet.cells(Rows+7,7).Value=TotalAmt2;
	xlsheet.cells(Rows+7,8).Value=TotalAmt3;
	xlApp.Visible = true;
	xlApp.UserControl = true;
}
function OutCardStatistic_click(){
	var ParRef="";
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+"DHCPECardDaySumSXT.xls";
	var obj,StartDate="",EndDate="";
	obj=document.getElementById("TIDz"+SelRow);
	if (obj) ParRef=obj.value;
	if (ParRef=="") {
		alert("未选择月报记录")
		return false;
	}

	obj=document.getElementById("StartDate");
	if (obj) StartDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	/*
	if(StartDate==""){
		alert("请输入日期");
		return;}
	if(EndDate==""){
		alert("请输入日期");
		return;}
		*/

	var Infos=tkMakeServerCall("web.DHCPE.CardMonthReport","GetCardInAmt",ParRef);
	if (Infos=="") return false;
	xlApp = new ActiveXObject("Excel.Application");
	xlApp.UserControl = true;
    xlApp.visible = true; //显示
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	var HosName=""
	var HosName=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetHospitalName");
    xlsheet.cells(1,1).Value=HosName+"体检中心体检卡收入日报表";
	if(Infos==0){return false;}
	var UserName="";
	var Info=Infos.split("$");
	var k=Info.length;
	for (var l=0;l<k;l++)
	{
		var Datas=Info[l];
		var Data=Datas.split("^");
		xlsheet.cells(l+7,1).Value=Data[0];
		xlsheet.cells(l+7,2).Value=Data[1];
		xlsheet.cells(l+7,3).Value=Data[2];
		xlsheet.cells(l+7,4).Value=Data[3];
		xlsheet.cells(l+7,5).Value=Data[4];
		xlsheet.cells(l+7,6).Value=Data[5];	
		xlsheet.cells(l+7,7).Value=Data[6];
		xlsheet.cells(l+7,8).Value=Data[7]; 

	}
	//xlApp.Visible = true;
	//xlApp.UserControl = true;
	xlBook.Close(savechanges = true);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;

}
function BPrint_click()
{
	if (SelRow==0) 
	{  
		alert("未选择月报记录");
		return false;
	}

	var ParRef="";
	var obj;
	obj=document.getElementById("TIDz"+SelRow);
	if (obj) ParRef=obj.value;
	if (ParRef=="") {
		alert("未选择月报记录");
		return false;
	}

	PrintApp(ParRef);
}
function PrintApp(ParRef)
{
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
	var HosName=""
	var HosName=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetHospitalName");
    xlsheet.cells(1,1).Value=HosName+"体检中心体检卡收支月报表";
	var ChangeAmount=0;
	var ChangeAmountobj=document.getElementById("ChangeAmount");
	if (ChangeAmountobj&&ChangeAmountobj.checked) ChangeAmount="1";
	var Info=cspRunServerMethod(encmeth,ParRef,"","D",ChangeAmount);
	var Row=4;
	var PreAmtSum=0;
	var AddAmtSum=0;
	var BackAmtSum=0;
	var MoveInAmtSum=0;
	var LesAmtSum=0;
	var OutAmtSum=0;
	var MoveOutAmtSum=0;	
	var CurAmtSum=0;
	var ExpStr="";
	while (Info!="")
	{
		var DataArr=Info.split("^");
		var DataLength=DataArr.length;
		var PreAmt=DataArr[4];
		var AddAmt=DataArr[5];
		var BackAmt=DataArr[6];
		var MoveInAmt=DataArr[7];
		var LesAmt=DataArr[8];
		var OutAmt=DataArr[9];
		var MoveOutAmt=DataArr[10];
		var CurAmt=DataArr[11];
		Info=cspRunServerMethod(encmeth,ParRef,DataArr[0],"D",ChangeAmount); //注意这句的位置，不能在continue后边，否则是死循环
		if((AddAmt==0)&&(BackAmt==0)&&(LesAmt==0)&&(MoveInAmt==0)&&(MoveOutAmt==0)&&(ChangeAmount==1)){
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
		//CardType_"^"_CardNo_"^"_Name_"^"_PreAmt_"^"_AddAmt_"^"_BackAmt_"^"_MoveInAmt
		//_"^"_LesAmt_"^"_OutAmt_"^"_MoveOutAmt_"^"_CurAmt
		var tmpPreAmt=DataArr[4];
		PreAmtSum=PreAmtSum+eval(tmpPreAmt);
		var tmpAddAmt=DataArr[5];
		AddAmtSum=AddAmtSum+eval(tmpAddAmt);
		var tmpBackAmt=DataArr[6];
		BackAmtSum=BackAmtSum+eval(tmpBackAmt);
		var tmpMoveInAmt=DataArr[7];
		MoveInAmtSum=MoveInAmtSum+eval(tmpMoveInAmt);		
		var tmpLesAmt=DataArr[8];
		LesAmtSum=LesAmtSum+eval(tmpLesAmt);
		var tmpOutAmt=DataArr[9];
		OutAmtSum=OutAmtSum+eval(tmpOutAmt);
		var tmpMoveOutAmt=DataArr[10];
		MoveOutAmtSum=MoveOutAmtSum+eval(tmpMoveOutAmt);
		var tmpCurAmt=DataArr[11];
		CurAmtSum=CurAmtSum+eval(tmpCurAmt);
		Row=Row+1;
		//if(Row==30)break;
	}
	xlsheet.Range(xlsheet.cells(4,2),xlsheet.cells(Row-1,3)).HorizontalAlignment=2;
	xlsheet.Range(xlsheet.cells(4,4),xlsheet.cells(Row-1,14)).HorizontalAlignment=4;
	xlsheet.Range(xlsheet.cells(4,4),xlsheet.cells(Row-1,14)).NumberFormatLocal = "0.00";
	
	//var RetInfo=cspRunServerMethod(encmeth,ParRef,ChangeAmount);
	var OldInfo=cspRunServerMethod(encmeth,ParRef,"","M",ChangeAmount);
	var OldArr=OldInfo.split("^");
	var OldArrLength=OldArr.length;
	ExpStr=OldArr[OldArrLength-3]+"^"+OldArr[OldArrLength-2]+"^"+OldArr[OldArrLength-1];
	var Info="^^^合计^"+PreAmtSum+"^"+AddAmtSum+"^"+BackAmtSum+"^"+MoveInAmtSum+"^"+LesAmtSum+"^"+OutAmtSum+"^"+MoveOutAmtSum+"^"+CurAmtSum+"^"+ExpStr;
	var DataArr=Info.split("^");
	var DataLength=DataArr.length;
	for (i=1;i<DataLength-3;i++)
	{
		xlsheet.cells(Row,i).value=DataArr[i];
		
	}
	
	xlsheet.Rows(Row+1).Delete;
	xlsheet.cells(Row+1,1).value="" //xlsheet.cells(Row+1,1)+DataArr[DataLength-3];
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
function GetIDs()
{
	var IDs="",StartDate="",EndDate="",UserID="",encmeth="",UserNo="",obj;
	obj=document.getElementById("StartDate");
	if (obj) StartDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	obj=document.getElementById("UserNo");
	if (obj) UserNo=obj.value;
	UserID=session['LOGON.USERID'];
	obj=document.getElementById("GetIDs")
	if (obj) encmeth=obj.value;
	var IDs=cspRunServerMethod(encmeth,StartDate,EndDate,UserID,UserNo);
	return IDs
}
function BPrintTotal_click()
{
	var IDs="",ParRef="",encmeth="",StartDate="",EndDate="";
	var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		//var Templatefilepath=prnpath+'DHCPECardMonthReport.xls';
		var Templatefilepath=prnpath+'DHCPECardMonthReportSZTotal.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	obj=document.getElementById("StartDate");
	if (obj) StartDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	IDs=GetIDs();
	if (IDs=="-1"){
		alert("输入工号不存在");
		return false;
	}
	var Arr=IDs.split("$");
	var UserName=Arr[1];
	IDs=Arr[0];
	if ((IDs=="")&&(UserName!="")){
		alert("输入工号没有对应的月报")
		return false;
	}
	if (IDs=="") return false
	xlApp = new ActiveXObject("Excel.Application");  
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  
	xlsheet = xlBook.WorkSheets("Sheet1");
	obj=document.getElementById("GetReportInfoClass");
	if (obj) encmeth=obj.value;
	var HosName=""
	var HosName=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetHospitalName");
    xlsheet.cells(1,1).Value=HosName+"体检中心体检卡收支月报表";
	var Row=4;
	var PreAmtSum=0;
	var AddAmtSum=0;
	var BackAmtSum=0;
	var MoveInAmtSum=0;
	var LesAmtSum=0;
	var OutAmtSum=0;
	var MoveOutAmtSum=0;	
	var CurAmtSum=0;
	var ExpStr="";
	var ChangeAmount=0;
	var ChangeAmountobj=document.getElementById("ChangeAmount");
	if (ChangeAmountobj&&ChangeAmountobj.checked) ChangeAmount="1";
	var IDArr=IDs.split("^");
	var IDLength=IDArr.length;
	for (var j=0;j<IDLength;j++)
	{
		var ParRef=IDArr[j];
		var Info=cspRunServerMethod(encmeth,ParRef,"","D",ChangeAmount);
		while (Info!="")
		{
			var DataArr=Info.split("^");
			var DataLength=DataArr.length;
			var PreAmt=DataArr[4];
			var AddAmt=DataArr[5];
			var BackAmt=DataArr[6];
			var MoveInAmt=DataArr[7];
			var LesAmt=DataArr[8];
			var OutAmt=DataArr[9];
			var MoveOutAmt=DataArr[10];
			var CurAmt=DataArr[11];
			Info=cspRunServerMethod(encmeth,ParRef,DataArr[0],"D",ChangeAmount); //注意这句的位置，不能在continue后边，否则是死循环
			if((AddAmt==0)&&(BackAmt==0)&&(LesAmt==0)&&(ChangeAmount==1)){
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
			//CardType_"^"_CardNo_"^"_Name_"^"_PreAmt_"^"_AddAmt_"^"_BackAmt_"^"_MoveInAmt
			//_"^"_LesAmt_"^"_OutAmt_"^"_MoveOutAmt_"^"_CurAmt
			var tmpPreAmt=DataArr[4];
			PreAmtSum=PreAmtSum+eval(tmpPreAmt);
			var tmpAddAmt=DataArr[5];
			AddAmtSum=AddAmtSum+eval(tmpAddAmt);
			var tmpBackAmt=DataArr[6];
			BackAmtSum=BackAmtSum+eval(tmpBackAmt);
			var tmpMoveInAmt=DataArr[7];
			MoveInAmtSum=MoveInAmtSum+eval(tmpMoveInAmt);		
			var tmpLesAmt=DataArr[8];
			LesAmtSum=LesAmtSum+eval(tmpLesAmt);
			var tmpOutAmt=DataArr[9];
			OutAmtSum=OutAmtSum+eval(tmpOutAmt);
			var tmpMoveOutAmt=DataArr[10];
			MoveOutAmtSum=MoveOutAmtSum+eval(tmpMoveOutAmt);
			var tmpCurAmt=DataArr[11];
			CurAmtSum=CurAmtSum+eval(tmpCurAmt);
			Row=Row+1;
			//if(Row==30)break;
		}
		xlsheet.Range(xlsheet.cells(4,2),xlsheet.cells(Row-1,3)).HorizontalAlignment=2;
		xlsheet.Range(xlsheet.cells(4,4),xlsheet.cells(Row-1,14)).HorizontalAlignment=4;
		xlsheet.Range(xlsheet.cells(4,4),xlsheet.cells(Row-1,14)).NumberFormatLocal = "0.00";
	}
	//var RetInfo=cspRunServerMethod(encmeth,ParRef,ChangeAmount);
	var OldInfo=cspRunServerMethod(encmeth,ParRef,"","M",ChangeAmount);
	var OldArr=OldInfo.split("^");
	var OldArrLength=OldArr.length;
	ExpStr=OldArr[OldArrLength-3]+"^"+OldArr[OldArrLength-2]+"^"+OldArr[OldArrLength-1];
	var Info="^^^合计^"+PreAmtSum+"^"+AddAmtSum+"^"+BackAmtSum+"^"+MoveInAmtSum+"^"+LesAmtSum+"^"+OutAmtSum+"^"+MoveOutAmtSum+"^"+CurAmtSum+"^"+ExpStr;
	var DataArr=Info.split("^");
	var DataLength=DataArr.length;
	for (i=1;i<DataLength-3;i++)
	{
		xlsheet.cells(Row,i).value=DataArr[i];
		
	}
	
	xlsheet.Rows(Row+1).Delete;
	xlsheet.cells(Row+1,1).value="" //xlsheet.cells(Row+1,1)+DataArr[DataLength-3];
	xlsheet.cells(2,1).value="日期范围："+StartDate+"   "+EndDate   //xlsheet.cells(2,1)+DataArr[DataLength-2];
	xlsheet.cells(Row+1,7).value=xlsheet.cells(Row+1,7)+DataArr[DataLength-1];
	xlsheet.cells(Row+1,4).value=xlsheet.cells(Row+1,4)+UserName;
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
	CreateApp();
	window.location.reload();
}
function CreateApp()
{
	var obj,encmeth="";
	obj=document.getElementById("CreateClass");
	if (obj) encmeth=obj.value;
	var UserID=session['LOGON.USERID'];
	var ret=cspRunServerMethod(encmeth,UserID);
	return ret;
}
function BCreatePrivew_click()
{
	var ret=CreateApp();
	var Arr=ret.split("^");
	if (Arr[0]=="-1"){
		alert("生成预览错误");
		return false;
	}
	PrintApp(Arr[0]);
	//if (!confirm("是否继续生成报表?")){
		DeleteReportApp(Arr[0]);
	//}else{
	//	window.location.reload();
	//}
}
function DeleteReportApp(ParRef)
{
	var obj,encmeth="";
	obj=document.getElementById("DeleteMethodClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ParRef);
	return ret;
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
		SelRow=0;
		
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