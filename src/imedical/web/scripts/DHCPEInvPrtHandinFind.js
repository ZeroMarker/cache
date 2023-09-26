    var Guser;
	var GuserCode;
	var GuserName;
	
function BodyLoadHandler() {
	Guser=session['LOGON.USERID']
	GuserCode=session["LOGON.USERCODE"];
	GuserName=session['LOGON.USERNAME']
	InitialCol();
	var AuditFlag=GetCtlValueById("AuditFlagValue");
	SetCtlValueById("AuditFlag",AuditFlag,0);
	Muilt_LookUp("Cashier")                       
    var obj=document.getElementById('BPrint');   
    if (obj){obj.onclick =BPrint_click;} 
	 
	 obj=document.getElementById("NoDayHand");
	if (obj) { obj.onclick=DateType_click; }
	
	obj=document.getElementById("CashierTotal");
	if (obj) { obj.onclick=DateType_click; }

}

function DateType_click() {
	
	var src=window.event.srcElement;
	obj=document.getElementById("NoDayHand");
	if (obj && obj.id!=src.id) { obj.checked=false; }
	obj=document.getElementById("CashierTotal");
	if (obj && obj.id!=src.id) { obj.checked=false; }

}

function InitialCol()
{   
	var objtbl=document.getElementById("tDHCPEInvPrtHandinFind");
   var catnum=20;
	
	for (var i=catnum+1;i<=20;i++){
		HiddenTblColumn(objtbl,"TPayMode"+i,i);
	}
	return;
	
	///unescape
	var obj=document.getElementById("uName");
	if (obj){
		////alert(obj.value);
		obj.value=unescape(obj.value);
	}
	var catobj=document.getElementById("getOPCAT");
	if (catobj) {var encmeth=catobj.value} else {var encmeth=''};
	var catinfo=cspRunServerMethod(encmeth);
	var objtbl=document.getElementById("tDHCOPFin_ItemColQuery");
	var Rows=objtbl.rows.length;
	var firstRow=objtbl.rows[0];
	///alert(firstRow);
	var RowItems=firstRow.all;
	///alert(catinfo);
	var cattmp =catinfo.split("^");
	var catnum=cattmp.length;
	for (var i=1;i<=catnum;i++)
	{
		var ColName="cat"+i;
		for (var j=0;j<RowItems.length;j++) 
		{
			if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH'))
			{
				RowItems[j].innerHTML=cattmp[i-1];
			}
		}
	}
	
}

function HiddenTblColumn(tbl,ColName,ColIdx){
	var row=tbl.rows.length;
	var firstRow=tbl.rows[0];
	var RowItems=firstRow.all;
	
	for (var j=0;j<RowItems.length;j++) {
		if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
			RowItems[j].style.display="none";
		} else {
		}
	}

	row=row-1;
	for (var j=1;j<row+1;j++) {
		var sLable=document.getElementById(ColName+'z'+j);
		var sTD=sLable.parentElement;
		sTD.style.display="none";
	}	
	var lastDetail=document.getElementById('TReportDetailz'+row);
	if (lastDetail) lastDetail.style.display="none";
}
function BPrint_click()
{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPECashierFeeTotal.xls';

	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
		
	var obj=document.getElementById('BeginDate')
	if (obj) var iBeginDate=obj.value;
	var obj=document.getElementById('EndDate')
	if (obj) var iEndDate=obj.value;
	  
	
	 
	 xlsheet.Range(xlsheet.Cells(2,2),xlsheet.Cells(2,10)).mergecells=true;
	 xlsheet.cells(2,2)= iBeginDate+"至"+iEndDate

	//xlsheet.cells(2,2)=iBeginDate; 
 	//xlsheet.cells(3,2)=iEndDate; 
	var tbObj = document.getElementById('tDHCPEInvPrtHandinFind');
 	var rowObj = tbObj.getElementsByTagName("tr");
	if(tbObj)
   	{
		var k=4
		var str = "";
		var MaxCol=0;
		//rowNumber行序号,columnNumber列序号
		for(var rowNumber = 0;  rowNumber < rowObj.length;rowNumber ++ )
		{
			var col=1;
			for(var columnNumber = 1; columnNumber < rowObj[rowNumber].cells.length;columnNumber ++ )
			{
				var Title=rowObj[0].cells[columnNumber].innerText
				if ((Title==" ")||(Title==""))
				{
					continue;
				}
				str = rowObj[rowNumber].cells[columnNumber].innerText;
				//alert((k+rowNumber)+"^"+col+"^"+str)
				xlsheet.cells(k+rowNumber,col)=str
				col=col+1
			}
			if (col>MaxCol) MaxCol=col;
		}
		xlsheet.Range( xlsheet.Cells(k,1),xlsheet.Cells(k+rowNumber-1,MaxCol-1)).Borders.LineStyle   = 1

	}
	xlsheet.printout;
	xlApp.Visible = false;
	xlApp.UserControl = true;
	
}
function GetUserID(value)
{      
	var Data=value.split("^");
	var name=document.getElementById('UserID')
	if (name) name.value=Data[1];
	var name=document.getElementById('Cashier')
	if (name) name.value=Data[0];
}
document.body.onload = BodyLoadHandler;