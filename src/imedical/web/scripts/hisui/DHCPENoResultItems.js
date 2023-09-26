//����	DHCPENoResultItems.js
//����	������ͳ��ĳʱ��ε�δ�ش��������Ŀ
//���	DHCPENoResultItems	
//����	2008.08.14
//������  xy

var TFORM="tDHCPENoResultItems"; 
function BodyLoadHandler() {

   
   var obj=document.getElementById("BFind");
	if (obj) {obj.onclick=BFind_Click;}
	
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
function BFind_Click()
{   
   
   var iDateFrom="",iDateTo="",iRecLocID="",iRecLoc="",iArrivedFlag="";
  
    iDateFrom=getValueById("DateFrom");
     
    iDateTo=getValueById("DateTo");
    
	iRecLocID=getValueById("RecLocID");
    
    iRecLoc=getValueById("RecLoc");
    
   
    ArrivedFlag=getValueById("ArrivedFlag");
	if(ArrivedFlag) {iArrivedFlag="Y"; }
	else{iArrivedFlag=""; }
	
  
 
  var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPENoResultItems"
			+"&DateFrom="+iDateFrom
			+"&DateTo="+iDateTo
			+"&RecLocID="+iRecLocID
			+"&RecLoc="+iRecLoc
			+"&ArrivedFlag="+iArrivedFlag	
            ;
            messageShow("","","",lnk)
    //location.href=lnk; 

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
	
	

    xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null

	idTmr   =   window.setInterval("Cleanup();",1); 
	 
}

catch(e)
	{
		messageShow("","","",e+"^"+e.message);
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