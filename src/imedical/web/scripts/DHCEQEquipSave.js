//̨�ʱ���
var num;
var job;

function  PrintDHCEQEquip(vData,SaveOrPrint)
{
	var job="";
	var obj=window.parent.frames[1].document.getElementById("Tjobz1");
	if(obj)
	{job=obj.innerText;}
	
	/// Modified by jdl 2013-7-16 JDL0133 �Ż�̨�ʵ���Ч��?���Ӳ���ÿ�λ�ȡ������Ϣ100
	PrintDHCEQEquipNew("Equip",SaveOrPrint,job,vData,"",50);
	return;
	/*
	GetNum()
	if (num<=1) {alertShow("��ûֵ")}
	else
	{
     try {
	    var FileName=GetFileName();
	    ///var FileName="d:\equip.xls";
	    if (FileName=="") {return;}
      	var GetPrescPath=document.getElementById("GetRepPath");
		if (GetPrescPath)
		 {
			 var encmeth=GetPrescPath.value
			 } 
		else 
		{
			var encmeth=''
			};
		if (encmeth!="") 
		{
			var	TemplatePath=cspRunServerMethod(encmeth);
			}
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQEquipSP.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet  
	    for (Row=1;Row<=num;Row++)
	    { 
	   		var list=document.getElementById('GetList');
		 	if (list) {var encmeth=list.value} else {var encmeth=''};
			var str=cspRunServerMethod(encmeth,'','',job,Row)
			var List=str.split("^")
			xlsheet.Rows(Row+1).Insert()
			xlsheet.cells(Row+1,1)=List[0]//��  ��  ��  ��
			xlsheet.cells(Row+1,2)=List[1]; //����
			xlsheet.cells(Row+1,3)=List[2]; //�豸����
			xlsheet.cells(Row+1,4)=List[3]; //�豸��λ
			xlsheet.cells(Row+1,5)=List[4]; //����
			xlsheet.cells(Row+1,6)=List[5]; //����
			xlsheet.cells(Row+1,7)=List[6]; //��װ�ص�
			xlsheet.cells(Row+1,8)=FormatDate(List[7],"",""); //��װ����
			xlsheet.cells(Row+1,9)=List[8]; //�������
			xlsheet.cells(Row+1,10)=FormatDate(List[9],"",""); //��������
			xlsheet.cells(Row+1,11)=FormatDate(List[10],"",""); //������������//��������
			xlsheet.cells(Row+1,12)=FormatDate(List[11],"",""); //��������
			xlsheet.cells(Row+1,13)=List[12]; //����
			xlsheet.cells(Row+1,14)=List[13]; //ʹ�ò���
			xlsheet.cells(Row+1,15)=List[14]; //�豸��Դ
			xlsheet.cells(Row+1,16)=List[15]; //�豸��Դ����
			xlsheet.cells(Row+1,17)=List[16]; //�豸ȥ��
			xlsheet.cells(Row+1,18)=List[17]; //�ɹ���ʽ
			xlsheet.cells(Row+1,19)=List[18]; //��Ӧ��
			xlsheet.cells(Row+1,20)=List[19]; //��������
			xlsheet.cells(Row+1,21)=List[20]; //�豸ԭֵ
			xlsheet.cells(Row+1,22)=List[21]; //�豸��ֵ
			xlsheet.cells(Row+1,23)=List[22]; //�豸����ֵ
			xlsheet.cells(Row+1,24)=List[23]; //ʹ������
			xlsheet.cells(Row+1,25)=List[24]; //��ͬ
			xlsheet.cells(Row+1,26)=List[25]; //�۾ɷ���
			xlsheet.cells(Row+1,27)=List[26]; //��ע
			xlsheet.cells(Row+1,28)=List[27]; //�ۼ��۾ɺϼ�
			xlsheet.cells(Row+1,29)=List[28]; //���������
			xlsheet.cells(Row+1,30)=List[29]; //��������λ
			xlsheet.cells(Row+1,31)=List[30]; //����������
			xlsheet.cells(Row+1,32)=List[31]; //ά�޸�����
			xlsheet.cells(Row+1,33)=List[32]; //������ϵ��
			xlsheet.cells(Row+1,34)=List[33]; //�����绰
			xlsheet.cells(Row+1,35)=List[34]; //���ӷ��úϼ�
			xlsheet.cells(Row+1,36)=FormatDate(List[35],"",""); //��������
			xlsheet.cells(Row+1,37)=FormatDate(List[36],"",""); //ת������
			xlsheet.cells(Row+1,38)=List[37]; //���ޱ�־
			xlsheet.cells(Row+1,39)=List[38]; //����
			xlsheet.cells(Row+1,40)=List[39]; //ҽ���豸
			xlsheet.cells(Row+1,41)=FormatDate(List[40],"",""); //���޿�ʼ����
			xlsheet.cells(Row+1,42)=FormatDate(List[41],"",""); //���޽�������
			xlsheet.cells(Row+1,43)=List[42]; //����־
			xlsheet.cells(Row+1,44)=List[43]; //����
			xlsheet.cells(Row+1,45)=List[44]; //������
			xlsheet.cells(Row+1,46)=List[45]; //����
			xlsheet.cells(Row+1,47)=List[46]; //�豸����
			xlsheet.cells(Row+1,48)=List[47]; //�깺���
			xlsheet.cells(Row+1,49)=List[48]; //��;
			xlsheet.cells(Row+1,50)=List[49]; //������
			xlsheet.cells(Row+1,51)=List[50]; //�豸�ⷿ
			xlsheet.cells(Row+1,52)=List[51]; //�����·�
			xlsheet.cells(Row+1,53)=List[52]; //�ۺ������
			xlsheet.cells(Row+1,54)=List[53]; //�����ϸ
			xlsheet.cells(Row+1,55)=List[54]; //�豸���
			xlsheet.cells(Row+1,56)=List[55]; //״̬
			xlsheet.cells(Row+1,57)=List[56]; //�ⷿ״̬
			xlsheet.cells(Row+1,58)=List[57]; //������ϵ��
			xlsheet.cells(Row+1,59)=List[58]; //����绰
			xlsheet.cells(Row+1,60)=List[59];
			var Loc=List[51];
			////if (Row>10&&Row<15) alertShow(Loc);
			if (Loc!="")
			{
				///Loc=Loc.split("-");
				///xlsheet.cells(Row+1,61)=Loc[0];
				xlsheet.cells(Row+1,61)=List[60];
			}
			
	     }
	    xlBook.SaveAs(FileName);   //lgl+
	    //xlBook.SaveAs("D:\\cgeqipsq.xls");
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	   }
 
	catch(e)
	 {
		alertShow(e.message);
		};
	}*/
}
/// Mozy0103	20130716
function PrintDHCEQEquipToTXT()
{
	var TempNode="EquipList";
	GetNum(TempNode,"");
	if (num<=1)
	{
		alertShow("û�з�������������!")
	}
	else
	{
		try
		{
			var FileName=GetFileNameToTXT();
			var fso = new ActiveXObject("Scripting.FileSystemObject");
    		var f = fso.OpenTextFile(FileName,2,true);	//����д�ļ�
    		encmeth=GetElementValue("GetColSets");
			var	colsets=cspRunServerMethod(encmeth,"","2","","Equip"); //�û�������
			if (colsets=="")
			{
				var	colsets=cspRunServerMethod(encmeth,"","1","","Equip"); //��ȫ�鼶����
				if (colsets=="")
				{
					var	colsets=cspRunServerMethod(encmeth,"","0","","Equip"); //ϵͳ����
				}
			}
			var colsetlist=colsets.split("&");
			var colname=new Array()
			var colcaption=new Array()
			var colposition=new Array()
			//var colformat=new Array()
			var cols=colsetlist.length
			for (i=0;i<cols;i++)
			{
				var colsetinfo=colsetlist[i].split("^");
				colcaption[i]=colsetinfo[1];
				//colname[i]=colsetinfo[2];
				colposition[i]=colsetinfo[3];
				//colformat[i]=colsetinfo[4];
			}
			//д�����
		    var tmpString="";
		    for (i=0;i<cols;i++)
		    {
			    if (tmpString!="") tmpString=tmpString+"\t";
			    tmpString=tmpString+colcaption[i];
			}
			f.WriteLine(tmpString);
			//д���¼
			var EndRow=parseFloat(num)+1;
			for (Row=1;Row<=num;Row++)
		    { 
		   		var list=document.getElementById('GetList');
			 	if (list) {var encmeth=list.value} else {var encmeth=''};
				var str=cspRunServerMethod(encmeth,TempNode,job,Row);
				var List=str.split("^")			// ����������Ϣ
				//alertShow("List="+List)
				tmpString="";
				for (i=1;i<=cols;i++)
		    	{
			    	var position=colposition[i-1];
			    	if (position>0)
			    	{	position=position-1;}
			    	else
			    	{	position=0}
			    	//if (Row==1) alertShow(position+"&"+List[position]);
			    	tmpString=tmpString+List[position].replace(/\r\n/g,"")+"\t";
				}
				f.WriteLine(tmpString);
		    }
		    f.Close();
			alertShow("�������!");
		} 
		catch(e)
		{
			alertShow(e.message);
		}
	}
}
