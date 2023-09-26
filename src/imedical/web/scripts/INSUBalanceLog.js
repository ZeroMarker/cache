
var cmenu;
var grid;
var selRowid="";
var searchParam = {}; 
var seldictype=""; 
var tmpselRow=-1;
$(function(){
	//GetjsonQueryUrl();
	
	//��ʼ��datagrid
	init_dg();
	
	$('#QueryBalanceLog').on('click',function(){
		reloadListGV();
	});
	
	var Options = {
		defaultFlag:'Y',
		hospDr:session['LOGON.HOSPID']
	}
	INSULoadDicData('InsuType','DLLType',Options); 	
	
	$HUI.combobox(('#UserNo'),{
		defaultFilter:'4',
		valueField: 'TUsrRowid',
		textField: 'TUsrName',
		url:$URL,
		onSelect:function(){
		},
		onLoadSuccess:function(data){

		}
		,onBeforeLoad: function(param) {
			param.ClassName = 'DHCBILLConfig.DHCBILLOthConfig';
			param.QueryName= 'FindGroupUser';
			param.Grp = session['LOGON.GROUPID'];
			param.Usr = "";
			param.HospId = session['LOGON.HOSPID'];
			param.ResultSetType = 'array';
			return true;
		}		
	})
	
	$('.hisui-datebox').datebox('setValue', GetConDateByConfig());
})
function init_dg(){
	grid=$('#dg').datagrid({
		rownumbers:true,
		width: '100%',
		fit:true,
		//striped:true,
		fitColumns: false,
		singleSelect: true,
		columns:[[
			{field:'INBLLRowid',title:'INBLLRowid',width:100,hidden:'true'},
			{field:'INSUTypte',title:'ҽ������',width:80},
			{field:'OptDate',title:'��������',width:100},
			{field:'UserDr',title:'����ԱID',width:80},
			{field:'Flag',title:'���˳ɹ���־',width:100},
			{field:'StartDate',title:'���˿�ʼ����',width:100},
			{field:'StartTime',title:'���˿�ʼʱ��',width:100},
			{field:'EndDate',title:'���˽�������',width:100},
			{field:'EndTime',title:'���˽���ʱ��',width:100},
			{field:'TotAmt',title:'his�����ܽ��',width:120,align:'right'},
			{field:'JJZFE',title:'his����֧�����',width:120,align:'right'},
			{field:'ZHZFE',title:'his�˻�֧�����',width:120,align:'right'},
			{field:'GRZFE',title:'his�ֽ�֧�����',width:150,align:'right'},
			{field:'TCZF',title:'his����ͳ��֧�����',width:150,align:'right'},
			{field:'DBZF',title:'his��֧�����',width:150,align:'right'},
			{field:'GWYZF',title:'his����Ա֧�����',width:150,align:'right'},
			{field:'MZJZ',title:'his�����������',width:150,align:'right'},
			{field:'INSUTotAmt',title:'ҽ�����ض����ܽ��',width:190,align:'right'},
			{field:'INSUJJZFE',title:'ҽ�����ػ���֧�����',width:190,align:'right'},
			{field:'INSUZHZFE',title:'ҽ�������˻�֧�����',width:190,align:'right'},
			{field:'INSUGRZFE',title:'ҽ�������ֽ�֧�����',width:190,align:'right'},
			{field:'INSUTCZF',title:'ҽ�����ػ���ͳ��֧�����',width:190,align:'right'},
			{field:'INSUDBZF',title:'ҽ�����ش�֧�����',width:190,align:'right'},
			{field:'INSUGWYZF',title:'ҽ�����ع���Ա֧�����',width:170,align:'right'},
			{field:'INSUMZJZ',title:'ҽ�����������������',width:170,align:'right'},
			{field:'Note',title:'����ʧ��ԭ��',width:100},
			{field:'Str1',title:'��չ�ֶ�1',width:100,hidden:'true'},
			{field:'Str2',title:'��չ�ֶ�2',width:100,hidden:'true'},
			{field:'Str3',title:'��չ�ֶ�3',width:100,hidden:'true'},
			{field:'Str4',title:'��չ�ֶ�4',width:100,hidden:'true'},
			{field:'Str5',title:'��չ�ֶ�5',width:100,hidden:'true'}
		]],
		pageSize: 10,
		pagination:true,
		rowStyler: function(index,row){
			if ('ʧ��'==row.Flag){
				return 'color:red;';
			}
		},
	});	
		
}
function reloadListGV(){
	
	var StDate=getValueById('StDate');
	var EndDate=getValueById('EndDate');
	var InsuType=getValueById('InsuType');
	var UserNo=getValueById('UserNo') ;
	var HospId = session['LOGON.HOSPID'];
	var queryParams = {
	    ClassName : 'web.INSUBalanceLog',
	    QueryName : 'QueryBalanceLog',
	    StDate : StDate,
	    EndDate : EndDate,
	    InsuType : InsuType,
	    HospId : HospId,
	    UserNo:UserNo,
	}	
    loadDataGridStore('dg',queryParams);
}
//����EXCEL
function Export(){
	try
	{
		var title="";
		var tmpurl=jsonQueryUrl+'web.INSUBalanceLog'+SplCode+"QueryBalanceLog"+SplCode+cspEscape($('#StDate').datebox('getValue'))+ArgSpl+cspEscape($('#EndDate').datebox('getValue'))+ArgSpl+$('#InsuType').combobox('getValue')+ArgSpl+cspEscape($('#UserNo').val())
		ExportTitle="ҽ������^��������^����ԱID^���˳ɹ���־^���˿�ʼ����^��ʼʱ��^���˽�������^����ʱ��^�ܽ��^����֧����^�˻�֧����^����֧����^ͳ��֧����^��֧����^����Ա����^��������^ҽ�������ܽ��^ҽ�����ػ���֧����^ҽ�������˻�֧����^ҽ�����ظ���֧����^ҽ������ͳ��֧����^ҽ�����ش�֧����^ҽ�����ع���Ա����^ҽ��������������^��ע^��չ1^��չ2^��չ3^��չ4^��չ5"
		ExportPrompt(tmpurl)
		return;
	} catch(e) {
		$.messager.alert("����",e.message);
		$.messager.progress('close');
	};
}

//����MSN����ʾ��Ϣ
//title:��ʾ��ı���
//msg:��ʾ��Ϣ
//timeout:��ú���Ϣ,��λΪ����
function MSNShow(title,msg,timeout){
	$.messager.show({
		title:title,
		msg:msg,
		timeout:timeout,
		showType:'slide'
	});
}

///��ȡ���õ�Ĭ����Чʱ��
///ע�⣺���Ϊ��Ĭ�ϵ�ǰʱ��
function GetConDateByConfig()
{
    var rtnDate=""
	//var rtnDate=GetDicStr("SYS","INSUCONACTDATE",6); // - 20200509 DingSH
	//if(rtnDate==""){ 
	rtnDate=getDefStDate(0);
	//}
	return rtnDate; 
 }
function GetDicStr(dicCode,CodeVal,index){
	return tkMakeServerCall("web.INSUDicDataCom","GetDicByCodeAndInd",dicCode,CodeVal,index,session['LOGON.HOSPID']);
}