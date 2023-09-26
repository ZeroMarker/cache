/// DHCPEGCashierDetailPrint.js
/// ����ʱ��		2007.12.10
/// ������			xuwm
/// ��Ҫ����		��ӡ���������ϸ
/// ��Ӧ��		
/// ����޸�ʱ��
/// ����޸���

var FExcel;

// ��������
function PrintGCashierDetail() {
	
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEGCashierDetailPrint.xls'; // ģ���ļ�
	}else{
		alert("��Чģ��·��");
		return;
	}

	var objExcel= new DHCPEExcel(Templatefilepath, false);
	if (objExcel)
	{
		// ���õ����ļ�(����ļ���,����)
		PGDFileChange(objExcel);

		// ������ۺϲ�ѯ
		ImportGCashierDetail(objExcel);
		var IsPreview=false;
		
		objExcel.Print(IsPreview);
		var IsSave=false;
		
		objExcel.Colse(IsSave);
		objExcel=null;
		alert("���ô�ӡ���.");
	}

}

function PGDFileChange(objExcel) {
		var obj;
		var Title='';
		obj=document.getElementById('Desc');
		if (obj) { Title=obj.value+'������ϸ'; }

		var iCol=1;
		var iRow=1;
		objExcel.writeData(iCol, iRow, Title);
}

// 
var FRow=3;
function ImportGCashierDetail(objExcel) {
	//alert('ImportGCashierDetail');
	
	var obj;
	var GDR='';
	obj=document.getElementById('ID');
	if (obj) { GDR=obj.value; }
	FRow=3;
	objExcel.GetSheet('GCashierDetail');
	FExcel=objExcel;
	var Instring=GDR;
	var Ins=document.getElementById('GCashierDetailBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var retvalue=cspRunServerMethod(encmeth,'GCashierDetailToExcel','',Instring)	
	if (""==retvalue) { return false; }
	//FExcel=null;
}

// 
function GCashierDetailToExcel(Datas) {
	//alert(Datas);
	var DayDatas=Datas.split("^");
	
	var iCol=0,iRow=FRow;
	for (var iCol=1;iCol<=DayDatas.length;iCol++) {
		FExcel.writeData(iRow, iCol, DayDatas[iCol-1]);
		if (""!=DayDatas[0]) { FExcel.Borders(iRow,iCol,'TOP^'); }
	}
	
	FRow=FRow+1;
}