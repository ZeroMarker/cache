var DiagCode="",DiagDesc="",SDate="",EDate="",name="",PatNo="",CenterNo="",Flag=""
var OEORIRowId=""
 var now=new Date()
var Guser=session['LOGON.USERID']
var GuserName=session['LOGON.USERNAME']
function BodyLoadHandler() {
try{

	//var selectrow=parent.frames["INSUAudit"].document.InsuRow
	var selectrow=parent.frames["INSUAudit"].InsuRow
	PatNo=parent.frames["INSUAudit"].document.getElementById('TabPatNoz'+selectrow).innerText;
	name=parent.frames["INSUAudit"].document.getElementById('TabPatNamez'+selectrow).innerText;
	Flag=parent.frames["INSUAudit"].document.getElementById('TabPrescNoz'+selectrow).innerText;
	OEORIRowId=parent.frames["INSUAudit"].document.getElementById('TabOEORIRowIdz'+selectrow).innerText;
}
catch(e){}
	var obj=document.getElementById("PatNo");
	if(obj){obj.value=PatNo;}
	var obj=document.getElementById("PatNo");
	if(obj){obj.onkeydown=ReadCard_Click;}
	var obj=document.getElementById("Query");
	if(obj){obj.onclick=Query_onclick;}
	var obj=document.getElementById("Report");
	if(obj){obj.onclick=Report_onclick;}
	var objtbl=document.getElementById("tDHCINSUOedLinkTar") ;
	if (objtbl)
	{
		for (i=1;i<objtbl.rows.length;i++)
		{
			var obj=document.getElementById("Selectz"+i);
			obj.checked=true;
		}
	}
	websys_setfocus('PatNo');
}
function Query_onclick(){
	var obj=document.getElementById("OeOrdDr");
	if (obj) {OeOrdDr=obj.value; }
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCINSUOedLinkTar&OeOrdDr="+OeOrdDr;
 	location.href=lnk;
	}
function Report_onclick(){
	var Amount="",flag=0,SDate="",EDate=""
	//add by zhangdongliang at 2016-09-29 for SucessCount ��Ϊ�����ɹ�������
	var SucessCount=0
	//end
	var objtbl=document.getElementById("tDHCINSUOedLinkTar") ;
	if (objtbl)
	{
		var Year=now.getFullYear(); //Ĭ��ʱ�䴦��
  		var Month=now.getMonth()+1;
  		var Date=now.getDate();
  		if (String(Month).length<2)   Month="0"+Month 
  		if (String(Date).length<2)   Date="0"+Date 
   		SDate=String(Year)+String(Month)+String(Date)
  		 now.setDate(now.getDate()+7)
  		 Year=now.getFullYear();Month=now.getMonth()+1;Date=now.getDate();
  		if (String(Month).length<2)   Month="0"+Month 
  		if (String(Date).length<2)   Date="0"+Date 
		EDate=String(Year)+String(Month)+String(Date)
		now.setDate(now.getDate()-7)
		//alert(EDate)
		var Selobj=document.getElementById('ZZ');  //֢״
  		var ZZ=Selobj.value;
  		var Selobj=document.getElementById('MD');  //Ŀ��
  		var MD=Selobj.value;
  		var Selobj=document.getElementById('PatNo');  //���˱��
  		var PatNo=Selobj.value;
  		var Selobj=document.getElementById('States');  //�α���
  		var TMPCenterNo=Selobj.value;
  		var RptType=""
  		//var PatNo="0044512"
  		//alert(Flag)
  		/*
  		if (Flag.indexOf("�ز�")>0) {var RptType="17"}
  		else var RptType="41"
  		if ((RptType=="17")&&(ZZ=="")) {alert("��¼��B֢״�I");return;}
  		if ((RptType=="17")&&(DiagCode=="")) {alert("��¼��B�������ơB");return;}
  		*/
  		if (ZZ=="") {alert("��¼��B֢״�I");return;}
  		if (DiagCode=="") {alert("��ѡ��B�������ơB");return;}
  		//alert(RptType)
  		if(TMPCenterNo.length>1) {CenterNo=TMPCenterNo}
  		var States=CenterNo   //�α���
  		if(States=="") {alert("�α������ݴ���������¼��");return;}	//modefy by zhangdongliang at 2015-10-12 for �޸�alert��ʾ��Ϣ��
  		//alert(States)
		for (i=1;i<objtbl.rows.length;i++)
		{
			var obj=document.getElementById("Selectz"+i);
			if (obj.checked==true)
			{
			 	var Selobj=document.getElementById('TariCodez'+i); 
  				var TariCode=Selobj.innerText;	
  				var Selobj=document.getElementById('TariDescz'+i); 
  				var TariDesc=Selobj.innerText;	
  				var Selobj=document.getElementById('InsuCodez'+i); 
  				var InsuCode=Selobj.innerText;	
  				var Selobj=document.getElementById('InsuDescz'+i); 
  				var InsuDesc=Selobj.innerText;
  				InsuDesc=InsuDesc.replace("�]","").replace("�^","")
  				var Selobj=document.getElementById('xmlbz'+i); 
  				var xmlb=Selobj.innerText;	
  				var Selobj=document.getElementById('slz'+i); 
  				var sl=Selobj.innerText;	
  				var Selobj=document.getElementById('Pricez'+i); 
  				var Price=Selobj.innerText;	
  				var Selobj=document.getElementById('Amountz'+i);
  				var Amount=Selobj.innerText;
  				if (RptType=="41") {Amount=Price;}	
				//var str=PatNo+"|"+RptType+"|"+AdmSeriNo+"|"+OutHosName+"|"+HosLevel+"|"+DiagCode+"|"+DiagDesc+"|"+HosYJ+"|"+xmbm+"|"+xmmc+"|"+sl+"|"+RptDate+"|"+SDate+"|"+EDate+"|"+GuserName+"|"+OutType+"|"+Demo+"|"+money+"|"+xmlb+"|"+RPTNo+"|"+ZYZZ+"|"+MD+"|"+Doctor+"|"+KZR+"|"+JSYJ+"|"+KZRYJ+"|"+LRuser+"|"+LRDate+"|"+RPTUser+"|"+HisCode+"|"+HisDesc+"|"+AdmType+"|"+NumberID+"|"+States
				var str=PatNo+"|"+RptType+"|"+""+"|"+""+"|"+""+"|"+DiagCode+"|"+DiagDesc+"|"+"01"+"|"+InsuCode+"|"+InsuDesc+"|"+sl+"|"+SDate+"|"+SDate+"|"+EDate+"|"+GuserName+"|"+""+"|"+""+"|"+Amount+"|"+xmlb+"|"+""+"|"+ZZ+"|"+MD+"|"+""+"|"+""+"|"+"01"+"|"+"01"+"|"+GuserName+"|"+SDate+"|"+GuserName+"|"+TariCode+"|"+TariDesc+"|"+""+"|"+""+"|"+States
				//alert(ExpString)
				var ExpString=name+"^"+OEORIRowId
				//alert(ExpString)
				var rtn=InsuReport(str,Guser,ExpString)
				if (rtn=="-1"){
					 alert("��"+i+"�����������ϱ�ʧ��!�������������ϴ���"+i+"������");
					//flag=1
				}
				else
				{
					SucessCount=SucessCount+1	
				}
   				// else alert("�����ϱ��ɹ�!")
   				
			}
		}
		alert("�����ϱ��ɹ�����"+SucessCount +"��!")
		if(SucessCount==objtbl.rows.length-1){
			parent.frames["INSUAudit"].Audit_Click();
		}
	}

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
	//modefy by zhangdongliang at 2015-10-12 for����������Ϊ��׼��汾������ʧ���жϡ�
	//var str=ReadINSUCard(CardNo,Guser,CardType)
	var str= InsuReadCard(0,Guser,CardNo,"")
	if(str=="-1")
	{
		alert("����ʧ��")
		return;
	}
	//alert(str)
	var TmpData=str.split("|")
	if (TmpData[0]!="0") alert("����ʧ�ܡI")
 	else 
 	{ ///9037786^10110377^3501-5^������^Ů^^19360914000000^450106360914002^�����ж��������������ι�˾^^^21^^786.51^^^^0^^450100|10015424^^20020515000000^2^1^^^^450107^10^100^3132      ^0^2011^840.8^0^0^0^0^0^0^0^46^1^0
	 	var TmpData1=TmpData[1].split("^")
	 	var obj=document.getElementById("PatNo"); //���˱��
		if (obj) obj.value=TmpData1[0];
		CenterNo=TmpData[2].split("^")[8]
		if(name!=TmpData1[3]){alert("������һ��,��������:"+TmpData1[3])}
		/*var obj=document.getElementById("CardNo"); //����
		if (obj) obj.value=TmpData1[1];
	 	var obj=document.getElementById("name"); //����
		if (obj) obj.value=TmpData1[3];
		var obj=document.getElementById("Sex"); //�Ա�
		if (obj) obj.value=TmpData1[4];*/
		CenterNo=TmpData[2].split("^")[8]
		//alert(CenterNo)
		//if (TmpData[2].split("^")[8]=="450100")	States="������"
		if (CenterNo=="450122")	States="������"
		else if (CenterNo=="450123")	States="¡����"
		else if (CenterNo=="450124")	States="��ɽ��"
		else if (CenterNo=="450125")	States="������"
		else if (CenterNo=="450126")	States="����"  
		else if (CenterNo=="450127")	States="������"
		else {States="������";CenterNo=="450100";}
	 	var obj=document.getElementById("States"); //�α���������
		if (obj) obj.value=States;
		//11 ��ְ���� 21	���ݴ��� 31	���ݴ��� 33	�˲о��˴��� 91	������� 92	δ�������
		/*if (TmpData1[11]=="11") TmpData1[11]="��ְ����"
		if (TmpData1[11]=="21") TmpData1[11]="���ݴ���"
		if (TmpData1[11]=="31") TmpData1[11]="���ݴ���"
		if (TmpData1[11]=="33") TmpData1[11]="�˲о��˴���"
		if (TmpData1[11]=="91") TmpData1[11]="�������"
		if (TmpData1[11]=="92") TmpData1[11]="δ�������"
		var obj=document.getElementById("rylb"); //��Ա���
		if (obj) obj.value=TmpData1[11];*/
		
	 	}
}
function LookUpWithAlias(str) //��������
{  //alert(str)
	var tmp= str.split("^");
	var obj=document.getElementById("DiagDesc")
	if (obj) obj.value=tmp[0];
   DiagCode=tmp[2]
   DiagDesc=tmp[0].split("|")[0]
   //alert(DiagDesc)
}
document.body.onload = BodyLoadHandler;