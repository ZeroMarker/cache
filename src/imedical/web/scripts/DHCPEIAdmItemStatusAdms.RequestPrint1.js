function PrintLisRequest()
{
	PrintDriverCard()
	return false
	PrintLisRequestOld("N");
}
function PrintLisRequestBD()
{
	PrintLisRequestOld("Y");
}
function PrintRisRequest()
{
	PrintRisRequestOld("N");
}
function PrintRisRequestBD()
{
	PrintRisRequestOld("Y");
}
function PrintLisRequestOld(Type)
{
	var Data=GetSelectId("TAdmId^TDeitFlag^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");
	var Instring=""
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){
		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			if (Instring=="")
			{
				Instring=FData[2];
			}
			else
			{Instring=Instring+"^"+FData[2];}
			
			
		}
		
	}
	PrintLisRequestApp(Instring,Type);	
}

function PrintRisGZD()
{
	var obj;
	var Data=GetSelectId("TAdmId^TDeitFlag^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");
	var OrdItemID="",Instring="",prnpath="",encmeth=""
	var OneSpecNo=parent.frames["DHCPEIAdmItemStatusDetail"].GetOneOrdItem();
	var Info=OneSpecNo.split("^");
	OrdItemID=Info[1];
	obj=document.getElementById("prnpath");
	prnpath=obj.value;
	var Ins=document.getElementById("GetGZDInfoClass");
	if (Ins) encmeth=Ins.value;
	if (encmeth=="") return;
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){
		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			var IADM=FData[2];
			var InfoStr=cspRunServerMethod(encmeth,IADM,OrdItemID);
			if (InfoStr=="") continue;
			var InfoStrArr=InfoStr.split("$$");
			var BaseInfo=InfoStrArr[0];
			var BaseArr=BaseInfo.split("^");
			var TempInfo=InfoStrArr[1];
			var TempArr=TempInfo.split("%%");
			var i=TempArr.length;
			for (var j=0;j<i;j++)
			{
				var Temp=TempArr[j].split("^");
				var Templatefilepath=prnpath+Temp[0];
				var OrderName=Temp[1];
				xlApp = new ActiveXObject("Excel.Application");
				xlBook = xlApp.Workbooks.Add(Templatefilepath);
				xlsheet = xlBook.WorkSheets("Sheet1");
				xlsheet.cells(1,1).Value=OrderName+xlsheet.cells(1,1).Value;
				xlsheet.cells(2,2).Value=BaseArr[0];
				xlsheet.cells(2,5).Value=BaseArr[1];
				xlsheet.cells(2,7).Value=BaseArr[4]+"岁";
				xlsheet.cells(3,2).Value="'"+BaseArr[2];
				xlsheet.cells(3,5).Value="'"+BaseArr[3];
				xlsheet.printout
				//xlsheet.saveas("d:\\aa.xls")
				xlBook.Close (savechanges=false);
				xlApp=null;
				xlsheet=null;
			}
			
			
		}
		
	}
}
function GetSelectOrdItem()
{
	var SelectOrdItem=""
	var OneSpecNo=parent.frames["DHCPEIAdmItemStatusDetail"].GetOneOrdItem();
	
	var Info=OneSpecNo.split("&");
	var i=Info.length;
	for (var j=0;j<i;j++)
	{
		var OneInfo=Info[j];
		var OneOrdItem=OneInfo.split("^")[1];
		if (OneOrdItem=="") continue;
		if (SelectOrdItem=="")
		{
			SelectOrdItem=OneOrdItem;
		}
		else
		{
			SelectOrdItem=SelectOrdItem+"^"+OneOrdItem;
		}
	}
	return SelectOrdItem;
	
}
function PrintLisRequestApp(Instring,Type)
{
	var targetFrame=GetCtlValueById("txtTargetFrame");
	var obj;
	/*var OneSpecNo=parent.frames["DHCPEIAdmItemStatusDetail"].GetOneOrdItem();
	var Info=OneSpecNo.split("^");
	var OrdItemID=Info[1];*/
	var OrdItemID=GetSelectOrdItem();
	var Ins=document.getElementById('GetLisRequestInfoBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,Instring,OrdItemID,"Lis",Type);
	if (value==""){
		alert("没有需要打印申请单的数据");	
		return;
	}
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPELisRequest.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	xlsheet.Columns(6).NumberFormatLocal="@";
	xlsheet.Columns(8).NumberFormatLocal="@";
	xlsheet.Columns(9).NumberFormatLocal="@";
	xlsheet.Columns(2).NumberFormatLocal="@";
	var Char_1=String.fromCharCode(1);
	var Char_2=String.fromCharCode(2);
	var Char_3=String.fromCharCode(3);
	var Char_4=String.fromCharCode(4);
	var DataArrT=value.split(Char_2);
	var PersonTotal=DataArrT.length;
	var Pages=-1;
	for (a=0;a<PersonTotal;a++)
	{
		
		var OnePersonData=DataArrT[a].split(Char_4);
		var BaseInfo=OnePersonData[0].split("^");
		var DataValue=OnePersonData[1];
		var DataArr=DataValue.split(Char_1);
		var i=DataArr.length;
		var Title=xlsheet.cells(2,3).Value
		Title=Title+"检验申请单"
		for (j=0;j<i;j++)
		{
			var Data=DataArr[j]
			Pages=Pages+1
			//if (DataStr.length<10) continue;
			var l=Pages*20
			xlsheet.cells(l+2,1).Value=BaseInfo[7]; //顺序号  Add 209-02-22
			xlsheet.cells(l+2,3).Value=Title //"中国医科大学附属第一医院检验申请单"
			xlsheet.cells(l+4,1).Value="姓名:"
			xlsheet.cells(l+4,2).Value=BaseInfo[0]; //姓名
			xlsheet.cells(l+4,3).Value="年龄:"
			xlsheet.cells(l+4,4).Value=BaseInfo[1]; //年龄 
			xlsheet.cells(l+4,5).Value="性别:"
			xlsheet.cells(l+4,6).Value=BaseInfo[2]; //性别
			xlsheet.cells(l+4,7).Value="登记号:"
			xlsheet.cells(l+4,8).Value=BaseInfo[3]; //登记号
			xlsheet.cells(l+5,1).Value="就诊科室:"
			xlsheet.cells(l+5,2).Value=BaseInfo[4]; //就诊科室
			DrawLine(l+5,9,xlsheet);
			xlsheet.cells(l+5,4).Value=BaseInfo[5]; //单位
			xlsheet.cells(l+6,1).Value="检验项目"
			xlsheet.cells(l+6,7).Value="送检标本"
			xlsheet.cells(l+6,9).Value="金额"
			xlsheet.cells(l+6,6).Value="标本号"
			var DataStr=Data.split(Char_3);
			
			var k=DataStr.length;
			for (m=0;m<k;m++)
			{
				OneItemInfo=DataStr[m].split("^");
				//xlsheet.Range(xlsheet.Cells(l+7+m,1),xlsheet.Cells(l+7,5)).mergecells=true;
				//xlsheet.Rows(l+7).WrapText=true
				//var String1=DataStr[9].substr(0,24)
				//var String2=DataStr[9].substr(24,48)
				//var String3=DataStr[9].substr(48,72)
				xlsheet.cells(l+7+m,1).Value=OneItemInfo[2]; //检验项目
				
				//xlsheet.cells(l+7,1).Value=String1; //检验项目
				//xlsheet.cells(l+8,1).Value=String2; //检验项目
				//xlsheet.cells(l+9,1).Value=String3; //检验项目
				
				xlsheet.cells(l+7+m,6).Value=OneItemInfo[0]; //标本号
				xlsheet.cells(l+7+m,7).Value=OneItemInfo[1]; //送检标本
				xlsheet.cells(l+7+m,9).Value=OneItemInfo[4]; //金额
			}
			xlsheet.cells(l+19,1).Value="申请日期:"
			xlsheet.Range(xlsheet.Cells(l+19,2),xlsheet.Cells(l+19,3)).mergecells=true;
			xlsheet.cells(l+19,2).Value=BaseInfo[6]; //申请日期
			xlsheet.cells(l+19,4).Value="检验人:"
			xlsheet.cells(l+19,6).Value="审核人:"
			xlsheet.cells(l+19,8).Value="检验时间:"
			DrawLine(l+18,9,xlsheet);
			xlsheet.cells(l+20,1).Value="备注:本单据金额仅为化验项目费用,未包括采血费以及采血器材费用"

		}
		
	}
	xlsheet.printout
	//xlsheet.saveas("d:\\aa.xls")
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
}
function PrintLisRis(crmid)
{
	if (""==crmid) {
		return ;
	}
	var encmeth=GetCtlValueById("GetAdmID");
	if (""==encmeth) return;
	var admid=cspRunServerMethod(encmeth,crmid);
	
	var info=admid.split("^");
	var Instring=info[1];
	var Ins=document.getElementById('GetLisRequestInfoBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,Instring,"","Lis","N");
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPELisRequest.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	if (value!=""){
		PrintLis(value,Templatefilepath)
	}
	var Title="中国医科大学附属第一医院检查申请单"
	var value=cspRunServerMethod(encmeth,Instring,"","Ris","N");
	if (value=="") return;
	PrintRis(value,Templatefilepath,Title)
}
function PrintLis(value,Templatefilepath)
{
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	xlsheet.Columns(6).NumberFormatLocal="@";
	xlsheet.Columns(8).NumberFormatLocal="@";
	xlsheet.Columns(9).NumberFormatLocal="@";
	xlsheet.Columns(2).NumberFormatLocal="@";
	var Title=xlsheet.cells(2,3).Value
	Title=Title+"检验申请单"
	var Char_1=String.fromCharCode(1);
	var Char_2=String.fromCharCode(2);
	var Char_3=String.fromCharCode(3);
	var Char_4=String.fromCharCode(4);
	var DataArrT=value.split(Char_2);
	var PersonTotal=DataArrT.length;
	var Pages=-1;
	for (a=0;a<PersonTotal;a++)
	{
		
		var OnePersonData=DataArrT[a].split(Char_4);
		var BaseInfo=OnePersonData[0].split("^");
		var DataValue=OnePersonData[1];
		var DataArr=DataValue.split(Char_1);
		var i=DataArr.length;
		for (j=0;j<i;j++)
		{
			var Data=DataArr[j]
			Pages=Pages+1
			//if (DataStr.length<10) continue;
			var l=Pages*20
			xlsheet.cells(l+2,3).Value=Title //"中国医科大学附属第一医院检验申请单"
			xlsheet.cells(l+4,1).Value="姓名:"
			xlsheet.cells(l+4,2).Value=BaseInfo[0]; //姓名
			xlsheet.cells(l+4,3).Value="年龄:"
			xlsheet.cells(l+4,4).Value=BaseInfo[1]; //年龄 
			xlsheet.cells(l+4,5).Value="性别:"
			xlsheet.cells(l+4,6).Value=BaseInfo[2]; //性别
			xlsheet.cells(l+4,7).Value="登记号:"
			xlsheet.cells(l+4,8).Value=BaseInfo[3]; //登记号
			xlsheet.cells(l+5,1).Value="就诊科室:"
			xlsheet.cells(l+5,2).Value=BaseInfo[4]; //就诊科室
			DrawLine(l+5,9,xlsheet);
			xlsheet.cells(l+5,4).Value=BaseInfo[5]; //单位
			xlsheet.cells(l+6,1).Value="检验项目"
			xlsheet.cells(l+6,7).Value="送检标本"
			xlsheet.cells(l+6,9).Value="金额"
			xlsheet.cells(l+6,6).Value="标本号"
			var DataStr=Data.split(Char_3);
			
			var k=DataStr.length;
			for (m=0;m<k;m++)
			{
				OneItemInfo=DataStr[m].split("^");
				//xlsheet.Range(xlsheet.Cells(l+7+m,1),xlsheet.Cells(l+7,5)).mergecells=true;
				//xlsheet.Rows(l+7).WrapText=true
				//var String1=DataStr[9].substr(0,24)
				//var String2=DataStr[9].substr(24,48)
				//var String3=DataStr[9].substr(48,72)
				xlsheet.cells(l+7+m,1).Value=OneItemInfo[2]; //检验项目
				
				//xlsheet.cells(l+7,1).Value=String1; //检验项目
				//xlsheet.cells(l+8,1).Value=String2; //检验项目
				//xlsheet.cells(l+9,1).Value=String3; //检验项目
				
				xlsheet.cells(l+7+m,6).Value=OneItemInfo[0]; //标本号
				xlsheet.cells(l+7+m,7).Value=OneItemInfo[1]; //送检标本
				xlsheet.cells(l+7+m,9).Value=OneItemInfo[4]; //金额
			}
			xlsheet.cells(l+19,1).Value="申请日期:"
			xlsheet.Range(xlsheet.Cells(l+19,2),xlsheet.Cells(l+19,3)).mergecells=true;
			xlsheet.cells(l+19,2).Value=BaseInfo[6]; //申请日期
			xlsheet.cells(l+19,4).Value="检验人:"
			xlsheet.cells(l+19,6).Value="审核人:"
			xlsheet.cells(l+19,8).Value="检验时间:"
			DrawLine(l+18,9,xlsheet);
			xlsheet.cells(l+20,1).Value="备注:本单据金额仅为化验项目费用,未包括采血费以及采血器材费用"

		}
		
	}
	xlsheet.printout
	//xlsheet.saveas("d:\\aa.xls")
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
}
function PrintRis(value,Templatefilepath,Title)
{
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	xlsheet.Columns(4).NumberFormatLocal="@";
	xlsheet.Columns(8).NumberFormatLocal="@";
	xlsheet.Columns(7).NumberFormatLocal="@";
	xlsheet.Columns(2).NumberFormatLocal="@";
	var Title=xlsheet.cells(2,3).Value
	Title=Title+"检验申请单"
	var Pages=-1;
	var Char_0=String.fromCharCode(0);
	var TotalPerson=value.split(Char_0);
	var i=TotalPerson.length;
	for (j=0;j<i;j++)
	{
		var Char_1=String.fromCharCode(1);
		var OneStr=TotalPerson[j];
		var OneArr=OneStr.split(Char_1);
		var OnePatInfo=OneArr[0];
		var OnePatInfo=OnePatInfo.split("^");
		var RecLoc=OneArr[1];
		var Char_2=String.fromCharCode(2);
		var RecLocArr=RecLoc.split(Char_2);
		var k=RecLocArr.length;
	
		for (l=0;l<k;l++)
		{ 
			var OneLoc=RecLocArr[l];
			var Char_3=String.fromCharCode(3);
			var OneLocArr=OneLoc.split(Char_3);
			var LocDesc=OneLocArr[0];
			Pages=Pages+1;
			var Rows=Pages*20
			xlsheet.cells(Rows+2,3).Value=Title;
			xlsheet.cells(Rows+4,1).Value="姓名:";
			xlsheet.cells(Rows+4,2).Value=OnePatInfo[0]; //姓名
			xlsheet.cells(Rows+4,3).Value="年龄:";
			xlsheet.cells(Rows+4,4).Value=OnePatInfo[1]; //年龄 
			xlsheet.cells(Rows+4,5).Value="性别:";
			xlsheet.cells(Rows+4,6).Value=OnePatInfo[2]; //性别
			xlsheet.cells(Rows+4,7).Value="登记号:";
			xlsheet.cells(Rows+4,8).Value=OnePatInfo[3]; //登记号
			xlsheet.cells(Rows+5,1).Value="就诊科室:";
			xlsheet.cells(Rows+5,2).Value=OnePatInfo[4]; //就诊科室
			DrawLine(Rows+5,9,xlsheet);
			xlsheet.cells(Rows+5,4).Value=OnePatInfo[5];
			xlsheet.cells(Rows+6,1).Value="医嘱名称";
			xlsheet.cells(Rows+6,7).Value="数量";
			xlsheet.cells(Rows+6,8).Value="金额";
			//parseFloat
			var Char_4=String.fromCharCode(4);
			var ItemDesc=OneLocArr[1].split(Char_4);
			var TotalPrice=0;
			var m=ItemDesc.length;
			for (var n=0;n<m;n++)
			{
				ItemDetail=ItemDesc[n];
				ItemDetail=ItemDetail.split("^");
				xlsheet.cells(Rows+7+n,1).Value=ItemDetail[0]; //检验项目
				xlsheet.cells(Rows+7+n,7).Value="1"; //送检标本
				TotalPrice=(TotalPrice)+parseFloat(ItemDetail[1]);
				xlsheet.cells(Rows+7+n,8).Value=ItemDetail[1]+" 元"; //金额
			}
			
			TotalPrice=(parseInt(TotalPrice*100+0.5))/100 //四舍五入
			//alert((parseInt(24.499999*100))/100)
			xlsheet.cells(Rows+17,1).Value="金额:  "+TotalPrice+" 元";
			xlsheet.cells(Rows+17,4).Value="接收科室:"+LocDesc; 
			xlsheet.cells(Rows+18,1).Value="检查号:";
			xlsheet.cells(Rows+18,4).Value="医师签字:";
			xlsheet.cells(Rows+16,1).Value="申请日期:"+OnePatInfo[6]; //单位
			
			DrawLine(Rows+18,9,xlsheet);
			xlsheet.cells(Rows+19,1).Value="备注:本单所列价格中仅为常规检查项目费用,未包括所需的采血容器,操作费及补充材料";
			xlsheet.cells(Rows+20,1).Value="等费用,本单据不具有证明功能";
			
		}
		
	}		
	xlsheet.printout;
	//xlsheet.saveas("d:\\aa.xls")
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
}
function PrintRisRequestOld(Type)
{    

	alert(Type)
	var Data=GetSelectId("TAdmId^TDeitFlag^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");
	var Instring=""
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){
		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			if (Instring=="")
			{
				Instring=FData[2];
			}
			else
			{Instring=Instring+"^"+FData[2];}
			
			
		}
		
	}
	alert(Instring)
	PrintRisRequestApp(Instring,"Ris",Type);	
}

function PrintOtherRequest()
{
	var Data=GetSelectId("TAdmId^TDeitFlag^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");
	var Instring=""
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){
		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			if (Instring=="")
			{
				Instring=FData[2];
			}
			else
			{Instring=Instring+"^"+FData[2];}
			
			
		}
		
	}
	PrintRisRequestApp(Instring,"Other");	
}

function PrintRisRequestApp(Instring,Type,BDFlag)
{  	
    alert(Instring+"$$"+Type+"$$"+BDFlag)
	var targetFrame=GetCtlValueById("txtTargetFrame");
	
	var obj;
	/*
	var OneSpecNo=parent.frames["DHCPEIAdmItemStatusDetail"].GetOneOrdItem();
	var Info=OneSpecNo.split("^");

	var OrdItemID=Info[1];*/
	var OrdItemID=GetSelectOrdItem();
	alert(OrdItemID)
	var Ins=document.getElementById('GetLisRequestInfoBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,Instring,OrdItemID,Type,BDFlag);
	if (value=="")
	{
		alert("没有需要打印的单据");
		return;
	}
	alert("value:"+value)
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPELisRequest.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	alert("Excel.Application")
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	xlsheet.Columns(4).NumberFormatLocal="@";
	xlsheet.Columns(8).NumberFormatLocal="@";
	xlsheet.Columns(7).NumberFormatLocal="@";
	xlsheet.Columns(2).NumberFormatLocal="@";
	var Pages=-1;
	var Char_0=String.fromCharCode(5);
	var TotalPerson=value.split(Char_0);
	var i=TotalPerson.length;
	alert("i:"+i)
	var Title=xlsheet.cells(Rows+2,3)
	
	if (Type=="Ris")
	{
		Title=Title+"检查申请单"
	}
	else
	{   
		Title=Title+"材料申请单"
	}
		alert("Title:"+Title)
	for (j=0;j<i;j++)
	{
		var Char_1=String.fromCharCode(1);
		var OneStr=TotalPerson[j];
		var OneArr=OneStr.split(Char_1);
		var OnePatInfo=OneArr[0];
		var OnePatInfo=OnePatInfo.split("^");
		var RecLoc=OneArr[1];
		var Char_2=String.fromCharCode(2);
		var RecLocArr=RecLoc.split(Char_2);
		var k=RecLocArr.length;
	
		for (l=0;l<k;l++)
		{ 
			var OneLoc=RecLocArr[l];
			var Char_3=String.fromCharCode(3);
			var OneLocArr=OneLoc.split(Char_3);
			var LocDesc=OneLocArr[0];
			Pages=Pages+1;
			var Rows=Pages*20
			xlsheet.cells(Rows+2,1).Value=OnePatInfo[7]; //顺序号  Add 209-02-22
			xlsheet.cells(Rows+2,3).Value=Title;
			xlsheet.cells(Rows+4,1).Value="姓名:";
			xlsheet.cells(Rows+4,2).Value=OnePatInfo[0]; //姓名
			xlsheet.cells(Rows+4,3).Value="年龄:";
			xlsheet.cells(Rows+4,4).Value=OnePatInfo[1]; //年龄 
			xlsheet.cells(Rows+4,5).Value="性别:";
			xlsheet.cells(Rows+4,6).Value=OnePatInfo[2]; //性别
			xlsheet.cells(Rows+4,7).Value="登记号:";
			xlsheet.cells(Rows+4,8).Value=OnePatInfo[3]; //登记号
			xlsheet.cells(Rows+5,1).Value="就诊科室:";
			xlsheet.cells(Rows+5,2).Value=OnePatInfo[4]; //就诊科室
			DrawLine(Rows+5,9,xlsheet);
			xlsheet.cells(Rows+5,4).Value=OnePatInfo[5];
			xlsheet.cells(Rows+6,1).Value="医嘱名称";
			xlsheet.cells(Rows+6,7).Value="数量";
			xlsheet.cells(Rows+6,8).Value="金额";
			//parseFloat
			var Char_4=String.fromCharCode(4);
			var ItemDesc=OneLocArr[1].split(Char_4);
			var TotalPrice=0;
			var m=ItemDesc.length;
			for (var n=0;n<m;n++)
			{
				ItemDetail=ItemDesc[n];
				ItemDetail=ItemDetail.split("^");
				xlsheet.cells(Rows+7+n,1).Value=ItemDetail[0]; //检验项目
				xlsheet.cells(Rows+7+n,7).Value="1"; //送检标本
				TotalPrice=(TotalPrice)+parseFloat(ItemDetail[1]);
				xlsheet.cells(Rows+7+n,8).Value=ItemDetail[1]+" 元"; //金额
			}
			
			TotalPrice=(parseInt(TotalPrice*100+0.5))/100 //四舍五入
			//alert((parseInt(24.499999*100))/100)
			if (Type=="Ris")
			{
				xlsheet.cells(Rows+17,1).Value="金额:  "+TotalPrice+" 元";
				xlsheet.cells(Rows+17,4).Value="接收科室:"+LocDesc; 
				xlsheet.cells(Rows+18,1).Value="检查号:";
				xlsheet.cells(Rows+18,4).Value="医师签字:";
				xlsheet.cells(Rows+16,1).Value="申请日期:"+OnePatInfo[6]; //单位
			}
			
			else
			{   
				xlsheet.cells(Rows+18,1).Value="金额:  "+TotalPrice+" 元";
				xlsheet.cells(Rows+18,4).Value="接收科室:"+LocDesc; 
				//xlsheet.cells(Rows+18,1).Value="检查号:"
				//xlsheet.cells(Rows+18,4).Value="医师签字:"
				xlsheet.cells(Rows+17,1).Value="申请日期:"+OnePatInfo[6]; //单位
			}
			DrawLine(Rows+18,9,xlsheet);
			xlsheet.cells(Rows+19,1).Value="备注:本单所列价格中仅为常规检查项目费用,未包括所需的采血容器,操作费及补充材料";
			xlsheet.cells(Rows+20,1).Value="等费用,本单据不具有证明功能";
			
		}
	}			
	xlsheet.printout;
	//xlsheet.saveas("d:\\aa.xls")
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
}



function DrawLine(Row,Col,xlsheet)
{
	//var Range=xlsheet.Cells(Row,1);
	var Range=xlsheet.Range(xlsheet.Cells(Row,1),xlsheet.Cells(Row,9));
	Range.Borders(9).LineStyle = 3;
	Range.Borders(9).Weight = 2;
	Range.Borders(9).ColorIndex = -4105;
}
///打印补检单
function PrintBJ()
{
	var Data=GetSelectId("TAdmId^TDeitFlag^");
	if (""==Data) { return ; }
	var Datas=Data.split(";");
	var Instring=""
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){
		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			if (Instring=="")
			{
				Instring=FData[2];
			}
			else
			{Instring=Instring+"^"+FData[2];}
			
			
		}
		
	}
	PrintBJApp(Instring,"PrintBJ");	
}
function PrintBJApp(Instring,Type)
{
	var targetFrame=GetCtlValueById("txtTargetFrame");
	if (Type=="PrintBJ")
	{
		var Title="中国医科大学附属第一医院补检单"
	}
	else
	{
		var Title="中国医科大学附属第一医院材料申请单"
	}
	var obj;
	var OneSpecNo=parent.frames["DHCPEIAdmItemStatusDetail"].GetOneOrdItem();
	var Info=OneSpecNo.split("^");
	var OrdItemID=Info[1];
	var Ins=document.getElementById('GetLisRequestInfoBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,Instring,OrdItemID,Type);
	if (value=="") return;
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPELisRequest.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	xlsheet.Columns(4).NumberFormatLocal="@";
	xlsheet.Columns(8).NumberFormatLocal="@";
	xlsheet.Columns(7).NumberFormatLocal="@";
	xlsheet.Columns(2).NumberFormatLocal="@";
	var Pages=-1;
	var Char_0=String.fromCharCode(0);
	var TotalPerson=value.split(Char_0);
	var i=TotalPerson.length;
	for (j=0;j<i;j++)
	{
		var Char_1=String.fromCharCode(1);
		var OneStr=TotalPerson[j];
		var OneArr=OneStr.split(Char_1);
		var OnePatInfo=OneArr[0];
		var OnePatInfo=OnePatInfo.split("^");
		var OneItemInfo=OneArr[1];
		var Char_2=String.fromCharCode(2);
		var OneItemInfo=OneItemInfo.split(Char_2);
		var k=OneItemInfo.length;
		Pages=Pages+1;
		var Rows=Pages*20
		xlsheet.cells(Rows+1,3).Value=Title;
		xlsheet.cells(Rows+3,1).Value="姓名:";
		xlsheet.cells(Rows+3,2).Value=OnePatInfo[0]; //姓名
		xlsheet.cells(Rows+3,3).Value="年龄:";
		xlsheet.cells(Rows+3,4).Value=OnePatInfo[1]; //年龄 
		xlsheet.cells(Rows+3,5).Value="性别:";
		xlsheet.cells(Rows+3,6).Value=OnePatInfo[2]; //性别
		xlsheet.cells(Rows+3,7).Value="登记号:";
		xlsheet.cells(Rows+3,8).Value=OnePatInfo[3]; //登记号
		xlsheet.cells(Rows+4,1).Value="就诊科室:";
		xlsheet.cells(Rows+4,2).Value=OnePatInfo[4]; //就诊科室
		DrawLine(Rows+4,9,xlsheet);
		xlsheet.cells(Rows+4,4).Value=OnePatInfo[5];
		xlsheet.cells(Rows+5,1).Value="项目名称";
		xlsheet.cells(Rows+5,8).Value="标本号";
		xlsheet.cells(Rows+5,9).Value="金额";
		var TotalPrice=0;
		for (var n=0;n<k;n++)
			{
				ItemDetail=OneItemInfo[n];
				ItemDetail=ItemDetail.split("^");
				xlsheet.cells(Rows+6+n,1).Value=ItemDetail[0]; //检验项目
				xlsheet.cells(Rows+6+n,8).Value=ItemDetail[1]; //标本号
				if (ItemDetail[2]=="") ItemDetail[2]=0
				TotalPrice=(TotalPrice)+parseFloat(ItemDetail[2]);
				xlsheet.cells(Rows+6+n,9).Value=ItemDetail[2]+" 元"; //金额
			}
			TotalPrice=(parseInt(TotalPrice*100))/100
			xlsheet.cells(Rows+19,1).Value="打印日期:"+OnePatInfo[6]; //单位
			xlsheet.cells(Rows+19,1).Value="金额:  "+TotalPrice+" 元";
			
			DrawLine(Rows+19,9,xlsheet);
			//xlsheet.cells(Rows+19,1).Value="备注:本单所列价格中仅为常规检查项目费用,未包括所需的采血容器?操作费及补充材料";
			xlsheet.cells(Rows+20,1).Value="备注:请于  天后来检查,谢谢合作!";
		
	}		
	xlsheet.printout;
	//xlsheet.saveas("d:\\aa.xls")
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
}

function printLabEpisodeNo()
{ 
	var Data=GetSelectId("TAdmId^TDeitFlag^");

	if (""==Data) { return ; }
	var Datas=Data.split(";");	
	
	var Instring=""
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){
		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			if (Instring=="")
			{
				Instring=FData[2];
			}
			else
			{Instring=Instring+"^"+FData[2];}

		}
		
	}
			
	PrintLabEpisodeApp(Instring);
	
}

function PrintLabEpisodeApp(Instring)
{   
    var targetFrame=GetCtlValueById("txtTargetFrame");
	var obj;
	//var OneSpecNo=parent.frames["DHCPEIAdmItemStatusDetail"].GetOneOrdItem();
	//var Info=OneSpecNo.split("^");
	//var OrdItemID=Info[1];
	var Ins=document.getElementById('GetlabInfolist');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,Instring,"");
	if (value=="") return;
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPELabEpisodeNolis.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1")
    
 

 	var labinfo=value.split("!")
    //var info=infoZ.split("&&")
	//var PatInfo=info[0]
	//var labinfo=info[1]
	

	  

	k=2 
    var tmp=0  
	for(i=0;i<(labinfo.length);i++)
	{    
	    var row=labinfo[i]
		//alert(row)
	    var tempcol=row.split("^");
	     	
	    //var patinfo=PatInfo.split("^")
	
	    var pno=tempcol[1] 
	    var name=tempcol[0]  
     
		
		//if((itemrowid != tmp)&&(tmp != 0))//本次组rowid不等于上次组rowid并且不是第一组时则行加2
		if((pno!= tmp))
		{   count=1
			k=k+2
			xlsheet.cells(k-2,1)="登记号:"+pno
			xlsheet.cells(k-1,1)="姓名:"+name
			xlsheet.cells(k,1)="标本号"
			xlsheet.cells(k,2)="医嘱名称" 
			xlsheet.cells(k,3)="接受科室" 
			xlsheet.cells(k,4)="应收金额"                              
		}
	
		xlsheet.Rows(k+1).insert()         //插入一行
		
		//循环列
		for(j=2;j<=tempcol.length;j++)
			{
				xlsheet.cells(k+1,j-1).Value=tempcol[j]	
			}
			 
	   tmp=pno   //将本次组rowid赋给一个临时变量?待与下次取得的组rowid比较
	   k=k+2
	  
	}
///删除最后的空行
xlsheet.Rows(k+1).Delete;
	
	xlsheet.printout;
	//xlsheet.saveas("d:\\aa.xls")
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
}
	
function PrintDriverCard()
{  	
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEDriverCard.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	xlsheet.CheckBox1.Value = True
    xlsheet.CheckBox2.Value = True
    xlsheet.CheckBox3.Value = True
	xlsheet.CheckBox4.Value = True
	xlsheet.printout;
	//xlsheet.saveas("d:\\aa.xls")
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
}	