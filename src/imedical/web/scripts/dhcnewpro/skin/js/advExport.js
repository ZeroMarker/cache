///�����¼����� 
function ExportWordData(ID,RepTypeCode,RepType,filePath)
{ 
	var RepDate="",OccDateTime="",RepProcess=""
	runClassMethod("web.DHCADVCOMMONPRINT","GetExportbyWord",
	{AdvMasterDr:ID,RepTypeCode:RepTypeCode},function(ret){
		var tmp=ret.replace(/(^\s*)|(\s*$)/g,"").split("^");
		RepDate=tmp[0];
		OccDateTime=tmp[1];
		RepProcess=tmp[2];
						
	},"",false);
	/* var WordApp=new ActiveXObject("Word.Application"); 
	var wdCharacter=1 
	var wdOrientLandscape = 1 
	WordApp.Application.Visible=true; //ִ�����֮���Ƿ񵯳��Ѿ����ɵ�word 
	var myDoc=WordApp.Documents.Add();//�����µĿ��ĵ�
	
	//WordApp.ActiveDocument.PageSetup.Orientation = wdOrientLandscape//ҳ�淽������Ϊ���� 
	WordApp. Selection.ParagraphFormat.Alignment=1 //1���ж���,0Ϊ����
	WordApp. Selection.ParagraphFormat.BaseLineAlignment=4 //1���ж���,0Ϊ����  
	WordApp. Selection.Font.Bold=true 
	WordApp. Selection.Font.Size=16 
	WordApp. Selection.TypeText("�������¼��Ľ��������Ͱ���������"); 
	
	WordApp.Selection.TypeParagraph()     // �������
	WordApp. Selection.Font.Bold=false 
	WordApp. Selection.Font.Size=10
	var myTable=myDoc.Tables.Add (WordApp.Selection.Range, 12,2) //12��2�еı�� 
	myTable.Style="������"
	var title = "����" 
	var TableRange; //����Ϊ������еĵ�Ԫ��ֵ 
	myTable.Rows.Height =30; //�����и�
	myTable.Rows(1).Cells.Merge();//�ϲ�����
	myTable.Cell(1,1).width=420;
	myTable.Rows(2).Cells.Merge();//�ϲ�����
	myTable.Cell(2,1).width=420;
	myTable.Cell(2,1).range.Font.Bold= false;
	myTable.Cell(2,1).range.Font.size= 12;
	myTable.Rows(3).Cells.Merge();//�ϲ�����
	myTable.Cell(3,1).width=420;
	myTable.Cell(3,1).Height="50";
	
	myTable.Cell(1,1).range.Text="�ϱ����ڣ�   "+RepDate+"                   ����ʱ�䣺"+OccDateTime;
	myTable.Cell(2,1).range.Text="ҽ�ƻ������ƣ� "+LgHospDesc+"                  �����¼���� "+RepType;
	//myTable.Cell(n+2,2).Height="25";
	//WordApp. Selection.ParagraphFormat.Alignment=1 //1���ж���,0Ϊ����
	myTable.Cell(3,1).range.Text="�¼����̣���ϸ��������"+RepProcess;
	myTable.Cell(3,1).Height="200";
	myTable.Rows(4).Cells.Merge();//�ϲ�����
	//myTable.Rows(4).Alignment=1;//1���ж���,0Ϊ����
	myTable.Cell(4,1).range.Text="ԭ�����"
	myTable.Cell(4,1).width=420;
	myTable.Cell(5,1).width=140;
	myTable.Cell(5,1).range.Text="�ˣ��κ������Ա��";
	myTable.Cell(5,2).width=280;
	myTable.Cell(5,1).Height="50";
	
	myTable.Cell(6,1).width=140;
	myTable.Cell(6,1).range.Text="���������ڡ����ߡ�ָ�Ϲ淶��";
	myTable.Cell(6,2).width=280;
	myTable.Cell(6,1).Height="50";
	
	myTable.Cell(7,1).width=140;
	myTable.Cell(7,1).range.Text="���ϣ�������Ʒ���Ĳġ���ʽ����ѵ�ֲᣩ";
	myTable.Cell(7,2).width=280;
	myTable.Cell(7,1).Height="50";
	
	myTable.Cell(8,1).width=140;
	myTable.Cell(8,1).range.Text="�������������豸��ϵͳ��";
	myTable.Cell(8,2).width=280;
	myTable.Cell(8,1).Height="50";
	
	myTable.Cell(9,1).width=140;
	myTable.Cell(9,1).range.Text="�������¶ȣ�ʪ�ȣ��������ţ�������������Ⱦ��";
	myTable.Cell(9,2).width=280;
	myTable.Cell(9,1).Height="50";
	
	myTable.Cell(10,1).width=140;
	myTable.Cell(10,1).range.Text="����";
	myTable.Cell(10,2).width=280;
	myTable.Cell(10,1).Height="50";
	
	myTable.Cell(11,1).width=140;
	myTable.Cell(11,1).range.Text="�Ľ���ʩ�뷽����";
	myTable.Cell(11,2).width=280;
	myTable.Cell(11,1).Height="50";
	
	myTable.Cell(12,1).width=140;
	myTable.Cell(12,1).range.Text="���ۣ�";
	myTable.Cell(12,2).width=280;
	myTable.Cell(12,1).Height="50";	
	
	myTable.range.ParagraphFormat.Alignment = 0; //�������
	row_count = 0; 
	col_count = 0 
	myDoc.Protect(1)  */
	
	//1����ȡXLS����·��
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_ExportWord.docx";
	
	
	var WordApp=new ActiveXObject("Word.Application");  
	WordApp.Application.Visible=true; //ִ�����֮���Ƿ񵯳��Ѿ����ɵ�word 
	
	//var myDoc = WordApp.documents.open("E:\\�����ĵ�\\word��ӡ����\\word��ӡ����\\bianshuai.docx");     //�˴�Ϊ�����е�ģ��
	var myDoc = WordApp.documents.open(Template);     //�˴�Ϊ�����е�ģ��
	var table=WordApp.ActiveDocument.Tables(1);	
	table.Cell(1,2).range.Text=RepDate;
	table.Cell(1,4).range.Text=OccDateTime;
	table.Cell(2,2).range.Text=LgHospDesc;
	table.Cell(2,4).range.Text=RepType;
	table.Cell(3,1).range.Text="�¼����̣���ϸ��������"+RepProcess;
	myDoc.Protect(1) 
	RepType=RepType.replace("/","��");
	RepDate=RepDate.replace(/(\/)/g,"-");
	myDoc .saveAs(filePath+"��������ҽԺ"+RepType+RepDate+".docx");     //��ŵ�ָ����λ��ע��·��һ��Ҫ�ǡ�\\����Ȼ�ᱨ��
}
			
		
///�����¼���������excelͳ��
function ExportExcelStatic(StDate,EndDate,filePath)
{ 
	var  retvalArr="",succflag="false"

	runClassMethod("web.DHCADVCOMMONPRINT","GetExportbyExcel",
	{StDate:StDate,EndDate:EndDate},function(ret){
				
		retvalArr=ret.replace(/(^\s*)|(\s*$)/g,"").split("^");
	},"",false);
	if(retvalArr==""){
		$.messager.alert("��ʾ:","ȡ���ݴ���");
		return;
	}	
	//1����ȡXLS����·��
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_ExportStatic.xls";

	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	objSheet.Cells(2,5).value=LgHospDesc; //ҽԺ����
	objSheet.Cells(8,1).value=retvalArr[0]; //����
	objSheet.Cells(8,2).value=retvalArr[1]; //Ȭ��
	objSheet.Cells(8,3).value=retvalArr[2]; //��ת
	objSheet.Cells(8,4).value=retvalArr[3]; //δ��չ
	objSheet.Cells(8,5).value=retvalArr[4]; //��չ
	objSheet.Cells(8,6).value=retvalArr[5]; //��
	objSheet.Cells(8,7).value=retvalArr[6]; //��
	objSheet.Cells(8,8).value=retvalArr[7]; //��
	objSheet.Cells(8,9).value=retvalArr[8]; //��
	objSheet.Cells(8,10).value=retvalArr[9]; //��
	objSheet.Cells(8,11).value=retvalArr[10]; //��
	objSheet.Cells(8,12).value=retvalArr[11]; //Ժ�����
	objSheet.Cells(8,13).value=retvalArr[12]; //θ��
	objSheet.Cells(8,14).value=retvalArr[13]; //���
	objSheet.Cells(8,15).value=retvalArr[14]; //���
	objSheet.Cells(8,16).value=retvalArr[15]; //����
	objSheet.Cells(8,17).value=retvalArr[16]; //����
	objSheet.Cells(8,18).value=retvalArr[17]; //׹��
	objSheet.Cells(8,19).value=retvalArr[18]; //������
	objSheet.Cells(8,20).value=retvalArr[19]; //ʱ��
	objSheet.Cells(8,21).value=retvalArr[20]; //����
	objSheet.Cells(8,22).value=retvalArr[21]; //����
	objSheet.Cells(8,23).value=retvalArr[22]; //��ʧ
	objSheet.Cells(8,24).value=retvalArr[23]; //��ɱ
	objSheet.Cells(8,25).value=retvalArr[24]; //����
	objSheet.Cells(8,26).value=retvalArr[25]; //����
	objSheet.Cells(8,27).value=retvalArr[26]; //ҽ�����
	objSheet.Cells(8,28).value=retvalArr[27]; //ҩ�����
	objSheet.Cells(8,29).value=retvalArr[28]; //�������
	objSheet.Cells(8,30).value=retvalArr[29]; //����

	objSheet.Cells(13,5).value=LgUserName; //�ϱ���
	objSheet.Cells(13,16).value="64456715"; //��ϵ�绰
	objSheet.Cells(13,24).value=formatDate(0); //�ϱ�ʱ��
	succflag=xlBook.SaveAs(filePath+"�����г�����ҽ�ƻ�������ȫ���������¼�����"+".xls");
	//xlApp=null;
	//xlBook.Close(savechanges=false);
	xlApp.Visible=true;////////////////////ceshidakai
	objSheet=null;
	return succflag;
}

///�����¼�ҽ�ֵܾ���excelͳ��
function ExportExcelAllData(StDate,EndDate,RepType,filePath)
{ 
	var  retvalArr="",succflag="false"

	runClassMethod("web.DHCADVCOMMONPRINT","GetExpbyExcel",
	{StDate:StDate,EndDate:EndDate,reporttype:RepType},function(ret){
				
		retvalArr=ret;
	},"json",false);
	RepType=RepType.replace("/","��");
	StDate=StDate.replace(/(\/)/g,"-");
	EndDate=EndDate.replace(/(\/)/g,"-");
	var NameList=RepType+StDate+"��"+EndDate;
	if(retvalArr==""){
		$.messager.alert("��ʾ:","ȡ���ݴ���");
		return false;
	}		
		//�����¼����浥
		if(RepType=="�����¼����浥"){  
			succflag=exportAccidentData(retvalArr,filePath,NameList); //
		}
		//��ҩ���󱨸浥
		if(RepType=="��ҩ���󱨸浥"){ 
			succflag=exportDrugErrData(retvalArr,filePath,NameList);
		}
		//����(׹��)�¼����浥	
		if(RepType=="����(׹��)�¼����浥"){  
			succflag=exportFallDownData(retvalArr,filePath,NameList);
		}
		//��·���䱨�浥
		if(RepType=="��·���ѱ��浥"){  
			succflag=exportPipeOffData(retvalArr,filePath,NameList);
		}
		//ѹ�����浥
		if(RepType=="ѹ�����浥"){  
			succflag=exportSkinUlcerData(retvalArr,filePath,NameList);
		}	
	return succflag;
}
//ygj �����¼����浥����
function exportAccidentData(data,filePath,NameList){
	var succflag="false";
	//var data=DataList.split("$$")
	var strjLen=data.length;
	//1����ȡXLS����·��
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_AccidentFillexcel.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;	
	for (i=0;i<strjLen;i++)
  	{
		objSheet.Cells(2+i,1).value=$g(data[i]["RepHospType"]); //���λ
		objSheet.Cells(2+i,2).value="'"+"003903110105210111"; //�����ǼǺ�
		objSheet.Cells(2+i,3).value="'"+$g(data[i]["DeptLocOne"]); //�����1		
		objSheet.Cells(2+i,4).value="'"+$g(data[i]["DeptLocTwo"]); //�����2
		objSheet.Cells(2+i,5).value="'"+$g(data[i]["ReportDate"]); //��������	
		objSheet.Cells(2+i,6).value=$g(data[i]["DisMedThingPatName"]); //��������
		objSheet.Cells(2+i,7).value=$g(data[i]["PatMedicalNo"]); //������	
		objSheet.Cells(2+i,8).value=$g(data[i]["OccuLoc"]); //��������		
		objSheet.Cells(2+i,9).value=radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data[i]); //������Դ
		objSheet.Cells(2+i,10).value=$g(data[i]["PatSexinput"]); //�Ա�
		objSheet.Cells(2+i,11).value=$g(data[i]["PatAge"]); //����
		objSheet.Cells(2+i,12).value="'"+radioValue("DegreeEducate-94370,DegreeEducate-94371,DegreeEducate-94372,DegreeEducate-94373,DegreeEducate-94374,DegreeEducate-94375",data[i]); //�Ļ��̶�
		objSheet.Cells(2+i,13).value="'"+$g(data[i]["PatDiag"]); //��һ���		
		objSheet.Cells(2+i,14).value="'"+$g(data[i]["PatAdmDate"]); //��Ժ����  
		objSheet.Cells(2+i,15).value="'"+$g(data[i]["PatAdmADLScore"]); //��ԺʱADL�÷�
		objSheet.Cells(2+i,16).value="'"+radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data[i]); //������
		objSheet.Cells(2+i,17).value="'"+radioValue("PatSelfCareAbility-94345,PatSelfCareAbility-94346,PatSelfCareAbility-94347",data[i]); //���������չ�����
		objSheet.Cells(2+i,18).value="'"+radioValue("AFType-94495,AFType-94498,AFType-94499",data[i]); //�����¼���������
		objSheet.Cells(2+i,19).value=""; //�����¼���������
		var oth=radioValue("AFType-94500,AFType-94927,AFType-94978,AFType-94979,AFType-94980,AFType-94981,AFType-94165",data[i]);
		if(oth!=""){
			objSheet.Cells(2+i,18).value="'"+"����"
			objSheet.Cells(2+i,19).value="'"+oth;
		}
		objSheet.Cells(2+i,20).value="'"+$g(data[i]["HappenTime"])+" "+$g(data[i]["OccurTime"]).split(":")[0]+"ʱ"; //��ҩ��������
		objSheet.Cells(2+i,21).value="'"+radioValue("HappenPlace-label-94575,HappenPlace-label-94576,HappenPlace-label-94577,HappenPlace-label-94579,HappenPlace-label-94580,HappenPlace-label-94581,HappenPlace-label-94582,HappenPlace-label-94583,HappenPlace-label-94584,HappenPlace-label-94585",data[i]); //�����ص�
		objSheet.Cells(2+i,22).value="'"+radioValue("PatEscort-94349,PatEscort-94350",data[i]); //�㻤��Ա		
		objSheet.Cells(2+i,23).value="'"+radioValue("DiscoverMan-94528,DiscoverMan-94530,DiscoverMan-94531,DiscoverMan-94532",data[i]); //������
		objSheet.Cells(2+i,24).value="'"+radioValue("PipeDutyNurTitle-94468,PipeDutyNurTitle-94469,PipeDutyNurTitle-94470,PipeDutyNurTitle-94471",data[i]); //�¼��������໤ʿְ��
		objSheet.Cells(2+i,25).value=""; //��������
		if($g(data[i]["WLManWorkLife"])!=""){
			objSheet.Cells(2+i,25).value="'"+$g(data[i]["WLManWorkLife"])+"��"; //��������
		}	
		objSheet.Cells(2+i,26).value="'"+radioValue("AFResult-94565",data[i]); //�¼���ɵĺ��
		objSheet.Cells(2+i,27).value="'"+$g(data[i]["AFResult-94567"]); //�¼���ɵĺ��		
		if($g(data[i]["AFResult-94567"])!=""){
			objSheet.Cells(2+i,26).value="����"
		}
		objSheet.Cells(2+i,28).value="'"+$g(data[i]["WLEventProcess"]); //�¼�����
	}
	succflag=xlBook.SaveAs(filePath+NameList+".xlsx");
	//xlApp=null;
	//xlBook.Close(savechanges=false);
	xlApp.Visible=true;////////////////////ceshidakai
	objSheet=null;
	return succflag;
}
//ygj ��ҩ���󱨸浥
function exportDrugErrData(data,filePath,NameList)
{
	var succflag="false";
	//var data=DataList.split("$$")
	var strjLen=data.length;
	//1����ȡXLS����·��
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_DrugUseErrexcel.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;	
	for (i=0;i<strjLen;i++)
	{
		objSheet.Cells(2+i,1).value=$g(data[i]["RepHospType"]); //���λ
		objSheet.Cells(2+i,2).value="'"+"003903110105210111"; //�����ǼǺ�
		objSheet.Cells(2+i,3).value="'"+$g(data[i]["ReportDate"]); //��������
		objSheet.Cells(2+i,4).value="'"+$g(data[i]["DeptLocOne"]); //�����1		
		objSheet.Cells(2+i,5).value="'"+$g(data[i]["DeptLocTwo"]); //�����2
			
		objSheet.Cells(2+i,6).value=$g(data[i]["DisMedThingPatName"]); //��������
		objSheet.Cells(2+i,7).value=$g(data[i]["PatMedicalNo"]); //������	
		objSheet.Cells(2+i,8).value=$g(data[i]["OccuLoc"]); //��������		
		objSheet.Cells(2+i,9).value=$g(data[i]["PatSexinput"]); //�Ա�
		objSheet.Cells(2+i,10).value=$g(data[i]["PatAge"]); //����
		objSheet.Cells(2+i,11).value="'"+radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data[i]); //������Դ
		objSheet.Cells(2+i,12).value="'"+radioValue("DegreeEducate-94370,DegreeEducate-94371,DegreeEducate-94372,DegreeEducate-94373,DegreeEducate-94374,DegreeEducate-94375",data[i]); //�Ļ��̶�
		objSheet.Cells(2+i,13).value="'"+$g(data[i]["PatDiag"]); //��һ���		
		objSheet.Cells(2+i,14).value="'"+$g(data[i]["PatAdmDate"]); //��Ժ����
		objSheet.Cells(2+i,15).value="'"+radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data[i]); //������
		
		objSheet.Cells(2+i,16).value="'"+$g(data[i]["GiveDrugHappenTime"]); //��ҩ��������
		if($g(data[i]["OccurTime"])!=""){
			objSheet.Cells(2+i,16).value="'"+$g(data[i]["GiveDrugHappenTime"])+" "+$g(data["OccurTime"]).split(":")[0]+"ʱ"; //��ҩ��������
		}
			
		objSheet.Cells(2+i,17).value="'"+radioValue("DrugUsePartyTitle-94597,DrugUsePartyTitle-94599,DrugUsePartyTitle-94611,DrugUsePartyTitle-94612",data[i]); //������ְ��
		objSheet.Cells(2+i,18).value=""; //�����˹�������
		if($g(data[i]["DrugUsePartyWorkYears"])!=""){
			objSheet.Cells(2+i,25).value="'"+$g(data[i]["DrugUsePartyWorkYears"])+"��"; //�����˹�������
		}
		objSheet.Cells(2+i,19).value=$g(data[i]["Shift"]);  //���
		objSheet.Cells(2+i,20).value="'"+radioValue("DrugUseHappenPlace-label-94587,DrugUseHappenPlace-label-94588,DrugUseHappenPlace-label-94589,DrugUseHappenPlace-label-94590",data[i]); //�����ص�
		objSheet.Cells(2+i,21).value="'"+""; //�����ص� ����
		if($g(data[i]["DrugUseHappenPlace-label-94591"])!=""){
			objSheet.Cells(2+i,20).value="'"+"����"
			objSheet.Cells(2+i,21).value="'"+$g(data[i]["DrugUseHappenPlace-label-94591"])
		}
		objSheet.Cells(2+i,22).value="'"+$g(data[i]["DrugUseErrType-94616"]); //��ҩ�������	
		objSheet.Cells(2+i,23).value="'"+$g(data[i]["DrugUseErrType-94617"]); //��ҩʱ�����
		objSheet.Cells(2+i,24).value="'"+$g(data[i]["DrugUseErrType-94618"]); //��ҩ;������
		objSheet.Cells(2+i,25).value="'"+$g(data[i]["DrugUseErrType-94619"]); //��©��ҩ	
		objSheet.Cells(2+i,26).value="'"+$g(data[i]["DrugUseErrType-94620"]); //��Һ�ٶȴ���
		objSheet.Cells(2+i,27).value="'"+$g(data[i]["DrugUseErrType-94621"]); //��������		
		objSheet.Cells(2+i,28).value="'"+$g(data[i]["DrugUseErrType-94622"]); //���ʹ���
		objSheet.Cells(2+i,29).value="'"+$g(data[i]["DrugUseErrType-94623"]); //ҩ�����
		objSheet.Cells(2+i,30).value="'"+$g(data[i]["DrugUseErrType-94624"]); //ҩ��Ч�ڴ���
		objSheet.Cells(2+i,31).value="'"+$g(data[i]["DrugUseErrType-94625"]); //����
		objSheet.Cells(2+i,32).value="'"+""; // ���� ����
		if($g(data[i]["DrugUseErrType-94625"])!=""){
			objSheet.Cells(2+i,31).value="'"+"����"
			objSheet.Cells(2+i,32).value="'"+$g(data[i]["DrugUseErrType-94625"])
		}
		objSheet.Cells(2+i,33).value="'"+radioValue("DrugUseDefectResult-label-94633,DrugUseDefectResult-label-94634,DrugUseDefectResult-label-94635,DrugUseDefectResult-label-94636,DrugUseDefectResult-label-94637",data[i]); //ȱ������ĺ��
		objSheet.Cells(2+i,34).value="'"+""; // ȱ������ĺ������
		if($g(data[i]["DrugUseDefectResult-label-94638"])!=""){
			objSheet.Cells(2+i,33).value="'"+"����"
			objSheet.Cells(2+i,34).value="'"+$g(data[i]["DrugUseDefectResult-label-94638"])
		}
		objSheet.Cells(2+i,35).value="'"+$g(data[i]["WLEventProcess"]); // �¼�����
		
	}
	
	succflag=xlBook.SaveAs(filePath+NameList+".xlsx");
	//xlApp=null;
	//xlBook.Close(savechanges=false);
	xlApp.Visible=true;////////////////////ceshidakai
	objSheet=null;
	return succflag;
}

//ygj ����(׹��)�¼����浥
function exportFallDownData(data,filePath,NameList)
{
	var succflag="false";
	//var data=DataList.split("$$")
	var strjLen=data.length;
	//1����ȡXLS����·��
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_FallDownFillexcel.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;	
	for (i=0;i<strjLen;i++)
	{
		objSheet.Cells(2+i,1).value=$g(data[i]["RepHospType"]); //���λ
		objSheet.Cells(2+i,2).value="'"+"003903110105210111"; //�����ǼǺ�
		objSheet.Cells(2+i,3).value="'"+$g(data[i]["ReportDate"]); //��������
		objSheet.Cells(2+i,4).value="'"+$g(data[i]["DeptLocOne"]); //�����1		
		objSheet.Cells(2+i,5).value="'"+$g(data[i]["DeptLocTwo"]); //�����2
			
		objSheet.Cells(2+i,6).value=$g(data[i]["DisMedThingPatName"]); //��������
		objSheet.Cells(2+i,7).value=$g(data[i]["PatMedicalNo"]); //������	
		objSheet.Cells(2+i,8).value=$g(data[i]["OccuLoc"]); //��������		
		objSheet.Cells(2+i,9).value=$g(data[i]["PatSexinput"]); //�Ա�
		objSheet.Cells(2+i,10).value=$g(data[i]["PatAge"]); //����
		objSheet.Cells(2+i,11).value="'"+radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data[i]); //������Դ
		objSheet.Cells(2+i,12).value="'"+$g(data[i]["PatDiag"]); //��һ���
		
		objSheet.Cells(2+i,13).value="'"+$g(data[i]["PatAdmDate"]); //��Ժ����	
		objSheet.Cells(2+i,14).value="'"+$g(data[i]["PatAdmADLScore"]); //ADL�÷�
		objSheet.Cells(2+i,15).value="'"+radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data[i]); //������
		objSheet.Cells(2+i,16).value=radioValue("PatSelfCareAbility-94345,PatSelfCareAbility-94346,PatSelfCareAbility-94347",data[i]); //���������չ�����
		objSheet.Cells(2+i,17).value="'"+$g(data[i]["HappenTime"]); //��ҩ��������
		if($g(data[i]["OccurTime"])!=""){
			objSheet.Cells(2+i,17).value="'"+$g(data[i]["HappenTime"])+" "+$g(data[i]["OccurTime"]).split(":")[0]+"ʱ"; //��ҩ��������
		}
		objSheet.Cells(2+i,18).value="'"+radioValue("HappenPlace-label-94575,HappenPlace-label-94576,HappenPlace-label-94577,HappenPlace-label-94579,HappenPlace-label-94580,HappenPlace-label-94581,HappenPlace-label-94582,HappenPlace-label-94583,HappenPlace-label-94584",data[i]); //�����ص�
		objSheet.Cells(2+i,19).value="'"+""; //�����ص� ����
		if($g(data[i]["HappenPlace-label-94585"])!=""){
			objSheet.Cells(2+i,18).value="'"+"����"
			objSheet.Cells(2+i,19).value="'"+$g(data[i]["HappenPlace-label-94585"])
		}
		objSheet.Cells(2+i,20).value="'"+radioValue("PatEscort-94349,PatEscort-94350",data[i]); //�㻤��Ա	
		
		objSheet.Cells(2+i,21).value="'"+($g(data[i]["OccurReason-95068"])==""?"":"��"); //��������
		objSheet.Cells(2+i,22).value="'"+($g(data[i]["OccurReason-95068-95072"])==""?"":"��"); //��ʶ�ϰ�	
		objSheet.Cells(2+i,23).value="'"+($g(data[i]["OccurReason-95068-95073"])==""?"":"��"); //�����������ϰ�
		objSheet.Cells(2+i,24).value="'"+($g(data[i]["OccurReason-95068-95074"])==""?"":"��"); //��ϰ�
		objSheet.Cells(2+i,25).value="'"+($g(data[i]["OccurReason-95068-95085"])==""?"":"��"); //�е���ʷ	
		objSheet.Cells(2+i,26).value="'"+($g(data[i]["OccurReason-95068-95088"])==""?"":"��"); //����
		objSheet.Cells(2+i,27).value="'"+""; //����		
		objSheet.Cells(2+i,28).value="'"+""; //������������
		if($g(data[i]["OccurReason-95068-95089"])!=""){
			objSheet.Cells(2+i,27).value="'"+"��"
			objSheet.Cells(2+i,28).value="'"+$g(data[i]["OccurReason-95068-95089"])
		}
		objSheet.Cells(2+i,29).value="'"+($g(data[i]["OccurReason-95069"])==""?"":"��"); //ҩ������
		objSheet.Cells(2+i,30).value="'"+($g(data[i]["OccurReason-95069-95094"])==""?"":"��"); //ɢͫ��	
		objSheet.Cells(2+i,31).value="'"+($g(data[i]["OccurReason-95069-95095"])==""?"":"��"); //�򾲰��߼�
		objSheet.Cells(2+i,32).value="'"+($g(data[i]["OccurReason-95069-95098"])==""?"":"��"); //��ѹ�����
		objSheet.Cells(2+i,33).value="'"+($g(data[i]["OccurReason-95069-95099"])==""?"":"��"); //���Ǽ�	
		objSheet.Cells(2+i,34).value="'"+($g(data[i]["OccurReason-95069-95102"])==""?"":"��"); //���ο���
		objSheet.Cells(2+i,35).value="'"+($g(data[i]["OccurReason-95069-95103"])==""?"":"��"); //����ֹʹ��	
		objSheet.Cells(2+i,36).value="'"+($g(data[i]["OccurReason-95069-95104"])==""?"":"��"); //кҩ
		objSheet.Cells(2+i,37).value="'"+""; //����		
		objSheet.Cells(2+i,38).value="'"+""; //����ҩ������
		if($g(data[i]["OccurReason-95069-95105"])!=""){
			objSheet.Cells(2+i,37).value="'"+"��"
			objSheet.Cells(2+i,38).value="'"+$g(data[i]["OccurReason-95069-95105"])
		}
		objSheet.Cells(2+i,39).value="'"+($g(data[i]["OccurReason-95070"])==""?"":"��"); //��������
		objSheet.Cells(2+i,40).value="'"+($g(data[i]["OccurReason-95070-95106"])==""?"":"��"); //��������	
		objSheet.Cells(2+i,41).value="'"+($g(data[i]["OccurReason-95070-95112"])==""?"":"��"); //�豸��ʩȱ�ݻ����
		objSheet.Cells(2+i,42).value="'"+($g(data[i]["OccurReason-95070-95113"])==""?"":"��"); //���̲���λ
		objSheet.Cells(2+i,43).value="'"+($g(data[i]["OccurReason-95070-95114"])==""?"":"��"); //������λ	
		objSheet.Cells(2+i,44).value="'"+($g(data[i]["OccurReason-95070-95121"])==""?"":"��"); //��ѵ����λ
		objSheet.Cells(2+i,45).value="'"+""; //����		
		objSheet.Cells(2+i,46).value="'"+""; //������������
		if($g(data[i]["OccurReason-95070-95122"])!=""){
			objSheet.Cells(2+i,45).value="'"+"��"
			objSheet.Cells(2+i,46).value="'"+$g(data[i]["OccurReason-95070-95122"]);
		}
		objSheet.Cells(2+i,47).value="'"+$g(data[i]["OccurReason-95071"]); //��������	
									
		objSheet.Cells(2+i,48).value="'"+radioValue("DiscoverMan-94528,DiscoverMan-94530,DiscoverMan-94531",data[i]); //������
		objSheet.Cells(2+i,49).value="'"+""; //����������
		if($g(data[i]["DiscoverMan-94532"])!=""){
			objSheet.Cells(2+i,48).value="'"+"����"
			objSheet.Cells(2+i,49).value="'"+$g(data[i]["DiscoverMan-94532"]);
		}
		objSheet.Cells(2+i,50).value="'"+radioValue("PipeDutyNurTitle-94468,PipeDutyNurTitle-94469,PipeDutyNurTitle-94470,PipeDutyNurTitle-94471",data[i]); //�¼��������໤ʿְ��
		objSheet.Cells(2+i,51).value=""; //��������
		if($g(data[i]["WLManWorkLife"])!=""){
			objSheet.Cells(2+i,51).value="'"+$g(data[i]["WLManWorkLife"])+"��"; //��������
		}
		objSheet.Cells(2+i,52).value="'"+radioValue("FDPatState-95051,FDPatState-95052,FDPatState-95053,FDPatState-95054,FDPatState-95055,FDPatState-95056,FDPatState-95057,FDPatState-95058,FDPatState-95059,FDPatState-95060,FDPatState-95061",data[i]); //����/���䣨ָ����������κβ�λ��������˫�ţ����ⴥ�����棩ʱ���ߵ�״̬	
		objSheet.Cells(2+i,53).value="'"+""; //״̬����
		if($g(data[i]["FDPatState-95062"])!=""){
			objSheet.Cells(2+i,52).value="'"+"����"
			objSheet.Cells(2+i,53).value="'"+$g(data[i]["FDPatState-95062"]);
		}
		
		objSheet.Cells(2+i,54).value="'"+$g(data[i]["JuredPart"]); //���˲�λ		
		objSheet.Cells(2+i,55).value="'"+radioValue("FDResult-95131,FDResult-95134",data[i]); //��ɺ��  
		objSheet.Cells(2+i,56).value="'"+""; //��ɺ������
		if($g(data[i]["FDResult-94245"])!=""){
			objSheet.Cells(2+i,55).value="'"+"����"
			objSheet.Cells(2+i,56).value="'"+$g(data[i]["FDResult-94245"]);
		}
		objSheet.Cells(2+i,57).value="'"+$g(data[i]["WLEventProcess"]); //�¼�����
		
	}
	
	succflag=xlBook.SaveAs(filePath+NameList+".xlsx");
	//xlApp=null;
	//xlBook.Close(savechanges=false);
	xlApp.Visible=true;////////////////////ceshidakai
	objSheet=null;
	return succflag;
}
//ygj ��·���ѱ��浥
function exportPipeOffData(data,filePath,NameList)
{
	var succflag="false";
	//var data=DataList.split("$$")
	var strjLen=data.length;
	//1����ȡXLS����·��
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_PipeOffexcel.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;	
	for (i=0;i<strjLen;i++)
	{
		objSheet.Cells(2+i,1).value=$g(data[i]["RepHospType"]); //���λ
		objSheet.Cells(2+i,2).value="'"+"003903110105210111"; //�����ǼǺ�
		objSheet.Cells(2+i,3).value="'"+$g(data[i]["ReportDate"]); //��������
		objSheet.Cells(2+i,4).value="'"+$g(data[i]["DeptLocOne"]); //�����1		
		objSheet.Cells(2+i,5).value="'"+$g(data[i]["DeptLocTwo"]); //�����2
			
		objSheet.Cells(2+i,6).value=$g(data[i]["DisMedThingPatName"]); //��������
		objSheet.Cells(2+i,7).value=$g(data[i]["PatMedicalNo"]); //������	
		objSheet.Cells(2+i,8).value=$g(data[i]["OccuLoc"]); //��������		
		objSheet.Cells(2+i,9).value=$g(data[i]["PatSexinput"]); //�Ա�
		objSheet.Cells(2+i,10).value=$g(data[i]["PatAge"]); //����
		objSheet.Cells(2+i,11).value="'"+radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data[i]); //������Դ
		objSheet.Cells(2+i,12).value="'"+radioValue("DegreeEducate-94370,DegreeEducate-94371,DegreeEducate-94372,DegreeEducate-94373,DegreeEducate-94374,DegreeEducate-94375",data[i]); //�Ļ��̶�
		objSheet.Cells(2+i,13).value="'"+$g(data[i]["PatDiag"]); //��һ���
		
		objSheet.Cells(2+i,14).value="'"+$g(data[i]["PatAdmDate"]); //��Ժ����	
		objSheet.Cells(2+i,15).value="'"+$g(data[i]["PatAdmADLScore"]); //ADL�÷�
		objSheet.Cells(2+i,16).value="'"+radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data[i]); //������
		objSheet.Cells(2+i,17).value=radioValue("PatSelfCareAbility-94345,PatSelfCareAbility-94346,PatSelfCareAbility-94347",data[i]); //���������չ�����
		
		objSheet.Cells(2+i,18).value="'"+($g(data[i]["PipeType-94449"])==""?"":"��"); //θ��
		objSheet.Cells(2+i,19).value="'"+($g(data[i]["PipeType-94450"])==""?"":"��"); //���	
		objSheet.Cells(2+i,20).value="'"+($g(data[i]["PipeType-94451"])==""?"":"��"); //͸����·
		objSheet.Cells(2+i,21).value="'"+($g(data[i]["PipeType-94452"])==""?"":"��"); //���ܲ��
		objSheet.Cells(2+i,22).value="'"+($g(data[i]["PipeType-94453"])==""?"":"��"); //�����п��׹�	
		objSheet.Cells(2+i,23).value="'"+($g(data[i]["PipeType-94454"])==""?"":"��"); //���ǹ�
		objSheet.Cells(2+i,24).value="'"+($g(data[i]["PipeType-94455"])==""?"":"��"); //�����ù�
		objSheet.Cells(2+i,25).value="'"+($g(data[i]["PipeType-94456"])==""?"":"��"); //����ù�	
		objSheet.Cells(2+i,26).value="'"+($g(data[i]["PipeType-94457"])==""?"":"��"); //PICC
		objSheet.Cells(2+i,27).value="'"+($g(data[i]["PipeType-94458"])==""?"":"��"); //��ǻ��ʽ������
		objSheet.Cells(2+i,28).value="'"+($g(data[i]["PipeType-94459"])==""?"":"��"); //��ǻ������
		objSheet.Cells(2+i,29).value="'"+($g(data[i]["PipeType-94460"])==""?"":"��"); //�˿�������	
		objSheet.Cells(2+i,30).value="'"+($g(data[i]["PipeType-94461"])==""?"":"��"); //�İ�������
		objSheet.Cells(2+i,31).value="'"+($g(data[i]["PipeType-94462"])==""?"":"��"); //����������
		objSheet.Cells(2+i,32).value="'"+""; //����	
		objSheet.Cells(2+i,33).value="'"+""; //��������		
		if($g(data[i]["PipeType-94463"])!=""){
			objSheet.Cells(2+i,32).value="'"+"��"
			objSheet.Cells(2+i,33).value="'"+$g(data[i]["PipeType-94463"])
		}
		
		objSheet.Cells(2+i,34).value="'"+$g(data[i]["PipeFindDate"]); //�ѹܷ���ʱ��
		if($g(data[i]["OccurTime"])!=""){
			objSheet.Cells(2+i,17).value="'"+$g(data[i]["PipeFindDate"])+" "+$g(data[i]["OccurTime"]).split(":")[0]+"ʱ"; //�ѹܷ���ʱ��
		}
		
		objSheet.Cells(2+i,35).value="'"+$g(data[i]["TubeDate"]); //�ù�����	
		objSheet.Cells(2+i,36).value="'"+radioValue("PipeDiscoverers-94464,PipeDiscoverers-94465,PipeDiscoverers-94466",data[i]); //������
		objSheet.Cells(2+i,37).value="'"+""; //������������Ա
		if($g(data[i]["PipeDiscoverers-94467"])!=""){
			objSheet.Cells(2+i,36).value="'"+"����"
			objSheet.Cells(2+i,37).value="'"+$g(data[i]["PipeDiscoverers-94467"]);
		}
		objSheet.Cells(2+i,38).value="'"+radioValue("PipeDutyNurTitle-94468,PipeDutyNurTitle-94469,PipeDutyNurTitle-9446870,PipeDutyNurTitle-94471",data[i]); //�¼��������໤ʿְ��
		
		objSheet.Cells(2+i,39).value="'"+$g(data[i]["WallWorkYears"]); //��������
		if($g(data[i]["WallWorkYears"])!=""){
			objSheet.Cells(2+i,51).value="'"+$g(data[i]["WallWorkYears"])+"��"; //��������
		}
		objSheet.Cells(2+i,40).value="'"+radioValue("PipePS-94473-94476,PipePS-94473-94477,PipePS-94473-94478,PipePS-94473-94479,PipePS-94473-94480",data[i]); //��ʶ״̬	
		objSheet.Cells(2+i,41).value="'"+radioValue("PipePS-94474-94481,PipePS-94474-94482,PipePS-94474-94483,PipePS-94474-94484",data[i]); //����״̬
		if($g(data[i]["PipePS-94474-94485"])!=""){
			objSheet.Cells(2+i,40).value="'"+"����";
		}
		objSheet.Cells(2+i,42).value="'"+radioValue("PipePS-94475-94486,PipePS-94475-94487,PipePS-94475-94488,PipePS-94475-94489",data[i]); //�����
		objSheet.Cells(2+i,43).value="'"+$g(data[i]["PipePS-94475-94490"]); //���������
		if($g(data[i]["PipePS-94475-94490"])!=""){
			objSheet.Cells(2+i,42).value="'"+"����";
			objSheet.Cells(2+i,43).value="'"+$g(data[i]["PipePS-94475-94490"]);
		}
		
		objSheet.Cells(2+i,44).value="'"+radioValue("PipeReason-94493,PipeReason-94494,PipeReason-94496",data[i]); //�ѹ�ԭ��
		objSheet.Cells(2+i,45).value="'"+""; //�ѹ�ԭ������	
		if($g(data[i]["PipeReason-94497"])!=""){
			objSheet.Cells(2+i,44).value="'"+"����";
			objSheet.Cells(2+i,45).value="'"+$g(data[i]["PipeReason-94497"]);
		}
			
		objSheet.Cells(2+i,46).value="'"+radioValue("PipeFixedMethod-94503,PipeFixedMethod-94506,PipeFixedMethod-94507,PipeFixedMethod-94508",data[i]); //�̶�����
		objSheet.Cells(2+i,47).value="'"+""; //�̶���������	
		if($g(data[i]["PipeFixedMethod-94509"])!=""){
			objSheet.Cells(2+i,46).value="'"+"����";
			objSheet.Cells(2+i,47).value="'"+$g(data[i]["PipeFixedMethod-94509"]);
		}
									
		objSheet.Cells(2+i,48).value="'"+radioValue("PipeOther-94512-94518,PipeOther-94512-94519",data[i]); //��������
		objSheet.Cells(2+i,49).value="'"+radioValue("PipeOther-94513-94520,PipeOther-94513-94521",data[i]); //Լ����ʹ��
		
		objSheet.Cells(2+i,50).value="'"+radioValue("PipeOther-94515-94522,PipeOther-94515-94523",data[i]); //�¼�����ǰ�����Ƿ�ʹ����ҩ��
		
		objSheet.Cells(2+i,51).value="'"+radioValue("PatEscort-94349,PatEscort-94350",data[i]); //�㻤��Ա
		objSheet.Cells(2+i,52).value="'"+radioValue("PipeOther-94516-94524,PipeOther-94516-94525",data[i]); //��·����ʱ������Ա
		objSheet.Cells(2+i,53).value="'"+radioValue("PipeOther-94517-94526,PipeOther-94517-94527",data[i]); //���߼����Ƿ�������·�����¼�	

		objSheet.Cells(2+i,54).value="'"+radioValue("PipeComplication-94539,PipeComplication-94540",data[i]); //����֢
		objSheet.Cells(2+i,55).value="'"+""; //��Ѫ	
		objSheet.Cells(2+i,56).value="'"+""; //��ѪMl
		if($g(data[i]["PipeComplication-94540-94541"])!=""){
			objSheet.Cells(2+i,55).value="'"+"��"
			objSheet.Cells(2+i,56).value="'"+$g(data[i]["PipeComplication-94540-94541"])
		}
		objSheet.Cells(2+i,57).value="'"+($g(data[i]["PipeComplication-94540-94542"])==""?"":"��"); //��˨
		objSheet.Cells(2+i,58).value="'"+($g(data[i]["PipeComplication-94540-94543"])==""?"":"��"); //Ѫ˨
		objSheet.Cells(2+i,59).value="'"+($g(data[i]["PipeComplication-94540-94544"])==""?"":"��"); //��Ϣ	
		objSheet.Cells(2+i,60).value="'"+($g(data[i]["PipeComplication-94540-94545"])==""?"":"��"); //��Ⱦ
		objSheet.Cells(2+i,61).value="'"+($g(data[i]["PipeComplication-94540-94546"])==""?"":"��"); //����
		objSheet.Cells(2+i,62).value="'"+($g(data[i]["PipeComplication-94540-94547"])==""?"":"��"); //�ǺϿ���
		objSheet.Cells(2+i,63).value="'"+""; //����	
		objSheet.Cells(2+i,64).value="'"+""; //��������֢		
		if($g(data[i]["PipeComplication-94540-94548"])!=""){
			objSheet.Cells(2+i,63).value="'"+"��"
			objSheet.Cells(2+i,64).value="'"+$g(data[i]["PipeComplication-94540-94547"])
		}
		
		objSheet.Cells(2+i,65).value="'"+($g(data[i]["PipeTakeSteps-94533"])==""?"":"��"); //�����ù�  
		objSheet.Cells(2+i,66).value="'"+($g(data[i]["PipeTakeSteps-94534"])==""?"":"��"); //�ѹܲ�λ����
		objSheet.Cells(2+i,67).value="'"+($g(data[i]["PipeTakeSteps-94536"])==""?"":"��"); //����Լ��
		objSheet.Cells(2+i,68).value="'"+""; //����
		objSheet.Cells(2+i,69).value="'"+""; //������ʩ
		if($g(data[i]["PipeTakeSteps-94537"])!=""){
			objSheet.Cells(2+i,68).value="'"+"��"
			objSheet.Cells(2+i,69).value="'"+$g(data[i]["PipeTakeSteps-94537"]);
		}
		objSheet.Cells(2+i,70).value="'"+$g(data[i]["WLEventProcess"]); //�¼�����
		
	}
	
	succflag=xlBook.SaveAs(filePath+NameList+".xlsx");
	//xlApp=null;
	//xlBook.Close(savechanges=false);
	xlApp.Visible=true;////////////////////ceshidakai
	objSheet=null;
	return succflag;
}

//ygj ѹ�����浥
function exportSkinUlcerData(data,filePath,NameList)
{
	var succflag="false";
	//var data=DataList.split("$$")
	var strjLen=data.length;
	//1����ȡXLS����·��
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_SkinUlcerexcel.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;	
	for (i=0;i<strjLen;i++)
	{
		objSheet.Cells(3+i,1).value=$g(data[i]["RepHospType"]); //���λ
		objSheet.Cells(3+i,2).value="'"+"003903110105210111"; //�����ǼǺ�
		objSheet.Cells(3+i,3).value="'"+$g(data[i]["ReportDate"]); //��������
		objSheet.Cells(3+i,4).value="'"+$g(data[i]["DeptLocOne"]); //�����1		
		objSheet.Cells(3+i,5).value="'"+$g(data[i]["DeptLocTwo"]); //�����2
			
		objSheet.Cells(3+i,6).value=$g(data[i]["DisMedThingPatName"]); //��������
		objSheet.Cells(3+i,7).value=$g(data[i]["PatMedicalNo"]); //������	
		objSheet.Cells(3+i,8).value=$g(data[i]["OccuLoc"]); //��������		
		objSheet.Cells(3+i,9).value=$g(data[i]["PatSexinput"]); //�Ա�
		objSheet.Cells(3+i,10).value=$g(data[i]["PatAge"]); //����
		objSheet.Cells(3+i,11).value="'"+radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data[i]); //������Դ
		
		objSheet.Cells(3+i,12).value="'"+$g(data[i]["PatDiag"]).split(",")[0]; //��һ���
		
		objSheet.Cells(3+i,13).value="'"+$g(data[i]["PatAdmDate"]); //��Ժ����	
		objSheet.Cells(3+i,14).value="'"+$g(data[i]["PatAdmADLScore"]); //ADL�÷�
		objSheet.Cells(3+i,15).value="'"+radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data[i]); //������
		objSheet.Cells(3+i,16).value="'"+radioValue("UseUlcerRiskpointtab-94929,UseUlcerRiskpointtab-94930,UseUlcerRiskpointtab-94931",data[i]); //ʹ��ѹ���������ֱ�
		objSheet.Cells(3+i,17).value="'"+""; //����_����		
		if($g(data[i]["UseUlcerRiskpointtab-94932"])!=""){
			objSheet.Cells(3+i,16).value="'"+"����"
			objSheet.Cells(3+i,17).value="'"+$g(data[i]["UseUlcerRiskpointtab-94932"])
		}
		objSheet.Cells(3+i,18).value=radioValue("PatSelfCareAbility-94345,PatSelfCareAbility-94346,PatSelfCareAbility-94347",data[i]); //���������չ�����
		objSheet.Cells(3+i,19).value="'"+$g(data[i]["OccurUlcerRiskScore"]); //ѹ����������
		objSheet.Cells(3+i,20).value="'"+radioValue("OccurUlcerRiskLev-94943,OccurUlcerRiskLev-94944,OccurUlcerRiskLev-94945,OccurUlcerRiskLev-94946",data[i]); //���յȼ�		
		objSheet.Cells(3+i,21).value="'"+radioValue("PatEscort-94349,PatEscort-94340",data); //�㻤��Ա
																														
		var UlcerPartlist=$g(data[i]["UlcerPart"]);//ѹ����λ
		var Ulcerlen=UlcerPartlist.length; //ѹ����λ����
		if (Ulcerlen>4){
			Ulcerlen=4;
		}
		for(var k=0;k<Ulcerlen;k++){
		
			objSheet.Cells(3+i,22+32*k).value="'"+radioValue("UlcerPart-95158-95163-95170,UlcerPart-95158-95163-95171",UlcerPartlist[k]); //ѹ����Դ	
			objSheet.Cells(3+i,23+32*k).value="'"+$g(UlcerPartlist[k]["UlcerPart-95158-95162-95192"]); //ѹ����������
			objSheet.Cells(3+i,24+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95172"])==""?"":"��"); //��λ_��
			objSheet.Cells(3+i,25+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95178"])==""?"":"��"); //��λ_��β��	
			objSheet.Cells(3+i,26+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95173"])==""?"":"��"); //��λ_����
			objSheet.Cells(3+i,27+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95173-95196"])==""?"":"��"); //����_��
			objSheet.Cells(3+i,28+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95173-95197"])==""?"":"��"); //����_��
			objSheet.Cells(3+i,29+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95179"])==""?"":"��"); //��λ_ϥ��	
			objSheet.Cells(3+i,30+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95179-94189"])==""?"":"��"); //ϥ��_��
			objSheet.Cells(3+i,31+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95179-94190"])==""?"":"��"); //ϥ��_��
			objSheet.Cells(3+i,32+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95174"])==""?"":"��"); //��λ_���β�
			objSheet.Cells(3+i,33+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95174-94173"])==""?"":"��"); //���β�_��
			objSheet.Cells(3+i,34+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95174-94174"])==""?"":"��"); //���β�_��
			objSheet.Cells(3+i,35+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95180"])==""?"":"��"); //��λ_�ײ�
			objSheet.Cells(3+i,36+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95180-94193"])==""?"":"��"); //�ײ�_��
			objSheet.Cells(3+i,37+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95180-94194"])==""?"":"��"); //�ײ�_��
			objSheet.Cells(3+i,38+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95175"])==""?"":"��"); //��λ_�ⲿ
			objSheet.Cells(3+i,39+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95175-94177"])==""?"":"��"); //�ⲿ_��
			objSheet.Cells(3+i,40+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95175-94178"])==""?"":"��"); //�ⲿ_��
			objSheet.Cells(3+i,41+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95181"])==""?"":"��"); //��λ_�����
			objSheet.Cells(3+i,42+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95181-94197"])==""?"":"��"); //�����_��
			objSheet.Cells(3+i,43+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95181-94198"])==""?"":"��"); //�����_��
			objSheet.Cells(3+i,44+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95176"])==""?"":"��"); //��λ_��ǰ�ϼ�
			objSheet.Cells(3+i,45+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95176-94181"])==""?"":"��"); //��ǰ�ϼ�_��
			objSheet.Cells(3+i,46+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95176-94182"])==""?"":"��"); //��ǰ�ϼ�_��
			objSheet.Cells(3+i,47+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95177"])==""?"":"��"); //��λ_�Ų�
			objSheet.Cells(3+i,48+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95177-94185"])==""?"":"��"); //�Ų�_��
			objSheet.Cells(3+i,49+32*k).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95177-94186"])==""?"":"��"); //�Ų�_��
			objSheet.Cells(3+i,50+32*k).value="'"+""; //����
			objSheet.Cells(3+i,51+32*k).value="'"+""; //����_����  	
			if($g(data[i]["UlcerPart-95158-95166-95182"])!=""){
				objSheet.Cells(3+i,50+32*k).value="'"+"��"
				objSheet.Cells(3+i,51+32*k).value="'"+$g(UlcerPartlist[k]["UlcerPart-95158-95166-95182"])
			}
			objSheet.Cells(3+i,52+32*k).value="'"+radioValue("UlcerPart-95158-95169-95183,UlcerPart-95158-95169-95184,UlcerPart-95158-95169-95185,UlcerPart-95158-95169-95186,UlcerPart-95158-95169-95187,UlcerPart-95158-95169-95188",UlcerPartlist[k]); //ѹ������
			objSheet.Cells(3+i,53+32*k).value="'"+""; //ѹ�����(cm*cm) 	
			if(($g(UlcerPartlist[k]["UlcerPart-95158-95189-94247"])!="")&&($g(UlcerPartlist[k]["UlcerPart-95158-95189-94249"]))){
				objSheet.Cells(3+i,53+32*k).value="'"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94247"])+"*"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94249"]);
			}

		}
		var Patreson=myRadioValue("UlcerOccurReason-94948-94952,UlcerOccurReason-94948-94953,UlcerOccurReason-94948-94954,UlcerOccurReason-94948-94955,UlcerOccurReason-94948-94956,UlcerOccurReason-94948-94957,UlcerOccurReason-94948-94958,UlcerOccurReason-94948-94959",data[i]);  //ѹ������ԭ�� ��������
		objSheet.Cells(3+i,150).value="'"+(Patreson==""?"":"��"); //��������	
		objSheet.Cells(3+i,151).value="'"+($g(data[i]["UlcerOccurReason-94948-94952"])==""?"":"��"); //�Դ�
		objSheet.Cells(3+i,152).value="'"+($g(data[i]["UlcerOccurReason-94948-94953"])==""?"":"��"); //�ƶ�
		objSheet.Cells(3+i,153).value="'"+($g(data[i]["UlcerOccurReason-94948-94954"])==""?"":"��"); //ǿ����λ	
		objSheet.Cells(3+i,154).value="'"+($g(data[i]["UlcerOccurReason-94948-94955"])==""?"":"��"); //����
		objSheet.Cells(3+i,155).value="'"+($g(data[i]["UlcerOccurReason-94948-94956"])==""?"":"��"); //��С��ʧ��
		objSheet.Cells(3+i,156).value="'"+($g(data[i]["UlcerOccurReason-94948-94957"])==""?"":"��"); //����
		objSheet.Cells(3+i,157).value="'"+($g(data[i]["UlcerOccurReason-94948-94958"])==""?"":"��"); //����	
		objSheet.Cells(3+i,158).value="'"+""; //����	
		objSheet.Cells(3+i,159).value="'"+""; //����_����		
		if($g(data[i]["UlcerOccurReason-94948-94959"])!=""){
			objSheet.Cells(3+i,158).value="'"+"��"
			objSheet.Cells(3+i,159).value="'"+$g(data[i]["UlcerOccurReason-94948-94959"])
		}
		
		var illnessreson=myRadioValue("UlcerOccurReason-94949-94960,UlcerOccurReason-94949-94961,UlcerOccurReason-94949-94962,UlcerOccurReason-94949-94963,UlcerOccurReason-94949-94964",data[i]);  //��������
		objSheet.Cells(3+i,160).value="'"+(illnessreson==""?"":"��"); //��������	
		objSheet.Cells(3+i,161).value="'"+($g(data[i]["UlcerOccurReason-94949-94960"])==""?"":"��"); //�͵���Ѫ֢
		objSheet.Cells(3+i,162).value="'"+($g(data[i]["UlcerOccurReason-94949-94961"])==""?"":"��"); //ƶѪ
		objSheet.Cells(3+i,163).value="'"+($g(data[i]["UlcerOccurReason-94949-94962"])==""?"":"��"); //����	
		objSheet.Cells(3+i,164).value="'"+($g(data[i]["UlcerOccurReason-94949-94963"])==""?"":"��"); //�о�����
		objSheet.Cells(3+i,165).value="'"+""; //����	
		objSheet.Cells(3+i,166).value="'"+""; //����_����		
		if($g(data[i]["UlcerOccurReason-94949-94964"])!=""){
			objSheet.Cells(3+i,165).value="'"+"��"
			objSheet.Cells(3+i,166).value="'"+$g(data[i]["UlcerOccurReason-94949-94964"])
		}
	
		var Nurreson=myRadioValue("UlcerOccurReason-94950-94966,UlcerOccurReason-94950-94967,UlcerOccurReason-94950-94968,UlcerOccurReason-94950-94969,UlcerOccurReason-94950-94970,UlcerOccurReason-94950-94971,UlcerOccurReason-94950-94972,UlcerOccurReason-94950-94973,UlcerOccurReason-94950-94974",data[i]);  //������Ա����
		objSheet.Cells(3+i,167).value="'"+(Nurreson==""?"":"��"); //������Ա����	
		objSheet.Cells(3+i,168).value="'"+($g(data[i]["UlcerOccurReason-94950-94966"])==""?"":"��"); //δ��ʱ����
		objSheet.Cells(3+i,169).value="'"+($g(data[i]["UlcerOccurReason-94950-94967"])==""?"":"��"); //δ��ʱ��ࡢ��ϴƤ��
		objSheet.Cells(3+i,170).value="'"+($g(data[i]["UlcerOccurReason-94950-94968"])==""?"":"��"); //������ʪ�����ࡢ����	
		objSheet.Cells(3+i,171).value="'"+($g(data[i]["UlcerOccurReason-94950-94969"])==""?"":"��"); //��·�ϳ�ʱ����ѹ��δ����
		objSheet.Cells(3+i,172).value="'"+($g(data[i]["UlcerOccurReason-94950-94970"])==""?"":"��"); //��·�̶�����
		objSheet.Cells(3+i,173).value="'"+($g(data[i]["UlcerOccurReason-94950-94971"])==""?"":"��"); //��������������ϡ���������ק��
		objSheet.Cells(3+i,174).value="'"+($g(data[i]["UlcerOccurReason-94950-94972"])==""?"":"��"); //������Ա��������	
		objSheet.Cells(3+i,175).value="'"+($g(data[i]["UlcerOccurReason-94950-94973"])==""?"":"��"); //����ʹ�ò���
		objSheet.Cells(3+i,176).value="'"+""; //����	
		objSheet.Cells(3+i,177).value="'"+""; //����_����		
		if($g(data[i]["UlcerOccurReason-94950-94974"])!=""){
			objSheet.Cells(3+i,176).value="'"+"��"
			objSheet.Cells(3+i,177).value="'"+$g(data[i]["UlcerOccurReason-94950-94974"])
		}
		var othreason=myRadioValue("UlcerOccurReason-94951-94975,UlcerOccurReason-94951-94976",data[i])//ѹ������ԭ��_��������
		objSheet.Cells(3+i,178).value="'"+(othreason==""?"":"��"); //ѹ������ԭ��_��������	
		objSheet.Cells(3+i,179).value="'"+($g(data[i]["UlcerOccurReason-94951-94975"])==""?"":"��"); //������Ա�䱸����
		objSheet.Cells(3+i,180).value="'"+""; //����	
		objSheet.Cells(3+i,181).value="'"+""; //����_����		
		if($g(data[i]["UlcerOccurReason-94951-94975"])!=""){
			objSheet.Cells(3+i,180).value="'"+"��"
			objSheet.Cells(3+i,181).value="'"+$g(data[i]["UlcerOccurReason-94951-94975"])
		}
	
	
		objSheet.Cells(3+i,182).value="'"+($g(data[i]["AdoptNursMeasure-95006"])==""?"":"��"); //���ӷ���Ƶ��
		objSheet.Cells(3+i,183).value="'"+($g(data[i]["AdoptNursMeasure-95007"])==""?"":"��"); //����Ƥ�����
		objSheet.Cells(3+i,184).value="'"+($g(data[i]["AdoptNursMeasure-95008"])==""?"":"��"); //���ִ���������ƽ��	
		objSheet.Cells(3+i,185).value="'"+($g(data[i]["AdoptNursMeasure-95009"])==""?"":"��"); //ʹ�÷�ѹ������
		objSheet.Cells(3+i,186).value="'"+($g(data[i]["AdoptNursMeasure-95010"])==""?"":"��"); //ʹ�������ڹ�¡ͻ��λ
		objSheet.Cells(3+i,187).value="'"+($g(data[i]["AdoptNursMeasure-95011"])==""?"":"��"); //Ӧ��ҽ���������ƴ���
		objSheet.Cells(3+i,188).value="'"+($g(data[i]["AdoptNursMeasure-95012"])==""?"":"��"); //��Ĥ������ѹ��λƤ��	
		objSheet.Cells(3+i,189).value="'"+($g(data[i]["AdoptNursMeasure-95013"])==""?"":"��"); //�˿ڻ�ҩ	
		objSheet.Cells(3+i,190).value="'"+""; //����	
		objSheet.Cells(3+i,191).value="'"+""; //����_����  
		if($g(data[i]["AdoptNursMeasure-95011"])!=""){
			objSheet.Cells(3+i,190).value="'"+"��"
			objSheet.Cells(3+i,191).value="'"+$g(data[i]["AdoptNursMeasure-95011"])
		}
		var UlcerOthlist="";
		for(var k=4;k<UlcerPartlist.length;k++){
			var orign=radioValue("UlcerPart-95158-95163-95170,UlcerPart-95158-95163-95171",UlcerPartlist[k]); //��Դ
			var orignout=radioValue("UlcerPart-95158-95163-95171-94233,UlcerPart-95158-95163-95171-94234,UlcerPart-95158-95163-95171-94235,UlcerPart-95158-95163-95171-94236",UlcerPartlist[k]); //Ժ�����
			if (orignout!=""){orign=orign+"��"+orignout+"��";}
			var part=""
			var qtpart=radioValue("UlcerPart-95158-95166-95172,UlcerPart-95158-95166-95178,UlcerPart-95158-95166-95182",UlcerPartlist[k]); //��λ
			if (qtpart!=""){part=qtpart+"�� "+part; }
			var ekpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95173"]),"UlcerPart-95158-95166-95173-95196,UlcerPart-95158-95166-95173-95197",UlcerPartlist[k]); //����
			if (ekpart!=""){part=ekpart+"�� "+part; }
			var jjpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95174"]),"UlcerPart-95158-95166-95174-94173,UlcerPart-95158-95166-95174-94174",UlcerPartlist[k]); //���β�
			if (jjpart!=""){part=jjpart+"�� "+part; }
			var zbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95175"]),"UlcerPart-95158-95166-95175-94177,UlcerPart-95158-95166-95175-94178",UlcerPartlist[k]); //�ⲿ
			if (zbpart!=""){part=zbpart+"�� "+part; }
			var qqsjpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95176"]),"UlcerPart-95158-95166-95175-94177,UlcerPart-95158-95166-95175-94178",UlcerPartlist[k]); //��ǰ�ϼ�
			if (qqsjpart!=""){part=qqsjpart+"�� "+part; }
			var kbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95177"]),"UlcerPart-95158-95166-95177-94185,UlcerPart-95158-95166-95177-94186",UlcerPartlist[k]); //�Ų�
			if (kbpart!=""){part=kbpart+"�� "+part; }
			var xbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95179"]),"UlcerPart-95158-95166-95179-94189,UlcerPart-95158-95166-95179-94190",UlcerPartlist[k]); //ϥ��
			if (xbpart!=""){part=xbpart+"�� "+part; }
			var hbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95180"]),"UlcerPart-95158-95166-95180-94193,UlcerPart-95158-95166-95180-94194",UlcerPartlist[k]); //�ײ�
			if (hbpart!=""){part=hbpart+"�� "+part; }
			var zgbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95181"]),"UlcerPart-95158-95166-95181-94197,UlcerPart-95158-95166-95181-94198",UlcerPartlist[k]); //�����
			if (zgbpart!=""){part=zgbpart+"�� "+part; }
			if (UlcerOthlist=""){
				UlcerOthlist="��λ"+(k+1)+"���������ڣ�"+$g(UlcerPartlist[k]["UlcerPart-95158-95162-95192"])+"��Դ��"+orign+"��λ��"+part+"���ڣ�"+radioValue("UlcerPart-95158-95169-95183,UlcerPart-95158-95169-95184,UlcerPart-95158-95169-95185,UlcerPart-95158-95169-95186,UlcerPart-95158-95169-95187,UlcerPart-95158-95169-95188",UlcerPartlist[k])+"���(������ cm��cm��cm)��"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94247"])+"��"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94249"])+"��"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94251"])+"��" ;
			}else{
				UlcerOthlist=UlcerOthlist+"��"+"��λ"+(k+1)+"���������ڣ�"+$g(UlcerPartlist[k]["UlcerPart-95158-95162-95192"])+"��Դ��"+orign+"��λ��"+part+"���ڣ�"+radioValue("UlcerPart-95158-95169-95183,UlcerPart-95158-95169-95184,UlcerPart-95158-95169-95185,UlcerPart-95158-95169-95186,UlcerPart-95158-95169-95187,UlcerPart-95158-95169-95188",UlcerPartlist[k])+"���(������ cm��cm��cm)��"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94247"])+"��"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94249"])+"��"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94251"])+"��" ;
			}
		}
		objSheet.Cells(3+i,192).value="'"+$g(data[i]["WLEventProcess"])+UlcerOthlist; //�¼�����(��ϸ����)	
		
	}
	
	succflag=xlBook.SaveAs(filePath+NameList+".xlsx");
	//xlApp=null;
	//xlBook.Close(savechanges=false);
	xlApp.Visible=true;////////////////////ceshidakai
	objSheet=null;
	return succflag;
}

//��̬����
function ExportData(StDate,EndDate,RepType,TitleList,DescList,filePath,TabFieldList,TabDescList)
{
	var data="",tabledata="";
	runClassMethod("web.DHCADVCOMMONPRINT","GetExportData",
	{StDate:StDate,EndDate:EndDate,reporttype:RepType,TitleList:TitleList,DescList:DescList},function(ret){
		data=ret;
	},"json",false);

	if((RepType.indexOf("ѹ��")>0)||(RepType.indexOf("ѹ��")==0)){
		runClassMethod("web.DHCADVCOMMONPRINT","GetExportData",
		{StDate:StDate,EndDate:EndDate,reporttype:RepType,TitleList:"UlcerPart",DescList:"ѹ����λ"},function(ret){
			tabledata=ret;
		},"json",false);
	}
	
	var succflag="false";
	var strjLen=data.length;
	var tbstrjLen=tabledata.length;
	//1����ȡXLS����·��
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_Export.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;	
	var Title=TitleList.split("#");
	var titlelen=Title.length;
	
	var TbDesc=TabDescList.split("#");
	var tbdesclen=TbDesc.length;
	var TbTitle=TabFieldList.split("#");
	var tbtitlelen=TbTitle.length;
	var len=0;
	for (i=1;i<strjLen;i++)
  	{
		if(tbstrjLen==0){
			len=i-1;
		}
		for (j=0;j<titlelen;j++){
			xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,titlelen)).MergeCells = true;  //�ϲ���Ԫ��
			objSheet.Cells(1,1).value="������Ϣ";
			objSheet.Cells(2,1+j).value="'"+$g(data[0][Title[titlelen-1-j]]); // ����������
			objSheet.Cells(3+len,1+j).value="'"+$g(data[i][Title[titlelen-1-j]]); // ������ ����ֵ
		}
	//}
		if(tbstrjLen>0) 
	  	{ 
			var UlcerPartlist=$g(tabledata[i]["UlcerPart"]);//ѹ����λ
			var Ulcerlen=UlcerPartlist.length; //ѹ����λ����
	  	
			for (j=0;j<tbtitlelen;j++){ 
				xlApp.Range(xlApp.Cells(1,1+titlelen+0),xlApp.Cells(1,1+titlelen+29)).MergeCells = true;  //�ϲ���Ԫ��
				objSheet.Cells(1,1+titlelen+0).value="��λ";
				/* for(var k=0;k<Ulcerlen;k++){
					xlApp.Range(xlApp.Cells(1,1+titlelen+(k*(tbtitlelen-1))+k),xlApp.Cells(1,1+titlelen+((k+1)*(tbtitlelen-1))+k)).MergeCells = true;  //�ϲ���Ԫ��
					objSheet.Cells(1,1+titlelen+(k*(tbtitlelen-1))+k).value="��λ"+(k+1);
					objSheet.Cells(2,1+titlelen+(k*tbtitlelen)+j).value="'"+TbDesc[tbtitlelen-1-j]; //
					objSheet.Cells(2+i,1+titlelen+(k*tbtitlelen)+j).value="'"+$g(UlcerPartlist[k][TbTitle[tbtitlelen-1-j]]); //
				} */
				objSheet.Cells(2,1+titlelen+0).value="'"+"ѹ����Դ";
				objSheet.Cells(2,1+titlelen+1).value="'"+"ѹ����������";
				objSheet.Cells(2,1+titlelen+2).value="'"+"��λ_��";
				objSheet.Cells(2,1+titlelen+3).value="'"+"��λ_��β��";
				objSheet.Cells(2,1+titlelen+4).value="'"+"��λ_����_��";
				objSheet.Cells(2,1+titlelen+5).value="'"+"��λ_����_��";
				objSheet.Cells(2,1+titlelen+6).value="'"+"��λ_ϥ��_��";
				objSheet.Cells(2,1+titlelen+7).value="'"+"��λ_ϥ��_��";
				objSheet.Cells(2,1+titlelen+8).value="'"+"��λ_���β�_��";
				objSheet.Cells(2,1+titlelen+9).value="'"+"��λ_���β�_��";
				objSheet.Cells(2,1+titlelen+10).value="'"+"��λ_�ײ�_��";
				objSheet.Cells(2,1+titlelen+11).value="'"+"��λ_�ײ�_��";
				objSheet.Cells(2,1+titlelen+12).value="'"+"��λ_�ⲿ_��";
				objSheet.Cells(2,1+titlelen+13).value="'"+"��λ_�ⲿ_��";
				objSheet.Cells(2,1+titlelen+14).value="'"+"��λ_�����_��";
				objSheet.Cells(2,1+titlelen+15).value="'"+"��λ_�����_��";
				objSheet.Cells(2,1+titlelen+16).value="'"+"��λ_��ǰ�ϼ�_��";
				objSheet.Cells(2,1+titlelen+17).value="'"+"��λ_��ǰ�ϼ�_��";
				objSheet.Cells(2,1+titlelen+18).value="'"+"��λ_�Ų�_��";
				objSheet.Cells(2,1+titlelen+19).value="'"+"��λ_�Ų�_��";
				objSheet.Cells(2,1+titlelen+20).value="'"+"����_����";
				objSheet.Cells(2,1+titlelen+21).value="'"+"����";
				objSheet.Cells(2,1+titlelen+22).value="'"+"����";
				objSheet.Cells(2,1+titlelen+23).value="'"+"����";
				objSheet.Cells(2,1+titlelen+24).value="'"+"����";
				objSheet.Cells(2,1+titlelen+25).value="'"+"���������֯����";
				objSheet.Cells(2,1+titlelen+26).value="'"+"���Է���";
				objSheet.Cells(2,1+titlelen+27).value="'"+"ѹ�������";
				objSheet.Cells(2,1+titlelen+28).value="'"+"ѹ�������";
				objSheet.Cells(2,1+titlelen+29).value="'"+"ѹ�������";
				
				for(var k=0;k<Ulcerlen;k++){
					objSheet.Cells(3+len+k,1+titlelen+0).value="'"+radioValue("UlcerPart-95158-95163-95170,UlcerPart-95158-95163-95171",UlcerPartlist[k]); //ѹ����Դ	
					objSheet.Cells(3+len+k,1+titlelen+1).value="'"+$g(UlcerPartlist[k]["UlcerPart-95158-95162-95192"]); //ѹ����������
					objSheet.Cells(3+len+k,1+titlelen+2).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95172"])==""?"0":"1"); //��λ_��
					objSheet.Cells(3+len+k,1+titlelen+3).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95178"])==""?"0":"1"); //��λ_��β��	
					objSheet.Cells(3+len+k,1+titlelen+4).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95173-95196"])==""?"0":"1"); //����_��
					objSheet.Cells(3+len+k,1+titlelen+5).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95173-95197"])==""?"0":"1"); //����_��
					objSheet.Cells(3+len+k,1+titlelen+6).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95179-94189"])==""?"0":"1"); //ϥ��_��
					objSheet.Cells(3+len+k,1+titlelen+7).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95179-94190"])==""?"0":"1"); //ϥ��_��
					objSheet.Cells(3+len+k,1+titlelen+8).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95174-94173"])==""?"0":"1"); //���β�_��
					objSheet.Cells(3+len+k,1+titlelen+9).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95174-94174"])==""?"0":"1"); //���β�_��
					objSheet.Cells(3+len+k,1+titlelen+10).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95180-94193"])==""?"0":"1"); //�ײ�_��
					objSheet.Cells(3+len+k,1+titlelen+11).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95180-94194"])==""?"0":"1"); //�ײ�_��
					objSheet.Cells(3+len+k,1+titlelen+12).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95175-94177"])==""?"0":"1"); //�ⲿ_��
					objSheet.Cells(3+len+k,1+titlelen+13).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95175-94178"])==""?"0":"1"); //�ⲿ_��
					objSheet.Cells(3+len+k,1+titlelen+14).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95181-94197"])==""?"0":"1"); //�����_��
					objSheet.Cells(3+len+k,1+titlelen+15).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95181-94198"])==""?"0":"1"); //�����_��
					objSheet.Cells(3+len+k,1+titlelen+16).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95176-94181"])==""?"0":"1"); //��ǰ�ϼ�_��
					objSheet.Cells(3+len+k,1+titlelen+17).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95176-94182"])==""?"0":"1"); //��ǰ�ϼ�_��
					objSheet.Cells(3+len+k,1+titlelen+18).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95177-94185"])==""?"0":"1"); //�Ų�_��
					objSheet.Cells(3+len+k,1+titlelen+19).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95166-95177-94186"])==""?"0":"1"); //�Ų�_��
					objSheet.Cells(3+len+k,1+titlelen+20).value="'"+$g(UlcerPartlist[k]["UlcerPart-95158-95166-95182"]); //����_����
					
					objSheet.Cells(3+len+k,1+titlelen+21).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95169-95183"])==""?"0":"1"); //����
					objSheet.Cells(3+len+k,1+titlelen+22).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95169-95184"])==""?"0":"1"); //����
					objSheet.Cells(3+len+k,1+titlelen+23).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95169-95185"])==""?"0":"1"); //����
					objSheet.Cells(3+len+k,1+titlelen+24).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95169-95186"])==""?"0":"1"); //����
					objSheet.Cells(3+len+k,1+titlelen+25).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95169-95187"])==""?"0":"1"); //���������֯����
					objSheet.Cells(3+len+k,1+titlelen+26).value="'"+($g(UlcerPartlist[k]["UlcerPart-95158-95169-95188"])==""?"0":"1"); //���Է���
					objSheet.Cells(3+len+k,1+titlelen+27).value="'"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94247"]);  //ѹ������� 
					objSheet.Cells(3+len+k,1+titlelen+28).value="'"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94249"]);  //ѹ�������
					objSheet.Cells(3+len+k,1+titlelen+29).value="'"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94251"]);  //ѹ�������
				}
			}
			if(Ulcerlen!=0){
				len=len+Ulcerlen;
			}
	  	}
	}
	
	RepType=RepType.replace("/","��");
	StDate=StDate.replace(/(\/)/g,"-");
	EndDate=EndDate.replace(/(\/)/g,"-");

	succflag=xlBook.SaveAs(filePath+RepType+StDate+"��"+EndDate+".xls");
	//xlApp=null;
	//xlBook.Close(savechanges=false);
	xlApp.Visible=true;////////////////////ceshidakai
	objSheet=null;
	return succflag;
}
///�����¼�������ȫ������
function ExportAllData(StDate,EndDate,typeevent,filePath)
{ 
	var  strjData="",succflag="false"

	runClassMethod("web.DHCADVCOMMONPRINT","GetExportAllData",
	{StDate:StDate,EndDate:EndDate,reporttype:typeevent},function(ret){				
		strjData=ret;
	},"json",false);
	//var data=DataList.split("$$")
	var strjLen=strjData.length;
	//1����ȡXLS����·��
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_ExportAll.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;	
	xlApp.Range(xlApp.Cells(2,1),xlApp.Cells(strjLen+2,18)).Borders.LineStyle=1;  //���ñ߿�
	xlApp.Range(xlApp.Cells(2,1),xlApp.Cells(strjLen+2,18)).WrapText=true; //�Զ�����
	for (i=1;i<=strjLen;i++)
	{
	//S DataList=RepDate_"^"_RepLoc_"^"_RepType_"^"_AdmNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatDiag_"^"_OccurDate_"^"_OccurLoc_"^"_status
		   
	    objSheet.cells(i+2,1)="'"+strjData[i-1].PatName;
	    objSheet.cells(i+2,2)="'"+strjData[i-1].PatSex;
	    objSheet.cells(i+2,3)="'"+strjData[i-1].PatAge;
	    objSheet.cells(i+2,4)="'"+strjData[i-1].AdmNo;
	    objSheet.cells(i+2,5)="'"+strjData[i-1].PatID;
	    objSheet.cells(i+2,6)="'"+strjData[i-1].PatDiag; 
	    objSheet.cells(i+2,7)="'"+strjData[i-1].PatAdmDate; //��Ժ����
	    objSheet.cells(i+2,8)="'"+strjData[i-1].DischgDate;  //��Ժ����
	    objSheet.cells(i+2,9)="'"+strjData[i-1].NurLev;  //������
	    objSheet.cells(i+2,10)="'"+strjData[i-1].DegreeEducate;  //�Ļ��̶�
	    objSheet.cells(i+2,11)="'"+strjData[i-1].RepLoc;  //�������
	    objSheet.cells(i+2,12)="'"+strjData[i-1].LocDep;  //��������
	    objSheet.cells(i+2,13)="'"+strjData[i-1].RepDate;  //��������
	    objSheet.cells(i+2,14)="'"+strjData[i-1].OccurDate; //��������
	    objSheet.cells(i+2,15)="'"+strjData[i-1].RepStaus; //����״̬
	    objSheet.cells(i+2,16)="'"+strjData[i-1].OccurLoc; //��������
	    objSheet.cells(i+2,17)="'"; //��������
	    objSheet.cells(i+2,18)="'"+strjData[i-1].RepType;
	    

	}
	StDate=StDate.replace(/(\/)/g,"-");
	EndDate=EndDate.replace(/(\/)/g,"-");
	succflag=xlBook.SaveAs(filePath+"�����¼�����ͳ��"+StDate+"��"+EndDate+".xls");
	//xlApp=null;
	//xlBook.Close(savechanges=false);
	xlApp.Visible=true;////////////////////ceshidakai
	objSheet=null;
	return succflag;
}
///�����¼�������ȫ������
function ExportGatherData(StDate,EndDate,typeevent,filePath)
{ 
	var  strjData="",succflag="false"

	runClassMethod("web.DHCADVCOMMONPRINT","GetExportAllData",
	{StDate:StDate,EndDate:EndDate,reporttype:typeevent},function(ret){				
		strjData=ret;
	},"json",false);
	//var data=DataList.split("$$")
	var strjLen=strjData.length;
	//1����ȡXLS����·��
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_ExportGather.xlsx";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;	
	
	objSheet.cells(1,1)="'"+StDate.split("-")[0]+"�껤�����¼���"+StDate+"��"+EndDate+")"; //����
	xlApp.Range(xlApp.Cells(2,1),xlApp.Cells(1+strjLen+2,9)).Borders.LineStyle=1;  //���ñ߿�
	xlApp.Range(xlApp.Cells(2,1),xlApp.Cells(1+strjLen+2,9)).WrapText=true; //�Զ�����
	for (i=1;i<=strjLen;i++)
	{
	    objSheet.cells(i+2,1)="'"+i; //���
	    objSheet.cells(i+2,2)="'"+strjData[i-1].RepLoc; //��������
	    objSheet.cells(i+2,3)="'"+strjData[i-1].PatName;
	    objSheet.cells(i+2,4)="'"+strjData[i-1].PatSex;
	    objSheet.cells(i+2,5)="'"+strjData[i-1].PatAge;
	    objSheet.cells(i+2,6)="'"+strjData[i-1].AdmNo;
	    objSheet.cells(i+2,7)="'"+strjData[i-1].PatDiag; 
	    objSheet.cells(i+2,8)="'"+strjData[i-1].RepDate;  //��������
	    objSheet.cells(i+2,9)="'"+strjData[i-1].RepTypeExp;
	}

	xlApp.Range(xlApp.Cells(3+strjLen,1),xlApp.Cells(3+strjLen,9)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(3+strjLen,1),xlApp.Cells(3+strjLen,9)).WrapText=true; //�Զ�����
	objSheet.cells(3+strjLen,1)="'"+"�ϼƣ�������"+"Ժ��ѹ����"+strjData[strjLen-1].ulcerout+"��Ժ��ѹ����"+strjData[strjLen-1].ulcernumall+"����·���ѣ�"+strjData[strjLen-1].Pipenum+"������׹����"+strjData[strjLen-1].Fallnum+"��һ����ҽ����Ʒ��"+strjData[strjLen-1].Mednum+"����ҩ����"+strjData[strjLen-1].Drugerrnum+"�������˺���"+strjData[strjLen-1].Accidentnum+"��ҽ�ƻ�����շ�����"+strjData[strjLen-1].Wallnum+"��";	
	//objSheet.cells(2+strjLen,1)="'"+"�ϼƣ�������"+"ѹ����"+strjData[strjLen-1].Ulcernum+"����·���ѣ�"+strjData[strjLen-1].Pipenum+"������׹����"+strjData[strjLen-1].Fallnum+"��һ����ҽ����Ʒ��"+strjData[strjLen-1].Mednum+"����ҩ����"+strjData[strjLen-1].Drugerrnum+"�������˺���"+strjData[strjLen-1].Accidentnum+"��ҽ�ƻ�����շ�����"+strjData[strjLen-1].Wallnum+"��";	
	
	StDate=StDate.replace(/(\/)/g,"-");
	EndDate=EndDate.replace(/(\/)/g,"-");

	succflag=xlBook.SaveAs(filePath+"�������¼�"+StDate+"��"+EndDate+".xlsx");
	//xlApp=null;
	//xlBook.Close(savechanges=false);
	xlApp.Visible=true;////////////////////ceshidakai
	objSheet=null;
	return succflag;
}


//����δ����ı���
function $g(param){
	return param==undefined?"":	param;
}
//radio��checkbox���ݻ�ȡ
function radioValue(param,data){
	var ret=[]
	
	if(param==="") return "";
	paramArray = param.split(",");
	
	for(var i =0;i<paramArray.length;i++){
		if($g(data[paramArray[i]])!=""){
			ret.push($g(data[paramArray[i]]));
		}
	}
	
	return ret.join("�� ");
}

//radio��checkbox���ݻ�ȡ  ������Ԫ��ƴ��
function checksubValue(data,param,subdata){
	//alert(param);
	var ret=[]
	if(param==="") return "";
	paramArray = param.split(",");
	for(var i =0;i<paramArray.length;i++){
		if($g(subdata[paramArray[i]])!=""){
			ret.push($g(subdata[paramArray[i]]));
		}
	}
	if (ret.join("�� ")!=""){
		data=data+"��"+ret.join("�� ")+"��";
	}
	return data;
}
function myRadioValue(param,data){
	var ret = radioValue(param,data);
	if(ret===""){
		ret="��";
	}
	return ret;
}
