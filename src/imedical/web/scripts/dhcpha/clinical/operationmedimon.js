/// Creator: bianshuai
/// CreateDate: 2014-09-18
//  Descript: ������ҩ���

var AppType="SSYY";
var url="dhcpha.clinical.action.csp";
var ItmID="";    //ҽ����ID  qunianpeng
var HospID=session['LOGON.HOSPID']
$(function(){
	
	//initScroll();//��ʼ����ʾ���������
	$("#stdate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#enddate").datebox("setValue", formatDate(0));  //Init��������
	
	//����
	$('#dept').combobox({
		mode:'remote',		
		onShowPanel:function(){ //qunianpeng 2017/8/14 ֧��ƴ����ͺ���
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+HospID+'  ')
			//$('#dept').combobox('reload',url+'?action=SelAllLoc')
		}
	}); 

	//����
	$('#ward').combobox({
		mode:'remote',	
		onShowPanel:function(){ //qunianpeng 2017/8/14 ֧��ƴ����ͺ���
			$('#ward').combobox('reload',url+'?action=GetAllWardNewVersion&hospId='+HospID+'  ')
			//$('#ward').combobox('reload',url+'?action=SelAllWard')
		}
	});

	//�ǼǺŻس��¼�
	$('#patno').bind('keypress',function(event){
	    if(event.keyCode == "13")    
	    {
	        SetPatNoLength();  //�ǼǺ�ǰ��0
	    }
	});
	
    //�������
	$('#oper').combobox({
		onShowPanel:function(){
			$('#oper').combobox('reload',url+'?action=SelOperCateGory')
		}
	});
	
	///�س��¼� wangxuejian   2016/09/19  qunianpeng ����
	$('#phdesc').bind('keypress',function(event){
		if(event.keyCode == "13"){
			var unitUrl = url+'?action=QueryArcItmDetail&hospId='+HospID+'&Input='+$('#phdesc').val(); 
			//var unitUrl =  "&Input="+$('#drug').val();
			/// ����ҽ�����б���
			new ListComponentWin($('#phdesc'), "", "600px", "" , unitUrl, ArcColumns, setCurrEditRowCellVal).init();
		}
	})	
	
		
	$('#Find').bind("click",Query); //�����ѯ
	
	InitPatList(); //��ʼ�������б�
})

///��ѯ��ťҽ������Ӧ����  2016-09-21 qunianpeng ����
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		$('#phdesc').focus().select();  ///���ý��� ��ѡ������
		return;
	}
	$('#phdesc').val(rowObj.itmDesc);  /// ҽ����
	ItmID=rowObj.itmID;    //��ȡҽ����ID
}

ArcColumns = [[
	    {field:'itmDesc',title:'ҽ��������',width:220},
	    {field:'itmCode',title:'ҽ�������',width:100},
	    //{field:'itmPrice',title:'����',width:100},
		{field:'itmID',title:'itmID',width:80}
	]];

//��ѯ
function Query()
{
	//1�����datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2����ѯ
	var StDate=$('#stdate').datebox('getValue'); //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue'); //����ID
	var WardID=$('#ward').combobox('getValue'); //����ID
	if (LocID== undefined){LocID="";}
	if (WardID== undefined){WardID="";}
	var PatNo=$.trim($("#patno").val());;
	var OperID=$('#oper').combobox('getValue');  //�������� qunianpeng
	if(OperID==undefined){
		OperID=""
	}
	var phDesc=$('#phdesc').val();		//ҩƷ����
	if(phDesc==""){			//ҩƷ����Ϊ��ʱ��ҩƷIDΪ��
		ItmID="";		
	}
	var params=StDate+"^"+EndDate+"^"+WardID+"^"+LocID+"^"+PatNo+"^"+AppType+"^"+OperID+"^"+ItmID+"^"+HospID;
	$('#maindg').datagrid({
		url:url+'?action=GetOperMedPatList',	
		queryParams:{
			params:params}
	});
	//$('#dg').datagrid('load',{params:params}); 
}

//��ʼ�������б�
function InitPatList()
{
	//����columns
	var columns=[[
		{field:'Ward',title:'����',width:160},
		{field:'PatNo',title:'�ǼǺ�',width:120,formatter:SetCellUrl},
		{field:'InMedicare',title:'������',width:80,hidden:true},
		{field:'PatName',title:'����',width:80},
		{field:'Bed',title:'����',width:80},
		{field:'PatSex',title:'�Ա�',width:80},
		{field:'PatAge',title:'����',width:80},
		{field:'PatHeight',title:'���',width:80},
		{field:'PatWeight',title:'����',width:80},
		{field:'AdmLoc',title:'����',width:160},
		{field:'AdmDoc',title:'ҽ��',width:80},
		{field:'PatDiag',title:'���',width:180},
		{field:'PatInDate',title:'��Ժʱ��',width:120},
		{field:'ExpCause',title:'�쳣ԭ��',width:200,formatter:showExpCause},
		{field:"AdmDr",title:'AdmDr',width:90,hidden:true}
	]];
	
	//����datagrid
	$('#maindg').datagrid({
		title:'�����б�',    
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	
	initScroll("#maindg");//��ʼ����ʾ���������
	$('#maindg').datagrid('loadData',{total:0,rows:[]});  //qunianpeng  2016-09-08
}

//�ǼǺ��������� formatter="SetCellUrl"
function SetCellUrl(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showWin("+rowData.AdmDr+")'>"+value+"</a>";
}

///��ʾ���� formatter="SetCellUrl"
function showWin(AdmDr)
{
	createPatInfoWin(AdmDr); //���ô��� createPatInfoWin.js
}

/// �쳣ָ����ʾ��ʽ
function showExpCause(value,rowData,rowIndex){
	
	var html = '<span style="color:red;font-weight:bold;">'+ value +'</span>';
	return html;
}

//ȡ�ǼǺų��ȣ�����ʱ��0
function SetPatNoLength()
{
	var PatNo=$('#patno').val();
	if(PatNo!=""){
	$.post(url+'?action=GetPatRegNoLen',function(PatNoLen){
		var PLen=PatNo.length; //����ǼǺŵĳ���
		for (i=1;i<=PatNoLen-PLen;i++)
		{
			PatNo="0"+PatNo; 
		}
		$('#patno').val(PatNo); //��ֵ
	},'text');
	Query();  //��ѯ
    }
}