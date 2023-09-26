var SelectedRow = 0;
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//��ʼ��
	KeyUp("UseLoc");	//���ѡ��
	KeyUp("Equip");
	KeyUp("MaintUser");
	Muilt_LookUp("UseLoc");
	Muilt_LookUp("Equip");
	Muilt_LookUp("MaintUser");
	SetElement("MaintType",GetElementValue("MaintTypeDR"))
}

function InitEvent() //��ʼ��
{
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
}

function BPrint_Click() //��ӡ��ť
{
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	var encmeth=GetElementValue("GetOneMaintStatistics");
	var TotalRows=cspRunServerMethod(encmeth,0);
	if (TotalRows<=1)
	{
		alertShow(t["01"])
		return;
	}
	var PageRows=24 //ÿҳ�̶�����
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1 
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	
	try {
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQMaintStatistics.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=0
	    	if (ModRows==0)
	    	{
		    	OnePageRow=PageRows
	    	}
	    	else
	    	{
	    		if (i==Pages)
	    		{
		    		OnePageRow=ModRows
	    		}
		    	else
		    	{
			    	OnePageRow=PageRows
		    	}
	    	}
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
		    	var OneDetail=cspRunServerMethod(encmeth,l);
		    	var OneDetailList=OneDetail.split("^");
		    	var j=k+3;
		    	xlsheet.Rows(j).Insert();
		    	xlsheet.cells(j,1)=GetShortName(OneDetailList[1],"-"); //�������
		    	xlsheet.cells(j,2)=OneDetailList[2]; //���뵥��
		    	xlsheet.cells(j,3)=OneDetailList[3]; //�豸����
		    	xlsheet.cells(j,4)=OneDetailList[4]; //�豸���
		    	xlsheet.cells(j,5)=OneDetailList[5]; //����ͺ�
		    	xlsheet.cells(j,6)=FormatDate(OneDetailList[6]); //��������
		    	if (OneDetailList[7]=="ά���ܴ���:")
		    	{
			    	xlsheet.cells(j,7)=OneDetailList[7]; //ά������
		    	}
		    	else
		    	{
			    	xlsheet.cells(j,7)=FormatDate(OneDetailList[7]); //ά������
		    	}
		    	xlsheet.cells(j,8)=OneDetailList[8]; //ά��Ա
		    	xlsheet.cells(j,9)=GetShortName(OneDetailList[9],"-"); //ʹ�ÿ���
		    	xlsheet.cells(j,10)=OneDetailList[10]; //����
		    	xlsheet.cells(j,11)=OneDetailList[11]; //����
			}
			if (GetElementValue("UseLoc")=="") //ʹ�ÿ���
			{
				xlsheet.cells(2,1)=""
			}
			else
			{
				xlsheet.cells(2,2)=GetElementValue("UseLoc")
			}
			xlsheet.cells(2,5)=FormatDate(GetElementValue("StartDate"))+"��"+FormatDate(GetElementValue("EndDate")) //ά������
			if (GetElementValue("MaintUser")=="") //ά��Ա
			{
				xlsheet.cells(2,9)=""
				xlsheet.cells(2,10)=""
			}
			else
			{
				xlsheet.cells(2,10)=GetElementValue("MaintUser")
			}
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(j+1,2)=curUserName
			xlsheet.cells(j+1,6)=FormatDate(GetCurrentDate())
			xlsheet.cells(j+1,10)="��"+(i+1)+"ҳ "+"��"+(Pages+1)+"ҳ"
	    	xlsheet.printout; //��ӡ���
	    	xlBook.Close (savechanges=false);
	    	
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

function BClear_Click() //��հ�ť
{
	SetElement("UseLoc","");
	SetElement("UseLocDR","")
	SetElement("Equip","");
	SetElement("EquipDR","");
	SetElement("MaintUser","");
	SetElement("MaintUserDR","");
	SetElement("StartDate","");
	SetElement("EndDate","");
}

function GetUseLoc(value) {
	var user=value.split("^");
	var obj=document.getElementById("UseLocDR");
	obj.value=user[1];
}

function GetEquip(value) {
	var type=value.split("^");
	var obj=document.getElementById("EquipDR");
	obj.value=type[1];
}

function GetMaintUser(value) {
	var type=value.split("^");
	var obj=document.getElementById("MaintUserDR");
	obj.value=type[1];
}

function FormatDate(DateStr,FromFormat,ToFormat)
{
	if (DateStr=="") return "";
	var year,month,day		
	var DateList=DateStr.split("/");
	year=DateList[2];
	month=DateList[1];
	day=DateList[0]
	var NewDateStr=DateList[2]+"-"+DateList[1]+"-"+DateList[0];
	return NewDateStr;
		
}

//����ҳ����ط���
document.body.onload = BodyLoadHandler;
