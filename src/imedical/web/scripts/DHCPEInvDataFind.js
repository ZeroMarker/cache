//DHCPEInvDataFind
//��ѯÿ�췢Ʊʵʱ����
	
function BodyLoadHandler() {
                    
    var obj=document.getElementById('BFind');   
    if (obj){obj.onclick =BFind_click;}  
    var obj=document.getElementById('BExport');   
    if (obj){obj.onclick =BPrint_click;}         
}


function BFind_click()
{
	 var iBeginDate="",iEndDate=""
	  var obj=document.getElementById('BeginDate')
	  if (obj) var iBeginDate=obj.value;
	  var obj=document.getElementById('EndDate')
	  if (obj) var iEndDate=obj.value;
  
	
   var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEInvDataFind"
			+"&BeginDate="+iBeginDate
			+"&EndDate="+iEndDate
	
      
    location.href=lnk; 
	}

function BPrint_click()
{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEInvPayModeDataFind.xls';

	}else{
		alert("��Чģ��·��");
		return;
	}
	alert(Templatefilepath)
	xlApp = new ActiveXObject("Excel.Application");  //�̶�
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������
		
	var obj=document.getElementById('BeginDate')
	if (obj) var iBeginDate=obj.value;
	var obj=document.getElementById('EndDate')
	if (obj) var iEndDate=obj.value;
	  
	var iBeginDate=iBeginDate.split("/")[2]+"-"+iBeginDate.split("/")[1]+"-"+iBeginDate.split("/")[0];
	var iEndDate=iEndDate.split("/")[2]+"-"+iEndDate.split("/")[1]+"-"+iEndDate.split("/")[0];
	xlsheet.cells(2,2)=iBeginDate; 
 	xlsheet.cells(3,2)=iEndDate; 
	var tbObj = document.getElementById('tDHCPEInvDataFind');
 	var rowObj = tbObj.getElementsByTagName("tr");
	if(tbObj)
   	{
		var k=4
		var str = "";
		var MaxCol=0;
		//rowNumber�����,columnNumber�����
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
	//xlsheet.printout;
	//xlsheet.SaveAs("d:\\"+"�շ�Ա�ս�����Ϣ.xls");
	xlApp.Visible = true;
	xlApp.UserControl = true;

	
}

document.body.onload = BodyLoadHandler;