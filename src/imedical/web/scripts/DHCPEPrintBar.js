//���������ӡ
//
function BarCodePrintByCrm(crmid)
{
	if (""==crmid) {
		return ;
	}
	var encmeth=GetCtlValueById("GetAdmID");
	if (""==encmeth) return;
	
	var admid=cspRunServerMethod(encmeth,crmid);
	var info=admid.split("^");
	admid=info[1];
	BarCodePrint(admid);
}

function BarCodePrint(paadmid) 
{
	var encmeth="";
	var result="";
	
	if (""==paadmid) {
		return ;
	}
	
	//��ȡ��Ϣ
	var Ins=document.getElementById("PatOrdItemInfo");
	if (Ins) {var encmeth=Ins.value; }
	if (""!=encmeth) result=cspRunServerMethod(encmeth,"BarPrint","",paadmid+"^");
}

function BarPrint(value) {
		
	if (""==value) {
		alert("δ�ҵ�������Ŀ");
		return false;
	}
	var Ords=value.split(";");
	var iLLoop=1;
	for (var iLLoop=1;iLLoop<Ords.length;iLLoop++) 
	{

		OrdItems=Ords[iLLoop].split("^");
		
		var Bar;  
		Bar= new ActiveXObject("PrintBar.PrnBar");
		Bar.PrintName="tm";//��ӡ������
        Bar.SetPrint()
		// �ǼǺ�
		Bar.RegNo=OrdItems[0]; 	
		// ����
		Bar.PatName=OrdItems[1];
		// ����
		Bar.Age=OrdItems[2];
		// �Ա�
		Bar.Sex=OrdItems[3];
		// ����
		Bar.PatLoc=OrdItems[4];	
		// �걾��
		Bar.SpecNo=OrdItems[6];	
		// ��Ŀ����
		var OrdNameArray=Ords[iLLoop].split("\!");
		Bar.OrdName=OrdNameArray[1];	
		Bar.RecLoc=OrdNameArray[2];
        Bar.BedCode="";  
		Bar.PrintZebraBar();
	}

}