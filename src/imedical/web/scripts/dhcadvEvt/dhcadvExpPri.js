
var Doclen=0, Apolen=0, DAlen=0, Displen=0, DADilen=0, Nuslen=0, DADiNulen=0,DADiNuPalen=0;
var DocList="", ApoList="",DispList="",NurList="",PatList="";
// ����Excel
function ExportExcel(ID,TypeCode,filePath)
{
	if(ID==""){
		$.messager.alert("��ʾ:","����IDΪ�գ�");
		return;
	}
	if(TypeCode=="material"){
		var retval=tkMakeServerCall("web.DHCADVMEDREPORT","getMataRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("��ʾ:","ȡ���ݴ���");
			return;
		}
		//DHCADV_MedsReport .xls
		var retvalArr=retval.split("&&");
		//1����ȡXLS����·��
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_MataReport.xls";
	
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
		objSheet.Cells(29,9).value=retvalArr[48]; //�¼�֮���Ƿ���к������Ⱥ�˳��
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
	if(TypeCode=="drugerr"){
		var retval=tkMakeServerCall("web.DHCADVMEDSAREPORT","getMedsRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("��ʾ:","ȡ���ݴ���");
			return;
		}
		//DHCADV_MedsReport .xls
		var retvalArr=retval.split("&&");
		//1����ȡXLS����·��
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_MedsReport.xls";
	
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		var OccDate=retvalArr[4]
		var SelDateArr="",SelYear="",SelMonth="",SelDate="";
		if(DateFormat=="4"){ //���ڸ�ʽ 4:"DMY" DD/MM/YYYY
			SelDateArr=OccDate.split("/");
			SelYear=SelDateArr[2];
			SelMonth=parseInt(SelDateArr[1])-1;
			SelDate=parseInt(SelDateArr[0]);
		}else if(DateFormat=="3"){ //���ڸ�ʽ 3:"YMD" YYYY-MM-DD
			SelDateArr=OccDate.split("-");
			SelYear=SelDateArr[0];
			SelMonth=parseInt(SelDateArr[1])-1;
			SelDate=parseInt(SelDateArr[2]);
		}else if(DateFormat=="1"){ //���ڸ�ʽ 1:"MDY" MM/DD/YYYY
			SelDateArr=OccDate.split("/");
			SelYear=SelDateArr[2];
			SelMonth=parseInt(SelDateArr[0])-1;
			SelDate=parseInt(SelDateArr[1]);
		}
		var dt = new Date(SelYear,SelMonth,SelDate), dt2 = new Date();
		var weekDay = ["������", "����һ", "���ڶ�", "������", "������", "������", "������"];
		var weekday=weekDay[dt.getDay()];
		objSheet.Cells(2,2).value=retvalArr[19]; //�������
		objSheet.Cells(2,7).value=retvalArr[2]+" "+retvalArr[3]; //��������
		objSheet.Cells(3,2).value=retvalArr[4]+" "+retvalArr[5]; //��������
		objSheet.Cells(3,7).value=weekday; //����
		objSheet.Cells(3,9).value=retvalArr[6]; //���
		
		objSheet.Cells(4,2).value=retvalArr[8]; //����ID
		objSheet.Cells(4,7).value=retvalArr[7]; //���˲�����
		objSheet.Cells(5,2).value=retvalArr[9]; //��������
		objSheet.Cells(5,7).value=retvalArr[10]; //�����Ա�
		objSheet.Cells(5,9).value=retvalArr[11]; //��������
		
		objSheet.Cells(6,2).value=retvalArr[12]; //Ӧ��ҩ��
		objSheet.Cells(6,7).value=retvalArr[13]; //ҩ�����
		objSheet.Cells(6,9).value=retvalArr[17]; //�ۼƸ�ҩ�������
		
		var MULtmpStr=retvalArr[22];  //������Ϣ
		var tmpStr=MULtmpStr.split("!!");
		for (i=0;i<tmpStr.length;i++){
			var tmpList=tmpStr[i].split("&");
			if(tmpList[0]=="DocL"){ //ҽ������
				DocList=tmpList;
			}else if(tmpList[0]=="ApoL"){
				ApoList=tmpList;
			}else if(tmpList[0]=="DispL"){
				DispList=tmpList;
			}else if(tmpList[0]=="NurL"){
				NurList=tmpList;
			}else if(tmpList[0]=="PatL"){
				PatList=tmpList;
			}	
		}
		//ҽ������		
		xlApp.Range(xlApp.Cells(8,1),xlApp.Cells(8,9)).MergeCells = true; //�ϲ���Ԫ��
		objSheet.Cells(8,1).value="ҽ������";
		objSheet.Cells(8,1).Interior.Pattern = 2;  //���õ�Ԫ�񱳾���ʽ*(1-�ޣ�2-ϸ����3-������4-�ߵ㣬5-���ߣ�6-����..)
		objSheet.Cells(9,1).value="�Ƿ�ѡ��";
		objSheet.Cells(9,2).value="����";
		xlApp.Range(xlApp.Cells(9,3),xlApp.Cells(9,6)).MergeCells = true;  //�ϲ���Ԫ��
		objSheet.Cells(9,3).value="����";
		objSheet.Cells(9,7).value="Ӧ����";
		objSheet.Cells(9,8).value="������";
		objSheet.Cells(9,9).value="����";
		
		Doclen=DocList.length-1;
		for(var k=1;k<=Doclen;k++){
			var MULIDoArr=DocList[k].split("^");
			objSheet.Cells(9+k,1).value=MULIDoArr[0]; //�Ƿ�ѡ��
			objSheet.Cells(9+k,2).value=MULIDoArr[2]; //����
			xlApp.Range(xlApp.Cells(9+k,3),xlApp.Cells(9+k,6)).MergeCells = true;  //�ϲ���Ԫ��
			objSheet.Cells(9+k,3).value=MULIDoArr[3]; //����
			objSheet.Cells(9+k,7).value=MULIDoArr[5]; //Ӧ����
			objSheet.Cells(9+k,7).WrapText=true;  
			objSheet.Cells(9+k,8).value=MULIDoArr[6]; //������
			objSheet.Cells(9+k,8).WrapText=true;  
			objSheet.Cells(9+k,9).value=MULIDoArr[7]; //����
		}
		
		//ҩʦ����		
		xlApp.Range(xlApp.Cells(10+Doclen+3,1),xlApp.Cells(10+Doclen+3,9)).MergeCells = true;
		objSheet.Cells(10+Doclen+3,1).value="ҩʦ����";
		objSheet.Cells(10+Doclen+3,1).Interior.Pattern = 2; 
		objSheet.Cells(10+Doclen+4,1).value="�Ƿ�ѡ��";
		objSheet.Cells(10+Doclen+4,2).value="����";
		xlApp.Range(xlApp.Cells(10+Doclen+4,3),xlApp.Cells(10+Doclen+4,6)).MergeCells = true;
		objSheet.Cells(10+Doclen+4,3).value="����";
		objSheet.Cells(10+Doclen+4,7).value="Ӧ����";
		objSheet.Cells(10+Doclen+4,8).value="������";
		objSheet.Cells(10+Doclen+4,9).value="����";
		
		Apolen=ApoList.length-1;
		for(var k=1;k<=Apolen;k++){
			var MULIApArr=ApoList[k].split("^");
			objSheet.Cells(10+Doclen+4+k,1).value=MULIApArr[0]; //�Ƿ�ѡ��
			objSheet.Cells(10+Doclen+4+k,2).value=MULIApArr[2]; //����
			xlApp.Range(xlApp.Cells(10+Doclen+4+k,3),xlApp.Cells(10+Doclen+4+k,6)).MergeCells = true;
			objSheet.Cells(10+Doclen+4+k,3).value=MULIApArr[3]; //����
			objSheet.Cells(10+Doclen+4+k,7).value=MULIApArr[5]; //Ӧ����
			objSheet.Cells(10+Doclen+4+k,7).WrapText=true;  
			objSheet.Cells(10+Doclen+4+k,8).value=MULIApArr[6]; //������
			objSheet.Cells(10+Doclen+4+k,8).WrapText=true;  
			objSheet.Cells(10+Doclen+4+k,9).value=MULIApArr[7]; //����
		}
		DAlen=Doclen+Apolen;
		
		//���ͻ���		
		xlApp.Range(xlApp.Cells(10+DAlen+8,1),xlApp.Cells(10+DAlen+8,9)).MergeCells = true;
		objSheet.Cells(10+DAlen+8,1).value="���ͻ���";
		objSheet.Cells(10+DAlen+8,1).Interior.Pattern = 2; 
		objSheet.Cells(10+DAlen+9,1).value="�Ƿ�ѡ��";
		objSheet.Cells(10+DAlen+9,2).value="����";
		xlApp.Range(xlApp.Cells(10+DAlen+9,3),xlApp.Cells(10+DAlen+9,6)).MergeCells = true;
		objSheet.Cells(10+DAlen+9,3).value="����";
		objSheet.Cells(10+DAlen+9,7).value="Ӧ����";
		objSheet.Cells(10+DAlen+9,8).value="������";
		objSheet.Cells(10+DAlen+9,9).value="����";

		Displen=DispList.length-1;
		for(var k=1;k<=Displen;k++){
			var MULIDiArr=DispList[k].split("^");
			objSheet.Cells(10+DAlen+9+k,1).value=MULIDiArr[0]; //�Ƿ�ѡ��
			objSheet.Cells(10+DAlen+9+k,2).value=MULIDiArr[2]; //����
			xlApp.Range(xlApp.Cells(10+DAlen+9+k,3),xlApp.Cells(10+DAlen+9+k,6)).MergeCells = true;
			objSheet.Cells(10+DAlen+9+k,3).value=MULIDiArr[3]; //����
			objSheet.Cells(10+DAlen+9+k,7).value=MULIDiArr[5]; //Ӧ����
			objSheet.Cells(10+DAlen+9+k,7).WrapText=true;  
			objSheet.Cells(10+DAlen+9+k,8).value=MULIDiArr[6]; //������
			objSheet.Cells(10+DAlen+9+k,8).WrapText=true;  
			objSheet.Cells(10+DAlen+9+k,9).value=MULIDiArr[7]; //����
		}
		DADilen=DAlen+Displen;
		
		//��ʿ����		
		xlApp.Range(xlApp.Cells(10+DADilen+11,1),xlApp.Cells(10+DADilen+11,9)).MergeCells = true;
		objSheet.Cells(10+DADilen+11,1).value="��ʿ����";
		objSheet.Cells(10+DADilen+11,1).Interior.Pattern = 2; 
		objSheet.Cells(10+DADilen+12,1).value="�Ƿ�ѡ��";
		objSheet.Cells(10+DADilen+12,2).value="����";
		xlApp.Range(xlApp.Cells(10+DADilen+12,3),xlApp.Cells(10+DADilen+12,6)).MergeCells = true;
		objSheet.Cells(10+DADilen+12,3).value="����";
		objSheet.Cells(10+DADilen+12,7).value="Ӧ����";
		objSheet.Cells(10+DADilen+12,8).value="������";
		objSheet.Cells(10+DADilen+12,9).value="����";

		Nuslen=NurList.length-1;
		for(var k=1;k<=Nuslen;k++){
			var MULINuArr=NurList[k].split("^");
			objSheet.Cells(10+DADilen+12+k,1).value=MULINuArr[0]; //�Ƿ�ѡ��
			objSheet.Cells(10+DADilen+12+k,2).value=MULINuArr[2]; //����
			xlApp.Range(xlApp.Cells(10+DADilen+12+k,3),xlApp.Cells(10+DADilen+12+k,6)).MergeCells = true;
			objSheet.Cells(10+DADilen+12+k,3).value=MULINuArr[3]; //����
			objSheet.Cells(10+DADilen+12+k,7).value=MULINuArr[5]; //Ӧ����
			objSheet.Cells(10+DADilen+12+k,7).WrapText=true;  
			objSheet.Cells(10+DADilen+12+k,8).value=MULINuArr[6]; //������
			objSheet.Cells(10+DADilen+12+k,8).WrapText=true;  
			objSheet.Cells(10+DADilen+12+k,9).value=MULINuArr[7]; //����
		}
		DADiNulen=DADilen+Nuslen;
		
		//���߻���		
		xlApp.Range(xlApp.Cells(10+DADiNulen+16,1),xlApp.Cells(10+DADiNulen+16,9)).MergeCells = true;
		objSheet.Cells(10+DADiNulen+16,1).value="���߻���";
		objSheet.Cells(10+DADiNulen+16,1).Interior.Pattern = 2; 
		objSheet.Cells(10+DADiNulen+17,1).value="�Ƿ�ѡ��";
		objSheet.Cells(10+DADiNulen+17,2).value="����";
		xlApp.Range(xlApp.Cells(10+DADiNulen+17,3),xlApp.Cells(10+DADiNulen+17,6)).MergeCells = true;
		objSheet.Cells(10+DADiNulen+17,3).value="����";
		objSheet.Cells(10+DADiNulen+17,7).value="Ӧ����";
		objSheet.Cells(10+DADiNulen+17,8).value="������";
		objSheet.Cells(10+DADiNulen+17,9).value="����";

		var Patlen=PatList.length-1;
		for(var k=1;k<=Patlen;k++){
			var MULIPaArr=PatList[k].split("^");
			objSheet.Cells(10+DADiNulen+17+k,1).value=MULIPaArr[0]; //�Ƿ�ѡ��
			objSheet.Cells(10+DADiNulen+17+k,2).value=MULIPaArr[2]; //����
			xlApp.Range(xlApp.Cells(10+DADiNulen+17+k,3),xlApp.Cells(10+DADiNulen+17+k,6)).MergeCells = true;
			objSheet.Cells(10+DADiNulen+17+k,3).value=MULIPaArr[3]; //����
			objSheet.Cells(10+DADiNulen+17+k,7).value=MULIPaArr[5]; //Ӧ����
			objSheet.Cells(10+DADiNulen+17+k,7).WrapText=true;  
			objSheet.Cells(10+DADiNulen+17+k,8).value=MULIPaArr[6]; //������
			objSheet.Cells(10+DADiNulen+17+k,8).WrapText=true;  
			objSheet.Cells(10+DADiNulen+17+k,9).value=MULIPaArr[7]; //����
		}
		DADiNuPalen=DADiNulen+Patlen;
		
		//����ҽ����ҩʦ����ʿ��Ϣ
		var MedsRepLinkList=retvalArr[21];  
		var RepLinkList=MedsRepLinkList.split("&");
		for (i=0;i<RepLinkList.length;i++){
			var messList=RepLinkList[i].split("^");
			var medsrMes=""
			if (messList[4]=="DocL"){
				xlApp.Range(xlApp.Cells(10+Doclen+1,1),xlApp.Cells(10+Doclen+1,2)).MergeCells = true;
				objSheet.Cells(10+Doclen+1,1).value="����ҽ����Ϣ��";
				xlApp.Range(xlApp.Cells(10+Doclen+1,3),xlApp.Cells(10+Doclen+1,9)).MergeCells = true;
				if(messList[1]==10){
					medsrMes="��ʽҽ��";
				}else if(messList[1]==11){
					medsrMes="�о���";
				}else if(messList[1]==12){
					medsrMes="����ҽ��";
				}
				objSheet.Cells(10+Doclen+1,3).value=medsrMes+" "+messList[2]+" "+messList[3];  //����ҽ����Ϣ
			}else if(messList[4]=="ApoL"){
				xlApp.Range(xlApp.Cells(10+DAlen+6,1),xlApp.Cells(10+DAlen+6,2)).MergeCells = true;
				objSheet.Cells(10+DAlen+6,1).value="����ҩʦ��Ϣ��";
				xlApp.Range(xlApp.Cells(10+DAlen+6,3),xlApp.Cells(10+DAlen+6,9)).MergeCells = true;
				if(messList[1]==20){
					medsrMes="��ʽҩʦ";
				}else if(messList[1]==21){
					medsrMes="ʵϰ��";
				}else if(messList[1]==22){
					medsrMes="����ҩʦ";
				}
				objSheet.Cells(10+DAlen+6,3).value=medsrMes+" "+messList[2]+" "+messList[3]; //����ҩʦ��Ϣ
			}else if(messList[4]=="NurL"){
				xlApp.Range(xlApp.Cells(10+DADiNulen+14,1),xlApp.Cells(10+DADiNulen+14,2)).MergeCells = true;
				objSheet.Cells(10+DADiNulen+14,1).value="���»�ʿ��Ϣ��";
				xlApp.Range(xlApp.Cells(10+DADiNulen+14,3),xlApp.Cells(10+DADiNulen+14,9)).MergeCells = true;
				objSheet.Cells(10+DADiNulen+14,3).value=retvalArr[27]+" "+retvalArr[28]+" "+retvalArr[29]; //���»�ʿ��Ϣ
				if(messList[1]==30){
					medsrMes="��ʽ��ʿ";
				}else if(messList[1]==31){
					medsrMes="ʵϰ��";
				}else if(messList[1]==32){
					medsrMes="���޻�ʿ";
				}
				objSheet.Cells(10+DADiNulen+14,3).value=medsrMes+" "+messList[2]+" "+messList[3]; //���»�ʿ��Ϣ
			}
		}
		
		xlApp.Range(8+":"+(10+DADiNuPalen+18)).HorizontalAlignment = 2; 
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+19,1),xlApp.Cells(10+DADiNuPalen+19,9)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+19,1).Font.Size = 16; //����Ϊ16����
		objSheet.Cells(10+DADiNuPalen+19,1).Font.Name = "����"; 
		objSheet.Cells(10+DADiNuPalen+19,1).Font.Bold = true; //����Ϊ����
		objSheet.Cells(10+DADiNuPalen+19,1).value="�����"; 
		
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+20,1),xlApp.Cells(10+DADiNuPalen+20,9)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+20,1).value=retvalArr[23]+retvalArr[24]; //���
		
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+21,1),xlApp.Cells(10+DADiNuPalen+21,9)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+21,1).Font.Size = 16; //����Ϊ16����
		objSheet.Cells(10+DADiNuPalen+21,1).Font.Name = "����"; 
		objSheet.Cells(10+DADiNuPalen+21,1).Font.Bold = true; //����Ϊ����
		objSheet.Cells(10+DADiNuPalen+21,1).value="��ʱ�ж�/��Ԥ��"; 
		
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+22,1),xlApp.Cells(10+DADiNuPalen+27,9)).MergeCells = true;
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+22,1),xlApp.Cells(10+DADiNuPalen+27,9)).WrapText=true; //�Զ�����
		objSheet.Cells(10+DADiNuPalen+22,1).value=retvalArr[14];  //��ʱ�ж�����Ԥ
		
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+28,1),xlApp.Cells(10+DADiNuPalen+28,4)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+28,1).value="������ң�"+retvalArr[1];
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+28,6),xlApp.Cells(10+DADiNuPalen+28,7)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+28,6).value="������������"+retvalArr[15];
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+28,8),xlApp.Cells(10+DADiNuPalen+28,9)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+28,8).value="������ְ�ƣ�"+retvalArr[16]; //������ְ��
					
		
		xlBook.SaveAs(filePath+retvalArr[19]+".xls");
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;
	}
	if(TypeCode=="blood"){
		var retval=tkMakeServerCall("web.DHCADVBLDREPORT","getBldRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("��ʾ:","ȡ���ݴ���");
			return;
		}
		//DHCADV_MedsReport .xls
		var retvalArr=retval.split("&&");
		//1����ȡXLS��ӡ·��
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_BloodReport.xls";
	
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		
		objSheet.Cells(2,2).value=retvalArr[3]; //�������
		objSheet.Cells(2,6).value=retvalArr[4]+" "+retvalArr[5]; //��������
		objSheet.Cells(3,2).value=retvalArr[6]; //����
		objSheet.Cells(3,6).value=retvalArr[1]; //����
		
		objSheet.Cells(5,1).Interior.Pattern = 2; 
		objSheet.Cells(6,2).value=retvalArr[9]; //����ID
		objSheet.Cells(6,5).value=retvalArr[8]; //���˲�����
		objSheet.Cells(7,2).value=retvalArr[10]; //��������
		objSheet.Cells(7,5).value=retvalArr[11]; //�����Ա�
		objSheet.Cells(7,8).value=retvalArr[12]; //��������
		objSheet.Cells(8,2).value=retvalArr[13]; //��������
		objSheet.Cells(8,5).value=retvalArr[14]; //����֤��
		objSheet.Cells(9,3).value=retvalArr[51]; //�������/��������
		
		objSheet.Cells(10,8).value=retvalArr[15]; //�в�ʷ
		objSheet.Cells(10,2).value=retvalArr[16]; //������Ѫʷ
		objSheet.Cells(10,5).value=retvalArr[17]; //��Ѫ��Ӧʷ
		objSheet.Cells(11,3).value=retvalArr[18]; //��ѪǰѪ�ͼ����
		objSheet.Cells(11,5).value=retvalArr[19]; //������
		objSheet.Cells(11,8).value=retvalArr[20]; //���⿹��ɸ�飨�����ԣ�
		objSheet.Cells(12,3).value=retvalArr[21]; //������ע��ѪҺ��Ϣ
		objSheet.Cells(12,5).value=retvalArr[22]; //������
		objSheet.Cells(13,2).value=retvalArr[23]; //��עѪ��
		objSheet.Cells(14,1).Interior.Pattern = 2; 
		var bldrptBldType=retvalArr[50];  //��������
		var BldTypeArr=bldrptBldType.split("&");
		var BldTypelen=BldTypeArr.length;
		for(var k=0;k<BldTypelen;k++){
			var BldType=BldTypeArr[k].split("^");
			objSheet.Cells(16+k,1).value=BldType[1]; //��Ѫ���
			xlApp.Range(xlApp.Cells(15+k,2),xlApp.Cells(15+k,3)).MergeCells = true;
			objSheet.Cells(16+k,2).value=BldType[3]; //��Ѫ���1
			objSheet.Cells(16+k,4).value=BldType[4]; //��Ѫ���2
			objSheet.Cells(16+k,5).value=BldType[5]; //��Ѫ���3
			xlApp.Range(xlApp.Cells(16+k,6),xlApp.Cells(16+k,7)).MergeCells = true;
			objSheet.Cells(16+k,6).value=BldType[6]; //��Ѫ���1
		}
		
		xlApp.Range(xlApp.Cells(16+BldTypelen,1),xlApp.Cells(16+BldTypelen,8)).MergeCells = true;
		objSheet.Cells(16+BldTypelen,1).value="��Ѫ������Ӧ����";
		objSheet.Cells(16+BldTypelen,1).Font.Size = 12; //����Ϊ12����
		objSheet.Cells(16+BldTypelen,1).Font.Name = "����"; 
		objSheet.Cells(16+BldTypelen,1).Font.Bold = true; //����Ϊ����
		objSheet.Cells(16+BldTypelen,1).Interior.Pattern = 2; 
		xlApp.Range(xlApp.Cells(17+BldTypelen,1),xlApp.Cells(17+BldTypelen,4)).MergeCells = true;
		xlApp.Range(xlApp.Cells(17+BldTypelen,5),xlApp.Cells(17+BldTypelen,8)).MergeCells = true;
		objSheet.Cells(17+BldTypelen,1).value="��������";
		objSheet.Cells(17+BldTypelen,5).value="�ٴ�֢״";
		
		
		var bldrptBldBasA=retvalArr[48];  //��������
		var BldBasArr=bldrptBldBasA.split("&");
		var BldBasAlen=BldBasArr.length;
		var BBasAlen=Math.ceil(BldBasAlen/2);
		for(var k=0;k<BBasAlen;k++){
			var BldB=BldBasArr[k].split("^");
			xlApp.Range(xlApp.Cells(18+BldTypelen+k,1),xlApp.Cells(18+BldTypelen+k,2)).MergeCells = true;
			objSheet.Cells(18+BldTypelen+k,1).value=BldB[0]+" "+BldB[1]; //�Ƿ�ѡ��
 			var i=BBasAlen+k;
 			if(i<BldBasAlen){
				var BldBi=BldBasArr[i].split("^");
				xlApp.Range(xlApp.Cells(18+BldTypelen+k,3),xlApp.Cells(18+BldTypelen+k,4)).MergeCells = true;
				objSheet.Cells(18+BldTypelen+k,3).value=BldBi[0]+" "+BldBi[1]; //����
			}
		}
		var bldrptBldBasB=retvalArr[49];  //�ٴ�֢״
		var BldBasBArr=bldrptBldBasB.split("&");
		var BldBasBlen=BldBasBArr.length;
		var BBasBlen=Math.ceil(BldBasBlen/2) ;
		for(var k=0;k<BBasBlen;k++){
			var BldB=BldBasBArr[k].split("^");
			xlApp.Range(xlApp.Cells(18+BldTypelen+k,5),xlApp.Cells(18+BldTypelen+k,6)).MergeCells = true;
			objSheet.Cells(18+BldTypelen+k,5).value=BldB[0]+" "+BldB[1]; //�Ƿ�ѡ��
 			var j=BBasBlen+k;
 			if(j<BldBasBlen){
				var BldBj=BldBasBArr[j].split("^");
				xlApp.Range(xlApp.Cells(18+BldTypelen+k,7),xlApp.Cells(18+BldTypelen+k,8)).MergeCells = true;
				objSheet.Cells(18+BldTypelen+k,7).value=BldBj[0]+" "+BldBj[1]; //����
			}
		}
		if(BBasAlen>BBasBlen){
			BBasBlen=BBasAlen;
		}
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen,1),xlApp.Cells(18+BldTypelen+BBasBlen,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen,1).Font.Size = 12; //����Ϊ12����
		objSheet.Cells(18+BldTypelen+BBasBlen,1).Font.Name = "����"; 
		objSheet.Cells(18+BldTypelen+BBasBlen,1).Font.Bold = true; //����Ϊ����
		objSheet.Cells(18+BldTypelen+BBasBlen,1).Interior.Pattern = 2; 
		objSheet.Cells(18+BldTypelen+BBasBlen,1).value="������������"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,1).value="���£�"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,2).value=retvalArr[24]; //����
		objSheet.Cells(18+BldTypelen+BBasBlen+1,3).value="Ѫѹ��"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,4).value=retvalArr[25]; //Ѫѹ
		objSheet.Cells(18+BldTypelen+BBasBlen+1,5).value="������"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,6).value=retvalArr[26]; //����
		objSheet.Cells(18+BldTypelen+BBasBlen+1,7).value="����Ƶ�Σ�"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,8).value=retvalArr[27]; //����Ƶ��
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+2,1),xlApp.Cells(18+BldTypelen+BBasBlen+2,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+2,1).value="��ѪǰԤ����ҩ��"; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+2,3),xlApp.Cells(18+BldTypelen+BBasBlen+2,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+2,3).value=retvalArr[28]+" "+retvalArr[29];  //��ѪǰԤ����ҩ
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+3,1),xlApp.Cells(18+BldTypelen+BBasBlen+3,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+3,1).value="������Ѫ��ʼʱ�䣺"; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+3,3),xlApp.Cells(18+BldTypelen+BBasBlen+3,4)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+3,3).value=retvalArr[30]+" "+retvalArr[31]; //������Ѫ��ʼʱ��
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+3,6),xlApp.Cells(18+BldTypelen+BBasBlen+3,7)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+3,6).value="�����߹��ţ�"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+3,8).value=retvalArr[32]; //�����߹���
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+4,1),xlApp.Cells(18+BldTypelen+BBasBlen+4,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+4,1).value="��Ѫ��Ӧ����ʱ�䣺"; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+4,3),xlApp.Cells(18+BldTypelen+BBasBlen+4,4)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+4,3).value=retvalArr[33]+" "+retvalArr[34]; //��Ѫ��Ӧ����ʱ��
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+4,6),xlApp.Cells(18+BldTypelen+BBasBlen+4,7)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+4,6).value="�����߹��ţ�"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+4,8).value=retvalArr[35]; //�����߹���
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+5,1),xlApp.Cells(18+BldTypelen+BBasBlen+5,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+5,1).value="��Ѫ������/���ţ�"; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+5,3),xlApp.Cells(18+BldTypelen+BBasBlen+5,5)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+5,3).value=retvalArr[36]; //��Ѫ������/����
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+5,6),xlApp.Cells(18+BldTypelen+BBasBlen+5,7)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+5,6).value="ʣ��Ѫ��(ml)��"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+5,8).value=retvalArr[37]; //ʣ��Ѫ��
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+6,1),xlApp.Cells(18+BldTypelen+BBasBlen+6,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+6,1).value="���س̶ȣ�"; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+6,3),xlApp.Cells(18+BldTypelen+BBasBlen+6,5)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+6,3).value=retvalArr[39]; //���س̶�
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+6,6),xlApp.Cells(18+BldTypelen+BBasBlen+6,7)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+6,6).value="����ԣ�"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+6,8).value=retvalArr[40]; //�����
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+7,1),xlApp.Cells(18+BldTypelen+BBasBlen+7,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+7,1).value="��Ѫ������Ӧ���"; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+7,3),xlApp.Cells(18+BldTypelen+BBasBlen+7,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+7,3).value=retvalArr[38]; //��Ѫ������Ӧ����
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+8,1),xlApp.Cells(18+BldTypelen+BBasBlen+8,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).Font.Size = 12; //����Ϊ12����
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).Font.Name = "����"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).Font.Bold = true; //����Ϊ����
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).Interior.Pattern = 2; 
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).value="�ٴ����ã�"; 
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+9,1),xlApp.Cells(18+BldTypelen+BBasBlen+12,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+9,1).value=retvalArr[41]; //�ٴ�����
		
		objSheet.Cells(18+BldTypelen+BBasBlen+13,1).value="����ת�飺"; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+13,2),xlApp.Cells(18+BldTypelen+BBasBlen+13,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+13,2).value=retvalArr[42]+" "+retvalArr[43]+" "+retvalArr[44];  //����ת��
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+14,1),xlApp.Cells(18+BldTypelen+BBasBlen+14,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+14,1).value="����Ѫ����ԣ�"; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+14,3),xlApp.Cells(18+BldTypelen+BBasBlen+14,4)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+14,3).value=retvalArr[45]; //����Ѫ�����
	
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+15,5),xlApp.Cells(18+BldTypelen+BBasBlen+15,6)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+15,5).value="������ǩ����"; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+15,7),xlApp.Cells(18+BldTypelen+BBasBlen+15,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+15,7).value=retvalArr[2]; //���

		
		xlBook.SaveAs(filePath+retvalArr[3]+".xls");
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;
	}
	if(TypeCode=="drug"){
		var retval=tkMakeServerCall("web.DHCADVMADRREPORT","getMadrRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("��ʾ:","ȡ���ݴ���");
			return;
		}
		//DHCADV_MedsReport .xls
		var retvalArr=retval.split("&&");
		//1����ȡXLS��ӡ·��
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_DrugReport.xls";
	
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		/*
		objSheet.Cells(2,2).value=retvalArr[0]+" "+retvalArr[1]; //��������
		objSheet.Cells(2,7).value=retvalArr[2]; //�������
	
		objSheet.Cells(3,2).value=retvalArr[3]; //����ID
		objSheet.Cells(3,5).value=retvalArr[4]; //�Ա�
		objSheet.Cells(3,7).value=retvalArr[5]; //����
		objSheet.Cells(3,9).value=retvalArr[6]; //��������
		objSheet.Cells(4,2).value=retvalArr[7]; //��������
		objSheet.Cells(4,4).value=retvalArr[8]; //������
		objSheet.Cells(4,7).value=retvalArr[9]+" "+"Kg"; //����
		objSheet.Cells(4,9).value=retvalArr[10]; //��ϵ��ʽ
		objSheet.Cells(5,2).value=retvalArr[11]; //����ҩƷ������Ӧ/�¼�
		objSheet.Cells(5,3).value=retvalArr[12]; //����ҩƷ������Ӧ/�¼�����
		
		objSheet.Cells(5,7).value=retvalArr[13]; //����ҩƷ������Ӧ/�¼�
		objSheet.Cells(5,8).value=retvalArr[14]; //����ҩƷ������Ӧ/�¼�����
		objSheet.Cells(6,3).value=retvalArr[15]; //�����Ҫ��Ϣ
		objSheet.Cells(6,9).value=retvalArr[30]; //�����Ҫ��Ϣ����
		objSheet.Cells(8,1).value=retvalArr[16]; //������Ӧ/�¼���������
		objSheet.Cells(13,4).value=retvalArr[17]+" "+retvalArr[18]; //������Ӧ/�¼�����ʱ��
		objSheet.Cells(14,3).value=retvalArr[19]; //������Ӧ/�¼��Ľ��
	    objSheet.Cells(14,6).value=retvalArr[20];   //�¼��Ľ������
	    objSheet.Cells(14,9).value=retvalArr[21]+" "+retvalArr[22];   //����ʱ��
		objSheet.Cells(15,3).value=retvalArr[23]; //��ϵ�˵绰
		objSheet.Cells(15,6).value=retvalArr[24]; //ְҵ
		objSheet.Cells(15,9).value=retvalArr[25]; //����
		
		objSheet.Cells(16,3).value=retvalArr[26]; //��������
		objSheet.Cells(16,6).value=retvalArr[27]; //ǩ��
		objSheet.Cells(16,8).value=retvalArr[28]; //���沿��
		objSheet.Cells(17,2).value=retvalArr[29]; //��ע*/
		
		objSheet.Cells(2,2).value=retvalArr[0]; //����״̬
		objSheet.Cells(2,9).value=retvalArr[1]; //���
		objSheet.Cells(3,2).value=retvalArr[2]+" "+retvalArr[3]+""+retvalArr[4]; //����
		objSheet.Cells(3,7).value=retvalArr[5]+retvalArr[6]; //���浥λ���
		objSheet.Cells(4,2).value=retvalArr[7]; //��������
		objSheet.Cells(4,4).value=retvalArr[8]; //�Ա�
		objSheet.Cells(4,6).value=retvalArr[9]; //��������
		objSheet.Cells(4,8).value=retvalArr[10]; //����
		if(retvalArr[11]!=""){
		  objSheet.Cells(4,10).value=retvalArr[11]+" "+"Kg"; //����
		}else{
		  objSheet.Cells(4,10).value=retvalArr[11]; //����
		}
		objSheet.Cells(4,12).value=retvalArr[12]; //��ϵ��ʽ
		objSheet.Cells(5,2).value=retvalArr[13]; //ԭ������
		objSheet.Cells(5,5).value=retvalArr[14]; //ҽԺ����
		objSheet.Cells(5,9).value=retvalArr[15]+retvalArr[16]; //����ҩƷ������Ӧ/�¼�
		objSheet.Cells(6,5).value=retvalArr[17]; //������/�����
		objSheet.Cells(6,9).value=retvalArr[18]+retvalArr[19]; //����ҩƷ������Ӧ/�¼�
		objSheet.Cells(7,2).value=retvalArr[20]+retvalArr[21]; //�����Ҫ��Ϣ
		objSheet.Cells(8,3).value=retvalArr[22];  //������Ӧ/�¼�����
		objSheet.Cells(8,10).value=retvalArr[23]+"  "+retvalArr[24]; //������Ӧ/�¼�����ʱ��
		objSheet.Cells(10,1).value=retvalArr[25]; //������Ӧ/�¼���������
		objSheet.Cells(11,3).value=retvalArr[26]; //������Ӧ/�¼��Ľ��
		objSheet.Cells(11,7).value=retvalArr[27]; //����/ֱ������
		objSheet.Cells(11,11).value=retvalArr[28]+"  "+retvalArr[29]; //����ʱ��
		objSheet.Cells(12,5).value=retvalArr[30]; //ͣҩ������󣬷�Ӧ/�¼��Ƿ���ʧ����᣿
		objSheet.Cells(13,5).value=retvalArr[31]; //�ٴ�ʹ�ÿ���ҩƷ���Ƿ��ٴγ���ͬ����Ӧ/�¼�
		objSheet.Cells(14,5).value=retvalArr[32]; //��ԭ��������Ӱ��
		objSheet.Cells(15,3).value=retvalArr[33]; //����������
		objSheet.Cells(15,11).value=retvalArr[34]; //ǩ��
		objSheet.Cells(16,3).value=retvalArr[35];  //���浥λ����
		objSheet.Cells(16,11).value=retvalArr[36]; //ǩ��
		objSheet.Cells(17,3).value=retvalArr[37]; //��ϵ�绰
		objSheet.Cells(17,11).value=retvalArr[38]+retvalArr[39]; //ְҵ
		objSheet.Cells(18,3).value=retvalArr[40]; //��������
		objSheet.Cells(18,6).value=retvalArr[41]; //ǩ��
		objSheet.Cells(18,11).value=retvalArr[42]; //���沿��
		objSheet.Cells(19,3).value=retvalArr[43]; //��λ����
		objSheet.Cells(19,6).value=retvalArr[44]; //��ϵ��
		objSheet.Cells(19,8).value=retvalArr[45]; //�绰
		objSheet.Cells(19,11).value=retvalArr[46]+"  "+retvalArr[47]; //��������
		objSheet.Cells(20,2).value=retvalArr[48]; //��ע
	   xlApp.Range(objSheet.Cells(22,1),objSheet.Cells(22,12)).Interior.Pattern = 2; //ҩƷ�б����ⱳ����ɫ
	   	var advRepDrgItmList=retvalArr[49];  //ҩƷ�б�

	   var advRepDrgItmArr=advRepDrgItmList.split("||");
	    for(var k=0;k<advRepDrgItmArr.length;k++){
		var drgItmArr=advRepDrgItmArr[k].split("^");
		objSheet.Cells(23+k,1).value=drgItmArr[0]; //����
		objSheet.Cells(23+k,2).value="'"+drgItmArr[1]; //��׼�ĺ�
		objSheet.Cells(23+k,3).value=drgItmArr[3]; //��Ʒ����
		objSheet.Cells(23+k,4).value=drgItmArr[8]; //ͨ����
		objSheet.Cells(23+k,6).value=drgItmArr[5]; //����
		objSheet.Cells(23+k,7).value="'"+drgItmArr[17]; //����
		objSheet.Cells(23+k,8).value="'"+drgItmArr[9]; //�÷�����
		objSheet.Cells(23+k,9).value="'"+drgItmArr[13]; //��ʼʱ��
		objSheet.Cells(23+k,11).value="'"+drgItmArr[14]; //����ʱ��
		objSheet.Cells(23+k,12).value="'"+drgItmArr[16]; //��ҩԭ��
	}  
        
		
		xlBook.SaveAs(filePath+retvalArr[1]+".xls");
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;
	}
	if(TypeCode=="med"||TypeCode=="bldevent"){
		var retval=tkMakeServerCall("web.DHCADVMEDADRREPORT","getMedRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("��ʾ:","ȡ���ݴ���");
			return;
		}
		//DHCADV_MedsReport .xls
		var retvalArr=retval.split("&&");
		//1����ȡXLS��ӡ·��
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_MedAdrReport.xls";
	
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		
		objSheet.Cells(2,2).value=retvalArr[0]+" "+retvalArr[1]; //��������
		objSheet.Cells(2,7).value=retvalArr[2]; //�������

		objSheet.Cells(4,2).value=retvalArr[3]; //����ID
		objSheet.Cells(4,5).value=retvalArr[4]; //����
		objSheet.Cells(4,9).value=retvalArr[5]; //������
		objSheet.Cells(5,2).value=retvalArr[6]; //��������
		objSheet.Cells(5,5).value=retvalArr[7]; //�Ա�
		objSheet.Cells(5,8).value=retvalArr[8]; //����
		objSheet.Cells(6,2).value=retvalArr[9]; //�ٴ����
		var adrAnonymFlag="" ,adrRepUser="" ,adradrRepDept="";
		if (retvalArr[10]==1){
			adrAnonymFlag="����";
			adrRepUser="" ;
			adradrRepDept="";
		 }else{
			 adrAnonymFlag=""
			 adrRepUser=retvalArr[11] ;
			 adradrRepDept=retvalArr[12];
		 
		 }
		
		objSheet.Cells(8,2).value=adrAnonymFlag; //����
		objSheet.Cells(8,7).value=adrRepUser; //����������
		objSheet.Cells(9,2).value=adradrRepDept; //���沿��
		objSheet.Cells(9,7).value=retvalArr[25]+" "+retvalArr[26]; //�¼���������ʱ��
		objSheet.Cells(10,3).value=retvalArr[15]; //�ϱ���ְҵ���
		
		objSheet.Cells(10,8).value=retvalArr[16]; //�ϱ���ְ��
		objSheet.Cells(11,2).value=retvalArr[17]; //��ϵ�绰
		objSheet.Cells(11,8).value=retvalArr[18]; //�����ʼ�
		objSheet.Cells(13,3).value=retvalArr[19]; //�¼���������
		objSheet.Cells(13,7).value=retvalArr[20]+" "+retvalArr[21]; //�¼������ص�
		//objSheet.Cells(13,9).value=retvalArr[21]; //�ص�����
		objSheet.Cells(15,1).value=retvalArr[22]; //�¼���������
	    objSheet.Cells(22,1).value=retvalArr[23];   //��������
	    objSheet.Cells(28,1).value=retvalArr[24];   //�Ľ�����

	   
		xlBook.SaveAs(filePath+retvalArr[2]+".xls");
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;
	}
}

/// ��ӡ
function printRep(ID,typecode)
{
	if(ID==""){
		$.messager.alert("��ʾ:","����IDΪ�գ�");
		return;
	}
	if(typecode=="material"){
		var retval=tkMakeServerCall("web.DHCADVMEDREPORT","getMataRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("��ʾ:","ȡ���ݴ���");
			return;
		}
		var retvalArr=retval.split("&&");
		//1����ȡXLS��ӡ·��
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_MataReport.xls";
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
		objSheet.Cells(29,9).value=retvalArr[48]; //�¼�֮���Ƿ���к������Ⱥ�˳��
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
		objSheet.printout();
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;
	}
	if(typecode=="drugerr"){
		var retval=tkMakeServerCall("web.DHCADVMEDSAREPORT","getMedsRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("��ʾ:","ȡ���ݴ���");
			return;
		}
		var retvalArr=retval.split("&&");
		//1����ȡXLS��ӡ·��
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_MedsReport.xls";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		
		var OccDate=retvalArr[4]
		var SelDateArr="",SelYear="",SelMonth="",SelDate="";
		if(DateFormat=="4"){ //���ڸ�ʽ 4:"DMY" DD/MM/YYYY
			SelDateArr=OccDate.split("/");
			SelYear=SelDateArr[2];
			SelMonth=parseInt(SelDateArr[1])-1;
			SelDate=parseInt(SelDateArr[0]);
		}else if(DateFormat=="3"){ //���ڸ�ʽ 3:"YMD" YYYY-MM-DD
			SelDateArr=OccDate.split("-");
			SelYear=SelDateArr[0];
			SelMonth=parseInt(SelDateArr[1])-1;
			SelDate=parseInt(SelDateArr[2]);
		}else if(DateFormat=="1"){ //���ڸ�ʽ 1:"MDY" MM/DD/YYYY
			SelDateArr=OccDate.split("/");
			SelYear=SelDateArr[2];
			SelMonth=parseInt(SelDateArr[0])-1;
			SelDate=parseInt(SelDateArr[1]);
		}
		var dt = new Date(SelYear,SelMonth,SelDate), dt2 = new Date();
		var weekDay = ["������", "����һ", "���ڶ�", "������", "������", "������", "������"];
		var weekday=weekDay[dt.getDay()];
		
		objSheet.Cells(2,2).value=retvalArr[19]; //�������
		objSheet.Cells(2,7).value=retvalArr[2]+" "+retvalArr[3]; //��������
		objSheet.Cells(3,2).value=retvalArr[4]+" "+retvalArr[5]; //��������
		objSheet.Cells(3,7).value=weekday; //����
		objSheet.Cells(3,9).value=retvalArr[6]; //���
		
		objSheet.Cells(4,2).value=retvalArr[8]; //����ID
		objSheet.Cells(4,7).value=retvalArr[7]; //���˲�����
		objSheet.Cells(5,2).value=retvalArr[9]; //��������
		objSheet.Cells(5,7).value=retvalArr[10]; //�����Ա�
		objSheet.Cells(5,9).value=retvalArr[11]; //��������
		
		objSheet.Cells(6,2).value=retvalArr[12]; //Ӧ��ҩ��
		objSheet.Cells(6,7).value=retvalArr[13]; //ҩ�����
		objSheet.Cells(6,9).value=retvalArr[17]; //�ۼƸ�ҩ�������
		
		var MULtmpStr=retvalArr[22];  //������Ϣ
		var tmpStr=MULtmpStr.split("!!");
		for (i=0;i<tmpStr.length;i++){
			var tmpList=tmpStr[i].split("&");
			if(tmpList[0]=="DocL"){ //ҽ������
				DocList=tmpList;
			}else if(tmpList[0]=="ApoL"){
				ApoList=tmpList;
			}else if(tmpList[0]=="DispL"){
				DispList=tmpList;
			}else if(tmpList[0]=="NurL"){
				NurList=tmpList;
			}else if(tmpList[0]=="PatL"){
				PatList=tmpList;
			}	
		}
		//ҽ������		
		xlApp.Range(xlApp.Cells(8,1),xlApp.Cells(8,9)).MergeCells = true; //�ϲ���Ԫ��
		objSheet.Cells(8,1).value="ҽ������";
		objSheet.Cells(8,1).Interior.Pattern = 2;  //���õ�Ԫ�񱳾���ʽ*(1-�ޣ�2-ϸ����3-������4-�ߵ㣬5-���ߣ�6-����..)
		objSheet.Cells(9,1).value="�Ƿ�ѡ��";
		objSheet.Cells(9,2).value="����";
		xlApp.Range(xlApp.Cells(9,3),xlApp.Cells(9,6)).MergeCells = true;  //�ϲ���Ԫ��
		objSheet.Cells(9,3).value="����";
		objSheet.Cells(9,7).value="Ӧ����";
		objSheet.Cells(9,8).value="������";
		objSheet.Cells(9,9).value="����";
		
		Doclen=DocList.length-1;
		for(var k=1;k<=Doclen;k++){
			var MULIDoArr=DocList[k].split("^");
			objSheet.Cells(9+k,1).value=MULIDoArr[0]; //�Ƿ�ѡ��
			objSheet.Cells(9+k,2).value=MULIDoArr[2]; //����
			xlApp.Range(xlApp.Cells(9+k,3),xlApp.Cells(9+k,6)).MergeCells = true;  //�ϲ���Ԫ��
			objSheet.Cells(9+k,3).value=MULIDoArr[3]; //����
			objSheet.Cells(9+k,7).value=MULIDoArr[5]; //Ӧ����
			objSheet.Cells(9+k,7).WrapText=true;  
			objSheet.Cells(9+k,8).value=MULIDoArr[6]; //������
			objSheet.Cells(9+k,8).WrapText=true;  
			objSheet.Cells(9+k,9).value=MULIDoArr[7]; //����
		}
		
		//ҩʦ����		
		xlApp.Range(xlApp.Cells(10+Doclen+3,1),xlApp.Cells(10+Doclen+3,9)).MergeCells = true;
		objSheet.Cells(10+Doclen+3,1).value="ҩʦ����";
		objSheet.Cells(10+Doclen+3,1).Interior.Pattern = 2; 
		objSheet.Cells(10+Doclen+4,1).value="�Ƿ�ѡ��";
		objSheet.Cells(10+Doclen+4,2).value="����";
		xlApp.Range(xlApp.Cells(10+Doclen+4,3),xlApp.Cells(10+Doclen+4,6)).MergeCells = true;
		objSheet.Cells(10+Doclen+4,3).value="����";
		objSheet.Cells(10+Doclen+4,7).value="Ӧ����";
		objSheet.Cells(10+Doclen+4,8).value="������";
		objSheet.Cells(10+Doclen+4,9).value="����";
		
		Apolen=ApoList.length-1;
		for(var k=1;k<=Apolen;k++){
			var MULIApArr=ApoList[k].split("^");
			objSheet.Cells(10+Doclen+4+k,1).value=MULIApArr[0]; //�Ƿ�ѡ��
			objSheet.Cells(10+Doclen+4+k,2).value=MULIApArr[2]; //����
			xlApp.Range(xlApp.Cells(10+Doclen+4+k,3),xlApp.Cells(10+Doclen+4+k,6)).MergeCells = true;
			objSheet.Cells(10+Doclen+4+k,3).value=MULIApArr[3]; //����
			objSheet.Cells(10+Doclen+4+k,7).value=MULIApArr[5]; //Ӧ����
			objSheet.Cells(10+Doclen+4+k,7).WrapText=true;  
			objSheet.Cells(10+Doclen+4+k,8).value=MULIApArr[6]; //������
			objSheet.Cells(10+Doclen+4+k,8).WrapText=true;  
			objSheet.Cells(10+Doclen+4+k,9).value=MULIApArr[7]; //����
		}
		DAlen=Doclen+Apolen;
		
		//���ͻ���		
		xlApp.Range(xlApp.Cells(10+DAlen+8,1),xlApp.Cells(10+DAlen+8,9)).MergeCells = true;
		objSheet.Cells(10+DAlen+8,1).value="���ͻ���";
		objSheet.Cells(10+DAlen+8,1).Interior.Pattern = 2; 
		objSheet.Cells(10+DAlen+9,1).value="�Ƿ�ѡ��";
		objSheet.Cells(10+DAlen+9,2).value="����";
		xlApp.Range(xlApp.Cells(10+DAlen+9,3),xlApp.Cells(10+DAlen+9,6)).MergeCells = true;
		objSheet.Cells(10+DAlen+9,3).value="����";
		objSheet.Cells(10+DAlen+9,7).value="Ӧ����";
		objSheet.Cells(10+DAlen+9,8).value="������";
		objSheet.Cells(10+DAlen+9,9).value="����";

		Displen=DispList.length-1;
		for(var k=1;k<=Displen;k++){
			var MULIDiArr=DispList[k].split("^");
			objSheet.Cells(10+DAlen+9+k,1).value=MULIDiArr[0]; //�Ƿ�ѡ��
			objSheet.Cells(10+DAlen+9+k,2).value=MULIDiArr[2]; //����
			xlApp.Range(xlApp.Cells(10+DAlen+9+k,3),xlApp.Cells(10+DAlen+9+k,6)).MergeCells = true;
			objSheet.Cells(10+DAlen+9+k,3).value=MULIDiArr[3]; //����
			objSheet.Cells(10+DAlen+9+k,7).value=MULIDiArr[5]; //Ӧ����
			objSheet.Cells(10+DAlen+9+k,7).WrapText=true;  
			objSheet.Cells(10+DAlen+9+k,8).value=MULIDiArr[6]; //������
			objSheet.Cells(10+DAlen+9+k,8).WrapText=true;  
			objSheet.Cells(10+DAlen+9+k,9).value=MULIDiArr[7]; //����
		}
		DADilen=DAlen+Displen;
		
		//��ʿ����		
		xlApp.Range(xlApp.Cells(10+DADilen+11,1),xlApp.Cells(10+DADilen+11,9)).MergeCells = true;
		objSheet.Cells(10+DADilen+11,1).value="��ʿ����";
		objSheet.Cells(10+DADilen+11,1).Interior.Pattern = 2; 
		objSheet.Cells(10+DADilen+12,1).value="�Ƿ�ѡ��";
		objSheet.Cells(10+DADilen+12,2).value="����";
		xlApp.Range(xlApp.Cells(10+DADilen+12,3),xlApp.Cells(10+DADilen+12,6)).MergeCells = true;
		objSheet.Cells(10+DADilen+12,3).value="����";
		objSheet.Cells(10+DADilen+12,7).value="Ӧ����";
		objSheet.Cells(10+DADilen+12,8).value="������";
		objSheet.Cells(10+DADilen+12,9).value="����";

		Nuslen=NurList.length-1;
		for(var k=1;k<=Nuslen;k++){
			var MULINuArr=NurList[k].split("^");
			objSheet.Cells(10+DADilen+12+k,1).value=MULINuArr[0]; //�Ƿ�ѡ��
			objSheet.Cells(10+DADilen+12+k,2).value=MULINuArr[2]; //����
			xlApp.Range(xlApp.Cells(10+DADilen+12+k,3),xlApp.Cells(10+DADilen+12+k,6)).MergeCells = true;
			objSheet.Cells(10+DADilen+12+k,3).value=MULINuArr[3]; //����
			objSheet.Cells(10+DADilen+12+k,7).value=MULINuArr[5]; //Ӧ����
			objSheet.Cells(10+DADilen+12+k,7).WrapText=true;  
			objSheet.Cells(10+DADilen+12+k,8).value=MULINuArr[6]; //������
			objSheet.Cells(10+DADilen+12+k,8).WrapText=true;  
			objSheet.Cells(10+DADilen+12+k,9).value=MULINuArr[7]; //����
		}
		DADiNulen=DADilen+Nuslen;
		
		//���߻���		
		xlApp.Range(xlApp.Cells(10+DADiNulen+16,1),xlApp.Cells(10+DADiNulen+16,9)).MergeCells = true;
		objSheet.Cells(10+DADiNulen+16,1).value="���߻���";
		objSheet.Cells(10+DADiNulen+16,1).Interior.Pattern = 2; 
		objSheet.Cells(10+DADiNulen+17,1).value="�Ƿ�ѡ��";
		objSheet.Cells(10+DADiNulen+17,2).value="����";
		xlApp.Range(xlApp.Cells(10+DADiNulen+17,3),xlApp.Cells(10+DADiNulen+17,6)).MergeCells = true;
		objSheet.Cells(10+DADiNulen+17,3).value="����";
		objSheet.Cells(10+DADiNulen+17,7).value="Ӧ����";
		objSheet.Cells(10+DADiNulen+17,8).value="������";
		objSheet.Cells(10+DADiNulen+17,9).value="����";

		var Patlen=PatList.length-1;
		for(var k=1;k<=Patlen;k++){
			var MULIPaArr=PatList[k].split("^");
			objSheet.Cells(10+DADiNulen+17+k,1).value=MULIPaArr[0]; //�Ƿ�ѡ��
			objSheet.Cells(10+DADiNulen+17+k,2).value=MULIPaArr[2]; //����
			xlApp.Range(xlApp.Cells(10+DADiNulen+17+k,3),xlApp.Cells(10+DADiNulen+17+k,6)).MergeCells = true;
			objSheet.Cells(10+DADiNulen+17+k,3).value=MULIPaArr[3]; //����
			objSheet.Cells(10+DADiNulen+17+k,7).value=MULIPaArr[5]; //Ӧ����
			objSheet.Cells(10+DADiNulen+17+k,7).WrapText=true;  
			objSheet.Cells(10+DADiNulen+17+k,8).value=MULIPaArr[6]; //������
			objSheet.Cells(10+DADiNulen+17+k,8).WrapText=true;  
			objSheet.Cells(10+DADiNulen+17+k,9).value=MULIPaArr[7]; //����
		}
		DADiNuPalen=DADiNulen+Patlen;
		
		//����ҽ����ҩʦ����ʿ��Ϣ
		var MedsRepLinkList=retvalArr[21];  
		var RepLinkList=MedsRepLinkList.split("&");
		for (i=0;i<RepLinkList.length;i++){
			var messList=RepLinkList[i].split("^");
			var medsrMes=""
			if (messList[4]=="DocL"){
				xlApp.Range(xlApp.Cells(10+Doclen+1,1),xlApp.Cells(10+Doclen+1,2)).MergeCells = true;
				objSheet.Cells(10+Doclen+1,1).value="����ҽ����Ϣ��";
				xlApp.Range(xlApp.Cells(10+Doclen+1,3),xlApp.Cells(10+Doclen+1,9)).MergeCells = true;
				if(messList[1]==10){
					medsrMes="��ʽҽ��";
				}else if(messList[1]==11){
					medsrMes="�о���";
				}else if(messList[1]==12){
					medsrMes="����ҽ��";
				}
				objSheet.Cells(10+Doclen+1,3).value=medsrMes+" "+messList[2]+" "+messList[3];  //����ҽ����Ϣ
			}else if(messList[4]=="ApoL"){
				xlApp.Range(xlApp.Cells(10+DAlen+6,1),xlApp.Cells(10+DAlen+6,2)).MergeCells = true;
				objSheet.Cells(10+DAlen+6,1).value="����ҩʦ��Ϣ��";
				xlApp.Range(xlApp.Cells(10+DAlen+6,3),xlApp.Cells(10+DAlen+6,9)).MergeCells = true;
				if(messList[1]==20){
					medsrMes="��ʽҩʦ";
				}else if(messList[1]==21){
					medsrMes="ʵϰ��";
				}else if(messList[1]==22){
					medsrMes="����ҩʦ";
				}
				objSheet.Cells(10+DAlen+6,3).value=medsrMes+" "+messList[2]+" "+messList[3]; //����ҩʦ��Ϣ
			}else if(messList[4]=="NurL"){
				xlApp.Range(xlApp.Cells(10+DADiNulen+14,1),xlApp.Cells(10+DADiNulen+14,2)).MergeCells = true;
				objSheet.Cells(10+DADiNulen+14,1).value="���»�ʿ��Ϣ��";
				xlApp.Range(xlApp.Cells(10+DADiNulen+14,3),xlApp.Cells(10+DADiNulen+14,9)).MergeCells = true;
				objSheet.Cells(10+DADiNulen+14,3).value=retvalArr[27]+" "+retvalArr[28]+" "+retvalArr[29]; //���»�ʿ��Ϣ
				if(messList[1]==30){
					medsrMes="��ʽ��ʿ";
				}else if(messList[1]==31){
					medsrMes="ʵϰ��";
				}else if(messList[1]==32){
					medsrMes="���޻�ʿ";
				}
				objSheet.Cells(10+DADiNulen+14,3).value=medsrMes+" "+messList[2]+" "+messList[3]; //���»�ʿ��Ϣ
			}
		}
		
		xlApp.Range(8+":"+(10+DADiNuPalen+18)).HorizontalAlignment = 2; 
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+19,1),xlApp.Cells(10+DADiNuPalen+19,9)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+19,1).Font.Size = 16; //����Ϊ16����
		objSheet.Cells(10+DADiNuPalen+19,1).Font.Name = "����"; 
		objSheet.Cells(10+DADiNuPalen+19,1).Font.Bold = true; //����Ϊ����
		objSheet.Cells(10+DADiNuPalen+19,1).value="�����"; 
		
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+20,1),xlApp.Cells(10+DADiNuPalen+20,9)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+20,1).value=retvalArr[23]+retvalArr[24]; //���
		
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+21,1),xlApp.Cells(10+DADiNuPalen+21,9)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+21,1).Font.Size = 16; //����Ϊ16����
		objSheet.Cells(10+DADiNuPalen+21,1).Font.Name = "����"; 
		objSheet.Cells(10+DADiNuPalen+21,1).Font.Bold = true; //����Ϊ����
		objSheet.Cells(10+DADiNuPalen+21,1).value="��ʱ�ж�/��Ԥ��"; 
		
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+22,1),xlApp.Cells(10+DADiNuPalen+27,9)).MergeCells = true;
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+22,1),xlApp.Cells(10+DADiNuPalen+27,9)).WrapText=true; //�Զ�����
		objSheet.Cells(10+DADiNuPalen+22,1).value=retvalArr[14];  //��ʱ�ж�����Ԥ
		
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+28,1),xlApp.Cells(10+DADiNuPalen+28,4)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+28,1).value="������ң�"+retvalArr[1];
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+28,6),xlApp.Cells(10+DADiNuPalen+28,7)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+28,6).value="������������"+retvalArr[15];
		xlApp.Range(xlApp.Cells(10+DADiNuPalen+28,8),xlApp.Cells(10+DADiNuPalen+28,9)).MergeCells = true;
		objSheet.Cells(10+DADiNuPalen+28,8).value="������ְ�ƣ�"+retvalArr[16]; //������ְ��
		
		objSheet.printout();
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;
	}
	if(typecode=="blood"){
		var retval=tkMakeServerCall("web.DHCADVBLDREPORT","getBldRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("��ʾ:","ȡ���ݴ���");
			return;
		}
		var retvalArr=retval.split("&&");
		//1����ȡXLS��ӡ·��
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_BloodReport.xls";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		
		
		objSheet.Cells(2,2).value=retvalArr[3]; //�������
		objSheet.Cells(2,6).value=retvalArr[4]+" "+retvalArr[5]; //��������
		objSheet.Cells(3,2).value=retvalArr[6]; //����
		objSheet.Cells(3,6).value=retvalArr[1]; //����
		
		objSheet.Cells(5,1).Interior.Pattern = 2; 
		objSheet.Cells(6,2).value=retvalArr[9]; //����ID
		objSheet.Cells(6,5).value=retvalArr[8]; //���˲�����
		objSheet.Cells(7,2).value=retvalArr[10]; //��������
		objSheet.Cells(7,5).value=retvalArr[11]; //�����Ա�
		objSheet.Cells(7,8).value=retvalArr[12]; //��������
		objSheet.Cells(8,2).value=retvalArr[13]; //��������
		objSheet.Cells(8,5).value=retvalArr[14]; //����֤��
	    objSheet.Cells(9,3).value=retvalArr[51]; //�������/��������
		
		objSheet.Cells(10,8).value=retvalArr[15]; //�в�ʷ
		objSheet.Cells(10,2).value=retvalArr[16]; //������Ѫʷ
		objSheet.Cells(10,5).value=retvalArr[17]; //��Ѫ��Ӧʷ
		objSheet.Cells(11,3).value=retvalArr[18]; //��ѪǰѪ�ͼ����
		objSheet.Cells(11,5).value=retvalArr[19]; //������
		objSheet.Cells(11,8).value=retvalArr[20]; //���⿹��ɸ�飨�����ԣ�
		objSheet.Cells(12,3).value=retvalArr[21]; //������ע��ѪҺ��Ϣ
		objSheet.Cells(12,5).value=retvalArr[22]; //������
		objSheet.Cells(13,2).value=retvalArr[23]; //��עѪ��
		objSheet.Cells(14,1).Interior.Pattern = 2; 
		var bldrptBldType=retvalArr[50];  //��������
		var BldTypeArr=bldrptBldType.split("&");
		var BldTypelen=BldTypeArr.length;
		for(var k=0;k<BldTypelen;k++){
			var BldType=BldTypeArr[k].split("^");
			objSheet.Cells(16+k,1).value=BldType[1]; //��Ѫ���
			xlApp.Range(xlApp.Cells(15+k,2),xlApp.Cells(15+k,3)).MergeCells = true;
			objSheet.Cells(16+k,2).value=BldType[3]; //��Ѫ���1
			objSheet.Cells(16+k,4).value=BldType[4]; //��Ѫ���2
			objSheet.Cells(16+k,5).value=BldType[5]; //��Ѫ���3
			xlApp.Range(xlApp.Cells(16+k,6),xlApp.Cells(16+k,7)).MergeCells = true;
			objSheet.Cells(16+k,6).value=BldType[6]; //��Ѫ���1
		}
		
		xlApp.Range(xlApp.Cells(16+BldTypelen,1),xlApp.Cells(16+BldTypelen,8)).MergeCells = true;
		objSheet.Cells(16+BldTypelen,1).value="��Ѫ������Ӧ����";
		objSheet.Cells(16+BldTypelen,1).Font.Size = 12; //����Ϊ12����
		objSheet.Cells(16+BldTypelen,1).Font.Name = "����"; 
		objSheet.Cells(16+BldTypelen,1).Font.Bold = true; //����Ϊ����
		objSheet.Cells(16+BldTypelen,1).Interior.Pattern = 2; 
		xlApp.Range(xlApp.Cells(17+BldTypelen,1),xlApp.Cells(17+BldTypelen,4)).MergeCells = true;
		xlApp.Range(xlApp.Cells(17+BldTypelen,5),xlApp.Cells(17+BldTypelen,8)).MergeCells = true;
		objSheet.Cells(17+BldTypelen,1).value="��������";
		objSheet.Cells(17+BldTypelen,5).value="�ٴ�֢״";
		
		
		var bldrptBldBasA=retvalArr[48];  //��������
		var BldBasArr=bldrptBldBasA.split("&");
		var BldBasAlen=BldBasArr.length;
		var BBasAlen=Math.ceil(BldBasAlen/2);
		for(var k=0;k<BBasAlen;k++){
			var BldB=BldBasArr[k].split("^");
			xlApp.Range(xlApp.Cells(18+BldTypelen+k,1),xlApp.Cells(18+BldTypelen+k,2)).MergeCells = true;
			objSheet.Cells(18+BldTypelen+k,1).value=BldB[0]+" "+BldB[1]; //�Ƿ�ѡ��
 			var i=BBasAlen+k;
 			if(i<BldBasAlen){
				var BldBi=BldBasArr[i].split("^");
				xlApp.Range(xlApp.Cells(18+BldTypelen+k,3),xlApp.Cells(18+BldTypelen+k,4)).MergeCells = true;
				objSheet.Cells(18+BldTypelen+k,3).value=BldBi[0]+" "+BldBi[1]; //����
			}
		}
		var bldrptBldBasB=retvalArr[49];  //�ٴ�֢״
		var BldBasBArr=bldrptBldBasB.split("&");
		var BldBasBlen=BldBasBArr.length;
		var BBasBlen=Math.ceil(BldBasBlen/2) ;
		for(var k=0;k<BBasBlen;k++){
			var BldB=BldBasBArr[k].split("^");
			xlApp.Range(xlApp.Cells(18+BldTypelen+k,5),xlApp.Cells(18+BldTypelen+k,6)).MergeCells = true;
			objSheet.Cells(18+BldTypelen+k,5).value=BldB[0]+" "+BldB[1]; //�Ƿ�ѡ��
 			var j=BBasBlen+k;
 			if(j<BldBasBlen){
				var BldBj=BldBasBArr[j].split("^");
				xlApp.Range(xlApp.Cells(18+BldTypelen+k,7),xlApp.Cells(18+BldTypelen+k,8)).MergeCells = true;
				objSheet.Cells(18+BldTypelen+k,7).value=BldBj[0]+" "+BldBj[1]; //����
			}
		}
		if(BBasAlen>BBasBlen){
			BBasBlen=BBasAlen;
		}
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen,1),xlApp.Cells(18+BldTypelen+BBasBlen,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen,1).Font.Size = 12; //����Ϊ12����
		objSheet.Cells(18+BldTypelen+BBasBlen,1).Font.Name = "����"; 
		objSheet.Cells(18+BldTypelen+BBasBlen,1).Font.Bold = true; //����Ϊ����
		objSheet.Cells(18+BldTypelen+BBasBlen,1).Interior.Pattern = 2; 
		objSheet.Cells(18+BldTypelen+BBasBlen,1).value="������������"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,1).value="���£�"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,2).value=retvalArr[24]; //����
		objSheet.Cells(18+BldTypelen+BBasBlen+1,3).value="Ѫѹ��"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,4).value=retvalArr[25]; //Ѫѹ
		objSheet.Cells(18+BldTypelen+BBasBlen+1,5).value="������"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,6).value=retvalArr[26]; //����
		objSheet.Cells(18+BldTypelen+BBasBlen+1,7).value="����Ƶ�Σ�"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+1,8).value=retvalArr[27]; //����Ƶ��
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+2,1),xlApp.Cells(18+BldTypelen+BBasBlen+2,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+2,1).value="��ѪǰԤ����ҩ��"; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+2,3),xlApp.Cells(18+BldTypelen+BBasBlen+2,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+2,3).value=retvalArr[28]+" "+retvalArr[29];  //��ѪǰԤ����ҩ
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+3,1),xlApp.Cells(18+BldTypelen+BBasBlen+3,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+3,1).value="������Ѫ��ʼʱ�䣺"; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+3,3),xlApp.Cells(18+BldTypelen+BBasBlen+3,4)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+3,3).value=retvalArr[30]+" "+retvalArr[31]; //������Ѫ��ʼʱ��
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+3,6),xlApp.Cells(18+BldTypelen+BBasBlen+3,7)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+3,6).value="�����߹��ţ�"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+3,8).value=retvalArr[32]; //�����߹���
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+4,1),xlApp.Cells(18+BldTypelen+BBasBlen+4,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+4,1).value="��Ѫ��Ӧ����ʱ�䣺"; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+4,3),xlApp.Cells(18+BldTypelen+BBasBlen+4,4)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+4,3).value=retvalArr[33]+" "+retvalArr[34]; //��Ѫ��Ӧ����ʱ��
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+4,6),xlApp.Cells(18+BldTypelen+BBasBlen+4,7)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+4,6).value="�����߹��ţ�"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+4,8).value=retvalArr[35]; //�����߹���
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+5,1),xlApp.Cells(18+BldTypelen+BBasBlen+5,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+5,1).value="��Ѫ������/���ţ�"; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+5,3),xlApp.Cells(18+BldTypelen+BBasBlen+5,5)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+5,3).value=retvalArr[36]; //��Ѫ������/����
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+5,6),xlApp.Cells(18+BldTypelen+BBasBlen+5,7)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+5,6).value="ʣ��Ѫ��(ml)��"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+5,8).value=retvalArr[37]; //ʣ��Ѫ��
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+6,1),xlApp.Cells(18+BldTypelen+BBasBlen+6,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+6,1).value="���س̶ȣ�"; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+6,3),xlApp.Cells(18+BldTypelen+BBasBlen+6,5)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+6,3).value=retvalArr[39]; //���س̶�
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+6,6),xlApp.Cells(18+BldTypelen+BBasBlen+6,7)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+6,6).value="����ԣ�"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+6,8).value=retvalArr[40]; //�����
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+7,1),xlApp.Cells(18+BldTypelen+BBasBlen+7,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+7,1).value="��Ѫ������Ӧ���"; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+7,3),xlApp.Cells(18+BldTypelen+BBasBlen+7,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+7,3).value=retvalArr[38]; //��Ѫ������Ӧ����
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+8,1),xlApp.Cells(18+BldTypelen+BBasBlen+8,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).Font.Size = 12; //����Ϊ12����
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).Font.Name = "����"; 
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).Font.Bold = true; //����Ϊ����
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).Interior.Pattern = 2; 
		objSheet.Cells(18+BldTypelen+BBasBlen+8,1).value="�ٴ����ã�"; 
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+9,1),xlApp.Cells(18+BldTypelen+BBasBlen+12,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+9,1).value=retvalArr[41]; //�ٴ�����
		
		objSheet.Cells(18+BldTypelen+BBasBlen+13,1).value="����ת�飺"; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+13,2),xlApp.Cells(18+BldTypelen+BBasBlen+13,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+13,2).value=retvalArr[42]+" "+retvalArr[43]+" "+retvalArr[44];  //����ת��
		
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+14,1),xlApp.Cells(18+BldTypelen+BBasBlen+14,2)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+14,1).value="����Ѫ����ԣ�"; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+14,3),xlApp.Cells(18+BldTypelen+BBasBlen+14,4)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+14,3).value=retvalArr[45]; //����Ѫ�����
	
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+15,5),xlApp.Cells(18+BldTypelen+BBasBlen+15,6)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+15,5).value="������ǩ����"; 
		xlApp.Range(xlApp.Cells(18+BldTypelen+BBasBlen+15,7),xlApp.Cells(18+BldTypelen+BBasBlen+15,8)).MergeCells = true;
		objSheet.Cells(18+BldTypelen+BBasBlen+15,7).value=retvalArr[2]; //���

		
		objSheet.printout();
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;
	}
	if(typecode=="drug"){
		var retval=tkMakeServerCall("web.DHCADVMADRREPORT","getMadrRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("��ʾ:","ȡ���ݴ���");
			return;
		}
		//DHCADV_MedsReport .xls
		var retvalArr=retval.split("&&");
		//1����ȡXLS��ӡ·��
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_DrugReport.xls";  //DHCST_PHCM_AdrReport  DHCADV_DrugReport
	
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		
		objSheet.Cells(2,2).value=retvalArr[0]; //����״̬
	
		objSheet.Cells(2,9).value=retvalArr[1]; //���
		   
		objSheet.Cells(3,2).value=retvalArr[2]+" "+retvalArr[3]+""+retvalArr[4]; //����
		objSheet.Cells(3,7).value=retvalArr[5]+retvalArr[6]; //���浥λ���

		objSheet.Cells(4,2).value=retvalArr[7]; //��������
		objSheet.Cells(4,4).value=retvalArr[8]; //�Ա�
		objSheet.Cells(4,6).value=retvalArr[9]; //��������
		objSheet.Cells(4,8).value=retvalArr[10]; //����
		if(retvalArr[11]!=""){
		  objSheet.Cells(4,10).value=retvalArr[11]+" "+"Kg"; //����
		}else{
		  objSheet.Cells(4,10).value=retvalArr[11]; //����
		}
		objSheet.Cells(4,12).value=retvalArr[12]; //��ϵ��ʽ
		objSheet.Cells(5,2).value=retvalArr[13]; //ԭ������
		objSheet.Cells(5,5).value=retvalArr[14]; //ҽԺ����
		objSheet.Cells(5,9).value=retvalArr[15]+retvalArr[16]; //����ҩƷ������Ӧ/�¼�
		objSheet.Cells(6,5).value=retvalArr[17]; //������/�����
		objSheet.Cells(6,9).value=retvalArr[18]+retvalArr[19]; //����ҩƷ������Ӧ/�¼�
		objSheet.Cells(7,2).value=retvalArr[20]+retvalArr[21]; //�����Ҫ��Ϣ
		objSheet.Cells(8,3).value=retvalArr[22];  //������Ӧ/�¼�����
		objSheet.Cells(8,10).value=retvalArr[23]+"  "+retvalArr[24]; //������Ӧ/�¼�����ʱ��
		objSheet.Cells(10,1).value=retvalArr[25]; //������Ӧ/�¼���������
		objSheet.Cells(11,3).value=retvalArr[26]; //������Ӧ/�¼��Ľ��
		objSheet.Cells(11,7).value=retvalArr[27]; //����/ֱ������
		
		objSheet.Cells(11,11).value=retvalArr[28]+"  "+retvalArr[29]; //����ʱ��
		objSheet.Cells(12,5).value=retvalArr[30]; //ͣҩ������󣬷�Ӧ/�¼��Ƿ���ʧ����᣿
		objSheet.Cells(13,5).value=retvalArr[31]; //�ٴ�ʹ�ÿ���ҩƷ���Ƿ��ٴγ���ͬ����Ӧ/�¼�
		objSheet.Cells(14,5).value=retvalArr[32]; //��ԭ��������Ӱ��

		objSheet.Cells(15,3).value=retvalArr[33]; //����������
		objSheet.Cells(15,11).value=retvalArr[34]; //ǩ��
		objSheet.Cells(16,3).value=retvalArr[35];  //���浥λ����
		objSheet.Cells(16,11).value=retvalArr[36]; //ǩ��

		objSheet.Cells(17,3).value=retvalArr[37]; //��ϵ�绰
		objSheet.Cells(17,11).value=retvalArr[38]+retvalArr[39]; //ְҵ
		objSheet.Cells(18,3).value=retvalArr[40]; //��������
		
		objSheet.Cells(18,6).value=retvalArr[41]; //ǩ��
		objSheet.Cells(18,11).value=retvalArr[42]; //���沿��
		objSheet.Cells(19,3).value=retvalArr[43]; //��λ����
		objSheet.Cells(19,6).value=retvalArr[44]; //��ϵ��
		objSheet.Cells(19,8).value=retvalArr[45]; //�绰
		objSheet.Cells(19,11).value=retvalArr[46]+"  "+retvalArr[47]; //��������
		objSheet.Cells(20,2).value=retvalArr[48]; //��ע
	   
	   xlApp.Range(objSheet.Cells(22,1),objSheet.Cells(22,12)).Interior.Pattern = 2; //ҩƷ�б����ⱳ����ɫ
	   	var advRepDrgItmList=retvalArr[49];  //ҩƷ�б�

	   var advRepDrgItmArr=advRepDrgItmList.split("||");
	    for(var k=0;k<advRepDrgItmArr.length;k++){
		var drgItmArr=advRepDrgItmArr[k].split("^");
		objSheet.Cells(23+k,1).value=drgItmArr[0]; //����
		objSheet.Cells(23+k,2).value="'"+drgItmArr[1]; //��׼�ĺ�
		objSheet.Cells(23+k,3).value=drgItmArr[3]; //��Ʒ����
		objSheet.Cells(23+k,4).value=drgItmArr[8]; //ͨ����
		objSheet.Cells(23+k,6).value=drgItmArr[5]; //����
		objSheet.Cells(23+k,7).value="'"+drgItmArr[17]; //����
		objSheet.Cells(23+k,8).value="'"+drgItmArr[9]; //�÷�����
		objSheet.Cells(23+k,9).value="'"+drgItmArr[13]; //��ʼʱ��
		objSheet.Cells(23+k,11).value="'"+drgItmArr[14]; //����ʱ��
		objSheet.Cells(23+k,12).value="'"+drgItmArr[16]; //��ҩԭ��
	}  
		objSheet.printout();
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;
	}
	if(typecode=="med"||typecode=="bldevent"){
		var retval=tkMakeServerCall("web.DHCADVMEDADRREPORT","getMedRepExportInfo",ID);
		if(retval==""){
			$.messager.alert("��ʾ:","ȡ���ݴ���");
			return;
		}
		//DHCADV_MedsReport .xls
		var retvalArr=retval.split("&&");
		//1����ȡXLS��ӡ·��
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_MedAdrReport.xls";
	
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		
		objSheet.Cells(2,2).value=retvalArr[0]+" "+retvalArr[1]; //��������
		objSheet.Cells(2,7).value=retvalArr[2]; //�������

		objSheet.Cells(4,2).value=retvalArr[3]; //����ID
		objSheet.Cells(4,5).value=retvalArr[4]; //����
		objSheet.Cells(4,9).value=retvalArr[5]; //������
		objSheet.Cells(5,2).value=retvalArr[6]; //��������
		objSheet.Cells(5,5).value=retvalArr[7]; //�Ա�
		objSheet.Cells(5,8).value=retvalArr[8]; //����
		objSheet.Cells(6,2).value=retvalArr[9]; //�ٴ����
		var adrAnonymFlag="" ,adrRepUser="" ,adradrRepDept="";
		if (retvalArr[10]==1){
			adrAnonymFlag="����";
			adrRepUser="" ;
			adradrRepDept="";
		 }else{
			 adrAnonymFlag=""
			 adrRepUser=retvalArr[11] ;
			 adradrRepDept=retvalArr[12];
			 
		 }
		
		objSheet.Cells(8,2).value=adrAnonymFlag; //����

		
		objSheet.Cells(8,7).value=adrRepUser; //����������
		objSheet.Cells(9,2).value=adradrRepDept; //���沿��
		objSheet.Cells(9,7).value=retvalArr[25]+" "+retvalArr[26]; //�¼���������ʱ��
		objSheet.Cells(10,3).value=retvalArr[15]; //�ϱ���ְҵ���
		
		objSheet.Cells(10,8).value=retvalArr[16]; //�ϱ���ְ��
		objSheet.Cells(11,2).value=retvalArr[17]; //��ϵ�绰
		objSheet.Cells(11,8).value=retvalArr[18]; //�����ʼ�
		objSheet.Cells(13,3).value=retvalArr[19]; //�¼���������
		objSheet.Cells(13,7).value=retvalArr[20]+" "+retvalArr[21]; //�¼������ص�
		//objSheet.Cells(13,9).value=retvalArr[21]; //�ص�����
		objSheet.Cells(15,1).value=retvalArr[22]; //�¼���������
	    objSheet.Cells(22,1).value=retvalArr[23];   //��������
	    objSheet.Cells(28,1).value=retvalArr[24];   //�Ľ�����

	   
		objSheet.printout();
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;
	}
} 