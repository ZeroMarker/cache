function BodyLoadHandler() 
{
	var obj=document.getElementById("print");
	if (obj)
	{
		obj.onclick=Print_Click;
	}
}
function GetUserInfoByUserCode(value)
{	
	var str=value.split("^");
	var obj=document.getElementById("TUserCode");
	if (obj) obj.value=str[0]
	var obj=document.getElementById("TUserName");
	if (obj) obj.value=str[1]
	var obj=document.getElementById("Tjkdate");
	if (obj) obj.value=str[2]
	var obj=document.getElementById("Tlastremain");
	if (obj) obj.value=str[3]
	var obj=document.getElementById("Tycamt1");
	if (obj) obj.value=str[4]
	var obj=document.getElementById("Tycamt2");
	if (obj) obj.value=str[5]
	var obj=document.getElementById("Tcashsum");
	if (obj) obj.value=str[7]
	var obj=document.getElementById("Tcurremain");
	if (obj) obj.value=str[8]	
}
function Print_Click()
{
	PrintClickHandler();
	
}
function PrintClickHandler() 
{
	try{
		var encmeth=""
		var obj=document.getElementById('getpath');
		if (obj) encmeth=obj.value;
		if (encmeth) var TemplatePath=cspRunServerMethod(encmeth);
		var Template=TemplatePath+"UDHCJFOP9CashDaily.xls";
		alert(Template);
		var xlApp = new ActiveXObject("Excel.Application"); 
	    var xlBook = xlApp.Workbooks.Add(Template);
	    var xlsheet = xlBook.ActiveSheet;
		var obj=document.getElementById('Tjobz'+2)  //一个进程的
		if (obj) var job=obj.innerText;;
		var getnum=document.getElementById('getnum');
	    if (getnum) {var encmeth=getnum.value} else {var encmeth=''};
	    var num=cspRunServerMethod(encmeth,job)
        if (num==0) return;
        var xlsRow=4;
		var xlsCol=0;
        for (var i=1;i<=num;i++){
	        var getdata=document.getElementById('getdata');
	        if (getdata) {var encmeth=getdata.value} else {var encmeth=''};
	        var data=cspRunServerMethod(encmeth,job,i)
	        var str=data.split("^")
	        var len=str.length
	        for (var j=0;j<=len-1;j++){
		        
		        xlsheet.cells(xlsRow+i,xlsCol+j+1)=str[j];
		        }
	        
	        }
	    gridlist(xlsheet,xlsRow,xlsRow+i,1,j+1);
		xlsheet.printout; 
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;

	} catch(e){
			alert(e.message);
		};
		
}
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}

function UnloadHandler()
{	
	var myTMPGID=DHCWebD_GetObjValue("Tjob");
	if (myEncrypt!="")
	{
		var mytmp=cspRunServerMethod(myEncrypt, myTMPGID);
	}
	
}

document.body.onload = BodyLoadHandler;
