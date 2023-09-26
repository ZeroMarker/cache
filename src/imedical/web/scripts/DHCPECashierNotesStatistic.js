/// 名称	DHCPECashierNotesStatistic.js
/// 体检收费票据打印  for 北京妇产

var TFORM="";
function BodyLoadHandler() {
	var obj;

	obj=document.getElementById("BExport")        
	if (obj) { obj.onclick=BExport_click; }	         
	iniForm();
	
}

function iniForm(){
	var obj
	return;
	obj=document.getElementById("DateFrom");
	if (obj){
		obj.value='t';
		DateBegin_lookupSelect();
	}
	
	obj=document.getElementById("DateTo");
	if (obj){
		obj.value='t';
		DateEnd_lookuphandler();
	}
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}


function BExport_click()
{   
    try{
		var obj;
		obj=document.getElementById("prnpath");
		if (obj && ""!=obj.value) {
			var prnpath=obj.value;
			var Templatefilepath=prnpath+'DHCPECashierNotesStatistic.xls';
		}else{
			alert("无效模板路径");
			return;
		}
		xlApp = new ActiveXObject("Excel.Application");  
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  
		xlsheet = xlBook.WorkSheets("Sheet1");  

		obj=document.getElementById('GetRowNum');
		 if (obj) {var encmeth=obj.value; } else {var encmeth=''; };
		 var NumStr=cspRunServerMethod(encmeth);
		 var Num=NumStr.split("^")
	
		k=3
		for (j=0;j<Num.length;j++)
		{  
			var Ins=document.getElementById('GetWorkInfoBox');
		    	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
		    	var DataStr=cspRunServerMethod(encmeth,Num[j]);
		  
		    	if (""==DataStr) { return false; }
		
		     	var Data=DataStr.split("^")
		     	xlsheet.cells(k+j,1)=Data[0]
		     	xlsheet.cells(k+j,2)=Data[1] 
			    xlsheet.cells(k+j,3)=Data[2] 
			    xlsheet.cells(k+j,4)=Data[3]
		     	xlsheet.cells(k+j,5)=Data[4] 
			    xlsheet.cells(k+j,6)=Data[5] 
			   xlsheet.Range( xlsheet.Cells(k+j,1),xlsheet.Cells(k+j,6)).Borders.LineStyle   = 1
			   
		} 
	
   		var SaveDir="d:\\体检收费票据统计.xls";
   		xlsheet.SaveAs(SaveDir);
   		xlApp.Visible = true;
   		xlApp.UserControl = true;  
   	}
	catch(e)
	{
		alert(e+"^"+e.message);
	}
}

document.body.onload = BodyLoadHandler;