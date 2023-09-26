/////UDHCJFJudgeBankTradePay.js

function BodyLoadHandler()
{
	//ChooseTime()
	GetNowTime()
	//ChoosePayMode()
	var Exportobj=document.getElementById("Export")
	if(Exportobj){
		Exportobj.onclick=Export_Click
	}
	
	var Importobj=document.getElementById("Import")
	if(Importobj){
		Importobj.onclick=Import_Click
	}
	
	var PrintBtnobj=document.getElementById("PrintBtn")
	if(PrintBtnobj){
		PrintBtnobj.onclick=PrintBtn_Click
	}
}

function ChooseTime()
{
	//初始化结算类型
	var obj=document.getElementById("TimeFlag");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=TimeFlag_OnChange;
	}	
	var varItem = new Option("HIS交易时间","1");
    obj.options.add(varItem);
    var varItem = new Option("银行交易时间","2");
    obj.options.add(varItem);
    //var varItem = new Option("银行结账时间","3");
    //obj.options.add(varItem);
}

function TimeFlag_OnChange()
{
	var obj=document.getElementById("TimeFlag");
	var index=obj.options.selectedIndex
	obj.options[index].selected = true;
}

function ChoosePayMode()
{
	//初始化支付方式
	var obj=document.getElementById("PayMode");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=PayMode_OnChange;
	}	
	var varItem = new Option("软POS","12");
    obj.options.add(varItem);
    var varItem = new Option("银医卡","13");
    obj.options.add(varItem);
}

function PayMode_OnChange()
{
	var obj=document.getElementById("PayMode");
	var index=obj.options.selectedIndex
	obj.options[index].selected = true;
}

function GetNowTime()
{
	var NowTimeobj=document.getElementById("GetNowTime");
		if (NowTimeobj){
			var encmeth=NowTimeobj.value;
			var NowTimeStr=cspRunServerMethod(encmeth)
		}
		if(NowTimeStr!=""){
			var StTimeobj=document.getElementById("StTime");
			var EndTimeobj=document.getElementById("EndTime");
			StTimeobj.value=NowTimeStr.split("^")[0]
			EndTimeobj.value=NowTimeStr.split("^")[1]
		}
}

function PrintBtn_Click()
{
	var xlApp,obook,osheet,xlsheet,xlBook,i,j
	var Template
	var encmeth=""
	var obj=document.getElementById('getpath');
	if (obj) encmeth=obj.value;
	if (encmeth) var TemplatePath=cspRunServerMethod(encmeth);
	var Template=TemplatePath+"UDHCJFJudgeBankTradePay.xls" 
	//var Template="d:\\JF_OPInvprtSearch.xls" 

    var job=document.getElementById('Tjobz'+1);
	var Tjob=job.innerText;
	var GetInvprtNum=document.getElementById('GetInvprtNum');
	if (GetInvprtNum) {var encmeth=GetInvprtNum.value} else {var encmeth=''};
	var GetInvprtNum=cspRunServerMethod(encmeth,session['LOGON.USERID'],Tjob)
	if(GetInvprtNum==0){
		alert("没有数据,不能打印!")
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet  
    //xlApp.visible=true
	for (i=1;i<=GetInvprtNum;i++)
	{
		var GetInvDetail=document.getElementById('GetInvDetail');
     	if (GetInvDetail) {var encmeth=GetInvDetail.value} else {var encmeth=''};
	    var GetInvDetail=cspRunServerMethod(encmeth,session['LOGON.USERID'],Tjob,i)
		var GetInvDetail=GetInvDetail.split("^");
		var ColLength=GetInvDetail.length;
		var ColLength=16
		for(j=0;j<ColLength;j++)
		{
			xlsheet.cells(4+i,j+1).value=GetInvDetail[j];
		}
	}
	var Colnum=i
    xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,ColLength-1)).MergeCells=true
	xlsheet.Cells(1,1)="门诊软POS对账差错明细"

    var obj=document.getElementById("StDate");
	if (obj) var StDate=obj.value;
	   //StDate=StDate.split("/");
	   //StDate=StDate[2]+"-"+StDate[1]+"-"+StDate[0]
	var obj=document.getElementById("EndDate");
	if (obj) var EndDate=obj.value;
	   //EndDate=EndDate.split("/");
	   //EndDate=EndDate[2]+"-"+EndDate[1]+"-"+EndDate[0]
	var date=new Date();
    var TodayDate=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()
    TodayDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",TodayDate)
    TodayDate=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",TodayDate)
    var TodayTime=date.getHours()+":"+date.getMinutes()+":"+date.getSeconds()
    var ColNum=parseInt(ColLength/3)
	xlsheet.cells(3,2).value="查询日期:"+StDate+" -- "+EndDate
	xlsheet.cells(3,6).value="打印日期:"+TodayDate+" "+TodayTime
	xlsheet.cells(3,11).value="打印人:"+session['LOGON.USERNAME']
	AddGrid(xlsheet,7,2,5+Colnum,ColLength+1,5,1)

    		//alert("文件将保存在您的C盘根目录下");
	xlsheet.printout
		//xlBook.SaveAs("C:\\门诊POS支付日报表"+h+m+s+".xls");   //lgl+
	    
	    
	xlBook.Close (savechanges=false);
	    
	xlApp=null;
	xlsheet.Quit;
	xlsheet=null;
    /*xlsheet.printout;
	xlsheet.visable=true;
    xlsheet.PrintPreview();
	xlBook.Close (savechanges=true);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null*/

}

function Export_Click()
{
	var xlApp,obook,osheet,xlsheet,xlBook,i,j
	var Template
	var encmeth=""
	var obj=document.getElementById('getpath');
	if (obj) encmeth=obj.value;
	if (encmeth) var TemplatePath=cspRunServerMethod(encmeth);
	var Template=TemplatePath+"UDHCJFJudgeBankTradePay.xls" 
	//var Template="d:\\JF_OPInvprtSearch.xls" 

    var job=document.getElementById('Tjobz'+1);
	var Tjob=job.innerText;
	var GetInvprtNum=document.getElementById('GetInvprtNum');
	if (GetInvprtNum) {var encmeth=GetInvprtNum.value} else {var encmeth=''};
	var GetInvprtNum=cspRunServerMethod(encmeth,session['LOGON.USERID'],Tjob)
	if(GetInvprtNum==0){
		alert("没有数据,不能打印!")
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet  
    //xlApp.visible=true
	for (i=1;i<=GetInvprtNum;i++)
	{
		var GetInvDetail=document.getElementById('GetInvDetail');
     	if (GetInvDetail) {var encmeth=GetInvDetail.value} else {var encmeth=''};
	    var GetInvDetail=cspRunServerMethod(encmeth,session['LOGON.USERID'],Tjob,i)
		var GetInvDetail=GetInvDetail.split("^");
		var ColLength=GetInvDetail.length;
		var ColLength=16
		for(j=0;j<ColLength;j++)
		{
			xlsheet.cells(4+i,j+1).value=GetInvDetail[j];
		}
	}
	var Colnum=i
    xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,ColLength-1)).MergeCells=true
	xlsheet.Cells(1,1)="门诊软POS对账差错明细"
    
    var obj=document.getElementById("StDate");
	if (obj) var StDate=obj.value;
	   //StDate=StDate.split("/");
	   //StDate=StDate[2]+"-"+StDate[1]+"-"+StDate[0]
	var obj=document.getElementById("EndDate");
	if (obj) var EndDate=obj.value;
	   //EndDate=EndDate.split("/");
	   //EndDate=EndDate[2]+"-"+EndDate[1]+"-"+EndDate[0]
	var date=new Date();
    var TodayDate=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate()
    TodayDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",TodayDate)
    TodayDate=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",TodayDate)
    var TodayTime=date.getHours()+":"+date.getMinutes()+":"+date.getSeconds()
    var ColNum=parseInt(ColLength/3)
	xlsheet.cells(3,2).value="查询日期:"+StDate+" -- "+EndDate
	xlsheet.cells(3,6).value="打印日期:"+TodayDate+" "+TodayTime
	xlsheet.cells(3,11).value="打印人:"+session['LOGON.USERNAME']
	AddGrid(xlsheet,7,2,5+Colnum,ColLength+1,5,1)

    //xlsheet.printout;
	//xlsheet.visable=true;
    //xlsheet.PrintPreview();
	xlBook.Close (savechanges=true);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null

}

function AddGrid(objSheet,fRow,fCol,tRow,tCol,xlsTop,xlsLeft)
{        
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
}

function Import_Click()
{
	var GetRecTXTFromFTPobj=document.getElementById('GetRecTXTFromFTP');
	if (GetRecTXTFromFTPobj) {var encmeth=GetRecTXTFromFTPobj.value} else {var encmeth=''};
	var Flag=cspRunServerMethod(encmeth)
	if(Flag==0){
		alert("导入成功!")
	}else if(Flag=="-1"){
		alert("系统错误,请联系信息科!")
	}else if(Flag=="-2"){
		alert("对账文本不存在,请联系信息科!")
	}else if(Flag=="-3"){
		alert("文本已导入")
	}else{
		alert("导入部分成功,失败记录: "+Flag+" 条")
	}
}
document.body.onload=BodyLoadHandler;