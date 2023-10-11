
/// Creator: bianshuai
/// CreateDate: 2014-08-31
/// Descript: ѪҩŨ�ȼ��

var AppType="TDM";
var url="dhcpha.clinical.action.csp";
var LgHospID=session['LOGON.HOSPID']
$(function(){
	
	$("#stdate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#enddate").datebox("setValue", formatDate(0));  //Init��������
	
	//����
	$('#dept').combobox({
		mode:'remote',		
		onShowPanel:function(){ //qunianpeng 2017/8/14 ֧��ƴ����ͺ���
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'')
			//$('#dept').combobox('reload',url+'?action=SelAllLoc')
		}
	}); 

	//����
	$('#ward').combobox({
		mode:'remote',	
		onShowPanel:function(){ //qunianpeng 2017/8/14 ֧��ƴ����ͺ���
			$('#ward').combobox('reload',url+'?action=GetAllWardNewVersion&hospId='+LgHospID+'')
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

   	//������Ŀ
	$('#labitm').combobox({
		onShowPanel:function(){
			$('#labitm').combobox('reload',url+'?action=SelMonItemByTheme&Theme='+AppType)
		},	
		panelHeight:"auto"  //���������߶��Զ�����
	});
	
	InitPatList(); //��ʼ��������Ϣ�б�
})

//��ʼ�������б�
function InitPatList()
{
	//����columns
	var columns=[[
		{field:'Ward',title:$g('����'),width:160},
		{field:'PatNo',title:$g('�ǼǺ�'),width:80,formatter:SetCellUrl},
		{field:'PatName',title:$g('����'),width:80},
		{field:'Bed',title:$g('����'),width:80},
		{field:'PatSex',title:$g('�Ա�'),width:80},
		{field:'PatAge',title:$g('����'),width:80},
		{field:'PatHeight',title:$g('���'),width:80},
		{field:'PatWeight',title:$g('����'),width:80},
		{field:'AdmLoc',title:$g('����'),width:120},
		{field:'AdmDoc',title:$g('����ҽʦ'),width:80},
		{field:'PatDiag',title:$g('���'),width:180},
		{field:'PatInDate',title:$g('��Ժʱ��'),width:80},
		{field:'ExpCause',title:$g('�쳣ԭ��'),width:200,formatter:showExpCause},
		{field:"AdmDr",title:'AdmDr',width:90}
	]];
	
	//����datagrid
	$('#maindg').datagrid({
		title:$g('�����б�'),
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
		rowStyler:function(index,row){
			if (row.ExpCause=="Y"){
				return 'background-color:pink;';
			}
		}
	});
	
	initScroll("#maindg");//��ʼ����ʾ���������
        $('#maindg').datagrid('loadData', {total:0,rows:[]});
}

//��ѯ
function Query()
{
	//1�����datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]});
	//2����ѯ
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue');     //����ID
	if (LocID== undefined){LocID="";}
	var WardID=$('#ward').combobox('getValue');    //����ID
	if (WardID== undefined){WardID="";}
	var LabItm=$('#labitm').combobox('getValue');  //������Ŀ
	if (LabItm== undefined){LabItm="";}
	var PatNo=$.trim($("#patno").val());
	var params=StDate+"^"+EndDate+"^"+WardID+"^"+LocID+"^"+PatNo+"^"+AppType+"^"+LabItm+"^"+LgHospID;
	$('#maindg').datagrid({
		url:url+'?action=QueryInPatList',	
		queryParams:{
			params:params}
	});
}
        
//��������ɫ  formatter="SetCellColor"
function SetCellColor(value, rowData, rowIndex)
{
	var color="";
	if((value>"0")||(value="��")){
		color="green";
	}else{
		color="red";}
	return '<span style="font-weight:bold;color:'+color+'">'+value+'</span>';
}

//�ǼǺ��������� formatter="SetCellUrl"
function SetCellUrl(value, rowData, rowIndex){
	
	return "<a href='#' onclick='showWin("+rowData.AdmDr+")'>"+value+"</a>";
}

///��ʾ���� formatter="SetCellUrl"
function showWin(AdmDr){
	
	createPatInfoWin(AdmDr); //���ô��� createPatInfoWin.js
}

/// �쳣ָ����ʾ��ʽ
function showExpCause(value,rowData,rowIndex){
	
	var html = '<span style="color:red;font-weight:bold;">'+ value +'</span>';
	return html;
}

//ȡ�ǼǺų��ȣ�����ʱ��0
function SetPatNoLength(){
	
	var PatNo=$('#patno').val();
	if(PatNo!=""){
	$.post(url+'?action=GetPatRegNoLen',function(PatNoLen){
		var PLen=PatNo.length; //����ǼǺŵĳ���
		for (i=1;i<=PatNoLen-PLen;i++)
		{
			PatNo="0"+PatNo; 
		}
		$('#patno').val(PatNo); //��ֵ
		Query();  //��ѯ
	},'text');
	}

}