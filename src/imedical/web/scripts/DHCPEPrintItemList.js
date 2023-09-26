///DHCPEPrintItemList.js
function PrintItemList(Info,path)
{
	try
	{
		var Templatefilepath=path+'DHCPEItemList.xls';
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Templatefilepath);
		xlsheet = xlBook.WorkSheets("Sheet1");
		var splitStr=String.fromCharCode(1);
		var BaseInfo=Info.split(splitStr)[0];
		var BaseInfo=BaseInfo.split("^");
		var name=BaseInfo[0];
		var regNo=BaseInfo[1];
		var sex=BaseInfo[2];
		var age=BaseInfo[3];
		var Amount=BaseInfo[4];
		var Date=BaseInfo[5];
		xlsheet.cells(2,1).value=name;
		xlsheet.cells(2,2).value=regNo;
		xlsheet.cells(2,4).value=sex;
		xlsheet.cells(2,5).value=age;
		
		var listInfo=Info.split(splitStr)[1];
		var splitStr=String.fromCharCode(2);
		var listInfo=listInfo.split(splitStr);
		var i=listInfo.length;
		var l=4
		for (var j=0;j<i;j++)
		{
			var Data=listInfo[j];
			var Row=j+l;
			var DataStr=Data.split("^");
			xlsheet.Rows(Row).insert();
			for (var k=0;k<5;k++)
			{
				xlsheet.cells(Row,k+1).value=DataStr[k];
			}
			
		}
		xlsheet.Rows(Row+1).Delete;
		xlsheet.Range( xlsheet.Cells(4,1),xlsheet.Cells(Row,1)).HorizontalAlignment =2;
		xlsheet.Range( xlsheet.Cells(4,4),xlsheet.Cells(Row,4)).HorizontalAlignment =2;
		xlsheet.Range( xlsheet.Cells(4,2),xlsheet.Cells(Row,2)).HorizontalAlignment =1;
		xlsheet.Range( xlsheet.Cells(4,3),xlsheet.Cells(Row,3)).HorizontalAlignment =1;
		xlsheet.Range( xlsheet.Cells(4,5),xlsheet.Cells(Row,5)).HorizontalAlignment =1;
		xlsheet.cells(Row+1,1).value=Amount;
		xlsheet.cells(Row+1,2).value=Date;			
		xlsheet.printout;
		//xlsheet.saveas("d:\\aa.xls")
		xlBook.Close (savechanges=false);
		xlApp=null;
		xlsheet=null;
	}
	catch(e)
	{
		
	}
}