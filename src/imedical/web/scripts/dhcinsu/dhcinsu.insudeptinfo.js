/*
 * FileName:	dhcinsu.insudeptinfo.js
 * Creator:		HanZH
 * Date:		2022-05-25
 * MainJS:      dhcinsu.insuservqry.js
 * Description: ������Ϣ��ѯ-5101
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//ҳ�����ˢ��
 	} */
	// ҽ������
	init_deptINSUType();
	//click�¼�
	init_regClick();
	//��ʼ��������Ϣ��ѯ��¼dg	
	init_insudeptdg();
	
});

/**
*��ʼ��click�¼�
*/		
function init_regClick()
{
	 //��ѯ
	 $("#btnDeptQry").click(DeptQry_Click);
  
}
	
/**
*��ѯ
*/	
function DeptQry_Click()
{
	var ExpStr=""
	var SaveFlag="0"
    if (getValueById('SaveFlag')){ SaveFlag="1" }
    
	var outPutObj=getDeptInfo();
	if(!outPutObj){return ;}
	//if (outPutObj.medinsinfo.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯ����Ӧ�Ŀ�����Ϣ��¼!", 'info');return ;}
	if (outPutObj.feedetail.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯ����Ӧ�Ŀ�����Ϣ��¼!", 'info');return ;}	//upt 20221209 HanZH
	loadQryGrid("insudeptdg",outPutObj.feedetail);
}

///ҽҩ������ѯ-1201
function getDeptInfo()
{
	
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('deptINSUType')+"^"+"5101"+"^^output^"+connURL;
	var QryParams=""
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
function init_insudeptdg() {
	var dgColumns = [[
			{field:'hosp_dept_codg',title:'ҽԺ���ұ���',width:100},		
			{field:'hosp_dept_name',title:'ҽԺ��������',width:150},
			{field:'begntime',title:'��ʼʱ��',width:120},	
			{field:'endtime',title:'����ʱ��',width:120},
			{field:'itro',title:'���',width:120},
			{field:'dept_resper_na me',title:'���Ҹ���������',width:120},
			{field:'dept_resper_te l',title:'���Ҹ����˵绰',width:120},
			{field:'dept_med_serv_ scp',title:'����ҽ�Ʒ���Χ',width:130},
			{field:'caty',title:'�Ʊ�',width:120},
			{field:'dept_estbdat',title:'���ҳ�������',width:120},
			{field:'aprv_bed_cnt',title:'��׼��λ����',width:120},
			{field:'hi_crtf_bed_cn t',title:'ҽ���Ͽɴ�λ��',width:120},
			{field:'poolarea_no',title:'ͳ�������',width:120},
			{field:'dr_psncnt',title:'ҽʦ����',width:120},
			{field:'phar_psncnt',title:'ҩʦ����',width:120},
			{field:'nurs_psncnt',title:'��ʿ����',width:120},
			{field:'tecn_psncnt',title:'��ʦ����',width:120},
			{field:'memo',title:'��ע',width:120}	
		]];

	// ��ʼ��DataGrid
	$('#insudeptdg').datagrid({
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
function init_deptINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('deptINSUType','DLLType',Options); 	
	$('#deptINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('deptINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
		}
 
	})	;
	
}






