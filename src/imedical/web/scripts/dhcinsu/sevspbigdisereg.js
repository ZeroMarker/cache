/*
 * FileName:	sevspbigdisereg.js
 * User:		HanZH
 * Date:		2023-04-20
 * Function:	��Ա���ش󼲲�����
 */
 
 var GV = {
	UPDATEDATAID : '',
	HospDr:session['LOGON.HOSPID'] ,
	USERID:session['LOGON.USERID'] ,
	ADMID:'',
	PAPMI:'',
	INSUADMID : ''

}
	
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
	
	// HIS������
	initCardType();
	
	// �����¼
	initAdmList();

    //������ϼ�¼
	InitDiagLst();
	
	// ����ҽԺ
	init_FixmedHosp();
	
	//click�¼�
	init_Click();
	
	//keydown�¼�
	init_keyDown();
	
	//��ʼ��תԺ������¼	
	init_dg(); 
	
	init_layout();
	
	//���ڳ�ʼ��
	//init_Date();
	
	//���Żس���ѯ�¼�
	$("#HISCardNo").keydown(function (e) {
		cardNoKeydown(e);
	});
	
	$("#HISCardType").combobox('disable',true);
	
	
	// �������		add HanZH 20230420
	$HUI.combobox(('#BydiseSetlDiseName'),{
		defaultFilter:'3',
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
			setValueById('BydiseSetlListCode',index.code);
		}		
	})
	// ������������		add HanZH 20230420
	$("#OprnOprtName").combogrid({
		panelWidth: 420,
		validType: ['checkInsuInfo'],
		delay: 300,
		mode: 'remote',
		method: 'GET',
		fitColumns: true,
		pagination: true,
		idField: 'OprnOprtCode',
		textField: 'OprnOprtName',
		data: [],
		columns: [
			[{field: 'Rowid', title: 'Rowid', hidden: true},
			 {field: 'OprnOprtCode', title: '������������', width: 120},
			 {field: 'OprnOprtName', title: '������������', width: 230}]
		],
		onBeforeLoad: function(param) {
			if (typeof param.q == "undefined"){
				return false;
				}
			if (getValueById("QInsuType") && ($.trim(param.q).length >= 1)) {
				$("#OprnOprtName").combogrid("grid").datagrid("options").url = $URL;
				param.ClassName = "web.DHCINSUIPReg";
				param.QueryName = "QueryOPRNOPRTLISTNEW";
				param.QryType="";
				param.StDate="";
				param.EndDate="";
				param.Code="";
				param.Desc = param.q;
				param.HospId=GV.HospDr;
				param.HiType = getValueById("QInsuType");
				param.StDate="";
				param.EndDate="";
				param.Code="";
				param.HisBatch="";
				param.Ver=""
			}else{
				$('#OprnOprtName').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
				return false;
				 
				}
		},
		onSelect: function(rowIndex, rowData) {
			setValueById("OprnOprtCode", rowData.OprnOprtCode);
		},
		onChange: function(newValue, oldValue) {
			if (!newValue) {
				setValueById("OprnOprtCode", "");
			}
		}
	});
	clear();
});

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
/**
*��ʼ��click�¼�
*/		
function init_Click()
{
	  //�����Ǽ�
	  $("#btnRefer").click(SevSpBigDiseReg_Click);
      //��������
      $("#btnReferDes").click(SevSpBigDiseRegDes_Click);  
       //������ѯ
      $("#btnsearch").click(SevSpBigDiseRegsearch_Click); 
}
	
/**
*�����Ǽ�
*/	
function SevSpBigDiseReg_Click()
{
	var Handle=0
	var InStr=""   
	InStr=InStr+"^"+GV.HospDr;                                       		//##ҽԺID
	InStr=InStr+"^"+GV.PAPMI;                                       		//##������Ϣ��Dr
	InStr=InStr+"^"+GV.ADMID;                                       			//##����Dr
	                                                     
	//��ʽ��ҽ������^��Ա���^��Ա֤������^֤������^��Ա����^����^�Ա�^��������^�¼�����^�걨��Դ^�����ֽ��㲡��Ŀ¼����^�����ֽ��㲡������^����5-16
	//������������^������������^����ҽҩ�������^����ҽҩ��������^ҽԺ����^�������ҽ������^��ʼ����^��������^����17-24
	//��ϵ�绰^��ϵ��ַ^�¼���ˮ��^��������ʵ��ID^���������ʵ��ID^�¼�ʵ��ID^�����걨��ϸ��ˮ��^��������^��Ч��־^����25-34
	//��λ���^��λ����^��Ա���^��Ա�α���ϵID^�α�����ҽ������^��������^��������^����35-41
	//����������^������֤������^������֤������^��������ϵ��ʽ^��������ϵ��ַ^�����˹�ϵ^��ע^�ֶ���չ^����42-49
	//ȡ��ָ��^������Id^��������^����ʱ��^������Id^��������^����ʱ��^ȡ��ָ�롭��50-56
	//^���ݿ����Ӵ�
	var QInsuType=getValueById('QInsuType');
	if(QInsuType == "")
	{
		$.messager.alert("��ܰ��ʾ","//ҽ�����Ͳ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+QInsuType;                                       		//ҽ������
	
	var PsnNo=getValueById('PsnNo');
	if(PsnNo == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա��Ų���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+PsnNo;                                       			//��Ա���
	InStr=InStr+"^"+"";                                       				//��Ա֤������
	InStr=InStr+"^"+"";                                       				//֤������
	InStr=InStr+"^"+"";                                       				//��Ա����
	InStr=InStr+"^"+"";                                       				//����
	InStr=InStr+"^"+"";                                       				//�Ա�
	InStr=InStr+"^"+"";                                       				//��������
	var EvtType=getValueById('EvtType');
	InStr=InStr+"^"+EvtType;												//�¼�����
	var Dclasouc=getValueById('Dclasouc');
	InStr=InStr+"^"+Dclasouc;												//�걨��Դ
	
	var BydiseSetlListCode=getValueById('BydiseSetlListCode');
	if(BydiseSetlListCode == "")
	{
		$.messager.alert("��ܰ��ʾ","�����ֽ��㲡��Ŀ¼���벻��Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+BydiseSetlListCode;										//�����ֽ��㲡��Ŀ¼����
	
	var BydiseSetlDiseName=getValueById('BydiseSetlDiseName');
	InStr=InStr+"^"+BydiseSetlDiseName;										//�����ֽ��㲡������
	var OprnOprtCode=getValueById('OprnOprtCode');
	InStr=InStr+"^"+OprnOprtCode;											//������������
	var OprnOprtName=getValueById('OprnOprtName');
	InStr=InStr+"^"+OprnOprtName;											//������������
	// var FixmedinsCode=getValueById('FixmedinsCode');
	// if(FixmedinsCode == "")
	// {
	// 	$.messager.alert("��ܰ��ʾ","����ҽҩ��������Ϊ��!", 'info');
	// 	return ;
	// } 
	FixmedinsCode=tkMakeServerCall("web.INSUDicDataCom","GetDicByCodeAndInd","HISPROPerty"+QInsuType,"InsuHospCode",4,GV.HospDr)
	InStr=InStr+"^"+FixmedinsCode;											//����ҽҩ�������
	//var FixmedinsName=getValueById('FixmedinsName');
	InStr=InStr+"^"+"";														//����ҽҩ��������
	InStr=InStr+"^"+"";														//ҽԺ����
	InStr=InStr+"^"+"";														//�������ҽ������
	var SDate=getValueById('SDate');
	if(SDate == "")
	{
		$.messager.alert("��ܰ��ʾ","��ʼ���ڲ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+SDate;                                        			//��ʼ����
	var EDate=getValueById('EDate');
	InStr=InStr+"^"+EDate;                                        			//��������
	InStr=InStr+"^"+"";                                  					//��ϵ�绰
	InStr=InStr+"^"+"";                                 					//��ϵ��ַ
	InStr=InStr+"^"+"";                                 					//�¼���ˮ��
	InStr=InStr+"^"+"";                                 					//��������ʵ��ID
	InStr=InStr+"^"+"";                                 					//���������ʵ��ID
	InStr=InStr+"^"+"";                                 					//�¼�ʵ��ID
	InStr=InStr+"^"+"";                                 					//�����걨��ϸ��ˮ��
	InStr=InStr+"^"+"";                                 					//��������
	InStr=InStr+"^"+"D";                                 					//��Ч��־
	InStr=InStr+"^"+"0";                                 					//���״̬
	InStr=InStr+"^"+"";                                						//��λ���
	InStr=InStr+"^"+"";                                						//��λ����
	InStr=InStr+"^"+"";                                						//��Ա���
	InStr=InStr+"^"+"";                                						//��Ա�α���ϵID
	InStr=InStr+"^"+"";                                						//�α�����ҽ������
	var AppyDate=getValueById('AppyDate');
	InStr=InStr+"^"+AppyDate;                                               //��������
	var AppyRea=getValueById('AppyRea');
	InStr=InStr+"^"+AppyRea;                                               	//��������
	InStr=InStr+"^"+getValueById('AgnterName');                           	//����������
	InStr=InStr+"^"+getValueById('AgnterCertType');                       	//������֤������
	InStr=InStr+"^"+getValueById('AgnterCertno');                         	//������֤������
	InStr=InStr+"^"+getValueById('AgnterTel');                            	//��������ϵ��ʽ
	InStr=InStr+"^"+getValueById('AgnterAddr');                           	//��������ϵ��ַ
	InStr=InStr+"^"+getValueById('AgnterRlts');                           	//�����˹�ϵ
	InStr=InStr+"^"+getValueById('Memo');                              		//��ע
	InStr=InStr+"^"+getValueById('ExpContent');                             //�ֶ���չ
	InStr=InStr+"^^^"+GV.USERID+"^^^"+GV.USERID+"^^^^^^";
	
	$m({
		ClassName:"INSU.MI.BL.SevSpBigDiseRegCtl",
		MethodName:"InsertSevSpBigDiseReg",
		InString:InStr,
	},function(Rtn){
		if(Rtn.split("!")[0]<0){
			$.messager.alert('��ʾ',"��Ա���ش󼲲��������ݱ���ʧ�ܣ�"+Rtn);
		}else{
			var ExpStr=getValueById('QInsuType')+"^";
			var SevSpBigDiseRegDr=Rtn
			var rtn=INSUSevSpBigDiseReg(Handle,GV.USERID,GV.ADMID,SevSpBigDiseRegDr,ExpStr); //DHCINSUPort.js
			
			if (rtn!="0") 
			{
				$.messager.alert("��ʾ","��Ա���ش󼲲������Ǽ�ʧ��!Rtn="+Rtn, 'error');
				return ;
			}else{
				$.messager.alert('��ʾ','��Ա���ش󼲲������Ǽǳɹ�');
				return ;
			}
		}
	  $.messager.progress("close");
	});
}
			
/**
*��������
*/

function SevSpBigDiseRegDes_Click()
{
	
	var selected = $('#dg').datagrid('getSelected');
	if (selected.TValiFlag!="��Ч"){
		$.messager.alert("��ʾ","������Ч�ı�����¼���ɳ���!", 'error');
		return 
	}
	// if (selected.TRchkFlag!="���ͨ��"){
	// 	$.messager.alert("��ʾ","�������ͨ���ı�����¼���賷��!", 'error');
	// 	return 
	// }
	if (selected) {
		if (selected.TRowid != "") {
			$.messager.confirm('ȷ��', 'ȷ�ϳ���������¼��', function (r) {
				if (r) {
					var Handle=0,UserId=GV.USERID,AdmDr=selected.TAdmDr
    				var ExpString=getValueById('SearchInsuType')+"^"+selected.TRowid+"^" //��ʽ:ҽ������^���ش󼲲��ǼǱ�Rowid^���ݿ����Ӵ�
					var rtn=INSUSevSpBigDiseRegDestory(Handle, UserId,AdmDr,selected.TPsnNo,ExpString); //DHCINSUPort.js
					if (rtn!="0") 
	 				{
						$.messager.alert("��ʾ","��Ա���ش󼲲���������ʧ��!rtn="+rtn, 'error');
						return ;
					}else{
						$.messager.alert("��ʾ","��Ա���ش󼲲����������ɹ�!", 'info',function(){
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
function SevSpBigDiseRegsearch_Click()
{
	var selected = $('#dg').datagrid('getSelected');
	if (selected) {
		if (selected.TRowid != "") {
			var Handle=0,UserId=GV.USERID
			var ExpString="" //��ʽ:^^^���ݿ����Ӵ�
			var rtn=INSUSevSpBigDiseRegQuery(Handle,UserId,selected.TRowid,selected.THiType,ExpString); //DHCINSUPort.js
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
	
	//���߲�ѯ
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
	//�����س���ѯ�¼�
	$("#SearchName").keydown(function (e) {
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
}

/**
*��ʼ������ҽԺ
*/
function init_FixmedHosp(){
	
    var data={total:0,rows:[]};
	$('#FixmedinsName').combogrid({
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
				  ///$("#FixmedinsName").combogrid("grid").datagrid({data:data});   //��Щ����Ŀ�ᵼ�� ������ѭ�� 
				   $("#FixmedinsName").combogrid("grid").datagrid("loadData",data);  //DingSH 20220322 
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
					 $("#FixmedinsName").combogrid("grid").datagrid({data:newData});
			    }
			}else{
				$('#FixmedinsName').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
				return false; 
      		}
		},
		onSelect:function(index,row){
			setValueById('FixmedinsCode',row.fixmedins_code);
			setValueById('HospLv',row.hosp_lv);
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
			refreshBar('',row.admId);
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
	         {field:'MainDiagFlag',title:'�����',width:60,
	            formatter: function(value,row,index)
	                {
			              return  value=="Y" ? "��":"��" 
			        }
			   },    
	        {field:'DiagnosType',title:'�������',width:80},   
	        {field:'DiagStat',title:'���״̬',width:80},   
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
	GV.PAPMI=myPapmiId;
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
*/
function init_layout(){	
	// east-panel
	var bodyWidth = +$('body div:first').css('width').split('px')[0];
	var westWidth = '900';
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
	var height = dgHeight + 124 -135;
	$('#dg').datagrid('options').height = dgHeight;
	$('#dg').datagrid('resize');
	$('#ReportPanel').panel('options').height = height;
	$('#ReportPanel').panel('resize');
	
}
/*
 * ҽ������ ��ҽ�������йص� ��������Ҫ�������¼���
 */
function init_INSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('QInsuType','DLLType',Options); 	//scripts/dhcinsu/common/dhcinsu.common.js	
	$('#QInsuType').combobox({
		onSelect:function(){
			// �����걨��Դ
			init_Dclasouc();
			// ���ش�����֤������
			init_AgnterCertType();
			// ���ش����˹�ϵ
			init_AgnterRlts();
			// �����¼�����
			init_EvtType();
		}	
	})	
	
}

function init_SearchINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('SearchInsuType','DLLType',Options); 
	$('#SearchInsuType').combobox({
		onSelect:function(){
			//init_SearchType();
		}	
	})
}

/*
 * ��ʼ��DataGrid
 */
function init_dg() {
	grid=$('#dg').datagrid({
		border: false,
		fit:true,
		striped:true,
		singleSelect: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data: [],
		border:false,
		autoSizeColumn:false,
		cache:true,
		pagination:true,
		rownumbers: false,
		toolbar: '#tToolBar',
		frozenColumns:[[
			{field:'TRowid',title:'�Ǽ�ID',width:60 },
			{field:'TValiFlag',title:'��Ч��־',width:65,styler:function(val, index, rowData){
				switch (val){
					case "δ����":
						return "color:blue";
						break;
					case "������":
						return "color:red";
						break;
					case "��Ч":
						return "color:green";
						break;
					case "����":
						return "color:red";
						break;			
				}
			}},
			{field:'TRchkFlag',title:'���״̬',width:70,styler:function(val, index, rowData){
				switch (val){
					case "δ���":
						return "color:blue";
						break;
					case "���ͨ��":
						return "color:green";
						break;
					case "��˲�ͨ��":
						return "color:red";
						break;
					case "�ѳ���":
						return "color:red";
						break;			
				}
			}},
			{field:'TPsnName',title:'��Ա����',width:80},
			{field:'TPsnCertType',title:'��Ա֤������',width:120,hidden:true},
			{field:'TCertno',title:'֤������',width:200,hidden:true}
			]],
		columns:[[ 
			{field:'TPsnNo',title:'��Ա���',width:220},
			{field:'TPsnType',title:'��Ա���',width:80},
			{field:'TServMattInstId',title:'��������ʵ��ID',width:210},
			{field:'TTrtDclaDetlSn',title:'�����걨��ϸ��ˮ��',width:260 },
			{field:'THospId',title:'ҽԺID',width:80,hidden:true},
			{field:'THiType',title:'ҽ������',width:80,hidden:true},
			{field:'THiTypeDesc',title:'ҽ������',width:80},
			{field:'TBydiseSetlListCode',title:'�����ֽ��㲡��Ŀ¼����',width:170},
			{field:'TBydiseSetlDiseName',title:'�����ֽ��㲡������',width:150},
			{field:'TOprnOprtCode',title:'������������',width:120},
			{field:'TOprnOprtName',title:'������������',width:120},
			{field:'TInsutype',title:'��������',width:120},
			{field:'TEvtType',title:'�¼�����',width:80},
			{field:'TDclaSouc',title:'�걨��Դ',width:80,hidden:true},
			{field:'TDclaSoucDesc',title:'�걨��Դ',width:80},
			{field:'TBegnDate',title:'��ʼ����',width:90},
			{field:'TEndDate',title:'��������',width:90},
			{field:'TAppyDate',title:'��������',width:90},
			{field:'TEvtsn',title:'�¼���ˮ��',width:270},
			{field:'TServMattNodeInstId',title:'���������ʵ��ID',width:230},
			{field:'TEvtInstId',title:'�¼�ʵ��ID',width:230},
			{field:'TFixmedinsCode',title:'����ҽҩ�������',width:100,hidden:true},
			{field:'TFixmedinsName',title:'����ҽҩ��������',width:100,hidden:true},
			{field:'THospLv',title:'ҽԺ����',width:100,hidden:true},
			{field:'TFixBlngAdmdvs',title:'�������ҽ������',width:100,hidden:true},
			{field:'TOpterId',title:'������',width:80},
			{field:'TOptDate',title:'��������',width:90},
			{field:'TOptTime',title:'����ʱ��',width:80 },
			{field:'TUpdtId',title:'������Id',width:80},
			{field:'TUpdtDate',title:'��������',width:90},
			{field:'TUpdtTime',title:'����ʱ��',width:80},
			{field:'TPsnInsuRltsId',title:'��Ա�α���ϵID',width:70,hidden:true},
			{field:'TGend',title:'�Ա�',width:70,hidden:true},
			{field:'TNaty',title:'����',width:75,hidden:true},
			{field:'TBrdy',title:'��������',width:90,hidden:true},
			{field:'TTel',title:'��ϵ�绰',width:100},
			{field:'TAddr',title:'��ϵ��ַ',width:150},
			{field:'TInsuAdmdvs',title:'�α�����ҽ������',width:130},
			{field:'TMsgId',title:'���ͷ�������ˮ��',width:150},
			{field:'TAdmDr',title:'����Dr',width:80},
			{field:'TMdtrtId',title:'����ID',width:80},		
			{field:'TEmpNo',title:'��λ���',width:180},
			{field:'TEmpName',title:'��λ����',width:130},
			{field:'TAgnterName',title:'��ϵ��ַ',width:150},
			{field:'TMdtrtId',title:'����������',width:100},
			{field:'TAgnterCertType',title:'������֤������',width:120},
			{field:'TAgnterCertno',title:'������֤������',width:150 },
			{field:'TAgnterTel',title:'��������ϵ��ʽ',width:120 },
			{field:'TAgnterAddr',title:'��������ϵ��ַ',width:150},
			{field:'TAgnterRlts',title:'�����˹�ϵ',width:100},
			{field:'TAppyRea',title:'��������',width:180},
			{field:'TMemo',title:'��ע',width:180},
			{field:'TExpContent',title:'�ֶ���չ',width:180}
		]],
        onSelect : function(rowIndex, rowData) {
        },
        onUnselect: function(rowIndex, rowData) {
        },
        onBeforeLoad:function(param){
	    },
	    onLoadSuccess:function(data){
			
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
	    
	    ClassName : 'INSU.MI.BL.SevSpBigDiseRegCtl',
	    QueryName : 'QuerySevSpBigDiseReg',
	    StartDate : getValueById('StartDate'),
	    EndDate : getValueById('EndDate'),
	    HiType: getValueById('SearchInsuType'),
	    InsuNo: getValueById('SearchInsuNo'),
	    PsnName: getValueById('SearchName'),
	    PatType : getValueById('SearchType'),
	    PatId : getValueById('SearchId'),
	    HospId: GV.HospDr
	    
	}	
    loadDataGridStore('dg',queryParams);
	
}

function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
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
	 	//setValueById('INSUCardNo',TmpData1[1]);  //����
	 	//setValueById('name',TmpData1[3]);        //����
	 	//setValueById('Sex',TmpData1[4]);         //�Ա�
	 	//setValueById('Naty',TmpData1[5]);        //����
	 	//setValueById('BrDate',TmpData1[6]);      //��������
	 	//setValueById('insuOptins',TmpData1[21]); //�α���������
	 	//setValueById('rylb',TmpData1[11]);     //��Ա���	 
	 	//setValueById('XZType',TmpData[3]);       //��������	
	 	//setValueById('BrDate',TmpData[6]);       //��������	
	 	//setValueById('EmpName',TmpData[8]);      //��λ����	
	 	//setValueById('EmpNo',TmpData[8]);        //��λ���	
	 	
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
			}
			var admStr = "";
			setPatientInfo(papmi);
			loadAdmList(papmi);
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
		//setValueById("name", myAry[2]);
		//setValueById("tel", myAry[6]);
		//setValueById("addr", myAry[16]+myAry[18]+myAry[20]+myAry[7]);
		//setValueById("Sex", 2);
		//setValueById("IDCardNo", myAry[8]);
		//setValueById("EmpName", myAry[7]);
	});
}


/**
 * ˢ�»�����Ϣ��
 */
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
}


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
	$(".addInfo").form("clear");
	$('#QInsuType').combobox('reload');	
	$(".PatInfoItem").html('');
	InsuDateDefault('SDate',-1);	
	InsuDateDefault('EDate');
	InsuDateDefault('StartDate',-1);
	InsuDateDefault('EndDate');	
	InsuDateDefault('AdmTime');	
	InsuDateDefault('AppyDate');
	setValueById("AdmTime","");
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
*��ʼ���걨��Դ
*/
function init_Dclasouc(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('Dclasouc','dcla_souc' + getValueById('QInsuType'),Options); 	//scripts/dhcinsu/common/dhcinsu.common.js	
}

/*
 * �����˹�ϵ
 */
function init_AgnterRlts(){
	var Options = {
		defaultFlag:'N'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('AgnterRlts','agnter_rlts' + getValueById('QInsuType'),Options); 	//scripts/dhcinsu/common/dhcinsu.common.js		
}

/*
 * ������֤������
 */
function init_AgnterCertType(){
	var Options = {
		defaultFlag:'N'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('AgnterCertType','psn_cert_type' + getValueById('QInsuType'),Options); 	//scripts/dhcinsu/common/dhcinsu.common.js	
}

/*
 * �¼�����
 */
function init_EvtType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HospDr
	}
	INSULoadDicData('EvtType','evt_type' + getValueById('QInsuType'),Options); 	//scripts/dhcinsu/common/dhcinsu.common.js	
}
