/// DHCPEHadCheckedList.js

function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("Print");
	if (obj) {obj.onclick=Print_Click;}

}




function Print_Click()
{ 
    var obj,HadCheckType="",DateFrom="",DateTo=""
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEHadCheckedList.xls';
	}else{
		alert("��Чģ��·��");
		return;
	}
	//alert(Templatefilepath)
	xlApp = new ActiveXObject("Excel.Application");  //�̶�
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //�̶�
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel�±������
	
	//xlsheet.Range(xlsheet.Cells(2,1),xlsheet.Cells(2,7)).Borders.LineStyle=1
	//xlsheet.Range(xlsheet.Cells(3,1),xlsheet.Cells(3,7)).Borders.LineStyle=1
	 xlsheet.Range(xlsheet.Cells(2,1),xlsheet.Cells(2,13)).Borders.LineStyle=1; 
     xlsheet.Range(xlsheet.Cells(3,1),xlsheet.Cells(3,13)).Borders.LineStyle=1;
     xlsheet.Range(xlsheet.Cells(2,1),xlsheet.Cells(2,13)).mergecells=true;
     xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,13)).mergecells=true;

	
	//if ((DateFrom=="")||(DateTo=="")) { 
	///xlsheet.Range(xlsheet.Cells(2,1),xlsheet.Cells(2,2)).RowHeight =0}
	
	//ExcelSheet.Range( ExcelSheet.Cells(tempRow+1,1),ExcelSheet.Cells(currRow-1,4)).RowHeight = 20;}
	
	//else { xlsheet.cells(2,1).Value="  "+"��ʼ����:"+DateFrom+"           "+"��������:"+DateFrom;}
	//var PersonString=String.split("!")[0]
	//var StringArr=PersonString.split("^");
    //var Rows=StringArr.length;
   
    var encmethObj=document.getElementById("PrintInfoBox");
    if (encmethObj) encmeth=encmethObj.value;
    /*
    var PersonInfo=cspRunServerMethod(encmeth,"");
    var infos= PersonInfo.split("@@");
   	*/
   
    Rows=tkMakeServerCall("web.DHCPE.PreGADM","GetPostionNum");
    for(i=0;i<Rows;i++)
		{
			//Position_"^"_GroupDesc_"^"_TeamDesc_"^"_IRegNo_"^"_IName_"^"_ISexDRName_"^"_IAge_"^"_IDepName_"^"_HadCheckType_"^"_DateFrom_"^"_DateTo_"^"_OneAmount_"^"_IAmt_"^"_FItemAmt_"^"_FEntAmt
		      
		      var OneInfo=cspRunServerMethod(encmeth,i+1)
		      var Info=OneInfo.split("^");
		      var HadCheckType=Info[7];
         	  if (HadCheckType=="Y"){ HadCheckType="�Ѽ���Ա����"}
			  else  { HadCheckType="δ����Ա����"}
		      
		      xlsheet.cells(4+i,1).Value=i+1;
		      xlsheet.cells(4+i,2).Value=Info[2];	//�ǼǺ�
		      xlsheet.cells(4+i,3).Value=Info[3]; 	//����
		      xlsheet.cells(4+i,4).Value=Info[4]; 	//�Ա�
		      xlsheet.cells(4+i,5).Value=Info[5]; 	//����6
		      xlsheet.cells(4+i,6).Value=Info[10];	//����5
		      xlsheet.cells(4+i,7).Value=Info[1];	//����6
		      xlsheet.cells(4+i,8).Value=Info[6]; 	//���7
		      xlsheet.cells(4+i,9).Value=Info[11]; 	//�Էѽ��7
		      xlsheet.cells(4+i,10).Value=Info[12]; 	//������Ŀ���7
		      xlsheet.cells(4+i,11).Value=Info[13]; 	//�ײͽ��7
			  xlsheet.cells(4+i,12).Value=Info[14]; //�ƶ��绰
			  xlsheet.cells(4+i,13).Value=Info[15]; //����ʱ��

		      //xlsheet.cells(3,7).Value="����"; 
              xlsheet.cells(1,1).Value=Info[0]+HadCheckType; 
             xlsheet.Range(xlsheet.Cells(4+i,1),xlsheet.Cells(4+i,6)).HorizontalAlignment =-4108;//����
             xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,13)).HorizontalAlignment =-4108;//����
         	// xlsheet.Range(xlsheet.Cells(1+i,1),xlsheet.Cells(1+i,6)).Borders(9).LineStyle=1;//����
         	 // xlsheet.Range(xlsheet.Cells(1+i,1),xlsheet.Cells(1+i,6)).Borders(3).LineStyle=1;
         	  xlsheet.Range(xlsheet.Cells(4+i,1),xlsheet.Cells(4+i,13)).Borders.LineStyle=1; }
   //xlsheet.SaveAs("d:\\������Ա����.xls")
   xlApp.Visible = true;
   xlApp.UserControl = true;
     

}



document.body.onload = BodyLoadHandler;
