/*
 * FileName:	dhcinsu.insutrtinfo.js
 * User:		DingSH
 * Date:		2021-01-11
 * MainJS:      dhcinsu.insuservqry.js
 * Description: �����������
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//ҳ�����ˢ��
 	} */
	//setValueById('trtSDate',getDefStDate(0));
	//setValueById('trtEDate',getDefStDate(1));
	InsuDateDefault('trtSDate');	
	InsuDateDefault('trtEDate',+1);		
	//setValueById('Trtpsn_no',GV.PSNNO);
	//setValueById('TrtINSUType',GV.INSUTYPE);
	//setValueById('TrtINSUTypeDesc',GV.INSUTYPEDESC);
	// ҽ������
	init_trtINSUType();
	//click�¼�
	init_TrtClick();
	//��ʼ���������������Ϣdg	
	init_iinsutrtdg(); 
	// ��������
	INSULoadDicData('trtInsuType','insutype' + GV.INSUTYPE,{hospDr: GV.HOSPDR}); 
	// ҽ�����
	INSULoadDicData('trtMedType','med_type' + GV.INSUTYPE,{hospDr: GV.HOSPDR}); 
});

/**
*��ʼ��click�¼�
*/		
function init_TrtClick()
{
	 //��ѯ
	 $("#btnTrtQry").click(TrtQry_Click);
  
}
	
/**
*��ѯ�������������Ϣ
*/	
function TrtQry_Click()
{
	var ExpStr=""  
	var trtPsnNo=getValueById('Trtpsn_no');
	if(trtPsnNo == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա��Ų���Ϊ��!", 'info');
		return ;
	}
	var trtInsuType=getValueById('trtInsuType');
	if(trtInsuType=="")
	{
		$.messager.alert("��ܰ��ʾ","�������Ͳ���Ϊ��!", 'info');
		return ;
	}
	var trtMedType=getValueById('trtMedType');
	if(trtMedType=="")
	{
		$.messager.alert("��ܰ��ʾ","ҽ�������Ϊ��!", 'info');
		return ;
	}
	var trtSDate=getValueById('trtSDate');
	if(trtSDate=="")
	{
		$.messager.alert("��ܰ��ʾ","��ʼʱ�䲻��Ϊ��!", 'info');
		return ;
	}
	
	
	var outPutObj=getTrtInfo();
	if(!outPutObj){return ;}
	if (outPutObj.trtinfo.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯ����Ӧ�ļ�¼!", 'info');return ;}
	loadQryGrid("insutrtdg",outPutObj.trtinfo)
	
}

///2001 ��Ա���������Ϣ��ȡ
function getTrtInfo()
{
	
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('TrtINSUType')+"^"+"2001"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('Trtpsn_no'));
	QryParams=AddQryParam(QryParams,"insutype",getValueById('trtInsuType'));
	QryParams=AddQryParam(QryParams,"fixmedins_code","H44020300006");
	QryParams=AddQryParam(QryParams,"med_type",getValueById('trtMedType'));
	QryParams=AddQryParam(QryParams,"begntime",GetInsuDateFormat(getValueById('trtSDate')));
	QryParams=AddQryParam(QryParams,"endtime",GetInsuDateFormat(getValueById('trtEDate')));
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
function init_iinsutrtdg() {
	var dgColumns = [[
			{field:'psn_no',title:'��Ա���',width:160},
			{field:'trt_chk_type',title:'�����������',width:150,formatter: function(value,row,index){
				var NewValue=""
				var DicType="trt_chk_type"+getValueById('TrtINSUType');
		     	NewValue= GetDicDescByCode(DicType,value);  
		     	return NewValue=="" ? value:NewValue
		     	    
			}},	
			
			{field:'fund_pay_type',title:'����֧������',width:150,formatter: function(value,row,index){
				var NewValue=""
				var DicType="fund_pay_type"+getValueById('TrtINSUType');
		     	NewValue= GetDicDescByCode(DicType,value); 
		     	return NewValue=="" ? value:NewValue
			}},
			{field:'trt_enjymnt_flag',title:'����������ܱ�־',width:150 ,formatter: function(value,row,index){
				return value=="1" ? "����":"������" ;
				}},
			{field:'begndate',title:'��ʼ����',width:160},
			{field:'enddate',title:'��������',width:160 },
			{field:'trt_chk_rslt',title:'���������',width:220}
			
		]];

	// ��ʼ��DataGrid
	$('#insutrtdg').datagrid({
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
function init_trtINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('TrtINSUType','DLLType',Options); 	
	$('#TrtINSUType').combobox({
		onSelect:function(rec){
			GV.INSUTYPE=getValueById('TrtINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
			INSULoadDicData('trtInsuType','insutype' + GV.INSUTYPE,{hospDr: GV.HOSPDR}); // ��������
	        INSULoadDicData('trtMedType','med_type' + GV.INSUTYPE,{hospDr: GV.HOSPDR});  	// ҽ�����
		
		}
 
	})	;
	
}






