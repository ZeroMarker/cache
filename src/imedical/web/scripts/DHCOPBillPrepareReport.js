var path,rsStr
function BodyLoadHandler()
{
   var obj=document.getElementById("find");
   if (obj) obj.onclick=find_click;
   var obj=document.getElementById("print");
   if (obj) obj.onclick=print_click;
   var getpath=document.getElementById('getpath');
    if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	    path=cspRunServerMethod(encmeth,'','')
}
function find_click()
{
	var tmp = document.getElementById("date").value
	if(tmp=="") {
		alert("请选中查询日期!");
		return;
	}

	var obj=document.getElementById("getDetail");
	if(obj)
	{
		encmeth=obj.value
		var tmpDate=document.getElementById("date").value.split("/");
		var date=tmpDate[2]+"-"+tmpDate[1]+"-"+tmpDate[0]
		
	}
	else
	{
		encmeth=""
	}

	var rs=cspRunServerMethod(encmeth,date);
	
	rsStr=rs.split("^")
	if(rsStr.length>1)
	{
	   var obj1=document.getElementById("beforCardLesf");
	   var obj2=document.getElementById("getPreToday");
	   var obj3=document.getElementById("putPreToday");
	   var obj4=document.getElementById("cardFeeToday");
	   var obj5=document.getElementById("cardLeftToday");
	   var obj6=document.getElementById("noFootNum");
	   var obj7=document.getElementById("noFootCardGet");
	   var obj8=document.getElementById("noFootCardPut");
	   var obj9=document.getElementById("noFootCardLeft");
	   var obj10=document.getElementById("preAmountToday");
	   var obj11=document.getElementById("employeeTally");
	   var obj12=document.getElementById("stfcrTally");
	   
	   obj1.value=rsStr[0]
	   obj2.value=rsStr[1]
	   obj3.value=rsStr[2]
	   obj4.value=rsStr[3]
	   obj5.value=rsStr[4]
	   obj6.value=rsStr[5]
	   obj7.value=rsStr[6]
	   obj8.value=rsStr[7]
	   obj9.value=rsStr[8]
	   obj10.value=rsStr[9]
	   obj11.value=rsStr[10]
	   obj12.value=rsStr[11]
	   
	   
	}
}
function print_click()
{
	Template=path+"JF_PreDayReport.xls"
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
	
	xlsheet.cells(3,5)=document.getElementById("date").value
	
	
    xlsheet.cells(4,2)=rsStr[0]
	xlsheet.cells(4,4)=rsStr[1]
	xlsheet.cells(5,2)=rsStr[2]
	xlsheet.cells(5,4)=rsStr[3]
	xlsheet.cells(5,6)=rsStr[4]
	
	xlsheet.cells(7,2)=rsStr[5]
	
	xlsheet.cells(8,2)=rsStr[6]
	xlsheet.cells(8,4)=rsStr[7]
	xlsheet.cells(9,2)=rsStr[8]
	xlsheet.cells(10,2)=rsStr[9]
	xlsheet.cells(11,2)=rsStr[10]
	xlsheet.cells(11,4)=rsStr[11]
  
	
   xlApp.Visible=true
   xlsheet.PrintPreview();
   xlBook.Close (savechanges=false);
   xlApp.Quit();
   xlApp=null;
   xlsheet=null 

}
document.body.onload = BodyLoadHandler;