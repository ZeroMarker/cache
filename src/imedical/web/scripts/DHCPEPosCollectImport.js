/// DHCPEPosCollectImport.js
/// ����ʱ��		2007.09.15
/// ������			xuwm
/// ��Ҫ����		�����������ܲ�ѯ ���ݵ�����Excel�ļ�
/// ��Ӧ��		
/// ����޸�ʱ��
/// ����޸���

var FExcel;

// ������ۺϲ�ѯ����
function PosCollectImport(DataSaveFilePath,Contion) {
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPoscollect.xls'; // ����ۺϲ�ѯ����
	}else{
		alert("��Чģ��·��");
		return;
	}

	var objExcel= new DHCPEExcel(Templatefilepath, false);
	if (objExcel)
	{
		// ���õ����ļ�(����ļ���,����)
		PCFileChange(objExcel, DataSaveFilePath);
		// ������ۺϲ�ѯ
		ImportPosCollect(objExcel,Contion);

		objExcel.Colse(true);
		objExcel=null;
		alert("���ݵ������");
	}

}
// ���õ����ļ�(����ļ���,����)
function PCFileChange(objExcel,DataSaveFilePath) {
	objExcel.SaveTo(DataSaveFilePath);
}

// ������ۺϲ�ѯ
var FIndex=1; 
function ImportPosCollect(objExcel,Contion) {
  
	FExcel=objExcel;
	FIndex=1;
	var Instring=Contion;
	//objExcel.GetSheet('��ϸ��Ϣ');
	//objExcel.GetSheet('����ͳ��');
	var Ins=document.getElementById('PosCollectBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'PosCollectToExcel','',Contion);
	if (""==value) { return false; }

}

// ����������ݵ�Excel�ļ�,�� ImportPosCollect �е���
function PosCollectToExcel(Datas) {
	var objExcel=FExcel;
	/*
	objExcel.writeDataToRow(Datas, FIndex, 1);
	FIndex=FIndex+1;
	*/
	objExcel.writeDataToCol(Datas,FIndex,1);
	//objExcel.Borders(2, FIndex, 'LEFT^TOP^BOTTOM^RIGHT^');
	FIndex=FIndex+1;
	return true;
}