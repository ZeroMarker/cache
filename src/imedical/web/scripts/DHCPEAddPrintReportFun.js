
function printCover()
{
	//var VIPLevel=#(VIPLevel)#
	var VIPLevel=1
	var FileName='DHCPEReportCover.xls'
	var i=-6
	if (VIPLevel=="2"){
		FileName='DHCPEReportCoverBJK.xls'
		i=-21
	}
	alert(1)
	var Templatefilepath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath",FileName); 
	alert(Templatefilepath)	
	//var Templatefilepath=#server(web.DHCPE.Report.MonthStatistic.getpath())#+FileName;
	try
	{
		xlApp = new ActiveXObject("Excel.Application");  //固定
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
		xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
		
		/*
		xlsheet.cells(23,4)=vName;
		xlsheet.cells(23,7)=vSex;
		xlsheet.cells(24,4)=vAge;
		xlsheet.cells(24,7)=vTel;
		xlsheet.cells(25,4)=vRegno;
		xlsheet.cells(25,7)=vDate;
		//xlsheet.cells(27,4)=vMail;
		//xlsheet.cells(27,7)=vIDCard;
		xlsheet.cells(26,4)=vCompany;*/
		xlsheet.cells(42+i,4)=vName;
		xlsheet.cells(43+i,4)=vSex;
		//xlsheet.cells(45,3)=vSortNo;
		xlsheet.cells(41+i,4)=+vRegno;
		xlsheet.cells(44+i,4)=vAge;
		//xlsheet.cells(27,7)=vIDCard;
		var Arr=vCompany.split("(")
		if (Arr.length>1){
			var Depart=Arr[1].split(")")[0];
			vCompany=Arr[0];
		}else{
			var Depart=""
		}
		
		if (VIPLevel=="2"){  //vip
			xlsheet.cells(45+i,4)=vDate
			xlsheet.cells(45+i+1,4)=vCompany;
			xlsheet.cells(46+i+1,4)=Depart;
		}else{
			xlsheet.cells(45+i,4)=vCompany;
			xlsheet.cells(46+i,4)=Depart;
		}
		
		var XB="先生"
		if (vAge=="女") XB="女士"
		XB=vName+XB
		xlsheet.cells(49,1)=xlsheet.cells(49,1)+XB;
		xlsheet.cells(51,1)=xlsheet.cells(51,1)+vOrderSetsDesc;
		xlsheet.cells(53,1)=xlsheet.cells(53,1)+vAddItem;
	
		xlsheet.printout;
		xlBook.Close (savechanges=false);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null

		idTmr   =   window.setInterval("Cleanup();",1); 
	
	}
	catch(e)
	{
		alert(e+"^"+e.message);
	}
}