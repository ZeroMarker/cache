var DiagDesc="",DiagCode="",xmmc="",xmbm="",xmlb="",HisDesc="",HisCode="",money="0"
var TabPatNo="",TabRptType="",TabAdmSeriNo="",TabDiagCode="",TabHisCode="",TabSDate="",TabRPTNo=""
var rowid,TabRptDate="",DicType="",CenterNo="",Amount=""
 var now=new Date()
Guser=session['LOGON.USERID'];
GuserName=session['LOGON.USERNAME'];
function BodyLoadHandler() {
	var obj=document.getElementById("RptType") //�������
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;	  
	  obj.options[0]=new Option("�������Բ�(ְ��)","15"); 
	  obj.options[1]=new Option("�����ز�","17"); 
	  obj.options[2]=new Option("ת��תԺ","26"); 
	  obj.options[3]=new Option("��ͥ����","31"); 
	  obj.options[4]=new Option("�ؼ�����","41"); 
	  obj.options[5]=new Option("��ҩ","42"); 
	  obj.options[6]=new Option("�������תԺ����","82"); 
	  obj.options[7]=new Option("�������Բ�(�������)","83"); 
	  obj.options[8]=new Option("������Ա���䶨������","91"); 
	  obj.selectedIndex=0;
	 }
	//01 ͬ�� 02��ͬ��
	var obj=document.getElementById("HosYJ") //ҽԺ���
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;	  
	  obj.options[0]=new Option("ͬ��","01"); 
	  obj.options[1]=new Option("��ͬ��","02"); 
	  obj.selectedIndex=0;
	}
	//01 ͬ�� 02��ͬ��
	var obj=document.getElementById("KZRYJ") //�����������
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;	  
	  obj.options[0]=new Option("ͬ��","01"); 
	  obj.options[1]=new Option("��ͬ��","02"); 
	  obj.selectedIndex=0;
	}
	//01 ͬ�� 02��ͬ��
	var obj=document.getElementById("JSYJ") //���˼������
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;	  
	  obj.options[0]=new Option("ͬ��","01"); 
	  obj.options[1]=new Option("��ͬ��","02"); 
	  obj.selectedIndex=0;
	}
	//0-ҽԺҪ�� 1-	����Ҫ�� 2-	��ذ���
	var obj=document.getElementById("OutType") //ת�����
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;	  
	  obj.options[0]=new Option("ҽԺҪ��","0"); 
	  obj.options[1]=new Option("����Ҫ��","1"); 
	  obj.options[2]=new Option("��ذ���","2"); 
	  obj.selectedIndex=0;
	}
	
	var obj=document.getElementById("ReadCard"); //����
	if (obj) obj.onclick=ReadCard_Click;
	//websys_setfocus('ReadCard');
	
	var obj=document.getElementById("OK"); //ȷ��
	if (obj) obj.onclick=OK_Click;
	
	var obj=document.getElementById("Del"); //ɾ��
	if (obj) obj.onclick=Del_Click;
	
	var obj=document.getElementById("FindSH"); //��ѯ���
	if (obj) obj.onclick=Query_Click;
	var obj=document.getElementById("tINSUReport"); //˫��ʵ�ֲ�ѯ����״̬
	if (obj) obj.ondblclick=Query_Click;
	var obj=document.getElementById("qp"); //����
	if (obj) obj.onclick=qp_Click;
	
	var obj=document.getElementById("RptType"); //�������
	if (obj) obj.onchange=RptTypeonchange;
	try{
		var obj=document.getElementById("OutHosName");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("xmmc");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("sl");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("DiagDesc");
		if (obj) (obj.style.background="00ffff")
	}catch(e){
	}
	
	var objRptlb=document.getElementById("Rptlb") //�������
	if (objRptlb){
	  objRptlb.size=1; 
	  objRptlb.multiple=false;	  
	  objRptlb.options[0]=new Option("�������Բ�(ְ��)","15"); 
	  objRptlb.options[1]=new Option("�����ز�","17"); 
	  objRptlb.options[2]=new Option("ת��תԺ","26"); 
	  objRptlb.options[3]=new Option("��ͥ����","31"); 
	  objRptlb.options[4]=new Option("�ؼ�����","41"); 
	  objRptlb.options[5]=new Option("��ҩ","42"); 
	  objRptlb.options[6]=new Option("�������תԺ����","82"); 
	  objRptlb.options[7]=new Option("�������Բ�(�������)","83"); 
	  objRptlb.options[8]=new Option("������Ա���䶨������","91"); 
	  objRptlb.selectedIndex=0;
	}
	var obj=document.getElementById("Find"); //��ѯ���
	if (obj) obj.onclick=Find_Click;
	
	var obj=document.getElementById("CardType"); //���޿���־
	if (obj) obj.checked=true;
	var obj=document.getElementById("DicType");
	if (obj){obj.value="Skc516";}

	var obj=document.getElementById("DiagDesc");//ʵ�ֻس�����
	if (obj) {obj.onkeydown=KeyDownDiagDesc; }
	var obj=document.getElementById("DiagCodeMXB");
	if (obj) {obj.onkeydown=KeyDownDiagCodeMXB; }
	var obj=document.getElementById("xmmc");
	if (obj) {obj.onkeydown=KeyDownxmmc; }
	var obj=document.getElementById("sl");
	if (obj) {obj.onkeydown=KeyDownsl; }
	var obj=document.getElementById("PatNo");
	if(obj){obj.onkeydown=ReadCard_Click;}

	var obj=document.getElementById("SDate"); //��ʼʱ��
	if (obj){ 
	var SDate=obj.value;
	var tmp = SDate.split("/");
	tmp[1]=parseFloat(tmp[1])+1
	if(parseInt(tmp[1])>12) {tmp[1]="01";tmp[2]=parseInt(tmp[2])+1}
	if((parseInt(tmp[0])==31)&&((parseInt(tmp[1])==2)||(parseInt(tmp[1])==4)||(parseInt(tmp[1])==6)||(parseInt(tmp[1])==9)||(parseInt(tmp[1])==11)))
  	{tmp[0]="01";tmp[1]=parseFloat(tmp[1])+1;}
  	if (String(tmp[1]).length<2) {tmp[1]="0"+tmp[1];}
  	var EDate=tmp[0]+"/"+tmp[1]+"/"+tmp[2]
	//var obj=document.getElementById("EDate"); //��ֹʱ�� ,Ĭ��һ����֮��
	//if (obj) obj.value=EDate
	}
}
function qp_Click() //����
{
	location.reload();	
}
function ReadCard_Click()
{
	//location.reload();
	if (window.event.keyCode!=13) return
	var CardType="0",CardNo="",States=""
	var obj=document.getElementById("PatNo"); //���˱��
	if (obj) CardNo=obj.value;
	if ((String(CardNo).length==15)||(String(CardNo).length==18)) CardType="1"
	//var obj=document.getElementById("CardType"); //���޿���־
	//if (obj.checked==true) CardType="0"; 
	//else CardType="1"
	//var str=ReadINSUCard(CardNo,Guser,CardType)
	var str=ReadCardNew(CardNo,CardType)
	//alert(str)
	var TmpData=str.split("|")
	if (TmpData[0]!="0") alert("����ʧ�ܡI")
 	else 
 	{ ///9037786^10110377^3501-5^������^Ů^^19360914000000^450106360914002^�����ж��������������ι�˾^^^21^^786.51^^^^0^^450100|10015424^^20020515000000^2^1^^^^450107^10^100^3132      ^0^2011^840.8^0^0^0^0^0^0^0^46^1^0
	 	var TmpData1=TmpData[1].split("^")
	 	var obj=document.getElementById("PatNo"); //���˱��
		if (obj) obj.value=TmpData1[0];
		var obj=document.getElementById("CardNo"); //����
		if (obj) obj.value=TmpData1[1];
	 	var obj=document.getElementById("name"); //����
		if (obj) obj.value=TmpData1[3];
		var obj=document.getElementById("Sex"); //�Ա�
		if (obj) obj.value=TmpData1[4];
		CenterNo=TmpData[2].split("^")[8]
		//alert(CenterNo)
		//if (TmpData[2].split("^")[8]=="450100")	States="������"
		if (CenterNo=="450122")	States="������"
		else if (CenterNo=="450123")	States="¡����"
		else if (CenterNo=="450124")	States="��ɽ��"
		else if (CenterNo=="450125")	States="������"
		else if (CenterNo=="450126")	States="����"  
		else if (CenterNo=="450127")	States="������"
		else States=""
	 	var obj=document.getElementById("States"); //�α���������
		if (obj) obj.value=States;
		//11 ��ְ���� 21	���ݴ��� 31	���ݴ��� 33	�˲о��˴��� 91	������� 92	δ�������
		if (TmpData1[11]=="11") TmpData1[11]="��ְ����"
		if (TmpData1[11]=="21") TmpData1[11]="���ݴ���"
		if (TmpData1[11]=="31") TmpData1[11]="���ݴ���"
		if (TmpData1[11]=="33") TmpData1[11]="�˲о��˴���"
		if (TmpData1[11]=="91") TmpData1[11]="�������"
		if (TmpData1[11]=="92") TmpData1[11]="δ�������"
		var obj=document.getElementById("rylb"); //��Ա���
		if (obj) obj.value=TmpData1[11];
		
	 	}
}
///���˱�� ������� סԺ��ˮ�� ת�����ҽԺ���� ҽԺ�ȼ� ���ֱ��� �������� ҽԺ��� ��Ŀ����
//��Ŀ���� �������� ҽԺ�������� ��ʼʱ�� ��ֹʱ�� ������ ת����� ��ע ������?�ؼ�������Ϊ����?
// ��Ŀ��� ������� ��Ҫ֢״ Ŀ�� ����ҽʦ ������ ���˼������ ����������� ¼��Ա ¼��ʱ�� ������ 
// ҽԺ������Ŀ���� ҽԺ������Ŀ���� ҽ����� �������κ� �α���������
function OK_Click()
{
	var PatNo="",RptType="",AdmSeriNo="",OutHosName="",OutHosName="",HosLevel="";
	var HosYJ="",sl="",RptDate="",SDate="",EDate="",OutType="",Demo="";
	var RPTNo="",ZYZZ="",MD="",Doctor="",KZR="",KZRYJ="",LRuser="",LRDate="";
	var RPTUser="",AdmType="",NumberID="",States="";
	var ExpString="";
	
	var obj=document.getElementById("PatNo"); //���˱��
	if (obj) PatNo=obj.value;
	var obj=document.getElementById("RptType"); //�������
	if (obj) RptType=obj.value;
	var obj=document.getElementById("rylb"); //��Ա���
	if(((obj.value=="�������")||(obj.value=="δ�������"))&&(RptType=="15"))
	{
		 alert("��Ա�����������һ��!");
		 return;
	}
	if((obj.value!="�������")&&(obj.value!="δ�������")&&(RptType=="83")) 
	{
		alert("��Ա�����������һ��!");
		return;
	}
	var obj=document.getElementById("AdmSeriNo"); //סԺ��ˮ��
	if (obj) AdmSeriNo=obj.value;
	//var obj=document.getElementById("OutHosName"); //ת�����ҽԺ����
	//if (obj) OutHosName=obj.value;
	OutHosName="";
	var obj=document.getElementById("OutHosName"); //סԺ��ˮ��
	if (obj) OutHosName=obj.value;
	HosLevel="";                              // ҽԺ�ȼ� 1һ��?2����?3����
	var obj=document.getElementById("HosYJ"); //ҽԺ���
	if (obj) HosYJ=obj.value;
	var obj=document.getElementById("sl"); //��������
	if (obj) sl=obj.value;
	var obj=document.getElementById("money"); //�������
	if (obj) money=obj.value;
	var obj=document.getElementById("RptDate"); //ҽԺ��������
	if (obj) RptDate=DateTime(obj.value); //+"000000";
	var obj=document.getElementById("SDate"); //��ʼʱ��
	if (obj) SDate=DateTime(obj.value); ///+"000000";
	var obj=document.getElementById("SDate"); //��ֹʱ�� ,Ĭ��һ����֮��
	if (obj) EDate=obj.value;
	

	var tmp = EDate.split("/");
	tmp[1]=parseFloat(tmp[1])+1;
	if(parseInt(tmp[1])>12){
		tmp[1]="01";
		tmp[2]=parseInt(tmp[2])+1;
	}
	if((parseInt(tmp[0])==31)&&((parseInt(tmp[1])==2)||(parseInt(tmp[1])==4)||(parseInt(tmp[1])==6)||(parseInt(tmp[1])==9)||(parseInt(tmp[1])==11))){
		tmp[0]="01";
		tmp[1]=parseFloat(tmp[1])+1;
	}
  	if (String(tmp[1]).length<2){
	  	tmp[1]="0"+tmp[1];
	}

  	var EDatestr=tmp[0]+"/"+tmp[1]+"/"+tmp[2];
	var obj=document.getElementById("EDate"); //��ֹʱ�� ,Ĭ��һ����֮��
	if (obj) EDatestr=obj.value;
	EDate=DateTime(EDatestr);
	OutType="";  //"1" //ת�����	0-ҽԺҪ��1-����Ҫ��2-��ذ���
	var obj=document.getElementById("Demo"); //��ע
	if (obj) Demo=obj.value;
	if(money=="0"){
		var obj=document.getElementById("money"); //������!�ؼ�������Ϊ����
		if (obj) {money=obj.value;}
	}

	if ((RptType=="41")&(xmlb=="")) alert("����Ŀ���Ϊ��,δ����!���ȶ�������!");
	//xmlb="2" // ? ҩƷ 2 ? ������Ŀ 3 ? ������ʩ
	//RPTNo ������� �������,ͨ��?ҽԺ��ȡ������š�������׻�ȡ���������	
    var obj=document.getElementById("ZYZZ"); //��Ҫ֢״ ZYZZ
	if (obj) ZYZZ=obj.value;
	var obj=document.getElementById("MD"); //Ŀ��
	if (obj) MD=obj.value;
	var obj=document.getElementById("Doctor");//����ҽʦDoctor
	if (obj) Doctor=obj.value;
	var obj=document.getElementById("KZR");//������
	if (obj) KZR=obj.value;
	var obj=document.getElementById("JSYJ");//���˼������
	if (obj) JSYJ=obj.value;
	var obj=document.getElementById("KZRYJ");//�����������
	if (obj) KZRYJ=obj.value;
	
	
	LRuser=GuserName;
	LRDate=RptDate;
	RPTUser=GuserName;
	
	NumberID=""; // �������κ�

	States=CenterNo;
	
	var obj=document.getElementById("name");//��������
	if (obj){
		var name=obj.value;
	}

	var str=PatNo+"|"+RptType+"|"+AdmSeriNo+"|"+OutHosName+"|"+HosLevel+"|"+DiagCode+"|"+DiagDesc+"|"+HosYJ+"|"+xmbm+"|"+xmmc+"|"+sl+"|"+RptDate+"|"+SDate+"|"+EDate+"|"+GuserName+"|"+OutType+"|"+Demo+"|"+money+"|"+xmlb+"|"+RPTNo+"|"+ZYZZ+"|"+MD+"|"+Doctor+"|"+KZR+"|"+JSYJ+"|"+KZRYJ+"|"+LRuser+"|"+LRDate+"|"+RPTUser+"|"+HisCode+"|"+HisDesc+"|"+AdmType+"|"+NumberID+"|"+States;
	ExpString=name+"|";

	

	var rtn=InsuReport(str,Guser,ExpString);
	if (rtn=="-1"){
		alert("�����ϱ�ʧ��!");
	} else{
		alert("�����ϱ��ɹ�!");	
	}
	
	if (RptType=="41"){
		websys_setfocus('xmmc');
		var obj=document.getElementById("xmmc")
		if (obj) obj.value="";
		var obj=document.getElementById("sl")
		if (obj) obj.value="1";
		var obj=document.getElementById("money")
		if (obj) obj.value="0";
		xmmc="",xmbm="",xmlb="",money="0"
		HisCode="",HisDesc="" ///,DiagCode="",DiagDesc=""
	}

}

function Del_Click()
{
	var PatNo="",RptType="",ExpString=""
	//alert("Del_Click")
	//var obj=document.getElementById("PatNo"); //���˱��
	//if (obj) PatNo=obj.value;
	//var obj=document.getElementById("RptType"); //�������
	//if (obj) RptType=obj.value;
	if (TabRptType=="�������Բ�(ְ��)") TabRptType="15";           
	  if (TabRptType=="�����ز�") TabRptType="17";             
	  if (TabRptType=="ת��תԺ") TabRptType="26";             
	  if (TabRptType=="��ͥ����") TabRptType="31";             
	  if (TabRptType=="�ؼ�����") TabRptType="41";             
	  if (TabRptType=="��ҩ") TabRptType="42";                 
	  if (TabRptType=="�������תԺ����") TabRptType="82";     
	  if (TabRptType=="�������Բ�(�������)") TabRptType="83"; 
	  if (TabRptType=="������Ա���䶨������") TabRptType="91";
	   
	var str=TabRptType+"|"+TabPatNo+"|"+TabAdmSeriNo+"|"+TabDiagCode+"|"+TabHisCode+"|"+TabSDate
	//alert(str)
	ExpString=rowid+"|"
	//��.NET
	 var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_GX_NNA");
	 var rtn=DHCINSUBLL.InsuReportDestroy(1,str,Guser,ExpString);	
    
    if (rtn=="-1") alert("�����ϱ�����ʧ��!")
    else alert("�����ϱ������ɹ�!")
	//location.reload();
}
function Query_Click()
{
	var PatNo="",RptType="",ExpString=""
	//alert(TabRptType)
	//var obj=document.getElementById("PatNo"); //���˱��
	//if (obj) PatNo=obj.value;
	//var obj=document.getElementById("RptType"); //�������
	//if (obj) RptType=obj.value;
	if (TabRptType=="�������Բ�(ְ��)") TabRptType="15";           
	  if (TabRptType=="�����ز�") TabRptType="17";             
	  if (TabRptType=="ת��תԺ") TabRptType="26";             
	  if (TabRptType=="��ͥ����") TabRptType="31";             
	  if (TabRptType=="�ؼ�����") TabRptType="41";             
	  if (TabRptType=="��ҩ") TabRptType="42";                 
	  if (TabRptType=="�������תԺ����") TabRptType="82";     
	  if (TabRptType=="�������Բ�(�������)") TabRptType="83"; 
	  if (TabRptType=="������Ա���䶨������") TabRptType="91"; 

	var str=TabPatNo+"|"+TabRptType+"|"+"450113001"+"|"+""+"|"+""+"|"+""+"|"+TabRptDate+"|"+TabRPTNo
	//alert(str)
	ExpString=rowid+"|"
	var rtn;
	try{
		//��.NET
		//alert(ExpString)
		 var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSU_GX_NNA");
		rtn=DHCINSUBLL.InsuReportQuery(1,str,Guser,ExpString);	
	}catch(e){
		alert("����ҽ���ӿڷ����쳣,����ҽ�������Ƿ�������װ!\n ��������:"+e.message);
		return "-1"
	}finally{
	} 
    if (rtn=="-1") alert("������ϸ��Ϣ��ѯʧ��!")
    else if(rtn=="0") alert("δ����!")
    else if(rtn=="1") alert("����ͨ��!")
    else if(rtn=="2") alert("����δͨ��!")
    else if(rtn=="3") alert("��ʹ��!")
    
	location.reload();
}

function Find_Click()
{
 
 	var EndDate="",StartDate="",Type="",Edate=""
	//alert("Find_Click")
	var obj=document.getElementById("StartDate"); //������ʼʱ��
	if (obj) StartDate=obj.value;
	var obj=document.getElementById("EndDate"); //����ʱ��
	if (obj) EndDate=obj.value;
	var obj=document.getElementById("Rptlb"); //�������
	if (obj) Rptlb=obj.value;
	var obj=document.getElementById("Edate"); //�������
	if (obj) Edate=obj.value;
 	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=INSUReport&StartDate="+StartDate+"&EndDate="+EndDate+"&Rptlb="+Rptlb+"&Edate="+Edate;
	 location.href=lnk;
	 var obj=document.getElementById("StartDate"); //������ʼʱ��
	if (obj) obj.value=StartDate;
	var obj=document.getElementById("EndDate"); //����ʱ��
	if (obj) obj.value=EndDate;
	var obj=document.getElementById("Rptlb"); //�������
	if (obj) obj.value=Type;


}

function RptTypeonchange()  //�������ı�ʱ
{
	var obj=document.getElementById("OutHosName");
	if (obj) (obj.style.background="ffffff")//ffffff ��ɫ
	var obj=document.getElementById("xmmc");
	if (obj) (obj.style.background="ffffff")
	var obj=document.getElementById("sl");
	if (obj) (obj.style.background="ffffff")
	var obj=document.getElementById("money");
	if (obj) (obj.style.background="ffffff")
	var obj=document.getElementById("DiagDesc");
	if (obj) (obj.style.background="ffffff")
	var obj=document.getElementById("DiagCodeMXB");
	if (obj) (obj.style.background="ffffff")
	
	var obj=document.getElementById("RptType");
	if (obj.value=="15") //�������Բ�   
	{
		var obj=document.getElementById("OutHosName");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("xmmc");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("sl");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("DiagDesc");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("DicType");
	if (obj){obj.value="Skc516ZG";}
	}
	var obj=document.getElementById("RptType");
	if (obj.value=="83") //�������Բ�   
	{
		var obj=document.getElementById("OutHosName");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("xmmc");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("sl");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("DiagDesc");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("DicType");
	if (obj){obj.value="Skc516JM";}
	}
	if (obj.value=="41") //�ؼ�����
	{
		var obj=document.getElementById("OutHosName");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("money");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("DiagCodeMXB");
		if (obj) (obj.style.background="00ffff")
	}
	if (obj.value=="17") //�����ز�
	{
		var obj=document.getElementById("OutHosName");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("xmmc");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("sl");
		if (obj) (obj.style.background="00ffff")
		var obj=document.getElementById("DiagCodeMXB");
		if (obj) (obj.style.background="00ffff")
	}
}

function SelectRowHandler()	{    //ѡ�б����һ��,���в���
	var eSrc=window.event.srcElement;
   var rowobj=getRow(eSrc)
   var Objtbl=document.getElementById('tINSUReport');
   var Rows=Objtbl.rows.length;
   var lastrowindex=Rows - 1;
   var rowObj=getRow(eSrc);
   var selectrow=rowObj.rowIndex;
 
  var Selobj=document.getElementById('TabPatNoz'+selectrow); 
  TabPatNo=Selobj.innerText;
	var Selobj=document.getElementById('TabRptTypez'+selectrow); 
  TabRptType=Selobj.innerText;
  var Selobj=document.getElementById('TabAdmSeriNoz'+selectrow); 
  TabAdmSeriNo="" //Selobj.innerText;
  var Selobj=document.getElementById('TabDiagCodez'+selectrow); 
  TabDiagCode=Selobj.innerText;
  var Selobj=document.getElementById('Tabxmbmz'+selectrow); 
  Tabxmbm=Selobj.innerText;
    var Selobj=document.getElementById('TabRPTNoz'+selectrow); 
  TabRPTNo=Selobj.innerText;
   var Selobj=document.getElementById('TabRptDatez'+selectrow); 
  TabRptDate=Selobj.innerText;
   var TmpDate=TabRptDate.split("-")
  TabRptDate=TmpDate[0]+TmpDate[1]+TmpDate[2]
  var Selobj=document.getElementById('TabSDatez'+selectrow); 
  TabSDate=Selobj.innerText 
  var TmpDate=TabSDate.split("-")
  TabSDate=TmpDate[0]+TmpDate[1]+TmpDate[2]
  var Selobj=document.getElementById('rowidz'+selectrow); 
  rowid=Selobj.value;
	         
}
function LookUpWithAlias(str) //��������
{  //alert(str)
	var tmp1 = str.split("^");
	var obj=document.getElementById("DiagDesc")
	if (obj) obj.value=tmp1[0];
   DiagCode=tmp1[2]
   DiagDesc=tmp1[0].split("|")[0]
   //alert(DiagDesc)
}
function LookUpDic(value) //���Բ���������
{  
	var tmp1 = value.split("^");
	var obj=document.getElementById("DiagCodeMXB")
	if (obj) obj.value=tmp1[0];
   DiagCode=tmp1[1]
   DiagDesc=tmp1[0]
}
function SetInsuString(value){	//��Ŀ���� 1505001 ȫѪ  
	var TarCate=value
	//alert(value)
	var TempData=TarCate.split("^")
	var obj=document.getElementById("xmmc")
	if (obj) obj.value=TempData[3];
	xmmc=TempData[11]
	xmbm=TempData[10]
	xmlb=TempData[17]
	money=TempData[7]
	HisCode=TempData[2]
	HisDesc=TempData[3]
	var obj=document.getElementById("money")
	if (obj) obj.value=TempData[7];
	}
function DateTime(str) //ת��ʱ���ʽ
{  
	var tmp = str.split("/");
	str=tmp[2]+tmp[1]+tmp[0]
	return str
}	
function KeyDownDiagDesc(){
	if (window.event.keyCode==13){
	window.event.keyCode=117;
	DiagDesc_lookuphandler();
	}
}
function KeyDownDiagCodeMXB(){
	if (window.event.keyCode==13){
	window.event.keyCode=117;
	DiagCodeMXB_lookuphandler();
	}
}
function KeyDownxmmc(){
	if (window.event.keyCode==13){
	window.event.keyCode=117;
	xmmc_lookuphandler();
	}
}
function KeyDownsl(){
	if (window.event.keyCode==13){
	var obj=document.getElementById("sl")
	if (obj) sl=obj.value;
	Amount=money*sl  ///����*����
	var obj=document.getElementById("money")
	if (obj) obj.value=Amount;
	}
}

document.body.onload = BodyLoadHandler;