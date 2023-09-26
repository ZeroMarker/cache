//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//��ʼ��
	KeyUp("UseLoc^Equip^Status");	//���ѡ��
	Muilt_LookUp("UseLoc^Equip^Status");
}

function InitEvent() //��ʼ��
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BExport");
	if (obj) obj.onclick=BExport_Click;
}

function BAdd_Click() //���
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBenefitAnaly&QXType='+GetElementValue("QXType")
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function BExport_Click()
{
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	var encmeth=GetElementValue("GetOneBenefitAnalyList");
	var TotalRows=cspRunServerMethod(encmeth,0);
	if (TotalRows<=1)
	{
		alertShow(t["01"])
		return;
	}
	var FileName=GetFileName();
	if (FileName=="") {return;}
	var PageRows=60000 //ÿҳ�̶�����
	var Pages=parseInt(TotalRows / PageRows) //��ҳ��-1 
	var ModRows=TotalRows%PageRows //���һҳ����
	if (ModRows==0) Pages=Pages-1
	try {
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQBenefitAnalyList.xls";
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
		    	xlsheet.cells(j,1)=OneDetailList[2]; //�豸����
		    	xlsheet.cells(j,2)=OneDetailList[5]; //���
		    	xlsheet.cells(j,3)=OneDetailList[6]; //��λ
		    	xlsheet.cells(j,4)=GetShortName(OneDetailList[3],"-"); //ʹ�ÿ���
		    	xlsheet.cells(j,5)=OneDetailList[8]; //��ֵ
		    	xlsheet.cells(j,6)=OneDetailList[11]; //������
		    	xlsheet.cells(j,7)=OneDetailList[12]; //��֧��
		    	xlsheet.cells(j,8)=OneDetailList[13]; //ӯ��
		    	xlsheet.cells(j,9)=(OneDetailList[10]/OneDetailList[9])*100; //ʹ����
		    	xlsheet.cells(j,10)=OneDetailList[14]; //������
			}
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(2,1)="���ڷ�Χ:"+GetElementValue("Year")+"-"+GetElementValue("Month")
			xlsheet.cells(2,6)=curUserName
			xlsheet.cells(2,9)="ҳ��:"+(i+1)+"/"+(Pages+1)
	    	xlBook.SaveAs(FileName);
	    	//xlsheet.printout; //��ӡ���
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

function GetEquip(value) {
	var user=value.split("^");
	var obj=document.getElementById("EquipDR");
	obj.value=user[1];
}
function GetStatus(value) {
	var user=value.split("^");
	var obj=document.getElementById("StatusDR");
	obj.value=user[1];
}
function GetUseLoc(value) {
	var user=value.split("^");
	var obj=document.getElementById("UseLocDR");
	obj.value=user[1];
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
