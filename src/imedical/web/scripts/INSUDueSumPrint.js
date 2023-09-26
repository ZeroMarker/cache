function BodyLoadHandler() 
{
		getpath();
	var obj=document.getElementById("prtDueSum");
	if (obj){ obj.onclick=PrintDueSum;}
	var Typeobj=document.getElementById("BackType")
	if (Typeobj){Typeobj.onclick=ChangeBackType;}
	var btnBillobj=document.getElementById("btnBill")
	if (btnBillobj){btnBillobj.onclick=Bill}
	var btnMonthBillobj=document.getElementById("btnMonthBill")
	if (btnMonthBillobj){btnMonthBillobj.onclick=MonthBill}
	var InPutobj=document.getElementById("btnInPut")
	if (InPutobj) { InPutobj.onclick=BackFileInPut;}
    var YBInPutobj=document.getElementById("YBInPut")
	if (YBInPutobj){YBInPutobj.onclick=FileInPut}
	iniDefaultDate()
}
function getpath() {
	var getpath=document.getElementById('getpath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	path=cspRunServerMethod(encmeth,'','')
	//alert(path)
	
	}
function BackFileInPut(){
	var Typeobj=document.getElementById("BackType")
	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLBJEFacade"); 
	if (Typeobj.checked==true){
		var rtnStr=DHCINSUBLL.InsuBackFileInput();} //如果是首信回款调用首信回款界面
	else{
    var rtnStr=DHCINSUBLL.InsuFileInput();} //金算盘回款
}
function iniDefaultDate(){
	var BackTypeobj=document.getElementById('BackType');
	if (BackTypeobj.checked==true){var BackType='1'} else{var  BackType='0'}
	var BillDateobj=document.getElementById('GetDefaultDate');
	if (BillDateobj){var encmeth=BillDateobj.value} else{var encmeth=''};
	var BillDate=cspRunServerMethod(encmeth,BackType)
	document.getElementById('BillDate').value=BillDate
	}
//医保上传导入
function FileInPut(){
	
	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.clsBasBILLBJDFacade"); 
	var rtnStr=DHCINSUBLL.InsuFileInput();
}

function ChangeBackType(){
	var Typeobj=document.getElementById("BackType")
	var TypeTextobj=document.getElementById("BackTypeText")
    
    if(Typeobj.checked==true)
    {
    TypeTextobj.value="首信回款"
    }
    else 
    {
    TypeTextobj.value="金算盘回款"
    iniDefaultDate()
    } //是首信回款的时候,日结按钮不可用
}
function PrintDueSum() {
	var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j 
    var Template
   //path="http://10.4.11.57/TrakCare/app/trak/med/Results/Templates/"
    Template=path+"INSU_PRTDueSum.xls"
    
    //alert(Template)
    xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet ; 
	var objtbl=document.getElementById('tINSUDueSumPrint');
	var str=objtbl.rows(1).cells(1).innerText.split("-")
	xlsheet.cells(3,1)=str[0]
	str=""
    for (i=2;i<objtbl.rows.length;i++)
    {
	    
	    for (j=1;j<objtbl.rows(1).cells.length-1;j++)
	    {
		    var TypeTextobj=document.getElementById("BackTypeText")
		    xlsheet.cells(2,6)=TypeTextobj.value
		    str=objtbl.rows(i).cells(1).innerText.split("-")
		    if (str==""){
			xlsheet.cells(3+i,1)=""
		    xlsheet.cells(3+i,2)=""
		    }
		    else{
		    xlsheet.cells(3+i,1)=str[1];
		    xlsheet.cells(3+i,2)=str[2];}
		    xlsheet.cells(3+i,j+2)=objtbl.rows(i).cells(j+1).innerText;

	    }
	    for (k=1;k<objtbl.rows(1).cells.length+1;k++)
	    {
		   xlsheet.Cells(3+i,k).Borders(9).LineStyle = 1;
           xlsheet.Cells(3+i,k).Borders(7).LineStyle = 1;
           xlsheet.Cells(3+i,k).Borders(10).LineStyle = 1;
           xlsheet.Cells(3+i,k).Borders(8).LineStyle = 1;
	    }
	}
		xlApp.Visible=true;
	    xlsheet.PrintPreview();	    
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet=null ;

}

//LOU 2008-12-22

function Bill(){
	//DailyCount
	var BillDate=document.getElementById('BillDate').value;
	var BegDate=document.getElementById('BegDate').value;
	var EndDate=document.getElementById('EndDate').value;
	var BackTypeobj=document.getElementById('BackType');
	if (BackTypeobj.checked==true){var BackType='1'} else{var  BackType='0'}
	var s=confirm("是否进行做账?")
	if (s==true){
		var BillFlagobj=document.getElementById('CanBillOrNot');//根据日期判断是否已经做过账
		if (BillFlagobj) {var encmeth=BillFlagobj.value} else {var encmeth=''};
		var BillFlag=cspRunServerMethod(encmeth,BegDate,BackType)
		if (BillFlag=="F") {alert("请将起始日期置于上次做账日期之后!!");return } 
	    var DailyCountobj=document.getElementById('DailyCount');
	    if (DailyCountobj) {var encmeth=DailyCountobj.value} else {var encmeth=''};
	    var DailyCount=cspRunServerMethod(encmeth,BegDate,EndDate,BackType) //做账存到INSU_DUEDAILY表
	    if (DailyCount!=""){alert("完成!");}
	    //alert(DailyCount)
	    //var DailyCount='341994'
	    //var UpDateBillFlag=document.getElementById('UpDateBillFlag');
	    //if (UpDateBillFlag) {var encmeth=UpDateBillFlag.value} else {var encmeth=''};
	    //var Flag=cspRunServerMethod(encmeth,DailyCount) //更新三个数据表的做账日期字段
	    //if (Flag=='0'){alert("完成!");}
	    }
	}
	
function MonthBill(){
	var s=confirm("是否进行月结,请保证开始日期和起始日期的正确性!!!")
	if (s==true){

	var BegDate=document.getElementById('BegDate').value;
	var EndDate=document.getElementById('EndDate').value;
	var BackTypeobj=document.getElementById('BackType');
	if (BackTypeobj.checked==true){var BackType='1'} else{var  BackType='0'}

	var MonthBillFlagobj=document.getElementById('CanMonthBillorNot');//根据日期判断是否已经做过账
	if (MonthBillFlagobj) {var encmeth=MonthBillFlagobj.value} else {var encmeth=''};
	var MonthBillFlag=cspRunServerMethod(encmeth,BegDate,EndDate,BackType)
	if (MonthBillFlag=="F"){alert("不能做月结!!"); return}
    var MonthCountObj=document.getElementById('MonthCount');
    if (MonthCountObj) {var encmeth=MonthCountObj.value} else {var encmeth=''};
    var MonthCount=cspRunServerMethod(encmeth,BegDate,EndDate,BackType)
    if (MonthCount=="0"){alert("月结成功!!")}
    else {alert("月结失败!!")}
	//alert("11")
	}
	}
document.body.onload = BodyLoadHandler;