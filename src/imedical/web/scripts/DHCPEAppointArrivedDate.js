/// 名称	DHCPEAppointArrivedDate.js
/// 创建时间		
/// 创建人		zl
/// 主要功能   设置团体?个人的预约到达时间的设置		
/// 对应表		
/// 最后修改时间	
/// 最后修改人	
/// 完成

function BodyLoadHandler() {

	var obj;
	
	//更新
	obj=document.getElementById("BOK");
	if (obj){ obj.onclick=Update_click; }
	
	obj=document.getElementById("BExport")          
	if (obj) { 
	obj.onclick=Export_click; }	  
      
	
}
function Cancel_click()
{
	window.close();
}

function Update_click() {
	var obj,ID,Type,Date,encmeth,Flag
	obj=document.getElementById('ID');
	if (obj) ID=obj.value;
	obj=document.getElementById('Type');
	if (obj) Type=obj.value;
	obj=document.getElementById('AppiontArrDate');
	if (obj) Date=obj.value;
	obj=document.getElementById('encmeth');
	if (obj) encmeth=obj.value
	if (Date=="")
	{
		alert(t["01"]);
		return;
	}
	Flag=cspRunServerMethod(encmeth,ID,Type,Date)
	if (Flag!=0)
	{
		alert(t["Err 01"]);
		return;
	}
	//if (opener)
	//{
	//	obj=opener.document.getElementById("AppiontArrDate");
	//	if (obj) obj.value=DelayDate;
	//}
	window.close();
}
function Export_click()
{  
    try{
		var obj;
		obj=document.getElementById("prnpath");
		if (obj && ""!=obj.value) {
			var prnpath=obj.value;
			var Templatefilepath=prnpath+'DHCPEAppointArrDateStatistic.xls';
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
			var Ins=document.getElementById('GetStationWorkInfoBox');
		    	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
		    	
		    	var DataStr=cspRunServerMethod(encmeth,Num[j]);
		  
		    	if (""==DataStr) { return false; }
		
		     	var Data=DataStr.split("^")
		     	xlsheet.cells(k+j,1)=Data[0]
		     	xlsheet.cells(k+j,2)=Data[1] 
			    xlsheet.cells(k+j,3)=Data[2] 
			    xlsheet.cells(k+j,4)=Data[3] 
			xlsheet.Range( xlsheet.Cells(k+j,1),xlsheet.Cells(k+j,4)).Borders.LineStyle   = 1
			   
		} 
	
   		var SaveDir="d:\\科室工作量统计.xls";
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

