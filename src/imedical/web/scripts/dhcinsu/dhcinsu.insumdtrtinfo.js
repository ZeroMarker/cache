/*
 * FileName:	dhcinsu.insumdtrtinfo.js
 * User:		sxq
 * Date:		2021-01-12
 * MainJS:      dhcinsu.insuservqry.js
 * Description: ������Ϣ��ѯ
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//ҳ�����ˢ��
 	} */
 	//setValueById('mdINSUType',GV.INSUTYPE);
 	//setValueById('mdINSUTypeDesc',GV.INSUTYPEDESC);
	//setValueById('mdSDate',getDefStDate(0));
	//setValueById('mdEDate',getDefStDate(1));
	InsuDateDefault('mdSDate');	
	InsuDateDefault('mdEDate',+1);		
	//setValueById('mdpsn_no',GV.PSNNO);
	//setValueById('med_type',GV.MEDTYPE);
	//ҽ������
	init_mdINSUType();
	//click�¼�
	init_mdClick();
	//������Ϣdg	
	init_insumddg(); 
	
});

/**
*��ʼ��click�¼�
*/		
function init_mdClick()
{
	 //��ѯ
	 $("#btnMdQry").click(MdQry_Click);
  
}
	
/**
*��ѯ�������������Ϣ
*/	
function MdQry_Click()
{
	var ExpStr=""  
	var trt=getValueById('mdpsn_no');
	if(trt == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա��Ų���Ϊ��!", 'info');
		return ;
	}
	var mdSDate=getValueById('mdSDate');
	if(mdSDate=="")
	{
		$.messager.alert("��ܰ��ʾ","��ʼʱ�䲻��Ϊ��!", 'info');
		return ;
	}
	/*var mdID=getValueById('mdtrt_id')
	if(mdID==""){
		$.messager.alert("��ܰ��ʾ","����ID����Ϊ��!", 'info');
		return ;
		}*/
	var outPutObj=getMdInfo();
	if(!outPutObj){return ;}
	if (outPutObj.mdtrtinfo.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯ������Ϣ!", 'info');return ;}
	loadQryGrid("insumddg",outPutObj.mdtrtinfo);
}

///��5201�������¼��ѯ
function getMdInfo()
{
	
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('mdINSUType')+"^"+"5201"+"^^output^"+connURL;
	var QryParams=""
	
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('mdpsn_no'));
	QryParams=AddQryParam(QryParams,"begntime",GetInsuDateFormat(getValueById('mdSDate')));
	QryParams=AddQryParam(QryParams,"endtime",GetInsuDateFormat(getValueById('mdEDate')));
	QryParams=AddQryParam(QryParams,"med_type",getValueById('mdmed_type'));
	QryParams=AddQryParam(QryParams,"mdtrt_id",getValueById('mdtrt_id'));
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
function init_insumddg() {
	var dgColumns = [[
			{field:'mdtrt_id',title:'����ID',width:120},
			{field:'psn_no',title:'��Ա���',width:150},	
			{field:'psn_cert_type',title:'��Ա֤������',width:160,formatter: function(value,row,index){
				var DicType="psn_cert_type"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'certno',title:'֤������',width:180},
			//{field:'psn_no',title:'��ʼ����',width:140},
			{field:'psn_name',title:'��Ա����',width:140 },
			{field:'gend',title:'�Ա�',width:100,formatter: function(value,row,index){
				var DicType="gend"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'naty',title:'����',width:100,formatter: function(value,row,index){
				var DicType="naty"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'brdy',title:'��������',width:120},
			{field:'age',title:'����',width:100},
			{field:'coner_name',title:'��ϵ������',width:140},
			{field:'tel',title:'��ϵ�绰',width:140},
			{field:'insutype',title:'��������',width:200,formatter: function(value,row,index){
				var DicType="insutype"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'psn_type',title:'��Ա���',width:120,formatter: function(value,row,index){
				var DicType="psn_type"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'maf_psn_flag',title:'ҽ�ƾ��������־',width:140,formatter: function(value,row,index){
				var DicType="maf_psn_flag"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'cvlserv_flag',title:'����Ա��־',width:120,formatter: function(value,row,index){
				var DicType="cvlserv_flag"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'flxempe_flag',title:'����ҵ��־',width:120,formatter: function(value,row,index){
				var DicType="flxempe_flag"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'nwb_flag',title:'��������־',width:120,formatter: function(value,row,index){
				var DicType="nwb_flag"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'insu_optins',title:'�α�����ҽ������',width:140,formatter: function(value,row,index){
				var DicType="insu_optins"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'emp_name',title:'��λ����',width:220},
			{field:'begntime',title:'��ʼʱ��',width:160},
			{field:'endtime',title:'����ʱ��',width:160},
			{field:'mdtrt_cert_type',title:'����ƾ֤����',width:140,formatter: function(value,row,index){
				var DicType="mdtrt_cert_type"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'med_type',title:'ҽ�����',width:120,formatter: function(value,row,index){
				var DicType="med_type"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'ars_year_ipt_flag',title:'�����סԺ��־',width:150,formatter: function(value,row,index){
				var DicType="ars_year_ipt_flag"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'pre_pay_flag',title:'����֧����־',width:140,formatter: function(value,row,index){
				var DicType="pre_pay_flag"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'ipt_otp_no',title:'סԺ/�����',width:120},
			{field:'medrcdno',title:'������',width:80},
			{field:'atddr_no',title:'����ҽ������',width:120},
			{field:'chfpdr_name',title:'����ҽʦ����',width:120},
			{field:'adm_dept_codg',title:'��Ժ���ұ���',width:120},
			{field:'adm_dept_name',title:'��Ժ��������',width:120},
			{field:'adm_bed',title:'��Ժ��λ',width:120},
			{field:'dscg_maindiag_code',title:'סԺ����ϴ���',width:120},
			{field:'dscg_maindiag_name',title:'סԺ���������',width:120},
			{field:'dscg_dept_codg',title:'��Ժ���ұ���',width:120},
			{field:'dscg_dept_name',title:'��Ժ��������',width:120},
			{field:'dscg_bed',title:'��Ժ��λ',width:120},
			{field:'dscg_way',title:'��Ժ��ʽ',width:120,formatter: function(value,row,index){
				var DicType="dscg_way"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'main_cond_dscr',title:'��Ҫ��������',width:120},
			{field:'dise_codg',title:'���ֱ���',width:120},
			{field:'dise_name',title:'��������',width:120},
			{field:'oprn_oprt_code',title:'������������',width:120},
			{field:'oprn_oprt_name',title:'������������',width:120},
			{field:'otp_diag_info',title:'���������Ϣ',width:120},
			{field:'inhosp_stas',title:'��Ժ״̬',width:120,formatter: function(value,row,index){
				var DicType="inhosp_stas"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'die_date',title:'��������',width:120},
			{field:'ipt_days',title:'סԺ����',width:120},
			{field:'fpsc_no',title:'�ƻ���������֤��',width:140},
			{field:'matn_type',title:'�������',width:120,formatter: function(value,row,index){
				var DicType="matn_type"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'birctrl_type',title:'�ƻ������������',width:140,formatter: function(value,row,index){
				var DicType="birctrl_type"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'latechb_flag',title:'������־',width:120,formatter: function(value,row,index){
				var DicType="latechb_flag"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'geso_val',title:'������',width:120},
			{field:'fetts',title:'̥��',width:120},
			{field:'fetus_cnt',title:'̥����',width:120},
			{field:'pret_flag',title:'�����־',width:120,formatter: function(value,row,index){
				var DicType="pret_flag"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'birctrl_matn_date',title:'�ƻ�������������������',width:180},
			{field:'cop_flag',title:'���в���֢��־',width:120,formatter: function(value,row,index){
				var DicType="cop_flag"+getValueById('mdINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'opter_id',title:'������ ID',width:120},
			{field:'opter_name',title:'����������',width:120},
			{field:'opt_time',title:'����ʱ��',width:160},
			{field:'memo',title:'��ע',width:120}
		]];

	// ��ʼ��DataGrid
	$('#insumddg').datagrid({
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
function init_mdINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('mdINSUType','DLLType',Options); 	
	$('#mdINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('mdINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
	        INSULoadDicData('mdmed_type','med_type' + GV.INSUTYPE,{hospDr: GV.HOSPDR});  	// ҽ�����
		
		},
 
	})	;
	
}