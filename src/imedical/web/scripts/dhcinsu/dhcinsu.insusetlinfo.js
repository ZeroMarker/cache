/*
 * FileName:	dhcinsu.insusetlinfo.js
 * User:		YuanDC
 * Date:		2021-01-12
 * MainJS:      dhcinsu.insuservqry.js
 * Description: ������Ϣ��ѯ-5203
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//ҳ�����ˢ��
 	} */
 	//setValueById('setlINSUType',GV.INSUTYPE);
 	//setValueById('setlINSUTypeDesc',GV.INSUTYPEDESC);
	//setValueById('regSDate',getDefStDate(0));
	//setValueById('regEDate',getDefStDate(1));	
	//setValueById('setlpsn_no',GV.PSNNO);
	//setValueById('setlInsuplc_admdvs',GV.INSUPLCADMDVS);
	// ҽ������
	init_setlINSUType();
	//click�¼�
	init_setlClick();
	//��ʼ����Ժ��Ϣ��ѯ��¼dg	
	init_insusetldg(); 
	
});

/**
*��ʼ��click�¼�
*/		
function init_setlClick()
{
	 //��ѯ
	 $("#btnSetlQry").click(setlQry_Click);
  
}
	
/**
*������Ϣ��ѯ-5203
*/	
function setlQry_Click()
{
	var ExpStr=""  
	var setlpsn_no=getValueById('setlpsn_no');
	if(setlpsn_no == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա��Ų���Ϊ��!", 'info');
		return ;
	}
	/*var setlsetlid=getValueById('setlsetl_id');
	if(setlsetlid=="")
	{
		$.messager.alert("��ܰ��ʾ","����ID����Ϊ��!", 'info');
		return ;
	}*/
	var setlmdtrtid=getValueById('setlmdtrt_id');
	if(setlmdtrtid=="")
	{
		$.messager.alert("��ܰ��ʾ","����ID����Ϊ��!", 'info');
		return ;
	}
	
	var outPutObj=getsetlInfo();
	
	var setlinfoData = JSON.stringify(outPutObj.setlinfo);
	
	var setinfoObj=JSON.parse("["+setlinfoData+"]");
	
	if(!outPutObj){return ;}
	if (setinfoObj.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯ����Ӧ�Ľ�����Ϣ��ѯ!", 'info');return ;}
	loadQryGrid("insusetldg",setinfoObj);
	
}

///������Ϣ��ѯ-5203
function getsetlInfo()
{
	
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('setlINSUType')+"^"+"5203"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('setlpsn_no'));
	QryParams=AddQryParam(QryParams,"setl_id",getValueById('setlsetl_id'));
	QryParams=AddQryParam(QryParams,"mdtrt_id",getValueById('setlmdtrt_id'));
	QryParams=AddQryParam(QryParams,"insuplc_admdvs",getValueById('setlInsuplc_admdvs'));
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
function init_insusetldg() {
	var dgColumns = [[
			{field:'setl_id',title:'����ID',width:120},
			{field:'mdtrt_id',title:'����ID',width:120},	
			{field:'psn_no',title:'��Ա���',width:150},
			{field:'psn_name',title:'��Ա����',width:100},
			{field:'psn_cert_type',title:'��Ա֤������',width:160,formatter: function(value,row,index){
				var DicType="psn_cert_type"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},
			{field:'certno',title:'֤������',width:180},
			{field:'gend',title:'�Ա�',width:100,formatter: function(value,row,index){
				var DicType="gend"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},		
			{field:'naty',title:'����',width:100,formatter: function(value,row,index){
				var DicType="naty"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},		
			{field:'brdy',title:'��������',width:120},
			{field:'age',title:'����',width:100},
			{field:'insutype',title:'��������',width:150,formatter: function(value,row,index){
				var DicType="insutype"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},		
			{field:'psn_type',title:'��Ա���',width:150,formatter: function(value,row,index){
				var DicType="psn_type"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},		
			{field:'cvlserv_flag',title:'����Ա��־',width:100,formatter: function(value,row,index){
				var DicType="cvlserv_flag"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},		
			{field:'flxempe_flag',title:'����ҵ��־',width:150,formatter: function(value,row,index){
				var DicType="flxempe_flag"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'ipt_otp_no',title:'סԺ/�����',width:150},
			{field:'nwb_flag',title:'��������־',width:150,formatter: function(value,row,index){
				var DicType="nwb_flag"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'insu_optins',title:'�α�����ҽ������',width:150},
			{field:'emp_name',title:'��λ����',width:150},
			{field:'pay_loc',title:'֧���ص����',width:150,formatter: function(value,row,index){
				var DicType="pay_loc"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'fixmedins_code',title:'����ҽҩ�������',width:150},
			{field:'fixmedins_name',title:'����ҽҩ��������',width:180},
			{field:'hosp_lv',title:'ҽԺ�ȼ�',width:100,formatter: function(value,row,index){
				var DicType="hosp_lv"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'fixmedins_poolarea',title:'�����������',width:150},
			{field:'lmtpric_hosp_lv',title:'�޼�ҽԺ�ȼ�',width:150,formatter: function(value,row,index){
				var DicType="lmtpric_hosp_lv"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'dedc_hosp_lv',title:'����ҽԺ�ȼ�',width:150,formatter: function(value,row,index){
				var DicType="dedc_hosp_lv"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'begndate',title:'��ʼ����',width:120},
			{field:'enddate',title:'��������',width:120},
			{field:'setl_time',title:'����ʱ��',width:160},
			{field:'mdtrt_cert_type',title:'����ƾ֤����',width:150,formatter: function(value,row,index){
				var DicType="mdtrt_cert_type"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'med_type',title:'ҽ�����',width:150,formatter: function(value,row,index){
				var DicType="med_type"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'clr_type',title:'�������',width:100,formatter: function(value,row,index){
				var DicType="clr_type"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'clr_way',title:'���㷽ʽ',width:130,formatter: function(value,row,index){
				var DicType="clr_way"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'clr_optins',title:'���㾭�����',width:150},
			{field:'medfee_sumamt',title:'ҽ�Ʒ��ܶ�',width:150,align:'right'},
			{field:'fulamt_ownpay_amt',title:'ȫ�Էѽ��',width:150,align:'right'},
			{field:'overlmt_selfpay',title:'���޼��Էѷ���',width:150,align:'right'},
			{field:'preselfpay_amt',title:'�����Ը����',width:150,align:'right'},
			{field:'inscp_scp_amt',title:'�������߷�Χ���',width:150,align:'right'},
			{field:'act_pay_dedc',title:'ʵ��֧������',width:150,align:'right'},
			{field:'hifp_pay',title:'����ҽ�Ʊ���ͳ�����֧��',width:220,align:'right'},
			{field:'pool_prop_selfpay',title:'����ҽ�Ʊ���ͳ�����֧������',width:220},
			{field:'cvlserv_pay',title:'����Աҽ�Ʋ����ʽ�֧��',width:200,align:'right'},
			{field:'hifes_pay',title:'��ҵ����ҽ�Ʊ��ջ���֧��',width:200,align:'right'},
			{field:'hifmi_pay',title:'����󲡱����ʽ�֧��',width:200,align:'right'},
			{field:'hifob_pay',title:'ְ�����ҽ�Ʒ��ò�������֧��',width:220,align:'right'},
			{field:'maf_pay',title:'ҽ�ƾ�������֧��',width:150,align:'right'},
			{field:'oth_pay',title:'����֧��',width:150,align:'right'},
			{field:'fund_pay_sumamt',title:'����֧���ܶ�',width:150,align:'right'},
			{field:'psn_pay',title:'����֧�����',width:150,align:'right'},
			{field:'acct_pay',title:'�����˻�֧��',width:150,align:'right'},
			{field:'cash_payamt',title:'�ֽ�֧�����',width:150,align:'right'},
			{field:'balc',title:'���',width:150,align:'right'},
			{field:'acct_mulaid_pay',title:'�����˻�����֧�����',width:150,align:'right'},
			{field:'medins_setl_id',title:'ҽҩ��������ID',width:150},
			{field:'refd_setl_flag',title:'�˷ѽ����־',width:150,formatter: function(value,row,index){
				var DicType="refd_setl_flag"+getValueById('setlINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'year',title:'���',width:120},
			{field:'dise_codg',title:'���ֱ���',width:150},
			{field:'dise_name',title:'��������',width:150},
			{field:'invono',title:'��Ʊ��',width:150},
			{field:'opter_id',title:'������ID',width:150},
			{field:'opter_name',title:'����������',width:150},
			{field:'opt_time',title:'����ʱ��',width:150}
		]];

	// ��ʼ��DataGrid
	$('#insusetldg').datagrid({
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
function init_setlINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('setlINSUType','DLLType',Options); 	
	$('#setlINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('setlINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
		
		}
 
	})	;
	
}
