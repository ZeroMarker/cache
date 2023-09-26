/// DHCPEGNoPayFeeFind.js


function BodyLoadHandler() {
 
	var obj;
	obj=document.getElementById("BFind");
	if (obj) {obj.onclick=BFind_Click;}
    obj=document.getElementById("Export");
    if (obj) {obj.onclick=Export_click;}
		
	obj=document.getElementById("PayedMoney");
	if (obj) { obj.onclick=Pay_click; }
	
	obj=document.getElementById("NotPayMoney");
	if (obj) { obj.onclick=Pay_click; }

}

function RegNo_keydown(){
	
	if ((13==Key)) {
		BFind_Click();
	}
}
function Pay_click(){
	var obj;
	var src=window.event.srcElement;
	obj=document.getElementById('PayedMoney');
	if (obj && obj.id!=src.id) { obj.checked=false; }
	obj=document.getElementById('NotPayMoney');
	if (obj && obj.id!=src.id) { obj.checked=false; }
}

function $(oid)
{ 
   return document.getElementById(oid);
}
function $$(str)
{
   window.alert(str);	
}
function BFind_Click()
{
    var obj="",PayStatus=""
    var stdate=document.getElementById("DateBegin").value;
    var edate=document.getElementById("DateEnd").value;
    obj=document.getElementById("PayedMoney");
    if (obj&&obj.checked)
	 { PayStatus="1";
	  
	  }
    obj=document.getElementById("NotPayMoney");
	if (obj&&obj.checked)
	 { PayStatus="0";
	   
	  }

	obj=document.getElementById("ExcNotPayMoney");
	if (obj&&obj.checked)
	 { PayStatus="2";
	   
	  }

    var lnk= "dhcpegfeelist.csp?"+"&StartDate="+stdate+"&EndDate="+edate+"&PayStatus="+PayStatus;
    parent.frames['DHCPEGNoPayFeeList'].location.href=lnk; 
    //var lnk= "dhcnuripexeclist.csp?"+"&wardid="+wardid+"&RegNo="+regobj+"&userId="+userId+"&StartDate="+stdate+"&EndDate="+edate+"&vartyp="+vartyp+"&gap="+gap+"&warddes="+wardobj+"&Loc="+locid+"&doctyp="+doctyp+"&longNewOrdAdd="+longNewOrdAdd+"&onlyNewOrd="+onlyNewOrd+"&ArcimDR="+ArcimDR+"&pdaExec="+pdaExec+"&wardProGroupId="+wardProGroupId+"&HospitalRowId="+HospitalRowId+"&OrdPro="+OrdPro;
    //parent.frames['OrdList'].location.href=lnk; 
}

function Export_click()
{	var stdate ="",edate="",PayStatus=""
	try {
		var excApp = new ActiveXObject("Excel.Application");
    }
    catch(e) 
	{
         $$( "��������ʧ��!�����밲װExcel���ӱ�������ͬʱ�������ʹ�á�ActiveX�ؼ��������������������ִ�пؼ�!");
         return "";
     }
     
   excApp.UserControl = true;
   excApp.visible = false; //����ʾ
   var excBook = excApp.Workbooks.Add();
   var oSheet = excBook.Worksheets(1);

   var obj=document.getElementById("PayStatus");
   if (obj){var PayStatus=obj.value}
   if (PayStatus==0){   
   oSheet.cells(1,1)="�������δ��������"}
   else if (PayStatus==2){
	  oSheet.cells(1,1)="���������ִ��δ��������";
   } else if (PayStatus==1){ 
   oSheet.cells(1,1)="��������ѽ�������";
   }

   var obj=document.getElementById("DateFrom");
   if (obj){var stdate=obj.value}
   
   var obj=document.getElementById("DateTo");
   if (obj){var edate=obj.value}
   
   oSheet.cells(2,1)="��ʼ����:"+stdate
   oSheet.cells(3,1)="��������:" +edate
   
   oSheet.Range(oSheet.Cells(1,1),oSheet.Cells(1,3)).mergecells=true; //�ϲ���Ԫ��
   oSheet.Range(oSheet.Cells(1,1),oSheet.Cells(1,3)).HorizontalAlignment =-4108;//����
   oSheet.Range(oSheet.Cells(1,1),oSheet.Cells(1,3)).Font.Name = "����" ;
   oSheet.Range(oSheet.Cells(1,1), oSheet.Cells(1,3)).Font.Size = 14 ;
   oSheet.Rows(2).Font.Name = "����" ;
   oSheet.Rows(2).Font.Size = 12;//�����С
   oSheet.Rows(2).ColumnWidth=25;//�п�
   oSheet.Rows(2).RowHeight = 20; //�����и�
   oSheet.Rows(3).Font.Name = "����" ;
   oSheet.Rows(3).Font.Size = 12;//�����С
   oSheet.Rows(3).ColumnWidth=25;//�п�
   oSheet.Rows(3).RowHeight = 20; //�����и�
   var tbObj = $('tGroupNoPayInfo')  //���ﶨ���TABLE

   var rowObj = tbObj.getElementsByTagName("tr");   
   oSheet.Rows(4).HorizontalAlignment = - 4108;//����A, B�о���
   oSheet.Rows(4).Font.Name = "����" ;
   oSheet.Rows(4).Font.Size = 12;//�����С
   oSheet.Rows(4).ColumnWidth=25;//�п�
   oSheet.Rows(4).RowHeight = 20; //�����и�
   if(tbObj)
   {  
      var str = "";
	  //rowNumber�����,columnNumber�����
      for(var rowNumber = 0;  rowNumber < rowObj.length;rowNumber ++ )
      {
         for(var columnNumber = 0; columnNumber < rowObj[rowNumber].cells.length;
         columnNumber ++ )
         {
            str = rowObj[rowNumber].cells[columnNumber].innerText;
            oSheet.cells(rowNumber+4, columnNumber + 1).value = str;
			if(0==rowNumber)
			{
			    oSheet.cells(4,  columnNumber + 1).Interior.ColorIndex = 17;//���õ�һ�е�ɫ
			}
         }
      }
   }
    oSheet.Range(oSheet.Cells(4,1),oSheet.Cells(rowNumber+4,columnNumber + 1)).HorizontalAlignment =-4108;//����
    if (PayStatus==0){   
   var dir = "d:\\" + "�������δ���㱨��.xls";//����Ŀ¼
   }
   else if (PayStatus==2){ 
   var dir = "d:\\" + "���������ִ��δ���㱨��.xls";//����Ŀ¼
   }else if (PayStatus==1){ 
    var dir = "d:\\" + "��������ѽ��㱨��.xls";
   }
	

	
   excBook.SaveAs(dir);
   excApp.Quit();//�˳�excel
   excApp=null;
   $$("�����ɹ�,������"+dir);
}

document.body.onload = BodyLoadHandler;


