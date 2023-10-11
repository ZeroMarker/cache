/*
 * FileName:	dhcinsu.insuzdinfo.js
 * User:		sxq
 * Date:		2021-01-12
 * MainJS:      dhcinsu.insuservqry.js
 * Description: �����Ϣ��ѯ
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//ҳ�����ˢ��
 	} */
 	//setValueById('zdINSUType',GV.INSUTYPE);
 	//setValueById('zdINSUTypeDesc',GV.INSUTYPEDESC);
	//setValueById('mtSDate',getDefStDate(0));
	//setValueById('mtEDate',getDefStDate(1));	
	//setValueById('zdpsn_no',GV.PSNNO);
	//setValueById('zdmdtrt_id',GV.MDTRTID);
	// ҽ������
	init_zdINSUType();
	//click�¼�
	init_zdClick();
	//��ʼ����Ա���ز���ҩ��¼dg	
	init_insuzddg(); 
	
});

/**
*��ʼ��click�¼�
*/		
function init_zdClick()
{
	 //��ѯ
	 $("#btnZdQry").click(ZdQry_Click);
  
}
	
/**
*��ѯ�������������Ϣ
*/	
function ZdQry_Click()
{
	var ExpStr=""  
	var trt=getValueById('zdpsn_no');
	if(trt == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա��Ų���Ϊ��!", 'info');
		return ;
	}
	var mdtrt_id=getValueById('zdmdtrt_id');
	if(mdtrt_id=="")
	{
		$.messager.alert("��ܰ��ʾ","����ID����Ϊ��!", 'info');
		return ;
	}
	
	var outPutObj=getZdInfo();
	if(!outPutObj){return ;}
	if (outPutObj.diseinfo.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯ����Ӧ������Ϣ!", 'info');return ;}
	loadQryGrid("insuzddg",outPutObj.diseinfo);
}

///��5202��������Ϣ��ѯ
function getZdInfo()
{
	
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('zdINSUType')+"^"+"5202"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('zdpsn_no'));
	QryParams=AddQryParam(QryParams,"mdtrt_id",getValueById('zdmdtrt_id'));
	//QryParams=AddQryParam(QryParams,"begntime",getValueById('mtSDate'));
	//QryParams=AddQryParam(QryParams,"endtime",getValueById('mtEDate'));
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
function init_insuzddg() {
	var dgColumns = [[
			{field:'diag_info_id',title:'�����Ϣ ID',width:160},
			{field:'mdtrt_id',title:'���� ID',width:150},	
			{field:'psn_no',title:'��Ա���',width:150},
			{field:'inout_diag_type',title:'����Ժ������',width:140,formatter: function(value,row,index){
				var DicType="inout_diag_type"+getValueById('zdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'diag_type',title:'������',width:140,formatter: function(value,row,index){
				var DicType="diag_type"+getValueById('zdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'maindiag_flag',title:'����ϱ�־',width:140,formatter: function(value,row,index){
				var DicType="maindiag_flag"+getValueById('zdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'diag_srt_no',title:'��������',width:120},
			{field:'diag_code',title:'��ϴ���',width:120},
			{field:'diag_name',title:'�������',width:220},
			{field:'adm_cond',title:'��Ժ����',width:220},
			{field:'diag_dept',title:'��Ͽ���',width:150},
			{field:'dise_dor_no',title:'���ҽ������',width:150},
			{field:'dise_dor_name',title:'���ҽ������',width:150},
			{field:'diag_time',title:'���ʱ��',width:180},
			{field:'opter_id',title:'������ ID',width:150},
			{field:'opter_name',title:'����������',width:150},
			{field:'opt_time',title:'����ʱ��',width:180}
			
		]];

	// ��ʼ��DataGrid
	$('#insuzddg').datagrid({
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
function init_zdINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('zdINSUType','DLLType',Options); 	
	$('#zdINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('zdINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
	     
		}
	})	;
	
}




