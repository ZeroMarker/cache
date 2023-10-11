/*
 * FileName:	dhcinsu.insureferralInfoqry.js
 * User:		YuanDC
 * Date:		2021-01-12
 * MainJS:      dhcinsu.insuservqry.js
 * Description: תԺ��Ϣ��ѯ-5304
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//ҳ�����ˢ��
 	} */
 	//setValueById('referINSUType',GV.INSUTYPE);
 	//setValueById('referINSUTypeDesc',GV.INSUTYPEDESC);
	//setValueById('referSDate',getDefStDate(0));
	//setValueById('referEDate',getDefStDate(1));
	InsuDateDefault('referSDate');	
	InsuDateDefault('referEDate',+1);		
	//setValueById('referpsn_no',GV.PSNNO);
	// ҽ������
	init_referINSUType();
	//click�¼�
	init_referClick();
	//��ʼ��תԺ��Ϣ��ѯ��¼dg	
	init_insureferdg(); 
	
});


/**
*��ʼ��click�¼�
*/		
function init_referClick()
{
	 //��ѯ
	 $("#btnreferQry").click(referQry_Click);
  
}
	
/**
*תԺ��Ϣ��ѯ
*/	
function referQry_Click()
{
	var ExpStr=""  
	var regpsnno=getValueById('referpsn_no');
	if(regpsnno == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա��Ų���Ϊ��!", 'info');
		return ;
	}
	var mtSDate=getValueById('referSDate');
	if(mtSDate=="")
	{
		$.messager.alert("��ܰ��ʾ","��ʼʱ�䲻��Ϊ��!", 'info');
		return ;
	}
	
	var outPutObj=getreferInfo();
	
	if(!outPutObj){return ;}
	if (outPutObj.refmedin.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯ����Ӧ��תԺ������¼!", 'info');return ;}
	loadQryGrid("insureferdg",outPutObj.refmedin);
}

///תԺ��Ϣ��ѯ-5304
function getreferInfo()
{
	
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('referINSUType')+"^"+"5304"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('referpsn_no'));
	QryParams=AddQryParam(QryParams,"begntime",getValueById('referSDate'));
	QryParams=AddQryParam(QryParams,"endtime",getValueById('referEDate'));
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
function init_insureferdg() {
	var dgColumns = [[
			{field:'insutype',title:'��������',width:150,formatter: function(value,row,index){
				var DicType="insutype"+getValueById('referINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'dcla_souc',title:'�걨��Դ',width:100,formatter: function(value,row,index){
				var DicType="dcla_souc"+getValueById('referINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'psn_no',title:'��Ա���',width:180},
			{field:'psn_cert_type',title:'��Ա֤������',width:150,formatter: function(value,row,index){
				var DicType="psn_cert_type"+getValueById('referINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'certno',title:'֤������',width:180},
			{field:'psn_name',title:'��Ա����',width:100},
			{field:'gend',title:'�Ա�',width:100},
			{field:'brdy',title:'��������',width:100},
			{field:'tel',title:'��ϵ�绰',width:100},
			{field:'addr',title:'��ϵ��ַ',width:180},
			{field:'insu_optins',title:'�α�����',width:100},
			{field:'emp_name',title:'��λ����',width:180},
			{field:'diag_code',title:'��ϴ���',width:100},
			{field:'diag_name',title:'�������',width:120},
			{field:'dise_cond_dscr',title:'����',width:100},
			{field:'reflin_medins_no',title:'ת��ҽԺ����',width:120},
			{field:'reflin_medins_name',title:'ת��ҽԺ����',width:180},
			{field:'out_flag',title:'��ر�־',width:100,formatter: function(value,row,index){
				var DicType="out_flag"+getValueById('referINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'refl_date',title:'תԺ����',width:120},
			{field:'refl_rea',title:'תԺԭ��',width:100},
			{field:'begndate',title:'��ʼ����',width:120},
			{field:'enddate',title:'��������',width:120},
			{field:'hosp_agre_refl_flag',title:'ҽԺͬ��תԺ��־',width:140,formatter: function(value,row,index){
				var DicType="hosp_agre_refl_flag"+getValueById('referINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'opter_id',title:'������ID',width:80},
			{field:'opter_name',title:'����������',width:100},
			{field:'opt_time',title:'����ʱ��',width:100}
			
		]];

	// ��ʼ��DataGrid
	$('#insureferdg').datagrid({
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
function init_referINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('referINSUType','DLLType',Options); 	
	$('#referINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('referINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
	     
		}
	})	;
	
}




