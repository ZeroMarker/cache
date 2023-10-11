/**
* FillName: dhcinsu/divmonstmtimportresult.js
* Description: ���������ϴ������������ϸ��������
* Creator WangXQ
* Date: 2022-06-17
*/
//var Rq = INSUGetRequest();
//var Pid=Rq["Pid"];

//��ں���
$(function(){

	setPageLayout();    //����ҳ�沼��
	setElementEvent();  //����ҳ��Ԫ���¼�	
});

function setPageLayout() {
	InitImportYDg();
	InitImportNDg();
}
function setElementEvent(){
	QryImportY();
	QryImportN();
	$("#btnSearch").click(SearchImportData);		//��ѯ
	$("#btnExportN").click(ExportImportDataN);		//����ʧ������
	$("#btnExportY").click(ExportImportDataY);		//�����ɹ�����
	$("#psnName").keydown(function(e) { 	//�����س��¼�
	  if (e.keyCode==13)
	  {
		SearchImportData();
	  }
	});
	$("#seltId").keydown(function(e) { 		//����ID�س��¼�
	  if (e.keyCode==13)
	  {
		SearchImportData();
	  }
	}); 
	$("#mdtrtId").keydown(function(e) { 	//����ID�س��¼�
	  if (e.keyCode==13)
	  {
		SearchImportData();
	  }
	}); 
	$("#certNo").keydown(function(e) { 		//֤������س��¼�
	  if (e.keyCode==13)
	  {
		SearchImportData();
	  }
	});   			
	
}

//��ѯ��ť
function SearchImportData(){
	
	QryImportY();
	QryImportN();

}
//��ѯ����ɹ�����
function QryImportY()
{
	var Rq = INSUGetRequest();
	var Pid=Rq["Pid"];

	 var queryParams = {

	    ClassName : 'INSU.MI.DAO.HisDivInfo',
	    QueryName : 'QueryImportInfo',
	    ImportFlag:"Y",
	    PsnName:$('#psnName').val(),
	 	SeltId:$('#seltId').val(),
	 	MdtrtId:$('#mdtrtId').val(),
	 	CertNo:$('#certNo').val(),
	 	Pid:Pid
	}	
    loadDataGridStore('importy',queryParams);
	}
	
//��ѯ����ʧ������
function QryImportN()
{
	var Rq = INSUGetRequest();
	var Pid=Rq["Pid"];
	
	 var queryParams = {

	    ClassName : 'INSU.MI.DAO.HisDivInfo',
	    QueryName : 'QueryImportInfo',
	    ImportFlag:"N",
	    PsnName:$('#psnName').val(),
	 	SeltId:$('#seltId').val(),
	 	MdtrtId:$('#mdtrtId').val(),
	 	CertNo:$('#certNo').val(),
	 	Pid:Pid	    
	}	
    loadDataGridStore('importn',queryParams);
	}

//����ʧ������
function ExportImportDataN()
{
   try
   {
  	var Rq = INSUGetRequest();
	var Pid=Rq["Pid"];
$.messager.progress({
         title: "��ʾ",
		 msg: '���ڵ�������ʧ������',
		 text: '������....'
		   });
$cm({
	ResultSetType:"ExcelPlugin",  
	ExcelName:"����ʧ������",		  
	PageName:"QueryImportData",      
	ClassName:"INSU.MI.DAO.HisDivInfo",
	QueryName:"QueryImportData",
    ImportFlag:"N",
	PsnName:$('#psnName').val(),
	SeltId:$('#seltId').val(),
	MdtrtId:$('#mdtrtId').val(),
	CertNo:$('#certNo').val(),
	Pid:Pid
},function(){
	  setTimeout('$.messager.progress("close");', 3 * 1000);	
});

   } catch(e) {
	   $.messager.alert("����",e.message);
	   $.messager.progress('close');
   };
  
   
   }
//�����ɹ�����
function ExportImportDataY()
{
   try
   {
  	var Rq = INSUGetRequest();
	var Pid=Rq["Pid"];
$.messager.progress({
         title: "��ʾ",
		 msg: '���ڵ�������ɹ�����',
		 text: '������....'
		   });
$cm({
	ResultSetType:"ExcelPlugin",  
	ExcelName:"����ɹ�����",		  
	PageName:"QueryImportData",      
	ClassName:"INSU.MI.DAO.HisDivInfo",
	QueryName:"QueryImportData",
    ImportFlag:"Y",
	PsnName:$('#psnName').val(),
	SeltId:$('#seltId').val(),
	MdtrtId:$('#mdtrtId').val(),
	CertNo:$('#certNo').val(),
	Pid:Pid
},function(){
	  setTimeout('$.messager.progress("close");', 3 * 1000);	
});

   } catch(e) {
	   $.messager.alert("����",e.message);
	   $.messager.progress('close');
   };
   }
   
   
	
//��ʼ������ɹ������б�
function InitImportYDg() {
	$('#importy').datagrid({
		onLoadSuccess: function () {
	           $(".datagrid-header-rownumber,.datagrid-cell-rownumber").width("50");
	        },
				fit:true,
				border:false,
				striped:true,
				checkOnSelect:true,
				singleSelect: true,
				rownumbers: true,
				pageList: [13,30,50],
				pageSize: 13,
				pagination: true,
			    columns: [[
			   {
				title: '����ID',
				field: 'seltId',
			},
			{
				title: '����ID',
				field: 'mdtrtId',
			},
			{
				title: 'ԭ����ID',
				field: 'msgId',
			},
			{
				title: '��Ա����',
				field: 'psnNo',
			},
			{
				title: '��Ա����',
				field: 'psnName',
			},
			{
				title: '֤������',
				field: 'certNo',
			},
			{
				title: '��ʼʱ��',
				field: 'StDate',
			},
			{
				title: '����ʱ��',
				field: 'EnDate',
			},
			{
				title: '����ʱ��',
				field: 'tmpsfrq',
			},
			{
				title: '��������',
				field: 'admType',
			},
			{
				title: '�ܷ���',
				field: 'totAmout',
			},
			{
				title: '����֧��',
				field: 'hisJjzfe',
			},
			{
				title: '����֧��',
				field: 'OwnPay',
			},
			{
				title: '����֧��',
				field: 'hisZhzfe',
			},
			{
				title: '�ֽ�֧��',
				field: 'hisGrzfe',
			},
			{
				title: '����',
				field: 'xzlb',
			},
			{
				title: '�˷ѽ����ʶ',
				field: 'RefdSetlFlag',
			},
			{
				title: '���㾭�����',
				field: 'ClrOptins',
			},
			{
				title: '��Ա���',
				field: 'patType',
			},
			{
				title: '�α�����ҽ������',
				field: 'insuOptins',
			},
			{
				title: '��������',
				field: 'VisitDate',
			},
			{
				title: '��Ժ����(��סԺΪ��)',
				field: 'LeaveDate',
			},
			{
				title: '��Ժ���',
				field: 'preDiagnosis',
			},
			{
				title: '��Ժ���/��Ҫ���',
				field: 'mainDiagnosis',
			},
			{
				title: '����ҽ��ͳ�����֧��',
				field: 'hisHifpPay',
			},
			{
				title: '���ҽ�Ʋ�������֧��',
				field: 'hisHifobPay',
			},
			{
				title: '����Աҽ�Ʋ�������֧��',
				field: 'hisCvlservPay',
			},
			{
				title: 'ҽ�ƾ�������֧��',
				field: 'hisMafPay',
			},
			{
				title: '�˲���Աҽ�Ʊ��ϻ���֧��',
				field: 'hisHifdmPay',
			},
			{
				title: '����ҽ�Ʊ��ջ���֧��',
				field: 'hisHifesPay',
			},
			{
				title: '�󲡲���ҽ�Ʊ��ջ���֧��',
				field: 'hisHifmiPay',
			},
			{
				title: '��������֧��',
				field: 'hisOthPay',
			},
			{
				title: 'ȫ�Էѽ��',
				field: 'hisOwnpayAmt',
			},
			{
				title: '���޼��Էѷ���',
				field: 'hisOverlmtSelfPay',
			},
			{
				title: '�����Ը����',
				field: 'hisPreselfpayAmt',
			},
			{
				title: '���Ϸ�Χ���',
				field: 'hisInscpScpAmt',
			},
			{
				title: '����ҽ��ͳ������Ը�',
				field: 'hisPoolPropSelfPay',
			},
			{
				title: '��Ա֤������',
				field: 'psnCertType',
			},
			{
				title: '�Ƿ�������¼',
				field: 'YoNNormalRecord',
			}
			    
			    ]]
			    			    
			    });
}
//��ʼ������ʧ�������б�
function InitImportNDg() {
	$('#importn').datagrid({
		onLoadSuccess: function () {
	           $(".datagrid-header-rownumber,.datagrid-cell-rownumber").width("50");
	        },
				fit:true,
				border:false,
				striped:true,
				checkOnSelect:true,
				singleSelect: true,
				rownumbers: true,
				pageList: [13,30,50],				
				pageSize: 13,
				pagination: true,
			    columns: [[
			    {
				title: 'ʧ����Ϣ',
				field: 'FailInfo',
			},
			    {
				title: '����ID',
				field: 'seltId',
			},
			{
				title: '����ID',
				field: 'mdtrtId',
			},
			{
				title: 'ԭ����ID',
				field: 'msgId',
			},
			{
				title: '��Ա����',
				field: 'psnNo',
			},
			{
				title: '��Ա����',
				field: 'psnName',
			},
			{
				title: '֤������',
				field: 'certNo',
			},
			{
				title: '��ʼʱ��',
				field: 'StDate',
			},
			{
				title: '����ʱ��',
				field: 'EnDate',
			},
			{
				title: '����ʱ��',
				field: 'tmpsfrq',
			},
			{
				title: '��������',
				field: 'admType',
			},
			{
				title: '�ܷ���',
				field: 'totAmout',
			},
			{
				title: '����֧��',
				field: 'hisJjzfe',
			},
			{
				title: '����֧��',
				field: 'OwnPay',
			},
			{
				title: '����֧��',
				field: 'hisZhzfe',
			},
			{
				title: '�ֽ�֧��',
				field: 'hisGrzfe',
			},
			{
				title: '����',
				field: 'xzlb',
			},
			{
				title: '�˷ѽ����ʶ',
				field: 'RefdSetlFlag',
			},
			{
				title: '���㾭�����',
				field: 'ClrOptins',
			},
			{
				title: '��Ա���',
				field: 'patType',
			},
			{
				title: '�α�����ҽ������',
				field: 'insuOptins',
			},
			{
				title: '��������',
				field: 'VisitDate',
			},
			{
				title: '��Ժ����(��סԺΪ��)',
				field: 'LeaveDate',
			},
			{
				title: '��Ժ���',
				field: 'preDiagnosis',
			},
			{
				title: '��Ժ���/��Ҫ���',
				field: 'mainDiagnosis',
			},
			{
				title: '����ҽ��ͳ�����֧��',
				field: 'hisHifpPay',
			},
			{
				title: '���ҽ�Ʋ�������֧��',
				field: 'hisHifobPay',
			},
			{
				title: '����Աҽ�Ʋ�������֧��',
				field: 'hisCvlservPay',
			},
			{
				title: 'ҽ�ƾ�������֧��',
				field: 'hisMafPay',
			},
			{
				title: '�˲���Աҽ�Ʊ��ϻ���֧��',
				field: 'hisHifdmPay',
			},
			{
				title: '����ҽ�Ʊ��ջ���֧��',
				field: 'hisHifesPay',
			},
			{
				title: '�󲡲���ҽ�Ʊ��ջ���֧��',
				field: 'hisHifmiPay',
			},
			{
				title: '��������֧��',
				field: 'hisOthPay',
			},
			{
				title: 'ȫ�Էѽ��',
				field: 'hisOwnpayAmt',
			},
			{
				title: '���޼��Էѷ���',
				field: 'hisOverlmtSelfPay',
			},
			{
				title: '�����Ը����',
				field: 'hisPreselfpayAmt',
			},
			{
				title: '���Ϸ�Χ���',
				field: 'hisInscpScpAmt',
			},
			{
				title: '����ҽ��ͳ������Ը�',
				field: 'hisPoolPropSelfPay',
			},
			{
				title: '��Ա֤������',
				field: 'psnCertType',
			},
			{
				title: '�Ƿ�������¼',
				field: 'YoNNormalRecord',
			}
			    
			    ]]
			    			    
			    });
}
