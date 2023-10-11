 /*
 * FileName:	dhcinsu/matntrtregpop.js
 * User:		JinS1010
 * Date:		2023-02-20
 * Function:	������������(����)
 */ 
// ���峣��
var Rq = INSUGetRequest();
var TRowid = Rq["TRowid"]
 var GV = {
	HospDr:session['LOGON.HOSPID'] ,  //Ժ��ID
	USERID:session['LOGON.USERID'] ,  //����ԱID
	GROUPID:session['LOGON.GROUPID'], //��ȫ��id
	ADMID:Rq["Rowid"],               //����ID
	SelADMID:'',                      //ѡ��ľ���ID                   
	INSUADMID : '',                   //ҽ��������ϢID
	MatnRowid:'',                     //����������rowid
	fixmedinsCode:'H36011100214',     //����ҽҩ�������(��Ŀ���Լ���)
	fixmedinsName:'�ϲ��еھ�ҽԺ',   //����ҽҩ��������(��Ŀ���Լ���)
	PoolareaNo:'360100',              //ҽԺ����ͳ�������(��Ŀ���Լ���)
	InsuAdmDvs:'',                    //���߲α��ر��� 
	OpterId:'',                       //������                     
	OpterDate :'',                    //��������
	OpterTime :''                     //����ʱ��
} 

var index=1
//��ں���
$(function(){
	//����ҳ�沼��
	setPageLayout();    
	//����ҳ��Ԫ���¼�
	setElementEvent();	
	//���س�ʼ��Ϣ
	getPatInfo();
	//���ùر�ҳ���¼�
	initEvent(); 
});
//����ҳ�沼��
function setPageLayout(){
	
	// ҽ������
	init_INSUType();
	
	// �����¼
	initAdmList();
		
	//��ʼ����������������¼	
	init_dg();
    
    //��ʼ����������������¼	
    if(TRowid!="")
    {
	pop();
    }
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
}

/*
*�������޸���Ϣ
*/
function MatnTrtMod_Click()
{
	var Handle=0,UserId=GV.USERID,AdmDr=GV.ADMID,HospId=GV.HospDr;
	var Rowid=GV.MatnRowid;
	var PapmiDr="";                            //������Ϣ��Dr
	var HiType=getValueById('QInsuType');
	var InStr="",ExpStr="";
	var InStr=TRowid+"^"+HospId+"^"+PapmiDr+"^"+AdmDr+"^"+HiType; 
	setValueById('psnNo',index)
	//��Ա���^��Ա֤������^֤������^��Ա����^����^�Ա�^��������^������^���������걨�����^�ƻ���������֤��^ĩ���¾�����^Ԥ����������^ 5-16
	//��ż����^��ż֤������^��ż֤������^����ҽҩ�������^����ҽҩ��������^��ʼ����^��������^ͳ�������^��ϵ�绰^��ϵ��ַ^̥��^�������^ 17-28
	//�α�����ҽ������^��������^�����걨��ϸ��ˮ��^��Ч��־^��λ���^��λ����^��Ա�α���ϵID^����������^����������^�����鱨����׼^ 29-38
	//�����ʸ�Ǽ�״̬^�걨����^�ֶ���չ^��չ����1^��չ����2^����������^������֤������^������֤������^��������ϵ��ʽ^��������ϵ��ַ^ 39-48
	//�����˹�ϵ^��ע^������ID^��������^����ʱ��^������ID^��������^����ʱ�� 49-56
	//^2^^^00A^����^411481199910105177^^^^5^1^11^^^111^01^111^H44022200010^ʼ��������ҽԺ^2022-02-16^2022-12-07^440222^18137077186^111111^1^7
	//^^310^1^A^^^^H44022200010^^^A^2022-12-1^^^^111^01^111^11^^1^^^^^909^2022-12-1^14:36:1
	var psnNo=getValueById('psnNo');
	InStr=InStr+"^"+psnNo;                                       			//��Ա���  ҽ���ǼǱ�  INADM_InsuId
	
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
	var Sex=getValueById('Sex');                                            //�Ա�
	InStr=InStr+"^"+Sex;                                 		             
	InStr=InStr+"^"+getValueById('Naty');                                 	//����
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
	
	var InsuAdmdvs=GV.InsuAdmDvs                                          //�α�����ҽ������ ��undif��
	if(InsuAdmdvs===undefined){
		
		InsuAdmdvs=""
		}
	
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

	var today=new Date();
	var NowDate=today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate();
	var NowTime=today.getHours()+":"+today.getMinutes()+":"+today.getSeconds();
	var UpdtId=UserId                                                          //�����ˣ������ˣ�-----ҽ������Ա��������
	var UpdtDate=NowDate                                                        //��������
	var UpdtTime=NowTime                                                       //����ʱ��
	
	if(TRowid==""){                                             //-ҽ������Ա��������
		
		OpterId=UpdtId
		OptDate=UpdtDate
		OptTime=UpdtTime
		}else{
		if (GV.OpterId!=""){OpterId=GV.OpterId}	
	      if (GV.OpterDate!=""){OptDate=GV.OpterDate}
	     if (GV.OpterTime!=""){OptTime=GV.OpterTime}                             //���ҽʦ��д�ģ���д�˲��ܱ�	
			}
		                                                                         //���ҽʦ��д�ģ���д�˲��ܱ�
	InStr=InStr+"^"+OpterId+"^"+OptDate+"^"+OptTime; 	
	InStr=InStr+"^"+UpdtId+"^"+UpdtDate+"^"+UpdtTime;
	console.log(InStr)
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
			    index=index+1
			   $.messager.alert('��ʾ','�޸������������ݳɹ�');
			   initLoadGrid();	
			}
	  $.messager.progress("close");
	});	 
	initLoadGrid();	
}
/**
*��ʼ�������¼
*/
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
/*
 * ҽ������ ��ҽ�������йص� ��������Ҫ�������¼���
 */
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
			
			//���ر�����ʶ
			init_ValiFlagSearch();
		}	
	})
}
/*
 * �������
 */
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
/*
 * �������
 */
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
			//FindReportInfo();	
		},
		onClickRow:function(index,rowData){
			//ѡ�д��ϴ���¼�������ݼ��ص���߱�������
			GV.MatnRowid="";
			GV.SelADMID="";
			FillCenterInfo(index,rowData)
		}
	});
}
/*
 * ��������
 */
function initLoadGrid(){	
	var SearchValiFlag=getValueById("SearchValiFlag")
	var queryParams = {
		ClassName:'INSU.MI.BL.MatnTrtRegCtl',
		QueryName:'QueryMatnTrtReg',
		StartDate:getValueById("StartDate"),
	    EndDate:getValueById("EndDate"),
	    HiType:"00A",
	    InsuNo:getValueById("patientNo"),
	    PsnName:"",
	    PatType:getValueById('tPsnCertType'),
	    PatId:getValueById('tPsnIDCardNo'),
	    SearchValiFlag:SearchValiFlag,
	    HospId:GV.HospDr
	}
	loadDataGridStore('dg',queryParams);
}function FillCenterInfo(i,rowDataObj){
	if(rowDataObj.TValiFlag!="������" && rowDataObj.TValiFlag!="����ʧ��"){return;}
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
function getPatInfo() {

	var patientNo = Rq["patientNo"];
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
$('#btnClean').bind('click',function(){
	addINSUTarItems();
	clear();		
})
//����
function clear(){
	//��ѯ����
	$(".searchPanel").form("clear");
	$('#SearchInsuType').combobox('reload');
	$(".addInfo").form("clear");
	$('#QInsuType').combobox('reload');	
	$(".PatInfoItem").html('');
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
	var InsuType = getValueById('QInsuType');
	if(InsuType==""){
		$.messager.alert('��ʾ','ҽ�����Ͳ���Ϊ��','info');
		return;	
	}
	var url = "dhcinsu.matntrtregpop.csp?&Rowid="+"&HiType="+InsuType+"&HospId="+GV.HospDr; 	
	websys_showModal({
		url: url,
		title: "����-���������Ǽ�",
		iconCls: "icon-w-edit",
		width: "1200",
		height: "600",
		onClose: function () {
			clear();
			}   
	});
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
	InsuDateDefault('PlanMatnDate');	}
function pop(){
    var MatnID=TRowid
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
	setValueById("MatnType",MatnArr[28])               //��������
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
	setValueById("psnNo",MatnArr[5])                   //��Ա���  
	GV.InsuAdmDvs=MatnArr[29]                          //�α��ر��
	GV.OpterId=MatnArr[51]                             //������Id
	GV.OpterDate=MatnArr[52]                           //��������
	GV.OpterTime=MatnArr[53]                           //����ʱ��              
}
function initEvent(){
	$("#btnU").click(function () {	
  
		MatnTrtMod_Click();	
	});	 
	$("#btnC").click(function () {		
		websys_showModal('close');
	});
}
