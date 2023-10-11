/*
 * FileName:	dhcinsu.medstff.js
 * Creator:		HanZH
 * Date:		2022-05-25
 * MainJS:      dhcinsu.insuservqry.js
 * Description: ҽִ��Ա��Ϣ��ѯ-5102
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//ҳ�����ˢ��
 	} */
	// ҽ������
	init_medINSUType();
	//click�¼�
	init_regClick();
	//��ʼ����Ա֤������
	init_psnCertType(); 
	//��ʼ��ִҵ��Ա����
	init_pracPsnType()
	//ҽִ��Ա��Ϣ��ѯ��¼dg	
	init_medstffdg();
	
});

/**
*��ʼ��click�¼�
*/		
function init_regClick()
{
	 //��ѯ
	 $("#btnMedQry").click(MedQry_Click);
}
	
/**
*ҽִ��Ա��Ϣ��ѯ
*/	
function MedQry_Click()
{
	var ExpStr=""  
	var pracPsnType=getValueById('pracPsnType');
	if(pracPsnType=="")
	{
		$.messager.alert("��ܰ��ʾ","ִҵ��Ա���಻��Ϊ��!", 'info');
		return ;
	}
	var SaveFlag="0"
    if (getValueById('SaveFlag')){ SaveFlag="1" }
    
	var outPutObj=getMedStffInfo();
	if(!outPutObj){return ;}
	if (outPutObj.feedetail.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯҽִ��Ա��Ϣ��¼!", 'info');return ;}
	loadQryGrid("medstffdg",outPutObj.feedetail);
}

///ҽִ��Ա��Ϣ��ѯ-5102
function getMedStffInfo()
{
	
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('medINSUType')+"^"+"5102"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"prac_psn_type",getValueById('pracPsnType'));	
	QryParams=AddQryParam(QryParams,"psn_cert_type",getValueById('psn_cert_type'));
	QryParams=AddQryParam(QryParams,"certno",getValueById('certno'));
	QryParams=AddQryParam(QryParams,"prac_psn_name",getValueById('pracPsnName'));
	QryParams=AddQryParam(QryParams,"prac_psn_code",getValueById('pracPsnCod'));
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
/*
 * datagrid
 */
function init_medstffdg() {
	var dgColumns = [[
			{field:'psn_cert_type',title:'��Ա֤������',width:180,formatter: function(value,row,index){
				var DicType="psn_cert_type"+getValueById('medINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},		
			{field:'certno',title:'֤������',width:160},
			{field:'prac_psn_no',title:'ִҵ��Ա�Ա��',width:320},	
			{field:'prac_psn_code',title:'ִҵ��Ա����',width:160},
			{field:'prac_psn_name',title:'ִҵ��Ա����',width:120},
			{field:'prac_psn_type',title:'ִҵ��Ա����',width:180,formatter: function(value,row,index){
				var DicType="medins_psn_type"+getValueById('medINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'prac_psn_cert',title:'ִҵ��Ա�ʸ�֤�����',width:160},
			{field:'prac_cert_no',title:'ִҵ֤����',width:120},
			{field:'hi_dr_flag',title:'ҽ��ҽʦ��־',width:120},
			{field:'begntime',title:'��ʼʱ��',width:120},
			{field:'endtime',title:'����ʱ��',width:120},
			{field:'chg_rea',title:'���ԭ��',width:120}
		]];

	// ��ʼ��DataGrid
	$('#medstffdg').datagrid({
		fit:true,
		border:false,
		data:[],
		//striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: false,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		columns: dgColumns,
		onDblClickRow:function(index,rowData){
			//FindReportInfo();	
		}
	});
}

/*
 * ҽ������ ��ҽ�������йص� ��������Ҫ�������¼���
 */
function init_medINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('medINSUType','DLLType',Options); 	
	$('#medINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('medINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
			INSULoadDicData('psnCertType','psn_cert_type' + GV.INSUTYPE,{hospDr: GV.HOSPDR}); // ��Ա֤������
			INSULoadDicData('pracPsnType','medins_psn_type' + GV.INSUTYPE,{hospDr: GV.HOSPDR}); // ִҵ��Ա����
		}
 
	})	;
	
}

/*
 * ��Ա֤������
 */
function init_psnCertType(){
	$HUI.combobox(('#psnCertType'),{
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
			param.Type = 'psn_cert_type' + getValueById('medINSUType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	});
	
}
/*
 * ִҵ��Ա����
 */
function init_pracPsnType(){
	$HUI.combobox(('#pracPsnType'),{
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
			param.Type = 'medins_psn_type' + getValueById('medINSUType');
			param.Code = '';
			param.HospDr = GV.HospDr; 
			param.ResultSetType = 'array';
		},
		onLoadSuccess:function(data){

		}		
	});
	
}


