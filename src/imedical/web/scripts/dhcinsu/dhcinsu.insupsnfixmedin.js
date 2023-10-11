/*
 * FileName:	dhcinsu.insupsnfixmedin.js
 * User:		DingSH
 * Date:		2021-01-12
 * MainJS:      dhcinsu.insuservqry.js
 * Description: ��Ա������Ϣ��ѯ
 */
 $(function () { 
 	/*window.onresize=function(){
    	location.reload();//ҳ�����ˢ��
 	} */
 	//setValueById('fixINSUType',GV.INSUTYPE);
 	//setValueById('fixINSUTypeDesc',GV.INSUTYPEDESC);
    //setValueById('fixbizappytype',getDefStDate(0));
	//setValueById('fixpsn_no',GV.PSNNO);
	INSULoadDicData('fixbizappytype','biz_appy_type' + GV.INSUTYPE,{hospDr: GV.HOSPDR});
	// ҽ������
	init_fixINSUType();
	//click�¼�
	init_fixClick();
	//��ʼ����Ա�����¼dg	
	init_insufixmeddg(); 
	
});

/**
*��ʼ��click�¼�
*/		
function init_fixClick()
{
	 //��ѯ
	 $("#btnFixQry").click(FixQry_Click);
  
}
	
/**
*��ѯ��Ա������Ϣ
*/	
function FixQry_Click()
{
	var ExpStr=""  
	var trtPsnNo=getValueById('fixpsn_no');
	if(trtPsnNo == "")
	{
		$.messager.alert("��ܰ��ʾ","��Ա��Ų���Ϊ��!", 'info');
		return ;
	}
	var fixbizappytype=getValueById('fixbizappytype');
	if(fixbizappytype=="")
	{
		$.messager.alert("��ܰ��ʾ","ҵ���������Ͳ���Ϊ��!", 'info');
		return ;
	}
	var outPutObj=getFixInfo();
	if(!outPutObj){return ;}
	if (outPutObj.psnfixmedin.length==0){$.messager.alert("��ܰ��ʾ","δ��ѯ����Ӧ�ļ�¼!", 'info');return ;}
	loadQryGrid("insufixmeddg",outPutObj.psnfixmedin);
}

///��5302����Ա������Ϣ��ѯ
function getFixInfo()
{
	
	//���ݿ����Ӵ�
	var connURL=""
	//'ExpStr=ҽ������^���״���^����ֵ��ʽ��ʶ()^����ֵ���ݽڵ���^���ݿ����Ӵ�^"ArgName1=ArgValue1&ArgName2=ArgValue2&...&ArgNameN=ArgValueN"
	var ExpStr=getValueById('fixINSUType')+"^"+"5302"+"^^output^"+connURL;
	var QryParams=""
	QryParams=AddQryParam(QryParams,"psn_no",getValueById('fixpsn_no'));
	QryParams=AddQryParam(QryParams,"biz_appy_type",getValueById('fixbizappytype'));
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
function init_insufixmeddg() {
	var dgColumns = [[
			{field:'psn_no',title:'��Ա���',width:180},
			{field:'insutype',title:'��������',width:150,formatter: function(value,row,index){
				var NewValue=""
				var DicType="insutype"+getValueById('fixINSUType');
		     	NewValue= GetDicDescByCode(DicType,value); 
		     	return NewValue=="" ? value:NewValue
			}},	
			{field:'fix_srt_no',title:'���������',width:100},
			{field:'fixmedins_code',title:'��ҽҩ�������',width:180},
			{field:'fixmedins_name',title:'����ҽҩ��������',width:240},
			{field:'begndate',title:'��ʼ����',width:140 },
			{field:'enddate',title:'��������',width:140},
			{field:'memo',title:'��ע',width:200}
		]];

	// ��ʼ��DataGrid
	$('#insufixmeddg').datagrid({
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
*
 * ҽ������ ��ҽ�������йص� ��������Ҫ�������¼���
 */function init_fixINSUType(){
	var Options = {
		defaultFlag:'Y'	,
		hospDr:GV.HOSPDR
	}
	INSULoadDicData('fixINSUType','DLLType',Options); 	
	$('#fixINSUType').combobox({
		onSelect:function(rec){
			INSULoadDicData('fixbizappytype','biz_appy_type' + GV.INSUTYPE,{hospDr: GV.HOSPDR});
			GV.INSUTYPE=getValueById('fixINSUType');
			GV.INSUTYPEDESC=rec.cDesc;
		}
	})	;
	
}





