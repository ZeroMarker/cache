/*
 * FileName:	dhcinsu.insureferral.js
 * User:		DingSH
 * Date:		2020-12-23
 * Description: ҽ��תԺ(ת��)����
 */
 
 
 var GV = {
	UPDATEDATAID : '',
	HospDr:session['LOGON.HOSPID'] ,
	USERID:session['LOGON.USERID'] ,
	ADMID:'',
	PAPMI:'',
	INSUADMID : ''

}

 var TransactionNumber=2501;  //��˧����ȫ�ֱ���,���״��� 
 var ParentNodeCode="refmedin";//��˧����ȫ�ֱ���,���ڵ����
 var ParameterCode="dise_cond_dscr";//��˧����ȫ�ֱ���,��������
 var FromtText="" //��ȡ��Ĳ�������
 $(function () { 
 
  $(document).keydown(function(e){
	 	banBackSpace(e);
	 	});
 	window.onresize=function(){
    	location.reload();//ҳ�����ˢ��
 	} 
	// ҽ������
	init_INSUType();
	
	// ��ѯ���ҽ������
	init_SearchINSUType();
	
	// �������
	init_XZType();
	
	//תԺ���
	init_RefLtype();
	
	// HIS������
	initCardType();
	
	// ת��ҽԺ
	init_ReferHosp();
	
	// �����¼
	initAdmList();

    //������ϼ�¼
	InitDiagLst();
	
	//click�¼�
	init_Click();
	
	//keydown�¼�
	init_keyDown();
	
	//��ʼ��תԺ������¼	
	init_dg(); 
	
	//init_layout();
	
	//���ڳ�ʼ��	add hanzh 20210918
	init_Date();
	
	$('#HISCardType').combobox('disable',true);
	
	//��ϳ�ʼ��	add HanZH 20210918
	init_diag();
	
	//תԺ����
	init_RRefLtype();
	
	clear();
	
});

/**
*��ʼ��click�¼�
*/		
function init_Click()
{
	  //�����Ǽ�
	  $("#btnRefer").click(Refer_Click);
      //��������
      $("#btnReferDes").click(ReferDes_Click);  
       //������ѯ
      $("#btnsearch").click(Refersearch_Click);
      //תԺ������¼����   WangXQ 20220627
      $("#btnexport").click(Referexport_Click);
}
	
/**
*�����Ǽ�
*/	
function Refer_Click()
{
	var Handle=0,UserId=GV.USERID,AdmDr=GV.ADMID;
	


//st	upt HanZH 20210918
//	if(AdmDr == "")
//	{
//		$.messager.alert("��ܰ��ʾ","��ѡ��һ�������¼", 'info');
//		return ;
//	}
//ed
	var ExpStr=""                                                        //��ʽ����ϵ�绰^��ַ^ҽԺͬ��תԺ��־^תԺ����^תԺ����^תԺԭ��^תԺ���^��ʼ����^��������^����^ת��ҽԺ����ģ������^ת��ҽԺ����^��������^���ݿ����Ӵ�
	
	var telNo=getValueById('tel');
	if(telNo == "")
	{
		$.messager.alert("��ܰ��ʾ","��ϵ�绰����Ϊ��!", 'info');
		return ;
	}
	ExpStr=telNo;                                                       //��ϵ�绰
	
	var addr=getValueById('addr');
	if(addr == "")
	{
		$.messager.alert("��ܰ��ʾ","��ϵ��ַ����Ϊ��!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+addr;                                             //��ϵ��ַ
	
	var hospAgreReflFlag=getValueById('hospAgreReflFlag');
	if(hospAgreReflFlag == "")
	{
		$.messager.alert("��ܰ��ʾ","ҽԺ�������Ϊ��!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+hospAgreReflFlag;                                 //ҽԺ���
	
	var refLtype=getValueById('refLtype');
	if(refLtype == "")
	{
		$.messager.alert("��ܰ��ʾ","ת�����Ͳ���Ϊ��!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+refLtype;                                        //ת������
	
	//var reflDate=GetInsuDateFormat(getValueById('reflDate'));
	var reflDate=getValueById('reflDate');	//upt HanZH 20210918
	
	if(reflDate == "")
	{
		$.messager.alert("��ܰ��ʾ","תԺ���ڲ���Ϊ��!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+reflDate;                                        //תԺ����
	
	//var reflRea=GetInsuDateFormat(getValueById('reflRea'));
	var reflRea=getValueById('reflRea');	//upt HanZH 20210918
	if(reflRea == "")
	{
		$.messager.alert("��ܰ��ʾ","תԺԭ����Ϊ��!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+reflRea;                                        //תԺԭ��
	
	var reflOpnn=getValueById('reflOpnn');
	if(reflOpnn == "")
	{
		$.messager.alert("��ܰ��ʾ","תԺ�������Ϊ��!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+reflOpnn;                                      //תԺ���
	
	//var SDate=GetInsuDateFormat(getValueById('SDate'));
	var SDate=getValueById('SDate');	//upt HanZH 20210918
	if(SDate == "")
	{
		$.messager.alert("��ܰ��ʾ","��ʼ���ڲ���Ϊ��!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+SDate;                                        //��ʼ����
	
	//var EDate=GetInsuDateFormat(getValueById('EDate'));
	var EDate=getValueById('EDate');	//upt HanZH 20210918
	if(EDate == "")
	{
		$.messager.alert("��ܰ��ʾ","�������ڲ���Ϊ��!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+EDate;                                        //��������
	
	var fixmedinsType=1;
	ExpStr=ExpStr+"^"+fixmedinsType;                                //�����������:ҽԺ��ҩ�� 
	
	var reflinMedinsName=getValueById('reflinMedinsName');          //ת��ҽԺ
	var reflinMedinsNo=getValueById('reflinMedinsNo');              //ת��ҽԺ����
	
	
	if((reflinMedinsName == "") &&(reflinMedinsNo=="")) 
	{
		$.messager.alert("��ܰ��ʾ","��ת��ҽԺ�����ߡ�ת��ҽԺ���롿����ͬʱΪ��!", 'info');
		return ;
	}
	
	
	ExpStr=ExpStr+"^"+reflinMedinsName;                             
	
	
	
	ExpStr=ExpStr+"^"+reflinMedinsNo;   
	
	var diseCondDscr=getValueById('diseCondDscr');
	if(diseCondDscr == "")
	{
		$.messager.alert("��ܰ��ʾ","������������Ϊ��!", 'info');
		return ;
	}
	
	FromtLength()                //���Ʋ����������ȣ�2022/10/15��˧1010

	ExpStr=ExpStr+"^"+FromtText;                                //��������
	
	var connURL=""
	ExpStr=ExpStr+"^"+connURL;                                     //���ݿ����Ӵ�
	
	var psnNo=getValueById('psnNo');
	if(psnNo == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա��Ų���Ϊ��!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+psnNo;                                       //��Ա���
	
	var insuOptins=getValueById('insuOptins');
	if(insuOptins == "")
	{
		$.messager.alert("��ܰ��ʾ","�α��ز���Ϊ��!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+insuOptins;                                   //ͳ�������
	
	
	var XZType=getValueById('XZType');
	if(XZType == "")
	{
		$.messager.alert("��ܰ��ʾ","�������Ͳ���Ϊ��!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+XZType;                                       //��������
	
	var diagCode=getValueById('diagCode');
	if(diagCode == "")
	{
		$.messager.alert("��ܰ��ʾ","��ϴ��벻��Ϊ��!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+diagCode;                                      //��ϴ���
	
	var diagName=getValueById('diagName');
	if(diagName == "")
	{
		$.messager.alert("��ܰ��ʾ","������Ʋ���Ϊ��!", 'info');
		return ;
	}
	ExpStr=ExpStr+"^"+diagName;                                       //�������
	
	var mdtrtareaAdmdvs=getValueById('mdtrtareaAdmdvs');
	if(mdtrtareaAdmdvs == "")
	{
		mdtrtareaAdmdvs="000000"
	}
	ExpStr=ExpStr+"^"+mdtrtareaAdmdvs;                                       //��ҽ��
	
	//alert(diagName)
	//return ;
	//��ϵ�绰^��ַ^ҽԺͬ��תԺ��־^תԺ����^תԺ����^תԺԭ��^תԺ���^��ʼ����^��������^����^
	//ת��ҽԺ����ģ������^ת��ҽԺ����^��������^���ݿ����Ӵ�^���˱��^ͳ������^��������^��ϴ���^������� 
	
	var rtn=INSUTransferHosApprove( Handle,UserId,AdmDr,getValueById('QInsuType'),ExpStr ); //DHCINSUPort.js
	if (rtn!="0") 
	 {
		$.messager.alert("��ʾ","תԺ�����Ǽ�ʧ��!rtn="+rtn, 'error');
		return ;
	}
	
	$.messager.alert("��ʾ","תԺ�����Ǽǳɹ�!", 'info');
}
			
/**
*��������
*/

function ReferDes_Click()
{
	
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.TRowid != "") {
			
			$.messager.confirm('ȷ��', 'ȷ�ϳ���������¼��', function (r) {
				if (r) {
					var Handle=0,UserId=GV.USERID,AdmDr=selected.TAdmDr
					if(AdmDr == "")
					{
						$.messager.alert("��ܰ��ʾ","��ѡ��һ�������¼", 'info');
						return ;
					}
    
    				var ExpString="^^��Ҫ���±���" //��ʽ:^^^���ݿ����Ӵ�
					var rtn=INSUTransferHosApproveDestory(Handle, UserId , AdmDr ,getValueById('QInsuType'), ExpString); //DHCINSUPort.js
					if (rtn!="0") 
	 				{
						$.messager.alert("��ʾ","ת�ﱸ������ʧ��!rtn="+rtn, 'error');
						return ;
					}else{
						$.messager.alert("��ʾ","ת�ﱸ�������ɹ�!", 'info',function(){
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
function Refersearch_Click()
{
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.TRowid != "") {
			var Handle=0,UserId=GV.USERID
			var ExpString="" //��ʽ:^^^���ݿ����Ӵ�
			var rtn=InsuTransferHospQuery(Handle,UserId,selected.TRowid,getValueById('QInsuType'),ExpString); //DHCINSUPort.js
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
*��ʼ��keydown
*/
function init_keyDown()
{
	
	
	//���Żس���ѯ�¼�
	$("#HISCardNo").keydown(function (e) {
		cardNoKeydown(e);
	});
	//�ǼǺŻس���ѯ�¼�
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	//������Żس���ѯ�¼�
	$("#SearchRPTNo").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			initLoadGrid();
		}
	});
	//��Ա��Żس���ѯ�¼�
	$("#SearchPatNo").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			initLoadGrid();
		}
	});
}

/**
*��ʼ��ת��Ժ��
*/
function init_ReferHosp(){
	
    var data={total:0,rows:[]};
	$('#reflinMedinsName').combogrid({
    panelWidth:450,
    value:'006',
    idField:'fixmedins_code',
    textField:'fixmedins_name',
    delay: 600,
	mode: 'remote',
	method: 'GET',
	pagination: true,
    columns:[[
        {field:'fixmedins_code',title:'ҽԺ����',width:160},
        {field:'fixmedins_name',title:'ҽԺ����',width:270}
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
				  ///$("#reflinMedinsName").combogrid("grid").datagrid({data:data});   //��Щ����Ŀ�ᵼ�� ������ѭ�� 
				   $("#reflinMedinsName").combogrid("grid").datagrid("loadData",data);  //DingSH 20220322 
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
					   $("#reflinMedinsName").combogrid("grid").datagrid("loadData",newData);
					 //return false;
			    }
			}else{
				$('#reflinMedinsName').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
				return false; 
      		}
		},
		onSelect:function(index,row){
			setValueById('reflinMedinsNo',row.fixmedins_code);
		}
});
	
	

}



function ReferHosp(){
	
	
	$("#reflinMedinsName").lookup("grid").datagrid({data:data})
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
			GetInsuAdmInfo();
		 	QryDiagLst();                     //���ؾ������	
		 	GetReferDiseCondDscr();           //��ȡ��������          
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

	//var dgHeight = window.document.body.offsetHeight - 36 - 20 - 12 - 100; // // window - patbanner - padding(banner)10 - padding(panel)10*2 - ��ѯ���
	//var height = dgHeight + 124 -135
	//$('#dg').datagrid('options').height = dgHeight;
	//$('#dg').datagrid('resize');
	//$('#ReportPanel').panel('options').height = height;
	//$('#ReportPanel').panel('resize');
	
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
			$('#XZType').combobox('clear');
			$('#refLtype').combobox('clear');
			setValueById('reflinMedinsNo',"");
 
			$('#XZType').combobox('reload');
			$('#refLtype').combobox('reload');
		  
		    //diagName
		    //diagCode
		    //$('#reflinMedinsName').lookup('clear');
		    // ���ؾ���ƾ֤����
			init_CertType();
			// �����Ա�
			init_Sex();
			// ����ҽԺͬ��תԺ��־
			init_hospAgreReflFlag();
			
			
		}	
	})	
	
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

function init_SearchINSUType(){
var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('SearchInsuType','DLLType',Options); 
	$('#SearchInsuType').combobox({
		onSelect:function(){
			$('#Rptlb').combobox('clear');
			$('#Rptlb').combobox('reload');
			init_RefLtype();
			init_RRefLtype();
		}	
	})
}
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
 * ת������
 */
function init_RefLtype(){
	$HUI.combobox(('#refLtype'),{
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
			param.Type = 'refl_type' + getValueById('QInsuType');
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
	var dgColumns = [[
			{field:'TTurnType',title:'ת������',width:75},
			{field:'TActiveFlag',title:'��Ч��־',width:80,styler:function(val, index, rowData){
				switch (val){
					case "������":
						return "background:red";
						break;
					case "��Ч":
						return "background:green";
						break;
					case "����":
						return "background:yellow";
						break;			
				}
			}},	
			{field:'TMemberNo',title:'���˱��',width:120 },
			{field:'TName',title:'��������',width:80 },
			{field:'TIdcardNo',title:'���֤��',width:120},
			{field:'TIcdCode',title:'��������',width:120 },
			{field:'TIcdName',title:'��������',width:150},
			{field:'TTurnCode',title:'������',width:150},
			{field:'TToHospCode',title:'ת��ҽԺ����',width:120},
			{field:'TToHospName',title:'ת��ҽԺ����',width:150 },
			{field:'TDemo1',title:'��ϵ�绰',width:100,hidden:true},
			{field:'TDemo2',title:'��ϵ��ַ',width:150,hidden:true },
			{field:'TInsuType',title:'ҽ������',width:75},
			{field:'TurnDate',title:'תԺ����',width:100},
			{field:'TDemo6',title:'��ʼ����',width:100},
			{field:'TDemo7',title:'��������',width:100},
			{field:'TDemo3',title:'ҽԺ���',width:150 },
			{field:'TDemo4',title:'תԺԭ��',width:150 },
			{field:'TDemo5',title:'תԺ���',width:150},
			{field:'TDemo8',title:'��������',width:150 },
			{field:'TUserDr',title:'������',width:150 },
			{field:'TiDate',title:'��������',width:100},
		    {field:'TAdmDr',hidden:true},
		    {field:'TInsuAdmInfoDr',hidden:true},
			{field:'TRowid',hidden:true}
		]];

	// ��ʼ��DataGrid
	$('#dg').datagrid({
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
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
	var ExpStr = getValueById('SearchTurnCode') + '|' + getValueById('SearchInsuNo') + '|' + getValueById('SearchName')  + '|' + getValueById('SearchId')  ;
    var queryParams = {

	    ClassName : 'web.DHCINSUReferralInfoCtl',
	    QueryName : 'QueryReferInfo',
	    ReferType : getValueById('RRefLtype'),
	    StartDate : getValueById('StartDate'),
	    EndDate : getValueById('EndDate'),
	    HospId: GV.HospDr,
	    ParamINSUType: getValueById('SearchInsuType'),
	    ExpStr:ExpStr
	    
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
 * readcard
 */
$('#btn-readINSUCard').bind('click', function () {
	if(getValueById('QInsuType')==''){
		$.messager.alert('��ʾ', "ҽ�����Ͳ���Ϊ��" + str, 'error');	
		return;	
	}
	var CardType="1",InsuNo="";
	CardType=getValueById('certtype');	
	var ExpString = getValueById('QInsuType') + '^' + GV.HospDr;
	var UserId = session['LOGON.USERID'];
	var str = InsuReadCard('0',UserId,InsuNo,CardType,ExpString);
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
	 	setValueById('insuOptins',TmpData1[21]); //�α���������
	 	//setValueById('rylb',TmpData1[11]);     //��Ա���	 
	 	setValueById('XZType',TmpData[3]);       //��������	
	 
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
/**
* ��ʼ��������
*/
function initCardType() {
	$HUI.combobox("#HISCardType", {
		url: $URL + "?ClassName=web.INSUReport&QueryName=QCardTypeDefineList&ResultSetType=array",
		editable: false,
		valueField: "myTypeID",
		textField: "caption",
		onChange: function (newValue, oldValue) {
		},
		onLoadSuccess:function(){
			setValueById('HISCardType','');	
		}
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
	readHFMagCardClick();	
	//readInsuCardClick();	
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
	$('#RRefLtype').combobox('reload');	
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
*���ݾ�������ȡ������Ϣ
*DingSH 20210105
*/
function GetReferDiseCondDscr()
{
	if (!!GV.ADMID) {
		$.m({
			ClassName: "web.DHCINSUReferralInfoCtl",
			MethodName: "GetReferDiseCondDscr",
			AdmDr: GV.ADMID
		}, function(rtn) {
			setValueById("diseCondDscr", rtn);
		});
	}
}
/*
*��ʼ�����ڸ�ʽ
*HanZH 20210918
*/
function init_Date(){
	InsuDateDefault('reflDate');
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
// �������	add HanZH 20210918
function init_diag(){
		$HUI.combobox(('#diagName'),{
		defaultFilter:'4',
		valueField: 'code',
		textField: 'desc',
		url:$URL,
		mode:'remote',
		onBeforeLoad:function(param){
			if(param.q==''){
				return true;	
			}
			param.ClassName = 'web.DHCMRDiagnos';
			param.QueryName= 'LookUpWithAlias';
			param.desc = param.q;
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		},
		onSelect:function(index,rowData){ 
			setValueById('diagCode',index.code);
		}		
	});
}
/*
 * ҽԺͬ��תԺ��־
 */
function init_hospAgreReflFlag(){
	$HUI.combobox(('#hospAgreReflFlag'),{
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
			param.Type = 'hosp_agre_refl_flag' + getValueById('QInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	});
	
}

//תԺ������¼��¼���� WangXQ  20220627
function Referexport_Click()
{
	try
   {
	 var ExpStr = getValueById('SearchTurnCode') + '|' + getValueById('SearchInsuNo') + '|' + getValueById('SearchName')  + '|' + getValueById('SearchId')  ;
$.messager.progress({
         title: "��ʾ",
		 msg: '���ڵ�����¼',
		 text: '������....'
		   });

$cm({
	ResultSetType:"ExcelPlugin",  
	ExcelName:"תԺ������¼",		  
	PageName:"QueryReferInfo",     
	ClassName:"web.DHCINSUReferralInfoCtl",
	QueryName:"QueryReferInfo",
    ReferType : getValueById('RRefLtype'),
	StartDate : getValueById('StartDate'),
	EndDate : getValueById('EndDate'),
	HospId: GV.HospDr,
	ParamINSUType: getValueById('SearchInsuType'),
	ExpStr:ExpStr
},
function(){

	  setTimeout('$.messager.progress("close");', 3 * 1000);	
});
   
   } catch(e) {
	   $.messager.alert("����",e.message);
	   $.messager.progress('close');
   };	
}

/*
 * תԺ����
 */
function init_RRefLtype(){
	$HUI.combobox(('#RRefLtype'),{
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
			param.Type = 'refl_type' + getValueById('SearchInsuType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){
			
		}		
	});
}

//���Ʋ����������ȣ�2022/10/15��˧1010
function FromtLength()
{
	
	var text=getValueById('diseCondDscr');
	
   FromtText=GetParameterLength(TransactionNumber,ParentNodeCode,ParameterCode,GV.HospDr,text);
	
	
	
	}

/*
*���dg��Ϣ
*HanZH 20230328
*/	
function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
}
