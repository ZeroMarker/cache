/*
 * FileName:	matntrtreg.js
 * User:		JinS
 * Date:		2021-11-29
 * Function:	������������(ҽ����)
 */
 
// ���峣��
var GV = {
	UPDATEDATAID : '',
	HospDr:session['LOGON.HOSPID'] ,  //Ժ��ID
	USERID:session['LOGON.USERID'] ,  //����ԱID
	GROUPID:session['LOGON.GROUPID'], //��ȫ��id
	ADMID:'',
	SelADMID:'',                       
	PAPMI:'',
	INSUADMID : '',
	MatnRowid:'',      //����������rowid
	fixmedinsCode:'H36011100214',
	fixmedinsName:'�ϲ��еھ�ҽԺ',
	PoolareaNo:'360100',
	InsuAdmDvs:'360100',                      //���߲α��ر��� 
	OpterId:'',
	OpterDate :'',
	OpterTime :''    

}
var index=1
//��ں���
$(function(){
	setPageLayout();    //����ҳ�沼��
	setElementEvent();	//����ҳ��Ԫ���¼�
	
	
    
});

//����ҳ�沼��
function setPageLayout(){
	
	// ҽ������
	init_INSUType();
	
	// ��ѯ���ҽ������
	init_SearchInsuType();
	
	// �����¼
	initAdmList();
		
	//��ʼ����������������¼	
	init_dg();
	
	//���ڳ�ʼ��	
	init_Date();
	
	//���ֳ�ʼ��-Size
	//init_layout();
    //����
	clear();
}


//����ҳ��Ԫ���¼�
function setElementEvent()
{
	//ҳ�����ˢ��
	$(document).keydown(function(e){
	 	banBackSpace(e);
	 	});
 	window.onresize=function(){
    	location.reload();
 	} 
 
	//�����Ǽ�
	$("#btnRefer").click(MatnTrtReg_Click);
	
    //��������
    $("#btnReferDes").click(MatnTrtRegDestory_Click); 
     
     //����ɾ��
     $("#btncancel").click(delect); 
    //������ѯ
    $("#btnSearch").click(FixRegsearch_Click); 
    
    //��ѯ
    $("#btnFind").click(initLoadGrid); 
    
    
 
	//���Żس���ѯ�¼�
	$("#HISCardNo").keydown(function (e) {
		cardNoKeydown(e);
	});
	
	//�ǼǺŻس���ѯ�¼�
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//������ѯ
	//��Ա��Żس���ѯ�¼�
	$("#SearchInsuNo").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			initLoadGrid();
		}
	});
	//֤������س���ѯ�¼�
	$("#SearchId").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			initLoadGrid();
		}
	});
	//��Ա�����س���ѯ�¼�
	$("#SearchName").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			initLoadGrid();
		}
	});
}

/*
*������Ȩ
*/
function BtnAuthor()
{
	//enableById("AdmList"); 
	if(GV.GROUPID=="17"){
		//disableById("btnReferCret");    
		$('#btnReferCret').attr('style','display:none')
	}else{
		//��ҽ���죬��ȡ��Ա��Ϣ������������������������ѯ�����ɼ�
		$('#btn-readINSUCard').attr('style','display:none')
		$('#btnRefer').attr('style','display:none')
		$('#btnReferDes').attr('style','display:none')
		$('#btnSearch').attr('style','display:none')

	}
	
}
//ɾ��
function delect(){
	
	
	var dgSelect = $('#dg').datagrid('getSelected');
	var RowId = '';
	var TValiFlag='';
	if(dgSelect){
		RowId = dgSelect.TRowid;	
		TValiFlag=dgSelect.TValiFlag
	}
	if (RowId == ''){
		$.messager.alert("��ܰ��ʾ","��ѡ��Ҫɾ������!", 'info')
	
		return;	
	}	
	
    if (TValiFlag =="�����ɹ�"){
		$.messager.alert("��ܰ��ʾ","�����ɹ���¼����ɾ��!", 'info')
		return;	
	}	
	$.messager.confirm('��ȷ��','��ȷ��Ҫɾ��������¼��?',function(fb){
		if(fb){
			var rtn = $.m({ClassName: "INSU.MI.BL.MatnTrtRegCtl", MethodName: "Delete", RowId:RowId,}, false);
	  if (rtn == '0'){
		$.messager.alert("��ܰ��ʾ",'ɾ���ɹ�' , 'info');
		initLoadGrid();
	  }else{
		$.messager.alert("��ܰ��ʾ",'ɾ��ʧ��'  + rtn , 'info');
		initLoadGrid();
	}
		}else{
			return;	
		}
	});
}
//����
function MatnTrtMod_Click()
{
	var Handle=0,UserId=GV.USERID,AdmDr=GV.ADMID,HospId=GV.HospDr;
	var Rowid=GV.MatnRowid;
	var PapmiDr="";                            //������Ϣ��Dr
	var HiType=getValueById('QInsuType');
	var InStr="",ExpStr="";
	var InStr=Rowid+"^"+HospId+"^"+PapmiDr+"^"+AdmDr+"^"+HiType; 
	//��Ա���^��Ա֤������^֤������^��Ա����^����^�Ա�^��������^������^���������걨�����^�ƻ���������֤��^ĩ���¾�����^Ԥ����������^ 5-16
	//��ż����^��ż֤������^��ż֤������^����ҽҩ�������^����ҽҩ��������^��ʼ����^��������^ͳ�������^��ϵ�绰^��ϵ��ַ^̥��^�������^ 17-28
	//�α�����ҽ������^��������^�����걨��ϸ��ˮ��^��Ч��־^��λ���^��λ����^��Ա�α���ϵID^����������^����������^�����鱨����׼^ 29-38
	//�����ʸ�Ǽ�״̬^�걨����^�ֶ���չ^��չ����1^��չ����2^����������^������֤������^������֤������^��������ϵ��ʽ^��������ϵ��ַ^ 39-48
	//�����˹�ϵ^��ע^������ID^��������^����ʱ��^������ID^��������^����ʱ�� 49-56
	//^2^^^00A^����^411481199910105177^^^^5^1^11^^^111^01^111^H44022200010^ʼ��������ҽԺ^2022-02-16^2022-12-07^440222^18137077186^111111^1^7
	//^^310^1^A^^^^H44022200010^^^A^2022-12-1^^^^111^01^111^11^^1^^^^^909^2022-12-1^14:36:1
	var psnNo=getValueById('psnNo');
	InStr=InStr+"^"+psnNo;                                       			//��Ա���   ҽ���ǼǱ�INADM_InsuId
	
	var PsnCertType=getValueById('PsnCertType');

	InStr=InStr+"^"+PsnCertType;                                       		//��Ա֤������
	
	var Certno=getValueById('Certno');
	if(Certno == "")
	{
		$.messager.alert("��ܰ��ʾ","�и�֤�����벻��Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+Certno;                                       			//֤������
	
	var name=getValueById('name');
	if(name == "")
	{
		$.messager.alert("��ܰ��ʾ","�и���������Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+name;                                       			//��Ա����
	
	InStr=InStr+"^"+getValueById('Naty');                                 	//����
	
	var Sex=getValueById('Sex');                                            //�Ա�
	
	 
	InStr=InStr+"^"+Sex;                                 		             
	
	InStr=InStr+"^"+getValueById('BrDate');                               	//��������
	
	var GesoVal=getValueById('GesoVal');                                                                                                
	if(GesoVal != "")                                                       //upt 20220429 HanZH ��֤��������������
	{
		if (isNaN(GesoVal)){
			$.messager.alert("��ܰ��ʾ","��������������ֵ!", 'info');
			return;
����	}
	}else{
		$.messager.alert("��ܰ��ʾ","����������Ϊ��!", 'info');
			return;
	}
	
	InStr=InStr+"^"+GesoVal;                                             	//������
	
	var MatnTrtDclaerType=getValueById('MatnTrtDclaerType');
	if(MatnTrtDclaerType == "")
	{
		$.messager.alert("��ܰ��ʾ","���������걨�������Ϊ��!", 'info');
		return ; 
	}
	InStr=InStr+"^"+MatnTrtDclaerType;                                     //���������걨�����
	
	InStr=InStr+"^"+getValueById('FpscNo');                                //�ƻ���������֤��
	
	var LastMenaDate=getValueById('LastMenaDate');
	if(LastMenaDate==""){
		$.messager.alert("��ܰ��ʾ","�и�ĩ���¾����ڲ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+LastMenaDate;                          				   //ĩ���¾�����
	
	var PlanMatnDate=getValueById('PlanMatnDate');
	if(PlanMatnDate==""){
		$.messager.alert("��ܰ��ʾ","�и�Ԥ���������ڲ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+PlanMatnDate;                                        	//Ԥ����������
	
	var SpusName="";
	var SpusCertType="";
	var SpusCertNo=""
	SpusName=getValueById('SpusName');
	SpusCertType=getValueById('SpusCertType');
	SpusCertNo=getValueById('SpusCertNo')
	
	InStr=InStr+"^"+SpusName;                                            //��ż����
	InStr=InStr+"^"+SpusCertType;                                        //��ż֤������
	InStr=InStr+"^"+SpusCertNo;                                          //��ż֤������
	
	if(Sex=="1" || Sex=="��" || Sex=="����"){
		if(SpusName=="" || SpusCertType =="" || SpusCertNo==""){
			
			$.messager.alert("��ܰ��ʾ","���Բα���������Ϣ����Ϊ�գ���ż����;��ż֤������;��ż֤������!")
			return ;
			}
		
	}
		
	InStr=InStr+"^"+GV.fixmedinsCode;                          //����ҽҩ�������
	InStr=InStr+"^"+GV.fixmedinsName;                          //����ҽҩ��������
	
	var SDate=getValueById('SDate');	
	if(SDate == "")
	{
		$.messager.alert("��ܰ��ʾ","���쿪ʼ���ڲ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+SDate;                                        	        //��ʼ����
	
	var EDate=getValueById('EDate');	
	if(EDate == "")
	{
		$.messager.alert("��ܰ��ʾ","����������ڲ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+EDate;                                        	        //��������
	
	InStr=InStr+"^"+GV.PoolareaNo;                                          //ҽԺ����ͳ�������
	
	var telNo=getValueById('tel');
	if(telNo == "")
	{
		$.messager.alert("��ܰ��ʾ","��ϵ�绰����Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+telNo;                                            //��ϵ�绰
	
	var addr=getValueById('addr');

	InStr=InStr+"^"+addr;                                             //��ϵ��ַ
	
	var Fetts=getValueById('Fetts');	
	if(Fetts != "")
	{
		if (isNaN(Fetts)){
			$.messager.alert("��ܰ��ʾ","̥����������ֵ!", 'info');
			return;
����	}
	}else{
		$.messager.alert("��ܰ��ʾ","̥�β�����Ϊ��!", 'info');
		return;
	}
	InStr=InStr+"^"+Fetts;                                               //̥��  upt 20220429 HanZH ��֤̥����������
		
	var MatnType=getValueById('MatnType');
	if(MatnType == "")
	{
		$.messager.alert("��ܰ��ʾ","���������Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+MatnType;                                             //�������
	
	var InsuAdmdvs=GV.InsuAdmDvs                                          //�α�����ҽ������
	InStr=InStr+"^"+InsuAdmdvs;               
	
	var InsuType=getValueById('InsuType');
	if(InsuType == "")
	{
		$.messager.alert("��ܰ��ʾ","�������Ͳ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+InsuType;                                               //��������
	
	var TrtDclaDetlSn="1"                                                   //�����걨��ϸ��ˮ��(�ǼǷ���)
	InStr=InStr+"^"+TrtDclaDetlSn;  
	
	var ValiFlag="D"                                                        //��Ч��־(D:��������A�ѱ�����S��������)
	InStr=InStr+"^"+ValiFlag;   
	
	InStr=InStr+"^"+"";                                	                    //��λ���
	InStr=InStr+"^"+"";                              	                    //��λ����
	
	var PsnInsuRltsId=""	                                                //��Ա�α���ϵID
	InStr=InStr+"^"+PsnInsuRltsId;
	var OptinsNo=GV.fixmedinsCode  		                                    //����������
	InStr=InStr+"^"+OptinsNo; 
	var OpterName=""   		                                                //����������
	InStr=InStr+"^"+OpterName; 
	var OtpExamReimStd=""                                                   //�����鱨����׼
	InStr=InStr+"^"+OtpExamReimStd; 
	var MatnQuaRegStas="A"                                                  //�����ʸ�Ǽ�״̬
	InStr=InStr+"^"+MatnQuaRegStas;
	 
	InStr=InStr+"^"+"";                              	                    //�걨����
	
	var ExpContent=""                                                       //�ֶ���չ
	InStr=InStr+"^"+ExpContent; 
	InStr=InStr+"^"+"";                                                     //��չ����1
	InStr=InStr+"^"+"";                                                     //��չ����2
	
	InStr=InStr+"^"+getValueById('AgnterName');                           	//����������
	InStr=InStr+"^"+getValueById('AgnterCertType');                       	//������֤������
	InStr=InStr+"^"+getValueById('AgnterCertno');                         	//������֤������
	InStr=InStr+"^"+getValueById('AgnterTel');                            	//��������ϵ��ʽ
	InStr=InStr+"^"+getValueById('AgnterAddr');                           	//��������ϵ��ַ
	InStr=InStr+"^"+getValueById('AgnterRlts');                           	//�����˹�ϵ
	
	var memo=getValueById('reflRea');                                          //��ע
	InStr=InStr+"^"+memo;  
	
	var OpterId=""                                                      //������(��д��,�޸���)-----ҽʦ�������ĸ�ҽʦ
	var OptDate="" ;                                                        //�������ڣ���д���ڣ�
	var OptTime="" ;                                                        //����ʱ�䣨��дʱ�䣩
	
	if (GV.OpterId!=""){OpterId=GV.OpterId}	
	if (GV.OpterDate!=""){OptDate=GV.OpterDate}
	if (GV.OpterTime!=""){OptTime=GV.OpterTime}                             //���ҽʦ��д�ģ���д�˲��ܱ�	
		
		
	InStr=InStr+"^"+OpterId+"^"+OptDate+"^"+OptTime; 
	var today=new Date();
	var NowDate=today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate();
	var NowTime=today.getHours()+":"+today.getMinutes()+":"+today.getSeconds();
	var UpdtId=UserId                                                          //�����ˣ������ˣ�-----ҽ������Ա��������
	var UpdtDate=NowDate                                                        //��������
	var UpdtTime=NowTime                                                       //����ʱ��
	InStr=InStr+"^"+UpdtId+"^"+UpdtDate+"^"+UpdtTime;
	
	$.messager.progress({
		title: "��ʾ",
		text: '�����޸ı�������,���Ժ�....'
	});
	
	$m({
		ClassName:"INSU.MI.BL.MatnTrtRegCtl",
		MethodName:"InsertMatnTrtReg",
		InString:InStr,
		HospDr:GV.HospDr,
	},function(rtn){
		if(rtn.split("^")[0]<0){
			$.messager.alert('��ʾ',"�޸�������������ʧ�ܣ�"+rtn);
			initLoadGrid();
		}else{
			   
			   $.messager.alert('��ʾ','�޸������������ݳɹ�');
			   initLoadGrid();	
			}
	  $.messager.progress("close");
	});	 
	initLoadGrid();	
	
	
}
//1101��ȡ��Ա��Ϣ
function getPersonInfo()
{

var selected = $('#dg').datagrid('getSelected');
	if (!selected) {
	   $.messager.alert("��ܰ��ʾ","��ѡ��һ��������¼!", 'info');
	}
	
	else{
			
    var MatnID=selected.TRowid;  //��¼rowid
    

	var MatnInfo=tkMakeServerCall("INSU.MI.BL.MatnTrtRegCtl","GetMatnTrtRegById",MatnID);
	var MatnArr=MatnInfo.split("^");
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('QInsuType')+"^"+"1101"+"^^output^"+connURL;
	var QryParams=""

	QryParams=AddQryParam(QryParams,"mdtrt_cert_type","02");
	QryParams=AddQryParam(QryParams,"mdtrt_cert_no",MatnArr[7]);
	QryParams=AddQryParam(QryParams,"card_sn","");
	QryParams=AddQryParam(QryParams,"begntime","");
	QryParams=AddQryParam(QryParams,"psn_cert_type","");
	QryParams=AddQryParam(QryParams,"certno","");
	QryParams=AddQryParam(QryParams,"psn_name","");
	ExpStr=ExpStr+"^"+QryParams
	

	var rtn=InsuServQry(0,GV.USERID,ExpStr); 
	if (!rtn){return ;}
	if (rtn.split("^")[0]!="0") 
	 {
		$.messager.alert("��ʾ","��ѯʧ��!rtn="+rtn, 'error');
		return ;
	}
	 var outPutObj=JSON.parse(rtn.split("^")[1]);
	 
	return outPutObj;
	}
}
function AddQryParam(QryArgs,name,value){
	return QryArgs+="&"+name+"="+value;
}
/**
*�����ǼǱ���
*/
function MatnTrtReg_Click()
{
	
	var obj=$('#btnRefer').linkbutton("options")
	if (obj.disabled==true){return ;}
	
	disableById("btnRefer");
	
	
	  try {
	
  
  
	var selected = $('#dg').datagrid('getSelected');
	
	if (!selected || selected.TValiFlag=="�����ɹ�") {
	   $.messager.alert("��ܰ��ʾ","��ѡ��һ����������¼!", 'info');
	}
	
	else{
    var MatnID=selected.TRowid;  //��¼rowid
    
	var MatnInfo=tkMakeServerCall("INSU.MI.BL.MatnTrtRegCtl","GetMatnTrtRegById",MatnID);
	var MatnArr=MatnInfo.split("^");
    
	var today=new Date();

	var Handle=0,UserId=GV.USERID,AdmDr=GV.ADMID,HospId=GV.HospDr;
	var Rowid=MatnID;
	
	var PapmiDr="";  //������Ϣ��Dr
	var HiType=getValueById('QInsuType');
	//var DclaSouc=1;  //�걨��Դ 1 ҽԺ 2 ����
	var InStr="",ExpStr="";
	var InStr=Rowid+"^"+HospId+"^"+"1"+"^"+"1"+"^"+HiType; 
	if(getValueById('QInsuType')==''){
		$.messager.alert('��ʾ', "ҽ�����Ͳ���Ϊ��" + str, 'error');	
		return;	
	}
	//var InStr=Rowid+"^"+HospId+"^"+PapmiDr+"^"+AdmDr+"^"+HiType; 
	//��Ա���^��Ա֤������^֤������^��Ա����^����^�Ա�^��������^������^���������걨�����^�ƻ���������֤��^ĩ���¾�����^Ԥ����������^ 5-16
	//��ż����^��ż֤������^��ż֤������^����ҽҩ�������^����ҽҩ��������^��ʼ����^��������^ͳ�������^��ϵ�绰^��ϵ��ַ^̥��^�������^ 17-28
	//�α�����ҽ������^��������^�����걨��ϸ��ˮ��^��Ч��־^��λ���^��λ����^��Ա�α���ϵID^����������^����������^�����鱨����׼^ 29-38
	//�����ʸ�Ǽ�״̬^�걨����^�ֶ���չ^��չ����1^��չ����2^����������^������֤������^������֤������^��������ϵ��ʽ^��������ϵ��ַ^ 39-48
	//�����˹�ϵ^��ע^������ID^��������^����ʱ��^������ID^��������^����ʱ�� 49-56
	
	
	
	var outPutObj=getPersonInfo();
	if(!outPutObj){return ;}
		
	var psnNo=outPutObj.baseinfo.psn_no;
	if(psnNo == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա��Ų���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+psnNo;                                       			//��Ա���
	
	
	var PsnCertType=MatnArr[6];
	if(PsnCertType == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա֤�����Ͳ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+PsnCertType;                                       		//��Ա֤������
	
	var Certno=MatnArr[7];
	if(Certno == "")
	{
		$.messager.alert("��ܰ��ʾ","֤�����벻��Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+Certno;                                       			//֤������
	
	
	var name=MatnArr[8];
	if(name == "")
	{
		$.messager.alert("��ܰ��ʾ","�и���������Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+name;                                       			//��Ա����
	var Sex=MatnArr[10];                                            //�Ա�
	 if(Sex==""){Sex="2"}
	InStr=InStr+"^"+Sex; 
	                                		             
	InStr=InStr+"^"+"01";                                 	//����
	InStr=InStr+"^"+MatnArr[11];                               	//��������
	
	var GesoVal=MatnArr[12];           
	                                                                                 
	if(GesoVal != "")                                                       //upt 20220429 HanZH ��֤��������������
	{
		if (isNaN(GesoVal)){
			$.messager.alert("��ܰ��ʾ","��������������ֵ!", 'info');
			return;
����	}
	}else{
		$.messager.alert("��ܰ��ʾ","����������Ϊ��!", 'info');
			return;
		}
	InStr=InStr+"^"+GesoVal;                                             	//������
	
	var MatnTrtDclaerType=MatnArr[13];
	if(MatnTrtDclaerType == "")
	{
		$.messager.alert("��ܰ��ʾ","���������걨�������Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+MatnTrtDclaerType;                                     //���������걨�����
	

	
	InStr=InStr+"^"+MatnArr[14];                                //�ƻ���������֤��
	
	
	var LastMenaDate=MatnArr[15];
	if(LastMenaDate==""){
		$.messager.alert("��ܰ��ʾ","�и�ĩ���¾����ڲ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+LastMenaDate;                          				   //ĩ���¾�����
	
	var PlanMatnDate=MatnArr[16];
	if(PlanMatnDate==""){
		$.messager.alert("��ܰ��ʾ","�и�Ԥ���������ڲ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+PlanMatnDate;                                        	//Ԥ����������
	
	var SpusName="";
	var SpusCertType="";
	var SpusCertNo=""
	SpusName=MatnArr[17];
	SpusCertType=MatnArr[18];
	SpusCertNo=MatnArr[19]
	
	
	InStr=InStr+"^"+SpusName;                                             //��ż����
	InStr=InStr+"^"+SpusCertType;                                        //��ż֤������
	InStr=InStr+"^"+SpusCertNo;                                          //��ż֤������
	
	if(Sex=="1" || Sex=="��" || Sex=="����"){
		if(SpusName=="" || SpusCertType =="" || SpusCertNo==""){
			
			$.messager.alert("��ܰ��ʾ","���Բα���������Ϣ����Ϊ�գ���ż����;��ż֤������;��ż֤������!")
			return ;
			}
		
	}
	
	/*var fixmedinsCode=getValueById('fixmedinscode');
	if(fixmedinsCode == "")
	{
		$.messager.alert("��ܰ��ʾ","����ҽҩ������Ų���Ϊ��!", 'info');
		return ;
	}*/
 
	InStr=InStr+"^"+GV.fixmedinsCode;                          //����ҽҩ�������
	InStr=InStr+"^"+GV.fixmedinsName;                          //����ҽҩ��������
	
	var SDate=MatnArr[22];	
	if(SDate == "")
	{
		$.messager.alert("��ܰ��ʾ","��ʼ���ڲ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+SDate;                                        	        //��ʼ����
	
	var EDate=MatnArr[23];	
	if(EDate == "")
	{
		$.messager.alert("��ܰ��ʾ","�������ڲ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+EDate;                                        	        //��������
	
	InStr=InStr+"^"+GV.PoolareaNo ;                                        //ҽԺ����ͳ�������
	
	var telNo=MatnArr[25];
	if(telNo == "")
	{
		$.messager.alert("��ܰ��ʾ","��ϵ�绰����Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+telNo;                                            //��ϵ�绰
	
	var addr=MatnArr[26];

	InStr=InStr+"^"+addr;                                             //��ϵ��ַ
	
	var Fetts=MatnArr[27];	
	if(Fetts != "")
	{
		if (isNaN(Fetts)){
			$.messager.alert("��ܰ��ʾ","̥����������ֵ!", 'info');
			return;
����	}
	}else{
		
		}
	InStr=InStr+"^"+Fetts;                                             //̥��  upt 20220429 HanZH ��֤̥����������
	
	var MatnType=MatnArr[28];
	if(MatnType == "")
	{
		$.messager.alert("��ܰ��ʾ","���������Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+MatnType;                                          //�������
	
	var InsuAdmdvs=GV.InsuAdmDvs;                                    //�α�����ҽ������
	InStr=InStr+"^"+InsuAdmdvs;               
	
	var InsuType=getValueById('InsuType');
	if(InsuType == "")
	{
		$.messager.alert("��ܰ��ʾ","�������Ͳ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+InsuType;                                          //��������
	
	
	var TrtDclaDetlSn="1"                                    //�����걨��ϸ��ˮ��(�ǼǷ���)
	InStr=InStr+"^"+TrtDclaDetlSn;  
	
	//var ValiFlag=MatnArr[32]                                                   //��Ч��־
	var ValiFlag="D"      
	InStr=InStr+"^"+ValiFlag;   
	
	InStr=InStr+"^"+"";                                	           //��λ���
	InStr=InStr+"^"+"";                              	           //��λ����
	
	var PsnInsuRltsId=""	                                                 //��Ա�α���ϵID
	InStr=InStr+"^"+MatnArr[35];
	var OptinsNo=""   		                                               //����������
	InStr=InStr+"^"+GV.fixmedinsCode ; 
	var OpterName=""   		                                           //����������
	InStr=InStr+"^"+OpterName; 
	var OtpExamReimStd=""                                            //�����鱨����׼
	InStr=InStr+"^"+"0"+OtpExamReimStd; 
	
	var MatnQuaRegStas="A"                                                 //�����ʸ�Ǽ�״̬
	InStr=InStr+"^"+MatnQuaRegStas;
	var NowDate=today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate();
	var NowTime=today.getHours()+":"+today.getMinutes()+":"+today.getSeconds();
	InStr=InStr+"^"+NowDate;                              	                     //�걨���ڣ���ǰ����
	
	var ExpContent=""                                                          //�ֶ���չ
	InStr=InStr+"^"+ExpContent; 
	InStr=InStr+"^"+"";                                                      //��չ����1
	InStr=InStr+"^"+"";                                                      //��չ����2
	
	InStr=InStr+"^"+MatnArr[45];                           	//����������
	InStr=InStr+"^"+MatnArr[46];                       	//������֤������
	InStr=InStr+"^"+MatnArr[47];                         	//������֤������
	InStr=InStr+"^"+MatnArr[48];                            	//��������ϵ��ʽ
	InStr=InStr+"^"+MatnArr[49];                           	//��������ϵ��ַ
	InStr=InStr+"^"+MatnArr[50];                           	//�����˹�ϵ
	
	var memo=MatnArr[51];                                          //��ע
	InStr=InStr+"^"+memo;  
	
	var OpterId=""                                                          //������
	var OptDate="" ;                                                        //��������
	var OptTime="" ;                                                        //����ʱ��
	
	if (GV.OpterId!=""){OpterId=GV.OpterId}	
	if (GV.OpterDate!=""){OptDate=GV.OpterDate}
	if (GV.OpterTime!=""){OptTime=GV.OpterTime}                             //���ҽʦ��д�ģ���д�˲��ܱ�
	
	InStr=InStr+"^"+OpterId+"^"+OptDate+"^"+OptTime; 
	
	var UpdtId=UserId                                                        //������
	var UpdtDate=NowDate                                                         //��������
	var UpdtTime=NowTime                                                          //����ʱ��
	InStr=InStr+"^"+UpdtId+"^"+UpdtDate+"^"+UpdtTime;
	var ExpStr=getValueById('QInsuType')+"^";                                     //ҽ������^���ݿ����Ӵ�
	var rtn=INSUMatnTrtReg(Handle,UserId,AdmDr,InStr,ExpStr)
	if (rtn!="0") 
	 {
		if(Rowid!=""){
			//����״̬Ϊ����ʧ��
			
			var UpdtInfo="F^"+UpdtId
			var Trtn=tkMakeServerCall("INSU.MI.BL.MatnTrtRegCtl","UpdtMatnTrtRegByRowid",Rowid,UpdtInfo,GV.HospDr)
			
			$.messager.alert("��ʾ","���������Ǽ�ʧ��!rtn="+rtn, 'error');
			}
		return ;
	}
	else{
		$.messager.alert('��ʾ','���������Ǽǳɹ�');
		return ;
	}
	}    
	} catch (error) {
  }
	finally{
		enableById("btnRefer");
		}                   
}			
//�����ǼǱ�������
function MatnTrtRegDestory_Click()
{
	
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.TRowid != "" && selected.TValiFlag=="�����ɹ�") {
			
			$.messager.confirm('ȷ��', 'ȷ�ϳ���������¼��', function (r) {
				if (r) {
					var Handle=0,UserId=GV.USERID,AdmDr=selected.TAdmDr,PsnNo=selected.TPsnNo,HiType=getValueById('QInsuType');
					
					
					
    				//var ExpString="��Ҫ���±���" //��ʽ:^^^���ݿ����Ӵ�
    				var ExpString=HiType+"^^"+"����Ҫ��"+"^" //��ʽ:^^����ԭ��^���ݿ����Ӵ�
    				
    				//alert(UserId+"^"+AdmDr+"^"+PsnNo+"^"+HiType)
    				//AdmDr="386"//��ȡԺ���Զ���
    			
					var rtn=INSUMatnTrtRegDestory(Handle, UserId , AdmDr ,PsnNo, ExpString); //DHCINSUPort.js
					
				   
					if (rtn!="0") 
	 				{
						$.messager.alert("��ʾ","����������������ʧ��!rtn="+rtn, 'error');
						return ;
					}else{
						$.messager.alert("��ʾ","�����������������ɹ�!", 'info',function(){
							initLoadGrid();	
						});
					}
				}
			});
		}else{
			$.messager.alert('��ʾ', "��ѡ��Ҫ�����ġ��ѱ�������¼", 'info');		
			return false;
		}
	}
	else{
			$.messager.alert('��ʾ', "��ѡ��Ҫ�����ļ�¼", 'info');		
			return false;
		}
}
//������ѯ
function FixRegsearch_Click()
{
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.TRowid != "") {
			var Handle=0,UserId=GV.USERID
			var ExpString="" //��ʽ:^^^���ݿ����Ӵ�
			//var rtn=InsuTransferHospQuery(Handle,UserId,selected.TRowid,ExpString); //DHCINSUPort.js
			var rtn="0"
			if (rtn!="0"){
				$.messager.alert("��ܰ��ʾ","��ѯ������Ϣʧ��", 'info');
				return ;
			}else{
				$.messager.alert("��ܰ��ʾ","��ѯ������Ϣ�ɹ�", 'info');
				return ;
			}
		}	
	}else{
		$.messager.alert('��ʾ', "��ѡ��Ҫ��ѯ�ļ�¼", 'info');		
		return false;
	}	
}
//��ʼ������ҽԺ
function init_FixmedHosp(){
	
    var data={total:0,rows:[]};
	$('#fixmedinsname').combogrid({
    panelWidth:450,
    value:'006',
    idField:'fixmedins_code',
    textField:'fixmedins_name',
    delay: 600,
	mode: 'remote',
	method: 'GET',
	pagination: true,
    columns:[[
        {field:'fixmedins_code',title:'�����������',width:160},
        {field:'fixmedins_name',title:'�����������',width:270}
    ]],
    onBeforeLoad: function(param) {
			if (typeof param.q == "undefined"){
				return false;
				}
			if (($.trim(param.q).length >= 1)) {
				  param.q=param.q.replace("��",",");
				 if (param.q.indexOf(",")<=-1){
				  var ExpStr = "1^"+param.q+"^^^00A"
				  var jsonstr=InsuGetHosp(1,GV.USERID,ExpStr); //DHCINSUPort.js
				  var rows=JSON.parse(jsonstr);
				   data={total:rows.length,rows:rows};
				  $("#fixmedinsname").combogrid("grid").datagrid({data:data});
				 }
				 else
				 {
					 var newRows =data.rows.filter(function(item,index,array){
						 return (param.q.split(",")[1]!=""&&item.fixmedins_name.indexOf(param.q.split(",")[1])>=0);
						 });
						 
				     if (newRows.length>0){
					     var newData={total:newRows.length,rows:newRows};
					     }else{
						        newData=data; 
						     }
					 $("#fixmedinsname").combogrid("grid").datagrid({data:newData});
			    }
			}else{
				$('#fixmedinsname').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
				return false; 
      		}
		},
		onSelect:function(index,row){
			setValueById('fixmedinscode',row.fixmedins_code);
		}
});
}
//��ʼ�������¼
function initAdmList() {
	$HUI.combogrid("#AdmList", {
		panelWidth: 560,
		panelHeight: 200,
		striped: true,
		fitColumns: false,
		editable: false,
		pagination: true,
		pageSize: 1000,
		pageList: [1000],
		method: 'GET',
		idField: 'admId',
		textField: 'admNo',
		columns: [[{field: 'admNo', title: "�����", width: 100},
					{field: 'admStatus', title: '��������', width: 80},
					{field: 'admDate', title: '��������', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.admTime;
							}
					}
					},
					{field: 'admDept', title: '�������', width: 100},
					{field: 'admWard', title: '���ﲡ��', width: 120},
					{field: 'admBed', title: '����', width: 60},

					{field: 'admId', title: '����ID', width: 80},
					{field: 'patName', title: '����', width: 80,hidden:true},
					{field: 'PaSex', title: '�Ա�', width: 80,hidden:true},
					{field: 'PAPMIHealthFundNo', title: 'ҽ���ֲ��', width: 80,hidden:true}
			]],
		onLoadSuccess: function (data) {
			    var admIndexEd=data.total;
                if (admIndexEd>0)
                {
	                var admdg = $('#AdmList').combogrid('grid');	
                    admdg.datagrid('selectRow',admIndexEd-1);	
                   
	              }
		},
		onLoadError:function(e){
		},
		onSelect: function (index, row) {
			GV.ADMID = row.admId;
			//refreshBar('',row.admId);
			//var admReaStr = getAdmReasonInfo(row.admId);
			//var admReaAry = admReaStr.split("^");
			//var admReaId = admReaAry[0];
			var INSUType = "00A";
			$("#QInsuType").combobox('select', INSUType);
			GetInsuAdmInfo();                 //��ȡҽ��������Ϣ
			//QryDiagLst();                     //���ؾ������
			       
		}
	});
}
//��ȡҽ��������Ϣ����
function GetInsuAdmInfo()
{
	$.m({
		ClassName: "web.DHCINSUIPReg",
		MethodName: "GetInfoByAdm",
		type: "GET",
		itmjs: "",
		itmjsex: "",
		Paadm: GV.ADMID
	}, function (rtn) {
          if (typeof rtn != "string")
         {
	       //$.messager.alert('��ʾ','û����His�ҵ�ҽ���Ǽ�(�Һ�)��Ϣ','info');
	     }
		if (rtn.split("!")[0] != "1") {
			//$.messager.alert('��ʾ','û����His�ҵ�ҽ���Ǽ�(�Һ�)��Ϣ','info');
		} else {
			var myAry = rtn.split("!")[1].split("^");
			GV.INSUADMID =  myAry[0];
			setValueById("psnNo", myAry[2]);              //ҽ����
			setValueById("INSUCardNo", myAry[3]);         //ҽ������
            setValueById("insuOptins",myAry[8])              //ҽ��ͳ����
            setValueById("InsuType",myAry[36])              //ҽ��ͳ����
		}
	});
	
}
// ���ؾ����б�
function loadAdmList(myPapmiId) {
	$('#AdmList').combobox('clear');
	
	var queryParams = {
		ClassName: "web.INSUReport",
		QueryName: "FindAdmList",
		type: "GET",
		papmi: myPapmiId,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		HisType:"O"
	}
	loadComboGridStore("AdmList", queryParams);
}
// �ǼǺŻس��¼�
function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		getPatInfo();
	}
}
//���ֳ�ʼ��
function init_layout(){	
	// east-panel
	var bodyWidth = +$('body div:first').css('width').split('px')[0];
	var westWidth = '800';
	var eastWidth = bodyWidth - westWidth;  	
	$('.west-panel').panel({ 
		width:westWidth 
	});  
	$('.west-panel').panel('resize');
	// east
	$('.east-panel').panel({
		width:eastWidth,
	});
	$('.east-panel').panel('resize');
	$('.layout-panel-east').css('left' ,westWidth + 'px'); 
	
	$('.EastSearch').panel({
		width:100	
	});
	$('.EastSearch').panel('resize');

	var dgHeight = 150; // // window - patbanner - padding(banner)10 - padding(panel)10*2 - ��ѯ���
	var height = 200;
	$('#dg').datagrid('options').height = 300;
	$('#dg').datagrid('resize');
	$('#ReportPanel').panel('options').height = 300;
	$('#ReportPanel').panel('resize');
	
}
// ҽ������ ��ҽ�������йص� ��������Ҫ�������¼���
function init_INSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('QInsuType','DLLType',Options); 	
	$('#QInsuType').combobox({
		onSelect:function(){
			// �����������
			init_XZType();
			
		    // ���ؾ���ƾ֤����
			init_CertType();
			
			// �����������
			init_MatnType();
			// ��������
			init_Naty();
			
			// ������Ա֤������
			init_PsnCertType();
			init_tPsnCertType()
			// �������������걨�����
			init_MatnTrtDclaerType();
			
			// ���ش�����֤������ 
			init_agnterCertType();
			
			// ������ż֤������ 
			init_SpusCertType();
			
			// ���ش����˹�ϵ
			init_agnterRlts();
			
			// ����Ĭ�϶���������ơ����� upt 20220428 HanZH
			init_fixmedins();
			//���ر�����ʶ
			init_ValiFlagSearch();
		}	
	})
		
}
// ����Ĭ�϶���������ơ����� add 20220428 HanZH
function init_fixmedins(){
	$.m({
			ClassName: "web.INSUDicDataCom",
			MethodName: "GetDicDataDescByCode",
			Type: 'HISPROPerty' + getValueById('QInsuType'),
			CodeStr: "InsuHospCode",
			HospDr: GV.HospDr
		}, function(DescStr) {
			if (!DescStr) {
				$.messager.popover({msg: "δ��ѯ������������룬���ʵҽ�������������ݣ�", type: "info"});
				return;
			}
			setValueById('fixmedinscode',DescStr);       //����������
		});
	$.m({
			ClassName: "web.INSUDicDataCom",
			MethodName: "GetDicDataDescByCode",
			Type: 'HISPROPerty' + getValueById('QInsuType'),
			CodeStr: "InsuHospName",
			HospDr: GV.HospDr
		}, function(DescStr) {
			if (!DescStr) {
				$.messager.popover({msg: "δ��ѯ������������ƣ����ʵҽ�������������ݣ�", type: "info"});
				return;
			}
			setValueById('fixmedinsname',DescStr);       //�����������
		});
	
}
// �������
function init_XZType(){
	$HUI.combobox(('#InsuType'),{
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
	        return data;
		},
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'insutype' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			$('#InsuType').combobox('select', "310");
		}		
	});

}
// �������
function init_MatnType(){
	$HUI.combobox(('#MatnType'),{
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		editable:false,
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'matn_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
 			$('#MatnType').combobox('select', "1");
		}		
	});	
}

/*
 * ���������걨�����
 */
function init_MatnTrtDclaerType(){
	$HUI.combobox(('#MatnTrtDclaerType'),{
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		editable:false,
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'matn_trt_dclaer_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			$('#MatnTrtDclaerType').combobox('select', "1");
		}		
	});
	
}

/*
 * ��Ա֤������
 */
function init_PsnCertType(){
	$HUI.combobox(('#PsnCertType'),{
		panelWidth:200,
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		editable:false,
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'psn_cert_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
 			$('#PsnCertType').combobox('select', "01");
		}		
	});
	
}
function init_tPsnCertType(){
	$HUI.combobox(('#tPsnCertType'),{
		panelWidth:200,
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		editable:false,
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'psn_cert_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
 			$('#tPsnCertType').combobox('select', "01");
		}		
	});
	
}

/*
 * ������֤������ 
 */
function init_agnterCertType(){
	$HUI.combobox(('#AgnterCertType'),{
		panelWidth:200,
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
	        return data;
		},
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'psn_cert_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			$('#AgnterCertType').combobox('select', "01");
		}		
	});
}

/*
 * ��ż֤������ 
 */
function init_SpusCertType(){
	$HUI.combobox(('#SpusCertType'),{
		panelWidth:200,
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
	        return data;
		},
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'psn_cert_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			$('#SpusCertType').combobox('select', "01");
		}		
	});
}

/*
 * �����˹�ϵ
 */
function init_agnterRlts(){
	$HUI.combobox(('#AgnterRlts'),{
		panelWidth:230,
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
	        return data;
		},
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'agnter_rlts' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			
		}		
	});
}

/*
 * �Ա�
 */
function init_Sex(){
	$HUI.combobox(('#Sex'),{
		panelWidth:200,
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		editable:false,
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'gend' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	});
	
}

/*
 * ����
 */
function init_Naty(){
	$HUI.combobox(('#Naty'),{
		panelWidth:200,
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		editable:false,
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'naty' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	});
	
}

/*
 * ����ƾ֤����
 */
function init_CertType(){
	
	var Options = {
		defaultFlag:'N',
		editable:'Y',
		hospDr:GV.HospDr	
	}
	INSULoadDicData('CertType','mdtrt_cert_type'+getValueById('QInsuType') ,Options); 
	$('#CertType').combobox({   
       onLoadSuccess: function(){
            $('#CertType').combobox('select', "99");
        }
	});		
}

/*
 *��ѯ���ҽ������
 */
function init_SearchInsuType(){
var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('SearchInsuType','DLLType',Options); 
	$('#SearchInsuType').combobox({
		onSelect:function(){
			// ���ر�����־
			init_ValiFlagSearch();
			// ���ز�ѯ���֤������ 
			//init_CertTypeSearch();
			
		},	
		
	})
}

//��ѯ��屸����־
function init_ValiFlagSearch()
{
	$HUI.combobox('#SearchValiFlag', {
		panelHeight: 'auto',
		data: [{
				value: '1',
				text: '�����ɹ�'
				
			},{
				value: '0',
				text: '����ʧ��'
			},{
				value: '',
				text: 'ȫ��',
				'selected':true
			}
		],
		valueField: 'value',
		textField: 'text',
	});
	
}
/*
 * ��ѯ���֤������
 */
function init_CertTypeSearch(){
	$HUI.combobox(('#SearchType'),{
		panelWidth:200,
		defaultFilter:'4',
		valueField: 'cCode',
		textField: 'cDesc',
		editable:false,
		url:$URL,
		loadFilter:function(data){
	        data.splice(data.length - 1, 1); // ��query���ص� ȫ�� ȥ��
	        return data;
		},
		onBeforeLoad:function(param){
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName= 'QueryDic';
			param.Type = 'psn_cert_type' + getValueById('SearchInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			$('#SearchType').combobox('select', "01");
		}		
	});
	
}

/*
 * datagrid
 */
function init_dg() {
	// ��ʼ��DataGrid
	$('#dg').datagrid({
		data:[],
		fit:true,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		frozenColumns:[[
		    {field:'TRowid',title:'TRowid',width:100,hidden:true},
			{field:'TMatnType',title:'�������',width:100},
			{field:'TValiFlag',title:'��Ч��־',width:80,align:'center',styler:function(val, index, rowData){
				switch (val){
					case "������":
						return "color:red";
						break;
					case "��Ч":
						return "color:green";
						break;
					case "����":
						return "color:yellow";
						break;
					case "������":
						return "color:blue";
						break;	
					case "����ʧ��":
						return "color:pink";
						break;			
				}
			}},	
			{field:'TPsnName',title:'��Ա����',width:100 }
			]],
		columns:[[ 
			{field:'THiType',title:'ҽ������',width:100},
			{field:'TBegnDate',title:'��ʼ����',width:100},
			{field:'TEndDate',title:'��������',width:100},
			{field:'TPsnNo',title:'���˱��',width:120 },
			{field:'TPsnCertType',title:'֤������',width:160 },
			{field:'TCertno',title:'֤������',width:150 },
			{field:'TTel',title:'��ϵ�绰',width:100},
			{field:'TAddr',title:'��ϵ��ַ',width:150 },
			{field:'TInsuOptins',title:'�α�ҽ������',width:150 },
			{field:'TFixmedinsCode',title:'����������',width:150 },
			{field:'TFixmedinsName',title:'�����������',width:150 },
			{field:'TMemo',title:'��ע',width:150 },
			{field:'TOpterId',title:'������',width:100 },
			{field:'TOptDate',title:'��������',width:100},
			{field:'TOptTime',title:'����ʱ��',hidden:true},
			{field:'TUpdtId',title:'������',hidden:true },
			{field:'TUpdtDate',title:'��������',hidden:true},
			{field:'TUpdtTime',title:'����ʱ��',hidden:true},
		    {field:'TRowid',hidden:true},
		    {field:'THospId',hidden:true},
		    {field:'TPapmiDr',hidden:true}, //������Ϣ��Dr
		    {field:'TAdmDr',hidden:true}, //�����Dr
		    //{field:'TInsuAdmInfoDr',hidden:true},
			//{field:'TDclaSouc',hidden:true}, //�걨��Դ
			{field:'TInsutype',hidden:true} //��������
		]],
		toolbar: '#tToolBar',
		onDblClickRow:function(index,rowData){
			ModINSUTarItems();
		},
		onClickRow:function(index,rowData){
			
		}
	});
}

//�޸ĸ�ֵ
function FillCenterInfo(i,rowDataObj){

	var MatnID=rowDataObj.TRowid;
	GV.MatnRowid=MatnID
	
	var MatnInfo=tkMakeServerCall("INSU.MI.BL.MatnTrtRegCtl","GetMatnTrtRegById",MatnID);
	var MatnArr=MatnInfo.split("^");
	GV.SelADMID=MatnArr[3];    //ҽ��ѡ��ľ����¼
	if(GV.SelADMID!=""){
		//disableById("AdmList"); 
	}
	setValueById("PsnCertType",MatnArr[6])	           //��Ա֤������
	setValueById("Certno",MatnArr[7])	               //��Ա֤������
	setValueById("name",MatnArr[8])	                   //����
	setValueById("BrDate",MatnArr[11])                 //��������
	setValueById("GesoVal",MatnArr[12])                //������
	setValueById("MatnTrtDclaerType",MatnArr[13])      //�����걨����� 
	setValueById("FpscNo",MatnArr[14])                 //�ƻ����������
	setValueById("LastMenaDate",MatnArr[15])           //ĩ���¾�ʱ��           
	setValueById("PlanMatnDate",MatnArr[16])           //Ԥ������ʱ��
	setValueById("SpusName",MatnArr[17])               //��ż����
	setValueById("SpusCertType",MatnArr[18])           //��ż֤������
	setValueById("SpusCertNo",MatnArr[19])             //��ż֤������	
	setValueById("SDate",MatnArr[22])                  //��ʼ����
	setValueById("EDate",MatnArr[23])                  //��������
	setValueById("tel",MatnArr[25])                    //��ϵ�绰
	setValueById("addr",MatnArr[26])                   //��ϵ��ַ
	setValueById("Fetts",MatnArr[27])                  //̥��
	setValueById("AgnterName",MatnArr[44])             //������
	setValueById("AgnterCertType",MatnArr[45])         //������֤������
	setValueById("AgnterCertno",MatnArr[46])           //������֤������
	setValueById("AgnterTel",MatnArr[47])              //��������ϵ��ʽ
	setValueById("AgnterAddr",MatnArr[48])             //��������ϵ��ַ
	setValueById("AgnterRlts",MatnArr[49])             //�����˹�ϵ
	setValueById("reflRea",MatnArr[50])                //��ע
	
	setValueById("psnNo",MatnArr[5])                //��Ա���  
	GV.InsuAdmDvs=MatnArr[29]                       //�α��ر��
	
	GV.OpterId=MatnArr[51]                             //������Id
	GV.OpterDate=MatnArr[52]                             //��������
	GV.OpterTime=MatnArr[53]                             //����ʱ��              
}



/*
 * ��������
 */
function initLoadGrid(){
		
	var queryParams = {
		ClassName : 'INSU.MI.BL.MatnTrtRegCtl',
		QueryName:'QueryMatnTrtReg',
		StartDate : getValueById("StartDate"),
	    EndDate : getValueById("EndDate"),
	    HiType : "00A",
	    InsuNo : getValueById("SearchInsuNo"),
	    PsnName: getValueById('SearchName'),
	    PatType : getValueById('SearchType'),
	    PatId : getValueById('SearchId'),
	    HospId : GV.HospDr
	}
	loadDataGridStore('dg',queryParams);
	
}

/*
 * ��ѯҽ�������Ϣ
 */
$('#btnFindReport').bind('click', function () {
	FindReportInfo();
})

/*
 * ��ҽ����
 */
$('#btn-readINSUCard').bind('click', function () {
	if(getValueById('QInsuType')==''){
		$.messager.alert('��ʾ', "ҽ�����Ͳ���Ϊ��" + str, 'error');	
		return;	
	}
	var CardType="1",InsuNo="";
	CardType=getValueById('CertType');	
	
	//CardType=getValueById('certtype');
 	var IDCardNo=getValueById('IDCardNo');
 	if(IDCardNo==""){
	 	$.messager.alert('��ʾ', "����д�и��ľ���ƾ֤����ٻ�ȡ��Ա��Ϣ" + str, 'error');
	 	return ;
	 	}
 	var tPsnCertType=getValueById('tPsnCertType');
 	var tPsnIDCardNo=getValueById('tPsnIDCardNo');
 	
	var ExpString = getValueById('QInsuType') + '^^' + GV.HospDr+"^^^"+CardType+"^"+IDCardNo+"^"+tPsnCertType+"^"+tPsnIDCardNo+"^^^";
	
	//var ExpString = getValueById('QInsuType') + '^' + GV.HospDr;
	var UserId = session['LOGON.USERID'];
	
	/*var str = InsuReadCard('0',UserId,InsuNo,CardType,ExpString);
	var TmpData = str.split("|");
	if (TmpData[0]!="0"){
		$.messager.alert('��ʾ', "����ʧ��" + str, 'error');	
		return;
	}else{
	 	var TmpData1 = TmpData[1].split("^")
	 	 
	 	setValueById('psnNo',TmpData1[0]);       //���˱��
	 	setValueById('INSUCardNo',TmpData1[1]);  //����
	 	setValueById('name',TmpData1[3]);        //����
	 	setValueById('Sex',TmpData1[4]);         //�Ա�
	 	setValueById('Naty',TmpData1[5]);        //����
	 	setValueById('BrDate',TmpData1[6]);      //��������
	 	setValueById('insuOptins',TmpData1[21]); //�α���������
	 	//setValueById('rylb',TmpData1[11]);     //��Ա���	 
	 	setValueById('InsuType',TmpData[3]);       //��������	
	 
	 }*/
	 var IPAddress=getClientIP().split("^")[0];
	var MACAddress=getClientIP().split("^")[2];
	var Input=GV.USERID+"^"+GV.HospDr+"^"+IPAddress+"^"+MACAddress+"^1^7"+"^"+"02"+"^"+IDCardNo+"^"
	var str =tkMakeServerCall("INSU.MI.BL.MatnTrtRegCtl","GetInsuPersonInfo",Input,"310","STR")
    var TmpData = str.split("^");
	if (TmpData[0]!="0"){
		$.messager.alert('��ʾ', "��ȡ��Ա��Ϣʧ��" + str, 'error');	
		return;
	}else{
		//0^44020000001101143720|01|440222198312140019|�Ž�|1|99|1983-12-14|38.1$0|310|11|1|2010-10-01|null|0|440222|ʼ��������ҽԺ
		var TmpData1=TmpData[1];
		var TmpAry=TmpData1.split("$");
		var TmpPsnAry=TmpAry[0].split("|");
		var TmpInsuAry=TmpAry[1].split("|");
		setValueById('psnNo',TmpPsnAry[0]);       //���˱��
	 	//setValueById('INSUCardNo',TmpData1[1]);  //����
	 	setValueById('name',TmpPsnAry[3]);        //����
	 	setValueById('Sex',TmpPsnAry[4]);         //�Ա�
	 	setValueById('Naty',TmpPsnAry[5]);        //����
	 	setValueById('BrDate',TmpPsnAry[6]);      //��������	
	 	setValueById(GV.InsuAdmDvs,TmpInsuAry[7]); //�α���������
	 	setValueById('InsuType',TmpInsuAry[1]);    //��������	
		
		
	}
    
});
/**
* ����У��
*/
function checkData() {
	var inValiddatebox = $('.validatebox-invalid');
	if(inValiddatebox.length > 0){ //validdatebox
		$.each(inValiddatebox, function (index, rowData) {
			var labelDesc = $('#' + rowData.id).parent().prev().find('label').text();
			var clsStr = $('#' + rowData.id).attr('class');
			if(clsStr.indexOf('combobox') > 0){
				var vaildCheck = getValueById(rowData.id);
				if(vaildCheck ==''>0){
					$.messager.alert('��ʾ', '[' + labelDesc +']' + '��֤��ͨ��' , 'error');
					throw rowData.id;
				}
			}else{
				$.messager.alert('��ʾ', '[' + labelDesc +']' + '��֤��ͨ��' , 'error');
				throw rowData.id;
			}
		});		
	}
}

/*
 * ��ѯ
 */
$('#btnFind').bind('click', function () {
	initLoadGrid();
});
/* 
 * ��ѯҽ�������Ϣ
 */
function FindReportInfo(){
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if(selected.TabFlag =='�ѳ���'){
			$.messager.alert('��ʾ', "����Ѿ�����", 'info');
			return;
		}
		$.messager.alert('��ʾ', "��Ҫ����ҽ������", 'info');	
	} else {
		$.messager.alert('��ʾ', "��ѡ��Ҫ��ѯ�ļ�¼", 'info');
	}
}
 

function getPatInfo() {
	var patientNo = getValueById("patientNo");
	if (patientNo) {
		var expStr = "";
		$.m({
			ClassName: "web.DHCOPCashierIF",
			MethodName: "GetPAPMIByNo",
			PAPMINo: patientNo,
			ExpStr: expStr
		}, function(papmi) {
			if (!papmi) {
				$.messager.popover({msg: "�ǼǺŴ�������������", type: "info"});
				return;
				//focusById("patientNo");
			}
			var admStr = "";
			setPatientInfo(papmi);
			loadAdmList(papmi);
			//refreshBar(papmi,'');
		});
	}
}

function setPatientInfo(papmi) {
	var expStr = PUBLIC_CONSTANT.SESSION.HOSPID;
	$.m({
		ClassName: "web.DHCINSUPatInfo",
		MethodName: "GetPatInfoByPatID",
		PatID: papmi,
	}, function(rtn) {
		var myAry = rtn.split("!");
		if(myAry[0]!=1){
			 $.messager.alert('��ʾ', "δ�ҵ��û��߻�����Ϣ���ʵ", 'info');
			  return ;
			}
		 myAry = rtn.split("^");
		setValueById("patientNo", myAry[1]);
		setValueById("name", myAry[2]);
		setValueById("tel", myAry[6]);
		setValueById("addr", myAry[16]+myAry[18]+myAry[20]+myAry[7]);
		setValueById("Sex", myAry[4]);
		setValueById("IDCardNo", myAry[8]);
		setValueById("tPsnIDCardNo", myAry[8]);
		setValueById("Certno", myAry[8]);
		setValueById("BrDate", myAry[9]);
		
	});
}


/**
 * ˢ�»�����Ϣ��
 */
 /*
function refreshBar(papmi, adm) {
	//loadAdmList(papmi);
	$.m({
		ClassName: "web.DHCDoc.OP.AjaxInterface",
		MethodName: "GetOPInfoBar",
		CONTEXT: "",
		EpisodeID: adm,
		PatientID: papmi
	}, function (html) {
		if (html != "") {
			$(".PatInfoItem").html(reservedToHtml(html));
		} else {
			$(".PatInfoItem").html("��ȡ������Ϣʧ�ܣ����顾������Ϣչʾ�����á�");
		}
	});
}*/


function reservedToHtml(str) {
	var replacements = {
		"&lt;": "<",
		"&#60;": "<",
		"&gt;": ">",
		"&#62;": ">",
		"&quot;": "\"",
		"&#34;": "\"",
		"&apos;": "'",
		"&#39;": "'",
		"&amp;": "&",
		"&#38;": "&"
	};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g, function (v) {
		return replacements[v];
	});
}

/**
* banner��ʾ��Ϣ
*/
function showBannerTip() {
	$(".PatInfoItem").html("<div class='unman'></div><div class='tip-txt'>���Ȳ�ѯ����</div>");
}


function cardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		//clear();
		var cardNo = getValueById("HISCardNo");
		if (!cardNo) {
			return;
		}
		DHCACC_GetAccInfo("", cardNo, "", "", magCardCallback);
	}
}

function magCardCallback(rtnValue) {
	loadAdmList('');
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("HISCardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("HISCardType", myAry[8]);
		getPatInfo();
		break;
	case "-200":
		$.messager.alert("��ʾ", "����Ч", "info", function () {
			//focusById("HISCardNo");
		});
		break;
	case "-201":
		setValueById("HISCardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("HISCardType", myAry[8]);
		getPatInfo();
		break;
	default:
	}
	if (patientId != "") {
		var admStr = "";
		loadAdmList(patientId);
		refreshBar(patientId, '');
	}
}

/**
* ��ȡ����ѱ���Ϣ
*/
function getAdmReasonInfo(episodeId) {
	return $.m({ClassName: "web.UDHCJFPAY", MethodName: "GetAdmReaNationCode", EpisodeID: episodeId}, false);
}
// HIS�շ���Ŀ
function init_HISTarItem(){		
	$('#xmbm').combobox({
		valueField: 'code',
		textField: 'desc',
		url: $URL + '?ClassName=DHCBILLConfig.DHCBILLFIND&QueryName=FindTarItem&ResultSetType=array',
		mode: 'remote',
		method: 'get',
		onBeforeLoad: function (param) {
			if (!param.q) {
				return false;
			}
			$.extend(param, {
				code: "",                           //��Ŀ����
				desc: "",                           //��Ŀ���� �����������ݲ�ѯ
				alias: param.q,                     //����
				str: '',                //��δ�
				HospID: GV.HospDr    //ҽԺID
			});
			return true;
	 	}
	});
}
$('#btnClean').bind('click',function(){
	
	addINSUTarItems();
		
})
$('#btnReferMod').bind('click',function(){
	
	ModINSUTarItems();
		
})
$('#btn-readCard').bind('click',function(){
	//readHFMagCardClick();	
	readInsuCardClick();	
})

/**
 * ����
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	if ($("#btn-readCard").hasClass("l-btn-disabled")) {
		return;
	}
	DHCACC_GetAccInfo7(magCardCallback);
}

function clear(){
	//��ѯ����
	$(".searchPanel").form("clear");
	$('#SearchInsuType').combobox('reload');
	$(".addInfo").form("clear");
	$('#QInsuType').combobox('reload');	
	$(".PatInfoItem").html('');
	//setValueById('SDate',getDefStDate(0));
	//setValueById('EDate',getDefStDate(1));
	//InsuDateDefault('SDate',-1);	//upt HanZH 20210918	
	//InsuDateDefault('EDate',365);
			
	//setValueById('RRefLtype',"");
	//$('#RRefLtype').combobox('reload');	
	//setValueById('StartDate',getDefStDate(0));
	//setValueById('EndDate',getDefStDate(1));
	//InsuDateDefault('StartDate',-1);	//upt HanZH 20210918
	//InsuDateDefault('EndDate');	
	
	//InsuDateDefault('DclaDate');
	initDate();
	initLoadGrid();
}

/*
*��ҽ����
*/
function readInsuCardClick()
{ 
	var rtn="-1"
	var Info=""
	rtn=InsuReadCard(1,GV.USERID,"","","^^^^^^^^^^")
	if (rtn.spit("|")[0]!="0"){
		$.messager.popover({msg: "��ҽ����ʧ��", type: "info"});
		return;	
	}else{
		Info=rtn.spit("|")[1].split("^")
		setValueById("psnNo", Info[0]);
		setValueById("name", Info[3]);
		//setValueById("Sex", Info[4]);
		setValueById("insuOptins", Info[21]);
		setValueById("XZType", Info[27].split("|")[2]);
		setValueById("PoolareaNo", Info[21]);
		setValueById("BrDate", Info[6]);	//�������� add 20220429 HanZH 
		setValueById("PsnCertType", Info[25]);	//��Ա֤������
		setValueById("Certno", Info[26]);	//��Ա֤������ 
	}
}


/*
 * �������������Ǽ�
 * ��˧ 2022/11/24
 */ 
function addINSUTarItems() { 
	var TRowid=""
    var InsuType= getValueById("QInsuType");

	if(getValueById("AdmList")==""){
		$.messager.alert("��ܰ��ʾ","��ѡ�������Ϣ!", 'info'); 
		return;
	}
	if ("undefined"==typeof parent.window.HISUIStyleCode || parent.window.HISUIStyleCode==""){
		// �Ųʰ�
		var top="218.5px"
	    var left="245.5px"
	  
	  }else if (parent.window.HISUIStyleCode=="lite"){
		// �����
	    var top="177"
	    var left="267"
	 }else{
		// �Ųʰ�
	    var top="218.5px"
	    var left="245.5px"
	  }
	var url = "dhcinsu.matntrtregpop.csp?&Rowid="+GV.ADMID+"&HiType="+InsuType+"&HospId="+GV.HospDr+"&TRowid="+TRowid+"&patientNo="+getValueById("patientNo"); 		
	websys_showModal({
		url: url,
		title: "����-���������Ǽ�",
		iconCls: "icon-w-add",
		width: "905",
		top:top,
		left: left,
		height: "448",
		onClose: function () {
			clear();
			//QryInOperList();
		}   
	});
	

}
/*
 * �޸����������Ǽ�
 * ��˧ 2022/12/02
 */	
	function ModINSUTarItems() {
	
	var selected = $('#dg').datagrid('getSelected');
	if (!selected) {
	   $.messager.alert("��ܰ��ʾ","��ѡ��һ��������¼!", 'info');
	}
	else{
				var TRowid=selected.TRowid;
				if ("undefined"==typeof parent.window.HISUIStyleCode || parent.window.HISUIStyleCode==""){
					// �Ųʰ�
					var top="218.5px"
					var left="245.5px"
				  
				  }else if (parent.window.HISUIStyleCode=="lite"){
					// �����
					var top="177"
					var left="267"
				 }else{
					// �Ųʰ�
					var top="218.5px"
					var left="245.5px"
				  }	
	var url = "dhcinsu.matntrtregpop.csp?&Rowid="+GV.ADMID+"&HiType="+InsuType+"&HospId="+GV.HospDr+"&TRowid="+TRowid; 		
	websys_showModal({
		url: url,
		title: "�޸�-���������Ǽ�",
		iconCls: "icon-w-edit",
		width: "905",
		height: "448",
		top:top,
		left: left,
		onClose: function () {
			clear();
			//QryInOperList();
		}   
	});
		}
	
	}
/*
*��ʼ�����ڸ�ʽ
*HanZH 20210918
*/
function init_Date(){
	InsuDateDefault('StartDate');
	InsuDateDefault('EndDate');
	InsuDateDefault('SDate');
	InsuDateDefault('EDate');
	InsuDateDefault('DclaDate');
	InsuDateDefault('LastMenaDate');
	InsuDateDefault('PlanMatnDate');
	}
function initDate(){
		
	var today=new Date();
	date=new Date(today.getTime()-24*60*60*1000);
	var s0=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+"01"
	
	 
	var s1=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+getSpanDays(date.getMonth()+1)
	
	$('#StartDate').datebox({
		value: s0,
	    formatter: function(date){
			var year=date.getFullYear();
			var month=date.getMonth()+1;
			var day=date.getDate();
				return year+"-"+(month<10 ? ("0"+month) : month)+"-"+(day<10?("0"+day):day);
		}
	});
	
	$('#EndDate').datebox({
		value: s1,
		formatter: function(date){
			var year=date.getFullYear();
			var month=date.getMonth()+1;
			var day=date.getDate();
				return year+"-"+(month<10 ? ("0"+month) : month)+"-"+(day<10?("0"+day):day);
			
		},
	});
	function getSpanDays(month,year){
		var SpanDays=31;
		if ((month == 4)||(month == 6)||(month == 9)||(month == 11)){
			 SpanDays=30;
			}
		if (month == 2) {
			var tyear=year||(new Date()).getFullYear();
			SpanDays=28;
			if((tyear%4 ==0)&&(tyear%100 !=0)){
				 SpanDays=29;
				}
			}
			
			return SpanDays ;
		
		}
}
