/*
 * FileName:	dhcinsu.insureginfo.js
 * User:		YuanDC
 * Date:		2021-01-12
 * MainJS:      dhcinsu.insuservqry.js
 * Description: ��Ժ��Ϣ��ѯ-5303
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//ҳ�����ˢ��
 	} */
 	//setValueById('regINSUType',GV.INSUTYPE);
 	//setValueById('regINSUTypeDesc',GV.INSUTYPEDESC);
	//setValueById('regSDate',getDefStDate(0));
	//setValueById('regEDate',getDefStDate(1));	
	InsuDateDefault('regSDate');	
	InsuDateDefault('regEDate',+1);	
	//setValueById('regpsn_no',GV.PSNNO);
	// ҽ������
	init_regINSUType();
	//click�¼�
	init_regClick();
	//��ʼ����Ժ��Ϣ��ѯ��¼dg	
	init_insuregdg(); 
	
});


/**
*��ʼ��click�¼�
*/		
function init_regClick()
{
	 //��ѯ
	 $("#btnRegQry").click(RegQry_Click);
  
}
	
/**
*��Ժ��Ϣ��ѯ
*/	
function RegQry_Click()
{
	var ExpStr=""  
	var regpsnno=getValueById('regpsn_no');
	if(regpsnno == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա��Ų���Ϊ��!", 'info');
		return ;
	}
	var mtSDate=getValueById('regSDate');
	if(mtSDate=="")
	{
		$.messager.alert("��ܰ��ʾ","��ʼʱ�䲻��Ϊ��!", 'info');
		return ;
	}
	
	var outPutObj=getRegInfo();
	
	if(!outPutObj){return ;}
	if (outPutObj.data.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯ����Ӧ����Ժ��¼!", 'info');return ;}
	loadQryGrid("insuregdg",outPutObj.data);
}

///��Ժ��Ϣ��ѯ-5303
function getRegInfo()
{
	
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('regINSUType')+"^"+"5303"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('regpsn_no'));
	QryParams=AddQryParam(QryParams,"begntime",GetInsuDateFormat(getValueById('regSDate')));
	QryParams=AddQryParam(QryParams,"endtime",GetInsuDateFormat(getValueById('regEDate')));
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
function init_insuregdg() {
	var dgColumns = [[
			{field:'mdtrt_id',title:'����ID',width:120},
			{field:'psn_no',title:'��Ա���',width:180},	
			{field:'psn_cert_type',title:'��Ա֤������',width:150,formatter: function(value,row,index){
				var DicType="psn_cert_type"+getValueById('regINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},		
			{field:'certno',title:'֤������',width:180},
			{field:'psn_name',title:'��Ա����',width:100},
			{field:'gend',title:'�Ա�',width:100,formatter: function(value,row,index){
				var DicType="gend"+getValueById('regINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},		
			{field:'brdy',title:'��������',width:100},
			{field:'age',title:'����',width:80},
			{field:'insutype',title:'��������',width:150,formatter: function(value,row,index){
				var DicType="insutype"+getValueById('regINSUType');
		     	return GetDicDescByCode(DicType,value);          
			}},	
			{field:'begndate',title:'��ʼ����',width:100},
			{field:'med_type',title:'ҽ�����',width:100,formatter: function(value,row,index){
				var DicType="med_type"+getValueById('regINSUType');
		     	return GetDicDescByCode(DicType,value);     
			}},	
			{field:'ipt_otp_no',title:'סԺ/�����',width:100},
			{field:'out_flag',title:'��ر�־',width:100}
		]];

	// ��ʼ��DataGrid
	$('#insuregdg').datagrid({
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
function init_regINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('regINSUType','DLLType',Options); 	
	$('#regINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('regINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
		}
 
	})	;
	
}




