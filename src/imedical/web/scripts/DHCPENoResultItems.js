/// 
//����	DHCPENoResultItems.js
//����	������ͳ��ĳʱ��ε�δ�ش��������Ŀ
//���	DHCPENoResultItems
//����	
//����	20121103
//����޸�ʱ��	
//����޸���	
//���
var TFORM="tDHCPENoResultItems"; 
function BodyLoadHandler() {

	var obj; 
	obj=document.getElementById("ExportNoResultItems");
	if (obj){	
		 obj.onclick=ExportNoResultItems_click;
	} 
	obj=document.getElementById("RecLoc");
	if (obj){	
		 obj.onchange=RecLoc_change;
	}
	websys_setfocus("DateFrom"); 
}  

function SelectRowHandler()
{
	//����к�
	var eSrc = window.event.srcElement
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex; 
	
	//��ö�Ӧ�ж�Ӧ�е�ֵ
	var SelRowObj=document.getElementById('TComPhonez'+selectrow)
	var ComName = SelRowObj.innerText; 
}
function ExportNoResultItems_click()
{  
    try{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPENoResultItems.xlsx';
	}else{
		alert("��Чģ��·��");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //�̶�
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������
    
   	if(TFORM.length==0)
   	{
		alert("�˴β�ѯ���Ϊ��")
	   	return;
	}  

	var DateFromTo=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetDateFromTo");
	xlsheet.cells(1,1).value="��ѯʱ���:"+DateFromTo;
	var QueryTime=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetQueryTime");

	if(QueryTime=="")
	{
		alert("�����²�ѯ");
		return; 
	}
	xlsheet.cells(2,1).value="��ӡʱ��:"+QueryTime;
	var RowsLen=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetRowLength");  
	if(RowsLen==0){		
		alert("�˴β�ѯ���Ϊ��")
	   	return;
	}
	var k=2
	for(var i=1;i<=RowsLen;i++)
	{  
		var DataStr=tkMakeServerCall("web.DHCPE.Report.NoResultItems","GetRowData",i); 
		var tempcol=DataStr.split("^");
		k=k+1
		xlsheet.Rows(k+1).insert(); 
		if((tempcol[1]==""))
		{   
			xlsheet.cells(k,1)=tempcol[0]; //д��������
			var Range=xlsheet.Cells(k,1);
	        xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,4)).mergecells=true; //�ϲ���Ԫ��
	        k=k+1
			xlsheet.Rows(k+1).insert();  
			xlsheet.cells(k,1)="����"
			xlsheet.cells(k,2)="�ǼǺ�" 
			xlsheet.cells(k,3)="����ʱ��" 
			xlsheet.cells(k,4)="��Ŀ" 
			xlsheet.Columns(2).NumberFormatLocal="@";  //���õǼǺ�Ϊ�ı��� 
			xlsheet.Columns(3).NumberFormatLocal="@";   
		}
		else
		{
			xlsheet.cells(k,1)=tempcol[0]
			xlsheet.cells(k,2)=tempcol[1]
			xlsheet.cells(k,3)=tempcol[2]
			xlsheet.cells(k,4)=tempcol[3]
			                          
		}  
	}
	var FileName="d:\\δ�ش������Ŀ.xls";
	var obj=document.getElementById("savepath");
	if (obj) FileName=obj.value;
	
	///ɾ�����Ŀ���
	//xlsheet.Rows(k+1).Delete;
	/*xlsheet.SaveAs(FileName);
	xlApp.Visible = true;
	xlApp.UserControl = true;	 
	idTmr   =   window.setInterval("Cleanup();",1);  
	*/ 

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
function SetStationID(value)
{
	if (value=="") return false;
	var DataArry=value.split("^");
	var obj=document.getElementById("StationId");
	if (obj) obj.value=DataArry[1];
}
function RecLocSelectAfter(value)
{
	if (value=="") return false;
	Arr=value.split("^");
	var obj=document.getElementById("RecLocID");
	if (obj) obj.value=Arr[1];
}
function RecLoc_change()
{
	var obj=document.getElementById("RecLocID");
	if (obj) obj.value="";
	
}
document.body.onload = BodyLoadHandler;