/// Creator: bianshuai
/// CreateDate: 2014-09-18
//  Descript: ������Ӧ���

var HospID = "";
var AppType="ADR";
var url="dhcpha.clinical.action.csp";
var HospID=session['LOGON.HOSPID']
var monItmArrList="";
$(function(){

	//initScroll();//��ʼ����ʾ���������
	$("#stdate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#enddate").datebox("setValue", formatDate(0));  //Init��������
	
	//����
	$('#dept').combobox({
		mode:'remote',
		onShowPanel:function(){ //qunianpeng 2017/8/14 ֧��ƴ����ͺ���
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+HospID+'  ')
			//$('#dept').combobox('reload',url+'?action=SelAllLoc&HospID='+HospID)
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

	//�����Ŀ
	$('#monitem').combobox({
		onShowPanel:function(){
			$('#monitem').combobox('reload',url+'?action=SelMonItemByTheme&Theme='+AppType)
		},	
		panelHeight:"auto"  //���������߶��Զ�����
	});
	
	//�ǼǺŻس��¼�
	$("#patno").bind('keypress',function(event){
        if(event.keyCode == "13"){
			SetPatNoLength();	 
	     	Query();
           }
    });
	
	
	var phdesccolumns=[[
		{field:'ck',checkbox:true,resize:false},
		{field:'Desc',title:'����',width:380}, 
		{field:'RowID',title:'rowid',width:50},
		{field:'Type',title:'����',width:50},
	]];
	
	$('#phdesc').combogrid({ 
		url:'', 
		valueField:'RowID',
		panelWidth:440,
		idField:'RowID',
		textField:'Desc',
		//fitColumns: true,  
		multiple:true,
		columns:phdesccolumns,
		onShowPanel: function(){
            var monItmID=$('#monitem').combobox('getValue'); //�����Ŀ
            //���¼���  
            $('#phdesc').combogrid("grid").datagrid({
	            url:url+'?action=FunLibSubTheItm',
				queryParams:{
					page:1,
					rows:30,
					monItmID:monItmID}
            })
		}
	});
	
	InitPatList(); //��ʼ�������б�

	$('#Find').bind("click",Query); //�����ѯ
})

//��ѯ
function Query()
{
	//1�����datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2����ѯ
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue');     //����ID
	var WardID=$('#ward').combobox('getValue');    //����ID
	var PatNo=$.trim($("#patno").val());           //���˵ǼǺ�
	var MonItem=$('#monitem').combobox('getValue'); //�����Ŀ
	var params=StDate+"^"+EndDate+"^"+trsUndefinedToEmpty(WardID)+"^"+trsUndefinedToEmpty(LocID)+"^"+PatNo+"^"+AppType+"^"+trsUndefinedToEmpty(MonItem)+"^"+""+"^"+""+"^"+HospID;

	$('#maindg').datagrid({
		url:url+'?action=GetUntoEffectPatList',	
		queryParams:{
			params:params}
	});
}

//��ʼ�������б�
function InitPatList()
{
	//����columns
	var columns=[[
		{field:'Ward',title:'����',width:160},
		{field:'PatNo',title:'�ǼǺ�',width:80,formatter:SetCellUrl},
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
		{field:"AdmDr",title:'AdmDr',width:90}
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
	$('#maindg').datagrid('loadData',{total:0,rows:[]});  //qunianpeng 2016-09-08
}

//�ǼǺ��������� formatter="SetCellUrl"
function SetCellUrl(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showWin("+rowData.AdmDr+")'>"+value+"</a>";
}

/// �쳣ָ����ʾ��ʽ
function showExpCause(value,rowData,rowIndex){
	
	var html = '<span style="color:red;font-weight:bold;">'+ value +'</span>';
	return html;
}

///��ʾ���� formatter="SetCellUrl"
function showWin(AdmDr)
{
	createPatInfoWin(AdmDr); //���ô��� createPatInfoWin.js
}


//�ǼǺ�λ������ʱ������    qunianpeng 2016-11-21 
function SetPatNoLength(){	
	var PatientNo=$('#patno').val();    //�ǼǺ�
	if(PatientNo!=""){
	var PatLen=PatientNo.length;			
	if(PatLen<10)     //�ǼǺų���Ϊ10λ
	{
		for (i=1;i<=10-PatLen;i++)
		{
			PatientNo="0"+PatientNo; 
		}
	}
	$('#patno').val(PatientNo);
	}
}

//δ����Ĭ��Ϊ��  //qunianpeng 2016/11/23
function trsUndefinedToEmpty(str)
{
	if(typeof str=="undefined"){
		str="";
	}
	return str;
}