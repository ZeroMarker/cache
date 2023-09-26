/*
ģ��:����ҩ��
��ģ��:����ҩ��-��ҳ-��˵�-�����ӡ��ǩ�÷�ά��
createdate:2016-06-24
creator:yunhaibao
*/
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var url = "dhcpha.outpha.instruction.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID']; 
var combooption = {
	valueField :'RowId',    
	textField :'Desc',
	panelWidth:'200'
} 
$(function(){
	var instruCombo=new ListCombobox("instru",commonOutPhaUrl+'?action=GetInstuDs','',combooption);
	instruCombo.init(); //��ʼ���÷�
	InitInstruGrid();	
	$('#instructiongrid').datagrid('reload');
	$('#btnDelete').bind('click',btnDeleteHandler);//���ɾ��
	$('#btnAdd').bind('click', btnAddHandler);//�������
});
//��ʼ��grid
function InitInstruGrid(){
	//����columns
	var columns=[[
        {field:'TLocDesc',title:'ҩ������',width:300},
        {field:'TYFDesc',title:'�÷�',width:300},
        {field:'TYFID',title:'TYFID',width:200,hidden:true},
        {field:'yfcodeid',title:'yfcodeid',width:200,hidden:true}
	]];  
	
   //����datagrid	
   $('#instructiongrid').datagrid({    
        url:url+'?action=QueryLocInstruction',
        fit:true,
	    border:false,
	    singleSelect:true,
	    rownumbers:true,
	    striped:true,
        columns:columns,
        pageSize:50,  // ÿҳ��ʾ�ļ�¼����
	    pageList:[50,100,300],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true  
   });
}
///����
function btnAddHandler()
{
	var instru=$("#instru").combobox('getValue');
	var instrudesc=$("#instru").combobox('getText')
	if  ($.trim(instrudesc)==""){
		instu="";
		$.messager.alert('��ʾ',"��ѡ���÷�!","info");
		return;		
	}
	if (instru==undefined){
		$.messager.alert('��ʾ',"��ѡ����ȷ�÷�,ѡ��������ֶ��޸�����!","info");
		return;	
	}
    var returnValue= tkMakeServerCall("PHA.OP.CfPrtLab.OperTab","Insert",gLocId,instru,instrudesc);
    if(returnValue==-1){
	    $.messager.alert('��ʾ',"���÷��ڱ�ҩ����ά��!","info");
	    return;
    }else{
	    $('#instructiongrid').datagrid('reload');
    }
}


///ɾ��
function btnDeleteHandler(){
	var seletcted = $("#instructiongrid").datagrid("getSelected");
	if (seletcted==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫɾ���ļ�¼!","info");
		return;
	}
	var yfcodeid=seletcted["yfcodeid"];
	$.messager.confirm('��ʾ',"ȷ��ɾ����",function(r){
		if(r){
			var retValue=tkMakeServerCall("PHA.OP.CfPrtLab.OperTab","Delete",gLocId,yfcodeid);
			if(retValue==0){
				$('#instructiongrid').datagrid('reload');
			}
			else{
				$.messager.alert('��ʾ',"ɾ��ʧ��,�������:"+retValue,"error");
			}
		}
	});
}
