/*
 * FileName:	dhcinsu.insuopspdiseqry.js
 * User:		YuanDC
 * Date:		2021-01-12
 * MainJS:      dhcinsu.insuservqry.js
 * Description: ��Ա���ز�������Ϣ��ѯ-5301
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//ҳ�����ˢ��
 	} */
 	//setValueById('opspINSUType',GV.INSUTYPE);
 	//setValueById('opspINSUTypeDesc',GV.INSUTYPEDESC);
	//setValueById('regSDate',getDefStDate(0));
	//setValueById('regEDate',getDefStDate(1));	
	//setValueById('opsppsn_no',GV.PSNNO);
	// ҽ������
	init_opspINSUType();
	//click�¼�
	init_opspClick();
	//��ʼ����Ա���ز�������Ϣ��ѯ��¼dg	
	init_insuopspdg(); 
	
});


/**
*��ʼ��click�¼�
*/		
function init_opspClick()
{
	 //��ѯ
	 $("#btnopspQry").click(opspQry_Click);
  
}
	
/**
*��Ա���ز�������Ϣ��ѯ
*/	
function opspQry_Click()
{
	var ExpStr=""  
	var regpsnno=getValueById('opsppsn_no');
	if(regpsnno == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա��Ų���Ϊ��!", 'info');
		return ;
	}
	
	var outPutObj=getopspInfo();
	
	if(!outPutObj){return ;}
	if (outPutObj.feedetail.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯ����Ӧ����Ա���ز�������¼!", 'info');return ;}
	loadQryGrid("insuopspdg",outPutObj.feedetail);
}

///��Ա���ز�������Ϣ��ѯ-5301
function getopspInfo()
{
	
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('opspINSUType')+"^"+"5301"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('opsppsn_no'));
	//QryParams=AddQryParam(QryParams,"begntime",getValueById('regSDate'));
	//QryParams=AddQryParam(QryParams,"endtime",getValueById('regEDate'));
	QryParams=AddQryParam(QryParams,"insuplc_admdvs",GV.INSUPLCADMDVS);
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
function init_insuopspdg() {
	var dgColumns = [[
			{field:'opsp_dise_code',title:'�����ز��ִ���',width:150},
			{field:'opsp_dise_name',title:'�����ز�������',width:150},
			{field:'begndate',title:'��ʼ����',width:100},
			{field:'enddate',title:'��������',width:100}
		]];

	// ��ʼ��DataGrid
	$('#insuopspdg').datagrid({
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
			
		}
	});
}

/*
 * ҽ������ ��ҽ�������йص� ��������Ҫ�������¼���
 */
function init_opspINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('opspINSUType','DLLType',Options); 	
	$('#opspINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('opspINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
	     
		}
	})	;
	
}





