/*
ģ��:����ҩ��
��ģ��:����ҩ��-ҩ��ͳ��-����ҩƷ����ͳ��
createdate:2016-07-04
creator:dinghongying
*/
var commonOutPhaUrl ="DHCST.OUTPHA.ACTION.csp";
var thisurl = "dhcpha.outpha.mzyptj.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'150'
} 
$(function(){
	InitMZYPTJList();
	var stkCatCombo=new ListCombobox("stkCat",commonOutPhaUrl+'?action=GetStkCatDs','',combooption);
	stkCatCombo.init(); //��ʼ��������
	combooption.required='true'
	var poisonCatCombo=new ListCombobox("poisonCat",commonOutPhaUrl+'?action=GetPoisonCatDs','',combooption);
	poisonCatCombo.init(); //��ʼ�����Ʒ���

	$('#BReset').on('click', Reset);//������
	$('#BRetrieve').on('click', Query);//���ͳ��
	$('#BExport').on('click', function(){  //�������
		ExportAllToExcel("mzyptjdg")
	});
	$('#mzyptjdg').datagrid('loadData',{total:0,rows:[]});
	$('#mzyptjdg').datagrid('options').queryParams.params = ""; 
	
});
//��ʼ������ҩƷ����ͳ���б�
function InitMZYPTJList(){
	//����columns
	var columns=[[
	    {field:'TPhDate',title:'����',width:80},
	    {field:'TPmiNo',title:'�ǼǺ�',width:100},
	    {field:'TPatName',title:'����',width:80},
	    {field:'TPatSex',title:'�Ա�',width:40,align:'center'},
	    {field:'TPatAge',title:'����',width:50,align:'center'},
	    {field:'TPatSN',title:'���֤��',width:150,align:'center'},
	    {field:'TMR',title:'���',width:200},
	    {field:'TPrescNo',title:'������',width:100,align:'center'},
	    {field:'TPhDesc',title:'ҩƷ����',width:200},
	    {field:'TPhQty',title:'����',width:60,align:'right'},
	    {field:'TPhUom',title:'��λ',width:60},
	   	{field:'TPhMoney',title:'���',width:60,align:'right'},
	    {field:'TIncBatCode',title:'����',width:100},
	    {field:'TYF',title:'�÷�',width:80},
	    {field:'TPatLoc',title:'�Ʊ�',width:120},
	    {field:'TDoctor',title:'ҽ��',width:80},
	    {field:'TFYUser',title:'��ҩ��',width:80},
	    {field:'TBZ',title:'��ע',width:100}
	]];  
    //����datagrid	
    $('#mzyptjdg').datagrid({    
        url:thisurl+'?action=GetMZYPTJList',
        fit:true,
	    border:false,
	    singleSelect:true,
	    rownumbers:true,
	    nowrap:false,
        columns:columns,
        pageSize:50,  // ÿҳ��ʾ�ļ�¼����
	    pageList:[50,100,300,500],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true,
	    onLoadError:function(data){
			$.messager.alert("����","��������ʧ��,��鿴������־!","warning")
			$('#mzyptjdg').datagrid('loadData',{total:0,rows:[]});
			$('#mzyptjdg').datagrid('options').queryParams.params = ""; 
		}
    });
}
///����ҩƷ����ͳ�����
function Reset(){
	$("#startDate").datebox("setValue", formatDate(0));  //Init��ʼ����
	$("#endDate").datebox("setValue", formatDate(0));  //Init��������
	$("#stkCat").combobox("setValue", "");  //Init������
	$("#poisonCat").combobox("setValue", "");  //Init���Ʒ���
	$('#mzyptjdg').datagrid('loadData',{total:0,rows:[]});
	$('#mzyptjdg').datagrid('options').queryParams.params = ""; 
}
///����ҩƷ����ͳ�Ʋ�ѯ
function Query(){
	var startDate=$('#startDate').datebox('getValue');
	if (startDate==""){
		$.messager.alert('��ʾ',"�����뿪ʼ����!","info");
		return;
	}
	var endDate=$('#endDate').datebox('getValue');
	if (endDate==""){
		$.messager.alert('��ʾ',"�������ֹ����!","info");
		return;
	}
	var stkCatId=$("#stkCat").combobox("getValue");
	if (($.trim($("#stkCat").combobox("getText"))=="")||(stkCatId==undefined)){
		stkCatId="";
	}
	var regCatId=$("#poisonCat").combobox("getValue");
	if (($.trim($("#poisonCat").combobox("getText"))=="")||(stkCatId==undefined)){
		$.messager.alert('��ʾ',"���Ʒ���Ϊ������!","info");
		return;
	}
	var params=startDate+"^"+endDate+"^"+gLocId+"^"+stkCatId+"^"+regCatId
	$('#mzyptjdg').datagrid({
		url:thisurl+'?action=GetMZYPTJList',
     	queryParams:{
			params:params}
	});	
}

