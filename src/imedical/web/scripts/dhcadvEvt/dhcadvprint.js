//congyue
//2017-12-12
alert("OK");
function printTumble(printTumble){
	alert(printTumble);
	var ID = printTumble;
	var retval=tkMakeServerCall("web.DHCADVCOMMONPRINT","GetPrintData",ID);
	if(retval==""){
		$.messager.alert("��ʾ:","ȡ���ݴ���");
		return;
	}
	
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_Tumble.xlsx";

	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	objSheet.Cells(2,2).value=retvalArr[44]+" "+retvalArr[45]; //��������
	objSheet.Cells(2,7).value=retvalArr[1]; //����

	objSheet.Cells(4,7).value=retvalArr[23]; //��ҵ��ϵ�绰
	objSheet.Cells(5,2).value=retvalArr[5]; //�ǼǺ�
	objSheet.Cells(5,7).value=retvalArr[24]; //�ͺŹ��
	objSheet.Cells(6,2).value=retvalArr[4]; //��������
	objSheet.Cells(6,4).value=retvalArr[2]; //�Ա�
	objSheet.Cells(6,7).value=retvalArr[25]; //��Ʒ���
	objSheet.Cells(7,7).value=retvalArr[26]; //��Ʒ����
	objSheet.Cells(8,1).value=retvalArr[6]; //Ԥ�����Ƽ���������
	objSheet.Cells(8,7).value=retvalArr[27]+retvalArr[28]; //������
	objSheet.Cells(9,2).value=retvalArr[7]+" "+retvalArr[8]; //����ʱ��
	objSheet.Cells(9,7).value=retvalArr[29]; //��Ч����
	objSheet.Cells(10,7).value=retvalArr[30]; //��������
	objSheet.Cells(11,2).value=retvalArr[9]; //�¼���Ҫ����
	objSheet.Cells(11,7).value=retvalArr[31]; //ͣ������
	objSheet.Cells(12,2).value=retvalArr[10];  //�¼���������
	objSheet.Cells(12,7).value=retvalArr[32]; //ֲ������
	objSheet.Cells(13,2).value=retvalArr[11]; //�¼���������
	objSheet.Cells(13,7).value=retvalArr[25]; //��Ʒ���
	objSheet.Cells(14,2).value=retvalArr[12]+retvalArr[13]; //ʵ��ʹ�ó���
	objSheet.Cells(14,6).value=retvalArr[33];  //�¼���������ԭ���
	objSheet.Cells(15,2).value=retvalArr[14]+" "+retvalArr[15]+" "+retvalArr[16]; //����ʱ���¼��Ľ��
	objSheet.Cells(17,1).value=retvalArr[17]; //�¼�����
	objSheet.Cells(17,6).value=retvalArr[34]; //�¼������������
	objSheet.Cells(19,7).value=retvalArr[35]; //�¼�����״̬
	objSheet.Cells(22,6).value=retvalArr[36]; //ʡ����⼼�������������
	objSheet.Cells(26,6).value=retvalArr[37]; //���Ҽ�⼼�������������
	objSheet.Cells(29,9).value=retvalArr[48]; //�¼�֮���Ƿ���к�����Ⱥ�˳��
	objSheet.Cells(31,2).value=retvalArr[18]; //��Ʒ����
	objSheet.Cells(31,9).value=retvalArr[49]; //�¼��Ƿ�������ʹ��ҽ����е���ܵ��µ��˺�����
	objSheet.Cells(32,2).value=retvalArr[19]; //��Ʒ����
	objSheet.Cells(33,2).value=retvalArr[20]; //ע��֤��
	objSheet.Cells(33,9).value=retvalArr[50]; //�¼��Ƿ�����úϲ���ҩ�����á����߲����������ҽ����е����������
	objSheet.Cells(34,2).value=retvalArr[21]; //������ҵ����
	objSheet.Cells(35,2).value=retvalArr[22]; //������ҵ��ַ
	objSheet.Cells(36,8).value=retvalArr[51]; //���������۽��

	objSheet.Cells(37,2).value=retvalArr[38]; //������ְ��
	objSheet.Cells(37,4).value=retvalArr[39]; //������
	objSheet.Cells(37,7).value=retvalArr[41]; //�������
	objSheet.Cells(38,2).value=retvalArr[42]; //��������ϵ�绰
	objSheet.Cells(38,7).value=retvalArr[43]; //����	
	xlBook.SaveAs(filePath+retvalArr[1]+".xls");
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
	
}

