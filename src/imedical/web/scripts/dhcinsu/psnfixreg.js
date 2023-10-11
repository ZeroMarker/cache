/*
 * FileName:	psnfixreg.js
 * User:		Chenyq
 * Date:		2021-09-23
 * Function:	��Ա���㱸��
 */
 
// ���峣��
 var GV = {
	UPDATEDATAID : '',
	HospDr:session['LOGON.HOSPID'] ,  //Ժ��ID
	USERID:session['LOGON.USERID'] ,  //����ԱID
	ADMID:'',
	PAPMI:'',
	INSUADMID : ''
}

//��ں���
$(function(){
	setPageLayout();    //����ҳ�沼��
	setElementEvent();	//����ҳ��Ԫ���¼�
});

//����ҳ�沼��
function setPageLayout(){
	
	// ҽ������
	init_INSUType();
	
	// ҵ����������
	init_bizAppyType();
	
	// ��Ա֤������
	init_PsnCertType();
	
	// ������֤������
	init_agnterCertType();
	
	// �����˹�ϵ
	init_agnterRlts();
	
	// ��ѯ���ҽ������
	init_SearchINSUType();
	
	// ��ѯ���֤������
	init_CertTypeSearch();
	
	// ����ҽҩ��������
	init_fixmedinsName();
	
	// �������
	init_XZType();
	
	// �����¼
	initAdmList();
	
	//������ϼ�¼
	InitDiagLst();
	
	//��ʼ����Ա���㱸����¼	
	init_dg();
	
	//���ڳ�ʼ��	add hanzh 20210918
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
	//���㱸��(�Ǽ�)
	$("#btnFixReg").click(FixReg_Click);
	
    //��������
    $("#btnReferDes").click(FixRegDes_Click); 
     
    //������ѯ
    $("#btnsearch").click(FixRegsearch_Click); 
    
    //��Ա���㱸����¼��ѯ
    $("#psnfixregSearch").click(initLoadGrid); 
	
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
	$("#CertNoSearch").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			initLoadGrid();
		}
	});
	
}
	
/**
*�����Ǽ�
*/
function FixReg_Click()
{
	var Handle=0,UserId=GV.USERID,AdmDr=GV.ADMID,HospId=GV.HospDr;
	//��Ա���^ҵ����������^��ϵ�绰^��ϵ��ַ^��ʼ����^��ʼ����^����������^������֤������^������֤������^��������ϵ��ʽ^��������ϵ��ַ^
	//�����˹�ϵ^���������^����ҽҩ�������^����ҽҩ��������^��ע
	var PapmiDr="";  //������Ϣ��Dr
	var HiType=getValueById('QInsuType');
	var DclaSouc="01";  //�걨��Դ 1 ҽԺ 2 ����
	var InStr=""
	var InStr="^"+HospId+"^"+PapmiDr+"^"+AdmDr+"^"+HiType+"^"+DclaSouc;
	
	var psnNo=getValueById('psnNo');
	if(psnNo == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա��Ų���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+psnNo;                                       				 //��Ա���
	
	var telNo=getValueById('tel');
//	if(telNo == "")
//	{
//		$.messager.alert("��ܰ��ʾ","��ϵ�绰����Ϊ��!", 'info');
//		return ;
//	}
	InStr=InStr+"^"+telNo;                                             //��ϵ�绰
	
	var addr=getValueById('addr');
//	if(addr == "")
//	{
//		$.messager.alert("��ܰ��ʾ","��ϵ��ַ����Ϊ��!", 'info');
//		return ;
//	}
	InStr=InStr+"^"+addr;                                             //��ϵ��ַ
	
	var InsuAdmdvs=""  //�α�����ҽ������
	InStr=InStr+"^"+InsuAdmdvs;  
	
	var InsuType=getValueById('XZType');
//	if(InsuType == "")
//	{
//		$.messager.alert("��ܰ��ʾ","�������Ͳ���Ϊ��!", 'info');
//		return ;
//	}
	InStr=InStr+"^"+InsuType;                                           //��������                
	
	var bizAppyType=getValueById('bizAppyType');
	if(bizAppyType == "")
	{
		$.messager.alert("��ܰ��ʾ","ҵ���������Ͳ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+bizAppyType;                                       //ҵ����������
	
	var TrtDclaDetlSn="1"  //�����걨��ϸ��ˮ��(�ǼǷ���)
	InStr=InStr+"^"+TrtDclaDetlSn;  
	
	var ValiFlag="A"      //��Ч��־
	InStr=InStr+"^"+ValiFlag;   
	
	var fixSrtNo=getValueById('fixSrtNo');	
	if(fixSrtNo == "")
	{
		$.messager.alert("��ܰ��ʾ","��������Ų���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+fixSrtNo;                                        //���������
	var fixmedinsCode=getValueById('fixmedinsCode');                   //����ҽҩ�������
	var fixmedinsName=getValueById('fixmedinsName');                   //����ҽҩ��������
	
	if((fixmedinsCode == "") &&(reflinMedinsNo=="")) 
	{
		$.messager.alert("��ܰ��ʾ","������ҽҩ������š����ߡ�����ҽҩ�������ơ�����ͬʱΪ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+fixmedinsCode;                             
	InStr=InStr+"^"+fixmedinsName;
	
	var SDate=getValueById('SDate');	
	if(SDate == "")
	{
		$.messager.alert("��ܰ��ʾ","��ʼ���ڲ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+SDate;                                        	//��ʼ����
	
	var EDate=getValueById('EDate');	
//	if(EDate == "")
//	{
//		$.messager.alert("��ܰ��ʾ","�������ڲ���Ϊ��!", 'info');
//		return ;
//	}
	InStr=InStr+"^"+EDate;                                        	//��������
	
	var agnterName=getValueById('agnterName');	
//	if(agnterName == "")
//	{
//		$.messager.alert("��ܰ��ʾ","��������������Ϊ��!", 'info');
//		return ;
//	}
	InStr=InStr+"^"+agnterName;                                       //����������
	
	var agnterCertType=getValueById('agnterCertType');	
//	if(agnterCertType == "")
//	{
//		$.messager.alert("��ܰ��ʾ","������֤�����Ͳ���Ϊ��!", 'info');
//		return ;
//	}
	InStr=InStr+"^"+agnterCertType;                                   //������֤������
	
	var agnterCertNo=getValueById('agnterCertNo');	
//	if(agnterCertNo == "")
//	{
//		$.messager.alert("��ܰ��ʾ","������֤�����벻��Ϊ��!", 'info');
//		return ;
//	}
	InStr=InStr+"^"+agnterCertNo;                                    //������֤������
	
	var agnterTel=getValueById('agnterTel');	
//	if(agnterTel == "")
//	{
//		$.messager.alert("��ܰ��ʾ","��������ϵ��ʽ����Ϊ��!", 'info');
//		return ;
//	}
	InStr=InStr+"^"+agnterTel;                                      //��������ϵ��ʽ
	
	var agnterAddr=getValueById('agnterAddr');	
//	if(agnterAddr == "")
//	{
//		$.messager.alert("��ܰ��ʾ","��������ϵ��ַ����Ϊ��!", 'info');
//		return ;
//	}
	InStr=InStr+"^"+agnterAddr;                                      //��������ϵ��ַ
	
	var agnterRlts=getValueById('agnterRlts');	
//	if(agnterRlts == "")
//	{
//		$.messager.alert("��ܰ��ʾ","�����˹�ϵ����Ϊ��!", 'info');
//		return ;
//	}
	InStr=InStr+"^"+agnterRlts;                                      //�����˹�ϵ
	
	
	var memo=getValueById('memo');                                    //��ע
	InStr=InStr+"^"+memo;  
	
	var OpterId=""  //������
	var OptDate="" ;  //��������
	var OptTime="" ;  //����ʱ��
	InStr=InStr+"^"+OpterId+"^"+OptDate+"^"+OptTime; 
	
	var UpdtId=""  //������
	var UpdtDate=""  //��������
	var UpdtTime=""  //����ʱ��
	InStr=InStr+"^"+UpdtId+"^"+UpdtDate+"^"+UpdtTime;

	var PsnCertType=getValueById('PsnCertType');
	if(PsnCertType == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա֤�����Ͳ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+PsnCertType;                                       		//��Ա֤������
	
	var CertNo=getValueById('CertNo');
	if(CertNo == "")
	{
		$.messager.alert("��ܰ��ʾ","֤�����벻��Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+CertNo;                                       			//֤������
	
	var name=getValueById('name');
	if(name == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա��������Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+name;                                       				//��Ա����

	InStr=InStr+"^"+"";   //��չ����
	
	var ExpStr=getValueById('QInsuType')+"^";                                     //ҽ������^���ݿ����Ӵ�

	
	$m({
		ClassName:"INSU.MI.BL.PsnFixRegCtl",
		MethodName:"InsertPsnFixReg",
		InString:InStr,
		HospDr:GV.HospDr,
	},function(rtn){
		if(rtn.split("^")[0]<0){
			$.messager.alert('��ʾ',"������Ա���㱸����Ϣʧ�ܣ�"+rtn);
		}else{
			var PsnFixRegDr=rtn.split("^")[0]
			var rtnStr=INSUPsnFixReg(Handle,UserId,AdmDr,InStr,ExpStr,PsnFixRegDr)
			if (rtnStr!="0") 
			{
				$.messager.alert("��ʾ","��Ա���㱸���Ǽ�ʧ��!rtn="+rtnStr, 'error');
				return ;
			}else{
				$.messager.alert('��ʾ','��Ա���㱸���Ǽǳɹ�');
				return ;
			}
		}
	$.messager.progress("close");
	});
   
	
	// var rtn=INSUPsnFixReg(Handle,UserId,AdmDr,InStr,ExpStr)
	
	// if (rtn!="0") 
	//  {
	// 	$.messager.alert("��ʾ","��Ա���㱸���Ǽ�ʧ��!rtn="+rtn, 'error');
	// 	return ;
	// }else{
	// 	$.messager.alert('��ʾ','��Ա���㱸���Ǽǳɹ�');
	// 	return ;
	// }
	
	/*
	$m({
		ClassName:"INSU.MI.BL.PsnFixRegCtl",
		MethodName:"InsertPsnFixReg",
		InString:ExpStr,
		HospDr:GV.HospDr,
	},function(rtn){
		if(rtn.split("^")[0]<0){
			$.messager.alert('��ʾ',"��Ա���㱸���Ǽ�ʧ�ܣ�"+rtn);
		}else{
			   $.messager.alert('��ʾ','��Ա���㱸���Ǽǳɹ�');
			}
	  $.messager.progress("close");
	});
	*/                                    
}
	
			
/**
*��������
*/

function FixRegDes_Click()
{
	
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.TRowid != "") {
			
			$.messager.confirm('ȷ��', 'ȷ�ϳ���������¼��', function (r) {
				if (r) {
					var Handle=0,UserId=GV.USERID,AdmDr=selected.TAdmDr,PsnNo=selected.TPsnNo,HiType=getValueById('SearchInsuType');
//					if(AdmDr == "")
//					{
//						$.messager.alert("��ܰ��ʾ","��ѡ��һ��������¼", 'info');
//						return ;
//					}
					if(PsnNo == "")
					{
						$.messager.alert("��ܰ��ʾ","��ѡ��һ��������¼", 'info');
						return ;
					}
    				var ExpString=HiType+"^^"+"����Ҫ��"+"^" //��ʽ:^^����ԭ��^���ݿ����Ӵ�
					var rtn=INSUPsnFixRegDestory(Handle, UserId , AdmDr , PsnNo, ExpString); //DHCINSUPort.js
					if (rtn!="0") 
	 				{
						$.messager.alert("��ʾ","��Ա���㱸������ʧ��!rtn="+rtn, 'error');
						return ;
					}else{
						$.messager.alert("��ʾ","��Ա���㱸�������ɹ�!", 'info',function(){
							initLoadGrid();	
						});
					}
				}
			});
		}
	}
	else{
			$.messager.alert('��ʾ', "��ѡ��Ҫ�����ļ�¼", 'info');		
			return false;
		}
}

/**
*������ѯ
*/
function FixRegsearch_Click()
{
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.TRowid != "") {
			var Handle=0,UserId=GV.USERID
			var ExpString="" //��ʽ:^^^���ݿ����Ӵ�
			var rtn=InsuTransferHospQuery(Handle,UserId,selected.TRowid,ExpString); //DHCINSUPort.js
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


/**
*��ʼ������ҽҩ����
*/
function init_fixmedinsName(){
	
    var data={total:0,rows:[]};
	$('#fixmedinsName').combogrid({
    panelWidth:470,
    value:'006',
    idField:'fixmedins_code',
    textField:'fixmedins_name',
    delay: 600,
	mode: 'remote',
	method: 'GET',
	pagination: true,
    columns:[[
        {field:'fixmedins_code',title:'ҽҩ�������',width:160},
        {field:'fixmedins_name',title:'ҽҩ��������',width:310}
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
				  $("#fixmedinsName").combogrid("grid").datagrid({data:data});
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
					 $("#fixmedinsName").combogrid("grid").datagrid({data:newData});
			    }
			}else{
				$('#fixmedinsName').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
				return false; 
      		}
		},
		onSelect:function(index,row){
			setValueById('fixmedinsCode',row.fixmedins_code);
		}
});
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
		pageSize: 100,
		pageList: [100],
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
			var admReaStr = getAdmReasonInfo(row.admId);
			var admReaAry = admReaStr.split("^");
			var admReaId = admReaAry[0];
			var INSUType = GetInsuTypeCode(admReaId);
			$("#QInsuType").combobox('select', INSUType);
			GetInsuAdmInfo();                 //��ȡҽ��������Ϣ
			QryDiagLst();                     //���ؾ������	  
			       
		}
	});
}

/**
*��ʼ��������ϼ�¼
*/
function InitDiagLst()
{
	
	$('#DiagLst').combogrid({    
	    panelWidth:780, 
	    method:'GET',
	    idField:'DiagnosICDCode',  
	    textField:'DiagnosDesc' ,  
	    columns:[[    
	        {field:'DiagnosICDCode',title:'��ϱ���',width:100},   
	        {field:'DiagnosDesc',title:'�������',width:160}, 
	        {field:'DiagnosMRDesc',title:'���ע��',width:80},  
	         {field:'MainDiagFlag',title:'�����',width:60,align:'center',
	            formatter: function(value,row,index)
	                {
			              return  value=="Y" ? "��":"��" 
			        }
			   },    
	        {field:'DiagnosType',title:'�������',width:80,align:'center'},   
	        {field:'DiagStat',title:'���״̬',width:80,align:'center'},   
	        {field:'InsuDiagCode',title:'ҽ����ϱ���',width:110},  
	        {field:'InsuDiagDesc',title:'ҽ���������',width:150} 
	    ]] ,
		onClickRow:function(rowIndex, rowData)
		{
			  var DiagLstVal=rowData.DiagnosICDCode+"/"+rowData.DiagnosDesc+"/"+rowData.DiagnosMRDesc+"/"+rowData.DiagStat+"/"+rowData.InsuDiagCode+"/"+rowData.InsuDiagDesc;
		      $('#DiagLst').combogrid("setValue",DiagLstVal);
			  setValueById('diagCode',rowData.DiagnosICDCode);
			  setValueById('diagName',rowData.DiagnosDesc)
		}
       
  });  

}

/**
*��ѯ������ϼ�¼
*/
function QryDiagLst()

{   
	//alert("GV.ADMID="+GV.ADMID)
	
	if (!!GV.ADMID)
    {
	    //alert("GV.ADMID="+GV.ADMID)
	 	var tURL=$URL+"?ClassName="+'web.DHCINSUPortUse'+"&MethodName="+"GetPatAllDiagsByADM"+"&PAADM="+GV.ADMID+"&DiagType="+""+"&ExpStr=^^HUIToJson" 
	 	//alert(tURL)
     	$('#DiagLst').combogrid({url:tURL});
    }
}  

/**
*��ȡҽ��������Ϣ����
*/
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
		HisType:"I"
	}
	loadComboGridStore("AdmList", queryParams);
}

/**
* �ǼǺŻس��¼�
*/
function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		getPatInfo();
	}
}

/**
* ���ֳ�ʼ��

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

	var dgHeight = window.document.body.offsetHeight - 36 - 20 - 12 - 122; // // window - patbanner - padding(banner)10 - padding(panel)10*2 - ��ѯ���
	var height = dgHeight + 124 -135
	$('#dg').datagrid('options').height = dgHeight;
	$('#dg').datagrid('resize');
	$('#ReportPanel').panel('options').height = height;
	$('#ReportPanel').panel('resize');
	
}
*/

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
			// ����ҵ����������
			init_bizAppyType();
			// ������Ա֤������
			init_PsnCertType();
			// ���ش�����֤������ 
			init_agnterCertType();
			// ���ش����˹�ϵ
			init_agnterRlts();
		}	
	})
		
}

/*
 * ҵ���������� 
 */
function init_bizAppyType(){
	$HUI.combobox(('#bizAppyType'),{
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
			param.Type = 'biz_appy_type' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			
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

		}		
	});
	
}

/*
 * ������֤������ 
 */
function init_agnterCertType(){
	$HUI.combobox(('#agnterCertType'),{
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
			
		}		
	});
}

/*
 * �����˹�ϵ
 */
function init_agnterRlts(){
	$HUI.combobox(('#agnterRlts'),{
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
}

/*
 *��ѯ���ҽ������
 */
function init_SearchINSUType(){
var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('SearchInsuType','DLLType',Options); 
	$('#SearchInsuType').combobox({
		onSelect:function(){
			
			// ���ز�ѯ���֤������ 
			init_CertTypeSearch();
			// ���ز�ѯ���ҵ���������� 
			//init_bizAppyTypeSearch();
		},	
		
	})
}

/*
 * ��ѯ���֤������
 */
function init_CertTypeSearch(){
	$HUI.combobox(('#CertTypeSearch'),{
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

		}		
	});
	
}

/*
 * ��ѯ���ҵ���������� 
 
function init_bizAppyTypeSearch(){
	$HUI.combobox(('#bizAppyTypeSearch'),{
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
			param.Type = 'biz_appy_type' + getValueById('SearchInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			
		}		
	});
}

*/
/*
 * �������
*/ 
function init_XZType(){
	$HUI.combobox(('#XZType'),{
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
			
		}		
	});

}



/*
 * datagrid
 */
function init_dg() {
	// ��ʼ��DataGrid
	$('#dg').datagrid({
		border: false,
		fit:true,
		data:[],
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		frozenColumns:[[
			{field:'TBizAppyType',title:'ҵ����������',width:150},
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
				}
			}},	
			{field:'TPsnNo',title:'���˱��',width:120 },
			{field:'TPsnName',title:'��������',width:80 },
			{field:'TPsnCertType',title:'��Ա֤������',width:120},
			{field:'TCertNo',title:'֤������',width:180},
			{field:'TTel',title:'��ϵ�绰',width:100,hidden:true},
			{field:'TAddr',title:'��ϵ��ַ',width:150,hidden:true }
				
			]],
		columns:[[ 
			{field:'THiType',title:'ҽ������',width:100},
			{field:'TBegndate',title:'��ʼ����',width:100},
			{field:'TEnddate',title:'��������',width:100},
			{field:'TAgnterName',title:'����������',width:100 },
			{field:'TAgnterCertType',title:'������֤������',width:160 },
			{field:'TAgnterCertno',title:'������֤������',width:150 },
			{field:'TAgnterTel',title:'��������ϵ��ʽ',width:150 },
			{field:'TAgnterAddr',title:'��������ϵ��ַ',width:150 },
			{field:'TAgnterRlts',title:'�����˹�ϵ',width:150 },
			{field:'TFixSrtNo',title:'���������',width:150 },
			{field:'TFixmedinsCode',title:'����ҽҩ�������',width:150 },
			{field:'TFixmedinsName',title:'����ҽҩ��������',width:150 },
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
			{field:'TDclaSouc',hidden:true}, //�걨��Դ
			{field:'TInsuAdmdvs',hidden:true}, //�α�����ҽ������
			{field:'TInsutype',hidden:true} //��������
		]],
		toolbar: '#tToolBar',
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		}
	});
}


/*
 * ��������
 */
function initLoadGrid(){
		if(getValueById('SearchInsuType')==''){
		//$.messager.alert('��ʾ','ҽ�����Ͳ���Ϊ��','info');
		//return;	
	}
	var queryParams = {
		ClassName : 'INSU.MI.BL.PsnFixRegCtl',
		QueryName:'QueryPsnFixReg',
		StartDate : getValueById("StartDate"),
	    EndDate : getValueById("EndDate"),
	    HiType : getValueById("SearchInsuType"),
	    InsuNo : getValueById("SearchInsuNo"),
	    PsnName : getValueById("PsnNameSearch"),
	    PsnCertType : getValueById("CertTypeSearch"),
	    CertNo : getValueById("CertNoSearch"),
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
	var ExpString = getValueById('QInsuType') + '^' + GV.HospDr;
	var UserId = session['LOGON.USERID'];
	var str = InsuReadCard('0',UserId,InsuNo,CardType,ExpString);
	var TmpData = str.split("|");
	if (TmpData[0]!="0"){
		$.messager.alert('��ʾ', "����ʧ��" + str, 'error');	
		return;
	}else{
	 	var TmpData1 = TmpData[1].split("^")
	 	 
	 	setValueById('psnNo',TmpData1[0]);       	//���˱��
	 	setValueById('INSUCardNo',TmpData1[1]);  	//����
	 	setValueById('name',TmpData1[3]);        	//����
	 	//setValueById('Sex',TmpData1[4]);         	//�Ա�
	 	setValueById('InsuAdmdvs',TmpData1[21]);	//�α���������
	 	//setValueById('rylb',TmpData1[11]);     	//��Ա���	 
	 	setValueById('XZType',TmpData[3]);			//��������	
	 
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
		PatID: papmi
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
		//setValueById("IDCardNo", myAry[8]);
		
		
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
	clear();		
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
	//initLoadGrid();
	//
	$(".addInfo").form("clear");
	$('#QInsuType').combobox('reload');	
	$(".PatInfoItem").html('');
	//setValueById('SDate',getDefStDate(0));
	//setValueById('EDate',getDefStDate(1));
	InsuDateDefault('SDate',-1);	//upt HanZH 20210918	
	InsuDateDefault('EDate');
			
	//setValueById('RRefLtype',"");
	//$('#RRefLtype').combobox('reload');	
	//setValueById('StartDate',getDefStDate(0));
	//setValueById('EndDate',getDefStDate(1));
	InsuDateDefault('StartDate',-1);	//upt HanZH 20210918
	InsuDateDefault('EndDate');	
	ClearGrid('dg');
	//���combogrid��������������� addby LuJH 20230412
	$(".combogrid-f").combogrid("clear").combogrid("grid").datagrid("loadData", { 
		total: 0,
		rows: []
	});
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
	}
/*
*���dg��Ϣ
*HanZH 20230328
*/	
function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
}
