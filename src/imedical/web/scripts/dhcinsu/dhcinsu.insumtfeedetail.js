/*
 * FileName:	dhcinsu.insumtfeedetail.js
 * User:		DingSH
 * Date:		2021-01-12
 * MainJS:      dhcinsu.insuservqry.js
 * Description: ��Ա���ز���ҩ��¼��ѯ
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//ҳ�����ˢ��
 	} */
 	//setValueById('mtINSUType',GV.INSUTYPE);
 	//setValueById('mtINSUTypeDesc',GV.INSUTYPEDESC);
	//setValueById('mtSDate',getDefStDate(0));
	//setValueById('mtEDate',getDefStDate(1));
	InsuDateDefault('mtSDate');	
	InsuDateDefault('mtEDate',+1);		
	//setValueById('mtpsn_no',GV.PSNNO);
	// ҽ������
	init_mtINSUType();
	//click�¼�
	init_mtClick();
	//��ʼ����Ա���ز���ҩ��¼dg	
	init_insumtdg(); 
	
});

/**
*��ʼ��click�¼�
*/		
function init_mtClick()
{
	 //��ѯ
	 $("#btnMtQry").click(MtQry_Click);
  
}
	
/**
*��ѯ�������������Ϣ
*/	
function MtQry_Click()
{
	var ExpStr=""  
	var trtPsnNo=getValueById('mtpsn_no');
	if(trtPsnNo == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա��Ų���Ϊ��!", 'info');
		return ;
	}
	var mtSDate=getValueById('mtSDate');
	if(mtSDate=="")
	{
		$.messager.alert("��ܰ��ʾ","��ʼʱ�䲻��Ϊ��!", 'info');
		return ;
	}
	var outPutObj=getMtInfo();
	if(!outPutObj){return ;}
	if (outPutObj.feedetail.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯ����Ӧ����ҩ��¼!", 'info');return ;}
	loadQryGrid("insumtdg",outPutObj.feedetail);
}

///��5205����Ա���ز���ҩ��¼��ѯ
function getMtInfo()
{
	
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('mtINSUType')+"^"+"5205"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('mtpsn_no'));
	QryParams=AddQryParam(QryParams,"begntime",GetInsuDateFormat(getValueById('mtSDate')));
	QryParams=AddQryParam(QryParams,"endtime",GetInsuDateFormat(getValueById('mtEDate')));
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
function init_insumtdg() {
	var dgColumns = [[
			{field:'psn_no',title:'��Ա���',width:150},
			{field:'rx_drord_no',title:'����/ҽ����',width:150},	
			{field:'fixmedins_code',title:'����ҽҩ�������',width:150},
			{field:'fixmedins_name',title:'����ҽҩ��������',width:150},
			{field:'psn_no',title:'��ʼ����',width:120},
			{field:'med_type',title:'��������',width:120 },
			{field:'fee_ocur_time',title:'���÷���ʱ��',width:160},
			{field:'cnt',title:'����',width:150},
			{field:'pric',title:'����',width:150,align:'right'},
			{field:'chrgitm_lv',title:'�շ���Ŀ�ȼ�',width:150,formatter: function(value,row,index){
				var DicType="chrgitm_lv"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'hilist_code',title:'ҽ��Ŀ¼����',width:160},
			{field:'hilist_name',title:'ҽ��Ŀ¼����',width:160},
			{field:'list_type',title:'Ŀ¼���',width:150,formatter: function(value,row,index){
				var DicType="list_type"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'med_list_codg',title:'ҽ��Ŀ¼����',width:150},
			{field:'medins_list_codg',title:'ҽҩ����Ŀ¼����',width:180},
			{field:'medins_list_name',title:'ҽҩ����Ŀ¼����',width:180},
			{field:'med_chrgitm_type',title:'ҽ���շ���Ŀ���',width:180,formatter: function(value,row,index){
				var DicType="med_chrgitm_type"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'prodname',title:'��Ʒ��',width:150},
			{field:'spec',title:'���',width:100},
			{field:'dosform_name',title:'��������',width:120},
			{field:'lmt_used_flag',title:'����ʹ�ñ�־',width:120,formatter: function(value,row,index){
				var DicType="lmt_used_flag"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'hosp_prep_flag',title:'ҽԺ�Ƽ���־',width:120,formatter: function(value,row,index){
				var DicType="hosp_prep_flag"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'hosp_appr_flag',title:'ҽԺ������־',width:120,formatter: function(value,row,index){
				var DicType="hosp_appr_flag"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'tcmdrug_used_way',title:'��ҩʹ�÷�ʽ',width:120},
			{field:'prodplac_type',title:'���������',width:120,formatter: function(value,row,index){
				var DicType="prodplac_type"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'bas_medn_flag',title:'����ҩ���־',width:120,formatter: function(value,row,index){
				var DicType="bas_medn_flag"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'hi_nego_drug_flag',title:'ҽ��̸��ҩƷ��־',width:160,formatter: function(value,row,index){
		     	return value=="1" ? "��":"��" ;          
			}},
			{field:'chld_medc_flag',title:'��ͯ��ҩ��־',width:120,formatter: function(value,row,index){
				var DicType="chld_medc_flag"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'etip_flag',title:'����־',width:80,formatter: function(value,row,index){
				var DicType="etip_flag"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'etip_hosp_code',title:'���ҽԺ����',width:120},
			{field:'dscg_tkdrug_flag',title:'��Ժ��ҩ��־',width:120,formatter: function(value,row,index){
				var DicType="dscg_tkdrug_flag"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'list_sp_item_flag',title:'Ŀ¼�����־',width:120,formatter: function(value,row,index){
				var DicType="list_sp_item_flag"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'matn_fee_flag',title:'�������ñ�־',width:120,formatter: function(value,row,index){
				var DicType="matn_fee_flag"+getValueById('mtINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}}
		]];

	// ��ʼ��DataGrid
	$('#insumtdg').datagrid({
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
function init_mtINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('mtINSUType','DLLType',Options); 	
	$('#mtINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('mtINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
		}
	})	;
	
}





